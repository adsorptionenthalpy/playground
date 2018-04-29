// Ether Will
// Version 1
// Adam Androulidakis 4-28-2018
// Definitely use at your own risk

pragma solidity ^0.4.22;

contract EtherWill {
    
    address private testator;
    address[] private beneficiary;
    uint256 public lastTouched;
    uint constant private TWOMIN = 120; 

    event Status(string msg, address user, uint256);

    constructor() public payable {
        testator = msg.sender;
        lastTouched = block.timestamp;
        emit Status ('Last will contract created', msg.sender, block.timestamp);
    }

    modifier onlyOwner {
        if (msg.sender != testator) {
            revert();
        }
        else {
            _;
        }
    }

    function depositFunds() public payable {
        emit Status('Funds have been deposited', msg.sender, block.timestamp);
    }

    function addBeneficiary(address beneficiaryAddress) public onlyOwner {
        emit Status('Beneficiary Added', beneficiaryAddress, block.timestamp);
        beneficiary.push(beneficiaryAddress);
    }

    function stillAlive() onlyOwner public{
        lastTouched = block.timestamp;
        emit Status('Im still alive!', msg.sender, block.timestamp);
    }

    function isDeceased() public {
        emit Status('Someone is checking death', msg.sender, block.timestamp);
        if (block.timestamp > (lastTouched + TWOMIN)) {
            giveMoneyToBeneficiary();
        }
        else {
            emit Status ('Im still alive', msg.sender, block.timestamp);
        }
    }

    function giveMoneyToBeneficiary() private {
        emit Status('Testator is deceased.', msg.sender, block.timestamp);
        uint amountPerBeneficiary  = address(this).balance/beneficiary.length;
        for(uint i = 0; i < beneficiary.length; i++)
        {
            beneficiary[i].transfer(amountPerBeneficiary);
        }
    }        
}
    
