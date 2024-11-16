// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {HelperUtils} from "./utils/HelperUtils.s.sol"; // Utility functions for JSON parsing and chain info
import {HelperConfig} from "./HelperConfig.s.sol"; // Network configuration helper
import {TokenPool} from "@chainlink/contracts-ccip/src/v0.8/ccip/pools/TokenPool.sol";
import {RateLimiter} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/RateLimiter.sol";

contract ApplyChainUpdates is Script {
    function run() external {
        if (block.chainid != 11155111) revert("Only Sepolia!!");
        // Get the current chain name based on the chain ID
        string memory chainName = HelperUtils.getChainName(block.chainid);

        // Construct paths to the configuration and local pool JSON files
        string memory root = vm.projectRoot();
        string memory configPath = string.concat(root, "/script/config.json");
        string memory localPoolPath = string.concat(root, "/script/output/deployedTokenPool_", chainName, ".json");

        // Read the remoteChainIds from config.json based on the current chain ID
        uint256[] memory remoteChainIds = HelperUtils.getUintArrayFromJson(
            vm, configPath, string.concat(".chainUpdateRemoteChains.", HelperUtils.uintToStr(block.chainid))
        );

        // Fetch the remote network configuration to get the chain selector
        HelperConfig helperConfig = new HelperConfig();
        // HelperConfig.NetworkConfig[] memory remoteNetworkConfigs;

        // Extract addresses from the JSON files
        address poolAddress =
            HelperUtils.getAddressFromJson(vm, localPoolPath, string.concat(".deployedTokenPool_", chainName));
        require(poolAddress != address(0), "Invalid pool address");

        // Get the remote chain name based on the remoteChainId
        // string[] memory remoteChainNames;
        // string[] memory remotePoolPaths;
        // string[] memory remoteTokenPaths;
        // address[] memory remotePoolAddress;
        // address[] memory remoteTokenAddress;
        // uint64[] memory remoteChainSelectors;
        // Prepare chain update data for configuring cross-chain transfers
        TokenPool.ChainUpdate[] memory chainUpdates = new TokenPool.ChainUpdate[](remoteChainIds.length);

        for (uint256 i; i < remoteChainIds.length; i++) {
            string memory remoteChainName = HelperUtils.getChainName(remoteChainIds[i]);
            string memory remotePoolPath =
                string.concat(root, "/script/output/deployedTokenPool_", remoteChainName, ".json");
            string memory remoteTokenPath =
                string.concat(root, "/script/output/deployedToken_", remoteChainName, ".json");
            address remotePoolAddress = HelperUtils.getAddressFromJson(
                vm, remotePoolPath, string.concat(".deployedTokenPool_", remoteChainName)
            );
            address remoteTokenAddress =
                HelperUtils.getAddressFromJson(vm, remoteTokenPath, string.concat(".deployedToken_", remoteChainName));
            HelperConfig.NetworkConfig memory remoteNetworkConfig =
                HelperUtils.getNetworkConfig(helperConfig, remoteChainIds[i]);
            uint64 remoteChainSelector = remoteNetworkConfig.chainSelector;
            require(remotePoolAddress != address(0), "Invalid remote pool address");
            require(remoteTokenAddress != address(0), "Invalid remote token address");
            require(remoteChainSelector != 0, "chainSelector is not defined for the remote chain");

            chainUpdates[i] = TokenPool.ChainUpdate({
                remoteChainSelector: remoteChainSelector, // Chain selector of the remote chain
                allowed: true, // Enable transfers to the remote chain
                remotePoolAddress: abi.encode(remotePoolAddress), // Encoded address of the remote pool
                remoteTokenAddress: abi.encode(remoteTokenAddress), // Encoded address of the remote token
                outboundRateLimiterConfig: RateLimiter.Config({
                    isEnabled: false, // Set to true to enable outbound rate limiting
                    capacity: 0, // Max tokens allowed in the outbound rate limiter
                    rate: 0 // Refill rate per second for the outbound rate limiter
                }),
                inboundRateLimiterConfig: RateLimiter.Config({
                    isEnabled: false, // Set to true to enable inbound rate limiting
                    capacity: 0, // Max tokens allowed in the inbound rate limiter
                    rate: 0 // Refill rate per second for the inbound rate limiter
                })
            });
        }

        vm.startBroadcast();

        // Instantiate the local TokenPool contract
        TokenPool poolContract = TokenPool(poolAddress);

        // Apply the chain updates to configure the pool
        poolContract.applyChainUpdates(chainUpdates);

        console.log("Chain update applied to pool at address:", poolAddress);

        vm.stopBroadcast();
    }
}
