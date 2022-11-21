//Use el estado como el estado actual y luego escriba el programa de acuerdo con el diagrama de transici�n de estado anterior para ayudar a algunas funciones
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <vector>
#include <map>

using namespace std;


const int KEY_NUM = 18; // Definir la cantidad de palabras clave ademas de los 3 tipos que vamos a utilizar 
const string KEY_SET[]={ // Colecci�n de palabras clave
        "for",
        "while",
        "do",
        "switch",
        "case",
        "break",
        "continue",
        "if",
        "else",
        "char",//tipo de dato
        "int",//tipo de dato
        "float",//tipo de dato 
        "return",
        "main",
        "const",
        "extern",
        "printf",
        "vector",
};
map<string,int> word_num; //Numero de palabras
const char* FILE_NAME="./nuevo.txt";
char strBuffer[1024]; // Bufer de cadenas
string token;
//const string operadores_relacionales[] = {">", "<", ">=", "<=", "=", "<>"};
//const string operadores_aritmeticos[] = {"*", "/", "%", "^"};
int line_num=0; // El n�mero de l�neas del programa a contar, que representa el n�mero de l�nea actual, que se utiliza para localizar la ubicaci�n del error.
int char_num=0; // Cuente el n�mero real de caracteres que no son espacios ni comentarios
int state=0; // El estado actual del programa

char getChar(char* &str) // Obtener el car�cter en la posici�n actual del puntero de la cadena
{
    return *str++;
}
//verificamos si la entrada es digito
bool esunDigito(char c)
{
    return (c>='0' && c<='9');
}
//es una letra
bool esunaLetra(char c)
{
    return (c>='a'&&c<='z') || (c>='A'&& c<='Z');
}

bool operadorAritmetico(char c) // Determinar si es un signo de puntuaci�n
{
    return c=='*' || c=='/' || c=='%' || c=='^';
}

bool isPunctuation(char c) // Determinar si es un signo de puntuaci�n+
{
    return  c=='(' || c==')' || c=='{'
    || c=='}' || c=='[' || c==']'|| c==';' || c==':' || c=='#' || c=='"' || c==','|| c=='.';
}
//funcion que nos sirve para poder verificar si es palabra clave 
bool palabraReservada(string str)
{
    for(int i=0;i<KEY_NUM;i++){
        if( str==KEY_SET[i] )
            return true;
    }
    return false;
}

//funcion de error  
void error()
{
    printf("en la linea %d hay un error \n",line_num);
}

void procesar_entrada(char* buf) // El contenido de una l�nea de cadena
{
    if(state !=4){
    	 state = 0;
     } // el estado 4 es de comentario , lo que significa que es un bloque de comentarios
     
    char C=' ';//inicianizando en c 
    //printf("%d\n",line_num );
    int pos=0;
    C = getChar(buf); // Buffer de datos para poder analizar 
    while( C!='\n' && C!='\0' ) //si no es un retorno de carro 
    {
        char_num++; // Cuenta el n�mero de caracteres 
        switch(state){ // Analizar el estado actual
            case 0: // En el estado de lectura de cadena en nombre de, no ha ingresado ning�n aut�mata
                if( esunaLetra(C) || C=='_' )
                {//caso id 
					state = 1; // Ingrese el estado 1
                    token = C;
                    C = getChar(buf);
                }    
                else if( esunDigito(C) )
                { //estado de numero 
                    state = 2; //Se va a el estado 2
                    token = C;
                    C = getChar(buf);
                    //printf("numero: ");
                    //printf("%d\n",line_num );
                }
                 else if(isPunctuation(C) )
                {
                    state = 0;
                    printf("< %c, - >\n",C);
                    C = getChar(buf);
                }
                else if( C=='/' ) //comentarios 
                {
                    state =3;
                    C = getChar(buf);
                }
                else if( C==' ' ) //Espacio
                {
                    state = 0;
                    C = getChar(buf);
                }
                 else if (C=='+'){
                	state =12;
                	token = C;
                    C = getChar(buf);
				}
				else if (C=='-'){
                	state =13;
                	token += C;
                    C = getChar(buf);
				}
                else if( C=='<' )
                {
                    state = 14;
                    token = C;
                    C = getChar(buf);
                }
                else if( C=='>' )
                {
                    state = 15;
                    token = C;
                    C = getChar(buf);
                }
                else if( C=='=' ) 
                {
                    state = 16;
                    token = C;
                    C = getChar(buf);
                }
    			 else if( operadorAritmetico(C) )
                {
                    state = 0;
                     printf("<OPERADOR aritmetico: ");
                    printf(" %c, - >",C);
                    printf(" %d\n",line_num );

                    C = getChar(buf);
                }
                else if(C=='\t' || C=='\n'){
                  state = 0;
                    C = getChar(buf);
                }else{
                      error();
                    // Omitir este caracter 
                    C = getChar(buf);
                }
                break;
            case 1:
                if( esunaLetra(C) || esunDigito(C) || C == '_' )
                {
                    state=1;//estado 1 del id 
                    token += C;
                    C = getChar(buf);
                }
                else{ // Al separador
                    word_num[token]++; // Cuenta el n�mero total de cada caract
                    if( palabraReservada(token) )
                    {
                        cout<<"<Pr, "<<token<<" >";
                        printf("%d\n",line_num );

                    }
                    else
                    {//si no es una palabra reservada entonces es un identificador 
                        cout<<"<id, "<<token<<" >";
                        printf("%d\n",line_num );

                    }

                    state = 0;
                }
                break;
            case 2: // nummero 
                if( esunDigito(C) )//si viene digito de nuevo 
                {//se queda en el estado 2 
                    state = 2;
                    token += C;
                    C = getChar(buf);//siguiente caracter 
                }else if(C=='.'){//si viene un punto se va al estado 7
                	state=7;
                	token+=C;
                	C=getChar(buf);//siguiente caracter a leer 
				}else if(C=='e'){//si viene un e (euler)
					state=8;//Se va al estado 8
                	token+=C;
                	C=getChar(buf);
				}
                else
                {
                  //int num=stoi(token); // La cadena se convierte a int para poder imprimirle 
                    //cout<<"< token, "<<num<<" >";
                     
                    cout<<"numero: "<<token<<"";
                    printf("  linea:%d\n",line_num );

                    state = 0;
                }
                break;
            case 3: //comentarios 
                if(C=='*'){
                    state = 4; //caso /*
         	        token += C;
                    C = getChar(buf);
                }
                else if(C=='/')
                { // caso: //
                    state = 5;
                    token += C;
                    //deteccion de los comentarios
                    cout<<"< //, - >";
                    printf(" %d\n",line_num );
                }
                break;
            case 4:
                if(C=='*') {
                    state = 6;
                    token+=C;
                    C = getChar(buf);
                }
                else
                {//cualquier otra cosa 
                    state = 4;
                    C = getChar(buf);
                }
                break;
            case 5://cualquier otra cosa en el comentario de // 
                    state = 5;
                    C = getChar(buf);
                break;
            case 6:
                if(C=='/')
                {
                    state = 0;
                    C = getChar(buf);
                
                }
                break;
            case 7://numero con punto decimal 
                 if(esunDigito(C)){//es necesario que venga un digito 2.
                 	 //int num=stoi(token); // La cadena se convierte a int
                    //cout<<"< num, "<<num<<" >";
            
                 	state=10;
                 	token+= C;
					C = getChar(buf); 
				 }
                break;
            case 8:
                 if(esunDigito(C)){//si veiene un digito es 3e
                 	state=11;
                 	token+= C;
					C = getChar(buf); 
				 } else if(C == '-'){//si viene - es 7e-
				 	state=9;
                 	token+= C;
					C = getChar(buf); 
				 }
                break;
            case 9://completar digito que contiene euler 
                   if(esunDigito(C)){
                   	state=11;
                 	token+= C;
					C = getChar(buf); 
                    //3.2e4
                    //34-3
				   }
                break;
            case 10:
                if(esunDigito(C))
                {
                 
            	    state = 10;
            	    token+=C;
                    C=getChar(buf);
                }
                else if(C=='e')
                {//si viene e entonces es un euler con decimal 
               	    state = 8;
               	    token+=C;
               	    C=getChar(buf);
                }else{
                    //puede que ya no venga ningun numero entonces es un estado final 
                    cout<<"numero: "<<token<<"";
                   
                    printf("  %d\n",line_num );

                    state = 0;
                }
                break;
            case 11:
                if(esunDigito(C))
                {
                	state =11;
               	    token+=C;
               	    C=getChar(buf);
                    
                }else
                {
                    //int num=stoi(token); // La cadena se convierte a int
                    //cout<<"< num, "<<num<<" >";
                    //es un estado final entonces hay que imprimir  
                     cout<<"numero: "<<token<<"";
                    printf(" %d\n",line_num );
                    state = 0;
                }
                break;
            case 12:
            	if(esunDigito(C)){
            			//numero con signo +
            	state=2;
            	token += C;
                C = getChar(buf);
				}else if(C=='+'){
					//simbolo de operacion ++
                     cout<<"< operador aritmetico: ++ >"<<endl;
                    state = 0;
                    C=getChar(buf);
				}else{
                    cout<<"< relop, + >"<<endl; 
            		state = 0;

                    
                }
            break;	
            case 13://numero con signo -3
 				if(esunDigito(C)){
            	state=2;
            	token += C;
                C = getChar(buf);
				} else if(C=='-'){
                      cout<<"< operador aritmetico: -- >"<<endl; 
						state=0;
					   C=getChar(buf);
				}else{
                    cout<<"< relop, - >"<<endl; 
            		state = 0;
                }
				      //si no viene un digito entonces es solo -	state=0;  
            break;
            case 14:
                if(C=='='){//caso <=
                     cout<<"< relop, <= >"<<endl; 
						state=0;
					   C=getChar(buf);
                }else{
                    cout<<"< relop, < >"<<endl; 
            		state = 0;
                    
                }
                break;
            case 15:
            	if(C=='='){//caso >=
            		cout<<"< relop, >= >"<<endl; 
            		state = 0;
                    C=getChar(buf);
				}else{
                    cout<<"< relop, > >"<<endl; 
            		state = 0;
                   C=getChar(buf);
                }
            break;
            case 16://caso ==
            	if(C=='='){
            		cout<<"< relop, == >"<<endl; 
                    printf(" %d\n",line_num );
            		state = 0;
                    C=getChar(buf);
				}else{
                     cout<<"< relop, = >"<<endl; 
            		state = 0;
                    C = getChar(buf);
                }
                
                    break;
           /* case 17:
                  if( esunaLetra(C) )
                {
                    state=17//estado 1 del id 
                    token += C;
                    C = getChar(buf);
                }
                else{ // Al separador
                    word_num[token]++; // Cuenta el n�mero total de cada caract
                    if( palabraReservada(token) )
                    {
                        cout<<"<Pr, "<<token<<" >";
                        printf("%d\n",line_num );
                    }
                    else
                    {//si no es una palabra reservada entonces es un identificador 
                        cout<<"<Cadena: , "<<token<<" >";
                        printf("%d\n",line_num );
                    }
                    state = 0;
                }
            break;*/	
           /*default: error();
                    state=0;
                    C = getChar(buf);
            break;*/
        }
    }
}

int main()
{

    FILE* file = fopen(FILE_NAME,"r"); // Abra el archivo a escanear en modo de solo lectura

    freopen("./outfile.txt","w",stdout); // Redireccion de salida, los datos de salida se guardaran en el archivo out.txt 

    if( file==NULL )
    {
        printf("Error! no se pudo abrir el archivo ");
        exit(1);
    }
    // Realice la lectura l�nea por l�nea del archivo
    while( !feof(file) )
    {
        line_num++;
        fgets(strBuffer,1024,file);
        procesar_entrada(strBuffer); // Cadena de proceso
    }
    fclose(file);

    cout<<"numero de lineas es : "<<line_num<<endl; // Imprime el n�mero de l�neas del contenido del archivo
    cout<<"Numero de caracteres: "<<char_num<<endl;
    map<string,int>::iterator iter;
    iter = word_num.begin();
    while(iter!=word_num.end())
    {
        cout<<iter->first<<' '<<iter->second<<endl;
        iter++;
    }
    return 0;
}