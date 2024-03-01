import { ethers } from "hardhat";

  const initialOwner = "0x5723fea1DDC24609F0150Ff0C0B96Af77ceF0753";
  const name = "Minato Token";
  const symbol = "MNT";
  const decimals = 18;

  const tokenAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";


async function main() {
  // deploying the Token contract
  const rewardToken = await ethers.deployContract("RewardToken",[
       initialOwner, name, symbol, decimals] );

  await rewardToken.waitForDeployment();
  console.log(`RewardToken deployed to ${rewardToken.target}`);
  // RewardToken deployed to 0x5FbDB2315678afecb367f032d93F642f64180aa3


  
  // deploying the Random Rewarder contract
  const randomisedRewarder = await ethers.deployContract("RandomisedRewarder",[initialOwner, tokenAddress]);
  await randomisedRewarder.waitForDeployment();
  console.log(`RandomisedRewarder deployed to ${randomisedRewarder.target}`);  
  // RandomisedRewarder deployed to 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
