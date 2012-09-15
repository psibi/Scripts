 %module Rec
%include "various.i"

 %apply char **STRING_ARRAY { char **db }

%{
#include "sab1.hpp"
   %}
class CRectangle {
int x, y;
public:
void set_values (int,int);
void print(char **db);
int area ();
};
