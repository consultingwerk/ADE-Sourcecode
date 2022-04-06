/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: adetran/common/_bkupres.p

  Description: Manages probkup and prorest operations for TranMan
  
  Input Parameters:
      p-Action (char)   - "PROBKUP" or "PROREST"
      p-kitName (char)  - name of kit database to create or operate on
  Output Parameters:
      p-status (log)    - Success or failure of operation

  Author: SLK
  Created: 7/20/98
------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-action      AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER p-kitname     AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER p-bkupExt     AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER p-status      AS LOGICAL              NO-UNDO.

DEFINE VARIABLE fExt                  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE KitFile               AS CHARACTER            NO-UNDO.
DEFINE VARIABLE KitFileBase           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE l-action              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE tmpFile               AS CHARACTER            NO-UNDO.

ASSIGN p-status = TRUE.
IF LOOKUP(p-Action,"probkup,prorest":U) <> 0 THEN 
DO: 
   /* PROBKUP <dbname> <device-name>
    * PROREST <dbname> <device-name>
    */

   IF p-Action = "probkup":U THEN
   DO:
      ASSIGN file-info:filename = p-kitname.
      RUN adecomm/_osfext.p (INPUT p-kitname,
                             OUTPUT fExt).
      ASSIGN 
         KitFile     = file-info:full-pathname
         KitFileBase = SUBSTRING(KitFile,1,LENGTH(KitFile) - LENGTH(fExt))
         l-action    = p-Action + " ":U
                        + KitFileBase + " ":U + KitFileBase + p-bkUpExt
         tmpFile     = KitFile + p-bkupExt.
   END. /* probkup */
   ELSE
   DO:
      ASSIGN 
         KitFileBase = p-kitname
         l-action    = p-Action + " ":U
                        + KitFileBase + " ":U + KitFileBase + p-bkUpExt
         tmpFile     = KitFile + p-bkupExt.
   END.

   IF l-action <> ? AND l-action <> "":U THEN 
   DO:
      OS-COMMAND SILENT VALUE(l-action).
      IF p-Action = "prorest":U AND SEARCH(tmpFile) <> ? THEN OS-DELETE VALUE(tmpFile).
   END.
   ELSE
      p-status = FALSE.
END.
ELSE 
   p-status = FALSE.
