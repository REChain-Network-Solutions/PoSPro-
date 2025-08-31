$sourceFile = "lib\Screens\main_screen_old.dart"
$targetFile = "lib\Screens\main_screen_fixed.dart"

Write-Host "Fixing encoding and copying file..."

# Read the source file with proper encoding
$content = Get-Content $sourceFile -Raw -Encoding UTF8

# Find the end of the first _showSocialSettingsDialog method (around line 8000)
$endOfFirstMethod = 8000

# Copy first part (up to line 8000)
$firstPart = $content.Substring(0, $endOfFirstMethod * 100)  # Approximate

# Find the end of the file (last few lines)
$endOfFile = $content.Substring($content.Length - 5000)

# Combine first part and end of file
$cleanContent = $firstPart + $endOfFile

# Save to new file with proper encoding
[System.IO.File]::WriteAllText($targetFile, $cleanContent, [System.Text.Encoding]::UTF8)

Write-Host "Fixed file created: $targetFile"
Write-Host "Original file had $($content.Length) characters"
Write-Host "Fixed file has $($cleanContent.Length) characters"
