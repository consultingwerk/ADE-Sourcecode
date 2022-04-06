&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  DEFINE VARIABLE OK2Load   AS LOGICAL   INITIAL TRUE             NO-UNDO.
  DEFINE VARIABLE load-file AS CHARACTER INITIAL "TM-fltrs.d"     NO-UNDO.
  DEFINE VARIABLE headr     AS CHARACTER EXTENT 5                 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
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

FILE-INFO:FILE-NAME = load-file.
IF FILE-INFO:TYPE = ? THEN Load-file = "":U.

RUN adecomm/_setcurs.p ("":U).

IF CAN-FIND(FIRST xlatedb.XL_SelectedFilter) THEN
  MESSAGE "There are filters aready defined. Importing" SKIP
          "new filters will replace the current set."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE OK2Load.

IF OK2Load THEN
  SYSTEM-DIALOG GET-FILE load-file
    TITLE    "Import from..."
    FILTERS  "Dump files (*.d)"   "*.d":U,
             "Text files (*.txt)" "*.txt":U,
             "All files (*.*)"    "*.*":U
          USE-FILENAME MUST-EXIST UPDATE OK2Load.
          
IF OK2Load THEN DO:
  RUN adecomm/_setcurs.p ("WAIT":u).
  INPUT FROM VALUE(load-file) NO-ECHO.
  IMPORT headr.
  IF headr[1] NE "TranMan":U OR
     headr[2] NE "II":U OR
     headr[3] NE "Filter":U OR
     headr[4] NE "Export":U OR
     headr[5] NE "Format":U THEN DO:
    MESSAGE load-file "does not contain the proper format" SKIP
            "for a filter export file." SKIP (1)
            "Aborting the import." VIEW-AS ALERT-BOX ERROR.
    RETURN.       
  END.
  
  /* Clean out existing filters */
  DO TRANSACTION:
    FOR EACH xlatedb.XL_SelectedFilter:
      DELETE xlatedb.XL_SelectedFilter.
    END.
    FOR EACH xlatedb.XL_CustomFilter:
      DELETE xlatedb.XL_CustomFilter.
    END.
  END.  /* Single transaction for performance */
  
  /* Load in the new */
  DO TRANSACTION:
    REPEAT:
      CREATE xlatedb.XL_SelectedFilter.
      IMPORT xlatedb.XL_SelectedFilter.
    END.
  END.  /* Transaction */
  DO TRANSACTION:
    REPEAT:
      CREATE xlatedb.XL_CustomFilter.
      IMPORT xlatedb.XL_CustomFilter.
    END.
  END. /* Transaction */
  INPUT CLOSE.
  RUN adecomm/_setcurs.p ("":U).
END.
ELSE MESSAGE "Nothing was imported..." SKIP
             IF CAN-FIND(FIRST xlatedb.XL_SelectedFilter) THEN
             "Existing filters are still defined." ELSE
             "No filters are defined."
     VIEW-AS ALERT-BOX INFORMATION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


