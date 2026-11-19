$port = 8080
$folder = "C:\Users\hp\OneDrive\Desktop\Documents\ChatGPT\foundation"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Output "Fast server running on http://localhost:$port/"

$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".apk"  = "application/vnd.android.package-archive"
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $response.AddHeader("Access-Control-Allow-Origin", "*")
        $response.AddHeader("Access-Control-Allow-Methods", "GET, POST, HEAD, OPTIONS")
        $response.AddHeader("Access-Control-Allow-Headers", "*")

        if ($request.HttpMethod -eq "OPTIONS") {
            $response.StatusCode = 200
            $response.OutputStream.Close()
            continue
        }

        $urlPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($urlPath) -or $urlPath -eq "/") {
            $urlPath = "index.html"
        }

        $filePath = Join-Path $folder $urlPath

        if (Test-Path $filePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $mime = $mimeTypes[$ext]
            if (-not $mime) { $mime = "application/octet-stream" }
            $response.ContentType = $mime

            if ($ext -eq ".apk") {
                $response.AddHeader("Content-Disposition", 'attachment; filename="Foundation-Tutorials-Patiala.apk"')
            }

            $fileInfo = New-Object System.IO.FileInfo($filePath)
            $response.ContentLength64 = $fileInfo.Length

            if ($request.HttpMethod -ne "HEAD") {
                $fileStream = [System.IO.File]::OpenRead($filePath)
                $fileStream.CopyTo($response.OutputStream)
                $fileStream.Close()
            }
        } else {
            $response.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.ContentLength64 = $msg.Length
            $response.OutputStream.Write($msg, 0, $msg.Length)
        }
        $response.OutputStream.Close()
    } catch {
        # Keep server alive on any error
    }
}
