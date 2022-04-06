&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    Library     : query.i  
    Purpose     : Basic ADM methods for query objects
  
    Syntax      : {src/adm/method/query.i}

    Description :
  
    Author(s)   :
    Created     :
    Notes       :
    HISTORY: 
      
--------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED (adm-query) = 0 &THEN
&GLOBAL adm-query yes

&GLOBAL adm-open-query yes

/* Dialog program to run to set runtime attributes - if not defined in master */
&IF DEFINED(adm-attribute-dlg) = 0 &THEN
&SCOP adm-attribute-dlg adm/support/queryd.w
&ENDIF

/* +++ This is the list of attributes whose values are to be returned
   by get-attribute-list, that is, those whose values are part of the
   definition of the object instance and should be passed to init-object
   by the UIB-generated code in adm-create-objects. */
&IF DEFINED(adm-attribute-list) = 0 &THEN
&SCOP adm-attribute-list Key-Name,SortBy-Case
&ENDIF

  DEFINE VARIABLE adm-first-rowid AS ROWID NO-UNDO /* INIT ? */.
  DEFINE VARIABLE adm-last-rowid  AS ROWID NO-UNDO /* INIT ? */.

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
         HEIGHT             = 15.19
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm/method/smart.i}
{src/adm/method/record.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

ASSIGN adm-first-rowid = ?
       adm-last-rowid  = ?.   /* INIT doesn't work for ROWIDs */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-get-first) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-get-first Method-Library 
PROCEDURE adm-get-first :
/* -----------------------------------------------------------
  Purpose:     Gets the first record in the default query.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  
  &IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN
    IF NOT adm-query-opened THEN RETURN.

    GET FIRST {&QUERY-NAME}.
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN
    DO:
        IF NUM-ENTRIES("{&TABLES-IN-QUERY-{&QUERY-NAME}}":U," ":U) = 1 THEN
            ASSIGN adm-first-rowid = 
                ROWID ({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
        RUN new-state ('first-record,SELF':U).
    END.

    RUN dispatch IN THIS-PROCEDURE ('row-changed':U) .
    
  &ELSEIF DEFINED(FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) NE 0 &THEN
    DEFINE VARIABLE browser-handle AS HANDLE  NO-UNDO.
    DEFINE VARIABLE q-stat         AS LOGICAL NO-UNDO.

    IF NOT adm-query-opened THEN RETURN.
    DO WITH FRAME {&FRAME-NAME}:
      IF num-results("{&BROWSE-NAME}":U) = 0 THEN  /* Browse is empty */
        RUN new-state ('no-record-available,SELF':U).
      ELSE DO:
        browser-handle = {&BROWSE-NAME}:HANDLE.
        APPLY "HOME":U TO BROWSE {&BROWSE-NAME}.
        q-stat = browser-handle:SELECT-FOCUSED-ROW(). 
        IF NUM-ENTRIES("{&TABLES-IN-QUERY-{&BROWSE-NAME}}":U," ":U) = 1 THEN
            ASSIGN adm-first-rowid = 
                ROWID ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
        IF num-results("{&BROWSE-NAME}":U) = 1 THEN  /* Just one row */
            RUN new-state ('only-record,SELF':U).
        ELSE RUN new-state ('first-record,SELF':U).
      END.
    END.
  &ENDIF
    RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-get-last) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-get-last Method-Library 
PROCEDURE adm-get-last :
/* -----------------------------------------------------------
  Purpose:     gets the last record in the default query.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  
  &IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN
    IF NOT adm-query-opened THEN RETURN.
    
    GET LAST {&QUERY-NAME}.
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN 
    DO:
        IF NUM-ENTRIES("{&TABLES-IN-QUERY-{&QUERY-NAME}}":U," ":U) = 1 THEN
            ASSIGN adm-last-rowid = 
                ROWID ({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
        IF adm-last-rowid NE ? AND adm-first-rowid = adm-last-rowid THEN
            RUN new-state ('only-record,SELF':U).  /* Just one rec in dataset */
        ELSE RUN new-state ('last-record,SELF':U).
    END.
    RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
    
  &ELSEIF DEFINED(FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) NE 0 &THEN
    DEFINE VARIABLE browser-handle AS HANDLE  NO-UNDO.
    DEFINE VARIABLE q-stat         AS LOGICAL NO-UNDO.

    IF NOT adm-query-opened THEN RETURN.
    DO WITH FRAME {&FRAME-NAME}:
      IF num-results("{&BROWSE-NAME}":U) = 0 THEN  /* Browse is empty */
        RUN new-state ('no-record-available,SELF':U).
      ELSE DO:
        browser-handle = {&BROWSE-NAME}:HANDLE.
        APPLY "END":U TO BROWSE {&BROWSE-NAME}.
        q-stat = browser-handle:SELECT-FOCUSED-ROW(). 
        IF NUM-ENTRIES("{&TABLES-IN-QUERY-{&BROWSE-NAME}}":U," ":U) = 1 THEN
            ASSIGN adm-last-rowid = 
                ROWID ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
        RUN new-state ('last-record,SELF':U).
      END.
    END.
  &ENDIF
    RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-get-next) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-get-next Method-Library 
PROCEDURE adm-get-next :
/* -----------------------------------------------------------
  Purpose:     Gets the next record in the default query.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  
  &IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN
    IF NOT adm-query-opened THEN RETURN.
    GET NEXT {&QUERY-NAME}. 

    IF AVAIL({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) THEN
    DO:
        IF adm-last-rowid = ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}})
             THEN RUN new-state ('last-record,SELF':U).
        ELSE RUN new-state ('not-first-or-last,SELF':U).
        RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
    END.
    ELSE 
        RUN dispatch IN THIS-PROCEDURE ('get-last':U).  

  &ELSEIF DEFINED(FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) NE 0 &THEN
    DEFINE VARIABLE browser-handle AS HANDLE  NO-UNDO.
    DEFINE VARIABLE q-stat         AS LOGICAL NO-UNDO.

    IF NOT adm-query-opened THEN RETURN.
    DO WITH FRAME {&FRAME-NAME}:
      IF num-results("{&BROWSE-NAME}":U) = 0 THEN  /* Browse is empty */
        RUN new-state ('no-record-available,SELF':U).
      ELSE DO:
        browser-handle = {&BROWSE-NAME}:HANDLE.
        q-stat = browser-handle:SELECT-NEXT-ROW(). 
        IF adm-last-rowid = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}})
             THEN RUN new-state ('last-record,SELF':U).
        ELSE RUN new-state ('not-first-or-last,SELF':U).
        RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
      END.
    END.
  &ENDIF
    RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-get-prev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-get-prev Method-Library 
PROCEDURE adm-get-prev :
/* -----------------------------------------------------------
  Purpose:     Gets the previous record in the default query.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  
  &IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN
    IF NOT adm-query-opened THEN RETURN.
    
    GET PREV {&QUERY-NAME}. 

    IF AVAIL({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) THEN
    DO:
        IF adm-first-rowid = ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}})
             THEN RUN new-state ('first-record,SELF':U).
        ELSE RUN new-state ('not-first-or-last,SELF':U).
        RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
    END.
    ELSE 
        RUN dispatch IN THIS-PROCEDURE ('get-first':U).

  &ELSEIF DEFINED(FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) NE 0 &THEN
    DEFINE VARIABLE browser-handle AS HANDLE  NO-UNDO.
    DEFINE VARIABLE q-stat         AS LOGICAL NO-UNDO.

    IF NOT adm-query-opened THEN RETURN.
    DO WITH FRAME {&FRAME-NAME}:
      IF num-results("{&BROWSE-NAME}":U) = 0 THEN  /* Browse is empty */
        RUN new-state ('no-record-available,SELF':U).
      ELSE DO:
        browser-handle = {&BROWSE-NAME}:HANDLE.
        q-stat = browser-handle:SELECT-PREV-ROW(). 
        IF adm-first-rowid = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}})
             THEN RUN new-state ('first-record,SELF':U).
        ELSE RUN new-state ('not-first-or-last,SELF':U).
        RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
      END.
    END.
  &ENDIF
    RETURN.
    
END PROCEDURE.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-new-first-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE new-first-record Method-Library 
PROCEDURE new-first-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER rRowid AS ROWID NO-UNDO.

ASSIGN adm-first-rowid = rRowid.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

