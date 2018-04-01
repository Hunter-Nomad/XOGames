pragma solidity ^0.4.19;

contract XOGameBoard{
    
    uint8[9] private board; // игровая доска
    uint8 private step; // текущий номер хода в игре
    address private player1;
    address private player2;
    uint8 res;
     
    function XOGameBoard(address _player1) public {
        player1 = _player1;
        step = 0;
    }
  
    // 1 2 3 
    // 4 5 6 
    // 7 8 9 
    function move(uint8 pos, uint8 chip) public returns(uint8){
        step += 1;
        board[pos - 1] = chip;
        if(step >= 5 && step != 9){
            if(pos == 1){ return cell0(chip); }
            if(pos == 2){ return cell1(chip); }
            if(pos == 3){ return cell2(chip); }
            if(pos == 4){ return cell3(chip); }
            if(pos == 5){ return cell4(chip); }
            if(pos == 6){ return cell5(chip); }
            if(pos == 7){ return cell6(chip); }
            if(pos == 8){ return cell7(chip); }
            if(pos == 9){ return cell8(chip); }
        }
        if(step == 9){ return 3; } else { return 0;}
    }
     
    // 0 1 2 
    // 3 4 5
    // 6 7 8
    function cell0(uint8 move) private view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
    }
    function cell1(uint8 move) private view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
    }
    function cell2(uint8 move) private view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
    }
    function cell3(uint8 move) private view returns(uint8){
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
    }
    function cell4(uint8 move) private view returns(uint8){
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
    }
    function cell5(uint8 move) private view returns(uint8){
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
    }
    function cell6(uint8 move) private view returns(uint8){
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    function cell7(uint8 move) private view returns(uint8){
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    function cell8(uint8 move) private view returns(uint8){
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }

    function getBoard() public returns(uint8[9]){
        return board;
    }
 
    
   function kill(address killer) public {
       if(killer == player1){
            selfdestruct(player1);
       }
   }
}