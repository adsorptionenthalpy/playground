pragma solidity ^0.4.18;

// Ether TimeVault for weak hands
// Adam Androulidakis 4-27-2018
// Definitely use at your own risk

    contract TimedVault {
    
    uint balance;
    uint private start;
   
    constructor() public {
        start = now; //now is alias block.time
        balance = 0;
    }
    
    function ReturnBalance() public {
        if(now > start + 1 years) { // Change me to x minutes or x days or x years
            assert(balance>0); 
            balance -= balance;
    	    kill();
        }
    }
    
    function deposit() public payable {
            assert(msg.value>0);
            balance += msg.value;
    }
    
    function kill() private {
         selfdestruct(msg.sender);
  }
 

}

