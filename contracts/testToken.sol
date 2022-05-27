// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

//Contract Created By Shailesh For Shardeum Testnet 

contract GenesisToken is ERC20 {

    using SafeMath for uint256;
    uint256 public supply = 1000 ether;
    
    struct MintInfo{
    uint256 mintedAmount;
    }

    mapping(address => MintInfo) public mintInfo;

    event Mint(address _recipent, uint256 _amount);
    event SetMinter(address _minter);

    constructor(
        

    ) ERC20("GENESIS COMMUNITY", "GCSHM") {

    }

        modifier checkSupply(uint256 _amount) {
        require(totalSupply().add(_amount) <= supply, "Supply Overflow");
        
        _;
    }

            modifier checkMinted(address _minter, uint256 _amount) {
            require(_amount<=100 * 1e18,"Specified Amount Greater Than 100 ether");
            require(mintInfo[_minter].mintedAmount+_amount<=100 * 1e18, "Minting Over Indiviual Cap");
        
        _;
    }

    function mintTokens(uint256 _amount) external checkMinted(msg.sender,_amount) checkSupply(_amount) {
        MintInfo storage mint = mintInfo[msg.sender];
        mint.mintedAmount += _amount;
        _mint(msg.sender, _amount);

        emit Mint(msg.sender, _amount);
    }



}