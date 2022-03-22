&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: commit.p 

 Description: Stateless commit of data to any SmartDataObject  
 Purpose:     Allow a client to commit data to the server with 
               ONE appserver call  

 Parameters: 
   input        pcObject    - physical object name of an sdo       
                              Will be extended to support logical icf SDOs 
   input-output piocContext - Context from client to server 
                                Will return new context to client   
   input-output table phRowObjUpd - RowObjUpd table with changes
   output       pocMessages  - error messages in adm format
   output       pocUndoids   - list of failed rowobjupd ROwnums 
                       
 Notes:  The only difference from the remoteCommit method in data.p is the 
         objectname     
 
 History:
---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER pcObject            AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piocContext  AS CHARACTER  NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd1. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd2. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd3. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd4. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd5. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd6. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd7. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd8. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd9. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd10. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd11. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd12. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd13. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd14. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd15. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd16. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd17. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd18. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd19. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd20. 

DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 4.29
         WIDTH              = 62.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hObject        AS HANDLE  NO-UNDO.
DEFINE VARIABLE hRowObjUpd     AS HANDLE  NO-UNDO.
DEFINE VARIABLE lDynamicData   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iEntry                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLogicalObjectName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContained             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDO                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cObjectName            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTable                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE cTableList             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOrdering              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDynamicSDO            AS LOGICAL    NO-UNDO.

  /* This is necessary so that the callback function 'getCurrentLogicalName' will */
  /* return the proper name to 'prepareInstance */
  IF NUM-ENTRIES(pcObject,':') > 1 THEN
    ASSIGN
      cLogicalObjectName = ENTRY(2,pcObject,':':U)
      pcObject           = ENTRY(1,pcObject,':':U).

  /* run the object */
  DO ON STOP UNDO, LEAVE:   
    RUN VALUE(pcObject) PERSISTENT SET hObject NO-ERROR.   
  END.
  
  IF NOT VALID-HANDLE(hObject) THEN
  DO:
    pocMessages = ERROR-STATUS:GET-MESSAGE(1).
    RETURN.
  END.

  {get DynamicData lDynamicData hObject}.

  IF lDynamicData THEN 
  DO:
    /* We cannot use 'setContextAndInitialize' here because we need to set the */
    /* 'IsRowObjUpdExternal' property in each SDO *before* they're initialized */
    RUN createObjects IN hObject.   /* Create all contained SDOs. */           
    
    /* Set properties passed from the client */
    DYNAMIC-FUNCTION('applyContextFromClient':U IN hObject,piocContext). 

    {set OpenOnInit FALSE hObject}. 
   
    RUN initializeObject IN hObject.

    /* set UpdateTables and synch SDOs */
    RUN applyUpdateTables IN hObject
                            (phRowObjUpd1,
                             phRowObjUpd2,
                             phRowObjUpd3,
                             phRowObjUpd4,
                             phRowObjUpd5,
                             phRowObjUpd6,
                             phRowObjUpd7,
                             phRowObjUpd8,
                             phRowObjUpd9,
                             phRowObjUpd10,
                             phRowObjUpd11,
                             phRowObjUpd12,
                             phRowObjUpd13,
                             phRowObjUpd14,
                             phRowObjUpd15,
                             phRowObjUpd16,
                             phRowObjUpd17,
                             phRowObjUpd18,
                             phRowObjUpd19,
                             phRowObjUpd20).

    RUN bufferCommitTransaction IN hObject (OUTPUT pocMessages, 
                                            OUTPUT pocUndoIds).
    
    piocContext = {fn obtainContextForClient hObject}.
    
    /* If there was any SDOs with static TT we need to copy the TT back to 
       the input-output parameter handle, as the static TT in the SDO will 
       be destroyed when the object is destroyed */   
    {get ContainedDataObjects cContained hObject}.
    {get DataObjectOrdering cOrdering hObject}.

    DO iPos = 1 TO NUM-ENTRIES(cOrdering):
      hDO = WIDGET-HANDLE(ENTRY(INTEGER(ENTRY(iPos, cOrdering)), cContained)).
      {get DynamicData lDynamicSDO hDO}.
      /* Set the handle BEFORE fetching  */
      IF NOT lDynamicSDO THEN
      DO:
        CASE iPos:
          WHEN 1 THEN hTable = phRowObjUpd1.
          WHEN 2 THEN hTable = phRowObjUpd2.
          WHEN 3 THEN hTable = phRowObjUpd3.
          WHEN 4 THEN hTable = phRowObjUpd4.
          WHEN 5 THEN hTable = phRowObjUpd5.
          WHEN 6 THEN hTable = phRowObjUpd6.
          WHEN 7 THEN hTable = phRowObjUpd7.
          WHEN 8 THEN hTable = phRowObjUpd8.
          WHEN 9 THEN hTable = phRowObjUpd9.
          WHEN 10 THEN hTable = phRowObjUpd10.
          WHEN 11 THEN hTable = phRowObjUpd11.
          WHEN 12 THEN hTable = phRowObjUpd12.
          WHEN 13 THEN hTable = phRowObjUpd13.
          WHEN 14 THEN hTable = phRowObjUpd14.
          WHEN 15 THEN hTable = phRowObjUpd15.
          WHEN 16 THEN hTable = phRowObjUpd16.
          WHEN 17 THEN hTable = phRowObjUpd17.
          WHEN 18 THEN hTable = phRowObjUpd18.
          WHEN 19 THEN hTable = phRowObjUpd19.
          WHEN 20 THEN hTable = phRowObjUpd20.
        END CASE.
        RUN serverFetchRowObjUpdTable IN hDO (OUTPUT TABLE-HANDLE hTable).
      END.
    END.
  END.   /* IF lDynamicData */
  ELSE
    RUN remoteCommitTransaction IN hObject (
                                 INPUT-OUTPUT piocContext, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd1, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd2, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd3, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd4, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd5, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd6, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd7, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd8, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd9, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd10,
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd11, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd12, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd13, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd14, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd15, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd16, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd17, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd18, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd19, 
                                 INPUT-OUTPUT TABLE-HANDLE phRowObjUpd20,
                                 OUTPUT pocMessages, 
                                 OUTPUT pocUndoIds).
/* clean up  objects */
RUN destroyObject IN hObject.
   
DELETE OBJECT phRowObjUpd1 NO-ERROR.
DELETE OBJECT phRowObjUpd2 NO-ERROR.
DELETE OBJECT phRowObjUpd3 NO-ERROR.
DELETE OBJECT phRowObjUpd4 NO-ERROR.
DELETE OBJECT phRowObjUpd5 NO-ERROR.
DELETE OBJECT phRowObjUpd6 NO-ERROR.
DELETE OBJECT phRowObjUpd7 NO-ERROR.
DELETE OBJECT phRowObjUpd8 NO-ERROR.
DELETE OBJECT phRowObjUpd9 NO-ERROR.
DELETE OBJECT phRowObjUpd10 NO-ERROR.
DELETE OBJECT phRowObjUpd11 NO-ERROR.
DELETE OBJECT phRowObjUpd12 NO-ERROR.
DELETE OBJECT phRowObjUpd13 NO-ERROR.
DELETE OBJECT phRowObjUpd14 NO-ERROR.
DELETE OBJECT phRowObjUpd15 NO-ERROR.
DELETE OBJECT phRowObjUpd16 NO-ERROR.
DELETE OBJECT phRowObjUpd17 NO-ERROR.
DELETE OBJECT phRowObjUpd18 NO-ERROR.
DELETE OBJECT phRowObjUpd19 NO-ERROR.
DELETE OBJECT phRowObjUpd20 NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN cLogicalObjectName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

