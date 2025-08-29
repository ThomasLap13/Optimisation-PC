function Request-RemoveBloatware {
    return Read-Host "Souhaitez-vous desinstaller les bloatwares ? (1 = Oui / 0 = Non)"
}

function Remove-Bloatware {
    $apps = @(
        "Microsoft.XboxGamingOverlay",
        "Microsoft.People",
        "Microsoft.News",
        "Microsoft.BingNews",
        "Microsoft.SkypeApp",
        "Microsoft.GetHelp",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        "Microsoft.WindowsMaps",
        "Microsoft.Getstarted",
        "Microsoft.Paint",
        "Microsoft.Tips",
        "MicrosoftCorporationII.QuickAssist",         # Assistance rapide
        "Microsoft.windowscommunicationsapps",        # Calendrier / Courrier
        "Microsoft.WindowsCamera",                    # Camera
        "Clipchamp.Clipchamp",                        # Clipchamp
        "Microsoft.549981C3F5F10",                    # Cortana
        "Microsoft.WindowsSoundRecorder",             # Enregistreur Vocal
        "Microsoft.WindowsAlarms",                    # Horloge
        "Microsoft.WindowsFeedbackHub",               # Hub commentaire
        "McAfeeWPSSparsePackage",                     # McAfee
        "Microsoft.BingWeather",                      # Meteo
        "Microsoft.Todos",                            # Microsoft To Do
        "Microsoft.MicrosoftOfficeHub",               # Office
        "Microsoft.MicrosoftStickyNotes",             # Pense-bete
        "Microsoft.MixedReality.Portal",              # Portail realite mixte
        "Microsoft.MicrosoftSolitaireCollection"      # Solitaire
    )
    $removedCount = 0
    foreach ($app in $apps) {
        $package = Get-AppxPackage -Name $app
        if ($package) {
            Write-Host "Suppression de : $app" -ForegroundColor Yellow
            $package | Remove-AppxPackage -ErrorAction SilentlyContinue
            $removedCount++
        } else {
            Write-Host "Non trouve : $app" -ForegroundColor DarkGray
        }
    }

    Write-Host "`nBloatwares supprimes : $removedCount / $($apps.Count)" -ForegroundColor Green
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------------"
    Write-Host