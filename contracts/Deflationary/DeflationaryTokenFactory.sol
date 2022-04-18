// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DeflationaryTokenContract.sol";


contract DeflationaryTokenFactory {

    event TokenCreated(
        address TokenAddress
    );

    mapping(address=>string) public tokenName;
    address[] public tokensCreated;
    address public owner;

    constructor(address _owner) {
        owner=_owner;
    }

    function newToken(string memory _name, string memory _symbol,uint256 _supply, address _minter, uint8 _transferFee)
        public
    {
        DeflationaryTokenContract token = new DeflationaryTokenContract(_name, _symbol, _supply, _minter,_transferFee);
        tokenName[address(token)]=_name;
        tokensCreated.push(address(token));
        emit TokenCreated(address(token));
    }
}
