#!/usr/bin/python

class routes:
    def __init__(self,filename):
        file_handler = open(filename,"r")
        self.nodes = []
        self.generated_route = []
        self.path = []
        for line in file_handler:
            route_pair = tuple(line.rstrip("\n").split(","))
            self.nodes.append(route_pair)

    def show_nodes(self):
        print self.nodes

    def check_num(self,a):
        for node_pair in self.nodes:
            if not set(a) == set(node_pair):
                #print "debug ",a," ",node_pair
                if a[1] == node_pair[0]:
                    return node_pair

    def prettify(self,ls):
        a = reduce(lambda a,b:(a[:-1])+b,ls)
        print a
        
    def build_path(self):
        temp_route = []
        flag = True
        count = 0
        for node_pair in self.nodes:
            temp_route.append(node_pair)
            pair = node_pair
            while (flag):
                a = map(self.check_num,[pair])
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

if __name__=="__main__":
    r = routes("routes.csv")
    r.build_path()
