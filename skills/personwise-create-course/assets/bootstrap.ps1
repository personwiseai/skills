# Generated from the signed PersonWise CLI release model.
# Embedded minisign trust root: RWQxXCGcBkNBLF/3q1BbM7xZmDxbaY53bjJYcruIuTbK5DYVm+Nm1ztO
$ErrorActionPreference = "Stop"
$action = if ($args.Count -eq 1) { $args[0] } else { "" }
if ($action -notin @("--approve-install", "--approve-upgrade", "--approve-rollback")) {
  [Console]::Error.WriteLine('{"schema_version":"1","ok":false,"error":{"code":"INSTALL_APPROVAL_REQUIRED","message":"Explicit user approval is required before installing, upgrading, or rolling back the PersonWise executable.","retryable":false,"action":"obtain_user_approval"},"request_id":"bootstrap-local"}')
  exit 2
}
if (-not [Environment]::Is64BitOperatingSystem) { throw "Unsupported Windows target" }
$nativeSignatureRequired = $false
if ($nativeSignatureRequired -and "deferred-founder-approved" -ne "verified") {
  [Console]::Error.WriteLine('{"schema_version":"1","ok":false,"error":{"code":"NATIVE_SIGNATURE_REQUIRED","message":"This release candidate has not completed Authenticode signing.","retryable":false,"action":"use_verified_release"},"request_id":"bootstrap-local"}')
  exit 9
}
if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) { throw "LOCALAPPDATA is unavailable" }
$targetDir = Join-Path $env:LOCALAPPDATA "PersonWise\bin"
$targetPath = Join-Path $targetDir "personwise.exe"
[IO.Directory]::CreateDirectory($targetDir) | Out-Null
$targetDirInfo = Get-Item -LiteralPath $targetDir -Force
if (($targetDirInfo.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "Install directory must not be a reparse point" }
$upgradeHashes = @("20a0dd088b2b19629899ee775b6bdf5189fe55ddd15765891ce76673169d53bb")
$rollbackHashes = @()
$currentDigest = ""
if (Test-Path -LiteralPath $targetPath) {
  $existing = Get-Item -LiteralPath $targetPath -Force
  if ($action -eq "--approve-install" -or $existing.PSIsContainer -or (($existing.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)) { throw "Install target is occupied by an unrecognized installation and was not changed" }
  $currentDigest = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash.ToLowerInvariant()
  $allowedHashes = if ($action -eq "--approve-upgrade") { $upgradeHashes } else { $rollbackHashes }
  if ($allowedHashes -notcontains $currentDigest) { throw "Existing executable is not recognized by the signed release history and was not changed" }
} elseif ($action -ne "--approve-install") {
  throw "An approved upgrade or rollback requires a recognized existing installation"
}
$workDir = Join-Path $targetDir (".personwise-install." + [Guid]::NewGuid().ToString("N"))
[IO.Directory]::CreateDirectory($workDir) | Out-Null
try {
  $archive = Join-Path $workDir "personwise_1.0.1_windows_amd64.zip"
  Add-Type -AssemblyName System.Net.Http
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $handler = [Net.Http.HttpClientHandler]::new()
  $handler.AllowAutoRedirect = $false
  $client = [Net.Http.HttpClient]::new($handler)
  $client.Timeout = [TimeSpan]::FromSeconds(300)
  $request = [Net.Http.HttpRequestMessage]::new([Net.Http.HttpMethod]::Get, "https://releases.personwise.ai/cli/v1.0.1/personwise_1.0.1_windows_amd64.zip")
  $response = $client.SendAsync($request, [Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
  try {
    if (-not $response.IsSuccessStatusCode) { throw "Artifact download failed" }
    $declaredLength = $response.Content.Headers.ContentLength
    if ($null -ne $declaredLength -and ($declaredLength -ne 3097784 -or $declaredLength -gt 26214400)) { throw "Artifact size mismatch" }
    $inputStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
    $outputStream = [IO.File]::Open($archive, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try {
      $buffer = New-Object byte[] 65536
      [long]$total = 0
      while (($read = $inputStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $total += $read
        if ($total -gt 3097784 -or $total -gt 26214400) { throw "Artifact size limit exceeded during download" }
        $outputStream.Write($buffer, 0, $read)
      }
      if ($total -ne 3097784) { throw "Artifact size mismatch" }
      $outputStream.Flush($true)
    } finally {
      $outputStream.Dispose()
      $inputStream.Dispose()
    }
  } finally {
    $response.Dispose()
    $request.Dispose()
    $client.Dispose()
    $handler.Dispose()
  }
  $file = Get-Item -LiteralPath $archive
  if ($file.Length -ne 3097784 -or $file.Length -gt 26214400) { throw "Artifact size mismatch" }
  $digest = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($digest -ne "c034406675c72fb13a8548e1fc1c0229c3a6e71c61cb7357ca005a2ebda5fa0f") { throw "Artifact checksum mismatch" }
  $extractDir = Join-Path $workDir "extracted"
  Expand-Archive -LiteralPath $archive -DestinationPath $extractDir
  $entries = @(Get-ChildItem -LiteralPath $extractDir -Force -Recurse)
  $binaryEntry = Get-Item -LiteralPath (Join-Path $extractDir "personwise.exe") -Force
  $licenseEntry = Get-Item -LiteralPath (Join-Path $extractDir "LICENSE") -Force
  $noticesEntry = Get-Item -LiteralPath (Join-Path $extractDir "THIRD_PARTY_NOTICES.md") -Force
  if ($entries.Count -ne 3 -or $binaryEntry.PSIsContainer -or $licenseEntry.PSIsContainer -or $noticesEntry.PSIsContainer -or (($binaryEntry.Attributes -bor $licenseEntry.Attributes -bor $noticesEntry.Attributes) -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "Archive contents invalid" }
  $candidate = Join-Path $extractDir "personwise.exe"
  $candidateDigest = (Get-FileHash -LiteralPath $candidate -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($candidateDigest -ne "151375f65df8b82e63ccba55119ad96badfc11437737452f67b1a274f229b4a5") { throw "Release executable checksum mismatch" }
  if ("deferred-founder-approved" -eq "verified") {
    $signature = Get-AuthenticodeSignature -LiteralPath $candidate
    if ($signature.Status -ne "Valid" -or $signature.SignerCertificate.Thumbprint -ne "") { throw "Authenticode verification failed" }
  }
  $currentTargetDirInfo = Get-Item -LiteralPath $targetDir -Force
  if ($currentTargetDirInfo.FullName -ne $targetDirInfo.FullName -or (($currentTargetDirInfo.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)) { throw "Install directory changed during verification" }
  if ($action -eq "--approve-install") {
    [IO.File]::Move($candidate, $targetPath)
  } else {
    $existing = Get-Item -LiteralPath $targetPath -Force
    if ($existing.PSIsContainer -or (($existing.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) -or (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $currentDigest) { throw "Existing installation changed during verification and was not replaced" }
    $backup = Join-Path $workDir "previous-personwise.exe"
    [IO.File]::Replace($candidate, $targetPath, $backup, $true)
    Remove-Item -LiteralPath $backup -Force
  }
  [ordered]@{schema_version="1"; ok=$true; data=[ordered]@{path=[IO.Path]::GetFullPath($targetPath); software_version="1.0.1"; cli_contract_version="1.0"; action=$action}; request_id="bootstrap-local"} | ConvertTo-Json -Compress
} finally {
  if (Test-Path -LiteralPath $workDir) { Remove-Item -LiteralPath $workDir -Recurse -Force }
}
