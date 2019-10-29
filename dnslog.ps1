############################################
##  DNS Trap. Script is designed to dump  ##
##  the DNS cache into a log so we can    ##
##  track the internet history of users   ##
##  even if using incognito tabs or if    ##
##  user deletes the history              ##
##                                        ##
##  Author: Jacob Pell                    ##
##  Version: 1.0                          ##
##  Date: 10/28/2019                      ##
############################################

# File name and path for log file
$logName = "$env:SystemRoot\Logs\DNS\dnscache.txt"

# Get the current date and append with section divider
Get-Date | Out-File -FilePath $logName -Append
Add-Content $logName "------------------------------------------------------------------------------------------------------------"

# Pull DNS Cache and output to the log file followed by a section divider
Get-DnsClientCache | Format-Table -Auto | Out-File -FilePath $logName -Append
Add-Content $logName "------------------------------------------------------------------------------------------------------------"

# Clear the cache to prevent excessive repitition 
Clear-DnsClientCache