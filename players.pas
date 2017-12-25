unit players;

{
	@author 	: Muhammad Arslan <rslnkrmt2552@gmail.com>
	@purpose 	: Board operations for a simple Prediction game.
}

interface
	uses board;

	type
		pType = (Human, Computer);
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
	procedure find_matching(board : matrix; p_list : predictionArray; var x1, y1, x2, y2 : Integer);
	procedure evaluate_bot_turn(n : Integer; game_board : matrix; var p : Player ; available : statusTracker; x1,x2,y1,y2 : Integer);

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
					if(not board[p.pred_list[i, 1], p.pred_list[i, 2]].in_memory) then
						popVal(i, p)
					else
					 i := i + 1;
				end;
		end;

	procedure find_matching(board : matrix; p_list : predictionArray; var x1, y1, x2, y2 : Integer);
	begin
		
	end;


	procedure evaluate_bot_turn(n : Integer; game_board : matrix; var p : Player ; available : statusTracker; x1,x2,y1,y2 : Integer);
	var
		i, j : Integer;
	begin
		clean_memory(game_board, p);
		x1 := -13;
		if p.elements > 1 then
			find_matching(game_board, p.pred_list, x1, y1, x2, y2);
		if (x1 < 0) then
			begin
				randomize;
				i := random(length(available));
				x1 := available[i].x;
				y1 := available[i].y;
				repeat
					j := random(length(available));
				until (i <> j);
				x2 := available[i].x;
				y2 := available[i].y;
			end;
	end;

end.

	