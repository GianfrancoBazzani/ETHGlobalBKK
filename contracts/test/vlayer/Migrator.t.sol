// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {VTest, Proof} from "vlayer-0.1.0/testing/VTest.sol";

import {MigratorVerifier} from "../../src/vlayer/MigratorVerifier.sol";
import {MigratorProver, ScrollL1StorageReader} from "../../src/vlayer/MigratorVerifier.sol";
import {BridgedToken} from "../../src/BridgedToken.sol";
import {L1Migrator} from "../../src/L1Migrator.sol";

import {IERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/console.sol";

contract BinarySearchTest is VTest {
    address private immutable OWNER = makeAddr("OWNER");
    address private immutable ALICE = makeAddr("ALICE");

    uint256 private constant INITIAL_TOKEN_L1_AMOUNT = 100e18;
    uint256 private constant INITIAL_TOKEN_L2_AMOUNT = INITIAL_TOKEN_L1_AMOUNT * 5;

    uint256 private constant INITIAL_ACCOUNTING_BLOCK = 100;
    uint256 private constant INTERMEDIATE_ACCOUNTING_BLOCK = INITIAL_ACCOUNTING_BLOCK * 100;
    uint256 private constant END_ACCOUNTING_BLOCK = INTERMEDIATE_ACCOUNTING_BLOCK * 100;

    uint256 private constant INITIAL_MIGRATION_TIME = 1000;
    uint256 private constant INTERMEDIATE_MIGRATION_TIME = INITIAL_MIGRATION_TIME + 10 days;
    uint256 private constant END_MIGRATION_TIME = INITIAL_MIGRATION_TIME + 20 days;

    uint256 private constant BASE_TIME_MULTIPLIER = 5e16; // 5%
    uint72 private constant BASE_AVERAGE_BALANCE_MULTIPLIER = 5e16; // 5%

    MigratorVerifier.BonusRange[] private TEST_BONUS_RANGES;

    BridgedToken private l1Token;
    BridgedToken private l2Token;
    L1Migrator private l1Migrator;

    MigratorVerifier private verifier;
    MigratorProver private prover;

    function setUp() external {
        vm.warp(INITIAL_MIGRATION_TIME);
        vm.roll(INITIAL_ACCOUNTING_BLOCK);

        l1Token = new BridgedToken(OWNER, "L1Token", "L1");
        l2Token = new BridgedToken(OWNER, "L2Token", "L2");

        vm.startPrank(OWNER);
        l1Token.mint(address(OWNER), INITIAL_TOKEN_L1_AMOUNT);
        l1Token.mint(address(ALICE), INITIAL_TOKEN_L1_AMOUNT);
        vm.stopPrank();

        l1Migrator = new L1Migrator();

        vm.warp(INTERMEDIATE_MIGRATION_TIME);
        vm.roll(INTERMEDIATE_ACCOUNTING_BLOCK);

        MigratorVerifier.BonusRange memory snapshotAlike =
            MigratorVerifier.BonusRange({rangeStartAmount: 0, multiplier: BASE_AVERAGE_BALANCE_MULTIPLIER});

        MigratorVerifier.BonusRange[] memory bonusRange = new MigratorVerifier.BonusRange[](1);
        bonusRange[0] = snapshotAlike;

        verifier = new MigratorVerifier(
            address(l1Migrator),
            INTERMEDIATE_MIGRATION_TIME + 100,
            END_MIGRATION_TIME + 100,
            BASE_TIME_MULTIPLIER,
            l1Token,
            l2Token,
            INITIAL_ACCOUNTING_BLOCK,
            INITIAL_ACCOUNTING_BLOCK + 50,
            0,
            bonusRange
        );

        prover = MigratorProver(verifier.getProver());

        // Liquidity on L2
        vm.prank(OWNER);
        l2Token.mint(address(verifier), type(uint96).max);
    }

    function fundAccountAndSkipTime(address who, uint256 amount, uint256 timeToJump, uint256 blockNumberToJump)
        internal
    {
        vm.prank(OWNER);
        l1Token.mint(who, amount);

        vm.warp(timeToJump);
        vm.roll(blockNumberToJump);
    }

    function test_userLocksTheTokenSuccessfully() external {
        vm.startPrank(OWNER);
        l1Token.approve(address(l1Migrator), type(uint256).max);
        l1Migrator.lockFunds(address(l1Token), INITIAL_TOKEN_L1_AMOUNT);
        vm.stopPrank();
    }

    function test_bridgeTokensWithAReward() external {
        vm.warp(block.timestamp + 120);
        vm.roll(block.number + 10);

        vm.startPrank(ALICE);

        l1Token.approve(address(l1Migrator), type(uint256).max);
        l1Migrator.lockFunds(address(l1Token), INITIAL_TOKEN_L1_AMOUNT);

        callProver();
        (, address user, uint256 averageBalance) = prover.averageBalance(address(ALICE));

        Proof memory proof = getProof();

        // Mock call to SCROLL L1SLOAD precompile
        vm.mockCall(
            ScrollL1StorageReader.L1_SLOAD_ADDRESS,
            calculateCdToL1SLOAD(ALICE),
            abi.encode(l1Migrator.getLockedFunds(address(l1Token), ALICE))
        );

        verifier.completeMigration(proof, user, averageBalance);

        vm.stopPrank();
    }

    function calculateCdToL1SLOAD(address user) internal view returns (bytes memory data) {
        bytes32 slot = ScrollL1StorageReader.calculateSecondLevelSlot(address(l1Migrator), 0, uint160(user));
        return abi.encodePacked(l1Migrator, slot);
    }
}
