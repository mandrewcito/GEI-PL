#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char * cabeza[100];
char * pie[100];
char *contenido[100];

int rellenaCabeza(char * fileName,char *cabeza[]){
  FILE* file = fopen(fileName, "r");
  char line[256];
  int n=0;
  while (fgets(line, sizeof(line), file)) {
	cabeza[n]=strdup(line);
        n++;
  }
  fclose(file);
return 1;
}
int rellenaPie(char * fileName,char *pie[]){
  FILE* file = fopen(fileName, "r");
  char line[256];
  int n=0;
  while (fgets(line, sizeof(line), file)) {
	pie[n]=strdup(line);
        n++;
  }
  fclose(file);
return 1;
}
int creaFichero(char *fileName,char *lineas[]){
char ch;
FILE* fp = fopen(fileName, "w");
int i=0;
while(cabeza[i]!=NULL){
  //putc(cabeza[i],fp);
  fprintf(fp, "%s\n", cabeza[i]);
  i++;
}
i=0;
while(lineas[i]!=NULL){
  char tmp[100];
  //sprintf(tmp, "<div> %s </div>",lineas[i]);
  //putc(tmp,fp);
  fprintf(fp, "#capitulo %d \n \n %s \n \n",i,lineas[i]);
  i++;
}

i=0;
while(pie[i]!=NULL){
  //putc(pie[i],fp);
  fprintf(fp, "%s\n \n", pie[i]);
  i++;
}
fclose(fp);
}
int crearContenido(char* lineas[]){
rellenaCabeza("res/cabeza.txt",cabeza);
rellenaPie("res/pie.txt",pie);
creaFichero("PdfToEpub-tmp.txt",lineas);
return 0;
}
