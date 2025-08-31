$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath

Write-Host "Step 2: Removing duplicate _showSharePostDialog methods..."

# Remove second _showSharePostDialog (lines 8025-8150)
Write-Host "Removing second _showSharePostDialog..."
$linesToRemove = @()
for ($i = 8025; $i -le 8150; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Save after removal
Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "Second _showSharePostDialog removed. File saved."
