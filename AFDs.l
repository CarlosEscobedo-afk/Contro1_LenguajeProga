%option noyywrap
%{
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

