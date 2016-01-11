&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"ADM dynamic SmartDataObject.

This dynamic object is used as a client proxy for a SmartDataObject."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
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
/*------------------------------------------------------------------------

  File:  

  Description: DYNDATA.W - Dynamic SmartData object in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified    : May 16, 2001 Version 9.1C
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

  DEFINE VARIABLE grCurrentRow AS ROWID      NO-UNDO.
  DEFINE VARIABLE ghROUQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghROQuery    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghRowNum     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghRowMod     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghROURowMod  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghROURowNum  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghRowObjUpd  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE gcUpdatable  AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF

&Scoped-define QUERY-NAME Query-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Commit dTables  _DB-REQUIRED
FUNCTION Commit RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumns dTables  _DB-REQUIRED
FUNCTION getDataColumns RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumns dTables  _DB-REQUIRED
FUNCTION getUpdatableColumns RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdatableColumns dTables  _DB-REQUIRED
FUNCTION setUpdatableColumns RETURNS LOGICAL
  ( pcUpdatableColumns AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.48
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/dyndata.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */
  
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doBuildUpd dTables  _DB-REQUIRED
PROCEDURE doBuildUpd :
/*------------------------------------------------------------------------------
  Purpose:     Transfers changed rows into the Update Temp-Table and returns
               it to the caller (the Commit function).

  Parameters:
    OUTPUT RowObjUpd - table containing updated records

  Notes:       Dynamic SDO version of the procedure from data.i.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE   NO-UNDO.
 /* First save off the current row number, so we can reposition to it after
     the update is all done. */
  IF ghRowObject:AVAILABLE THEN
    grCurrentRow = ghRowObject:ROWID.
  ELSE grCurrentRow = ?.
  
  /* Copy each updated row to the update table (the before image is already there) */
  {get RowObject hRowObject}.
  ghROQuery:SET-BUFFERS(hRowObject).
  ghROQuery:QUERY-PREPARE('FOR EACH RowObject WHERE RowObject.RowMod = "U":U':U).
  ghROQuery:QUERY-OPEN().
  ghROQuery:GET-FIRST().
  DO WHILE NOT ghROQuery:QUERY-OFF-END:
      ghRowObjUpd:BUFFER-CREATE().
      ghRowObjUpd:BUFFER-COPY(ghRowObject).
      ghROQuery:GET-NEXT().
  END.
  ghROQuery:QUERY-CLOSE().

  /* Now copy the final values for all Added/Copied rows to the Update table. */
  ghROQuery:QUERY-PREPARE('FOR EACH RowObject WHERE RowObject.RowMod = "A":U':U +
                         ' OR RowObject.RowMod = "C":U':U).
  ghROQuery:QUERY-OPEN().
  ghROQuery:GET-FIRST().
  DO WHILE NOT ghROQuery:QUERY-OFF-END:
      ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U +
                               STRING(ghRowNum:BUFFER-VALUE)).
      ghROUQuery:QUERY-OPEN().
      ghROUQuery:GET-FIRST().
      ghRowObjUpd:BUFFER-COPY(ghRowObject).
      ghROUQuery:QUERY-CLOSE().
      ghROQuery:GET-NEXT().
  END.
  ghROQuery:QUERY-CLOSE().

  /* Read current RowObject record back into the buffer - we count on it
     being there later (e.g., in doUndoUpdate() when an Add is canceled). */
  IF grCurrentRow NE ? THEN
      ghRowObject:FIND-BY-ROWID(grCurrentRow).
      
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doCreateUpdate dTables  _DB-REQUIRED
PROCEDURE doCreateUpdate :
/*------------------------------------------------------------------------------
  Purpose:     FINDs the specified row to be updated and creates a "backup" 
               (a before-image) copy of it in the RowObjUpd table, to support
               Undo.  Run from submitRow when it receives a set of value 
               changes from a UI object.

  Parameters:
    INPUT  pcRowIdent  - encoded "key" of the row to be updated.
    INPUT  pcValueList - the list of changes made.  A CHR(1) delimited list
                         of FieldName/NewValue pairs.
    OUTPUT plReopen    - true if the row was new (either a copy or an add),
                         so reopen RowObject query.
    OUTPUT pcMessage   - error messages.
 
  Notes:       dynamic version of the procedure in data.i. The rowIdent and
               valueList parameters aren't actually used.
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcRowIdent  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcValueList AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plReopen    AS LOGICAL   NO-UNDO INIT no.
  DEFINE OUTPUT PARAMETER pcMessage   AS CHARACTER NO-UNDO.
  
  /* First check to see if there's already a saved pre-change version 
     of the record; this would be so if the same row is changed 
     multiple times before commit. */
  ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U +
                      STRING(ghRowNum:BUFFER-VALUE)).
  ghROUQuery:QUERY-OPEN().
  ghROUQuery:GET-FIRST().
  DO TRANSACTION:
    IF NOT ghRowObjUpd:AVAILABLE THEN
    DO:
      ghRowObjUpd:BUFFER-CREATE().
      ghRowObjUpd:BUFFER-COPY(ghRowObject).
   END.        /* END DO IF NO ROU available */

    IF ghRowMod:BUFFER-VALUE NE "A":U AND /* If this isn't an add/copy then */
       ghRowMod:BUFFER-VALUE NE "C":U
      THEN ghRowMod:BUFFER-VALUE = "U":U. /*  flag it as update. */
    ELSE plReopen = TRUE.            /* Tell caller to reopen query. */
  END.     /* END TRANSACTION */

  pcMessage = "".   /* "Success" output value. */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doReturnUpd dTables  _DB-REQUIRED
PROCEDURE doReturnUpd :
/*------------------------------------------------------------------------------
  Purpose:     RUN from Commit on the client side to get back the Update 
               (RowObjUpd) table (from the server side) and undo any failed 
               changes or return final versions of record values to the client.
 
  Parameters:  
    INPUT cUndoIds - list of any RowObject ROWIDs whose changes were
                     rejected by a commit. Delimited list of the form:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."
            
  Notes:       dynamic SDO version of the procedure in data.i
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER cUndoIds AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lAutoCommit     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE lBrowsed        AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE lRefreshBrowse  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hAltROUQuery    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hAltROUBuf      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.
  
  {get AutoCommit lAutoCommit}.
  {get DataQueryBrowsed lBrowsed}.
  {get QueryContainer lQueryContainer}.


  /* Commit successful. */
  IF NOT anyMessage() AND (cUndoIds = "":U) THEN
  DO:
    /* Move updated versions of records, including any values assigned by CREATE
       or WRITE triggers, back into the RowObject table for the client to see.
       Adds and Copies are marked with an "A" or "C", Updates with "U". */
       ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd':U).
       ghROUQuery:QUERY-OPEN().
       ghROUQuery:GET-FIRST().
       DO WHILE(ghRowObjUpd:AVAILABLE):
           IF LOOKUP(ghROURowMod:BUFFER-VALUE, "A,C,U":U) NE 0 THEN
           DO:
               ghROQuery:QUERY-PREPARE('FOR EACH RowObject WHERE RowObject.RowNum = ':U +
                                        STRING(ghROURowNum:BUFFER-VALUE)).
               ghROQuery:QUERY-OPEN().
               ghROQuery:GET-FIRST().
               ghRowObject:BUFFER-COPY(ghRowObjUpd).
               ghRowMod:BUFFER-VALUE = "":U.
               /* Display any refreshed values to the current row only.
                  9.1B -- do this only if we're not inside a Container that 
                  does the commit for us (SBO) */
               IF (ghRowObject:ROWID = grCurrentRow) AND lQueryContainer = NO THEN
               DO:
                   IF ghROURowMod:BUFFER-VALUE = "U":U THEN
                     PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("SAME":U).
                   ELSE /* A or C : Add or Copy */
                     PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
               END.      /* END DO IF current row and not in an SBO */
           END.          /* END DO if A,C,U */
           ghRowObjUpd:BUFFER-DELETE().
           ghROUQuery:GET-NEXT().
       END.        /* END DO WHILE AVAIL */   
  END.             /* Commit successful. */
  ELSE DO:  /* Commit not successful.  */
    /* Refresh fields from db values for updates only. */
    IF INDEX(cUndoIds, "ADM-FIELDS-CHANGED":U) > 0 THEN
    DO:
        ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "U":U':U).
        ghROUQuery:QUERY-OPEN().
        ghROUQuery:GET-FIRST().
        CREATE QUERY hAltROUQuery.   /* second RowObjUpd buffer for copying before image. */
        hAltROUQuery:SET-BUFFERS(hAltROUBuf).

        DO WHILE (ghRowObjUpd:AVAILABLE):
            /* Skip refreshing the update record if not required. */
            IF INDEX(cUndoIds, STRING(ghROURowNum:BUFFER-VALUE) + CHR(3) +
               "ADM-FIELDS-CHANGED":U) = 0
            THEN NEXT.
            /* Copy the refreshed db field values to row object. */
            ghROQuery:QUERY-PREPARE('FOR EACH RowObject WHERE RowObject.RowNum = ':U +
                                    STRING(ghROURowNum:BUFFER-VALUE)).
            ghROQuery:QUERY-OPEN().
            ghROQuery:GET-FIRST().
            ghRowObject:BUFFER-COPY(ghRowObjUpd,'RowMod':U).
            ghROQuery:QUERY-CLOSE().
                  /* Copy the refreshed db field values to the pre-commit row.
                     Don't copy over the RowMod (that could change what the
                     record is used for). And don't copy over ChangedFields. Leave
                     that as the client set it. */
            hAltROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U +
                                       STRING(ghROURowNum:BUFFER-VALUE) + 
                                       ' AND RowObjUpd.RowMod = "":U':U).
            hAltROUQuery:QUERY-OPEN().
            hAltROUQuery:GET-FIRST().
            hAltROUBuf:BUFFER-COPY(ghRowObjUpd, "RowMod,ChangedFields":U).
            hAltROUQuery:QUERY-CLOSE().
            /* Display any refreshed values to the current row only. */
            IF ghRowObject:ROWID = grCurrentRow AND lQueryContainer = NO THEN
            PUBLISH 'dataAvailable':U ("SAME":U).
            ghROUQuery:GET-NEXT().
        END.    /* END DO WHILE ROU available -- for each update */
        DELETE OBJECT hAltROUQuery.
    END.        /* END DO IF ADM-FIELDS-CHANGED in the cUndoIds */
    
    /* The pre-commit update record (RowMod = "") contains the right values for
       an undo, so we no longer need the commit copy (RowMod = "U") of
       the update record. A failed AutoCommit Delete should also be removed.
       Don't delete the Add/Copy records or non-AutoCommit Delete records
       because they are needed for Undo. */
    ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "U":U':U).
    ghROUQuery:QUERY-OPEN().
    ghROUQuery:GET-FIRST().
    DO WHILE(ghRowObjUpd:AVAILABLE):
        ghRowObjUpd:BUFFER-DELETE().
        ghROUQuery:GET-NEXT().
    END.        /* END DO WHILE AVAIL */
                                                          
    IF lAutoCommit THEN
    DO:
        ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "D":U':U).
        ghROUQuery:QUERY-OPEN().
        ghROUQuery:GET-FIRST().
        DO WHILE(ghRowObjUpd:AVAILABLE):
            ghRowObjUpd:BUFFER-DELETE().
            ghROUQuery:GET-NEXT().
        END.   /* END DO WHILE ROU available -- deleted recs */
    END.       /* END DO IF AutoCommit */
  END. /* Commit not successful */

  /* If data object is being browsed and changes can be to more than one
     record (AutoCommit is no), then ensure all records in the displayed
     browser(s) are refreshed correctly by reopening the temp-table query.
     Then position query to current row again. */
  IF lBrowsed AND NOT lAutoCommit THEN
  DO:
    lRefreshBrowse = (ghROQuery:IS-OPEN ) AND (grCurrentRow NE ?).
    IF lRefreshBrowse THEN
    DO:
      ghROQuery:QUERY-OPEN(). /* Re-open the Temp-Table query. */
      ghROQuery:REPOSITION-TO-ROWID (grCurrentRow).
    END.     /* END DO IF RefreshBrowse */
  END.       /* END DO IF Browsed and not AutoCommit */

  /* Now that we're all done, reposition to where we were
     before we did the commit, but only if there's an active query. */
  ELSE IF ghROQuery:IS-OPEN AND grCurrentRow NE ? THEN
  DO:
    /* Avoid reposition with a browse, because if you edit a column and
       use the scrollbar before you enter another column, the reposition will
       scroll back to the previous viewport. (saves on row-leave, not on scroll)
       However, with an error (undo), this reposition is crucial in order to
       be able to return to the correct row if the user presses Cancel.
       (In which case the browse scrolls back anyway) */
    IF NOT lBrowsed OR cUndoIds <> "":U THEN DO:
       ghROQuery:REPOSITION-TO-ROWID (grCurrentRow).

      IF NOT ghRowObject:AVAILABLE THEN  /* If not being browsed, then this is*/
        ghROQuery:GET-NEXT().  /* Needed to move onto the row itself. */
      IF lQueryContainer = NO THEN /* Not for SBOs */
          PUBLISH 'dataAvailable':U ("DIFFERENT":U).
    END.  /* END DO if not lBrowsed or cUndoIds <> "" */
  END.    /* END DO IF Query open and CurrentRow defined */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoRow dTables  _DB-REQUIRED
PROCEDURE doUndoRow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF ghRowObject:AVAILABLE THEN
  DO:
    /* Copy the "before" version back to the RowObject record   */
    ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U +
                              STRING(ghRowNum:BUFFER-VALUE) + 
                             ' AND RowObjUpd.RowMod = "":U':U).
    ghROUQuery:QUERY-OPEN().
    ghROUQuery:GET-FIRST().
    IF ghRowObjUpd:AVAILABLE THEN /* may not be there if never saved */
    DO:                               
      ghRowObject:BUFFER-COPY (ghRowObjUpd).
      ghRowObjUpd:BUFFER-DELETE(). 
      ghROUQuery:QUERY-CLOSE().
    END.   /* END DO IF RowObjUpd AVAILABLE */
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoTrans dTables  _DB-REQUIRED
PROCEDURE doUndoTrans :
/*------------------------------------------------------------------------------
  Purpose:     Does the buffer delete and copy operations to restore the
               RowObject temp-table when an Undo occurs.  New RowObject records
               (added or copied) are deleted, modified records are restored to 
               their original states and deleted records are recreated.  The
               RowObjUpd table is emptied.

  Parameters:  <none>
 
  Notes:       Invoked from the event procedure undoTransaction.
               doUndoTrans is run on the client side.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iFirstRowNum    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRowNum     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hROURowIdent    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpdTbl   AS HANDLE    NO-UNDO.

  hROURowIdent = ghRowObjUpd:BUFFER-FIELD('RowIdent':U).    /* for use below */

  /* Restore RowObject to its original state. To do this:
     delete any added/copied rows (RowObject.RowMod = "A"/"C");
     copy any updated rows (RowObject.RowMod = "U") back from RowObjUpd;
     and restore any deleted rows (RowObjUpd.RowMod = "D"). */
  ghROQuery:QUERY-PREPARE
      ('FOR EACH RowObject WHERE RowObject.RowMod = "A":U OR RowObject.RowMod = "C":U':U).
  ghROQuery:QUERY-OPEN().
  ghROQuery:GET-FIRST().
  DO WHILE(ghRowObject:AVAILABLE):
    ghRowObject:BUFFER-DELETE().
    ghROQuery:GET-NEXT().
  END.      /* END DO WHILE RowObject available */
  ghROQuery:QUERY-CLOSE().

  ghROQuery:QUERY-PREPARE
      ('FOR EACH RowObject WHERE RowObject.RowMod = "U":U':U).
  ghROQuery:QUERY-OPEN().
  ghROQuery:GET-FIRST().
  DO WHILE(ghRowObject:AVAILABLE):
      ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U +
                               STRING(ghRowNum:BUFFER-VALUE) + 
                               ' AND RowObjUpd.RowMod = "":U':U).
      ghROUQuery:QUERY-OPEN().                /* FIND the matching RowObjUpd record. */
      ghROUquery:GET-FIRST().
      ghRowObject:BUFFER-COPY(ghRowObjUpd).   /* Copy its values back to RowObject. */
      ghROUQuery:QUERY-CLOSE().
      ghROQuery:GET-NEXT().
  END.        /* END DO WHILE RowObject AVAILABLE */

  ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "D":U':U).
  ghROUQuery:QUERY-OPEN().
  ghROUQuery:GET-FIRST().
  DO WHILE (ghRowObjUpd:AVAILABLE):
      ghRowObject:BUFFER-CREATE().
      ghRowObject:BUFFER-COPY(ghRowObjUpd).
      ghRowMod:BUFFER-VALUE = "":U.

     /* Reset the first or last num values if the undeleted record falls outside
        the current batch range. */
     {get FirstRowNum iFirstRowNum}.
     IF ghROURowNum:BUFFER-VALUE < iFirstRowNum THEN
       {set FirstRowNum ghROURowNum:BUFFER-VALUE}.
     {get LastRowNum iLastRowNum}.
     IF ghROURowNum:BUFFER-VALUE >= iLastRowNum THEN 
     DO:
         {set LastRowNum ghROURowNum:BUFFER-VALUE}.
         {set LastDbRowIdent hROURowIdent:BUFFER-VALUE}.
     END.  /* If RowNum >= LastRowNum */
     ghROUQuery:GET-NEXT().
  END.     /* END WHILE "D"eleted RowObjUpd recs available */

  /* For repositioning, locate the first Update or Delete record that's being undone
     and position there. If there aren't any, then we are undoing an Add. In that
     case, position to the first record in the batch. */
  ghROUQuery:QUERY-PREPARE
      ('FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "":U OR RowObjUpd.RowMod = "D":U':U +
                      ' USE-INDEX RowNum':U).
  ghROUQuery:QUERY-OPEN().
  ghROUQuery:GET-FIRST().
  IF ghRowObjUpd:AVAILABLE THEN
      ghROQuery:QUERY-PREPARE('FOR EACH RowObject WHERE RowObject.RowNum = ':U +
                              STRING(ghROURowNum:BUFFER-VALUE)).
  ELSE ghROQuery:QUERY-PREPARE('FOR EACH RowObject USE-INDEX RowNum':U).
  ghROQuery:QUERY-OPEN().
  ghROQuery:GET-FIRST().
  IF ghRowObject:AVAILABLE THEN
  DO:
      {get FirstRowNum iFirstRowNum}.
      {get LastRowNum iLastRowNum}.
      IF ghRowNum:BUFFER-VALUE = iFirstRowNum THEN
          {set QueryPosition 'FirstRecord':U}.
      ELSE IF ghRowNum:BUFFER-VALUE >= iLastRowNum THEN
          {set QueryPosition 'LastRecord':U}.
      ELSE
          {set QueryPosition 'NotFirstOrLast':U}.
  END.    /* END DO IF RowObject AVAILABLE */
  ELSE
  DO: /* There were no records in the batch to begin with. */
      {set FirstRowNum ?}.
      {set LastRowNum ?}.
      {set QueryPosition 'NoRecordAvailable':U}.
  END.     /* END DO IF No records in batch */

  ghRowObjUpd:EMPTY-TEMP-TABLE() .

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoUpdate dTables  _DB-REQUIRED
PROCEDURE doUndoUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Supports a cancelRow by copying the current RowObjUpd record back 
               to the current RowObject record.
 
  Parameters:  <none>
    Notes:     dynamic SDO version of this procedure from data.i
------------------------------------------------------------------------------*/
  DEFINE VARIABLE rRowObject  AS ROWID                 NO-UNDO.
  DEFINE VARIABLE lAutoCommit AS LOGICAL               NO-UNDO.
  DEFINE VARIABLE lBrowsed    AS LOGICAL               NO-UNDO.
   
  IF ghRowObject:AVAILABLE THEN
  DO:
      /* Copy the "before" version back to the RowObject record and tell 
         other clienbt objects to redisplay it. */
      ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U +
                               STRING(ghRowNum:BUFFER-VALUE) + 
                               ' AND RowObjUpd.RowMod = "":U':U).
      ghROUQuery:QUERY-OPEN().
      ghROUQuery:GET-FIRST().
      IF ghRowObjUpd:AVAILABLE THEN /* may not be there if never saved */
      DO:                               
          ghRowObject:BUFFER-COPY (ghRowObjUpd).
          ghRowObjUpd:BUFFER-DELETE(). 
          ghROUQuery:QUERY-CLOSE().
          PUBLISH 'dataAvailable':U ("SAME":U). 
          RETURN.
      END.   /* END DO IF RowObjUpd AVAILABLE */
    
      IF ghRowMod:BUFFER-VALUE = "A":U OR ghRowMod:BUFFER-VALUE = "C":U THEN
      DO:
          /* If a save was attempted, clean out the Update table. */
          ghROUQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U +
                                   STRING(ghRowNum:BUFFER-VALUE)).
          ghROUQuery:QUERY-OPEN().
          ghROUQuery:GET-FIRST().
          IF ghRowObjUpd:AVAILABLE THEN
              ghRowObjUpd:BUFFER-DELETE().
          /* And delete the newly added row from the RowObject table in any case. */
          ghRowObject:BUFFER-DELETE().      

          /* Re-establish the current row */
          {get CurrentRowid rRowObject}.
          IF ghROQuery:IS-OPEN THEN 
          DO:
              IF DYNAMIC-FUNCTION('linkProperty':U,
                            INPUT 'Update-Source':U,
                            INPUT 'BrowseHandle':U) = ? THEN /* only if UpdateSource is not a SDBrowser */          
              ghROQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
              {get DataQueryBrowsed lBrowsed}.
              IF NOT lBrowsed THEN    /* No Next needed for a browser */
                  ghROQuery:GET-NEXT() NO-ERROR.
          END.  /* IF the query is open */
      END. /* DO IF "A"/"C" */
  END. /* if avail rowobject */

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Dynamic SDO version of initializeObject
  Parameters:  <none>
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cColumns             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainerType       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cServerOperatingMode AS CHARACTER  NO-UNDO.

 /* For now at least this object runs only on the client. */
 {set ASDivision 'Client':U}.
 {set ServerOperatingMode 'None':U}. /* This comes from data.i */
 {set QueryObject yes}.             /* All DataObjects are query objects.*/
  
  /* Overrides query object setting */
 {set DataSourceEvents 'dataAvailable,confirmContinue':U}.
                                                 
 RUN SUPER.

 {get RowObject ghRowObject}.
 ghROQuery:SET-BUFFERS(ghRowObject).
  
 ASSIGN ghRowNum = ghRowObject:BUFFER-FIELD('RowNum':U)
        ghRowMod = ghRowObject:BUFFER-FIELD('RowMod':U).

 RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeServerObject dTables  _DB-REQUIRED
PROCEDURE initializeServerObject :
/*------------------------------------------------------------------------------
  Purpose:     Override that retrieves the rowObjUpdtable from the server 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryContainer      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hAppServer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hROUTable            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAsHasStarted        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cUpdColumns          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables              AS CHARACTER  NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN SUPER.
  /* If we're not inside an SBO or some other container which manages the
     query for us, fetch initial property values from the static SDO on
     the server, along with the RowObjUpdTable, whose structure needs to
     be initialized here on the client. */
  {get ASHasStarted lASHasStarted}.
  IF NOT lAsHasStarted THEN
  DO:
    {get QueryContainer lQueryContainer}.
    IF NOT lQueryContainer THEN
    DO:
      {get ASHandle hAppServer}. /* This will always be a 'client' object. */
      RUN serverFetchRowObjUpdTable IN hAppServer 
          (OUTPUT TABLE-HANDLE hROUTable).
      cUpdcolumns = DYNAMIC-FUNCTION('getUpdatableColumns':U IN hAppserver).
      DYNAMIC-FUNCTION('setUpdatableColumns':U IN TARGET-PROCEDURE,
                       cUpdColumns).
      cTables = DYNAMIC-FUNCTION('getTables':U IN hAppserver).
      DYNAMIC-FUNCTION('setTables':U IN TARGET-PROCEDURE,
                       cTables).

      {set RowObjUpdTable hROUTable}.
      {set RowObjUpd hROUTable:DEFAULT-BUFFER-HANDLE}.
    
      /* "Client" validation must be done on the server. */
      {set ServerSubmitValidation YES}.   
    END.       /* END DO IF Not lQueryContainer -- not in an SBO */
  
    /* Initialize the query to find the ROU record the first time through,
     along with other variables we will need throughout the code. */
    CREATE QUERY ghROUQuery.
    CREATE QUERY ghROQuery.
    {get RowObjUpd ghRowObjUpd}.
    ghROUQuery:SET-BUFFERS(ghRowObjUpd).
  
    ASSIGN ghROURowMod = ghRowObjUpd:BUFFER-FIELD('RowMod':U)
           ghROURowNum = ghRowObjUpd:BUFFER-FIELD('RowNum':U).
  
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Commit dTables  _DB-REQUIRED
FUNCTION Commit RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Client-side part of the Commit function. Copies changed records
            into an update temp-table and sends it to the serverCommit (the
            server-side commit procedure.)
   Params:  <none> 
    Notes:  This is a dynamic SDO version of the function in data.i.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iRowNum         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCnt            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUndoIds        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAppServer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessages       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cASDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBrowsed        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOperatingMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFirstUndoId    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iUndoId         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hROUTable       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowObject      AS ROWID      NO-UNDO.

  /* Transfer modified and added rows to the update table. */
  RUN doBuildUpd.  
  
  {get ASHandle hAppServer}.
  {get RowObjUpdTable hROUTable}.
  RUN serverCommit in hAppServer
    (INPUT-OUTPUT TABLE-HANDLE hROUTable, OUTPUT cMessages, OUTPUT cUndoIds).

  {get ServerOperatingMode cOperatingMode}.
  IF cOperatingMode = 'STATELESS':U THEN DO:
    RUN saveContextAndDestroy IN hAppServer (OUTPUT cContext).
    RUN setPropertyList IN TARGET-PROCEDURE (cContext).
  END.  /* If Stateless */

  /* Append any error messages returned to the message log.  */
  IF cMessages NE "" THEN
    RUN addMessage IN TARGET-PROCEDURE (cMessages, ?, ?).

  /* We need to get the Rowid for the first row (by RowNum) that has failed
     in order to reposition to that row.  */
  IF cUndoIds NE "":U THEN DO:
    DO iCnt = 1 TO NUM-ENTRIES(cUndoIds, ",":U):
      iUndoId = INTEGER(ENTRY(1, ENTRY(iCnt, cUndoIds, ",":U), CHR(3))).
      IF iUndoId > 0 THEN iFirstUndoId = IF iCnt = 1 THEN iUndoId 
                                         ELSE MIN(iFirstUndoId, iUndoId).
    END.  /* Do i to Num entries */  
  END.  /* If cUndoIds NE blank */
  
  /* Return any rows to the client that have been changed by the server. */
  RUN doReturnUpd (INPUT cUndoIds).
     
  RETURN NOT anyMessage().  /* return success if no error msgs. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataColumns dTables  _DB-REQUIRED
FUNCTION getDataColumns RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
  
  cColumns = SUPER().
  
  IF cColumns = '':U THEN
  DO:
    {get RowObject hrowObject}.  
    IF VALID-HANDLE(hROwObject) THEN
    DO i = 1 TO hRowObject:NUM-FIELDS - 4: /* don't include the row* fields*/ 
      ASSIGN 
        hField = hRowObject:BUFFER-FIELD(i)
        cColumns = cColumns 
                 + (IF i = 1 THEN '':U ELSE ',':U) 
                 + hField:NAME.
    END.
    
  END.
  RETURN cColumns.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumns dTables  _DB-REQUIRED
FUNCTION getUpdatableColumns RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the updatablecolumns 
    Notes: This is set from the server object in initializeServerObject.
           Changing this does not affect which fields really are updatable, it
           only gives an error on the client if the field are updated.
------------------------------------------------------------------------------*/
  RETURN gcUpdatable.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdatableColumns dTables  _DB-REQUIRED
FUNCTION setUpdatableColumns RETURNS LOGICAL
  ( pcUpdatableColumns AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose: Set updatable columns  
    Notes:  
------------------------------------------------------------------------------*/
  gcUpdatable = pcUpdatablecolumns.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}
