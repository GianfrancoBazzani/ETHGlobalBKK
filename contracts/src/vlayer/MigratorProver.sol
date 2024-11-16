// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Prover, Proof} from "vlayer-0.1.0/Prover.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";

import {IMigratorProver} from "./interfaces/IMigratorProver.sol";

contract MigratorProver is Prover, IMigratorProver {
    IERC20 private immutable migratedToken;
    uint256 private immutable startBlockForAccounting;
    uint256 private immutable endBlockForAccounting;
    uint256 private immutable minimalAverageBalanceForBonusEligibility;

    constructor(
        IERC20 _migratedToken,
        uint256 _startBlockForAccounting,
        uint256 _endBlockForAccounting,
        uint256 _minimalAverageBalanceForBonusEligibility
    ) {
        require(address(_migratedToken) != address(0), MigratedTokenIsZero());
        require(
            block.number > _endBlockForAccounting,
            AccountingEndBlockMustBeInThePast(_endBlockForAccounting, block.number)
        );
        require(
            _endBlockForAccounting > _startBlockForAccounting,
            AccountingStartBlockMustBeInThePast(_startBlockForAccounting, _endBlockForAccounting)
        );

        // Check that the token has been deployed at the moment of {_startBlockForAccounting}
        setBlock(_startBlockForAccounting);
        try _migratedToken.totalSupply() returns (uint256) {}
        catch {
            revert TokenDoesNotExistAtTheAccountingStartBlock();
        }

        migratedToken = _migratedToken;
        startBlockForAccounting = _startBlockForAccounting;
        endBlockForAccounting = _endBlockForAccounting;
        minimalAverageBalanceForBonusEligibility = _minimalAverageBalanceForBonusEligibility;
    }

    function averageBalance(address user) external returns (Proof memory, address, uint256) {
        require(user != address(0), UserCantBeZero());

        uint256 cumulativeBalance;

        for (uint256 currentBlock = startBlockForAccounting; currentBlock < endBlockForAccounting; currentBlock++) {
            setBlock(currentBlock);
            cumulativeBalance += migratedToken.balanceOf(user);
        }
        uint256 userAverageBalance = cumulativeBalance / (endBlockForAccounting - startBlockForAccounting);

        require(
            userAverageBalance >= minimalAverageBalanceForBonusEligibility,
            IneligibleAverageBalance(userAverageBalance, minimalAverageBalanceForBonusEligibility)
        );

        return (proof(), user, userAverageBalance);
    }
}
