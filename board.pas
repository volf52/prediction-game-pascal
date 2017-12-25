unit board;

{
	@author 	: Muhammad Arslan <rslnkrmt2552@gmail.com>
	@purpose 	: Board operations for a simple Prediction game.
}

interface

	const
		max = 10;
		MAX_PAIRS=50;

    type
    	cell = record
    		val, x, y : Integer;
    		status : (highlighted, clear, hidden);
    		in_memory : Boolean;
    	end;
	    matrix = array of array of cell;
	    statusTracker = array of cell;
	    predictionArray = array[1..MAX_PAIRS, 1..2] of Integer;
	    intSet = set of 1..100;
	    tmparr = array[1.. (max*max)] of integer;
           
    

    procedure print_board(board : matrix; n : integer; reveal : Boolean);
    procedure popCell(index : Integer; var available : statusTracker);
   	function gen_board(n : Integer; var available : statusTracker) : matrix;



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


	procedure popCell(index : Integer; var available : statusTracker);
    var
    	i : Integer;
    begin
    	for i := (index + 1) to high(available) do
	    	begin
	    		available[i] := available[i+1];
	    	end;
    	SetLength(available, length(available) - 1);
    end;


	function gen_board(n : Integer; var available : statusTracker) : matrix;
	var
	    i, j, k,l,  tmp : Integer;
	    board : matrix;
	    tmpSet : intSet;
	    arr : tmparr;
	begin
				
	    randomize;
	    tmpSet := [];
	    setLength(board, n, n);
	    setLength(available, (n*n));
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
	        		board[i, j].val := arr[ (i * n) + j + 1];
	        		board[i, j].status := hidden;
	        		board[i, j].in_memory := False;
	        		board[i, j].x := (i+1);
	        		board[i, j].y := (j+1);
	        		available[ (i * n) + j ] := board[i, j];
	        	end;
	            

	        gen_board := board;

	end;	       
	
end.