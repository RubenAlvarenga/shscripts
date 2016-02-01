
import nmap
nm = nmap.PortScanner()
#nm.scan('192.168.1.56', '22-80')
print nm.scan('192.168.1.0/24', arguments='-n -A -sSV -p22,25,80,443')

print "dsdas"