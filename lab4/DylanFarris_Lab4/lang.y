%{
//**************************************
// lang.y
//
// Minimal parser for Tests 1-10
//

#include <iostream>
#include "lex.h"
#include "astnodes.h"

int yyerror(const char *msg);

cAstNode *yyast_root;
%}

%locations

%union{
    int             int_val;
    cAstNode*       ast_node;
    cProgramNode*   program_node;
    cBlockNode*     block_node;
    cStmtsNode*     stmts_node;
    cStmtNode*      stmt_node;
    cExprNode*      expr_node;
    cSymbol*        symbol;
}

%start program

%token <symbol> IDENTIFIER
%token <int_val> INT_VAL

%token PROGRAM
%token PRINT
%token WHILE
%token IF
%token ELSE
%token ENDIF

%type <program_node> program
%type <block_node> block
%type <stmts_node> stmts
%type <stmt_node> stmt
%type <expr_node> expr addit term fact

%%

program: PROGRAM block
{
    $$ = new cProgramNode($2);
    yyast_root = $$;

    if (yynerrs == 0) YYACCEPT;
    else YYABORT;
};

block:
      '{' stmts '}'
        { $$ = new cBlockNode(nullptr, $2); }
;

stmts:
      stmts stmt
        { $1->AddChild($2); $$ = $1; }
    | stmt
        { $$ = new cStmtsNode($1); }
;

stmt:
      IF '(' expr ')' stmts ENDIF ';'
        { $$ = new cIfNode($3,$5,nullptr); }

    | IF '(' expr ')' stmts ELSE stmts ENDIF ';'
        { $$ = new cIfNode($3,$5,$7); }

    | WHILE '(' expr ')' stmt
        { $$ = new cWhileNode($3,$5); }

    | PRINT '(' expr ')' ';'
        { $$ = new cPrintNode($3); }

    | IDENTIFIER '=' expr ';'
        { $$ = new cAssignNode($1,$3); }

    | block
        { $$ = (cStmtNode*)$1; }
;

expr:
      expr '+' term
        { $$ = new cBinaryExprNode($1,new cOpNode("+"),$3); }

    | expr '-' term
        { $$ = new cBinaryExprNode($1,new cOpNode("-"),$3); }

    | term
        { $$ = $1; }
;

term:
      term '*' fact
        { $$ = new cBinaryExprNode($1,new cOpNode("*"),$3); }

    | term '/' fact
        { $$ = new cBinaryExprNode($1,new cOpNode("/"),$3); }

    | fact
        { $$ = $1; }
;

fact:
      '(' expr ')'
        { $$ = $2; }

    | INT_VAL
        { $$ = new cIntExprNode($1); }
;

%%

int yyerror(const char *msg)
{
    std::cerr << "ERROR: " << msg
              << " at symbol " << yytext
              << " on line " << yylineno << "\n";
    return 0;
}
