%option noyywrap
%{
//INCLUDE DEL SCANNER
#include "AFDs.tab.h"

%}

%%
[ ] { return SPACE;}

[A-Za-z0-9]+ { yylval.sval = strdup(yytext);return EJEC;}
"alfabeto"  { return ALFABETO;}
"estados"   { return ESTADOS;}
"inicial"   { return INICIAL;}
"final"     { return FINAL;}
"palabra"   { return PALABRA;}
"transicion" { return TRANSICION;}
"iniciar"   { return INICIAR;}
\n			  { return FINLINEA; }
[ \t]	; // Ignora espacios en blanco
.			  { printf("No. %c\n", *yytext); }
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