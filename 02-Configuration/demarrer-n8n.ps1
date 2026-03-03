# Script de demarrage n8n - Agent IA Marketing Local
# Pre-requis : Docker Desktop doit etre LANCE

Set-Location $PSScriptRoot

Write-Host "Verification Docker..." -ForegroundColor Cyan
docker info 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR : Docker n'est pas demarre. Lancez Docker Desktop puis relancez ce script." -ForegroundColor Red
    exit 1
}

Write-Host "Demarrage de n8n..." -ForegroundColor Green
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "n8n est demarre !" -ForegroundColor Green
    Write-Host "  -> Ouvrez http://localhost:5678 dans votre navigateur" -ForegroundColor Yellow
    Write-Host "  -> Creer un compte a la premiere connexion" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Rappel : installez Ollama (https://ollama.com) puis lancez : ollama pull tinyllama" -ForegroundColor Cyan
} else {
    Write-Host "Echec du demarrage. Verifiez que Docker Desktop est bien lance." -ForegroundColor Red
    exit 1
}
