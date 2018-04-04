pragma solidity ^0.4.17;

contract XOGameBoard{
    
    address internal player1; // игрок 1, он инициирует игру
    address internal player2; // игрок 2, он присоединяется к игре
    uint8[9] internal board; // игровая доска
    uint8 step; // текущий номер хода в игре
    uint8 chip;
    
    // enum StatusGame{PLAYER1, PLAYER2, PLAYER1_WIN, PLAYER2_WIN, GAME_DRAW}
    enum StatusGame{PLAYER1, PLAYER2}
    StatusGame statusGame;
    
    // модификатор прав владельуа контракта
    modifier isPlayer {
        require(player1 == msg.sender || player2 == msg.sender);
        _;
    }
    
    event Pos(uint8 pos);
    event Info(string _string, uint _uint);
    
    function XOGameBoard(address player) public payable{
        player1 = player;
        step = 0;
        statusGame = StatusGame.PLAYER1;
    }
    
    function setRate(address player) external payable{
        player2 = player;
    }
    
    ////////////// 
    // 1 2 3 
    // 4 5 6 
    // 7 8 9
    
    function checkWinner(uint8 pos) public isPlayer returns(uint8){
        
        if(msg.sender == player1){
            chip = 1;
            // statusGame = StatusGame.PLAYER2;
        }
        if(msg.sender == player2){
            chip = 2;
            // statusGame = StatusGame.PLAYER1;
        }
        
        Info("pos", pos);
        Info("chip", chip);
        
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
    function cell0(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
    }
    function cell1(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
    }
    function cell2(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[1] == move && board[2] == move){return move;}
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
    }
    function cell3(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
    }
    function cell4(uint8 move) internal view returns(uint8){
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
    }
    function cell5(uint8 move) internal view returns(uint8){
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[3] == move && board[4] == move && board[5] == move){return move;}
    }
    function cell6(uint8 move) internal view returns(uint8){
        if(board[0] == move && board[3] == move && board[6] == move){return move;}
        if(board[2] == move && board[4] == move && board[6] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    function cell7(uint8 move) internal view returns(uint8){
        if(board[1] == move && board[4] == move && board[7] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }
    function cell8(uint8 move) private view returns(uint8){
        if(board[2] == move && board[5] == move && board[8] == move){return move;}
        if(board[0] == move && board[4] == move && board[8] == move){return move;}
        if(board[6] == move && board[7] == move && board[8] == move){return move;}
    }

    function move(uint8 pos) public{
        if(checkWinner(pos) == 1){ // player1 winner
            selfdestruct(player1);
        }
        if(checkWinner(pos) == 2){ // player2 winner
            selfdestruct(player2);
        }
        if(checkWinner(pos) == 3){ // drawe
            player2.transfer(address(this).balance / 2);
            selfdestruct(player1);
        }
        if(checkWinner(pos) == 0){ // 0
        }
    }
    
    
    ///////// 
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    
    function getOwner() public view returns(address, address){
        return (player1, player2);
    }
    
    function getBoard() public view returns(uint8[9]){
        return board;
    }
    
}