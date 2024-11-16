# MigratoOoR!

## Migrate your community to Scroll and unlock a universe of efficiency.

MigratoOoR! is a tool to migrate a project's token supply from Mainnet to Scroll with the possibility to reward long-time holders and early migrators through token incentives.

### Testnet Addresses
TODO: ADD addresses


### Project description
MigratoOoR! is a tool that offers a simple framwork for projects who originally launched their tokens on Ethereum L1 to easily migrate their governance token to Scroll L2 in a trustless manner. Projects that initially launched their tokens on Ethereum L1 can take advantage of the lower costs and increased throughput of the Scroll rollup network, all while preserving Ethereum L1's security as a settlement layer and helping to alleviate network congestion.

A token migration includes the following steps:
* Migration Proposal: Protocol operators deploy a new governance ERC20 token on Scroll L2 through the MigratoOoR! dashboard and creates a migration proposal in MigratoOor! bridge contract. This token will be minted by the L1 -> L2 bridge as tokens migrate from L1.
* Migration Process: From a certain point in time the users can start to migrate the tokens through MigratoOoR! bridge in a trust-less manner.
* Rewards Distribution: As an additional configurable option, protocol operators can execute a final step of rewards distribution among the holders. These rewards are configurable through the MigratoOoR! dashboard and can incentivize users for early migrations and long-term holding.

Hosting the token's canonical supply on an L2 offers transaction cost benefits for both users and the project's team. It can also serve as an excellent way to align with Ethereum's rollup-centric scaling roadmap, particularly with Scroll's values and technical features. LDR; MigratoOoR! provides projects using our protocol with a decentralized, L2-native alternative to their pre-migration infrastructure setup.

### The problem that MigratoOoR! solves
MigratoOoR! addresses several key challenges faced by projects that initially launched their tokens on Ethereum Layer 1 (L1):
1. High Transaction Costs on Ethereum L1 -> Lower Price Scroll L2 transactions.
2. Scalability Bottlenecks -> Alleviate network congestion by migrating dao related computation to Scroll L2.
3. Complex Token Migration -> Standard Token Migration Framework.
5. Limited Interoperability -> Use of Chainlink's CCIP CCT to make te new governance token in Scroll multichain.

Tokens deployed solely on Ethereum L1 are restricted in terms of multichain interoperability. Projects need solutions to enable cross-chain functionality while maintaining the token's core features and security.

### Technical details
To construct a trustless L1 -> L2 bridge for token migrations, MigratoOoR! leverages Scroll's new L1SLOAD precompile, which allows users to verify token locks in the L1 bridge contract.

In the rewards distribution system MigratoOoR! migrator uses Vlayer time travel feature to compute and verify in Scroll L2 the amount of rewards acquired by long therm holding the tokens.

To introduce multichain functionality for the new token on Scroll, protocol owners can opt to deploy it as a Chainlink Cross-Chain Token, unlocking enhanced interoperability across multiple chains.
