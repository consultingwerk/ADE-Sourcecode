/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
