%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	
	extern FILE *yyin;
	extern FILE *yyout;
	
	int lineno = 1; // initialize to 1
	void ret_print(char *token_type);
	void yyerror();

    /* maximum size of hash table */
#define SIZE 211

/* maximum size of tokens-identifiers */
#define MAXTOKENLEN 40

/* token types */
#define UNDEF 0
#define INT_TYPE 1
#define REAL_TYPE 2
#define STR_TYPE 3
#define LOGIC_TYPE 4
#define ARRAY_TYPE 5
#define FUNCTION_TYPE 6

/* how parameter is passed */
#define BY_VALUE 1
#define BY_REFER 2

/* current scope */
int cur_scope = 0;

/* parameter struct */
typedef struct Param{
	int par_type;
	char param_name[MAXTOKENLEN];
	// to store value
	int ival; double fval; char *st_sval;
	int passing; // value or reference
}Param;

/* a linked list of references (lineno's) for each variable */
typedef struct RefList{ 
    int lineno;
    struct RefList *next;
    int type;
}RefList;

// struct that represents a list node
typedef struct list_t{
	char st_name[MAXTOKENLEN];
    int st_size;
    int scope;
    RefList *lines;
	// to store value and sometimes more information
	int st_ival; double st_fval; char *st_sval;
	// type
    int st_type;
	int inf_type; // for arrays (info type) and functions (return type)
	// array stuff
	int *i_vals; double *f_vals; char **s_vals;
	int array_size;
	// function parameters
	Param *parameters;
	int num_of_pars;
	// pointer to next item in the list
	struct list_t *next;
}list_t;

/* the hash table */
static list_t **hash_table;

// Function Declarations
void init_hash_table(); // initialize hash table
unsigned int hash(char *key); // hash function 
void insert(char *name, int len, int type, int lineno); // insert entry
list_t *lookup(char *name); // search for entry
list_t *lookup_scope(char *name, int scope); // search for entry in scope
void hide_scope(); // hide the current scope
void incr_scope(); // go to next scope
void symtab_dump(FILE *of); // dump file

%}

%x ML_COMMENT

alpha 		[a-zA-Z]
digit 		[0-9]
alnum 		{alpha}|{digit}
print		[ -~]

ID 			{alpha}+{alnum}*
ICONST		"0"|[0-9]{digit}*
FCONST		"0"|{digit}*"."{digit}+
CCONST		(\'{print}\')|(\'\\[nftrbv]\')
STRING		\"{print}*\"

%%

"//".*					{ printf("Eat up comment at line %d\n", lineno); } 

"/*"					{ printf("Eat up comment from line %d ", lineno); BEGIN(ML_COMMENT); }
<ML_COMMENT>"*/" 		{ printf("to line %d\n", lineno); BEGIN(INITIAL); }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			
<ML_COMMENT>"\n"		{ lineno += 1; }


"char"|"CHAR"       	{ ret_print("KEYWORD_CHAR"); }
"int"|"INT"				{ ret_print("KEYWORD_INT"); }
"float"|"FLOAT"			{ ret_print("KEYWORD_FLOAT"); }
"double"|"DOUBLE"		{ ret_print("KEYWORD_DOUBLE"); }
"if"|"IF"				{ ret_print("KEYWORD_IF"); }
"else"|"ELSE"			{ ret_print("KEYWORD_ELSE"); }
"while"|"WHILE"			{ ret_print("KEYWORD_WHILE"); }
"for"|"FOR"				{ ret_print("KEYWORD_FOR"); }
"continue"|"CONTINUE"	{ ret_print("KEYWORD_CONTINUE"); }
"break"|"BREAK"			{ ret_print("KEYWORD_BREAK"); }
"void"|"VOID"			{ ret_print("KEYWORD_VOID"); }
"return"|"RETURN"		{ ret_print("KEYWORD_RETURN"); }


"+"|"-"					{ ret_print("ADDOP"); }
"*"						{ ret_print("MULOP"); }
"/"						{ ret_print("DIVOP"); }
"++"|"--"				{ ret_print("INCR"); }
"||"					{ ret_print("OROP"); }
"&&"					{ ret_print("ANDOP"); }
"!"						{ ret_print("NOTOP"); }
"=="|"!="				{ ret_print("EQUOP"); }
">"|"<"|">="|"<="		{ ret_print("RELOP"); }


"("				{ ret_print("LPAREN"); }
")"				{ ret_print("RPAREN"); }
"]"				{ ret_print("LBRACK"); }
"["				{ ret_print("RBRACK"); }
"{"				{ ret_print("LBRACE"); }
"}"				{ ret_print("RBRACE"); }
";"				{ ret_print("SEMI"); }
"."				{ ret_print("DOT"); }
","				{ ret_print("COMMA"); }
"="				{ ret_print("ASSIGN"); }
"&"				{ ret_print("REFER"); }


{ID} 			{
					// insert identifier into symbol table
					insert(yytext, strlen(yytext), UNDEF, lineno);
					ret_print("ID");
				}
{ICONST} 		{ ret_print("ICONST"); }
{FCONST} 		{ ret_print("FCONST"); }
{CCONST} 		{ ret_print("CCONST"); }
{STRING} 		{ ret_print("STRING"); }


"\n"			{ lineno += 1; }
[ \t\r\f]+			/* eat up whitespace */

.				{ yyerror("Unrecognized character"); }

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
	
	/* variable not yet in table */
	if (l == NULL){
		l = (list_t*) malloc(sizeof(list_t));
		strncpy(l->st_name, name, len);  
		/* add to hashtable */
		l->st_type = type;
		l->scope = cur_scope;
		l->lines = (RefList*) malloc(sizeof(RefList));
		l->lines->lineno = lineno;
		l->lines->next = NULL;
		l->next = hash_table[hashval];
		hash_table[hashval] = l; 
		printf("Inserted %s for the first time with linenumber %d!\n", name, lineno); // error checking
	}
	/* found in table, so just add line number */
	else{
		l->scope = cur_scope;
		RefList *t = l->lines;
		while (t->next != NULL) t = t->next;
		/* add linenumber to reference list */
		t->next = (RefList*) malloc(sizeof(RefList));
		t->next->lineno = lineno;
		t->next->next = NULL;
		printf("Found %s again at line %d!\n", name, lineno);
	}
}

list_t *lookup(char *name){ /* return symbol if found or NULL if not found */
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;
	return l; // NULL is not found
}

list_t *lookup_scope(char *name, int scope){ /* return symbol if found or NULL if not found */
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	while ((l != NULL) && (strcmp(name,l->st_name) != 0) && (scope != l->scope)) l = l->next;
	return l; // NULL is not found
}

void hide_scope(){ /* hide the current scope */
	if(cur_scope > 0) cur_scope--;
}

void incr_scope(){ /* go to next scope */
	cur_scope++;
}

/* print to stdout by default */ 
void symtab_dump(FILE * of){  
  int i;
  fprintf(of,"------------ ------ ------------\n");
  fprintf(of,"Name         Type   Line Numbers\n");
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
				else fprintf(of,"%-7s","undef");
			}
			else if (l->st_type == FUNCTION_TYPE){
				fprintf(of,"%-7s %s","function returns ");
				if (l->inf_type == INT_TYPE) 		   fprintf(of,"%-7s","int");
				else if (l->inf_type  == REAL_TYPE)    fprintf(of,"%-7s","real");
				else if (l->inf_type  == STR_TYPE) 	   fprintf(of,"%-7s","string");
				else fprintf(of,"%-7s","undef");
			}
			else fprintf(of,"%-7s","undef"); // if UNDEF or 0
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
	printf("yytext: %s\ttoken: %s\tlineno: %d\n", yytext, token_type, lineno);
}

void yyerror(char *message){
	printf("Error: \"%s\" in line %d. Token = %s\n", message, lineno, yytext);
	//exit(1);
}

int main(int argc, char *argv[]){
	// initialize symbol table
	init_hash_table();

	// open input file
	yyin = fopen(argv[1], "r");
	
	// lexical analysis
	yylex();
	fclose(yyin);
	
	// symbol table dump
	yyout = fopen("symtab_dump.out", "w");
	symtab_dump(yyout);
	fclose(yyout);	
	
	return 0;
}