// classes example
#include <iostream>
#include "sab1.hpp"
using namespace std;


int CRectangle::area () {
  return (x*y);
}

void CRectangle::set_values (int a, int b) {
  x = a;
  y = b;
}

void CRectangle::print(char **db) 
{
  cout<<db[0];
}


int main () {
  CRectangle rect;
  char *a[] = 
    {
      "Hi", "bye" 
    }
  ;
  
  rect.set_values (3,4);
  cout << "area: " << rect.area();
  rect.print(&a[0]);
  return 0;
}
