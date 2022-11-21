#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char Buffer[1026]; // Búfer de cadenas

const char* FILE_NAME="./infile.c";

int contadordelineas = 0;

bool esunDelimitador(char ch)
{

    if (ch == ' ' || ch == '  ' || ch == ';' || ch == '\n' )
      {
        return (true); //validamos si en realidad es un delimitador
      }
    return (false);
}

bool esunOperadorRelacional(char ch)
{
  if(ch== '>' || ch=="<" || ch=='=')
  {
    return true;
  }
  return false;
}

bool esunNumero(char ch)
{
  if(ch>='0' && ch<='9' || ch=='E')
  {
    return true;
  }
  return false;
}

bool operadioresAritmeticos(char ch )
{
  if(ch == '+' || ch =='-' || ch == '/' || ch == '*')
  {
    return true;
  }
  return false;
}

int reconocedorDelAutomata()
{

}
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
        fgets(Buffer,1024,file);
        parse(Buffer);
    }
    fclose(file);
    printf("Numero de lineas %d", contadordelineas);


    return (0);
}
//para crear esto es necesario entener el funcionamiento del automata
