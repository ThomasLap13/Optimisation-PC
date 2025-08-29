function Request-InstallLauncher {
    return Read-Host "Souhaitez-vous installer des launchers de jeux via Ninite ? (1 = Oui / 0 = Non)"
}

function Select-Launchers {
    $options = @(
        @{ Name = "Steam"; NiniteID = "steam"; Path = "C:\Program Files (x86)\Steam\Steam.exe" },
        @{ Name = "Epic Games"; NiniteID = "epic"; Path = "$env:ProgramFiles\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe" }
    )

    Write-Host "`nSelectionnez les launchers a installer (entrez les numeros separes par des virgules, 0 pour aucun) :"
    for ($i = 0; $i -lt $options.Count; $i++) {
        Write-Host "$($i + 1)) $($options[$i].Name)"
    }
    Write-Host "0) Aucun"

    $input = Read-Host "Votre selection"
    if ($input -eq "0") { return @() }

    $selectedIndexes = $input -split "," | ForEach-Object { ($_ -as [int]) - 1 }
    return $options[$selectedIndexes]
}

function Install-Launcher {
    $selected = Select-Launchers
    if ($selected.Count -eq 0) {
        Write-Host "`nAucun launcher selectionne. Passage a la suite..."
        return
    }

    $niniteBaseUrl = "https://ninite.com"
    $apps = ($selected | ForEach-Object { $_.NiniteID }) -join "-"
    $installerUrl = "$niniteBaseUrl/$apps/ninite.exe"

    try {
        $filePath = "$env:TEMP\Ninite-Launchers.exe"
        Invoke-WebRequest -Uri $installerUrl -OutFile $filePath -UseBasicParsing
        Start-Process -FilePath $filePath

        Start-Loading "Installation des launchers en cours..."
        Start-Sleep -Seconds 20
    } catch {
        Write-Host "`nErreur : $($_.Exception.Message)"
        return
    }
    Write-Host "`nInstallation terminee"
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------------"
    Write-Host ""
}
