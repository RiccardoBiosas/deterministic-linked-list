pragma solidity 0.8.0;

struct Node {
    address current;
    function() returns(address) next;
}

contract NodeFactory {
    address private _next;
    Node private _self;

    constructor() {
        _self.current = address(this);
        _self.next = getNextNode;
    }

    function getNextNode() public view returns(address) {
        return _next;
    }

    // add acl
    function setNextNode(address _addr) external {
        _next = _addr;
    }
}

contract LinkedList {
    uint256 private _size;
    address private _head;

    function size() external view returns(uint256) {
        return _size;
    }    

    function head() external view returns(address) {
        return _head;
    }

    function add() external returns(address){
        address newNode;
        if(_size == 0) {
            _head = address(new NodeFactory());
            newNode = _head;
        } else {
            newNode = address(new NodeFactory());
        }
        _size++;
        return newNode;
    }
}