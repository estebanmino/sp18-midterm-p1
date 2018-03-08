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
    uint gapTime;
    uint pricePerWei;
    uint balance;
    uint tokensSold;
    uint initialTime;

    mapping(address => uint) amountToBuy;

    function Crowdsale() public {
        owner = msg.sender;
        started = false;
        balance = 0;
        tokensSold = 0;
    }

    event TokenDeployed(uint _totalSupply, address _token);
    event BurnTokens(uint _burnedTokens);
    event MoreThanTwoInQueue(uint _place);
    event TryingToBuyFor(uint _i, uint _amount);
    event DoingTransfer(bool _doingTransfer);
    event TryingToRefund(address _refundAddress, uint _refundAmount);
    

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier saleNotEnded {
        require(now - initialTime < gapTime);
        _;
    }

    modifier saleEnded() {
        require(now - initialTime > gapTime);
        _;
    }

    modifier inSaleTime() {
        require(now - initialTime < gapTime && now > initialTime);
        _;
    }

    function getTokenTotalSupply() public constant returns (uint) {
        return token.totalSupply();
    }

    function deployToken(uint _totalSupply, uint _gapTime, uint _pricePerWei) public onlyOwner() {
        token = new Token(_totalSupply);
        TokenDeployed(_totalSupply, token);
        started = true;
        gapTime = _gapTime;
        initialTime = now;
        pricePerWei = _pricePerWei;
        queue = new Queue(_gapTime);
		
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
        BurnTokens(token.balanceOf(msg.sender));
    }

    // Must be able to receive funds from contract after the sale is over
    function receiveFunds() public payable onlyOwner() {
        balance += msg.value;
    }

    function refund() public payable inSaleTime() {
        uint refundAmount = token.refund(msg.sender);
        TryingToRefund(msg.sender, refundAmount);
        tokensSold -= refundAmount;
        msg.sender.transfer(refundAmount * pricePerWei);
        balance -= refundAmount * pricePerWei;
    }

    function refundQueue() public saleEnded() {
        address first = queue.getFirst();
        TryingToRefund(first, amountToBuy[first]);
        first.transfer(amountToBuy[first] * pricePerWei);
        balance -= amountToBuy[first] * pricePerWei;
    }

    // Buyers waiting in line must make sure they are not the last person 
    // in line: you must have someone behind you to place a token 
    
    function buyTokens() public payable  {
        require(queue.enqueue(msg.sender));
        amountToBuy[msg.sender] = msg.value / pricePerWei;
        uint place = queue.checkPlace(msg.sender);
        balance += msg.value;
        // if first in queue, empty queue, do nothing

        // if second in queue, try to buy the first, if pass the time delete it
        // if third or more, try one and two...
        if (place >= 2) {
            MoreThanTwoInQueue(place);
            for (uint i = 0; i < place-1; i++) {
                TryingToBuyFor(i, amountToBuy[msg.sender]);
                if (!queue.checkTime()) {
                    DoingTransfer(true);
                    token.transfer(queue.getFirst(), amountToBuy[queue.getFirst()]);    
                    tokensSold += amountToBuy[queue.getFirst()];
                    queue.dequeue();
                } else {
                    DoingTransfer(false);

                }
            }
        }
    }

    function getMyBalance() public constant returns (uint256) {
        require(started);        
        return token.balanceOf(msg.sender);
    }


    function getTokenOwner() public constant returns (address) {
        return token.owner();
    }

    function getTokensSold() public constant returns (uint) {
        return tokensSold;
    }
    
    function () public payable {
        msg.sender.transfer(msg.value);
        revert();
    }

}
