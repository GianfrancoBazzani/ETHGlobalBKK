// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Verifier, Proof} from "vlayer-0.1.0/Verifier.sol";
import {MigratorProver} from "./MigratorProver.sol";

import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {IMigratorVerifier} from "./interfaces/IMigratorVerifier.sol";

contract MigratorVerifier is Verifier, IMigratorVerifier {
    uint256 private constant ONE_SCALED = 1e18;
    uint256 private constant MINIMAL_MIGRATION_DURATION = 1 days;
    uint256 private constant BASE = 10000;

    address private immutable prover;
    uint256 private immutable baseTimeMultiplier;
    uint256 private immutable totalMigrationDuration;
    uint256 private immutable startMigrationTimestamp;
    uint256 private immutable endMigrationTimestamp;

    BonusRange[] private bonusRanges;

    struct BonusRange {
        uint184 rangeStartAmount;
        uint72 multiplier;
    }

    constructor(
        uint256 _startMigrationTimestamp,
        uint256 _endMigrationTimestamp,
        uint256 _baseTimeMultiplier,
        IERC20 _migratedToken,
        uint256 _startBlockForAccounting,
        uint256 _endBlockForAccounting,
        uint256 _minimalAverageBalanceForBonusEligibility,
        BonusRange[] memory _bonusRanges
    ) {
        require(_baseTimeMultiplier > 0, ZeroBaseMultiplier());
        require(
            _startMigrationTimestamp >= block.timestamp,
            InvalidMigrationStart(block.timestamp, _startMigrationTimestamp)
        );
        require(
            _endMigrationTimestamp > _startMigrationTimestamp,
            InvalidMigrationEnd(_startMigrationTimestamp, _endMigrationTimestamp)
        );

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
    }

    function completeMigration(Proof memory, address user, uint256 averageBalance)
        external
        onlyVerified(prover, MigratorProver.averageBalance.selector)
    {
        require(msg.sender == user, ProofIsNotGeneratedForCaller(user, msg.sender));
        require(endMigrationTimestamp > block.timestamp, BonusMigrationEnded());

        uint256 timeBonus = getUserTimeBonus(averageBalance);
        uint256 loyaltyBonus = getUserTimeBonus(averageBalance);

        notImplemented();
    }

    function getUserTimeBonus(uint256 usersAverageBalance) public view returns (uint256) {
        return (usersAverageBalance * getTimeMultiplier()) / ONE_SCALED;
    }

    function getUserLoyaltyBonus(uint256 usersAverageBalance) public view returns (uint256) {
        return (usersAverageBalance * findMultiplierForValue(usersAverageBalance)) / ONE_SCALED;
    }

    function getTimeMultiplier() private view returns (uint256) {
        uint256 remainingMigrationTime = endMigrationTimestamp - block.timestamp;

        uint256 numerator = baseTimeMultiplier * remainingMigrationTime * ONE_SCALED;
        uint256 fraction = (numerator / totalMigrationDuration) / ONE_SCALED;

        return ONE_SCALED + fraction;
    }

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

    function getBonusRanges() external view returns (BonusRange[] memory) {
        return bonusRanges;
    }

    // TODO: remove when everything is implemented
    error NOT_YET_IMPLEMENTED();

    function notImplemented() private {
        revert NOT_YET_IMPLEMENTED();
    }
}
