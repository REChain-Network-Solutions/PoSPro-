$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath

Write-Host "Step 4: Removing duplicate _buildAnalyticsRow methods..."

# Remove second _buildAnalyticsRow (lines 8123-8140)
Write-Host "Removing second _buildAnalyticsRow..."
$linesToRemove = @()
for ($i = 8123; $i -le 8140; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Save after removal
Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "Second _buildAnalyticsRow removed. File saved."
