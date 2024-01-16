
$url = $args[0]
$out = $args[1]

$redirect_content = @'
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Redirecting</title>
  <noscript>
    <meta http-equiv="refresh" content="1; url={0}" />
  </noscript>
  <script>
    window.location.href = '{0}';
  </script>
</head>
<body>
  Redirecting to <a href="{0}">{0}</a>
</body>
</html>
'@ -f $url

$out_dir = Split-Path $out -Parent
if (!(Test-Path $out_dir -PathType Container)) {
    New-Item $out_dir -ItemType Directory 1>$null 2>$null
}

[System.IO.File]::WriteAllText($out, $redirect_content)
