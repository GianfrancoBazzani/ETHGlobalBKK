// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {IL1Blocks} from "./interfaces/IL1Blocks.sol";

library ScrollL1StorageReader {
    address internal constant L1_SLOAD_ADDRESS = 0x0000000000000000000000000000000000000101;
    address internal constant L1_BLOCKS_ADDRESS = 0x5300000000000000000000000000000000000001;

    error SloadFailed(bytes returnedData);

    function getLatestL1BlockNumber() public view returns (uint256 latestL1BlockNumber) {
        return IL1Blocks(L1_BLOCKS_ADDRESS).latestBlockNumber();
    }

    function l1Sload(address targetContract, uint256 slot) internal view returns (bytes32) {
        bytes memory payload = abi.encodePacked(targetContract, slot);
        (bool success, bytes memory returnedData) = L1_SLOAD_ADDRESS.staticcall(payload);
        require(success, SloadFailed(returnedData));

        return abi.decode(returnedData, (bytes32));
    }

    /**
     * @dev Calculate the first-level storage slot for a token in the `lockedFunds` mapping.
     * This function computes the hash of the token address and the root slot
     *
     * The calculation follows the Solidity storage layout rules for mappings:
     * keccak256(abi.encodePacked(key, root_slot))
     *
     * @param contractAddr The address of the contract.
     * @param slot The slot to user for calculating
     * @return bytes32 The calculated first-level storage slot.
     */
    function calculateFirstLevelSlot(address contractAddr, uint256 slot) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(contractAddr, slot));
    }

    /**
     * @dev Calculate the second-level storage slot for a user in the `lockedFunds` mapping.
     * This function computes the hash of the user address and the first-level slot.
     *
     * The calculation follows the Solidity storage layout rules for nested mappings:
     * keccak256(abi.encodePacked(inner_key, keccak256(abi.encodePacked(outer_key, root_slot))))
     *
     * @param contractAddr The address of the contract
     * @param slot The slot to use
     * @param secondLevelKey The second layer key
     * @return bytes32 The calculated second-level storage slot.
     */
    function calculateSecondLevelSlot(address contractAddr, uint256 slot, uint256 secondLevelKey)
        internal
        pure
        returns (bytes32)
    {
        bytes32 firstLevelSlot = calculateFirstLevelSlot(contractAddr, slot);
        return keccak256(abi.encodePacked(secondLevelKey, firstLevelSlot));
    }

    function sloadValueFromSecondLevelSlot(address contractAddr, uint256 slot, uint256 secondLevelKey)
        internal
        view
        returns (bytes32)
    {
        uint256 secondLevelSlot = uint256(calculateSecondLevelSlot(contractAddr, slot, secondLevelKey));
        return l1Sload(contractAddr, secondLevelSlot);
    }
}
