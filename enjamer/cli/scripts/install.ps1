$ErrorActionPreference = 'Stop'

$git = Get-Command git.exe -CommandType Application -ErrorAction SilentlyContinue |
    Select-Object -First 1
if (-not $git) {
    throw 'Install Git for Windows and make git available on PATH before running this installer.'
}

$gitDirectory = Split-Path -Parent $git.Source
$gitRoot = Split-Path -Parent $gitDirectory
$bash = Join-Path $gitRoot 'bin\bash.exe'
if (-not (Test-Path -LiteralPath $bash -PathType Leaf)) {
    throw "Git Bash was not found at $bash. Use Git for Windows with Git Bash installed."
}

$sourceDir = Join-Path (Split-Path -Parent $PSScriptRoot) 'bin'
$commands = @(Get-ChildItem -LiteralPath $sourceDir -Filter 'enjamer-*' -File)
if ($commands.Count -eq 0) {
    throw "No Enjamer commands were found in $sourceDir."
}

$installDir = Join-Path $env:LOCALAPPDATA 'Enjamer\bin'
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

$batchBash = $bash.Replace('%', '%%')
foreach ($command in $commands) {
    Copy-Item -LiteralPath $command.FullName -Destination $installDir -Force

    $launcher = @(
        '@echo off'
        'setlocal DisableDelayedExpansion'
        ('"{0}" --noprofile --norc "%~dp0{1}"' -f $batchBash, $command.Name)
        'exit /b %errorlevel%'
    )
    Set-Content -LiteralPath (Join-Path $installDir "$($command.Name).cmd") -Value $launcher -Encoding OEM
}

function Add-PathEntry([string]$PathValue, [string]$Directory) {
    $entries = $PathValue -split ';'
    if ($entries.TrimEnd('\', '/') -contains $Directory.TrimEnd('\', '/')) {
        return $PathValue
    }
    if ([string]::IsNullOrWhiteSpace($PathValue)) {
        return $Directory
    }
    return "$($PathValue.TrimEnd(';'));$Directory"
}

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$updatedUserPath = Add-PathEntry $userPath $installDir
if ($updatedUserPath -ne $userPath) {
    [Environment]::SetEnvironmentVariable('Path', $updatedUserPath, 'User')
}
$env:Path = Add-PathEntry $env:Path $installDir

Write-Output "Enjamer commands installed in $installDir."
