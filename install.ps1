Write-Host "Installing npm packages in all microservices..." -ForegroundColor Cyan

Get-ChildItem -Directory | ForEach-Object {
    if (Test-Path "$($_.FullName)\package.json") {
        Write-Host "📦 Installing in $($_.Name)" -ForegroundColor Yellow
        Push-Location $_.FullName
        npm install
        Pop-Location
        Write-Host ""
    }
}

Write-Host "✅ All installations completed!" -ForegroundColor Green