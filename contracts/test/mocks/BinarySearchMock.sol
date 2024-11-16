// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {MigratorVerifier} from "../../src/vlayer/MigratorVerifier.sol";
import {Test} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract BinarySearchMock is Test {
    MigratorVerifier.BonusRange[] private bonusRanges;

    error InvalidState();

    constructor(MigratorVerifier.BonusRange[] memory _bonusRanges) {
        bonusRanges = _bonusRanges;
    }

    function findMultiplierForValue(uint256 value) external view returns (uint256 multiplier) {
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

    function setArray(MigratorVerifier.BonusRange[] memory _bonusRanges) external {
        bonusRanges = _bonusRanges;
    }
}
