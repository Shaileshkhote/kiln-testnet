'use strict';
const fs = require('fs');
const HDWalletProvider = require('@truffle/hdwallet-provider');

const Factory = require('./build/contracts/GenesisToken.json');


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
  let accounts = await web3.eth.getAccounts();
  console.log(`accounts: ${JSON.stringify(accounts)}`);


const contracts = ["0x8cCD28a39D97FcC655A8337Ca089381dc7e0151D","0xAC872a13dA5D88c050E9afaa5e75BE1adBD5f1B2","0x0173A0F94feC58ad8C20F4a709697649b393ca90","0xC72adcE9211AbFe7c41780bb7f2b3EEaB99C77F8","0xC0e5a605AB19e638b41FBb34749B7061395FAa4E","0xa2Bc68d0FB9D058a4Da1eCD69E4Db0ed85821767","0xF04eA71558042dab9763b0baf1056D28506ec0C0","0xEAA0d89270AD6c0F9AAE6A6F03d75e826AEdF689","0x14035a3E2Bf4e65c9ab2219336BE3734c6ed76ba","0x27d78A410E744D841855EA2fa047c96D275cB93C"]


for(var i=0;i<101;i++){

const GCSHM = new web3.eth.Contract(Factory.abi,contracts[1])
GCSHM.methods
  .mintTokens("100000000000000000")
  .send({ from: accounts[0] }, function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    console.log("Hash of the transaction: " + res)
  })

}


  await provider.engine.stop();
})();