/*Analizador lexico.l uso de la funcion yylex*/
%{
#include <stdio.h>
#include <stdlib.h>
#ifndef SLLIST
#define SLLIST
#include <string.h>
//list of list C 


typedef struct 
{
     int numlinea;
     nodo *lineas;
}linea;


typedef struct 
{
    char identificador*;
    struct nodo *next;
}nodo;


Slinked_list *create_slinked_list();
listaparalosidentificadores *crear_lista_por_lexema();
Lexema* create_node(char* lexema);
LineasporIdentificador* create_node_identificador(int linea);
void insert_head(Node **head_ref,char* lexema ,int linea);
void insert_end(Node **head_red,char* lexema , int linea);
void display(Slinked_list *slinked_list);
void destroy_slinked_list(Node *slinked_list);
int buscar_id(Slinked_list *slinked_list,char *id_buscado);
int error=0;
int nolin=1;
int que_es;
FILE *fuente;
int id=120;
#endif
%}

%option noyywrap
%option yylineno


DIGITO			[0-9]+
LETRA		    [a-zA-Z]
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
INCLUDE   "include"
Error     .
%%
{nvalin}		{printf("\n Salto de linea:(%s) ",yytext);nolin++;}
{e}
{ESPACIO_M}		{printf("ESPACIO: %s", yytext);}
{COMENTARIO}	{printf("\n COMENTARIO EN LINEA (%s)", yytext);}
{IF}        	{printf("\n palabra reservada if:(%s)",yytext); return(101);}
{FOR}	      	{printf("\n palabra reservada for:(%s)",yytext );return(102);}
{WHILE}     	{printf("\n palabra reservada while:(%s)",yytext);return(103);}
{DO}        	{printf("\n palabra reservada do: (%s)",yytext);return(104);}
{SWITCH}    	{printf("\n palabra reservada switch:(%s)",yytext);return(105);}
{CASE}      	{printf("\n palabra reservada case:(%s)",yytext);return(106);}
{BREAK}     	{printf("\n palabra reservada break:(%s)",yytext);return(107);}
{CONTINUE}  	{printf("\n palabra reservada continue:(%s)",yytext);return(108);}
{ELSE}      	{printf("\n palabra reservada else:(%s)",yytext);return(109);}
{RETURN}    	{printf("\n palabra reservada return:(%s)",yytext);return(110);}
{EXTERN}    	{printf("\n palabra reservada extern:(%s)",yytext);return(111);}
{PRINTF}    	{printf("\n palabra reservada printf:(%s)",yytext);return(112);}
{VECTOR}    	{printf("\n palabra reservada vector:(%s",yytext);return(113);}
{MAIN}      	{printf("\n palabra reservada main:(%s)",yytext);return(115);}
{INT}	    	{printf("\n tipo de dato int:(%s",yytext);return(116);}
{FLOAT} 	  	{printf("\n tipo de dato float:(%s)",yytext);return(117);}
{DOUBLE} 	  	{printf("\n tipo de dato double:(%s)",yytext);return(118);}
{CHAR} 	    	{printf("\n tipo de dato char:(%s)",yytext);return(119);}
{INCLUDE}       {printf("\n include palabra reservada %s", yytext); return(146);}
{IDENTIFICADOR}	{printf("\n Identificador:(%s)",yytext);return(120);}
{NUMERO}   {printf("\n Numero:(%s)",yytext);return(121);}
{CADENA}        {printf("\n CADENA DE TEXTO:(%s) ",yytext);return(122);}
{GUIONES}		{printf("\n GUIONES:(%s",yytext);return(123);}
{LLAVE_ABRE}	{printf("\n LLAVE_ABRE:(%s",yytext);return(124);}
{LLAVE_CIERRA}	{printf("\n LLAVE_CIERRA:(%s)",yytext);return(125);}
{PAR_ABRE}		{printf("\n PAR_ABRE:(%s) ",yytext);return(126);}
{PAR_CIERRA}	{printf("\n PAR_CIERRA:(%s) ",yytext);return(127);}
{COR_ABRE}		{printf("\n COR_ABRE:(%s) ",yytext);return(128);}
{COR_CIERRA}	{printf("\n COR_CIERRA:(%s) ",yytext);return(129);}
{CHAR_COMA}		{printf("\n COMA:(%s) ",yytext);return(131);}
{CHAR_PUNTO} 	{printf("\n PUNTO:(%s) ",yytext);return(132);}
{CHAR_PUNTOCOMA}  {printf("\n PUNTO Y COMA:(%s) ",yytext);return(133);}
{CHAR_DOSPUNTOS}  {printf("\n DOS PUNTOS :(%s) ",yytext);return(134);}
{OP_MAS}  		{printf("\n Operador +:(%s)",yytext);return(135);}
{OP_POR}  		 {printf("\n Operador *:(%s)",yytext);return(137);}
{OP_DIV} 		 {printf("\n Operador /:(%s)",yytext);return(138);}
{OP_IGUAL}		 {printf("\n Operador =:(%s)",yytext);return(139);}
{OP_MAYOR}		 {printf("\n Operador Rel >:(%s",yytext);return(140);}
{OP_MENOR}		 {printf("\n Operador Rel <:(%s) ",yytext);return(141);}
{OP_MAYORIGUAL}	 {printf("\n Operador Rel >=:(%s)",yytext);return(142);}
{OP_MENORRIGUAL} {printf("\n Operador Rel <=:(%s)",yytext);return(143);}
{OP_COPMENOR}	 {printf("\n Operador Rel ==:(%s)",yytext);return(144);}
{OP_NEGACION}	 {printf("\n Operador Rel !:(%s)",yytext, nolin);return(145);}
{Error} 		{error++; printf("\nSe leyo el caracter no reconocido: (%s)\n",yytext, nolin);}

%%
//




int main(int argc, char *argv[])
{
      int primer_id=0;
      char *lexema;
 //freopen("./outfile.txt","w",stdout); // Redireccion de salida, los datos de salida se guardaran en el archivo out.txt 
 Slinked_list *slinked_list = create_slinked_list();
  if ((fuente=fopen(argv[1],"r"))!=NULL)
  {
        //int size = 1000;
        yyin=fuente;
        que_es=yylex();
		while (que_es!=0)
		{   
			printf("\t TOKEN:%d \t LEXEMA:%s LINEA: %d\n", que_es, yytext, nolin);
            //strcpy(lexema,yytext);
            if(que_es==120 && primer_id==0 ){// si es un id y no esta repetido en la lista
                  //printf("INSERTO \n");
                  insert_end(&slinked_list->head,yytext,nolin);
                  primer_id=1;
            }

            if(que_es==120 && primer_id==1){
               int repetido_id=buscar_id(slinked_list,yytext);
                if(repetido_id==1){
                     printf("hay un identificador repetido \n");
                     
                     //insert_end(&slinked_list->head,yytext,nolin);
                }else{
                    insert_end(&slinked_list->head,yytext,nolin);
                }
                // primer_id=0;
            }
           
                
			que_es=yylex();//insertar en la tabla 
			//getchar();
		
	}
  }
	else{
		   printf("\nError, No se puede abrir archivo");
		   exit(1);
		}
	printf("NumLinea \t lexema\n");
	display(slinked_list);
	freopen("./outfile.txt","w",stdout);
	display(slinked_list);
    fclose(fuente);
	//destroy_slinked_list(slinked_list);
	printf("\nNumero de lineas analizadas: %d", nolin);
	printf("\nNumero total de errores:     %d\n", error);
  return 0;
}