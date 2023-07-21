const hre = require("hardhat");

const { ethers, upgrades } = require("hardhat");

async function main() {
  const AccessRestriction = await hre.ethers.getContractFactory(
    "AccessRestriction"
  );

  console.log("Deploying AccessRestriction...");

  const [deployer] = await ethers.getSigners();

  const accessRestriction = await upgrades.deployProxy(AccessRestriction,[
    deployer.address
  ], {
    kind: "uups",
    initializer: "initialize",
  });

  await accessRestriction.deployed();

  console.log("accessRestriction deployed to:", accessRestriction.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
