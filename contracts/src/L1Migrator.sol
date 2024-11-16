// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20, SafeERC20} from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";

contract L1Migrator {
    using SafeERC20 for IERC20;

    // Mapping: token address => user address => amount locked
    mapping(address token => mapping(address user => uint256 amountLocked)) public lockedFunds;

    event FundsLocked(address indexed token, address indexed user, uint256 amount);

    /**
     * @dev Lock ERC20 tokens for bridging to L2.
     * @param token Address of the ERC20 token.
     * @param amount Amount of tokens to lock.
     */
    function lockFunds(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(token != address(0), "Invalid token address");

        uint256 balanceBefore = IERC20(token).balanceOf(address(this));
        // Transfer tokens from user to the bridge
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        uint256 balanceAfter = IERC20(token).balanceOf(address(this));

        uint256 actualAmountLocked = balanceAfter - balanceBefore;
        // Update locked funds mapping
        lockedFunds[token][msg.sender] += actualAmountLocked;

        emit FundsLocked(token, msg.sender, actualAmountLocked);
    }

    /**
     * @dev Get the locked balance of a user for a specific token.
     * @param token Address of the ERC20 token.
     * @param user Address of the user.
     * @return Locked balance of the user for the specified token.
     */
    function getLockedFunds(address token, address user) external view returns (uint256) {
        return lockedFunds[token][user];
    }
}
