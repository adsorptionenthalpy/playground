/**** Simple Lottery ****
 **** Date 4-28-2018 ****
 **** Adam Androulidakis ****
 **** Inital pot size is .05 ether. Must deposit .01 either. 
 **** Each address can deposit multiple times for equal entries.
 **** Will not accept deposits if gas price is above 1000000.
 **** See uint constant GASMARGIN below
 **** Warning: random is not truly random and may be reproduced by miners */
 
pragma solidity ^0.4.22;

contract SimpleLottery  {
  
    uint private potsize;
    uint private addresses;
    uint private roundbalance;
    uint constant AMOUNT = 10**16;  // .01 ether required amount
    uint constant GASMARGIN = 10**7; // 10,000,000 gas 
    uint constant DEVFEE = 10**15;      // .001 ether 
    uint constant SYRUP = 1;
    uint constant GAMECAP = 10**19;
    uint constant INITIAL = ((10**17)/2);
    address[] private participant;
    address private owner;
    address private winner;
    
    event status(string,uint256,address);
    
    constructor() public {

        potsize = INITIAL; // initial cap is .05 Ether
        owner = msg.sender;
    }
     
    function destroy() public ownerOnly {
          selfdestruct(owner);
    }
     
     
    modifier ownerOnly() {
         
        require(msg.sender == owner);
             _;
    }
     
    function GetMemberCount() external view returns(uint) {
        
        return participant.length;
    }
    
    function GetPotSize() external view returns(uint) {
        
        return potsize;
    }
    
    function NewGame() private {
        potsize *= 2;
        //transfer balance to contract owner (optional), or it will later be done when contract is destroyed.
        winner = 0x0;
        participant.length=0;
        roundbalance = 0;
        emit status("New game has started.",potsize,address(this));
    }
    
    function GetBalance() ownerOnly external view  returns (uint) {
        
        return address(this).balance;
    }
    
    function RoundBalance() public view returns(uint) {
        return roundbalance;
    }
     
    function GenerateRandom(uint seed, uint size) private constant returns (uint randomNumber) {
        
        return (uint(keccak256(blockhash(block.number-1), seed ))%size);
    }
     
     function AddParticipant() private {
         emit status("Participant has been added.", block.timestamp,msg.sender);
         participant.push(msg.sender);
    }
     
     function Payout() private {
        
        winner.transfer(roundbalance - (DEVFEE));

    // This destroys the contract if the game exceeds a certain amount of ether
        if (potsize < GAMECAP)
            NewGame();
        else
        {
            emit status("Game cap reached. Contract is being terminated. ", block.timestamp,address(this));
            selfdestruct(owner);
        }
    }
     
     function PickWinner() private {
         
         winner = participant[GenerateRandom(SYRUP,(participant.length)-1)];
         emit status("The winner is: ",roundbalance,winner);
         
     }

     function Deposit() public payable {
         
        //Make sure ether is .01 but allow enough room for gas 
        if ((msg.value < AMOUNT) || (msg.value >= (AMOUNT + GASMARGIN))) {
            emit status("You must enter .01 Ether.", block.timestamp,msg.sender);
            revert();
        }

        emit status("Deposit has been made.", block.timestamp,msg.sender);
       
        AddParticipant(); // Add address to participant array
        roundbalance += msg.value;
         
        if (roundbalance >= potsize)  {
             PickWinner();
             Payout();
        }

    }
     
 }

 
 
