function Pause {
    Write-Host "続行するには何かキーを押してください . . ." -NoNewLine
    [Console]::ReadKey($true) | Out-Null
    Write-Host
}

function Get-SHA256Hash {
    param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        $ClearString
    )
    $hasher = [System.Security.Cryptography.SHA256]::Create()
    $content = [System.Text.Encoding]::UTF8.GetBytes($ClearString)
    $hash = [System.Convert]::ToBase64String($hasher.ComputeHash($content))
    Write-Output $hash
}