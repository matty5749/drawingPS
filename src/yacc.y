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
int longueur=0, largeur=0;
int arcDebut=0;
int arcFin=0;
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

%token PROTOTYPES DECLARATIONS DEBUT FIN NOMBRE CARRE CARREPLEIN CERCLE CERCLEPLEIN RECTANGLE RECTANGLEPLEIN ARC SECTEUR SECTEURPLEIN CD CG VIRG COULEUR

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
	|primitiveRectangle {asprintf(&$$.ps,"%s",$1.ps);}
	|primitiveRectanglePlein {asprintf(&$$.ps,"%s",$1.ps);}
	|primitiveCercle {asprintf(&$$.ps,"%s",$1.ps);}
	|primitiveCerclePlein {asprintf(&$$.ps,"%s",$1.ps);}
	|primitiveArc {asprintf(&$$.ps,"%s",$1.ps);}
	|primitiveSecteur {asprintf(&$$.ps,"%s",$1.ps);}
	|primitiveSecteurPlein {asprintf(&$$.ps,"%s",$1.ps);}
	;

primitiveCarre:
	coord CARRE NOMBRE 
	{
		taille=atoi($3.ps);
		asprintf(&$$.ps,"newpath\n%d %d moveto\n%d %d lineto\n%d %d lineto\n%d %d lineto\nclosepath\nstroke\n",x-taille/2,y-taille/2,x+taille/2,y-taille/2,x+taille/2,y+taille/2,x-taille/2,y+taille/2);
	}
	;

primitiveCarrePlein:
	coord CARREPLEIN NOMBRE 
	{
		taille=atoi($3.ps);
		asprintf(&$$.ps,"newpath\n%d %d moveto\n%d %d lineto\n%d %d lineto\n%d %d lineto\nclosepath\nfill\nstroke\n",x-taille/2,y-taille/2,x+taille/2,y-taille/2,x+taille/2,y+taille/2,x-taille/2,y+taille/2);
	}
	;

primitiveRectangle:
	coord RECTANGLE NOMBRE NOMBRE 
	{
		longueur=atoi($3.ps);
		largeur=atoi($4.ps);
		asprintf(&$$.ps,"newpath\n%d %d moveto\n%d %d lineto\n%d %d lineto\n%d %d lineto\nclosepath\nstroke\n",x-longueur/2,y-largeur/2,x+longueur/2,y-largeur/2,x+longueur/2,y+largeur/2,x-longueur/2,y+largeur/2);
	}
	;	
	
primitiveRectanglePlein:
	coord RECTANGLEPLEIN NOMBRE NOMBRE 
	{
		longueur=atoi($3.ps);
		largeur=atoi($4.ps);
		asprintf(&$$.ps,"newpath\n%d %d moveto\n%d %d lineto\n%d %d lineto\n%d %d lineto\nclosepath\nfill\nstroke\n",x-longueur/2,y-largeur/2,x+longueur/2,y-largeur/2,x+longueur/2,y+largeur/2,x-longueur/2,y+largeur/2);
	}
	;	
	
primitiveCercle:	
	coord CERCLE NOMBRE 
	{
		taille=atoi($3.ps);
		asprintf(&$$.ps,"newpath\n%d %d %d 0 360 arc \nclosepath\nstroke \n",x,y,taille);
	}
	;

primitiveCerclePlein:	
	coord CERCLEPLEIN NOMBRE 
	{
		taille=atoi($3.ps);
		asprintf(&$$.ps,"newpath\n%d %d %d 0 360 arc \nclosepath\nfill\nstroke \n",x,y,taille);
	}
	;

primitiveArc:
	coord ARC NOMBRE NOMBRE NOMBRE
	{
		taille=atoi($3.ps);
		arcDebut=atoi($4.ps);
		arcFin=atoi($5.ps);
		asprintf(&$$.ps,"newpath\n%d %d %d %d %d arc \n 0 0 moveto \n closepath\nstroke \n",x,y,taille,arcDebut,arcFin);
	}
	;

primitiveSecteur:
	coord SECTEUR NOMBRE NOMBRE NOMBRE
	{
		taille=atoi($3.ps);
		arcDebut=atoi($4.ps);
		arcFin=atoi($5.ps);
		asprintf(&$$.ps,"newpath\n%d %d moveto\n%d %d %d %d %d arc \nclosepath\nstroke \n",x,y,x,y,taille,arcDebut,arcFin);
	}
	;

primitiveSecteurPlein:
	coord SECTEURPLEIN NOMBRE NOMBRE NOMBRE
	{
		taille=atoi($3.ps);
		arcDebut=atoi($4.ps);
		arcFin=atoi($5.ps);
		asprintf(&$$.ps,"newpath\n%d %d moveto\n%d %d %d %d %d arc \nclosepath\nfill\nstroke \n",x,y,x,y,taille,arcDebut,arcFin);
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
