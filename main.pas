program print;
{
    @author     : Muhammad Arslan <rslnkrmt2552@gmail.com>
    @purpose    : The main game.
}
uses
    board;

var
    
    real_arr, game_arr  : matrix; 
    i, j, k, n : Integer;
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
    


    real_arr := gen_board(n, True);
    game_arr := gen_board(n, False);

    print_board(real_arr, n);

    writeln;
end.
