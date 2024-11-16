// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

contract View_L1SLOAD {
    address constant L1_SLOAD_ADDRESS = 0x0000000000000000000000000000000000000101;

    function retrieveSlotFromL1(address l1StorageAddress, uint256 slot) internal view returns (bytes memory) {
        bool success;
        bytes memory result;
        (success, result) = L1_SLOAD_ADDRESS.staticcall(abi.encodePacked(l1StorageAddress, slot));
        if (!success) {
            revert("L1SLOAD failed");
        }
        return result;
    }

    function retrieveL1Balance(address user, address l1TokenAddress) public view returns (uint256) {
        uint256 slotNumber = 0; // ERC20 standard balance slot
        return abi.decode(
            retrieveSlotFromL1(l1TokenAddress, uint256(keccak256(abi.encodePacked(uint256(uint160(user)), slotNumber)))),
            (uint256)
        );
    }
}
