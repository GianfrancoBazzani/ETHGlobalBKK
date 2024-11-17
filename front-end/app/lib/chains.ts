import { defineChain } from "viem";

export const scrollDevnet = defineChain({
  id: 2227728,
  name: "Scroll Devnet",
  nativeCurrency: { name: "Sepolia Ether", symbol: "ETH", decimals: 18 },
  rpcUrls: {
    default: { http: ["https://l1sload-rpc.scroll.io"] },
  },
  blockExplorers: {
    default: {
      name: "BLockscout",
      url: "https://l1sload-blockscout.scroll.io",
    },
  },
});
