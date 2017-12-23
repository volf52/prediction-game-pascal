program print;
{
    @author     : Muhammad Arslan <rslnkrmt2552@gmail.com>
    @purpose    : The main game.
}
uses
    board;

var
    
    game_board  : matrix; 
    n : Integer;
    reveal : Boolean;
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
    
    reveal := False;

    game_board := gen_board(n);
    game_board[3,4].status := clear;
    print_board(game_board, n, reveal);
    writeln('-------------------------------------------------------');
end.
