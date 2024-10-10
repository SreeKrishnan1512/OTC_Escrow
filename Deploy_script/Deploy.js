const hre = require ("hardhat");
// const {ethers}= require ("ethers");

const main= async ()=> {


    
    const Escrow= await hre.ethers.getContractFactory(`OTCEscrow`);
    
    const OCT_Escrow = await Escrow.deploy();
   
    await OCT_Escrow.waitForDeployment();
    
    console.log(`OCT Escrow contract address:`, OCT_Escrow.target);
    
    }
   

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});