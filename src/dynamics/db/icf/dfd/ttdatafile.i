
DEFINE TEMP-TABLE ttDataFile NO-UNDO
  FIELD iProgNo   AS INTEGER
  FIELD cDataFile AS CHARACTER
  FIELD cDataFilePath AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    iProgNo
    cDataFile
  INDEX dx 
    cDataFile
  .
  
