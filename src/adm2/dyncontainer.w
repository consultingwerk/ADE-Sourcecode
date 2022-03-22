&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS cContainer 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrsimpl.w - ADM2 Simple SmartContainer Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* 
   The creation of the widget pool is commented as creating a widget pool
   and destroying the dyncontainer.w (in keep alive implementation) deletes 
   the query and other widgets created in the widget pool. This causes
   prolems on webspeed and other code.  ADMProps is explicitly deleted
   in an override of destroyObject
CREATE WIDGET-POOL. 
*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartContainer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER VIRTUAL

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,OutMessage-Source,OutMessage-Target


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addDataObject cContainer 
FUNCTION addDataObject RETURNS HANDLE
  ( pcPhysicalObject AS CHAR,
    pcInstanceName   AS CHAR,
    phParent         AS HANDLE,
    pcForeignFields  AS CHAR,
    pcProperties     AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertDataObject cContainer 
FUNCTION insertDataObject RETURNS HANDLE
  ( pcLogicalObject  AS CHAR,
    pcPhysicalObject AS CHAR,
    pcObjectInstance AS CHAR,
    phParent         AS HANDLE,
    pcForeignFields  AS CHAR,
    pcProperties     AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartContainer
   Allow: Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,OutMessage-Source,OutMessage-Target
   Frames: 0
   Add Fields to: Neither
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW cContainer ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 62.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB cContainer 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW cContainer
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK cContainer 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects cContainer  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject cContainer 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Override of destroyObject to delete ADMProps temp-table
  Parameters:  <none>
  Notes:       ADMProps must be deleted here because no default widget pool 
               is created when dyncontainer.w is started to prevent problems 
               with keep alive (see comments in Definitions section)
------------------------------------------------------------------------------*/
DEFINE VARIABLE hADMProps AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTable    AS HANDLE     NO-UNDO.
  
  RUN SUPER.

  hADMProps = WIDGET-HANDLE(ENTRY(1,TARGET-PROCEDURE:ADM-DATA,CHR(1))).
  IF VALID-HANDLE(hADMProps) AND hADMProps:NAME = 'ADMProps':U THEN
  DO:
    hTable = hADMProps:TABLE-HANDLE.
    IF VALID-HANDLE(hTable) THEN
      DELETE OBJECT hTable.
  END.  /* if valid admprops */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI cContainer  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI cContainer  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteFetchData cContainer 
PROCEDURE remoteFetchData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT-OUTPUT PARAMETER pcContext AS CHARACTER  NO-UNDO.
  
 DEFINE INPUT  PARAMETER pcObjects       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcClientNames   AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcForeignFields AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcQueries       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcPositions     AS CHARACTER  NO-UNDO.

 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject21.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject22.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject23.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject24.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject25.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject26.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject27.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject28.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject29.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject30.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject31.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject32.

 DEFINE OUTPUT PARAMETER pcError  AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE hObject             AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iObject             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDataObjects        AS CHARACTER  NO-UNDO.

 RUN serverCreateDataObjects  IN TARGET-PROCEDURE
                (pcObjects,
                 pcClientNames,
                 pcForeignFields,
                 pcContext).

 RUN bufferFetchContainedData IN TARGET-PROCEDURE
                     (pcQueries,
                      pcPositions).

 {get ContainedDataObjects cDataObjects}.
 DO iObject = 1 TO NUM-ENTRIES(cDataObjects):
   hObject = WIDGET-HANDLE(ENTRY(iObject,cDataObjects)).
   CASE iObject:
     WHEN 1 THEN
       {get RowObjectTable phRowObject1 hObject}.
     WHEN 2 THEN
       {get RowObjectTable phRowObject2 hObject}.
     WHEN 3 THEN
       {get RowObjectTable phRowObject3 hObject}.
     WHEN 4 THEN
       {get RowObjectTable phRowObject4 hObject}.
     WHEN 5 THEN
       {get RowObjectTable phRowObject5 hObject}.
     WHEN 6 THEN
       {get RowObjectTable phRowObject6 hObject}.
     WHEN 7 THEN
       {get RowObjectTable phRowObject7 hObject}.
     WHEN 8 THEN
       {get RowObjectTable phRowObject8 hObject}.
     WHEN 9 THEN
       {get RowObjectTable phRowObject9 hObject}.
     WHEN 10 THEN
       {get RowObjectTable phRowObject10 hObject}.
     WHEN 11 THEN
       {get RowObjectTable phRowObject11 hObject}.
     WHEN 12 THEN
       {get RowObjectTable phRowObject12 hObject}.
     WHEN 13 THEN
       {get RowObjectTable phRowObject13 hObject}.
     WHEN 14 THEN
       {get RowObjectTable phRowObject14 hObject}.
     WHEN 15 THEN
       {get RowObjectTable phRowObject15 hObject}.
     WHEN 16 THEN
       {get RowObjectTable phRowObject16 hObject}.
     WHEN 17 THEN
       {get RowObjectTable phRowObject17 hObject}.
     WHEN 18 THEN
       {get RowObjectTable phRowObject18 hObject}.
     WHEN 19 THEN
       {get RowObjectTable phRowObject19 hObject}.
     WHEN 20 THEN
       {get RowObjectTable phRowObject20 hObject}.
     WHEN 21 THEN
       {get RowObjectTable phRowObject21 hObject}.
     WHEN 22 THEN
       {get RowObjectTable phRowObject22 hObject}.
     WHEN 23 THEN
       {get RowObjectTable phRowObject23 hObject}.
     WHEN 24 THEN
       {get RowObjectTable phRowObject24 hObject}.
     WHEN 25 THEN
       {get RowObjectTable phRowObject25 hObject}.
     WHEN 26 THEN
       {get RowObjectTable phRowObject26 hObject}.
     WHEN 27 THEN
       {get RowObjectTable phRowObject27 hObject}.
     WHEN 28 THEN
       {get RowObjectTable phRowObject28 hObject}.
     WHEN 29 THEN
       {get RowObjectTable phRowObject29 hObject}.
     WHEN 30 THEN
       {get RowObjectTable phRowObject30 hObject}.
     WHEN 31 THEN
       {get RowObjectTable phRowObject31 hObject}.
     WHEN 32 THEN
       {get RowObjectTable phRowObject32 hObject}.
   END.
 END.
 pcContext = {fn obtainContextForClient}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteFetchRows cContainer 
PROCEDURE remoteFetchRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT-OUTPUT PARAMETER pcContext AS CHARACTER  NO-UNDO.
  
 DEFINE INPUT  PARAMETER pcObjects       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcClientNames   AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcForeignFields AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcQueries       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.

 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject21.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject22.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject23.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject24.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject25.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject26.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject27.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject28.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject29.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject30.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject31.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject32.

 DEFINE OUTPUT PARAMETER pcError  AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE hObject             AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iObject             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDataObjects        AS CHARACTER  NO-UNDO.

 RUN serverCreateDataObjects  IN TARGET-PROCEDURE
                (pcObjects,
                 pcClientNames,
                 pcForeignFields,
                 pcContext).

 RUN bufferFetchContainedRows IN TARGET-PROCEDURE
                     (pcQueries,
                      piStartRow, 
                      pcRowIdent, 
                      plNext, 
                      piRowsToReturn, 
                      OUTPUT piRowsReturned).

 {get ContainedDataObjects cDataObjects}.
 DO iObject = 1 TO NUM-ENTRIES(cDataObjects):
   hObject = WIDGET-HANDLE(ENTRY(iObject,cDataObjects)).
   CASE iObject:
     WHEN 1 THEN
       {get RowObjectTable phRowObject1 hObject}.
     WHEN 2 THEN
       {get RowObjectTable phRowObject2 hObject}.
     WHEN 3 THEN
       {get RowObjectTable phRowObject3 hObject}.
     WHEN 4 THEN
       {get RowObjectTable phRowObject4 hObject}.
     WHEN 5 THEN
       {get RowObjectTable phRowObject5 hObject}.
     WHEN 6 THEN
       {get RowObjectTable phRowObject6 hObject}.
     WHEN 7 THEN
       {get RowObjectTable phRowObject7 hObject}.
     WHEN 8 THEN
       {get RowObjectTable phRowObject8 hObject}.
     WHEN 9 THEN
       {get RowObjectTable phRowObject9 hObject}.
     WHEN 10 THEN
       {get RowObjectTable phRowObject10 hObject}.
     WHEN 11 THEN
       {get RowObjectTable phRowObject11 hObject}.
     WHEN 12 THEN
       {get RowObjectTable phRowObject12 hObject}.
     WHEN 13 THEN
       {get RowObjectTable phRowObject13 hObject}.
     WHEN 14 THEN
       {get RowObjectTable phRowObject14 hObject}.
     WHEN 15 THEN
       {get RowObjectTable phRowObject15 hObject}.
     WHEN 16 THEN
       {get RowObjectTable phRowObject16 hObject}.
     WHEN 17 THEN
       {get RowObjectTable phRowObject17 hObject}.
     WHEN 18 THEN
       {get RowObjectTable phRowObject18 hObject}.
     WHEN 19 THEN
       {get RowObjectTable phRowObject19 hObject}.
     WHEN 20 THEN
       {get RowObjectTable phRowObject20 hObject}.
     WHEN 21 THEN
       {get RowObjectTable phRowObject21 hObject}.
     WHEN 22 THEN
       {get RowObjectTable phRowObject22 hObject}.
     WHEN 23 THEN
       {get RowObjectTable phRowObject23 hObject}.
     WHEN 24 THEN
       {get RowObjectTable phRowObject24 hObject}.
     WHEN 25 THEN
       {get RowObjectTable phRowObject25 hObject}.
     WHEN 26 THEN
       {get RowObjectTable phRowObject26 hObject}.
     WHEN 27 THEN
       {get RowObjectTable phRowObject27 hObject}.
     WHEN 28 THEN
       {get RowObjectTable phRowObject28 hObject}.
     WHEN 29 THEN
       {get RowObjectTable phRowObject29 hObject}.
     WHEN 30 THEN
       {get RowObjectTable phRowObject30 hObject}.
     WHEN 31 THEN
       {get RowObjectTable phRowObject31 hObject}.
     WHEN 32 THEN
       {get RowObjectTable phRowObject32 hObject}.
   END.
 END.
 pcContext = {fn obtainContextForClient}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverCreateDataObjects cContainer 
PROCEDURE serverCreateDataObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
 DEFINE INPUT  PARAMETER pcObjects       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcClientNames   AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcQueryFields   AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcContext       AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE cPhysicalObject       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cClientName           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLogicalName          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iProc                 AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hObject               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hSBO                  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cObjectName           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectType           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSBOcontained         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iSBOSDONum            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hDataSource           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cQueryString          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lQueryContainer       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cObjects              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainedDataObjects AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cForeignFields        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPositionFields       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cParent               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hParent               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iParentInstance       AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cTargets              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryFields          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFetchOnOpen          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lDestroyStateless     AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cStartProps           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.
 
 DO iProc = 1 TO NUM-ENTRIES(pcObjects):
   ASSIGN 
     cPhysicalObject = ENTRY(iProc,pcObjects)
     cLogicalName    = IF NUM-ENTRIES(cPhysicalObject,':') > 1 THEN
                       ENTRY(2,cPhysicalObject,':')
                       ELSE ''
     cPhysicalObject = ENTRY(1,cPhysicalObject,':')
     cClientName     = ENTRY(iProc,pcClientNames)
     hParent         = ? 
     cStartProps     = '':U.   /* desperate default value */

   IF cPhysicalObject <> '':U THEN
   DO:
     IF cLogicalName > '' THEN
        cStartProps = "LaunchLogicalName":U + CHR(4) + cLogicalName.
     RUN constructObject (cPhysicalObject /*cPhysicalObject*/,
                          ?,
                          cStartProps,
                          OUTPUT hObject) no-error.
     if error-status:error then 
         return error return-value.  
 
     ASSIGN
       cQueryFields    = ENTRY(iProc,pcQueryFields,CHR(1))
       cForeignFields  = ENTRY(1,cQueryFields,CHR(2))
       cPositionFields = IF NUM-ENTRIES(cQueryFields,CHR(2)) > 1 
                         THEN ENTRY(2,cQueryFields,CHR(2))
                         ELSE '':U.

     {get ContainerTarget cTargets}.

     IF cForeignFields <> '':U THEN
     DO:
       ASSIGN 
         cParent         = ENTRY(1,cForeignFields)  
         ENTRY(1,cForeignFields) = '':U            
         cForeignFields  = LEFT-TRIM(cForeignFields,',':U)
         iParentInstance = LOOKUP(cParent,pcClientNames).
       
       IF iParentInstance > 0 THEN
       DO:
         hParent = WIDGET-HANDLE(ENTRY(iParentInstance,cContainedDataObjects)).
         /* Parent reference may be indirect to container (SBO)*/ 
         {get ContainerSource hContainer hParent}.
         IF hContainer <> TARGET-PROCEDURE THEN
           hParent = hContainer.

         IF VALID-HANDLE(hParent) THEN
         DO:
           RUN addLink IN TARGET-PROCEDURE(hParent,'Data':u,hObject).
           hParent = ?.
         END.
       END.
       {set ForeignFields cForeignFields hObject}.
     END.

     cFetchOnOpen = 'First':U.
     IF cPositionFields <> '':U THEN
     DO:
       ASSIGN 
         cParent         = ENTRY(1,cPositionFields)  
         iParentInstance = LOOKUP(cParent,pcClientNames)
         hParent         = WIDGET-HANDLE(ENTRY(iParentInstance,cContainedDataObjects)) NO-ERROR.
       IF VALID-HANDLE(hParent) THEN
         cFetchOnOpen = 'findRowFromObject':U    + CHR(2)
                      + ENTRY(2,cPositionFields) + CHR(2)
                      + ENTRY(3,cPositionFields) + CHR(2)
                      + STRING(hParent).    
     END.

     {get ObjectType cObjectType hObject}.
     IF cObjectType = 'SmartBusinessObject':U THEN
     DO:
       ASSIGN
         hSBO       = hObject  
         iSBOSDONum = 1.
       RUN createObjects IN hSBO. 
       
       {set AsDivision 'Server':U hSBO}.
       /* Don't open during initialization */ 
       {set OpenOnInit FALSE hSBO}. 

       {get ContainedDataObjects cSBOContained hSBO}.
     END.
     ELSE 
       ASSIGN
         cSBOContained = '':u
         hSBO          = ?
         iSBOSDONum    = 0.
   END.
   ELSE iSBOSDONum = iSBOSDONum + 1.
   
   IF iSBOSDONum > 0 THEN
   DO:
     hObject = WIDGET-HANDLE(ENTRY(iSBOSDONum,cSBOcontained)).
     {get ObjectType cObjectType hObject}.
   END.

   cContainedDataObjects = cContainedDataObjects 
                         + (IF iProc = 1 THEN '':U ELSE ',':U)
                         + STRING(hObject).

   /* If this SDO is to be kept alive (DestroyStateless = NO) or */
   /* it has been resurrected (ObjectInitialized = TRUE), we do not want */
   /* (need) to set the following properties */
   lDestroyStateless = LOOKUP(DYNAMIC-FUNCT('obtainPropertyFromContext':U IN TARGET-PROCEDURE,
                                            cObjectType,
                                            cClientName,
                                            'DestroyStateless':U,
                                            pcContext),
                              "YES,TRUE":U) > 0.

   IF lDestroyStateless = ? THEN
     lDestroyStateless = YES.

   /* set fetch on open from above ('first' or findRowFromObject) */
   IF cObjectType = "SmartDataObject":U THEN
     {set FetchOnOpen cFetchOnOpen hObject}.

   IF NOT ({fn getObjectInitialized hObject} OR lDestroyStateless = FALSE) THEN
   DO: 
     /* The AsDivision defaults to 'server' on a server, but in this context
        the objects are server objects even if this is run on a client...
        so just force it  */
     {set AsDivision 'Server':U hObject}.
     /* Don't open during initialization */ 
     {set OpenOnInit FALSE hObject}. 
     /* Ensure that the rowobject is not deleted 
        (and that dynamic is used also if possible when definition is static)  */
     {set IsRowObjectExternal TRUE hObject}.
   END.
 END.
  /* just as a precaution...  */
 RUN createObjects IN TARGET-PROCEDURE.  
 
 &SCOPED-DEFINE xp-assign
 {set ContainedDataObjects cContainedDataObjects} 
 {set ClientNames pcClientNames}
  .
 &UNDEFINE xp-assign
 
 DYNAMIC-FUNCTION('applyContextFromClient':U IN TARGET-PROCEDURE,
                   pcContext). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchData cContainer 
PROCEDURE serverFetchData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcQueries    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcPositions   AS CHARACTER  NO-UNDO.
 
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject21.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject22.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject23.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject24.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject25.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject26.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject27.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject28.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject29.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject30.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject31.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject32.

 DEFINE VARIABLE hObject             AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iObject             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDataObjects        AS CHARACTER  NO-UNDO.

 RUN bufferFetchContainedData IN TARGET-PROCEDURE
                    (pcQueries,
                     pcPositions).

 {get ContainedDataObjects cDataObjects}.
 DO iObject = 1 TO NUM-ENTRIES(cDataObjects):
   hObject = WIDGET-HANDLE(ENTRY(iObject,cDataObjects)).
   CASE iObject:
     WHEN 1 THEN
       {get RowObjectTable phRowObject1 hObject}.
     WHEN 2 THEN
       {get RowObjectTable phRowObject2 hObject}.
     WHEN 3 THEN
       {get RowObjectTable phRowObject3 hObject}.
     WHEN 4 THEN
       {get RowObjectTable phRowObject4 hObject}.
     WHEN 5 THEN
       {get RowObjectTable phRowObject5 hObject}.
     WHEN 6 THEN
       {get RowObjectTable phRowObject6 hObject}.
     WHEN 7 THEN
       {get RowObjectTable phRowObject7 hObject}.
     WHEN 8 THEN
       {get RowObjectTable phRowObject8 hObject}.
     WHEN 9 THEN
       {get RowObjectTable phRowObject9 hObject}.
     WHEN 10 THEN
       {get RowObjectTable phRowObject10 hObject}.
     WHEN 11 THEN
       {get RowObjectTable phRowObject11 hObject}.
     WHEN 12 THEN
       {get RowObjectTable phRowObject12 hObject}.
     WHEN 13 THEN
       {get RowObjectTable phRowObject13 hObject}.
     WHEN 14 THEN
       {get RowObjectTable phRowObject14 hObject}.
     WHEN 15 THEN
       {get RowObjectTable phRowObject15 hObject}.
     WHEN 16 THEN
       {get RowObjectTable phRowObject16 hObject}.
     WHEN 17 THEN
       {get RowObjectTable phRowObject17 hObject}.
     WHEN 18 THEN
       {get RowObjectTable phRowObject18 hObject}.
     WHEN 19 THEN
       {get RowObjectTable phRowObject19 hObject}.
     WHEN 20 THEN
       {get RowObjectTable phRowObject20 hObject}.
     WHEN 21 THEN
       {get RowObjectTable phRowObject21 hObject}.
     WHEN 22 THEN
       {get RowObjectTable phRowObject22 hObject}.
     WHEN 23 THEN
       {get RowObjectTable phRowObject23 hObject}.
     WHEN 24 THEN
       {get RowObjectTable phRowObject24 hObject}.
     WHEN 25 THEN
       {get RowObjectTable phRowObject25 hObject}.
     WHEN 26 THEN
       {get RowObjectTable phRowObject26 hObject}.
     WHEN 27 THEN
       {get RowObjectTable phRowObject27 hObject}.
     WHEN 28 THEN
       {get RowObjectTable phRowObject28 hObject}.
     WHEN 29 THEN
       {get RowObjectTable phRowObject29 hObject}.
     WHEN 30 THEN
       {get RowObjectTable phRowObject30 hObject}.
     WHEN 31 THEN
       {get RowObjectTable phRowObject31 hObject}.
     WHEN 32 THEN
       {get RowObjectTable phRowObject32 hObject}.
   END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchRows cContainer 
PROCEDURE serverFetchRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcQueries    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
 
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject21.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject22.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject23.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject24.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject25.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject26.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject27.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject28.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject29.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject30.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject31.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject32.

 DEFINE VARIABLE hObject             AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iObject             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDataObjects        AS CHARACTER  NO-UNDO.

 RUN bufferFetchContainedRows IN TARGET-PROCEDURE
                     (pcQueries,
                      piStartRow, 
                      pcRowIdent, 
                      plNext, 
                      piRowsToReturn, 
                      OUTPUT piRowsReturned).

 {get ContainedDataObjects cDataObjects}.
 DO iObject = 1 TO NUM-ENTRIES(cDataObjects):
   hObject = WIDGET-HANDLE(ENTRY(iObject,cDataObjects)).
   CASE iObject:
     WHEN 1 THEN
       {get RowObjectTable phRowObject1 hObject}.
     WHEN 2 THEN
       {get RowObjectTable phRowObject2 hObject}.
     WHEN 3 THEN
       {get RowObjectTable phRowObject3 hObject}.
     WHEN 4 THEN
       {get RowObjectTable phRowObject4 hObject}.
     WHEN 5 THEN
       {get RowObjectTable phRowObject5 hObject}.
     WHEN 6 THEN
       {get RowObjectTable phRowObject6 hObject}.
     WHEN 7 THEN
       {get RowObjectTable phRowObject7 hObject}.
     WHEN 8 THEN
       {get RowObjectTable phRowObject8 hObject}.
     WHEN 9 THEN
       {get RowObjectTable phRowObject9 hObject}.
     WHEN 10 THEN
       {get RowObjectTable phRowObject10 hObject}.
     WHEN 11 THEN
       {get RowObjectTable phRowObject11 hObject}.
     WHEN 12 THEN
       {get RowObjectTable phRowObject12 hObject}.
     WHEN 13 THEN
       {get RowObjectTable phRowObject13 hObject}.
     WHEN 14 THEN
       {get RowObjectTable phRowObject14 hObject}.
     WHEN 15 THEN
       {get RowObjectTable phRowObject15 hObject}.
     WHEN 16 THEN
       {get RowObjectTable phRowObject16 hObject}.
     WHEN 17 THEN
       {get RowObjectTable phRowObject17 hObject}.
     WHEN 18 THEN
       {get RowObjectTable phRowObject18 hObject}.
     WHEN 19 THEN
       {get RowObjectTable phRowObject19 hObject}.
     WHEN 20 THEN
       {get RowObjectTable phRowObject20 hObject}.
     WHEN 21 THEN
       {get RowObjectTable phRowObject21 hObject}.
     WHEN 22 THEN
       {get RowObjectTable phRowObject22 hObject}.
     WHEN 23 THEN
       {get RowObjectTable phRowObject23 hObject}.
     WHEN 24 THEN
       {get RowObjectTable phRowObject24 hObject}.
     WHEN 25 THEN
       {get RowObjectTable phRowObject25 hObject}.
     WHEN 26 THEN
       {get RowObjectTable phRowObject26 hObject}.
     WHEN 27 THEN
       {get RowObjectTable phRowObject27 hObject}.
     WHEN 28 THEN
       {get RowObjectTable phRowObject28 hObject}.
     WHEN 29 THEN
       {get RowObjectTable phRowObject29 hObject}.
     WHEN 30 THEN
       {get RowObjectTable phRowObject30 hObject}.
     WHEN 31 THEN
       {get RowObjectTable phRowObject31 hObject}.
     WHEN 32 THEN
       {get RowObjectTable phRowObject32 hObject}.
   END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addDataObject cContainer 
FUNCTION addDataObject RETURNS HANDLE
  ( pcPhysicalObject AS CHAR,
    pcInstanceName   AS CHAR,
    phParent         AS HANDLE,
    pcForeignFields  AS CHAR,
    pcProperties     AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  Depracated - Use 'insertDataObject' instead. Supported for backward 
            compatibility only.
------------------------------------------------------------------------------*/

  RETURN insertDataObject('':U,      /* LogicalObjectName */
                          pcPhysicalObject,
                          pcInstanceName,
                          phParent,
                          pcForeignFields,
                          pcProperties).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertDataObject cContainer 
FUNCTION insertDataObject RETURNS HANDLE
  ( pcLogicalObject  AS CHAR,
    pcPhysicalObject AS CHAR,
    pcObjectInstance AS CHAR,
    phParent         AS HANDLE,
    pcForeignFields  AS CHAR,
    pcProperties     AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  This API replaces 'addDataObject'. It takes an additional parameter,
            'LogicalObjectName' which, if supplied, will be used to retrieve the
            object from the repository.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargets       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iInstance      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cInstanceNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lstarted       AS LOGICAL    NO-UNDO.

  {get ContainerTarget cTargets}.
  {get InstanceNames cInstanceNames}.

  iInstance = LOOKUP(pcObjectInstance,cInstanceNames).
  IF iInstance > 0 THEN
    ASSIGN
      hObject = WIDGET-HANDLE(ENTRY(iInstance,cTargets))
      lstarted = TRUE.
  ELSE
    RUN constructObject (pcPhysicalObject,
                         ?,
                         (IF pcLogicalObject > '':U THEN /* prepareInstance will respond to this */
                            'LaunchLogicalName':U + CHR(4) + pcLogicalObject + CHR(3)
                          ELSE 
                            IF pcObjectInstance > '' THEN /* only used to locate running instances */
                               'LogicalObjectName':U + CHR(4) + pcObjectInstance + CHR(3)
                            ELSE '':U) +
                         (IF pcObjectInstance > '':U THEN 
                            'ObjectName':U + CHR(4) + pcObjectInstance + CHR(3)
                          ELSE '':U) +
                          'OpenOnInit':U + CHR(4) + 'NO':U ,
                         OUTPUT hObject). 

  IF pcForeignFields > '':U THEN
  DO:
    IF VALID-HANDLE(phParent) THEN
      RUN addLink IN TARGET-PROCEDURE(phParent,'Data':U,hObject).
      {set ForeignFields pcForeignFields hObject}.
  END.

  IF NOT lstarted THEN
  DO:
    {set FetchOnOpen '':U hObject}.
    RUN setContextAndInitialize IN hObject (pcProperties).
  END.

  RETURN hObject.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

