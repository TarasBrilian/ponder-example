import { createConfig } from "ponder";
import { erc20Abi } from "viem";

import { VaultAbi } from "./abis/VaultAbi";
import { TokenDepositAbi } from "./abis/TokenDepositAbi";
// import { arbitrumSepolia } from "viem/chains";

export default createConfig({
  chains: {
    arbitrumSepolia: {
      id: 421614,
      rpc: process.env.PONDER_RPC_URL_1!,
    },
  },
  contracts: {
    VaultContract: {
      chain: "arbitrumSepolia",
      abi: VaultAbi,
      address: "0xD1fECB135eE971F7DB0a1B0506e9DC1dD1532b1C",
      startBlock: 154233060,
    },
    ERC20:{
      chain: "arbitrumSepolia",
      abi: TokenDepositAbi,
      address: "0x886aD109ca35c7B5cf7017aF9F5b2C3306A666f9",
      startBlock: 154233060,
    },
  },
    accounts: { 
    BeaverBuild: { 
      chain: "arbitrumSepolia", 
      address: "0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5", 
      startBlock: 20000000, 
    }, 
  }, 
  database: {
    kind: "postgres",
    connectionString: "postgresql://postgres:[password]@db.xrnimdgkxitsdeeuprmq.supabase.co:5432/postgres"
  }
});
