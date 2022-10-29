/* escáner para un lenguaje de juguete al estilo de Pascal */

%{
/* se necesita esto para la llamada a atof() más abajo */
#include <math.h>
#include<stdio.h>
%}

DIGITO   [0-9]
ID       [a-zA-Z][a-zA-Z0-9]*

%%

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

[ \t\n]+          /* se come los espacios en blanco */

.           printf( "Caracter no reconocido: %s\n", yytext );

%%

int main( )
    {
        
    yylex();
return 0;
    }

