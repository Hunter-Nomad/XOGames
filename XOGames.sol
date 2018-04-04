pragma solidity ^0.4.17;

import "./XOGameBoard.sol";

contract XOGames{
    address owner; // владелец контракта
    uint256 commission = 5; // комиссия за использование платформы 5% ;-)
    
    
    // статусы игры
    enum StatusGame {
        GAME_EXPECTED, // игра готова к старту, ожидается второй игрок
        GAME_START // игра стартовала
    }
    
    // структура игры
    struct Game{
        address player1; // игрок 1, он инициирует игру
        address player2; // игрок 2, он присоединяется к игре
        uint256 rate;
        StatusGame statusGame; // статус игры
    }
    
    mapping(address => Game) public games; // игры
    
    // модификатор прав владельуа контракта
    modifier isOwner {
        require(owner == msg.sender);
        _;
    }
    
    event Info(address _info);
    
    function XOGames() public {
        owner = msg.sender;
    }
    
    function createGame() public payable returns(XOGameBoard gameBoard){
        require(msg.value != 0);
        gameBoard = (new XOGameBoard).value((msg.value - (msg.value * commission / 100)))(msg.sender);
        games[gameBoard].player1 = msg.sender;
        games[gameBoard].statusGame = StatusGame.GAME_EXPECTED;
        games[gameBoard].rate = msg.value;
        // gamesExpected.push(gameBoard);
        // rateInGames.push(msg.value);
        Info(gameBoard);
        return gameBoard;
    }
    
    function joinToGame(XOGameBoard gameBoard) public payable returns(bool){
        require(games[gameBoard].statusGame != StatusGame.GAME_START);
        require(msg.value != 0);
        require(games[gameBoard].rate == msg.value);
        games[gameBoard].player2 = msg.sender;
        games[gameBoard].statusGame = StatusGame.GAME_START;
        gameBoard.setRate.value((msg.value - (msg.value * commission / 100)))(msg.sender);
    }
    
    function getThisBalance() public view returns(uint256){
        return address(this).balance;
    }
    
    // уничтожение контракта
    function kill() public isOwner {
        selfdestruct(owner);
    }
}