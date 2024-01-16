
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

[System.IO.File]::WriteAllText($out, $redirect_content)
