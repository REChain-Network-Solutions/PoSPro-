$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath -Raw -Encoding UTF8

Write-Host "Removing duplicate methods..."

# Find the start of duplicate methods (around line 8000)
$duplicateStart = "// Дополнительные диалоги для SocialScreen"
$duplicateIndex = $content.IndexOf($duplicateStart, 8000)

if ($duplicateIndex -gt 0) {
    # Keep only the first part (up to duplicate methods)
    $cleanContent = $content.Substring(0, $duplicateIndex)
    
    # Add closing brace for the class
    $cleanContent += "}"
    
    # Save to file with proper encoding
    [System.IO.File]::WriteAllText($filePath, $cleanContent, [System.Text.Encoding]::UTF8)
    
    Write-Host "Duplicate methods removed. File saved."
    Write-Host "Original file had $($content.Length) characters"
    Write-Host "Clean file has $($cleanContent.Length) characters"
} else {
    Write-Host "Could not find duplicate methods"
}
