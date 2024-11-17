// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {L1Migrator} from "../src/L1Migrator.sol";

contract DeployBridgeToken is Script {
    function run() external returns (L1Migrator) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        L1Migrator l1migrator = new L1Migrator();
        console.log("l1migrator token deployed to:", address(l1migrator));

        vm.stopBroadcast();

        return l1migrator;
    }
}
