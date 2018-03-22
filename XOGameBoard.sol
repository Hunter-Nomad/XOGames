pragma solidity ^0.4.19;

contract XOGameBoard{
    
    uint8[9] private board; // игровая доска
    uint8 private step; // текущий номер хода в игре
    uint8 res;
     
    function XOGameBoard() public {
        step = 0;
    }
  
    function move(uint8 x, uint8 y, uint8 chip) public returns(uint8){
        step += 1;
        if(x == 1 && y == 1){ 
            board[0] = chip;
            if(step >= 5){ return cell0(chip); }
        }
        if(x == 1 && y == 2){ 
            board[1] = chip;
            if(step >= 5){ return cell1(chip); }
        }
        if(x == 1 && y == 3){ 
            board[2] = chip;
            if(step >= 5){ return cell2(chip); }
        }
        if(x == 2 && y == 1){ 
            board[3] = chip;
            if(step >= 5){ return cell3(chip); }
        }
        if(x == 2 && y == 2){ 
            board[4] = chip;
            if(step >= 5){ return cell4(chip); }
        }
        if(x == 2 && y == 3){ 
            board[5] = chip;
            if(step >= 5){ return cell5(chip); }
        }
        if(x == 3 && y == 1){ 
            board[6] = chip;
            if(step >= 5){ return cell6(chip); }
        }
        if(x == 3 && y == 2){ 
            board[7] = chip;
            if(step >= 5){ return cell7(chip); }
        }
        if(x == 3 && y == 3){ 
            board[8] = chip;
            if(step >= 5){ return cell8(chip); }
        }
        if(step == 9){ return 3; } else { return 0;}
    }
     
  
    // 0 1 2 
    // 3 4 5
    // 6 7 8
    
    function cell0(uint8 move) public view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
    }
    function cell1(uint8 move) public view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
    }
    function cell2(uint8 move) public view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
    }
    function cell3(uint8 move) public view returns(uint8){
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
    }
    function cell4(uint8 move) public view returns(uint8){
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
    }
    function cell5(uint8 move) public view returns(uint8){
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
    }
    function cell6(uint8 move) public view returns(uint8){
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    function cell7(uint8 move) public view returns(uint8){
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    function cell8(uint8 move) public view returns(uint8){
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    
   /* 
    
    // function getBoard() public returns(uint8[9]){
    //     return board;
    // }
    */
}