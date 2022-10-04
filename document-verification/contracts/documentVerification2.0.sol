//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
*
*   @title Document Verification Smart Contract
*   @dev Simple solution to verify documents on the Ethereum blockchain
*
*   NOTE: This is purely a proof of concept, it is not to be used in real-life transactions as it has not been tested properly.
*
 */

 contract documentVerification {

    string docOwnerName;
    address verifier;
    string verifierName;
    string dateOfVerification;
    bool documentVerified = false;
    string textDate;
    string ipfsHash;

    mapping (string => string) verifiedDocuments;


    constructor(string memory _docOwnerName, address _verifier, string memory _verifierName, string memory _ipfsHash){
        docOwnerName = _docOwnerName;
        verifier = _verifier;
        verifierName = _verifierName;
        ipfsHash = _ipfsHash;
    }

    function verifyDocument(string memory _dateOfVerification) public onlyVerifier {
        dateOfVerification = _dateOfVerification;
        bytes memory verification = abi.encodePacked(
            "I, ", verifierName, ", confirm that the following document: ",
            ipfsHash, " is a certified true copy of the original. ",
            dateOfVerification,
            "|| Document Owner: ", docOwnerName);
        verifiedDocuments[ipfsHash] = string(verification);
    }

    function getVerification(string memory _hashToVerify) public view returns (string memory){
        if (bytes(verifiedDocuments[_hashToVerify]).length == 0) {
            revert("Document not verified.");
        }
        
        return verifiedDocuments[_hashToVerify];
    }

    modifier onlyVerifier() {
        require(msg.sender == verifier, "Only the verifier can verify the document");
        _;
    }
 
 }