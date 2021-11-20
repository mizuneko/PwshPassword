function Save-Password
{
    Write-Host "パスワード管理【保存】"
    $Site = Read-Host "サイト名を入力してください。"
    $Ident = Read-Host "IDを入力してください。"
    $filename = $Ident + ".dat"
    $SecureString = Read-Host -AsSecureString "パスワードを入力してください。"

    # 暗号化用のバイト配列を作成(192bit)
    # ※8bitの要素が24個で192bit
    [byte[]] $EncryptedKey = (115,65,182,118,230,229,156,76,142,220,152,32,237,3,176,149,46,167,138,223,49,151,206,215)

    try {
        # SecureStringを暗号化された標準文字列に変換
        $encrypted = ConvertFrom-SecureString -SecureString $SecureString -key $EncryptedKey

        $savedir = Join-Path $HOME Password $Site
        if ((Test-Path $savedir) -eq $false)
        {
            New-Item $savedir -ItemType Directory
        }
        $savepath = Join-Path $savedir $filename
        $encrypted | Out-File $savepath

        Write-Output ('パスワードを保存しました。')
    } catch {
        Write-Output ('Error message is ' + $_.Exception.Message)
    }
}