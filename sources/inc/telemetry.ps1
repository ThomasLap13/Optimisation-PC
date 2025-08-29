function Request-Telemetry {
    return Read-Host "Souhaitez-vous desactiver la telemetrie ? (1 = Oui / 0 = Non)"
}

function Disable-Telemetry {
    $countTotal = 0
    # Services a desactiver
    $services = @("DiagTrack", "dmwappushservice", "WMPNetworkSvc")
    foreach ($service in $services) {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc) {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled
            Write-Host "Suppression de : $service" -ForegroundColor Yellow
            $countTotal++
        } else {
            Write-Host "Non trouve : $service" -ForegroundColor DarkGray
        }
    }

    # Taches planifiees a supprimer
    $tasks = @(
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
        "\Microsoft\Windows\Autochk\Proxy",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    )
    foreach ($task in $tasks) {
        $result = schtasks /Query /TN $task 2>$null
        if ($result) {
            schtasks /Delete /TN $task /F | Out-Null
            Write-Host "Suppression de : $task" -ForegroundColor Yellow
            $countTotal++
        } else {
            Write-Host "Non trouve : $task" -ForegroundColor DarkGray
        }
    }

    # Clés de registre
    $regPaths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    )
    foreach ($path in $regPaths) {
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        try {
            Set-ItemProperty -Path $path -Name "AllowTelemetry" -Value 0 -Type DWord
            Write-Host "Suppression de : $path\AllowTelemetry" -ForegroundColor Yellow
            $countTotal++
        } catch {
            Write-Host "Non trouve : $path\AllowTelemetry" -ForegroundColor DarkGray
        }
    }

    # Preview Builds
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "AllowBuildPreview" -Value 0 -Type DWord
        Write-Host "Suppression de : PreviewBuilds" -ForegroundColor Yellow
        $countTotal++
    } catch {
        Write-Host "Non trouve : PreviewBuilds" -ForegroundColor DarkGray
    }

    # Feedback automatique
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Type DWord
        Write-Host "Suppression de : Feedback automatique" -ForegroundColor Yellow
        $countTotal++
    } catch {
        Write-Host "Non trouve : Feedback automatique" -ForegroundColor DarkGray
    }

    Write-Host "`nTelemetrie desactivee : $countTotal modifications appliquees." -ForegroundColor Green
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------------"
    Write-Host ""
}
