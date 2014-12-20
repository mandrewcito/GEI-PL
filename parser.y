%{
#include <stdio.h>
#include "toEpub.c"
void yyerror (char const *);
char *parrafos[100];
int insertar=0;
int nObj=0;
int nObjerr=0;
%}

%union{
	int valInt;
        char * valString;
        float valFloat;
}
%token END
%token <valFloat>FLOAT
%token <valInt> NUMERO
%token <valString> COMMENT ENDCOMMENT XREF INICIO FIN STR ENDSTR OBJ ENDOBJ LETRA STARTXREF TRAIL CADENA KEY CIFRA BOOL NAMEOBJ STRLITERAL STRHX INIARRAY FINARRAY OBJ_REF CONTENIDOSTREAM 
%type <valString> cabecera cuerpo lista_obj obj stream comentarios cola lista_xref linea_xref cxref dict lineadict lineasdict  contenido_obj stream_obj clave valor name_obj string array numerico arraycells
%start S
%%

S:cabecera cuerpo cola END{printf("Parsing completado!!! \n");}
	;
cabecera:comentarios {}
	;
comentarios: comentarios COMMENT ENDCOMMENT{printf("comentario \n");}
	|COMMENT ENDCOMMENT {printf("comentario \n");}
	|{}
	;
cuerpo: lista_obj {}
	;
lista_obj:lista_obj comentarios obj  {}
	|comentarios obj {}
	;
obj:NUMERO NUMERO OBJ contenido_obj ENDOBJ{printf("objeto %d %d \n",$1,$2);nObj++;}
	|error{yyerror("error en objeto");yyclearin;nObjerr++;}
	;
contenido_obj:numerico{}
	|BOOL{}
	|stream_obj{}
	|dict{}
	|name_obj{}
	|OBJ_REF{}
	|string{}
	|{}
	;
stream_obj: dict stream {}
	;
stream: STR CONTENIDOSTREAM ENDSTR{parrafos[insertar]=$2;insertar++;}
	|error CONTENIDOSTREAM ENDSTR{yyerror("error inicio stream");yyclearin;}
	|STR error ENDSTR{yyerror("error contenido stream");yyclearin;}
	|STR CONTENIDOSTREAM error{yyerror("error contenido stream");yyclearin;}
	;
cola: cxref TRAIL dict STARTXREF NUMERO {}
	;
dict: INICIO lineasdict FIN {}
	|{}
	;
lineasdict: lineasdict lineadict {}
	|lineadict{}
	;
lineadict:clave valor {}
	|error valor{yyerror("error en clave");yyclearin;}
	|clave error{yyerror("error en valor");yyclearin;}
	;
clave:KEY {printf("<clave>");}
	;
valor:numerico{}
	|BOOL {printf("<BOOL> ");}
	|string{}
	|name_obj{printf("<name obj>");}
	|array{printf("<array>");}
	|OBJ_REF{printf("<obj_ref>");}
	;
numerico:CIFRA{printf("<cifra>");}
	|NUMERO{printf("<numero>");}
	|FLOAT{printf("<Float>");}
	;
array: INIARRAY arraycells FINARRAY{}
	|error arraycells FINARRAY{yyerror("error en INIARRAY");yyclearin;}
	|INIARRAY error FINARRAY{yyerror("error en celdas array");yyclearin;}
	|INIARRAY arraycells error{yyerror("error en FINARRAy");yyclearin;}
	;
arraycells: arraycells " "valor{}
	|" "valor{}
	;
string:STRLITERAL {printf("<strLITERAL>");}
	|STRHX {printf("<strHEX>");}
	;
name_obj: NAMEOBJ{}
	;
cxref: XREF NUMERO NUMERO lista_xref{}
	|{}
	;
lista_xref: {}
	|lista_xref linea_xref{}
	;
linea_xref:NUMERO NUMERO LETRA {}
	;

%%
int main(int argc, char *argv[] ) {
	yyparse();
	int i=0;
	while(parrafos[i]!=NULL)
	{
		printf("%s \n",parrafos[i]);
		i++;
	}
 	crearContenido(parrafos);
	printf("\n numero de objetos %d , obj con error %d \n",nObj,nObjerr);
	return 0;
}
void yyerror (char const *message) {fprintf (stderr, "%s \n", message);}
