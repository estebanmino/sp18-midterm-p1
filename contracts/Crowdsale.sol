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
    bool started;
    uint startTime;
    uint endTime;
    uint pricePerWei;
    uint balance;
    uint tokensSold;

    mapping(address => uint) amountToBuy;

    function Crowdsale() public {
        owner = msg.sender;
        queue = new Queue();
        started = false;
        balance = 0;
        tokensSold = 0;
    }

    event TokenDeployed(uint _totalSupply, address _token);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }


    function deployToken(uint _totalSupply, uint _endTime, uint _pricePerWei) public onlyOwner() {
        token = new Token(_totalSupply);
        TokenDeployed(_totalSupply, token);
        started = true;
        startTime = now;
        endTime = _endTime * 1 minutes;
        pricePerWei = _pricePerWei;
    }

    // Creation of new tokens
    function mintTokens(uint _mintedAmount) public onlyOwner() {
        require(started);
        token.mintTokens(_mintedAmount);
    }

    // Burn tokens not sold
    function burnTokens(uint _burnedTokens) public onlyOwner() {
        require(started);
        token.burnTokens(_burnedTokens);
    }

    // Must be able to receive funds from contract after the sale is over
    function receiveFunds() public payable onlyOwner() {
        balance += msg.value;
    }

    // Buyers waiting in line must make sure they are not the last person 
    // in line: you must have someone behind you to place a token 
    
    function buyTokens() public payable {
        require(queue.enqueue(msg.sender));
        amountToBuy[msg.sender] = msg.value / pricePerWei;
        uint place = queue.checkPlace();
        balance += msg.value;
        tokensSold += amountToBuy[msg.sender]; // wrote code to increment tokensSold
        // if first in queue, empty queue
        if (place == 2 && !queue.checkTime()) {
            // if second in queue
            // buy tokens for first in queue
            token.transfer(queue.getFirst(), amountToBuy[msg.sender]);
            // else first deleted, wait for the next
        }
    }

    function getTokenSupply() public returns (uint) {
        return token.getTotalSupply();
    }

    function getTokensSold() public returns (uint) {
    	return tokensSold;
    }
}
