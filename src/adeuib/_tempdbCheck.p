&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : adeuib/_TempdbCheck
    Purpose     : Checks that the connected TEMP-DB database contains
                  the control table 'TEMP-DB-CTRL' and loads it if not.

    Syntax      :

    Description :

    Author(s)   : Don Bulua
    Created     : 05/01/2004
    Notes       : Requires A TEMP-DB connection
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF DEFINED(UIB_is_Running) = 0 &THEN
  DEFINE OUTPUT PARAMETER plok AS LOGICAL NO-UNDO .
&ELSE
  DEFINE VARIABLE plOK    AS LOGICAL   NO-UNDO .
&ENDIF

DEFINE VARIABLE lChoice     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWindow     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hOrigWindow AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


 FIND TEMP-DB._db WHERE TEMP-DB._db._db-name = ? 
                    AND TEMP-DB._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
 IF NOT AVAIL TEMP-DB._db THEN
     RETURN "ERROR":U.

 FIND TEMP-DB._FILE NO-LOCK
     WHERE TEMP-DB._File._DB-recid  = RECID(TEMP-DB._db)
       AND TEMP-DB._FILE._File-Name = "temp-db-ctrl":U  NO-ERROR.

 IF NOT AVAIL TEMP-DB._FILE THEN
 DO:
    MESSAGE "The TEMP-DB database requires a specific control Table" SKIP
            "called 'Temp-db-ctrl' for this tool to work." SKIP(2)
            "Do you want the system to automatically load this table to the TEMP-DB schema?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL
        UPDATE lchoice .
    IF lChoice THEN
    DO ON ERROR UNDO,LEAVE
        ON STOP UNDO,LEAVE:
        
        RUN checkDBReference in THIS-PROCEDURE.
        IF RETURN-VALUE = "ERROR":U THEN
        DO:
           plOK = NO.
           RETURN.
        END.
        
        CREATE ALIAS VALUE("DICTDB":U) FOR DATABASE "TEMP-DB":U.
        ASSIGN FILE-INFO:FILE-NAME = "src/adettdb/temp-db-ctrl.df":U
               cFile               = FILE-INFO:FULL-PATHNAME.
          
        IF cFile <> ? THEN
        DO:
           CREATE WINDOW hWindow.
           ASSIGN  hOrigWIndow    = CURRENT-WINDOW
                   CURRENT-WINDOW = hWindow.

           RUN prodict/load_df.p (INPUT cFile) NO-ERROR.
           
           IF VALID-HANDLE(hWindow) THEN
              DELETE WIDGET hWindow.
           IF VALID-HANDLE(hOrigWindow) THEN
              CURRENT-WINDOW = hOrigWindow.
           plOK = TRUE.
        END.
        ELSE
            MESSAGE "Could not find Data Definition file 'src/adettdb/temp-db-ctrl.df'"
                VIEW-AS ALERT-BOX WARNING.
    END.
 END.
 ELSE plOK = TRUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE checkDBReference :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether there is a TEMP-DB reference in any
               persistent program.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE h          AS HANDLE    NO-UNDO. /* procedure handle */
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE dbEntry    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lChoice    AS LOGICAL   NO-UNDO.
  
  
  ASSIGN h  = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    IF NOT (h:FILE-NAME BEGINS "adetran") THEN 
    DO i = 1 TO NUM-ENTRIES(h:DB-REFERENCES):
      ASSIGN dbentry = ENTRY(i,h:DB-REFERENCES).
      IF dbentry EQ "TEMP-DB":U THEN
      DO:
         MESSAGE "The database TEMP-DB is currently in use by running procedure '" h:FILE-NAME "'"  skip(1)
                 "Making schema changes to TEMP-DB at this time will cause PROGRESS to initiate" SKIP
                 "a session restart causing all unsaved work to be lost." SKIP(1)
                 "Are you sure you want to continue?" 
                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lchoice .
         IF lChoice THEN
            RETURN "".
         ELSE
           RETURN "ERROR":U.
      END.
    END.
    h = h:NEXT-SIBLING.
  END.
  RETURN "".
    
END PROCEDURE.
