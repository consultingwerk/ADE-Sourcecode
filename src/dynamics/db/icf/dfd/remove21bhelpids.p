/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* This fix program removes 2.1B help ids that have object ids
   that clash with 10.x help ids  */

DEFINE VARIABLE cError        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectIdList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iNum          AS INTEGER    NO-UNDO.

  cObjectIdList = '363.769200000,17628.549800000,17632.549800000':U.

  PUBLISH 'DCU_WriteLog':U ('Removing 2.1B help ids with object ids clashes in 10.x.':U).

  DO iNum = 1 TO NUM-ENTRIES(cObjectIdList):
    FIND gsm_help WHERE gsm_help.help_obj = DECIMAL(ENTRY(iNum,cObjectIdList)) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE gsm_help THEN
    DO:
      cMessage = 'Help context record removed for ':U + 
                 gsm_help.help_container_filename + ' with Object ID = ':U + STRING(gsm_help.help_obj).
      DELETE gsm_help NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
        PUBLISH 'DCU_WriteLog':U (cMessage).
    END.
      
  END.
  
  PUBLISH 'DCU_WriteLog':U ('Removal of 2.1B help ids complete.':U).
     
  RETURN.  

    
