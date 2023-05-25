// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./TicketNFT.sol";

contract TicketNFTFactory is Ownable {
    using Address for address;

    TicketNFT[] public ticketNFTs;

    // Whitelist for creating TicketNFT contract
    mapping(address => bool) private _whiteList;

    
    event TicketNFTCreated(address indexed ticketNFTAddress, string concertName, uint256 concertDate, uint256 maxTicketCount, uint256 ticketPrice);

    constructor() {

    }

    function createTicketNFT(string memory _concertName, uint256 _concertDate, uint256 _maxTicketCount, uint256 _ticketPrice) public returns (address) {
        require(_whiteList[msg.sender], "You are not authorized ticket manager");
        // Ticket price = ticketPrice * 0.001 ETH
        TicketNFT newTicket = new TicketNFT(_concertName, _concertDate, _maxTicketCount, _ticketPrice);
        ticketNFTs.push(newTicket);

        emit TicketNFTCreated(address(newTicket), _concertName, _concertDate, _maxTicketCount, _ticketPrice);

        return address(newTicket);
    }

    // Showing all concert information
    function getConcertInfo() public view returns (
        address[] memory, address[] memory, string[] memory,
         uint256[] memory, uint256[] memory, uint256[] memory, bool[] memory) {
        uint256 totalConcerts = ticketNFTs.length;

        address[] memory ticketNFTAddresses = new address[](totalConcerts);
        address[] memory contractOwners = new address[](totalConcerts);
        string[] memory concertNames = new string[](totalConcerts);
        uint256[] memory concertDates = new uint256[](totalConcerts);
        uint256[] memory maxTicketCounts = new uint256[](totalConcerts);
        uint256[] memory ticketPrices = new uint256[](totalConcerts);
        bool[] memory finish = new bool[](totalConcerts);

        for (uint256 i = 0; i < totalConcerts; i++) {
            TicketNFT ticketNFT = ticketNFTs[i];
            ticketNFTAddresses[i] = address(ticketNFT);
            contractOwners[i] = ticketNFT.owner();
            concertNames[i] = ticketNFT.concertName();
            concertDates[i] = ticketNFT.concertDate();
            maxTicketCounts[i] = ticketNFT.maxTicketCount();
            ticketPrices[i] = ticketNFT.ticketPrice();
            finish[i] = ticketNFT.finish();
        }

        return (ticketNFTAddresses, contractOwners, concertNames,
                    concertDates, maxTicketCounts, ticketPrices, finish);
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

    // 사진 링크 추가?
}