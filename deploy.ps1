param(
  [Parameter(Mandatory=$true)] [string]$ResourceGroup,
  [Parameter(Mandatory=$true)] [string]$AppName
)

Write-Host "Building frontend..." -ForegroundColor Cyan
Push-Location frontend
npm install
npm run build
Pop-Location

Write-Host "Copying build into backend..." -ForegroundColor Cyan
if (Test-Path backend\build) { Remove-Item -Recurse -Force backend\build }
Copy-Item -Recurse -Force frontend\build backend\

Write-Host "Installing backend deps..." -ForegroundColor Cyan
Push-Location backend
npm install
Pop-Location

Write-Host "Setting Node 18 on App Service..." -ForegroundColor Cyan
az webapp config appsettings set --resource-group $ResourceGroup --name $AppName --settings WEBSITE_NODE_DEFAULT_VERSION=18.20.3 | Out-Null

Write-Host "Deploying ZIP to Azure..." -ForegroundColor Cyan
az webapp deploy --resource-group $ResourceGroup --name $AppName --src-path backend --type zip

Write-Host "Done. Visit your site: https://$AppName.azurewebsites.net" -ForegroundColor Green
