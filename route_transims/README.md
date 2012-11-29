Transims Route File Generator for TransitNet
---------------------------------------------

This script helps in basic Route Header and Route Nodes file generation. It needs a csv file as input which should be composed of anodes and bnodes in the following format:

4,5
5,6
7,8

A sample routes.csv file is in the repository for reference.


To Do:
-------
1. Remove Circular dependancy problem in a sane way. As of now, maximum route path length is limited to ten and that may contain duplicates. 
 
License:
--------
GNU General Public License v3 (GPLv3)

