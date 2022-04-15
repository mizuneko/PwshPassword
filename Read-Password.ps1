function Pause {
    Write-Host "続行するには何かキーを押してください . . ." -NoNewLine
    [Console]::ReadKey($true) | Out-Null
    Write-Host
}

function Read-Password
{
    Clear-Host
    Write-Host "パスワード管理【読込】"
    $curdir = Join-Path $HOME Password
    Get-ChildItem $curdir -Directory | Format-Wide Name -AutoSize
    while ($Site.Length -eq 0) {
        $Site = Read-Host "サイトを入力してください。"
        $savedir = Join-Path $HOME Password $Site
        if ((Test-Path -Path $savedir) -eq $false) {
            Write-Host ("指定されたサイトは存在しません。")
            $Site = $null
        }
    }
    
    Write-Host ("IDを選択してください。")
    $Ident = (Get-ChildItem $savedir -File).Basename | Show-Menu
    if ($Ident.Length -ne 0) {    
        $filename = $Ident + ".dat"
        $savepath = Join-Path $savedir $filename   
    } else {
        while ($Ident.Length -eq 0) {
            $Ident = Read-Host "IDを入力してください。"
            $filename = $Ident + ".dat"
            $savepath = Join-Path $savedir $filename
            if ((Test-Path -Path $savepath) -eq $false) {
                Write-Host ("指定されたIDは存在しません。")
                $Ident = $null
            }
        }
    }

    #暗号化で使用したバイト配列を用意
    [byte[]] $EncryptedKey = (115,65,182,118,230,229,156,76,142,220,152,32,237,3,176,149,46,167,138,223,49,151,206,215)

    try {
        #暗号化された標準文字列をインポートしてSecureStringに変換
        $importSecureString = Get-Content $savepath | ConvertTo-SecureString -key $EncryptedKey

        #SecureStringから文字列を取り出すおまじない
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($importSecureString)
        $StringPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)

        Set-Clipboard $StringPassword
        Write-Host ($Ident)
        Write-Host ('コピー完了: ' + $StringPassword)
        $modifier = [ConsoleModifiers]::Control
        # Pause
    } catch {
        Write-Output ('Error message is ' + $_.Exception.Message)
    }
}