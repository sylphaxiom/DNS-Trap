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

# Make sure folders and everything is still present
try {
    IF (Test-Path "$env:SystemRoot\Logs\DNSArchive\*.txt") {
        Continue
    } ELSE {
        Copy-Item -Path "$env:SystemDrive\Windows.old\WINDOWS\Logs\DNSArchive" -Destination "$env:SystemRoot\Logs\DNSArchive" -Recurse -ErrorAction Stop
    }
} catch {
    # Error log file name
    $errLog = "$env:SystemRoot\Logs\DnsTrapError.txt"

    # Get the current date and append with section divider
    Get-Date | Out-File -FilePath $errLog -Append
    Add-Content $errLog "------------------------------------------------------------------------------------------------------------"

    # Write error to a log file
    Add-Content $errLog "There is an issue with copying the log file: $logName"
    Add-Content $errLog "Error is: $_"
    Add-Content $errLog "------------------------------------------------------------------------------------------------------------"
}
    

# get date and format file name
$date = Get-Date -UFormat "_%m_%d_%Y"
$name = "DNSArchive"
$filename = $name + $date + ".txt"

# Move the file from DNS to Archive
Move-Item -Path "$env:SystemRoot\Logs\DNS\dnscache.txt" -Destination "$env:SystemRoot\Logs\DNSArchive\$filename"