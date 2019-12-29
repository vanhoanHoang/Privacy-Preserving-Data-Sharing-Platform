pragma solidity >=0.5.0 <0.7.0;


contract IdentityKeyContract{

    /**
     * @dev UserIdentity describes the identity of a user. In this simple struct, the identity is represented by a string. One can update this contract by introduce
     * more information into the struct then deploy the modified contract on the blockchain. The address of the new contract will be registred into the Proxycontract
     * for users to be aware of its existence.
    */

    struct UserIdentity{
        // Users are allowed to register raw identity data that could not be their real names.
        string identityData;
    }

    /**
     * @dev Store all the user addresses registrered in the system
     * @notice user address is computed as the first 20 bytes of the hash of the user's public key
    */
    mapping (address => UserIdentity) public registeredIdentityList;


    /**
     * @dev Registering a new user in the system
     * @param newIdentity: the address of the new user
    */

    function registerUserIdentity(string memory newIdentity) public {

        require(bytes(registeredIdentityList[msg.sender].identityData).length != 0, "The identity has already existed.");
        UserIdentity memory newUser = UserIdentity(newIdentity);
        registeredIdentityList[msg.sender] = newUser;
    }


    /**
     * @dev Remove a user from the registry
     * @param removedIdentity: the identity of the user
    */

    function removeUserIdentity(address removedIdentity) public {
        require(msg.sender == removedIdentity, "Only the owner can remove its owner identity");
        delete registeredIdentityList[msg.sender];
    }


    /**
     * @dev Get the identity of a user based on its address/public key
     * @param userIdentity: address of the user
    */

    function retrieveUserIdentity(address userIdentity) public view returns(string memory){
        require(bytes(registeredIdentityList[msg.sender].identityData).length !=0, "User does not exist.");
        return registeredIdentityList[userIdentity].identityData;
    }


}
