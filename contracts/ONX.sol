pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/token/ERC20/ERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";

contract ONX is ERC20,Ownable{
    
    uint public latestTimestamp;
    mapping(string=>uint) public max_supply;
    mapping(string=>bool) public phase_tracker; // true if phase ended
    string[] public phases;
    uint public supply_milestone;
    uint public release_period = 1 minutes; // 7 days;  // 7 days

    constructor() ERC20('ONX Token', 'ONX') Ownable() {
        supply_milestone = 100000;
        _mint(msg.sender, supply_milestone);
        latestTimestamp = block.timestamp;
        max_supply["phase1"] = totalSupply() +(totalSupply() * 50)/100;
        max_supply["phase2"] = max_supply["phase1"] + (max_supply["phase1"] * 25)/100;
        phases.push("phase1");
        phases.push("phase2");
    }

    function  release_funds() public onlyOwner() isReleaseTime(){
        for(uint i=0; i<phases.length; i++){
            if(phase_tracker[phases[i]] == false){
                uint amt_to_mint = (max_supply[phases[i]] - supply_milestone)/50;
                _mint(msg.sender, amt_to_mint);
                latestTimestamp = block.timestamp;
                if(totalSupply() > max_supply[phases[i]]){
                    phase_tracker[phases[i]] = true;
                    supply_milestone = totalSupply();
                }
                break;
            }
        } 
    }
        } 
    }

    modifier isReleaseTime() {
        require(block.timestamp >= (latestTimestamp+ release_period), "Hold up dude!");
        _;
    }   
}