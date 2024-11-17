
%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
int yyerror(char *s);

extern int yylineno;
%}

%token START FINISH FUNCTION IF ELSE FOR WHILE RETURN 
%token IDENTIFIER INTCONST FLOAT DEGREE STRCONST
%token URL INPUT OUTPUT CLIMB DROP MOVEFORWARD MOVEBACKWARD
%token STOPVERTICAL STOPHORIZONTAL TURNLEFT TURNRIGHT SPRAYON SPRAYOFF
%token GETTIME GETCURRENTHEADING GETCURRENTHEIGHT GETCURRENTALTITUDE CONNECTTOURL
%token COMMENT 
%token LP RP LCB RCB LB RB SC COMMA NOT

%right ASSIGNOP

%left ADDOP SUBOP
%left MULTOP DIVOP
%left MODOP
%left SMALLEQ BIGEQ LESS GREATER EQUALITY NOTEQ
%left AND OR

%%

start:
    START stmts FINISH { printf("Input program is valid\n"); return 0; }
    ;

stmts:
    stmt
    | stmt stmts
    ;

stmt:
     comment
    | matched
    | unmatched
    | return_stmt
    ;

comment:
    COMMENT
    ;

matched:
    if_stmt
    | assignment SC
    | loop_stmt
    | function_call SC
    | drone_command SC
    | function_def 
    ;

unmatched:
    if_stmt_unmatched
    ;

return_stmt:
    RETURN expression SC
    ;

if_stmt:
    IF LP logic_expr RP LCB stmts RCB ELSE LCB stmts RCB
    ;

if_stmt_unmatched:
    IF LP logic_expr RP LCB stmts RCB 
    ;

assignment:
    identifier ASSIGNOP expression 
    | array_assignment 
    ;

array_assignment:
    identifier LB expression RB ASSIGNOP LCB var_list RCB
    ;

expression:
    expression sign term
    | LP expression RP
    | SUBOP term
    | term
    | NOT term
    ;

term:
    term op factor
    | factor
    ;

factor:
      var_list
    | function_call
    | array_access
    ;

function_def:
    FUNCTION identifier LP var_list RP LCB stmts RCB
    | FUNCTION identifier LP RP LCB stmts RCB
    ;

function_call:
    primitive_call
    | identifier LP expression RP
    ;

primitive_call:
     INPUT LP identifier RP
    | OUTPUT LP expression RP
    | GETTIME LP RP
    | GETCURRENTHEADING LP RP
    | GETCURRENTHEIGHT LP RP
    | GETCURRENTALTITUDE LP RP
    | CONNECTTOURL LP RP
    ;

loop_stmt:
    for_loop
    | while_loop
    ;

for_loop:
    FOR LP assignment SC logic_expr SC assignment RP LCB stmts RCB
    ;

while_loop:
    WHILE LP logic_expr RP LCB stmts RCB
    ;

logic_expr:
    var logic_op var
    | logic_expr AND logic_expr
    | logic_expr OR logic_expr
    ;

var_list:
    var
    | var COMMA var_list
    ;

var:
    IDENTIFIER
    | INTCONST
    | FLOAT
    | STRCONST
    | degree
    ;

degree:
    DEGREE
    ;

identifier:
    IDENTIFIER
    ;

array_access:
    identifier LB expression RB
    ;


drone_command:
    CLIMB LP expression RP
    | DROP LP RP
    | MOVEFORWARD LP expression RP
    | MOVEBACKWARD LP expression RP
    | STOPVERTICAL LP RP
    | STOPHORIZONTAL LP RP
    | TURNLEFT LP expression RP
    | TURNRIGHT LP expression RP
    | SPRAYON LP RP
    | SPRAYOFF LP RP
    ;

sign:
    ADDOP
    | SUBOP
    ;

op:
    MULTOP
    | DIVOP
    | MODOP
    | AND
    | OR
    ;

logic_op:
    SMALLEQ
    | EQUALITY
    | BIGEQ
    | LESS
    | GREATER
    | NOTEQ
    ;



%%

#include "lex.yy.c"

int yyerror(char *s){
  fprintf(stderr, "%s on line %d, near token %s \n",s, yylineno, yytext);
  return 1;
}

int main(){
  yyparse();
  return 0;
}

