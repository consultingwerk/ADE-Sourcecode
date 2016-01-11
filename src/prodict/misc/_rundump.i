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

/* _rundump.i - Data Dictionary file dump module */
DEFINE SHARED STREAM   dump.
DEFINE SHARED VARIABLE recs AS DECIMAL FORMAT "ZZZZZZZZZZZZ9" NO-UNDO.
DEFINE SHARED VARIABLE xpos AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE ypos AS INTEGER NO-UNDO.

/* Will be "y" or "n" */
DEFINE INPUT PARAMETER p_Disable AS CHARACTER NO-UNDO.

DEFINE VARIABLE i AS INTEGER NO-UNDO.


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  IF TERMINAL <> "" THEN DO:
    DEFINE STREAM run_dump.
    OUTPUT STREAM run_dump TO TERMINAL.

  END.
&ENDIF
IF p_Disable  = "y" THEN
  DISABLE TRIGGERS FOR DUMP OF DICTDB2.{1}.
recs = 0.


for each DICTDB2.{1} {2}:

  assign recs = recs + 1.
  export stream dump DICTDB2.{1}.
  
  if   terminal       <> ""
   and recs modulo 100 = 0
   then do:  /* */
    
    end.
  end.  /* for each DICTDB2.{1} {2} */

RETURN.
