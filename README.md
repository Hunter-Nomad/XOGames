# XOGames/Tic Tac Toe on Solidity

</br>
<h3><b>Набросок README</b></h3>
<b>Start:</b> git clone https://github.com/Hunter-Nomad/XOGames.git
<p>
Этапы разворачивания:</br>
1. Деплойд контрактов</br>
2. Первый игрок, в контракте XOGames, создает игравой контракт XOGameBoard через <i>createGame</i> отправляя на него wei </br>
3. При создании контракта <i>createGame</i> в event виден адрес XOGameBoard</br>
4. Второй игрок подключается к созданному контракту через <i>joinToGame</i> указывая его адрес, одновременно отправляя wei в том же размере, что и первый игрок.</br>
5. Игроки вызывают у себя контракт и делают по очереди ходы через <i>move</i>, указывая номер клетки.</br>
Клетки:</br>
1 2 3</br>
4 5 6</br>
7 8 9</br>
</br>
Весь баланс отправляется выигравшему игроку. В случае ничьи, баланс делится между играками.
</br>

<b><i>За использование платформы XOGames игры взымается комиссия 5% ))))))))</i></b>
</p>
<h3><b>P.S. Описание функций контрактов</b></h3></br></br>
<h4><b>XOGames</b></h4></br>
<p>
	<b>createGame</b> - Создание контракта-игры XOGameBoard. При создании XOGameBoard первый игрок отправляет некое количество wei на баланс игры. После создания XOGameBoard выводится event GameWait с указанием адреса и ставки созданной игры; </br>
	<b>joinToGame</b> - Присоединение второго игрока к созданному контракту-игры XOGameBoard. При присоединении к XOGameBoard второй игрок отправляет столько же wei на баланс игры, сколько и первый игрок. После присоединения второго игрока к XOGameBoard, данные по игре удаляются из XOGames; </br>	
	<b>setCommission</b> - Изменение, от имени владельца контракта XOGames, комиссии за использование игры. Комиссия устанавливается в процентах; </br>
	<b>sendBalance</b> - Пересылка баланса контракта XOGames, от имени владельца контракта XOGames, на указанный адрес; </br>
	<b>kill</b> - Уничтожение контракта XOGames, от имени владельца контракта XOGames;</br>
</p></br>
<h4><b>XOGameBoard</b></h4></br>
<p>
	<b>move</b> - Поочередный ввод позиции игрока (от 1 до 9) на игровом поле; </br>
	<b>move3x3</b> - Эмуляция игрового поля 3х3. Поочередный ввод позиции игрока (по горизонтали от 1 до 3 и по вертикали от 1 до 3) на игровом поле; </br>	
	<b>getBoard</b> - Возвращает состояние игрового поля; </br>
	<b>sendBalance</b> - Пересылка баланса контракта XOGames, от имени владельца контракта XOGames, на указанный адрес; </br>
	<b>kill</b> - Уничтожение контракта XOGames, от имени владельца контракта XOGames;</br>
</p>