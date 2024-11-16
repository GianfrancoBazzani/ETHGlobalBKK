// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBurnMintERC677 {
    function mint(address to, uint256 amount) external;
}

contract TokenMinter {
    address public s_tokenAddress;

    // Event for logging token address updates
    event TokenAddressUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Sets the address of the token to be minted.
     * @param _tokenAddress The address of the token contract.
     */
    function setToken(address _tokenAddress) external {
        require(_tokenAddress != address(0), "Token address cannot be zero");
        emit TokenAddressUpdated(s_tokenAddress, _tokenAddress);
        s_tokenAddress = _tokenAddress;
    }

    /**
     * @dev Mints tokens to a specified address.
     * @param to The address to receive the minted tokens.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external {
        require(s_tokenAddress != address(0), "Token address not set");
        require(to != address(0), "Recipient address cannot be zero");
        require(amount > 0, "Amount must be greater than zero");

        IBurnMintERC677(s_tokenAddress).mint(to, amount);
    }
}
