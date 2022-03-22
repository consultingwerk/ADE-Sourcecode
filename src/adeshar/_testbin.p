/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _testbin.p

Description:
    Tests, by actually writing, the binary file.
    
Input Parameters:
   ph_win   The handle of the window to be saved.
                  
Output Parameters:
   bStatus The status. 0 is all OK
                       1 file exists, operation cancelled
                       2 problem writing file             
Author: D. Lee

Date Created: 1995

Last Modified: 
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER hWin    AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER bName   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER bStatus AS INTEGER   NO-UNDO INITIAL 1.

{adeuib/pre_proc.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adecomm/adefext.i}

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN

DEFINE VARIABLE s          AS INTEGER   NO-UNDO.
DEFINE VARIABLE modeSave   AS INTEGER   NO-UNDO.
DEFINE VARIABLE ans        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE madeBinary AS LOGICAL   NO-UNDO.    
DEFINE VARIABLE dir_name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE base_name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE err_code   AS INTEGER   NO-UNDO.
DEFINE VARIABLE err_msg    AS CHARACTER  NO-UNDO.

/* Check to see if it already exists. If the name already
 * exists then let the user decide to overwrite.
 */
IF SEARCH(bName) <> ? THEN
DO:
  ASSIGN ans = no.
  MESSAGE bName SKIP
          "The file already exists." SKIP(1)
          "Choose OK to overwrite the file."
          VIEW-AS ALERT-BOX WARNING BUTTONS ok-cancel UPDATE ans.
  IF ans = no THEN
  DO:
    ASSIGN bStatus = 2.
    RETURN.
  END.
END.

/* File doesn't exist. Check to see if the path to the file exists. */
RUN adecomm/_osprefx.p
  (INPUT bName, OUTPUT dir_name, OUTPUT base_name).
IF (dir_name = "") THEN ASSIGN dir_name = ".".

ASSIGN FILE-INFO:FILE-NAME = dir_name.
IF (FILE-INFO:FULL-PATHNAME = ?) THEN
DO:
  ASSIGN ans = no.
  MESSAGE dir_name SKIP
          "Path does not exist." SKIP(1)
          "Choose OK to create the path."
          VIEW-AS ALERT-BOX WARNING BUTTONS ok-cancel UPDATE ans.
  IF ans = no THEN
  DO:
    ASSIGN bStatus = 2.
    RETURN.
  END.
  RUN adecomm/_oscpath.p
      (INPUT  dir_name , OUTPUT err_code ).
  IF err_code <> 0 THEN
  DO:
    RUN adecomm/_oserr.p (OUTPUT err_msg).
    MESSAGE dir_name SKIP
            "Unable to create path." SKIP(1)
            "Path is invalid or you do not have permission to create the path." SKIP(1)
          VIEW-AS ALERT-BOX ERROR.
    ASSIGN bStatus = 2.
    RETURN.
  END.
END.

ASSIGN bStatus = 2.
/*
 * Now write the file. This is the only sure way to make sure that
 * the file can be written
 */
RUN adeshar/_contbin.p
    (INPUT hWin, INPUT "NORMAL":U, INPUT "SAVE":U, INPUT bName,
     OUTPUT madeBinary, OUTPUT s).

IF s <> 1 THEN bStatus = 0. 
    
&ENDIF
