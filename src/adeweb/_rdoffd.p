&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------
File: _rdoffd.p

Description:
    Read the contents of an HTML offset file at design time and create _HTM
    temp-table records.  

Input Parameters:
    p_proc-id:   RECID of the associated file _P record
    p_offset:    Name of offset file to open.

Output Parameters:
   <None>

Author: D.M.Adams

Date Created:  June 1996     

Modified:
 wood  2/3/97   Converted to 2mars (from v1 adeweb/_rdoffd.p)
 wood  2/14/97  Added checks to verify all correct sections exist in the file.
 adams 12/10/97 Converted to 9.0a AppBuilder
---------------------------------------------------------------------------- */


DEFINE INPUT  PARAMETER p_proc-id   AS INTEGER   NO-UNDO. /* RECID of _P for .w  */
DEFINE INPUT  PARAMETER p_offset    AS CHARACTER NO-UNDO. /* name of offset file */

/* Shared variables --                                                     */
{ adeweb/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.              */
{ adeuib/sharvars.i }     
{ adeuib/uniwidg.i }      /* Universal Widget TEMP-TABLE definition        */

/* Local variables --                                                        */
DEFINE VARIABLE b-scrap     AS CHARACTER           NO-UNDO. /* scrap */
DEFINE VARIABLE html-file   AS CHARACTER           NO-UNDO.            
DEFINE VARIABLE icnt        AS INTEGER             NO-UNDO.  
DEFINE VARIABLE last-order  AS INTEGER             NO-UNDO.  
DEFINE VARIABLE file-path   AS CHARACTER           NO-UNDO. /* .off path base */
DEFINE VARIABLE find-file   AS CHARACTER           NO-UNDO. /* .off path */
DEFINE VARIABLE l-scrap     AS LOGICAL             NO-UNDO. /* scrap */
DEFINE VARIABLE off-token   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE off-value   AS CHARACTER           NO-UNDO.

/* Use this to turn debugging on after each line that is read in. 
   (i.e. rename no-DEBUG  to DEBUG) */
&SCOPED-DEFINE no-debug PUT UNFORMATTED off-token SPACE off-value "<BR>".

DEFINE STREAM _inp_line.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***************************  Main Block  *************************** */
FIND _P WHERE RECID(_P) eq p_proc-id.

/* Look for offset file and generate it if not found.  For remote Web objects,
   we have already retrieved the offset file into a local temp-file. */
IF NOT _remote_file THEN 
  /*RUN webutil/_offsrch.p (_P._html-file, _P._fullpath, OUTPUT offset-file).*/
  RUN webutil/_offsrch.p (_P._html-file, _P._save-as-file, INPUT-OUTPUT p_offset).

IF p_offset = ? THEN DO:
  MESSAGE SUBSTITUTE("The offset file &1 was not found and could not be regenerated. [_rdoffd.p]",p_offset)
    VIEW-AS ALERT-BOX ERROR.
  RETURN "Error":U.
END.

INPUT STREAM _inp_line FROM VALUE(p_offset) NO-ECHO.

/* Repeat the following block for each offset line. */
main-loop:
REPEAT:
  ASSIGN 
    off-token = ""
    off-value = "".
    
  IMPORT STREAM _inp_line off-token off-value.
  
  IF off-token = "version=":U THEN DO: /* version mismatch */
    /* put error processing here */
    NEXT main-loop.
  END.
  
  IF NOT off-token MATCHES "field[*]=":U THEN NEXT main-loop.
  
  FIND FIRST _HTM WHERE _HTM._P-recid  eq RECID(_P) 
                    AND _HTM._HTM-NAME eq ENTRY(1,off-value) NO-ERROR.
  IF NOT AVAILABLE _HTM THEN DO:
    CREATE _HTM.
    ASSIGN
      _HTM._P-recid   = RECID(_P)
      _HTM._HTM-NAME  = ENTRY(1,off-value)
      _HTM._HTM-TAG   = ENTRY(2,off-value)
      _HTM._HTM-TYPE  = ENTRY(3,off-value)
      _HTM._MDT-TYPE  = ENTRY(4,off-value)
      _HTM._i-order   = last-order + 1
      last-order      = _HTM._i-order.
  END. /* IF NOT AVAILABLE _HTM... */
  ELSE DO:
    /* It is available -- assume it is either a SELECT or RADIO-SET.
       Make a second entry in the MDT-TYPE that has an X for each
       item in the set. */
    IF NUM-ENTRIES (_HTM._MDT-TYPE, CHR(10)) < 2
    THEN _HTM._MDT-TYPE = _HTM._MDT-TYPE + CHR(10) + "xx":U.
    ELSE _HTM._MDT-TYPE = _HTM._MDT-TYPE + "x":U.
  END. /* IF AVAILABLE _HTM... */
END.  /* main-loop */

/* Used for V2
/* This is going to be an HTML mapping file. Make sure all the correct
   sections exist and flags are set. */
IF last-order > 0 THEN RUN workshop/_set-map.p (INPUT p_proc-id).
*/

/* Explicitly close the file -- there were reports of some applications not  
   "seeing" recently created .off files. Close the files so they will be 
   visible to the file system. */
INPUT STREAM _inp_line CLOSE.
IF _remote_file THEN
  OS-DELETE VALUE(p_offset).
  
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _rdoffd.p - end of file */
