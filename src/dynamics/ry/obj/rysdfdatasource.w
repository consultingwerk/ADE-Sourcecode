&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: dynlookup.w 

  Description: from FIELD.W - Template for ADM2 SmartDataField object

  Created: Astra2 Object - November 2000 -- Progress Version 9.1B
           Uses new Astra2 lookup class

    Modified    : 30/07/2001      Mark Davies
                  Frame should not be movable in run-time.
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

&IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF

  &IF "{&xcTranslatableProperties}":U NE "":U &THEN
    &GLOB xcTranslatableProperties {&xcTranslatableProperties},
  &ENDIF
  &GLOB xcTranslatableProperties {&xcTranslatableProperties}~
SelectionLabel,OptionalString

&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adeuib/_dynamiclookupd.w
&ENDIF
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject
{src/adm2/ttlookup.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frLookup

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createDataTableCombo sObject 
FUNCTION createDataTableCombo RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frLookup
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.2 BY 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataField
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
         HEIGHT             = 1
         WIDTH              = 62.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/lookup.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frLookup
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frLookup:SCROLLABLE       = FALSE
       FRAME frLookup:HIDDEN           = TRUE
       FRAME frLookup:SELECTABLE       = TRUE
       FRAME frLookup:MOVABLE          = TRUE
       FRAME frLookup:RESIZABLE        = TRUE
       FRAME frLookup:PRIVATE-DATA     = 
                "nolookups".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frLookup
/* Query rebuild information for FRAME frLookup
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frLookup */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frLookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frLookup sObject
ON SELECTION OF FRAME frLookup
DO:
  DEFINE VARIABLE cMode AS CHARACTER  NO-UNDO.
  
  {get UIBMode cMode}.
  IF cMode = "":U THEN /* Run Time */
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frLookup sObject
ON START-MOVE OF FRAME frLookup
DO:
  DEFINE VARIABLE cMode AS CHARACTER  NO-UNDO.
  
  {get UIBMode cMode}.
  IF cMode = "":U THEN /* Run Time */
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataTableValueChanged sObject 
PROCEDURE dataTableValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cNewDisplayValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldKeyValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewKeyValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnValues           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnNames            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldDisplayValue        AS CHARACTER  NO-UNDO.

  {get ContainerSource hContainer}.

  {get DisplayValue cOldDisplayValue}.

  PUBLISH "lookupComplete":U FROM hContainer (INPUT '',        /* CSV of fields specified */
                                              INPUT '',       /* CHR(1) delim list of all the values of the above columns */
                                              INPUT SELF:INPUT-VALUE,        /* the key field value of the selected record */
                                              INPUT SELF:INPUT-VALUE,    /* the value displayed on screen (may be the same as the key field value ) */
                                              INPUT cOldDisplayValue,    /* the old value displayed on screen (may be the same as the key field value ) */
                                              INPUT YES,                 /* YES = lookup browser used, NO = manual value entered */
                                              INPUT TARGET-PROCEDURE     /* Handle to lookup - use to determine which lookup has been left */
                                            ). 

  {set dataValue SELF:INPUT-VALUE}.
  {set DisplayValue SELF:INPUT-VALUE}.

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
  HIDE FRAME frLookup.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose: Override of initializeObject in order to create a combo if the 
           viewer is linked to a dataview.
  Notes:    
---------------------------------------------------------------------------*/

  DEFINE VARIABLE cUIBMode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataViewSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListtables           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable                AS CHARACTER  NO-UNDO.

  {get ContainerSource hContainer}. /* SDV */    
  {get UIBMode cUIBMode}.    
  
  /* Check if the viewer is using a Dataview */
  IF VALID-HANDLE(hcontainer) THEN
    {get DataViewSource hDataViewSource hContainer}.
  
  RUN SUPER.

  /* tables that are part of the viewers view, except the actual table
     the viewer is working on can be selected for the combo */  
  IF VALID-HANDLE(hDataViewSource) THEN
  DO:
    hCombo = {fn createDataTablecombo}.
    {get DataTable cDataTable hDataViewSource}.
    {get ViewTables cListTables hDataViewSource}.
    DO i = 1 TO NUM-ENTRIES(cListTables):
      cTable = ENTRY(i,cListTables).
      IF cTable <> cDataTable THEN
        hCombo:ADD-LAST(cTable). 
    END.
    hCombo:INNER-LINES = MAX(10,hCombo:NUM-ITEMS).
  END.
  ELSE 
    RUN initializeLookup IN TARGET-PROCEDURE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Resize the Lookup      
  Parameters:  INPUT pidHeight decimal New height of component 
               INPUT pidWidth decimal New widtht of component.
  Notes:  The procedure deletes the current widget,
          Resizes the frame and recreates the widget.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pidWidth  AS DECIMAL NO-UNDO.

  DEFINE VARIABLE hFrame        AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hLookup       AS HANDLE   NO-UNDO.
  
  {get LookupHandle hLookup}.
  IF VALID-HANDLE(hLookup) AND hLookup:TYPE = 'combo-box' THEN
  DO:
    {get ContainerHandle hFrame}.
    ASSIGN hFrame:SCROLLABLE            = TRUE
           hFrame:WIDTH-CHARS           = pidWidth
           hFrame:HEIGHT-CHARS          = pidHeight
           hFrame:VIRTUAL-WIDTH-CHARS   = hFrame:WIDTH-CHARS
           hFrame:VIRTUAL-HEIGHT-CHARS  = hFrame:HEIGHT-CHARS
           hFrame:SCROLLABLE            = FALSE
           hLookup:WIDTH-PIXELS         = hFrame:WIDTH-PIXELS.
  END.
  ELSE 
    RUN SUPER(pidHeight,pidWidth).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createDataTableCombo sObject 
FUNCTION createDataTableCombo RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCombo         AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hFrame         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTooltip       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFormat AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.

  {get ContainerHandle hFrame}.
  {get FieldToolTip cToolTip}.
  {get DisplayFormat cDisplayFormat}.
  {get FieldLabel cLabel}.

  CREATE COMBO-BOX hCombo
          ASSIGN SORT             = TRUE
                 NAME             = "fiLookup" 
                 FORMAT           = "x(80)" 
                 WIDTH-PIXELS     = hFrame:WIDTH-PIXELS
                 FRAME            = hFrame
                 HIDDEN           = FALSE 
                 SENSITIVE        = FALSE
    TRIGGERS:
        ON 'VALUE-CHANGED':U 
          PERSISTENT RUN dataTableValueChanged IN TARGET-PROCEDURE. 
    END.

  {set LookupHandle hcombo}.
  IF cLabel NE "":U THEN
     {fnarg createLabel 'DataTable':T}. 

  hCombo:MOVE-TO-BOTTOM().
  hCombo:TOOLTIP = cToolTIP.

  RETURN hCombo.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

