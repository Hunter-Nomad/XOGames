pragma solidity ^0.4.15;

import "./XOGameBoard.sol";

contract XOGames{
    
    address owner; // владелец контракта
    address[] public gameBoards;
    uint8[9] board;
    byte O; // фишка "нолик"
    byte X; // фишка "крестик"
    uint8 stepEnd = 9; // последний ход в игре //??????
    uint public gameCount; // число активных игр
    
    // статусы игры
    enum StatusGame {
        GAME_OVER, // игра окончена
        GAME_EXPECTED, // игра готова к старту, ожидается второй игрок
        GAME_START, // игра стартовала
        PLAYER1_MOVE, // ход первого игрока
        PLAYER2_MOVE, // ход второго игрока
        PLAYER1_WIN, // выйграл первый игрок
        PLAYER2_WIN, // выйграл второй игрок
        PLAYERS_DRAW // ничья
    }
    // StatusGame statusGame;
    StatusGame constant defaultStatusGame = StatusGame.GAME_EXPECTED; // статус по умолчанию
    
     // структура игрока
    struct Player{
        address player;
        byte chip; // "X" или "0"
    }
    
    // структура игры
    struct Game{
        // address gameBoard;
        Player player1; // игрок 1, он инициирует игру
        Player player2; // игрок 2, он присоединяется к игре
        uint8 statusGame; // статус игры
        uint256 balance; // баланс игры
    }
    
    mapping(address => uint) players; // игроки
    mapping(address => Game) games; // игры
    
    // errors event
    event ErrorMSG(string err);
    event ErrorAddress(string err);
    event ErrorValue(string err, uint value);
    
    // event
    event CreateGame(string str, address _address, string rate, uint _value);
    event JoinToGame(string str, address _address, string rate, uint _value);
    event Board(uint8 l1, uint8 l2, uint8 l3, uint8 l4, uint8 l5, uint8 l6, uint8 l7, uint8 l8, uint8 l9);
    event CheckBoard(uint8 u);
    
    // модификатор прав владельуа контракта
    modifier isOwner {
        require(owner == msg.sender);
        _;
    }
    
    // конструктор
    function XOGames() public {
        owner = msg.sender;
        gameCount = 0;
        X = "X"; // 0x58
        O = "O"; // 0x4f
    }
    
    // инициализация/создание игры
    function createGame() public payable returns(XOGameBoard gameBoard){
        if(msg.value == 0){
            emit ErrorValue("'value' can not be zero", 0);
            return;
        }
        if(players[msg.sender] == 1){
            emit ErrorAddress("You have already created a game");
            return;
        }
        gameBoard = new XOGameBoard(msg.sender);
        gameBoards.push(gameBoard);
        players[msg.sender] = 1;
        games[gameBoard].player1.player = msg.sender;
        // games[gameBoard].player1.chip = X;
        games[gameBoard].statusGame = uint8(defaultStatusGame);
        games[gameBoard].balance = msg.value;
        emit CreateGame("New game create in address", gameBoard, "rate", msg.value);
        return gameBoard;
    }
    
    function joinToGame(XOGameBoard gameBoard) public payable{
        if(gameBoard == address(0x0)){
            emit ErrorAddress("Error game address!"); 
            // return;
            revert();
        }
        if(msg.value != games[gameBoard].balance){
            emit ErrorValue("Invalid value. The value must be", games[gameBoard].balance);
            revert();
        }
        if(games[gameBoard].statusGame == uint8(defaultStatusGame)){
            players[msg.sender] = 1;
            games[gameBoard].player2.player = msg.sender; 
            // games[gameAddress].player2.chip = O;
            games[gameBoard].statusGame = uint8(StatusGame.GAME_START);
            games[gameBoard].balance += msg.value;
            gameBoard.joinPlayer(msg.sender);
            emit JoinToGame("You join to game. Address", gameBoard, "rate", msg.value);
        } else {
            emit ErrorAddress("The game is started!"); 
        }
    }
    
    function move(XOGameBoard gameBoard, uint8 x, uint8 y) public{
        gameBoard.move(x, y, 1);
    }
    
    function getBoard(XOGameBoard gameBoard) public{
        board = gameBoard.getBoard();
        emit Board(board[0], board[1], board[2], board[3], (board[4]), board[5], board[6], (board[7]), board[8]);
        // emit Board(board[3], (board[4]), board[5]);
        // emit Board(board[6], (board[7]), board[8]);
    }
    
    function getCheckBoard(XOGameBoard gameBoard) public{
        CheckBoard(gameBoard.checkBoard());
    }
    
}