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
"cantidad" {return CANTIDAD;}
"mostrari" {return MOSTRARI;}
"mostrarf" {return MOSTRARF;}
"mostrare" {return MOSTRARE;}
"mostrara" {return MOSTRARA;}
"mostrarp" {return MOSTRARP;}
"mostrart" {return MOSTRART;}
"mostrarc" {return MOSTRARC;}


";"           {return SEMICOLON;}
[0-9]+		{yylval.ival = atoi(yytext); return NUM;}
(,*[A-Za-z0-9]+)+ { yylval.sval = strdup(yytext);return ENTRADA;}
\n	{ return FINLINEA; }

[ \t]   { /*ignoramos en este caso*/ } 
. 	{ printf("OTRO CARACTER %s \n", *yytext); }
%%

