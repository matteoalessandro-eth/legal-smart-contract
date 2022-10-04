// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract certifiedCopyNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721 ("Certified True Copy", "CTC"){
    }

    function getTokenURI(bytes memory _certification) private returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(_certification)
            )
        );
    }

    function mint(address docOwner, bytes memory _certification) public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(docOwner, newItemId);
        _setTokenURI(newItemId, getTokenURI(_certification));
    }
}