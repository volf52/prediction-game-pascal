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
				Computer : (level, elements : Integer; pred_list : array[1..50] of integer)
			end;


	procedure getDetails(num : Integer; var p : Player);
	procedure evaluate_turn(n, prediction_n: Integer; p : Player; game_board : matrix; available : statusTracker; var x, y :Integer);


implementation	

	procedure getDetails(num : Integer; var p : Player);
	var
		tmp_type: Integer;
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
					readln(tmp_type);	
				until (tmp_type in [1..5]);
				p.level := tmp_type;
				p.elements := 0;
					
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

	procedure evaluate_turn(n, prediction_n: Integer; p : Player; game_board : matrix; available : statusTracker; var x, y :Integer);
	var
		correct_input, valid_input : Boolean;
	begin
		if (p.player_type = Human) then
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
				
			end
			else
				begin
					if (prediction_n = 1) then
						begin
							
						end;



				end;

	end;

end.

	