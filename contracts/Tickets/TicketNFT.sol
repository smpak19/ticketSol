// SPDX-License-Identifier: MIT

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TicketNFT is ERC721URIStorage, Ownable {
    string public concertName;
    uint256 public concertDate;
    uint256 public ticketCount;
    uint256 public maxTicketCount;

    event ConcertFinished();

    constructor(string memory _concertName, uint256 _concertDate, uint256 _maxTicketCount) ERC721("TicketNFT", "TNFT") {
        concertName = _concertName;
        concertDate = _concertDate;
        ticketCount = 0;
        maxTicketCount = _maxTicketCount;
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        require(ticketCount < maxTicketCount, "Maximum ticket count reached");
        _safeMint(to, tokenId);
        ticketCount++;
    }

    function finishConcert() public onlyOwner {
        emit ConcertFinished();
    }
}
