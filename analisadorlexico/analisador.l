%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	
	extern FILE *yyin;
	extern FILE *yyout;
	
	int lineno = 1; //comenzamos desde la linea 1
	void ret_print(char *token_type);
	void yyerror();

    /* tam maximo de la tabla hash */
#define SIZE 211

/* numero maximo de identificadores (tokens) */
#define MAXTOKENLEN 40

/* tipos de token */
#define UNDEF 0
#define INT_TYPE 1
#define REAL_TYPE 2
#define STR_TYPE 3
#define LOGIC_TYPE 4
#define ARRAY_TYPE 5
#define FUNCTION_TYPE 6

/* como el parametro es pasado */
#define BY_VALUE 1
#define BY_REFER 2

/* alcance actual */
int cur_scope = 0;

/* estructura de los parametros */
typedef struct Param{
	int par_type;
	char param_name[MAXTOKENLEN];
	// almacenar valor
	int ival; double fval; char *st_sval;
	int passing; // por valor o referencia
}Param;

/* numero de linea en lista enlazada de referencias para cada variable */
typedef struct RefList{ 
    int lineno;
    struct RefList *next;
    int type;
}RefList;

// esta estructura representa una lista de nodos
typedef struct list_t{
	char st_name[MAXTOKENLEN];
    int st_size;
    int scope;
    RefList *lines;
	//para almacenar valor e informacion
	int st_ival; double st_fval; char *st_sval;
	// tipo
    int st_type;
	int inf_type; //  para los arrglos informacion del tipo y funciones o que retornan 
	// elementos del arreglo
	int *i_vals; double *f_vals; char **s_vals;
	int array_size;
	// parametros de la funcion
	Param *parameters;
	int num_of_pars;
	// apuntador al siguiente elemento de la lista
	struct list_t *next;
}list_t;

/* tabla hash */
static list_t **hash_table;

// prototipos de funciones
void init_hash_table(); // inicializar la tabla
unsigned int hash(char *key); // funcion hash 
void insert(char *name, int len, int type, int lineno); // insertar entradas
list_t *lookup(char *name); // buscar segun la entrada
list_t *lookup_scope(char *name, int scope); // buscar la entrada por alcance
void hide_scope(); // ocultar alcance actual
void incr_scope(); // ir al alcance
void symtab_dump(FILE *of); // papelera de carpetas

%}

%x ML_COMMENT

DIGITO			[0-9]+
LETRA		    [a-zA-Z]
alnum 		{LETRA}|{DIGITO}
print		[ -~]
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

%%

"//".*					{ printf("Cometario en la linea(%d)\n", lineno); } 

"/*"					{ printf("Cometario iniciado en (%d) ", lineno); BEGIN(ML_COMMENT); }
<ML_COMMENT>"*/" 		{ printf("to line %d\n", lineno); BEGIN(INITIAL); }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			
<ML_COMMENT>"\n"		{ lineno += 1; }



{e}
{ESPACIO_M}		{printf("ESPACIO: %s", yytext);}
{nvalin}		{printf("\n Salto de linea: ",yytext);lineno++;}
{IF}        	{printf("\n palabra reservada if:(%s)",yytext); }
{FOR}	      	{printf("\n palabra reservada for:(%s)",yytext );}
{WHILE}     	{printf("\n palabra reservada while:(%s)",yytext);}
{DO}        	{printf("\n palabra reservada do: (%s)",yytext);}
{SWITCH}    	{printf("\n palabra reservada switch:(%s)",yytext);}
{CASE}      	{printf("\n palabra reservada case:(%s)",yytext);}
{BREAK}     	{printf("\n palabra reservada break:(%s)",yytext);}
{CONTINUE}  	{printf("\n palabra reservada continue:(%s)",yytext);}
{ELSE}      	{printf("\n palabra reservada else:(%s)",yytext);}
{RETURN}    	{printf("\n palabra reservada return:(%s)",yytext);}
{EXTERN}    	{printf("\n palabra reservada extern:(%s)",yytext);}
{PRINTF}    	{printf("\n palabra reservada printf:(%s)",yytext);}
{VECTOR}    	{printf("\n palabra reservada vector:(%s",yytext);}
{MAIN}      	{printf("\n palabra reservada main:(%s)",yytext);}
{INT}	    	{printf("\n tipo de dato int:(%s",yytext);}
{FLOAT} 	  	{printf("\n tipo de dato float:(%s)",yytext);}
{DOUBLE} 	  	{printf("\n tipo de dato double:(%s)",yytext);}
{CHAR} 	    	{printf("\n tipo de dato char:(%s)",yytext);}
{INCLUDE}       {printf("\n include palabra reservada %s", yytext); }
{ID} 			{
					// insetamos el identificador en la tabla de simbolos
					insert(yytext, strlen(yytext), UNDEF, lineno);
					ret_print("ID");
				}
{ICONST} 		{ ret_print("ICONST"); }
{FCONST} 		{ ret_print("FCONST"); }
{CCONST} 		{ ret_print("CCONST"); }
{STRING} 		{ ret_print("STRING"); }

{NUMERO}   {printf("\n Numero:(%s)",yytext);}
{CADENA}        {printf("\n CADENA DE TEXTO:(%s) ",yytext);}
{GUIONES}		{printf("\n GUIONES:(%s",yytext);}
{LLAVE_ABRE}	{printf("\n LLAVE_ABRE:(%s",yytext);}
{LLAVE_CIERRA}	{printf("\n LLAVE_CIERRA:(%s)",yytext);}
{PAR_ABRE}		{printf("\n PAR_ABRE:(%s) ",yytext);}
{PAR_CIERRA}	{printf("\n PAR_CIERRA:(%s) ",yytext);}
{COR_ABRE}		{printf("\n COR_ABRE:(%s) ",yytext);}
{COR_CIERRA}	{printf("\n COR_CIERRA:(%s) ",yytext);}
{CHAR_COMA}		{printf("\n COMA:(%s) ",yytext);}
{CHAR_PUNTO} 	{printf("\n PUNTO:(%s) ",yytext);}
{CHAR_PUNTOCOMA}  {printf("\n PUNTO Y COMA:(%s) ",yytext);}
{CHAR_DOSPUNTOS}  {printf("\n DOS PUNTOS :(%s) ",yytext);}
{OP_MAS}  		{printf("\n Operador +:(%s)",yytext);}
{OP_POR}  		 {printf("\n Operador *:(%s)",yytext);}
{OP_DIV} 		 {printf("\n Operador /:(%s)",yytext);}
{OP_IGUAL}		 {printf("\n Operador =:(%s)",yytext);}
{OP_MAYOR}		 {printf("\n Operador Rel >:(%s",yytext);}
{OP_MENOR}		 {printf("\n Operador Rel <:(%s) ",yytext);}
{OP_MAYORIGUAL}	 {printf("\n Operador Rel >=:(%s)",yytext);}
{OP_MENORRIGUAL} {printf("\n Operador Rel <=:(%s)",yytext);}
{OP_COPMENOR}	 {printf("\n Operador Rel ==:(%s)",yytext);}
{OP_NEGACION}	 {printf("\n Operador Rel !:(%s)",yytext);}

[ \t\r\f]+			/* iGNORAR ESPACIOS EN BLANCOS*/
.				{ yyerror("Caracter no reconozido "); }
%%


void init_hash_table(){
	int i; 
	hash_table = malloc(SIZE * sizeof(list_t*));
	for(i = 0; i < SIZE; i++) hash_table[i] = NULL;
}

unsigned int hash(char *key){
	unsigned int hashval = 0;
	for(;*key!='\0';key++) hashval += *key;
	hashval += key[0] % 11 + (key[0] << 3) - key[0];
	return hashval % SIZE;
}

void insert(char *name, int len, int type, int lineno){
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	
	while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;
	
	/* La variable a un no encuentra en la tabla*/
	if (l == NULL){
		l = (list_t*) malloc(sizeof(list_t));
		strncpy(l->st_name, name, len);  
		/* Lo agregamos a la tabla de symbolos hash */
		l->st_type = type;
		l->scope = cur_scope;
		l->lines = (RefList*) malloc(sizeof(RefList));
		l->lines->lineno = lineno;
		l->lines->next = NULL;
		l->next = hash_table[hashval];
		hash_table[hashval] = l; 
		printf("\nInsertado (%s) por primera vez en la linea %d!\n", name, lineno); // error de chequeo
	}
	/*Debemos encontrar si ya se encuentra en la tabla, entonces solo agregramamos el numero de linea */
	else{
		l->scope = cur_scope;
		RefList *t = l->lines;
		while (t->next != NULL) t = t->next;
		/* agregar el numero de linea en la lista */
		t->next = (RefList*) malloc(sizeof(RefList));
		t->next->lineno = lineno;
		t->next->next = NULL;
		printf("Encontrado (%s) nuevamente en %d!\n", name, lineno);
	}
}

list_t *lookup(char *name){ /*  regresar el simbolo si se encontro o null si no*/ 
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;
	return l; // no se hallo NULL
}

list_t *lookup_scope(char *name, int scope){ /* regresa el simbolo si se encuentra o null si no*/
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	while ((l != NULL) && (strcmp(name,l->st_name) != 0) && (scope != l->scope)) l = l->next;
	return l; // no se encontro NULL
}

void hide_scope(){ /*ocultar el alcance actual */
	if(cur_scope > 0) cur_scope--;
}

void incr_scope(){ /* ir al siguiente alcance */
	cur_scope++;
}

/* imprimir por default stdout  */ 
void symtab_dump(FILE * of){  
  int i;
  fprintf(of,"------------ ------ ------------\n");
  fprintf(of,"Nombre                Numero de linea\n");
  fprintf(of,"------------ ------ -------------\n");
  for (i=0; i < SIZE; ++i){ 
	if (hash_table[i] != NULL){ 
		list_t *l = hash_table[i];
		while (l != NULL){ 
			RefList *t = l->lines;
			fprintf(of,"%-12s ",l->st_name);
			if (l->st_type == INT_TYPE) fprintf(of,"%-7s","int");
			else if (l->st_type == REAL_TYPE) fprintf(of,"%-7s","real");
			else if (l->st_type == STR_TYPE) fprintf(of,"%-7s","string");
			else if (l->st_type == ARRAY_TYPE){
				fprintf(of,"array of ");
				if (l->inf_type == INT_TYPE) 		   fprintf(of,"%-7s","int");
				else if (l->inf_type  == REAL_TYPE)    fprintf(of,"%-7s","real");
				else if (l->inf_type  == STR_TYPE) 	   fprintf(of,"%-7s","string");
				else fprintf(of,"%-7s","");
			}
			else if (l->st_type == FUNCTION_TYPE){
				fprintf(of,"%-7s %s","function returns ");
				if (l->inf_type == INT_TYPE) 		   fprintf(of,"%-7s","int");
				else if (l->inf_type  == REAL_TYPE)    fprintf(of,"%-7s","real");
				else if (l->inf_type  == STR_TYPE) 	   fprintf(of,"%-7s","string");
				else fprintf(of,"%-7s","");
			}
			else fprintf(of,"%-7s",""); // si es indefinido o 0
			while (t != NULL){
				fprintf(of,"%4d ",t->lineno);
			t = t->next;
			}
			fprintf(of,"\n");
			l = l->next;
		}
    }
  }
}


void ret_print(char *token_type){
	printf("\ttoken: %s\n numero de linea: %d\n", yytext , lineno);
}

void yyerror(char *message){
	printf("Error: \"%s\" in line %d. Token = %s\n", message, lineno, yytext);
	//exit(1);
}

int main(int argc, char *argv[]){
	// inicializador de la tabla de simbolos
	init_hash_table();

	// abrir carpeta de ingreso
	yyin = fopen(argv[1], "r");
	
	// analisis lexico
	yylex();
	fclose(yyin);
	
	//mandamos al archivo la tabla de simbolos
    //leonel santiuago rosas 

	yyout = fopen("tabladesimbolos.out", "w");
	symtab_dump(yyout);
	fclose(yyout);	
	
	return 0;
}