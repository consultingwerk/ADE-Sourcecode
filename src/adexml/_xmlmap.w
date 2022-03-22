&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

  File: adexml/_xmlmap.w

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author: D.M.Adams
  Created: 05/16/2000

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
{ adexml/xmldefs.i }

DEFINE VARIABLE gcConversion AS CHARACTER  NO-UNDO. /* Conversion Function */
DEFINE VARIABLE gcDataType   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFile       AS CHARACTER  NO-UNDO. /* data source file */
DEFINE VARIABLE gchNode      AS COM-HANDLE NO-UNDO. /* selected node */
DEFINE VARIABLE gcMode       AS CHARACTER  NO-UNDO. /* consumer/producer */
DEFINE VARIABLE gcName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObject     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjects    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcParameter  AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghProc       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSmartB2B   AS HANDLE     NO-UNDO.
DEFINE VARIABLE giTabPage    AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcUpdate     AS CHARACTER  NO-UNDO.

DEFINE VARIABLE old_hit   AS DECIMAL    NO-UNDO. /* initial height      */
DEFINE VARIABLE old_wid   AS DECIMAL    NO-UNDO. /* initial width       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS procedureObject entryType internalEntries ~
parameterList consumerUpdate rObject 
&Scoped-Define DISPLAYED-OBJECTS procedureObject entryType internalEntries ~
text4 parameterList consumerUpdate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD convertType sObject 
FUNCTION convertType RETURNS CHARACTER
  ( INPUT pSchemaType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataType sObject 
FUNCTION getDataType RETURNS LOGICAL
  ( INPUT pDataType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEntry sObject 
FUNCTION getEntry RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMapPhrase sObject 
FUNCTION getMapPhrase RETURNS CHARACTER
  ( INPUT pText   AS CHARACTER, 
    INPUT pObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD testFunction sObject 
FUNCTION testFunction RETURNS LOGICAL
  ( INPUT pHandle   AS HANDLE,
    INPUT cIntEntry AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD testProcedure sObject 
FUNCTION testProcedure RETURNS LOGICAL
  ( INPUT pHandle   AS HANDLE,
    INPUT cIntEntry AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD trimMode sObject 
FUNCTION trimMode RETURNS CHARACTER
  ( INPUT pValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Map 
     LABEL "&Map" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Unmap 
     LABEL "&Unmap" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE procedureObject AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 72 BY 1 NO-UNDO.

DEFINE VARIABLE text4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .86 NO-UNDO.

DEFINE VARIABLE consumerUpdate AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Update (may exist)", "update-may",
"Update (must exist)", "update-must",
"Create only", "create only",
"Delete", "delete",
"Find", "find"
     SIZE-PIXELS 349 BY 88 NO-UNDO.

DEFINE VARIABLE entryType AS CHARACTER INITIAL "column" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Object", "object",
"Column", "column",
"Procedure", "procedure",
"Function", "function"
     SIZE 53 BY .95 NO-UNDO.

DEFINE RECTANGLE rObject
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71.8 BY 4.52.

DEFINE VARIABLE internalEntries AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 72 BY 5 NO-UNDO.

DEFINE VARIABLE parameterList AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 71.8 BY 4.52 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     procedureObject AT ROW 1.95 COL 1 NO-LABEL
     entryType AT ROW 3.38 COL 20 NO-LABEL
     internalEntries AT ROW 4.57 COL 1 NO-LABEL
     Btn_Map AT ROW 9.81 COL 42
     Btn_Unmap AT ROW 9.81 COL 58
     text4 AT ROW 10.29 COL 1 NO-LABEL
     parameterList AT ROW 11.24 COL 1 NO-LABEL
     consumerUpdate AT Y 221 X 5 NO-LABEL
     rObject AT ROW 11.24 COL 1
     "Object:" VIEW-AS TEXT
          SIZE 19 BY .62 AT ROW 1.24 COL 2
     "Map to:" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 3.62 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 14.81
         WIDTH              = 72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:HEIGHT           = 14.81
       FRAME F-Main:WIDTH            = 72.

/* SETTINGS FOR BUTTON Btn_Map IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn_Unmap IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       parameterList:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR COMBO-BOX procedureObject IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text4 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Map
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Map sObject
ON CHOOSE OF Btn_Map IN FRAME F-Main /* Map */
DO:
  DEFINE VARIABLE c4GLDataType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBase           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnDataType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConversion     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDataType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParam          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefix         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSignature      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cText           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSchema         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO INITIAL ?.
  DEFINE VARIABLE iPos            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lReturn         AS LOGICAL    NO-UNDO.
  
  ASSIGN
    cText     = gchNode:TEXT
    iPos      = INDEX(cText, "(":U)
    cObject   = ENTRY(1, procedureObject:SCREEN-VALUE, " ":U)
    cType     = entryType:SCREEN-VALUE.
  
  IF iPos > 0 THEN
    cText = SUBSTRING(cText, 1, (iPos - 2), "CHARACTER":U).
  cNodeName = cText.

  CASE cType:
    WHEN "object":U THEN DO: /* object */
      cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN ghProc) NO-ERROR.
      ASSIGN
        cText     = cText + " (":U + cObject + 
                      (IF cObjectType <> ? AND 
                         cObjectType = "SmartBusinessObject":U THEN
                         ".":U + internalEntries:SCREEN-VALUE ELSE "") +
                      (IF gcMode = "producer":U THEN ""
                       ELSE ":":U + consumerUpdate:SCREEN-VALUE) + ")":U.
    END.
    WHEN "column":U THEN DO: /* column */
      ASSIGN
        cConversion     = (IF parameterList:SCREEN-VALUE = "<none>":U 
                           THEN "" ELSE IF VALID-HANDLE(ghSmartB2B) 
                           THEN parameterList:SCREEN-VALUE ELSE "")
        cText           = cText + " (":U + cObject + ".":U +
                            internalEntries:SCREEN-VALUE + 
                            (IF cConversion = "" THEN "" ELSE
                             ":":U + cConversion) + ")":U
        cColumnDataType = DYNAMIC-FUNCTION("columnDataType":U IN ghProc, 
                            internalEntries:SCREEN-VALUE) NO-ERROR.

      /* Datatype check when Conversion Function is not used. Otherwise we'll
         rely on the Conversion Function to return the correct data type at
         run time.
      IF dataTypeWarning AND cConversion = "" THEN DO:
        ASSIGN
          hContainer    = DYNAMIC-FUNCTION("getContainerSource":U)
          cNodeDataType = DYNAMIC-FUNCTION("getDataType" IN hContainer)
          c4GLDataType  = convertType(cNodeDataType).

        IF c4GLDataType <> cColumnDataType AND 
          c4GLDataType <> "" AND cColumnDataType <> "" THEN DO:
          RUN adecomm/_s-alert.p (INPUT-OUTPUT lReturn, "warning":U, "yes-no":U,
            SUBSTITUTE("The data types of the data source &1 (&2) and the node target &3 (&4) do not match. This mapping may produce run time errors.^^Do you want to proceed?",
              internalEntries:SCREEN-VALUE, cColumnDataType, cNodeName, c4GLDataType)).
          IF lReturn <> yes THEN RETURN.
        END.
      END.
      */
    END.
    WHEN "procedure":U OR  /* procedure */
    WHEN "function":U THEN /* function */
      ASSIGN
        cText  = getMapPhrase(cText, cObject)
        iEntry = getEntry() - 2.
  END CASE.

  ASSIGN
    gchNode:TEXT        = cText
    btn_unmap:SENSITIVE = TRUE
    iPos                = procedureObject:LOOKUP(procedureObject:SCREEN-VALUE)
    cFile               = ENTRY(iPos, gcObjects).

  /* Update tData temp-table */
  PUBLISH "mapNode":U (/* TreeView node */ gchNode,
                       /* mapFile       */ cFile,
                       /* mapObject     */ cObject,
                       /* mapName       */ internalEntries:SCREEN-VALUE,
                       /* mapType       */ cType,
                       /* mapParameter  */ (IF iEntry = ? THEN 0 
                                            ELSE iEntry),
                       /* mapUpdate     */ (IF cType = "object":U THEN 
                                              consumerUpdate:SCREEN-VALUE
                                            ELSE ""),
                       /* mapConversion */ cConversion).
  PUBLISH "isDirty":U.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Unmap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Unmap sObject
ON CHOOSE OF Btn_Unmap IN FRAME F-Main /* Unmap */
DO:
  DEFINE VARIABLE cText AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos  AS INTEGER    NO-UNDO.
  
  ASSIGN
    cText = gchNode:TEXT
    iPos  = INDEX(cText, "(":U).
    
  IF iPos > 0 THEN
    gchNode:TEXT = SUBSTRING(cText, 1, (iPos - 2), "CHARACTER":U).
    
  /* Update tData temp-table */
  PUBLISH "mapNode":U (/* TreeView node */ gchNode,
                       /* mapFile       */ "",
                       /* mapObject     */ "",
                       /* mapName       */ "",
                       /* mapType       */ "",
                       /* mapParameter  */ ?,
                       /* mapUpdate     */ "",
                       /* mapConversion */ "").
  PUBLISH "isDirty":U.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME entryType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL entryType sObject
ON VALUE-CHANGED OF entryType IN FRAME F-Main
DO:
  IF giTabPage = 1 THEN
  DO WITH FRAME {&FRAME-NAME}:
    CASE SELF:SCREEN-VALUE:
      WHEN "object":U THEN
        text4:SCREEN-VALUE = "Action:".
      WHEN "column":U THEN
        text4:SCREEN-VALUE = "B2B Conversion Function:".
      WHEN "procedure":U OR
      WHEN "function":U THEN
        text4:SCREEN-VALUE = "Parameters:".
    END CASE.
    
    ASSIGN
      parameterList:VISIBLE    = NOT CAN-DO("column,object":U, SELF:SCREEN-VALUE)
                                 OR (SELF:SCREEN-VALUE = "column":U AND
                                     VALID-HANDLE(ghSmartB2B))
      parameterList:SENSITIVE  = NOT CAN-DO("column,object":U, SELF:SCREEN-VALUE)
                                 OR (SELF:SCREEN-VALUE = "column":U AND
                                     VALID-HANDLE(ghSmartB2B))
      rObject:VISIBLE          = CAN-DO("column,object":U, SELF:SCREEN-VALUE)
      consumerUpdate:VISIBLE   = (SELF:SCREEN-VALUE = "object":U) AND
                                   gcMode = "consumer":U
      consumerUpdate:SENSITIVE = (SELF:SCREEN-VALUE = "object":U) AND
                                   gcMode = "consumer":U.
  END.

  RUN setEntries (ghProc).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME internalEntries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL internalEntries sObject
ON DEFAULT-ACTION OF internalEntries IN FRAME F-Main
DO:
  DO WITH FRAME {&FRAME-NAME}:
    IF CAN-DO("column,object",entryType:SCREEN-VALUE) THEN
      APPLY "choose":U TO btn_map.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL internalEntries sObject
ON VALUE-CHANGED OF internalEntries IN FRAME F-Main
DO:
  RUN setParameters.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME parameterList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL parameterList sObject
ON DEFAULT-ACTION OF parameterList IN FRAME F-Main
DO:
  DO WITH FRAME {&FRAME-NAME}:
    IF CAN-DO("function,procedure":U, entryType:SCREEN-VALUE) THEN
      APPLY "choose":U TO btn_map.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME procedureObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL procedureObject sObject
ON VALUE-CHANGED OF procedureObject IN FRAME F-Main
DO:
  DEFINE VARIABLE cObject  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry   AS INTEGER    NO-UNDO.
  
  /* Populate Map To selection list */
  ASSIGN
    cObject  = SELF:SCREEN-VALUE
    iEntry   = SELF:LOOKUP(cObject)
    ghProc   = (IF iEntry = ? THEN ? ELSE 
                  WIDGET-HANDLE(ENTRY(iEntry,SELF:PRIVATE-DATA))) NO-ERROR.
    
  IF ghProc = ? THEN
    Btn_Map:SENSITIVE = FALSE.
    
  RUN setEntries (ghProc).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the AppBuilder, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN 
    gcMode                 = "consumer":U  /* temporary hack */
    entryType:SCREEN-VALUE = "column":U.
  APPLY "value-changed":U TO entryType.
END.

SUBSCRIBE TO "synchronize":U      IN THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePage sObject 
PROCEDURE changePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piPage AS INTEGER    NO-UNDO.
  
  giTabPage = piPage.
  
  APPLY "value-changed":U TO entryType IN FRAME {&FRAME-NAME}.

  /* Synchronize Map tab */
  IF piPage = 1 AND gcFile <> "" THEN
    PUBLISH "synchronize":U (gcFile,
                             gcObject,
                             gcName,
                             gcType,
                             gcParameter,
                             gcUpdate,
                             gcConversion).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getColumns sObject 
PROCEDURE getColumns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pHandle AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pList   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cColumnList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectColumns AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectNames   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iy             AS INTEGER    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    internalEntries:LIST-ITEMS = "".
      
    cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN pHandle) NO-ERROR.
    IF cObjectType <> ? THEN DO:
      CASE cObjectType:
        WHEN "SmartDataObject":U THEN
          pList = DYNAMIC-FUNCTION("getDataColumns":U IN pHandle).
        WHEN "SmartBusinessObject":U THEN DO:
          ASSIGN
            cObjectColumns = DYNAMIC-FUNCTION("getContainedDataColumns":U 
                               IN pHandle)
            cObjectNames   = DYNAMIC-FUNCTION("getDataObjectNames":U 
                               IN pHandle).
            
          DO ix = 1 TO NUM-ENTRIES(cObjectColumns, ";":U):
            cColumnList = ENTRY(ix, cObjectColumns, ";":U).
              
            DO iy = 1 TO NUM-ENTRIES(cColumnList):
              pList = pList + (IF pList = "" THEN "" ELSE ",":U) +
                      ENTRY(ix, cObjectNames) + ".":U + 
                      ENTRY(iy, cColumnList).
            END.
          END.
        END.
      END CASE.
    END.
    
    IF pList <> "" THEN
      ASSIGN
        internalEntries:LIST-ITEMS   = pList
        internalEntries:SCREEN-VALUE = internalEntries:ENTRY(1).
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFunctions sObject 
PROCEDURE getFunctions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pHandle AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pList   AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix     AS INTEGER    NO-UNDO.
  
  DO ix = 1 TO NUM-ENTRIES(pHandle:INTERNAL-ENTRIES):
    cEntry = ENTRY(ix, pHandle:INTERNAL-ENTRIES).
    IF ENTRY(1, pHandle:GET-SIGNATURE(cEntry)) <> "FUNCTION":U THEN NEXT.
    
    IF testFunction(pHandle, cEntry) THEN
      ASSIGN pList = pList + (IF pList = "" THEN "" ELSE ",":U) + cEntry.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjects sObject 
PROCEDURE getObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pHandle AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pList   AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cObjectType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cList        AS CHARACTER  NO-UNDO. /* SDO handles */
  
  cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN pHandle) NO-ERROR.
  
  IF cObjectType = ? THEN
    pList = "".
  ELSE DO:
    CASE cObjectType:
      WHEN "SmartDataObject":U THEN
        pList = DYNAMIC-FUNCTION("getObjectName":U IN pHandle).
      WHEN "SmartBusinessObject":U THEN DO:
        ASSIGN
          cList = DYNAMIC-FUNCTION("getContainedDataObjects":U IN pHandle)
          pList = DYNAMIC-FUNCTION("getDataObjectNames":U IN pHandle).
      END.
    END CASE.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProcedures sObject 
PROCEDURE getProcedures :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pHandle AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pList   AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cIntEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSigEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iy        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lOK       AS LOGICAL    NO-UNDO.
  
  DO ix = 1 TO NUM-ENTRIES(pHandle:INTERNAL-ENTRIES):
    ASSIGN 
      cIntEntry = ENTRY(ix, pHandle:INTERNAL-ENTRIES)
      lOK       = FALSE.
    IF ENTRY(1, pHandle:GET-SIGNATURE(cIntEntry)) <> "PROCEDURE":U THEN NEXT.
    
    IF testProcedure(pHandle, cIntEntry) THEN
      ASSIGN pList = pList + (IF pList = "" THEN "" ELSE ",":U) + cIntEntry.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadProcedures sObject 
PROCEDURE loadProcedures :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER cObjects  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER cHandles  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER cNames    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER hSmartB2B AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix    AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      procedureObject:LIST-ITEMS   = ""
      procedureObject:PRIVATE-DATA = ""
      ghProc                       = ?
      gcObjects                    = cObjects
      ghSmartB2B                   = hSmartB2B.
      
    IF cObjects NE "" AND cObjects NE ? THEN DO:
      DO ix = 1 TO NUM-ENTRIES(cObjects):
        cList = cList + (IF ix > 1 THEN ",":U ELSE "") +
                  ENTRY(ix, cNames) + " (":U + 
                  ENTRY(ix, cObjects) + ")":U.
      END.
      
      ASSIGN
        procedureObject:LIST-ITEMS   = cList
        procedureObject:SCREEN-VALUE = procedureObject:ENTRY(1) 
        procedureObject:PRIVATE-DATA = cHandles
        ghProc                       = WIDGET-HANDLE(ENTRY(1, cHandles)).
    END.
    
    APPLY "value-changed":U TO procedureObject.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modeChange sObject 
PROCEDURE modeChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pMode AS CHARACTER NO-UNDO.
  
  gcMode = pMode.
  
  APPLY "value-changed":U TO entryType IN FRAME {&FRAME-NAME}.
  
  PUBLISH "isDirty":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveObject sObject 
PROCEDURE moveObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pRow    AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pColumn AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE dRow    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dColumn AS DECIMAL    NO-UNDO.
  
  {get ROW dRow}.
  {get COLUMN dColumn}.
  
  dColumn = IF pColumn = ? THEN dColumn ELSE pColumn.
  
  RUN repositionObject ( dRow, dColumn ) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nodeClick sObject 
PROCEDURE nodeClick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pNode AS COM-HANDLE NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      gchNode             = pNode
      btn_map:SENSITIVE   = gchNode <> ? AND ghProc <> ?
      btn_unmap:SENSITIVE = (gchNode <> ? AND 
                           gchNode:TEXT MATCHES "*(*)":U).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHeight AS DECIMAL NO-UNDO. /* container height */
  DEFINE INPUT PARAMETER pWidth  AS DECIMAL NO-UNDO. /* container width */

  /* window height growing */
  IF pHeight <> ? AND pHeight > old_hit THEN
    ASSIGN
      FRAME {&FRAME-NAME}:HEIGHT              = pHeight
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT      = pHeight
      /*editor-1:HEIGHT IN FRAME {&FRAME-NAME}  = pHeight*/ .
  ELSE
  /* window height shrinking */
  IF pHeight <> ? AND pHeight < old_hit THEN
    ASSIGN
      /*editor-1:HEIGHT IN FRAME {&FRAME-NAME}    = pHeight*/
      FRAME {&FRAME-NAME}:HEIGHT                = pHeight
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT        = pHeight.
  
  /* window width growing */
  IF pWidth <> ? AND pWidth > old_wid THEN
    ASSIGN
      FRAME {&FRAME-NAME}:WIDTH                 = pWidth
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH         = pWidth
      /*editor-1:WIDTH IN FRAME {&FRAME-NAME}     = pWidth*/ .
  ELSE
  /* window width shrinking */
  IF pWidth <> ? AND SELF:WIDTH-PIXELS < old_wid THEN
    ASSIGN
      /*editor-1:WIDTH IN FRAME {&FRAME-NAME}     = pWidth*/
      FRAME {&FRAME-NAME}:WIDTH                 = pWidth
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH         = pWidth.
  
  ASSIGN
    old_hit = pHeight WHEN pHeight <> ?
    old_wid = pWidth  WHEN pWidth  <> ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEntries sObject 
PROCEDURE setEntries :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pHandle AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cList       AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      internalEntries:LIST-ITEMS   = "".
    
    IF VALID-HANDLE(pHandle) THEN DO:
      CASE entryType:SCREEN-VALUE:
        WHEN "object":U THEN    /* SBO data objects */
          RUN getObjects (pHandle, OUTPUT cList).
        WHEN "column":U THEN    /* SBO/SDO field columns */
          RUN getColumns (pHandle, OUTPUT cList).
        WHEN "procedure":U THEN /* internal procedures */ 
          RUN getProcedures (pHandle, OUTPUT cList).
        WHEN "function":U THEN  /* functions */
          RUN getFunctions (pHandle, OUTPUT cList).
      END CASE.
    
      ASSIGN
        internalEntries:LIST-ITEMS   = cList
        internalEntries:SCREEN-VALUE = internalEntries:ENTRY(1)
                                       WHEN cList <> "".
    END.
    
    RUN setParameters.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameters sObject 
PROCEDURE setParameters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEntry     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSigEntry  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSignature AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lColumn    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFunction  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lObject    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOK        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lProcedure AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReturn    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iy         AS INTEGER    NO-UNDO.
   
  /* Temp selection list for sorting SmartB2B conversion functions. */
  DEFINE FRAME a cSortList 
    VIEW-AS SELECTION-LIST SINGLE SORT SIZE 72 BY 5.
  FRAME a:HIDDEN = TRUE.
    
  DO WITH FRAME {&FRAME-NAME}:
    parameterList:LIST-ITEMS = "".

    IF VALID-HANDLE(ghProc) THEN DO:
      ASSIGN 
        cSignature               = ghProc:GET-SIGNATURE(internalEntries:SCREEN-VALUE)
        lColumn                  = entryType:SCREEN-VALUE = "column":U
        lObject                  = entryType:SCREEN-VALUE = "object":U
        lProcedure               = ENTRY(1, cSignature) = "PROCEDURE":U
        lFunction                = ENTRY(1, cSignature) = "FUNCTION":U.
        
      /* If a Function, insert line indicating the return value datatype */
      IF lFunction AND (gcMode = "producer":U) THEN
        lReturn = parameterList:ADD-LAST("FUNCTION returns ":U + 
                                         CAPS(ENTRY(2, cSignature))).
    
      IF (lFunction OR lProcedure) AND NUM-ENTRIES(cSignature) > 2 THEN DO:
        DO ix = 3 TO NUM-ENTRIES(cSignature):
          cSigEntry = ENTRY(ix, cSignature).
        
          IF lFunction THEN
            lOK = (gcMode = "consumer":U AND cSigEntry BEGINS "INPUT":U) OR
                  (gcMode = "producer":U AND cSigEntry BEGINS "OUTPUT":U).
          IF lProcedure THEN
            lOK = (gcMode = "consumer":U AND cSigEntry BEGINS "INPUT":U) OR
                  (gcMode = "producer":U AND cSigEntry BEGINS "OUTPUT":U) OR
                  (gcMode = "producer":U AND cSigEntry BEGINS "INPUT-OUTPUT":U).
          IF lOK THEN
            lReturn = parameterList:ADD-LAST(cSigEntry).
        END.
      
        parameterList:SCREEN-VALUE = parameterList:ENTRY(1).
      END.
      
      /* Select SmartB2B functions with only one INPUT parameter. */
      IF lColumn AND VALID-HANDLE(ghSmartB2B) THEN DO:
        ASSIGN
          lOK                   = FALSE
          lReturn               = cSortList:ADD-LAST("<none>").
        
        DO ix = 1 TO NUM-ENTRIES(ghSmartB2B:INTERNAL-ENTRIES):
          ASSIGN
            iCount = 0
            cEntry = ENTRY(ix, ghSmartB2B:INTERNAL-ENTRIES).
          IF ENTRY(1, ghSmartB2B:GET-SIGNATURE(cEntry)) <> "FUNCTION":U THEN NEXT.
    
          DO iy = 3 TO NUM-ENTRIES(ghSmartB2B:GET-SIGNATURE(cEntry)):
            cSigEntry = ENTRY(iy, ghSmartB2B:GET-SIGNATURE(cEntry)).
            IF ENTRY(1, cSigEntry, " ":U) = "INPUT":U THEN
              iCount    = iCount + 1.
          END.
          IF iCount = 1 THEN
            lReturn = cSortList:ADD-LAST(cEntry) IN FRAME a.
        END.
        parameterList:LIST-ITEMS = cSortList:LIST-ITEMS IN FRAME a.
        IF parameterList:NUM-ITEMS > 0 THEN
          parameterList:SCREEN-VALUE = parameterList:ENTRY(1).
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE synchronize sObject 
PROCEDURE synchronize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pFile       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pObject     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pName       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pType       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pParameter  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pUpdate     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pConversion AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
  
  ASSIGN
    gcFile       = pFile
    gcObject     = pObject
    gcName       = pName
    gcType       = pType
    gcParameter  = pParameter
    gcUpdate     = pUpdate
    gcConversion = pConversion.
  
  DO WITH FRAME {&FRAME-NAME}:
    cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN ghProc) NO-ERROR.
    IF CAN-DO("SmartDataObject,SmartBusinessObject,SmartB2BObject":U, cObjectType) THEN
       pFile = pObject + " (":U + pFile + ")":U.

    ASSIGN 
      procedureObject:SCREEN-VALUE = pFile 
      entryType:SCREEN-VALUE       = ptype NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN DO:
      APPLY "value-changed":U TO entryType.
      APPLY "value-changed":U TO procedureObject.
    END.
    
    CASE pType:
      WHEN "column":U THEN
        ASSIGN
          internalEntries:SCREEN-VALUE = pName WHEN pName <> ""
          parameterList:SCREEN-VALUE   = 
            (IF pConversion = "" THEN "<none>":U ELSE pConversion)
            WHEN VALID-HANDLE(ghSmartB2B).
      WHEN "object":U THEN
        ASSIGN
          consumerUpdate:SCREEN-VALUE  = pUpdate
          internalEntries:SCREEN-VALUE = pName WHEN pName <> "".
      WHEN "procedure":U OR
      WHEN "function":U THEN DO:
        ASSIGN
          internalEntries:SCREEN-VALUE = pName WHEN pName <> "".
        APPLY "value-changed":U TO internalEntries.
        ASSIGN
          parameterList:SCREEN-VALUE   = parameterList:ENTRY(pParameter).
      END.
    END CASE.
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION convertType sObject 
FUNCTION convertType RETURNS CHARACTER
  ( INPUT pSchemaType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Converts XML Schema data type to 4GL data type.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c4GLType AS CHARACTER  NO-UNDO.

  pSchemaType = ENTRY(NUM-ENTRIES(pSchemaType,":":U), pSchemaType,":":U).
  
  CASE pSchemaType:
    WHEN "binary":U             THEN c4GLType = "raw".
    WHEN "boolean":U            THEN c4GLType = "logical".
    WHEN "byte":U               THEN c4GLType = "".
    WHEN "CDATA":U              THEN c4GLType = "character".
    WHEN "century":U            THEN c4GLType = "".
    WHEN "date":U               THEN c4GLType = "".
    WHEN "decimal":U            THEN c4GLType = "decimal".
    WHEN "double":U             THEN c4GLType = "".
    WHEN "ENTITY":U             THEN c4GLType = "character".
    WHEN "ENTITIES":U           THEN c4GLType = "character".
    WHEN "float":U              THEN c4GLType = "".
    WHEN "ID":U                 THEN c4GLType = "character".
    WHEN "IDREF":U              THEN c4GLType = "character".
    WHEN "IDREFS":U             THEN c4GLType = "character".
    WHEN "int":U                THEN c4GLType = "integer".
    WHEN "integer":U            THEN c4GLType = "integer".
    WHEN "language":U           THEN c4GLType = "character".
    WHEN "long":U               THEN c4GLType = "".
    WHEN "month":U              THEN c4GLType = "".
    WHEN "Name":U               THEN c4GLType = "character".
    WHEN "NCName":U             THEN c4GLType = "character".
    WHEN "negativeInteger":U    THEN c4GLType = "integer".
    WHEN "NMTOKEN":U            THEN c4GLType = "character".
    WHEN "NMTOKENS":U           THEN c4GLType = "character".
    WHEN "nonNegativeInteger":U THEN c4GLType = "integer".
    WHEN "nonPositiveInteger":U THEN c4GLType = "integer".
    WHEN "NOTATION":U           THEN c4GLType = "character".
    WHEN "positiveInteger":U    THEN c4GLType = "integer".
    WHEN "QName":U              THEN c4GLType = "character".
    WHEN "recurringDate":U      THEN c4GLType = "".
    WHEN "recurringDay":U       THEN c4GLType = "".
    WHEN "recurringDuration":U  THEN c4GLType = "".
    WHEN "short":U              THEN c4GLType = "".
    WHEN "string":U             THEN c4GLType = "character".
    WHEN "time":U               THEN c4GLType = "".
    WHEN "timeDuration":U       THEN c4GLType = "".
    WHEN "timeInstant":U        THEN c4GLType = "".
    WHEN "timePeriod":U         THEN c4GLType = "".
    WHEN "token":U              THEN c4GLType = "character".
    WHEN "unsignedByte":U       THEN c4GLType = "".
    WHEN "unsignedInt":U        THEN c4GLType = "integer".
    WHEN "unsignedLong":U       THEN c4GLType = "".
    WHEN "unsignedShort":U      THEN c4GLType = "".
    WHEN "uriReference":U       THEN c4GLType = "character".
    WHEN "year":U               THEN c4GLType = "".
  END CASE.

  RETURN c4GLType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataType sObject 
FUNCTION getDataType RETURNS LOGICAL
  ( INPUT pDataType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  gcDataType = pDataType.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEntry sObject 
FUNCTION getEntry RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParam     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSignature AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cParam     = parameterList:SCREEN-VALUE
      cSignature = ghProc:GET-SIGNATURE(internalEntries:SCREEN-VALUE).
      
    RETURN LOOKUP(cParam, cSignature).
  END.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMapPhrase sObject 
FUNCTION getMapPhrase RETURNS CHARACTER
  ( INPUT pText   AS CHARACTER, 
    INPUT pObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParam     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSignature AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry     AS INTEGER    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      iEntry     = getEntry() - 2
      cParam     = trimMode(parameterList:SCREEN-VALUE)
      cParam     = (IF cParam = ? THEN "" ELSE cParam)
      pText      = pText + " (":U + pObject + ":":U +
                   internalEntries:SCREEN-VALUE + ":":U + 
                   TRIM(cParam) + ")":U.
  END.
  
  RETURN pText. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION testFunction sObject 
FUNCTION testFunction RETURNS LOGICAL
  ( INPUT pHandle   AS HANDLE,
    INPUT cIntEntry AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSigEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lOK       AS LOGICAL    NO-UNDO.
  
  /* If object is a consumer, allow functions with INPUT parameters
     only.  If object is a producer, allow any functions. */
  DO ix = 3 TO NUM-ENTRIES(pHandle:GET-SIGNATURE(cIntEntry))
    WHILE lOK = FALSE:
    ASSIGN  
      cSigEntry = ENTRY(ix, pHandle:GET-SIGNATURE(cIntEntry))
      lOK       = (gcMode = "consumer":U AND cSigEntry BEGINS "INPUT":U) OR 
                  (gcMode = "producer":U).
  END.
  
  RETURN lOK.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION testProcedure sObject 
FUNCTION testProcedure RETURNS LOGICAL
  ( INPUT pHandle   AS HANDLE,
    INPUT cIntEntry AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSigEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lOK       AS LOGICAL    NO-UNDO.
  
  /* If object is a consumer, allow procedures with INPUT parameters
     only.  If object is a producer, allow procedures with OUTPUT
     parameters only. */
  DO ix = 3 TO NUM-ENTRIES(pHandle:GET-SIGNATURE(cIntEntry))
    WHILE lOK = FALSE:
    ASSIGN  
      cSigEntry = ENTRY(ix, pHandle:GET-SIGNATURE(cIntEntry))
      lOK       = (gcMode = "consumer":U AND cSigEntry BEGINS "INPUT":U) OR
                  (gcMode = "producer":U AND cSigEntry BEGINS "OUTPUT":U) OR
                  (gcMode = "producer":U AND cSigEntry BEGINS "INPUT-OUTPUT":U).
  END.
  
  RETURN lOK.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION trimMode sObject 
FUNCTION trimMode RETURNS CHARACTER
  ( INPUT pValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMode   AS CHARACTER  NO-UNDO INITIAL
  "input-output table,input-output,input table,input,output table,output,buffer".
  DEFINE VARIABLE iLength AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFound  AS LOGICAL    NO-UNDO.
  
  /* Extract parameter name */
  DO ix = 1 TO NUM-ENTRIES(cMode):
    IF pValue BEGINS ENTRY(ix, cMode) THEN DO:
      RETURN ENTRY(1, TRIM(TRIM(pValue, ENTRY(ix, cMode))), " ":U).
    END.
  END.
  IF NOT lFound THEN
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

