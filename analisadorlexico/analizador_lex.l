/*Analizador lexico.l uso de la funcion yylex*/
%{
#include <stdio.h>
#include <stdlib.h>
#ifndef SLLIST
#define SLLIST
#include <string.h>

typedef struct node Node;
typedef struct slinked_list Slinked_list;

struct node {
	char* lexema; //lexema encontrado 
	int numlinea;//atributo numero de linea del token
	Node *next;
};

struct slinked_list {
	Node *head;
};

Slinked_list *create_slinked_list();
Node* create_node(char* lexema1,int linea);
void insert_head(Node **head_ref,char* lexema ,int linea);
void insert_end(Node **head_red,char* lexema , int linea);
void display(Slinked_list *slinked_list);
void destroy_slinked_list(Node *slinked_list);
int error=0;
int nolin=1;
int que_es;
FILE *fuente;

#endif
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


/**
 * Crear la lista ligada simple, head = NULL
 * */
Slinked_list* create_slinked_list(){
    Slinked_list *slinked_list = (Slinked_list *) malloc (sizeof(Slinked_list));
    slinked_list->head = NULL;
    return slinked_list;
}

/**
 * Crear un nodo para ser agregado a la lista
 * */
Node* create_node(char* lexema,int linea)
{
    Node *new_node = (Node *) malloc (sizeof(8 * sizeof(char)));
	new_node->lexema=lexema;
	//strcpy(new_node->lexema,lexema);
    new_node->numlinea=linea;
    new_node->next = NULL;
    return new_node;
}
/**
 * Insertar elemento en lista al inicio (head)
 **/
void insert_head(Node **head_ref,char* lexema, int linea){
    Node *new_node = create_node(lexema,linea);
    new_node->next = (*head_ref);
    (*head_ref) = new_node;
	//new_node->next = NULL;
}

void destroy_slinked_list(Node *slinked_list){
    Node *node = slinked_list;
    while(node != NULL){
        Node *temp = node; 
        node = node->next;
        free(temp);
    }   
    free(node); 
}
/**
 * Insertar elemento en lista al final
 * */
 //funciona
void insert_end(Node **head_ref,char* lexema, int linea)
{
    if (*head_ref == NULL)
	{
		printf("INSERTO HEAD");
		printf("LEXEMA HEAD %s",lexema);
        insert_head(head_ref,lexema,linea);
        return;
    }
    Node *new_node = create_node(lexema,linea);
	printf("\nLEXEMAAA: %s", new_node->lexema);
    Node *last = *head_ref;
    while(last->next != NULL)
	{
        last = last->next;
	}
    last->next = new_node;
}
void display(Slinked_list* slinked_list){
    Node *node = slinked_list->head;
    while(node != NULL)
	{ 
		printf("numLinea : %d ", node->numlinea);
        printf("lexema   : (%s) \n", node->lexema);
        node = node->next;
    }
}


int main(int argc, char *argv[])
{
 //freopen("./outfile.txt","w",stdout); // Redireccion de salida, los datos de salida se guardaran en el archivo out.txt 
 Slinked_list *slinked_list = create_slinked_list();
  if ((fuente=fopen(argv[1],"r"))!=NULL)
  {
        yyin=fuente;
        que_es=yylex();
		while (que_es!=0)
		{   
			char *lexema;
			lexema = yytext;
			printf("\t TOKEN:%d \t LEXEMA:%s LINEA: %d\n", que_es, yytext, nolin);
			insert_end(&slinked_list->head,yytext,nolin);
			que_es=yylex();//insertar en la tabla 
			getchar();
		}
		display(slinked_list);
	}
	else{
		   printf("\nError, No se puede abrir archivo");
		   exit(1);
		  }
    fclose(fuente);
	//destroy_slinked_list(slinked_list);
	printf("\nNumero de lineas analizadas: %d", nolin);
	printf("\nNumero total de errores:     %d\n", error);
  return 0;
}
