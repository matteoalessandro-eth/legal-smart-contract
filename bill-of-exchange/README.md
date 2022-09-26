### Smart Contracts used for Bills of Exchange

The first implementation which will be considered is the use of smart contracts to create bills of exchange ("BoE"). These will be analysed in the local (Maltese) context, and then a basic implementation of them is proposed. 

#### Assumptions
1. That tokens are construed as 'containers' which can hold rights, as was implemented by the Liechtenstein TVTG Act and as proposed by myself in a forthcoming paper.

2. That methods for identity verification are available, and accepted legally.

#### Proposed Method
1. Two parties who come to an agreement deploy and sign a smart contract which issues an NFT (or as many as necessary) to represent the obligations. The NFT is sent to the party who is due to receive the amount.

2. The party promising to pay the amount can also choose to have the payments made automatically.

3. The NFT is burnt once payment has been accepted by the receiver, thus terminating the obligation.


#### NFT Data Needed
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
4. When both parties have agreed, the smart contract issues an NFT, with linked metadata containing all the info, which is sent to the Promisee.
5. The Promisor will then pay the amount due into the smart contract through a function, with the smart contract holding the amount until it is accepted by the Promisee
6. Once the Promisee has accepted the payment, the funds are transferred to their address, and the token is burnt

#### To Do

1. Develop NFT mint function
2. Look into deployment using scripts
3. Finalise functions