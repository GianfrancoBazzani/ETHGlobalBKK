export const L2BridgeCheckerABI = [
  {
    type: "constructor",
    inputs: [
      { name: "_l1BridgeAddress", type: "address", internalType: "address" },
    ],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    name: "deployBridgedToken",
    inputs: [
      { name: "name", type: "string", internalType: "string" },
      { name: "symbol", type: "string", internalType: "string" },
    ],
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    name: "getLockedFundsFromL1",
    inputs: [
      { name: "l1Token", type: "address", internalType: "address" },
      { name: "user", type: "address", internalType: "address" },
    ],
    outputs: [{ name: "", type: "uint256", internalType: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "latestL1BlockNumber",
    inputs: [],
    outputs: [{ name: "", type: "uint256", internalType: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "mapToken",
    inputs: [
      { name: "l1Token", type: "address", internalType: "address" },
      { name: "l2Token", type: "address", internalType: "address" },
    ],
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    name: "mint",
    inputs: [
      { name: "l1Token", type: "address", internalType: "address" },
      { name: "user", type: "address", internalType: "address" },
    ],
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    name: "tokenMappings",
    inputs: [{ name: "", type: "address", internalType: "address" }],
    outputs: [{ name: "", type: "address", internalType: "address" }],
    stateMutability: "view",
  },
  {
    type: "event",
    name: "L2TokenDeployed",
    inputs: [
      {
        name: "l2Token",
        type: "address",
        indexed: true,
        internalType: "address",
      },
      { name: "name", type: "string", indexed: false, internalType: "string" },
      {
        name: "symbol",
        type: "string",
        indexed: false,
        internalType: "string",
      },
    ],
    anonymous: false,
  },
  {
    type: "event",
    name: "TokenMapped",
    inputs: [
      {
        name: "l1Token",
        type: "address",
        indexed: true,
        internalType: "address",
      },
      {
        name: "l2Token",
        type: "address",
        indexed: true,
        internalType: "address",
      },
    ],
    anonymous: false,
  },
  {
    type: "event",
    name: "TokensMinted",
    inputs: [
      {
        name: "l1Token",
        type: "address",
        indexed: true,
        internalType: "address",
      },
      {
        name: "l2Token",
        type: "address",
        indexed: true,
        internalType: "address",
      },
      { name: "user", type: "address", indexed: true, internalType: "address" },
      {
        name: "amount",
        type: "uint256",
        indexed: false,
        internalType: "uint256",
      },
    ],
    anonymous: false,
  },
];
