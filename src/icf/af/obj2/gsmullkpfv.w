&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmullkpfv.w

  Description:  Lookup Filter Viewer for Security Allocations

  Purpose:      Lookup Filter Viewer for Security Allocations

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000011   UserRef:    POSSE
                Date:   28/03/2001  Author:     Phillip Magnay  


---------------------------------------------------------------------------------*/
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

&scop object-name       gsmullkpfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{af/sup2/afglobals.i}

DEFINE VARIABLE glModified                  AS LOGICAL INITIAL NO.
DEFINE VARIABLE gcCallerName                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCallerHandle              AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowse                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSDF                       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghUser1Source               AS HANDLE     NO-UNDO.

/* Filter temp table*/
{af/sup2/afttlkfilt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buClear buApply 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buApply 
     LABEL "&Apply" 
     SIZE 15 BY 1.14 TOOLTIP "Apply Filter and Re-open lookup query"
     BGCOLOR 8 .

DEFINE BUTTON buClear 
     LABEL "C&lear" 
     SIZE 15 BY 1.14 TOOLTIP "Clear Filter Settings - must then press APPLY button to refresh query"
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buClear AT ROW 1 COL 71.8
     buApply AT ROW 1 COL 87.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103 BY 9.24.


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
         HEIGHT             = 9.24
         WIDTH              = 103.
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply sObject
ON CHOOSE OF buApply IN FRAME frMain /* Apply */
DO:

  DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

  APPLY "entry":U TO SELF.

  /* First validate fields in filter temp-table before applying */
  RUN validateFilter(OUTPUT lOk).
  IF NOT lOk THEN RETURN NO-APPLY.

  /* Apply filter to the linked source */
  IF VALID-HANDLE(ghUser1Source) THEN
     RUN applyFilters IN ghUser1Source (INPUT TABLE ttLookFilt).

  /* Change tab folder page to previous page */
  RUN processAction(INPUT "ctrl-page-up":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClear sObject
ON CHOOSE OF buClear IN FRAME frMain /* Clear */
DO:

  /* Clear from and to values */
  FOR EACH ttLookFilt:
    ASSIGN
      ttLookFilt.cFromValue = IF ttLookFilt.cFieldDataType EQ "LOGICAL":U THEN "NO"  ELSE "":U
      ttLookFilt.cToValue   = IF ttLookFilt.cFieldDataType EQ "LOGICAL":U THEN "YES" ELSE "":U
      .
  END.

  /* Now open the query */
  ghQuery:QUERY-OPEN().

  /* Move focus to browser */
  IF VALID-HANDLE(ghBrowse) THEN
  APPLY "ENTRY":U TO ghBrowse.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildFilters sObject 
PROCEDURE buildFilters :
/*------------------------------------------------------------------------------
  Purpose:     Construct dynamic filter browser onto viewer plus related info
  Parameters:  <none>
  Notes:       User1 link which is used to determine the handle of the object
               to which the filter is appled, is set up in the dynamic folder
               window object.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hTH                       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cBrowseColHdls            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hLookup                   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cValue                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hFrame                    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lPreviouslyHidden         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE dHeight                   AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dWidth                    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cBrowseFields             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cBrowseFieldLabels        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cBrowseFieldFormats       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cBrowseFieldDataTypes     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cPrevBrowseFields         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cPrevBrowseFieldFromValues AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPrevBrowseFieldToValues  AS CHARACTER  NO-UNDO.

    /* Get handle to container */
    {get ContainerSource hContainerSource}.    

    /* Get handle to User1 source object  - the User1 link is set up in the dynamic folder window object */
    cLinkHandles = DYNAMIC-FUNCTION('linkHandles' IN THIS-PROCEDURE, 'User1-Source').    
    IF cLinkHandles <> "":U THEN
      ghUser1Source = WIDGET-HANDLE(ENTRY(1,cLinkHandles)).

    /*  Get details of browser columns in the User1 source object */
    RUN getBrowseDetails IN ghUser1Source 
        (OUTPUT cBrowseFields,
         OUTPUT cBrowseFieldLabels,
         OUTPUT cBrowseFieldFormats,
         OUTPUT cBrowseFieldDataTypes).

    /* Save previous filter from and to values */
    FOR EACH ttLookFilt:
       ASSIGN
           cPrevBrowseFieldFromValues  = cPrevBrowseFieldFromValues
                                       + (IF cPrevBrowseFields EQ "":U THEN "":U ELSE CHR(1))
                                       + ttLookFilt.cFromValue
           cPrevBrowseFieldToValues    = cPrevBrowseFieldToValues
                                       + (IF cPrevBrowseFields EQ "":U THEN "":U ELSE CHR(1))
                                       + ttLookFilt.cToValue
           cPrevBrowseFields           = cPrevBrowseFields
                                       + (IF cPrevBrowseFields EQ "":U THEN "":U ELSE ",":U)
                                       + ttLookFilt.cFieldName
           .
    END. /* FOR EACH ttLookFilt: */

    /* Clear and populate filter temp-table */
    EMPTY TEMP-TABLE ttLookFilt.
    DO iLoop = 1 TO NUM-ENTRIES(cBrowseFields):
      CREATE ttLookFilt.
      ASSIGN
        ttLookFilt.cFieldName     = ENTRY(iLoop, cBrowseFields)
        ttLookFilt.cFieldLabel    = ENTRY(iLoop, cBrowseFieldLabels,CHR(3))
        ttLookFilt.cFieldFormat   = ENTRY(iLoop, cBrowseFieldFormats,CHR(3))
        ttLookFilt.cFieldDataType = ENTRY(iLoop, cBrowseFieldDataTypes).
        ttLookFilt.cFromValue     = (IF cPrevBrowseFields EQ cBrowseFields THEN ENTRY(iLoop, cPrevBrowseFieldFromValues, CHR(1)) 
                                     ELSE IF ENTRY(iLoop, cBrowseFieldDataTypes) EQ 'LOGICAL':U THEN 'NO' ELSE "":U).
        ttLookFilt.cToValue       = (IF cPrevBrowseFields EQ cBrowseFields THEN ENTRY(iLoop, cPrevBrowseFieldToValues,   CHR(1)) 
                                     ELSE IF ENTRY(iLoop, cBrowseFieldDataTypes) EQ 'LOGICAL':U THEN 'YES' ELSE "":U)
        .
    END. /* DO iLoop = 1 TO NUM-ENTRIES(cBrowseFields) */

    /* Get handles to filter temp table and filter temp table buffer */
    ASSIGN
      ghTable = TEMP-TABLE ttLookFilt:HANDLE
      ghBuffer = ghTable:DEFAULT-BUFFER-HANDLE
      . 

    /* Construct query for filter temp table */
    CREATE QUERY ghQuery.
    ghQuery:ADD-BUFFER(ghBuffer).
    ASSIGN cQuery = "FOR EACH ttLookFilt NO-LOCK":U.
    ghQuery:QUERY-PREPARE(cQuery).

    /* Get dimensions of containing window */
    {get ContainerHandle hWindow hContainerSource}.    

    /* Create the dynamic browser and size it relative to the containing window */
    CREATE BROWSE ghBrowse
           ASSIGN FRAME            = FRAME {&FRAME-NAME}:handle
                  ROW              = 2.5
                  COL              = 1.5
                  WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 3
                  HEIGHT-CHARS     = FRAME {&FRAME-NAME}:HEIGHT-CHARS - ghBrowse:ROW + 1
                  SEPARATORS       = TRUE
                  ROW-MARKERS      = FALSE
                  EXPANDABLE       = TRUE
                  COLUMN-RESIZABLE = TRUE
                  COLUMN-SCROLLING = TRUE
                  ALLOW-COLUMN-SEARCHING = TRUE
                  READ-ONLY        = NO
                  QUERY            = ghQuery
            /* Set procedures to handle browser events */
            TRIGGERS:            
              ON ROW-LEAVE
                 PERSISTENT RUN rowLeave        IN THIS-PROCEDURE.
              ON PAGE-UP
                 PERSISTENT RUN pageUp          IN THIS-PROCEDURE.
              ON PAGE-DOWN
                 PERSISTENT RUN pageDown        IN THIS-PROCEDURE.
              ON ANY-PRINTABLE, 
                 MOUSE-SELECT-DBLCLICK ANYWHERE
                 PERSISTENT RUN setScreenValue  IN THIS-PROCEDURE.
            end TRIGGERS.

    /* Position Apply and Clear buttons */
    ASSIGN
      buApply:COL = FRAME {&FRAME-NAME}:WIDTH-CHARS - buApply:WIDTH-CHARS - 1
      buClear:COL = FRAME {&FRAME-NAME}:WIDTH-CHARS - buApply:WIDTH-CHARS - buClear:WIDTH-CHARS - 2
      .

    /* Hide the dynamic browser while it is being constructed */
    ASSIGN
       ghBrowse:VISIBLE   = NO
       ghBrowse:SENSITIVE = NO.

    /* Add fields to browser using structure of dynamic temp table */
    DO iLoop = 1 TO 5:
      hCurField = ghBuffer:BUFFER-FIELD(iLoop).

      CASE iLoop:
        WHEN 1 THEN
          ASSIGN
            hCurField:FORMAT = "x(35)":U
            hCurField:LABEL = "Filter Field":U
            .
        WHEN 2 THEN
          ASSIGN
            hCurField:FORMAT = "x(20)":U
            hCurField:LABEL = "From Value":U
            .
        WHEN 3 THEN
          ASSIGN
            hCurField:FORMAT = "x(20)":U
            hCurField:LABEL = "To Value":U
            .
        WHEN 4 THEN
          ASSIGN
            hCurField:FORMAT = "x(20)":U
            hCurField:LABEL = "Format":U
            .
        WHEN 5 THEN
          ASSIGN
            hCurField:FORMAT = "x(20)":U
            hCurField:LABEL = "DataType":U
            .
      END CASE. /* CASE iLoop */

      hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

      /* Enable To and From columns, disable the rest */
      IF iLoop = 2 OR iLoop = 3 THEN
        ASSIGN
          hField:READ-ONLY = FALSE.
      ELSE
        ASSIGN
          hField:READ-ONLY = TRUE.

      /* Build up the list of browse columns for use in rowDisplay */
      IF VALID-HANDLE(hField) THEN
        cBrowseColHdls = cBrowseColHdls + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                         + STRING(hField).

    END. /* DO iLoop = 1 TO 5 */

    /* Lock first column of browser */
    ghBrowse:NUM-LOCKED-COLUMNS = 1.

    /* Open the query for the browser */
    ghQuery:QUERY-OPEN() NO-ERROR.

    /* Show and move focus to the browser */
    ASSIGN
       FRAME {&FRAME-NAME}:VISIBLE = FALSE
       ghBrowse:VISIBLE            = YES
       ghBrowse:SENSITIVE          = YES
       FRAME {&FRAME-NAME}:VISIBLE = TRUE
       .
    APPLY "ENTRY":U TO ghBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super override
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Clean up dynamic object handles */
    DELETE OBJECT ghBrowse NO-ERROR.
    ASSIGN ghBrowse = ?.
    DELETE OBJECT ghQuery NO-ERROR.
    ASSIGN ghQuery = ?.
    DELETE OBJECT ghTable NO-ERROR.
    ASSIGN ghTable = ?.

    RUN SUPER.

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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Sets subscriptions to some standard published events.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource            AS HANDLE     NO-UNDO.

  /* Get handle of container, then get toolbar source of container to determine the containers toolbar.
     We then subscribe this procedure to toolbar events in the containers toolbar so
     that we can action an OK or CANCEL being pressed in the toolbar. */  

  /* Ignore if running in the AppBuilder */
  &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN

    /* Get container handle */
    {get ContainerSource hContainerSource}.

    /* Get handle to toolbar of the container */
    cLinkHandles   = DYNAMIC-FUNCTION('linkHandles' IN hContainerSource, 'Toolbar-Source').
    hToolbarSource = WIDGET-HANDLE(ENTRY(1,cLinkHandles)). 

    IF VALID-HANDLE(hToolBarSource) THEN
    DO:
        /* Subscribe this procedure to 'toolbar' event published by the toolbar of the container */
        SUBSCRIBE PROCEDURE THIS-PROCEDURE  TO 'toolbar'     IN hToolbarSource.

        /* Subscribe this procedure to 'updateState' event published by this same procedure */
        SUBSCRIBE PROCEDURE THIS-PROCEDURE  TO 'upDateState' IN THIS-PROCEDURE.

        /* Subscrive the toolbar of the container to 'updateState' published by the toolbar of the container */
        SUBSCRIBE PROCEDURE  hToolbarSource TO 'updateState' IN THIS-PROCEDURE.


    END. /* IF VALID-HANDLE(hToolBarSource) */

    /* Subscribe this procedure to the event which builds the browser */    
    IF VALID-HANDLE(hContainerSource) THEN
       SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'buildFilters' IN hContainerSource.

  &ENDIF  

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pageDown sObject 
PROCEDURE pageDown :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'PAGE-DOWN' browser event
  Parameters:  <none>
  Notes:       Not implemented (yet!)
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pageUp sObject 
PROCEDURE pageUp :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'PAGE-UP' browser event
  Parameters:  <none>
  Notes:       Not implemented (yet!)
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:    Resize the viewer
  Parameters: pd_height AS DECIMAL - the desired height (in rows)
              pd_width  AS DECIMAL - the desired width (in columns)
    Notes:    Used internally. Calls to resizeObject are generated by the
              AppBuilder in adm-create-objects for objects which implement it.
              Having a resizeObject procedure is also the signal to the AppBuilder
              to allow the object to be resized at design time.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.

  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.

  /* Get container and window handles */
  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  /* Save hidden state of current frame, then hide it */
  FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.                                               
  lPreviouslyHidden = FRAME {&FRAME-NAME}:HIDDEN.                                                           
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.

  /* Resize frame relative to containing window size */
  FRAME {&FRAME-NAME}:HEIGHT-PIXELS = SESSION:PIXELS-PER-ROW * pdHeight.
  FRAME {&FRAME-NAME}:WIDTH-PIXELS  = SESSION:PIXELS-PER-COL * pdWidth.

  /* Resize dynamic browser (if exists) relative to current frame */
  IF VALID-HANDLE(ghBrowse) THEN
  DO:
    ghBrowse:WIDTH-CHARS  = FRAME {&FRAME-NAME}:WIDTH-CHARS     - 3.
    ghBrowse:HEIGHT-CHARS = FRAME {&FRAME-NAME}:HEIGHT-CHARS - ghBrowse:ROW + 1.
  END.

  /* Position Apply and Clear buttons */
  ASSIGN
    buApply:COL = FRAME {&FRAME-NAME}:WIDTH-CHARS - buApply:WIDTH-CHARS - 1
    buClear:COL = FRAME {&FRAME-NAME}:WIDTH-CHARS - buApply:WIDTH-CHARS - buClear:WIDTH-CHARS - 2
    .

  /* Restore original hidden state of current frame */
  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave sObject 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'ROW-LEAVE' browser event
  Parameters:  <none>
  Notes:       Assigns column screen values of the current record in the browser
               to the corresponding temp table buffer fields
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hCol                      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.

    /* if current record in browse has been modified */
    IF ghBrowse:CURRENT-ROW-MODIFIED THEN
    DO:
       /* for each column in the browse */
       REPEAT iLoop = 1 TO ghBrowse:NUM-COLUMNS:
          hCol = ghBrowse:GET-BROWSE-COLUMN(iLoop).

          /* If modified then assign column screen value to corresponding temp table buffer field */
          IF hCol:MODIFIED THEN
          DO:
              hField = hCol:BUFFER-FIELD.
              IF VALID-HANDLE(hField) THEN
                  hField:BUFFER-VALUE = hCol:SCREEN-VALUE.
          END.

       END. /* REPEAT */
    END. /* IF ghBrowse:CURRENT-ROW-MODIFIED */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScreenValue sObject 
PROCEDURE setScreenValue :
/*------------------------------------------------------------------------------
  Purpose:     Sets screen values for columns in the browser for given UI events
               Also sets modified state
  Parameters:  <none>
  Notes:       For logical columns, the user may mouse-double-click to toggle YES and NO,
               or type 'Y' or 'N'.
               This approach needs rework as there is a lot of specific hard-coding.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hCurrentField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataTypeField       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCurrentColumn       AS HANDLE    NO-UNDO.

  /* If a record is available in browser */
  IF ghBuffer:AVAILABLE THEN
  DO:
     /* Gat handle to data type column of filter browser */
     hDataTypeField = ghBuffer:BUFFER-FIELD('cFieldDataType':U).

     /* If the current column in the browser is of a logical data type */
     IF hDataTypeField:BUFFER-VALUE = 'LOGICAL':U THEN
     DO:

         /* Get handle of current column and handle of corresponding buffer field in the temp table */
         ASSIGN
            hCurrentColumn      = ghBrowse:CURRENT-COLUMN
            hCurrentField       = hCurrentColumn:BUFFER-FIELD
            .

         /* Toggle YES/NO screen value if mouse is double clicked */         
         IF LAST-EVENT:FUNCTION EQ 'mouse-select-dblclick':U THEN
         DO:
             IF hCurrentColumn:SCREEN-VALUE EQ 'YES' THEN
                 ASSIGN
                    hCurrentColumn:SCREEN-VALUE = 'NO'.
             ELSE IF hCurrentColumn:SCREEN-VALUE EQ 'NO' THEN
                 ASSIGN
                    hCurrentColumn:SCREEN-VALUE = 'YES'.
         END. /* IF LAST-EVENT:FUNCTION EQ 'mouse-select-dblclick':U */
         ELSE 
         /* Process 'Y' key press */
         IF LAST-EVENT:LABEL EQ 'Y' THEN
              hCurrentColumn:SCREEN-VALUE = 'YES'.
         ELSE 
         /* Process 'Y' key press */
         IF LAST-EVENT:LABEL EQ 'N' THEN
                hCurrentColumn:SCREEN-VALUE = 'NO'.

         /* Assign screen value to temp table buffer */
         hCurrentField:BUFFER-VALUE  = hCurrentColumn:SCREEN-VALUE.

         /* Return without processing the original browser event */
         RETURN NO-APPLY.

     END. /* IF hDataTypeField:BUFFER-VALUE = 'LOGICAL':U */

  END. /* IF ghBuffer:AVAILABLE */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFilter sObject 
PROCEDURE validateFilter :
/*------------------------------------------------------------------------------
  Purpose:     Validate filter settings
  Parameters:  output flag indicating if the filter settings are valid or not
  Notes:       Checks that the values entered comply with the data type of the
               columns on the source browser
               Checks that From values are less than or equal to To values
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER lOk AS LOGICAL NO-UNDO.

    DEFINE VARIABLE cErrorMessage   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cButton         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE dDecimal        AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE tDateFrom       AS DATE         NO-UNDO.
    DEFINE VARIABLE tDateTo         AS DATE         NO-UNDO.

    /* Initialise result to valid */
    ASSIGN lOk = YES.

    /* for each record in the filter settings temp table */
    filter-loop:
    FOR EACH ttLookFilt:

      /* if a From or To value has been entered */
      IF ttLookFilt.cFromValue <> "":U OR ttLookFilt.cToValue <> "":U THEN
      DO:

        CASE ttLookFilt.cFieldDataType:
          WHEN "decimal":U OR WHEN "integer":U THEN
          DO:
            /* Use ASSIGN statement with NO-ERROR to catch data type exception */
            ASSIGN 
                dDecimal = DECIMAL(ttLookFilt.cFromValue)
                dDecimal = DECIMAL(ttLookFilt.cToValue) 
                NO-ERROR.    
            IF  ERROR-STATUS:ERROR THEN
            DO:
              ASSIGN
                  cErrorMessage = "Invalid data type for " + ttLookFilt.cFieldName + ".  Should be " + ttLookFilt.cFieldDataType + "."
                  lOk           = NO.
            END.
            ELSE
            /* From and To value range check */
            IF  ttLookFilt.cToValue <> "":U
            AND DECIMAL(ttLookFilt.cFromValue) > DECIMAL(ttLookFilt.cToValue) THEN
              ASSIGN
                  cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
                  lOk           = NO.
          END. /* WHEN "decimal":U OR WHEN "integer":U */

          WHEN "date":U THEN
          DO:
            /* Use ASSIGN statement with NO-ERROR to catch data type exception */
            ASSIGN 
                tDateFrom = DATE(ttLookFilt.cFromValue)
                tDateTo   = DATE(ttLookFilt.cToValue) 
                NO-ERROR.    
            IF  ERROR-STATUS:ERROR
            OR  (tDateFrom = ? AND ttLookFilt.cFromValue <> "")
            OR  (tDateTo = ?   AND ttLookFilt.cToValue   <> "":U) THEN
            DO:
              ASSIGN
                  cErrorMessage = "Invalid data type for " + ttLookFilt.cFieldName + ".  Should be " + ttLookFilt.cFieldDataType + "."
                  lOk           = NO.    
            END.
            /* From and To value range check */
            ELSE IF  ttLookFilt.cToValue <> "":U
            AND DATE(ttLookFilt.cFromValue) > DATE(ttLookFilt.cToValue) THEN
              ASSIGN
                  cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
                  lOk = NO.
          END. /* WHEN "date":U */

          OTHERWISE
          DO: /* character, &c. */

            /* Valid From and To value range check */
            IF  ttLookFilt.cToValue <> "":U
            AND ttLookFilt.cFromValue > ttLookFilt.cToValue THEN
              ASSIGN
                  cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value '" "'the from value'"}
                  lOk           = NO.
          END.

        END CASE. /* CASE ttLookFilt.cFieldDataType */

      END. /* IF ttLookFilt.cFromValue <> "":U OR ttLookFilt.cToValue <> "":U */

      /* Leave the loop if a check had failed */
      IF NOT lOk THEN LEAVE filter-loop.

    END.  /* filter-loop: FOR EACH ttLookFilt */

    IF NOT lOk THEN
    DO:
      RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,    /* messages */
                                             INPUT  "":U,             /* type */
                                             INPUT  "OK":U,           /* button list */
                                             INPUT  "OK":U,           /* default */
                                             INPUT  "OK":U,           /* cancel */
                                             INPUT  "":U,             /* title */
                                             INPUT  YES,              /* disp. empty */
                                             INPUT  ?,                /* container handle */
                                             OUTPUT cButton           /* button pressed */
                                            ).
    END. /* IF NOT lOk */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject sObject 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(ghBrowse) THEN
  DO:
      DELETE OBJECT ghBrowse.
      ghBrowse = ?.
  END.

  RUN SUPER.

  /* Build the filter browser upon view */
  RUN buildFilters.

  /* Reposition to first record in browser and then move focus to browser */
  IF VALID-HANDLE(ghBrowse) THEN
  DO:
     ghBrowse:REPOSITION-TO-ROW(1) NO-ERROR.
     APPLY "ENTRY":U TO ghBrowse.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

