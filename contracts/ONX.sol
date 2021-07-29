// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

        
contract ONX is ERC20,Ownable{
    
    uint public latestTimestamp;
    mapping(string=>uint) public max_supply;
    mapping(string=>bool) public phase_tracker; // true if phase ended
    string[] public phases;
    uint public achived_supply_milestone;
    uint public release_period = 1 seconds; //1 minutes; // 7 days;  // 7 days
    uint public inflation_rate = 2;
    //event log_str(string data);
    //event log(uint len);
    uint public inflation_flag;
    uint public inflation_target_supply;
    
    
    constructor() ERC20('ONX Token', 'ONX') Ownable() {
        achived_supply_milestone = 100000;
        _mint(msg.sender, achived_supply_milestone);
        latestTimestamp = block.timestamp;
    }
        

    function addSupplyPhase(string calldata phase, uint phase_cap) public onlyOwner() {
        require(max_supply[phase] == 0, "Phase already exists");
        max_supply[phase] = phase_cap;
        phases.push(phase);
        
    }
    
    function setInflationRate(uint _inflation_rate) public onlyOwner(){
        require(inflation_flag == 1, "Phase has no yet ended");
        require(_inflation_rate > 0, "Rate must be greater than zero");
        inflation_rate = _inflation_rate;
        inflation_target_supply = achived_supply_milestone + (achived_supply_milestone * _inflation_rate)/100;
    
    }
    
        
    function  release_funds() public onlyOwner() isReleaseTime(){
        if(inflation_flag == 0){
            for(uint i=0; i<phases.length; i++){
                if(phase_tracker[phases[i]] == false){
                    uint amt_to_mint = (max_supply[phases[i]] - achived_supply_milestone)/2;
                    _mint(msg.sender, amt_to_mint);
                    latestTimestamp = block.timestamp;
                    if(totalSupply() >= max_supply[phases[i]]){
                        phase_tracker[phases[i]] = true;
                        achived_supply_milestone = totalSupply();
                    }
                    break;
                }
                else{
                    if(i == (phases.length-1)){
                        inflation_flag = 1;
                        inflation_target_supply = achived_supply_milestone + (achived_supply_milestone * inflation_rate)/100 ;
                        release_inflation_funds();
                    }
                }
        }
        }
        else{
            release_inflation_funds();
        }
    }
    
    function  release_inflation_funds() internal {
        uint amt_to_mint = (inflation_target_supply - achived_supply_milestone)/2;
        _mint(msg.sender, amt_to_mint);
        latestTimestamp = block.timestamp;
        if(totalSupply() >= inflation_target_supply){
            achived_supply_milestone = totalSupply();
            inflation_target_supply = achived_supply_milestone + (achived_supply_milestone * inflation_rate)/100;
        }
}

    modifier isReleaseTime() {
        require(block.timestamp >= (latestTimestamp+ release_period), "Hold up dude!");
        _;
    }   
}