%{
// ejem1.l
#include  <stdio.h>
int palabra=0, numero=0;
void bye();
%}

Numero	-?[0-9]+
Palabra	[a-zA-Z]+

%%
"bye"		{bye();return 0;}
"quit"		{bye();return 0;}
"resume"	{bye();return 0;}
{Palabra}	{printf("Se leyo la palabra : %s\n", yytext);palabra++;}
{Numero}	{printf("Se leyo el numero : %d\n", atoi(yytext));numero++;}
. 		printf("Se leyo el caracter no reconocido: %s\n",yytext);


%%
int main(){
	printf("ejem1.l\nEste ejemplo, distingue entre un numero entero y palabras.\nIntroduzca bye, quit o resume para terminar.\n");
	yylex();
return 0;
}

void bye(){
	printf("Se leyeron %d entradas, de las cuales se reconocieron\n%d\tEnteros\ny\n%d\tPalabras.\n", (palabra+numero), numero, palabra);
}


