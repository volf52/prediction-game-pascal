program main;
{
    @author     : Muhammad Arslan <rslnkrmt2552@gmail.com>
    @purpose    : The main game.
}
uses
    board, players, crt;

type
    player_array = array[1..2] of Player;

procedure print_scores(players : player_array);
begin
    writeln;
    writeln(' Player 1 (', players[1].player_name.firstname, ' ', players[1].player_name.lastname, ') |=| ', players[1].score);
    writeln(' Player 2 (', players[2].player_name.firstname, ' ', players[2].player_name.lastname, ') |=| ', players[2].score);
    writeln;
end;

procedure printCurrentState(board : matrix; players : player_array; n, round_i, current_player : Integer);
begin
    ClrScr;
    writeln('         ==== Round ', round_i , ' ====');
    writeln;
    writeln;
    writeln(' ---- Board Condition ---- ');
    print_board(board, n, False);
    writeln;
    writeln(' --- Scores --- ');
    print_scores(players);
    writeln;
    writeln(' --- For Player ', current_player, ' ---');
    writeln;
end;


var
    game_board  : matrix; 
    n, i, j, x1, x2, y1, y2 : Integer;
    p : player_array;
    correct_prediction : Boolean;
begin
    x1 := 0;
    y1 := 0;
    x2 := 0;
    y2 := 0;

    {Getting the input}
    repeat
        writeln('Which board do you want to initialize:');
        writeln;
        writeln('--  6  x 6');
        writeln('--  8  x 8');
        writeln('--  10 x 10');
        writeln;
        write('(6, 8 or 10) -> ');
        readln(n);
        writeln;
    until n in [6, 8, 10];

    writeln('Generating Board...');
    game_board := gen_board(n);
    repeat
        writeln;
        writeln('1- Human vs Human.');
        writeln('2- Human vs Computer.');
        write('--> ');
        readln(i);
    until (i in [1, 2]);
    writeln;
    p[1].player_type := Human;
    writeln('---- For Player 1 ----');
    getDetails(0, p[1]);
    writeln;
    if (i = 1) then
        begin
            p[2].player_type := Human;
            writeln('---- For Player 2 ----');
            getDetails(0, p[2]);
        end
    else
        begin
            p[2].player_type := Computer;
            getDetails(1, p[2]);
        end;
    writeln;            
    i := 1;
    repeat
       for j := 1 to 2 do
        begin
        repeat
            printCurrentState(game_board, p, n, i, j);
            evaluate_turn(n, 1, p[j], game_board, x1, y1);
            game_board[x1-1, y1-1].status := highlighted;
            printCurrentState(game_board, p, n, i, j);
            game_board[x1-1, y1-1].status := hidden;
            evaluate_turn(n, 2, p[j], game_board, x2, y2);
            game_board[x2-1, y2-1].status := highlighted;
            printCurrentState(game_board, p, n, i, j);
            game_board[x2-1, y2-1].status := hidden;
            correct_prediction := (game_board[x1-1, y1-1].val = game_board[x2-1, y2-1].val);
            if correct_prediction then
                begin
                    writeln;
                    writeln(' Congrats for the correct prediction...');
                    Writeln('Enter the next one.');
                    game_board[x1-1, y1-1].status := clear;
                    game_board[x2-1, y2-1].status := clear;
                    p[j].score := p[j].score + 1;
                end
            else
                writeln(' Wrong prediction.');
        until (not correct_prediction);
            writeln;
            writeln('Wait for the turn to change ... ');
            Delay(5000);
        end;
        i := i + 1;
    until ((p[1].score > (n*n) DIV 4) OR (p[2].score > (n*n) DIV 4));

    writeln;
    writeln('             ======== End of Game Stats ========= ');
    print_scores(p);
    if p[1].score > p[2].score then 
        writeln(' Player 1 wins.')
    else if p[2].score > p[1].score then 
         writeln(' Player 2 wins.')
    else 
        writeln(' Draw ');
    writeln;
    writeln(' ---- Game Board ---- ');
    print_board(game_board, n, True);
    writeln;
    write(' Press any key to exit ...');
    readln;
end.
