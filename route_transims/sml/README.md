Experimental Path Generator for TRANSIMS
-----------------------------------------

Generates Route Node files for TRANSIMS.
I started writing this code after the Python Version became spaghetti and unmaintainable.

Execution
----------
1) Currently in REPL Mode
  
      use "route_generator.sml"
      tasks "./routes.csv" "./dum"

That will produce an ouput file of "dum" which will be your Route Node file for TRANSIMS. The roues.csv file is the 
ANODE & BNODE column of Input Links file of TRANSIMS in csv format.
