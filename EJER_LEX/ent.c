

// EJEMPLO No. 1: PROGRAMA QUE LEE DOS NÚMEROS Y ESCRIBE EL MAYOR DE LOS DOS.

#include <stdio.h>

main()

{

float
 x, y;

printf(“Escribe el primer número: “);

scanf(“%f”,&x);

printf(“Escribe el segundo número:”);

scanf(“%f”,&y);

if (x > y)

printf(“El mayor es: %f”,x);

else

if ( y > x )

printf(“El mayor es: %f”,y);

else

printf(“Son iguales”);

}
//EJEMPLO No. 2: PROGRAMA QUE INDICA SI 
//UN NÚMERO ES PAR O NO

#include <stdio.h>

main()

{

int x;

printf(“Escribe el número sin decimales: “);

scanf(“%d”,&x);

if (x%2==0)

printf(“El número es par”);

else

printf(“El número es impar”);

}
