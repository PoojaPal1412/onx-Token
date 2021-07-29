
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/token/ERC20/ERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";


contract ONX is ERC20,Ownable{
    
    uint public latestTimestamp;
    mapping(string=>uint) public max_supply;
    mapping(string=>bool) public phase_tracker; // true if phase ended
    string[] public phases;

    uint public achieved_supply_milestone;
    uint public release_period = 7 days;  // releasing weekly
    uint public inflation_rate = 2;
    uint public inflation_flag;
    uint public inflation_target_supply;
    
    constructor() ERC20('ONX Token', 'ONX') Ownable() {
        achieved_supply_milestone = 100000;
        _mint(msg.sender, achieved_supply_milestone);
        latestTimestamp = block.timestamp;
    }
    
    function addSupplyPhase(string calldata phase, uint phase_cap) public onlyOwner() {
        // phase_cap: max totalsupply for that phase
        require(max_supply[phase] == 0, "Phase already exists");
        max_supply[phase] = phase_cap;
        phases.push(phase);  
    }
    
    function setInflationRate(uint _inflation_rate) public onlyOwner(){
        // inflation rate can only be set when all phase supply has ended
        require(inflation_flag == 1, "Phase has no yet ended");
        require(_inflation_rate > 0, "Rate must be greater than zero");
        inflation_rate = _inflation_rate;
        inflation_target_supply = achieved_supply_milestone + (achieved_supply_milestone * _inflation_rate)/100;
    }
    
    function  release_funds() public onlyOwner() isReleaseTime(){
        if(inflation_flag == 0){
            // if phase supply is ongoing
            for(uint i=0; i<phases.length; i++){
                if(phase_tracker[phases[i]] == false){
                    // assuming 1 year = 52 weeks
                    uint amt_to_mint = (max_supply[phases[i]] - achieved_supply_milestone)/52;
                    _mint(msg.sender, amt_to_mint);
                    latestTimestamp = block.timestamp;
                    if(totalSupply() >= max_supply[phases[i]]){
                        phase_tracker[phases[i]] = true;
                        achieved_supply_milestone = totalSupply();
                    }
                    break;
                }
                else{
                    if(i == (phases.length-1)){
                        inflation_flag = 1;
                        // phase supply ended, start with inflationary supply
                        inflation_target_supply = achieved_supply_milestone + (achieved_supply_milestone * inflation_rate)/100 ;
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
        uint amt_to_mint = (inflation_target_supply - achieved_supply_milestone)/52;
        _mint(msg.sender, amt_to_mint);
        latestTimestamp = block.timestamp;
        if(totalSupply() >= inflation_target_supply){
            achieved_supply_milestone = totalSupply();
            inflation_target_supply = achieved_supply_milestone + (achieved_supply_milestone * inflation_rate)/100;
        }
    }


    modifier isReleaseTime() {
        require(block.timestamp >= (latestTimestamp+ release_period), "Hold up dude!");
        _;
    }   
}