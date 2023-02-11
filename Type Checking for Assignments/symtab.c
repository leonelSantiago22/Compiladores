#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantics.h"
#include "symtab.h"

/* current scope */
int cur_scope = 0;

/* flag variable for declaring */
int declare = 0; // 1: declaring variable, 0: not

// Symbol Table Functions

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
		/* check if we are really declaring */
		if(declare == 1){
			/* set up entry */
			l = (list_t*) malloc(sizeof(list_t));
			strncpy(l->st_name, name, len);
			l->st_size = len;
			l->st_type = type;
			l->scope = cur_scope;
			l->lines = (RefList*) malloc(sizeof(RefList));
			l->lines->lineno = lineno;
			l->lines->next = NULL;
			
			/* add to hashtable */
			l->next = hash_table[hashval];
			hash_table[hashval] = l; 
			// printf("Inserted %s for the first time with linenumber %d!\n", name, lineno);
		}
		else{
			/* add it to check it again later */
			l = (list_t*) malloc(sizeof(list_t));
			strncpy(l->st_name, name, len);
			l->st_size = len;
			l->st_type = type;
			l->scope = cur_scope;
			l->lines = (RefList*) malloc(sizeof(RefList));
			l->lines->lineno = lineno;
			l->lines->next = NULL;
			l->next = hash_table[hashval];
			hash_table[hashval] = l;
			// printf("Inserted %s at line %d to check it again later!\n", name, lineno);
			
			/* Adding identifier to the revisit queue! */
			add_to_queue(l, l->st_name, PARAM_CHECK);
		}
	}
	/* found in table */
	else{
		// just add line number
		if(declare == 0){
			/* find last reference */
			RefList *t = l->lines;
			while (t->next != NULL) t = t->next;
			
			/* add linenumber to reference list */
			t->next = (RefList*) malloc(sizeof(RefList));
			t->next->lineno = lineno;
			t->next->next = NULL;
			// printf("Found %s again at line %d!\n", name, lineno);
		}
		/* new entry */
		else{
			/* same scope - multiple declaration error! */
			if(l->scope == cur_scope){
				fprintf(stderr, "Declaración múltiple de la variable %s en la línea %d\n", name, lineno);
 				exit(1);
			}
			/* other scope - create new entry */
			else{
				/* set up entry */
				l = (list_t*) malloc(sizeof(list_t));
				strncpy(l->st_name, name, len);
				l->st_size = len;
				l->st_type = type;
				l->scope = cur_scope;
				l->lines = (RefList*) malloc(sizeof(RefList));
				l->lines->lineno = lineno;
				l->lines->next = NULL;
				
				/* add to hashtable */
				l->next = hash_table[hashval];
				hash_table[hashval] = l; 
				// printf("Inserted %s for a new scope with linenumber %d!\n", name, lineno);
			}	
		}		
	}
}

list_t *lookup(char *name){ /* return symbol if found or NULL if not found */
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;
	return l;
}

void symtab_dump(FILE * of){  /* dump file */
  int i;
  fprintf(of,"------------ -------------- -----------------\n");
  fprintf(of,"Nombre       Tipo           Numero de Lineas\n");
  fprintf(of,"------------ -------------- ----------------\n");
  for (i=0; i < SIZE; ++i){ 
	if (hash_table[i] != NULL){ 
		list_t *l = hash_table[i];
		while (l != NULL){ 
			RefList *t = l->lines;
			fprintf(of,"%-13s",l->st_name);
			if (l->st_type == INT_TYPE)                fprintf(of,"%-15s","int");
			else if (l->st_type == REAL_TYPE)          fprintf(of,"%-15s","real");
			else if (l->st_type == CHAR_TYPE)          fprintf(of,"%-15s","char");
			else if (l->st_type == VOID_TYPE)          fprintf(of,"%-15s","void");
			else if (l->st_type == ARRAY_TYPE){
				fprintf(of,"arreglo de ");
				if (l->inf_type == INT_TYPE) 		   fprintf(of,"%-6s","int");
				else if (l->inf_type  == REAL_TYPE)    fprintf(of,"%-6s","real");
				else if (l->inf_type  == CHAR_TYPE)    fprintf(of,"%-6s","char");
				else fprintf(of,"%-13s","undef");
			}
			else if (l->st_type == POINTER_TYPE){
				fprintf(of,"apuntador de ");
				if (l->inf_type == INT_TYPE) 		   fprintf(of,"%-4s","int");
				else if (l->inf_type  == REAL_TYPE)    fprintf(of,"%-4s","real");
				else if (l->inf_type  == CHAR_TYPE)    fprintf(of,"%-4s","char");
				else if (l->inf_type  == VOID_TYPE)    fprintf(of,"%-4s","void");
				else fprintf(of,"%-4s","undef");
			}
			else if (l->st_type == FUNCTION_TYPE){
				fprintf(of,"func ret ");
				if (l->inf_type == INT_TYPE) 		   fprintf(of,"%-6s","int");
				else if (l->inf_type  == REAL_TYPE)    fprintf(of,"%-6s","real");
				else if (l->inf_type  == CHAR_TYPE)	   fprintf(of,"%-6s","char");
				else if (l->inf_type  == VOID_TYPE)	   fprintf(of,"%-6s","void");
				else fprintf(of,"%-4s","undef");
			}
			else fprintf(of,"%-15s","undef"); // if UNDEF or 0
		
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

// Type Functions

void set_type(char *name, int st_type, int inf_type){ // set the type of an entry (declaration)
	/* lookup entry */
	list_t *l = lookup(name);
	
	/* set as "main" type */
	l->st_type = st_type;
	
	/* if array, pointer or function */
	if(inf_type != UNDEF){
		l->inf_type = inf_type;
	}
}

int get_type(char *name){ // get the type of an entry
	/* lookup entry */
	list_t *l = lookup(name);
	
	/* if "simple" type */
	if(l->st_type == INT_TYPE || l->st_type == REAL_TYPE || l->st_type == CHAR_TYPE){
		return l->st_type;
	}
	/* if array, pointer or function */
	else{
		return l->inf_type;
	}
}

// Scope Management Functions

void hide_scope(){ /* hide the current scope */
	list_t *l;
	int i;
	// printf("Hiding scope \'%d\':\n", cur_scope);
	/* for all the lists */
	for (i = 0; i < SIZE; i++){
		if(hash_table[i] != NULL){
			l = hash_table[i];
			/* Find the first item that is from another scope */
			while(l != NULL && l->scope == cur_scope){
				// printf("Hiding %s..\n", l->st_name);
				l = l->next;
			}
			/* Set the list equal to that item */
			hash_table[i] = l;
		}
	}
	cur_scope--;
}

void incr_scope(){ /* go to next scope */
	cur_scope++;
}

// Function Declaration and Parameters

Param def_param(int par_type, char *param_name, int passing){ // define parameter
	Param param; /* Parameter struct */
	
	/* set the information */
	param.par_type = par_type;
	strcpy(param.param_name, param_name);
	param.passing = passing;	
	
	/* return the structure */
	return param;
}

int func_declare(char *name, int ret_type, int num_of_pars, Param *parameters){ // declare function
	/* lookup entry */
	list_t *l = lookup(name);
	
	/* if type is not defined yet */
	if(l->st_type != UNDEF){
		/* entry is of function type */
		l->st_type = FUNCTION_TYPE;
		
		/* return type is ret_type */
		l->inf_type = ret_type;
		
		/* parameter stuff */
		l->num_of_pars = num_of_pars;
		l->parameters = parameters;
		
		return 0; /* success */
	}
	/* already declared error */
	else{
		fprintf(stderr, "¡Función %s ya declarada!\n", name);
		exit(1);
	}
}

int func_param_check(char *name, int num_of_pars, Param *parameters){ // check parameters
	int i, type_1, type_2;
	
	/* lookup entry */
	list_t *l = lookup(name);
	
	/* check number of parameters */
	if(l->num_of_pars != num_of_pars){
		fprintf(stderr, "La llamada a la función %s tiene un número incorrecto de parámetros\n", name);
		exit(1);
	}
	
	/* check if parameters are compatible */
	for(i = 0; i < num_of_pars; i++){
		/* type of parameter in function declaration */
		type_1 = l->parameters[i].par_type; 
		
		/* type of parameter in function call*/
		type_2 = parameters[i].par_type; 
		
		/* check compatibility for function call */
		get_result_type(type_1, type_2, NONE);
		/* error occurs automatically in the function */
	}
	
	return 0; /* success */
}

// Revisit Queue Functions

void add_to_queue(list_t *entry, char *name, int type){ /* add to queue */
	revisit_queue *q;
	
	/* queue is empty */
	if(queue == NULL){
		/* set up entry */
		q = (revisit_queue*) malloc(sizeof(revisit_queue));
		q->entry = entry;
		q->st_name = name;
		q->revisit_type = type;
		q->next = NULL;
		
		/* q "becomes" the queue */
		queue = q;
	}
	/* queue not empty */
	else{
		/* find last element */
		q = queue;
		while(q->next != NULL) q = q->next;
		
		/* add element to the end */
		q->next = (revisit_queue*) malloc(sizeof(revisit_queue));
		q->next->entry = entry;
		q->next->st_name = name;
		q->next->revisit_type = type;
		q->next->next = NULL;
	}		
}

revisit_queue *search_queue(char *name){ /* search queue */
	revisit_queue *q;
	
	/* search for the entry */
	q = queue;
	while( strcmp(q->st_name, name) != 0 ) q = q->next;
	
	return q;
}

int revisit(char *name){ /* revisit entry by also removing it from queue */
	revisit_queue *q;
	
	/* special case - first entry */
	if( strcmp(queue->st_name, name) == 0 ){
		
		/* revisit entry depending on the type */
		switch(queue->revisit_type){
			case PARAM_CHECK:
				/* TO DO: run parameter check */
				break;
			/* ... */
		}
		
		/* remove entry by setting queue to "next" */
		queue = queue->next;
		
		return 0; // success
	}
	
	/* search for the entry that points to it */
	q = queue;
	while( strcmp(q->next->st_name, name) != 0 ) q = q->next;
	
	/* check if entry was not found */
	if(q == NULL){
		return 1;  // not found
	}
	
	/* revisit entry depending on the type */
	switch(q->next->revisit_type){
		case PARAM_CHECK:
			/* TO DO: run parameter check */
			break;
		/* ... */
	}
	
	/* remove entry by making the previous entry point at */
	/* the "next" of the entry that we want to remove  */
	q->next = q->next->next;	
	
	return 0; // success
}

void revisit_dump(FILE *of){
	int i;
	revisit_queue *q;
	q = queue;
	
	fprintf(of,"-------------- ---------------\n");
	fprintf(of,"Identificador  Tipo de visita\n");
	fprintf(of,"-------------- ---------------\n");
  	while(q != NULL){
  		fprintf(of, "%-13s", q->st_name);
  		if(q->revisit_type == PARAM_CHECK){
  			fprintf(of,"%s","Comprobación de parámetros");
		}
		// more later on
		fprintf(of, "\n");
  		q = q->next;	
	}
}
