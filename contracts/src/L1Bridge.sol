// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract L1Bridge {
    // Mapping: token address => user address => amount locked
    mapping(address => mapping(address => uint256)) public lockedFunds;

    event FundsLocked(
        address indexed token,
        address indexed user,
        uint256 amount
    );

    /**
     * @dev Lock ERC20 tokens for bridging to L2.
     * @param token Address of the ERC20 token.
     * @param amount Amount of tokens to lock.
     */
    function lockFunds(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(token != address(0), "Invalid token address");

        // Transfer tokens from user to the bridge
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // Update locked funds mapping
        lockedFunds[token][msg.sender] += amount;

        emit FundsLocked(token, msg.sender, amount);
    }

    /**
     * @dev Get the locked balance of a user for a specific token.
     * @param token Address of the ERC20 token.
     * @param user Address of the user.
     * @return Locked balance of the user for the specified token.
     */
    function getLockedFunds(
        address token,
        address user
    ) external view returns (uint256) {
        return lockedFunds[token][user];
    }
}
