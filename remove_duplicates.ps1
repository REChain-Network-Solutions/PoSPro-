# PowerShell скрипт для удаления дублированных методов из main_screen.dart

$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath -Raw

# Список дублированных методов для удаления
$duplicateMethods = @(
    "_showUserProfileDialog",
    "_showSharePostDialog", 
    "_showPostAnalyticsDialog",
    "_buildAnalyticsRow",
    "_showTrendingTopicsDialog",
    "_showSocialSettingsDialog"
)

foreach ($method in $duplicateMethods) {
    Write-Host "Обрабатываю метод: $method"
    
    # Находим все вхождения метода
    $pattern = "void $method\([^)]*\)\s*\{[^}]*\}"
    $matches = [regex]::Matches($content, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    
    if ($matches.Count -gt 1) {
        Write-Host "Найдено $($matches.Count) вхождений метода $method"
        
        # Оставляем только первое вхождение, удаляем остальные
        for ($i = $matches.Count - 1; $i -gt 0; $i--) {
            $match = $matches[$i]
            $content = $content.Remove($match.Index, $match.Length)
            Write-Host "Удалено дублированное вхождение $($i + 1)"
        }
    }
}

# Сохраняем очищенный файл
Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "Дублированные методы удалены. Файл сохранен."
