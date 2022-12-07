%option noyywrap
%{
//INCLUDE DEL SCANNER
#include "AFDs.tab.h"

%}

%%
"inicial" { return INICIAL;}
"final" { return FINAL;}
"estados" { return ESTADOS;}
"alfabeto" { return ALFABETO;}
"palabra" {return PALABRA;}
"transiciones" {return TRANSICION;}
"iniciar"   {return START;}
(,*[A-Za-z0-9]+)+ { yylval.sval = strdup(yytext);return ENTRADA;}
\n	{ return FINLINEA; }

[ \t]   { /*ignoramos en este caso*/ } 
. 	{ printf("OTRO CARACTER %s \n", *yytext); }
%%



/*
string alfabeto = "" , estados = "" , estadoInicial = "" , estadoFinal ="" , palabra = "";
{numeros}	  { yylval = atoi(yytext); return ENTERO; }
{palabras}	  { sscanf(yytext, "%s", yylval.cad); return CADENA; }

"{"letra_numero"}"	  { return ALFABETO }
{estado}	  { return ESTADO }
"transicion{{"[[a-zA-Z0-9]+","|[a-zA-Z0-9]+]+"}}"  { return TRANSICION }
"{"			  { return LLAVE }
","			  { return COMMA }
*/