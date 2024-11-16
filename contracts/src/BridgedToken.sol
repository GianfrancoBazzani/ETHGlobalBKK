// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/token/ERC20/ERC20.sol";

contract BridgedToken is ERC20 {
    address public bridge;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        bridge = msg.sender;
    }

    modifier onlyBridge() {
        require(msg.sender == bridge, "Only bridge can mint");
        _;
    }

    function mint(address to, uint256 amount) external onlyBridge {
        _mint(to, amount);
    }
}
