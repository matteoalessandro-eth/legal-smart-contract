### Smart Contracts used for Bills of Exchange

The first implementation which will be considered is the use of smart contracts to create bills of exchange ("BoE"). These will be analysed in the local (Maltese) context, and then a basic implementation of them is proposed. 

#### Assumptions
1. That methods for identity verification are available, and accepted legally.

#### Proposed Method
1. Two parties who come to an agreement deploy and sign a smart contract.

2. The party promising to pay the amount can also choose to have the payments made automatically.

3. The contract is killed once payment has been accepted.


#### Information Needed
1. Identification of both parties

2. Information about the BoE including: </br>
    a. Amount </br>
    b. Payment date </br>
    c. Jurisdiction </br>

3. A URI to the natural language version of the BoE stored on IPFS

#### System Architecture

1. A main smart contract is initiated by the Promisee (the person who is due the money)
2. This smart contract will contain the following information about the BoE: </br>
    a. Wallet addresses of both parties </br>
    b. Names of both parties </br>
    c. Amount of the BoE </br>
    d. Description of the BoE </br>
    e. The date of expiry of the BoE (when the payment is due) - this is converted to a Unix timestamp from a regular date
    f. The link to the natural language version of the BoE </br>
    g. The date of entry of the BoE - this is automatically calculated when consent has been given by both parties </br>
3. The consent is then acquired from both parties, with the date being recorded
4. The Promisor will then pay the amount due into the smart contract through a function, with the smart contract holding the amount until it is accepted by the Promisee
5. Once the Promisee has accepted the payment, the funds are transferred to their address, and the token is burnt

#### Improvements

1. Develop a function which mints an NFT which points to a JSON file of the bill data, and which is burnt upon acceptance of payment.

2. Develop a script and interface which can create a JSON file, and be used to interact with functions.

3. Split the contract into other sub-contracts in order to increase efficiency. Streamlining of processes is also ideal since the stack depth is often problematic.