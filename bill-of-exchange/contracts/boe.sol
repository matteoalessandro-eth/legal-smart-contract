// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
*
*   @title Bills of Exchange Smart Contract
*   @dev Implement bills of exchange through a smart contract which issues a token representative of the right
*   
*   NOTE: This is purely a proof of concept, it is not to be used in real-life transactions as it has not been tested properly.   
*
*   Made use of:
*   BillOfSale.sol by Michael Rice (https://github.com/mrice/solidity-legal-contracts)
*   DateUtils by Skeleton Codeworks (http://github.com/SkeletonCodeworks/DateUtils)
*/

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Date.sol";


contract BillOfExchange is Ownable {

    using SafeMath for uint256;

    address payable public promisee;
    address public promisor;
    string public promiseeName;
    string public promisorName;
    uint public billAmount;
    string public billDescription;
    bool public promiseeConsent = false;
    bool public promisorConsent = false;
    bool public billPaid = false;
    uint public dateOfEntry;
    uint public dateOfExpiry;
    string public naturalLanguage;
    bool public paymentAccepted;
    uint public dateOfPromisorConsent;
    uint public dateOfPromiseeConsent;

    //below will probably be included in a separate mint contract
    struct billInfo {
        address promisee;
        address promisor;
        string promiseeName;
        string promisorName;
        uint billAmount;
        string billDescription;
        uint dateOfEntry;
        uint dateOfExpiry;
        bool promiseeConsent;
        bool promisorConsent;
        string naturalLanguage;
    }

    // initial constructor setting basic information needed
    constructor(address _promisee, address _promisor, string memory _promiseeName, string memory _promisorName) public {
        promisee = _promisee;
        promisor = _promisor;
        promiseeName = _promiseeName;
        promisorName = _promisorName;
        owner = promisee;
    }

    // sets the amount for the BoE
    function setBillAmount(uint _billAmount) public promiseeOnly {
        billAmount = _billAmount;
    }

    // sets the billDescription;
    function setBillDescription(string memory _billDescription) public promiseeOnly {
        billDescription = _billDescription;
    }

    // declares URL for IPFS natural language contract

    function setNaturalLanguage (string memory _naturalLanguage) public promiseeOnly {
        naturalLanguage = _naturalLanguage;
    }

    // determines party consent and date of consent

    function setPromiseeConsent() public promiseeOnly {
        promiseeConsent = true;
        dateOfPromiseeConsent = block.timestamp;
        if (promisorConsent) {
            setDateOfEntry();
        }
    }

    // if both consented, the date of entry is calculated. This will later lead to the NFT being minted.
    function setPromisorConsent() public promisorOnly {
        promisorConsent = true;
        dateOfPromisorConsent = block.timestamp;
        if (promiseeConsent) {
            setDateOfEntry();
        }
    }

    // sets date of expiry

    function setDateOfExpiry(string memory _dateOfExpiry){
        dateOfExpiry = Date.setDateFromString(_dateOfExpiry);
    }

    // set date of entry

    function setDateOfEntry() internal {
        dateOfEntry = block.timestamp;
    }

    // function to submit payment

    function payBill () public payable needConsent promisorOnly {
        require(msg.value == billAmount, "You must pay the amount stipulated");
        billPaid = true;
    }

    // function for promisee to accept payment, leading to contract being killed (still needs to have function which burns token when this is done)

    function acceptPayment () public promiseeOnly billHasBeenPaid {
        paymentAccepted = true;
        promisee.transfer(billAmount);
        kill();
    }

    // function to kill smart contract once it has been concluded

    function kill() promiseeOnly public {
        selfdestruct(promisee);
    }

    /**
    *   Below functions still to be implemented. 
    *   1. function to mint bill
    *   2. acceptance leading to token burn
    *   3. function to burn token
    */

    // modifiers

    modifier promisorOnly(){
        require(msg.sender == promisor, "only the promisor can send this message");
        _;
    }

    modifier promiseeOnly(){
        require(msg.sender == promisee, "only the promisee can send this message");
        _;
    }

    modifier partiesOnly(){
        require(msg.sender == promisor || msg.sender == promisee, "only parties to this agreement can send this message");
        _;
    }

    modifier needConsent(){
        require(promiseeConsent == true && promisorConsent == true);
        _;
    }

    modifier billHasBeenPaid(){
        require(billPaid == true, "Payment must be made before withdrawing funds");
        _;
    }

}