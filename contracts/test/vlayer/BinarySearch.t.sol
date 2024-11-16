// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {BinarySearchMock, MigratorVerifier} from "../mocks/BinarySearchMock.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/console.sol";
import {MockToken} from "../mocks/ERC20Mock.sol";

contract BinarySearchTest is Test {
    function testFuzz_binaryRangeSearch(MigratorVerifier.BonusRange[] memory arr, uint256 value) external {
        vm.assume(arr.length < 15);
        vm.assume(arr.length > 0);
        vm.assume(arr[0].rangeStartAmount == 0);

        // Only ascending order is allowed
        for (uint256 i; i < arr.length - 1; i++) {
            if (arr[i].rangeStartAmount >= arr[i + 1].rangeStartAmount) {
                vm.assume(false);
            }
        }

        BinarySearchMock mock = new BinarySearchMock(arr);
        uint256 multiplier = mock.findMultiplierForValue(value);

        // Verify correctness
        for (uint256 i; i < arr.length - 1; i++) {
            if (value >= arr[i].rangeStartAmount && arr[i + 1].rangeStartAmount > value) {
                require(multiplier == arr[i].multiplier, "incorrect multiplier");
            }
        }
    }
}
