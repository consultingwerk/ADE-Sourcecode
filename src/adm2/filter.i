&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    File        : filter.i
    Purpose     : Basic Method Library for the ADMClass filter.
  
    Syntax      : {src/adm2/filter.i}

    Description :
  
    Modified    : 06/28/1999
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass filter
&ENDIF

&IF "{&ADMClass}":U = "filter":U &THEN
  {src/adm2/filtprop.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
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
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
  DEFINE VARIABLE cViewCols AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cEnabled  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iEntries  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cEntry    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lResult   AS LOGICAL   NO-UNDO.

  &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Starts super procedure */
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
  DO:
    RUN start-super-proc("adm2/filter.p":U).
    
    {get EnabledFields cEnabled}.

    iEntries = NUM-ENTRIES("{&DISPLAYED-FIELDS}":U, " ":U).
    DO iCol = 1 TO iEntries:
      cEntry = ENTRY(iCol, "{&DISPLAYED-FIELDS}":U, " ":U).
      cViewCols = cViewCols + (IF cViewCols NE "":U THEN ",":U ELSE "":U) +
        SUBSTR(cEntry, R-INDEX(cEntry, ".":U) + 1).  /* Remove table (and db) */
    END.

    iEntries = NUM-ENTRIES("{&ENABLED-FIELDS}":U, " ":U).
    DO iCol = 1 TO iEntries:
      cEntry = ENTRY(iCol, "{&ENABLED-FIELDS}":U, " ":U).
      cEnabled = cEnabled + (IF cEnabled NE "":U THEN ",":U ELSE "":U) +
        SUBSTR(cEntry, R-INDEX(cEntry, ".":U) + 1).  /* Remove table (and db) */
    END.

    {set DisplayedFields cViewCols}.
    {set EnabledFields cEnabled}.

  END.  /* if not adm-load-from-repos */
  &ENDIF
  
   /* Capture update keystrokes and signal the start of an update, so that
     checkModified can work and to control the state of Panels. */
  ON VALUE-CHANGED OF FRAME {&FRAME-NAME} ANYWHERE 
    APPLY 'U10':U TO THIS-PROCEDURE.
  
  /* Make the trigger indirect so that if application code also puts a
     VALUE-CHANGED trigger on some field it can APPLY 'U10' TO THIS-PROCECURE.*/
  ON 'U10':U OF THIS-PROCEDURE
  DO:
    IF VALID-HANDLE(FOCUS) 
    AND FOCUS:TYPE  = "FILL-IN":U THEN
      {fnarg unBlankFillin focus}.      
     
    {get FieldsEnabled lResult}.    /* Only if the object's enable for input.*/
    IF lResult THEN DO:
      {get DataModified lResult}.
      IF NOT lResult THEN           /* Don't send the event more than once. */
        {set DataModified yes}.
    END.   /* END DO IF Fields are Enabled */
  END.     /* END DO ON ANY */
  
  &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */

  {src/adm2/custom/filtercustom.i}

  /* _ADM-CODE-BLOCK-END */

  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


