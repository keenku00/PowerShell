# Welcome to tracetcp.

Full documentation available here: http://simulatedsimian.github.io/tracetcp.html 

TraceTCP is a such a function to use TCP SYN Patckets which's based on an Win32. Rather than using tracerout or ping function, the TraceTCP would be better because the ICMP/UDP packets are highly likely to be filtered/blocked while they're heading to destnation.

Indeed, the TraceTCP allows a trace to be performed over any TCP port. This allows the discovery of what ports a filewall blocks and also the presence of any transparent proxies that have been put in place.

# System Requirements

Since WinPcap is completely unsupported, there might have compatibility issues with current versions of Windows.
But, as the TraceTCP function works with Winpcap, the Winpcap library (http://www.winpcap.org) must be installed in advance.

# Installation

1. The winpcap library (http://www.winpcap.org) at first.
2. Then, the execution program should be downloaded from (https://github.com/keenku00/PowerShell/blob/23ed847ff19233f07b221d97c49f58772c4cc2e6/TraceTCP/Tracetcp.zip).

# Usage

1. In Powershell environment, go to the path having the "tracetcp.exe" execution file. Then, execute the program with the conditions below.

From the command prompt:
```
tracetcp host [options]
    where host = hostName|ipAddress[:portNumber|serviceName]
    if portNumber or serviceName is not present then port 80 (http) 
    is assumed.

Options:
    -?            Displays help information.

    -c            Select condensed output mode

    -h start_hop  Starts trace at hop specified.

    -m max_hops   Maximum number of hops to reach target.

    -n            No reverse DNS lookups for each node.

    -p num_pings  # of pings per hop (default 3).

    -r p1 p2      Multiple traces from port p1 to p2.

    -t timeout    Wait timeout milliseconds for each reply.

    -v            Displays version information.

    -s p1 p2      Easy port scan mode. gives the same result as
                  setting the following options:
                  -cnr p1 p2 -h 128 -m 1 -p 1

    -F            Disables the Anti-flood timer. Normally tracetcp
                  waits *at least* 0.5 seconds between sending out 
                  each packet, because if the packets are sent too 
                  fast some host seem to detect this as some form of 
                  flood and stop responding for a time. This option 
                  disables the 0.5 second timer, so the traces occur
                  faster.

    -R            Use raw socket interface to send/receive packets
                  this will not work on XP sp2. 
                  (you still need winpcap installed)

    -g address    use the specified host as a a gateway to remote
                  systems rather than the default gateway.


Examples:
    tracetcp www.microsoft.com:80 -m 60
    tracetcp post.sponge.com:smtp
    tracetcp 192.168.0.1 -n -t 500
```


# Revision History

### version 1.0.0 2023.01.29
* Create the read.me file.
