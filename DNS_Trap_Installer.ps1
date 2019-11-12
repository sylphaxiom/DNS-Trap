##[Ps1 To Exe]
##
##NcDBCIWOCzWE8pGP3wFk4Fn9fmI7a8mXhZKox5Sx+uT4qBnqSogdWUBkqQrzCk20XuEuUfsGuN4WGw05fpI=
##NcDBCIWOCzWE8pGP3wFk4Fn9fmI7a8mXhZKox5Sx+uT4qBnqSogdWUBkqQrzCk20XuEuUfsGtcMSXRQ8Krwb8eOw
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
##M9jHFoeYB2Hc8u+VslQ=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWI0g==
##OsfOAYaPHGbQvbyVvnQmqxigEzl6PJTC2Q==
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnRTy3iudnoqfoWyt6WzxY2w+viM
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnRe61j6Q2Qna9fbv7m1hKWSzKrYqSTJKQ==
##P8HPFJGEFzWE8pHc9y036k2ubmk8fMCVurPpy5O7nw==
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+VyTV06kmucm0nYqU=
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
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
##  Version: 1.3                          ##
##  Date: 10/28/2019                      ##
############################################

# Function to Install items

function Install {
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
    $Trigger = New-ScheduledTaskTrigger -Once -At $start -RepetitionInterval (New-TimeSpan -Minutes 10)
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
}

# Check for new install if n back pedal all files and re-new
$title = "New Install of DNS Trap?"
$message = "Is this a new install of the DNS Trap?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Installs normally, will throw errors if the necessary files already exist."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Will retain copies of the log files and re-installs all of the folders and scripts fresh."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

# Parse results

Switch ($result)
{
    0 {
        Write-Host "Installing Trap..."
        
        # Install Normally
        Install
        break
    }
    1 {
        Write-Host "Backing up remaining logs..."

        # Backup logs
        IF (Test-Path "$env:SystemRoot\Logs\DNS") {Copy-Item -Path "$env:SystemRoot\Logs\DNS" -Destination "$env:temp\tempDNS" -Recurse}
        IF (Test-Path "$env:SystemRoot\Logs\DNSArchive") {Copy-Item -Path "$env:SystemRoot\Logs\DNSArchive" -Destination "$env:temp\tempArchive" -Recurse}
        
        Write-Host "Removing Folders..."
        
        # Remove All folders
        IF (Test-Path "$env:SystemRoot\System32\WindowsPowerShell\Scripts") {Remove-Item -Path "$env:SystemRoot\System32\WindowsPowerShell\Scripts" -Force -Recurse}
        IF (Test-Path "$env:SystemRoot\Logs\DNS") {Remove-Item -Path "$env:SystemRoot\Logs\DNS" -Force -Recurse}
        IF (Test-Path "$env:SystemRoot\Logs\DNSArchive") {Remove-Item -Path "$env:SystemRoot\Logs\DNSArchive" -Force -Recurse}
        
        Write-Host "Removing Tasks..."
        
        # Remove Scheduled Tasks
        $tasks = Get-ScheduledTask
        $tasks | % -Process {if ($_.TaskName -like "DNS*") {Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$FALSE}}
        
        Write-Host "Installing Trap..."
        
        # Install as normal
        Install

        Write-Host "Restoring old Logs..."
        
        # Restore old log files
        IF (Test-Path "$env:temp\tempDNS") {Get-ChildItem -Path "$env:temp\tempDNS" | % {Move-Item -Path $_.FullName -Destination "$env:SystemRoot\Logs\DNS"}}
        IF (Test-Path "$env:temp\tempArchive") {Get-ChildItem -Path "$env:temp\tempArchive" | % {Move-Item -Path $_.FullName -Destination "$env:SystemRoot\Logs\DNSArchive"}}
        break
    }
}

function Install {
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
    $Trigger = New-ScheduledTaskTrigger -Once -At $start -RepetitionInterval (New-TimeSpan -Minutes 10)
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
}