#Helper Script for converting TAB-delimited file to comma delimited file.
import csv
# read tab-delimited file
cr = csv.reader(open('routes.csv','rb'), 
                delimiter='\t')
# prepare to write comma-delimited file
cw = csv.writer(open('comma.csv','wb'),
                delimiter=',', 
                quoting=csv.QUOTE_MINIMAL)
# write comma-delimited file
for line in cr: cw.writerow(line)
