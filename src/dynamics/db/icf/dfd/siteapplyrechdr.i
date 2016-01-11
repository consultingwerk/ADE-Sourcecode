/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
PROCEDURE applyRecord:
  DEFINE INPUT  PARAMETER piLineNo AS INTEGER     NO-UNDO.
  DEFINE PARAMETER BUFFER tt_{&InputTable} FOR tt_{&InputTable}.

  FIND FIRST {&InputTable}
    WHERE {&InputTable}.{&ObjField} = tt_{&InputTable}.{&ObjField}
    NO-ERROR.

  /* Anything that was applied because of the ADOs should stay. */
  IF AVAILABLE({&InputTable}) THEN
  DO:
    PUBLISH "DCU_WriteLog":U 
      ( SUBSTITUTE("Line no: &1 - Record ignored because it exists", STRING(piLineNo))).
    RETURN.
  END.


