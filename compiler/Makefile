# Default target to build everything
all: compiler

# Step to create the lexer and the compiler
compiler: yacc.tab.c lex.yy.c
	gcc lex.yy.c yacc.tab.c -lfl -ljson-c -o compiler

# Create the yacc and lex files
yacc.tab.c yacc.tab.h: yacc.y
	bison -d -Wcounterexamples yacc.y

lex.yy.c lex.yy.h: lex.l
	flex -o lex.yy.c -i lex.l  # Add -I to generate lex.yy.h header file

# Step to compile the lexer separately for testing tokens
tokens: lex.yy.c
	gcc lex.yy.c -lfl -ljson-c -o lexer
	./lexer < input.c

# Step to run the compiler and parse the input
run: compiler
	./compiler < input.c

# Clean the generated files
clean:
	rm -f lex.yy.c yacc.tab.c yacc.tab.h compiler lexer tokens.json parse_tree.json output.json lex.yy.h
