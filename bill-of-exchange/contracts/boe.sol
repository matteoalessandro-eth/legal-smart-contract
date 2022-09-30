// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
*
*   @title Bills of Exchange Smart Contract
*   @dev Implement bills of exchange through a smart contrac
*   
*   NOTE: This is purely a proof of concept, it is not to be used in real-life transactions as it has not been tested properly.   
*
*   Made use of:
*   BillOfSale.sol by Michael Rice (https://github.com/mrice/solidity-legal-contracts)
*/


contract BillOfExchange {

    // variables
    bool public billPaid = false;
    bool public paymentAccepted = false;
    uint public dateOfAcceptance;


    // struct containing bill info
    struct billInfo {
        address payable holder;
        string holderName;
        address drawer;
        string drawerName;
        uint billAmount;
        string billDescription;
        uint dateOfEntry;
        string dateOfExpiry;
        bool holderConsent;
        uint dateOfHolderConsent;
        bool drawerConsent;
        uint dateOfDrawerConsent;
        string naturalLanguage;
    }

    // initialise struct which contains bill data
    billInfo private bill;

    // initial constructor setting party info and pushing it to struct
    constructor(string memory _holderName) {
        bill.holder = payable(msg.sender);
        bill.holderName = _holderName;
    }

    // function setting bill details and pushing them to struct
    function setDetails (string memory _drawerName, address _drawer, uint _billAmount, string memory _billDescription, string memory _dateOfExpiry, string memory _naturalLanguage) public holderOnly {
        require(_drawer!=bill.holder, "Drawer and Holder must be different parties");
        bill.drawer = _drawer;
        bill.drawerName = _drawerName;
        bill.billAmount = _billAmount;
        bill.billDescription = _billDescription;
        bill.dateOfExpiry = _dateOfExpiry;
        bill.naturalLanguage = _naturalLanguage;
    }

    // function setting party consent and date of consent, and pushes them to struct
    // if both consented, the date of entry is calculated. 
    function setHolderConsent() public holderOnly {
        bill.holderConsent = true;
        bill.dateOfHolderConsent = block.timestamp;
        if (bill.drawerConsent == true) {
            setDateOfEntry();
        }
    }

    function setDrawerConsent() public drawerOnly {
        bill.drawerConsent = true;
        bill.dateOfDrawerConsent = block.timestamp;
        if (bill.holderConsent == true) {
            setDateOfEntry();
        }
    }

    // set date of entry

    function setDateOfEntry() internal {
        bill.dateOfEntry = block.timestamp;
    }

    // function to submit payment

    function payBill () public payable needConsent drawerOnly {
        require(msg.value == bill.billAmount, "You must pay the amount stipulated");
        billPaid = true;
    }

    // function for holder to accept payment, leading to contract being killed (still needs to have function which burns token when this is done)

    function acceptPayment () public holderOnly billHasBeenPaid {
        paymentAccepted = true;
        dateOfAcceptance = block.timestamp;
        bill.holder.transfer(bill.billAmount);
        kill();
    }

    // function to kill smart contract once it has been concluded

    function kill() holderOnly public {
        selfdestruct(bill.holder);
    }

    // function to get struct info as tuple - can be improved through use of JSON file
    function getInfo() public view returns(billInfo memory){
        return bill;
    }

    // modifiers

    modifier drawerOnly(){
        require(msg.sender == bill.drawer, "only the drawer can send this message");
        _;
    }

    modifier holderOnly(){
        require(msg.sender == bill.holder, "only the holder can send this message");
        _;
    }

    modifier partiesOnly(){
        require(msg.sender == bill.drawer || msg.sender == bill.holder, "only parties to this agreement can send this message");
        _;
    }

    modifier needConsent(){
        require(bill.holderConsent == true && bill.drawerConsent == true);
        _;
    }

    modifier billHasBeenPaid(){
        require(billPaid == true, "Payment must be made before withdrawing funds");
        _;
    }

}
