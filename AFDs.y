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
string alfabeto = "" , estados = "", estadoInicial = "" , estadoFinal = "" , palabra = "";
char seperator = ',';
vector<string> strongs;
vector<string> arregloEntrada;
vector<vector<string>> transicionSep;
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
//Función para realizar un Split en un String:
void split (string str, char seperator, int posicioooon){ 
    strongs.resize(cantidadTransiciones);
    transicionSep.resize(cantidadTransiciones,vector<string>(cantidadTransiciones));
    int currIndex = 0, i = 0, startIndex = 0, endIndex = 0, cont = 0;
    while (i <= len(str)){  
        if (str[i] == seperator || i == len(str)){  
            endIndex = i;
            string subStr = "";
            subStr.append(str, startIndex, endIndex - startIndex);
            strongs[currIndex] = subStr;
            //cout<<"strongs: "<<strongs[currIndex]<<endl;
            transicionSep[posicioooon][cont] = strongs[currIndex];
			currIndex += 1;
		   	startIndex = endIndex + 1;
		   	cont++;
        }
		i++;
    }
}


//Automata gen�rico:
void automata(){
    for(int q=0;q<cantidadTransiciones;q++){
    	split(arregloEntrada[q],seperator,q);
	}
    int estadoEjec = 0; // Estado en ejecucion
    string marcaEstado = estadoInicial; // Indica el estado actual del DFA.
    int count = 1; // Contador para definir el final de la lectura de la palabra de ingreso.
	char ultimaLetra; //Permite almacenar la �ltima lea visitada.
	bool valido = false; // Verificar invalidez.
	int trueTran = 1; // Verificar que todas las transiciones sean validas.
	
	// Para cada letra de la palabra de entrada:
	for(int i=0; i < palabra.length(); i++){
		// Si es v�lida en el alfabeto:
		for(int j=0; j < alfabeto.length(); j++){
			if(palabra[i] == alfabeto[j]){
				// Se recorren todas las transiciones posibles para esa letra:
				for(int h=0; h < cantidadTransiciones; h++){
					// Si la transici�n es v�lida se realiza el cambio de estado:
					string transicionLetra = transicionSep[h][1];
					string transicionInicio = transicionSep[h][0];
					string palabraString(1, palabra[i]);
					if(marcaEstado == transicionInicio && palabraString == transicionLetra){
						string transicionLlegada = transicionSep[h][2];
						marcaEstado = transicionLlegada;
						trueTran++;
					}
				}
				// Si ninguna transici�n fue �til, la palabra no es v�lida:
				if(trueTran > palabra.length()){
					valido = true;
				}
			}
		}
		count++;
	}
	if(valido == false){
		cout << "Invalido!" << endl;
	}
	else if(valido == true){
		cout << "Valido!" << endl;
	}
}


%}

%union{
    char *sval;
    int ival;
}


//TOKENS

%token FINLINEA INICIAL FINAL ESTADOS PALABRA ALFABETO TRANSICION START CANTIDAD SEMICOLON
%token MOSTRARI MOSTRARF MOSTRARE MOSTRARA MOSTRARP MOSTRART MOSTRARC
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
        | mostrara
        | mostrari
        | mostrarc
        | mostrare
        | mostrarf
        | mostrarp
        | mostrart
        | start
        ;

mostrara    : MOSTRARA  {   int i = 0;
                            if (alfabeto != ""){
                                for (char c : alfabeto){
	                                if (c == ','){
	                                    i++;
                                    }else{
	                                    cout << c << endl;
	                                    i++;
	                                }
	                            }
                            }else{
                                cout << "Ingrese un alfabeto" << endl;
                            }
                        }
;
mostrari    : MOSTRARI  {cout<<"Nodo inicial: "<<estadoInicial<<endl;}
;
mostrarc    : MOSTRARC  {   cout<<"Cantidad de transiciones: "<<cantidadTransiciones<<endl;}
;
mostrare    : MOSTRARE  {   int i = 0;
                            string pali="",ayuda="";
                            if (estados != ""){
                                for (char c : estados){
                                    if (c == ','){
                                        cout << pali << endl;
                                        pali="";
                                    }else{
                                        ayuda=c;
                                        pali = pali.append(ayuda);
                                    }
                                }
                                cout << pali << endl;
                            }else{
                                cout << "Ingrese un conjunto de estados" << endl;
                            }
                        }
mostrarf    : MOSTRARF {cout<<"Nodo Final: "<<estadoFinal<<endl;}
;
mostrart    : MOSTRART  {   if(arregloEntrada.size()!=0){
                                for(int i=0;i<arregloEntrada.size();i++){
                                    cout<< arregloEntrada[i] << endl;
                                }
                            }else{
                                cout<< "Ingrese transicion" << endl;
                            }

                        }
;
mostrarp    : MOSTRARP  {   cout<<"La palabra ingresada es: "<<palabra<<endl;}
;
nodo_final  : ENTRADA  { estadoFinal = $1}
            ;
nodo_inicial : ENTRADA { estadoInicial = $1}
             ;
cre_alfabeto : ENTRADA { alfabeto = $1}
            ;
cre_estados : ENTRADA { estados = $1;}
            ;
cre_palabra : ENTRADA { palabra = $1;}
;

tran        : ENTRADA   {   arregloEntrada.resize(cantidadTransiciones);
                            while(contAux<cantidadTransiciones)
                            {
                                if(arregloEntrada[contAux]!=$1)
                                {
                                    arregloEntrada[contAux]=$1;
                                    contAux++;
                                    break;
                                }
                            }
                        }
            | tran SEMICOLON tran
;

cant        : NUM { cantidadTransiciones = $1;}
;
start       : START {automata();}
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