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


contract BillOfExchange {

    using SafeMath for uint256;

    bool private billPaid = false;
    bool private paymentAccepted;


    //below will probably be included in a separate mint contract
    struct billInfo {
        address payable promisee;
        string promiseeName;
        address promisor;
        string promisorName;
        uint billAmount;
        string billDescription;
        uint dateOfEntry;
        string dateOfExpiry;
        bool promiseeConsent;
        uint dateOfPromiseeConsent;
        bool promisorConsent;
        uint dateOfPromisorConsent;
        string naturalLanguage;
    }

    billInfo private bill;

    // initial constructor setting party info
    constructor(address _promisor, string memory _promiseeName, string memory _promisorName) public {
        bill.promisee = payable(msg.sender);
        bill.promisor = _promisor;
        bill.promiseeName = _promiseeName;
        bill.promisorName = _promisorName;
    }

    // sets bill details

    function setDetails (uint _billAmount, string memory _billDescription, string memory _dateOfExpiry, string memory _naturalLanguage) public promiseeOnly {
        bill.billAmount = _billAmount;
        bill.billDescription = _billDescription;
        bill.dateOfExpiry = _dateOfExpiry;
        bill.naturalLanguage = _naturalLanguage;
    }

    // determines party consent and date of consent

    function setPromiseeConsent() public promiseeOnly {
        bill.promiseeConsent = true;
        bill.dateOfPromiseeConsent = block.timestamp;
        if (bill.promisorConsent == true) {
            setDateOfEntry();
        }
    }

    // if both consented, the date of entry is calculated. This will later lead to the NFT being minted.
    function setPromisorConsent() public promisorOnly {
        bill.promisorConsent = true;
        bill.dateOfPromisorConsent = block.timestamp;
        if (bill.promiseeConsent == true) {
            setDateOfEntry();
        }
    }

    // set date of entry

    function setDateOfEntry() internal {
        bill.dateOfEntry = block.timestamp;
    }

    // function to submit payment

    function payBill () public payable needConsent promisorOnly {
        require(msg.value == bill.billAmount, "You must pay the amount stipulated");
        billPaid = true;
    }

    // function for promisee to accept payment, leading to contract being killed (still needs to have function which burns token when this is done)

    function acceptPayment () public promiseeOnly billHasBeenPaid {
        paymentAccepted = true;
        bill.promisee.transfer(bill.billAmount);
        kill();
    }

    // function to kill smart contract once it has been concluded

    function kill() promiseeOnly public {
        selfdestruct(bill.promisee);
    }


    // function to get bill data
    // function getInfo() public returns(address, string calldata, address, string calldata, uint, string calldata, uint, string calldata, bool, uint, bool, uint, string calldata) {
    //     return(bill.promisee, bill.promiseeName, bill.promisor, bill.promisorName, bill.billAmount, bill.billDescription, bill.dateOfEntry, bill.dateOfExpiry, bill.promiseeConsent, bill.dateOfPromiseeConsent, bill.promisorConsent, bill.dateOfPromiseeConsent, bill.naturalLanguage);
    // }

    function getInfo() public view returns(billInfo memory){
        return bill;
    }



    /**
    *   Below functions still to be implemented. 
    *   1. function to mint bill
    *   2. acceptance leading to token burn
    *   3. function to burn token
    */

    // modifiers

    modifier promisorOnly(){
        require(msg.sender == bill.promisor, "only the promisor can send this message");
        _;
    }

    modifier promiseeOnly(){
        require(msg.sender == bill.promisee, "only the promisee can send this message");
        _;
    }

    modifier partiesOnly(){
        require(msg.sender == bill.promisor || msg.sender == bill.promisee, "only parties to this agreement can send this message");
        _;
    }

    modifier needConsent(){
        require(bill.promiseeConsent == true && bill.promisorConsent == true);
        _;
    }

    modifier billHasBeenPaid(){
        require(billPaid == true, "Payment must be made before withdrawing funds");
        _;
    }

}
