$sourceFile = "lib\Screens\main_screen_old.dart"
$targetFile = "lib\Screens\main_screen_fixed.dart"

Write-Host "Fixing encoding and copying file..."

# Read the source file with proper encoding
$content = Get-Content $sourceFile -Raw -Encoding UTF8

# Find the end of the first _showSocialSettingsDialog method
$pattern = "void _showSocialSettingsDialog\(BuildContext context\) \{"
$matches = [regex]::Matches($content, $pattern)

if ($matches.Count -gt 1) {
    $firstMatch = $matches[0]
    $secondMatch = $matches[1]
    
    # Copy from start to end of first method
    $firstPart = $content.Substring(0, $secondMatch.Index)
    
    # Find the end of the file
    $endPattern = "^\}"
    $endMatches = [regex]::Matches($content, $endPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
    
    if ($endMatches.Count -gt 0) {
        $lastEnd = $endMatches[$endMatches.Count - 1]
        $endOfFile = $content.Substring($lastEnd.Index)
        
        # Combine first part and end of file
        $cleanContent = $firstPart + $endOfFile
        
        # Save to new file with proper encoding
        [System.IO.File]::WriteAllText($targetFile, $cleanContent, [System.Text.Encoding]::UTF8)
        
        Write-Host "Fixed file created: $targetFile"
        Write-Host "Original file had $($content.Length) characters"
        Write-Host "Fixed file has $($cleanContent.Length) characters"
    }
} else {
    Write-Host "Could not find duplicate methods"
}
