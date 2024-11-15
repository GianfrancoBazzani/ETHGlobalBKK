// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IL1Blocks {
    function latestBlockNumber() external view returns (uint256);
}

interface IERC20 {
    function mint(address to, uint256 amount) external;
}

contract L2BridgeChecker {
    address constant L1_BLOCKS_ADDRESS =
        0x5300000000000000000000000000000000000001;
    address constant L1_SLOAD_ADDRESS =
        0x0000000000000000000000000000000000000101;
    address immutable l1BridgeAddress;

    // Mapping: L1 Token -> L2 Token
    mapping(address => address) public tokenMappings;

    event TokenMapped(address indexed l1Token, address indexed l2Token);
    event TokensMinted(
        address indexed l1Token,
        address indexed user,
        uint256 amount
    );

    constructor(address _l1BridgeAddress) {
        require(_l1BridgeAddress != address(0), "L1 Bridge address is zero");
        l1BridgeAddress = _l1BridgeAddress;
    }

    /**
     * @dev Map an L1 token to an L2 token.
     * @param l1Token The address of the token on L1.
     * @param l2Token The address of the corresponding token on L2.
     */
    function mapToken(address l1Token, address l2Token) external {
        require(
            l1Token != address(0) && l2Token != address(0),
            "Invalid token address"
        );
        require(tokenMappings[l1Token] == address(0), "Token already mapped");
        tokenMappings[l1Token] = l2Token;

        emit TokenMapped(l1Token, l2Token);
    }

    /**
     * @dev Retrieve the latest L1 block number that L2 has visibility on.
     */
    function latestL1BlockNumber() public view returns (uint256) {
        return IL1Blocks(L1_BLOCKS_ADDRESS).latestBlockNumber();
    }

    /**
     * @dev Get locked funds from L1 for a specific token and user.
     * @param l1Token The address of the token on L1.
     * @param user The address of the user.
     * @return The amount of locked funds.
     */
    function getLockedFundsFromL1(
        address l1Token,
        address user
    ) public view returns (uint256) {
        // Calculate the storage slot: keccak256(abi.encodePacked(user, keccak256(abi.encodePacked(token, slot))))
        uint256 slot = uint256(
            keccak256(
                abi.encodePacked(
                    user,
                    uint256(keccak256(abi.encodePacked(l1Token, uint256(0))))
                )
            )
        );

        // Prepare the input for the L1SLOAD call
        bytes memory input = abi.encodePacked(l1BridgeAddress, slot);

        // Perform the L1SLOAD call
        (bool success, bytes memory result) = L1_SLOAD_ADDRESS.staticcall(
            input
        );
        require(success, "L1SLOAD failed");

        // Decode the result as a uint256
        return abi.decode(result, (uint256));
    }

    /**
     * @dev Mint bridged tokens on L2 based on locked funds on L1.
     * @param l1Token The address of the token on L1.
     * @param user The address of the user to mint tokens for.
     */
    function mint(address l1Token, address user) external {
        require(user != address(0), "Invalid user address");

        address l2Token = tokenMappings[l1Token];
        require(l2Token != address(0), "L2 token not mapped");

        uint256 lockedAmount = getLockedFundsFromL1(l1Token, user);
        require(lockedAmount > 0, "No funds locked on L1");

        IERC20(l2Token).mint(user, lockedAmount);

        emit TokensMinted(l1Token, user, lockedAmount);
    }
}
