$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath

Write-Host "Removing duplicate methods step by step..."

# Step 1: Remove second _showUserProfileDialog (lines 8024-8150)
Write-Host "Step 1: Removing second _showUserProfileDialog..."
$linesToRemove = @()
for ($i = 8024; $i -le 8150; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Step 2: Remove third _showUserProfileDialog (lines 8387-8514)
Write-Host "Step 2: Removing third _showUserProfileDialog..."
$linesToRemove = @()
for ($i = 8387; $i -le 8514; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Save after first two removals
Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "First two duplicate methods removed. File saved."
