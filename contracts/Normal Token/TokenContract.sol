// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenContract is ERC20 {

    using SafeMath for uint256;

    address public minter;
    uint256 public supply;
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _supply,
        address _minter
    ) ERC20(_name, _symbol) {
        supply=_supply;
        minter=_minter;

    }

            modifier onlyMinter() {
        require(msg.sender == minter, "Not Minter");
        
        _;
    }

        modifier checkSupply(uint256 _amount) {
        require(totalSupply().add(_amount) <= supply, "Supply Overflow");
        
        _;
    }

    function mintTokens(uint256 _amount) external onlyMinter() checkSupply(_amount) {
        _mint(msg.sender, _amount);
    }



    function setMinter(address _minter) external onlyMinter() {
        minter=_minter;
    }


}