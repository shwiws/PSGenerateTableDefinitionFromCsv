cd %~dp0
powershell -File ..\Src\GenerateTableDefinitionFromCsv.ps1 sample.csv

type sample.csv.table.csv