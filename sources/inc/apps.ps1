function Request-InstallApps {
    return Read-Host "Souhaitez-vous installer des applications ? (1 = Oui / 0 = Non)"
}

function Select-Apps {
    $options = @(
        @{ Name = "Steam"; NiniteID = "steam"; Path = "C:\Program Files (x86)\Steam\Steam.exe" },
        @{ Name = "Epic Games"; NiniteID = "epic"; Path = "$env:ProgramFiles\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe" },
        @{ Name = "Discord"; Command = { winget install Discord.Discord -h } }
    )

    Write-Host "`nSelectionnez les applications à installer (entrez les numeros separes par des virgules, 0 pour aucun) :"
    Write-Host "0) Aucun"
    for ($i = 0; $i -lt $options.Count; $i++) {
        Write-Host "$($i + 1)) $($options[$i].Name)"
    }

    $input = Read-Host "Votre selection"
    if ($input -eq "0") { return @() }

    $selectedIndexes = $input -split "," | ForEach-Object { ($_ -as [int]) - 1 }
    return $options[$selectedIndexes]
}

function Install-Apps {
    $selected = Select-Apps
    if ($selected.Count -eq 0) {
        Write-Host "`nAucune application selectionnee. Passage à la suite..."
        return
    }

    # Séparer les apps Ninite et les apps Winget
    $niniteApps = $selected | Where-Object { $_.ContainsKey("NiniteID") }
    $wingetApps = $selected | Where-Object { $_.ContainsKey("Command") }

    # Installation via Ninite
    if ($niniteApps.Count -gt 0) {
        $niniteBaseUrl = "https://ninite.com"
        $apps = ($niniteApps | ForEach-Object { $_.NiniteID }) -join "-"
        $installerUrl = "$niniteBaseUrl/$apps/ninite.exe"

        try {
            $filePath = "$env:TEMP\Ninite-Apps.exe"
            Invoke-WebRequest -Uri $installerUrl -OutFile $filePath -UseBasicParsing
            Start-Process -FilePath $filePath

            Start-Loading "Installation des applications Ninite en cours..."
            Start-Sleep -Seconds 20
        } catch {
            Write-Host "`nErreur Ninite : $($_.Exception.Message)"
        }
    }

    # Installation via Winget
    foreach ($app in $wingetApps) {
        Start-Loading "Installation de $($app.Name)..."
        try {
            $app.Command.Invoke()
        } catch {
            Write-Host "`nErreur Winget : $($_.Exception.Message)"
        }
        Stop-Loading "$($app.Name) installe"
    }

    Write-Host "`nInstallation terminee"
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------------"
    Write-Host ""
}
