%{
#ifdef _DEBUG
	#define DEBUGPRINT(fmt, ...) printf(fmt, __VA_ARGS__)
#else
	#define DEBUGPRINT(fmt, ...)
#endif
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>

int whileBlocks=0;
int forBlocks=0;
int repeatBlocks=0;
int ifBlocks=0;
int functionCalls=0;
int localVars=0;
int functionCount=0;
int localFunctions=0;
int doBlocks=0;
extern int comments;
extern int lines;



void yyerror(const char *s)
{
	printf("%s",s);
	exit(1);
}

extern int yylex(void);
extern int SetYYIN();
extern void CloseYYIN();

#define alloca malloc


%}


%token DO
%token WHILE
%token FOR
%token UNTIL
%token REPEAT
%token END
%token IN

%token IF
%token THEN
%token ELSEIF
%token ELSE

%token GOTO

%token LOCAL

%token FUNCTION
%token RETURN
%token BREAK

%token NIL
%token FALSE
%token TRUE
%token NUMBER
%token STRING
%token TDOT
%token NAME
%token LABEL


%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token POWER
%token MODULO

%token EQUALS
%token LESS_THAN
%token MORE_THAN
%token LESS_EQUAL_THAN
%token MORE_EQUAL_THAN
%token TILDE_EQUAL

%token AND
%token OR
%token SQUARE
%token NOT

%token APPEND

%token ASSIGN
%token DOT
%token COLON
%token COMMA
%token SEMICOLON

%token BRACES_L
%token BRACES_R

%token BRACKET_L
%token BRACKET_R

%token PARANTHESES_L
%token PARANTHESES_R

%token LEFT_SHIFT
%token RIGHT_SHIFT
%token TILDE
%token PIPE
%token AMPERSAND
%token MYEOF

%left MINUS,OR,PLUS,NOT,TIMES,DIVIDE,POWER,MODULO,EQUALS,LESS_THAN,MORE_THAN,LESS_EQUAL_THAN,MORE_EQUAL_THAN,TILDE_EQUAL,AND,SQUARE,APPEND,LEFT_SHIFT,RIGHT_SHIFT,TILDE,PIPE,AMPERSAND

%%

block : chunk {DEBUGPRINT("block is here\n");}
;

chunk : chunknext laststate {DEBUGPRINT("chunk is here\n");}
| chunknext {DEBUGPRINT("chunk is here\n");}
| laststate {DEBUGPRINT("chunk is here\n");}
;

chunknext: state {DEBUGPRINT("chunknext is here\n");}
| chunk state {DEBUGPRINT("chunknext is here\n");}
;

//semicolon	: SEMICOLON {DEBUGPRINT("semicolon is here\n");}
//| /* empty */ {DEBUGPRINT("semicolon is here\n");}
//;

laststate: RETURN exprlist {DEBUGPRINT("laststate is here\n");}
| RETURN {DEBUGPRINT("laststate is here\n");}
| BREAK {DEBUGPRINT("laststate is here\n");}
;

state	: varlist ASSIGN exprlist {DEBUGPRINT("state is here\n");}
| LOCAL namelist ASSIGN exprlist {DEBUGPRINT("state is here\n");localVars++;}
| LOCAL namelist {DEBUGPRINT("state is here\n");localVars++;}
| FUNCTION funcname funcbody {DEBUGPRINT("state is here\n");functionCount++;}
| LOCAL FUNCTION NAME funcbody {DEBUGPRINT("state is here\n");functionCount++;localFunctions++;}
| functioncall {DEBUGPRINT("state is here\n");functionCalls++;}
| DO block END {DEBUGPRINT("state is here\n");doBlocks++;}
| DO END {DEBUGPRINT("state is here\n");doBlocks++;}
| whileblock {DEBUGPRINT("state is here\n");whileBlocks++;}
| REPEAT block UNTIL expr {DEBUGPRINT("state is here\n");repeatBlocks++;}
| REPEAT UNTIL expr {DEBUGPRINT("state is here\n");repeatBlocks++;}
| ifblock {DEBUGPRINT("state is here\n");ifBlocks++;}
| forblock {DEBUGPRINT("state is here\n");forBlocks++;}
| GOTO NAME {DEBUGPRINT("state is here\n");}
| LABEL {DEBUGPRINT("state is here\n");}
| SEMICOLON
| MYEOF {return 0;}
;

forblock: FOR NAME ASSIGN expr COMMA expr DO block END {DEBUGPRINT("forblock is here\n");}
| FOR NAME ASSIGN expr COMMA expr COMMA expr DO block END {DEBUGPRINT("forblock is here\n");}
| FOR namelist IN exprlist DO block END {DEBUGPRINT("forblock is here\n");}
| FOR NAME ASSIGN expr COMMA expr DO END {DEBUGPRINT("forblock is here\n");}
| FOR NAME ASSIGN expr COMMA expr COMMA expr DO END {DEBUGPRINT("forblock is here\n");}
| FOR namelist IN exprlist DO END {DEBUGPRINT("forblock is here\n");}
;
		
whileblock: WHILE expr DO block END {DEBUGPRINT("whileblock is here\n");}
| WHILE expr DO END {DEBUGPRINT("whileblock is here\n");}
;

ifblock	: if elseif else END {DEBUGPRINT("ifblock is here\n");}
;
		

if: IF expr THEN block {DEBUGPRINT("if is here\n");}
| IF expr THEN{DEBUGPRINT("if is here\n");}
;

elseif: ELSEIF expr THEN block elseif {DEBUGPRINT("elseif is here\n");}
| ELSEIF expr THEN elseif {DEBUGPRINT("elseif is here\n");}
| {DEBUGPRINT("elseif is here\n");}
;

else: ELSE block {DEBUGPRINT("else is here\n");}
| ELSE {DEBUGPRINT("else is here\n");}
| /* empty */ {DEBUGPRINT("else is here\n");}
;

var: NAME {DEBUGPRINT("var is here\n");}
| prefixexpr BRACKET_L expr BRACKET_R {DEBUGPRINT("var is here\n");}
| prefixexpr DOT NAME {DEBUGPRINT("var is here\n");}
;

varlist: var {DEBUGPRINT("varlist is here\n");}
| varlist COMMA var {DEBUGPRINT("varlist is here\n");}
;

funcname: funcnamenext {DEBUGPRINT("funcname is here\n");}
| funcnamenext COLON NAME {DEBUGPRINT("funcname is here\n");}
;

funcnamenext: NAME {DEBUGPRINT("funcnamenext is here\n");}
| funcnamenext DOT NAME {DEBUGPRINT("funcnamenext is here\n");}
;

namelist: NAME {DEBUGPRINT("namelist is here\n");}
| namelist COMMA NAME {DEBUGPRINT("namelist is here\n");}
		;

expr: NIL {DEBUGPRINT("expr is here\n");}
| FALSE {DEBUGPRINT("expr is here\n");}
| TRUE {DEBUGPRINT("expr is here\n");}
| NUMBER {DEBUGPRINT("expr is here\n");}
| STRING {DEBUGPRINT("expr is here\n");}
| TDOT {DEBUGPRINT("expr is here\n");}
| function {DEBUGPRINT("expr is here\n");}
| prefixexpr {DEBUGPRINT("expr is here\n");}
| table {DEBUGPRINT("expr is here\n");}
| expr OR expr {DEBUGPRINT("expr is here\n");}
| expr AND expr {DEBUGPRINT("expr is here\n");}
| expr LESS_THAN expr {DEBUGPRINT("expr is here\n");}
| expr LESS_EQUAL_THAN expr {DEBUGPRINT("expr is here\n");}
| expr MORE_THAN expr {DEBUGPRINT("expr is here\n");}
| expr MORE_EQUAL_THAN expr {DEBUGPRINT("expr is here\n");}
| expr TILDE_EQUAL expr {DEBUGPRINT("expr is here\n");}
| expr EQUALS expr {DEBUGPRINT("expr is here\n");}
| expr APPEND expr {DEBUGPRINT("expr is here\n");}
| expr PLUS expr {DEBUGPRINT("expr is here\n");}
| expr MINUS expr {DEBUGPRINT("expr is here\n");}
| expr TIMES expr {DEBUGPRINT("expr is here\n");}
| expr DIVIDE expr {DEBUGPRINT("expr is here\n");}
| expr MODULO expr {DEBUGPRINT("expr is here\n");}
| NOT expr {DEBUGPRINT("expr is here\n");}
| SQUARE expr {DEBUGPRINT("expr is here\n");} 
| MINUS expr {DEBUGPRINT("expr is here\n");} 
| expr POWER expr {DEBUGPRINT("expr is here\n");} 
| expr LEFT_SHIFT expr {DEBUGPRINT("expr is here\n");} 
| expr RIGHT_SHIFT expr {DEBUGPRINT("expr is here\n");} 
| expr PIPE expr {DEBUGPRINT("expr is here\n");} 
| expr AMPERSAND expr {DEBUGPRINT("expr is here\n");}
| expr TILDE expr {DEBUGPRINT("expr is here\n");} 
| TILDE expr {DEBUGPRINT("expr is here\n");} 
;

exprlist : expr {DEBUGPRINT("exprlist is here\n");}
| exprlist COMMA expr {DEBUGPRINT("exprlist is here\n");}
;

prefixexpr: var {DEBUGPRINT("prefixexpr is here\n");}
| functioncall {DEBUGPRINT("prefixexpr is here\n");}
| PARANTHESES_L expr PARANTHESES_R {DEBUGPRINT("prefixexpr is here\n");}
;

function: FUNCTION funcbody {DEBUGPRINT("function is here\n");}
;

functioncall: prefixexpr args {DEBUGPRINT("functioncall is here\n");}
| prefixexpr COLON NAME args {DEBUGPRINT("functioncall is here\n");}
;

funcbody: PARANTHESES_L parameters PARANTHESES_R block END {DEBUGPRINT("funcbody is here\n");}
| PARANTHESES_L PARANTHESES_R block END {DEBUGPRINT("funcbody is here\n");}
| PARANTHESES_L PARANTHESES_R END {DEBUGPRINT("funcbody is here\n");}
| PARANTHESES_L parameters PARANTHESES_R END {DEBUGPRINT("funcbody is here\n");}
;

parameters	: namelist {DEBUGPRINT("parameters is here\n");}
| namelist COMMA TDOT {DEBUGPRINT("parameters is here\n");}
| TDOT {DEBUGPRINT("parameters is here\n");}
;

args	: PARANTHESES_L PARANTHESES_R {DEBUGPRINT("args is here\n");}
| PARANTHESES_L exprlist PARANTHESES_R {DEBUGPRINT("args is here\n");}
| table {DEBUGPRINT("args is here\n");}
| STRING {DEBUGPRINT("args is here\n");}
;

table: BRACES_L fieldlist BRACES_R {DEBUGPRINT("table is here\n");}
| BRACES_L BRACES_R {DEBUGPRINT("table is here\n");}
;

field	: BRACKET_L expr BRACKET_R ASSIGN expr {DEBUGPRINT("field is here\n");}
| NAME ASSIGN expr {DEBUGPRINT("field is here\n");}
| expr {DEBUGPRINT("field is here\n");}
;

fieldlist: fieldlistnext nextfield {DEBUGPRINT("fieldlist is here\n");}
;

fieldlistnext: field {DEBUGPRINT("fieldlistnext is here\n");}
| fieldlistnext fieldseparator field {DEBUGPRINT("fieldlistnext is here\n");}

nextfield: fieldseparator {DEBUGPRINT("nextfield is here\n");}
| /* empty */ {DEBUGPRINT("nextfield is here\n");}
;

fieldseparator: COMMA {DEBUGPRINT("fieldseparator is here\n");}
| SEMICOLON {DEBUGPRINT("fieldseparator is here\n");}
;

		
%%

void PrintResults()
{
	printf("\n\n-------------------------------------------------------\n");
	printf("comments : %d\n",comments);
	printf("local variables : %d\n",localVars);
	printf("functions : %d\n",functionCount);
	printf("local functions : %d\n",functionCount);
	printf("functions calls : %d\n",functionCalls);
	printf("if blocks : %d\n",ifBlocks);
	printf("while blocks : %d\n",whileBlocks);
	printf("repeat blocks : %d\n",repeatBlocks);
	printf("for blocks : %d\n",forBlocks);
	printf("do blocks : %d\n",doBlocks);
}

int main(int argc,char *argv[])
	{
		int stateus = 0;
		if (argc!=2)
		{
			printf("wrong argument number\n");
			return 0;
		}
		stateus=SetYYIN(argv[1]);
		if (stateus==0)
		{
			printf("filename==NULL\n");
			return 0;
		}
		yyparse();
		CloseYYIN();
		PrintResults();
	}
