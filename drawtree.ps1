param (
    [string]$Path = ".",
    [int]$MaxDepth = 10  # Limite anti-boucle infinie
)

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$OutputFile = Join-Path $ScriptPath "maptree_output.txt"

# export file reinit
try {
    if (Test-Path $OutputFile) { Remove-Item $OutputFile -Force }
    New-Item -Path $OutputFile -ItemType File -Force | Out-Null
} catch {
    Write-Host "Erreur lors de la création du fichier d'export." -ForegroundColor Red
    exit
}

function Show-Tree {
    param (
        [string]$CurrentPath,
        [int]$Level
    )

    if ($Level -gt $MaxDepth) {
        return
    }

    $spacer = ("    " * $Level) + "|-- "
    $folderName = [System.IO.Path]::GetFileName($CurrentPath)

    # Colors
    switch ($Level) {
        0 { $folderColor = "Green" }
        1 { $folderColor = "Blue" }
        default { $folderColor = "Cyan" }
    }

    Write-Host "$spacer$folderName" -ForegroundColor $folderColor
    Add-Content -Path $OutputFile -Value "$spacer$folderName"

    try {
        $files = Get-ChildItem -Path $CurrentPath -File -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            $fPrefix = ("    " * ($Level + 1)) + "-> "
            $ext = $file.Extension.ToLower()
            $color = "White"

            switch ($ext) {
                ".txt" { $color = "Yellow" }
                ".exe" { $color = "Red" }
                ".ps1" { $color = "Red" }
                ".sh"  { $color = "Red" }
            }

            Write-Host "$fPrefix$file" -ForegroundColor $color
            Add-Content -Path $OutputFile -Value "$fPrefix$file"
        }

        # Recurse 
        $dirs = Get-ChildItem -Path $CurrentPath -Directory -ErrorAction SilentlyContinue
        foreach ($dir in $dirs) {
            Show-Tree -CurrentPath $dir.FullName -Level ($Level + 1)
        }
    } catch {
        Write-Host "Accès refusé à : $CurrentPath" -ForegroundColor DarkGray
    }
}

Show-Tree -CurrentPath (Resolve-Path $Path).Path -Level 0

Write-Host "`nExport créé dans : $OutputFile" -ForegroundColor Green
