// //import BigNumber from 'bignumber.js';
// let BigNumber = require('bignumber.js');
// let fs = require('fs');
// let Web3 = require('web3');
//
//
//
// //初始化 web3
// //let web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/971dfadadf284cc684bb270f59f055de'));
// let web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:7545'));
//
//
// let red = '0xEEeD817fFcf0779B809ebeb89E65D455511cBffF';
// let blue = '0x99C1f7ffFb38A557A128D9d52Dc14D5ae1F0b0b2';
// let green = '0x5409ED021D9299bf6814279A6A1411A7e866A631';
// // let balance = web3.eth.getBalance(a);
// //
// // web3.eth.getBalance(a, function(error, result){
// //   if(!error)
// //     console.log(a+ ':' +result);
// //   else
// //     console.error(error);
// // })
//
//
//
//
// const getBalance = async function(){
//   const redBalance = await web3.eth.getBalance(red);
//   console.log(red+ ':' +redBalance);
//   const blueBalance = await web3.eth.getBalance(blue);
//   console.log(blue+ ':' +blueBalance);
//   const greenBalance = await web3.eth.getBalance(green);
//   console.log(green+ ':' +greenBalance);
// }
// //getBalance();
//
//
//
// const deploy = async function(){
//
// }
//
// deploy();
//
//
// //let code = fs.readFileSync('../contracts/NewMinorityDecisionSale.sol').toString();
// const solc = require('solc');
//
// let code = fs.readFileSync('Voting.sol','utf8').toString();
// //编译合约为ABI文件
// let compiledCode = solc.compile(code, 1);
//
// console.log('compiledCode: ' + compiledCode);
//
// console.log('Compile Voting.sol complete');
// //部署合约至区块链节点
// let abiDefinition = JSON.parse(compiledCode.contracts[':Voting'].interface);
// //写入ABI文件至本地文件目录
// fs.writeFile('Voting.json',JSON.stringify(abiDefinition), {}, function(err) {
//   console.log('write ABI file [Voting.json] complete . ');
// });
//
// let VotingContract = web3.eth.contract(abiDefinition);
// let byteCode = compiledCode.contracts[':Voting'].bytecode;
//
//
//
//
//
