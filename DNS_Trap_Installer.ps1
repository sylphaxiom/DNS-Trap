##[Ps1 To Exe]
##
##NcDBCIWOCzWE8pGP3wFk4Fn9fmI7a8mXhZKox5Sx+uT4qBnqSogdWUBkqQrzCk20XuEuUfsGtcMSXRQ8Krwb8eOw
##NcDBCIWOCzWE8pGP3wFk4Fn9fmI7a8mXhZKox5Sx+uT4qBnqSogdWUBkqQrzCk20XuEuUfsGuN4WGw05fpI=
##Kd3HDZOFADWE8uO1
##Nc3NCtDXTkyDjpH6z3Re6ErpR3sXZ8aUt7CuyoW57dXLtSrUTNcnUEdjkySxN0S7TeUTR/BYnd8CQRwmI/cZr+aIJLL8EfdZ3Op8ZIU=
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4NI=
##OcrLFtDXTiS5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+VslQ=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWI0g==
##OsfOAYaPHGbQvbyVvnQmqxuO
##LNzNAIWJGmPcoKHc7Do3uAu/DDl7IJfD9+T3ldjc
##LNzNAIWJGnvYv7eVvnRTy3iudnoqfoX7
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnRTy3iudnoqfoWPtvakxZGo6vjp+yTVRdoBWlFl0Tq8DUWpXOAcUOFVvNgCQRI4NrIZ57XRCeOlQLEZ0ux5K8yApb0uG1PM7NP7wVmcwImOfg==
##P8HPFJGEFzWE8pHc9y036k2ubmk8fMCVurPH
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+VyTV06kmucm0nYqU=
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/L09iB/6lmuaGkoYcfbibOryMG68PismCzNUNobTxRblz7uAUW+XLxy
##L8/UAdDXTlaDjofG5iZk2UH+R2QnUuGUuqOqwY+o7NbfuDfQWY4Hdnd4mC/1A1iBfdwhYecUpJ8UTRhK
##Kc/BRM3KXxU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
############################################
##  Installation script for DNS trap and  ##
##  archive. Script places needed files   ##
##  on the system, where they need to be  ##
##  and will set up scheduled tasks       ##
##                                        ##
##  Author: Jacob Pell                    ##
##  Version: 1.0                          ##
##  Date: 10/28/2019                      ##
############################################

# Create Necessary Folders for logs and archive
New-Item -Path "$env:SystemRoot\System32\WindowsPowerShell" -Name "Scripts" -ItemType "directory"
New-Item -Path "$env:SystemRoot\Logs\" -Name "DNS" -ItemType "directory"
New-Item -Path "$env:SystemRoot\Logs\" -Name "DNSArchive" -ItemType "directory"

# Put Powershell scripts where they need to go
Move-Item -Path "$env:p2eincfilepath\dnslog.ps1" -Destination $env:SystemRoot\System32\WindowsPowershell\Scripts\dnslog.ps1
Move-Item -Path "$env:p2eincfilepath\dnsarchive.ps1" -Destination $env:SystemRoot\System32\WindowsPowershell\Scripts\dnsarchive.ps1

# Get the current date
$start = (Get-Date).AddMinutes(5)

# Set up the first task for the Log
$Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass C:\Windows\System32\WindowsPowershell\Scripts\dnslog.ps1"
$Description = "Logs DNS cache entries every 15 minutes and saves in a log location"
$Trigger = New-ScheduledTaskTrigger -Once -At $start -RepetitionInterval (New-TimeSpan -Minutes 15)
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable -DontStopIfGoingOnBatteries -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM"
$Name = "DNS Log"

# Create and Register Task
$Task = New-ScheduledTask -Action $Action -Description $Description -Principal $Principal -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName $Name -InputObject $Task

# Set up the second task for the archive
$Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass C:\Windows\System32\WindowsPowershell\Scripts\dnsarchive.ps1"
$Description = "Archives the DNS log so the file doesn't get too long"
$Trigger = New-ScheduledTaskTrigger -Weekly -At 12am -DaysOfWeek Monday
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable -DontStopIfGoingOnBatteries
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest
$Name = "DNS Archive"

# Create and Register Task
$Task = New-ScheduledTask -Action $Action -Description $Description -Principal $Principal -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName $Name -InputObject $Task