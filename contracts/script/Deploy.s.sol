// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/View_L1SLOAD.sol";

contract Deploy is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        View_L1SLOAD l1sload = new View_L1SLOAD();
        console.log("L1SLOAD Contract deployed to:", address(l1sload));

        vm.stopBroadcast();
    }
}
