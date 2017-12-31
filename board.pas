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
    	cell = record   {An "object" to keep track of each cell}
    		val, x, y : Integer;
    		status : (highlighted, clear, hidden);
    		in_memory : Boolean;
    	end;
	    matrix = array of array of cell; {A dynamic, 2D array of cells to replicate a board}
	    statusTracker = array of cell; {Dynamic array to keep track of available cells}
	    predictionArray = array[1..MAX_PAIRS, 1..2] of Integer; {The "memory" of a bot player}
	    intSet = set of 1..100; {A set of values between 1 and 100}
	    tmparr = array[1.. (max*max)] of integer; {A temp array to randomize the number pairs on the board}
           
    

    procedure print_board(board : matrix; n : integer; reveal : Boolean); {Print the board}
    procedure popCell(index : Integer; var available : statusTracker); {Pop the element at the given index for a dynamic array}
   	function gen_board(n : Integer; var available : statusTracker) : matrix; { Generate a board and the array to keep track of available cells}



implementation
	
	procedure print_board(board : matrix; n : integer; reveal: Boolean) ; {No furthur comments required, I think.}
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


	procedure popCell(index : Integer; var available : statusTracker); {The same logic as popVal, just different implementation for a dynamic array}
    var
    	i : Integer;
    begin
    	for i := index to (high(available)-1) do
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
	    repeat {Create a set of random values with (n*n)/2 elements}
	            j := random(99)+1; {Not using random(100) cause tmpSet is defined for 1..100 ... in cases where random produces 0, there will be a runtime error}
	            if not (j in tmpSet) then
	                begin
	                include(tmpSet, j);
	                i := i + 1;    
	                end;
	        until (i = ((n*n) div 2));

	    i := 1;
	    for tmp in tmpSet do
	        begin
	            arr[2*(i-1) + 1] := tmp; {"Convert" the set to an array. The "function" I am using for indexing is inspired by what I think is the array addressing function}
	            arr[2*(i-1) + 2] := tmp;
	            i := i + 1;
	        end;

	    for l := 1 to 100 do {Randomize the values in the array, using a new random seed each time}
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
	    
	    for i := low(board) to high(board) do  {Convert that 1D, static array to this 2D, dynamic array using the similar addressing/indexing function}
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