pragma solidity >= 0.5.0 < 0.7.0;
pragma experimental ABIEncoderV2;

import "./EllipticCurveLib.sol";


/**
 * @notice Implementing the curve ECSecp256k1 with functions defined in the EllipticCurveLib
*/
contract ECSecp256k1 {

  /**
   * Recommended parameters of the curve can be found in https://www.secg.org/sec2-v2.pdf
  */

  uint256 constant GX = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
  uint256 constant GY = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
  uint256 constant AA = 0;
  uint256 constant BB = 7;
  uint256 constant PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

  /**
   *  @dev Struct describes an element structure on the Curve
  */

  struct CurveElement {
      uint256 X;
      uint256 Y;
  }


  /**
    * @dev Public Key derivation from private key
    * @param privKey The private key
    * @return (CurveElement) The Public Key
  */

  function derivePubKey(uint256 privKey) public pure returns(CurveElement memory) {
    (uint256 qx, uint256 qy) = EllipticCurveLib.ecMul(privKey, GX, GY, AA, PP);
    return CurveElement(qx, qy);
  }


  /**
   * @dev Verify whether an element lies on the curve
   * @param e: the element to be verified
   * @return bool
  */

  function isOnCurve(CurveElement memory e) internal pure returns(bool){
      return EllipticCurveLib.isOnCurve(e.X, e.Y, AA, BB, PP);
  }


  /**
   * @dev Finding the inverse of a curve element
   * @param e: the element to be verified
  */

  function ecInv(CurveElement memory e) internal pure returns(CurveElement memory){
      (uint256 x, uint256 y) = EllipticCurveLib.ecInv(e.X, e.Y, PP);
      return CurveElement(x, y);
  }

  /**
   * @dev Add two curve elements
   * @param e1: the first element
   * @param e2: the second element
  */

  function ecAdd(CurveElement memory e1, CurveElement memory e2) public pure returns(CurveElement memory){
      (uint256 x, uint256 y) = EllipticCurveLib.ecAdd(e1.X, e1.Y, e2.X, e2.Y, AA, PP);
      return CurveElement(x, y);
  }


  /**
   * @dev Subtract a curve element by another element
  */

  function ecSub(CurveElement memory e1, CurveElement memory e2) public pure returns (CurveElement memory){
      (uint256 x, uint256 y) = EllipticCurveLib.ecSub(e1.X, e1.Y, e2.X, e2.Y, AA, PP);
      return CurveElement(x, y);
  }


  /**
   * @dev Multiply an element on the curve with an interger
   * @param k: the interger
   * @param e: the curve element
   * @return Return the value
  */

  function ecMul(uint256 k, CurveElement memory e) public pure returns(CurveElement memory){
      (uint256 x, uint256 y) = EllipticCurveLib.ecMul(k, e.X, e.Y, AA, PP);
      return CurveElement(x, y);
  }


  /**
   * @dev Compairing two elements onn the Curve
   * @param e1: the first element
   * @param e2: the second element
  */

  function ecEqual(CurveElement memory e1, CurveElement memory e2) public pure returns(bool){
      if((e1.X==e2.X) &&(e1.Y == e2.Y)) return true;
      return false;
  }


  /**
   * Generate a random curve element based on a given input
   * @param seed: input
   * @return randomBumber
  */


  function randomElement(uint256 seed) public view returns(CurveElement memory) {
      uint256 seedHash = uint256(keccak256(abi.encodePacked(seed, block.difficulty)));
      return derivePubKey(seedHash % PP);
  }



}
