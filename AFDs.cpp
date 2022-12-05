#include <iostream>
#include <iterator>
#include <fstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <sstream>
using namespace std;

//Variables Globales:
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

//Función para realizar un Split en un String:
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

//Automata genérico:
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
}

//Main
int main(){
	string *transit = NULL;
	//Definiciones para el Autómata:
    int cantidadTransiciones = 3;
    string alfabeto = "a,b,c";
    string estados = "q1,q2,q3";
    string estadoInicial = "q1";
    string estadoFinal = "q3";
    string transicion = "{q1,a,q2};{q2,c,q3};{q2,b,q2}";
    string palabra = "abbbbbbbbcca";
    
    //Separar transiciones:
	transit = new string[cantidadTransiciones];
	char seperator = '};{';
    split(transicion, seperator);
    
    //Añadir transiciones al puntero:
	for (int j = 0; j < cantidadTransiciones; j++){
		transit[j] = strings[j+1];
		/*
		//Intento de limpiar las transiciones:
		char ch = ';';
		transit[j].erase(remove(transit[j].begin(), transit[j].end(),ch), transit[j].end());
		cout << "TRANSICIONES   " << transit[j] << endl;
		*/
	}
	
	cout << endl;
	//Llamar autómata:
    automata(estados, alfabeto, estadoInicial, estadoFinal, palabra, transit, cantidadTransiciones);
    delete [] transit;
    return 0;
}
