unit players;

{
	@author 	: Muhammad Arslan <rslnkrmt2552@gmail.com>
	@purpose 	: Board operations for a simple Prediction game.
}

interface
	uses board;

	type
		pType = (Human, Computer);
		botC = array[1..4] of Integer;
		Player = record
			player_name : record
				firstname, lastname : String;				
			end;
			score : Integer;
			case player_type : pType of
				Human : ();
				Computer : (level, elements : Integer; pred_list : predictionArray)
			end;
		


	procedure getDetails(num : Integer; var p : Player);
	procedure evaluate_human_turn(n, prediction_n: Integer; game_board : matrix; var x, y :Integer);
	procedure popVal(index : Integer; var p : Player);
	procedure clean_memory(board : matrix; var p : Player);
	procedure find_matching(board : matrix; p : Player ; var x1, y1, x2, y2 : Integer);
	function RandomRange(Low, High: LongInt) : LongInt;
	function evaluate_bot_turn(n : Integer; game_board : matrix;  available : statusTracker; var p : Player) : botC;

implementation	
	

	procedure getDetails(num : Integer; var p : Player);
	var
		tmp : Integer;
	begin
		if (p.player_type = Computer) then
			begin

				p.player_name.firstname := 'BOT';
				case num of
					1 : p.player_name.lastname := '_ONE';
					2 : p.player_name.lastname := '_TWO';
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
						p.pred_list[tmp,2] := -13;
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
	        correct_input := (x in [1..n]) AND (y in [1..n]);
	        if correct_input then
	        	begin
	        		valid_input := (game_board[x-1, y-1].status = hidden);
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
			i := index;
			repeat
				p.pred_list[i,1] := p.pred_list[i+1, 1];
				p.pred_list[i,2] := p.pred_list[i+1, 2];
				i := i + 1;
			until ( (p.pred_list[i,1] < 0) OR (i = MAX_PAIRS));
			p.elements := p.elements - 1;
		end;

	procedure clean_memory(board : matrix; var p : Player);
		var
			i : Integer;
		begin
			i := 1;
			while (i <= p.elements) do
				begin
					if(not board[p.pred_list[i, 1]-1, p.pred_list[i, 2]-1].in_memory) then
						popVal(i, p)
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
			end;
		if (not found) then x1 := -13;
	end;

	function RandomRange(Low, High: LongInt) : LongInt;
		begin
		  if High < Low then
		    RandomRange := High + Random(High - Low)
		  else
		    RandomRange := Low + Random(Low -High);
		end;


	function evaluate_bot_turn(n : Integer; game_board : matrix;  available : statusTracker; var p : Player) : botC;
	var
		i, j : Integer;
		ret : botC;
	begin
		ret[1] := -13;
		if p.elements > 1 then
			find_matching(game_board, p, ret[1], ret[2], ret[3], ret[4]);
		if (ret[1] < 0) then
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
		if (p.level in [1..4]) then
			begin
				for i := 1 to p.level do
					begin
						repeat
							j := RandomRange(low(available), high(available));
						until (available[j].in_memory = False);
						p.elements := p.elements + 1;
						p.pred_list[p.elements, 1] := available[j].x;
						p.pred_list[p.elements, 2] := available[j].y;
						popCell(j, available); 
					end;
			end;
		evaluate_bot_turn := ret;
	end;

end.

	