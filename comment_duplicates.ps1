$filePath = "lib\Screens\main_screen.dart"
$content = Get-Content $filePath

Write-Host "Commenting out duplicate methods..."

# Comment out second _showUserProfileDialog (lines 8025-8150)
for ($i = 8025; $i -le 8150; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out third _showUserProfileDialog (lines 8388-8514)
for ($i = 8388; $i -le 8514; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out second _showSharePostDialog (lines 8152-8270)
for ($i = 8152; $i -le 8270; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out third _showSharePostDialog (lines 8515-8632)
for ($i = 8515; $i -le 8632; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out second _showPostAnalyticsDialog (lines 8204-8325)
for ($i = 8204; $i -le 8325; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out third _showPostAnalyticsDialog (lines 8567-8688)
for ($i = 8567; $i -le 8688; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out second _buildAnalyticsRow (lines 8250-8270)
for ($i = 8250; $i -le 8270; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out third _buildAnalyticsRow (lines 8613-8632)
for ($i = 8613; $i -le 8632; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out second _showTrendingTopicsDialog (lines 8270-8325)
for ($i = 8270; $i -le 8325; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out third _showTrendingTopicsDialog (lines 8633-8688)
for ($i = 8633; $i -le 8688; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Comment out second _showSocialSettingsDialog (lines 8326-8387)
for ($i = 8326; $i -le 8387; $i++) {
    if ($content[$i-1] -notmatch "^//") {
        $content[$i-1] = "// " + $content[$i-1]
    }
}

# Save the file
Set-Content -Path $filePath -Value $content -Encoding UTF8

Write-Host "Duplicate methods commented out. File saved."
