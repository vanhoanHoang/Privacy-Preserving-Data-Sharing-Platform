pragma solidity >= 0.5.0 < 0.7.0;
pragma experimental ABIEncoderV2;

import "./ECSecp256k1.sol";

/**
 * @dev Implement the ring signature scheme described in https://eprint.iacr.org/2003/067.pdf
*/

contract ECRingSignature is ECSecp256k1 {


    /**
     * @dev the format of the signature is described in https://eprint.iacr.org/2003/067.pdf
    */
    struct JGSignature {
        string data;
        uint256 delta;
        ECSecp256k1.CurveElement[] RList;
        uint256[] hashList;
    }


    // List of public keys in the ring

    ECSecp256k1.CurveElement[] public pks;

    function setPublicKeyList(ECSecp256k1.CurveElement[] memory pkeys, uint256 listSize) public {
        for(uint256 i = 0; i < listSize; i++){
            pks.push(pkeys[i]);
        }
    }


    /**
     * @dev Implementing the signing Operation
     * @param ringSize: the size of the ringSign
     * @param data: the signed data
     * @param sk: the private key of signer
     * @param indexS: the index of the signer in the ring
     * @return (signature)
    */

    function ringSign(uint256 ringSize, string memory data, uint256 sk, uint256 indexS ) public view returns(JGSignature memory) {

        ECSecp256k1.CurveElement[] memory RList = new ECSecp256k1.CurveElement[](ringSize);
        uint256[] memory hashList = new uint256[](ringSize);
        uint256 delta = 0;


        ECSecp256k1.CurveElement memory G;
        G = ECSecp256k1.CurveElement(ECSecp256k1.GX, ECSecp256k1.GY);

        uint256 a;
        uint256 hi;

        ECSecp256k1.CurveElement memory Ri;
        ECSecp256k1.CurveElement memory Rs;

        ECSecp256k1.CurveElement memory hiPK;

        Rs = ECSecp256k1.CurveElement(0,0);

        for(uint256 i = 0; i < ringSize; i++){
            if(i != indexS){
                // Generate a random value a

                a =  uint256(keccak256(abi.encodePacked( block.difficulty, i)));

                Ri = ECSecp256k1.ecMul(a, G);
                RList[i]   = Ri;

                hi = uint256(keccak256(abi.encodePacked(data, Ri.X, Ri.Y)));
                hiPK = ECSecp256k1.ecMul(-hi, pks[i]);
                Rs = ECSecp256k1.ecAdd(Rs, hiPK);

                hashList[i] = hi;
                delta +=  a + sk* hi;

            }
        }

        // Generate a random number a
        a = uint256(keccak256(abi.encodePacked(block.difficulty, indexS)));

        delta += a;
        delta = delta % ECSecp256k1.PP;

        ECSecp256k1.CurveElement memory Ga = ECSecp256k1.ecMul(a, G);
        Rs = ECSecp256k1.ecAdd(Rs, Ga);

        RList[indexS] = Rs;
        hashList[indexS] = uint256(keccak256(abi.encodePacked(data, Rs.X, Rs.Y)));

        return JGSignature(data, delta, RList, hashList);
    }

    /**
     * @dev Verify the validity of a ring signature
     * @param sig: the signature
     * @param ringSize: the size of the ringVerify
    */


    function ringVerify(JGSignature memory sig, uint256 ringSize) public  returns(bool){
        ECSecp256k1.CurveElement memory G;
        G = ECSecp256k1.CurveElement(ECSecp256k1.GX, ECSecp256k1.GY);

        uint256 hi;
        for(uint256 i = 0; i < ringSize; i++){
            hi = uint256(keccak256(abi.encodePacked(sig.data, sig.RList[i].X, sig.RList[i].Y)));
            if(hi != sig.hashList[i]){
                return false;
            }
        }


        ECSecp256k1.CurveElement memory firstComparingElement;
        ECSecp256k1.CurveElement memory secondComparingElement;


        firstComparingElement = ECSecp256k1.ecMul(sig.delta, G);


        secondComparingElement = ECSecp256k1.CurveElement(0, 0);
        for(uint256 i = 0; i < ringSize; i++){
            secondComparingElement = ECSecp256k1.ecAdd(secondComparingElement, sig.RList[i]);
            secondComparingElement = ECSecp256k1.ecAdd(secondComparingElement, ECSecp256k1.ecMul(sig.hashList[i], pks[i]));
        }
        delete pks;

        if(ECSecp256k1.ecEqual(firstComparingElement, secondComparingElement)) return true;
        return false;

    }

}
