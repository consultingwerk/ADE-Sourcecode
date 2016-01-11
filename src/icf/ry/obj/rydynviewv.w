&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This is the Astra 2 Dynamic Viewer. No new instances of this should be created. Use the Astra 2 Wizard Menu Controller to create instances using Repository Data."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" vTableWin _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
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
/*---------------------------------------------------------------------------------
  File: rydynviewv.w

  Description:  ICF Dynamic SmartDataViewer

  Purpose:      ICF Dynamic SmartDataViewer

  Parameters:

  History:
  --------
  (v:010000)    Task:   101000006   UserRef:    
                Date:   07/31/2001  Author:     Peter Judge

  Update Notes: Move for customisation

  (v:010001)    Task:   101000006   UserRef:    
                Date:   07/31/2001  Author:     Peter Judge

  Update Notes: NEW/ Dynamic Viewer

  (v:010002)    Task:   101000028   UserRef:    
                Date:   09/11/2001  Author:     Peter Judge

  Update Notes: - change NoLookups to NoPopups
                - change TabOrder to use FieldOrder
                - remove EnabledField attribute. Will use Enabled instead
                - change DataSourceName to DataSource

  (v:010003)    Task:           0   UserRef:    
                Date:   02/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3627 - Toolbar with tableiotype ‘UPDATE’ does not sentisize correctly
                Always ensure that all fields on the viewer are disabled on initialization.

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamicviewer YES

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* This pre-processor is necessary to exclude certain code from firing in viewer.i,
 * even though there is a DynamicObject property.                                  */
&GLOBAL-DEFINE ICF-DYNAMIC-VIEWER YES

{ ry/app/rycsofetch.i }
{ ry/app/rydynviewi.i }
{ launch.i &define-only = YES }

DEFINE VARIABLE gcUIBMode                   AS CHARACTER            NO-UNDO.
DEFINE VARIABLE gcLogicalObjectName         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE gcDefaultAttributes         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE gdViewerInstanceObj         AS DECIMAL              NO-UNDO.
DEFINE VARIABLE ghContainerSource           AS HANDLE               NO-UNDO.

/* These are the default attributes which are stored in the ttWidget temp-table. These
 * attributes must not be duplicated in any of the widget type temp-tables.
*/
ASSIGN gcDefaultAttributes = "LABEL,FORMAT,ROW,COLUMN,X,Y,PRIVATE-DATA,FONT,TOOLTIP,SENSITIVE,VISIBLE,HIDDEN,":U
                           + "HEIGHT-PIXELS,HEIGHT-CHARS,WIDTH-PIXELS,WIDTH-CHARS,DATA-TYPE,FRAME,NAME,SIDE-LABEL-HANDLE,":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildViewerAttributes vTableWin 
FUNCTION buildViewerAttributes RETURNS LOGICAL
    ( /**/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildWidgetTable vTableWin 
FUNCTION buildWidgetTable RETURNS LOGICAL
    ( INPUT pdViewerInstanceObj         AS DECIMAL      )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearWidgetTempTable vTableWin 
FUNCTION clearWidgetTempTable RETURNS LOGICAL
    ( INPUT phTempTable         AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createEvents vTableWin 
FUNCTION createEvents RETURNS LOGICAL
    ( INPUT pdObjectInstanceObj     AS DECIMAL,
      INPUT phField                 AS HANDLE       )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyWidgets vTableWin 
FUNCTION destroyWidgets RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeValue vTableWin 
FUNCTION getAttributeValue RETURNS CHARACTER
    ( INPUT pdObjectInstanceObj     AS DECIMAL,
      INPUT pcAttributeLabel        AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getExtraAttributes vTableWin 
FUNCTION getExtraAttributes RETURNS LOGICAL
    ( INPUT phTempTable             AS HANDLE,
      INPUT pdObjectInstanceObj     AS DECIMAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLocalAttributes vTableWin 
FUNCTION getLocalAttributes RETURNS CHARACTER
    ( INPUT pdObjectInstanceObj         AS DECIMAL      )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExtraAttributes vTableWin 
FUNCTION setExtraAttributes RETURNS LOGICAL
    ( INPUT pdObjectInstanceObj     AS DECIMAL,
      INPUT phField                 AS HANDLE,
      INPUT phTempTable             AS HANDLE       )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 82.8 BY 8.71.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 8.71
         WIDTH              = 82.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildWidgetTempTable vTableWin 
PROCEDURE buildWidgetTempTable :
/*------------------------------------------------------------------------------
  Purpose:     Builds temp-tables of attributes for specified widgets types.
  Parameters:  pcWidgetType
               phTable
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcWidgetType  AS CHARACTER            NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER phTable       AS HANDLE               NO-UNDO.
    
    DEFINE VARIABLE hWidget             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE iFillInLoop         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iAttributeLoop      AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cWidgetAttributes   AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cAttribute          AS CHARACTER                    NO-UNDO.

    CREATE VALUE(pcWidgetType) hWidget NO-ERROR.

    IF NOT ERROR-STATUS:ERROR THEN
    DO:
        ASSIGN cWidgetAttributes = LIST-SET-ATTRS(hWidget).

        IF NOT VALID-HANDLE(phTable) THEN
            CREATE TEMP-TABLE phTable.

        phTable:CLEAR().
        /* This field allows us to specify the instances of an object. */
        phTable:ADD-NEW-FIELD("tObjectInstanceObj":U, "DECIMAL":U).

        DO iAttributeLoop = 1 TO NUM-ENTRIES(cWidgetAttributes):
            ASSIGN cAttribute = ENTRY(iAttributeLoop, cWidgetAttributes).
            IF LOOKUP(cAttribute, gcDefaultAttributes) = 0 THEN
                /* ADD-NEW-FIELD: field-name-exp, datatype-exp, extent-exp, format-exp, initial-exp */
                phTable:ADD-NEW-FIELD(cAttribute, "CHARACTER":U, 0, ?, ?).
        END.    /* loop through attributes */

        phTable:ADD-NEW-INDEX("idxObjectInstance":U, NO, YES, NO).
        phTable:ADD-INDEX-FIELD("idxObjectInstance":U, "tObjectInstanceObj":U).

        phTable:TEMP-TABLE-PREPARE("tt_":U + REPLACE(pcWidgetType, "-":U, "_":U)).

        DELETE WIDGET hWidget.
    END.    /* no error */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects vTableWin 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeValue             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLabel                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hDataFieldProcedure         AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hDataFieldFrame             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPreviousWidget             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cContainerObjectName        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dFrameWidth                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dFrameHeight                AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dWidgetWidth                AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dWidgetHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dColumnPosition             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dRowPosition                AS DECIMAL              NO-UNDO.   
    DEFINE VARIABLE dFrameMinHeight             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dFrameMinWidth              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dLabelWidth                 AS DECIMAL              NO-UNDO.     
    DEFINE VARIABLE cButtonPressed              AS CHARACTER            NO-UNDO.
    
    /* Before we start - make the frame virtually big */
    ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE           = TRUE
           FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH-CHARS  - 1
           FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT-CHARS - 1
           FRAME {&FRAME-NAME}:WIDTH-CHARS          = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS 
           FRAME {&FRAME-NAME}:HEIGHT-CHARS         = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS
           FRAME {&FRAME-NAME}:SCROLLABLE           = FALSE
           
           /* Design time considerations. These parameters allow us to change the size of this frame.
            * This code is not is use yet.                                                            */
           &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN           
           FRAME {&FRAME-NAME}:SELECTABLE           = TRUE
           FRAME {&FRAME-NAME}:RESIZABLE            = TRUE
           FRAME {&FRAME-NAME}:GRID-VISIBLE         = TRUE
           FRAME {&FRAME-NAME}:GRID-SNAP            = TRUE
           
           /* These values should be taken from the .INI  */
           FRAME {&FRAME-NAME}:GRID-UNIT-HEIGHT-CHARS = 0.1
           FRAME {&FRAME-NAME}:GRID-UNIT-WIDTH-CHARS  = 0.33
           FRAME {&FRAME-NAME}:GRID-FACTOR-HORIZONTAL = 5
           FRAME {&FRAME-NAME}:GRID-FACTOR-VERTICAL   = 5
           &ENDIF
           .
    FOR EACH ttWidget
             BY ttWidget.tTabOrder:
        /* Clear all handle variables. */
        ASSIGN hField              = ?
               hLabel              = ?
               hDataFieldProcedure = ?
               hDataFieldFrame     = ?
               .
        IF ttWidget.tWidgetType = "SmartDataField":U THEN
        DO:
            ASSIGN cAttributeValue = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                      INPUT ttWidget.tObjectInstanceObj,
                                                      INPUT "MasterFile":U).
            /* Build the SDF */
            RUN constructObject ( INPUT  cAttributeValue,
                                  INPUT  FRAME {&FRAME-NAME}:HANDLE,
                                  INPUT  DYNAMIC-FUNCTION("getLocalAttributes":U, INPUT ttWidget.tObjectInstanceObj),
                                  OUTPUT hDataFieldProcedure ).
            RUN repositionObject IN hDataFieldProcedure ( ttWidget.tRow,     ttWidget.tColumn ) NO-ERROR.
            RUN resizeObject     IN hDataFieldProcedure ( ttWidget.tHeight , ttWidget.tWidth ) NO-ERROR.

            ASSIGN hDataFieldFrame        = DYNAMIC-FUNCTION("getContainerHandle" IN hDataFieldProcedure)
                   dWidgetWidth           = DYNAMIC-FUNCTION("getWidth" IN hDataFieldProcedure)
                   dWidgetHeight          = DYNAMIC-FUNCTION("getHeight" IN hDataFieldProcedure)
                   dRowPosition           = ttWidget.tRow
                   dColumnPosition        = ttWidget.tColumn
                   ttWidget.tFrameHandle  = hDataFieldFrame
                   ttWidget.tWidgetHandle = hDataFieldProcedure
                   ttWidget.tVisible      = YES
                   .
            /* Start the Custom Super Procedure if available. */
            IF ttWidget.tCustomSuperProc NE "":U AND ttWidget.tCustomSuperProc NE ? THEN
            DO:
                { launch.i
                    &PLIP  = ttWidget.tCustomSuperProc
                    &IProc = ''
                    &OnApp = 'NO'
                }
                IF VALID-HANDLE(hPlip) THEN
                    hDataFieldProcedure:ADD-SUPER-PROCEDURE(hPlip, SEARCH-TARGET).
            END.    /* has a custom super procedure. */          
        END.    /* SDF */
        ELSE
        DO:
            CREATE VALUE(ttWidget.tWidgetType) hField
                ASSIGN FRAME = FRAME {&FRAME-NAME}:HANDLE.

            IF CAN-SET(hField, "DATA-TYPE":U)    THEN ASSIGN hField:DATA-TYPE    = ttWidget.tDataType.
            IF CAN-SET(hField, "FORMAT":U)       THEN ASSIGN hField:FORMAT       = ttWidget.tFormat.
            IF CAN-SET(hField, "PRIVATE-DATA":U) THEN ASSIGN hField:PRIVATE-DATA = ttWidget.tPrivateData.
            IF CAN-SET(hField, "NAME":U)         THEN ASSIGN hField:NAME         = ttWidget.tWidgetName.
            IF CAN-SET(hField, "TOOLTIP":U)      THEN ASSIGN hField:TOOLTIP      = ttWidget.tTooltip.

            /* The layout positions have been determined in CHARS. */
            IF CAN-SET(hField, "ROW":U)    THEN ASSIGN hField:ROW    = ttWidget.tRow.
            IF CAN-SET(hField, "COLUMN":U) THEN ASSIGN hField:COLUMN = ttWidget.tColumn.

            /* The size has already been calculated in CHARS */
            IF CAN-SET(hField, "HEIGHT-CHARS":U) THEN ASSIGN hField:HEIGHT-CHARS = ttWidget.tHeight.
            IF CAN-SET(hField, "WIDTH-CHARS":U)  THEN ASSIGN hField:WIDTH-CHARS  = ttWidget.tWidth.

            /* Table Name */
            IF CAN-SET(hField, "PRIVATE-DATA":U) AND
               ttWidget.tTableName       NE "":U THEN
                ASSIGN hField:PRIVATE-DATA = ("TableName,":U + ttWidget.tTableName + ",":U)
                                           + ( IF hField:PRIVATE-DATA EQ ? THEN "":U ELSE hField:PRIVATE-DATA).
            
            /* Font */
            IF CAN-SET(hField, "FONT":U) AND
               ttWidget.tFont       NE 0 THEN
                ASSIGN hField:FONT = ttWidget.tFont.

            /* Create a placeholder for this widget. */
            ASSIGN ttWidget.tWidgetHandle = hField
                   ttWidget.tFrameHandle  = hField:FRAME
                   .
            /** Create a label for this widget.
             *  ----------------------------------------------------------------------- **/
            IF ttWidget.tLabel NE ? THEN
            DO:
                /* Check whether the field has a SIDE-LABEL-HANDLE. This will be the case for most
                 * widgets, but certain widget types (buttons in particular) do not use this mechanism
                 * for displaying their labels. These will be handled separately in a following section */
                IF CAN-SET(hField, "SIDE-LABEL-HANDLE":U) THEN
                DO:
                    CREATE TEXT hLabel
                        ASSIGN FRAME        = FRAME {&FRAME-NAME}:HANDLE
                               FORMAT       = "x(" + STRING(LENGTH(ttWidget.tLabel, "CHARACTER":U) + 1) + ")":U
                               HEIGHT-CHARS = 1
                               VISIBLE      = NO
                               NAME         = "LABEL_":U + REPLACE(ttWidget.tWidgetName, ".":U, "_":U)
                               TAB-STOP     = NO            /* Labels should never be in the tab order */
                               ROW          = hField:ROW
                               SCREEN-VALUE = ttWidget.tLabel
                               .
                    IF ttWidget.tLabelFont NE ? THEN
                        ASSIGN hLabel:FONT = ttWidget.tLabelFont.
                    IF ttWidget.tLabelFgColor NE ? THEN
                        ASSIGN hLabel:FGCOLOR = ttWidget.tLabelFgColor.
                    IF ttWidget.tLabelBgColor NE ? THEN
                        ASSIGN hLabel:BGCOLOR = ttWidget.tLabelBgColor.
    
                    /** Position the label. We use pixels here since we can X and WIDTH-PIXELS
                     *  are denominated in the same units, unlike COLUMN and WIDTH-CHARS.
                     *  ----------------------------------------------------------------------- **/
                    IF ( ttWidget.tLabelWidth - 1 ) GT hField:X THEN
                        ASSIGN dLabelWidth = hField:X - 1.
                    ELSE
                        ASSIGN dLabelWidth = ttWidget.tLabelWidth - 1.
    
                    IF dLabelWidth LE 0 THEN
                        ASSIGN dLabelWidth = 0.
    
                    /* If the label's width is zero, don't create a label. */
                    IF dLabelWidth EQ 0 THEN
                        DELETE WIDGET hLabel.
                    ELSE
                        ASSIGN hLabel:WIDTH-PIXELS = dLabelWidth
                               hLabel:X            = hField:X - dLabelWidth
                               .
                    /* Associate the label and field widget. */
                    IF VALID-HANDLE(hLabel) THEN
                        ASSIGN hField:SIDE-LABEL-HANDLE = hLabel.
                END.    /* CAN-SET the SIDE-LABEL-HANDLE */
                ELSE
                /* Labels which do not support the SIDE-LABEL-HANDLE principle are set here. */
                IF CAN-SET(hField, "LABEL":U) THEN
                    ASSIGN hField:LABEL = ttWidget.tLabel.
            END.    /* there is a label. */

            /* Before visualising, add any other attributes */
            FIND ttWidgetTable WHERE
                 ttWidgetTable.tWidgetType = ttWidget.tWidgetType
                 NO-ERROR.
            IF AVAILABLE ttWidgetTable                  AND
               VALID-HANDLE(ttWidgetTable.tTableHandle) THEN
                DYNAMIC-FUNCTION("setExtraAttributes":U,
                                 INPUT ttWidget.tObjectInstanceObj,
                                 INPUT hField,
                                 INPUT ttWidgetTable.tTableHandle   ).

            IF CAN-SET(hField, "VISIBLE":U)   THEN ASSIGN hField:VISIBLE = ttWidget.tVisible.
            /* Set the initial SENSITIVE state of the field to FALSE and let the toolbar
               take care of enabling and disabling the fields - this was done to fix issue #3627 */
            IF CAN-SET(hField, "SENSITIVE":U) THEN ASSIGN hField:SENSITIVE = FALSE. /*ttWidget.tEnabled.*/

            ASSIGN dRowPosition             = hField:ROW
                   dColumnPosition          = hField:COLUMN
                   dWidgetWidth             = hField:WIDTH-CHARS
                   dWidgetHeight            = hField:HEIGHT-CHARS
                   .
            /* UI Events. */
            DYNAMIC-FUNCTION("createEvents":U, INPUT ttWidget.tObjectInstanceObj, INPUT hField).

            /* When in design mode ... */
            &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
            IF CAN-SET(hField, "VISIBLE":U)    THEN ASSIGN hField:VISIBLE    = TRUE.
            IF CAN-SET(hField, "SENSITIVE":U)  THEN ASSIGN hField:SENSITIVE  = TRUE.
            IF CAN-SET(hField, "MOVABLE":U)    THEN ASSIGN hField:MOVABLE    = TRUE.
            IF CAN-SET(hField, "RESIZABLE":U)  THEN ASSIGN hField:RESIZABLE  = TRUE.
            IF CAN-SET(hField, "SELECTABLE":U) THEN ASSIGN hField:SELECTABLE = TRUE.
            &ENDIF
        END.    /* non-SDF */

        IF ttWidget.tWidgetType = "SmartDataField"               OR
           ( CAN-SET(ttWidget.tWidgetHandle, "TAB-STOP":U) AND
             ttWidget.tWidgetHandle:TAB-STOP                   ) THEN
        DO:
            ASSIGN hPreviousWidget = ttWidget.tWidgetHandle.
            IF ttWidget.tTabOrder                         NE 1 AND
               CAN-QUERY(ttWidget.tWidgetHandle, "ADM-DATA":U) AND
               CAN-QUERY(hPreviousWidget, "ADM-DATA":U)        THEN
                RUN adjustTabOrder ( INPUT ttWidget.tWidgetHandle,
                                     INPUT hPreviousWidget,
                                     INPUT "AFTER":U                     ).
        END.    /* TAB-STOP is true */

        /* Determine the size of the frame. */
        ASSIGN dFrameWidth  = MAX(dFrameWidth, dColumnPosition + dWidgetWidth )
               dFrameHeight = MAX(dFrameHeight, dRowPosition + dWidgetHeight)
               .
    END.    /* each widget */

    /* All widgets are now complete. We set the frame to fit the widgets. */
    ASSIGN dFrameWidth                      = MAX(dFrameWidth, 10)
           FRAME {&FRAME-NAME}:WIDTH-CHARS  = dFrameWidth
           FRAME {&FRAME-NAME}:HEIGHT-CHARS = dFrameHeight
           NO-ERROR.

    /* Finally the virtual size can be also reduced. */
    ASSIGN FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = FRAME {&FRAME-NAME}:WIDTH-CHARS 
           FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = FRAME {&FRAME-NAME}:HEIGHT-CHARS
           NO-ERROR.

    /* Set the MinWidth and MinHeight attributes.
     * Only perform these calculations when we are not in design mode.
     * In design mode we will save these values separately.           */
    &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN
    /* Double-check whether we are in a design mode or not. */
    IF gcUIBMode NE "Design":U THEN
    DO:
        {get MinHeight dFrameMinHeight}.
        {get MinWidth  dFrameMinWidth}.
    
        IF dFrameMinHeight NE dFrameHeight OR
           dFrameMinWidth  NE dFrameWidth  THEN
        DO:
            /* Inform the user that there's a problem. */
            RUN showMessages IN gshSessionManager (INPUT  "A sizing error has been detected and corrected."
                                                        + "~nPlease close and reopen this window to see this correction.",
                                                   INPUT  "WAR",                    /* error type */
                                                   INPUT  "&OK",                    /* button list */
                                                   INPUT  "&OK",                    /* default button */ 
                                                   INPUT  "&OK",                    /* cancel button */
                                                   INPUT  "Viewer Sizing Error",    /* error window title */
                                                   INPUT  YES,                      /* display if empty */ 
                                                   INPUT  ghContainerSource,         /* container handle */
                                                   OUTPUT cButtonPressed       ).   /* button pressed */
    
            /* Update the Frame MinWidth and Frame MinHeight */
            RUN ry/app/rycavfrhwp.p ON gshAstraAppServer ( INPUT gdViewerInstanceObj,
                                                           INPUT dFrameWidth,
                                                           INPUT dFrameHeight ) NO-ERROR.
    
            /* Clear the local cache. This is to ensure that the correct dimensions are read
             * from the repository the next time this viewer is instantiated.               */
            {get LogicalObjectName cContainerObjectName ghContainerSource}.
    
            RUN ClearObjectCache IN gshRepositoryManager ( INPUT cContainerObjectName ).
        END.    /* the stored size <> the frame size. */
    END.    /* not design mode */
    &ENDIF
             
    RUN SUPER.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DYNAMIC-FUNCTION("destroyWidgets":U).

    RUN SUPER.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cDisplayedFields            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEnabledFields              AS CHARACTER            NO-UNDO.    
    DEFINE VARIABLE cDisplayedObjects           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEnabledObjects             AS CHARACTER            NO-UNDO.

    /* Determine whether we're in design mode */
    ASSIGN gcUIBMode = DYNAMIC-FUNCTION("getUIBmode":U).

    /* Remove any widgets previously created in this instance */
    DYNAMIC-FUNCTION("destroyWidgets":U).

    /* Ask the RepositoryManager for the SmartObject Field and Widget definitions  */
    {get LogicalObjectName gcLogicalObjectName}.
    
    &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN
    /* Double-check whether we are in a design mode or not. */
    IF gcUIBMode NE "Design" THEN
    DO:
        /* We need to determine the object instance of the current viewer, in case there are 2 
         * instances of the same viewer on one window.                                         */
        {get ContainerSource ghContainerSource}.
        ASSIGN gdViewerInstanceObj = DYNAMIC-FUNCTION("getInstanceObjectId":U IN ghContainerSource,
                                                      INPUT TARGET-PROCEDURE) NO-ERROR.
    END.    /* not design mode */
    &ELSE    
    /* If in design mode, then we clear this obejct's cache, so we ensure that
     * the obejct only appears once in the cache.                             */
    RUN ClearObjectCache IN gshRepositoryManager ( INPUT gcLogicalObjectName ).
    &ENDIF
                     
    RUN getObjectAttributes IN gshRepositoryManager ( INPUT  gcLogicalObjectName,
                                                      OUTPUT TABLE tt_object_instance,
                                                      OUTPUT TABLE tt_page,
                                                      OUTPUT TABLE tt_page_instance,
                                                      OUTPUT TABLE tt_link,
                                                      OUTPUT TABLE ttAttributeValue,
                                                      OUTPUT TABLE ttUiEvent               ) NO-ERROR.

    /* Build the widget table */
    DYNAMIC-FUNCTION("buildWidgetTable":U, INPUT gdViewerInstanceObj).

    /* Build a table of attribute values for the Container */
    DYNAMIC-FUNCTION("buildViewerAttributes":U).

    FOR EACH ttWidget WHERE
             ttWidget.tWidgetType NE "SmartDataField":U
             BY ttWidget.tTabOrder:
        /** Build lists of the the fields to display and enable
         *  ----------------------------------------------------------------------- **/
        IF ttWidget.tDisplayField THEN
        DO:
            /* Not a RowObject/DB field */
            IF ttWidget.tTableName EQ "":U THEN
                ASSIGN cDisplayedObjects = cDisplayedObjects + (IF NUM-ENTRIES(cDisplayedObjects, " ":U) EQ 0 THEN "":U ELSE " ":U)
                                          + ttWidget.tWidgetName.
            ELSE
                ASSIGN cDisplayedFields = cDisplayedFields + (IF NUM-ENTRIES(cDisplayedFields, " ":U) EQ 0 THEN "":U ELSE " ":U)
                                         + (IF ttWidget.tTableName EQ "":U OR ttWidget.tTableName EQ ? THEN "":U ELSE ttWidget.tTableName + ".":U)
                                         + ttWidget.tWidgetName.
        END.    /* display field */

        IF ttWidget.tEnabled THEN
        DO:        
            /* Not a RowObject/DB field */
            IF ttWidget.tTableName EQ "":U THEN
                ASSIGN cEnabledObjects = cEnabledObjects + (IF NUM-ENTRIES(cEnabledObjects, " ":U) EQ 0 THEN "":U ELSE " ":U)
                                        + ttWidget.tWidgetName.
            ELSE
                ASSIGN cEnabledFields = cEnabledFields + (IF NUM-ENTRIES(cEnabledFields, " ":U) EQ 0 THEN "":U ELSE " ":U)
                                         + (IF ttWidget.tTableName EQ "":U OR ttWidget.tTableName EQ ? THEN "":U ELSE ttWidget.tTableName + ".":U)
                                         + ttWidget.tWidgetName.
        END.    /* enabled */
    END.    /* all non-SDF widgets */

    /* Override the standard VIEWER.I behaviour. */   
    RUN ViewerIncludeMainBlock ( INPUT cDisplayedFields,
                                 INPUT cEnabledFields,
                                 INPUT cDisplayedObjects,
                                 INPUT cEnabledObjects      ).

    RUN SUPER.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processEventProcedure vTableWin 
PROCEDURE processEventProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Procedure called when a UI event is fired. This procedure will
               process the request according to the relevant parameters.
  Parameters:  pcActionType     - RUN/PUBLISH
               pcEventAction    - 
               pcActionTarget   - SELF,CONTAINER,ANYWHERE, ManagerCode
               pcEventParameter - a parameter to pass into the event procedure.

  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcActionType         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcEventAction        AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcActionTarget       AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcEventParameter     AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hActionTarget       AS HANDLE                       NO-UNDO.

    CASE pcActionTarget:
        WHEN "SELF":U      THEN ASSIGN hActionTarget = TARGET-PROCEDURE.
        WHEN "CONTAINER":U THEN ASSIGN hActionTarget = DYNAMIC-FUNCTION("getContainerSource":U IN TARGET-PROCEDURE).
        WHEN "ANYWHERE":U  THEN ASSIGN hActionTarget = ?.
        /* Run on the AppServer. This is only valid for an action type of RUN. */
        WHEN "AS":U        THEN ASSIGN hActionTarget = gshAstraAppServer.
        /* Managers */
        WHEN "SM":U        THEN ASSIGN hActionTarget = gshSessionManager.
        WHEN "SEM":U       THEN ASSIGN hActionTarget = gshSecurityManager.
        WHEN "PM":U        THEN ASSIGN hActionTarget = gshProfileManager.
        WHEN "RM":U        THEN ASSIGN hActionTarget = gshRepositoryManager.
        WHEN "TM":U        THEN ASSIGN hActionTarget = gshTranslationManager.
        &IF "{&AstraGen}":U <> "":U &THEN
        /* These are MIP's Astra Managers. They are included because the variable
         * definitions are still included as part of the ICF                      */
        WHEN "FM":U        THEN ASSIGN hActionTarget = gshFinManager.
        WHEN "AM":U        THEN ASSIGN hActionTarget = gshAgnManager.
        &ENDIF
        WHEN "GM":U        THEN ASSIGN hActionTarget = gshGenManager.
        OTHERWISE               ASSIGN hActionTarget = ?.
    END CASE.   /* action target */

    IF pcActionType = "RUN":U      AND
       VALID-HANDLE(hActionTarget) THEN
    DO:
        IF pcEventParameter = "":U THEN
        DO:
            IF pcActionTarget EQ "AS":U THEN
                RUN VALUE(pcEventAction) ON hActionTarget NO-ERROR.
            ELSE
                RUN VALUE(pcEventAction) IN hActionTarget NO-ERROR.
        END.    /* no parameter */
        ELSE
        DO:
            IF pcActionTarget EQ "AS":U THEN
                RUN VALUE(pcEventAction) ON hActionTarget ( INPUT pcEventParameter) NO-ERROR.
            ELSE
                RUN VALUE(pcEventAction) IN hActionTarget ( INPUT pcEventParameter) NO-ERROR.
        END.    /* a parameter exists */
    END.    /* run */
    ELSE
    DO:
        IF pcActionTarget = "ANYWHERE":U THEN
        DO:
            IF pcEventParameter = "":U THEN
                PUBLISH pcEventAction.
            ELSE
                PUBLISH pcEventAction ( INPUT pcEventParameter ).
        END.    /* anywhere */
        ELSE
        IF VALID-HANDLE(hActionTarget) THEN
        DO:
            IF pcEventParameter = "":U THEN
                PUBLISH pcEventAction FROM hActionTarget.
            ELSE
                PUBLISH pcEventAction FROM hActionTarget ( INPUT pcEventParameter).
        END.    /* not anywhere */
    END.    /* publish */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewerIncludeMainBlock vTableWin 
PROCEDURE ViewerIncludeMainBlock :
/*------------------------------------------------------------------------------
  Purpose:     This procedure acts a substitute for the ADM2 Viewer Class Include's
               Main Block. This is because pre-processors are use by the ADM2.
  Parameters:  pcDisplayedFields  -
               pcEnabledFields    -
               pcDisplayedObjects -
               pcEnabledObjects   -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcDisplayedFields        AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcEnabledFields          AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcDisplayedObjects       AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcEnabledObjects         AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE cViewCols               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cEnabled                AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iCol                    AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iEntries                AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cEntry                  AS CHARACTER                NO-UNDO.

    /* As of 9.1B, the fields can be qualified by the SDO ObjectName rather
     * than just RowObject. In that case keep the SDO ObjectName qualifier. */
    ASSIGN iEntries = NUM-ENTRIES(pcDisplayedFields, " ":U).
    DO iCol = 1 TO iEntries:
        cEntry = ENTRY(iCol, pcDisplayedFields, " ":U).
        cViewCols = cViewCols + (IF cViewCols NE "":U THEN ",":U ELSE "":U) +
            IF ENTRY(1, cEntry, ".":U) NE "RowObject":U THEN cEntry 
                ELSE SUBSTR(cEntry, R-INDEX(cEntry, ".":U) + 1).  /* Remove table */
    END.

    iEntries = NUM-ENTRIES(pcEnabledFields, " ":U).
    DO iCol = 1 TO iEntries:
        cEntry = ENTRY(iCol, pcEnabledFields, " ":U).
        cEnabled = cEnabled + (IF cEnabled NE "":U THEN ",":U ELSE "":U) +
            IF ENTRY(1, cEntry, ".":U) NE "RowObject":U THEN cEntry 
                ELSE SUBSTR(cEntry, R-INDEX(cEntry, ".":U) + 1).  /* Remove table */
    END.

    {set DisplayedFields cViewCols}.
    {set EnabledFields cEnabled}.

    /* Ensure that the viewer is disabled if it is an update-target without
     * tableio-source (? will enable ) */
    {set SaveSource NO}. 

    /* If there *are* no enabled fields, don't let the viewer be an 
     * Update-Source or TableIO-Target. NOTE: This in principle belongs
     * in datavis.i because it's generic but EnabledFields has just been set. */
    IF cEnabled = "":U THEN
    DO:
        RUN modifyListProperty(THIS-PROCEDURE, "REMOVE":U, "SupportedLinks":U,
                               "Update-Source":U).
        RUN modifyListProperty(THIS-PROCEDURE, "REMOVE":U, "SupportedLinks":U,
                               "TableIO-Target":U).
    END.   /* END DO cEnabled "" */
    ELSE
    DO:
        /* If there are EnabledFields, set the Editable Property to true.
         * This is because the 'Add', 'Update' and 'Copy' actions require 
         * this property to be set as part of their ENABLE_RULEs.
         * This property is usually determined by reading the EnabledFields
         * property, but because we are only setting this property here, as
         * opposed to when the viewer is RUN, we need to explicitly set the
         * Editable property to true.                                      */
        {set Editable YES}.
    END.    /* EnabledFields exist. */

    /* Non-db fields. */
    ASSIGN pcEnabledObjects = REPLACE(pcEnabledObjects, " ":U, ",":U).
    {set EnabledObjFlds pcEnabledObjects}.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildViewerAttributes vTableWin 
FUNCTION buildViewerAttributes RETURNS LOGICAL
    ( /**/ ) :
/*------------------------------------------------------------------------------
  Purpose:  Converts the attributes whicha er stored as a string got the container
            into attribute value temp-table records.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iAttributeLoop              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cAttributePair              AS CHARACTER            NO-UNDO.

    DEFINE BUFFER ttAttributeValue          FOR ttAttributeValue.
    DEFINE BUFFER tt_object_instance        FOR tt_object_instance.

    FIND FIRST tt_object_instance WHERE
               tt_object_instance.logical_object_name = gcLogicalObjectName AND
               tt_object_instance.object_instance_obj = 0
               NO-LOCK NO-ERROR.
    IF AVAILABLE tt_object_instance THEN
    DO iAttributeLoop = 1 TO NUM-ENTRIES(tt_object_instance.instance_attribute_list, CHR(3)):
        ASSIGN cAttributePair = ENTRY(iAttributeLoop, tt_object_instance.instance_attribute_list, CHR(3)).

        CREATE ttAttributeValue.
        ASSIGN ttAttributeValue.containerLogicalObject = gcLogicalObjectName
               ttAttributeValue.ObjectInstanceObj      = 0                      /* this is the containing object */
               ttAttributeValue.attributeGroup         = "":U
               ttAttributeValue.attributeType          = "":U
               ttAttributeValue.attributeLabel         = ENTRY(1, cAttributePair, CHR(4))
               ttAttributeValue.attributeValue         = ENTRY(2, cAttributePair, CHR(4))
               .
    END.    /* container attributes */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildWidgetTable vTableWin 
FUNCTION buildWidgetTable RETURNS LOGICAL
    ( INPUT pdViewerInstanceObj         AS DECIMAL      ) :
/*------------------------------------------------------------------------------
  Purpose:  Builds a temp-table of widgets to create.
    Notes:  * Layout is done elsewhere, as is the tab order.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCounter                    AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iTabOrder                   AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iMaxRow                     AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cLogical                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cShowPopup                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cWidth                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lNoLabel                    AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hTTBuffer                   AS HANDLE               NO-UNDO.

    DEFINE BUFFER tt_object_instance        FOR tt_object_instance.
    DEFINE BUFFER lbAttributeValue          FOR ttAttributeValue.
    DEFINE BUFFER ttWidget                  FOR ttWidget.

    EMPTY TEMP-TABLE ttWidget.

    FOR EACH ttWidgetTable:
        IF VALID-HANDLE(ttWidgetTable.tTableHandle) AND
           ttWidgetTable.tTableHandle:PREPARED      THEN
        DO:
            ASSIGN hTTBuffer = ttWidgetTable.tTableHandle:DEFAULT-BUFFER-HANDLE.
            hTTBuffer:EMPTY-TEMP-TABLE().
        END.    /* valid, prepared TT handle */

        ASSIGN ttWidgetTable.tTableHandle = ?
               hTTBuffer                  = ?
               .
    END.    /* each widget table. */

    ASSIGN iCounter = 1.

    FOR EACH tt_object_instance WHERE
             tt_object_instance.logical_object_name = gcLogicalObjectName AND
             tt_object_instance.object_instance_obj > 0 /* ignore the viewer itself. */
             NO-LOCK:
        CREATE ttWidget.
        ASSIGN ttWidget.tObjectInstanceObj = tt_object_instance.object_instance_obj.

        /* Initial Value */
        ASSIGN ttWidget.tInitialValue = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                         INPUT tt_object_instance.object_instance_obj,
                                                         INPUT "InitialValue":U).

        /* Tab Order */
        ASSIGN ttWidget.tTabOrder = INTEGER(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                             INPUT tt_object_instance.object_instance_obj,
                                                             INPUT "FieldOrder":U) 
                                            ) NO-ERROR.
        /* If no tab order has been set, then create a dummy tab order. */
        IF ttWidget.tTabOrder EQ 0 OR ttWidget.tTabOrder EQ ? THEN
            ASSIGN ttWidget.tTabOrder = iTabOrder + 1.
        ASSIGN iTabOrder = ttWidget.tTabOrder.

        /* Visualisation */
        ASSIGN ttWidget.tWidgetType = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                       INPUT tt_object_instance.object_instance_obj,
                                                       INPUT "VisualizationType":U).
        IF ttWidget.tWidgetType = ? OR ttWidget.tWidgetType = "":U THEN
            ASSIGN ttWidget.tWidgetType = "FILL-IN":U.

        FIND FIRST ttWidgetTable WHERE
                   ttWidgetTable.tWidgetType = ttWidget.tWidgetType
                   NO-ERROR.

        IF NOT AVAILABLE ttWidgetTable                AND
           ttWidget.tWidgetType NE "SmartDataField":U THEN
        DO:
            CREATE ttWidgetTable.
            ASSIGN ttWidgetTable.tWidgetType  = ttWidget.tWidgetType
                   ttWidgetTable.tTableHandle = ?
                   .
        END.

        /* Only build the widget attribute temp tables if needed. */
        IF AVAILABLE ttWidgetTable                                AND 
           ( ( VALID-HANDLE(ttWidgetTable.tTableHandle) AND
               NOT ttWidgetTable.tTableHandle:PREPARED     ) OR
             NOT VALID-HANDLE(ttWidgetTable.tTableHandle)       ) THEN
            RUN buildWidgetTempTable ( INPUT ttWidget.tWidgetType, INPUT-OUTPUT ttWidgetTable.tTableHandle).        
        
        /** Determine the widget name. If there is a FieldName attribute, use this for 
         *  the widget name. This is assumed to mean that the widget belongs to a data
         *  source, and we retrieve the Table~ and DatabaseName attributes.
         *  ----------------------------------------------------------------------- **/
        FIND FIRST lbAttributeValue WHERE
                   lbAttributeValue.ObjectInstanceObj = tt_object_instance.object_instance_obj AND
                   lbAttributeValue.AttributeLabel    = "FieldName":U
                   NO-ERROR.
        IF AVAILABLE lbAttributeValue THEN
        DO:
            /* Widget Name */
            ASSIGN ttWidget.tWidgetName = TRIM(lbAttributeValue.AttributeValue)
                   cFieldName           = ttWidget.tWidgetName
                   .
            /* Table Name */
            ASSIGN ttWidget.tTableName = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                          INPUT tt_object_instance.object_instance_obj,
                                                          INPUT "TableName":U).
            IF ttWidget.tTableName = ? THEN
                ASSIGN ttWidget.tTableName = "":U.

            /* DB Name */
            ASSIGN ttWidget.tDatabaseName = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                             INPUT tt_object_instance.object_instance_obj,
                                                             INPUT "DatabaseName":U).
            IF ttWidget.tDatabaseName = ? THEN
                ASSIGN ttWidget.tDatabaseName = "":U.                

            /* DataSource */
            ASSIGN ttWidget.tDataSource = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                             INPUT tt_object_instance.object_instance_obj,
                                                             INPUT "DataSource":U).
            IF ttWidget.tDataSource = ? THEN
                ASSIGN ttWidget.tDataSource = "":U.
        END.    /* field name available */
        ELSE
        DO:
            FIND FIRST lbAttributeValue WHERE
                       lbAttributeValue.ObjectInstanceObj = tt_object_instance.object_instance_obj AND
                       lbAttributeValue.AttributeLabel    = "WidgetName":U
                       NO-ERROR.
            IF AVAILABLE lbAttributeValue THEN
                ASSIGN ttWidget.tWidgetName = TRIM(lbAttributeValue.AttributeValue).
            ELSE
                /* Give the widget some unique name */
                ASSIGN ttWidget.tWidgetName = ttWidget.tWidgetType + "-":U + STRING(iCounter)
                       iCounter             = iCounter + 1
                       .
            /* This is local widget */
            ASSIGN ttWidget.tTableName    = "":U
                   ttWidget.tDatabaseName = "":U
                   cFieldName             = "<":U + TRIM(ttWidget.tWidgetName) + ">":U
                   .
        END.    /* no FieldName */

        /* If we have auto-attached and SDF to a local fill-in, we need to set the FieldName attribute 
         * to "<Local>", so that we know which property to store that handle in.                       */
        IF ttWidget.tWidgetType EQ "SmartDataField":U THEN
        DO:
            FIND FIRST lbAttributeValue WHERE
                       lbAttributeValue.ObjectInstanceObj = tt_object_instance.object_instance_obj AND
                       lbAttributeValue.AttributeLabel    = "FieldName":U
                       NO-ERROR.
            IF NOT AVAILABLE lbAttributeValue THEN
            DO:
                CREATE lbAttributeValue.
                ASSIGN lbAttributeValue.ObjectInstanceObj      = tt_object_instance.object_instance_obj
                       lbAttributeValue.AttributeLabel         = "FieldName":U
                       lbAttributeValue.containerLogicalObject = gcLogicalObjectName
                       .
            END.    /* n/a ttAttributeValue */
    
            ASSIGN lbAttributeValue.AttributeValue = cFieldName.
        END.    /* SDF with a */

        /* Data Type */
        ASSIGN ttWidget.tDataType = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                     INPUT tt_object_instance.object_instance_obj,
                                                     INPUT "DATA-TYPE":U).

        IF ttWidget.tDataType = "":U OR ttWidget.tDataType = ? THEN
            ASSIGN ttWidget.tDataType = "CHARACTER":U.

        /* Widget Label */
        ASSIGN cLogical = DYNAMIC-FUNCTION("getAttributeValue":U,
                                           INPUT tt_object_instance.object_instance_obj,
                                           INPUT "NoLabel":U).
        CASE cLogical:
            WHEN "YES":U OR WHEN "TRUE":U THEN ASSIGN lNoLabel = YES.
            OTHERWISE                          ASSIGN lNoLabel = NO.
        END CASE.   /* logical*/

        IF NOT lNoLabel THEN
        DO:
            /* We need the font to determine the label's width. */
            ASSIGN ttWidget.tLabelFont = INTEGER(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                  INPUT tt_object_instance.object_instance_obj,
                                                                  INPUT "LabelFont":U)) NO-ERROR.

            IF ttWidget.tWidgetType = "SmartDataField":U THEN
                ASSIGN ttWidget.tLabel= DYNAMIC-FUNCTION("getAttributeValue":U,
                                                         INPUT tt_object_instance.object_instance_obj,
                                                         INPUT "FieldLabel":U).
            ELSE
                ASSIGN ttWidget.tLabel= DYNAMIC-FUNCTION("getAttributeValue":U,
                                                         INPUT tt_object_instance.object_instance_obj,
                                                         INPUT "LABEL":U).

            IF ttWidget.tLabel = ? OR ttWidget.tLabel = "":U THEN
                ASSIGN ttWidget.tLabel = REPLACE(ttWidget.tWidgetName, "_":U, " ":U).

            /* We use pixels here. For more details 
             * see the CreateObjects IP, particularly the
             * code involved in the creation of the label.  */
            IF LOOKUP(ttWidget.tWidgetType, "TOGGLE-BOX":U) EQ 0 THEN
                ASSIGN ttWidget.tLabel = ttWidget.tLabel + ": ":U.
            ELSE
                ASSIGN ttWidget.tLabel = ttWidget.tLabel.

            ASSIGN ttWidget.tLabelWidth = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttWidget.tLabel, ttWidget.tLabelFont).

            /* Other Label Attribute: Colors */
            ASSIGN ttWidget.tLabelBgColor = INTEGER(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                     INPUT tt_object_instance.object_instance_obj,
                                                                     INPUT "LabelBgColor":U)) NO-ERROR.
            ASSIGN ttWidget.tLabelFgColor = INTEGER(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                     INPUT tt_object_instance.object_instance_obj,
                                                                     INPUT "LabelFgColor":U)) NO-ERROR.
        END.    /* use a label */
        ELSE
            ASSIGN ttWidget.tLabel = ?.

        /* Format */
        ASSIGN ttWidget.tFormat = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                   INPUT tt_object_instance.object_instance_obj,
                                                   INPUT "FORMAT":U).
        IF ttWidget.tFormat = "":U OR ttWidget.tFormat = ? THEN
        /* These default formats are the same as the Progress data type default formats. */
        CASE ttWidget.tDataType:
            WHEN "CHARACTER":U THEN ASSIGN ttWidget.tFormat = "x(8)":U.
            WHEN "DECIMAL":U   THEN ASSIGN ttWidget.tFormat = "->>,>>9.99":U.
            WHEN "INTEGER":U   THEN ASSIGN ttWidget.tFormat = "->,>>>,>>9":U.
            WHEN "DATE":U      THEN ASSIGN ttWidget.tFormat = "99/99/9999":U.
            WHEN "LOGICAL":U   THEN ASSIGN ttWidget.tFormat = "YES/NO":U.
        END CASE.   /* data type */

        /* Private Data */
        ASSIGN ttWidget.tPrivateData = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                        INPUT tt_object_instance.object_instance_obj,
                                                        INPUT "PRIVATE-DATA":U).
        IF ttWidget.tPrivateData EQ ? THEN
            ASSIGN ttWidget.tPrivateData = "":U.

        /* Display the Popup Calendar/Calculator? */
        ASSIGN cShowPopup = DYNAMIC-FUNCTION("getAttributeValue":U,
                                             INPUT tt_object_instance.object_instance_obj,
                                             INPUT "ShowPopup":U                           ).

        IF cShowPopup                                NE ? AND
           LOOKUP(cShowPopup, "YES,TRUE,FALSE,NO":U) NE 0 THEN        
            ASSIGN ttWidget.tPrivateData = ttWidget.tPrivateData + (IF NUM-ENTRIES(ttWidget.tPrivateData) = 0 THEN "":U ELSE ",":U)
                                         + "ShowPopup,":U + cShowPopup.
        
        /* Height */
        ASSIGN ttWidget.tHeight = DECIMAL(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                           INPUT tt_object_instance.object_instance_obj,
                                                           INPUT "HEIGHT-CHARS":U)
                                          ) NO-ERROR.

        /* Default height is 1 (one) character */
        IF ttWidget.tHeight = 0 OR ttWidget.tHeight = ? THEN
            ASSIGN ttWidget.tHeight = 1.

        /* Font. The font may be needed to calculate the width of the widget. */
        ASSIGN ttWidget.tFont = INTEGER(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                         INPUT tt_object_instance.object_instance_obj,
                                                         INPUT "FONT":U))
               NO-ERROR.

        /* Width */
        ASSIGN ttWidget.tWidth = DECIMAL(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                          INPUT tt_object_instance.object_instance_obj,
                                                          INPUT "WIDTH-CHARS":U)
                                         ) NO-ERROR.

        /* Default the width to the format size if none is specified. */
        IF ttWidget.tWidth = 0 OR ttWidget.tWidth = ? THEN
        CASE ttWidget.tDataType:
            WHEN "CHARACTER":U THEN
            DO:
                /* If the format is of type 'x(n)', then */
                IF INDEX(ttWidget.tFormat, "(":U) NE 0 THEN
                DO:                    
                    ASSIGN cWidth = SUBSTRING(ttWidget.tFormat, INDEX(ttWidget.tFormat, "(":U ) + 1).
                    ASSIGN cWidth = SUBSTRING(cWidth, 1, R-INDEX(cWidth, ")":U) - 1).

                    ASSIGN ttWidget.tWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(FILL("w":U, INTEGER(cWidth)), ttWidget.tFont)
                           NO-ERROR.
                END.    /* */
                ELSE
                    ASSIGN ttWidget.tWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ttWidget.tFormat, ttWidget.tFont).
            END.    /* character */
            WHEN "LOGICAL":U THEN            
                ASSIGN ttWidget.tWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(IF LENGTH(ENTRY(1, ttWidget.tFormat, "/":U)) GE LENGTH(ENTRY(2, ttWidget.tFormat, "/":U)) THEN
                                                                            ENTRY(1, ttWidget.tFormat, "/":U)
                                                                         ELSE
                                                                            ENTRY(2, ttWidget.tFormat, "/":U)
                                                                                , ttWidget.tFont).            
            OTHERWISE
                ASSIGN ttWidget.tWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ttWidget.tFormat, ttWidget.tFont).
        END CASE.   /* data type */

        /* Separate assign statements in case of errors. */
        ASSIGN ttWidget.tRow = DECIMAL(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                        INPUT ttWidget.tObjectInstanceObj,
                                                        INPUT "ROW":U)
                                       ) NO-ERROR.
        /* Store the maximum row in case there are some widgets which have no Row attribute stored. */
        ASSIGN iMaxRow = MAX(iMaxRow, ttWidget.tRow).

        ASSIGN ttWidget.tColumn = DECIMAL(DYNAMIC-FUNCTION("getAttributeValue":U,
                                                           INPUT ttWidget.tObjectInstanceObj,
                                                           INPUT "COLUMN":U)
                                          ) NO-ERROR.

        /* Visible? */
        ASSIGN cLogical = DYNAMIC-FUNCTION("getAttributeValue":U,
                                           INPUT tt_object_instance.object_instance_obj,
                                           INPUT "VISIBLE":U).
        CASE cLogical:
            WHEN "YES":U OR WHEN "TRUE":U  THEN ASSIGN ttWidget.tVisible = YES.
            OTHERWISE                           ASSIGN ttWidget.tVisible = NO.
        END CASE.   /* logical*/

        /* Enabled? */
        IF ttWidget.tWidgetType EQ "SmartDataField":U THEN
        DO:
            ASSIGN cLogical = DYNAMIC-FUNCTION("getAttributeValue":U,
                                               INPUT tt_object_instance.object_instance_obj,
                                               INPUT "EnableField":U).
            CASE cLogical:
                WHEN "YES":U OR WHEN "TRUE":U THEN ASSIGN ttWidget.tEnabled = YES.
                OTHERWISE                          ASSIGN ttWidget.tEnabled = NO.
            END CASE.   /* logical*/
        END.
        ELSE
        DO:
            ASSIGN cLogical = DYNAMIC-FUNCTION("getAttributeValue":U,
                                               INPUT tt_object_instance.object_instance_obj,
                                               INPUT "ENABLED":U).
            CASE cLogical:
                WHEN "YES":U OR WHEN "TRUE":U THEN ASSIGN ttWidget.tEnabled = YES.
                OTHERWISE                          ASSIGN ttWidget.tEnabled = NO.
            END CASE.   /* logical*/
        END.    /* not SDF */

        /* DisplayField? */
        ASSIGN cLogical = DYNAMIC-FUNCTION("getAttributeValue":U,
                                           INPUT tt_object_instance.object_instance_obj,
                                           INPUT "DisplayField":U).
        CASE cLogical:
            WHEN "YES":U OR WHEN "TRUE":U THEN ASSIGN ttWidget.tDisplayField = YES.
            OTHERWISE                          ASSIGN ttWidget.tDisplayField = NO.
        END CASE.   /* logical*/

        /* Tooltip */
        ASSIGN ttWidget.tTooltip = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                    INPUT tt_object_instance.object_instance_obj,
                                                    INPUT "TOOLTIP":U).
        IF ttWidget.tTooltip EQ ? THEN
            ASSIGN ttWidget.tTooltip = "":U.

        /* Before visualising, add any other attributes */
        IF AVAILABLE ttWidgetTable                  AND
           VALID-HANDLE(ttWidgetTable.tTableHandle) THEN
            DYNAMIC-FUNCTION("getExtraAttributes":U,
                             INPUT ttWidgetTable.tTableHandle,
                             INPUT tt_object_instance.object_instance_obj).

        /* Custom Super Procedure, for use by SmartDataFields. */
        ASSIGN ttWidget.tCustomSuperProc = tt_object_instance.custom_super_procedure.
    END.    /* object instances */

    /* Ensure that all widgets have a valid Row. Add the widgets to the end of the 
     * viewer. This will result in a "Sizing Error" warning, but there's nothing we
     * can do about that.                                                          */
    ASSIGN iMaxRow = iMaxRow + 1.
    FOR EACH ttWidget WHERE
             ttWidget.tRow = 0:
        ASSIGN ttWidget.tRow = iMaxRow
               iMaxRow       = iMaxRow + 1
               .
    END.    /* widgets where row = 0 */

    /* Ensure that all widgets have a valid Column value.
     * Align the widgets along the left-hand border.     */
    FOR EACH ttWidget WHERE
             ttWidget.tColumn = 0:
        IF ttWidget.tLabel EQ ? THEN
            ASSIGN ttWidget.tColumn = 1.
        ELSE
            ASSIGN ttWidget.tColumn = ( ttWidget.tLabelWidth / SESSION:PIXELS-PER-COLUMN ) + 1.
    END.    /* no column specified. */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearWidgetTempTable vTableWin 
FUNCTION clearWidgetTempTable RETURNS LOGICAL
    ( INPUT phTempTable         AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Empties all of the dynamic temp-tables
    Notes:  
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE hTTBuffer           AS HANDLE                   NO-UNDO.

    IF VALID-HANDLE(phTEmpTable) AND
       phTEmpTable:PREPARED      THEN
    DO:
        ASSIGN hTTBuffer = phTempTable:DEFAULT-BUFFER-HANDLE.
        hTTBuffer:EMPTY-TEMP-TABLE().
    END.    /* valid, prepared TT handle */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createEvents vTableWin 
FUNCTION createEvents RETURNS LOGICAL
    ( INPUT pdObjectInstanceObj     AS DECIMAL,
      INPUT phField                 AS HANDLE       ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates custom events for the widget. 
    Notes:  
------------------------------------------------------------------------------*/
    FOR EACH ttUiEvent WHERE
             ttUiEvent.ObjectInstanceObj = pdObjectInstanceObj
             NO-LOCK:
        /* Make sure that this is a valid event for the widget */
        IF VALID-EVENT(phField, ttUiEvent.EventName) THEN
        CASE ttUiEvent.EventName:
            WHEN "ANY-KEY":U THEN
                ON ANY-KEY OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "ANY-PRINTABLE":U THEN
                ON ANY-PRINTABLE OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "BACK-TAB":U THEN
                ON BACK-TAB OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "BACKSPACE":U THEN
                ON BACKSPACE OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "BELL":U THEN
                ON BELL OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "CHOOSE":U THEN
                ON CHOOSE OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "CLEAR":U THEN
                ON CLEAR OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "DEFAULT-ACTION":U THEN
                ON DEFAULT-ACTION OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "DEL":U THEN
                ON DEL OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "DELETE-CHAR":U THEN
                ON DELETE-CHAR OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "DELETE-CHARACTER":U THEN
                ON DELETE-CHARACTER OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "DESELECT":U THEN
                ON DESELECT OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "DESELECTION":U THEN
                ON DESELECTION OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "DROP-FILE-NOTIFY":U THEN
                ON DROP-FILE-NOTIFY OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "END-ERROR":U THEN
                ON END-ERROR OF phField PERSISTENT        
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "END-MOVE":U THEN
                ON END-MOVE OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "END-RESIZE":U THEN
                ON END-RESIZE OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "ENDKEY":U THEN
                ON ENDKEY OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "ENTRY":U THEN
                ON ENTRY OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "ERROR":U THEN
                ON ERROR OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "GO":U THEN
                ON GO OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "HELP":U THEN
                ON HELP OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "LEAVE":U THEN
                ON LEAVE OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "RECALL":U THEN
                ON RECALL OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).
            WHEN "RETURN":U THEN
                ON RETURN OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "SELECT":U THEN
                ON SELECT OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "SELECTION":U THEN
                ON SELECTION OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "START-MOVE":U THEN
                ON START-MOVE OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "START-RESIZE":U THEN
                ON START-RESIZE OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "TAB":U THEN
                ON TAB OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
            WHEN "VALUE-CHANGED":U THEN
                ON VALUE-CHANGED OF phField PERSISTENT
                    RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ttUiEvent.ActionType,      /* RUN/PUBLISH */
                                                                    INPUT ttUiEvent.EventAction,     /* The procedure to RUN or PUBLISH */
                                                                    INPUT ttUiEvent.ActionTarget,    /* SELF,CONTAINER,ANYWHERE */ 
                                                                    INPUT ttUiEvent.EventParameter ).            
        END CASE.    /* only valid events */
    END.    /* all UI events */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyWidgets vTableWin 
FUNCTION destroyWidgets RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Destroy everything in case we are morphing from one physical 
           object to another
    Notes:  * If this procedure is being called from another destroy routine,
              we don't delete the PROCEDURE objects. These will be gracefully
              destroyed by the ADM.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWidget         AS HANDLE                           NO-UNDO.

    DEFINE BUFFER ttWidget  FOR ttWidget.

    FOR EACH ttWidget WHERE
             VALID-HANDLE(ttWidget.tWidgetHandle):

        IF ttWidget.tWidgetType = "SmartDataField":U AND
           PROGRAM-NAME(2) BEGINS "destroy":U        THEN
            NEXT.

        IF CAN-QUERY(ttWidget.tWidgetHandle, "SIDE-LABEL-HANDLE":U) THEN
        DO:
            ASSIGN hWidget = ttWidget.tWidgetHandle:SIDE-LABEL-HANDLE.

            IF VALID-HANDLE(hWidget) THEN
                DELETE WIDGET hWidget.
        END.    /* label */

        DELETE OBJECT ttWidget.tWidgetHandle NO-ERROR.

        ASSIGN ttWidget.tWidgetHandle = ?
               ttWidget.tFrameHandle  = ?
               .
    END.    /* each widget */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeValue vTableWin 
FUNCTION getAttributeValue RETURNS CHARACTER
    ( INPUT pdObjectInstanceObj     AS DECIMAL,
      INPUT pcAttributeLabel        AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the attribute value for a given attribute label and
            object instance.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeValue             AS CHARACTER            NO-UNDO.
    DEFINE BUFFER ttAttributeValue          FOR ttAttributeValue.

    FIND FIRST ttAttributeValue WHERE
               ttAttributeValue.ObjectInstanceObj = pdObjectInstanceObj AND
               ttAttributeValue.AttributeLabel    = pcAttributeLabel
               NO-ERROR.
    IF AVAILABLE ttAttributeValue THEN
        RETURN TRIM(ttAttributeValue.AttributeValue).
    ELSE
        RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getExtraAttributes vTableWin 
FUNCTION getExtraAttributes RETURNS LOGICAL
    ( INPUT phTempTable             AS HANDLE,
      INPUT pdObjectInstanceObj     AS DECIMAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  Adds any attribute which are specific to the widget type
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hTTBuffer           AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hTTField            AS HANDLE                       NO-UNDO.

    DEFINE BUFFER ttAttributeValue      FOR ttAttributeValue.

    ASSIGN hTTBuffer = phTempTable:DEFAULT-BUFFER-HANDLE
           hTTField  = hTTBuffer:BUFFER-FIELD("tObjectInstanceObj":U)
           .
    hTTBuffer:BUFFER-CREATE().
    ASSIGN hTTField:BUFFER-VALUE = pdObjectInstanceObj.

    FOR EACH ttAttributeValue WHERE
             ttAttributeValue.ObjectInstanceObj = pdObjectInstanceObj:
        /* Assign attribute values which exist as attributes for the widget type. */
        ASSIGN hTTField = hTTBuffer:BUFFER-FIELD(ttAttributeValue.AttributeLabel) NO-ERROR.
        IF VALID-HANDLE(hTTField) THEN
        DO:
            /* Null values are stored as blank in the RYC_ATTRIBUTE_VALUE table.
             * We convert these blank values to a 'proper' null value, as the
             * routine that sets the attribute values checks for the existence
             * of a ? string as values which should not be set.                  */
            IF ttAttributeValue.AttributeValue = "":U THEN
                ASSIGN hTTField:BUFFER-VALUE = ?.
            ELSE
                ASSIGN hTTField:BUFFER-VALUE = ttAttributeValue.AttributeValue.
        END.    /* valid TT Field */
    END.    /* attribute values */

    hTTBuffer:BUFFER-RELEASE().

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLocalAttributes vTableWin 
FUNCTION getLocalAttributes RETURNS CHARACTER
    ( INPUT pdObjectInstanceObj         AS DECIMAL      ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns all of the attributes for a given object instance.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cLocalAttributes        AS CHARACTER                NO-UNDO.

    DEFINE BUFFER ttAttributeValue      FOR ttAttributeValue.

    FOR EACH ttAttributeValue WHERE
             ttAttributeValue.ObjectInstanceObj = pdObjectInstanceObj
             NO-LOCK:
        ASSIGN cLocalAttributes = cLocalAttributes + (IF NUM-ENTRIES(cLocalAttributes, CHR(3)) = 0 THEN "":U ELSE CHR(3))
                                + (ttAttributeValue.AttributeLabel + CHR(4) + ttAttributeValue.AttributeValue)
               .
    END.    /* object instances */

    RETURN cLocalAttributes.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExtraAttributes vTableWin 
FUNCTION setExtraAttributes RETURNS LOGICAL
    ( INPUT pdObjectInstanceObj     AS DECIMAL,
      INPUT phField                 AS HANDLE,
      INPUT phTempTable             AS HANDLE       ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the attibutes for the specified widget. These will be attributes
            for widget types other than FILL-INs, which are the default widget
            type. 
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hTTBuffer               AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hTTField                AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hQuery                  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iFieldLoop              AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cCharacterValue         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cQueryString            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dDecimalValue           AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE iIntegerValue           AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE lLogicalValue           AS LOGICAL                  NO-UNDO.

    ASSIGN hTTBuffer = phTempTable:DEFAULT-BUFFER-HANDLE.
    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(hTTBuffer).

    /* Use a variable for readablilty. */
    ASSIGN cQueryString = "FOR EACH " + hTTBuffer:NAME + " WHERE ":U
                        + hTTBuffer:NAME + ".tObjectInstanceObj = '":U + STRING(pdObjectInstanceObj) + "' ":U.

    /* Ensure that the query prepare string conforms to the numeric format specified. */
    hQuery:QUERY-PREPARE(DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryString)).

    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    IF hTTBuffer:AVAILABLE THEN
    DO:
        DO iFieldLoop = 1 TO hTTBuffer:NUM-FIELDS:
            
            ASSIGN hTTField = hTTBuffer:BUFFER-FIELD(iFieldLoop).

            /* The initial value of all fields is ?, so if the current value is ?, we haven't set
             * anything extra, and the default value will be retained.                            */
            IF hTTField:BUFFER-VALUE NE ? THEN
            DO:
                ASSIGN cCharacterValue = hTTField:BUFFER-VALUE.
                ASSIGN dDecimalValue = DECIMAL(cCharacterValue) NO-ERROR.
                ASSIGN iIntegerValue = INTEGER(cCharacterValue) NO-ERROR.
                IF LOOKUP(cCharacterValue, "YES,TRUE":U) NE 0 THEN
                    ASSIGN lLogicalValue = YES.
                ELSE
                IF LOOKUP(cCharacterValue, "NO,FALSE":U) NE 0 THEN                
                    ASSIGN lLogicalValue = NO.
                ELSE
                    ASSIGN lLogicalValue = ?.

                /* This is where I _really_ need dynamic attributes */
                IF NOT(lLogicalValue = ? AND cCharacterValue = "":U AND dDecimalValue = 0 AND iIntegerValue = 0) AND
                   CAN-SET(phField, hTTField:NAME)                                                               THEN
                CASE hTTField:NAME:
                    WHEN "AUTO-COMPLETION":U        THEN ASSIGN phField:AUTO-COMPLETION      = lLogicalValue.
                    WHEN "AUTO-END-KEY":U           THEN ASSIGN phField:AUTO-END-KEY         = lLogicalValue.
                    WHEN "AUTO-GO":U                THEN ASSIGN phField:AUTO-GO              = lLogicalValue.
                    WHEN "AUTO-INDENT":U            THEN ASSIGN phField:AUTO-INDENT          = lLogicalValue.
                    WHEN "AUTO-RESIZE":U            THEN ASSIGN phField:AUTO-RESIZE          = lLogicalValue. 
                    WHEN "AUTO-RETURN":U            THEN ASSIGN phField:AUTO-RETURN          = lLogicalValue.
                    WHEN "AUTO-ZAP":U               THEN ASSIGN phField:AUTO-ZAP             = lLogicalValue.
                    WHEN "BGCOLOR":U                THEN ASSIGN phField:BGCOLOR              = iIntegerValue.
                    WHEN "BLANK":U                  THEN ASSIGN phField:BLANK                = lLogicalValue.
                    WHEN "BOX":U                    THEN ASSIGN phField:BOX                  = lLogicalValue.
                    WHEN "BUFFER-CHARS":U           THEN ASSIGN phField:BUFFER-CHARS         = iIntegerValue.
                    WHEN "BUFFER-LINES":U           THEN ASSIGN phField:BUFFER-LINES         = iIntegerValue.
                    WHEN "CHECKED":U                THEN ASSIGN phField:CHECKED              = lLogicalValue.
                    WHEN "CONTEXT-HELP-ID":U        THEN ASSIGN phField:CONTEXT-HELP-ID      = iIntegerValue.
                    WHEN "CONVERT-3D-COLORS":U      THEN ASSIGN phField:CONVERT-3D-COLORS    = lLogicalValue.
                    WHEN "CURSOR-CHAR":U            THEN ASSIGN phField:CURSOR-CHAR          = iIntegerValue.
                    WHEN "CURSOR-LINE":U            THEN ASSIGN phField:CURSOR-LINE          = iIntegerValue.
                    WHEN "CURSOR-OFFSET":U          THEN ASSIGN phField:CURSOR-OFFSET        = iIntegerValue.
                    WHEN "DEBLANK":U                THEN ASSIGN phField:DEBLANK              = lLogicalValue.
                    WHEN "DEFAULT":U                THEN ASSIGN phField:DEFAULT              = lLogicalValue.
                    WHEN "DELIMITER":U              THEN ASSIGN phField:DELIMITER            = cCharacterValue.
                    WHEN "DISABLE-AUTO-ZAP":U       THEN ASSIGN phField:DISABLE-AUTO-ZAP     = lLogicalValue.
                    WHEN "DRAG-ENABLED":U           THEN ASSIGN phField:DRAG-ENABLED         = lLogicalValue.
                    WHEN "DROP-TARGET":U            THEN ASSIGN phField:DROP-TARGET          = lLogicalValue.
                    WHEN "EDGE-CHARS":U             THEN ASSIGN phField:EDGE-CHARS           = dDecimalValue. 
                    WHEN "EDGE-PIXELS":U            THEN ASSIGN phField:EDGE-PIXELS          = iIntegerValue. 
                    WHEN "EDIT-CAN-UNDO":U          THEN ASSIGN phField:EDIT-CAN-UNDO        = lLogicalValue.
                    WHEN "FGCOLOR":U                THEN ASSIGN phField:FGCOLOR              = iIntegerValue.
                    WHEN "FILLED":U                 THEN ASSIGN phField:FILLED               = lLogicalValue.
                    WHEN "FLAT-BUTTON":U            THEN ASSIGN phField:FLAT-BUTTON          = lLogicalValue.
                    WHEN "GRAPHIC-EDGE":U           THEN ASSIGN phField:GRAPHIC-EDGE         = lLogicalValue.
                    WHEN "HELP":U                   THEN ASSIGN phField:HELP                 = cCharacterValue.
                    WHEN "INNER-CHARS":U            THEN ASSIGN phField:INNER-CHARS          = iIntegerValue.
                    WHEN "INNER-LINES":U            THEN ASSIGN phField:INNER-LINES          = iIntegerValue. 
                    WHEN "LARGE":U                  THEN ASSIGN phField:LARGE                = lLogicalValue.
                    WHEN "LIST-ITEM-PAIRS":U        THEN ASSIGN phField:LIST-ITEM-PAIRS      = cCharacterValue.
                    WHEN "LIST-ITEMS":U             THEN ASSIGN phField:LIST-ITEMS           = cCharacterValue.
                    WHEN "MANUAL-HIGHLIGHT":U       THEN ASSIGN phField:MANUAL-HIGHLIGHT     = lLogicalValue.
                    WHEN "MAX-CHARS":U              THEN ASSIGN phField:MAX-CHARS            = iIntegerValue.
                    WHEN "MENU-KEY":U               THEN ASSIGN phField:MENU-KEY             = cCharacterValue.
                    WHEN "MENU-MOUSE":U             THEN ASSIGN phField:MENU-MOUSE           = iIntegerValue.
                    WHEN "MOVABLE":U                THEN ASSIGN phField:MOVABLE              = lLogicalValue.
                    WHEN "MULTIPLE":U               THEN ASSIGN phField:MULTIPLE             = lLogicalValue.
                    WHEN "NO-FOCUS":U               THEN ASSIGN phField:NO-FOCUS             = lLogicalValue.
                    WHEN "PROGRESS-SOURCE":U        THEN ASSIGN phField:PROGRESS-SOURCE      = lLogicalValue.
                    WHEN "READ-ONLY":U              THEN ASSIGN phField:READ-ONLY            = lLogicalValue.
                    WHEN "RESIZABLE":U              THEN ASSIGN phField:RESIZABLE            = lLogicalValue.
                    WHEN "RETURN-INSERTED":U        THEN ASSIGN phField:RETURN-INSERTED      = lLogicalValue.
                    WHEN "SCREEN-VALUE":U           THEN ASSIGN phField:SCREEN-VALUE         = cCharacterValue.
                    WHEN "SCROLLBAR-HORIZONTAL":U   THEN ASSIGN phField:SCROLLBAR-HORIZONTAL = lLogicalValue.
                    WHEN "SCROLLBAR-VERTICAL":U     THEN ASSIGN phField:SCROLLBAR-VERTICAL   = lLogicalValue.
                    WHEN "SELECTABLE":U             THEN ASSIGN phField:SELECTABLE           = lLogicalValue.
                    WHEN "SELECTED":U               THEN ASSIGN phField:SELECTED             = lLogicalValue.
                    WHEN "SORT":U                   THEN ASSIGN phField:SORT                 = lLogicalValue.
                    WHEN "SUBTYPE":U                THEN ASSIGN phField:SUBTYPE              = cCharacterValue.
                    WHEN "TAB-STOP":U               THEN ASSIGN phField:TAB-STOP             = lLogicalValue.
                    WHEN "UNIQUE-MATCH":U           THEN ASSIGN phField:UNIQUE-MATCH         = lLogicalValue.
                    WHEN "WORD-WRAP":U              THEN ASSIGN phField:WORD-WRAP            = lLogicalValue.
                END CASE.   /* field name */
            END.    /* there is a value in the field.*/
        END.    /* loop through the fields. */
    END.    /* record is available */

    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

