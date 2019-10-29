# DNS-Trap
Small script and installer that will move the DNS Cache into a log file to track a computer's network activity.

The script will still track all network activity, even if the user is using an "incognito" tab or browser of some sort.
In order to install the script, download the files and run the EXE or DNS_Trap_Installer.ps1.

The scripts included are simple:

### dnslog.ps1:
- This script simply creates a time stamp, pulls the DNS Cache using `Get-DnsClientCache`, and then clears the cache.

### dnsarchive.ps1:
- This script moves the dns log file into a different folder named 'DNS Archive' and re-names it with DNSArchive_current_date.txt.
                 
### DNS_Trap_Installer.ps1:
- This script is what installs all of the components. The script creates 3 folders, one for the logs, one for the archives, and one for the scripts.
- The scripts are stored in the '%systemroot%\System32\WindowsPowershell' directory in a folder called 'Scripts'. The logs and archive are stored in the '%systemroot%\Logs' folder in folders called 'DNS' and 'DNS Archive' respectively.
- The script will then put the scripts into their folders and create 2 scheduled tasks. These tasks are called 'DNS Log' and 'DNS Archive'. This is what controls the frequency the scripts run.
- The default is set to log the DNS cache every 15 minutes indefinitately and to archive the file every Monday at 12am
- These can be changed either in the script before install, or after installation. You have 5 minutes after installation before the first DNS log is created.
                          
### DNSTrap.exe:
- This is an EXE compiled using Ps1 to Exe (https://github.com/99fk/Ps1-To-Exe-Downloader). It will request administrator rights so you need to be ready for that. Then it will do exactly what the ps1 script above does (since it is compiled from that script).
                          
These scripts are a great way to keep track of users in your organization who you think might be going places they shouldn't. If you
don't want to restrict where they go, but want to keep an eye on them. This is a great script to use. It will runn completely
silent and the user will never be aware that they are being monitored.
