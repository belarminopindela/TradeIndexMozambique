* Encoding: UTF-8.
* Read commodities that shall use external source instead of customs data for Export.
DATASET CLOSE ALL.
GET DATA
  /TYPE=XLSX
  /FILE='cat\Use_external_source.xlsx'
  /SHEET=name Export
  /CELLRANGE=FULL
  /READNAMES=ON.
EXECUTE.
ALTER TYPE comno (A9).
SELECT IF (comno NE '').
SORT CASES BY comno.
SAVE OUTFILE='data\Use_external_source_Export.sav'.




* Read commodities that shall use external source instead of customs data for Import.
DATASET CLOSE ALL.
GET DATA
  /TYPE=XLSX
  /FILE='cat\Use_external_source.xlsx'
  /SHEET=name Import
  /CELLRANGE=FULL
  /READNAMES=ON.
EXECUTE.
ALTER TYPE comno (A9).
SELECT IF (comno NE '').
SORT CASES BY comno.
SAVE OUTFILE='data\Use_external_source_Import.sav'.

