'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol");
// YOUR CODE HERE

contract('QueueTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {_size: 5};
	let queue, account1, account2, account3, account4, account5, account6;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		queue = await Queue.new();
		account1 = accounts[0];
		account2 = accounts[1];
		account3 = accounts[2];
		account4 = accounts[3];
		account5 = accounts[4];
		account6 = accounts[5];
		await queue.enqueue(account1);
		await queue.enqueue(account2);
		await queue.enqueue(account3);
		await queue.enqueue(account4);
		await queue.enqueue(account5);
	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('~Queues Work~', function() {
		it("Must have a finite size, please keep this set to 5.", async function() {
			await queue.enqueue(account6);
			queueSize = await queue.qsize.call();
			assert.isAtMost(queueSize, args._size, 'Queue size should be less than or equal to 5.');
		});
		it("Must have a time limit someone can keep their spot in the front; this prevents griefing.", async function() {
			// YOUR CODE HERE
		});
		it("Must have qsize() method.", async function() {
			queueSize = await queue.qsize.call();
			assert.isEqual(queueSize, args._size, 'qsize() method should return correct size.');
		});
		it("Must have empty() method.", async function() {
			// YOUR CODE HERE
		});
		it("Must have getFirst() method.", async function() {
			// YOUR CODE HERE
		});
		it("Must have checkPlace() method.", async function() {
			// YOUR CODE HERE
		});
		it("Must have checkTime() method.", async function() {
			// YOUR CODE HERE
		});
		it("Must have dequeue() method.", async function() {
			// YOUR CODE HERE
		});
		it("Must have enqueue(address addr) method.", async function() {
			// YOUR CODE HERE
		});
		it("The queue should only permit buyers to place an order if they are not the only ones in line, i.e. if there is at least one person waiting behind them.", async function() {
			// YOUR CODE HERE
		});
		it("Event fired when someone's time limit is over and they are ejected from the front of the queue.", async function() {
			// YOUR CODE HERE
		});
	});

	// describe('Your string here', function() {
	// 	// YOUR CODE HERE
	// });
});
