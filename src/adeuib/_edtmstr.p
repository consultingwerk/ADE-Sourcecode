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
/*----------------------------------------------------------------------------

File: _edtmstr.p

Description: Edits the Master File for a SmartObject (or puts up a message
             if the Master cannot be found).

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: William T. Wood

Date Created: 1 June 1995

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

{adeuib/uniwidg.i}   /* Universal Widget Records */


&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

DEFINE VARIABLE cnt           AS INTEGER NO-UNDO.
DEFINE VARIABLE file-name     AS CHAR    NO-UNDO.
DEFINE VARIABLE file-prfx     AS CHAR    NO-UNDO.
DEFINE VARIABLE file-base     AS CHAR    NO-UNDO.
DEFINE VARIABLE file-ext      AS CHAR    NO-UNDO.
DEFINE VARIABLE lEditMaster   AS LOGICAL NO-UNDO.
DEFINE VARIABLE src-file      AS CHAR    NO-UNDO.

/* Find the information about this SmartObject. */
FIND _U       WHERE RECID(_U)       eq uRecId.
FIND _S       WHERE RECID(_S)       eq _U._x-recid.

/* Assume the master can be editted. */
ASSIGN lEditMaster = yes
       file-name   = _S._FILE-NAME.

/* Break the file name into its component parts. For example:
    c:\bin.win\gui\test.r => file-prfx "c:\bin.win\gui\",  file-base "test.r"
                             file-ext  "r" 
 */
RUN adecomm/_osprefx.p (INPUT file-name, OUTPUT file-prfx, OUTPUT file-base).
ASSIGN cnt      = NUM-ENTRIES(file-base, ".")
       file-ext = IF cnt < 2 THEN "" ELSE ENTRY(cnt, file-base, "." ).

/* Look for a related .w file if the user asked for a .r.  We will use
   this to Edit the Master. */
IF file-ext eq "r" THEN DO:
  /* Replace the .r at the end of the file name. */
  ASSIGN file-name = file-base
         ENTRY(cnt, file-name, ".") = "w"
         file-name = file-prfx + file-name.
  IF SEARCH(file-name) eq ? THEN lEditMaster = no.
END.
/* Otherwise, just look for the file. */
ELSE DO:
  IF SEARCH(file-name) eq ? THEN lEditMaster = no.
END.

/* Does the source exist in the DLC/src directory? */
IF (REPLACE(file-prfx, "~\":U, "~/") eq "adm/objects/":U) OR (REPLACE(file-prfx, "~\":U, "~/") EQ "adm2/":U)
THEN DO: src-file = SEARCH("src/":U + file-name).
END.
ELSE src-file = ?.


/* Open the window for the SmartObject if we can find it. Otherwise
   report an error if we cannot edit the master. */
IF lEditMaster THEN RUN adeuib/_open-w.p (file-name, "", "WINDOW").
ELSE MESSAGE "Source code for this SmartObject could not be found." SKIP(1)       
             "You cannot edit the master until you move a copy of the " {&SKP}
             "source file (i.e. " + file-name + ") into your PROPATH." +
             (IF src-file ne ? 
              THEN CHR(10) + CHR(10) +
                   "[Note: The source code for this built-in PROGRESS object " +
                   &IF "{&WINDOW-SYSTEM}" eq "OSF/Motif":U &THEN CHR(10) + &ENDIF
                   "can be found in " + src-file + ".]"
              ELSE "")
             VIEW-AS ALERT-BOX ERROR.
