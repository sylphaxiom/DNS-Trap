############################################
##  DNS Trap. Script is designed to dump  ##
##  the DNS cache into a log so we can    ##
##  track the internet history of users   ##
##  even if using incognito tabs or if    ##
##  user deletes the history              ##
##                                        ##
##  Author: Jacob Pell                    ##
##  Version: 1.1                          ##
##  Date: 10/28/2019                      ##
############################################
##  Changelog V1.1:                       ##
##  Major windows updates re-create the   ##
##  Windows folder and the Logs are not   ##
##  included in this change. File looks   ##
##  for missing files and re-creates or   ##
##  copies files/folders from WINDOWS.old ##
############################################


# File name and path for log file
$logName = "$env:SystemRoot\Logs\DNS\dnscache.txt"
$errLog = "$env:SystemRoot\Logs\DnsTrapError.txt"

# Make sure folders and everything is still present
try {
    IF ([System.IO.File]::Exists($logName)) {
        Continue
    } ELSE {
        Copy-Item -Path "$env:SystemDrive\Windows.old\WINDOWS\Logs\DNS" -Destination "$env:SystemRoot\Logs\DNS" -Recurse -ErrorAction Stop
    }
} catch {
    # Get the current date and append with section divider
    Get-Date | Out-File -FilePath $errLog -Append
    Add-Content $errLog "------------------------------------------------------------------------------------------------------------"

    # Write error to a log file
    Add-Content $errLog "There is an issue with copying the log file: $logName"
    Add-Content $errLog "Error is: $_"
    Add-Content $errLog "------------------------------------------------------------------------------------------------------------"
}

# Get the current date and append with section divider
Get-Date | Out-File -FilePath $logName -Append
Add-Content $logName "------------------------------------------------------------------------------------------------------------"

# Pull DNS Cache and output to the log file followed by a section divider
Get-DnsClientCache | Format-Table -Auto | Out-File -FilePath $logName -Append
Add-Content $logName "------------------------------------------------------------------------------------------------------------"

# Clear the cache to prevent excessive repitition 
Clear-DnsClientCache