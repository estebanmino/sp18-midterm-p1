pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
    /* State variables */
    uint8 size = 5;
    address[] queue;

    uint timeLimit;
    uint lastHeadTime;

    uint8 front;
    uint8 back;

    /* Add events */
    event Enqueue(address adr, uint pos);
    event Dequeue(address adr);
    event LastTimeUpdated();
    event CheckPlace(uint _pos);
    

    /* Add constructor */
    function Queue(uint _timeGap) public {
        queue = new address[](0);
        front = 0;
        back = 0;
        timeLimit = _timeGap * 1 minutes;
    }

    /* Returns the number of people waiting in line */
    function qsize() public constant returns(uint8) {
        if (back == front) {
            return 0;
        } else {
            return back-front;
        }
    }

    /* Returns whether the queue is empty or not */
    function empty() public constant returns(bool) {
        return qsize() == 0;
    }

    /* Returns the address of the person in the front of the queue */
    function getFirst() public constant returns(address) {
        if (empty()) {
            return 0;
        }
        return queue[front];
    }

    /* Allows `msg.sender` to check their position in the queue */
    function checkPlace(address _address) public constant returns(uint8) {
        for (uint8 i = front; i < qsize() + front; i++) {
            if (_address == queue[i]) {
                return i+1-front;
            }
        }
        return 0;
    }

    /* Allows anyone to expel the first person in line if their time
        * limit is up
        * returns true if dequeue() is executed
        */
    // Checktime in terms of blocks created between transactions
    // due to time problems
    function checkTime() public returns (bool) { 
        if (!empty() && timeLimit < now - lastHeadTime) {
            dequeue();
            return true;
        } else {
            return false;
        }

        /* CheckBlock(blockLimit, block.number, lastHeadBlock);
        if (!empty() && blockLimit < block.number - lastHeadBlock) {
            dequeue();
            return true;
        } else {
            return false;
        }*/
    }

    /* Removes the first person in line; either when their time is up or when
        * they are done with their purchase
        */
    function dequeue() public {
        require(!empty());
        Dequeue(queue[front]);
        delete queue[front];
        front += 1;
        if (!empty()) {
            lastHeadTime = now;            
        }
        LastTimeUpdated();
    }

    /* Places `addr` in the first empty position in the queue */
    function enqueue(address addr) public returns (bool) {
        require(qsize() < 5);
        if (empty()) {
            lastHeadTime = now;
        }
        back += 1;
        queue.push(addr);
        Enqueue(addr, qsize());
        return true;
    }
    
    function () public payable {
        msg.sender.transfer(msg.value);
        revert();
    }
}
