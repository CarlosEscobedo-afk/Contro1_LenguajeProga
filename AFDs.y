%{
#include <iostream>
#include <iterator>
#include <fstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <sstream>
using namespace std;
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

//Variables Globales:
string *transit = NULL;
int cantidadTransiciones = 3;
string alfabeto = "" , estados = "", transicion = "" , estadoInicial = "" , estadoFinal = "" , palabra = "";
#define max 8
string strings[max];

//Longitud de String para Split:
int len(string str){  
    int length = 0;  
    for (int i = 0; str[i] != '\0'; i++)  {  
        length++;  
    }  
    return length;     
}

//Funci�n para realizar un Split en un String:
void split (string str, char seperator){  
    int currIndex = 0, i = 0;  
    int startIndex = 0, endIndex = 0;  
    while (i <= len(str)){  
        if (str[i] == seperator || i == len(str)){  
            endIndex = i;
            string subStr = "";
            subStr.append(str, startIndex, endIndex - startIndex);
            strings[currIndex] = subStr;
            currIndex += 1;
            startIndex = endIndex + 1;
        }
        i++;
    }
}

//Automata gen�rico:
void automata(string estados, string alfabeto, string estadoInicial, string estadoFinal, string palabra, string *transit, int cantidadTransiciones){
    int estadoEjec = 0; // Estado en ejecucion
    string marcaEstado; // Indica el estado actual del DFA.
    int count = 0; // Contador para definir el final de la lectura de la palabra de ingreso.
	
    // Aca se definen las transiciones.
    for(int i=0; i <= palabra.length(); i++){
        for(int j=0; j < alfabeto.length(); j++){
            if(palabra[i] == alfabeto[j]){
        		for(int h=0; h < cantidadTransiciones; h++){
        			//Transicion de estado.
        			if(transit[estadoEjec][3] == alfabeto[j]){
						ostringstream ss;
					    ss << transit[estadoEjec][5] << transit[estadoEjec][6];
					    string s = ss.str();
						marcaEstado = s;
			        	estadoEjec++;
					}
					if(estadoEjec >= cantidadTransiciones){
					    estadoEjec = 0;
						break;
					}
				}
            }
        }
        //Verificar si el estado de llegada es valido:
        if(count == palabra.length()){
		    if(estadoFinal == marcaEstado){
		        cout << "Valido!" << endl;
		    }
			else {
		        cout << "Invalido!" << endl;
		    }
		}
		count++;
    }
    delete [] transit;
}

//Main

void transi(){

	//Definiciones para el Aut�mata:
    
    //Separar transiciones:
	transit = new string[cantidadTransiciones];
	char seperator = '};{';
    split(transicion, seperator);
    
    //A�adir transiciones al puntero:
	for (int j = 0; j < cantidadTransiciones; j++){
		transit[j] = strings[j+1];
		/*
		//Intento de limpiar las transiciones:
		char ch = ';';
		transit[j].erase(remove(transit[j].begin(), transit[j].end(),ch), transit[j].end());
		cout << "TRANSICIONES   " << transit[j] << endl;
		*/
	}

    
    
}

%}

%union{
    char *sval;
}


//TOKENS

%token ALFABETO
%token ESTADOS
%token INICIAL
%token FINAL
%token PALABRA
%token TRANSICION
%token FINLINEA INICIAR
%token SPACE
%token <sval> EJEC
%type<sval> exp
%start input
//string alfabeto = "" , estados = "" , estadoInicial = "" , estadoFinal ="" , palabra = "";

//REGLAS DE TRADUCCIÓN
%%
input   : /*vacio*/
        | input linea
        ;
linea   : FINLINEA
        | exp FINLINEA
        ;

exp     : EJEC
        | ALFABETO exp {alfabeto=$2; cout<<"Estados: "<<alfabeto<<endl;}
        | ESTADOS  exp {alfabeto=$2; cout<<"Estados: "<<alfabeto<<endl;}
        | INICIAL exp  { estadoInicial = $2; cout<<"Estado Inicial: "<<estadoInicial<<endl; }
        | FINAL   exp  { estadoFinal = $2; cout<<"Estado Final: "<<estadoFinal<<endl;}
        | PALABRA  exp { palabra = $2; cout<<"Palabra: "<<palabra<<endl;}
        | TRANSICION exp{transicion = $2; cout<<"Transiciones: "<<transicion<<endl;transi()}
        | lis
        ;

lis     : INICIAR { automata(estados, alfabeto, estadoInicial, estadoFinal, palabra, transit, cantidadTransiciones);}
        ;
%%


int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}

/*
CONSOLA USUARIO (FLEX y BISON):
        alfabeto{a,b,c,d,e}
        estados{q1,q2,q3}
        transicion{{q1,a,q2}}
        transicion{{q1,b,q3}}
        transicion{{q2,e,q3}}

CÓDIGO DEL DFA EN C (para importar en Bison):
  ENTRADAS:
        alfabeto[a,b,c,d,e]
        estados[q1,q2,q3]
        transicion[{q1,a,q2},{q1,b,q3},{q2,e,q3}]

  MANEJO DE LOS ARREGLOS:
        arreglo = [q1,q2,q3]
        transicion = [q2]
            --consola--aplicar{e}
        transicion = [q3]
*/