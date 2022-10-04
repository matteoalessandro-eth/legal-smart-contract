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

 import "./DateTime.sol";

 contract documentVerification {

    string public ipfsLink;
    address public docOwner;
    string public docOwnerName;
    address public verifier;
    string public verifierName;
    string public dateOfVerification;
    bool public documentVerified = false;
    string public textDate;


    constructor(string memory _ipfsLink, string memory _docOwnerName, address _verifier, string memory _verifierName){
        docOwner = msg.sender;
        docOwnerName = _docOwnerName;
        ipfsLink = _ipfsLink;
        verifier = _verifier;
        verifierName = _verifierName;
    }

    function verifyDocument(string memory _dateOfVerification) public onlyVerifier {
        documentVerified = true;
        dateOfVerification = _dateOfVerification;
    }

    function getVerification() public view documentHasBeenVerified returns (string memory) {
        bytes memory verification = abi.encodePacked(
            "I, ", verifierName, " confirm that the following document: ",
            ipfsLink, " is a certified true copy of the original.",
            dateOfVerification);

        return string(verification);
    }


    modifier documentHasBeenVerified() {
        require(documentVerified == true, "Document needs to be verified before this can be called");
        _;
    }

    modifier onlyVerifier() {
        require(msg.sender == verifier, "Only the verifier can verify the document");
        _;
    }
 
 }