%{
#include "yacc.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <json-c/json.h>

extern struct json_object *tokens_array;  // Declare external JSON array to hold tokens
extern char* yytext;
%}

%%

"int"       { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("INT"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return INT; 
}

[0-9]+      { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("NUMBER"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    yylval.num = atoi(yytext); 
    return NUMBER; 
}

[a-zA-Z_][a-zA-Z0-9_]* { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("ID"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return ID; 
}

"+"         { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("PLUS"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return PLUS; 
}

"="         { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("ASSIGN"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return ASSIGN; 
}

"*"         { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("MUL"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return MUL; 
}

"/"         { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("DIV"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return DIV; 
}

"-"         { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("MINUS"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return MINUS; 
}

";"         { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("SEMI"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return SEMI; 
}

"("         { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("LPAREN"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return LPAREN; 
}

")"         { 
    struct json_object *token_obj = json_object_new_object();
    json_object_object_add(token_obj, "token_type", json_object_new_string("RPAREN"));
    json_object_object_add(token_obj, "lexeme", json_object_new_string(yytext));
    json_object_array_add(tokens_array, token_obj);
    return RPAREN; 
}

[ \t\n]+    ;  // skip whitespace

.           { 
    printf("Unknown character: %s\n", yytext); 
}

%%

// The yywrap function returns 1 to indicate the end of the input file
int yywrap() {
    return 1;
}
