%{
	#include "symtab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
	#ifdef YYDEBUG
  	yydebug = 1;
	#endif
%}	

/* YYSTYPE union */
%union{
    char char_val;
	int int_val;
	double double_val;	
	char* str_val;
	list_t* symtab_item;
}

/* token definition */
%token Char Int Float Double PR_IF PR_ELSE PR_WHILE PR_FOR PR_CONTINUE PR_BREAK PR_SWITCH PR_RETURN PR_MAIN PR_SCANF tipos_scanf PR_PRINTF PR_EXTERN PR_CASE PR_INCLUDE 
%token PR_VECTOR op_mas op_menos op_por op_div  Inc Dec  op_igual op_mayor op_menor op_mayorigual op_menorigual op_dosigual op_negacion amperson ESPACIO 
%token guion llave_a llave_c par_a par_c cor_a cor_c coma punto punto_coma dos_puntos
%token id  Iconst numero Cconst  String  cadena  Fconst  GATO  

%start Programa

%%
Programa:  INCLUDES FuncionPrincipal
    ;

INCLUDES: GATO PR_INCLUDE op_menor  id  op_mayor  ;


FuncionPrincipal: tipo_int PR_MAIN par_a par_c llave_a lista_declaraciones lista_proposiciones PR_RETURN numero punto_coma llave_c
	;

lista_declaraciones: lista_declaraciones declaraciones 
 | declaraciones  
     ;

declaraciones : tipo lista_identificadores punto_coma 
               | error punto_coma 
			    ;

lista_identificadores : lista_identificadores coma id  
 | id 
  ;

lista_proposiciones:  lista_proposiciones  proposiciones
	 | proposiciones
	; 

proposiciones : asignacion punto_coma
               | lectura 
			   | escritura 
			   | ciclos_repeticion 
			   | estructura_control
			   | error punto_coma 
               ;

asignacion : id  op_igual expresion  ;


expresion : expresion  op_mas  termino 
 | expresion  op_menos termino 
 | expresion  op_por termino 
 | expresion  op_div termino 
 | termino
  ;


expresion_logico : expresion_logico  op_dosigual  termino
  | expresion_logico  op_mayor  termino
  | expresion_logico  op_menor  termino
  | expresion_logico  op_mayorigual  termino
  | expresion_logico  op_menorigual  termino
  | termino
  ;

 termino : numero  | id
  ;
 

lectura : PR_SCANF par_a   tipos_scanf   coma amperson id par_c punto_coma 
  
 ;  


escritura :PR_PRINTF  par_a  tipos_scanf coma id par_c punto_coma

 
 ;


ciclos_repeticion: PR_FOR par_a exp_id par_c  bloque_instruccion
    | error par_c 
   ;

exp_id : asignacion punto_coma expresion_logico punto_coma id ic_dc 

 ;


estructura_control : PR_IF par_a expresion_logico par_c   bloque_instruccion   PR_ELSE bloque_instruccion
;  

bloque_instruccion : llave_a lista_proposiciones llave_c 
  |  error llave_c
 ; 

tipo :  tipo_int 
        |Float 
		| Char 
		|Double 
;

tipo_int : Int; 

ic_dc: Inc 
 | Dec 
 ; 
%%

void yyerror ()
{
  	printf(" \n ERROR SINTACTICO!!! en la linea \t %d \n ", lineno);
}
int main (int argc, char *argv[]){

	// initialize symbol table
	init_hash_table();
	// parsing
	int flag;
	yyin = fopen(argv[1], "r");
	printf("%d", flag);
	flag = yyparse();
	yylex();
	fclose(yyin);
	
	printf("Parsing Terminado!");
	// symbol table dump
	yyout = fopen("tabladesimbolos.out", "w");
	symtab_dump(yyout);
	fclose(yyout);
	
	return flag;
}