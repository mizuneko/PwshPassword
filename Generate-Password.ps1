function Generate-Password {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [int]$PasswordLength = 10,

        [Parameter(Mandatory=$false)]
        [Alias('L')]
        [switch]$UseLowercase = $false,

        [Parameter(Mandatory=$false)]
        [Alias('U')]
        [switch]$UseUppercase = $true,

        [Parameter(Mandatory=$false)]
        [Alias('N')]
        [switch]$UseNumbers = $false,

        [Parameter(Mandatory=$false)]
        [Alias('S')]
        [switch]$UseSymbols = $false
    )

    # パスワードに使用する文字をそれぞれ設定します
    $Lowercase = if ($UseLowercase) { if ($UseUppercase -or $UseNumbers) { 'abcdefghijkmnpqrstuvwxyz' } else { 'abcdefghijklmnopqrstuvwxyz' } } else { '' } # 'l' and 'o' are removed
    $Uppercase = if ($UseUppercase) { if ($UseLowercase -or $UseNumbers) { 'ABCDEFGHJKLMNPQRSTUVWXYZ' } else { 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' } } else { '' } # 'I' and 'O' are removed
    $Numbers = if ($UseNumbers) { '0123456789' } else { '' }
    $Symbols = if ($UseSymbols) { '@#$%&*!?' } else { '' }

    # それぞれの文字列を結合します
    $PasswordChars = $Lowercase + $Uppercase + $Numbers + $Symbols

    # ランダムなパスワードを生成します
    $Password = ''
    if ($UseLowercase) {
        $Password += $Lowercase[(Get-Random -Maximum $Lowercase.Length)]
    }
    if ($UseUppercase) {
        $Password += $Uppercase[(Get-Random -Maximum $Uppercase.Length)]
    }
    if ($UseNumbers) {
        $Password += $Numbers[(Get-Random -Maximum $Numbers.Length)]
    }
    if ($UseSymbols) {
        $Password += $Symbols[(Get-Random -Maximum $Symbols.Length)]
    }
    for ($i = $Password.Length; $i -lt $PasswordLength; $i++) {
        $Password += $PasswordChars[(Get-Random -Maximum $PasswordChars.Length)]
    }

    # パスワードをシャッフルします
    $Password = -join ($Password.ToCharArray() | Sort-Object {Get-Random})

    # パスワードをクリップボードにコピーします
    Set-Clipboard -Value $Password

    # パスワードを返します
    return $Password
}
