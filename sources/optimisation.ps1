#############################################################
# Script modification des parametres Windows ULTIME         #
# Auteur : Lapierre Thomas                                  #
# Date : 27/08/2025                                         #
# Version 9999 : Teste sur Windows 10/11 22H2/23H2/24H2     #
#############################################################

# Lien vers les script et les dossiers :
. "$PSScriptRoot\inc\fonction-script.ps1"
. "$PSScriptRoot\inc\bloatware.ps1"
. "$PSScriptRoot\inc\telemetry.ps1"

# Debut du parametrage
Write-Host ""
Write-Host "==============================================================================="
Write-Host "======        Bienvenue dans le script de parametrage automatique        ======"
Write-Host "==============================================================================="
Write-Host ""

Write-Host "Repondez au questionnaire avec :"
Write-Host "    - Oui = 1"
Write-Host "    - Non = 0"
Write-Host ""
Write-Host "-------------------------------------------------------------------------------"
Write-Host ""

# Configuration
if ((Request-RemoveBloatware) -eq 1) { Show-Loading "Suppression des bloatwares"; Remove-Bloatware }
if ((Request-Telemetry) -eq 1) { Show-Loading "Desactivation de la telemetrie"; Disable-Telemetry }

Wait-FinScript
