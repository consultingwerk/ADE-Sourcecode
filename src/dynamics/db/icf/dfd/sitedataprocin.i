/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
{db/icf/dfd/sitedatahdrin.i}

DEFINE VARIABLE cFileName   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iLineNo     AS INTEGER     NO-UNDO.
DEFINE TEMP-TABLE tt_{&InputTable} LIKE {&InputTable}.


FIND ttDumpFileLocation 
  WHERE ttDumpFileLocation.cDumpFile = {&InputFile}
  NO-ERROR.

IF NOT AVAILABLE(ttDumpFileLocation) OR
   ttDumpFileLocation.cDumpFilePath = ? THEN
  RETURN.

IF SEARCH(ttDumpFileLocation.cDumpFilePath) = ? THEN
DO:
  PUBLISH "DCU_WriteLog":U ("WARNING: Import file not found: " + ttDumpFileLocation.cDumpFilePath).
  RETURN.
END.
ELSE
DO:
  PUBLISH "DCU_WriteLog":U ("Reading data from: " + ttDumpFileLocation.cDumpFilePath).
END.

INPUT FROM VALUE(ttDumpFileLocation.cDumpFilePath).

REPEAT:
  CREATE tt_{&InputTable}.
  IMPORT tt_{&InputTable}.
  iLineNo = iLineNo + 1.
  RUN applyRecord 
    (INPUT iLineNo,
     BUFFER tt_{&InputTable}).

  DELETE tt_{&InputTable}.
END.

INPUT CLOSE.
PUBLISH "DCU_WriteLog":U ("Finished reading data from: " + ttDumpFileLocation.cDumpFilePath).
