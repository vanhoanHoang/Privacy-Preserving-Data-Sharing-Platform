pragma solidity >=0.5.0 < 0.7.0;


/**
 * @dev The ProxyContract plays the registry role to store all addresses of all the deployed global identity contracts.
 * One can add updated contract in the registry so that users are aware of the up-to-date contract to interact with
*/

contract ProxyContract{

    /* @dev store all versions of global identity contracts, making the contract upgradable
    */
    address[] public globalIdentityContractList;
    address public currentContractVersion;


    /*
    * @param _initialContractVersion: the address of the firstly deployed GlobalIdentityContract
    */

    constructor(address _initialContractVersion) public{
        currentContractVersion = _initialContractVersion;
        globalIdentityContractList.push(_initialContractVersion);

    }

    /**
     * @dev Get the address of the current identity contract
    */

    function getCurrentIdentityContract() public view returns(address){
        return currentContractVersion;
    }

    /**
    * @dev Upgrade the newly deployed contract
    * @param upgradedContract: address of the new contract
    */
    function upgradeIdentityContract(address upgradedContract) public{
        globalIdentityContractList.push(upgradedContract);
        currentContractVersion = upgradedContract;
    }


    /**
     * @dev Get the addresses of all the deployed contracts
    */

    function getAllIdentityContracts() public view returns(address[] memory){
        return globalIdentityContractList;
    }

}
