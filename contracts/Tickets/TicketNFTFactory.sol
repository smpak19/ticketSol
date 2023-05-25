// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./TicketNFT.sol";

contract TicketNFTFactory is Ownable {
    using Address for address;

    TicketNFT[] public ticketNFTs;

    // Whitelist for creating TicketNFT contract
    mapping(address => bool) private _whiteList;

    constructor() {

    }

    struct TicketInfo {
        address ticketNFTAddress;
        address contractOwner;
        bool finish;
        string tokenURI;
    }

    function createTicketNFT(string memory _concertName, uint256 _maxTicketCount, uint256 _ticketPrice, string memory _tokenURI) public returns (address) {
        require(_whiteList[msg.sender], "You are not authorized ticket manager");
        // Ticket price = ticketPrice * 0.001 ETH
        TicketNFT newTicket = new TicketNFT(_concertName, _maxTicketCount, _ticketPrice, _tokenURI);
        ticketNFTs.push(newTicket);
        newTicket.transferOwnership(msg.sender);

        return address(newTicket);
    }

    // Showing all concert information
    function getConcertInfo() public view returns (TicketInfo[] memory) {
        uint256 totalConcerts = ticketNFTs.length;

        TicketInfo[] memory ticketInfo = new TicketInfo[](totalConcerts);

        for (uint256 i = 0; i < totalConcerts; i++) {
            TicketNFT ticketNFT = ticketNFTs[i];
            ticketInfo[i] = TicketInfo({
                ticketNFTAddress: address(ticketNFT),
                contractOwner: ticketNFT.owner(),
                finish: ticketNFT.finish(),
                tokenURI: ticketNFT.tokenURI()
            });
        }

        return ticketInfo;
    }

    // Whitelist methods
    function addWhiteList(address user) public onlyOwner returns (bool) {
        require(user != address(0), "Invalid address");
        require(!_whiteList[user], "Already authorized");
        _whiteList[user] = true;
        return true;
    }

    function removeWhiteList(address user) public onlyOwner returns (bool) {
        require(user != address(0), "Invalid address");
        require(_whiteList[user], "Not authorized");
        _whiteList[user] = false;
        return true;
    }

    function checkValidity(address user) public view returns (bool) {
        require(user != address(0), "Invalid address");
        return _whiteList[user];
    }
}