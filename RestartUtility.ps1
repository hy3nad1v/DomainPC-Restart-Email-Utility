# Set the list of computer names and domain
$computerNames = @("Computer1", "Computer2")
$domain = "example.local"

# Function to restart a remote computer
function Restart-RemoteComputer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$ComputerName
    )
    
    try {
        # Validate computer name format
        if ($ComputerName -notmatch '^[a-zA-Z0-9-]+$') {
            throw "Invalid computer name format: $ComputerName"
        }

        # Restart the remote computer
        Restart-Computer -ComputerName $ComputerName -Force -ErrorAction Stop
        return $true
    } 
    catch {
        Write-Error "Failed to restart computer $ComputerName: $_"
        return $false
    }
}

# Function to send email
function Send-EmailWithAttachment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Recipient,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Subject,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Body,
        
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]$AttachmentPath
    )
    
    $EmailFrom = $env:USEREMAIL
    $SMTPServer = $env:SMTPSERVER
    
    # Send email
    Send-MailMessage -From $EmailFrom -To $Recipient -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Attachments $AttachmentPath
}

# Function to log events
function Log-Event {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )
    
    $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Computer: $ComputerName - $Message"
    $logFilePath = "C:\TEMP\PC_Restart_Logs\restart_log_$ComputerName.txt"
    
    # Append log entry to log file
    Add-Content -Path $logFilePath -Value $logEntry
    
    return $logEntry
}

# Restart each computer in the list
foreach ($computerName in $computerNames) {
    # Get the target computer's fully qualified domain name
    $computerFQDN = "$computerName.$domain"
    
    # Restart the computer
    $restartResult = Restart-RemoteComputer -ComputerName $computerFQDN
    
    # Log the restart attempt
    $logMessage = "Restart attempt: "
    if ($restartResult) {
        $logMessage += "successful"
    } else {
        $logMessage += "failed"
    }
    Log-Event -ComputerName $computerFQDN -Message $logMessage
    
    # Send email based on the restart result
    $emailSubject = if ($restartResult) {
        "Computer Restarted Successfully"
    } else {
        "Computer Restart Failed"
    }
    $emailBody = if ($restartResult) {
        "The computer $computerFQDN was restarted successfully."
    } else {
        "The attempt to restart the computer $computerFQDN failed. Please check the system."
    }
    Send-EmailWithAttachment -Recipient $env:ADMINEMAIL -Subject $emailSubject -Body $emailBody -AttachmentPath $logFilePath
    
    # Clean up log file
    if (Test-Path $logFilePath -PathType Leaf) {
        Remove-Item -Path $logFilePath -Force
    }
}
