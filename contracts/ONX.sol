
pragma solidity ^0.8.0;


import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/token/ERC20/ERC20.sol";

contract ONX is ERC20 {
    address public admin;
    constructor() ERC20("OneByX","ONX"){
        admin = msg.sender;
        _mint(admin,1e21);
    }
}


