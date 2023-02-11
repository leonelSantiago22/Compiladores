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
OP_PLUS 		"++"
OP_MINUS		"--"
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
TIPO_SCANF		(%(c|s|f|d))
/*tipos*/
INT 	"int"
FLOAT 	"float"
DOUBLE 	"double"
CHAR 	"char"
GATO	"#"

/* Palabras reservadas */
IF  	 "if"
FOR		 "for"
WHILE	 "while"
DO		 "do"
SWITCH	 "begin"
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
STDLIB 			"stdlib"
STUDIO			"studio.h"
%%

"//".*					{ printf("Cometario en la linea(%d)\n", lineno); } 

"/*"					{ printf("Cometario iniciado en (%d) ", lineno); BEGIN(ML_COMMENT); }
<ML_COMMENT>"*/" 		{ printf("to line %d\n", lineno); BEGIN(INITIAL); }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			
<ML_COMMENT>"\n"		{ lineno += 1; }



{e}
{ESPACIO_M}		
{nvalin}		{lineno++;}
{IF}        	{printf("%s ",yytext); }
{FOR}	      	{printf("%s ",yytext );}
{WHILE}     	{printf("%s ",yytext);}
{STDLIB}		{printf("biblioteca ");}
{STUDIO}		{printf("biblioteca ");}
{NUMERO}   		{printf("numero ",yytext);}
{SWITCH}    	{printf("%s ",yytext);}
{DO}        	{printf("%s ",yytext);}
{CASE}      	{printf("%s ",yytext);}
{BREAK}     	{printf("%s ",yytext);}
{CONTINUE}  	{printf("%s ",yytext);}
{ELSE}      	{printf("%s ",yytext);}
{RETURN}    	{printf("%s ",yytext);}
{EXTERN}    	{printf("%s ",yytext);}
{PRINTF}    	{printf("%s ",yytext);}
{VECTOR}    	{printf("%s ",yytext);}
{MAIN}      	{printf("%s ",yytext);}
{INT}	    	{printf("%s ",yytext);}
{FLOAT} 	  	{printf("%s ",yytext);}
{DOUBLE} 	  	{printf("%s ",yytext);}
{CHAR} 	    	{printf("%s ",yytext);}
{INCLUDE}       {printf("%s ", yytext); }
{ID} 			{printf("id ", yytext); (yytext, strlen(yytext), UNDEF, lineno);}
{CADENA}        {printf("%s ",yytext);}
{GUIONES}		{printf("%s ",yytext);}
{LLAVE_ABRE}	{printf("%s ",yytext);}
{LLAVE_CIERRA}	{printf("%s ",yytext);}
{PAR_ABRE}		{printf("%s ",yytext);}
{PAR_CIERRA}	{printf("%s ",yytext);}
{COR_ABRE}		{printf("%s ",yytext);}
{COR_CIERRA}	{printf("%s ",yytext);}
{CHAR_COMA}		{printf("%s ",yytext);}
{CHAR_PUNTOCOMA}  {printf("%s ",yytext);}
{CHAR_PUNTO} 	{printf("%s ",yytext);}
{CHAR_DOSPUNTOS}  {printf("%s ",yytext);}
{OP_MAS}  		{printf("%s ",yytext);}
{OP_POR}  		 {printf("%s ",yytext);}
{OP_DIV} 		 {printf("%s ",yytext);}
{OP_IGUAL}		 {printf("%s ",yytext);}
{OP_MAYOR}		 {printf("%s ",yytext);}
{OP_MENOR}		 {printf("%s ",yytext);}
{OP_MAYORIGUAL}	 {printf("%s ",yytext);}
{OP_MENORRIGUAL} {printf("%s ",yytext);}
{OP_COPMENOR}	 {printf("%s ",yytext);}
{OP_NEGACION}	 {printf("%s ",yytext);}
{TIPO_SCANF} 	{printf("%s ", yytext);}
{GATO}			{printf("%s ", yytext);}
[ \t\r\f]+			/* iGNORAR ESPACIOS EN BLANCOS*/
.				{ }
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

	// abrir carpeta de ingreso
	yyin = fopen(argv[1], "r");
	// analisis lexico
	freopen("./outfile.txt","w",stdout);
	yylex();
	fclose(yyin);
	//mandamos al archivo la tabla de simbolos
    //leonel santiuago rosas 
 	

	
	return 0;
}