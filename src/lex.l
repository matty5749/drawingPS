%{
#include "yacc.tab.h"
%}

NOMBRE [0-9]+
/*OPERATEUR_BINAIRE (\+|\-|\*|\/)*/
IDENTIFIANT ([a-zA-Z]+[a-zA-Z_]*)
/*Une chaine peut contenir tout les caracteres.A FAIRE: exceptés le caractere "*/
/*CHAINE (\".*\")*/
COMMENTAIRE (#.*\n)
/*COORD [{NOMBRE},{NOMBRE}]*/


%option yylineno

%%
	/*Dans cette section , les commentaires doivent être précédé d'une tabulation*/

DEBUT {return DEBUT;}
FIN {return FIN;}
PROTOTYPES {return PROTOTYPES;}
DECLARATIONS {return DECLARATIONS;}
carre {return CARRE;}
carrePlein {return CARREPLEIN;}
rectangle {return RECTANGLE;}
rectanglePlein {return RECTANGLEPLEIN;}
cercle {return CERCLE;}
cerclePlein {return CERCLEPLEIN;}
arc {return ARC;}
secteur {return SECTEUR;}
secteurPlein {return SECTEURPLEIN;}
couleur {return COULEUR;}

	/*{COORD} {return COORD}*/


	/*{CHAINE} {asprintf(&yylval,"%s",yytext);return CHAINE;}*/
	/*{OPERATEUR_BINAIRE} {asprintf(&yylval,"%s",yytext);return OPERATEUR_BINAIRE;}*/
	/*{IDENTIFIANT} {asprintf(&yylval,"%s",yytext);return IDENTIFIANT;}*/

{NOMBRE} {asprintf(&yylval,"%s",yytext);return NOMBRE;}
	/*; {return POINT_VIRGULE;}*/

	/*Les expressions ci dessous n'envoie pas d'information à yacc*/

\[ {return CG;}
\] {return CD;}
, {return VIRG;}


[ \t] {}
\n {}
{COMMENTAIRE} {}

%%

