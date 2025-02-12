%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

int is_debug = 0;

typedef struct Passenger {
  char* first_name;
  char* second_name;
  char * ssr_code;
  char* gender;
  char* status;
  char* rph;
  char *ref_num;
  char* text;
  struct Passenger* next;
} Passenger;

Passenger * passenger_nodes = NULL;

void passenger_allocator() {
  
  Passenger* new_passenger = malloc(sizeof(Passenger));
  if (!new_passenger) {
    printf("Memory allocation failed %s\n", __FUNCTION__);
    exit(EXIT_FAILURE);
  }
  else {
    if(is_debug) printf("---ALLOC---\n");
  }

  new_passenger->first_name = NULL;
  new_passenger->second_name = NULL;
  new_passenger->ssr_code = NULL;
  new_passenger->gender = NULL;
  new_passenger->status = NULL;
  new_passenger->rph = NULL;
  new_passenger->ref_num = NULL;
  new_passenger->text = NULL;
  new_passenger->next = NULL;

  if (passenger_nodes == NULL) {
    passenger_nodes = new_passenger;
  } else {
    passenger_nodes->next = new_passenger;
  }
}

void passenger_print() {
    printf("------------- Passenger data --------------------------\n");
    printf("Passenger First name: %s\n", passenger_nodes->first_name);
    printf("Passenger Sure name:  %s\n", passenger_nodes->second_name);
    printf("Gender:               %s\n", passenger_nodes->gender);
    printf("RPH:                  %s\n", passenger_nodes->rph);
    printf("Ref Number            %s\n", passenger_nodes->ref_num);
    printf("SSR:                  %s\n", passenger_nodes->ssr_code);
    printf("Passanger status:     %s\n", passenger_nodes->status);
}

typedef struct Flight {
  char* pnr_passengers_number;
  char* dair_loc_code;
  char* arri_loc_code;
  char* air_line_code;
  char* dep_datetime;
  char* arriv_datetime;
  char* dep_airport;
  char* arriv_airport;
  char* company_code;
} Flight;

Flight* flight_data;

%}

%token DANEXML DANEXML_CLOSE PNR PNR_CLOSE EQ XMLNS_XSD XMLNS_XSI TEXT RT SPACE PASSENGERS_NUMBER BOOKING_REF BOOKING_REF_CLOSE
%token ID COMPANY_CODE COMPANY_NAME ET
%token PNR_TRANS_DATE PNR_CREATION_DATE
%token XMLNS T_TEXT T_TEXT_CLOSE T_TEXT_EMPTY
%token PASSENGER PASSENGER_CLOSE S_NAME_REFNUM ACC_STATUS RPH
%token GIVENNAME GIVENNAME_CLOSE SURNAME SURNAME_CLOSE AIRLINE
%token DOC_SSR DOC_SSR_CLOSE SSR_CODE SERVICE_QT STATUS FL_INFO DOCS
%token FIRSTNAME_PARAM SURNAME_PARAM GENDER ARRAIRPORT MARKAIRLINE SSR SSR_CLOSE BOARDPOINT OFFPOINT
%token FLIGHT FLIGHT_CLOSE DEPAIRPORT LOCATION_CODE DEP_DATETIME ARRIV_DATETIME NUM_PARTY FLIGHT_NUMBER

%union {
  char* str;
}

%type<str> TEXT

%%

input: xml
     ;

xml: DANEXML pnr DANEXML_CLOSE { if(is_debug) printf("Parsed <DaneXML> element\n"); }
   ;

pnr: PNR SPACE pnr_param RT pnr_data PNR_CLOSE { if(is_debug) printf("Parsed <PNR> with data\n"); }
   | PNR RT PNR_CLOSE { if(is_debug) printf("Parsed empty <PNR>\n"); }
   ;

pnr_param: pnr_attr
        | pnr_param SPACE pnr_attr { if(is_debug) printf("Print pnr_param\n"); }
        ;

pnr_data: booking_data passengers_data flight_data
        ;

booking_data: BOOKING_REF SPACE booking_param RT booking BOOKING_REF_CLOSE { if(is_debug) printf("Parse Booking REF with param"); }
        ;

booking_param: booking_attr
             | booking_param SPACE booking_attr
             ;

booking_attr:
            XMLNS EQ text_data { if(is_debug) printf("Parse Booking REF string\n"); } 
            | ID EQ text_data { if(is_debug) printf("Parse Booking ID string\n"); }
            ;

booking: COMPANY_NAME SPACE COMPANY_CODE EQ text_data ET { if(is_debug) printf("Parse company code\n"); } 
       ;

passengers_data: single_passenger { if(is_debug) printf("Parse passenger Name (1)\n"); }
              | passengers_data single_passenger { if(is_debug) printf("Parse passenger (2)\n"); 
              }
              ;
    
single_passenger: passenger_start SPACE passenger_param RT passenger_details passenger_end { if(is_debug) printf("Parse passenger param"); 
                }
               ;

passenger_start: PASSENGER { passenger_allocator(); }
passenger_end: PASSENGER_CLOSE { passenger_print(); }

passenger_param: passenger_attr { if(is_debug) printf("Parse parameters (1) \n"); }
               | passenger_param SPACE passenger_attr { if(is_debug) printf("Parse parameters (2) \n"); }
               ;

passenger_attr: 
              XMLNS EQ text_data { if(is_debug) printf("Parse Passenger XMLNS parameter\n"); }
               | RPH EQ TEXT { if(is_debug) printf("Parse Passenger RPH parameter\n"); passenger_nodes->rph = $3; }
               | S_NAME_REFNUM EQ TEXT { if(is_debug) printf("Parse Passenger ref num\n"); passenger_nodes->ref_num = $3;}
               | ACC_STATUS EQ text_data { if(is_debug) printf("Parse Passenger acc status\n"); }
               ;

passenger_details: 
              passenger_elem { if(is_debug) printf("Print passenger details (1)\n"); }
              | passenger_details passenger_elem { if(is_debug) printf("Print passenger details (2)\n"); }
              ;

passenger_elem: 
              GIVENNAME TEXT GIVENNAME_CLOSE { if(is_debug) printf("Print passenger name: %s\n", $2); passenger_nodes->first_name = $2; }
              | SURNAME TEXT SURNAME_CLOSE { if(is_debug) printf("Print passenger surname: %s\n", $2); passenger_nodes->second_name = $2; }
              | DOC_SSR SPACE ssr_param RT ssr_data DOC_SSR_CLOSE { if(is_debug) printf("Print SSR data\n"); }
              ;

ssr_param: ssr_attr
         | ssr_param SPACE ssr_attr
         ;

ssr_attr:
        SSR_CODE EQ TEXT { if(is_debug) printf("Parse SSR code.\n"); passenger_nodes->ssr_code = $3; }
        | SERVICE_QT EQ text_data { if(is_debug) printf("Parse service qty.\n"); }
        | STATUS EQ TEXT { if(is_debug) printf("Parse SSR status\n"); passenger_nodes->status= $3; }
        | BOARDPOINT EQ text_data { if(is_debug) printf("Parse SSR boardpoint\n"); }
        | OFFPOINT EQ text_data { if(is_debug) printf("Parse SSR offpoint\n"); }
        | RPH EQ text_data { if(is_debug) printf("Parse SSR RPH\n"); }
        ;

ssr_data: ssr_details_data { if(is_debug) printf("Parse ssr details data (1)\n"); }
        | ssr_data ssr_details_data { if(is_debug) printf("Parse ssr details data (2)\n"); }
        ;

ssr_details_data:
                FL_INFO SPACE fl_param ET { if(is_debug) printf("Parse flight info\n"); }
                | DOCS SPACE fl_param ET { if(is_debug) printf("Parse DOCS\n"); }
                | T_TEXT TEXT T_TEXT_CLOSE { if(is_debug) printf("Parse SSR text\n"); passenger_nodes->text  = $2; }
                | T_TEXT_EMPTY ET { if(is_debug) printf("Parse empty tag\n"); }
                | AIRLINE SPACE COMPANY_CODE EQ text_data ET { if(is_debug) printf("Parse SSR airline\n"); }
                ;

fl_param: fl_attr
        | fl_param SPACE fl_attr
        ;

fl_attr:
        COMPANY_CODE EQ text_data { if(is_debug) printf("Print company code\n"); }
        | GENDER EQ TEXT { if(is_debug) printf("Print gender data\n"); if(strcmp($3, "\"M\"")) { 
            passenger_nodes->gender = "Male"; } else { passenger_nodes->gender = "Famale"; }
            }
        | SURNAME_PARAM EQ text_data { if(is_debug) printf("Print Surname\n"); }
        | FIRSTNAME_PARAM EQ text_data { if(is_debug) printf("Print Name\n"); }
        ;
  
flight_data:
           FLIGHT SPACE flight_param RT flight_details FLIGHT_CLOSE { if(is_debug) printf("Print flight data\n"); }
           ;

flight_param: 
            flight_attr { if(is_debug) printf("Print flight attr (1)\n"); }
            | flight_param SPACE flight_attr { if(is_debug) printf("Print flight attr (2)\n"); }
            ;

flight_details: flight_elem
              | flight_details flight_elem
              ;

flight_elem:
              DEPAIRPORT SPACE LOCATION_CODE EQ TEXT ET { if(is_debug) printf("Print dep air port\n"); flight_data->dep_airport = $5; }
              | ARRAIRPORT SPACE LOCATION_CODE EQ TEXT ET { if(is_debug) printf("Print arr air port\n"); flight_data->arriv_airport = $5; }
              | MARKAIRLINE SPACE COMPANY_CODE EQ TEXT ET { if(is_debug) printf("Print company code\n"); flight_data->company_code = $5; }
              | SSR SPACE ssr_param RT ssr_data SSR_CLOSE { if(is_debug) printf("Print flight SSR\n"); }
              | BOOKING_REF SPACE booking_param RT booking BOOKING_REF_CLOSE { if(is_debug) printf("Print booking flight data\n"); }
              ;

flight_attr:
           XMLNS EQ text_data { if(is_debug) printf("XMLNS flight attr\n"); }
           | DEP_DATETIME EQ TEXT { if(is_debug) printf("Dep datetime flight attr\n"); flight_data->dep_datetime = $3; }
           | ARRIV_DATETIME EQ TEXT { if(is_debug) printf("Arriv datetime flight attr\n"); flight_data->arriv_datetime = $3; }
           | NUM_PARTY EQ text_data { if(is_debug) printf("num party flight attr\n"); }
           | STATUS EQ text_data { if(is_debug) printf("status flight attr\n"); }
           | FLIGHT_NUMBER EQ text_data { if(is_debug) printf("Flight number attr\n");}


pnr_attr: XMLNS_XSD EQ text_data { if(is_debug) printf("Parse xmlns xsd string\n"); }
        | XMLNS_XSI EQ text_data { if(is_debug) printf("Parse xmlns xsi string\n"); }
        | PASSENGERS_NUMBER EQ text_data { if(is_debug) printf("Parse passengers number\n"); }
        | PNR_TRANS_DATE EQ text_data { if(is_debug) printf("Parse PNR trans date\n"); }
        | PNR_CREATION_DATE EQ text_data { if(is_debug) printf("Parse PNR creation date\n"); }
         ;

text_data:
         TEXT { if(is_debug) printf("%s\n", $1); }
         ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char** argv) {
  if("-debug", argv[1]) {
    is_debug = 1;
  }
  flight_data = malloc(sizeof(Flight));
  yyparse(); 
  Passenger *nodes = passenger_nodes;
  printf("----------- FLIGHT DATA SYSTEM ------------------------\n");
  printf("------------      FLIGHT       ------------------------\n");
  printf("Flight from [ %s ], departure date and time: %s\n", flight_data->dep_airport, flight_data->dep_datetime);
  printf("Flight to   [ %s ], arrival date and time:   %s\n", flight_data->arriv_airport, flight_data->arriv_datetime);
  printf("Airlines:   [ %s ]                             \n", flight_data->company_code); 
}

