$versions = gh release list `
  --repo leanprover/lean4 `
  --json tagName | `
  ConvertFrom-Json | `
  ForEach-Object { $_.tagName }

$versions >> tmp.versionlist.txt

gh release download `
  --repo Seasawher/Semver.lean latest `
  --pattern 'semver.exe' `
  --dir "." `
  --skip-existing

./semver.exe tmp.versionlist.txt lean-toolchain

$latestLean = Get-Content -Path "lean-toolchain"
Write-Host "Latest Lean version: $latestLean"

Remove-Item -Path tmp.versionlist.txt
Remove-Item -Path .\semver.exe