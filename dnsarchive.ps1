############################################
##  Archive DNS Trap. Script designed to  ##
##  archive the logs so we have multiple  ##
##  dated log files rather than one large ##
##  log file that will take a long time   ##
##  to go through if it is needed         ##
##                                        ##
##  Author: Jacob Pell                    ##
##  Version: 1.0                          ##
##  Date: 10/28/2019                      ##
############################################

# get date and format file name
$date = Get-Date -UFormat "_%m_%d_%Y"
$name = "DNSArchive"
$filename = $name + $date + ".txt"

# Move the file from DNS to Archive
Move-Item -Path "$env:SystemRoot\Logs\DNS\dnscache.txt" -Destination "$env:SystemRoot\Logs\DNSArchive\$filename"