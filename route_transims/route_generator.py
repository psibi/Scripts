#!/usr/bin/python3
#
# Copyright (C) 2012 Sibi <sibi@psibi.in>
#
# This is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Identity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this.  If not, see <http://www.gnu.org/licenses/>.
#
#
# Author:   Sibi <sibi@psibi.in>
from functools import reduce

class routes:
    def __init__(self,filename):
        file_handler = open(filename,"r")
        self.nodes = []
        self.generated_path = []
        self.generated_route = []
        self.path = []
        for line in file_handler:
            route_pair = tuple(line.rstrip("\n").split(","))
            self.nodes.append(route_pair)
        file_handler.close()
        self.rnodes_file = open("Route_Nodes.txt","a")

    def show_nodes(self):
        print(self.generated_path)

    def check_num(self,a):
        for node_pair in self.nodes:
            if not set(a) == set(node_pair):
                #print "debug ",a," ",node_pair
                if a[1] == node_pair[0]:
                    return node_pair

    def prettify(self,ls):
        a = reduce(lambda a,b:(a[:-1])+b,ls)
        path = []
        #For Unique path. No duplicate nodes present. Ciruclar dependency problem removed.
        for element in a:
            if element not in path:
                path.append(element)
            else:
                break
        self.generated_path.append(path)
        #print a
        
    def build_path(self,max_path_length=10):
        temp_route = []
        flag = True
        count = 0
        for node_pair in self.nodes:
            temp_route.append(node_pair)
            pair = node_pair
            while (flag):
                a = list(map(self.check_num,[pair]))
                #print("A:",a)
                if not None in a:
                    temp_route.append(a[0])
                    pair = a[0]
                    count = count + 1
                    if count == max_path_length:
                        count = 0
                        if temp_route:
                            self.prettify(temp_route)
                        temp_route = []
                        break
                else:
                    if temp_route:
                        self.prettify(temp_route)
                    temp_route = []
                    break
                
    def write_routeheader_file(self,node_no):
        rheader_file = open("Route_Header.txt","a")
        node = str(node_no)
        print(node+"\tRoute "+node+" \tBUS",file=rheader_file)
        rheader_file.close()

    def create_routenodes_file(self,length_of_route=4):
        nodes_gt4 = list(filter(lambda x:len(x)>=length_of_route,self.generated_path))
        count = -1
        for node in nodes_gt4:
            count = count + 1
            for n in node:
                pstr = str(count)+"\t"+str(n)+"\t10"
                print(pstr,file = self.rnodes_file)
        self.rnodes_file.close()

    def create_routeheader_file(self,length_of_route=4):
        nodes_gt4 = list(filter(lambda x:len(x)>=length_of_route,self.generated_path))
        total_routes = len(nodes_gt4)
        print("total routes:",total_routes)
        list(map(self.write_routeheader_file,list(range(total_routes))))
        
if __name__=="__main__":
    r = routes("routes.csv")
    r.build_path() #Max path length can be increased from 10 by passing a parameter here.
    #r.show_nodes()
    r.create_routeheader_file()
    r.create_routenodes_file()
