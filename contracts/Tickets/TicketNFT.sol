// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TicketNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    mapping(address => bool) private _hasTicket;

    string public concertName;
    uint256 public concertDate;
    uint256 public maxTicketCount;
    uint256 public ticketPrice;
    bool public finish;

    event ConcertOver(string concertName, uint256 concertDate);
    event TicketSold(uint256 tokenId, address indexed buyer);

    constructor(string memory _concertName, uint256 _concertDate, uint256 _maxTicketCount, uint256 _ticketPrice) ERC721(_concertName, "MTK") {
        concertName = _concertName;
        concertDate = _concertDate;
        maxTicketCount = _maxTicketCount;
        ticketPrice = _ticketPrice * 1e15;
        finish = false;
    }

    function safeMint(address to) private {
        require(!finish, "Concert is over!");
        require(_tokenId.current() < maxTicketCount, "Maximum ticket count reached");
        // Limit one ticket per address
        require(!_hasTicket[to], "You already have a ticket for this concert");
        _tokenId.increment();
        _safeMint(to, _tokenId.current());

        _hasTicket[to] = true;
    }

    // User pay -> mint to user
    function sellTicket(address buyer) public payable {
        require(msg.value >= ticketPrice, "Invalid amount of Ether");
        safeMint(buyer);
        payable(owner()).transfer(msg.value);

        emit TicketSold(_tokenId.current(), address(buyer));
    }

    // Prevent user transfer NFT before concert finish
    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(finish, "You cannot trade ticket before concert over");
        super.transferFrom(from, to, tokenId);
    }

    // Set when concert over
    function concertOver() public onlyOwner {
        finish = true;
        emit ConcertOver(concertName, concertDate);
    }
    
    // Retrieve all NFT owner info
    function getUserInfo() public view returns (address[] memory) {
        uint256 mintedTokens = _tokenId.current();

        address[] memory owners = new address[](mintedTokens);

        for (uint256 i=1; i <= mintedTokens; i++) {
            owners[i-1] = ownerOf(i);
        }

        return owners;
    }
}
