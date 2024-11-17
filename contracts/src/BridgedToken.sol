// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {Ownable2Step, Ownable} from "openzeppelin-contracts/access/Ownable2Step.sol";

/// @title The default token implementation for migrator compatibility
contract BridgedToken is ERC20, Ownable2Step {
    address public bridge;

    error NotAuthorized();

    constructor(address _owner, string memory _name, string memory _symbol) Ownable(_owner) ERC20(_name, _symbol) {}

    modifier onlyAuthorized() {
        require(owner() == msg.sender || msg.sender == bridge, NotAuthorized());
        _;
    }

    function mint(address to, uint256 amount) external onlyAuthorized {
        _mint(to, amount);
    }
}
