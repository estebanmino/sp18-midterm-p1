pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {

    uint256 constant private MAX_UINT256 = 2**256 - 1;   // Overflow
    string public name;
    string public symbol;
    uint public totalSupply;
    address public owner;

    mapping(address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;

    function Token (uint _totalSupply) public {
        owner = msg.sender;
        balances[owner] = _totalSupply; // give the total amount of tokens to the creator
        totalSupply = _totalSupply;
        TokenInitialized(balances[owner]);
    }
    
    function owner() public constant returns (address) {
        return owner;
    }

    function totalSupply() public constant returns (uint) {
        return totalSupply;
    }

    event ReturningBalance(uint256 _balance);
    event TokenInitialized(uint _balanceOwner);
    event TokenTransfer(address _to, uint _value);
     

    // MUST trigger when tokens are transferred, including zero value transfers.
    event Transfer(address indexed _from, address indexed _to, uint _value);

    // MUST trigger on any successful call to approve(address _spender, uint256 _value).
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    // Fire on buyers burning tokens
    event Burned(address indexed _owner, uint _value);

    // Returns the account balance of another account with address _owner
    function balanceOf(address _owner) public constant returns (uint256) {
        ReturningBalance(balances[_owner]);
        return balances[_owner];
    }
    
    // Transfer _value amount of tokens to address _to, and MUST fire the 
    // event Transfer. The function SHOULD throw if the _from account 
    // balance does not have enough tokens to spend.
    // Transfer of 0 values MUST be treated as normal transfer
    function transfer(address _to, uint _value) public returns (bool success) {
        TokenTransfer(_to, _value);
        require(balances[msg.sender] > _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(owner, _to, _value);
        return true;
    }

    // Trasfer _value amount of tokens from address _to and MUST fire  Transfer event
    // Used for a withdraw workflow, allowing contracts to transfer tokens on you behalf.
    // The functions SHOULD throw inless the _from account has deliberately authorized the
    // sender of the message via some mechanism.
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        Transfer(_from, _to, _value);
        return true;
    }

    function refund(address _to) public payable returns (uint) {
        if (balances[_to] > 0) {
            uint refundAmount = balances[_to];
            balances[_to] = 0;
            balances[owner] += refundAmount;
            return refundAmount;
        } else {
            return 0;
        }
    }

    // Allows _spender to withdraw from your account multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    // Must be able to burn their tokens
    function burnTokens(uint _value) public returns (bool) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        totalSupply -= _value;
        Burned(msg.sender, _value);
        return true;
    }

    function mintTokens(uint _mintedAmount) public {
        balances[msg.sender] += _mintedAmount;
        totalSupply += _mintedAmount;
    }

    function getTotalSupply() constant public returns (uint) {
        return totalSupply;
    }
    
    function () public payable {
        msg.sender.transfer(msg.value);
        revert();
    }

}
 