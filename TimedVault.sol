pragma solidity ^0.4.22;

// Ether TimeVault for weak hands
// Adam Androulidakis 4-28-2018
// Definitely use at your own risk

    contract TimedVault {
    
    uint256 private balance;
    uint private start;
    uint vaultTime;
    address private owner;
    
    constructor() public {
        start = now; //now is alias block.time
        vaultTime = start + 1 minutes; //change to x minutes, x days, x years...
        balance = 0;
        owner = msg.sender;
    }
    
     modifier ownerOnly{
        require(msg.sender == owner);
        _;
    }
    
    function ReturnBalance() ownerOnly public returns (uint){
        if(now > vaultTime) { 
            assert(balance>0); 
            balance -= balance;
    	    kill();
        }
        else{
             return vaultTime - now; //return time remaining in seconds
        }
    }
    
    function deposit() public payable returns (uint){
            assert(msg.value > 0);
            setBalance(msg.value);
            return getBalance(); //return with accumulated balance
    }
    
    function getBalance() constant public returns(uint256){
        return balance;
    }
    
    function setBalance(uint256 _value) private {
        balance+=_value;
    }
    
    function kill() private {
         selfdestruct(owner);
    }
 

}
