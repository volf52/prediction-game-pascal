unit board;

{
	@author 	: Muhammad Arslan <rslnkrmt2552@gmail.com>
	@purpose 	: Board operations for a simple Prediction game.
}

interface

	const
		max = 10;

    type
	    matrix = array of array of Integer;
	    intSet = set of 1..100;
	    tmparr = array[1.. (max*max)] of integer;
           
    

    procedure print_board(board : matrix; n : integer);
    function gen_board(n : Integer; is_real: Boolean) : matrix;



implementation
	
	procedure print_board(board : matrix; n : integer) ;
	var
	    i, j : Integer;
	begin
		writeln;
	    for i := low(board) to high(board) do write('  - ');
	    writeln;
	    for i := low(board) to high(board) do
	        begin
	            for j := low(board[i]) to high(board[i]) do
	                case board[i, j] of
	                    -7 : write('|   ');
	                    -5 : write('| * ');
	                    else write('|',board[i, j]:2, ' ');
	                end;
	            write('|');
	            writeln;
	            for j := low(board[i]) to high(board[i]) do write('  - ');
	            writeln;
	        end;
	    writeln;
	end;


	function gen_board(n : Integer; is_real: Boolean) : matrix;
	var
	    i, j, k,l,  tmp : Integer;
	    board : matrix;
	    tmpSet : intSet;
	    arr : tmparr;
	begin

		if is_real then
			begin
				
			    randomize;
			    tmpSet := [];
			    setLength(board, n, n);
			    i := 0;
			    repeat
			            j := random(100);
			            if not (j in tmpSet) then
			                begin
			                include(tmpSet, j);
			                i := i + 1;    
			                end;
			        until (i = ((n*n) div 2));

			    i := 1;
			    for tmp in tmpSet do
			        begin
			            arr[2*(i-1) + 1] := tmp;
			            arr[2*(i-1) + 2] := tmp;
			            i := i + 1;
			        end;

			    for l := 1 to 100 do
			        begin
			                randseed := arr[1];
			                for i := 1 to (n*n) do
			                    begin
			                        j := random( (n*n) - 1) + 1;
			                        k := random( (n*n) - 1) + 1;

			                        tmp    := arr[j];
			                        arr[j] := arr[k];
			                        arr[k] := tmp;
			                    end;
			        end;
			    
			    for i := low(board) to high(board) do
			        for j := low(board[i]) to high(board[i]) do
			            board[i, j] := arr[ (i * (n)) + j + 1];

			        gen_board := board;

			end
		else
			begin

				setLength(board, n, n);
				for i := low(board) to high(board) do
					for j := low(board[i]) to high(board[i]) do
						board[i, j] := -5;

				gen_board := board;
			end;	       
	
	end;


end.