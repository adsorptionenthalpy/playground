pragma solidity ^0.4.22;

// Ether TimeVault for weak hands
// Adam Androulidakis 4-28-2018
// Definitely use at your own risk

    contract TimedVault {
    
    uint256 private balance;
    uint private start;
    uint vaultTime;
    address private owner;
    
    event Status(string, uint256, address); 
    
     constructor(uint256) public payable {
        start = now; //now is alias block.time
        vaultTime = start + 1 minutes; //change to x minutes, x days, x years...
        balance = 0 + msg.value;
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
            emit Status ('Funds cannot be withdrawn right now. Time remaining (minutes): ', (vaultTime - now) / 60, msg.sender);
            return vaultTime - now; //return time remaining in seconds
        }
    }
    
    function deposit() public payable returns (uint){
            assert(msg.value > 0);
            setBalance(msg.value);
            emit Status ('Funds have been deposited', msg.value, msg.sender);
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
