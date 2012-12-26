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
    def __init__(self,filename,time_period):
        file_handler = open(filename,"r")
        self.time_period = time_period
        self.nodes = []
        self.generated_path = []
        self.generated_route = []
        self.path = []
        self.lane_data = []
        self.lane_connectivity_data = []
        for line in file_handler:
            route_pair = tuple(line.rstrip("\n").split(","))
            self.nodes.append(route_pair)
        file_handler.close()
        self.rnodes_file = open("Route_Nodes.txt","a")
        self.rheader_file = open("Route_Header.txt","a")

    def validate_lane_connectivity(self,fname="lc.csv"):
        fhandler = open(fname,"r")
        for line in fhandler:
            line_data = tuple(line.rstrip("\n").split(","))
            self.lane_connectivity_data.append(line_data)
        fhandler.close()
               
    def get_inlinks(self,node):
        node_data = tuple(filter(lambda x:int(x[0])==node,self.lane_connectivity_data))
        int_node_data = tuple(map(lambda t:tuple(map(int,t)),node_data))
        in_link_data = tuple(reduce(lambda accumulator,y: accumulator + (y[1],) if y[1] not in accumulator else accumulator,node_data,()))
        return in_link_data

    def get_outlink_of_inlink(self,node,inlink):
        node_data = tuple(filter(lambda x:int(x[0])==node,self.lane_connectivity_data))
        int_node_data = tuple(map(lambda t:tuple(map(int,t)),node_data))
        outlinks = tuple(reduce(lambda x,y:x+(y[2],) if inlink == y[1] and y[2] not in x else x,int_node_data,())) 
        return outlinks

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
        
    def build_path(self,max_path_length=30):
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
        node = str(node_no)
        headway = reduce(lambda x,y:x+"\t10",list(range(self.time_period*2)),"")
        print(node+"\tRoute "+node+" \tBUS"+headway,file=self.rheader_file)

    def create_routenodes_file(self,length_of_route=4):
        nodes_gt4 = list(filter(lambda x:len(x)>=length_of_route,self.correct_path))
        count = -1
        for node in nodes_gt4:
            count = count + 1
            for n in node:
                pstr = str(count)+"\t"+str(n)+"\t10"
                print(pstr,file = self.rnodes_file)
        self.rnodes_file.close()

    def create_routeheader_file(self,length_of_route=4):
        nodes_gt4 = list(filter(lambda x:len(x)>=length_of_route,self.correct_path))
        total_routes = len(nodes_gt4)
        print("total routes:",total_routes)
        list(map(self.write_routeheader_file,list(range(total_routes))))
        self.rheader_file.close()

    def _route_verification(self,path):
        first_node = path[0]
        second_node = path[1]
        fnode_inlinks = self.get_inlinks(first_node)
        snode_inlinks = self.get_inlinks(second_node)
        #We have first and second node inlinks.
        intersection_node = tuple(set(fnode_inlinks) & set(snode_inlinks))
        if not intersection_node:
            return False
        #print(intersection_node[0])
        flag = False
        for i in range(len(path)-2):
            try:
                ith_node = path[i+2]
                #print("ith node",ith_node)
                outlink = self.get_outlink_of_inlink(int(path[i+1]),int(intersection_node[0]))
                #print("outlinks",outlink)
                inlinks = tuple(map(int,self.get_inlinks(ith_node)))
                #print("inlinks",inlinks)
                #print(outlink,inlinks)
                intersection_node = tuple(set(outlink) & set(inlinks))
                #print("Ints. data.",intersection_node)
                if not intersection_node:
                    flag = True
                    break
            except IndexError:
                break
        if (flag):
            return False
        else:
            return True
          
    def validate_lc_data(self):
        min_four_paths = list(filter(lambda x:len(x)>=4,self.generated_path))
        self.correct_path = []
        counter = 0
        ccounter = 0
        for path in min_four_paths:
            int_path = tuple(map(int,path))
            status = self._route_verification(int_path)
        #status = self._route_verification((80,81,2247,1905,114,115,95,96,1908,193,1115,97,91,100,1907))
            if status:
                self.correct_path.append(int_path)
                ccounter = ccounter + 1
            else:
                counter = counter + 1
        print("Correct:",ccounter)
        print("Incorrect:",counter)
        print("Length of self.correct_path",len(self.correct_path))
    
    def single_validate_lc_data(self):
        #status = self._route_verification((118,115,95,96,1908,193,1115,97,91,100,1907,140,151,152,107,134,220,460,459,42,115))
        status = self._route_verification((459,42,115))
        if status:
            print("Correct path")
        else:
            print("Incorrect path")
    
if __name__=="__main__":
    r = routes("routes.csv",4)
    r.build_path() #Max path length can be increased from 10 by passing a parameter here.
    #r.show_nodes()
    r.validate_lane_connectivity();
    #r.single_validate_lc_data()
    r.validate_lc_data()
    r.create_routeheader_file()
    r.create_routenodes_file()
