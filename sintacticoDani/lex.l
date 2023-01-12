%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.h"
	#include "parser.tab.h"
	
	extern FILE *yyin;
	extern FILE *yyout;
	
	int lineno = 1; //comenzamos desde la linea 1
	void ret_print(char *token_type);
	void yyerror();

%}

%x ML_COMMENT

DIGITO			[0-9]+
LETRA		    [a-zA-Z]
alnum 		{LETRA}|{DIGITO}
print		[-~]
ESPACIO			["\0"]
ESPACIO_M {ESPACIO}+
INICOMENTARIO	["/*"]
FINCOMENTARIO	["*/"]
GUIONBAJO		[_]
GUIONES 		[-_]
LLAVE_ABRE		"{"
LLAVE_CIERRA	"}"
PAR_ABRE		"("
PAR_CIERRA		")"
COR_ABRE		"["
COR_CIERRA		"]"
nvalin   		["\n"]
e [ "\t"]
eb {e}+
gato             "#"
CHAR_COMA		","
CHAR_PUNTO 		"."
CHAR_PUNTOCOMA	";"
CHAR_DOSPUNTOS	":"
COMENTARIO 	 	"//"[^\n]*
ID 			({LETRA}+|{GUIONBAJO})({LETRA}|{DIGITO})* 
ICONST		"0"|[0-9]{DIGITO}*
FCONST		"0"|{DIGITO}*"."{DIGITO}+
CCONST		(\'{print}\')|(\'\\[nftrbv]\')
STRING		\"{print}*\"
NUMERO_REAL     {DIGITO}.{DIGITO}
CADENA 			\"[^"]*\"
NUMERO_REAL2	{NUMERO_REAL}[eE][\+\-]?{DIGITO}
NUMERO 			{DIGITO}|{NUMERO_REAL}|{NUMERO_REAL2}
OP_MAS  		"+"
OP_PLUS 		"++"
OP_MINUS		"--"
OP_MENOS  		"-"
OP_POR  		"*"
AMPERSON		"&"
OP_DIV 			["/"]
OP_IGUAL		"="
OP_MAYOR		">"
OP_MENOR		"<"
OP_MAYORIGUAL	">="
OP_MENORRIGUAL	"<="
OP_COPMENOR		"=="

OP_NEGACION		"!"
TIPO_SCANF		(%(c|s|f|d|i))
/*tipos*/
INT 	"int"
FLOAT 	"float"
DOUBLE 	"double"
CHAR 	"char"
/* Palabras reservadas */
IF  	 "if"
FOR		 "for"
WHILE	 "while"
DO		 "do"
SWITCH	 "switch"
CASE	 "case"
BREAK	 "break"
CONTINUE "continue"
ELSE	 "else"
RETURN	 "return"
EXTERN	 "extern"
PRINTF	 "printf"
SCANF 	 "scanf"
VECTOR	 "vector"
CONST    "const"
MAIN     "main"
INCLUDE   "include"

%%


"//".*					{} 

"/*"					{ }
<ML_COMMENT>"*/" 		{ printf(" line %d\n", lineno); BEGIN(INITIAL); }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			



{e}				
{nvalin}		{lineno++;}
{NUMERO}      	{insert(yytext, strlen(yytext), UNDEF, lineno);return numero;}
{OP_MENOS}      {return op_menos; }
{IF}        	{return PR_IF; }
{FOR}	      	{return PR_FOR;}
{SWITCH}    	{return PR_SWITCH ;}
{BREAK}     	{return PR_BREAK ;}
{CONTINUE}  	{return PR_CONTINUE ;}
{ELSE}      	{return PR_ELSE ;}
{EXTERN}    	{return PR_EXTERN ;}
{RETURN}    	{return PR_RETURN ;}
{WHILE}     	{return PR_WHILE;}
{PRINTF}    	{return PR_PRINTF ;}
{CASE}      	{return PR_CASE ;}
{VECTOR}    	{return PR_VECTOR ;}
{MAIN}      	{return PR_MAIN ;}
{INT}	    	{return Int ;}
{FLOAT} 	  	{return Float ;}
{DOUBLE} 	  	{return Double ;}
{CHAR} 	    	{return Char ;}
{SCANF}			{return PR_SCANF;}
{INCLUDE}       {return PR_INCLUDE ; }
{ID} 			{insert(yytext, strlen(yytext), UNDEF, lineno); return id;}
{ICONST} 		{ return Iconst ; }
{FCONST} 		{return Fconst ; }
{CCONST} 		{ return Cconst ;}
{STRING} 		{ return String ;}
{AMPERSON}		{return amperson ;}
{OP_PLUS}     { return Inc ;}
{OP_MINUS}    { return Dec ;}
{NUMERO_REAL2} 	{return numero;}
{NUMERO_REAL} 	{return numero;}
{DIGITO} 		{return numero;}
{CADENA}        {return cadena ;}
{LLAVE_ABRE}	{return llave_a ;}
{LLAVE_CIERRA}	{return llave_c ;}
{PAR_ABRE}		{return par_a ;}
{PAR_CIERRA}	{return par_c ;}
{COR_ABRE}		{return cor_a ;}
{COR_CIERRA}	{return cor_c ;}
{gato}           {return GATO;}
{CHAR_COMA}		{return coma ;}
{CHAR_PUNTO} 	{return punto ;}
{CHAR_PUNTOCOMA}  {return punto_coma ;}
{CHAR_DOSPUNTOS}  {return dos_puntos ;}
{OP_MAS}  		{return op_mas ;}
{OP_POR}  		 {return op_por ;}
{OP_DIV} 		 {return op_div ;}
{OP_IGUAL}		 {return op_igual ;}
{OP_MAYOR}		 {return op_mayor ;}
{OP_MENOR}		 {return op_menor ;}
{OP_MAYORIGUAL}	 {return op_mayorigual ;}
{OP_MENORRIGUAL} {return op_menorigual ;}
{OP_COPMENOR}	 {return op_dosigual ;}
{OP_NEGACION}	 {return op_negacion ;}
{TIPO_SCANF} 	{return tipos_scanf;}



[ \t\r\f]+			/* iGNORAR ESPACIOS EN BLANCOS*/
.				{printf("ERROR EN LA LINEA %d\n", lineno);}
%%
