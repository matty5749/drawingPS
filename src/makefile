cible:

	bison -d yacc.y
	flex -l lex.l
	
	gcc lex.yy.c yacc.tab.c tableSymbole.c gestionArgument.c -lfl -o drawingPS -g
			
clean:
	rm drawingPS lex.yy.c yacc.tab.h yacc.tab.c *~
	
