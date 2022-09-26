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

2. Information about the BoE including:
    a. Amount
    b. Payment date
    c. Jurisdiction

3. A URI to the natural language version of the BoE stored on IPFS