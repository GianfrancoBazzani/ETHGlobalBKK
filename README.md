# MigratoOoR!

- Please, see the [Demo Video through this link](https://www.youtube.com/watch?v=1VlyXPb4ag8) 
- [Deployed website](https://ethglobal-bkk-eth-belgrade.vercel.app/)
- ETHGlobal Bangkok 2024 [submission](https://ethglobal.com/showcase/migrator-ethbelgrade-7x4pc)

## Migrate your community to Scroll and unlock a universe of efficiency.

MigratoOoR! is a tool that allows projects to migrate their token supply from Mainnet to Scroll, while offering incentives to long-time holders and early adopters through token rewards. With MigratoOoR!, projects can embrace Ethereum's rollup-centric scalability vision, utilizing Scroll's cost-efficient and high-performance infrastructure.

##### Table of Contents

[Overview](#overview)

[Key Features](#key-features)

[Technical Details](#technical-details)

[Testnet Contracts](#testnet-contracts)

[Notable Components](#notable-components)

[Images](#images)

---

### Background

MigratoOoR! was developed as part of the ETHGlobal Bangkok 2024 Hackathon by **Team Migrator ETHBelgrade**. The project showcases the potential of Ethereum rollups and their alignment with Ethereum’s rollup-centric roadmap. It was designed to tackle token migration challenges while leveraging cutting-edge L1 and L2 technologies, including Scroll and vlayer.

---

### Overview

MigratoOoR! simplifies the process of migrating a governance token from Ethereum L1 to Scroll L2 while maintaining Ethereum's robust security guarantees. It leverages Scroll's advanced technology to reduce costs and enhance scalability.

1. Migration Deployment: Protocol operators deploy a new ERC20 token on Scroll L2 (or instantiate an existing one) via the MigratoOoR! dashboard, which offers customizable parameters for any preferred configuration.
2. Migration Process: Users migrate their tokens from Ethereum L1 to Scroll L2 via a trustless bridge, locking tokens in the L1 contract and minting them in the L2.
3. Rewards Distribution: Protocol operators can distribute rewards to incentivize early migration and long-term token holding using the MigratoOoR! rewards system.
4. Hosting the canonical token supply on Scroll L2 brings significant transaction cost reductions and aligns projects with Ethereum's scaling roadmap.

### Key Features

#### The problem that MigratoOoR! solves

MigratoOoR! addresses several key challenges faced by projects that initially launched their tokens on Ethereum Layer 1 (L1):

1. High Transaction Costs on Ethereum L1 -> Lower Price Scroll L2 transactions.
2. Scalability Bottlenecks -> Alleviate network congestion by migrating dao related computation to Scroll L2.
3. Complex Token Migration -> Standard Token Migration Framework.
4. Limited Interoperability -> Use of Chainlink's CCIP CCT to make te new governance token in Scroll multichain.


### Technical details

To construct a trustless L1 -> L2 bridge for token migrations, MigratoOoR! leverages Scroll's new L1SLOAD precompile, which allows for verification of token locks in the L1 bridge contract.

In the rewards distribution system MigratoOoR! uses Vlayer's time travel feature to compute and verify each user's token-holding history, transparently ensuring that the proper rewards are acquired in Scroll L2 by long term holding the  the tokens.

To introduce multichain functionality for the new token on Scroll a cross-chain solution using Chainlink's CCIP has been integrated, protocol owners can opt to deploy it as a Chainlink Cross-Chain Token.

### Notable Components

- **L1 and L2 Contracts**: Core smart contracts for bridging and migration.
- **Frontend**: React-based interface to interact with the bridge.
- **Vlayer Integration**: Off-chain reward calculation and verification tools.
- **CCIP Integration**: Contracts and rerouting to showcase cross-chain functionality.

### Testnet Contracts

- **L1 Bridge Contract** (Token Locking): [0xa2969e30ff87ffd5fd5529a54c8ce95c0b86e51b](https://sepolia.etherscan.io/address/0xa2969e30ff87ffd5fd5529a54c8ce95c0b86e51b)
- **L2 Bridge Contract** (Token Minting): [0xaF5F991e11181E268F8a1e89a4aB84B1e5713FF8](https://l1sload-blockscout.scroll.io/address/0xaF5F991e11181E268F8a1e89a4aB84B1e5713FF8)
- **L2 Wrapped USDC**: [0x0468880bE4970DBab8c9aBE52D9063050652b8db](https://l1sload-blockscout.scroll.io/address/0x0468880bE4970DBab8c9aBE52D9063050652b8db)
- **Rewards Contract**: [0x67d2d3a45457b69259FB1F8d8178bAE4F6B11b4d](https://l1sload-blockscout.scroll.io/address/0x67d2d3a45457b69259FB1F8d8178bAE4F6B11b4d)

## Images

Below are visuals demonstrating the MigratoOoR! flow and dashboard:

### 1. Implementation Overview

![Implementation Overview](https://raw.githubusercontent.com/GianfrancoBazzani/ETHGlobalBKK/refs/heads/main/ressources/implementation.png)

### 2. Project Architecture

![Project Arch](https://raw.githubusercontent.com/GianfrancoBazzani/ETHGlobalBKK/refs/heads/main/ressources/project.png)

### 3. Welcome Page

![Welcome](https://raw.githubusercontent.com/GianfrancoBazzani/ETHGlobalBKK/refs/heads/main/ressources/welcome.png)

### 4. Migration Flow

![Migration](https://raw.githubusercontent.com/GianfrancoBazzani/ETHGlobalBKK/refs/heads/main/ressources/migration_full.png)

### 5. Bridge Process

![Bridge](https://raw.githubusercontent.com/GianfrancoBazzani/ETHGlobalBKK/refs/heads/main/ressources/bridge.png)

### 6. Rewards Distribution

![Rewards](https://raw.githubusercontent.com/GianfrancoBazzani/ETHGlobalBKK/refs/heads/main/ressources/rewards.png)
