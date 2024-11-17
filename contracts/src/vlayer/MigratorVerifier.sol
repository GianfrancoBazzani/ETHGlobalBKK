// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Verifier, Proof} from "vlayer-0.1.0/Verifier.sol";
import {MigratorProver} from "./MigratorProver.sol";

import {IERC20, SafeERC20} from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {SafeCast} from "openzeppelin-contracts/utils/math/SafeCast.sol";
import {IMigratorVerifier} from "./interfaces/IMigratorVerifier.sol";
import {ScrollL1StorageReader} from "../ScrollL1StorageReader.sol";

contract MigratorVerifier is Verifier, IMigratorVerifier {
    using SafeERC20 for IERC20;

    struct UserInfo {
        bool isMigrated;
        uint248 usedLockedAmount;
    }

    struct BonusRange {
        uint184 rangeStartAmount;
        uint72 multiplier;
    }

    // *** Constants & Immutables *** \\\
    uint256 private constant LOCKED_VALUE_BY_USER_SLOT = 0;
    uint256 private constant MINIMAL_MIGRATION_DURATION = 1 days;
    uint256 private constant ONE_SCALED = 1e18;

    address private immutable prover;
    address private immutable l1Migrator;
    IERC20 private immutable l2Token;
    uint256 private immutable baseTimeMultiplier;
    uint256 private immutable totalMigrationDuration;
    uint256 private immutable startMigrationTimestamp;
    uint256 private immutable endMigrationTimestamp;

    // *** State Variables *** \\\
    BonusRange[] private bonusRanges;
    mapping(address user => UserInfo info) private userMigrationInformation;

    // *** State Changing Functions *** \\\
    constructor(
        address _l1Migrator,
        uint256 _startMigrationTimestamp,
        uint256 _endMigrationTimestamp,
        uint256 _baseTimeMultiplier,
        IERC20 _migratedToken,
        IERC20 _l2Token,
        uint256 _startBlockForAccounting,
        uint256 _endBlockForAccounting,
        uint256 _minimalAverageBalanceForBonusEligibility,
        BonusRange[] memory _bonusRanges
    ) {
        // *** Validations *** \\\
        require(_baseTimeMultiplier > 0, ZeroBaseMultiplier());
        require(
            _startMigrationTimestamp >= block.timestamp,
            InvalidMigrationStart(block.timestamp, _startMigrationTimestamp)
        );
        require(
            _endMigrationTimestamp > _startMigrationTimestamp,
            InvalidMigrationEnd(_startMigrationTimestamp, _endMigrationTimestamp)
        );
        require(_l1Migrator != address(0), L1MigratorMustBeNotZero());

        // Sanity check that token exists
        _l2Token.totalSupply();

        uint256 migrationDuration = _endMigrationTimestamp - _startMigrationTimestamp;
        require(migrationDuration > MINIMAL_MIGRATION_DURATION, MigrationDurationTooSmall());

        // If project wants to set the bonus based on average balance to the constant for every user
        // then they will provide array with 1 element where the rangeStartAmount is 0 and the multiplier is some value
        require(_bonusRanges.length > 0, BonusRangesArrayIsEmpty());
        require(_bonusRanges[0].rangeStartAmount == 0, FirsRangeStartAmountMustBeZero());

        // Validate that price ranges are in ascending order
        for (uint256 i = _bonusRanges.length - 1; i > 0; i--) {
            require(
                _bonusRanges[i].rangeStartAmount > _bonusRanges[i - 1].rangeStartAmount, RangeAmountsDecreasing(i - 1)
            );
        }

        // *** State changes *** \\\
        // Deploy the MigrationProver first to validate all parameters first
        prover = address(
            new MigratorProver(
                _migratedToken,
                _startBlockForAccounting,
                _endBlockForAccounting,
                _minimalAverageBalanceForBonusEligibility
            )
        );

        baseTimeMultiplier = _baseTimeMultiplier;
        startMigrationTimestamp = _startMigrationTimestamp;
        endMigrationTimestamp = _endMigrationTimestamp;
        totalMigrationDuration = migrationDuration;

        bonusRanges = _bonusRanges;
        l2Token = _l2Token;
        l1Migrator = _l1Migrator;
    }

    function completeMigration(Proof memory, address user, uint256 averageBalance)
        external
        onlyVerified(prover, MigratorProver.averageBalance.selector)
    {
        require(msg.sender == user, ProofIsNotGeneratedForCaller(user, msg.sender));
        require(!userMigrationInformation[msg.sender].isMigrated, UserAlreadyMigrated());
        require(endMigrationTimestamp > block.timestamp, BonusMigrationEnded());

        // Get all incentive bonuses
        uint256 timeBonus = getUserTimeBonus(averageBalance);
        uint256 loyaltyBonus = getUserLoyaltyBonus(averageBalance);

        // Use L1SLOAD precompile to get the amount of tokens locked on L1
        uint256 l1LockedAmount = getL1LockedAmount(user);

        uint256 usedLockedAmount = userMigrationInformation[msg.sender].usedLockedAmount;

        // Invariant should never be reached
        assert(l1LockedAmount >= usedLockedAmount);

        uint256 l1AdjustedAmount = l1LockedAmount - usedLockedAmount;
        uint256 totalAmountToSend = l1AdjustedAmount + timeBonus + loyaltyBonus;

        userMigrationInformation[msg.sender].isMigrated = true;
        userMigrationInformation[msg.sender].usedLockedAmount += SafeCast.toUint248(l1AdjustedAmount);

        emit UserMigrated(msg.sender, averageBalance, totalAmountToSend);

        // CEI
        l2Token.safeTransfer(msg.sender, totalAmountToSend);
    }

    function bridgeTokens() external {
        uint256 l1LockedAmount = getL1LockedAmount(msg.sender);
        uint256 diff = l1LockedAmount - userMigrationInformation[msg.sender].usedLockedAmount;
        require(diff > 0, NoTokensToBridge());

        userMigrationInformation[msg.sender].usedLockedAmount += SafeCast.toUint248(diff);
        emit TokensBridged(msg.sender, diff);

        // CEI
        l2Token.safeTransfer(msg.sender, diff);
    }

    // *** Private View Functions *** \\\

    function findMultiplierForValue(uint256 value) private view returns (uint256 multiplier) {
        uint256 arrayLengthCached = bonusRanges.length;

        // Handle single-element edge case
        if (arrayLengthCached == 1) {
            if (value >= bonusRanges[0].rangeStartAmount) {
                return bonusRanges[0].multiplier;
            }
            revert InvalidState(); // Value does not fall in the valid range
        }

        uint256 lowBound = 0;
        uint256 highBound = arrayLengthCached - 1;

        while (lowBound <= highBound) {
            uint256 middle = (highBound + lowBound) / 2;

            uint256 testedRangeStart = bonusRanges[middle].rangeStartAmount;
            uint256 testedRangeEnd =
                middle + 1 < arrayLengthCached ? bonusRanges[middle + 1].rangeStartAmount : type(uint256).max;

            if (value >= testedRangeStart && value < testedRangeEnd) {
                return bonusRanges[middle].multiplier;
            } else if (value < testedRangeStart) {
                if (middle == 0) break; // Prevent underflow
                highBound = --middle;
            } else {
                lowBound = ++middle;
            }
        }

        // Explicitly check if value is within the last range
        uint256 lastRangeStart = bonusRanges[arrayLengthCached - 1].rangeStartAmount;
        if (value >= lastRangeStart) {
            return bonusRanges[arrayLengthCached - 1].multiplier;
        }

        // If no range matches, revert. Should never happen
        revert InvalidState();
    }

    // *** External & Public Getter Functions *** \\\

    function getL2Token() external view returns (address) {
        return address(l2Token);
    }

    function getUserTimeBonus(uint256 usersAverageBalance) public view returns (uint256) {
        return (usersAverageBalance * getTimeMultiplier()) / ONE_SCALED;
    }

    function getUserLoyaltyBonus(uint256 usersAverageBalance) public view returns (uint256) {
        return (usersAverageBalance * findMultiplierForValue(usersAverageBalance)) / ONE_SCALED;
    }

    function getTimeMultiplier() public view returns (uint256) {
        uint256 remainingMigrationTime = endMigrationTimestamp - block.timestamp;

        uint256 numerator = baseTimeMultiplier * remainingMigrationTime * ONE_SCALED;
        uint256 fraction = (numerator / totalMigrationDuration) / ONE_SCALED;

        return ONE_SCALED + fraction;
    }

    function getL1LockedAmount(address user) public view returns (uint256) {
        return uint256(
            ScrollL1StorageReader.sloadValueFromSecondLevelSlot(l1Migrator, LOCKED_VALUE_BY_USER_SLOT, uint160(user))
        );
    }

    function getBonusRanges() external view returns (BonusRange[] memory) {
        return bonusRanges;
    }

    function getUserInformation(address user) external view returns (UserInfo memory) {
        return userMigrationInformation[user];
    }

    function getStartMigrationTimestamp() external returns (uint256) {
        return startMigrationTimestamp;
    }

    function getEndMigrationTimestamp() external returns (uint256) {
        return endMigrationTimestamp;
    }
}
