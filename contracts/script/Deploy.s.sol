// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "forge-std/Script.sol";
// import "../src/L1MigratorScrollL1StorageReader.sol";

// contract Deploy is Script {
//     function run() external {
//         uint256 privateKey = vm.envUint("PRIVATE_KEY");

//         vm.startBroadcast(privateKey);

//         L1MigratorScrollL1StorageReader l1sload = new L1MigratorScrollL1StorageReader();
//         console.log("L1SLOAD Contract deployed to:", address(l1sload));

//         vm.stopBroadcast();
//     }
// }
