import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config({ path: ".env" });


const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    // hardhat: {
    //   forking: {
    //     url: ALCHEMY_MAINNET_API_KEY_URL,
    //   }
    // },
    sepolia: {
      url: ALCHEMY_SEPOLIA_API_KEY_URL,
      accounts: [ACCOUNT_PRIVATE_KEY],
    },
    mumbai: {
      url: ALCHEMY_MUMBAI_API_KEY_URL,
      accounts: [ACCOUNT_PRIVATE_KEY],
    }   
  },

  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
};

export default config;
