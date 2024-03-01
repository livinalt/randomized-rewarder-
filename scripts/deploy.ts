import { ethers } from "hardhat";

async function main() {
  
  const rewardToken = await ethers.deployContract("RewardToken");
  await rewardToken.waitForDeployment();
  
  const randomisedRewarder = await ethers.deployContract("RandomisedRewarder");
  await randomisedRewarder.waitForDeployment();

  console.log(`RewardToken deployed to ${rewardToken.target}`);
  console.log(`RandomisedRewarder deployed to ${randomisedRewarder.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
