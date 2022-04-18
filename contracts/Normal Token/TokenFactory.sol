// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenContract.sol";


contract TokenFactory {
    mapping(address => string) public tokenName;
    address[] public tokensCreated;
    address public owner;
    uint256 public payableFees = 0.1 ether;

    event TokenCreated(address TokenAddress);
    event SetPayableFees(uint256 payableAmt);
    event SetOwner(address _owner);
    event WithdrawBnb(address sendTo, uint256 Amt);

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");

        _;
    }

    modifier payableAmt() {
        require(msg.value == payableFees, "Invalid Amount");

        _;
    }

    function createToken(
        string memory _name,
        string memory _symbol,
        uint256 _supply,
        address _minter
    ) external payable payableAmt() {
        
        _deployToken(_name, _symbol, _supply, _minter);
    }

    function withdrawBnb(address payable _sendTo) external onlyOwner {
        emit WithdrawBnb(_sendTo, address(this).balance);
        _sendTo.transfer(address(this).balance);
    }

    function setPayableFees(uint256 _payableFees) external onlyOwner {
        payableFees = _payableFees;
        emit SetPayableFees(_payableFees);
    }

    function setOwner(address _owner) external onlyOwner {
        owner = _owner;
        emit SetOwner(_owner);
    }

    function _deployToken(
        string memory _name,
        string memory _symbol,
        uint256 _supply,
        address _minter
    ) internal {
        TokenContract token = new TokenContract(
            _name,
            _symbol,
            _supply,
            _minter
        );
        tokenName[address(token)] = _name;
        tokensCreated.push(address(token));
        emit TokenCreated(address(token));
    }
}
