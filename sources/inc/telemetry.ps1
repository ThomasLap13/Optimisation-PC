function Request-Telemetry {
    return Read-Host "Souhaitez-vous desactiver la telemetrie ? (1 = Oui / 0 = Non)"
}
function Disable-Telemetry {
    Write-Host "`nDesactivation complete de la telemetrie..." -ForegroundColor Cyan

    # 1. Desactivation des services lies a la telemetrie
    $services = @("DiagTrack", "dmwappushservice", "WMPNetworkSvc")
    foreach ($service in $services) {
        Get-Service -Name $service -ErrorAction SilentlyContinue | ForEach-Object {
            Stop-Service -Name $_.Name -Force -ErrorAction SilentlyContinue
            Set-Service -Name $_.Name -StartupType Disabled
            Write-Host "Service desactive : $($_.Name)" -ForegroundColor Yellow
        }
    }

    # 2. Suppression des taches planifiees de telemetrie
    $tasks = @(
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
        "\Microsoft\Windows\Autochk\Proxy",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    )
    foreach ($task in $tasks) {
        try {
            schtasks /Delete /TN $task /F | Out-Null
            Write-Host "Tache supprimee : $task" -ForegroundColor Yellow
        } catch {
            Write-Host "Tache introuvable : $task" -ForegroundColor DarkGray
        }
    }

    # 3. Modification du registre pour desactiver la collecte de donnees
    $regPaths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    )
    foreach ($path in $regPaths) {
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "AllowTelemetry" -Value 0 -Type DWord
        Write-Host "Cle modifiee : $path\AllowTelemetry = 0" -ForegroundColor Yellow
    }

    # 4. Desactivation de la telemetrie via Group Policy (si applicable)
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "AllowBuildPreview" -Value 0 -Type DWord
        Write-Host "Cle modifiee : PreviewBuilds desactive" -ForegroundColor Yellow
    } catch {}

    # 5. Desactivation des feedbacks automatiques
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Type DWord
        Write-Host "Feedback automatique desactive" -ForegroundColor Yellow
    } catch {}

    Write-Host "`nTelemetrie desactivee avec succes." -
}