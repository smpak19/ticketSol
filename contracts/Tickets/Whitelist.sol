// SPDX-License-Identifier: MIT

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Whitelist is Ownable {
    mapping(address => bool) public isAuthorized;

    event AddressAuthorized(address indexed account);
    event AddressRevoked(address indexed account);

    function authorizeAddress(address account) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(!isAuthorized[account], "Address already authorized");

        isAuthorized[account] = true;
        emit AddressAuthorized(account);
    }

    function revokeAddress(address account) external onlyOwner {
        require(isAuthorized[account], "Address not authorized");

        isAuthorized[account] = false;
        emit AddressRevoked(account);
    }
}
