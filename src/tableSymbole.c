#include "tableSymbole.h"
#include "stdlib.h"
#include "stdio.h"


Symbole* tableSymbole;

//Insere un symbole dans la table, on retient le nom et la ligne à laquelle a été trouvé le symbole
Symbole* insererSymbole (char* identifiant,int ligne)
{
	Symbole* ptr=(Symbole*)getSymbole(identifiant);
	
	//Si le symbole n'est pas déjà present dans la table des symboles --> Creation du symbole
	if(!ptr) 
	{
		ptr = (Symbole *) malloc (sizeof (Symbole));
		ptr->id = identifiant;
		ptr->est_utilise = 0;
		ptr->ligne = ligne;
		ptr->arite = 0;
		ptr->suivant = tableSymbole;
		tableSymbole = ptr;
	} 
	return ptr;
}


//Recupere un symbole dans la table des symboles si il existe dans celle-ci, 0 sinon
Symbole* getSymbole (char* identifiant)
{
	Symbole* ptr;
	for (ptr = tableSymbole; ptr; ptr = ptr->suivant)
		if (strcmp (ptr->id,identifiant) == 0)
			return ptr;
	return 0;
}


//Parcours de la table des symboles afin de detecter d'eventuelles erreurs ou oublis
int lectureTableDeSymbole()
{
	Symbole* ptr;
	int nb_erreur=0;
	for (ptr = tableSymbole; ptr; ptr = ptr->suivant)
		if (!ptr->est_utilise)
		{
			nb_erreur++;
			fprintf(stderr, "Ligne %d :\n",ptr->ligne);
			fprintf(stderr, "Attention: la variable %s n'est pas utilisee\n\n", ptr->id);
		}
	return nb_erreur;
}

