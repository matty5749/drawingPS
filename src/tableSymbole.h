#ifndef TABLE_SYMBOLE_H
#define TABLE_SYMBOLE_H

/*
Une table des symboles est composés de symbole.
Un symbole tel que définit dans la structure ci dessous a pour role:

	_d'identifier une variable ou une fonction lors de sa déclaration
	
	_de recuperer des informations concernant cette variable ou fonction (arité , ligne de déclaration)
	
	_d'etre mis à jour au fur et a mesure de la traduction(à la "volée") effectué par le parseur (respect de l'arité lors des appels de fonctions, utilisation des variables/fonctions déclarés
	
*/


//Un symbole est composé de
struct s_Symbole 
{
        char* id;		//Un identifiant unique (nom variable/fonction)
	int est_utilise;	//Un drapeau(flag) afin de savoir si une variable/fonction déclaré est bien utilisé
	int ligne;		//Le numero de la ligne de la déclaration
	int arite;		//Pour une fonction, le nombre d'argument qu'elle attend
	int estProcedure;       //1 si c'est une procedure, 0 si c'est une variable
	struct s_Symbole* suivant; 	//Un pointeur vers le symbole suivant
};

typedef struct s_Symbole Symbole ;

Symbole* insererSymbole (char*,int procedure,int ligne);//Insere un symbole
Symbole* getSymbole (char*);//Recupere un symbole si il existe dans la table des symboles, 0 sinon
int lectureTableDeSymbole();//Parcours de la table des symboles et renvoie du nombre d'erreur,0 si pas d'erreur

#endif
