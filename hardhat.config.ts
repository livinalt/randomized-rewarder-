import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require('dotenv').config();

const ALCHEMY_API_KEY_URL = process.env.ALCHEMY_API_KEY_URL;
const ALCHEMY_MUMBAI_API_KEY_URL = process.env.MUMBAI_ALCHEMY_API_KEY_URL;
const ALCHEMY_SEPOLIA_API_KEY_URL = process.env.ALCHEMY_SEPOLIA_API_KEY_URL;

const ACCOUNT_PRIVATE_KEY = process.env.ACCOUNT_PRIVATE_KEY;



const config: HardhatUserConfig = {
  solidity: "0.8.0",
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
