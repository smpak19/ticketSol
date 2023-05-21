// SPDX-License-Identifier: MIT

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./TicketNFT.sol";
import "./Whitelist.sol";

contract TicketSmartContractFactory is Ownable {
    using Address for address;

    TicketNFT[] public ticketNFTs;
    Whitelist public whitelistContract;

    event TicketNFTCreated(address indexed ticketNFTAddress, string concertName, uint256 concertDate);

    constructor(address _whitelistContractAddress) {
        whitelistContract = Whitelist(_whitelistContractAddress);
    }

    function createTicketNFT(string memory _concertName, uint256 _concertDate, uint256 _maxTicketCount) public onlyOwner returns (address) {
        require(whitelistContract.isAuthorized(msg.sender), "Not authorized concert director");

        TicketNFT newTicket = new TicketNFT(_concertName, _concertDate, _maxTicketCount);
        ticketNFTs.push(newTicket);
        emit TicketNFTCreated(address(newTicket), _concertName, _concertDate);

        return address(newTicket);
    }
}
