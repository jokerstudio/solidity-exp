// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ReceiveEther {
    /*
    Which function is called, fallback() or receive()?
           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function callAndPay(string memory data) public payable returns (string memory, uint) {
        return (data, msg.value);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendEther {
    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    function callFuncWithEther(address payable _to) public payable  {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        ReceiveEther addr = ReceiveEther(_to);
        (string memory sender, uint amount) = addr.callAndPay{value: (msg.value / 2)}("send data");
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}