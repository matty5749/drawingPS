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

int x=0;
int y=0;
int taille=0;
int r=0;
int g=0;
int b=0;

struct token
{
char* ps;
int arite;
};
typedef struct token token;

#define YYSTYPE token
#define YYERROR_VERBOSE 1
%}

%token PROTOTYPES DECLARATIONS DEBUT FIN NOMBRE CARRE  CARREPLEIN CD CG VIRG COULEUR

%start program
%%

program : PROTOTYPES DECLARATIONS DEBUT ensInstructions FIN
		{
			printf("\nLe code source lobo est syntaxiquement correct!\n");
			FILE* fichier=fopen("traduction.ps","w");
			if (fichier)
			{
				fprintf(fichier,"%s",$4.ps);
			}
			fclose(fichier);
		}
	;

ensInstructions:
	instruction {asprintf(&$$.ps,"%s",$1.ps);}
	| instruction ensInstructions {asprintf(&$$.ps,"%s %s",$1.ps,$2.ps);} 
	;

instruction :
	color {asprintf(&$$.ps,"%s",$1.ps);}
	|primitiveCarre {asprintf(&$$.ps,"%s",$1.ps);}
	|primitiveCarrePlein {asprintf(&$$.ps,"%s",$1.ps);}
	;

primitiveCarre:
	coord CARRE NOMBRE 
	{
		taille=atoi($3.ps);
		asprintf(&$$.ps,"newpath\n%d %d moveto\n%d %d lineto\n%d %d lineto\n%d %d lineto\nclosepath\nstroke\n",x,y,x+taille,y,x+taille,y+taille,x,y+taille);
	}
	;

primitiveCarrePlein:
	coord CARREPLEIN NOMBRE 
	{
		taille=atoi($3.ps);
		asprintf(&$$.ps,"newpath\n%d %d moveto\n%d %d lineto\n%d %d lineto\n%d %d lineto\nclosepath\nfill\nstroke\n",x,y,x+taille,y,x+taille,y+taille,x,y+taille);
	}
	;

coord:
	CG NOMBRE VIRG NOMBRE CD
	{
		x=atoi($2.ps);
		y=atoi($4.ps);
	}
	;
	
color:
	COULEUR CG NOMBRE VIRG NOMBRE VIRG NOMBRE CD
	{
		r=atoi($3.ps);
		g=atoi($5.ps);
		b=atoi($7.ps);

		asprintf(&$$.ps,"%d %d %d setrgbcolor\n",r,g,b);
	}
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
		//char *name =(char*) gestionArgument(argc, argv);
		fclose(fichier);

		/*
		char *strTemp;
		strTemp = (char*)malloc(sizeof(char)*(strlen(name)+strlen("indent -linux ")+1));
		strcpy(strTemp,"indent -linux ");
		strcat(strTemp, name);
		system(strTemp);
		free(strTemp);
		name = NULL;
		strTemp = NULL;
		*/
	}

return 0;
}

int yyerror(char *s)
{
	char* chaine=(void *)yytext;
	fprintf(stderr,"%s sur : %s \n", s ,chaine);
	return 0;
}
