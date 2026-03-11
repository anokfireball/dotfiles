$listOutput = winget list --source winget --upgrade-available --accept-source-agreements --details 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Output "__WINGET_FAILED__"
    exit 1
}

$ids = @()

foreach ($line in ($listOutput | ForEach-Object { $_.ToString() })) {
    if ($line -match '^\(\d+/\d+\) .+ \[(.+)\]$') {
        $ids += $Matches[1]
    }
}

$ids = $ids | Select-Object -Unique

if (-not $ids) {
    Write-Output "__WINGET_ALREADY_UP_TO_DATE__"
    exit 0
}

$updated = $false

foreach ($id in $ids) {
    $showOutput = winget show --id "$id" --exact --accept-source-agreements 2>&1
    $showExit = $LASTEXITCODE
    $showText = ($showOutput | Out-String)

    if ($showExit -ne 0) {
        continue
    }

    if ($showText -match "(?m)^License:\s*Proprietary\s*$") {
        continue
    }

    $packageOutput = winget upgrade --id "$id" --exact --silent --accept-package-agreements --accept-source-agreements 2>&1
    $exitCode = $LASTEXITCODE
    $packageText = ($packageOutput | Out-String)

    if ($exitCode -eq 0) {
        $updated = $true
        continue
    }

    if ($packageText -match "No available upgrade found\." -or $packageText -match "No newer package versions are available") {
        continue
    }

    Write-Output "__WINGET_FAILED__"
    exit 1
}

if ($updated) {
    Write-Output "__WINGET_UPDATED__"
} else {
    Write-Output "__WINGET_ALREADY_UP_TO_DATE__"
}

exit 0
