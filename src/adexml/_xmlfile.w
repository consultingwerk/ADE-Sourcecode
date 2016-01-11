&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
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
**********************************************************************

  File:

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:
  Created:

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
DEFINE VARIABLE gcOldObject AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSmartB2B  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghSmartB2B  AS HANDLE     NO-UNDO.

DEFINE VARIABLE old_hit   AS DECIMAL NO-UNDO. /* initial viewer height */
DEFINE VARIABLE old_wid   AS DECIMAL NO-UNDO. /* initial viewer width */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiObjectName Btn_Add dataObjects Btn_MoveUp ~
Btn_MoveDown cpMode Btn_Browse fiContainer dataHandles dataNames 
&Scoped-Define DISPLAYED-OBJECTS fiObjectName dataObjects cpMode ~
fiContainer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainer sObject 
FUNCTION getContainer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCPMode sObject 
FUNCTION getCPMode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectHandles sObject 
FUNCTION getObjectHandles RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUnSafe sObject 
FUNCTION getUnSafe RETURNS CHARACTER
  ( INPUT pValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainer sObject 
FUNCTION setContainer RETURNS LOGICAL
  ( INPUT pContainer AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCPMode sObject 
FUNCTION setCPMode RETURNS LOGICAL
  ( INPUT pMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Add 
     LABEL "&Add..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Browse 
     LABEL "Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_MoveDown 
     LABEL "Move &Down" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_MoveUp 
     LABEL "Move &Up" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Remove 
     LABEL "&Remove" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE fiContainer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Container" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE cpMode AS CHARACTER INITIAL "consumer" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Consumer", "consumer",
"Producer", "producer"
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE dataHandles AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 56 BY 1.91 NO-UNDO.

DEFINE VARIABLE dataNames AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 56 BY 1.91 NO-UNDO.

DEFINE VARIABLE dataObjects AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 56 BY 7.14 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fiObjectName AT ROW 2.19 COL 1 NO-LABEL
     Btn_Add AT ROW 2.19 COL 58
     dataObjects AT ROW 3.38 COL 1 NO-LABEL
     Btn_Remove AT ROW 3.62 COL 58
     Btn_MoveUp AT ROW 7.91 COL 58
     Btn_MoveDown AT ROW 9.33 COL 58
     cpMode AT ROW 10.52 COL 11.6 NO-LABEL
     Btn_Browse AT ROW 11.57 COL 58
     fiContainer AT ROW 11.62 COL 9.8 COLON-ALIGNED
     dataHandles AT ROW 12.67 COL 1 NO-LABEL
     dataNames AT ROW 12.67 COL 1 NO-LABEL
     "Mode:" VIEW-AS TEXT
          SIZE 6 BY 1 AT ROW 10.52 COL 10.2 RIGHT-ALIGNED
     "Object Name:" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 1.48 COL 1
     "Container:" VIEW-AS TEXT
          SIZE 10 BY .95 AT ROW 11.71 COL 1.4
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
         HEIGHT             = 15
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
       FRAME F-Main:HEIGHT           = 15
       FRAME F-Main:WIDTH            = 72.

ASSIGN 
       Btn_MoveDown:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       Btn_MoveUp:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON Btn_Remove IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR SELECTION-LIST dataHandles IN FRAME F-Main
   NO-DISPLAY                                                           */
ASSIGN 
       dataHandles:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR SELECTION-LIST dataNames IN FRAME F-Main
   NO-DISPLAY                                                           */
ASSIGN 
       dataNames:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN fiObjectName IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR TEXT-LITERAL "Mode:"
          SIZE 6 BY 1 AT ROW 10.52 COL 10.2 RIGHT-ALIGNED               */

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

&Scoped-define SELF-NAME Btn_Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Add sObject
ON CHOOSE OF Btn_Add IN FRAME F-Main /* Add... */
DO:
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProc     AS HANDLE     NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE cFileName MUST-EXIST
    TITLE "Select Data Source".
  
  IF cFileName <> "" THEN DO:
    RUN adecomm/_relname.p (cFileName, "must-exist":U, OUTPUT cRelName).
    RUN runDataObject (cFileName, cRelName, "", OUTPUT hProc).
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Browse sObject
ON CHOOSE OF Btn_Browse IN FRAME F-Main /* Browse... */
DO:
  DEFINE VARIABLE cContainer AS CHARACTER  NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE cContainer MUST-EXIST
    TITLE "Choose File".
  
  IF cContainer <> "" THEN DO:
    RUN adecomm/_relname.p (cContainer, "must-exist":U, OUTPUT cContainer).
    fiContainer:SCREEN-VALUE = cContainer.
    APPLY "leave":U TO fiContainer.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_MoveDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_MoveDown sObject
ON CHOOSE OF Btn_MoveDown IN FRAME F-Main /* Move Down */
DO:
  DEFINE VARIABLE iPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lReturn     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE newData     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE newObject   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE nextData    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE nextObject  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisData    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisObject  AS CHARACTER NO-UNDO.
    
  ASSIGN 
    thisObject = dataObjects:SCREEN-VALUE
    iPos       = dataObjects:LOOKUP(dataObjects:SCREEN-VALUE).
  IF thisObject = "" OR iPos = dataObjects:NUM-ITEMS THEN 
    RETURN.  /* no item or last item */
  
  ASSIGN
    /* adjust object list */
    nextObject = dataObjects:ENTRY(iPos + 1)
    newObject  = thisObject
    lReturn    = dataObjects:REPLACE(newObject, nextObject)  /* next up */
    lReturn    = dataObjects:REPLACE(nextObject, thisObject) /* this down */
  
    /* adjust handle list */
    nextData   = dataHandles:ENTRY(iPos + 1)
    newData    = dataHandles:ENTRY(iPos)
    lReturn    = dataHandles:REPLACE(newData, nextData)  /* next up */
    lReturn    = dataHandles:REPLACE(nextData, thisData) /* this down */
  
    /* adjust object name list */
    nextData   = dataNames:ENTRY(iPos + 1)
    newData    = dataNames:ENTRY(iPos)
    lReturn    = dataNames:REPLACE(newData, nextData)  /* next up */
    lReturn    = dataNames:REPLACE(nextData, thisData) /* this down */
    .
  
  /* select the Object value. */
  dataObjects:SCREEN-VALUE = thisObject.
  
  PUBLISH "objectChange":U (dataObjects:LIST-ITEMS,
                            dataHandles:LIST-ITEMS,
                            dataNames:LIST-ITEMS,
                            ghSmartB2B).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_MoveUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_MoveUp sObject
ON CHOOSE OF Btn_MoveUp IN FRAME F-Main /* Move Up */
DO:
  DEFINE VARIABLE ipos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lReturn     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE newData     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE newObject   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE prevData    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE prevObject  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisData    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisObject  AS CHARACTER NO-UNDO.
    
  ASSIGN 
    thisObject = dataObjects:SCREEN-VALUE
    ipos       = dataObjects:LOOKUP(dataObjects:SCREEN-VALUE).
  IF thisObject = "" OR iPos = 1 THEN 
    RETURN.  /* no item or first item */
  
  ASSIGN
    /* adjust object list */
    prevObject = dataObjects:ENTRY(iPos - 1)
    newObject  = thisObject
    lReturn    = dataObjects:REPLACE(prevObject, thisObject) /* this up */
    lReturn    = dataObjects:REPLACE(newObject, prevObject)  /* prev down */
    
    /* adjust handle list */
    prevData   = dataHandles:ENTRY(iPos - 1)
    newData    = dataHandles:ENTRY(iPos)
    lReturn    = dataHandles:REPLACE(prevData, thisData) /* this up */
    lReturn    = dataHandles:REPLACE(newData, prevData)  /* prev down */
    
    /* adjust object name list */
    prevData   = dataNames:ENTRY(iPos - 1)
    newData    = dataNames:ENTRY(iPos)
    lReturn    = dataNames:REPLACE(prevData, thisData) /* this up */
    lReturn    = dataNames:REPLACE(newData, prevData)  /* prev down */
    .
  /* select the Object value. */
  dataObjects:SCREEN-VALUE = thisObject.
  
  PUBLISH "objectChange":U (dataObjects:LIST-ITEMS,
                            dataHandles:LIST-ITEMS,
                            dataNames:LIST-ITEMS,
                            ghSmartB2B).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Remove sObject
ON CHOOSE OF Btn_Remove IN FRAME F-Main /* Remove */
DO:
  DEFINE VARIABLE cName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProc    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPos     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lReturn  AS LOGICAL    NO-UNDO.
  
  IF dataObjects:SCREEN-VALUE <> ? THEN DO:
    ASSIGN
      iPos                     = dataObjects:LOOKUP(dataObjects:SCREEN-VALUE)
      hProc                    = WIDGET-HANDLE(dataHandles:ENTRY(iPos))
      cName                    = dataNames:ENTRY(iPos)
      
      lReturn                  = dataObjects:DELETE(iPos)
      lReturn                  = dataHandles:DELETE(iPos)
      lReturn                  = dataNames:DELETE(iPos).
      
    IF VALID-HANDLE(hProc) THEN DO:
      cType = DYNAMIC-FUNCTION("getObjectType":U IN hProc).
      IF cType = "SmartB2BObject":U THEN
        ASSIGN
          gcSmartB2B = ""
          ghSmartB2B = ?.
      DELETE PROCEDURE hProc.
    END.
      
    /* new selected object */
    IF dataObjects:NUM-ITEMS > 0 THEN DO:
      ASSIGN
        iPos                     = MAXIMUM(1, iPos - 1)
        dataObjects:SCREEN-VALUE = dataObjects:ENTRY(iPos).
    
      APPLY "value-changed":U TO dataObjects.
    END.
    ELSE
      ASSIGN
        SELF:SENSITIVE            = FALSE
        fiObjectName:SCREEN-VALUE = "".
    
    PUBLISH "objectChange":U (dataObjects:LIST-ITEMS,
                              dataHandles:LIST-ITEMS,
                              dataNames:LIST-ITEMS,
                              ghSmartB2B).
    PUBLISH "setSmartB2B":U  (gcSmartB2B).
    
    /* Delete mappings to this object */
    PUBLISH "nameChange":U   (cName, ?, TRUE).
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cpMode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cpMode sObject
ON VALUE-CHANGED OF cpMode IN FRAME F-Main
DO:
  PUBLISH "modeChange":U (SELF:SCREEN-VALUE).
  
  IF cpMode:SCREEN-VALUE = "consumer":U THEN ASSIGN 
    fiContainer:SENSITIVE = TRUE
    Btn_Browse:SENSITIVE  = TRUE.
  ELSE ASSIGN 
    fiContainer:SENSITIVE = FALSE
    Btn_Browse:SENSITIVE  = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dataObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dataObjects sObject
ON VALUE-CHANGED OF dataObjects IN FRAME F-Main
DO:
  DEFINE VARIABLE hObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      iPos         = dataObjects:LOOKUP(dataObjects:SCREEN-VALUE)
      hObject      = WIDGET-HANDLE(dataHandles:ENTRY(iPos))
      fiObjectName:SCREEN-VALUE = dataNames:ENTRY(iPos)
      gcOldObject  = SELF:SCREEN-VALUE.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiContainer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiContainer sObject
ON LEAVE OF fiContainer IN FRAME F-Main /* Container */
DO:
  DEFINE VARIABLE cByte      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainer AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReturn    AS LOGICAL    NO-UNDO.
  
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    cByte = getUnSafe(SELF:SCREEN-VALUE).
    IF cByte = ? THEN DO:
      RUN adecomm/_relname.p (SELF:SCREEN-VALUE, "must-exist":U, 
                              OUTPUT cContainer).
      IF cContainer = ? THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT lReturn, "error":U, "ok":U,
          SUBSTITUTE("Container was not found in PROPATH.^Please enter a new name or move file into a PROPATH directory.")).
        APPLY "entry":U TO SELF.
        RETURN NO-APPLY.
      END.
      IF fiContainer <> cContainer THEN
        PUBLISH "isDirty":U.
        
      ASSIGN
        SELF:SCREEN-VALUE = cContainer
        fiContainer       = cContainer.
    END.
    ELSE DO:
      MESSAGE 
        "Container contains at least one invalid character:" cByte SKIP
        "Please enter a new name."
        VIEW-AS ALERT-BOX ERROR.
      APPLY "entry":U TO SELF.
      RETURN NO-APPLY.
    END.
  END.
  ELSE IF SELF:SCREEN-VALUE <> fiContainer THEN
    PUBLISH "isDirty":U.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectName sObject
ON LEAVE OF fiObjectName IN FRAME F-Main
DO:
  DEFINE VARIABLE cByte    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lChange  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReturn  AS LOGICAL    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* check for non-blank */
    IF SELF:SCREEN-VALUE = "" AND dataObjects:NUM-ITEMS > 0 THEN DO:
      MESSAGE 
        "Object Name must be non-blank."
        VIEW-AS ALERT-BOX ERROR.
      APPLY "entry":U TO SELF.
      RETURN.
    END.
    
    /* check for bad characters */
    cByte = getUnSafe(SELF:SCREEN-VALUE).
    IF cByte <> ? THEN DO:
      MESSAGE 
        "Object Name contains at least one invalid character:" cByte SKIP
        "Please enter a new name."
        VIEW-AS ALERT-BOX ERROR.
      APPLY "entry":U TO SELF.
      RETURN.
    END.
    
    /* iPos = dataObjects:LOOKUP(dataObjects:SCREEN-VALUE).
       If user updates Object Name fill-in and then immediately selects a 
       different object in the selection list, the new object name was being
       assigned to the new selection list value, not the previous one. 
       gcOldObject is set in VALUE-CHANGED trigger for dataObjects list. */
    iPos = dataObjects:LOOKUP(gcOldObject).
      
    /* check for uniqueness */
    DO ix = 1 TO dataNames:NUM-ITEMS:
      IF ix = iPos THEN NEXT.
      IF dataNames:ENTRY(ix) = SELF:SCREEN-VALUE THEN DO:
        MESSAGE 
          "Object Name must be unique."
          VIEW-AS ALERT-BOX ERROR.
        APPLY "entry":U TO SELF.
        RETURN.
      END.
    END.
    
    ASSIGN  
      cList    = dataNames:LIST-ITEMS
      cOldName = ENTRY(iPos, cList)
      lChange  = (cOldName <> SELF:SCREEN-VALUE).
      
    IF lChange THEN DO:
      ASSIGN
        dataNames:LIST-ITEMS  = ""
        ENTRY(iPos, cList)    = SELF:SCREEN-VALUE
        dataNames:LIST-ITEMS  = cList.
      
      PUBLISH "objectChange":U (dataObjects:LIST-ITEMS, 
                                dataHandles:LIST-ITEMS,
                                dataNames:LIST-ITEMS,
                                ghSmartB2B).
                              
      PUBLISH "nameChange":U (cOldName, SELF:SCREEN-VALUE, TRUE).
    END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

btn_remove:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT      = pHeight.
  ELSE
  /* window height shrinking */
  IF pHeight <> ? AND pHeight < old_hit THEN
    ASSIGN
      FRAME {&FRAME-NAME}:HEIGHT                = pHeight
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT        = pHeight.
  
  /* window width growing */
  IF pWidth <> ? AND pWidth > old_wid THEN
    ASSIGN
      FRAME {&FRAME-NAME}:WIDTH                 = pWidth
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH         = pWidth.
  ELSE
  /* window width shrinking */
  IF pWidth <> ? AND SELF:WIDTH-PIXELS < old_wid THEN
    ASSIGN
      FRAME {&FRAME-NAME}:WIDTH                 = pWidth
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH         = pWidth.
  
  ASSIGN
    old_hit = pHeight WHEN pHeight <> ?
    old_wid = pWidth  WHEN pWidth  <> ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runDataObject sObject 
PROCEDURE runDataObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pFileName AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pRelName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pObject   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pProc     AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cBase   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefix AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProc   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLookup AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    iLookup = dataObjects:LOOKUP(pRelName).
    IF iLookup = 0 THEN DO:
      DO WHILE TRUE
         ON ERROR UNDO, RETRY
         ON QUIT  UNDO, RETRY  
         ON STOP  UNDO, RETRY:
        IF RETRY THEN DO:
          RUN runError (pFileName, OUTPUT cReturn).
          IF cReturn = "_error":U THEN RETURN.
        END.
        
        RUN VALUE(pFileName) PERSISTENT SET hProc NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          RUN runError (pFileName, OUTPUT cReturn).
          IF cReturn = "_error":U THEN RETURN.
        END.
        LEAVE.
      END.
      IF NOT VALID-HANDLE(hProc) THEN RETURN.
      
      cType = DYNAMIC-FUNCTION("getObjectType":U IN hProc) NO-ERROR.
      CASE ctype:
        WHEN "SmartB2BObject":U THEN DO:
          /* Check for any contained SmartB2B object */
          IF NOT VALID-HANDLE(ghSmartB2B) THEN DO:
            ASSIGN
              ghSmartB2B = hProc
              gcSmartB2B = pRelName.
            PUBLISH "setSmartB2B":U (pRelName).
          END.
          ELSE DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT lReturn, "warning":U, "ok":U,
              SUBSTITUTE("Only one SmartB2B object can run at a time.^Remove &1 before adding &2.",
              ghSmartB2B:FILE-NAME, hProc:FILE-NAME)).
            DELETE PROCEDURE hProc.
            RETURN ERROR.
          END.
        END.
        WHEN "SmartBusinessObject":U THEN
          /* Start the SBO's SDOs */
          RUN createObjects IN hProc.
      END CASE.
        
      dataObjects:ADD-LAST(pRelName).
      dataHandles:ADD-LAST(STRING(hProc)).
      
      /* Add the object name to the selection list.  When reopening a mapped
         file, pObject will be non-blank.  We use it to override the object's 
         internal name. */
      IF pObject = "" THEN DO:
        cObject = DYNAMIC-FUNCTION("getObjectName":U IN hProc) NO-ERROR.
        IF cObject = ? THEN DO:
          RUN adecomm/_osprefx.p (pRelName, OUTPUT cPrefix, OUTPUT cBase).
          cObject = SUBSTRING(cBase, 1, INDEX(cBase,".":U) - 1, 
                                      "CHARACTER":U).
        END.
      END.
      ELSE 
        cObject = pObject.
        
      dataNames:ADD-LAST(cObject).
      
      ASSIGN
        fiObjectName:SCREEN-VALUE = cObject
        dataObjects:SCREEN-VALUE  = dataObjects:ENTRY(dataObjects:NUM-ITEMS)
        gcOldObject               = dataObjects:SCREEN-VALUE
        btn_remove:SENSITIVE      = TRUE
        pProc                     = hProc.
  
      PUBLISH "objectChange":U (dataObjects:LIST-ITEMS, 
                                dataHandles:LIST-ITEMS,
                                dataNames:LIST-ITEMS,
                                ghSmartB2B).
    END.
    ELSE
      pProc = WIDGET-HANDLE(dataHandles:ENTRY(iLookup)).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runError sObject 
PROCEDURE runError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pFile   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pChoice AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cDBList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBLName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReturn  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ix       AS INTEGER    NO-UNDO.

  /* Check for disconnected databases */
  DO ix = 1 TO ERROR-STATUS:NUM-MESSAGES:
    IF ERROR-STATUS:GET-NUMBER(ix) = 1006 THEN DO:
      cDBName = ENTRY(3, ERROR-STATUS:GET-MESSAGE(ix), " ":U).
      IF NOT CAN-DO(cDBList, cDBName) THEN
        cDBList = cDBLIst + (IF cDBList = "" THEN "" ELSE ",":U) + cDBName.
    END.
  END.
  
  IF cDBList <> "" THEN
  DO ix = 1 TO NUM-ENTRIES(cDBList):
    ASSIGN
      cDBName = ENTRY(ix, cDBList)
      pChoice = "_connect":U.
    
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lReturn, "question":U, "yes-no":U,
      SUBSTITUTE("The database &1 was used by &2 when it was compiled.^^Would you like to connect to this database?",
        cDBName, pFile)).
    IF lReturn THEN DO:
      ASSIGN
        cDBLName = ?
        cDBType  = "PROGRESS":U.
      RUN adecomm/_dbconn.p (INPUT-OUTPUT  cDBName,
                             INPUT-OUTPUT  cDBLName,
                             INPUT-OUTPUT  cDBType).
    END.
    ELSE DO:
      pChoice = "_cancel":U.
      LEAVE.
    END.
  END.
  
  IF cDBList = "" OR pChoice = "_cancel":U THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lReturn, "warning":U, "ok":U,
      SUBSTITUTE("Error attempting to run data object &1 persistently.^^Any mappings to this object have been deleted.",
      pFile)).
    pChoice = "_error":U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainer sObject 
FUNCTION getContainer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN fiContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCPMode sObject 
FUNCTION getCPMode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN cpMode:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectHandles sObject 
FUNCTION getObjectHandles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN dataHandles:LIST-ITEMS IN FRAME {&FRAME-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUnSafe sObject 
FUNCTION getUnSafe RETURNS CHARACTER
  ( INPUT pValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cByte   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUnsafe AS CHARACTER  NO-UNDO INITIAL " ,~"":U.
  DEFINE VARIABLE ix      AS INTEGER    NO-UNDO.
  
  DO ix = 1 TO LENGTH(pValue, "character":U):
    cByte = SUBSTRING(pValue, ix, 1, "character":U).
    IF INDEX(cUnsafe, cByte) > 0 THEN 
      RETURN cByte.
  END.
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainer sObject 
FUNCTION setContainer RETURNS LOGICAL
  ( INPUT pContainer AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      fiContainer              = pContainer
      fiContainer:SCREEN-VALUE = pContainer.
  END.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCPMode sObject 
FUNCTION setCPMode RETURNS LOGICAL
  ( INPUT pMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  cpMode:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pMode.
  
  APPLY "value-changed":U TO cpMode.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

