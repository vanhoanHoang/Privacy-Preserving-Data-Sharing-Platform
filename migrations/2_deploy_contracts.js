const DataSharingContract = artifacts.require("DataSharingContract");
const IdentityContract = artifacts.require("IdentityContract");
const EllipticCurveLib = artifacts.require("EllipticCurveLib");
const ECSecp256k1 = artifacts.require("ECSecp256k1");
const ECRingSignature = artifacts.require("ECRingSignature");
const ProxyContract = artifacts.require("ProxyContract");


module.exports = function(deployer) {

  deployer.deploy(IdentityContract).then(function(){
      return deployer.deploy(ProxyContract, IdentityContract.address);
  });

  deployer.deploy(EllipticCurveLib);
  deployer.link(EllipticCurveLib, ECSecp256k1);
  deployer.deploy(ECSecp256k1).then(function(){
      return deployer.deploy(ECRingSignature, ECSecp256k1.address).then(function(instance){
          return deployer.deploy(DataSharingContract, ECRingSignature.address);
      });
  });

};
