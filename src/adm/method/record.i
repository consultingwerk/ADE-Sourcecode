&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
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
/*-------------------------------------------------------------------------
    Library     : record.i  
    Purpose     : Base ADM methods for record handling objects
  
    Syntax      : {src/adm/method/record.i}

    Description :
  
    Author(s)   :
    Created     :
    HISTORY: 
--------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF DEFINED(adm-record) = 0 &THEN
&GLOBAL adm-record yes

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
         HEIGHT             = 1.23
         WIDTH              = 35.86.
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

&IF DEFINED(EXCLUDE-adm-display-fields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-display-fields Method-Library 
PROCEDURE adm-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Displays the fields in the current record and any other 
               objects in the DISPLAYED-OBJECTS list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  &IF DEFINED(adm-browser) NE 0 AND 
    "{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U NE "":U &THEN
      IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
          DISPLAY {&FIELDS-IN-QUERY-{&BROWSE-NAME}} WITH BROWSE {&BROWSE-NAME}
            NO-ERROR.
    &IF "{&DISPLAYED-OBJECTS}":U NE "":U &THEN
      DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-OBJECTS} 
          WITH FRAME {&FRAME-NAME} NO-ERROR.
    &ENDIF
  &ELSEIF DEFINED(adm-viewer) NE 0 AND
     "{&FIRST-EXTERNAL-TABLE}":U NE "":U &THEN
      IF AVAILABLE {&FIRST-EXTERNAL-TABLE} THEN
          DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-FIELDS} {&DISPLAYED-OBJECTS}
            WITH FRAME {&FRAME-NAME} NO-ERROR. 
      ELSE DO:
          CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.        
          RUN set-editors('CLEAR':U).
      END.
  &ENDIF
    
    /* Clear MODIFIED field attr. */
    RUN check-modified IN THIS-PROCEDURE ('clear':U) NO-ERROR.  
   
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-open-query) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query Method-Library 
PROCEDURE adm-open-query :
/* -----------------------------------------------------------
  Purpose:     Opens the default or browse query.
  Parameters:  <none>
  Notes:       If there's a dependency on an external table, and 
               no record from that table is available, the query
               is closed.
-------------------------------------------------------------*/
&IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN
  &IF "{&EXTERNAL-TABLES}":U NE "":U &THEN
    IF AVAILABLE({&FIRST-EXTERNAL-TABLE}) THEN 
    DO:
  &ENDIF
        &IF DEFINED(OPEN-QUERY-CASES) NE 0 &THEN
            {&OPEN-QUERY-CASES}
        &ELSE
            {&OPEN-QUERY-{&QUERY-NAME}}
        &ENDIF
        ASSIGN adm-query-opened = YES 
               adm-last-rowid = ?.      /* we don't know the last record yet */

        /* Find out if this is the end of an Add or other operation that
           reopens the query and immediately does a reposition-query. If so,
           skip the get-first. */
        RUN get-attribute ('REPOSITION-PENDING':U).
        IF RETURN-VALUE NE "YES":U THEN
            RUN dispatch IN THIS-PROCEDURE ('get-first':U).

        IF NOT AVAILABLE ({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) THEN
            RUN new-state ('no-record-available,SELF':U).
        ELSE 
            /* In case there previously was no record in the dataset: */
            RUN new-state ('record-available,SELF':U). 
        
  &IF "{&EXTERNAL-TABLES}":U NE "":U &THEN
    END.
    ELSE 
    DO:
        CLOSE QUERY {&QUERY-NAME}.
        /* If there is a current record in this object's query, it may
           not be released automatically by the CLOSE. */
        RELEASE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-ERROR.
        /* Tell others that there's an external dependency not available. */
        RUN new-state ('no-external-record-available,SELF':U).
        RUN dispatch ('row-changed':U).  /* Signal that no row is available. */
    END.
  &ENDIF
&ELSEIF DEFINED(adm-browser) NE 0 AND
    DEFINED(TABLES-IN-QUERY-{&BROWSE-NAME}) <> 0 &THEN
  &IF "{&EXTERNAL-TABLES}":U NE "":U &THEN
    IF AVAILABLE({&FIRST-EXTERNAL-TABLE}) THEN DO:
  &ENDIF
        &IF DEFINED(OPEN-QUERY-CASES) NE 0 &THEN
            {&OPEN-QUERY-CASES}
        &ELSE
            {&OPEN-QUERY-{&BROWSE-NAME}}
        &ENDIF
        adm-query-opened = yes.
        IF NUM-RESULTS("{&BROWSE-NAME}":U) = 0 THEN /* query's empty */
            RUN new-state ('no-record-available,SELF':U).
        ELSE DO:
            RUN new-state ('record-available,SELF':U). 
            /* In case there's a Navigation Panel attached to the Browser,
               send this state also because get-first is not invoked. */
            RUN new-state ('first-record,SELF':U). 
        END.
  &IF "{&EXTERNAL-TABLES}":U NE "":U &THEN
    END. 
    ELSE
    DO:
        CLOSE QUERY {&BROWSE-NAME}.
        /* If there is a current record in this object's query, it may
           not be released automatically by the CLOSE. */
        RELEASE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} NO-ERROR.
        /* Tell others that there's an external dependency not available. */
        RUN new-state ('no-external-record-available,SELF':U).
    END.
  &ENDIF
        IF NOT adm-updating-record THEN /* Suppress if in the middle of update*/
            RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
&ENDIF
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-row-changed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-changed Method-Library 
PROCEDURE adm-row-changed :
/* -----------------------------------------------------------
      Purpose:    Executed when a new record or set of records
                  is retrieved locally (as opposed to passed on from
                  another procedure). Handles default display or browse open
                  code and then signals to RECORD-TARGETs that 
                  a fresh record or set of joined records is available.. 
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/   
      /* If there's a Frame or other valid container associated
         with this object, display the record's fields. */ 
      IF VALID-HANDLE(adm-object-hdl) THEN 
        RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

      RUN notify ('row-available':U).
          
      RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reposition-query) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reposition-query Method-Library 
PROCEDURE reposition-query :
/* -----------------------------------------------------------
  Purpose:     Gets the current rowid from the calling procedure,
               and repositions the current query to that record.
  Parameters:  Caller's procedure handle
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-requestor-hdl     AS HANDLE NO-UNDO.

&IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN

    DEFINE VAR repos-rowid                    AS ROWID NO-UNDO.
    
    RUN get-rowid IN p-requestor-hdl (OUTPUT repos-rowid).
    IF repos-rowid <> ? THEN
    DO:                                           
        REPOSITION {&QUERY-NAME} TO ROWID repos-rowid NO-ERROR.
        RUN dispatch IN THIS-PROCEDURE ('get-next':U).
    END.
    
&ELSEIF DEFINED (adm-browser) NE 0 AND
    DEFINED(TABLES-IN-QUERY-{&BROWSE-NAME}) <> 0 &THEN

    DEFINE VARIABLE table-name                 AS ROWID NO-UNDO.
    
    RUN get-rowid IN p-requestor-hdl (OUTPUT table-name).
    /* Note: row-changed was removed from this (after reposition)
       because the update-complete state will take care of that. */
    IF table-name <> ? THEN
        REPOSITION {&BROWSE-NAME} TO ROWID table-name NO-ERROR.
&ENDIF

    /* In case this attribute was set earlier, turn it off. */
    RUN set-attribute-list ('REPOSITION-PENDING = NO':U).

    RETURN.    
  
END PROCEDURE.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

