#include "gestionArgument.h"

extern int opterr;

char* gestionArgument(int paramargc, char** const paramargv)
{
	int optch;
	
	char format[] = "n:";
	
	opterr = 1;

		if ( paramargc == 2 )
		{
			printf("\nLa traduction du code source se trouve dans le fichier traduction.ps\n");
			return "traduction.ps";
		}
		else
		{
			if( (optch = getopt(paramargc, paramargv, format) ) != -1 )
			{
				optind = 1;

				while ( (optch = getopt(paramargc, paramargv, format) ) != -1 )
				{
					switch ( optch )
					{
						case 'n' :
						{
							char *name = (char*)malloc(sizeof(char)*(strlen(optarg)+1));
							strcpy(name, optarg);

							if (strstr(name, ".cpp") == NULL)
							{
								char *temp = (char*)malloc(sizeof(char)*(strlen(name)+5));
								strcpy(temp, name);
								strcat(temp, ".ps\0");
								free(name);
								name = temp;
							}

							rename("traduction.ps", name);	
							printf ("\nLa traduction du code source se trouve dans le fichier %s  \n", name);

							return name;
						break;
						}

						default:
							printf("\nLa traduction du code source se trouve dans le fichier traduction.ps\n");
							return "traduction.ps";
						break;
					}
				}
			}
			else 
			{
				printf("\nLa traduction du code source se trouve dans le fichier traduction.ps\n");
				return "traduction.ps";
			}
		}
}
