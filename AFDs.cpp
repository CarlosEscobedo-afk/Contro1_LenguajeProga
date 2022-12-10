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
string strings[3];

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
    int largo= len(str);
    while (i <= largo){  
        if (str[i] == seperator || i == largo ){  
            endIndex = i;
            string subStr = "";
            subStr.append(str, startIndex + 1, (endIndex - 1) - (startIndex + 1));
            strings[currIndex] = subStr;
            cout<<"strings: "<<strings[currIndex]<<endl;
            currIndex += 1;
            startIndex = endIndex + 1;
        }
        i++;
    }
}

//Automata gen�rico:
void automata(string estados, string alfabeto, string estadoInicial, string estadoFinal, string palabra, string strings[], int cantidadTransiciones){
    int estadoEjec = 0; // Estado en ejecucion
    string marcaEstado; // Indica el estado actual del DFA.
    int count = 0; // Contador para definir el final de la lectura de la palabra de ingreso.
	
    // Aca se definen las transiciones.
    for(int i=0; i < palabra.length(); i++){
        for(int j=0; j < alfabeto.length(); j++){
            if(palabra[i] == alfabeto[j]){
        		for(int h=0; h < cantidadTransiciones; h++){
        			//Transicion de estado.
        			if(strings[estadoEjec][3] == palabra[i]){
						ostringstream ss;
					    ss << strings[estadoEjec][5] << strings[estadoEjec][6];
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
	//Definiciones para el Aut�mata:
    int cantidadTransiciones = 3;
    string alfabeto = "a,b,c";
    string estados = "q1,q2,q3";
    string estadoInicial = "q1";
    string estadoFinal = "q3";
    string transicion = "{q1,a,q2};{q2,b,q2};{q2,c,q3}";
    string palabra = "abca";
    
	
	
	char seperator = ';';
	
    split(transicion, seperator);
    

    //A�adir transiciones al puntero:
    
	
	cout << endl;
	//Llamar aut�mata:
    automata(estados, alfabeto, estadoInicial, estadoFinal, palabra, strings, cantidadTransiciones);
    return 0;
}
