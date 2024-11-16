// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

interface IL1Blocks {
    function latestBlockNumber() external view returns (uint256);
}
