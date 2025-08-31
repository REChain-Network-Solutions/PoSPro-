$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath

Write-Host "Step 3: Removing duplicate _showPostAnalyticsDialog methods..."

# Remove second _showPostAnalyticsDialog (lines 8077-8200)
Write-Host "Removing second _showPostAnalyticsDialog..."
$linesToRemove = @()
for ($i = 8077; $i -le 8200; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Save after removal
Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "Second _showPostAnalyticsDialog removed. File saved."
