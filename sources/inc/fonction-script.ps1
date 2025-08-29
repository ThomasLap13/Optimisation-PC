# Fonction : Animation de chargement
function Show-Loading {
    param (
        [string]$Message
    )
    Write-Host "$Message" -NoNewline
    for ($i = 0; $i -lt 5; $i++) {
        Start-Sleep -Milliseconds 300
        Write-Host "." -NoNewline
    }
    Write-Host " OK" -ForegroundColor Green
}

# Fonction : Fin du script
function Wait-FinScript {
    Write-Host "`nAppuyez sur Entree pour quitter..." -ForegroundColor Cyan
    [void][System.Console]::ReadLine()
}
