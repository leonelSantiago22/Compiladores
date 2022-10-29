/* escáner para un lenguaje de juguete al estilo de Pascal */

%{
/* se necesita esto para la llamada a atof() más abajo */
#include <math.h>
#include<stdio.h>
FILE *in,*sal;
int l=0,e=0;
%}

DIGITO   [0-9]
ID       [a-zA-Z][a-zA-Z0-9]*



%%
\n      {l++;}
{DIGITO}+   {
            printf( "Un entero: %s (%d)\n", yytext,
                    atoi( yytext ) );
            }

{DIGITO}+"."{DIGITO}*      {
            printf( "Un real: %s (%g)\n", yytext,
                    atof( yytext ) );
            }

IF|THEN|BEGIN|END|PROCEDURE|FUNCTION        {
            printf( "Una palabra clave: %s\n", yytext );
            }

{ID}      { printf( "Un identificador: %s\n", yytext ); printf (" que tiene %d caracteres\n", yyleng);}

"+"|"-"|"*"|"/"   printf( "Un operador: %s\n", yytext );

"{"[^}\n]*"}"     /* se come una linea de comentarios */

[ \t]+          /* se come los espacios en blanco */

.          {e++; printf( "Caracter no reconocido: %s\n", yytext );}

%%

int main()
{

     if ((in = fopen("entrada.p", "rt"))  == NULL)
   {
      printf("Cannot open input file.\n");
      exit(1);

   }
  
	 yyin=in;
	 yylex(); /* inicia analisis lexico*/
	 printf("\n Se hallaron %d errores \n Total de lineas analizada: %d \n ",e,l );
   fclose(in); 
return 0;

}
