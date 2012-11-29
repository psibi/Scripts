#!/usr/bin/python3
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
        print(self.nodes)

    def check_num(self,a):
        for node_pair in self.nodes:
            if not set(a) == set(node_pair):
                #print "debug ",a," ",node_pair
                if a[1] == node_pair[0]:
                    return node_pair

    def prettify(self,ls):
        a = reduce(lambda a,b:(a[:-1])+b,ls)
        self.generated_path.append(a)
        #print a
        
    def build_path(self):
        temp_route = []
        flag = True
        count = 0
        for node_pair in self.nodes:
            temp_route.append(node_pair)
            pair = node_pair
            while (flag):
                a = list(map(self.check_num,[pair]))
                #print a
                if not None in a:
                    temp_route.append(a[0])
                    pair = a[0]
                    count = count + 1
                    if count == 10: #This check avoids circular loop by limiting the maximum routes to ten.
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
    r.build_path()
    r.create_routeheader_file()
    r.create_routenodes_file()
