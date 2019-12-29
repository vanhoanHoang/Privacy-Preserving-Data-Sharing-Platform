
# Summary

An implemmentation of the privacy-preserving data sharing platform for decentralized storages. 
The features of the platform can be summarized as following:
1. Allowing data owner to anonymously share data with other users in the system without anyone being able to identify users involved in the sharing.
2. Data is protected end-to-end using revocation predicate encrytion.  
3. Providing data censorship-resistance due to 1 and 2.
4. Providing auditable fine-grained access control without reliance on third party. 
 

# Notes on the implementation and the smartcontract interaction
1. The [ring signature scheme]([https://eprint.iacr.org/2003/067.pdf](https://eprint.iacr.org/2003/067.pdf)) is implemented on the elliptic curve *ECSecp256k1*  with the domain parameters recommended in [here](https://www.secg.org/SEC2-Ver-1.0.pdf). The [Projective](https://en.wikibooks.org/wiki/Cryptography/Prime_Curve/Standard_Projective_Coordinates) and [Jacobian](https://en.wikibooks.org/wiki/Cryptography/Prime_Curve/Jacobian_Coordinates) Coordinates are used to speed up computations on the curve. 
2. To interact with the deployed contract, one can use CLI and Truffle support. In addition, we can also deploy all the contracts on [Remix](https://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.5.12+commit.7709ece9.js), a web-based solidity IDE, which provides a more user-friendly interface to interact with them easily.  In such case, please do follow the truffle-based migration files in the migration folder to deploy the contracts correctly. 