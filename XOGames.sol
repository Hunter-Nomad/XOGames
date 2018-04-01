pragma solidity ^0.4.19;

import "./XOGameBoard.sol";

contract XOGames{
    
    address owner; // владелец контракта
    address[] public gameBoards;
    uint8[9] board;
    uint public gameCount; // число активных игр
    uint256 commission = 5; // комиссия за использование платформы 5% ;-)
    
    // статусы игры
    enum StatusGame {
        GAME_OVER, // игра окончена
        GAME_EXPECTED, // игра готова к старту, ожидается второй игрок
        GAME_START // игра стартовала
    }
   
     // структура игрока
    struct Player{
        address player;
    }
    
    // структура игры
    struct Game{
        Player player1; // игрок 1, он инициирует игру
        Player player2; // игрок 2, он присоединяется к игре
        uint8 statusGame; // статус игры
        uint8 step;
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
    event Move(string msg);
    event MSG(string msg);
    event Win(string msg);
    
    
    // модификатор прав владельуа контракта
    modifier isOwner {
        require(owner == msg.sender);
        _;
    }
    
    // конструктор
    function XOGames() public {
        owner = msg.sender;
        gameCount = 0;
    }
    
    // инициализация/создание игры
    function createGame() public payable returns(XOGameBoard gameBoard){
        if(msg.value == 0){
            ErrorValue("'value' can not be zero", 0);
            return;
        }
        if(players[msg.sender] == 1){
            ErrorAddress("You have already created a game");
            return;
        }
        gameBoard = new XOGameBoard(msg.sender);
        gameBoards.push(gameBoard);
        players[msg.sender] = 1; // игрок готов к игре
        games[gameBoard].player1.player = msg.sender;
        games[gameBoard].step = 1;
        games[gameBoard].statusGame = uint8(StatusGame.GAME_EXPECTED); // статус игры "в ожитании"
        games[gameBoard].balance = msg.value; // запись ставки первого игрока
        CreateGame("New game create in address", gameBoard, "rate", msg.value);
        return gameBoard;
    }
    
    // присоединиться к игре второму игроку
    function joinToGame(XOGameBoard gameBoard) public payable{
        if(gameBoard == address(0x0)){
            ErrorAddress("Error game address!"); 
            // return;
            revert();
        }
        if(players[msg.sender] == 1){
            ErrorAddress("You have join to game");
            revert();
            // return;
        }
        if(msg.value != games[gameBoard].balance){
            ErrorValue("Invalid value. The value must be", games[gameBoard].balance);
            revert();
        }
        if(games[gameBoard].statusGame == uint8(StatusGame.GAME_EXPECTED)){
            players[msg.sender] = 1; // игрок готов к игре
            games[gameBoard].player2.player = msg.sender; 
            games[gameBoard].statusGame = uint8(StatusGame.GAME_START);
            games[gameBoard].balance += msg.value; // добавление ставки второго игрока
            JoinToGame("You join to game. Address", gameBoard, "rate", msg.value);
        } else {
            ErrorAddress("The game is started!"); 
        }
    }
    
    function move(uint8 _pos, XOGameBoard gameBoard) public{
        uint8 _player;
        uint8 status;
        uint256 money;
        
        if(gameBoard == address(0x0)){
            ErrorAddress("Error game address!");
            return;
        }
        if(games[gameBoard].player1.player == msg.sender && games[gameBoard].step == 1){
            _player = 1;
            games[gameBoard].step = 2;
            Move("Plaeyr 1 move");
        } else if(games[gameBoard].player2.player == msg.sender && games[gameBoard].step == 2){
            _player = 2;
            games[gameBoard].step = 1;
            Move("Plaeyr 2 move");
        }
        status = gameBoard.move(_pos, _player);
        
        if(gameBoard.move(_pos, _player) == 1){
            // оправка вознаграждения за вычетом комиссия
            money = games[gameBoard].balance - ((games[gameBoard].balance * commission) / 100);
            games[gameBoard].player1.player.transfer(money);
            players[games[gameBoard].player1.player] = 0;
            players[games[gameBoard].player2.player] = 0;
            gameBoards[uint256(gameBoard)] = 0x0;
            games[gameBoard].statusGame = uint8(StatusGame.GAME_OVER);
            gameBoard.kill(games[gameBoard].player1.player);
            Win("Player 1 is WIN!");
        }
        if(gameBoard.move(_pos, _player) == 2){
            // оправка вознаграждения за вычетом комиссия
            money = games[gameBoard].balance - ((games[gameBoard].balance * commission) / 100);
            games[gameBoard].player2.player.transfer(money);
            players[games[gameBoard].player1.player] = 0;
            players[games[gameBoard].player2.player] = 0;
            gameBoards[uint256(gameBoard)] = 0x0;
            games[gameBoard].statusGame = uint8(StatusGame.GAME_OVER);
            gameBoard.kill(games[gameBoard].player1.player);
            Win("Player 2 is WIN!");
        }
        if(gameBoard.move(_pos, _player) == 3){
            // оправка вознаграждения за вычетом комиссия
            money = games[gameBoard].balance - ((games[gameBoard].balance * commission) / 100);
            games[gameBoard].player1.player.transfer(money / 2);
            games[gameBoard].player2.player.transfer(money / 2);
            players[games[gameBoard].player1.player] = 0;
            players[games[gameBoard].player2.player] = 0;
            gameBoards[uint256(gameBoard)] = 0x0;
            games[gameBoard].statusGame = uint8(StatusGame.GAME_OVER);
            gameBoard.kill(games[gameBoard].player1.player);
            Win("In game is DRAW!");
        }
    }
    
    function getBoard(XOGameBoard gameBoard) public{
        board = gameBoard.getBoard();
        Board(board[0], board[1], board[2], board[3], (board[4]), board[5], board[6], (board[7]), board[8]);
    }
    
    function thisBalance() public returns(uint256){ 
        return this.balance;
    }
}
