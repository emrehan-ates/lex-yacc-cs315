%{
#include <stdlib.h>
%}

%option yylineno
digit                [0-9] 
sign                 [+-] 
op                   [*/%]
alphabetic           [A-Za-z_]
alphanumeric         ({alphabetic}|{digit})+
number               ({digit}+) 
float                {number}\.{number}?
degree               ({float}|{number})d
identifier           ({alphabetic}{alphanumeric}*)
space                [ ]
var                  ({number}|{identifier}|{array_access})
array_access         {identifier}\[({number}|{identifier})\]
unsecuredUrl		("http://")+({alphanumeric}\.?\=?\_?\??\/?\-?\+?)*
securedUrl		    ("https://")+({alphanumeric}\.?\=?\_?\??\/?\-?\+?)*

%%

{number}             return INTCONST;
{float}              return FLOAT;
{degree}             return DEGREE;
start                return START;
finish               return FINISH;
function             return FUNCTION;
if                   return IF;
else                 return ELSE;
for                  return FOR;
while                return WHILE;
return               return RETURN;
{securedUrl}|{unsecuredUrl}    return URL;
input                return INPUT;
output               return OUTPUT;
climb                return CLIMB;
drop                 return DROP;
moveForward          return MOVEFORWARD;
moveBackward         return MOVEBACKWARD;
stopVertical         return STOPVERTICAL;
stopHorizontal       return STOPHORIZONTAL;
turnLeft             return TURNLEFT;
turnRight            return TURNRIGHT;
sprayOn              return SPRAYON;
sprayOff             return SPRAYOFF;
getTime              return GETTIME;
getCurrentHeading    return GETCURRENTHEADING;
getCurrentHeight     return GETCURRENTHEIGHT;
getCurrentAltitude   return GETCURRENTALTITUDE;
connectToUrl         return CONNECTTOURL;
"/*"([^*]|(\*+[^*/]))*"*/"  return COMMENT;
\"([^\"\\]|\\.)*\"   return STRCONST;
{identifier}         return IDENTIFIER;
=                    return ASSIGNOP;
\<=                  return SMALLEQ; 
\==                  return EQUALITY; 
\>=                  return BIGEQ;
\!=                  return NOTEQ;
\<                   return LESS; 
\>                   return GREATER;
\(                   return LP;
\)                   return RP;
\{                   return LCB;
\}                   return RCB;
\[                   return LB;
\]                   return RB;
\+                   return ADDOP;
\-                   return SUBOP;
\*                   return MULTOP;
\/                   return DIVOP;
\%                   return MODOP;
\&\&                 return AND;
\|\|                 return OR;
\,                   return COMMA;
\;                   return SC;
\!                   return NOT;
[ \t\n]+               ;

%% 

int yywrap() {return 1;}
