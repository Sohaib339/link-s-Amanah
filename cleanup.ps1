$files = Get-ChildItem -Path "E:\linkAmanah\pages\software\*.html"
$count = 0

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Remove emoji patterns using Unicode regex - covers most emoji ranges
    # Emoticons, dingbats, symbols, misc symbols
    $content = $content -replace '[\u2600-\u26FF]', ''
    $content = $content -replace '[\u2700-\u27BF]', ''
    $content = $content -replace '[\u2B50-\u2B55]', ''
    $content = $content -replace '[\u2B05-\u2B07]', ''
    
    # Supplementary Multilingual Plane emojis (surrogate pairs in UTF-16)
    # Match common emoji patterns
    $content = $content -replace '\uD83C[\uDF00-\uDFFF]', ''
    $content = $content -replace '\uD83D[\uDC00-\uDDFF]', ''
    $content = $content -replace '\uD83D[\uDE00-\uDE4F]', ''
    $content = $content -replace '\uD83D[\uDE80-\uDEFF]', ''
    $content = $content -replace '\uD83E[\uDD00-\uDDFF]', ''
    
    # Remove variation selectors
    $content = $content -replace '\uFE0F', ''
    
    # Replace up arrow with caret for back-to-top
    $content = $content -replace [char]0x2191, '^'
    
    # Replace logo-icon content with LA
    $content = $content -replace '<div class="logo-icon">[^<]*</div>', '<div class="logo-icon">LA</div>'
    
    # Update favicon SVG to use LA text
    $content = $content -replace "<text y='\.9em' font-size='90'>[^<]*</text>", "<text y='.9em' font-size='90'>LA</text>"
    
    # Clean up leading/extra spaces in tags
    $content = $content -replace '(<h[1-4][^>]*>)\s+', '$1'
    $content = $content -replace '(class="download-btn[^"]*">)\s+', '$1'
    $content = $content -replace '(<strong>)\s+', '$1'
    $content = $content -replace '(<h4>)\s+', '$1'
    $content = $content -replace '  +', ' '
    
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
    $count++
    Write-Host "[$count/51] $($file.Name)"
}

Write-Host "Done! Processed $count files."
