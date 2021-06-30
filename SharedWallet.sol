pragma solidity ^0.5.13;

contract SharedWallet {
    
    address payable public owner;
    mapping(address => uint) public wallet;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier isOwner {
        require (msg.sender == owner, "This operation is reserved to the wallet owner!");
        _;
    }
    
    function topUp() public payable {
        assert(wallet[msg.sender] + msg.value > wallet[msg.sender]);
        wallet[msg.sender] += msg.value;
    }
    
    function topUpWallet(address payable toAddress) public payable isOwner {
        assert(wallet[toAddress] + msg.value > wallet[toAddress]);
        wallet[toAddress] += msg.value;
    }
    
    function withdraw(uint amount) public {
        assert(wallet[msg.sender] - amount < wallet[msg.sender]);
        assert(wallet[msg.sender] - amount >= 0);
        
        wallet[msg.sender] -= amount;
        address(msg.sender).transfer(amount);
    }
    
    function withdrawFromWallet(address fromAddress, uint amount) public isOwner {
        assert(wallet[fromAddress] - amount < wallet[fromAddress]);
        assert(wallet[fromAddress] - amount >= 0);
        
        wallet[fromAddress] -= amount;
        owner.transfer(amount);
    }
    
}