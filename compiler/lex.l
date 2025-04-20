%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "yacc.tab.h"

extern YYSTYPE yylval;
struct json_object* tokens_array;  // actual definition (not extern)
%}

digit   [0-9]
alpha   [a-zA-Z_]
alnum   [a-zA-Z0-9_]

%%

{digit}+ {
    yylval.num = atoi(yytext);
    return NUMBER;
}

{alpha}{alnum}* {
    yylval.id = strdup(yytext);
    return ID;
}

"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MUL; }
"/"     { return DIV; }
"="     { return ASSIGN; }
";"     { return SEMI; }
"("     { return LPAREN; }
")"     { return RPAREN; }

[ \t\n]+   { /* skip whitespace */ }

.       { printf("Unknown character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
