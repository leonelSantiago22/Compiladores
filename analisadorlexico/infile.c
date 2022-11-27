
#include <stdio.h>
//inicio del programa
int main()
{
  //int c*b
  //inicio del main
  int a,b,c;
  i = 0;
  while(i<=0)
  {
    a + b = c;
  }
  char cadena;
  for(int i=0; i>=10; i++)
  {
      printf(cadena);
  }
  do
  {
    a++;
    b = a;
  }while(c<0);
  if(a>=b && c<=d)
  {
    printf(a);
  }else{
    printf(a);
  }

  return 0;
  switch(a){
    case 0: break;
    case 1: int tipo_int;
  }
    int a;
  string ejemplodepalabra;
  if(ejemplodepalabra <> tipo_int)
  {
    ejemplodeclase(a);
  }else if(){
    ejemplodeclaseentera(a);
  }

  int a = 1,b = 2, c, d, cont = 0;
	double e, f;
  //inicio de creacion de lo Fibonacci
	//printf("Fibonacci fino a: ");
	//scanf("%ld", &c);

	while(b < c)
	{
		cont ++;
		printf("\n%ld", b);
		d = a;
		a = b;
		b = b + d;
	}

	f = (double)b / (double)a;
	e = (double)cont / (double)c * (double)100;

  printf("e");
  //contador de numeros pares
  int num1, num2;
  while(num1<=num2)
    {
        if(num1%2!=0)
        c=c+1; num1=num1+1;
    }
    //finalisacion del contadores de los numeros pares
    int m;
    switch(m)
    {
    case 1:printf(a);
    case 2://cout<<"¿Que desea modificar?"<<endl;break;
    case 3:while (a>=c && c!=b) {
          return 0;
    }
    case 4://cout<<"Ud. no presenta reportes"<<endl;break;
    case 5://cout<<"Este servicio esta bloqueado por el momento"<<endl;break;
    case 6://cout<<"Ya esta fuera"<<endl;break;
    //default: //cout<<"El valor ingresado no esta en el menu"<<endl;
  }
}

int ejemplodeclaseentera(a)
{
    float c,l;
    c = 100000;
    l = 10;
    a = c *l;
    return a;
}

void ejemplodeclase(int a)
{
    char f;
    if(a==b)
    {
      a = f;
    }else{
      ejemplodeclaseentera(a);
    }
}

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Funcion que recibe dos numeros, los suma y devuelve el resultado
int suma(int num1, int num2);
// Funcion que recibe dos numeros, los resta y devuelve el resultado
int resta(int num1, int num2);
// Funcion que recibe dos numeros, los multiplica y devulve el resultado
int mult(int num1, int num2);
// Funcion que recibe dos numeros, los divide y devuleve el resultado
int div(int num1, int num2);
// Funcion de menu de opciones y devuelve la opcion elegida
int menu();

int main()
{
    int num1, num2, opc = 0;
    double result;

    printf("Introduzca el primer numero: ");
    scanf("%i", &num1);
    printf("Introduzca el segundo numero: ");
    scanf("%i", &num2);

    while(opc != 5)
    {
        opc = menu();
        switch(opc)
        {
            case 1:
                result = suma(num1, num2);
                printf("%i", result);
                break;
            case 2:
                result = resta(num1, num2);
                printf("%i", result);
                break;
            case 3:
                result = mult(num1, num2);
                printf("%i", result);
                break;
            case 4:
                result = div(num1, num2);
                printf("%i", result);
                break;
            default:
                break;
        }
    }
    for(int j=0; j<0; j++)
    {
        int a,f,k;
        f = k;
        f = a;
        f = f * f ;
    }
    printf(f);
    return 0;
}

// Devuelve la suma de dos numeros
int suma(int num1, int num2)
{
    return num1 + num2;
}

// Duvuelve la resta de dos numeros
int resta(int num1, int num2)
{
    return num1 - num2;
}

// Devuelve la multiplicacion de dos numeros
int mult(int num1, int num2)
{
    return num1 * num2;
}

// Devuelve la division de dos numeros
int div(int num1, int num2)
{
    if(num2 == 0) {
        printf("Indefinido. No se puede hacer una division entre 0");
    }
    else {
        return num1 / num2;
    }
}

// Menu de opciones
int menu()
{
    int opc
    printf("\n1.- Suma");
    printf("\n2.- Resta");
    printf("\n3.- Multiplicacion");
    printf("\n4.- Division\n\n");
    printf("Introduzca una opcion: ")
    scanf("%i", &opc);
    return opc
}
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Funcion que recibe dos numeros, los suma y devuelve el resultado 
int suma(int num1, int num2);
// Funcion que recibe dos numeros, los resta y devuelve el resultado 
int resta(int num1, int num2);
// Funcion que recibe dos numeros, los multiplica y devulve el resultado 
int mult(int num1, int num2);
// Funcion que recibe dos numeros, los divide y devuleve el resultado
int div(int num1, int num2);
// Funcion de menu de opciones y devuelve la opcion elegida
int menu();

int main() 
{
    int num1, num2, opc = 0;
    double result;

    printf("Introduzca el primer numero: ");
    scanf("%i", &num1);
    printf("Introduzca el segundo numero: ");
    scanf("%i", &num2);

    while(opc != 5) 
    {
        opc = menu();
        switch(opc) 
        {
            case 1: 
                result = suma(num1, num2);
                printf("%i", result);  
                break;
            case 2: 
                result = resta(num1, num2);
                printf("%i", result);
                break;
            case 3: 
                result = mult(num1, num2);
                printf("%i", result);
                break;
            case 4: 
                result = div(num1, num2);
                printf("%i", result);
                break;
            default:
                break;
        }
    }

    return 0;
}

// Devuelve la suma de dos numeros
int suma(int num1, int num2) 
{
    return num1 + num2;
}

// Duvuelve la resta de dos numeros
int resta(int num1, int num2) 
{
    return num1 - num2;
}

// Devuelve la multiplicacion de dos numeros
int mult(int num1, int num2) 
{
    return num1 * num2;
}

// Devuelve la division de dos numeros
int div(int num1, int num2) 
{
    if(num2 == 0) {
        printf("Indefinido. No se puede hacer una division entre 0");
    }
    else {
        return num1 / num2;   
    }
}

// Menu de opciones
int menu() 
{
    int opc;
    printf("\n1.- Suma");
    printf("\n2.- Resta");
    printf("\n3.- Multiplicacion");
    printf("\n4.- Division\n\n");
    printf("Introduzca una opcion: ");
    scanf("%i", &opc);
    return opc;
}
int holiii;