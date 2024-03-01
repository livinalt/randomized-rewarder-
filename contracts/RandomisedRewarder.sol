// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import './RewardToken.sol';
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBase.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";



contract RandomisedRewarder is VRFConsumerBase {
    //from vrf
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    // Chainlink VRF Coordinator address and LINK token address
    address constant VRF_COORDINATOR = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    address constant LINK_TOKEN = 0x779877A7B0D9E8603169DdbD7836e478b4624789;

    bool isParticipant = true;
    address owner;

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
    constructor(address initialOwner, address tokenAddress) VRFConsumerBase(VRF_COORDINATOR, LINK_TOKEN) {
        keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c; 
        fee = 0.25 * 10 ** 18; 

    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function requestRandomness() public payable returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK tokens in contract");

        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
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
    function randomWinnerSelection() external onlyOwner {
        // Ensure there are participants registered
        require(allParticipants.length > 0, "No participants registered"); 
        requestRandomness(); // from VRF
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
        RewardToken token = RewardToken(_tokenContract);
        token.transfer(_participant, _amount);
    }

    
}


