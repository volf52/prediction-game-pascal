program print;
{
    @author     : Muhammad Arslan <rslnkrmt2552@gmail.com>
    @purpose    : The main game.
}
uses
    board, players;

var
    game_board  : matrix; 
    n, i : Integer;
    p1, p2 : Player;
begin

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
    p1.player_type := Human;
    writeln('---- For Player 1 ----');
    getDetails(0, p1);
    writeln;
    if (i = 1) then
        begin
            p2.player_type := Human;
            writeln('---- For Player 2 ----');
            getDetails(0, p2);
        end
    else
        begin
            p2.player_type := Computer;
            getDetails(1, p2);
        end;
    writeln;            
    i := 1;
    repeat
    writeln;
    writeln('         ==== Round ', i, '====');
    writeln;
    writeln;
    writeln(' ---- Board Condition ---- ');
    print_board(game_board, n, False);
    writeln;
    writeln(' --- For Player 1 ---');
    writeln;
    evaluate_turn(n, p1, game_board);
    writeln;
    writeln(' --- For Player 2 ---');
    writeln;
    writeln(' ---- Board Condition ---- ');
    print_board(game_board, n, False);
    writeln;
    writeln;
    evaluate_turn(n, p2, game_board);
    writeln;
    writeln(' --- Scores --- ');
    writeln;
    writeln(' Player 1 (', p1.player_name.firstname, ' ', p1.player_name.lastname, ') <-=-> ', p1.score);
    writeln(' Player 2 (', p2.player_name.firstname, ' ', p2.player_name.lastname, ') <-=-> ', p2.score);
    writeln;
    writeln;
    i := i + 1;
    until ((p1.score > (n*n) DIV 2) OR (p2.score > (n*n) DIV 4));

    writeln;
    writeln('             ======== End of Game Stats ========= ');
    writeln;
    writeln(' --- Scores --- ');
    writeln(' Player 1 (', p1.player_name.firstname, ' ', p1.player_name.lastname, ') <-=-> ', p1.score);
    writeln(' Player 2 (', p2.player_name.firstname, ' ', p2.player_name.lastname, ') <-=-> ', p2.score);
    writeln;
    if p1.score > p2.score then 
        writeln(' Player 1 wins.')
    else if p2.score > p1.score then 
         writeln(' Player 2 wins.')
    else 
        writeln(' Draw ');; 

    writeln(' ---- Game Board ---- ');
    print_board(game_board, n, True);
    writeln;
    write(' Press any key to exit ...');
    readln;
end.
