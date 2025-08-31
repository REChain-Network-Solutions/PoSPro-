$sourceFile = "lib\Screens\main_screen.dart"
$targetFile = "lib\Screens\main_screen_clean.dart"

Write-Host "Creating clean file without duplicate methods..."

# Read the source file
$content = Get-Content $sourceFile

# Find the end of the first _showSocialSettingsDialog method (around line 8000)
$endOfFirstMethod = 8000

# Copy first part (up to line 8000)
$firstPart = $content[0..($endOfFirstMethod-1)]

# Find the end of the file (last few lines)
$endOfFile = $content[($content.Length-100)..($content.Length-1)]

# Combine first part and end of file
$cleanContent = $firstPart + $endOfFile

# Save to new file
Set-Content -Path $targetFile -Value $cleanContent -Encoding UTF8

Write-Host "Clean file created: $targetFile"
Write-Host "Original file had $($content.Length) lines"
Write-Host "Clean file has $($cleanContent.Length) lines"
