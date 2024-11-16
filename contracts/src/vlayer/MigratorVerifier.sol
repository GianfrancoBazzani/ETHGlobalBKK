// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Verifier, Proof} from "vlayer-0.1.0/Verifier.sol";
import {MigratorProver} from "./MigratorProver.sol";

contract MigratorVerifier is Verifier {
    address prover;

    function claimWhale(Proof calldata, address claimer, uint256 balance)
        public
        onlyVerified(prover, MigratorProver.averageBalance.selector)
    {}
}
