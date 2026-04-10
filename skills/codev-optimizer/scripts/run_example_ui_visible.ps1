$len = "D:\WorkSpace\CodeX\CodeV\templates\current\ex_all_02_112002.len"

if (-not (Test-Path -LiteralPath $len)) {
    Write-Error "Lens file not found: $len"
    exit 1
}

Start-Process -FilePath $len
