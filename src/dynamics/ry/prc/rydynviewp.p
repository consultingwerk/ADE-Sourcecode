&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: rydynviewp.p

  Description:  Dynamic Viewer Super Procedure

  Purpose:      Dynamic Viewer Super Procedure. Contains code for dynamic viewers.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   01/23/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynviewp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Tell *attr.i that this is a Super procedure. */
&SCOP ADMSuper rydynviewp.p

/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

{ry/app/rydynviewi.i}

{launch.i &define-only = YES }

DEFINE VARIABLE gcDefaultAttributes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghRenderingQuery    AS HANDLE     NO-UNDO.

/* These handles store the buffers of the cacheObject, cachePage and cacheLink
 * temp-tables in the Repository Manager. We use these to build the objects.
 * These are global variables since this is more efficient that re-fetching the,
 * every time they are needed, and also the tables in the cache don't change (even
 * though the contents of those tables change).
 */
DEFINE VARIABLE ghCacheObject            AS HANDLE                NO-UNDO.
DEFINE VARIABLE ghCachePage              AS HANDLE                NO-UNDO.
DEFINE VARIABLE ghCacheLink              AS HANDLE                NO-UNDO.

&SCOPED-DEFINE Value-Delimiter CHR(1)

/* These are the default attributes which are stored in the ttWidget temp-table. These
 * attributes must not be duplicated in any of the widget type temp-tables.
*/
ASSIGN gcDefaultAttributes = "LABEL,FORMAT,ROW,COLUMN,X,Y,PRIVATE-DATA,FONT,TOOLTIP,SENSITIVE,VISIBLE,HIDDEN,":U
                           + "HEIGHT,HEIGHT-PIXELS,HEIGHT-CHARS,WIDTH,WIDTH-PIXELS,WIDTH-CHARS,DATA-TYPE,FRAME,":U
                           + "NAME,SIDE-LABEL-HANDLE,PARENT,SCREEN-VALUE,MODIFIED,":U.

/** This pre-processor is used to save space, since the section editor limits
 *  are exceeded when this code is included, as it is repeated for each event
 *  that is added. This pre-processor is used in createUiEvents.
 *  ----------------------------------------------------------------------- **/
&SCOPED-DEFINE RUN-PROCESS-EVENT-PROCEDURE ~
RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ENTRY((4 * iLoop + 1)    , pcEventValues, {&Value-Delimiter}),  /* RUN/PUBLISH */~
                                                INPUT ENTRY((4 * iLoop + 1) + 2, pcEventValues, {&Value-Delimiter}),  /* The procedure to RUN or PUBLISH */~
                                                INPUT ENTRY((4 * iLoop + 1) + 1, pcEventValues, {&Value-Delimiter}),  /* SELF,CONTAINER,ANYWHERE */ ~
                                                INPUT ENTRY((4 * iLoop + 1) + 3, pcEventValues, {&Value-Delimiter}) ) /* Parameters */
                                                

DEFINE VARIABLE gcErrorMessage AS CHARACTER  NO-UNDO.

/* This variable should NEVER be accessed directly; it should always be 
   accessed using the {getCurrentLogicalName} and {setCurrentLogicalName} 
   functions.
 */
define variable gcCurrentLogicalName             as character            no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-setFieldWidgetIDs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldWidgetIDs Procedure
FUNCTION setFieldWidgetIDs RETURNS LOGICAL 
	(INPUT pcFieldWidgetIDs AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldWidgetIDs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldWidgetIDs Procedure
FUNCTION getFieldWidgetIDs RETURNS CHARACTER 
	(  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-assignRadioSetWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignRadioSetWidth Procedure 
FUNCTION assignRadioSetWidth RETURNS DECIMAL
  ( pcRadioButtons AS CHARACTER,
    piFont         AS INTEGER,
    plHorizontal   AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createWidgetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createWidgetEvents Procedure 
FUNCTION createWidgetEvents RETURNS LOGICAL
    ( INPUT phWidget            AS HANDLE,
      INPUT pcEventNames                AS CHARACTER,
      INPUT pcEventValues               AS CHARACTER           )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyWidgets Procedure 
FUNCTION destroyWidgets RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupHandle Procedure 
FUNCTION getPopupHandle RETURNS HANDLE
    ( INPUT phWidgetHandle      AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidgetTableBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetTableBuffer Procedure 
FUNCTION getWidgetTableBuffer RETURNS HANDLE
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentLogicalName Procedure 
FUNCTION setCurrentLogicalName RETURNS LOGICAL
        ( input pcCurrentLogicalName        as character ) FORWARD.

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
         HEIGHT             = 15.57
         WIDTH              = 53.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
CREATE QUERY ghRenderingQuery.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-assignPopupWidgetID) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignPopupWidgetID Procedure
PROCEDURE assignPopupWidgetID:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phField AS HANDLE  NO-UNDO.
DEFINE INPUT  PARAMETER phPopup AS HANDLE  NO-UNDO.

DEFINE VARIABLE cWidgetIDs     AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iObject  AS INTEGER    NO-UNDO.
DEFINE VARIABLE hObject  AS HANDLE     NO-UNDO.

{get FieldWidgetIDs cWidgetIDs}.

    ASSIGN iObject = LOOKUP(phField:NAME, cWidgetIDs).

    IF iObject GT 0 THEN
        ASSIGN phPopup:WIDGET-ID = INT(ENTRY(iObject + 1, cWidgetIDs)) + 2 NO-ERROR.

RETURN.

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF 
&IF DEFINED(EXCLUDE-assignWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignWidgetID Procedure
PROCEDURE assignWidgetID:
/*------------------------------------------------------------------------------
    Purpose: Assign widget-ids for the viewer fields.

    Parameters:
        pcWidgetID: comma separated list with the field names and
                    their widget-ids

    Notes: For Dynamic viewers the field widget-ids are stored in the XML file.
           AssignWidgetIDs in containr.p collects those widget-id values from
           the XML file, and then calls this procedure passing those widget-ids
           in the input parameter.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phField AS HANDLE  NO-UNDO.

DEFINE VARIABLE cWidgetIDs     AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iObject  AS INTEGER    NO-UNDO.
DEFINE VARIABLE hObject  AS HANDLE     NO-UNDO.

{get FieldWidgetIDs cWidgetIDs}.

    ASSIGN iObject = LOOKUP(phField:NAME, cWidgetIDs).

    IF iObject GT 0 THEN
        ASSIGN phField:WIDGET-ID = INT(ENTRY(iObject + 1, cWidgetIDs)) NO-ERROR.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeFrameSizeAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFrameSizeAttributes Procedure 
PROCEDURE changeFrameSizeAttributes :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piPageNumber   AS INTEGER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdFrameHeight  AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pdFrameWidth   AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE dFrameMinWidth              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dFrameMinHeight             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hContainerSource            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.    
    DEFINE VARIABLE hDefaultFrame               AS HANDLE               NO-UNDO.

    &SCOPED-DEFINE xp-assign
    {get ContainerSource hContainerSource}
    {get ContainerHandle hDefaultFrame}
    {get MinHeight dFrameMinHeight}
    {get MinWidth  dFrameMinWidth}.
    &UNDEFINE xp-assign
    
    /* Update the Frame MinWidth and Frame MinHeight.
    * We don't particularly care of there are errors
    * here, since we can update the records at a later
    * stage.                                         */
    IF dFrameMinHeight <> pdFrameHeight THEN 
        {set MinHeight pdFrameHeight}.
    
    IF dFrameMinWidth <> pdFrameWidth THEN
        {set MinWidth pdFrameWidth}.

    /* There is no need to pack here because the window that this
       viewer is on will be packed by either the page instantiation or
       by the object instantiation. As long as the frame's size and attributes
       are correct, there should be no problems.
     */
     
    /* Our window should now be sized correctly, so we can size the frame now as well */
    ASSIGN hDefaultFrame:SCROLLABLE     = YES
           hDefaultFrame:WIDTH          = pdFrameWidth
           hDefaultFrame:HEIGHT         = pdFrameHeight           
           hDefaultFrame:VIRTUAL-WIDTH  = hDefaultFrame:WIDTH
           hDefaultFrame:VIRTUAL-HEIGHT = hDefaultFrame:HEIGHT
           hDefaultFrame:SCROLLABLE     = NO
           ERROR-STATUS:ERROR   = NO.
    RETURN.
END PROCEDURE.  /* changeFrameSizeAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose: Renders the viewer widgets from the repository cache.
    Notes: 
------------------------------------------------------------------------------*/
    /* Because we want all our code inline, we end up blowing section editor limits */
    {ry/prc/rydynvcroi.i}
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.    /* createObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:        
------------------------------------------------------------------------------*/
    DYNAMIC-FUNCTION("destroyWidgets":U  IN TARGET-PROCEDURE).

    RUN SUPER.
    
    DELETE OBJECT ghRenderingQuery NO-ERROR.
    ASSIGN ghRenderingQuery   = ?
           ERROR-STATUS:ERROR = NO.
    
    RETURN.
END PROCEDURE.  /* destroyObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable_UI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Procedure  _DEFAULT-DISABLE
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

&ENDIF

&IF DEFINED(EXCLUDE-displayObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayObjects Procedure 
PROCEDURE displayObjects :
/*------------------------------------------------------------------------------
  Purpose:  Sets the initial (on viewer instantiation) value for various widgets.
    Notes:  * Only widgets that are not dataobject-based will have their initial
              values displayed.
            * MODIFIED needs to be set to false for widgets where screen-value
              is being set because this does not get done for all widget types
              when the widget is enabled.  
            * The value in the InitialValue attribute/field is assumed to be the
              key value in cases where there is a key and display value, like 
              combos and DynLookups.
            * Called from datavis.p initializeObject.  
------------------------------------------------------------------------------*/
    FOR EACH ttWidget WHERE
             ttWidget.tTargetProcedure = TARGET-PROCEDURE AND
             ttWidget.tVisible         = TRUE             AND
             ttWidget.tInitialValue   <> "":U             AND
             ttWidget.tInitialValue   <> ?
             BY ttWidget.tTabOrder:
        IF ttWidget.tWidgetType EQ "SmartDataField":U AND
           {fn getLocalField ttWidget.tWidgetHandle}  THEN
            RUN assignNewValue IN ttWidget.tWidgetHandle
                             ( INPUT ttWidget.tInitialValue,
                               INPUT "":U,              /* pcDisplayedValue */
                               INPUT NO   ) NO-ERROR.   /* plSetModified */
        ELSE
        IF CAN-SET(ttWidget.tWidgetHandle, "SCREEN-VALUE":U)         AND
           ttWidget.tTableName EQ "":U THEN
        DO:
          ASSIGN ttWidget.tWidgetHandle:SCREEN-VALUE = ttWidget.tInitialValue.
          IF CAN-SET(ttWidget.tWidgetHandle, "MODIFIED":U) THEN
            ttWidget.tWidgetHandle:MODIFIED = NO.
        END.  /* if can set screen-value and tablename not set */
    END.    /* all objects */
    
    RETURN.
END PROCEDURE.  /* displayObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/    

    IF NOT {fn getObjectsCreated} THEN
       RUN createObjects IN TARGET-PROCEDURE.
    
    RUN SUPER.

    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionWidgetForTranslation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionWidgetForTranslation Procedure 
PROCEDURE repositionWidgetForTranslation :
/*------------------------------------------------------------------------------
  Purpose:     If widgets have been translated, this procedure will check if 
               widgets need to be repositioned and do so if necessary.  It will
               also check for translated RADIO-BUTTONs and update the RADIO-SET
               width if necessary.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER pdFrameWidth AS DECIMAL NO-UNDO.
     
    DEFINE VARIABLE cJunk              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lJunk              AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE dColsToAdd         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cFieldPopupMapping AS CHARACTER  NO-UNDO INITIAL ?.
    DEFINE VARIABLE iEntry             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hPopup             AS HANDLE     NO-UNDO.
    DEFINE VARIABLE dWidgetWidth       AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dSDFCol            AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dLabelWidth        AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lOverlap           AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cSDFLabel          AS CHARACTER  NO-UNDO.

    DEFINE BUFFER bMove_Widget FOR ttWidget.
    DEFINE BUFFER btWidget     FOR ttWidget.
    
    /* Check translated widgets and make sure their labels fit into the viewer *
     * and that they don't overlap with other widgets.                         */
    widget-blk:
    FOR EACH ttWidget
       WHERE ttWidget.tTargetProcedure = TARGET-PROCEDURE
         AND ttWidget.tTranslated      = YES
          BY ttWidget.tColumn
          BY ttWidget.tRow:
              
        IF NOT ttWidget.tVisible
        OR ttWidget.tWidgetType = "BUTTON":U THEN /* Buttons don't reposition because of translation */
            NEXT widget-blk.
        
        /* Make sure radio sets are sized correctly. If they have been translated, their width attribute *
         * will not reflect the translated radio-set width.                                              */
        CASE ttWidget.tWidgetType:
            WHEN "RADIO-SET":U 
            THEN DO:
                ASSIGN dWidgetWidth = DYNAMIC-FUNCTION("assignRadioSetWidth":U IN TARGET-PROCEDURE, 
                                                       ttWidget.tWidgetHandle:RADIO-BUTTONS,
                                                       ttWidget.tFont,
                                                       ttWidget.tWidgetHandle:HORIZONTAL).
                IF dWidgetWidth > ttWidget.tWidth
                THEN DO:
                    ASSIGN ttWidget.tWidth = dWidgetWidth + 2.4
                           pdFrameWidth    = MAXIMUM(pdFrameWidth, ttWidget.tColumn + ttWidget.tWidth).

                    IF VALID-HANDLE(ttWidget.tWidgetHandle) THEN
                        ASSIGN ttWidget.tWidgetHandle:WIDTH = ttWidget.tWidth NO-ERROR.
                END.
            END.

            WHEN "TOGGLE-BOX":U THEN
                ASSIGN ttWidget.tWidth = ttWidget.tWidgetHandle:WIDTH
                       pdFrameWidth    = MAXIMUM(pdFrameWidth, ttWidget.tColumn + ttWidget.tWidth).
        END CASE.    /* WIDGET TYPE */
                
        /* Determine what the label width is */
        IF ttWidget.tWidgetType = "smartDataField":U  
        THEN DO:
            {get fieldLabel cSDFLabel ttWidget.tWidgetHandle}.
            ASSIGN dLabelWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cSDFLabel, ttWidget.tFont).
        END.
        ELSE
            ASSIGN dLabelWidth = IF CAN-QUERY(ttWidget.tWidgetHandle, "SIDE-LABEL-HANDLE":U)
                                 AND VALID-HANDLE(ttWidget.tWidgetHandle:SIDE-LABEL-HANDLE)
                                 THEN ttWidget.tWidgetHandle:SIDE-LABEL-HANDLE:WIDTH
                                 ELSE 0.
        /* First check if this widget is going to render over any widgets to the left */
        ASSIGN lOverlap = NO.
        fe-blk:
        FOR EACH btWidget 
           WHERE btWidget.tTargetProcedure = TARGET-PROCEDURE
             AND btWidget.tColumn     < ttWidget.tColumn:

            IF NOT btWidget.tVisible THEN
                NEXT fe-blk.
             
            /* This widget starts between the other widgets start and end row */
            IF (ttWidget.tRow + .3 >= btWidget.tRow AND ttWidget.tRow + .3 <= btWidget.tEndRow)
               /* This widget ends between the other widgets start and end row */
               OR (ttWidget.tEndRow - .3 >= btWidget.tRow AND ttWidget.tEndRow - .3 <= btWidget.tEndRow)
               /* This widget starts above the other widget and ends below it */
               OR (ttWidget.tRow <= btWidget.tRow AND ttWidget.tEndRow >= btWidget.tEndRow)
            THEN DO:  
              /* Check if the two widgets overlap */
               IF btWidget.tColumn + btWidget.tWidth > ttWidget.tColumn - dLabelWidth
               THEN DO:
                  /* If rectangle, only move widgets so they don't overlap left side of rectangle */
                  IF btWidget.tWidgetType = "RECTANGLE":U THEN 
                     ASSIGN dColsToAdd       = MAX(0,btWidget.tColumn  + dLabelWidth + 2.4 - ttWidget.tColumn)
                            lOverlap         = YES.    
                  ELSE   
                  /* Move everything on this column and greater to the right */
                     ASSIGN dColsToAdd = (btWidget.tColumn + btWidget.tWidth + dLabelWidth + 2.4) - ttWidget.tColumn
                            lOverlap   = YES.
                           
                  /* All widgets on the same column or on columns to the right need to move now as well */
                  FOR EACH bmove_Widget
                     WHERE bmove_Widget.tTargetProcedure = TARGET-PROCEDURE
                       AND bmove_Widget.tColumn         >= ttWidget.tColumn:

                      ASSIGN bmove_Widget.tColumn = bmove_Widget.tColumn + dColsToAdd
                             pdFrameWidth         = MAXIMUM(pdFrameWidth, bmove_Widget.tColumn + bmove_Widget.tWidth).
                  END.
                  
                  /* Increase width of rectangles that are contained within translated widget */
                  FOR EACH bmove_Widget
                     WHERE bmove_Widget.tTargetProcedure = TARGET-PROCEDURE
                       AND bmove_Widget.tWidgetType      = "RECTANGLE":U:

                     IF bMove_Widget.tColumn  < ttWidget.tColumn 
                         AND bMove_Widget.tColumn + bMove_Widget.tWidth + dColsToAdd > ttWidget.tColumn + ttWidget.tWidth THEN
                        ASSIGN bMove_Widget.tWidth                    = bMove_Widget.tWidth + dColsToAdd   
                               bMove_Widget.tWidgetHandle:WIDTH-CHARS = bMove_Widget.tWidth
                               pdFrameWidth                           = MAXIMUM(pdFrameWidth, bMove_Widget.tColumn + bMove_Widget.tWidth).
                  END.      
               END. /* If widget overlaps */  
            END. /* If widget's row is within translated widget's row */
        END.  /* For each Widget whose column is less than translated column */
        
        /* If we didn't get overlap, then check if the label fits and move widgets if applicable */
        IF lOverlap = NO THEN
            IF ttWidget.tColumn - (dLabelWidth + 2.4) < 0
            THEN DO:
                ASSIGN dColsToAdd = dLabelWidth + 2.4 - ttWidget.tColumn.

                /* All widgets on the same column or on columns to the right need to move now as well */
                FOR EACH bmove_Widget
                   WHERE bmove_Widget.tTargetProcedure = TARGET-PROCEDURE:
                   
                      ASSIGN bmove_Widget.tColumn = bmove_Widget.tColumn + dColsToAdd
                             pdFrameWidth         = MAXIMUM(pdFrameWidth, bmove_Widget.tColumn + bmove_Widget.tWidth).
                END.
            END.
    END.

    /* Check if we're exceeding session boundaries. */
    IF pdFrameWidth > (SESSION:WIDTH - 5) 
    THEN DO:
        /* If the new size causes the viewer to be larger than the session's max width
         * we need to trim the translations down a bit */
        RUN afmessagep IN gshSessionManager
                        (INPUT {aferrortxt.i 'RY' '21'},
                         INPUT "YES":U,
                         INPUT "":U,
                         OUTPUT cJunk,
                         OUTPUT gcErrorMessage, /* gcErrorMessage will be checked by createObjects, and the message displayed if necessary */
                         OUTPUT cJunk,
                         OUTPUT cJunk,
                         OUTPUT lJunk,
                         OUTPUT lJunk).
        RETURN.
    END.

    /* Right, we know where our widgets must go, move them. */
    FOR EACH ttWidget
       WHERE ttWidget.tTargetProcedure = TARGET-PROCEDURE:       
        IF ttWidget.tWidgetType = "smartDataField":U 
        THEN DO:
            {get COL dSDFCol ttWidget.tWidgetHandle}.
            IF dSDFCol <> ttWidget.tColumn THEN
                RUN repositionObject IN ttWidget.tWidgetHandle (INPUT ttWidget.tRow, INPUT ttWidget.tColumn) NO-ERROR.
        END.
        ELSE
            /* If the column of this widget has changed,  or the widget
               itself has been translated, then move the widget and/or label.
               
               There are cases where the label has been translated, and is now
               longer than the original label, but not so much as to cause the column
               to shift. In these cases we need to reposition the label.
             */
            IF ttWidget.tColumn <> ttWidget.tWidgetHandle:COLUMN or ttWidget.tTranslated 
            THEN DO:
                /* Move the field */
                ASSIGN dColsToAdd                    = ttWidget.tColumn - ttWidget.tWidgetHandle:COLUMN
                       ttWidget.tWidgetHandle:COLUMN = ttWidget.tWidgetHandle:COLUMN + dColsToAdd
                       NO-ERROR.

                /* Move the popup if applicable */
                IF cFieldPopupMapping = ? 
                THEN DO:
                    {get FieldPopupMapping cFieldPopupMapping}.
                END.

                ASSIGN iEntry = LOOKUP(STRING(ttWidget.tWidgetHandle), cFieldPopupMapping) + 1.
                IF iEntry > 1 THEN
                do:
                    hPopup = WIDGET-HANDLE(ENTRY(iEntry, cFieldPopupMapping)) no-error.
                    if valid-handle(hPopup) then
                        assign hPopup:COLUMN = hPopup:COLUMN + dColsToAdd
                               pdFrameWidth  = MAX(pdFrameWidth, hPopup:COLUMN + hPopup:WIDTH).
                end.
                
                /* Move the label */
                IF CAN-QUERY(ttWidget.tWidgetHandle, "SIDE-LABEL-HANDLE":U)
                AND VALID-HANDLE(ttWidget.tWidgetHandle:SIDE-LABEL-HANDLE) THEN
                    ASSIGN ttWidget.tWidgetHandle:SIDE-LABEL-HANDLE:X = ttWidget.tWidgetHandle:X
                                                                      - ttWidget.tWidgetHandle:SIDE-LABEL-HANDLE:WIDTH-PIXELS.
            END.    /* column changed or translated */
    END.    /* each widget */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */
&IF DEFINED(EXCLUDE-setFieldWidgetIDs) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldWidgetIDs Procedure
FUNCTION setFieldWidgetIDs RETURNS LOGICAL 
	(INPUT pcFieldWidgetIDs AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
{set FieldWidgetIDs pcFieldWidgetIDs}.
RETURN TRUE.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getFieldWidgetIDs) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldWidgetIDs Procedure
FUNCTION getFieldWidgetIDs RETURNS CHARACTER 
	(  ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFieldWidgetIDs AS CHARACTER  NO-UNDO.
{get FieldWidgetIDs cFieldWidgetIDs}.
RETURN cFieldWidgetIDs.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-assignRadioSetWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignRadioSetWidth Procedure 
FUNCTION assignRadioSetWidth RETURNS DECIMAL
  ( pcRadioButtons AS CHARACTER,
    piFont         AS INTEGER,
    plHorizontal   AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will determine the RADIO-SET's largest option in width
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dMaxWidth    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iRadioLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRadioOption AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dOptionWidth AS DECIMAL    NO-UNDO.
  
  IF NOT plHorizontal THEN DO:
    DO iRadioLoop = 1 TO NUM-ENTRIES(pcRadioButtons) BY 2:
      cRadioOption = ENTRY(iRadioLoop, pcRadioButtons).
      dOptionWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cRadioOption, piFont) + 2. /* to reserve space for the UI (sircle) */
      dMaxWidth = MAX(dMaxWidth,dOptionWidth).
    END.
  END.
  ELSE DO:
    dMaxWidth = 0.
    DO iRadioLoop = 1 TO NUM-ENTRIES(pcRadioButtons) BY 2:
      cRadioOption = ENTRY(iRadioLoop, pcRadioButtons).
      dOptionWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cRadioOption, piFont).
      dMaxWidth = dMaxWidth + dOptionWidth + 3.5 /* to reserve space for the UI (sircle) */.
    END.
  END.
  RETURN dMaxWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createWidgetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createWidgetEvents Procedure 
FUNCTION createWidgetEvents RETURNS LOGICAL
    ( INPUT phWidget            AS HANDLE,
      INPUT pcEventNames                AS CHARACTER,
      INPUT pcEventValues               AS CHARACTER           ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates custom events for the widget. 
    Notes:  * A Dynamics Repository is required for this API.
            * EventNames contains a comma-delimited list of names.
            * EventValues contains information as follows:
               action_type,action_target,event_action,event_parameter
               delimited by {&Value-Delimiter}    
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLoop                    AS INTEGER                NO-UNDO.
    DEFINE VARIABLE cEventName               AS CHARACTER              NO-UNDO.    
    
        /* Use a zero-based loop because it makes the determination of the entries in the
           EventValues variable eaiser to determine (there is less calculation required).
         */    
    DO iLoop = 0 TO NUM-ENTRIES(pcEventNames) - 1:
        ASSIGN cEventName = ENTRY(iLoop + 1, pcEventNames).
        
        /* Make sure that this is a valid event for the widget */
        IF VALID-EVENT(phWidget, cEventName ) THEN
        CASE cEventName:
            WHEN "ANY-KEY":U                THEN ON ANY-KEY                OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "ANY-PRINTABLE":U          THEN ON ANY-PRINTABLE          OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "BACK-TAB":U               THEN ON BACK-TAB               OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "BACKSPACE":U              THEN ON BACKSPACE              OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "BELL":U                   THEN ON BELL                   OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "CHOOSE":U                 THEN ON CHOOSE                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "CLEAR":U                  THEN ON CLEAR                  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DEFAULT-ACTION":U         THEN ON DEFAULT-ACTION         OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DEL":U                    THEN ON DEL                    OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DELETE-CHAR":U            THEN ON DELETE-CHAR            OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DELETE-CHARACTER":U       THEN ON DELETE-CHARACTER       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DESELECT":U               THEN ON DESELECT               OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DESELECTION":U            THEN ON DESELECTION            OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DROP-FILE-NOTIFY":U       THEN ON DROP-FILE-NOTIFY       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "EMPTY-SELECTION":U        THEN ON EMPTY-SELECTION        OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "END-BOX-SELECTION":U      THEN ON END-BOX-SELECTION      OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "END-ERROR":U              THEN ON END-ERROR              OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "END-MOVE":U               THEN ON END-MOVE               OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "END-RESIZE":U             THEN ON END-RESIZE             OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "ENDKEY":U                 THEN ON ENDKEY                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "ENTRY":U                  THEN ON ENTRY                  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "ERROR":U                  THEN ON ERROR                  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "GO":U                     THEN ON GO                     OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "HELP":U                   THEN ON HELP                   OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "LEAVE":U                  THEN ON LEAVE                  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "MOUSE-MENU-CLICK":U       THEN ON MOUSE-MENU-CLICK       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "MOUSE-SELECT-CLICK":U     THEN ON MOUSE-SELECT-CLICK     OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "MOUSE-SELECT-DBLCLICK":U  THEN ON MOUSE-SELECT-DBLCLICK  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "PARENT-WINDOW-CLOSE"      THEN ON PARENT-WINDOW-CLOSE    OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "RECALL":U                 THEN ON RECALL                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "RETURN":U                 THEN ON RETURN                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "SELECT":U                 THEN ON SELECT                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "SELECTION":U              THEN ON SELECTION              OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "START-BOX-SELECTION":U    THEN ON START-BOX-SELECTION    OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "START-MOVE":U             THEN ON START-MOVE             OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "START-RESIZE":U           THEN ON START-RESIZE           OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "TAB":U                    THEN ON TAB                    OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "VALUE-CHANGED":U          THEN ON VALUE-CHANGED          OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-CLOSE":U           THEN ON WINDOW-CLOSE           OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-MAXIMIZED":U       THEN ON WINDOW-MAXIMIZED       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-MINIMIZED":U       THEN ON WINDOW-MINIMIZED       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-RESIZED":U         THEN ON WINDOW-RESIZED         OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-RESTORED":U        THEN ON WINDOW-RESTORED        OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            /* User-defined events */
            WHEN "U1":U                     THEN ON U1  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U2":U                     THEN ON U2  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U3":U                     THEN ON U3  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U4":U                     THEN ON U4  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U5":U                     THEN ON U5  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U6":U                     THEN ON U6  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U7":U                     THEN ON U7  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U8":U                     THEN ON U8  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U9":U                     THEN ON U9  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "U10":U                    THEN ON U10 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.            
        END CASE.    /* only valid events */
    END.    /* UI events. */
        
    RETURN TRUE.
END FUNCTION.   /* createUiEvents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyWidgets Procedure 
FUNCTION destroyWidgets RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Destroy everything in case we are morphing from one physical 
           object to another
    Notes:  * If this procedure is being called from another destroy routine,
              we don't delete the PROCEDURE objects. These will be gracefully
              destroyed by the ADM.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWidget         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hObjectBuffer   AS HANDLE     NO-UNDO.

    DEFINE BUFFER ttWidget  FOR ttWidget.

    FOR EACH ttWidget WHERE
             ttWidget.tTargetProcedure = TARGET-PROCEDURE:

        IF VALID-HANDLE(ttWidget.tWidgetHandle) THEN
        DO:
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
            ASSIGN 
              ttWidget.tWidgetHandle = ?.
        END.    /* valid widget handle */

        DELETE ttWidget.
    END.    /* each widget */
    
    DYNAMIC-FUNCTION('destroyPopups':U IN TARGET-PROCEDURE).

    RETURN TRUE.
END FUNCTION.   /* destroyWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  Used by prepareInstance in the Repository Manager.
        Notes:
------------------------------------------------------------------------------*/
    return gcCurrentLogicalName.
END FUNCTION.    /* getCurrentLogicalName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupHandle Procedure 
FUNCTION getPopupHandle RETURNS HANDLE
    ( INPUT phWidgetHandle      AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes: This is kept for backwards compatibility and should NOT be moved to 
           adm2 as it clashes with naming convention.      
------------------------------------------------------------------------------*/
  RETURN {fn popupHandle phWidgetHandle}.  
END FUNCTION.   /* getPopupHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidgetTableBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetTableBuffer Procedure 
FUNCTION getWidgetTableBuffer RETURNS HANDLE
        (  ):
/*------------------------------------------------------------------------------
  Purpose: Returns the buffer handle to the ttWidget temp-table.  
    Notes: * This is typically called from generated viewers, since they need
             to create records in the ttWidget temp-table so that the
             repositionWidgetForTranslation() function can work.
------------------------------------------------------------------------------*/
    define variable hBuffer                    as handle            no-undo.
    
    hBuffer = buffer ttWidget:handle.
    
    error-status:error = no.
    return hBuffer.
END FUNCTION.     /* getWidgetTableBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentLogicalName Procedure 
FUNCTION setCurrentLogicalName RETURNS LOGICAL
        ( input pcCurrentLogicalName        as character ):
/*------------------------------------------------------------------------------
  Purpose: This function is called from the rendering before the calls are 
                   made to constructObject. This value is used by the prepareInstance
                   bootstrapping API.
    Notes: 
------------------------------------------------------------------------------*/
    gcCurrentLogicalName = pcCurrentLogicalName.
    return true.
END FUNCTION.    /* setCurrentLogicalName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

