FUENTE = parser
PRUEBA=pdfFIles/entrada.txt
TEST=pdfFIles/ejemploOrig-sinZIP.pdf
TMP=PdfToEpub-tmp.txt
EPUBFILE=example.epub
all: compile run

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -yd -v
	gcc -g -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -lfl -ly

run:
	./$(FUENTE) < $(PRUEBA)
debug:
	valgrind ./$(FUENTE)<$(PRUEBA)
test:
	./$(FUENTE)<$(TEST)
epub:
	./$(FUENTE) < $(PRUEBA) && pandoc $(TMP) -o example.epub
clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h $(TMP)
	rm *~
