pragma solidity 0.8.0;

struct NodeSchema {
    address current;
    function() returns(address) next;
}

contract Node {
    NodeSchema private _self;
    address private _next;
    uint256 private _timestamp;

    constructor() {
        _self.current = address(this);
        _self.next = getNextNode;
        _timestamp = block.timestamp;
    }

    // add acl
    function setNextNode(address addr_) external {
        _next = addr_;
    }

    function getNextNode() public view returns(address) {
        return _next;
    }

    function getTimestamp() external view returns(uint256) {
        return _timestamp;
    }
}
