function Request-Settings {
    return Read-Host "Souhaitez-vous optimiser le systeme globalement ? (1 = Oui / 0 = Non)"
}

function Set-Settings {
    $countTotal = 0

    # 1. Nettoyage des fichiers temporaires
    try {
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Suppression de : Fichiers temporaires" -ForegroundColor Yellow
        $countTotal++
    } catch {
        Write-Host "Non trouve : Fichiers temporaires" -ForegroundColor DarkGray
    }

    # 2. Vider le cache DNS
    try {
        Clear-DnsClientCache
        Write-Host "Suppression de : Cache DNS" -ForegroundColor Yellow
        $countTotal++
    } catch {
        Write-Host "Non trouve : Cache DNS" -ForegroundColor DarkGray
    }

    # 3. Activer le mode Performances optimales
    try {
        if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        }

        if (Get-Command powercfg -ErrorAction SilentlyContinue) {
            $highPerfGUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"
            $plans = powercfg -list

            if ($plans -match $highPerfGUID) {
                powercfg -setactive $highPerfGUID
                Write-Host "Activation de : Mode Performances optimales" -ForegroundColor Yellow
                $countTotal++
            } else {
                Write-Host "Mode Performances optimales non disponible sur ce systeme." -ForegroundColor DarkGray
            }
        } else {
            throw "L'utilitaire powercfg n'est pas disponible."
        }
    } catch {
        Write-Host "Erreur : Mode Performances optimales ($($_.Exception.Message))" -ForegroundColor DarkGray
    }

    # 4. Desactiver les effets visuels (registre)
    try {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value 90
        Write-Host "Suppression de : Effets visuels" -ForegroundColor Yellow
        $countTotal++
    } catch {
        Write-Host "Non trouve : Effets visuels" -ForegroundColor DarkGray
    }

    Write-Host "`nOptimisation terminee : $countTotal modifications appliquees." -ForegroundColor Green
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------------"
    Write-Host ""
}
