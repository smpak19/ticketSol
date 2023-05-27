import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(deployer);

  
  const TicketNFTFactory = await ethers.getContractFactory("TicketNFTFactory");
  const TicketNFT = await ethers.getContractFactory("TicketNFT");
  const ticketNFTFactory = await TicketNFTFactory.deploy();
  const ticketNFT = await TicketNFT.deploy("", 0, 0, "");

  await ticketNFTFactory.deployed();
  await ticketNFT.deployed();

  // npx hardhat verify {address}
  console.log(`TicketNFTFactory deployed to ${ticketNFTFactory.address}`);
  // npx hardhat verify {address} --constructor-args arguments.js
  console.log(`Dummy ticketNFT deployed to ${ticketNFT.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
