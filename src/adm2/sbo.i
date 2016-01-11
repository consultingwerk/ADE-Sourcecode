&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
    File        : sbo.i
    Purpose     : Basic Method Library for the ADMClass sbo.
  
    Syntax      : {src/adm2/sbo.i}

    Description :
  
    Modified    : June 12, 2000 -- Version 9.1B
     
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass sbo
&ENDIF

&IF "{&ADMClass}":U = "sbo":U &THEN
  {src/adm2/sboprop.i}
&ENDIF

  /* This is an array of all the update table handles. */
  DEFINE VARIABLE ghUpdTables          AS HANDLE EXTENT 20    NO-UNDO.

  /* Now define all the actual Upd temp-tables using preprocessors which 
     are used in the SBO. */
  {src/adm2/updtabledef.i 1}
  {src/adm2/updtabledef.i 2}
  {src/adm2/updtabledef.i 3}
  {src/adm2/updtabledef.i 4}
  {src/adm2/updtabledef.i 5}
  {src/adm2/updtabledef.i 6}
  {src/adm2/updtabledef.i 7}
  {src/adm2/updtabledef.i 8}
  {src/adm2/updtabledef.i 9}
  {src/adm2/updtabledef.i 10}
  {src/adm2/updtabledef.i 11}
  {src/adm2/updtabledef.i 12}
  {src/adm2/updtabledef.i 13}
  {src/adm2/updtabledef.i 14}
  {src/adm2/updtabledef.i 15}
  {src/adm2/updtabledef.i 16}
  {src/adm2/updtabledef.i 17}
  {src/adm2/updtabledef.i 18}
  {src/adm2/updtabledef.i 19}
  {src/adm2/updtabledef.i 20}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-initDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataObjectOrdering Method-Library 
FUNCTION initDataObjectOrdering RETURNS CHARACTER
  (   )  FORWARD.

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
         HEIGHT             = 7.86
         WIDTH              = 48.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
  
  /* Starts super procedure */
  RUN start-super-proc("adm2/sbo.p":U).
  RUN start-super-proc("adm2/sboext.p":U).
  /* sboext.p is merely a simple "extension" of sbo.p.  This was necessary
     because functions don't have their own action segement and sbo.p got
     too big and had to be broken up.  All of the functions in sboext.p
     are get and set property functions.  */
  RUN modifyListProperty IN TARGET-PROCEDURE
       ( THIS-PROCEDURE, 'ADD':U, 'SupportedLinks':U, 'Filter-Target':U).
  
  RUN modifyListProperty IN TARGET-PROCEDURE
       ( THIS-PROCEDURE, 'ADD':U, 'DataTargetEvents':U, 'RegisterObject':U).

  {set QueryObject yes}.               /* True for SBOs as for SDOs. */
      
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */

  {src/adm2/custom/sbocustom.i}

  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-serverCommitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverCommitTransaction Method-Library 
PROCEDURE serverCommitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     server-side version of CommitTransaction to receive all
               RowObjUpd table updates and pass them on to server-side SDOs.
  Parameters:  INPUT-OUTPUT -- up to twenty RowObjUpd table references -- 
                  unused tables have dummy placeholder TABLE-HANDLEs;
               OUTPUT pcMessages AS CHARACTER -- error messages
               OUTPUT pcUndoIds  AS CHARACTER -- rowids of error'd rows
 
------------------------------------------------------------------------------*/
 
  {src/adm2/updparam.i 1}
  {src/adm2/updparam.i 2}
  {src/adm2/updparam.i 3}
  {src/adm2/updparam.i 4}
  {src/adm2/updparam.i 5}
  {src/adm2/updparam.i 6}
  {src/adm2/updparam.i 7}
  {src/adm2/updparam.i 8}
  {src/adm2/updparam.i 9}
  {src/adm2/updparam.i 10}
  {src/adm2/updparam.i 11}
  {src/adm2/updparam.i 12}
  {src/adm2/updparam.i 13}
  {src/adm2/updparam.i 14}
  {src/adm2/updparam.i 15}
  {src/adm2/updparam.i 16}
  {src/adm2/updparam.i 17}
  {src/adm2/updparam.i 18}
  {src/adm2/updparam.i 19}
  {src/adm2/updparam.i 20}

  DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER   NO-UNDO.
 
  DEFINE VARIABLE cContained  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iDO         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hDO         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOrdering   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cASDivision AS CHARACTER  NO-UNDO.

  /* These vars are for foreign field assignment. */
  DEFINE VARIABLE hBuf           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFld           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSaveDO        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSaveTable     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSaveBuf       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSaveQry       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSaveCol       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCol           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCol           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowMod        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFld           AS CHARACTER  NO-UNDO.

  {get ContainedDataObjects cContained}.
  {get DataObjectOrdering cOrdering}.
  {get ASDivision cASDivision}.

  /* First do any validation the SBO needs to do at the very outset. */
  RUN preTransactionValidate IN THIS-PROCEDURE NO-ERROR.
  IF RETURN-VALUE NE "":U THEN
  DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision,
                                 INPUT-OUTPUT pcMessages).
      RETURN.
  END.      /* END DO IF error return */
  
  DO iDO = 1 TO NUM-ENTRIES(cContained):
      hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
      IF LOOKUP('preTransactionValidate':U, hDO:INTERNAL-ENTRIES) 
          NE 0 THEN
      DO:
         /* This will find which of the hard-coded AppBuilder-generated
            update table definitions corresponds to this entry in the
            ContainedDataObjects list. */
         iEntry = LOOKUP(STRING(iDO), cOrdering).
         hTable = ghUpdTables[iEntry].
         IF hTable:HAS-RECORDS THEN
           RUN pushTableAndValidate IN hDO (INPUT "Pre":U, 
                                 INPUT-OUTPUT TABLE-HANDLE hTable).
           IF RETURN-VALUE NE "":U THEN
           DO:
             RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision,
                                        INPUT-OUTPUT pcMessages).
             RETURN.
           END.     /* END DO IF error return */
      END.          /* END DO IF preTV defined in SDO */
  END.              /* END DO iDO -- for each contained SDO */

  DO TRANSACTION ON ERROR UNDO, LEAVE:
 
      /* First run any SBO specific logic for the transaction start. */
      RUN beginTransactionValidate IN THIS-PROCEDURE NO-ERROR.
      IF RETURN-VALUE NE "":U THEN
      DO:
        RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision,
                                   INPUT-OUTPUT pcMessages).
        UNDO, RETURN.
      END.     /* END DO IF error return */

      DO iDO = 1 TO NUM-ENTRIES(cContained):
        hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
        iEntry = LOOKUP(STRING(iDO), cOrdering).
        hTable = ghUpdTables[iEntry].
        
        IF hTable:HAS-RECORDS THEN
        DO:
          /* In this section we look to see if a parent and one or more child
             rows are being Added at the same time. If so, we copy ForeignField
             key values from the parent rec to all newly added child recs,
             *after* running serverCommit in the parent (so that the key values
             will have been assigned for it), and *before* running it for
             the child SDO. */
          IF VALID-HANDLE(hSaveDO) THEN
          DO:
          /* We have saved off keys from the previous table. See if that's
             a Data-Source for the current table. */
             {get DataSource hSource hDO}.
             IF hSource = hSaveDO THEN
             DO:
               /* The previous SDO was the current SDO's data-source,
                  so look for key values to assign. */
               {get ForeignFields cForeignFields hDO}.
               IF cForeignFields NE "":U THEN
               DO:
                   hSaveBuf = hSaveTable:DEFAULT-BUFFER-HANDLE.
                   CREATE QUERY hSaveQry.
                   hSaveQry:SET-BUFFERS(hSaveBuf).
                   hSaveQry:QUERY-PREPARE('For each ' + hSaveTable:NAME).
                   hSaveQry:QUERY-OPEN().
                   hSaveQry:GET-FIRST().
                   /* Now we have the buffer the the parent record. 
                      Create another query to loop through the children. */
                   ASSIGN hBuf    = hTable:DEFAULT-BUFFER-HANDLE
                          hRowMod = hBuf:BUFFER-FIELD('RowMod':U).
                   CREATE QUERY hQry.
                   hQry:SET-BUFFERS(hBuf).
                   hQry:QUERY-PREPARE('For each ' + hTable:NAME).
                   hQry:QUERY-OPEN().
                   hQry:GET-FIRST().
                   DO WHILE hBuf:AVAILABLE:
                     IF hRowMod:BUFFER-VALUE = "A":U THEN
                     DO:
                       /* Assign the key values from the Saved record
                          to each added row in the current SDO. */
                       DO iCol = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
                           ASSIGN hSaveCol =    /* This is the parent */
                                    hSaveBuf:BUFFER-FIELD(ENTRY(iCol + 1,
                                                          cForeignFields))
                                  /* remove the ObjectName qualifier from the
                                     field name for the child SDO. */
                                  cFld = ENTRY(iCol, cForeignFields)
                                  hCol =        /* This is the child */
                                    hBuf:BUFFER-FIELD(ENTRY(NUM-ENTRIES(cFld, ".":U), cFld, ".":U))
                                  hCol:BUFFER-VALUE = hSaveCol:BUFFER-VALUE.
                       END.      /* END DO iCol == for each foreign field */ 
                     END.        /* END DO IF "A"dd */
                     hQry:GET-NEXT().
                   END.          /* END DO WHILE AVAIL == for each child. */
                   hQry:QUERY-CLOSE().
                   hSaveQry:QUERY-CLOSE().
                   DELETE OBJECT hQry.
                   DELETE OBJECT hSaveQry.
               END.              /* END DO if foreign fields */
             END.                /* END DO IF SaveDO is DataSource */
          END.                   /* END DO IF ValidHandle SaveDO */

          RUN serverCommit IN hDO
              (INPUT-OUTPUT TABLE-HANDLE hTable, 
               OUTPUT pcMessages,
               OUTPUT pcUndoIds).
         
          /* if we're on the Server-side of a divided SBO, serverCommit for
             the SDO will have put any error messages into pcMessages.
             Otherwise it will simply have logged them with addMessage. */
          IF (cASDivision = 'Server':U AND pcMessages NE "":U) OR
              DYNAMIC-FUNCTION ('anyMessage':U IN TARGET-PROCEDURE) THEN
          DO:
            UNDO, RETURN.
          END.

          /* Now that we're back from the commit, check to see if it
             was an Add. If so, save the DO and Table handles to use to
             create keys for the next table if appropriate. */
          hBuf = hTable:DEFAULT-BUFFER-HANDLE.
          CREATE QUERY hQry.
          hQry:SET-BUFFERS(hBuf).
          hQry:QUERY-PREPARE('For each ' + hTable:NAME).
          hQry:QUERY-OPEN().
          hQry:GET-FIRST().
          hCol = hBuf:BUFFER-FIELD('RowMod').
          IF hCol:BUFFER-VALUE = "A":U THEN
              ASSIGN hSaveDO    = hDO
                     hSaveTable = hTable.
          ELSE ASSIGN hSaveDO = ?
                      hSaveTable = ?.
          hQry:QUERY-CLOSE().
          DELETE OBJECT hQry.

        END.      /* END DO IF HAS-RECORDS */
      END.        /* END DO iDO -- serverCommit for each SDO */
      /* Finally do any validation the SBO needs to do at the very end
         of the transaction. */
        RUN endTransactionValidate IN THIS-PROCEDURE NO-ERROR.
        IF RETURN-VALUE NE "":U THEN
        DO:
          RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision,
                                     INPUT-OUTPUT pcMessages).
          UNDO, RETURN.
        END.     /* END DO IF error return */

  END.            /* END TRANSACTION */
          
  DO iDO = 1 TO NUM-ENTRIES(cContained):
      hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
      IF LOOKUP('postTransactionValidate':U, hDO:INTERNAL-ENTRIES) 
          NE 0 THEN
      DO:
        iEntry = LOOKUP(STRING(iDO), cOrdering).
        hTable = ghUpdTables[iEntry].
         
        IF hTable:HAS-RECORDS THEN
          RUN pushTableAndValidate IN hDO (INPUT "Post":U,
                                 INPUT-OUTPUT TABLE-HANDLE hTable).
          IF RETURN-VALUE NE "":U THEN
          DO:
              RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision,
                                         INPUT-OUTPUT pcMessages).
              RETURN.
          END.      /* END DO IF error return */
      END.          /* END DO IF postTV defined in SDO */
  END.              /* END DO iDO -- for each contained SDO */
  /* Finally do any validation the SBO needs to do at the very end. */
  RUN postTransactionValidate IN THIS-PROCEDURE NO-ERROR.
  IF RETURN-VALUE NE "":U THEN
  DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision,
                                 INPUT-OUTPUT pcMessages).
      RETURN.
  END.     /* END DO IF error return */

  RETURN.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-initDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataObjectOrdering Method-Library 
FUNCTION initDataObjectOrdering RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Initializes the mapping of the AppBuilder-generated order of
            Upd tables to the developer-defined update order.
   Params:  <none>
    Notes:  This is used in commitTransaction and serverCommitTransaction
            to order the table parameters properly.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iOrder         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDONames       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOrdering      AS CHARACTER  NO-UNDO INIT "":U.
 DEFINE VARIABLE iEntry         AS INTEGER    NO-UNDO.
  
  {get DataObjectNames cDONames}.
  DO iOrder = 1 TO {&MaxContainedDataObjects}:
      IF VALID-HANDLE(ghUpdTables[iOrder]) THEN
      DO:
          cObjectName = ghUpdTables[iOrder]:NAME.
          iEntry = LOOKUP(cObjectName, cDONames).
          cOrdering = cOrdering + (IF cOrdering NE "":U THEN ",":U ELSE "":U) +
              STRING(iEntry).
      END.
      ELSE LEAVE.
  END.
   
  RETURN cOrdering.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

