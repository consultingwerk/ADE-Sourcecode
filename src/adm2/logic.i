&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
/*------------------------------------------------------------------------
    Library     : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE rowObjUpd
  /* Allow users to ommit the hardcoded RCODE-INFORMATION and put it in the 
     include instead. 
     This makes it possible to manually maintain the include using LIKE 
     and thus avoid -inp and -tok limitations 
   ----------------------------------------    
    LIKE  CUSTOMER {&TEMP-TABLE-OPTIONS}  
   --------------------------------------*/
 &IF '{&TEMP-TABLE-OPTIONS}' = '' &THEN
     RCODE-INFORMATION
 &ENDIF
  
 &IF '{&DATA-FIELD-DEFS}' BEGINS '"' &THEN
   {{&DATA-FIELD-DEFS}}
 &ELSE
   {&DATA-FIELD-DEFS}
 &ENDIF  
   {src/adm2/rupdflds.i}.

DEFINE BUFFER b_{&DATA-LOGIC-TABLE}     FOR rowObjUpd.
DEFINE BUFFER old_{&DATA-LOGIC-TABLE}   FOR rowObjUpd.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-isAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isAdd Method-Library 
FUNCTION isAdd RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isCopy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isCopy Method-Library 
FUNCTION isCopy RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isCreate Method-Library 
FUNCTION isCreate RETURNS LOGICAL FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 12.19
         WIDTH              = 52.
/* END WINDOW DEFINITION */
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

&IF DEFINED(EXCLUDE-clearLogicRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearLogicRows Method-Library 
PROCEDURE clearLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF AVAILABLE b_{&DATA-LOGIC-TABLE} THEN
       DELETE b_{&DATA-LOGIC-TABLE} NO-ERROR.
        
   IF AVAILABLE OLD_{&DATA-LOGIC-TABLE} THEN
       DELETE OLD_{&DATA-LOGIC-TABLE} NO-ERROR.

   EMPTY TEMP-TABLE rowObjUpd NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogicBuffer Method-Library 
PROCEDURE getLogicBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE OUTPUT PARAMETER ohUpdateBuffer       AS HANDLE   NO-UNDO.

   IF AVAILABLE b_{&DATA-LOGIC-TABLE} THEN
       ohUpdateBuffer = BUFFER b_{&DATA-LOGIC-TABLE}:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogicRows Method-Library 
PROCEDURE getLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE OUTPUT PARAMETER TABLE FOR b_{&DATA-LOGIC-TABLE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverCommit Method-Library 
PROCEDURE serverCommit :
/*------------------------------------------------------------------------------
  Purpose:     Server-side update procedure executed on the server side of a
------------------------------------------------------------------------------*/
  
  /*
  DEFINE INPUT-OUTPUT  PARAMETER TABLE FOR RowObjUpd.
  DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO INIT "":U.
  
  DEFINE VARIABLE lCheck        AS LOGICAL   NO-UNDO.
  DEFINE BUFFER   bRowObjUpd    FOR RowObjUpd.
  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjFld    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lKillTrans    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSubmitVal    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iChange       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cChanged      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedFlds  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cChangedVals  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cUpdatable    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL NO-UNDO INIT NO.
  DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDeleteMsg    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER   NO-UNDO.

 &IF DEFINED(DATA-LOGIC-TABLE) NE 0 &THEN  /* Skip when compiling templ*/

  IF NOT lQueryContainer THEN
  DO:
      RUN TransactionValidate IN THIS-PROCEDURE NO-ERROR. 
      IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
      DO:
        RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                   INPUT-OUTPUT pocMessages).
        RETURN.      /* Bail out if application code rejected the txn. */
      END.   /* END DO IF RETURN-VALUE NE "" */
      RUN preTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
      IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
      DO:
        RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                   INPUT-OUTPUT pocMessages).
        RETURN.      /* Bail out if application code rejected the txn. */
      END.   /* END DO IF RETURN-VALUE NE "" */
  END.       /* END DO IF Container (SBO) is not doing the Commit. */

  /* Construct the changed value list. This list is actually stored in the 
     before version of the record for an update. */
  {get UpdatableColumns cUpdatable}.
  hRowObjUpd = BUFFER RowObjUpd:HANDLE.

  FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) NE 0:
     IF RowObjUpd.RowMod = "U":U THEN
     DO:
       FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum 
                       AND   bRowObjUpd.RowMod = "":U.
         /* As of 9.1A, we no longer rely on ChangedFields being set
            before this point. Calculate it here so it includes any
            application-generated values. */
       BUFFER-COMPARE RowObjUpd EXCEPT ChangedFields RowMod RowIdent RowNum
                   TO bRowObjUpd CASE-SENSITIVE SAVE cChangedFlds.
     END.    /* END DO IF RowMod = U */
     ELSE IF RowObjUpd.RowMod = "A":U THEN
     DO:
        /* For an Add, set ChangedFields to all fields no longer
           equal to their defined INITIAL value. Determine this by
           creating a RowObject record to compare against. */
       CREATE RowObject.
       BUFFER-COMPARE RowObjUpd EXCEPT ChangedFields RowMod RowIdent RowNum
                   TO RowObject CASE-SENSITIVE SAVE cChangedFlds. 
     END.      /* END DO If "A" for Add */
     ELSE                 /* use all enabled fields for a Copy. */
       cChangedFlds = cUpdatable.
        /* Now assign the list of fields into the ROU record. 
           (Put it in the before record as well for an Update.) 
           This list will be used by query.p code to ASSIGN changes
           back to the database. */
     IF RowObjUpd.RowMod = "U":U THEN
       bRowObjUpd.ChangedFields = cChangedFlds.
     RowObjUpd.ChangedFields = cChangedFlds.
     /* if a row was temporarily created to supply initial values for the
        Add operation BUFFER-COMPARE, delete it now. */
     IF RowObjUpd.RowMod = "A":U AND AVAILABLE(RowObject) THEN
       DELETE RowObject. 
  END.     /* END FOR EACH */

  /* If this is the server side and the ServerSubmitValidation property
     has been set to *yes*, then we execute that normally client side 
     validation here to make sure that it has been done. */
  IF cASDivision = "Server":U THEN 
  DO:
    {get ServerSubmitValidation lSubmitVal}.
    IF lSubmitVal THEN
    DO:
      
      FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod, "A,C,U":U) NE 0:
        /* Validation procs look at RowObject, so we have to create a row
           temporarily for it to use. This will be deleted below. */
        DO TRANSACTION:
          CREATE RowObject.     
        END.
        BUFFER-COPY RowObjUpd TO RowObject.
        
        cChangedFlds = RowObjUpd.ChangedFields.
        DO iChange = 1 TO NUM-ENTRIES(cChangedFlds):
          ASSIGN cChanged = ENTRY(iChange, cChangedFlds)
                 hRowObjFld = hRowObjUpd:BUFFER-FIELD(cChanged)
                 cChangedVals = cChangedVals +
                   (IF cChangedVals NE "":U THEN CHR(1) ELSE "":U) +
                   cChanged + CHR(1) + STRING(hRowObjFld:BUFFER-VALUE).
        END.    /* END DO iChange */

        /* Now pass the values and column list to the client validation. */
        RUN submitValidation (INPUT cChangedVals, cUpdatable).
        DO TRANSACTION:
          DELETE RowObject. 
        END.
      END.      /* END FOR EACH RowObjUpd */  
      /* Exit if any error messages were generated. This means that
         all messages associated with the "client" SubmitValidation will
         be accumulated, but the update transaction will not be attempted
         if there are any prior errors. */
      IF anyMessage() THEN
      DO:
        RUN prepareErrorsForReturn(INPUT "":U, INPUT cASDivision, 
                                   INPUT-OUTPUT pocMessages).
        RETURN.
      END.  /* END IF anyMessage */
    END.   /* END DO IF SUbMitVal */
  END.   /* END DO IF Server */

  TRANS-BLK:
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* This user-defined validation hook is for code to be executed
       inside the transaction, but before any updates occur. */
    RUN beginTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      UNDO, RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */
    
    /* First locate each pre-change record. Find corresponding database record
       and do a buffer-compare to make sure it hasn't been changed. */
    Process-Update-Records-Blk:
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "":U:
        /* For each table in the join, update its fields if on the enabled list.
         NOTE: at present at least we don't check whether fields in this table
         have actually been modified in this record. */
      RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
      IF RETURN-VALUE NE "":U THEN
      DO:
        RUN addMessage In TARGET-PROCEDURE
          (messageNumber(18), ?, RETURN-VALUE).
        ASSIGN lKillTrans = yes
               pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
        UNDO Process-Update-Records-Blk, NEXT Process-Update-Records-Blk.
      END.
        /* Check first whether we care if the database record has been
           changed by another user. This is a settable instance property. */
      {get CheckCurrentChanged lCheck}.
      IF lCheck THEN
      DO:
          RUN compareDBRow In TARGET-PROCEDURE.
          IF RETURN-VALUE NE "":U THEN /* Table name that didn't compare is returned. */
          DO:
            RUN addMessage IN TARGET-PROCEDURE
             (SUBSTITUTE(messageNumber(8), '':U /* No field names available. */) , ?, 
              RETURN-VALUE  /* Table name that didn't compare */).
            pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + "ADM-FIELDS-CHANGED":U + ",":U.
            /* Get the changed version of the record in order to copy
               the new database values into it to pass back to the client.*/
            FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum
                              AND bRowObjUpd.RowMod = "U":U.
            RUN refetchDBRow IN TARGET-PROCEDURE
                  (INPUT BUFFER bRowObjUpd:HANDLE) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
              RUN addMessage IN TARGET-PROCEDURE
                   /* Support return-value from triggers (from RefetchDbRow)*/ 
                   (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
              lKillTrans = yes.
              pocUndoIds = pocUndoIds + STRING(bRowObjUpd.RowNum) + CHR(3) + ",":U.
            END.  /* If ERROR */
            IF cASDivision = 'Server':U THEN
              pocMessages = LEFT-TRIM(pocMessages + CHR(3) + DYNAMIC-FUNCTION('fetchMessages':U),CHR(3)).
              
            /* Don't try to write values to db. Just process next update record. */
            NEXT Process-Update-Records-Blk.
          END.  /* END DO IF compareDBRow returned a table value */
        END.    /* END DO IF CheckCurrentChanged */
        
        DO:   /* If we haven't 'next'ed because of an error, do the update. */
          /* Now find the changed version of the record, move its fields to the
             database record(s) which were found above, and report any errors
             (which would be database triggers at this point). */
          FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum
                          AND   bRowObjUpd.RowMod = "U":U.
          /* Copy the ChangedFields to this buffer too */
          ASSIGN bRowObjUpd.ChangedFields = RowObjUpd.ChangedFields
                 hRowObjUpd               = BUFFER bRowObjUpd:HANDLE.
          RUN assignDBRow IN TARGET-PROCEDURE (INPUT hRowObjUpd).
          IF RETURN-VALUE NE "":U THEN  /* returns table name in error. */
          DO:
            RUN addMessage IN TARGET-PROCEDURE (?, ?, RETURN-VALUE).
            lKillTrans = yes.
            pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
            UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
          END.   /* END DO IF RETURN-VALUE NE "" */
          
          /* Pass back the final values to the client. Note - because we
             want to get values changed by the db trigger, we copy *all*
             fields, not just the ones that are enabled in the Data Object. */
          RUN refetchDBRow IN TARGET-PROCEDURE
                (INPUT BUFFER bRowObjUpd:HANDLE) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO:
            RUN addMessage IN TARGET-PROCEDURE 
                   /* Support return-value from triggers (from RefetchDbRow)*/ 
                  (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
            lKillTrans = yes.
            pocUndoIds = pocUndoIds + STRING(bRowObjUpd.RowNum) + CHR(3) + ",":U.
          END.  /* if ERROR */
          
          /* Add a record to the ModRowIdent table */
          IF NOT CAN-FIND(FIRST ModRowIdent WHERE
                                ModRowIdent.RowIdentIdx = bRowObjUpd.RowIdentIdx
                                AND
                                ModRowIdent.RowIdent = bRowObjUpd.RowIdent) THEN
          DO:
            CREATE ModRowIdent.
            ASSIGN ModRowIdent.RowIdent = bRowObjUpd.RowIdent
                   ModRowIdent.RowIdentIdx = SUBSTR(bRowObjUpd.RowIdent, 1, xiRocketIndexLimit)
                   .
          END.  /* DO if ModRowIdent is already there */
      END.  /* END DO the update for this row if no error */
    END.  /* END FOR EACH RowObjUpd */

    /* This code to handle DELETE operations: */    
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "D":U:
      /* This will procedure will do the Delete (looking at RowMod) */
      RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
      IF RETURN-VALUE NE "":U THEN
      DO:
        /* fetchDbRowForUpdate will return "Delete" as LAST element of the 
           return-value if the Delete and not the FIND EXCLUSIVE-LOCK failed. */
        IF ENTRY(NUM-ENTRIES(RETURN-VALUE),RETURN-VALUE) = "Delete":U THEN
        DO:
          IF NUM-ENTRIES(RETURN-VALUE) = 2 THEN
            cDeleteMsg = messageNumber(23).
          ELSE /* support return-value from triggers */
            ASSIGN 
              cDeleteMsg = RETURN-VALUE 
              ENTRY(NUM-ENTRIES(cDeleteMsg),cDeleteMsg) = "":U
              ENTRY(1,cDeleteMsg) = "":U
              cDeleteMsg = TRIM(cDeleteMsg,",":U).
        END. /* if entry(num-entries(return-value) = 'delete' */ 
        ELSE /* locked record */
          cDeleteMsg = messageNumber(18).
        RUN addMessage IN TARGET-PROCEDURE
              (cDeleteMsg, ?, ENTRY(1,RETURN-VALUE)).
        ASSIGN lKillTrans = yes
               pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
      END.      /* END DO IF RETURN-VALUE NE "" */
    END.        /* END FOR EACH block */

    /* This code to handle ADD/COPY operations: */
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "A":U OR
                             RowObjUpd.RowMod = "C":U:  
      /* This procedure will do the record Create (looking at RowMod) */
      RUN assignDBRow IN TARGET-PROCEDURE (INPUT BUFFER RowObjUpd:HANDLE).
      IF RETURN-VALUE NE "":U THEN  /* returns table name in error. */
      DO:
        /* If the add failed, clear the rowident field because the rowid 
           assigned to it after the BUFFER-CREATE in assignDBRow is now invalid 
           due to the failure. */
        ASSIGN RowObjUpd.RowIdent = "" RowObjUpd.RowIdentIdx = "".
        /* If BUFFER-CREATE faile because of a CREATE trigger we add return-value
           before the table name, otherwise set the first parameter of addMessage
           to ? to retireve errors from error-status */
        RUN addMessage IN TARGET-PROCEDURE                                  
                          (IF NUM-ENTRIES(RETURN-VALUE,CHR(3)) > 1                 
                           THEN ENTRY(1,RETURN-VALUE,CHR(3))                           
                           ELSE ?,                                                   
                           ?,                                                        
                           ENTRY(NUM-ENTRIES(RETURN-VALUE, CHR(3)),RETURN-VALUE,CHR(3))       
                           ).                                                        
         lKillTrans = yes.
         pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
         UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
      END.    /* END DO IF ERROR-STATUS:ERROR OR cErrorMsgs NE "":U */

      /* Pass back the final values to the client. Note - because we
         want to get values changed by the db trigger, we copy *all*
         fields, not just the ones that are enabled in the Data Object. */
      RUN refetchDBRow In TARGET-PROCEDURE
        (INPUT BUFFER RowObjUpd:HANDLE) NO-ERROR.      
      /* if a database trigger returns error it will be catched here */
      IF ERROR-STATUS:ERROR THEN
      DO:
        lKillTrans = yes.
        pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
        RUN addMessage IN TARGET-PROCEDURE 
            /* Support return-value from triggers (from RefetchDbRow)*/ 
            (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
        UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
      END.

      /* Add a record to the ModRowIdent table */
      IF NOT CAN-FIND(FIRST ModRowIdent WHERE
                            ModRowIdent.RowIdentIdx = RowObjUpd.RowIdentIdx
                            AND
                            ModRowIdent.RowIdent = RowObjUpd.RowIdent) THEN
      DO:
        CREATE ModRowIdent.
        ASSIGN ModRowIdent.RowIdent = RowObjUpd.RowIdent
               ModRowIdent.RowIdentIdx = SUBSTR(RowObjUpd.RowIdent, 1, xiRocketIndexLimit)
               .
      END.  /* DO if ModRowIdent is already there */        
    END.  /* END FOR EACH block for Adds. */

    /* If errors of any kind, undo the transaction and leave. */
    IF pocUndoIds NE "":U OR lKillTrans THEN
      UNDO Trans-Blk, LEAVE Trans-Blk.

    /* This user-defined validation hook is for code to be executed
       inside the transaction, but after all updates occur. */
    RUN endTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      UNDO, RETURN.     /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */
  END.          /* END transaction block. */ 
  
  /* RELEASE the database record(s). */
  RUN releaseDBRow IN TARGET-PROCEDURE.
  
  /* Add a message to indicate the update has been cancelled. */
  IF pocUndoIds NE "":U OR lKillTrans THEN
    RUN addMessage IN TARGET-PROCEDURE (messageNumber(15),?,?).
  
&ENDIF          /* ENDIF QUERY defined */
  
  /* This user-defined validation hook is for code to be executed
     outside the transaction, after all updates occur. */
  IF NOT lQueryContainer THEN
  DO:
    RUN postTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      RETURN.      /* Bail out. */
    END.   /* END DO IF RETURN-VALUE NE "" */
  END.       /* END DO IF Container (SBO) is not doing the commit for us. */
        
    /* If we're not on an AppServer, the messages will be available to the
     caller, so don't "fetch" them (which would also delete them). */
  RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                             INPUT-OUTPUT pocMessages).
  */
                               
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLogicBuffer Method-Library 
PROCEDURE setLogicBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER phAfterImageBuffer       AS HANDLE NO-UNDO. 
   DEFINE INPUT PARAMETER phBeforeImageBuffer      AS HANDLE NO-UNDO. 

   DEFINE VARIABLE hBuffer    AS HANDLE       NO-UNDO.
        
   IF VALID-HANDLE(phAfterImageBuffer) THEN
   DO:
       hBuffer = BUFFER b_{&DATA-LOGIC-TABLE}:HANDLE.
       hBuffer:BUFFER-COPY(phAfterImageBuffer).
   END.

   IF VALID-HANDLE(phBeforeImageBuffer) THEN
   DO:
       hBuffer = BUFFER OLD_{&DATA-LOGIC-TABLE}:HANDLE.
       hBuffer:BUFFER-COPY(phBeforeImageBuffer).
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLogicRows Method-Library 
PROCEDURE setLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER TABLE FOR b_{&DATA-LOGIC-TABLE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-isAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isAdd Method-Library 
FUNCTION isAdd RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (AVAILABLE b_{&DATA-LOGIC-TABLE} AND b_{&DATA-LOGIC-TABLE}.Rowmod = 'A':U).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isCopy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isCopy Method-Library 
FUNCTION isCopy RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (AVAILABLE b_{&DATA-LOGIC-TABLE} AND b_{&DATA-LOGIC-TABLE}.Rowmod = 'C':U).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isCreate Method-Library 
FUNCTION isCreate RETURNS LOGICAL:
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (NOT AVAILABLE old_{&DATA-LOGIC-TABLE}).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

