# Deploy this site to GitHub Pages (run in PowerShell after logging into GitHub)

# 1) Install / use GitHub CLI, then login once:
#    & "$env:LOCALAPPDATA\gh-cli\bin\gh.exe" auth login

$ErrorActionPreference = "Stop"
$gh = "$env:LOCALAPPDATA\gh-cli\bin\gh.exe"
Set-Location $PSScriptRoot

if (-not (Test-Path $gh)) {
  Write-Error "gh.exe not found. Install GitHub CLI first."
}

& $gh auth status

# Create public repo and push current main branch
& $gh repo create kang-chen-homepage --public --source=. --remote=origin --push

# Enable GitHub Pages from main branch root
& $gh api -X POST "repos/{owner}/{repo}/pages" -f build_type=legacy -f source='{"branch":"main","path":"/"}' 2>$null
& $gh api -X PUT "repos/{owner}/{repo}/pages" -f source='{"branch":"main","path":"/"}' 2>$null

$login = & $gh api user --jq .login
Write-Host ""
Write-Host "Done. Site URL (may take 1-2 minutes):"
Write-Host "https://$login.github.io/kang-chen-homepage/"
