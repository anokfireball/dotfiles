param(
    [switch]$EmitMarkers
)

function Write-TerminalMarker {
    param(
        [string]$Marker
    )

    if ($EmitMarkers) {
        Write-Output $Marker
    }
}

function Complete-Run {
    param(
        [int]$ExitCode,
        [string]$Marker,
        [string[]]$Lines = @()
    )

    foreach ($line in $Lines) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            Write-Output $line
        }
    }

    Write-TerminalMarker -Marker $Marker
    exit $ExitCode
}

Write-Output ':: Winget : Discovering updates...'

$listOutput = winget list --source winget --upgrade-available --accept-source-agreements --details 2>&1
if ($LASTEXITCODE -ne 0) {
    Complete-Run -ExitCode 1 -Marker '__WINGET_FAILED__' -Lines @('  ! Failed to discover packages')
}

$packages = @()
$currentPackage = $null
$inAvailableUpgrades = $false

function Add-PackageRecord {
    param(
        [object]$Candidate
    )

    if (-not $Candidate) {
        return
    }

    if ([string]::IsNullOrWhiteSpace($Candidate.Id) -or
        [string]::IsNullOrWhiteSpace($Candidate.Version) -or
        [string]::IsNullOrWhiteSpace($Candidate.AvailableVersion)) {
        return
    }

    $Candidate.PresentationName = if ([string]::IsNullOrWhiteSpace($Candidate.DisplayName)) {
        $Candidate.Id
    } else {
        $Candidate.DisplayName
    }

    $script:packages += $Candidate
}

foreach ($line in (($listOutput | Out-String) -split "`r?`n")) {
    if ($line -match '^\(\d+/\d+\)\s+(.+)\s+\[(.+)\]$') {
        Add-PackageRecord -Candidate $currentPackage
        $currentPackage = [pscustomobject]@{
            DisplayName = $Matches[1].Trim()
            Id = $Matches[2].Trim()
            Version = $null
            AvailableVersion = $null
            PresentationName = $null
        }
        $inAvailableUpgrades = $false
        continue
    }

    if (-not $currentPackage) {
        continue
    }

    if ($line -match '^Version:\s*(.+)$') {
        $currentPackage.Version = $Matches[1].Trim()
        continue
    }

    if ($line -match '^Available Upgrades:\s*$') {
        $inAvailableUpgrades = $true
        continue
    }

    if ($inAvailableUpgrades -and $line -match '^\s+winget\s+\[(.+)\]\s*$') {
        $currentPackage.AvailableVersion = $Matches[1].Trim()
        $inAvailableUpgrades = $false
    }
}

Add-PackageRecord -Candidate $currentPackage

$eligiblePackages = @()

foreach ($package in $packages) {
    $showOutput = winget show --id "$($package.Id)" --exact --accept-source-agreements 2>&1
    $showExit = $LASTEXITCODE
    $showText = ($showOutput | Out-String)

    if ($showExit -ne 0) {
        continue
    }

    if ($showText -match '(?m)^License:\s*Proprietary\s*$') {
        continue
    }

    $eligiblePackages += $package
}

if (-not $eligiblePackages) {
    Complete-Run -ExitCode 0 -Marker '__WINGET_ALREADY_UP_TO_DATE__' -Lines @(':: Winget : All packages are up to date')
}

$packageCount = $eligiblePackages.Count
$packageLabel = if ($packageCount -eq 1) { 'package' } else { 'packages' }
Write-Output "`n:: Winget : Found $packageCount upgradable ${packageLabel}"

foreach ($package in $eligiblePackages) {
    Write-Output "  * $($package.PresentationName) [$($package.Version) => $($package.AvailableVersion)]"
}
Write-Output ""

$updatedCount = 0
$failedCount = 0

for ($index = 0; $index -lt $eligiblePackages.Count; $index++) {
    $package = $eligiblePackages[$index]
    $position = $index + 1

    Write-Output ":: Winget : [$position/$packageCount] Upgrading $($package.PresentationName)..."

    $packageOutput = winget upgrade --id "$($package.Id)" --exact --silent --accept-package-agreements --accept-source-agreements 2>&1
    $exitCode = $LASTEXITCODE
    $packageText = ($packageOutput | Out-String)

    if ($exitCode -eq 0) {
        $updatedCount++
        continue
    }

    if ($packageText -match 'No available upgrade found\.' -or $packageText -match 'No newer package versions are available') {
        continue
    }

    Write-Output "  ! Failed to upgrade $($package.PresentationName)"
    $failedCount++
}

$updatedLabel = if ($updatedCount -eq 1) { 'package' } else { 'packages' }
if ($failedCount -gt 0) {
    Complete-Run -ExitCode 1 -Marker '__WINGET_FAILED__' -Lines @("`n:: Winget : Completed with errors ($updatedCount updated, $failedCount failed)")
}

if ($updatedCount -gt 0) {
    Complete-Run -ExitCode 0 -Marker '__WINGET_UPDATED__' -Lines @("`n:: Winget : Successfully updated $updatedCount $updatedLabel")
}

Complete-Run -ExitCode 0 -Marker '__WINGET_ALREADY_UP_TO_DATE__' -Lines @(':: Winget : All packages are up to date')
