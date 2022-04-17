// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenContract.sol";


contract TokenFactory {

    event TokenCreated(
        address TokenAddress
    );

    mapping(address=>string) public tokenName;
    address[] public tokensCreated;
    address public owner;

    constructor(address _owner) {
        owner=_owner;
    }

     modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        
        _;
    }
    function createToken(string memory _name, string memory _symbol,uint256 _supply, address _minter) payable external{
        require(msg.value == 0.1 ether , "Invalid Amount");
        deployToken( _name,_symbol, _supply,_minter);

    }

    function withdrawBnb(address payable _sendTo) public onlyOwner(){
        _sendTo.transfer(address(this).balance);

    }

    function deployToken(string memory _name, string memory _symbol,uint256 _supply, address _minter)
        internal
    {
        TokenContract token = new TokenContract(_name, _symbol, _supply, _minter);
        tokenName[address(token)]=_name;
        tokensCreated.push(address(token));
        emit TokenCreated(address(token));
    }
}
