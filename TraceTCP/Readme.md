# ![logo][] PowerShell
All PowerShell scripts mentioned in this repository are created for IT security tasks.

[logo]: https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_64.svg?sanitize=true

* 01.Command_Prompt_(Microsoft_Windows)
* 02.Powershell_Learning
* 03.Powershell_Script
* 04.WMI
* 05.Powershell_Network
* 06.Powershell_Popup
* 07.Powershell_Program
* 08.Powershell_ActiveDirectory
* 09.Powershell_Web
* 10.Powershell_Remote

# Code of Conduct

For more information see the [Code of Conduct FAQ][conduct-FAQ] or contact [keenku00@naver.com][conduct-email] with any additional questions or comments.

[conduct-FAQ]: https://blog.naver.com/jimmy_jib
[conduct-email]: mailto:keenku00@naver.com

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
