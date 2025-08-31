$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath

Write-Host "Удаляю дублированные методы..."

# Удаляем второй _showUserProfileDialog (строки 8025-8150)
$linesToRemove = @()
for ($i = 8025; $i -le 8150; $i++) {
    $linesToRemove += $i - 1  # PowerShell индексирует с 0
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем третий _showUserProfileDialog (строки 8388-8514)
$linesToRemove = @()
for ($i = 8388; $i -le 8514; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем второй _showSharePostDialog (строки 8152-8270)
$linesToRemove = @()
for ($i = 8152; $i -le 8270; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем третий _showSharePostDialog (строки 8515-8632)
$linesToRemove = @()
for ($i = 8515; $i -le 8632; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем второй _showPostAnalyticsDialog (строки 8204-8325)
$linesToRemove = @()
for ($i = 8204; $i -le 8325; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем третий _showPostAnalyticsDialog (строки 8567-8688)
$linesToRemove = @()
for ($i = 8567; $i -le 8688; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем второй _buildAnalyticsRow (строки 8250-8270)
$linesToRemove = @()
for ($i = 8250; $i -le 8270; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем третий _buildAnalyticsRow (строки 8613-8632)
$linesToRemove = @()
for ($i = 8613; $i -le 8632; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем второй _showTrendingTopicsDialog (строки 8270-8325)
$linesToRemove = @()
for ($i = 8270; $i -le 8325; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем третий _showTrendingTopicsDialog (строки 8633-8688)
$linesToRemove = @()
for ($i = 8633; $i -le 8688; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Удаляем второй _showSocialSettingsDialog (строки 8326-8387)
$linesToRemove = @()
for ($i = 8326; $i -le 8387; $i++) {
    $linesToRemove += $i - 1
}
$content = $content | Select-Object -Index (0..($linesToRemove[0]-1) + ($linesToRemove[-1]+1)..($content.Length-1))

# Сохраняем файл
Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "Все дублированные методы удалены. Файл сохранен."
