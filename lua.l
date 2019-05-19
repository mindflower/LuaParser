%option noyywrap nounput batch noinput
%{
#ifdef _DEBUG
	#define DEBUGPRINT(fmt, ...) printf(fmt, __VA_ARGS__)
#else
	#define DEBUGPRINT(fmt, ...)
#endif
#define fileno _fileno
#include "y_tab.h"
extern int yylex(void);
int SetYYIN();
void CloseYYIN();
static void parse_comment();
#include <stdio.h>
#include <stdlib.h>
int lines = 1;
int comments=0;
%}


%%

do																													{ DEBUGPRINT("do: %s\n",yytext); return DO; }
while																												{ DEBUGPRINT("while: %s\n",yytext); return WHILE; }
for																													{ DEBUGPRINT("for: %s\n",yytext); return FOR; }
until																												{ DEBUGPRINT("until: %s\n",yytext); return UNTIL; }
repeat																												{ DEBUGPRINT("repeat: %s\n",yytext); return REPEAT; }
end																													{ DEBUGPRINT("end: %s\n",yytext); return END; }
in																													{ DEBUGPRINT("in: %s\n",yytext); return IN; }
if																													{ DEBUGPRINT("if: %s\n",yytext); return IF; }
then																												{ DEBUGPRINT("then: %s\n",yytext); return THEN; }
elseif																												{ DEBUGPRINT("elseif: %s\n",yytext); return ELSEIF; }
else																												{ DEBUGPRINT("else: %s\n",yytext); return ELSE; }
																			
local																												{ DEBUGPRINT("local: %s\n",yytext); return LOCAL; }
function																											{ DEBUGPRINT("function: %s\n",yytext); return FUNCTION; }
return																												{ DEBUGPRINT("return: %s\n",yytext); return RETURN; }
break																												{ DEBUGPRINT("break: %s\n",yytext); return BREAK; }
																			
goto																												{ DEBUGPRINT("goto: %s\n",yytext); return GOTO; }
																			
[+]                                     																			{ DEBUGPRINT("operation /+: %s\n",yytext); return PLUS; }
[-]                                     																			{ DEBUGPRINT("operation /-: %s\n",yytext); return MINUS; }
[*]                                     																			{ DEBUGPRINT("operation /*: %s\n",yytext); return TIMES; }
[/]                                     																			{ DEBUGPRINT("operation //: %s\n",yytext); return DIVIDE; }
[/][/]                                  																			   { DEBUGPRINT("operation //: %s\n",yytext); return DIVIDE; }
[\^]                                    																			{ DEBUGPRINT("operation /^: %s\n",yytext); return POWER; }
[%]                                     																			{ DEBUGPRINT("operation /%: %s\n",yytext); return MODULO; }
[~]                                     																			{ DEBUGPRINT("operation /~: %s\n",yytext); return TILDE; }
"|" 																												{ DEBUGPRINT("operation /|: %s\n",yytext); return PIPE; }
"&" 																												{ DEBUGPRINT("operation /&: %s\n",yytext); return AMPERSAND; }
[<][<]																												{ DEBUGPRINT("operation /<<: %s\n",yytext); return LEFT_SHIFT; }
[>][>]																												{ DEBUGPRINT("operation />>: %s\n",yytext); return RIGHT_SHIFT; }
[=][=]                                  																			{ DEBUGPRINT("operation /==: %s\n",yytext); return EQUALS; }
[<]                                     																			{ DEBUGPRINT("operation /<: %s\n",yytext); return LESS_THAN; }
[<][=]                                  																			{ DEBUGPRINT("operation /<=: %s\n",yytext); return LESS_EQUAL_THAN; }
[>]                                     																			{ DEBUGPRINT("operation />: %s\n",yytext); return MORE_THAN; }
[>][=]                                  																			{ DEBUGPRINT("operation />=: %s\n",yytext); return MORE_EQUAL_THAN; }
[~][=]                                  																			{ DEBUGPRINT("operation /~=: %s\n",yytext); return TILDE_EQUAL; }
[.][.]                                  																			{ DEBUGPRINT("operation /..: %s\n",yytext); return APPEND; }
and                                     																			{ DEBUGPRINT("operation and: %s\n",yytext); return AND; }
or                                      																			{ DEBUGPRINT("operation or: %s\n",yytext); return OR; }
#                                       																			{ DEBUGPRINT("operation #: %s\n",yytext); return SQUARE; }
not                                     																			{ DEBUGPRINT("operation not: %s\n",yytext); return NOT; }
																			
nil																													{ DEBUGPRINT("nil: %s\n",yytext); return NIL;}
false																												{ DEBUGPRINT("false: %s\n",yytext); return FALSE; }
true																												{ DEBUGPRINT("true: %s\n",yytext); return TRUE;}
[0-9]+|[0-9]+[Ee\.][0-9]*|[0-9]*[Ee\.][0-9]+|[0-9]*[\.][0-9]+[Ee][+-]?[0-9]*|0x[A-Fa-f0-9]+|0x[A-Fa-f0-9]+"."[A-Fa-f0-9]*	{ DEBUGPRINT("number: %s\n",yytext); return NUMBER;}
\"([^\\\"]|\\\n|\\.)*\"																								{ DEBUGPRINT("string: %s\n",yytext); return STRING;}
\'([^\\\']|\\\n|\\.)*\'																								{ DEBUGPRINT("string: %s\n",yytext); return STRING;}
\[{2}([^\]]*[\]]?[^\]]+)*\]{2}																						{ DEBUGPRINT("string: %s\n",yytext); return STRING;}
\[=\[(([^\]]*[\]]?[^=]+)|([^\]]*[\]]?[=]?[^\]]+))*\]=\]																{ DEBUGPRINT("string: %s\n",yytext); return STRING;}
\.\.\.																												{ DEBUGPRINT("tdot: %s\n",yytext); return TDOT;}
[A-Za-z_][A-Za-z0-9_]*																								{ DEBUGPRINT("name: %s\n",yytext); return NAME; }
::[A-Za-z_][A-Za-z0-9_]*::																							{ DEBUGPRINT("label: %s\n",yytext); return LABEL; }
<<EOF>>																												{return MYEOF;}
--\[\[([^\]]*[\]]?[^\]]+)*\]\]																						{ DEBUGPRINT("comment: %s\n",yytext); comments++;}
--\[=\[(([^\]]*[\]]?[^=]+)|([^\]]*[\]]?[=]?[^\]]+))*\]=\]															{ DEBUGPRINT("comment: %s\n",yytext); comments++;}
--[^\n]*																											{ DEBUGPRINT("comment: %s\n",yytext); comments++;}
																			
=																													{ DEBUGPRINT("assign: %s\n",yytext); return ASSIGN; }
\.																													{ DEBUGPRINT("dot: %s\n",yytext); return DOT; }
:																													{ DEBUGPRINT("colon: %s\n",yytext); return COLON; }
,																													{ DEBUGPRINT("comma: %s\n",yytext); return COMMA; }
;																													{ DEBUGPRINT("semicolon: %s\n",yytext); return SEMICOLON; }
\(																													{ DEBUGPRINT("parentheses_l: %s\n",yytext); return PARANTHESES_L; }
\)																													{ DEBUGPRINT("parantheses_r: %s\n",yytext); return PARANTHESES_R; }
\{																													{ DEBUGPRINT("braces_l: %s\n",yytext); return BRACES_L; }
\}																													{ DEBUGPRINT("braces_r: %s\n",yytext); return BRACES_R; }
[\[]																												{ DEBUGPRINT("bracket_l: %s\n",yytext); return BRACKET_L; }
[\]]																												{ DEBUGPRINT("bracket_r: %s\n",yytext); return BRACKET_R; }
[ \t]																												{ /* spacing */}
[\n]																												{ lines++; }

%%

static void parse_comment()
{
	int c;

    while ((c = input()) != -1)
    {
        if (c == '\n')
        {
            break;
        }
    }
   // yyerror("unterminated comment");
}

int SetYYIN(char *in)
{
	//char filename[100];
	fopen_s(&yyin,in, "r");
	if (yyin!=NULL)
		return 1;
	
	return 0;
}


void CloseYYIN()
{
  fclose(yyin);
}