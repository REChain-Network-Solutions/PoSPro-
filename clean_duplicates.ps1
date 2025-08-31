$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath -Raw

# Remove duplicate _showUserProfileDialog methods (keep first, remove others)
$pattern1 = "void _showUserProfileDialog\([^)]*\)\s*\{[^}]*\}"
$matches1 = [regex]::Matches($content, $pattern1, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($matches1.Count -gt 1) {
    Write-Host "Found $($matches1.Count) _showUserProfileDialog methods"
    for ($i = $matches1.Count - 1; $i -gt 0; $i--) {
        $match = $matches1[$i]
        $content = $content.Remove($match.Index, $match.Length)
        Write-Host "Removed duplicate $($i + 1)"
    }
}

# Remove duplicate _showSharePostDialog methods
$pattern2 = "void _showSharePostDialog\([^)]*\)\s*\{[^}]*\}"
$matches2 = [regex]::Matches($content, $pattern2, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($matches2.Count -gt 1) {
    Write-Host "Found $($matches2.Count) _showSharePostDialog methods"
    for ($i = $matches2.Count - 1; $i -gt 0; $i--) {
        $match = $matches2[$i]
        $content = $content.Remove($match.Index, $match.Length)
        Write-Host "Removed duplicate $($i + 1)"
    }
}

# Remove duplicate _showPostAnalyticsDialog methods
$pattern3 = "void _showPostAnalyticsDialog\([^)]*\)\s*\{[^}]*\}"
$matches3 = [regex]::Matches($content, $pattern3, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($matches3.Count -gt 1) {
    Write-Host "Found $($matches3.Count) _showPostAnalyticsDialog methods"
    for ($i = $matches3.Count - 1; $i -gt 0; $i--) {
        $match = $matches3[$i]
        $content = $content.Remove($match.Index, $match.Length)
        Write-Host "Removed duplicate $($i + 1)"
    }
}

# Remove duplicate _buildAnalyticsRow methods
$pattern4 = "Widget _buildAnalyticsRow\([^)]*\)\s*\{[^}]*\}"
$matches4 = [regex]::Matches($content, $pattern4, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($matches4.Count -gt 1) {
    Write-Host "Found $($matches4.Count) _buildAnalyticsRow methods"
    for ($i = $matches4.Count - 1; $i -gt 0; $i--) {
        $match = $matches4[$i]
        $content = $content.Remove($match.Index, $match.Length)
        Write-Host "Removed duplicate $($i + 1)"
    }
}

# Remove duplicate _showTrendingTopicsDialog methods
$pattern5 = "void _showTrendingTopicsDialog\([^)]*\)\s*\{[^}]*\}"
$matches5 = [regex]::Matches($content, $pattern5, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($matches5.Count -gt 1) {
    Write-Host "Found $($matches5.Count) _showTrendingTopicsDialog methods"
    for ($i = $matches5.Count - 1; $i -gt 0; $i--) {
        $match = $matches5[$i]
        $content = $content.Remove($match.Index, $match.Length)
        Write-Host "Removed duplicate $($i + 1)"
    }
}

# Remove duplicate _showSocialSettingsDialog methods
$pattern6 = "void _showSocialSettingsDialog\([^)]*\)\s*\{[^}]*\}"
$matches6 = [regex]::Matches($content, $pattern6, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($matches6.Count -gt 1) {
    Write-Host "Found $($matches6.Count) _showSocialSettingsDialog methods"
    for ($i = $matches6.Count - 1; $i -gt 0; $i--) {
        $match = $matches6[$i]
        $content = $content.Remove($match.Index, $match.Length)
        Write-Host "Removed duplicate $($i + 1)"
    }
}

Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Host "Duplicate methods removed. File saved."
