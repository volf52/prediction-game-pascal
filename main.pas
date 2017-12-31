program main;
{
    @author     : Muhammad Arslan <rslnkrmt2552@gmail.com>
    @purpose    : The main game.
}
uses
    board, players, crt;

type
    player_array = array[1..2] of Player;

procedure print_scores(players : player_array); {Prints the scores. Can be made more scalable by using an array to loop through the players.}
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
    availableCells : statusTracker; 
    n, i, j, x1, y1, x2, y2  : Integer;
    h_coord, bot_coord : coordinate_array;
    p : player_array;
    correct_prediction, end_game : Boolean;
begin

    end_game := False;
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
    game_board := gen_board(n, availableCells);
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
       for j := 1 to 2 do {Player turns}
            begin
                correct_prediction := False;
                repeat {repeat until a player makes a wrong prediction}
                    printCurrentState(game_board, p, n, i, j);
                    if (p[j].player_type = Human) then
                        begin
                            repeat 
                                h_coord[1] := 0;
                                h_coord[2] := 0;
                                h_coord[3] := 0;
                                h_coord[4] := 0;
                                evaluate_human_turn(n, 1, game_board, h_coord[1], h_coord[2]);
                                game_board[h_coord[1]-1, h_coord[2]-1].status := highlighted; {Highlight the cell to let know the value of  selected cell}
                                printCurrentState(game_board, p, n, i, j);
                                game_board[h_coord[1]-1, h_coord[2]-1].status := hidden;     {Hide the cell again}
                                evaluate_human_turn(n, 2, game_board, h_coord[3], h_coord[4]);  
                                game_board[h_coord[3]-1, h_coord[4]-1].status := highlighted;
                                printCurrentState(game_board, p, n, i, j);
                                game_board[h_coord[3]-1, h_coord[4]-1].status := hidden;
                            until ( not ((h_coord[1] = h_coord[3]) AND (h_coord[2] = h_coord[4])));  {To ensure both entered cells are different}
                            correct_prediction := (game_board[h_coord[1]-1, h_coord[2]-1].val = game_board[h_coord[3]-1, h_coord[4]-1].val); {Correct prediction if symbols are same}
                        end
                    else
                        begin
                            clean_memory(game_board, p[j]); {Clear any cells from board which have been selected and cleared, to avoid making false prediction}
                            bot_coord := evaluate_bot_turn(correct_prediction, n, game_board, availableCells, p[j]);
                            game_board[bot_coord[1]-1, bot_coord[2]-1].status := highlighted;
                            printCurrentState(game_board, p, n, i, j); 
                            game_board[bot_coord[1]-1, bot_coord[2]-1].status := hidden;
                            writeln('Computer has made the prediction:');
                            writeln;
                            writeln('X = ', bot_coord[1]);
                            writeln('Y = ', bot_coord[2]);
                            delay(3000); {To let the human player know which cell was selected by the BOT}
                            game_board[bot_coord[3]-1, bot_coord[4]-1].status := highlighted;
                            printCurrentState(game_board, p, n, i, j);
                            game_board[bot_coord[3]-1, bot_coord[4]-1].status := hidden;
                            writeln('Computer has made the prediction:');
                            writeln;
                            writeln('X = ', bot_coord[3]);
                            writeln('Y = ', bot_coord[4]);
                            writeln;
                            correct_prediction := (game_board[bot_coord[1]-1, bot_coord[2]-1].val = game_board[bot_coord[3]-1, bot_coord[4]-1].val);
                        end;

                    
                    if correct_prediction then
                        begin
                            writeln;
                            writeln(' Correct prediction...');
                            writeln;
                            Writeln('Won the chance for one more...');
                            if (p[j].player_type = Human) then
                                begin
                                    x1 := h_coord[1];
                                    y1 := h_coord[2];
                                    x2 := h_coord[3];
                                    y2 := h_coord[4];
                                end
                            else
                                begin
                                    x1 := bot_coord[1];
                                    y1 := bot_coord[2];
                                    x2 := bot_coord[3];
                                    y2 := bot_coord[4];
                                end;
                                {The logic after this is to ensure that the cells are not available for further use by any other players, especially BOTS}
                            game_board[x1-1, y1-1].status := clear;
                            game_board[x1-1, y1-1].in_memory := False;
                            game_board[x2-1, y2-1].status := clear;       
                            game_board[x2-1, y2-1].in_memory := False;
                            popCell( ((x1-1)*n) + (y1-1), availableCells);
                            popCell( ((x2-1)*n) + (y2-1), availableCells);
                            p[j].score := p[j].score + 1;
                            end_game := (p[1].score >= (n*n) DIV 4) OR (p[2].score >= (n*n) DIV 4); {Game ends when score goes equal to or more than half the pairs of symbols}
                            delay(5000); {Delay of 5 seconds between one correct prediction and the next one}
                        end
                    else
                        writeln(' Wrong prediction.');
                until ( (not correct_prediction) OR end_game);
                    writeln;
                    writeln('Wait for the turn to change ... ');
                    Delay(7000);
            end;
        i := i + 1;
    until (end_game); {Game ends when any }

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
