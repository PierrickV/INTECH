   import nmap                         # import nmap.py module

    nm = nmap.PortScanner()
    host = '127.0.0.1'
    nm.scan(host, '1-1024')
    nm.command_line()
    nm.scaninfo()

    for host in nm.all_hosts():
        print('----------------------------------------------------')
        print('Host : %s (%s)' % (host, nm[host].hostname()))
        print('State : %s' % nm[host].state())
        print('----------------------------------------------------')

    for proto in nm[host].all_protocols():
            print('----------')
            print('Protocol : %s' % proto)

    lport = nm[host]['tcp'].keys()   #<------ This 'proto' was changed from the [proto] to the ['tcp'].
    lport.sort()
    for port in lport:
                    print('----------------------------------------------------')
                    print('port : %s\tstate : %s' % (port, nm[host][proto][port]['state']))
                    print('----------------------------------------------------')
