#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#define MAX_SIZE 100

int precedence[256]; // Precedence matrix

// Stack structure
typedef struct stack {
    int top;
    double items[MAX_SIZE];
} Stack;

// Function to initialize stack
void initStack(Stack *stack) {
    stack->top = -1;
}

// Function to check if stack is empty
int isEmpty(Stack *stack) {
    return stack->top == -1;
}

// Function to check if stack is full
int isFull(Stack *stack) {
    return stack->top == MAX_SIZE - 1;
}

// Function to push an item onto the stack
void push(Stack *stack, double item) {
    if (isFull(stack)) {
        printf("Stack overflow!\n");
        return;
    }
    stack->items[++stack->top] = item;
}

// Function to pop an item from the stack
double pop(Stack *stack) {
    if (isEmpty(stack)) {
        printf("Stack underflow!\n");
        return 0;
    }
    return stack->items[stack->top--];
}

// Function to check if a character is an operator
int isOperator(char c) {
    return c == '+' || c == '-' || c == '*' || c == '/' || c == '^' || c == '(' || c == ')';
}

// Function to get the precedence of an operator
int getPrecedence(char operator) {
    switch (operator) {
        case '(': return 0;
        case '+':
        case '-': return 1;
        case '*':
        case '/': return 2;
        case '^': return 3;
    }
    return -1;
}

// Function to check if an operator is right-associative
int isRightAssociative(char operator) {
    return operator == '^';
}

// Function to perform an operation
double performOperation(double operand1, double operand2, char operator) {
    switch (operator) {
        case '+': return operand1 + operand2;
        case '-': return operand1 - operand2;
        case '*': return operand1 * operand2;
        case '/': return operand1 / operand2;
        case '^': return pow(operand1, operand2);
    }
    return -1;
}

    // Function to parse an infix expression
double parseExpression(char *expression) {
    Stack stack;
    initStack(&stack);

    for (int i = 0; i < strlen(expression); i++) {
        char c = expression[i];

        if (isdigit(c)) {
            double number = 0;
            while (isdigit(c)) {
                number = number * 10 + (c - '0');
                c = expression[++i];
            }
            i--;
            push(&stack, number);
        } else if (c == '(') {
            push(&stack, c);
        } else if (c == ')') {
            while (!isEmpty(&stack) && stack.items[stack.top] != '(') {
                double operand2 = pop(&stack);
                double operand1 = pop(&stack);
                char operator = pop(&stack);
                push(&stack, performOperation(operand1, operand2, operator));
            }
            pop(&stack);
        } else if (isOperator(c)) {
            while (!isEmpty(&stack) && isOperator(stack.items[stack.top])
                && (isRightAssociative(c) ? getPrecedence(c) < getPrecedence(stack.items[stack.top]) :
                getPrecedence(c) <= getPrecedence(stack.items[stack.top]))) {
                double operand2 = pop(&stack);
                double operand1 = pop(&stack);
                char operator = pop(&stack);
                push(&stack, performOperation(operand1, operand2, operator));
            }
            push(&stack, c);
        }
    }

    while (!isEmpty(&stack)) {
        double operand2 = pop(&stack);
        double operand1 = pop(&stack);
        char operator = pop(&stack);
        push(&stack, performOperation(operand1, operand2, operator));
    }

    return pop(&stack);
}

void parse(char *expression) {
    // Initialize stack
    Stack stack;
    initStack(&stack);

    // Initialize precedence matrix
    int matrix[][] = {
        /*       +    -    *    /    (    )    $ */
        /* + */  { -1, -1, -1, -1, -1,  1, -1 },
        /* - */  { -1, -1, -1, -1, -1,  1, -1 },
        /* * */  { -1, -1, -1, -1, -1,  1, -1 },
        /* / */  { -1, -1, -1, -1, -1,  1, -1 },
        /* ( */  { -1, -1, -1, -1, -1,  0,  1 },
        /* ) */  { -1, -1, -1, -1, -1, -1, -1 },
        /* $ */  { -1, -1, -1, -1, -1, -1,  0 }
    };

    // Process input
    for (int i = 0; i < strlen(expression); i++) {
        char c = expression[i];

        // Get precedence level of current character
        int level = getPrecedence(c);

        // Get precedence level of top of stack
        int topLevel = getPrecedenceLevel(stack.top->data);

        // Compare levels using matrix
        if (matrix[topLevel][level] == -1) {
            // Push operator onto stack
            push(&stack, c);
        } else if (matrix[topLevel][level] == 1) {
            // Pop operators from stack and perform operations
            while (matrix[topLevel][level] == 1) {
                char operator = pop(&stack);
                performOperation(operator);
                topLevel = getPrecedenceLevel(stack.top->data);
            }
            // Push current operator onto stack
            push(&stack, c);
        } else if (matrix[topLevel][level] == 0) {
            // Pop left parenthesis from stack
            if (c == ')') {
                pop(&stack);
            } else {
                // Push left parenthesis onto stack
                push(&stack, c);
            }
        }
    }

    // Pop remaining operators from stack and perform operations
    while (stack.top->data != '$') {
        char operator = pop(&stack);
        performOperation(operator);
    }
}
void printParsedExpression(char *expression) {
    double result = parseExpression(expression);
    printf("The result of the parsed expression '%s' is: %lf\n", expression, result);
}
int main() {
    char expression[MAX_EXPRESSION_LENGTH];
    printf("Expresion: ");
    scanf("%s", expression);
    printParsedExpression(expression);
    return 0;
}
