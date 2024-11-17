// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BridgedToken} from "../src/BridgedToken.sol";

contract DeployBridgeToken is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        address owner = vm.envAddress("TOKEN_OWNER");
        string memory name = vm.envString("TOKEN_NAME");
        string memory symbol = vm.envString("TOKEN_SYMBOL");

        vm.startBroadcast(privateKey);

        BridgedToken bridgedToken = new BridgedToken(owner, name, symbol);
        console.log("Bridged token deployed to:", address(bridgedToken));

        vm.stopBroadcast();
    }
}
