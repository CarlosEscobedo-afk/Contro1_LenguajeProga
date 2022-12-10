%{
#include <iostream>
#include <iterator>
#include <fstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <sstream>
#include <vector>
using namespace std;
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

//Variables Globales:
int cantidadTransiciones;
int contAux=0;
string alfabeto = "" , estados = "", transicion = "" , estadoInicial = "" , estadoFinal = "" , palabra = "";
char seperator = ';';
vector<string> arregloEntrada;
//string arregloEntrada[3];

//Longitud de String para Split:
int len(string str){  
    int length = 0;  
    for (int i = 0; str[i] != '\0'; i++)  {  
        length++;  
    }  
    return length;     
}

//Funci�n para realizar un Split en un String:
string * split (){  
    int currIndex = 0, i = 0;  
    int startIndex = 0, endIndex = 0;  
    int largo= len(transicion);
    while (i <= largo){  
        if (transicion[i] == seperator || i == largo ){  
            endIndex = i;
            string subStr = "";
            subStr.append(transicion, startIndex + 1, (endIndex - 1) - (startIndex + 1));
            arregloEntrada[currIndex] = subStr;
            cout<<"arregloEntrada: "<<arregloEntrada[currIndex]<<endl;
            currIndex += 1;
            startIndex = endIndex + 1;
        }
        i++;
    }
    return arregloEntrada;
}


//Automata gen�rico:
void automata(){
    int estadoEjec = 0; // Estado en ejecucion
    string* aux =split();
    string marcaEstado; // Indica el estado actual del DFA.
    int count = 0; // Contador para definir el final de la lectura de la palabra de ingreso.
	
    // Aca se definen las transiciones.
    for(int i=0; i < palabra.length(); i++){
        for(int j=0; j < alfabeto.length(); j++){
            if(palabra[i] == alfabeto[j]){
        		for(int h=0; h < cantidadTransiciones; h++){
        			//Transicion de estado.
        			if(aux[estadoEjec][3] == palabra[i]){
						ostringstream ss;
					    ss << aux[estadoEjec][5] << aux[estadoEjec][6];
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

}


%}

%union{
    char *sval;
    int ival;
}


//TOKENS

%token FINLINEA INICIAL FINAL ESTADOS PALABRA ALFABETO TRANSICION START CANTIDAD SEMICOLON
%token <sval> ENTRADA
%token <ival> NUM
%start input
%%

input   : /* empty string */
        | input linea
        ;

linea   : FINLINEA
        | func FINLINEA
        ;

func    : ALFABETO cre_alfabeto
        | INICIAL nodo_inicial
        | FINAL nodo_final
        | ESTADOS cre_estados
        | PALABRA cre_palabra
        | TRANSICION tran
        | CANTIDAD cant
        | start
        ;


nodo_final  : ENTRADA  { estadoFinal = $1;cout << "estado final  : " << estadoFinal<<endl;}
            ;
nodo_inicial : ENTRADA { estadoInicial =$1;cout << "estado incial : " <<estadoInicial<< endl;}
             ;
cre_alfabeto : ENTRADA { alfabeto = $1; cout << "Alfabeto: " << alfabeto << endl;}
            ;
cre_estados : ENTRADA { estados = $1; cout << "Estados: "<<estados<<endl;}
            ;
cre_palabra : ENTRADA { palabra = $1; cout << "Palabra: " << palabra << endl;}
;
tran        : ENTRADA   {   arregloEntrada.resize(cantidadTransiciones);
                            while(contAux<cantidadTransiciones)
                            {
                                if(arregloEntrada[contAux]!=$1)
                                {
                                    arregloEntrada[contAux]=$1;
                                    cout << "Transicion "<<contAux<<": "<< arregloEntrada[contAux] << endl;
                                    contAux++;
                                    break;
                                }
                                
                            }
                            
                        }
            | tran SEMICOLON tran
;
cant        : NUM { cantidadTransiciones = $1; cout << "Cantidad de transciones: "<< cantidadTransiciones<<endl;}
;
start       : START {automata(); }
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