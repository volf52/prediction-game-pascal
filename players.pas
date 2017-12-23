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
				Computer : (level, current_prediction : Integer)
			end;


	procedure getDetails(num : Integer; var p : Player);
	function evaluate_turn(n: Integer; var p : Player; game_board : matrix) : Boolean;


implementation	

	procedure getDetails(num : Integer; var p : Player);
	var
		tmp_type: Integer;
	begin
		if (p.player_type = Computer) then
			begin

				p.player_name.firstname := 'BOT';
				case num of
					1 : p.player_name.lastname := '_One';
					2 : p.player_name.lastname := '_Two';
				end;
				repeat
					Writeln;
					Writeln;
					Writeln('What level should ', p.player_name.firstname, p.player_name.lastname, ' have...?');
					Writeln('1- Beginner');
					Writeln('2- Intermediate');
					Writeln('3- Advanced');
					Writeln('4- Professional');
					Writeln('Surprise');
					Write('--> ');
					readln(tmp_type);	
				until (tmp_type in [1..4]);
				p.level := tmp_type;
				p.current_prediction := 1;
					
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

	function evaluate_turn(n: Integer; var p : Player; game_board : matrix) : Boolean;
	var
		correct_input, valid_input, correct_prediction : Boolean;
		x1, x2, y1, y2 : Integer;
	begin
		if (p.player_type = Human) then
			begin
				repeat
					writeln('Enter prediction 1: ');
			        write('(x y) --> ');
			        read(x1);
			        read();
			        readln(y1);
			        correct_input := (x1 in [1..n]) AND (y1 in [1..n]);
			        if correct_input then
			        	valid_input := (game_board[x1-1, y1-1].status = hidden);		
				until valid_input;
				writeln;
				writeln;
				game_board[x1-1, y1-1].status := highlighted;
				print_board(game_board, n, False);
				game_board[x1-1, y1-1].status := hidden;
				writeln;
				repeat
					writeln;
					writeln('Enter prediction 2: ');
			        write('(x y) --> ');
			        read(x2);
			        read();
			        readln(y2);
			        correct_input := (x2 in [1..n]) AND (y2 in [1..n]);
			        if correct_input then
			        	valid_input := (game_board[x2-1, y2-1].status = hidden);		
				until valid_input;
				writeln;
				game_board[x2-1, y2-1].status := highlighted;
				print_board(game_board, n, False);
				game_board[x2-1, y2-1].status := hidden;
				writeln;
				correct_prediction := (game_board[x1-1, y1-1].val = game_board[x2-1, y2-1].val);
				if correct_prediction then
					begin
						writeln;
						write('Congrats for the correct prediction.');
						game_board[x1-1, y1-1].status := clear;
						game_board[x2-1, y2-1].status := clear;
						p.score := p.score + 1;
					end;
				writeln;
				print_board(game_board, n, False);
				writeln;	
				evaluate_turn := correct_prediction;
			end;
	


	end;

end.

	