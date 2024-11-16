// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

interface IMigratorProver {
    error MigratedTokenIsZero();
    error UserCantBeZero();
    error AccountingStartBlockMustBeInThePast(uint256 startBlock, uint256 endBlock);
    error AccountingEndBlockMustBeInThePast(uint256 startAccountingBlock, uint256 endAccountingBlock);
    error TokenDoesNotExistAtTheAccountingStartBlock();
    error IneligibleAverageBalance(uint256 userAverageBalance, uint256 minimalAverageBalance);
}
