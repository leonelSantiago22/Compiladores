/*Analizador lexico.l uso de la funcion yylex*/
%{
#include <stdio.h>
#include <stdlib.h>

#include <string.h>

int error=0;
int nolin=1;
int que_es;
FILE *fuente;

%}

%option noyywrap
%option yylineno


DIGITO			[0-9]+
LETRA		    [a-zA-Z]
ESPACIO			["\0"]
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
CHAR_COMA		","
CHAR_PUNTO 		"."
CHAR_PUNTOCOMA	";"
CHAR_DOSPUNTOS	":"
COMENTARIO 	 	"//"[^\n]*
IDENTIFICADOR	({LETRA}+|{GUIONBAJO})({LETRA}|{DIGITO})*
NUMERO_REAL     {DIGITO}.{DIGITO}
CADENA 			\"[^"]*\"
NUMERO_REAL2	{NUMERO_REAL}[eE][\+\-]?{DIGITO}
NUMERO 			{DIGITO}|{NUMERO_REAL}|{NUMERO_REAL2}
/*Operadores logicos y aritmeticos basicos */
OP_MAS  		"+"
OP_MENOS  		"-"
OP_POR  		"*"
OP_DIV 			["/"]
OP_IGUAL		"="
OP_MAYOR		">"
OP_MENOR		"<"
OP_MAYORIGUAL	">="
OP_MENORRIGUAL	"<="
OP_COPMENOR		"=="
OP_NEGACION		"!"
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
VECTOR	 "vector"
CONST    "const"
MAIN     "main"
Error     .


%%
{nvalin}		{printf("\n Salto de linea:(%s) ",yytext);nolin++;}
{e}
{ESPACIO}		{printf("ESPACIO: JIJI %s", yytext);}
{COMENTARIO}	{printf("\n COMENTARIO EN LINEA (%s) linea : %d ", yytext, nolin);}
{IF}        	{printf("\n palabra reservada if:(%s)  linea : %d ",yytext, nolin); return(101);}
{FOR}	      	{printf("\n palabra reservada for:(%s) linea : %d  ",yytext, nolin);return(102);}
{WHILE}     	{printf("\n palabra reservada while:(%s) linea : %d ",yytext, nolin);return(103);}
{DO}        	{printf("\n palabra reservada do: (%s) linea : %d ",yytext, nolin);return(104);}
{SWITCH}    	{printf("\n palabra reservada switch:(%s)  linea : %d ",yytext, nolin);return(105);}
{CASE}      	{printf("\n palabra reservada case:(%s) linea : %d ",yytext, nolin);return(106);}
{BREAK}     	{printf("\n palabra reservada break:(%s) linea : %d ",yytext, nolin);return(107);}
{CONTINUE}  	{printf("\n palabra reservada continue:(%s) linea : %d ",yytext, nolin);return(108);}
{ELSE}      	{printf("\n palabra reservada else:(%s) linea : %d ",yytext, nolin);return(109);}
{RETURN}    	{printf("\n palabra reservada return:(%s) linea : %d ",yytext, nolin);return(110);}
{EXTERN}    	{printf("\n palabra reservada extern:(%s)  linea : %d",yytext, nolin);return(111);}
{PRINTF}    	{printf("\n palabra reservada printf:(%s)  linea : %d ",yytext, nolin);return(112);}
{VECTOR}    	{printf("\n palabra reservada vector:(%s) linea : %d",yytext, nolin);return(113);}
{CONST}     	{printf("\n palabra reservada const:(%s)  linea : %d ",yytext, nolin);return(114);}
{MAIN}      	{printf("\n palabra reservada main:(%s) linea : %d ",yytext, nolin);return(115);}
{INT}	    	{printf("\n tipo de dato int:(%s) linea : %d",yytext, nolin);return(116);}
{FLOAT} 	  	{printf("\n tipo de dato float:(%s) linea : %d ",yytext, nolin);return(117);}
{DOUBLE} 	  	{printf("\n tipo de dato double:(%s) linea : %d ",yytext, nolin);return(118);}
{CHAR} 	    	{printf("\n tipo de dato char:(%s) linea : %d ",yytext, nolin);return(119);}
{IDENTIFICADOR}	{printf("\n Identificador:(%s) linea : %d ",yytext, nolin);return(120);}
{NUMERO}   {printf("\n Numero:(%s)  linea : %d ",yytext, nolin);return(121);}
{CADENA}        {printf("\n CADENA DE TEXTO:(%s) ",yytext);return(122);}
{GUIONES}		{printf("\n GUIONES:(%s) linea : %d",yytext, nolin);return(123);}
{LLAVE_ABRE}	{printf("\n LLAVE_ABRE:(%s) linea : %d",yytext, nolin);return(124);}
{LLAVE_CIERRA}	{printf("\n LLAVE_CIERRA:(%s) linea : %d ",yytext, nolin);return(125);}
{PAR_ABRE}		{printf("\n PAR_ABRE:(%s) ",yytext);return(126);}
{PAR_CIERRA}	{printf("\n PAR_CIERRA:(%s) ",yytext);return(127);}
{COR_ABRE}		{printf("\n COR_ABRE:(%s) ",yytext);return(128);}
{COR_CIERRA}	{printf("\n COR_CIERRA:(%s) ",yytext);return(129);}
{CHAR_COMA}		{printf("\n COMA:(%s) ",yytext);return(131);}
{CHAR_PUNTO} 	{printf("\n PUNTO:(%s) ",yytext);return(132);}
{CHAR_PUNTOCOMA}  {printf("\n PUNTO Y COMA:(%s) ",yytext);return(133);}
{CHAR_DOSPUNTOS}  {printf("\n DOS PUNTOS :(%s) ",yytext);return(134);}
{OP_MAS}  		{printf("\n Operador +:(%s) linea : %d ",yytext, nolin);return(135);}
{OP_POR}  		 {printf("\n Operador *:(%s) linea : %d ",yytext, nolin);return(137);}
{OP_DIV} 		 {printf("\n Operador /:(%s) linea : %d ",yytext, nolin);return(138);}
{OP_IGUAL}		 {printf("\n Operador =:(%s) linea : %d ",yytext, nolin);return(139);}
{OP_MAYOR}		 {printf("\n Operador Rel >:(%s) linea : %d",yytext, nolin);return(140);}
{OP_MENOR}		 {printf("\n Operador Rel <:(%s) linea : %d  ",yytext, nolin);return(141);}
{OP_MAYORIGUAL}	 {printf("\n Operador Rel >=:(%s)linea : %d  ",yytext, nolin);return(142);}
{OP_MENORRIGUAL} {printf("\n Operador Rel <=:(%s) linea : %d  ",yytext, nolin);return(143);}
{OP_COPMENOR}	 {printf("\n Operador Rel ==:(%s)  linea : %d  ",yytext, nolin);return(144);}
{OP_NEGACION}	 {printf("\n Operador Rel !:(%s) linea : %d ",yytext, nolin);return(145);}
{Error} 		{error++; printf("\nSe leyo el caracter no reconocido: (%s) linea: %d\n",yytext, nolin);}

%%

int main(int argc, char *argv[])
{
 //freopen("./outfile.txt","w",stdout); // Redireccion de salida, los datos de salida se guardaran en el archivo out.txt 
  if ((fuente=fopen(argv[1],"r"))!=NULL){
        yyin=fuente;
        que_es=yylex();
		while (que_es!=0)
		{
			printf("\tNumero de token: %d\n", que_es);
			que_es=yylex();
			getchar();
		}

	}
	else{
		   printf("\nError, No se puede abrir archivo");
		   exit(1);
		  }
    fclose(fuente);
	
	printf("\nNumero de lineas analizadas: %d", nolin);
	printf("\nNumero total de errores:     %d\n", error);
  return 0;
}
