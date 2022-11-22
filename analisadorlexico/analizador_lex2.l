/*Analizador lexico.l uso de la funcion yylex*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

int error=0;
int nolin=1;
int que_es;
FILE *fuente;
%}


/*Seleccion de opciones  */
/*Esto indica a Flex que lea solo un fichero de entrada */ 
%option noyywrap 
/*Nos permite obtener el numero de linea */
%option yylineno

/*Definiciones regulares */

DIGITO			[0-9]
LETRA		    [a-zA-Z]
ESPACIO			[" "]
INICOMENTARIO	["/*"]
FINCOMENTARIO	["*/"]
GUIONES			[_-]
LLAVE_ABRE		"{"
LLAVE_CIERRA	"}"
PAR_ABRE		"("
PAR_CIERRA		")"
COR_ABRE		"["
COR_CIERRA		"]"
CHAR_COMA		[","]
CHAR_PUNTO 		["."]
CHAR_PUNTOCOMA	[";"]
CHAR_DOSPUNTOS	[":"]

COMENTARIO 		"//".*\n

IDENTIFICADOR	({LETRA}+|{GUIONBAJO})({LETRA}|{DIGITO})*
NUMERO_REAL     (-?{DIGITO})({CHAR_PUNTO})
CADENA 			""[a-zA-Z]""

/*Operadores logicos y aritmeticos basicos */

OP_MAS  		"+"
OP_MENOS  		"-"
OP_POR  		"*"
OP_DIV 			 "/"
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
Error .

%%
{IF}       {printf("\n palabra reservada if:(%s) ",yytext);}
{FOR}	    {printf("\n palabra reservada for:(%s) ",yytext);}
{CADENA}		{printf("\n Cadena:(%s) ",yytext);}	

{WHILE}     {printf("\n palabra reservada while:(%s) ",yytext);}
{DO}        {printf("\n palabra reservada do: (%s) ",yytext);}
{SWITCH}    {printf("\n palabra reservada switch:(%s) ",yytext);}
{CASE}      {printf("\n palabra reservada case:(%s) ",yytext);}
{BREAK}     {printf("\n palabra reservada break:(%s) ",yytext);}
{CONTINUE}  {printf("\n palabra reservada continue:(%s) ",yytext);}
{ELSE}      {printf("\n palabra reservada else:(%s) ",yytext);}
{RETURN}    {printf("\n palabra reservada return:(%s) ",yytext);}
{EXTERN}    {printf("\n palabra reservada extern:(%s) ",yytext);}
{PRINTF}    {printf("\n palabra reservada printf:(%s) ",yytext);}
{VECTOR}    {printf("\n palabra reservada vector:(%s) ",yytext);}
{CONST}     {printf("\n palabra reservada const:(%s) ",yytext);}
{MAIN}      {printf("\n palabra reservada main:(%s) ",yytext);}
{INT}	     {printf("\n tipo de dato int:(%s) ",yytext);}
{FLOAT} 	 {printf("\n tipo de dato float:(%s) ",yytext);}
{DOUBLE} 	  {printf("\n tipo de dato double:(%s) ",yytext);}
{CHAR} 	      {printf("\n tipo de dato char:(%s) ",yytext);}
{IDENTIFICADOR}	{printf("\n Identificador:(%s) ",yytext);}
{NUMERO_REAL}   {printf("\n Numero real:(%s) ",yytext);}
{GUIONES}			{printf("\n Guion bajo:(%s) ",yytext);}
{LLAVE_ABRE}		{printf("\n LLAVE_ABRE:(%s) ",yytext);}
{LLAVE_CIERRA}	    {printf("\n LLAVE_CIERRA:(%s) ",yytext);}
{PAR_ABRE}		    {printf("\n PAR_ABRE:(%s) ",yytext);}
{PAR_CIERRA}	    {printf("\n PAR_CIERRA:(%s) ",yytext);}
{COR_ABRE}		    {printf("\n COR_ABRE:(%s) ",yytext);}
{COR_CIERRA}		{printf("\n COR_CIERRA:(%s) ",yytext);}

{CHAR_COMA}		    {printf("\n COMA:(%s) ",yytext);}
{CHAR_PUNTO} 		{printf("\n PUNTO:(%s) ",yytext);}
{CHAR_PUNTOCOMA}	{printf("\n PUNTO Y COMA:(%s) ",yytext);}
{CHAR_DOSPUNTOS}    {printf("\n DOS PUNTOS :(%s) ",yytext);}


{OP_MAS}  			{printf("\n Operador +:(%s) ",yytext);}
{OP_MENOS}  		{printf("\n Operador -:(%s) ",yytext);}
{OP_POR}  		    {printf("\n Operador *:(%s) ",yytext);}
{OP_DIV} 			{printf("\n Operador /:(%s) ",yytext);}
{OP_IGUAL}		    {printf("\n Operador =:(%s) ",yytext);}
{OP_MAYOR}		    {printf("\n Operador Rel >:(%s) ",yytext);}
{OP_MENOR}		    {printf("\n Operador Rel <:(%s) ",yytext);}
{OP_MAYORIGUAL}	    {printf("\n Operador Rel >=:(%s) ",yytext);}
{OP_MENORRIGUAL}	{printf("\n Operador Rel <=:(%s) ",yytext);}
{OP_COPMENOR}		{printf("\n Operador Rel ==:(%s) ",yytext);}
{OP_NEGACION}		{printf("\n Operador Rel !:(%s) ",yytext);}

{Error} 		{error++; printf("Se leyo el caracter no reconocido: %s\n",yytext);}

%%

int main (int argc, char *argv[]){
  if ((fuente=fopen(argv[1],"r"))==NULL)
		  {
		   printf("\nError, No se puede abrir archivo");
		   exit(1);
		  }
        yyin=fuente;
        que_es=yylex();

        while (que_es!=0)
	  {
		
		  printf("\tNumero de token: %d\n", que_es);
                  que_es=yylex();
		  getchar();
	 }  	
        fclose(fuente);
	printf("\nNumero de lineas analizadas: %d", nolin);
	printf("\nNumero total de errores:     %d\n", error);
return 0;


}


