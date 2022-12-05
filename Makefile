# Rutas para OSX

AFDs.exe: AFDs.l AFDs.y
	bison -d AFDs.y
	flex AFDs.l
	g++ -Wall -o $@ AFDs.tab.c lex.yy.c

clean:
	rm AFDs.tab.* lex.yy.c AFDs.exe
