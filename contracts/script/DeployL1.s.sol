// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/L1Bridge.sol";

contract DeployL1 is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        L1Bridge l1Bridge = new L1Bridge();
        console.log("L1Bridge deployed to:", address(l1Bridge));

        vm.stopBroadcast();
    }
}
