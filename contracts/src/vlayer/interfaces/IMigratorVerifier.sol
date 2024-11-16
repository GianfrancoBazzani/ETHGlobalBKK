// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Proof} from "vlayer-0.1.0/Proof.sol";

interface IMigratorVerifier {
    error ZeroBaseMultiplier();
    error InvalidMigrationStart(uint256 currentBlockNumber, uint256 providedBlockNumber);
    error InvalidMigrationEnd(uint256 startBlockNumber, uint256 endBlockNumber);
    error ProofIsNotGeneratedForCaller(address proofGeneratedFor, address caller);
    error BonusMigrationEnded();
    error MigrationDurationTooSmall();
    error RangeAmountsDecreasing(uint256 smallerIndexWhichIsGreaterInValue);
    error NotZeroIndexMultiplierMustBeNonZero(uint256 multiplierIndex);
    error BonusRangesArrayIsEmpty();
    error InvalidState();
    error FirsRangeStartAmountMustBeZero();
    error L1MigratorMustBeNotZero();
    error UserAlreadyMigrated();
}
