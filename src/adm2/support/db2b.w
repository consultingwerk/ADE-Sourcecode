&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE mapping NO-UNDO LIKE mapping.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: from DATA.W - Template For SmartData objects in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified:     February 24, 1999
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
DEFINE VARIABLE gcDirection AS CHAR   NO-UNDO.

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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES mapping

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  destination name replyreq replysel xmlschema dtdPublicId dtdSystemId
&Scoped-define ENABLED-FIELDS-IN-mapping destination name replyreq replysel ~
xmlschema dtdPublicId dtdSystemId 
&Scoped-Define DATA-FIELDS  destination name replyreq replysel xmlschema dtdPublicId dtdSystemId
&Scoped-define DATA-FIELDS-IN-mapping destination name replyreq replysel ~
xmlschema dtdPublicId dtdSystemId 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "src/adm2/support/db2b.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH mapping NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH mapping NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main mapping
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main mapping


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDirection dTables  _DB-REQUIRED
FUNCTION getDirection RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDirection dTables  _DB-REQUIRED
FUNCTION setDirection RETURNS LOGICAL
  (pcDirection AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      mapping SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
   Temp-Tables and Buffers:
      TABLE: mapping T "?" NO-UNDO TEMP-DB mapping
   END-TABLES.
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
         HEIGHT             = 1.62
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

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
     _TblList          = "Temp-Tables.mapping"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.mapping.destination
"destination" "destination" ? "X(50)" "character" ? ? ? ? ? ? yes ? no 50 no
     _FldNameList[2]   > Temp-Tables.mapping.name
"name" "name" ? "X(20)" "character" ? ? ? ? ? ? yes ? no 20 no
     _FldNameList[3]   > Temp-Tables.mapping.replyreq
"replyreq" "replyreq" ? ? "logical" ? ? ? ? ? ? yes ? no 14.6 no
     _FldNameList[4]   > Temp-Tables.mapping.replysel
"replysel" "replysel" ? "X(100)" "character" ? ? ? ? ? ? yes ? no 100 no
     _FldNameList[5]   > Temp-Tables.mapping.xmlschema
"xmlschema" "xmlschema" "XML Mapping File" "X(50)" "character" ? ? ? ? ? ? yes ? no 50 no
     _FldNameList[6]   > Temp-Tables.mapping.dtdPublicId
"dtdPublicId" "dtdPublicId" ? ? "character" ? ? ? ? ? ? yes ? no 60 no
     _FldNameList[7]   > Temp-Tables.mapping.dtdSystemId
"dtdSystemId" "dtdSystemId" ? ? "character" ? ? ? ? ? ? yes ? no 60 no
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

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createMappings dTables  _DB-REQUIRED
PROCEDURE createMappings :
/*------------------------------------------------------------------------------
  Purpose:     This procedure create mapping temp-table records based on the
               setting of DirectionList, NameList, XMLSchemaList, DocTypeList,
               DestinationList, ReplyReqList, and ReplySelectorList  property
               values
  Parameters:  pcDirections     AS CHARACTER
               pcNames          AS CHARACTER
               pcSchemas        AS CHARACTER
               pcDestinations   AS CHARACTER
               pcReplyReqs      AS CHARACTER
               pcSelectors      AS CHARACTER 
  Notes: Creates mapping records for entries where the corresponding 
         entry in pcDirection = gcDirection  (consumer or producer)      
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDirections    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNames         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcSchemas       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDTDPublicIds  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDTDSystemIds  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDestinations  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcReplyReqs     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcSelectors     AS CHARACTER NO-UNDO.

DEFINE VARIABLE iNumDest AS INTEGER   NO-UNDO.

  DO iNumDest = 1 TO NUM-ENTRIES(pcDirections, CHR(1)):
    IF ENTRY(iNumDest, pcDirections, CHR(1)) = gcDirection THEN
    DO:
       
      CREATE mapping.
      ASSIGN
        mapping.NAME        = ENTRY(iNumDest, pcNames, CHR(1))
        mapping.xmlschema   = ENTRY(iNumDest, pcSchemas, CHR(1))
        mapping.dtdSystemID = ENTRY(iNumDest, pcDTDSystemIDs, CHR(1))
        mapping.dtdPublicID = ENTRY(iNumDest, pcDTDPublicIDs, CHR(1))
        mapping.destination = ENTRY(iNumDest, pcDestinations, CHR(1))
        mapping.replyreq    = IF ENTRY(iNumDest, pcReplyReqs, CHR(1)) = "yes":U
                              THEN TRUE ELSE FALSE.
        mapping.replysel    = ENTRY(iNumDest, pcSelectors, CHR(1)).     
    END.
  END.  /* do iNumDest */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DestinationValidate dTables  _DB-REQUIRED
PROCEDURE DestinationValidate :
/*------------------------------------------------------------------------------
  Purpose:    Validate Destination  
  Parameters:  Value from screen 
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcDest AS CHARACTER  NO-UNDO.
   
   IF pcDest = "":U AND gcDirection = 'Producer':U THEN 
     RETURN "Destination Must be entered for a producing document.".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NameValidate dTables  _DB-REQUIRED
PROCEDURE NameValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcName AS CHARACTER  NO-UNDO.
  IF gcDirection = "Producer":U AND pcName = "":U THEN
    RETURN "Name must be entered for a producing document.".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnMappings dTables  _DB-REQUIRED
PROCEDURE returnMappings :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns lists of Directions, Names, Schemas,
               DocTypes, Destinations, ReplyReqs, and Reply Selectors
  Parameters:  pcDirections     AS CHARACTER
               pcNames          AS CHARACTER
               pcSchemas        AS CHARACTER
               pcDestinations   AS CHARACTER
               pcReplyReqs      AS CHARACTER
               pcSelectors      AS CHARACTER 
  Notes: Append this object's mappings to each variables (chr(1) separated)      
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER pcDirections    AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcNames         AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcSchemas       AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcDTDPublicIds  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcDTDSystemIds  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcDestinations  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcReplyReqs     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcSelectors     AS CHARACTER NO-UNDO.

DEFINE VARIABLE lFirst AS LOGICAL INIT TRUE NO-UNDO.
  lFirst = pcDirections = "":U. 
  FOR EACH mapping:
    ASSIGN 
      pcDirections   = pcDirections + 
                         (IF lFirst THEN "":U ELSE CHR(1)) +
                         gcDirection
      pcNames        = pcNames + 
                         (IF lFirst THEN "":U ELSE CHR(1)) +
                         mapping.NAME
      pcSchemas      = pcSchemas + 
                         (IF lFirst THEN "":U ELSE CHR(1)) +
                         mapping.XMLSchema
      pcDTDPublicIds = pcDTDPublicIds + 
                         (IF lFirst THEN "":U ELSE CHR(1)) +
                         mapping.dtdPublicID
      pcDTDSystemIds = pcDTDSystemIds + 
                         (IF lFirst THEN "":U ELSE CHR(1)) +
                         mapping.dtdSystemID
      pcDestinations = pcDestinations +
                         (IF lFirst THEN "":U ELSE CHR(1)) +
                         mapping.destination
      pcReplyReqs    = pcReplyReqs +
                         (IF lFirst THEN "":U ELSE CHR(1)) +
                         IF mapping.replyreq THEN "yes":U ELSE "no":U
      pcSelectors    = pcSelectors +
                         (IF lFirst THEN "":U ELSE CHR(1)) +
                         mapping.replysel.
    lFirst = FALSE.
  END.  /* for each destination */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XMLSchemaValidate dTables  _DB-REQUIRED
PROCEDURE XMLSchemaValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcDest AS CHARACTER  NO-UNDO.
  IF pcDest = "":U THEN
    RETURN "An XML Mapping File must be entered.".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDirection dTables  _DB-REQUIRED
FUNCTION getDirection RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gcdirection.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDirection dTables  _DB-REQUIRED
FUNCTION setDirection RETURNS LOGICAL
  (pcDirection AS CHAR):

/*------------------------------------------------------------------------------
  Purpose:  This is called from the container to specify producer or consumer
    Notes:  
------------------------------------------------------------------------------*/
  gcDirection = pcdirection.
  RETURN FALSE.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

