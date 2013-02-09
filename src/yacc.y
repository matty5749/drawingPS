%{
#include "stdio.h"
#include "tableSymbole.h"
#include "gestionArgument.h"

int erreur=0;
int repete=0;

int yylex(void);
int yytext(void);
extern int yyin;
extern int yylineno;


struct token
{
char* cpp;
int arite;
};
typedef struct token token;

#define YYSTYPE token
#define YYERROR_VERBOSE 1
%}

%token FONCTION PARAMETRES DEBUT RETOUR FIN_FONCTION POINT_VIRGULE
%token APPEL FIN_REPETE DECLARE AFFECTE AFFICHE REPETE
%token CHAINE  OPERATEUR_BINAIRE IDENTIFIANT NOMBRE

%start program
%%

program :
	ensDefinitionFonction ensInstructions 
	{
		int erreurTS=lectureTableDeSymbole();
		if (erreurTS || erreur)
		{
			fprintf(stderr,"Il y a : %d erreur\n", erreurTS+erreur);
		}
		else
		{
			printf("\nLe code source lobo est syntaxiquement correct!\n");
			FILE* fichier=fopen("traduction.cpp","w");
			if (fichier)
			{
				fprintf(fichier,"#include <stdio.h>\n#include <math.h>\n#include <iostream>\nusing namespace std;\n\n");
				fprintf(fichier,"%s",$1.cpp);
				fprintf(fichier,"int main(int argc,char** argv)\n{\n");
				fprintf(fichier,"%s",$2.cpp);
				fprintf(fichier,"return 0;\n}");
			}
			fclose(fichier);
		}
	}
	;

ensDefinitionFonction:
	/*vide*/ {asprintf(&$$.cpp,"");}
	|ensDefinitionFonction definition_fonction {asprintf(&$$.cpp,"%s%s",$1.cpp,$2.cpp);}
	;
		
ensInstructions:
	instructions {asprintf(&$$.cpp,"%s",$1.cpp);}
	|ensInstructions instructions {asprintf(&$$.cpp,"%s%s",$1.cpp,$2.cpp);}
	;
	
instructions :
	appel_fonction POINT_VIRGULE {asprintf(&$$.cpp,"%s",$1.cpp);}
	|repete {asprintf(&$$.cpp,"%s",$1.cpp);}
	|instruction_simple POINT_VIRGULE {asprintf(&$$.cpp,"%s",$1.cpp);}
	;
	
definition_fonction:
	FONCTION IDENTIFIANT PARAMETRES ensIdentifiants DEBUT ensInstructions RETOUR expression POINT_VIRGULE FIN_FONCTION
	{
		asprintf(&$$.cpp,"int %s(%s)\n{\n%sreturn %s;\n}\n\n",$2.cpp,$4.cpp,$6.cpp,$8.cpp);
		insererSymbole($2.cpp,yylineno)->arite=$4.arite;
	}
	;

ensIdentifiants:
	/*vide*/ {asprintf(&$$.cpp,"");$$.arite=0;}
	| identifiants {asprintf(&$$.cpp,"%s",$1.cpp);}
	;

identifiants:
	IDENTIFIANT  
	{
		insererSymbole($1.cpp,yylineno);
		asprintf(&$$.cpp,"int %s",$1.cpp);
		$$.arite++;
	}
	|identifiants IDENTIFIANT  
	{
		insererSymbole($2.cpp,yylineno);
		asprintf(&$$.cpp,"%s,int %s",$1.cpp,$2.cpp);
		$$.arite++;
	}
	;
	
appel_fonction :
	APPEL IDENTIFIANT ensParametres
	{
		asprintf(&$$.cpp,"%s(%s);\n",$2.cpp,$3.cpp);
		Symbole* symb=getSymbole($2.cpp);
		if (symb) 
		{	
			symb->est_utilise=1;
			if (symb->arite!=$3.arite) 
			{
				fprintf(stderr,"Erreur: Ligne %d: la fonction %s attend %d arguments.Hors vous en avez placé %d\n",yylineno,$2.cpp,symb->arite,$3.arite);
				erreur++;
			}
		}
		else 
		{
			fprintf(stderr,"Erreur: Ligne %d: la fonction %s n'a pas été déclaré\n",yylineno,$2.cpp);
			erreur++;
		}
	}
	;
	
repete :
	REPETE NOMBRE DEBUT ensInstructions FIN_REPETE
	{
		asprintf(&$$.cpp,"int repete%d=1;\nwhile (repete%d<=%s)\n{\n%srepete%d++;\n}\n",repete,repete,$2.cpp,$4.cpp,repete);
		repete++;
	}
	;
	
instruction_simple :
	declare_variable {asprintf(&$$.cpp,"%s",$1.cpp);}
	|affecte_variable {asprintf(&$$.cpp,"%s",$1.cpp);}
	|affiche_chaine {asprintf(&$$.cpp,"%s",$1.cpp);}
	|affiche_variable {asprintf(&$$.cpp,"%s",$1.cpp);}
	;
	
declare_variable:
	DECLARE IDENTIFIANT 
	{
		asprintf(&$$.cpp,"int %s ;\n",$2.cpp);
		insererSymbole($2.cpp,yylineno);
	}
	
	;
	
affecte_variable:
	AFFECTE IDENTIFIANT expression 
	{
		asprintf(&$$.cpp,"%s = %s ;\n",$2.cpp,$3.cpp);
		Symbole* symb=getSymbole($2.cpp);
		if (symb) symb->est_utilise=1;
		else
		{
			fprintf (stderr,"Erreur: Ligne %d : La variable %s n'a pas été déclaré.\n",yylineno,$2.cpp);
			erreur++;
		}
	}
	;
	
affiche_chaine:
	AFFICHE CHAINE {asprintf(&$$.cpp,"cout<<%s<<endl;\n",$2.cpp);}
	;

affiche_variable:
	AFFICHE IDENTIFIANT 
	{
		asprintf(&$$.cpp,"cout<<%s<<endl;\n",$2.cpp);
		Symbole* symb=getSymbole($2.cpp);
		if (symb) symb->est_utilise=1;
		else
		{
			fprintf (stderr,"Erreur: Ligne %d : La variable %s n'a pas été déclaré.\n",yylineno,$2.cpp);
			erreur++;
		}
	}
	;
	
expression:
	parametre {asprintf(&$$.cpp,"%s",$1.cpp);}
	|OPERATEUR_BINAIRE expression expression {asprintf(&$$.cpp,"%s%s%s",$2.cpp,$1.cpp,$3.cpp);}
	;

ensParametres:
	/*vide*/ {asprintf(&$$.cpp,"");}
	|ensParametres parametre {asprintf(&$$.cpp,"%s",$2.cpp);$$.arite++;}
	;
	
parametre:
	IDENTIFIANT
	|NOMBRE
	;
	
%%

int main(int argc, char **argv) 
{
	if(argc >= 2)
	{
		FILE* fichier;
		if(!(fichier=fopen(argv[1], "r"))) return 1;
			
		yyin=(int)fichier;	
		yyparse();
		char *name =(char*) gestionArgument(argc, argv);
		fclose(fichier);

		char *strTemp;
		strTemp = (char*)malloc(sizeof(char)*(strlen(name)+strlen("indent -linux ")+1));
		strcpy(strTemp,"indent -linux ");
		strcat(strTemp, name);
		system(strTemp);
		free(strTemp);
		name = NULL;
		strTemp = NULL;
	}

return 0;
}

int yyerror(char *s)
{
	char* chaine=(void *)yytext;
	fprintf(stderr,"%s sur : %s \n", s ,chaine);
	return 0;
}
