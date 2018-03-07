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
    uint8 queueSize = 0;
    address[] queue;
    uint timeLimit; // minutes
    uint lastHeadTime = 0 * 1 minutes;
    // YOUR CODE HERE

    /* Add events */
    // YOUR CODE HERE

    /* Add constructor */
    // YOUR CODE HERE
    function Queue(uint _timeLimit, address[] _queue) public {
        timeLimit = _timeLimit * 1 minutes;
        queue = _queue;
    }

    /* Returns the number of people waiting in line */
    function qsize() constant returns(uint8) {
        return queueSize;
    }

    /* Returns whether the queue is empty or not */
    function empty() constant returns(bool) {
        return queueSize == 0;
    }

    /* Returns the address of the person in the front of the queue */
    function getFirst() constant returns(address) {
        return queue[0];
    }

    /* Allows `msg.sender` to check their position in the queue */
    function checkPlace() constant returns(uint8) {
        for (uint8 i = 0; i < queueSize; i++) {
            if (msg.sender == queue[i]) {
                return i;
            }
        }
    }

    /* Allows anyone to expel the first person in line if their time
        * limit is up
        */
    function checkTime() { 
        require(timeLimit < lastHeadTime);
        dequeue();
    }

    /* Removes the first person in line; either when their time is up or when
        * they are done with their purchase
        */
    function dequeue() {
        address[] memory newQueue = new address[](5);
        for (uint8 i = 1; i < 5; i++) {
            newQueue[i-1] = queue[i];
        }
        queue = newQueue;
    }

    /* Places `addr` in the first empty position in the queue */
    function enqueue(address addr) {
        require(queueSize < 5);
        queue.push(addr);
        queueSize += 1;
    }
}
