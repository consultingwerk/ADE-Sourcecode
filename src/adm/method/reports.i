&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : reports.i
    Purpose     : Asks as an interface between a PROGRESS Report Builder
                  library and a SmartObject.
    Description :

    Author(s)   : Rich Kuzyk
    Created     : April 1996
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE v-library       AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-report        AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-printer       AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-copies        AS INTEGER   NO-UNDO.
DEFINE VARIABLE v-pagebeg       AS INTEGER   NO-UNDO.
DEFINE VARIABLE v-pageend       AS INTEGER   NO-UNDO.
DEFINE VARIABLE v-outputfile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-batch         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE v-status        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE v-connect       AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-printerprompt AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-printername   AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-include       AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-filter        AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-get-report-parameters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-report-parameters Method-Library 
PROCEDURE get-report-parameters :
/*------------------------------------------------------------------------------
  Purpose:     This procedure copies the attributes needed to setup a 
               report into variables defined in the definition section
               of this method library. 
                     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  
    RUN get-attribute IN THIS-PROCEDURE ('Report-Library':U).
    IF RETURN-VALUE NE ? 
        THEN v-library = RETURN-VALUE.

    RUN get-attribute IN THIS-PROCEDURE ('Printer':U).
    IF RETURN-VALUE NE ? 
        THEN v-printer = RETURN-VALUE.

    RUN get-attribute IN THIS-PROCEDURE ('Include':U).
    IF RETURN-VALUE NE ? 
        THEN v-include = RETURN-VALUE.

    RUN get-attribute IN THIS-PROCEDURE ('Filter':U).
    IF RETURN-VALUE NE ? 
        THEN v-filter = RETURN-VALUE.

    RUN get-attribute IN THIS-PROCEDURE ('Copies':U).
    IF RETURN-VALUE NE ? 
        THEN v-copies = INTEGER(RETURN-VALUE).

    RUN get-attribute IN THIS-PROCEDURE ('BegPage':U).
    IF RETURN-VALUE NE ? 
        THEN v-pagebeg = INTEGER(RETURN-VALUE).

    RUN get-attribute IN THIS-PROCEDURE ('EndPage':U).
    IF RETURN-VALUE NE ? 
        THEN v-pageend = INTEGER(RETURN-VALUE).

    RUN get-attribute IN THIS-PROCEDURE ('Display-Errors':U).
    IF RETURN-VALUE NE ? 
        THEN v-batch = (RETURN-VALUE eq "YES":U).

    RUN get-attribute IN THIS-PROCEDURE ('Display-Status':U).
    IF RETURN-VALUE NE ? 
        THEN v-status = (RETURN-VALUE eq "YES":U).

    RUN get-attribute IN THIS-PROCEDURE ('Printer-Prompt':U).
    IF RETURN-VALUE EQ "YES" AND v-printer = " " 
        THEN v-printername = "?".
        ELSE v-printername = "".

    RUN get-attribute IN THIS-PROCEDURE ('Connect':U).
    IF RETURN-VALUE NE ? 
        THEN v-connect = RETURN-VALUE.
       
    RUN get-attribute IN THIS-PROCEDURE ('OutputFile':U).
    IF RETURN-VALUE NE ? 
        THEN v-OutputFile = RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-run-report) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-report Method-Library 
PROCEDURE run-report :
/*------------------------------------------------------------------------------
  Purpose:     This procedure submits the report chosen in the combo box
               with the appropriate parameters.                      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  run aderb/_printrb.p (
             v-library,                     /* RB-REPORT-LIBRARY    */
             v-report,                      /* RB-REPORT-NAME       */
             v-connect,                     /* RB-DB-CONNECTION     */
             v-include,                     /* RB-INCLUDE-RECORDS   */
             v-filter,                      /* RB-FILTER            */
             "",                            /* RB-MEMO-FILE         */
             v-printer,                     /* RB-PRINT-DESTINATION */
             v-printername,                 /* RB-PRINTER-NAME      */
             "",                            /* RB-PRINTER-PORT      */
             v-OutputFile,                  /* RB-OUTPUT-FILE       */
             v-Copies,                      /* RB-NUMBER-COPIES     */
             v-pagebeg,                     /* RB-BEGIN-PAGE        */
             v-pageend,                     /* RB-END-PAGE          */
             FALSE,                         /* RB-TEST-PATTERN      */
             v-report,                      /* RB-WINDOW-TITLE      */
             v-batch,                       /* RB-DISPLAY-ERRORS    */
             v-status,                      /* RB-DISPLAY-STATUS    */
             FALSE,                         /* RB-NO-WAIT           */
             ""                             /* RB-OTHER-PARAMETERS  */
             ). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

