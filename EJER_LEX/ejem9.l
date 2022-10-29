/*Analizador lexico.l uso de la funcion yylex*/
%{
#include <stdio.h>
#include <stdlib.h>


int nolin=1, error=0;
int que_es;

FILE *fuente;
%}
/*Definiciones regulares*/
digito [0-9]
letra [a-zA-Z]
nvalin   "\n"
e [ \t]
eb {e}+
op_mas  "+"
op_men  "-"
op_por  "*"
op_div  "/"
delim  ";"
parizq "("
parder ")"
op_or "or"
id {letra}({letra}|{digito})*
int {digito}+
Error .
%%
{eb}
{nvalin} {nolin++;}
{op_or} {printf("lexema %s ",yytext);return(100);}
{op_mas} {printf("lexema %s",yytext); return(101); }
{op_men} { printf("lexema %s",yytext); return(102); }
{op_por} {printf("lexema %s",yytext);   return (103); }
{op_div} {printf("lexema %s",yytext); return(104); }
{delim} { printf("lexema %s",yytext);return(-1 );}
{parizq} {printf("lexema %s",yytext);return(105);}
{parder} {printf("lexema %s",yytext);return(106);}
{int} {printf("lexema %s",yytext);return(107);}
{id} {printf("lexema %s",yytext);return(108); }
{Error} { printf(" Error Lexico: %s\n",yytext); error++;}
%%
int main(int argc, char *argv[])
{       if ((fuente=fopen(argv[1],"r"))==NULL)
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
