// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Proof} from "vlayer-0.1.0/Proof.sol";

interface IMigratorProver {
    error MigratedTokenIsZero();
    error UserCantBeZero();
    error AccountingStartBlockMustBeInThePast(uint256 startBlock, uint256 endBlock);
    error AccountingEndBlockMustBeInThePast(uint256 startAccountingBlock, uint256 endAccountingBlock);
    error TokenDoesNotExistAtTheBlock(uint256 blockNumber);
    error IneligibleAverageBalance(uint256 userAverageBalance, uint256 minimalAverageBalance);

    function averageBalance(address user) external returns (Proof memory, address, uint256);
}
