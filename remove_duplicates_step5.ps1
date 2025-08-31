$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath

Write-Host "Step 5: Removing duplicate _showTrendingTopicsDialog methods..."

# Remove second _showTrendingTopicsDialog (lines 8143-8200)
Write-Host "Removing second _showTrendingTopicsDialog..."
$linesToRemove = @()
for ($i = 8143; $i -le 8200; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Save after removal
Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "Second _showTrendingTopicsDialog removed. File saved."
