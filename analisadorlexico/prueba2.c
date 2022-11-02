
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Returns 'true' if the character is a DELIMITER.

char strBuffer[1026]; // Búfer de cadenas

const char* FILE_NAME="./infile.c";

int contadordelineas = 0;

bool esunDelimitador(char ch)
{

    if (ch == ' ' || ch == '+' || ch == '-' || ch == '*' ||

        ch == ',' || ch == ';' || ch == '>' ||

        ch == '<' || ch == '=' || ch == '(' || ch == ')' ||

        ch == '[' || ch == ']' || ch == '{' || ch == '}')
      {
        return (true); //validamos si en realidad es un delimitador
      }
    return (false);
}

// Returns 'true' if the character is an OPERATOR.

bool OperadorRelacional(char ch)
{

    if (ch == '+' || ch == '-' || ch == '*' ||

        ch == '/' || ch == '>' || ch == '<' ||

        ch == '=')

        return (true);

    return (false);
}

// Returns 'true' if the string is a VALID IDENTIFIER.

bool IndentificadorValido(char* str)
{

    if (str[0] == '0' || str[0] == '1' || str[0] == '2' ||

        str[0] == '3' || str[0] == '4' || str[0] == '5' ||

        str[0] == '6' || str[0] == '7' || str[0] == '8' ||

        str[0] == '9' || esunDelimitador(str[0]) == true)

        return (false);

    return (true);
}

// Returns 'true' if the string is a KEYWORD.

bool palabraReservada(char* str)
{

    if (!strcmp(str, "if") || !strcmp(str, "else") ||

        !strcmp(str, "while") || !strcmp(str, "do") ||

        !strcmp(str, "break") ||

         !strcmp(str, "continue") || !strcmp(str, "int")

        || !strcmp(str, "double") || !strcmp(str, "float")

        || !strcmp(str, "return") || !strcmp(str, "char")

        || !strcmp(str, "case") || !strcmp(str, "char")

        || !strcmp(str, "sizeof") || !strcmp(str, "long")

        || !strcmp(str, "short") || !strcmp(str, "typedef")

        || !strcmp(str, "switch") || !strcmp(str, "unsigned")

        || !strcmp(str, "void") || !strcmp(str, "static")

        || !strcmp(str, "struct") || !strcmp(str, "goto"))

        return (true);

    return (false);
}

// Returns 'true' if the string is an INTEGER.

bool esunnumerEntero(char* str)
{

    int i, len = strlen(str);


    if (len == 0)

        return (false);

    for (i = 0; i < len; i++) {

        if (str[i] != '0' && str[i] != '1' && str[i] != '2'

            && str[i] != '3' && str[i] != '4' && str[i] != '5'

            && str[i] != '6' && str[i] != '7' && str[i] != '8'

            && str[i] != '9' || (str[i] == '-' && i > 0))

            return (false);

    }
    return (true);
}

// Returns 'true' if the string is a REAL NUMBER.

bool isRealNumber(char* str)
{

    int i, len = strlen(str);

    bool hasDecimal = false;


    if (len == 0)

        return (false);

    for (i = 0; i < len; i++) {

        if (str[i] != '0' && str[i] != '1' && str[i] != '2'

            && str[i] != '3' && str[i] != '4' && str[i] != '5'

            && str[i] != '6' && str[i] != '7' && str[i] != '8'

            && str[i] != '9' && str[i] != '.' ||

            (str[i] == '-' && i > 0))

            return (false);

        if (str[i] == '.')

            hasDecimal = true;

    }

    return (hasDecimal);
}

// Extracts the SUBSTRING.

char* subString(char* str, int left, int right)
{

    int i;

    char* subStr = (char*)malloc(

                  sizeof(char) * (right - left + 2));


    for (i = left; i <= right; i++)

        subStr[i - left] = str[i];

    subStr[right - left + 1] = '\0';

    return (subStr);
}

// Parsing the input STRING.
int tipodeestado = 0;
void parse(char* str)
{

    int left = 0, right = 0;

    int len = strlen(str);

    if(tipodeestado != 7 ){
      if (str[right] == '/') {
         if (str[right+1] == '/') {
           tipodeestado =7;
         }
      }else{
        tipodeestado =0;
      }
    while (right <= len && left <= right) {
          tipodeestado =0;
        if (esunDelimitador(str[right]) == false)

            right++;


        if (esunDelimitador(str[right]) == true && left == right) {

            if (OperadorRelacional(str[right]) == true)
                printf("'%c' Es un operador \n", str[right]);


            right++;

            left = right;

        } else if (esunDelimitador(str[right]) == true && left != right

                   || (right == len && left != right)) {

            char* subStr = subString(str, left, right - 1);


            if (palabraReservada(subStr) == true)

                printf("'%s' \t una plabra reservada %d \n", subStr, contadordelineas);


            else if (esunnumerEntero(subStr) == true)

                printf("'%s' Es un entero \n", subStr);


            else if (isRealNumber(subStr) == true)

                printf("'%s' Es un numero real \n", subStr);


            else if (IndentificadorValido(subStr) == true

                     && esunDelimitador(str[right - 1]) == false)

                printf("'%s' es un identidicador valido\n", subStr);


            else if (IndentificadorValido(subStr) == false

                     && esunDelimitador(str[right - 1]) == false)

                printf("'%s' no es un identidicador\n", subStr);

            left = right;

        }else{
          printf("error en la cadena %d\n",contadordelineas );
        }

    }
    }
    return;
}

// DRIVER FUNCTION
//declaracion del buffer

int main()
{

    FILE* file = fopen(FILE_NAME, "r");
     // maximum length of string is 100 here

    freopen("./salida.txt", "w", stdout);
    if(file==NULL)
    {
      printf("Error al abrir el archivo\n");
      exit(1);
    }
    while (!feof(file)) {
        contadordelineas++;
        fgets(strBuffer,1024,file);
        parse(strBuffer);
    }
    fclose(file);
    //char str[100] = "int a = b + 1c; ";

    //parse(str); // calling the parse function


    return (0);
}
