PROG = pnr_parser

all: ${PROG} run
${PROG}.tab.c: ${PROG}.y
	bison -d ${PROG}.y
	bison -v -g ${PROG}.y
lex.yy.c: ${PROG}lex.l
	flex ${PROG}lex.l
${PROG}: ${PROG}.tab.c lex.yy.c
	gcc -o ${PROG} ${PROG}.tab.c lex.yy.c -lfl
run: ${PROG}
	./${PROG} < test_pnr.xml
test: ${PROG}
	./${PROG} < test_parser.xml
debug: ${PROG}
	./${PROG} -debug < test_pnr.xml
clean:
	rm -f ${PROG} ${PROG}.tab.c ${PROG}.tab.h lex.yy.c
