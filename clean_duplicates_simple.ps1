$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath

Write-Host "Removing duplicate methods..."

# Remove second _showUserProfileDialog (lines 8025-8150)
$linesToRemove = @()
for ($i = 8025; $i -le 8150; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove third _showUserProfileDialog (lines 8388-8514)
$linesToRemove = @()
for ($i = 8388; $i -le 8514; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove second _showSharePostDialog (lines 8152-8270)
$linesToRemove = @()
for ($i = 8152; $i -le 8270; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove third _showSharePostDialog (lines 8515-8632)
$linesToRemove = @()
for ($i = 8515; $i -le 8632; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove second _showPostAnalyticsDialog (lines 8204-8325)
$linesToRemove = @()
for ($i = 8204; $i -le 8325; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove third _showPostAnalyticsDialog (lines 8567-8689)
$linesToRemove = @()
for ($i = 8567; $i -le 8689; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove second _buildAnalyticsRow (lines 8250-8269)
$linesToRemove = @()
for ($i = 8250; $i -le 8269; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove third _buildAnalyticsRow (lines 8613-8632)
$linesToRemove = @()
for ($i = 8613; $i -le 8632; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove second _showTrendingTopicsDialog (lines 8270-8325)
$linesToRemove = @()
for ($i = 8270; $i -le 8325; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove third _showTrendingTopicsDialog (lines 8633-8688)
$linesToRemove = @()
for ($i = 8633; $i -le 8688; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Remove second _showSocialSettingsDialog (lines 8326-8387)
$linesToRemove = @()
for ($i = 8326; $i -le 8387; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Save cleaned file
Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "Duplicate methods removed. File saved."
