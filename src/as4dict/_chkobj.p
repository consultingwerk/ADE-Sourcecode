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


/* Procedure as4dict/_Chkobj.p

   Created 12/30/99  D. McMann

   This procedure can be used to check any type of object on the AS/400.
   If a specific error message needs to be issued, then use the obj-type
   to determine when to test.
   
*/   

{as4dict/dictvar.i shared}

DEFINE INPUT PARAMETER  as4-name  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER  lib-name  AS CHARACTER     NO-UNDO.
Define INPUT  PARAMETER p_Win  	  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER  obj-type  AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER okay      AS LOGICAL       NO-UNDO.

IF NOT s_adding THEN
    ASSIGN CURRENT-WINDOW = p_win.

ASSIGN dba_cmd = "CHKOBJ".
  RUN as4dict/_dbaocmd.p 
    (INPUT obj-type, 
	 INPUT CAPS(as4-name),
     INPUT  CAPS(lib-name),
	 INPUT 0,
	 INPUT 0).

  if dba_return <> 1 THEN DO:
    IF dba_return = 9810 THEN
      MESSAGE "The library " + CAPS(lib-name) +
              " does not exist."  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ELSE
       MESSAGE "The object " + CAPS(as4-name) +
              " of type " + obj-type + " does not exist in Library " +
              CAPS(lib-name) + "."
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.               
    ASSIGN okay = FALSE.
    RETURN .
  end.  
  ELSE IF obj-type = "*PGM" AND dba_return = 1 THEN DO:
    FIND FIRST as4dict.p__File WHERE as4dict.p__File._AS4-File =  CAPS(as4-name)
                                 AND as4dict.p__File._AS4-Library = CAPS(Lib-name)
                                 NO-LOCK NO-ERROR.
    IF AVAILABLE as4dict.p__File THEN DO:
      MESSAGE "Procedure " + as4dict.p__File._File-name + " is defined using program " + CAPS(as4-name)  SKIP
              "in Library " + CAPS(lib-name) + ".  Only one stored procedure can be" SKIP
              "defined for a program."  SKIP
              VIEW-AS ALERT-BOX.
      ASSIGN okay = FALSE.
      RETURN.
    END.  
  END.

  ASSIGN okay = TRUE.
  RETURN.
