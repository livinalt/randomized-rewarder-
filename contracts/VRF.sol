// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./node_moduels/@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomisedRewarder is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    // Chainlink VRF Coordinator address and LINK token address
    address constant VRF_COORDINATOR = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    address constant LINK_TOKEN = 0x779877A7B0D9E8603169DdbD7836e478b4624789;

    // Events
    event RandomnessRequested(bytes32 indexed requestId);
    event RandomnessFulfilled(bytes32 indexed requestId, uint256 randomness);

    constructor() VRFConsumerBase(VRF_COORDINATOR, LINK_TOKEN) {
        keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c; 
        fee = 0.25 * 10 ** 18; 
    }

    function requestRandomness() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK tokens in contract");

        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
        emit RandomnessFulfilled(requestId, randomness);
    }

}
