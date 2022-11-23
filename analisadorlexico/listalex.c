#include <stdio.h>
#include <limits.h>
#include <stdlib.h>

typedef struct node Node;
typedef struct slinked_list Slinked_list;

struct node {
	char *lexema; //lexema encontrado 
	int numlinea;//atributo numero de linea del token
	Node *next;
};

struct slinked_list {
	Node *head;
};

Slinked_list *create_slinked_list();
Node *create_node(int item);
void destroy_slinked_list(Node *slinked_list);
void insert_head(Node **head_ref, int item);
void insert_end(Node **head_red, int item);
int delete_head(Node **head_ref);
void display(Slinked_list *slinked_list);


int main() {
	Slinked_list *slinked_list = create_slinked_list();
	int option, item;
	insert_end(&slinked_list->head,yytext,nolin);
	display(slinked_list);
				
		
	return 0;
}


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
Node* create_node(int item){
    Node *new_node = (Node *) malloc (sizeof(Node));
    new_node->data = item;
    new_node->next = NULL;
    return new_node;
}

/**
 * Detruir la lista
 * */
void destroy_slinked_list(Node *slinked_list){
    Node *node = slinked_list->head;
    while(node != NULL){
        Node *temp = node; 
        node = node->next;
        free(temp);
    }   
    free(node); 
}

/**
 * Insertar elemento en lista al inicio (head)
 **/
void insert_head(Node **head_ref, int item){
    Node *new_node = create_node(item);
    new_node->next = (*head_ref);
    (*head_ref) = new_node;
}

/**
 * Insertar elemento en lista al final
 * */
void insert_end(Node **head_ref, int item){
    if (*head_ref == NULL){
        insert_head(head_ref, item);
        return;
    }
    Node *new_node = create_node(item);
    Node *last = *head_ref;
    while(last->next != NULL)
        last = last->next;
    last->next = new_node;
}


int delete_head(Node **head_ref){
    int data;
    if(*head_ref == NULL){
        //printf("Lista vacía...\n");
        return INT_MIN;
    } else {
        Node *temp = *head_ref;
        *head_ref = temp->next;
        temp->next = NULL;
        data = temp->data;
        free(temp);
    }
    return data;
}

void display(Slinked_list *slinked_list){
    Node *node = slinked_list->head;
    while(node != NULL){
        printf("%d\t", node->data);
        node = node->next;
    }
}


