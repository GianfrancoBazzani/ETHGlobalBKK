// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/View_L1SLOAD.sol";

contract Interact is Script {
    function run() external view {
        address l1sloadAddress = address(
            0xfa29381958DD8a2dD86246FC0Ab2932972640580
        );

        View_L1SLOAD l1sload = View_L1SLOAD(l1sloadAddress);

        address l1Token = address(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238);
        address user = address(0x632b39E5Fe4EAAFDF21601b2Bc206ca0f602C85A);

        uint256 balance = l1sload.retrieveL1Balance(l1Token, user);
        console.log("Token Balance:", balance);
    }
}
