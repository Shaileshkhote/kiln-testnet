// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DeflationaryTokenContract is ERC20 {

    using SafeMath for uint256;

    address public minter;
    // Burn Address to send Transfer Fee
    address public burnAddress;
    uint256 public supply;
    // Transfer Fee Upto 10%
    uint8 public transferFee;
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _supply,
        address _minter,
        uint8 _transferFee

    ) ERC20(_name, _symbol) {
        require(_transferFee<=100,"Invalid Transfer Fee");
        supply=_supply;
        minter=_minter;
        transferFee=_transferFee;
        burnAddress = 0x000000000000000000000000000000000000dEaD;

    }

        function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        uint256 burnAmount = (amount.mul(transferFee)).div(1000);
        uint256 newAmount = amount.sub(burnAmount);
        _transfer(from, burnAddress, burnAmount);
        _transfer(from, to, newAmount);
        return true;
    }

        function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        uint256 burnAmount = (amount.mul(transferFee)).div(1000);
        uint256 newAmount = amount.sub(burnAmount);
        _transfer(owner,burnAddress,burnAmount);
        _transfer(owner, to, newAmount);
        return true;
    }

    function mintTokens(uint256 _amount) external onlyMinter() checkSupply(_amount) {
        _mint(msg.sender, _amount);
    }

        modifier onlyMinter() {
        require(msg.sender == minter, "Not Minter");
        
        _;
    }

            modifier checkSupply(uint256 _amount) {
        require(totalSupply().add(_amount) <= supply, "Supply Overflow");
        
        _;
    }

    function setMinter(address _minter) external onlyMinter() {
        minter=_minter;
    }

     function setTransferFee(uint8 _transferFee) external onlyMinter() {
        require(_transferFee<=100,"Invalid Transfer Fee Should be Between 0-100");
        transferFee=_transferFee;
    }


}