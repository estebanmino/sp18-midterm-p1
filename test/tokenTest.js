'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol");
// YOUR CODE HERE

contract('TokenTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {_supply: 99999999999, _amount1: 150, _amount2: 50, _zero: 0};
	let sale, queue, token;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		sale = await Crowdsale.new();
		queue = await Queue.new();
		token = await Token.new(args._supply);
	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('~Tokens Work~', function() {
		it("Buyers must be able to buy tokens directly from the contract and as long as the sale has not ended, if they are first in the queue and there is someone waiting in line behind them.", async function() {
			// YOUR CODE HERE
		});
		it("Buyers must be able to refund their tokens as long as the sale has not ended. Their place in the queue does not matter.", async function() {
			// YOUR CODE HERE
		});
		it("Events fired on token purchase and refund.", async function() {
			// YOUR CODE HERE
		});
	});

	// describe('Your string here', function() {
	// 	// YOUR CODE HERE
	// });
});
