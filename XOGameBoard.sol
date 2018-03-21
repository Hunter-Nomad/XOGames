pragma solidity ^0.4.19;

contract XOGameBoard{
    
    uint8[9] private board; // игровая доска
    uint8 private step; // текущий номер хода в игре
    address player1;
    address player2;
    uint8 res;
     
    function XOGameBoard(address _player1) public {
        player1 = _player1;
        step = 0;
    }
  
    function joinPlayer(address _player2) public{
        player2 = _player2;
    }
  
    function move(uint8 x, uint8 y, uint8 chip) public{
        step += 1;
        if(x == 1 && y == 1){ board[0] = chip;}
        if(x == 1 && y == 2){ board[1] = chip;}
        if(x == 1 && y == 3){ board[2] = chip;}
        if(x == 2 && y == 1){ board[3] = chip;}
        if(x == 2 && y == 2){ board[4] = chip;}
        if(x == 2 && y == 3){ board[5] = chip;}
        if(x == 3 && y == 1){ board[6] = chip;}
        if(x == 3 && y == 2){ board[7] = chip;}
        if(x == 3 && y == 3){ board[8] = chip;}
        
       
        // res = checkBoard();
    }
     
  
    // 0 1 2 
    // 3 4 5
    // 6 7 8
    
    function winPlayer1() public view returns(uint8){
        if(board[0] == 1 && board[1] == 1 && board[2] == 1){return 1;}
        if(board[3] == 1 && board[4] == 1 && board[5] == 1){return 1;}
        if(board[6] == 1 && board[7] == 1 && board[8] == 1){return 1;}
        if(board[0] == 1 && board[3] == 1 && board[6] == 1){return 1;}
        if(board[1] == 1 && board[4] == 1 && board[7] == 1){return 1;}
        if(board[2] == 1 && board[5] == 1 && board[8] == 1){return 1;}
        if(board[0] == 1 && board[4] == 1 && board[8] == 1){return 1;}
        if(board[2] == 1 && board[4] == 1 && board[6] == 1){return 1;}
    }
    
    function winPlayer2() public view returns(uint8){
        if(board[0] == 2 && board[1] == 2 && board[2] == 2){return 2;}
        if(board[3] == 2 && board[4] == 2 && board[5] == 2){return 2;}
        if(board[6] == 2 && board[7] == 2 && board[8] == 2){return 2;}
        if(board[0] == 2 && board[3] == 2 && board[6] == 2){return 2;}
        if(board[1] == 2 && board[4] == 2 && board[7] == 2){return 2;}
        if(board[2] == 2 && board[5] == 2 && board[8] == 2){return 2;}
        if(board[0] == 2 && board[4] == 2 && board[8] == 2){return 2;}
        if(board[2] == 2 && board[4] == 2 && board[6] == 2){return 2;}
    }
    
    function checkBoard() public view returns(uint8){
        if(winPlayer1() == 1){ return 1;}
        if(winPlayer2() == 2){ return 2;}
        if(step == 9){
            return 3;
        } else {
            return 0;
        }
    }
     /*
    function getBoard() public returns(uint8[9]){
        return board;
    }
    */
}