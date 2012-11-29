Transims Route File Generator for TransitNet
---------------------------------------------

This script helps in basic Route Header and Route Nodes file generation. It needs a csv file as input which should be composed of ANODES and BNODES in the following format:

    4,5
    5,6
    7,8

The list of ANODES and BNODES can be obtained form the Input Links file. A sample routes.csv file is in the repository for reference.

How to Use
----------
1. Create a router.csv file containing ANODES and BNODES which in turn can be obtained from the Input Link file.
2. Place the router.csv file under the same directory in which the Python script resides.
3. Run the script in Python 3. (Yes it's Python 3)
4. File named Route_Nodes.txt and Route_Header.txt will be created on the same directory.

License:
--------
GNU General Public License v3 (GPLv3)

