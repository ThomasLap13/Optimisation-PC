function Request-RemoveBloatware {
    return Read-Host "Souhaitez-vous desinstaller les bloatwares ? (1 = Oui / 0 = Non)"
}

function Remove-Bloatware {
    $apps = @(
        "Microsoft.XboxGamingOverlay",
        "Microsoft.People",
        "Microsoft.News",
        "Microsoft.SkypeApp",
        "Microsoft.GetHelp",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        "Microsoft.WindowsMaps",
        "Microsoft.Getstarted",
        "Microsoft.Paint",
        "Microsoft.Getstarted",
        "Microsoft.Tips"
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
    Write-Host ""
}