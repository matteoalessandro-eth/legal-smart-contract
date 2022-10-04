### Smart Contracts Used for Document Verification

The second implementation I will be considering is the use of smart contracts for document verification. A number of systems for this have already been proposed, so I will attempt to create a simple example of such, while analysing how it can be used in the local context.

#### Assumptions
1. That methods for identity verification are available, and accepted legally. 

#### Proposed Method
1. The party that needs the document verified uploads it to IPFS
2. The document is verified by a trusted individual, such as lawyers or notaries
3. The verification is attached to the document, allowingf the holder to use it and prove its authenticity without needing to re-verify it every time

#### Existing Systems Considered
1. [E-Certify by Nikhildsahu](https://github.com/nikhildsahu/E-Certify)
2. [Blockchain Certificate Veracity by Vinayakrit](https://github.com/vinayakrit/Blockchain-certicate-verify)
3. [Document Verification on Blockchain by Shivasai780](https://github.com/shivasai780/Document-verification-on-Blockchain)
4. [Certoshi by Thawalk](https://github.com/thawalk/Certoshi)
5. [Certificate Verification DApp by Kreloaded](https://github.com/kreloaded/certificate-verification-dapp)
6. [Ether Doc Cert by Datts68](https://github.com/datts68/ether-doc-cert)
7. [Academic Certificates on Blockchain by Tasinlshmam](https://github.com/TasinIshmam/blockchain-academic-certificates)
8. [Proof Of Existence by Qinfengling](https://github.com/proofofexistence/proofofexistence)
9. [Crypto Stamp by Rumkin](https://github.com/rumkin/crypto-stamp)
10. [DocChain by Abkafi001](https://github.com/abkafi001/DocChain)
11. [Ethereum Document Authentication by Harpreetvirkk](https://github.com/harpreetvirkk/Ethereum-Document-Authentication)

#### Notes on documentVerification.sol
The [first implementation](https://github.com/matteoalessandro-eth/legal-smart-contract/blob/main/document-verification/contracts/documentVerification.sol) of this concept is a very rudimentary one. 

[documentVerification2.0](https://github.com/matteoalessandro-eth/legal-smart-contract/blob/main/document-verification/contracts/documentVerification2.0.sol) uses a SHA-2 256 hash of the IPFS link for more security, and stores the verified documents using a mapping, in which the key is the IPFS hash and the value is the verification text.

I will now be working on creating a system in which an authorised person (a lawyer, notary public etc.) would have a contract through which clients can request verification, which is then issued by the authorised person. Possibly, a certificate of authenticity in the form of an NFT could be created, which is sent to the client.

