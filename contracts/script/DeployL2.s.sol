// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/L2BridgeChecker.sol";

contract DeployL2 is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address l1BridgeAddress = vm.envAddress("L1_BRIDGE_ADDRESS");
        vm.startBroadcast(privateKey);

        L2BridgeChecker l2BridgeChecker = new L2BridgeChecker(l1BridgeAddress);
        console.log("L2BridgeChecker deployed to:", address(l2BridgeChecker));

        vm.stopBroadcast();
    }
}
