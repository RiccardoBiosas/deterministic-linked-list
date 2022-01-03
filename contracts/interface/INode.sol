pragma solidity 0.8.0;

interface INode {
    function setNextNode(address _addr) external;
    function getNextNode() external view returns(address);
    function getTimestamp() external view returns(uint256);    
}
