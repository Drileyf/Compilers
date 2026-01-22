%{
//**************************************
// lang.l
//
// scanner definition file. flex uses this file to create the scanner
//
// Author: Dylan Farris
//

#include "tokens.h"
#include "cSymbol.h"
#include "cSymbolTable.h"
#include "lex.h"

// Macros that can be used to create debug output from the scanner
// Uncomment the next line of code to generate debug output.
// Note: for this to work, use DO_RETURN(val) for all the return statements
//       for your tokens. See sample below for "program"
#define DEBUG_OUTPUT
#ifdef DEBUG_OUTPUT
    #define DO_RETURN(a) { return Return(a); }
#else
    #define DO_RETURN(a) { return (a); }
#endif

int Return(int val);
int ScopeIncrease();
int ScopeDecrease();

%}

%option noyywrap
%option noinput
%option nounput
%option yylineno


    /* definitions go here. period is an example. */
    /* NOTE: You do not need to use definitions */
letters          [a-z]
whitespace       '[\t\n\r ]'
%%

    // token definitions. I gave "program" as an example
program                   DO_RETURN(PROGRAM);
[\t\n\r ]*                {}
"_"                       DO_RETURN(IDENTIFIER);
"("                       DO_RETURN('(');
")"                       DO_RETURN(')');
"{"                       DO_RETURN(ScopeIncrease());
"}"                       DO_RETURN(ScopeDecrease());
"["                       DO_RETURN('[');
"]"                       DO_RETURN(']');
";"                       DO_RETURN(';');
","                       DO_RETURN(',');
"."                       DO_RETURN('.');
"+"                       DO_RETURN('+');
"-"                       DO_RETURN('-');
"*"                       DO_RETURN('*');
"/"                       DO_RETURN('/');
"%"                       DO_RETURN('%');
"="                       DO_RETURN('=');
">"                       DO_RETURN('>');
"<"                       DO_RETURN('<');
if                        DO_RETURN(IF);
else                      DO_RETURN(ELSE);
endif                     DO_RETURN(ENDIF);
while                     DO_RETURN(WHILE);
print                     DO_RETURN(PRINT);
char                      DO_RETURN(CHAR);
int                       DO_RETURN(INT);
Wlong                     DO_RETURN(LONG);
float                     DO_RETURN(FLOAT);
double                    DO_RETURN(DOUBLE);
[0-9]                     DO_RETURN(INT_VAL);
[0-9]+[.]+[0-9]+          DO_RETURN(FLOAT_VAL);
struct                    DO_RETURN(STRUCT);
array                     DO_RETURN(ARRAY);
return                    DO_RETURN(RETURN);
[[a-zA-Z+]+[a-zA-Z0-9_]*  DO_RETURN(IDENTIFIER);
"!="                      DO_RETURN(NOT_EQUALS);
"=="                      DO_RETURN(EQUALS);
"&&"                      DO_RETURN(AND);
"||"                      DO_RETURN(OR);
">="                      DO_RETURN(GE);
"<="                      DO_RETURN(LE);
prints                    DO_RETURN(PRINTS);
["].*["]                  DO_RETURN(STRING_LIT);
.                         DO_RETURN(JUNK_TOKEN);
%%

// This function allows us to do extra processing on each token
// It is used to generate lexer debug info
int Return(int val)
{
    printf("Scanned '%s': %d\n", yytext, val);
    return val;
}

//IncreaseScope
int ScopeIncrease()
{
    g_symbolTable.IncreaseScope();
    return '{';
}

//DecreaseScope
int ScopeDecrease()
{
    g_symbolTable.DecreaseScope();
    return '}';
}
