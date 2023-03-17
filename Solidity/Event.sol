//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;

contract EventContract {
    struct Event{
    address organiser;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;
    }

    mapping (uint=>Event) public events; //keep tract of all events
    mapping (address=>mapping(uint=>uint)) public tickets; //holds all our tickets
    uint public nextId;


    function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
        require(date>block.timestamp, "You can organize event for future date"); //time in blockchain is in sec
        require(ticketCount>0, "You can organize event only if you create more than 0 tickets");

        events [nextId] = Event (msg.sender, name, date, price, ticketCount, ticketCount); //remain ticket equals count in start
        nextId++;
    }
    
    function buyTicket(uint id,uint quantity) external payable {
        require(events[id].date!=0, "Event does not exist");  //initially date is 0
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity), "Ether is not enough"); 
        require(_event.ticketRemain >= quantity, "Not enough tickets");
        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;

    }

    function transferTicket(uint id, uint quantity, address to) external{
        require(events[id].date!=0, "Event does not exist");  //initially date is 0
        require(events[id].date>block.timestamp,"Event has already occured");
        require (tickets[msg.sender][id] >= quantity, "you do not have enough tickets");
        tickets[msg.sender][id] -= quantity;
        tickets[to][id]+= quantity;
    }
    
}

 