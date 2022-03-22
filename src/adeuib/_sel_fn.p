/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _sel_fn.p

Description:
    SELECT a File Name to save the _h_win window into using the ADE common
    getfile routine.

Input Parameters:
    p_Title  : The title of the window.
    p_sample : The filename to use as the default.

Output Parameters:
    <None>
   
Side Effects:
    Sets _save_file to the desired file name (or ? if the user clicks cancel).
    The initial value of _save_file is set to the desired filename.

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_Title  AS CHAR   NO-UNDO.
DEFINE INPUT PARAMETER p_Sample AS CHAR   NO-UNDO.

{adeuib/sharvars.i}             /* Shared variables                         */

DEFINE VAR    nment             AS INTEGER                      NO-UNDO.
DEFINE VAR    OK2save           AS LOGICAL                      NO-UNDO.
DEFINE VAR    tmp-strng         AS CHARACTER                    NO-UNDO.
DEFINE VAR    trunc-strng       AS LOGICAL                      NO-UNDO.

/* Get a filename using the adecomm/_getfile.p. */
RUN adecomm/_getfile.p (INPUT CURRENT-WINDOW, "uib", p_Title, p_Title, "SAVE", 
                        INPUT-OUTPUT p_Sample,
                              OUTPUT OK2save).

_save_file = IF OK2save THEN TRIM(p_sample)  ELSE ?.
IF opsys = "unix" THEN DO:
  ASSIGN nment      = NUM-ENTRIES(_save_file,"~/")
         tmp-strng  = ENTRY(1,ENTRY(nment,_save_file,"~/"),"~.").
  IF LENGTH(tmp-strng) > 12 THEN DO:
    MESSAGE "The length of the specified filename (" + tmp-strng + ") is" SKIP
            "greater than 12 characters and cannot be processed by the" SKIP
            "User Interface Builder~'s code analyzer.  " + tmp-strng SKIP
            "is being truncated to " + SUBSTRING(tmp-strng,1,12) + "."
         VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE trunc-strng.
     IF trunc-strng THEN
       ENTRY(nment,_save_file,"~/") = SUBSTRING(tmp-strng,1,12) + "." +
                                      ENTRY(2,ENTRY(nment,_save_file,"~/"),"~.").
     ELSE DO:
        MESSAGE _save_file "not saved." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        _save_file = ?.
     END.
  END.
END.


