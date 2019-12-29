pragma solidity >= 0.5.0 < 0.7.0;
pragma experimental ABIEncoderV2;

import "./ECRingSignature.sol";

contract DataSharingContract {

    address public owner;
    bytes32 public dataHash;
    address private ecRingSignatureContractAddress;

    /**
     * @dev Store all the data consumers by their hidden addresses
    */
    mapping(address => bool) public hiddenAddressControlList;

    event addNewDataCustomerEvent(address);
    event removeDataCustomerEvent(address);

    constructor(address _ecRingSignatureContractAddress) public {
        owner = msg.sender;
        ecRingSignatureContractAddress = _ecRingSignatureContractAddress;
    }


    /**
     * @dev Register the hash of data into the contract
     * @param _dataHash: The hash of data
    */

    function setDataHash(bytes32 _dataHash) public {
        dataHash = _dataHash;
    }

    /**
     * @dev Add a new data consumer
     * @param newCustomer: the hidden address of the new user
    */

    function addNewDataCustomer(address newCustomer) public {
        require(msg.sender== owner, "Only owner can add new revocation members");
        hiddenAddressControlList[newCustomer] = true;

        emit addNewDataCustomerEvent(newCustomer);

    }

    /**
     * @dev Remove the hidden address of a consumer
     * @param customer: the address of the consumer
    */


    function removeDataCustomer(address customer) public {
        require(msg.sender== owner, "Only owner can delete revocation members");
        delete hiddenAddressControlList[customer];

        emit removeDataCustomerEvent(customer);
    }


    /**
     * @dev Verify the signature provided by a data consumer
     * @param sig: the signature
     * @param pks: the list of the ring's public keys
     * @param ringSize: the size of the ring
    */


    function verifyUserEligibility(ECRingSignature.JGSignature memory sig, ECSecp256k1.CurveElement[] memory pks, uint256 ringSize) public returns(bool){
        ECRingSignature ecRingSignature = ECRingSignature(ecRingSignatureContractAddress);
        ecRingSignature.setPublicKeyList(pks, ringSize);

        return ecRingSignature.ringVerify(sig, ringSize);
    }
}
