unit players;

{
	@author 	: Muhammad Arslan <rslnkrmt2552@gmail.com>
	@purpose 	: Player operations for a simple Prediction game.
}

interface
	uses board;

	type
		pType = (Human, Computer);
		coordinate_array = array[1..4] of Integer; {array of coordinates/inputs by player}
		Player = record
			player_name : record
				firstname, lastname : String;				
			end;
			score : Integer;
			case player_type : pType of
				Human : ();
				Computer : (level, elements : Integer; pred_list : predictionArray) {variable attributes in case of computer player only}
			end;
		


	procedure getDetails(num : Integer; var p : Player); {Get information to create an instant of a Player}
	procedure evaluate_human_turn(n, prediction_n: Integer; game_board : matrix; var x, y :Integer); {Get correct input from a human player}
	procedure popVal(index : Integer; var p : Player); {Pop the value at the given index, for a static array which is the player's prediction list}
	procedure clean_memory(board : matrix; var p : Player); {Clear any non-usable cells from the player's memory}
	procedure find_matching(board : matrix; p : Player ; var x1, y1, x2, y2 : Integer); {Find if there are any cells with matching value in memory}
	function RandomRange(Low, High: LongInt) : LongInt; {Find a random number between the given range}
	function evaluate_bot_turn(prediction_status : Boolean; n : Integer; game_board : matrix;  available : statusTracker; var p : Player) : coordinate_array; {evaluate turn for a bot}

implementation	
	
	procedure getDetails(num : Integer; var p : Player);
	var
		tmp : Integer;
	begin
		if (p.player_type = Computer) then
			begin

				p.player_name.firstname := 'BOT';
				case num of
					1 : p.player_name.lastname := 'ONE';
					2 : p.player_name.lastname := 'TWO';
				end;
				repeat
					Writeln;
					Writeln;
					Writeln('What level should BOT', p.player_name.lastname, ' have...?');
					Writeln('1- Beginner');
					Writeln('2- Intermediate');
					Writeln('3- Advanced');
					Writeln('4- Professional');
					Writeln('5- Surprise');
					Write('--> ');
					readln(tmp);	
				until (tmp in [1..5]);
				p.level := tmp;
				p.elements := 0;
				for tmp := 1 to MAX_PAIRS do 
					begin
						p.pred_list[tmp,1] := -13;
						p.pred_list[tmp,2] := -13; {A placeholder value}
					end;
					
			end
			else
				begin
					Write('Enter First Name -> ');
					readln(p.player_name.firstname);
					Write('OK ', p.player_name.firstname, ', enter your Last Name -> ');
					readln(p.player_name.lastname);
				end;

			p.score := 0;		
	end;

	procedure evaluate_human_turn(n, prediction_n: Integer; game_board : matrix; var x, y :Integer);
	var
		correct_input, valid_input : Boolean;
	begin
		repeat
			writeln;
			writeln('Enter prediction ', prediction_n, ': ');
	        write('x --> ');
	        readln(x);
	        write('y --> ');
	        readln(y);
	        correct_input := (x in [1..n]) AND (y in [1..n]); {Ensure inputs are within the range}
	        valid_input := False;
	        if correct_input then
	        	begin
	        		valid_input := (game_board[x-1, y-1].status = hidden); {Ensure that the cell is not already being used}
	        		if (not valid_input) then writeln('You should visit an eye doctor ... cause that box is already taken ...');
	        	end
	        	
	        else
	        	writeln('Out of bounds, try again...')		
		until valid_input;
		writeln;
	end;

	procedure popVal(index : Integer; var p : Player);
		var
			i : Integer;
		begin
			for i := index to (MAX_PAIRS - 1) do {Just make the value of every element from the index equal to the value of the next element}
				begin
					p.pred_list[i,1] := p.pred_list[i+1, 1];
					p.pred_list[i,2] := p.pred_list[i+1, 2];
				end;
			p.elements := p.elements - 1;
		end;

	procedure clean_memory(board : matrix; var p : Player);
		var
			i : Integer;
		begin
			i := 1;
			while (i <= p.elements) do
				begin
					if(board[p.pred_list[i, 1]-1, p.pred_list[i, 2]-1].status = clear) then
						popVal(i, p) {Pop any value for which the board cell is already being used}
					else
					 i := i + 1;
				end;
		end;

	procedure find_matching(board : matrix; p : Player ; var x1, y1, x2, y2 : Integer);
	var
		i, j : Integer;
		found : Boolean;
	begin
		i := 1;
		found := False;
		while((not found) AND (i < p.elements)) do
			begin
				x1 := p.pred_list[i, 1];
				y1 := p.pred_list[i, 2];
				j := i+1;
				while ((not found) AND (j <= p.elements)) do
				begin
					x2 := p.pred_list[j, 1];
					y2 := p.pred_list[j, 2];
					found := (board[x1-1, y1-1].val = board[x2-1, y2-1].val);
					j := j + 1;
				end;
				i := i + 1;
			end; {A basic linear search, as the prediction list will not be sorted}
		if (not found) then x1 := -13; {enter the placeholder value if no matching symbol is found}
	end;

	function RandomRange(Low, High: LongInt) : LongInt; {Self-explanatory}
		begin
		  if High < Low then
		    RandomRange := High + Random(High - Low)
		  else
		    RandomRange := Low + Random(Low -High);
		end;


	function evaluate_bot_turn(prediction_status : Boolean; n : Integer; game_board : matrix;  available : statusTracker; var p : Player) : coordinate_array;
	var
		i, j, toAdd : Integer;
		ret : coordinate_array;
	begin
		ret[1] := -13;
		clean_memory(game_board, p); 
		if p.elements > 1 then { Try to find matching if there are two or more values in memory}
			find_matching(game_board, p, ret[1], ret[2], ret[3], ret[4]);
		
		if (ret[1] < 0) then {If no matching symbol is found, give back a random prediction}
			begin
				i := RandomRange(low(available), length(available));
				ret[1] := available[i].x;
				ret[2] := available[i].y;
				repeat
					j := RandomRange(low(available), length(available));
				until (i <> j);
				ret[3] := available[j].x;
				ret[4] := available[j].y;
			end;
		if ( (not prediction_status) AND (length(available) > 20) ) then  {Don't add anything new if the previous prediction was correct or if there are less than}
			begin															{21 cells available. This value was found experimentally efficient}
				if (p.level = 5) then toAdd := random(4) else toAdd := p.level;
			
				if (toAdd < length(available)) then {If there are less available ones than there are to add than just add all of them.}
					begin                            {This state won't be reached logically but was places as security, and fun, and because I am lazy.}
						i := 1;
						while ( (i <= toAdd) AND (length(available) > 20) ) do
							begin
								repeat
									j := RandomRange(low(available), high(available));
								until (game_board[available[j].x-1, available[j].y-1].in_memory = False);
								p.elements := p.elements + 1;
								p.pred_list[p.elements, 1] := available[j].x;
								p.pred_list[p.elements, 2] := available[j].y;
								game_board[available[j].x-1, available[j].y-1].in_memory := True;
								popCell(j, available);
								i := i + 1;
							end;
					end
				else
					begin
						j := length(available);
						for i := low(available) to high(available) do
							begin
								p.elements := p.elements + 1;
								p.pred_list[p.elements, 1] := available[i].x;
								p.pred_list[p.elements, 2] := available[i].y;
								game_board[available[i].x-1, available[i].y-1].in_memory := True;
							end;
						for i := 1 to j do popCell(low(available), available);
					end;	
			end;
		evaluate_bot_turn := ret;
	end;

end.

	