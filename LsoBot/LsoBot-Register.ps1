## BEGIN USER VARIABLES

$lsoBotfilePath = ".\LsoBot.ps1"
$LsoScriptRoot = $PWD.Path
$LsoScriptRoot.Trim()
$LsoScriptRoot.Split([Environment]::NewLine)[0]
$logX = "\Logs\lsobot-debug.txt"
$logPath =  $LsoScriptRoot + $logX

## END USER VARIABLES

$lsoJobStart = Get-Date

function Get-Timestamp {
    return Get-Date -Format "yyyy-MM-dd HH:mm:ss:fff"
}

# Queue jobs if current instance is running late
$O = New-ScheduledJobOption -MultipleInstancePolicy Queue

# Start the job immediately, repeate every minute, for 10 years.This wil persist past reboot.
$T = New-JobTrigger -Once -At $lsoJobStart -RepetitionInterval (New-TimeSpan -Seconds 60) -RepetitionDuration (New-Timespan -Days 3650)

# Create scheduled job
try {
    Register-ScheduledJob -Name "LSO Check" -FilePath $lsoBotfilePath -ScheduledJobOption $O -Trigger $T -ArgumentList @($LsoScriptRoot)

}
catch {
    Write-Output "$(Get-Timestamp) | ERROR | The Powershell Scheduled Job failed to be created." | Out-file $PSScriptRoot\Logs\lsobot-debug.txt -append
}

Write-Output "$(Get-Timestamp) | INFO | The Powershell Scheduled Job has been started successfully." | Out-file $PSScriptRoot\Logs\lsobot-debug.txt -append
Write-Host "LSO Bot Powershell Scheduled Job Created" -ForegroundColor Green