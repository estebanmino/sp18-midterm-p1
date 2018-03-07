pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {

    address owner;
    Queue queue;
    Token token;

    function Crowdsale() public {
        owner = msg.sender;
        queue = new Queue();
    }

    event TokenDeployed(uint _totalSupply, address _token);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function deployToken(uint _totalSupply) public onlyOwner() {
        token = new Token(_totalSupply);
        TokenDeployed(_totalSupply, token);
    }

}
