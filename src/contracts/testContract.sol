pragma solidity 0.5.1;

contract testContract {

  uint public balance;

  function sendEthers() public payable {

  }

  function getBalance() public returns (uint) {
    balance = address(this).balance;
    return balance;
  }

  function getEthers() public  payable {
    msg.sender.transfer(address(this).balance);
  }
}