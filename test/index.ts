import { ethers } from "hardhat";
import { expect } from "chai";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import type { LinkedList } from "../src/types/LinkedList";
import type { Node } from "../src/types/Node";

const nullAddress = "0x0000000000000000000000000000000000000000";

describe("Unit tests", function () {
  let linkedList: LinkedList;
  let signers: SignerWithAddress[];
  before(async function () {
    signers = await ethers.getSigners();
    const LinkedList = await ethers.getContractFactory("LinkedList", signers[0]);

    linkedList = <LinkedList>await LinkedList.deploy();
    await linkedList.deployed();
  });

  describe("LinkedList", function () {
    it("should return 0 and address(0) as the initial values of the LinkedList's _size and _head", async function () {
      const [admin] = signers;
      expect(await linkedList.connect(admin).size(), "wrong size").to.equal(0);
      expect(await linkedList.connect(admin).head(), "wrong head").to.equal(nullAddress);
    });

    it("should set the head during round 1", async function () {
      const [admin] = signers;

      await linkedList.add();
      const head = <Node>await ethers.getContractAt("Node", await linkedList.connect(admin).head());
      const computedHeadAddress = await linkedList.computeNodeAddress(0);
      console.log(`timestamp: ${(await head.getTimestamp()).toString()}`);
      const nextNodeAddress = await head.getNextNode();

      expect(await linkedList.connect(admin).size(), "wrong size").to.equal(1);
      expect(head.address, "wrong head").to.equal(computedHeadAddress);
      expect(nextNodeAddress, "wrong next node").to.equal(nullAddress);
    });

    it("should deploy a new node and point the previous node (head) to the new node during round 2", async function () {
      const [admin] = signers;

      await linkedList.add();
      const head = <Node>await ethers.getContractAt("Node", await linkedList.connect(admin).head());
      const computedHeadAddress = await linkedList.computeNodeAddress(0);
      console.log("timestamp: ", (await head.getTimestamp()).toString());
      const currentNode = <Node>await ethers.getContractAt("Node", await head.getNextNode());
      const computedCurrentNodeAddressAddress = await linkedList.computeNodeAddress(1);

      expect(await linkedList.connect(admin).size(), "wrong size").to.equal(2);
      expect(head.address, "wrong head").to.equal(computedHeadAddress);
      expect(currentNode.address, "wrong current node").to.equal(computedCurrentNodeAddressAddress);
      expect(+(await currentNode.getTimestamp()).toString(), "wrong timestamp").to.be.greaterThan(
        +(await head.getTimestamp()).toString(),
      );
      expect(await currentNode.getNextNode(), "wrong next node").to.equal(nullAddress);
    });
  });
});
