// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
*
*   @title Promissory Notes Smart Contract
*   @dev Implement promissory notes through a smart contrac
*   
*   NOTE: This is purely a proof of concept, it is not to be used in real-life transactions as it has not been tested properly.   
*
*   Made use of:
*   BillOfSale.sol by Michael Rice (https://github.com/mrice/solidity-legal-contracts)
*/


contract PromissoryNote {

    // variables
    bool public notePaid = false;
    bool public paymentAccepted = false;
    uint public dateOfAcceptance;


    // struct containing note info
    struct noteInfo {
        address payable holder;
        string holderName;
        address drawer;
        string drawerName;
        uint noteAmount;
        string noteDescription;
        uint dateOfEntry;
        string dateOfExpiry;
        bool holderConsent;
        uint dateOfHolderConsent;
        bool drawerConsent;
        uint dateOfDrawerConsent;
        string naturalLanguage;
    }

    // initialise struct which contains note data
    noteInfo private note;

    // initial constructor setting party info and pushing it to struct
    constructor(string memory _holderName) {
        note.holder = payable(msg.sender);
        note.holderName = _holderName;
    }

    // function setting note details and pushing them to struct
    function setDetails (string memory _drawerName, address _drawer, uint _noteAmount, string memory _noteDescription, string memory _dateOfExpiry, string memory _naturalLanguage) public holderOnly {
        require(_drawer!=note.holder, "Drawer and Holder must be different parties");
        note.drawer = _drawer;
        note.drawerName = _drawerName;
        note.noteAmount = _noteAmount;
        note.noteDescription = _noteDescription;
        note.dateOfExpiry = _dateOfExpiry;
        note.naturalLanguage = _naturalLanguage;
    }

    // function setting party consent and date of consent, and pushes them to struct
    // if both consented, the date of entry is calculated. 
    function setHolderConsent() public holderOnly {
        note.holderConsent = true;
        note.dateOfHolderConsent = block.timestamp;
        if (note.drawerConsent == true) {
            setDateOfEntry();
        }
    }

    function setDrawerConsent() public drawerOnly {
        note.drawerConsent = true;
        note.dateOfDrawerConsent = block.timestamp;
        if (note.holderConsent == true) {
            setDateOfEntry();
        }
    }

    // set date of entry

    function setDateOfEntry() internal {
        note.dateOfEntry = block.timestamp;
    }

    // function to submit payment

    function payNote () public payable needConsent drawerOnly {
        require(msg.value == note.noteAmount, "You must pay the amount stipulated");
        notePaid = true;
    }

    // function for holder to accept payment, leading to contract being killed (still needs to have function which burns token when this is done)

    function acceptPayment () public holderOnly noteHasBeenPaid {
        paymentAccepted = true;
        dateOfAcceptance = block.timestamp;
        note.holder.transfer(note.noteAmount);
        kill();
    }

    // function to kill smart contract once it has been concluded

    function kill() holderOnly public {
        selfdestruct(note.holder);
    }

    // function to get struct info as tuple - can be improved through use of JSON file
    function getInfo() public view returns(noteInfo memory){
        return note;
    }

    // modifiers

    modifier drawerOnly(){
        require(msg.sender == note.drawer, "only the drawer can send this message");
        _;
    }

    modifier holderOnly(){
        require(msg.sender == note.holder, "only the holder can send this message");
        _;
    }

    modifier partiesOnly(){
        require(msg.sender == note.drawer || msg.sender == note.holder, "only parties to this agreement can send this message");
        _;
    }

    modifier needConsent(){
        require(note.holderConsent == true && note.drawerConsent == true);
        _;
    }

    modifier noteHasBeenPaid(){
        require(notePaid == true, "Payment must be made before withdrawing funds");
        _;
    }

}
