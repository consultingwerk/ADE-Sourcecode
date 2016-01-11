&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdoffp.p

Description:
    Reads the contents of a _WEB-HTM-OFFSETS code procedure at design time.

Note:
    Called from _cdsread.p when it finds an "htm-offsets" method.

Input Parameters:
    p_proc-id: Context ID of the procedure.

Output Parameters:
    <None>

Author: D.M.Adams

Created: June 1996

Modified: wood  2/3/97  Converted to 2mars (from v1 _rdoffp.p)
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id AS INTEGER NO-UNDO. /* RECID of _P for .w  */

/* Shared variables --                                                       */
{ workshop/errors.i }       /* Error handling procedures                     */
{ workshop/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.              */
{ workshop/objects.i }      /* Web Objects TEMP-TABLE definition             */
{ workshop/sharvars.i }     /* Shared variables                              */
{ workshop/uniwidg.i }      /* Universal Widget TEMP-TABLE definition        */

/* Local variables --                                                        */
DEFINE VARIABLE b-scrap       AS CHARACTER           NO-UNDO. /* scrap */
DEFINE VARIABLE file-name     AS CHARACTER           NO-UNDO. /* */
DEFINE VARIABLE html-file     AS CHARACTER           NO-UNDO.      
DEFINE VARIABLE l-scrap       AS LOGICAL             NO-UNDO. /* scrap */
DEFINE VARIABLE off-record    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE offset-file   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE org-name      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE fld-name      AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VARIABLE tbl-name      AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VARIABLE db-name       AS CHARACTER INITIAL ? NO-UNDO.

/* Standard End-of-line character */
&SCOPED-DEFINE EOL CHR(10)

/* Use this to turn debugging on after each line that is read in. 
   (i.e. rename no-DEBUG  to DEBUG) */
&SCOPED-DEFINE no-debug MESSAGE off-record VIEW-AS ALERT-BOX.

DEFINE SHARED STREAM    _P_QS.
DEFINE SHARED VARIABLE  _inp_line AS CHARACTER EXTENT 100 NO-UNDO.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE GUI

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ***************************  Main Block  *************************** */
/* Get the current procedure file */
FIND _P WHERE RECID(_P) EQ p_proc-id.

/* Repeat the following block for each line in the code block. */
main-loop:
REPEAT:
  ASSIGN off-record = "".
  IMPORT STREAM _P_QS UNFORMATTED off-record. {&debug}
  ASSIGN off-record = TRIM(off-record).

  /* Detect the end of code block. */
  IF off-record BEGINS "END PROCEDURE":u THEN LEAVE main-loop.
  
  /* Load HTML offset file. */
  IF off-record BEGINS "RUN web":u THEN DO:
    
    /* Find the offset file and regenerate if necessary. */
    RUN webutil/_offsrch.p (_P._html-file, _P._fullpath, INPUT-OUTPUT offset-file).
    IF offset-file = ? THEN DO:
      RUN Add-Error IN _err-hdl ("ERROR":U, ?, "The offset file was not successfully generated. [_rdoffp.p]").
      RETURN "Error":U.
    END.
                            
    /* Read the offset file. */
    RUN workshop/_rdoffd.p (INTEGER(RECID(_P)), offset-file).
    IF RETURN-VALUE EQ "Error":U THEN RETURN "Error":U.
    
    NEXT main-loop.
  END. /* RUN web... */
  
  IF NOT off-record BEGINS "(":U THEN NEXT main-loop.
  
  ASSIGN
    db-name     = ?
    tbl-name    = ?
    fld-name    = ?
    off-record  = TRIM(SUBSTRING(off-record,2,-1,"CHARACTER":U),").":U)
    off-record  = REPLACE(REPLACE(off-record,'"':U,''),':U':U,'')
    org-name    = ENTRY(2,off-record)        /* WDT-NAME -jep */
    .

  /* Extract possible db and table names. */
  CASE NUM-ENTRIES(org-name,".":U):
    WHEN 1 THEN 
      ASSIGN 
        fld-name = org-name.
    WHEN 2 THEN 
      ASSIGN 
        tbl-name = ENTRY(1,org-name,".":U)
        fld-name = ENTRY(2,org-name,".":U).
    WHEN 3 THEN 
      ASSIGN 
        db-name  = ENTRY(1,org-name,".":U)
        tbl-name = ENTRY(2,org-name,".":U)
        fld-name = ENTRY(3,org-name,".":U).
  END CASE.
  
  /* Find the _U record with the correct name. */
  FIND _U WHERE _U._P-recid eq p_proc-id
            AND _U._NAME    eq fld-name
            AND _U._TABLE   eq tbl-name 
            AND (IF db-name eq ? THEN true ELSE _U._DBNAME eq db-name) 
            AND LOOKUP(_U._TYPE, "FRAME,QUERY":U) eq 0.

  FIND FIRST _HTM WHERE _HTM._HTM-NAME = ENTRY(1,off-record) 
                    AND _HTM._P-recid EQ RECID(_P) NO-ERROR.
  /* Associate the _HTM record with the _U record. */
  IF AVAILABLE(_HTM) THEN DO:
    _HTM._U-recid = RECID (_U).
    
    /* Check to see if the datatype has changed.  If so, raise error. */
    IF ENTRY(1,_HTM._MDT-TYPE,CHR(10)) <> _U._TYPE THEN DO:
      RUN Add-Error IN _err-hdl ("ERROR":U,?,
        SUBSTITUTE("For the field &1, the HTML datatype (&2) does not match the Web object datatype (&3).", 
                    org-name, LC(_HTM._MDT-TYPE), LC(_U._TYPE))).
      RETURN "Error":U.
    END.
  END.
  ELSE DO:    
    /* ERROR: widget missing in offset file */
    RUN Add-Error IN _err-hdl
      ("WARNING":U, ?,
        SUBSTITUTE("The &1 field was not found in the offset file. It was deleted.",
                   ENTRY(1,off-record))).
      
    /* delete widget */
    RUN workshop/_delet_u.p (INPUT RECID(_U), INPUT TRUE /* Trash */) .
  END.
  
END.  /* main-loop */

/* Look for HTML fields that have no matching Web object field */   
RUN workshop/_drwhtml.p (INPUT p_proc-id, TRUE /* Messages */, OUTPUT l-scrap).

&ANALYZE-RESUME
 
/* _rdoffp.p - end of file */
