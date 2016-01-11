/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*
   FILE: prodict/pro/fldfuncs.i
   
   Description:
     Include file containing functions for use in the Data Dictionary
     Field Properties dialogs.
     
   Created: March 3, 2005  K. McIntosh
   History: 
--------------------------------------------------------------------------- */

/*------------------------------Functions-----------------------------------*/    

/*--------------------------------------------------------------------------*/
/* Name: isNumeric                                                          */
/* Purpose: Check a character to determine if it is numeric                 */
/* Return Type: LOGICAL                                                     */
/* Parameters: INPUT pcChar AS CHARACTER - Character to test                */
/* Note:                                                                    */
/*--------------------------------------------------------------------------*/
FUNCTION isNumeric RETURNS LOGICAL
    ( INPUT pcChar AS CHARACTER ):
  RETURN CAN-DO("1,2,3,4,5,6,7,8,9,0",pcChar).
END FUNCTION.

/*--------------------------------------------------------------------------*/
/* Name: badFormat                                                          */
/* Purpose: Check a string to determine if it's format is bad               */
/* Return Type: LOGICAL                                                     */
/* Parameters: INPUT pcDataType AS CHARACTER  - Data-Type of field string is    */
/*                                              intended for                    */
/*             INPUT pcField    AS CHARACTER - _Field Field to test format for */
/*             INPUT pcFormat   AS CHARACTER - Format value                    */
/* Note:       This function returns a value of TRUE if the format is       */
/*             actually bad.                                                */
/*--------------------------------------------------------------------------*/
FUNCTION badFormat RETURNS LOGICAL
     ( INPUT pcDataType AS CHARACTER,
       INPUT pcField    AS CHARACTER,
       INPUT pcFormat   AS CHARACTER ):
  DEFINE VARIABLE iPos      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iLobWdth  AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iLastNum  AS INTEGER     NO-UNDO.
  
  DEFINE VARIABLE lHitAlpha AS LOGICAL     NO-UNDO.
  
  DEFINE VARIABLE cLobType  AS CHARACTER   NO-UNDO.

  CASE pcDataType:
    WHEN "CLOB" OR WHEN "BLOB" THEN DO:
      CASE pcField:
        WHEN "lob-size" THEN DO:
          
          CHK-NUM: /* Check for numbers after the first letter. */
          DO iPos = 1 TO LENGTH(pcFormat):
            IF isNumeric(SUBSTRING(pcFormat,iPos,1)) AND
               NOT lHitAlpha THEN NEXT.
            ELSE IF isNumeric(SUBSTRING(pcFormat,iPos,1)) THEN 
              RETURN TRUE.
            ELSE lHitAlpha = TRUE.
            IF (lHitAlpha = TRUE) AND
               iLastNum = 0 THEN
              iLastNum = iPos - 1.
          END.
          /* If we never hit a letter it's perfectly legitimate. */
          IF NOT lHitAlpha THEN RETURN FALSE.

          /* Make sure that only the supported alpha characters are used. */
          ASSIGN iLobWdth = INTEGER(SUBSTRING(pcFormat,1,iLastNum))
                 cLobType = SUBSTRING(pcFormat,iLastNum + 1).
          IF NOT CAN-DO("B,K,KB,M,MB,G,GB",cLobType) THEN
            RETURN TRUE.

          RETURN FALSE.
        END.
      END CASE.
    END. /* When LOB */
  END CASE.

END FUNCTION. /* badFormat */
