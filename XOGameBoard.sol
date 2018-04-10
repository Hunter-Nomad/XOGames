pragma solidity ^0.4.17;

contract XOGameBoard{
    
    address internal player1; // игрок 1, он инициирует игру
    address internal player2; // игрок 2, он присоединяется к игре
    uint8[9] internal board; // игровая доска
    uint8 internal step; // текущий номер хода в игре
    uint8 internal chip;
    
    enum StatusGame{PLAYER1, PLAYER2}
    StatusGame statusGame;
    
    // модификатор прав владельуа контракта
    modifier isPlayer {
        require(player1 == msg.sender || player2 == msg.sender);
        _;
    }
    
    event RunPlayer(string _player);
    event Winner(string _player);
    
    function XOGameBoard(address player) public payable{
        player1 = player;
        step = 0;
        statusGame = StatusGame.PLAYER1;
    }
    
    function setRate(address player) external payable{
        player2 = player;
    }
    
    // Game Board //
    // 1 2 3 
    // 4 5 6 
    // 7 8 9 
    
    // Check who winner in game
    function checkWinner(uint8 pos) internal isPlayer returns(uint8){
        uint8 _pos;
        if(msg.sender == player1 && statusGame == StatusGame.PLAYER1){
            chip = 1;
            statusGame = StatusGame.PLAYER2;
            emit RunPlayer("Next step Player 2");
        }
        if(msg.sender == player2 && statusGame == StatusGame.PLAYER2){
            chip = 2;
            statusGame = StatusGame.PLAYER1;
            emit RunPlayer("Next step Player 1");
        }
        
        _pos = pos - 1;
        board[_pos] = chip;
        if(step == 5 && step < 9){
            if(_pos == 0){ return cell1(chip); }
            if(_pos == 1){ return cell2(chip); }
            if(_pos == 2){ return cell3(chip); }
            if(_pos == 3){ return cell4(chip); }
            if(_pos == 4){ return cell5(chip); }
            if(_pos == 5){ return cell6(chip); }
            if(_pos == 6){ return cell7(chip); }
            if(_pos == 7){ return cell8(chip); }
            if(_pos == 8){ return cell9(chip); }
        }
        if(step == 9){ return 3; }
    }
    

    function cell1(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
    }
    function cell2(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
    }
    function cell3(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
    }
    function cell4(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
    }
    function cell5(uint8 move) internal view returns(uint8){
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
    }
    function cell6(uint8 move) internal view returns(uint8){
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
    }
    function cell7(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    function cell8(uint8 move) internal view returns(uint8){
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    function cell9(uint8 move) private view returns(uint8){
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }

    function move(uint8 _pos) public isPlayer{
        step++;
        if(checkWinner(_pos) == 1){ // player1 winner
            emit Winner("Winner Player 1");
            selfdestruct(player1);
        }
        if(checkWinner(_pos) == 2){ // player2 winner
            emit Winner("Winner Player 2");
            selfdestruct(player2);
        }
        if(checkWinner(_pos) == 3){ // drawe
            emit Winner("DRAWE");
            player2.transfer(address(this).balance / 2);
            selfdestruct(player1);
        }
    }
    
    // emulation of the 3x3 game board
    function move3x3(uint8 row, uint8 col) public isPlayer{
        require(row <=3 || col <= 3);
        if(row == 0){
            if(col == 0) move(1);
            if(col == 1) move(2);
            if(col == 2) move(3);
        }
        if(row == 1){
            if(col == 0) move(4);
            if(col == 1) move(5);
            if(col == 2) move(6);
        }
        if(row == 3){
            if(col == 0) move(7);
            if(col == 1) move(8);
            if(col == 2) move(9);
        }
    }
    
    // return gameboard
    function getBoard() public view isPlayer returns(uint8[9]){
        return board;
    }
}