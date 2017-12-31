all:
	fpc -Criot board.pas
	fpc -Criot players.pas
	fpc -Criot main.pas -ogame

clean:
	rm *.o
	rm *.ppu
	rm game
