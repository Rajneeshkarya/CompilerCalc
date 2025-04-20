%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <json-c/json.h>
#include <ctype.h>

// Define the Node structure before using it
typedef struct Node {
    char* value;
    struct Node* left;
    struct Node* right;
} Node;

// Declare function used in parser
Node* createNode(char* value, Node* left, Node* right);
int evaluate(Node* node);
struct json_object* nodeToJson(Node* root);

// Declare external variable
extern struct json_object* tokens_array;

// Needed for Bison & Flex interaction
int yylex(void);
void yyerror(const char *s);

%}

// YYSTYPE union
%union {
    int num;
    char* id;
    struct Node* node;
}

// Token types
%token <id> ID
%token <num> NUMBER
%token INT
%token PLUS MINUS MUL DIV ASSIGN SEMI LPAREN RPAREN

%left PLUS MINUS
%left MUL DIV
%right ASSIGN

%type <node> expr stmt

%%

stmt: ID ASSIGN expr SEMI
    {
        $$ = createNode("=", createNode($1, NULL, NULL), $3);

        // 1. Generate Parse Tree JSON
        struct json_object* tree = nodeToJson($$);
        json_object_to_file("parse_tree.json", tree);

        // 2. Evaluate Arithmetic
        int result = evaluate($3);
        struct json_object* result_obj = json_object_new_object();
        json_object_object_add(result_obj, "result", json_object_new_int(result));
        json_object_to_file("output.json", result_obj);
    }
;

expr: expr PLUS expr     { $$ = createNode("+", $1, $3); }
    | expr MINUS expr    { $$ = createNode("-", $1, $3); }
    | expr MUL expr      { $$ = createNode("*", $1, $3); }
    | expr DIV expr      { $$ = createNode("/", $1, $3); }
    | NUMBER             { char buf[16]; sprintf(buf, "%d", $1); $$ = createNode(buf, NULL, NULL); }
    | ID                 { $$ = createNode($1, NULL, NULL); }
    | LPAREN expr RPAREN { $$ = $2; }
;

%%

// Function definitions

Node* createNode(char* value, Node* left, Node* right) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->value = strdup(value);
    node->left = left;
    node->right = right;
    return node;
}

int evaluate(Node* node) {
    if (!node) return 0;
    if (strcmp(node->value, "+") == 0) return evaluate(node->left) + evaluate(node->right);
    if (strcmp(node->value, "-") == 0) return evaluate(node->left) - evaluate(node->right);
    if (strcmp(node->value, "*") == 0) return evaluate(node->left) * evaluate(node->right);
    if (strcmp(node->value, "/") == 0) return evaluate(node->left) / evaluate(node->right);
    if (isdigit(node->value[0])) return atoi(node->value);
    return 0;
}

struct json_object* nodeToJson(Node* root) {
    if (!root) return NULL;
    struct json_object* obj = json_object_new_object();
    json_object_object_add(obj, "value", json_object_new_string(root->value));
    if (root->left) json_object_object_add(obj, "left", nodeToJson(root->left));
    if (root->right) json_object_object_add(obj, "right", nodeToJson(root->right));
    return obj;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}