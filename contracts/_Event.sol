// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract eventOrganize{

    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint ticketremain;
    }

     mapping(uint=>Event) public events;
     mapping (address=>mapping (uint=>uint)) public tickets;
     
     uint public nextid;

     function createevent(string memory name, uint date, uint price, uint ticketcount) external  {
      
       require(date>block.timestamp,"You should organize your event for future");
       require(ticketcount>0,"Ticket should be more than 0");


       events[nextid]=Event(msg.sender,name,date,price,ticketcount,ticketcount);
       nextid++;

     }


    function buyticket(uint id, uint quantity) external payable  {

        require(events[id].date!=0,"This event doesn`t exist");
        require(events[id].date>block.timestamp,"Event has already occured");
         
         Event storage _event=events[id];
         require(msg.value==(_event.price*quantity),"Ether is not sufficient");
         require(_event.ticketremain>=quantity,"Not enough tickets");
         _event.ticketremain-=quantity;
         tickets[msg.sender][id]+=quantity;
    }


     function transferticket(uint id,uint quantity, address to)external{
        require(events[id].date!=0,"This event doesn`t exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"you don`t have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;


     }


}
