parser: y.tab.c lex.yy.c
	gcc -o parser y.tab.c
y.tab.c: CS315_24F_Team_47.yacc lex.yy.c
	yacc CS315_24F_Team_47.yacc
lex.yy.c: CS315_24F_Team_47.lex
	lex CS315_24F_Team_47.lex
clean:
	rm -f lex.yy.c y.tab.c parser