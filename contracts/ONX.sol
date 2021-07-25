// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

contract ONX is ERC20, Ownable{
    uint256 InitialSupply = 1e24;
    uint256 public deployedTimeStamp;
    uint _totalSupply;
    struct Supply{
        string phase;
        uint256 supply;
        uint256 durationleft;
        
    }
    
    Supply[] supplyarray;
    
    
    constructor() ERC20('ONX Token', 'ONX') Ownable() {
        _mint(msg.sender, InitialSupply);
        deployedTimeStamp = block.timestamp;
        

        // releaseSlot["Phase0"] = _totalSupply; //10
        // releaseSlot["Phase1"] = _totalSupply + (_totalSupply * 50)/100; //10 + 5...15
        // releaseSlot["Phase2"] = _totalSupply + (releaseSlot["Phase1"] * 50)/100; //15 + 7....22
        
    }
    
    
    
    function increaseSupply() public {
        Supply memory supply1 = Supply('Phase1', 1658730551 ,  (_totalSupply * 50)/100);
        supplyarray.push(supply1);
        Supply memory supply2 = Supply('Phase2', 1690267234 ,  (_totalSupply * 25)/100);
        supplyarray.push(supply2);
        
        for(uint i=0; i <= supplyarray.length; i++)
        {
        
        if (_totalSupply < supply1.supply)
        {
            uint256 timer = block.timestamp + supply1.durationleft/7;
            require(block.timestamp > timer, "Too early to increase supply");
            _mint(msg.sender, supply1.supply);

        }
        else {
            
        }
        }
    }
    
}
