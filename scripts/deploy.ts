import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(deployer);

  const TicketNFTFactory = await ethers.getContractFactory("TicketNFTFactory");
  const ticketNFTFactory = await TicketNFTFactory.deploy();

  await ticketNFTFactory.deployed();

  console.log(`TicketNFTFactory deployed to ${ticketNFTFactory.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
