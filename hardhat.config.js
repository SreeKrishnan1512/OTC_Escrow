require("@nomicfoundation/hardhat-toolbox");

require('dotenv').config();

const { TESTNET_RPC, PRIVATE_KEY, API_KEY } = process.env;


module.exports = {
  solidity: "0.8.20",
  networks: {
    arb: {
      url: TESTNET_RPC,
      accounts: [PRIVATE_KEY]
    },
  },
  settings: {
    optimizer: {
      enabled: true, // Enable optimizer for better gas efficiency
      runs: 200, // Number of optimization runs
    },
  },
  sourcify: {
    enabled: true
  },
  etherscan: {
    apiKey: {
      arbitrumSepolia: API_KEY
    }
  }
};