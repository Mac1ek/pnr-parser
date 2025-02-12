# PNR DATA PARSER
## Parser with scanner, tokens and prouctions used with bison and flex with c language

### Name pnr_parser
### Program parse PNR Flight data
### source file: XML

## Authors

- [@Mac1ek](https://github.com/Mac1ek/)


## Documentation

### Makefile command :
##### make - compile and run, compiler create also graphiz data for create graphical graph model
##### make debug - compile and run parser in debug mode for show parsing additional information
##### clean: command run remove files: rm -f ${PROG} ${PROG}.tab.c ${PROG}.tab.h lex.yy.c
##### binary name after compile: pnr_parser


### run command with debug mode example:

##### ./pnr_parser -debug < test_pnr.xml

### run normal mode command example:

##### ./pnr_parser < test_pnr.xml

## Visualisation data:

##### dot -Tpng pnr_parser.gv -o pnr_parser.png
