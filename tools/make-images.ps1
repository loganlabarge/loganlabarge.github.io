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

# ---- Game page social card (amator-fortuna/) ----
$night = [System.Drawing.Color]::FromArgb(11, 16, 32)
$bmp, $g = New-Canvas 1200 630
$g.Clear($night)
$band = New-Object System.Drawing.Drawing2D.LinearGradientBrush ((New-Object System.Drawing.Rectangle 0, 0, 1200, 630), $night, $navy, 90)
$g.FillRectangle($band, 0, 0, 1200, 630)

# Isometric voxel stack on the right, same layout as the page's hero art.
function Fill-Cube([float]$cx, [float]$cy, [float]$s, $top, $left, $right) {
    $h = $s * 4 / 7; $w = $s
    $pts = { param($a) [System.Drawing.PointF[]]($a | ForEach-Object { New-Object System.Drawing.PointF ($cx + $_[0]), ($cy + $_[1]) }) }
    # Parenthesised products: in PowerShell the comma binds before * (0, 2 * $h would repeat an array).
    $g.FillPolygon((New-Object System.Drawing.SolidBrush $top), (& $pts @(@(0, 0), @($w, -$h), @(0, (-2 * $h)), @(-$w, -$h))))
    $g.FillPolygon((New-Object System.Drawing.SolidBrush $left), (& $pts @(@(-$w, -$h), @(0, 0), @(0, (2 * $h)), @(-$w, $h))))
    $g.FillPolygon((New-Object System.Drawing.SolidBrush $right), (& $pts @(@($w, -$h), @(0, 0), @(0, (2 * $h)), @($w, $h))))
}
$goldCube = @([System.Drawing.Color]::FromArgb(230, 184, 110), [System.Drawing.Color]::FromArgb(168, 116, 42), [System.Drawing.Color]::FromArgb(111, 74, 20))
$stoneCube = @([System.Drawing.Color]::FromArgb(74, 92, 136), [System.Drawing.Color]::FromArgb(42, 58, 99), [System.Drawing.Color]::FromArgb(27, 39, 71))
$s = 70; $ox = 930; $oy = 330
foreach ($c in @(@(0,0,0,'s'), @(1,0,0,'s'), @(0,1,0,'s'), @(0,0,1,'g'), @(2,0,0,'s'), @(1,1,0,'s'), @(0,2,0,'s'), @(1,0,1,'g'), @(0,1,1,'g'), @(0,0,2,'g'))) {
    $cols = if ($c[3] -eq 'g') { $goldCube } else { $stoneCube }
    Fill-Cube ($ox + $s * ($c[0] - $c[1])) ($oy + ($s * 4 / 7) * ($c[0] + $c[1]) - ($s * 8 / 7) * $c[2]) $s $cols[0] $cols[1] $cols[2]
}

$g.DrawString('A GAME BY MONK HIGH GAMES', (New-Object System.Drawing.Font('Segoe UI Semibold', 24, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)), (New-Object System.Drawing.SolidBrush $gold), 96, 150)
$g.DrawString('Amator', (Get-Serif 112 'Bold'), (New-Object System.Drawing.SolidBrush $white), 84, 190)
$g.DrawString('Fortuna', (Get-Serif 112 'Bold'), (New-Object System.Drawing.SolidBrush $white), 84, 310)
$g.DrawString(('Voxel RPG  {0}  First-person shooter  {0}  Integrated AI' -f [char]0x00B7), (New-Object System.Drawing.Font('Segoe UI', 28, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)), (New-Object System.Drawing.SolidBrush $muted), 96, 450)
$g.DrawString("$Url/amator-fortuna", (New-Object System.Drawing.Font('Segoe UI Semibold', 26, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)), (New-Object System.Drawing.SolidBrush $gold), 96, 530)

$g.Dispose()
$bmp.Save((Join-Path $assets 'og-amator-fortuna.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

# ---- Square monogram icons ----
function Save-Icon([int]$size, [string]$file, [string]$text = 'LL', $bg = $navy, $fg = $white) {
    $bmp, $g = New-Canvas $size $size
    $g.Clear([System.Drawing.Color]::Transparent)
    $r = [int]($size * 0.22)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0, 0, $r * 2, $r * 2, 180, 90)
    $path.AddArc($size - $r * 2 - 1, 0, $r * 2, $r * 2, 270, 90)
    $path.AddArc($size - $r * 2 - 1, $size - $r * 2 - 1, $r * 2, $r * 2, 0, 90)
    $path.AddArc(0, $size - $r * 2 - 1, $r * 2, $r * 2, 90, 90)
    $path.CloseFigure()
    $g.FillPath((New-Object System.Drawing.SolidBrush $bg), $path)
    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Alignment = 'Center'; $fmt.LineAlignment = 'Center'
    $rect = New-Object System.Drawing.RectangleF 0, (-$size * 0.04), $size, $size
    $g.DrawString($text, (Get-Serif ($size * 0.44) 'Bold'), (New-Object System.Drawing.SolidBrush $fg), $rect, $fmt)
    $g.FillRectangle((New-Object System.Drawing.SolidBrush $gold), [int]($size * 0.31), [int]($size * 0.77), [int]($size * 0.38), [Math]::Max(1, [int]($size * 0.05)))
    $g.Dispose()
    $bmp.Save((Join-Path $assets $file), [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}
Save-Icon 32 'favicon-32.png'
Save-Icon 180 'apple-touch-icon.png'
Save-Icon 32 'favicon-af-32.png' 'AF' $night $gold
Save-Icon 180 'apple-touch-icon-af.png' 'AF' $night $gold

Write-Output "Wrote og-image.png, og-amator-fortuna.png and the LL / AF icons to $assets"
