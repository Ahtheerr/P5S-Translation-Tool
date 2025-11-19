# LINKDATA Handling
python .\Main\ImportXLSX.py "Translation_PC.XLSX" "Main\PC\CSV"
$files = Get-Childitem -Force "Main\PC\CSV\*.csv"
$files | ForEach-Object -Parallel {.\Main\P5SLDT.exe -csv $_.FullName} -ThrottleLimit 5
if (Test-Path "Main\PC\DAT\"){
 	Remove-Item -Path "Main\PC\DAT\*.dat"
}
Move-Item -Path "Main\PC\CSV\*.dat" -Destination "Main\PC\DAT\"
Copy-Item -Path "Main\PC\LINKDATA\LINKDATA.BIN" -Destination "Output\PC\update\data\pd_ww\LINKDATA.BIN"
Copy-Item -Path "Main\PC\LINKDATA\LINKDATA.IDX" -Destination "Output\PC\update\data\pd_ww\LINKDATA.IDX"
$files = Get-Childitem -Force "Main\PC\DAT\*.dat"
foreach ($file in $files) {.\Main\P5SLDT.exe -linkdata $file "Output\PC\update\data\pd_ww\LINKDATA.IDX" -enc}
# LINKDATA Handling

# Texture Handling
$files = Get-Childitem -Force "Main\PC\Textures\G1T\*" -Directory
$files | ForEach-Object -Parallel {.\Main\gust_g1t.exe $_.FullName} -ThrottleLimit 5
Remove-Item -Path "Output\PC\update\data\motor_rsc\data\*.file"
Get-ChildItem -Path "Main\PC\Textures\G1T\*.g1t" -File | ForEach-Object {
    # Dentro do loop, $_ é o arquivo atual (ex: A.g1t)
    
    # 1. Constrói o novo caminho usando interpolação e o BaseName do arquivo atual.
    $NewDestination = "Output\PC\update\data\motor_rsc\data\0x$($_.BaseName).file"
    
    # 2. Executa o Move-Item para o arquivo ATUAL ($_.FullName) para o destino ÚNICO.
    Move-Item -Path $_.FullName -Destination $NewDestination
}
Copy-Item "Main\PC\Textures\ScreenLayout.rdb" "Output\PC\update\data\motor_rsc\ScreenLayout.rdb"
.\Main\rdb_tool.exe "Output\PC\update\data\motor_rsc\ScreenLayout.rdb" "Output\PC\update\data\motor_rsc\ScreenLayout.rdb"
# Texture Handling