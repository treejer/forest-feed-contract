const hre = require("hardhat");

const { ethers, upgrades } = require("hardhat");

async function main() {
    


  const ForestFeed = await hre.ethers.getContractFactory(
    "ForestFeed"
  );

  const AccessRestriction = await hre.ethers.getContractFactory(
    "AccessRestriction"
  );



  console.log("Deploying ForestFeed...");

  const [deployer] = await ethers.getSigners();

  let mockDaiToken;
  let mockRegularSale;
  let accessRestriction = deployer.address;

  if(hre.network.name=="localhost"){

    const MockDaiToken = await hre.ethers.getContractFactory(
        "MockDaiToken"
    );

    const MockRegularSale = await hre.ethers.getContractFactory(
        "MockRegularSale"
    );

    mockDaiToken = await MockDaiToken.deploy();

    await mockDaiToken.deployed();


    mockRegularSale = await MockRegularSale.deploy();

    await mockRegularSale.deployed();

    mockRegularSale = mockRegularSale.address;
    mockDaiToken = mockDaiToken.address;
    
  }else{}


  const forestFeed = await upgrades.deployProxy(ForestFeed,[
    accessRestriction,
    mockDaiToken,
    mockRegularSale
  ], {
    kind: "uups",
    initializer: "initialize",
  });

  await forestFeed.deployed();

  console.log("forestFeed deployed to:", forestFeed.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
