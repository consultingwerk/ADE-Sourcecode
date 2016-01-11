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

/* NOTE: The &END  is in the LAST procedure ... 
   make sure it is moved if a new mproc/func is added */ 
&IF DEFINED(adm-datalogic) = 0 &THEN
  &GLOB adm-datalogic

DEFINE VARIABLE ghDataLogicProcedure            AS HANDLE   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getDataLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataLogicObject Method-Library 
FUNCTION getDataLogicObject RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

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

RUN initializeLogicObject IN TARGET-PROCEDURE NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-beginTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beginTransactionValidate Method-Library 
PROCEDURE beginTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b_rowObjUpd               FOR rowObjUpd.

    DEFINE VARIABLE cMessageList            AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cValueList              AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE hTT                     AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hBeforeImageBuffer      AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hRowObjUpd              AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hReturnBuffer           AS HANDLE        NO-UNDO.
    
    IF CAN-DO(ghDataLogicProcedure:INTERNAL-ENTRIES, "beginTransactionValidate":U) THEN   
    DO:
        hTT = TEMP-TABLE rowObjUpd:HANDLE.
        RUN setLogicRows IN THIS-PROCEDURE
            (INPUT TABLE-HANDLE hTT).
        RUN SUPER.
        IF RETURN-VALUE NE "":U THEN
           cMessageList = RETURN-VALUE.
        RUN getLogicRows IN THIS-PROCEDURE
            (OUTPUT TABLE-HANDLE hTT).
        RUN clearLogicRows IN THIS-PROCEDURE.
    END.
    ELSE   
    FOR EACH rowObjUpd WHERE rowObjUpd.RowMod NE "":U: 

       /* Fetch the before image of the current record if being modified */
       FIND FIRST b_rowObjUpd 
            WHERE b_rowObjUpd.rowIdent EQ rowObjUpd.rowIdent
              AND b_rowObjUpd.rowMod   EQ "":U
            NO-ERROR.

       hBeforeImageBuffer = IF AVAILABLE b_rowObjUpd THEN BUFFER b_rowObjUpd:HANDLE ELSE ?.

       RUN setLogicBuffer IN THIS-PROCEDURE
           (INPUT BUFFER rowObjUpd:HANDLE,
            INPUT hBeforeImageBuffer).

       IF CAN-DO("A,C,U":U,rowObjUpd.rowMod) THEN
       DO:

          IF rowObjUpd.rowMod EQ "A":U OR rowObjUpd.rowMod EQ "C":U THEN
          DO:
              RUN createBeginTransValidate IN THIS-PROCEDURE NO-ERROR.
              IF RETURN-VALUE NE "":U THEN
                 cMessageList = RETURN-VALUE.
          END.

          RUN writeBeginTransValidate IN THIS-PROCEDURE NO-ERROR.
          IF RETURN-VALUE NE "":U THEN
              cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                           + RETURN-VALUE.
       END.
       ELSE
       IF rowObjUpd.rowMod EQ "D":U THEN
       DO:
          RUN deleteBeginTransValidate IN THIS-PROCEDURE NO-ERROR.
          IF RETURN-VALUE NE "":U THEN
             cMessageList = RETURN-VALUE.
       END.

       RUN getLogicBuffer IN THIS-PROCEDURE
           (OUTPUT hReturnBuffer).
        
       hRowObjUpd = BUFFER rowObjUpd:HANDLE.
       hRowObjUpd:BUFFER-COPY(hReturnBuffer).

       RUN clearLogicRows IN THIS-PROCEDURE.

    END.

    ERROR-STATUS:ERROR = NO.
    RETURN cMessageList.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endTransactionValidate Method-Library 
PROCEDURE endTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b_rowObjUpd               FOR rowObjUpd.

    DEFINE VARIABLE cMessageList            AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cValueList              AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE hTT                     AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hBeforeImageBuffer      AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hRowObjUpd              AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hReturnBuffer           AS HANDLE        NO-UNDO.
    
    IF CAN-DO(ghDataLogicProcedure:INTERNAL-ENTRIES, "endTransactionValidate":U) THEN   
    DO:
        hTT = TEMP-TABLE rowObjUpd:HANDLE.
        RUN setLogicRows IN THIS-PROCEDURE
            (INPUT TABLE-HANDLE hTT).
        RUN SUPER.
        IF RETURN-VALUE NE "":U THEN
           cMessageList = RETURN-VALUE.
        RUN getLogicRows IN THIS-PROCEDURE
            (OUTPUT TABLE-HANDLE hTT).
        RUN clearLogicRows IN THIS-PROCEDURE.
    END.
    ELSE   
    FOR EACH rowObjUpd WHERE rowObjUpd.RowMod NE "":U: 

       /* Fetch the before image of the current record if being modified */
       FIND FIRST b_rowObjUpd 
            WHERE b_rowObjUpd.rowIdent EQ rowObjUpd.rowIdent
              AND b_rowObjUpd.rowMod   EQ "":U
            NO-ERROR.

       hBeforeImageBuffer = IF AVAILABLE b_rowObjUpd THEN BUFFER b_rowObjUpd:HANDLE ELSE ?.

       RUN setLogicBuffer IN THIS-PROCEDURE
           (INPUT BUFFER rowObjUpd:HANDLE,
            INPUT hBeforeImageBuffer).

       IF CAN-DO("A,C,U":U,rowObjUpd.rowMod) THEN
       DO:

          IF rowObjUpd.rowMod EQ "A":U OR rowObjUpd.rowMod EQ "C":U THEN
          DO:
              RUN createEndTransValidate IN THIS-PROCEDURE NO-ERROR.
              IF RETURN-VALUE NE "":U THEN
                 cMessageList = RETURN-VALUE.
          END.

          RUN writeEndTransValidate IN THIS-PROCEDURE NO-ERROR.
          IF RETURN-VALUE NE "":U THEN
              cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                           + RETURN-VALUE.
       END.
       ELSE
       IF rowObjUpd.rowMod EQ "D":U THEN
       DO:
          RUN deleteEndTransValidate IN THIS-PROCEDURE NO-ERROR.
          IF RETURN-VALUE NE "":U THEN
             cMessageList = RETURN-VALUE.
       END.

       RUN getLogicBuffer IN THIS-PROCEDURE
           (OUTPUT hReturnBuffer).

       hRowObjUpd = BUFFER rowObjUpd:HANDLE.
       hRowObjUpd:BUFFER-COPY(hReturnBuffer).

       RUN clearLogicRows IN THIS-PROCEDURE.

    END.

    ERROR-STATUS:ERROR = NO.
    RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeLogicObject Method-Library 
PROCEDURE initializeLogicObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF '{&DATA-LOGIC-PROCEDURE}':U <> '':U  AND '{&DATA-LOGIC-PROCEDURE}':U <> '.p':U &THEN
  DEFINE VARIABLE cDataLogicProc    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataProcedure    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProc             AS HANDLE    NO-UNDO.
  
  ASSIGN
    cDataLogicProc = '{&DATA-LOGIC-PROCEDURE}':U
    cDataProcedure = TARGET-PROCEDURE:FILE-NAME.
  
  IF INDEX(cDataProcedure,'_cl.':U) > 0 
  AND INDEX(cDataProcedure,'_cl.':U) = LENGTH(cDataProcedure) - 4 THEN
  DO:
    IF R-INDEX(cDataLogicProc,'.':U) > 1 THEN
      SUBSTRING(cDataLogicProc,R-INDEX(cDataLogicProc,'.':U),1) = '_cl.':U.
    ELSE 
      cDataLogicProc = cDataLogicProc + '_cl':U.
  END.

  IF SEARCH(REPLACE(cDataLogicProc,".p":U,".r":U)) NE ? 
  OR SEARCH(cDataLogicProc) NE ? THEN 
  DO:
    /* We do not look for a running instance, but run one logic procedure per SDO */
    RUN VALUE(cDataLogicProc) PERSISTENT SET ghDataLogicProcedure.
    THIS-PROCEDURE:ADD-SUPER-PROCEDURE(ghDataLogicProcedure, SEARCH-TARGET).
  END.
  
  ELSE
    MESSAGE SUBSTITUTE("The business logic procedure &1 does not exist.",cDataLogicProc) SKIP 
            "Please modify the preprocessor located in the Definitions section." SKIP 
            "You may specify an existing business logic procedure, or you can delete the preprocessor entirely."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyNewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modifyNewRecord Method-Library 
PROCEDURE modifyNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to modify values of a new record before 
               dataAvailable is published 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNewRowObject   AS HANDLE     NO-UNDO.
  
  hRowObject = BUFFER rowObject:HANDLE.
  
  IF CAN-DO(ghDataLogicProcedure:INTERNAL-ENTRIES, "modifyNewRecord":U) THEN
  DO:
     RUN setLogicBuffer IN THIS-PROCEDURE
         (INPUT hRowObject,
          INPUT ?).
     RUN SUPER.
     RUN getLogicBuffer IN THIS-PROCEDURE
           (OUTPUT hNewRowObject).
     hRowObject:BUFFER-COPY(hNewRowObject).
     RUN clearLogicRows IN THIS-PROCEDURE.
  END.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-postTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postTransactionValidate Method-Library 
PROCEDURE postTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE BUFFER b_rowObjUpd               FOR rowObjUpd.

    DEFINE VARIABLE cMessageList            AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cValueList              AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE hTT                     AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hBeforeImageBuffer      AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hRowObjUpd              AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hReturnBuffer           AS HANDLE        NO-UNDO.
    
    IF CAN-DO(ghDataLogicProcedure:INTERNAL-ENTRIES, "postTransactionValidate":U) THEN   
    DO:
        hTT = TEMP-TABLE rowObjUpd:HANDLE.
        RUN setLogicRows IN THIS-PROCEDURE
            (INPUT TABLE-HANDLE hTT).
        RUN SUPER.
        IF RETURN-VALUE NE "":U THEN
           cMessageList = RETURN-VALUE.
        RUN getLogicRows IN THIS-PROCEDURE
            (OUTPUT TABLE-HANDLE hTT).
        RUN clearLogicRows IN THIS-PROCEDURE.
    END.
    ELSE   
    FOR EACH rowObjUpd WHERE rowObjUpd.RowMod NE "":U: 

       /* Fetch the before image of the current record if being modified */
       FIND FIRST b_rowObjUpd 
            WHERE b_rowObjUpd.rowIdent EQ rowObjUpd.rowIdent
              AND b_rowObjUpd.rowMod   EQ "":U
            NO-ERROR.

       hBeforeImageBuffer = IF AVAILABLE b_rowObjUpd THEN BUFFER b_rowObjUpd:HANDLE ELSE ?.

       RUN setLogicBuffer IN THIS-PROCEDURE
           (INPUT BUFFER rowObjUpd:HANDLE,
            INPUT hBeforeImageBuffer).

       IF CAN-DO("A,C,U":U,rowObjUpd.rowMod) THEN
       DO:

          IF rowObjUpd.rowMod EQ "A":U OR rowObjUpd.rowMod EQ "C":U THEN
          DO:
              RUN createPostTransValidate IN THIS-PROCEDURE NO-ERROR.
              IF RETURN-VALUE NE "":U THEN
                 cMessageList = RETURN-VALUE.
          END.

          RUN writePostTransValidate IN THIS-PROCEDURE NO-ERROR.
          IF RETURN-VALUE NE "":U THEN
              cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                           + RETURN-VALUE.
       END.
       ELSE
       IF rowObjUpd.rowMod EQ "D":U THEN
       DO:
          RUN deletePostTransValidate IN THIS-PROCEDURE NO-ERROR.
          IF RETURN-VALUE NE "":U THEN
             cMessageList = RETURN-VALUE.
       END.

       RUN getLogicBuffer IN THIS-PROCEDURE
           (OUTPUT hReturnBuffer).

       hRowObjUpd = BUFFER rowObjUpd:HANDLE.
       hRowObjUpd:BUFFER-COPY(hReturnBuffer).

       RUN clearLogicRows IN THIS-PROCEDURE.

    END.

    ERROR-STATUS:ERROR = NO.
    RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-preTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate Method-Library 
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE BUFFER b_rowObjUpd               FOR rowObjUpd.

    DEFINE VARIABLE cMessageList            AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cValueList              AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE hTT                     AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hBeforeImageBuffer      AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hRowObjUpd              AS HANDLE        NO-UNDO.
    DEFINE VARIABLE hReturnBuffer           AS HANDLE        NO-UNDO.
    
    IF CAN-DO(ghDataLogicProcedure:INTERNAL-ENTRIES, "preTransactionValidate") THEN   
    DO:
        hTT = TEMP-TABLE rowObjUpd:HANDLE.
        RUN setLogicRows IN THIS-PROCEDURE
            (INPUT TABLE-HANDLE hTT).
        RUN SUPER.
        IF RETURN-VALUE NE "":U THEN
           cMessageList = RETURN-VALUE.
        RUN getLogicRows IN THIS-PROCEDURE
            (OUTPUT TABLE-HANDLE hTT).
        RUN clearLogicRows IN THIS-PROCEDURE.
    END.
    ELSE
    FOR EACH rowObjUpd WHERE rowObjUpd.RowMod NE "":U: 

       /* Fetch the before image of the current record if being modified */
       FIND FIRST b_rowObjUpd 
            WHERE b_rowObjUpd.rowIdent EQ rowObjUpd.rowIdent
              AND b_rowObjUpd.rowMod   EQ "":U
            NO-ERROR.      

       hBeforeImageBuffer = IF AVAILABLE b_rowObjUpd THEN BUFFER b_rowObjUpd:HANDLE ELSE ?.
                                                                          
       RUN setLogicBuffer IN THIS-PROCEDURE
           (INPUT BUFFER rowObjUpd:HANDLE,
            INPUT hBeforeImageBuffer).
      
       IF CAN-DO("A,C,U":U,rowObjUpd.rowMod) THEN
       DO:

          IF rowObjUpd.rowMod EQ "A":U OR rowObjUpd.rowMod EQ "C":U THEN
          DO:
              RUN createPreTransValidate IN THIS-PROCEDURE NO-ERROR.
              IF RETURN-VALUE NE "":U THEN
                 cMessageList = RETURN-VALUE.
          END.
      
          RUN writePreTransValidate IN THIS-PROCEDURE NO-ERROR.
          IF RETURN-VALUE NE "":U THEN
              cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                           + RETURN-VALUE.
       END.
       ELSE
       IF rowObjUpd.rowMod EQ "D":U THEN
       DO:
          RUN deletePreTransValidate IN THIS-PROCEDURE NO-ERROR.
          IF RETURN-VALUE NE "":U THEN
             cMessageList = RETURN-VALUE.
       END.
      
       RUN getLogicBuffer IN THIS-PROCEDURE
           (OUTPUT hReturnBuffer).

       hRowObjUpd = BUFFER rowObjUpd:HANDLE.
       hRowObjUpd:BUFFER-COPY(hReturnBuffer).

       RUN clearLogicRows IN THIS-PROCEDURE.
        
    END.
    
    ERROR-STATUS:ERROR = NO.
    RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowObjectValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate Method-Library 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObject record client-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNewRowObject   AS HANDLE     NO-UNDO.
  hRowObject = BUFFER rowObject:HANDLE.
  IF CAN-DO(ghDataLogicProcedure:INTERNAL-ENTRIES, "rowObjectValidate":U) THEN
  DO:
     RUN setLogicBuffer IN THIS-PROCEDURE
         (INPUT hRowObject,
          INPUT ?).
     RUN SUPER.
     IF RETURN-VALUE NE "":U THEN
        cMessageList = RETURN-VALUE.
     /* Should we allow changes in rowObjectvalidate ?
     RUN getLogicBuffer IN THIS-PROCEDURE
           (OUTPUT hNewRowObject).
     hRowObject:BUFFER-COPY(hNewRowObject).
     */
     RUN clearLogicRows IN THIS-PROCEDURE.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getDataLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataLogicObject Method-Library 
FUNCTION getDataLogicObject RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN ghDataLogicProcedure.

END FUNCTION.

/* Note: This ENDIF matches the adm-datalogic definition at the top of file.
   Do not delete it and if another procedure or function is defined which
   occurs later in the file, move it to the end of that. 
   This is for backwards compatibility with code that has datalogic.i as a 
   method library 
   */
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

