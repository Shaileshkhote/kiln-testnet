'use strict';
const fs = require('fs');
const HDWalletProvider = require('@truffle/hdwallet-provider');

const Factory = require('./build/contracts/TokenFactory.json');


function get_data(_message) {
  return new Promise(function(resolve, reject) {
      fs.readFile('./installation_data.json', (err, data) => {
          if (err) throw err;
          resolve(data);
      });
  });
}

function write_data(_message) {
  return new Promise(function(resolve, reject) {
      fs.writeFile('./installation_data.json', _message, (err) => {
          if (err) throw err;
          console.log('Data written to file');
          resolve();
      });
  });
}

var privateKeys = [];
var URL = "";


(async () => {
  // Read in the configuration information
  var data = await get_data();
  var data_object = JSON.parse(data);
  // Add keys
  console.log("Adding Alice key ...");
  privateKeys.push(data_object.private_key.alice);
  // RPC
  URL = data_object.provider.rpc_endpoint;

  // Web3 - keys and accounts
  const Web3 = require("web3");
  const provider = new HDWalletProvider(privateKeys, URL, 0, 1);
  const web3 = new Web3(provider);
  await web3.eth.net.isListening();
  console.log('Web3 is connected.');
  console.log("Private keys: " + privateKeys);
  let accounts = await web3.eth.getAccounts();
  console.log(`accounts: ${JSON.stringify(accounts)}`);



  let FactoryContract;
  FactoryContract = await new web3.eth.Contract(Factory.abi)
                              .deploy({
                                data: Factory.bytecode, 
                                arguments: [
                                  "0x939bC583367958f2b8a62A203Aa9C6e6d5FAb2A9"
                                ]})
                              .send({
                                from: accounts[0],
                                 gas: 10000000,
                                 gasPrice: 10000000000,
                                 chainId:97
                              })
  console.log(`Factory contract deployed at ${FactoryContract.options.address}`);
  console.log(`Please store this Factory address for future use ^^^`);
  data_object.contract_address.Factory = FactoryContract.options.address;

 
  let data_to_write = JSON.stringify(data_object, null, 2);
  await write_data(data_to_write);


  await provider.engine.stop();
})();