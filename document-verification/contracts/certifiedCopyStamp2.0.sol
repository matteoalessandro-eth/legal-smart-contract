//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
*
*   @title Certified True Copy Stamp Smart Contract
*   @dev Solution which allows authorised persons to certify copies of documents for their clients.
*
*   NOTE: This is purely a proof of concept, it is not to be used in real-life transactions as it has not been tested properly.
*
*/

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./certifiedCopyNFT.sol";


contract certifiedCopyStamp is Ownable {

    
    string certifierDetails = 
        "Av. Matteo Alessandro "
        "LL.B.(Hons.), M.Adv.(Melit.) "
        "Advocate "
        "matteo@matteoalessandro.com ";

    string certificationText = 
        "I confirm that I have seen the original document, and that the hash above represents a certified true copy of the original.";

    string certifierAddress;

    string ipfsHash;

    string dateOfCertificationText;

    string dateOfCertificationUnix;

    mapping(string => bytes) certifiedDocuments;

    constructor(){
        certifierAddress = Strings.toHexString(uint160(msg.sender), 20);
    }

    function certifyDocument(string memory _ipfsHash, string memory _dateOfCertificationText) public onlyOwner {
        ipfsHash = _ipfsHash;
        dateOfCertificationText = _dateOfCertificationText;
        dateOfCertificationUnix = Strings.toString(block.timestamp);

        bytes memory certification = abi.encodePacked(
            ipfsHash, " ",
            certificationText, " ",
            certifierDetails, " ",
            "Certifier Wallet Address: ", certifierAddress, " ",
            "Date of Certification: ", dateOfCertificationText, " ",
            "Unix Date of Certification: ", dateOfCertificationUnix 
        );

        certifiedDocuments[ipfsHash] = certification;
    }

    function mintCertificate(address _docOwner, string memory _mintIpfsHash) public onlyOwner {
        bytes memory certificateData = certifiedDocuments[_mintIpfsHash];
        certifiedCopyNFT certificateNFT = new certifiedCopyNFT();
        certificateNFT.mint(_docOwner, certificateData);
    }

    function checkCertification(string memory _hashToCheck) public view returns (string memory){
        if(certifiedDocuments[_hashToCheck].length == 0) {
            revert("Document has not been certified.");
        }

        else {
            return string(certifiedDocuments[_hashToCheck]);
        }
    }
}