'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol");
// YOUR CODE HERE

contract('CrowdsaleTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {_supply: 99999999999, _endtime: 5000, _pricePerWei: 2, _amount1: 50, _amount2: 25, _zero: 0};
	let sale, queue, token, account1;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		sale = await Crowdsale.new();
		queue = await Queue.new();
		token = await Token.new(args._supply);
		await sale.deployToken(args._supply, args._endtime, args._pricePerWei);
		account1 = accounts[0];
		await sale.buyTokens({from: account1, value: args._amount1});
	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('~Crowdsale Works~', function() {
		it("The contract must keep track of how many tokens have been sold.", async function() {
			// let acc1Balance = await web3.eth.getBalance(account1);
			// console.log('account1: ' + account1);
			// console.log('acc1Balance');
			// console.log(acc1Balance);
			// console.log('acc1Balance: ' + acc1Balance);
			let tokensSold = await sale.getTokensSold.call();
			assert.equal(tokensSold.valueOf(), args._amount1 / args._pricePerWei, 'Amount of tokens sold in sale equals amount bought by accounts.');
		});
		it("The contract must only sell to/refund buyers between start-time and end-time.", async function() {
			// YOUR CODE HERE
		});
		it("The contract must forward all funds to the owner after sale is over.", async function() {
			// YOUR CODE HERE
		});
		it("Owner must be set on deployment.", async function() {
			// YOUR CODE HERE
		});
		it("Must keep track of start-time.", async function() {
			// YOUR CODE HERE
		});
		it("Must keep track of end-time/time remaining since start-time.", async function() {
			// YOUR CODE HERE
		});
		it("Owner must be able to specify an initial amount of tokens to create.", async function() {
			// YOUR CODE HERE
		});
		it("Owner must be able to specify the amount of tokens 1 wei is worth.", async function() {
			// YOUR CODE HERE
		});
		it("Owner must be able to mint new tokens.", async function() {
			// YOUR CODE HERE
		});
		it("Must be able to burn tokens not sold yet.", async function() {
			// YOUR CODE HERE
		});
		it("Owner must be able to receive funds from contract after the sale is over.", async function() {
			// YOUR CODE HERE
		});
	});

	// describe('Your string here', function() {
	// 	// YOUR CODE HERE
	// });
});
