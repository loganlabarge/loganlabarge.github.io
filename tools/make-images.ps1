# Builds the social-share card (assets/og-image.png, 1200x630) and the PNG icons.
# Re-run after changing the name or subtitle:
#   powershell -ExecutionPolicy Bypass -File tools\make-images.ps1 -Subtitle "Your new line"
param(
    [string]$Name = 'Logan LaBarge',
    [string]$Subtitle = ('Finance  {0}  Game Development  {0}  Monk High Games' -f [char]0x00B7),
    [string]$Url = 'loganlabarge.github.io'
)

Add-Type -AssemblyName System.Drawing
$assets = Join-Path (Split-Path $PSScriptRoot -Parent) 'assets'

$navy = [System.Drawing.Color]::FromArgb(20, 33, 61)
$navyLight = [System.Drawing.Color]::FromArgb(29, 44, 79)
$gold = [System.Drawing.Color]::FromArgb(217, 165, 86)
$white = [System.Drawing.Color]::White
$muted = [System.Drawing.Color]::FromArgb(181, 189, 208)

function New-Canvas([int]$w, [int]$h) {
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'AntiAlias'
    $g.TextRenderingHint = 'AntiAliasGridFit'
    $g.InterpolationMode = 'HighQualityBicubic'
    return @($bmp, $g)
}

function Get-Serif([float]$size, [string]$style = 'Regular') {
    foreach ($family in 'Palatino Linotype', 'Georgia', 'Times New Roman') {
        try { return New-Object System.Drawing.Font($family, $size, [System.Drawing.FontStyle]$style, [System.Drawing.GraphicsUnit]::Pixel) } catch {}
    }
}

# ---- Social card ----
$bmp, $g = New-Canvas 1200 630
$g.Clear($navy)
$glow = New-Object System.Drawing.Drawing2D.GraphicsPath
$glow.AddEllipse(700, -380, 900, 760)
$pgb = New-Object System.Drawing.Drawing2D.PathGradientBrush $glow
$pgb.CenterColor = $navyLight
$pgb.SurroundColors = @($navy)
$g.FillPath($pgb, $glow)

$g.FillRectangle((New-Object System.Drawing.SolidBrush $gold), 96, 150, 72, 6)
$g.DrawString($Name, (Get-Serif 104 'Bold'), (New-Object System.Drawing.SolidBrush $white), 88, 200)
$g.DrawString($Subtitle, (New-Object System.Drawing.Font('Segoe UI', 34, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)), (New-Object System.Drawing.SolidBrush $muted), 96, 350)
$g.DrawString($Url, (New-Object System.Drawing.Font('Segoe UI Semibold', 28, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)), (New-Object System.Drawing.SolidBrush $gold), 96, 520)

$g.Dispose()
$bmp.Save((Join-Path $assets 'og-image.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

# ---- Square monogram icons ----
function Save-Icon([int]$size, [string]$file) {
    $bmp, $g = New-Canvas $size $size
    $g.Clear([System.Drawing.Color]::Transparent)
    $r = [int]($size * 0.22)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0, 0, $r * 2, $r * 2, 180, 90)
    $path.AddArc($size - $r * 2 - 1, 0, $r * 2, $r * 2, 270, 90)
    $path.AddArc($size - $r * 2 - 1, $size - $r * 2 - 1, $r * 2, $r * 2, 0, 90)
    $path.AddArc(0, $size - $r * 2 - 1, $r * 2, $r * 2, 90, 90)
    $path.CloseFigure()
    $g.FillPath((New-Object System.Drawing.SolidBrush $navy), $path)
    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Alignment = 'Center'; $fmt.LineAlignment = 'Center'
    $rect = New-Object System.Drawing.RectangleF 0, (-$size * 0.04), $size, $size
    $g.DrawString('LL', (Get-Serif ($size * 0.44) 'Bold'), (New-Object System.Drawing.SolidBrush $white), $rect, $fmt)
    $g.FillRectangle((New-Object System.Drawing.SolidBrush $gold), [int]($size * 0.31), [int]($size * 0.77), [int]($size * 0.38), [Math]::Max(1, [int]($size * 0.05)))
    $g.Dispose()
    $bmp.Save((Join-Path $assets $file), [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}
Save-Icon 32 'favicon-32.png'
Save-Icon 180 'apple-touch-icon.png'

Write-Output "Wrote og-image.png, favicon-32.png, apple-touch-icon.png to $assets"
