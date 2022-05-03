// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

error Raffle__SendMoreToEnterRaffle();
error Raffle__RaffleNotOpen();

contract Raffle {
    enum RaffleState {
        Open,
        Calculating
    }

    RaffleState public s_raffleState;
    uint256 public immutable i_entranceFee;
    uint256 public immutable i_interval;
    uint256 public s_lastTimestamp;
    address payable[] public s_players;

    event RaffleEnter(address indexed player);

    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimestamp = block.timestamp;
    }

    function enterRaffle() external payable {
        if(msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }

        if(s_raffleState != RaffleState.Open) {
            revert Raffle__RaffleNotOpen();
        }

        s_players.push(payable(msg.sender));
        emit RaffleEnter(msg.sender);
    }

    function checkUpkeep(
        bytes memory /* checkData */
    ) 
        public 
        view 
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        bool isOpen = RaffleState.Open == s_raffleState;
        bool timePassed = ((block.timestamp - s_lastTimestamp) > i_interval);
        bool hasBalance = address(this).balance > 0;
        upkeepNeeded = (timePassed && isOpen && hasBalance);
        return (upkeepNeeded, "0x0");
    }
}