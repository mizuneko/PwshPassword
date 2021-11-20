function Get-SHA256Hash($ClearString)
{
    $hasher = [System.Security.Cryptography.SHA256]::Create()
    $content = [System.Text.Encoding]::UTF8.GetBytes($ClearString)
    $hash = [System.Convert]::ToBase64String($hasher.ComputeHash($content))
    return $hash
}

function Build-Password
{
    param (
        [Parameter(Mandatory=$True)]
        [String]
        $ClearString,
        [ValidateRange(4,20)]
        [Int]
        $Charcter = 10,
        [bool]
        $ForceNumber = $true,
        [bool]
        $ForceSymbol = $true
    )

    $hash = Get-SHA256Hash $ClearString
    $hasNumber = !$ForceNumber
    $hasSymbol = !$ForceSymbol
    $checkLength = 0
    $password = ""

    if ($ForceNumber) {
        $checkLength += 1
    }
    if ($ForceSymbol) {
        $checkLength += 1
    }

    foreach ($hashChar in $hash.ToCharArray()) {
        if ($password.Length -lt ($Charcter - $checkLength)) {
            if ($hashChar -match "[a-zA-Z]") {
                $password += $hashChar
            }
            if ($ForceNumber -And $ForceSymbol) {
                if ($hashChar -match "[0-9]") {
                    $password += $hashChar
                    $hasNumber = $true
                }
                if ($hashChar -match "[!-/:-@\[-\`\{-~]") {
                    $password += $hashChar
                    $hasSymbol = $true
                }
            } elseif ($ForceNumber) {
                if ($hashChar -match "[0-9]") {
                    $password += $hashChar
                    $hasNumber = $true
                }
            } elseif ($ForceSymbol) {
                if ($hashChar -match "[!-/:-@\[-\`\{-~]") {
                    $password += $hashChar
                    $hasSymbol = $true
                }
            }
        } elseif ($hasNumber -And $hasSymbol) {
            if ($hashChar -match "[a-zA-Z]") {
                $password += $hashChar
            }
        } elseif (-Not $hasNumber) {
            if ($hashChar -match "[0-9]") {
                $password += $hashChar
                $hasNumber = $true
            }
        } elseif (-Not $hasSymbol) {
            if ($hashChar -match "[!-/:-@\[-\`\{-~]") {
                $password += $hashChar
                $hasSymbol = $true
            }
        }
        if ($password.Length -eq $Charcter) {
            break
        }
    }

    return $password
}