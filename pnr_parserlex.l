%{
#include "pnr_parser.tab.h"
%}

%%

"="                        return EQ;
"<DaneXML>"                return DANEXML;
"</DaneXML>"               return DANEXML_CLOSE;
"<PNR"                     return PNR;
" "                        return SPACE;
">"                        return RT;
"<Text"                    return T_TEXT_EMPTY;
"</PNR>"                   return PNR_CLOSE;
"xmlns:xsd"                return XMLNS_XSD;
"xmlns:xsi"                return XMLNS_XSI;
"NumberOfPassengers"       return PASSENGERS_NUMBER;
"PNR_TransDate"            return PNR_TRANS_DATE;
"PNR_CreationDate"         return PNR_CREATION_DATE;
"<BookingRefID"            return BOOKING_REF;
"</BookingRefID>"          return BOOKING_REF_CLOSE; 
"ID"                       return ID;
"<CompanyName"             return COMPANY_NAME;
"Code"                     return COMPANY_CODE;
"/>"                       return ET;
"<Passenger"               return PASSENGER;
"</Passenger>"             return PASSENGER_CLOSE;
"xmlns"                    return XMLNS;
"RPH"                      return RPH;
"SurnameRefNumber"         return S_NAME_REFNUM;
"AccompaniedByInfantInd"   return ACC_STATUS;
"<GivenName>"              return GIVENNAME; 
"</GivenName>"             return GIVENNAME_CLOSE;
"<Surname>"                return SURNAME;
"</Surname>"               return SURNAME_CLOSE;       
"<DOC_SSR"                 return DOC_SSR;
"</DOC_SSR>"               return DOC_SSR_CLOSE;
"SSRCode"                  return SSR_CODE; 
"ServiceQuantity"          return SERVICE_QT;
"Status"                   return STATUS;
"<FlightInfo"              return FL_INFO;
"<DOCS"                    return DOCS;
"Gender"                   return GENDER;
"Surname"                  return SURNAME_PARAM;
"FirstGivenName"           return FIRSTNAME_PARAM;
"<Flight"                  return FLIGHT;
"</Flight>"                return FLIGHT_CLOSE;
"<DepartureAirport"        return DEPAIRPORT;
"<ArrivalAirport"          return ARRAIRPORT;
"<MarketingAirline"        return MARKAIRLINE;
"<SSR"                     return SSR;
"</SSR>"                   return SSR_CLOSE;
"<Airline"                 return AIRLINE;
"<Text>"                   return T_TEXT;
"</Text>"                  return T_TEXT_CLOSE;
"BoardPoint"               return BOARDPOINT;
"OffPoint"                 return OFFPOINT;
"LocationCode"             return LOCATION_CODE;
"DepartureDateTime"        return DEP_DATETIME;
"ArrivalDateTime"          return ARRIV_DATETIME;
"NumberInParty"            return NUM_PARTY;
"FlightNumber"             return FLIGHT_NUMBER;
[a-zA-Z:/][a-zA-Z0-9:/:_-]* { yylval.str = strdup(yytext); return TEXT; } 
\"[^\"]*\"                 { yylval.str = strdup(yytext); return TEXT; }
[ \t\n]+                   // WS
.                          return yytext[0];
%%

