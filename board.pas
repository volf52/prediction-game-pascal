unit board;

{
	@author 	: Muhammad Arslan <rslnkrmt2552@gmail.com>
	@purpose 	: Board operations for a simple Prediction game.
}

interface

	const
		max = 10;

    type
    	cell = record
    		val : Integer;
    		status : (highlighted, clear, hidden);
    	end;
	    matrix = array of array of cell;
	    intSet = set of 1..100;
	    tmparr = array[1.. (max*max)] of integer;
           
    

    procedure print_board(board : matrix; n : integer; reveal : Boolean);
    function gen_board(n : Integer) : matrix;



implementation
	
	procedure print_board(board : matrix; n : integer; reveal: Boolean) ;
	var
	    i, j : Integer;
	begin
		writeln;
	    for i := low(board) to high(board) do write('  - ');
	    writeln;
	    for i := low(board) to high(board) do
	        begin
	            for j := low(board[i]) to high(board[i]) do
	            	begin
	            		if reveal then write('|',board[i, j].val:2, ' ')
	            		else
	            		begin
			                case board[i, j].status of
			                    clear       : write('|   ');
			                    hidden      : write('| * ');
			                    highlighted : write('|', board[i, j].val:2, ' ');
			                end;
		                end;
		            end;
	            write('|');
	            writeln;
	            for j := low(board[i]) to high(board[i]) do write('  - ');
	            writeln;
	        end;
	    writeln;
	end;


	function gen_board(n : Integer) : matrix;
	var
	    i, j, k,l,  tmp : Integer;
	    board : matrix;
	    tmpSet : intSet;
	    arr : tmparr;
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
	        	begin
	        		board[i, j].val := arr[ (i * (n)) + j + 1];
	        		board[i, j].status := hidden;
	        	end;
	            

	        gen_board := board;

	end;	       
	
end.