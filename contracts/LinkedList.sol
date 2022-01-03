pragma solidity 0.8.0;
import "./Node.sol";
import "./interface/INode.sol";

contract LinkedList {
    uint256 private _size;
    address private _head;

    function add() external returns (address, address) {
        address newNodeAddress = _deployNode();
        address currentNodeAddress;

        if (_size == 0) {
            _head = newNodeAddress;
            currentNodeAddress = _head;
        } else {
            uint256 prev = _size - 1;
            INode currentNode = INode(_computeNodeAddress(prev));
            currentNode.setNextNode(newNodeAddress);
            currentNodeAddress = address(currentNode);
        }
        _size++;
        return (currentNodeAddress, newNodeAddress);
    }

    function size() external view returns (uint256) {
        return _size;
    }

    function head() external view returns (address) {
        return _head;
    }

    function computeNodeAddress(uint256 size_) external view returns (address) {
        return _computeNodeAddress(size_);
    }

    function _getBytecode() private pure returns (bytes memory) {
        return abi.encodePacked(type(Node).creationCode);
    }

    function _computeNodeAddress(uint256 size_) private view returns (address) {
        bytes memory bytecode = _getBytecode();
        return
            address(
                uint160(uint256(keccak256(abi.encodePacked(bytes1(0xff), address(this), size_, keccak256(bytecode)))))
            );
    }

    function _deployNode() private returns (address) {
        bytes memory bytecode = _getBytecode();
        address deployed;
        assembly {
            deployed := create2(
                callvalue(),
                add(bytecode, 0x20),
                mload(bytecode),
                sload(_size.slot) // use size as a salt
            )
            if iszero(extcodesize(deployed)) {
                revert(0, 0)
            }
        }
        return deployed;
    }
}
