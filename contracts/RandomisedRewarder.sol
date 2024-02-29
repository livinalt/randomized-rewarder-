// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import './RewardToken.sol';

contract RandomisedRewarder {
    bool isParticipant = true;

    // Struct to store participant details
    struct Participant {
        uint256 id;
        address participantAddress;
        Activity activity;
    }

    // Enum for participant activities
    enum Activity { Racing, Biking, Soccer, Painting }

    // Struct to track participant activity and earned values
    struct ParticipantActivity {
        Activity activity;
        uint256 value;  // Earned values
    }

    // Array to hold all participants
    Participant[] public allParticipants;

    // Mapping to track participant's activity
    mapping(address => ParticipantActivity) participant;

    // Event for participant registration
    event ParticipantRegistered(uint256 id, address participantAddress, Activity activity);

    // Event for activity participation
    event ActivityParticipation(address participantAddress, uint256 valueEarned);

    // Constructor
    constructor() {
        // Initialize activities
        participant[msg.sender].activity = Activity.Biking;
    }

    // Function to register a participant
    function participantRegistration(address _address, Activity _activity) external {
        require(participant[_address].activity == Activity(0), "Participant already registered");

        Participant memory newParticipant = Participant(allParticipants.length + 1, _address, _activity);
        allParticipants.push(newParticipant);
        participant[_address].activity = _activity;

        emit ParticipantRegistered(newParticipant.id, newParticipant.participantAddress, newParticipant.activity);
    }

    // Function to check if a participant is registered
    function signInParticipant(address _address) external view {
        require(participant[_address].activity != Activity(0), "You are not registered as a participant");
    }

    // Function to handle activity participation and earn points
    function activityParticipation(address _address, uint256 _value) external {
        require(participant[_address].activity != Activity(0), "Participant not registered");
        participant[_address].value += _value;

        emit ActivityParticipation(_address, _value);
    }

    // Function to select random winners
    function randomWinnerSelection() external pure returns (uint256) {
        // random winner selection logic
       
    }

    // Function to calculate airdrop rewards
    function airdropRewardCalculation(address _address) external view returns (uint256) {
        // Implement airdrop reward calculation logic based on participant's activity
        if (participant[_address].value <= 50) {
            return 50; // Reward 50 tokens
        } else {
            return 100; // Reward 100 tokens
        }
    }

    // Function to distribute ERC20 tokens as airdrop rewards
    function airdropTokenDistribution(address _tokenContract, address _participant, uint256 _amount) external {
        // token distribution
        TokenERC20 token = TokenERC20(_tokenContract);
        token.transfer(_participant, _amount);
    }

    // Function to request randomness from Chainlink VRF
    function requestRandomness() external {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK tokens");

        bytes32 requestId = requestRandomness(keyHash, fee);
        emit RandomnessRequested(requestId);
    }

    // Function to handle randomness received from Chainlink VRF
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
        emit RandomnessFulfilled(requestId, randomness);
    }
}


