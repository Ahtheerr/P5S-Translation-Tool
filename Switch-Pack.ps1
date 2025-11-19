# LINKDATA Handling
python .\Main\ImportXLSX.py "Translation_Switch.XLSX"  "Main\Switch\CSV"
$files = Get-Childitem -Force "Main\Switch\CSV\*.csv"
$files | ForEach-Object -Parallel {.\Main\P5SLDT.exe -csv $_.FullName} -ThrottleLimit 5
if (Test-Path "Main\Switch\DAT\"){
 	Remove-Item -Path "Main\Switch\DAT\*.dat"
}
Move-Item -Path "Main\Switch\CSV\*.dat" -Destination "Main\Switch\DAT\"
Copy-Item -Path "Main\Switch\LINKDATA\LINKDATA.BIN" -Destination "Output\Switch\data\pd_west\LINKDATA.BIN"
Copy-Item -Path "Main\Switch\LINKDATA\LINKDATA.IDX" -Destination "Output\Switch\data\pd_west\LINKDATA.IDX"
$files = Get-Childitem -Force "Main\Switch\DAT\*.dat"
foreach ($file in $files) {.\Main\P5SLDT.exe -linkdata $file "Output\Switch\data\pd_west\LINKDATA.IDX"}
# LINKDATA Handling

# Texture Handling
$files = Get-Childitem -Force "Main\Switch\Textures\G1T\*" -Directory
$files | ForEach-Object -Parallel {.\Main\gust_g1t.exe $_.FullName} -ThrottleLimit 5
Remove-Item -Path "Output\Switch\data\motor_rsc\data\*.file"
Get-ChildItem -Path "Main\Switch\Textures\G1T\*.g1t" -File | ForEach-Object {
    # Dentro do loop, $_ é o arquivo atual (ex: A.g1t)
    
    # 1. Constrói o novo caminho usando interpolação e o BaseName do arquivo atual.
    $NewDestination = "Output\Switch\data\motor_rsc\data\0x$($_.BaseName).file"
    
    # 2. Executa o Move-Item para o arquivo ATUAL ($_.FullName) para o destino ÚNICO.
    Move-Item -Path $_.FullName -Destination $NewDestination
}
Copy-Item "Main\Switch\Textures\ScreenLayout.rdb" "Output\Switch\data\motor_rsc\ScreenLayout.rdb"
.\Main\rdb_tool.exe "Output\Switch\data\motor_rsc\ScreenLayout.rdb" "Output\Switch\data\motor_rsc\ScreenLayout.rdb"
# Texture Handling