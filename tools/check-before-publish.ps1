# Pre-publish gate: fails while any placeholder or unconfirmed draft is left in the site.
#   powershell -ExecutionPolicy Bypass -File tools\check-before-publish.ps1
$root = Split-Path $PSScriptRoot -Parent
$files = Get-ChildItem $root -Recurse -Include *.html, *.xml, *.txt -File |
    Where-Object { $_.FullName -notmatch '\\(tools|\.git)\\' }

$patterns = @(
    @{ Label = 'TODO placeholder';        Regex = 'TODO' },
    @{ Label = 'unconfirmed draft text';  Regex = 'class="[^"]*\bdraft\b' },
    @{ Label = 'verification comment';    Regex = 'paste the tag each service gives you' }
)

$problems = 0
foreach ($f in $files) {
    $lines = [System.IO.File]::ReadAllLines($f.FullName)
    for ($i = 0; $i -lt $lines.Length; $i++) {
        foreach ($p in $patterns) {
            if ($lines[$i] -match $p.Regex) {
                $problems++
                $rel = $f.FullName.Substring($root.Length + 1)
                Write-Output ("{0}:{1}  [{2}]  {3}" -f $rel, ($i + 1), $p.Label, $lines[$i].Trim())
            }
        }
    }
}

# The structured data must still be valid JSON after editing.
$html = [System.IO.File]::ReadAllText((Join-Path $root 'index.html'))
$m = [regex]::Match($html, '<script type="application/ld\+json">(.*?)</script>', 'Singleline')
try { $null = $m.Groups[1].Value | ConvertFrom-Json -ErrorAction Stop }
catch { $problems++; Write-Output "index.html  [JSON-LD]  structured data is not valid JSON: $($_.Exception.Message)" }

if ($problems -gt 0) {
    Write-Output ""
    Write-Output "NOT READY: $problems item(s) to resolve before publishing."
    exit 1
}
Write-Output "READY: no placeholders, drafts or JSON errors found."
