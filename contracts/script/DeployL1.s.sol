// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/L1Migrator.sol";

contract DeployL1 is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        L1Migrator l1Migrator = new L1Migrator();
        console.log("L1Migrator deployed to:", address(l1Migrator));

        vm.stopBroadcast();
    }
}
