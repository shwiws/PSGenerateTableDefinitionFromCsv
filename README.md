# PSGenerateTableDefinitionFromCsv

CSVを読み込んで各列のSQL Server用の定義候補を生成します。

## 対応データ型

- char
- varchar
- nchar
- nvarchar
- tinyint
- smallint
- int
- bigint
- decimal
- bit

# 実行環境（検証済）

- Windows 10 Pro
- Powershell 5

# デモ

> powershell -File Src\GenerateTableDefinitionFromCsvTest.ps1 -File Sample\sample.csv

このようなCSVから・・・

|"ID"|Namae|Name|Rate|Flag01|FlagTF|
|----|----|----|----|----|----|
|1|"なまえいち"|"name one"|.59|1|True|
|2|"なまえに"|""|1.23|0|False|
|3|"なまえさん"|"name three"||1|true|
|4|"なまえよん"|"name four"|0.4578|1|false|

以下のような候補を出力します。

|Column|Index|Text|Integer|Decimal|Boolean|
|----|----|----|----|----|----|----|
|ID|0|[ID] \[CHAR](1) NOT NULL|[ID] [TINYINT] NOT NULL|||
|Namae|1|[Namae] \[NVARCHAR](10) NOT NULL||||
|Name|2|[Name] \[VARCHAR](10) NULL||||
|Rate|3|[Rate] \[VARCHAR](6) NULL||[Rate] \[DECIMAL](5,4) NULL||
|Flag01|4|[Flag01] \[CHAR](1) NOT NULL|[Flag01] [TINYINT] NOT NULL||[Flag01] [BIT] NOT NULL|
|FlagTF|5|[FlagTF] \[VARCHAR](5) NOT NULL|||[FlagTF] [BIT] NOT NULL|
