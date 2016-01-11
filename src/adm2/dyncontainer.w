&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_asbroker1                AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS cContainer 
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

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

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
         HEIGHT             = 6.95
         WIDTH              = 59.
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
 DEFINE VARIABLE iProc                 AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hObject               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hSBO                  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cObjectName           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectType           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSBOcontained         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iSBOSDONum            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cClientNames          AS CHARACTER  NO-UNDO.
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

 DO iProc = 1 TO NUM-ENTRIES(pcObjects):
   ASSIGN 
     cPhysicalObject = ENTRY(iProc,pcObjects)
     cClientName     = ENTRY(iProc,pcClientNames).
   
   IF cPhysicalObject <> '':U THEN
   DO:
     RUN constructObject (cPhysicalObject,
                          ?,
                          'OpenOnInit':U + CHR(4) + 'NO':U,
                          OUTPUT hObject). 
     ASSIGN
       cClientNames = cClientNames 
                    + (IF cClientNames = '':U THEN '':U ELSE ',':U)
                    + cClientName
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
         iParentInstance = LOOKUP(cParent,cClientNames)
         hParent         = WIDGET-HANDLE(ENTRY(iParentInstance,cTargets)).
       
       IF VALID-HANDLE(hParent) THEN
          RUN addLink IN TARGET-PROCEDURE(hParent,'Data':u,hObject).

       {set ForeignFields cForeignFields hObject}.
     END.
     cFetchOnOpen = 'First':U.
     IF cPositionFields <> '':U THEN
     DO:
       ASSIGN 
         cParent         = ENTRY(1,cPositionFields)  
         iParentInstance = LOOKUP(cParent,cClientNames)
         hParent         = WIDGET-HANDLE(ENTRY(iParentInstance,cTargets)).       
       IF VALID-HANDLE(hParent) THEN
       DO:
         cFetchOnOpen = 'findRowFromObject':U    + CHR(2)
                      + ENTRY(2,cPositionFields) + CHR(2)
                      + ENTRY(3,cPositionFields) + CHR(2)
                      + STRING(hParent).          
       END.
     END.

     {get ObjectType cObjectType hObject}. 
     IF cObjectType = 'SmartBusinessObject':U THEN
     DO:
       ASSIGN
         hSBO       = hObject  
         iSBOSDONum = 1.
       RUN createObjects IN hSBO.  
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
     hObject = WIDGET-HANDLE(ENTRY(iSBOSDONum,cSBOcontained)).

   {get ObjectName cObjectName}.
   
   cContainedDataObjects = cContainedDataObjects 
                         + (IF iProc = 1 THEN '':U ELSE ',':U)
                         + STRING(hObject).
   /* The AsDivision defaults to 'server' on a server, but in this context
      the objects are server objects even if this is run on a client...
      so just force it  */
   {set AsDivision 'Server':U hObject}.
   /* let openQuery fetchFirst () */
   {set FetchOnOpen cFetchOnOpen hObject}.
 END.

  /* just as a precaution...  */
 RUN createObjects IN TARGET-PROCEDURE.  

 {set ContainedDataObjects cContainedDataObjects}. 
 {set ClientNames cClientNames}.
 
 RUN setContextAndInitialize IN TARGET-PROCEDURE(pcContext).

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

