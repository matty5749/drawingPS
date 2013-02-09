%{
#include "yacc.tab.h"
%}

NOMBRE ([0-9]+)
OPERATEUR_BINAIRE (\+|\-|\*|\/)
IDENTIFIANT ([a-zA-Z]+[a-zA-Z_]*)
/*Une chaine peut contenir tout les caracteres.A FAIRE: exceptés le caractere "*/
CHAINE (\".*\")
COMMENTAIRE (#.*\n)

%option yylineno

%%
	/*Dans cette section , les commentaires doivent être précédé d'une tabulation*/



FONCTION {return FONCTION;}
PARAMETRES {return PARAMETRES;}
DEBUT {return DEBUT;}
RETOUR {return RETOUR;}
FIN_FONCTION {return FIN_FONCTION;}

APPEL {return APPEL;}
FIN_REPETE {return FIN_REPETE;}
DECLARE {return DECLARE;}
AFFECTE {return AFFECTE;}
AFFICHE {return AFFICHE;}
REPETE {return REPETE;}

{CHAINE} {asprintf(&yylval,"%s",yytext);return CHAINE;}
{OPERATEUR_BINAIRE} {asprintf(&yylval,"%s",yytext);return OPERATEUR_BINAIRE;}
{IDENTIFIANT} {asprintf(&yylval,"%s",yytext);return IDENTIFIANT;}
{NOMBRE} {asprintf(&yylval,"%s",yytext);return NOMBRE;}
; {return POINT_VIRGULE;}

	/*Les expressions ci dessous n'envoie pas d'information à yacc*/
[ \t] {}
\n {}
{COMMENTAIRE} {}

%%

