pragma solidity ^0.4.17;

contract XOGameBoard{
    
    address internal player1; // игрок 1, он инициирует игру
    address internal player2; // игрок 2, он присоединяется к игре
    uint8[10] internal board; // игровая доска
    uint8 step; // текущий номер хода в игре
    uint8 chip;
    
    enum StatusGame{PLAYER1, PLAYER2}
    StatusGame statusGame;
    
    // модификатор прав владельуа контракта
    modifier isPlayer {
        require(player1 == msg.sender || player2 == msg.sender);
        _;
    }
    
    event RunPlayer(string _player);
    event Winnner(string _player, uint256 _balance);
    
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
    
    function checkWinner(uint8 pos) internal isPlayer returns(uint8){
        if(msg.sender == player1 && statusGame == StatusGame.PLAYER1){
            chip = 1;
            statusGame = StatusGame.PLAYER2;
            emit RunPlayer("Now step Player 2");
        }
        if(msg.sender == player2 && statusGame == StatusGame.PLAYER2){
            chip = 2;
            statusGame = StatusGame.PLAYER1;
            emit RunPlayer("Now step Player 1");
        }
        
        step++;
        board[pos - 1] = chip;
        if(step >= 5 && step < 9){
            if(pos == 1){ return cell1(chip); }
            if(pos == 2){ return cell2(chip); }
            if(pos == 3){ return cell3(chip); }
            if(pos == 4){ return cell4(chip); }
            if(pos == 5){ return cell5(chip); }
            if(pos == 6){ return cell6(chip); }
            if(pos == 7){ return cell7(chip); }
            if(pos == 8){ return cell8(chip); }
            if(pos == 9){ return cell9(chip); }
        }
        if(step == 9){ return 3; } else { return 0;}
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
        require(board[_pos] == 0);
        if(checkWinner(_pos) == 1){ // player1 winner
            emit Winnner("Winner Player 1", address(this).balance);
            selfdestruct(player1);
        }
        if(checkWinner(_pos) == 2){ // player2 winner
            emit Winnner("Winner Player 2", address(this).balance);
            selfdestruct(player2);
        }
        if(checkWinner(_pos) == 3){ // drawe
            emit Winnner("DRAWE ", address(this).balance / 2);
            player2.transfer(address(this).balance / 2);
            selfdestruct(player1);
        }
        if(checkWinner(_pos) == 0){ // 0
        }
    }
    
    ///////// 
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    
    function getOwner() public view returns(address, address){
        return (player1, player2);
    }
    
    function getBoard() public view returns(uint8[10]){
        return board;
    }
    
    function getBoardLength() public view returns(uint256){
        return board.length;
    }
}