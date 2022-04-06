&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : rylayoutsp.p
    Purpose     : Layout Manager--new Version for ICF with layout 06

    Syntax      :

    Description : To deal with resizing of Astra 2 objects

    Author(s)   : Originally Robin Roos but fixed by Anthony Swindells
    Created     : June 2000
    Notes       :
  
  
    Modified : 23/10/2001         Mark Davies (MIP)
               Made some modifications to resize06 to support centre
               and right justification.
    Modified : 01/14/2002         Mark Davies (MIP)
               Made some modifications to resize05 to allow the folder
               window to be resized to accommodate the different styles
               of layouts supported by resize06 within a TreeView
    Modified : 01/06/2002         Mark Davies (MIP)
               When the TreeView is used as a menu and it launches objects
               on the application side - the Folder Toolbar is normally
               hidden. This space was left open and the objects being
               instantiated always started at the bottom of where the 
               toolbar used to be. I changed the layout to use the space
               of the toolbar and thus put the first object where the
               toolbar used to be. This sorts out any sizing problems due
               to the pack size being returned excluded the size of the 
               toolbar and would thus be to small.
    Modified : 02/22/2002         Mark Davies (MIP)
               Fix for issue #4012 - Multi-Page Container created in 
               Dynamics 1.1A Fails after update
    Modified : 03/12/2002         Mark Davies (MIP)
               For objects with a special layout position of 
               C - Centered; or
               R - Right Justified 
               on a tab page did not enherit this special positioning
               due to a ',<Page Number>' being added to the Layout Code
    Modified : 03/15/2002         Mark Davies (MIP)
               Ensure that if there is more than one object in a row and 
               one of these objects are resizable that we do not make the 
               whole row fixed if another object in the same row is fixed. 
----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE dCharsPerRowPixel       AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE dCharsPerColumnPixel    AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE ghSourceProcedure       AS HANDLE                   NO-UNDO.

ASSIGN dCharsPerRowPixel    = SESSION:HEIGHT-CHARS / SESSION:HEIGHT-PIXELS
       dCharsPerColumnPixel = SESSION:WIDTH-CHARS  / SESSION:WIDTH-PIXELS.

{src/adm2/globals.i}

/* Used in 03 layout
 */
DEFINE TEMP-TABLE ttCentre              NO-UNDO
    FIELD hInstanceHandle   AS HANDLE
    FIELD lToolbar          AS LOGICAL
    FIELD lResize           AS LOGICAL
    FIELD tLayoutPosition   AS CHARACTER
    FIELD cObjectTypeCode   AS CHARACTER
    INDEX key1
        hInstanceHandle
        lResize
    INDEX idxPosition
        tLayoutPosition
    .
/* Used in 06 layout. 
 */
DEFINE TEMP-TABLE ttRow                 NO-UNDO
    FIELD SourceProcedure     AS HANDLE        
    FIELD PageNum             AS INTEGER
    FIELD RowNum              AS INTEGER
    FIELD MinWidth            AS DECIMAL
    FIELD MinHeight           AS DECIMAL
    FIELD RowWidth            AS DECIMAL
    FIELD RowHeight           AS DECIMAL
    FIELD FixedWidth          AS LOGICAL  INIT YES
    FIELD FixedHeight         AS LOGICAL  INIT NO
    FIELD NumResizeHorizontal AS INTEGER
    FIELD FixedHorizontalSize AS DECIMAL
    FIELD BottomSection       AS LOGICAL
    FIELD NumObjects          AS INTEGER
    INDEX idxMain
        SourceProcedure
        PageNum
    .
DEFINE TEMP-TABLE ttInstance NO-UNDO
    FIELD SourceProcedure       AS HANDLE
    FIELD PageNum               AS INTEGER
    FIELD RowNum                AS INTEGER
    FIELD ColumnNum             AS INTEGER
    FIELD RowCol                AS CHARACTER        /* For a layout position of "M32" this will be "32" */    
    FIELD ObjectHeight          AS DECIMAL
    FIELD ObjectWidth           AS DECIMAL
    FIELD MinHeight             AS DECIMAL
    FIELD MinWidth              AS DECIMAL
    FIELD FixedHeight           AS LOGICAL
    FIELD FixedWidth            AS LOGICAL
    FIELD LayoutPosition        AS CHARACTER
    FIELD ObjectInstanceHandle  AS HANDLE
    FIELD ObjectTypeCode        AS CHARACTER
    FIELD JustifyPosition       AS CHARACTER
    INDEX idxPerPage
        SourceProcedure
        PageNum
        RowNum        
    INDEX idxLayout
        SourceProcedure
        RowCol
    INDEX idxRowCol
        RowNum
        ColumnNum
    .
    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildRowsAndInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildRowsAndInstances Procedure 
FUNCTION buildRowsAndInstances RETURNS LOGICAL
    ( INPUT phTargetProcedure       AS HANDLE,
      INPUT piPageNumber            AS INTEGER  )  FORWARD.

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
         HEIGHT             = 20.24
         WIDTH              = 50.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-dimensionSomething) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dimensionSomething Procedure 
PROCEDURE dimensionSomething :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     To work out width and height of object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectType            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER phObjectInstance        AS HANDLE           NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL          NO-UNDO.

    DEFINE VARIABLE hOldSourceProcedure         AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cLayoutCode                 AS CHARACTER            NO-UNDO.     
    DEFINE VARIABLE dMinWidth                   AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMinHeight                  AS DECIMAL              NO-UNDO.   
    DEFINE VARIABLE hPageInitField              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lPageInit                   AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lResizeHorizontal           AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lResizeVertical             AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE iFrameCurrentPage           AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iPageLoop                   AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cPageLayoutInfo             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitialPageList            AS CHARACTER            NO-UNDO.

    IF NOT VALID-HANDLE(phObjectInstance) THEN
        RETURN.
    
    /* No need to try and reposition or size non-visible objects */
    IF {fnarg signature 'getHeight':U phObjectInstance} EQ '':U THEN
        RETURN.
    IF piLayoutForPage EQ 0                              AND
       {fnarg InstanceOf 'SmartFolder' phObjectInstance} THEN
    DO:
        ASSIGN pdPackedWidth  = 0
               pdPackedHeight = 0.
        
        /* Page layout information stored at the Container level. */
        {get PageLayoutInfo cPageLayoutInfo ghSourceProcedure}.
        
        /* If the requested page is zero, and we are packing page zero (as
           indicated by the piLayoutForPage parameter) then we need to make
           sure that all pages are packed. This is important when more than
           one page is initialised on object initialisation (as per the InitialPageList
           property). When this happens, the pages that are initialised up front
           are not packed when the page is selected, and it is possible that
           these pages are larger than the packed size of the StartPage.
           
           The packing routines work off running objects only, so only those
           pages that have running objects will be affected. Still, only attempt
           to pack those pages in the InitialPageList property.
         */
        IF piPageNumber EQ 0 THEN
        DO:
            {get InitialPageList cInitialPageList ghSourceProcedure}.            
            /* If there are no initial pages, make sure that at the 
               start page is also packed. 
             */
            IF cInitialPageList EQ "":U OR cInitialPageList EQ ? THEN
                ASSIGN cInitialPageList = STRING({fn getStartPage ghSourceProcedure}).
            
            DO iPageLoop = 1 TO NUM-ENTRIES(cInitialPageList):
                ASSIGN piPageNumber = INTEGER(ENTRY(iPageLoop, cInitialPageList))
                       cLayoutCode  = ENTRY(piPageNumber, cPageLayoutInfo, "|":U)
                       NO-ERROR.
                
                /* Don't try page 0 again. */
                IF piPageNumber EQ 0 THEN
                    NEXT.
                IF cLayoutCode NE "":U AND cLayoutCode NE ? THEN
                    RUN packLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,
                                                         INPUT  piPageNumber,
                                                         INPUT  piPageNumber,
                                                         OUTPUT dMinWidth,
                                                         OUTPUT dMinHeight     ).
                ASSIGN pdPackedHeight = MAX(pdPackedHeight,dMinHeight)
                       pdPackedWidth  = MAX(pdPackedWidth,dMinWidth).
            END.    /* loop through all pages  */
        END.    /* page number to layout is zero */
        ELSE
        DO:
            ASSIGN cLayoutCode = ENTRY(piPageNumber, cPageLayoutInfo, "|":U) NO-ERROR.
            IF cLayoutCode NE "":U AND cLayoutCode NE ? THEN
            DO:
                RUN packLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,
                                                     INPUT  piPageNumber,
                                                     INPUT  piPageNumber,
                                                     OUTPUT dMinWidth,
                                                     OUTPUT dMinHeight     ).
                ASSIGN pdPackedHeight = MAX(pdPackedHeight,dMinHeight)
                       pdPackedWidth  = MAX(pdPackedWidth,dMinWidth).
            END.    /* page layout available */
        END.    /* non-zero page */
        
        /* Make sure there's enough space for all the tabs on the window. */
        ASSIGN dMinWidth = {fn getPanelsMinWidth phObjectInstance} NO-ERROR.

        ASSIGN pdPackedWidth = MAX(dMinWidth, pdPackedWidth).

        /* Add the space a folder needs for its labels and margins.  We calculate the number of tab rows * 1.14 (hardcoded tab height). *
         * The tab folder currently only supports 1 row, when it's changed to support more than 1, uncomment the part after the assign. */
        ASSIGN pdPackedHeight = pdPackedHeight + {fn getTabRowHeight phObjectInstance} + 0.48
               pdPackedWidth  = pdPackedWidth + 1.8.

        /* We may already have dimensioned another page on this folder object. 
         * We get the previous min size and save the larger. Both of these will have the
         * manual adjustments above done to them, so there is no need to do thema gain. */
        &SCOPED-DEFINE xp-assign
        {get MinHeight dMinHeight phObjectInstance}
        {get MinWidth  dMinWidth  phObjectInstance}.
        &UNDEFINE xp-assign

        ASSIGN pdPackedHeight = MAX(pdPackedHeight,dMinHeight)
               pdPackedWidth  = MAX(pdPackedWidth,dMinWidth).
               
        /* Set these minimum (packed) heights/widths */
        {set MinHeight pdPackedHeight phObjectInstance}.
        {set MinWidth  pdPackedWidth  phObjectInstance}.
    END.    /* SmartFolder */
    ELSE
    /* Cater for DynFrames and other contained window containers, 
       such as those run by the treeview window.
     */
    IF {fnarg instanceOf 'DynContainer' phObjectInstance} then
    DO:    
        ASSIGN pdPackedWidth  = 0
               pdPackedHeight = 0.

        /* Get the instanceID of the DynFrame instance. */
        &SCOPED-DEFINE xp-assign
        {get CurrentPage iFrameCurrentPage phObjectInstance}
        /* Get the layout code for page 0 */
        {get Page0LayoutManager cLayoutCode phObjectInstance}.
        &UNDEFINE xp-assign
        
        /* The ghSourceProcedure is used to find the relevant objects. Since a global variable
         * is used we need to fool this resize procedure.                                     */
        ASSIGN hOldSourceProcedure = ghSourceProcedure
               ghSourceProcedure   = phObjectInstance.
               
        /* The value of the LayoutForPage variable is zero because
         * we need it to force the packing in the event of there being 
         * a SmartFolder object on the frame.
         * 
         * We also pack for the currently selected page on the DynFrame,
         * which may not be the same that is passed in.                  */
        RUN packLayout IN TARGET-PROCEDURE( INPUT  cLayoutCode,
                                            INPUT  0,                   /* piLayoutForPage */
                                            INPUT  iFrameCurrentPage,   /* piPageNumber */
                                            OUTPUT pdPackedWidth,
                                            OUTPUT pdPackedHeight   ).
        
        /* Set these minimum (packed) heights/widths */
        {set MinHeight pdPackedHeight phObjectInstance}.
        {set MinWidth  pdPackedWidth  phObjectInstance}.

        /* Reset back to the DynFrame's containing source procedure. */
        ASSIGN ghSourceProcedure = hOldSourceProcedure.
    END.    /* DynFrame */
    ELSE
    DO:
        ASSIGN pdPackedHeight = 0
               pdPackedWidth  = 0.

        IF {fnarg InstanceOf 'SmartToolbar' phObjectInstance} THEN
        DO:
            {get MinHeight pdPackedHeight phObjectInstance}.
            IF pdPackedHeight = 0 OR pdPackedHeight = ? THEN
                ASSIGN pdPackedHeight  = {fn getHeight phObjectInstance}.

            /* The Toolbar must be at least 1.24 characters high, if no other size is set. */
            IF pdPackedHeight = 0 OR pdPackedHeight = ? THEN
            DO:
                ASSIGN pdPackedHeight  = 1.24.
                {set MinHeight pdPackedHeight phObjectInstance}.
            END.

            {get MinWidth  pdPackedWidth phObjectInstance}.
            IF pdPackedWidth = 0 OR pdPackedWidth = ? THEN
            DO:
                ASSIGN pdPackedWidth  = {fn getWidth phObjectInstance}.
                {set MinWidth pdPackedWidth phObjectInstance}.
            END.    /* no min width set */
        END.    /* toolbar */
        ELSE
            ASSIGN
                lResizeHorizontal = {fn getResizeHorizontal phObjectInstance}
                lResizeVertical   = {fn getResizeVertical phObjectInstance}
                
                pdPackedHeight    = (IF lResizeVertical THEN {fn getMinHeight phObjectInstance} 
                                                        ELSE {fn getHeight phObjectInstance})
                pdPackedWidth     = (IF lResizeHorizontal THEN {fn getMinWidth phObjectInstance}
                                                          ELSE {fn getWidth phObjectInstance})
                                                           
                pdPackedHeight    = (IF pdPackedHeight = 0 THEN {fn getHeight phObjectInstance} ELSE pdPackedHeight)
                pdPackedWidth     = (IF pdPackedWidth  = 0 THEN {fn getWidth phObjectInstance} ELSE pdPackedWidth).
    END.    /* not a smartfolder */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* dimensionSomething */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack00) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack00 Procedure 
PROCEDURE pack00 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Work out minimum size of a widnow based on its contents
  Parameters:  <none>
  Notes:       No layout specified
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL   NO-UNDO.
    
    RETURN.
END PROCEDURE.  /* pack00 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack01) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack01 Procedure 
PROCEDURE pack01 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Pack Routine for Everything Centred layout
  Parameters:  <none>
  Notes:       Work out minimum size of a window based on its contents
               Works with resize01
               Basically assumes all objects on page to be in column position 1
               and row 0.24 and the width of every object to be the width
               of the container minus 2 and the height of the container minus
               0.48.
               Only useful if a single viewer on a tab page and nothing else, 
               not even a toolbar.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER         NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER         NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL         NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL         NO-UNDO.

    DEFINE VARIABLE dObjectHeight                   AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dObjectWidth                    AS DECIMAL          NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                      AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dMaxWidth                       AS DECIMAL          NO-UNDO.            
    DEFINE VARIABLE hObjectInstanceHandle           AS HANDLE           NO-UNDO.     
    DEFINE VARIABLE cObjectTypeCode                 AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cLayoutPosition                 AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cPageNTargets                                       AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAllPageTargets                             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLoop                                                       AS INTEGER                      NO-UNDO.
    
    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piLayoutForPage EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
                
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
        END.    /* page 0 */
        ELSE
                ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                                                    INPUT ghSourceProcedure,
                                                                                    INPUT piLayoutForPage               ).
        
        DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
                IF piLayoutForPage EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
                        NEXT.
        
        &SCOPED-DEFINE xp-assign                
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
        &UNDEFINE xp-assign  
        
        RUN dimensionSomething( INPUT  piLayoutForPage,
                                INPUT  piPageNumber,
                                INPUT  cObjectTypeCode,
                                INPUT  hObjectInstanceHandle,
                                OUTPUT dObjectWidth,
                                OUTPUT dObjectHeight               ).

        IF dObjectHeight NE ? THEN ASSIGN dMaxHeight = MAX(dMaxHeight, dObjectHeight).
        IF dObjectWidth <> ?  THEN ASSIGN dMaxWidth  = MAX(dMaxWidth, dObjectWidth).
    END.    /* pageN target loop  */
    
    ASSIGN pdPackedWidth          = dMaxWidth + 2    
           pdPackedHeight         = dMaxHeight + 0.48
           ERROR-STATUS:ERROR = NO.
        
    RETURN.
END PROCEDURE.  /* pack01 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack02) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack02 Procedure 
PROCEDURE pack02 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Pack Routine for Top/Center/Bottom layout
  Parameters:  <none>
  Notes:       Work out minimum size of a window based on its contents
               Works with resize02
               This layout assumes a maximum of 1 top, 1 centre and 1 bottom 
               object. It is useful for object controllers with no viewer and
               for folder pages that contain just a browser and a toolbar, or
               just a viewer and a toolbar. Only the centre object will ever be
               made bigger vertically.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL          NO-UNDO.
    
    DEFINE VARIABLE dObjectHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dObjectWidth                AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                  AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMaxWidth                   AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE               NO-UNDO.     
    DEFINE VARIABLE cObjectTypeCode             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLayoutPosition             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dCenterMaxHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dTopMaxHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dBottomMaxHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE iLoop                                               AS INTEGER                              NO-UNDO.
    DEFINE VARIABLE cPageNTargets                               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cAllPageTargets             AS CHARACTER            NO-UNDO.
    
    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piLayoutForPage EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
                
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
        END.    /* page 0 */
        ELSE
                ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                                                    INPUT ghSourceProcedure,
                                                                                    INPUT piLayoutForPage               ).
        
        DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
                IF piLayoutForPage EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
                        NEXT.
        
        &SCOPED-DEFINE xp-assign        
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.  
        &UNDEFINE xp-assign
        
        RUN dimensionSomething ( INPUT  piLayoutForPage,
                                 INPUT  piPageNumber,
                                 INPUT  cObjectTypeCode,
                                 INPUT  hObjectInstanceHandle,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight             ).

        IF dObjectHeight NE ? AND cLayoutPosition NE "":U THEN
        DO:
            ASSIGN cLayoutPosition = ENTRY(1, cLayoutPosition)
                   cLayoutPosition = SUBSTRING(cLayoutPosition,1,1).
            CASE cLayoutPosition:
                WHEN "T" THEN ASSIGN dTopMaxHeight    = MAX(dTopMaxHeight,dObjectHeight).
                WHEN "C" THEN ASSIGN dCenterMaxHeight = MAX(dCenterMaxHeight,dObjectHeight) + 0.24.
                WHEN "B" THEN ASSIGN dBottomMaxHeight = MAX(dBottomMaxHeight,dObjectHeight).
            END CASE.   /* layout position */
        END.    /* height a valid value */

        IF dObjectWidth <> ?  THEN
            ASSIGN dMaxWidth  = MAX(dMaxWidth, dObjectWidth).
    END.    /* lop through pageN targets */

    ASSIGN dMaxHeight     = dTopMaxHeight + dCenterMaxHeight + dBottomMaxHeight
           pdPackedWidth  = dMaxWidth  + 2
           pdPackedHeight = dMaxHeight + 0.24
           
           ERROR-STATUS:ERROR = NO.
           
    RETURN.
END PROCEDURE.  /* pack02 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack03 Procedure 
PROCEDURE pack03 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Pack Routine for Top/Multi/Bottom layout
  Parameters:  <none>
  Notes:       Work out minimum size of a window based on its contents
               This layout assumes a maximum of 1 top and 1 bottom object, and
               any number of objects in the centre.
               Objects that are resizable in the centre will share the remaining
               space equally, after working out how much space the non resizable
               centre objects need.
               A small gap is left between the centre objects, and a smaller gap 
               is left if it is a toolbar, to cope with toolbars under browsers
               in the centre.
               This layout will cope with a wide variety of applications. Its only
               real limitation is that it makes all objects full width.
               This layout assumes all toolbars are horizontally aligned.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL          NO-UNDO.
    
    DEFINE VARIABLE dObjectHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dObjectWidth                AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                  AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMaxWidth                   AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE               NO-UNDO.     
    DEFINE VARIABLE cObjectTypeCode             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLayoutPosition             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dCenterMaxHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dTopMaxHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dBottomMaxHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE iLoop                                               AS INTEGER                              NO-UNDO.
    DEFINE VARIABLE cPageNTargets                               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cAllPageTargets                     AS CHARACTER                    NO-UNDO.
    
    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piLayoutForPage EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
                
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
        END.    /* page 0 */
        ELSE
                ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                                                    INPUT ghSourceProcedure,
                                                                                    INPUT piLayoutForPage               ).
        
        DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
                IF piLayoutForPage EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
                        NEXT.
   
        &SCOPED-DEFINE xp-assign        
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.  
        &UNDEFINE xp-assign
        
        RUN dimensionSomething ( INPUT  piLayoutForPage,
                                 INPUT  piPageNumber,
                                 INPUT  cObjectTypeCode,
                                 INPUT  hObjectInstanceHandle,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight          ).            

        IF dObjectHeight NE ? AND cLayoutPosition NE "":U THEN
        DO:
            ASSIGN cLayoutPosition = ENTRY(1, cLayoutPosition)
                   cLayoutPosition = SUBSTRING(cLayoutPosition,1,1).
                        
            CASE cLayoutPosition:
                WHEN "T" THEN ASSIGN dTopMaxHeight    = MAX(dTopMaxHeight,dObjectHeight).
                WHEN "C" THEN ASSIGN dCenterMaxHeight = MAX(dCenterMaxHeight,(dCenterMaxHeight + dObjectHeight + 0.24 )). /* many centre objects */
                WHEN "B" THEN ASSIGN dBottomMaxHeight = MAX(dBottomMaxHeight,dObjectHeight).
            END CASE.   /* layout position */
        END.

        IF dObjectWidth <> ? THEN
                ASSIGN dMaxWidth  = MAX(dMaxWidth, dObjectWidth).
    END.    /* loop through pageN targets  */

    ASSIGN dMaxHeight     = dTopMaxHeight + dCenterMaxHeight + dBottomMaxHeight
           pdPackedWidth  = dMaxWidth + 2
           pdPackedHeight = dMaxHeight + 0.24
           ERROR-STATUS:ERROR = NO.     
    RETURN.
END PROCEDURE.  /* pack03 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack04) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack04 Procedure 
PROCEDURE pack04 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Pack Routine for left/centre/right layout
  Parameters:  <none>
  Notes:       Work out minimum size of a window based on its contents
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL   NO-UNDO.
    
    DEFINE VARIABLE dObjectHeight               AS DECIMAL NO-UNDO INITIAL 50.
    DEFINE VARIABLE dObjectWidth                AS DECIMAL NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dMaxWidth                   AS DECIMAL NO-UNDO.            
    DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE NO-UNDO.     
    DEFINE VARIABLE cObjectTypeCode             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLayoutPosition             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dCenterMaxWidth     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dRightMaxWidth      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dLeftMaxWidth       AS DECIMAL NO-UNDO.    
    DEFINE VARIABLE iLoop                                               AS INTEGER                              NO-UNDO.
    DEFINE VARIABLE cPageNTargets                               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cAllPageTargets                     AS CHARACTER                    NO-UNDO.
    
    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piLayoutForPage EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
                
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
        END.    /* page 0 */
        ELSE
                ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                                                    INPUT ghSourceProcedure,
                                                                                    INPUT piLayoutForPage               ).
        
        DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piLayoutForPage EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        &SCOPED-DEFINE xp-assign        
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.  
        &UNDEFINE xp-assign
                    
        RUN dimensionSomething( INPUT  piLayoutForPage,    
                                                    INPUT  piPageNumber,  
                                                    INPUT  cObjectTypeCode,
                                                    INPUT  hObjectInstanceHandle,        
                                                    OUTPUT dObjectWidth,
                                                    OUTPUT dObjectHeight            ).            
                                                        
        IF dObjectWidth <> ? AND cLayoutPosition <> "":U THEN
        DO:
            ASSIGN cLayoutPosition = ENTRY(1, cLayoutPosition)
                   cLayoutPosition = SUBSTRING(cLayoutPosition,1,1).
                   
            CASE cLayoutPosition:
                WHEN "R" THEN dRightMaxWidth  = MAX(dRightMaxWidth,dObjectWidth).
                WHEN "C" THEN dCenterMaxWidth = MAX(dCenterMaxWidth,(dObjectWidth / 2)).
                WHEN "L" THEN dLeftMaxWidth   = MAX(dLeftMaxWidth,dObjectWidth).
            END CASE.
        END.
        IF dObjectWidth <> ?  THEN dMaxHeight = MAX(dMaxHeight, dObjectHeight).
    END.        /* loop through pagen targets */
    
    ASSIGN dMaxWidth      = dRightMaxWidth + dCenterMaxWidth + dLeftMaxWidth
           pdPackedWidth  = dMaxWidth + 2
           pdPackedHeight = dMaxHeight + 0.24
           
           ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* pack04 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack05) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack05 Procedure 
PROCEDURE pack05 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Pack Routine for TreeView layout
  Parameters:  piLayoutForPage
               piPageNumber
               OUTPUT pdPackedWidth
               OUTPUT pdPackedHeight
  Notes:       Work out minimum size of a window based on its contents
               We assume that there are 3 static objects on the TreeView 
               container - TreeView OCX, ResizeBar and Title Fill-IN.
               The handles to these objects can be retrieved by calling 3 
               different functions.
               The other objects that we would expect to find on the TreeView
               container would be a Top Toolbar (ObjcTop) and a Filter Viewer.
               The filter viewer is optional.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber    AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth   AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight  AS DECIMAL   NO-UNDO.
                                                           
    DEFINE VARIABLE hTopToolbar             AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hTreeViewOCX            AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hFilterViewer           AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hTitleBar               AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hResizeBar              AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hObjectInstanceHandle   AS HANDLE    NO-UNDO.
    DEFINE VARIABLE dFilterViewerHeight     AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dFilterViewerWidth      AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTitleBarHeight         AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTitleBarWidth          AS DECIMAL   NO-UNDO.    
    DEFINE VARIABLE dTopToolbarHeight       AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTopToolbarWidth        AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTreeViewMinHeight      AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTreeViewMinWidth       AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTreeViewWidth          AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dObjectWidth            AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dObjectHeight           AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dChildWindowWidth       AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dChildWindowHeight      AS DECIMAL   NO-UNDO.    
    DEFINE VARIABLE cObjectTypeCode         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cContainerTargets       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iLoop                   AS INTEGER   NO-UNDO.    
    
    /* Get the things we know about. These are the hard-coded (non Repository-based)
       components used by the treeview.
     */
    ASSIGN hTreeViewOCX = {fn getTreeViewOCX ghSourceProcedure}
           hTitleBar    = {fn getTitleBar ghSourceProcedure}
           hResizeBar   = {fn getResizeBar ghSourceProcedure}.
    
    /* The top toolbar will be on the end of the ContainerToolbar link. */
    ASSIGN hTopToolbar = WIDGET-HANDLE({fnarg linkHandles '"ContainerToolbar-Source"' ghSourceProcedure}) NO-ERROR.
    
    IF VALID-HANDLE(hTopToolbar) THEN
    DO:
        {get ClassName cObjectTypeCode hTopToolbar}.
        
        RUN dimensionSomething ( INPUT  piLayoutForPage,
                                 INPUT  piPageNumber,
                                 INPUT  cObjectTypeCode,
                                 INPUT  hTopToolbar,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight).
        ASSIGN dTopToolbarHeight = dObjectHeight
               dTopToolbarWidth  = dObjectWidth.                                 
    END.    /* toolbar */
    
    /* The filter viewer will be on the front of the TreeFilter link. */
    ASSIGN hFilterViewer = WIDGET-HANDLE({fnarg linkHandles '"TreeFilter-Source"' ghSourceProcedure}) NO-ERROR.    
    IF VALID-HANDLE(hFilterViewer) THEN
    DO:
        {get ClassName cObjectTypeCode hFilterViewer}.
        
        RUN dimensionSomething ( INPUT  piLayoutForPage,
                                 INPUT  piPageNumber,
                                 INPUT  cObjectTypeCode,
                                 INPUT  hFilterViewer,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight).
        ASSIGN dFilterViewerHeight = dObjectHeight
               dFilterViewerWidth  = dObjectWidth.                                 
    END.    /* fileter viewer */    
    
    IF VALID-HANDLE(hTreeViewOCX) THEN
        ASSIGN dTreeViewMinHeight = {fn getMinHeight hTreeViewOCX}
               dTreeViewMinWidth  = {fn getMinWidth hTreeViewOCX}
               dTreeViewWidth     = {fn getWidth hTreeViewOCX}.
    
    /* The title bar cannot be narrower than its contents.
     */    
    IF VALID-HANDLE(hTitleBar) THEN
        ASSIGN dTitleBarHeight = hTitleBar:HEIGHT-CHARS
               dTitleBarWidth  = MAX(1, LENGTH(hTitleBar:SCREEN-VALUE)).
    
    /* Now resize any remaining objects on the window. */     
    /* Get all of the objects on the treeview. */
    {get ContainerTarget cContainerTargets ghSourceProcedure}.
    
    DO iLoop = 1 TO NUM-ENTRIES(cContainerTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cContainerTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* We know about some of the things ... */
        IF hObjectInstanceHandle EQ hTreeViewOCX  OR
           hObjectInstanceHandle EQ hTitleBar     OR
           hObjectInstanceHandle EQ hResizeBar    OR
           hObjectInstanceHandle EQ hTopToolbar   OR           
           hObjectInstanceHandle EQ hFilterViewer THEN
            NEXT.
            
        /* Skip DataObjects */
        if {fn getQueryObject hObjectInstanceHandle} then
            next.
        
        /* The stuff that's left will typically be the child information folder window(s). */
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
        
        RUN dimensionSomething ( INPUT  piLayoutForPage,
                                 INPUT  (IF piLayoutForPage EQ 0 THEN 0 ELSE piPageNumber),
                                 INPUT  cObjectTypeCode,
                                 INPUT  hObjectInstanceHandle,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight).
        
        ASSIGN dChildWindowWidth  = MAX(dChildWindowWidth, dObjectWidth)
               dChildWindowHeight = MAX(dChildWindowHeight, dObjectHeight).    
    END.    /* looping through container targets */
    
    /* The minimum height of a treeview is calculated as follows:
        - the min height of the toolbar, plus the min height of the filter viewer (if any),
          plus the larger of the min height of the folder windows or treeview object/OCX.
        - a spacer of 0.48 chars is added.
       
       The min width is calculated as follows:
       - the larger of the min width of the filter viewer (if any), the min width of the
         top toolbar, the sum of the min widths of the child window and the treeview OCX.
       - a spacer of 0.48 chars is added.
     */
     
    ASSIGN pdPackedWidth  = MAX(dTopToolbarWidth,
                               (MAX(dTreeViewMinWidth, hResizeBar:COL) + MAX(dTitleBarWidth ,dChildWindowWidth) + hResizeBar:WIDTH),
                               dFilterViewerWidth)
                          + 0.48
           pdPackedHeight = dTopToolbarHeight + dFilterViewerHeight +
                          + MAX(dTreeViewMinHeight, dChildWindowHeight + dTitleBarHeight)
                          + 0.48.
    
    /* Check that we at least leave space for the Title Bar */
    IF (pdPackedWidth - dTreeViewWidth) LT 10 THEN
        ASSIGN pdPackedWidth = 10 + dTreeViewWidth.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* pack05 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack06) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack06 Procedure 
PROCEDURE pack06 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Pack Routine for Relative layout
  Parameters:  piLayoutForPage
               piPageNumber
               OUTPUT pdPackedWidth
               OUTPUT pdPackedHeight
  Notes:       Work out minimum size of a window based on its contents
               This layout assumes a maximum of 1 row of bottom objects, and
               up to nine rows of nine objects in the "main" (center).
               There is no separate "top" section. The "Bottom" layout really
               isn't separate either; it simply means that the objects in that row
               are tied to the bottom of the window, in case there's extra space above.
               Objects that are resizable in the "Main" section will share the remaining
               space equally, after working out how much space the non resizable
               main objects need.
               A small gap is left between the objects, and a smaller gap 
               is left if it is a toolbar, to cope with toolbars under browsers.
               This layout will cope with a wide variety of applications. 
               The format for the "Main" layout position is "M" plus the 1-digit
               row number plus the 1 digit sequential position number, which
               can also be "C" to center the object within the (remaining) space,
               or "R" to right justify the object (maximum of one of these per row).
               Non-visual objects should be given a row number of 0 (e.g. "M01").
               The remaining "Bottom" section has a layout code of "B" plus 
               a one-digit row number (higher than M row numbers), 
               plus the sequential position.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage        AS INTEGER           NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber           AS INTEGER           NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth          AS DECIMAL           NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight         AS DECIMAL           NO-UNDO.

    DEFINE VARIABLE dObjectHeight                   AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dObjectWidth                    AS DECIMAL          NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                      AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dMaxWidth                       AS DECIMAL          NO-UNDO.            
    DEFINE VARIABLE hObjectInstanceHandle           AS HANDLE           NO-UNDO.
    DEFINE VARIABLE cObjectTypeCode                 AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cLayoutPosition                 AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cLayoutCode                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE iLayoutRow                      AS INTEGER          NO-UNDO.
    DEFINE VARIABLE dMainHeight                     AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dMainWidth                      AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dRowHeight                      AS DECIMAL          NO-UNDO EXTENT 9.
    DEFINE VARIABLE dRowWidth                       AS DECIMAL          NO-UNDO EXTENT 9.
    DEFINE VARIABLE iLoop                           AS INTEGER          NO-UNDO.
    DEFINE VARIABLE iMaxRow                         AS INTEGER          NO-UNDO.
    DEFINE VARIABLE lQueryObject                    AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE cPageNTargets                   AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cAllPageTargets                 AS CHARACTER        NO-UNDO.

    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piLayoutForPage EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
                
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
    END.    /* page 0 */
    ELSE
        ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                INPUT ghSourceProcedure,
                                                INPUT piLayoutForPage               ).
    
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
            NEXT.
                
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piLayoutForPage EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        &SCOPED-DEFINE xp-assign                
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
        &UNDEFINE xp-assign  

        /* Skip blank layouts for non-visual objects. Note that these are assigned a
         * position of CENTRE by other code so we must skip that also. */
        {get QueryObject lQueryObject hObjectInstanceHandle} NO-ERROR.

        IF cLayoutPosition EQ "":U OR LENGTH(cLayoutPosition) < 3 OR lQueryObject THEN
            NEXT.
                
        ASSIGN cLayoutCode = SUBSTRING(cLayoutPosition, 1, 1)
               iLayoutRow  = INTEGER(SUBSTRING(cLayoutPosition, 2, 1))
               NO-ERROR.
                
        /* Skip objects on row "0" which is the code for non-visual objects,
         * or an object which has been assigned "CENTRE" as a default. */
        IF (cLayoutCode NE "M":U AND cLayoutCode NE "B":U) OR iLayoutRow EQ 0 THEN
            NEXT.
        
        RUN dimensionSomething ( INPUT  piLayoutForPage,
                                 INPUT  piPageNumber,
                                 INPUT  cObjectTypeCode,
                                 INPUT  hObjectInstanceHandle,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight         ).
        
        IF dObjectHeight + dObjectWidth <> ? THEN
            ASSIGN dRowWidth[iLayoutRow]  = dRowWidth[iLayoutRow] + dObjectWidth + (IF dRowWidth[iLayoutRow] NE 0 THEN 1 ELSE 0)
                   dRowHeight[iLayoutRow] = MAX(dRowHeight[iLayoutRow], dObjectHeight)
                   iMaxRow                = MAX(iMaxRow, iLayoutRow).
    END.        /* loop through pageN targets */
    
    DO iLoop = 1 TO iMaxRow:
        ASSIGN dMainHeight = dMainHeight + dRowHeight[iLoop] + 
                           (IF iLoop NE 1 AND dRowHeight[iLoop] NE 0 THEN 0.24 ELSE 0)
               dMainWidth  = MAX(dMainWidth, dRowWidth[iLoop]).               
    END.    /* loop */
    
    ASSIGN pdPackedWidth  = dMainWidth  + 2
           pdPackedHeight = dMainHeight + 0.24.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* pack06 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-packLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packLayout Procedure 
PROCEDURE packLayout :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Called from packwindow - to work out minumum window size
               according to contents.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcLayoutCode            AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdMinWidth              AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdMinHeight             AS DECIMAL   NO-UNDO.
    
    IF NOT CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES, ("pack":U + pcLayoutCode) ) THEN
        RETURN.

    RUN VALUE("pack" + pcLayoutCode) ( INPUT  piLayoutForPage,
                                       INPUT  piPageNumber,
                                       OUTPUT pdMinWidth,
                                       OUTPUT pdMinHeight           ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* packLayout */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-packWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packWindow Procedure 
PROCEDURE packWindow :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     To work out new minimum width of window to fit contents of page
               being initialized.
               If Resize flag is passed in as yes, the window will also be
               resized to the new minimum. This should be done if saved size
               and positions is turned off or none exist, otherwise the resize
               will be done according to the saved size and position, but not
               less than the minimum found here.
  Parameters:  input page number
               input page 0 layout code, e.g. top/centre/bottom
               input buffer handle of page instance temp-table
               input buffer handle of page temp-table
               input window handle
               input frame handle
               input min window width
               input min window height
               input max window width
               input max window height
               input resize window 
  Notes:       Called from packwindow procedure in dynamic container
               rydyncontw.w
               Works only on page passed in as pages are only built as they are
               visited.
               Note the layout passed in is for page 0. Each time this is called
               for a new page, the contents must be packed according to the page
               0 layout, because other pages are within page 0 and must leave room
               for page 0 toolbar, folder, etc. if any.
               
               * The buffer handles (phObjectBuffer and phPageBuffer) are no longer used.
                 The information they contained is taken from context.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber         AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER pcLayoutCode         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER phObjectBuffer       AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phPageBuffer         AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phWindow             AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phFrame              AS HANDLE               NO-UNDO. 
    DEFINE INPUT PARAMETER pdMinPackedWidth     AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdMinPackedHeight    AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdMaxWidth           AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdMaxHeight          AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER plResize             AS LOGICAL              NO-UNDO.
    
    DEFINE VARIABLE dPackedWidth        AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dPackedHeight       AS DECIMAL                      NO-UNDO.
    
    /* These used later, by resize 06 for example. */
    EMPTY TEMP-TABLE ttRow.
    EMPTY TEMP-TABLE ttInstance.
    /* Used by resize03 */
    EMPTY TEMP-TABLE ttCentre.   
    
    /* Some hard coded defaults */
    IF pdMinPackedWidth  EQ ? THEN ASSIGN pdMinPackedWidth = 81.
    IF pdMinPackedHeight EQ ? THEN ASSIGN pdMinPackedHeight = 10.14.
    
    /* Set the source procedure variable. For details of why then
     * 'packWindowFromSuper' is checked, see that API for details why. */
    IF NOT PROGRAM-NAME(2) BEGINS "packWindowFromSuper":U THEN
        ASSIGN ghSourceProcedure = SOURCE-PROCEDURE.
        
    /* Work out packed width and height for page */
    RUN packLayout( INPUT  pcLayoutCode,
                    INPUT  0,               /* layout for page */
                    INPUT  piPageNumber,
                    OUTPUT dPackedWidth,
                    OUTPUT dPackedHeight        ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN RETURN-VALUE.
    
    /* Avoid resizing beyond session width and height - IF AT ALL POSSIBLE */
    IF (pdMaxWidth  EQ ? OR pdMaxWidth  GT SESSION:WIDTH - 1) AND dPackedWidth <= SESSION:WIDTH - 1 THEN
        ASSIGN pdMaxWidth  = SESSION:WIDTH  - 1.
    
    IF (pdMaxHeight EQ ? OR pdMaxHeight GT SESSION:HEIGHT - 1) AND dPackedHeight <= SESSION:HEIGHT - 1 THEN
        ASSIGN pdMaxHeight = SESSION:HEIGHT - 1.
    
    /* Ensure does not got smaller then previous minimum */
    ASSIGN dPackedWidth  = MAX(dPackedWidth, pdMinPackedWidth)
           dPackedHeight = MAX(dPackedHeight, pdMinPackedHeight).
    
    /* If the newly packed height or width is larger than the 
       current window's height or width, then force a resize.
     */
    IF NOT plResize THEN
        ASSIGN plResize = (dPackedWidth GT phWindow:WIDTH OR dPackedHeight GT phWindow:HEIGHT).
    
    /* Set new window minimums and maximums */
    ASSIGN phWindow:MIN-WIDTH  = dPackedWidth
           phWindow:MIN-HEIGHT = dPackedHeight
           
           /* The maximum window size cannot be smaller than the minimum. */
           phWindow:MAX-WIDTH  = MAX(pdMaxWidth, dPackedWidth)
           phWindow:MAX-HEIGHT = MAX(pdMaxHeight, dPackedHeight)
           
           /* Make sure that the window is at least as big as the minimums */
           phWindow:HEIGHT     = MAX(phWindow:MIN-HEIGHT, phWindow:HEIGHT)
           phWindow:WIDTH      = MAX(phWindow:MIN-WIDTH, phWindow:WIDTH)
           NO-ERROR.
    
    /* Do we need to resize?
	   Only resize of the pack is for page 0, EXCEPT in the case of pages being run in the
	   treeview window. This window typically has none of its own pages, so any requests
	   for pages here are for pages on objects contained by the treeview. We want to make
	   sure that everything is laid out correctly after packing.
     */
    IF plResize AND
       ( piPageNumber EQ 0 OR {fnarg InstanceOf 'DynTree' ghSourceProcedure} ) THEN
    DO:
        ASSIGN phFrame:SCROLLABLE     = TRUE
               phFrame:VIRTUAL-WIDTH  = MAX(phFrame:VIRTUAL-WIDTH,dPackedWidth)
               phFrame:VIRTUAL-HEIGHT = MAX(phFrame:VIRTUAL-HEIGHT,dPackedHeight)
               phFrame:HEIGHT         = phFrame:VIRTUAL-HEIGHT
               phFrame:WIDTH          = phFrame:VIRTUAL-WIDTH
               NO-ERROR.
               
        RUN resizeLayout( INPUT  pcLayoutCode,
                          INPUT  0,
                          INPUT  phWindow:WIDTH,
                          INPUT  phWindow:HEIGHT,
                          INPUT  0,
                          INPUT  0                ).

        ASSIGN phFrame:WIDTH          = phWindow:WIDTH
               phFrame:HEIGHT         = phWindow:HEIGHT
               phFrame:VIRTUAL-WIDTH  = phFrame:WIDTH
               phFrame:VIRTUAL-HEIGHT = phFrame:HEIGHT
               
               phFrame:SCROLLABLE     = FALSE
               NO-ERROR.
    END.        /* resize me? */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* packWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-packWindowFromSuper) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packWindowFromSuper Procedure 
PROCEDURE packWindowFromSuper :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Wrapper for packWindow.
  Parameters:  As per packWindow
               phSourceProcedure - the TARGET-PROCEDURE of the caller.
  Notes:       * This procedure acts as a wrapper for packWindow() since the API
                 signature cannot be changed. There should be no other code in this,
                 than the setting of the ghSourceProcedure handle and the calling of
                 the packWindow() API.
               * The only thing that this API does is
                 to set the value of the ghSourceProcedure variable to the passed
                 in value. This is needed because the SOURCE-PROCEDURE handle returns
                 the name of the calling procedure itself (and not the TARGET-PROCEDURE
                 of that caller). The Window and Frame code relies on the TARGET-PROCEDURE
                 to distinguish running instances and so this value needs to be 
                 correct otherwise the resizing fails.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber         AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER pcLayoutCode         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER phObjectBuffer       AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phPageBuffer         AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phWindow             AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phFrame              AS HANDLE               NO-UNDO. 
    DEFINE INPUT PARAMETER pdMinPackedWidth     AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdMinPackedHeight    AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdMaxWidth           AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdMaxHeight          AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER plResize             AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER phSourceProcedure    AS HANDLE               NO-UNDO.

    /* Set the value of the source procedure handle */
    ASSIGN ghSourceProcedure = phSourceProcedure.

    IF NOT VALID-HANDLE(ghSourceProcedure) THEN
        ASSIGN ghSourceProcedure = SOURCE-PROCEDURE.
    
    RUN packWindow ( INPUT piPageNumber,
                     INPUT pcLayoutCode,
                     INPUT pdInstanceId,
                     INPUT phObjectBuffer,
                     INPUT phPageBuffer,
                     INPUT phWindow,
                     INPUT phFrame,
                     INPUT pdMinPackedWidth,
                     INPUT pdMinPackedHeight,
                     INPUT pdMaxWidth,
                     INPUT pdMaxHeight,
                     INPUT plResize         ) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF NOT (RETURN-VALUE = "":U OR RETURN-VALUE = ?) THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* packWindowFromSuper */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize00) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize00 Procedure 
PROCEDURE resize00 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     No layout specified
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber         AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerWidth     AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerHeight    AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn      AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow         AS DECIMAL   NO-UNDO.
    
        ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resize01 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize01) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize01 Procedure 
PROCEDURE resize01 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Everything Centred layout
  Parameters:  <none>
  Notes:       Basically sets all objects on page to be in column position 1
               and row 0.24 and sets the width of every object to be the width
               of the container minus 2 and the height of the container minus
               0.48.
               Only useful if a single viewer on a tab page and nothing else, 
               not even a toolbar.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPageNumber         AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerWidth     AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerHeight AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftColumn   AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftRow      AS DECIMAL   NO-UNDO.

DEFINE VARIABLE dObjectHeight               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dObjectWidth                AS DECIMAL      NO-UNDO.            
DEFINE VARIABLE dMaxHeight                  AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dMaxWidth                   AS DECIMAL      NO-UNDO.            
DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE       NO-UNDO.        
DEFINE VARIABLE cObjectTypeCode             AS CHARACTER    NO-UNDO.

DEFINE VARIABLE dNewObjectWidth             AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectHeight            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectColumn            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectRow               AS DECIMAL      NO-UNDO.

    DEFINE VARIABLE iLoop                                               AS INTEGER                              NO-UNDO.
    DEFINE VARIABLE cPageNTargets                               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLe cLayoutPosition                             AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cAllPageTargets                     AS CHARACTER                    NO-UNDO.
    
    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piPageNumber EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
                
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
        END.    /* page 0 */
        ELSE
                ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                                                    INPUT ghSourceProcedure,
                                                                                    INPUT piPageNumber          ).
    
        DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
                IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
                        NEXT.
        
        &SCOPED-DEFINE xp-assign                
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
        &UNDEFINE xp-assign  
              

        dNewObjectWidth = dObjectWidth.
        dNewObjectHeight = dObjectHeight.
        dNewObjectColumn = 1.
        dNewObjectRow = 0.24.

        RUN resizeAndMoveSomething IN THIS-PROCEDURE ( 
            INPUT  piPageNumber,  
            INPUT  cObjectTypeCode,
            INPUT  hObjectInstanceHandle,        
            INPUT  pdTopLeftColumn,
            INPUT  pdTopLeftRow,
            INPUT  dNewObjectColumn, 
            INPUT  dNewObjectRow,
            INPUT  dNewObjectWidth,
            INPUT  dNewObjectHeight     ).            
    END.        /* loop through pageNtargets */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resize01 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize02) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize02 Procedure 
PROCEDURE resize02 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Top/Centre/Bottom Layout
  Parameters:  <none>
  Notes:       To re-layout objects on container.

               TOP OBJECTS
               Objects with a layout position of top are placed at column
               position 1 and the width is set to the window width minus 2,
               therefore leaving a 1 character margin on either side of the object.
               The exception is if the top object is a toolbar, in which case its
               column position is set to 0 and it is made full window width.
               The row for the top object is set at 1 for non toolbars and at 0
               for toolbars.

               BOTTOM OBJECTS
               Objects with a layout position of bottom are placed at column
               position 1 and the width is set to the window width minus 2,
               therefore leaving a 1 character margin on either side of the object.
               The row is the container height minus the object height, unless it is
               a toolbar where the row is set 1 pixel higher. 

               CENTRE OBJECTS
               Objects with a layout position of centre are placed at column
               position 1 and the width is set to the window width minus 2,
               therefore leaving a 1 character margin on either side of the object.

               The row of the centre object is the row of the top object plus the
               height of the top object (if any) + 0.24 for a gap.
               The height of the centre object is the space left between the top
               object and the bottom object if specified, i.e. the rest of the 
               space left on the container. This will work even if there is no 
               top and/or bottom object. Basically in this layout it is therefore
               the centre object that gets resized vertically when the container is
               resized.

               This layout assumes a maximum of 1 top, 1 centre and 1 bottom 
               object. It is useful for object controllers with no viewer and
               for folder pages that contain just a browser and a toolbar, or
               just a viewer and a toolbar. Only the centre object will ever be
               made bigger vertically.

------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNumber       AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER pdContainerWidth   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdContainerHeight  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdTopLeftColumn    AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdTopLeftRow       AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dDesiredHeight            AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dDesiredWidth             AS DECIMAL      NO-UNDO.  
  DEFINE VARIABLE dObjectHeight             AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dObjectWidth              AS DECIMAL      NO-UNDO.            
  DEFINE VARIABLE dMaxHeight                AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dMaxWidth                 AS DECIMAL      NO-UNDO.            
  DEFINE VARIABLE hObjectInstanceHandle     AS HANDLE       NO-UNDO.        
  DEFINE VARIABLE cObjectTypeCode           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iCenterTopRow             AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE iCenterBottomRow          AS DECIMAL      NO-UNDO. 
  DEFINE VARIABLE dNewObjectWidth           AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectHeight          AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectColumn          AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectRow             AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE lTopObjects               AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE lBottomObjects            AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cPageNTargets             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cLayoutPosition           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cAllPageTargets           AS CHARACTER    NO-UNDO.
  
  ASSIGN dDesiredWidth        = pdContainerWidth  - 2
         dDesiredHeight       = pdContainerHeight - 0.24 - (IF piPageNumber = 0 THEN 0 ELSE 0.24)
         iCenterTopRow        =  0
         iCenterBottomRow     = iCenterTopRow + dDesiredHeight.
                 
    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piPageNumber EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
                
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
    END.    /* page 0 */
    ELSE
        ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                INPUT ghSourceProcedure,
                                                INPUT piPageNumber          ).
    /* TOP components */
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
	        NEXT.
        
        &SCOPED-DEFINE xp-assign   
        {get ClassName cObjectTypeCode hObjectInstanceHandle}
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}.
        &UNDEFINE xp-assign
        
        IF NOT cLayoutPosition BEGINS "TOP":U THEN
                NEXT.
                
        /* Tell the others that there is at least one TOP component */  
        ASSIGN lTopObjects = YES.
        
        {get Height dObjectHeight hObjectInstanceHandle} NO-ERROR.
        {get Width  dObjectWidth  hObjectInstanceHandle} NO-ERROR.
      
        IF {fnarg instanceOf 'SmartToolbar' hObjectInstanceHandle} then
            ASSIGN dNewObjectRow    = 0
                   dNewObjectColumn = 0
                   dNewObjectWidth  = dDesiredWidth + 2.
        ELSE
            ASSIGN dNewObjectColumn = 1
                   dNewObjectWidth  = dDesiredWidth
                   dNewObjectRow    = 0.48.
                           
        ASSIGN dNewObjectHeight = dObjectHeight
               iCenterTopRow    = MAX(iCenterTopRow, dNewObjectRow + dObjectHeight).        
                   
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,
                                     INPUT  cObjectTypeCode,
                                     INPUT  hObjectInstanceHandle,
                                     INPUT  pdTopLeftColumn,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn,
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight            ).      
    END.    /* all TOP objects */
                    
    /* BOTTOM components */
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}.
        IF NOT cLayoutPosition BEGINS "BOT":U THEN
            NEXT.
        
        ASSIGN lBottomObjects = YES.                                    
                
        {get Height dObjectHeight hObjectInstanceHandle} NO-ERROR.
        {get Width  dObjectWidth  hObjectInstanceHandle} NO-ERROR.
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
                                
        ASSIGN dNewObjectColumn = 1
                   dNewObjectRow    = 0.24 + dDesiredHeight - dObjectHeight
                   dNewObjectHeight = dObjectHeight
                   dNewObjectWidth  = dDesiredWidth
                   iCenterBottomRow = MIN(iCenterBottomRow, dNewObjectRow).
        
        IF {fnarg instanceOf 'SmartToolbar' hObjectInstanceHandle} then
            /* all toolbars positioned in bottom are drawn one pixel 
               higher up the screen, and one pixel deeper
             */
            dNewObjectRow = dNewObjectRow - (1 * dCharsPerRowPixel).
            
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,  
                                     INPUT  cObjectTypeCode,
                                     INPUT  hObjectInstanceHandle,
                                     INPUT  pdTopLeftColumn,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn, 
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight         ).
    END.    /* all BOTTOM objects */

    /* CENTRE components */
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.

        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}.
        IF NOT cLayoutPosition BEGINS "CENT":U THEN
            NEXT.
        
        {get Height dObjectHeight hObjectInstanceHandle} NO-ERROR.
        {get Width  dObjectWidth  hObjectInstanceHandle} NO-ERROR.  
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
                
        ASSIGN dNewObjectColumn = 1
               dNewObjectRow    = (IF lTopObjects THEN 0.24 ELSE 0) + iCenterTopRow
               dNewObjectHeight = iCenterBottomRow - iCenterTopRow - 0.24 - (IF lBottomObjects AND piPageNumber = 0 THEN 0.24 ELSE 0)
               dNewObjectWidth  = dDesiredWidth.
                           
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,  
                                     INPUT  cObjectTypeCode,
                                     INPUT  hObjectInstanceHandle,
                                     INPUT  pdTopLeftColumn,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn, 
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight            ).                                                                   
    END.    /* all CENTRE objects */
                
    ERROR-STATUS:ERROR = NO.
    RETURN.         
END PROCEDURE.  /* resize02 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize03 Procedure 
PROCEDURE resize03 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Top/Multi/Bottom Layout
  Parameters:  <none>
  Notes:       To re-layout objects on container.

               TOP OBJECTS
               Objects with a layout position of top are placed at column
               position 1 and the width is set to the window width minus 2,
               therefore leaving a 1 character margin on either side of the object.
               The exception is if the top object is a toolbar, in which case its
               column position is set to 0 and it is made full window width.
               The row for the top object is set at 1 for non toolbars and at 0
               for toolbars.

               BOTTOM OBJECTS
               Objects with a layout position of bottom are placed at column
               position 1 and the width is set to the window width minus 2,
               therefore leaving a 1 character margin on either side of the object.
               The row is the container height minus the object height, unless it is
               a toolbar where the row is set 1 pixel higher. 

               CENTRE OBJECTS
               Objects with a layout position of centre are placed at column
               position 1 and the width is set to the window width minus 2,
               therefore leaving a 1 character margin on either side of the object.

               The row of the 1st centre object is the row of the top object plus the
               height of the top object (if any) + 0.24 for a gap.
               The space left in the middle is then divided up between all the centre
               objects. Non-resizable objects remain at a fixed height, and the
               remaining space is then divided equally amongst the resizable objects.

               We know if an object is resizable by the existance of an internal
               procedure called resizeObject. The exception to this is for toolbars
               which we never resize vertically in this layout.

               This layout assumes a maximum of 1 top and 1 bottom object, and
               any number of objects in the centre.
               Objects that are resizable in the centre will share the remaining
               space equally, after working out how much space the non resizable
               centre objects need.
               A small gap is left between the centre objects, and a smaller gap 
               is left if it is a toolbar, to cope with toolbars under browsers
               in the centre.
               This layout will cope with a wide variety of applications. Its only
               real limitation is that it makes all objects full width.
               This layout assumes all toolbars are horizontally aligned.

------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPageNumber      AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerWidth  AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerHeight AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftColumn   AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftRow      AS DECIMAL   NO-UNDO.

DEFINE VARIABLE dDesiredHeight              AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dDesiredWidth               AS DECIMAL      NO-UNDO.  
DEFINE VARIABLE dObjectHeight               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dObjectWidth                AS DECIMAL      NO-UNDO.            
DEFINE VARIABLE dMaxHeight                  AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dMaxWidth                   AS DECIMAL      NO-UNDO.            
DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE       NO-UNDO.        
DEFINE VARIABLE cObjectTypeCode             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCenterTopRow               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE iCenterBottomRow            AS DECIMAL      NO-UNDO. 

DEFINE VARIABLE dNewObjectWidth             AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectHeight            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectColumn            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectRow               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dCentreRow                  AS DECIMAL      NO-UNDO.

DEFINE VARIABLE iNumToolbar                 AS INTEGER      NO-UNDO.
DEFINE VARIABLE iNumStatic                  AS INTEGER      NO-UNDO.
DEFINE VARIABLE iNumResize                  AS INTEGER      NO-UNDO.
DEFINE VARIABLE dStaticHeight               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dCentreResizeHeight         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dGaps                       AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dHeightLeft                 AS DECIMAL      NO-UNDO.

    DEFINE VARIABLE iLoop                    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cPageNTargets            AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cLayoutPosition          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cAllPageTargets          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cCentreObjects           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cBottomObjects           AS CHARACTER  NO-UNDO.    
    DEFINE VARIABLE lQueryObject             AS LOGICAL      NO-UNDO.  
    
    ASSIGN dDesiredWidth    = pdContainerWidth  - (1 + 1)
           dDesiredHeight   = pdContainerHeight - 0.24
           iCenterTopRow    = 0
           iCenterBottomRow = iCenterTopRow + dDesiredHeight.
    
    /* Get all of the objects on the specified page.
       There is currently no support for Page0 in the PageN functionality,
       so the objects on page zero need to be derived from the 
     */
    IF piPageNumber EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
        
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
    END.    /* page 0 */
    ELSE
        ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                INPUT ghSourceProcedure,
                                                INPUT piPageNumber          ).
                                                
    ASSIGN iNumStatic     = 0
           iNumToolbar    = 0
           iNumResize     = 0
           dStaticHeight  = 0
           cCentreObjects = "":U
           cBottomObjects = "":U.
           
    /* TOP components */
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
            NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
           ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        &SCOPED-DEFINE xp-assign
        {get QueryObject lQueryObject hObjectInstanceHandle}
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}
        {get Height dObjectHeight hObjectInstanceHandle}
        NO-ERROR.
        &UNDEFINE xp-assign
        
        /* Skip Query objects */
        IF lQueryObject THEN
            NEXT.
            
       /* Build list of Bottom and Centre objects so that we 
          can reduct the amount of work we do in figuring out
          which things go where.
        */
        IF cLayoutPosition BEGINS "CENT":U THEN
            ASSIGN cCentreObjects = cCentreObjects + ",":U + STRING(hObjectInstanceHandle).
        ELSE            
        IF cLayoutPosition BEGINS "BOT":U THEN
            ASSIGN cBottomObjects = cBottomObjects + ",":U + STRING(hObjectInstanceHandle).
            
        /* But right now we only care about the Top components */
        IF NOT cLayoutPosition BEGINS "TOP":U THEN
            NEXT.
        
        IF {fnarg instanceOf 'SmartToolbar' hObjectInstanceHandle} THEN
            ASSIGN dNewObjectRow    = 0
                   dNewObjectColumn = 0
                   dNewObjectWidth = dDesiredWidth + 2.
        ELSE
            ASSIGN dNewObjectColumn = 1
                   dNewObjectWidth  = dDesiredWidth
                   dNewObjectRow    = 1.
                                   
        ASSIGN dNewObjectHeight = dObjectHeight
               iCenterTopRow    = MAX(iCenterTopRow, dNewObjectRow + dObjectHeight).
        
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,
                                     INPUT  cObjectTypeCode,
                                     INPUT  hObjectInstanceHandle,
                                     INPUT  pdTopLeftColumn - 0.12,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn, 
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight       ).
    END.    /* TOP components */
    
    ASSIGN cCentreObjects = LEFT-TRIM(cCentreObjects, ",":U)
           cBottomObjects = LEFT-TRIM(cBottomObjects, ",":U).
    
    /* BOTTOM components */
    DO iLoop = 1 TO NUM-ENTRIES(cBottomObjects):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cBottomObjects)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
            NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        &SCOPED-DEFINE xp-assign
        {get QueryObject lQueryObject hObjectInstanceHandle}
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}
        {get Height dObjectHeight hObjectInstanceHandle}
        NO-ERROR.
        &UNDEFINE xp-assign
        
        IF lQueryObject THEN
            NEXT.
        
        ASSIGN dNewObjectColumn = 1
               dNewObjectRow    = 0.24 + dDesiredHeight - dObjectHeight
               dNewObjectHeight = dObjectHeight
               dNewObjectWidth  = dDesiredWidth
               iCenterBottomRow = MIN(iCenterBottomRow, dNewObjectRow).

        IF {fnarg instanceOf 'SmartToolbar' hObjectInstanceHandle} then
            /* all toolbars positioned in bottom are drawn one pixel higher up the screen, and one pixel deeper */            
            ASSIGN dNewObjectRow = dNewObjectRow - (1 * dCharsPerRowPixel).
        
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,  
                                     INPUT  cObjectTypeCode,
                                     INPUT  hObjectInstanceHandle,        
                                     INPUT  pdTopLeftColumn - 0.12,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn, 
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight       ).                               
    END.    /* BOTTOM components */
    
    /* Centre components. These must be built separately
       because it is possible to have ONLY centre positioned objects
       on a page, so the centre temp-table cannot be built as part of
       the TOP or BOTTOM loops.
     */
    DO iLoop = 1 TO NUM-ENTRIES(cCentreObjects):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cCentreObjects)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
            NEXT.
        
        /* If we are looking for page zero objects, and the object exists on another page,
           ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.

        &SCOPED-DEFINE xp-assign
        {get QueryObject lQueryObject hObjectInstanceHandle}
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}
        {get Height dObjectHeight hObjectInstanceHandle}
        NO-ERROR.
        &UNDEFINE xp-assign
        
        IF lQueryObject THEN
            NEXT.
        
        CREATE ttCentre.
        ASSIGN ttCentre.hInstanceHandle = hObjectInstanceHandle
               ttCentre.tLayoutPosition = cLayoutPosition
               ttCentre.cObjectTypeCode = cObjectTypeCode.
        /* Separate assignments to avoid error 7955 */
        ASSIGN ttCentre.lToolbar = {fnarg instanceOf 'SmartToolbar' hObjectInstanceHandle}
               ttCentre.lResize  = NOT ttCentre.lToolbar AND {fnarg Signature 'resizeObject' hObjectInstanceHandle} NE "":U.
        
        IF ttCentre.lResize THEN
            ASSIGN iNumResize = iNumResize + 1.
        ELSE
        DO:
            IF NOT ttCentre.lToolbar THEN
                ASSIGN iNumStatic = iNumStatic + 1.
            ELSE
                ASSIGN iNumToolbar = iNumToolbar + 1.
            
            IF dObjectHeight NE ? THEN
                ASSIGN dStaticHeight = dStaticHeight + dObjectHeight.
        END.    /* not resizable */
    END.    /* centre */
    
    /* Work out height of resizable centre objects */
    IF iNumResize = 0 THEN
        ASSIGN dCentreResizeHeight = 0.
    ELSE
        ASSIGN dGaps               = (iNumStatic + iNumResize) * 0.24
               dHeightLeft         = iCenterBottomRow - iCenterTopRow - 0.24 - dGaps - dStaticHeight
               dCentreResizeHeight = IF dHeightLeft > 0 THEN (dHeightLeft / iNumResize) ELSE 0.
    
    /* now process centre objects in order */
    ASSIGN dCentreRow = 0.24 + iCenterTopRow.
    
    FOR EACH ttCentre BY ttCentre.tLayoutPosition:        
        /* Only work with centre components that are on the current object/page.
           The ttCentre temp-table may contain may centre components, and we only
           want to work with the current subset right now.
         */
        IF NOT CAN-DO(cCentreObjects, STRING(ttCentre.hInstanceHandle)) THEN
            NEXT.
        
        IF ttCentre.lToolbar THEN
            ASSIGN dCentreRow = dCentreRow - 0.24.  /* no gap for toolbars */
        
        ASSIGN dNewObjectColumn = 1
               dNewObjectWidth = dDesiredWidth
               dNewObjectRow   = dCentreRow
               dNewObjectHeight = ?.
                       
        IF ttCentre.lResize AND dCentreResizeHeight <> 0 THEN
            ASSIGN dNewObjectHeight = dCentreResizeHeight.
        ELSE
            {get Height dNewObjectHeight ttCentre.hInstanceHandle} NO-ERROR.
        
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,  
                                     INPUT  ttCentre.cObjectTypeCode,
                                     INPUT  ttCentre.hInstanceHandle,
                                     INPUT  pdTopLeftColumn - 0.12,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn, 
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight   ).
        
        /* get next row position */
        ASSIGN dCentreRow = dCentreRow + dNewObjectHeight + 0.24.
    END.    /* each ttCentre */             
        
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resize03 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize04) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize04 Procedure 
PROCEDURE resize04 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Layout = left/centre/right
  Parameters:  <none>
  Notes:       Not used yet and needs testing / reworking !!!!
               Will be for associative entity layouts with 2 browsers side by
               side and a vertical toolbar between them.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPageNumber      AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerWidth  AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerHeight AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftColumn   AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftRow      AS DECIMAL   NO-UNDO.

DEFINE VARIABLE dDesiredHeight              AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dDesiredWidth               AS DECIMAL      NO-UNDO.  
DEFINE VARIABLE dObjectHeight               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dObjectWidth                AS DECIMAL      NO-UNDO.            
DEFINE VARIABLE dMaxHeight                  AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dMaxWidth                   AS DECIMAL      NO-UNDO.            
DEFINE VARIABLE hPageInstanceQuery          AS HANDLE       NO-UNDO.
DEFINE VARIABLE hLocalObjectBuffer         AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE       NO-UNDO.        
DEFINE VARIABLE cObjectTypeCode             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCenterLeftCol               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE iCenterBottomRow            AS DECIMAL      NO-UNDO. 

DEFINE VARIABLE dNewObjectWidth             AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectHeight            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectColumn            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectRow               AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cPageNTargets             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cLayoutPosition           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cAllPageTargets           AS CHARACTER    NO-UNDO.
  
    ASSIGN dDesiredWidth  = (pdContainerWidth / 2) - 8
           dDesiredHeight = pdContainerHeight - 3
           iCenterLeftCol =  1.
          
    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piPageNumber EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
            
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
    END.    /* page 0 */
    ELSE
        ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                INPUT ghSourceProcedure,
                                                INPUT piPageNumber          ).
    /* LEFT components */
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.

        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        &SCOPED-DEFINE xp-assign
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
        &UNDEFINE xp-assign
        
        IF NOT cLayoutPosition BEGINS "LEFT":U THEN
            NEXT.
                
        {get Height dObjectHeight hObjectInstanceHandle} NO-ERROR.
        {get Width  dObjectWidth  hObjectInstanceHandle} NO-ERROR.
                                                                                                  
        IF {fnarg instanceOf 'SmartToolbar' hObjectInstanceHandle} then
            ASSIGN dNewObjectColumn = 1
                   dNewObjectWidth  = 0.
        ELSE
            ASSIGN dNewObjectRow    = 0
                   dNewObjectHeight = dDesiredHeight.
                           
        ASSIGN dNewObjectWidth = dDesiredWidth
               iCenterLeftCol = MAX(iCenterLeftCol, dNewObjectColumn + dObjectWidth).
                           
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,  
                                     INPUT  cObjectTypeCode,
                                     INPUT  hObjectInstanceHandle,        
                                     INPUT  pdTopLeftColumn,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn, 
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight         ).
    END.    /* LEFT */
        
    /* RIGHT components */
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.

        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        &SCOPED-DEFINE xp-assign
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
        &UNDEFINE xp-assign
        
        IF NOT cLayoutPosition BEGINS "RIGHT":U THEN
            NEXT.
                
        {get Height dObjectHeight hObjectInstanceHandle} NO-ERROR.
        {get Width  dObjectWidth  hObjectInstanceHandle} NO-ERROR.
        
        ASSIGN dNewObjectColumn = pdContainerWidth - dDesiredWidth - 1
               dNewObjectRow    = 0
               dNewObjectHeight = dDesiredHeight
               dNewObjectWidth  = dDesiredWidth
               iCenterBottomRow = MIN(iCenterBottomRow, dNewObjectRow). 
        IF {fnarg instanceOf 'SmartToolbar' hObjectInstanceHandle} then
            /* all toolbars positioned in bottom are drawn one pixel higher up the screen, and one pixel deeper */
            ASSIGN dNewObjectRow = dNewObjectRow - (1 * dCharsPerRowPixel).
                
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,  
                                     INPUT  cObjectTypeCode,
                                     INPUT  hObjectInstanceHandle,        
                                     INPUT  pdTopLeftColumn,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn, 
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight         ).
    END.    /* RIGHT  */
        
    /* CENTRE components */
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.                
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.

        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        &SCOPED-DEFINE xp-assign
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
        &UNDEFINE xp-assign
        
        IF NOT cLayoutPosition BEGINS "CENT":U THEN
            NEXT.
                
        IF {fnarg instanceOf 'SmartToolbar' hObjectInstanceHandle} then
            ASSIGN dNewObjectColumn = pdContainerWidth / 2
                   dNewObjectWidth  = 5.
        ELSE
            ASSIGN dNewObjectColumn = MAX(iCenterLeftCol, dNewObjectColumn + dObjectWidth)
                   dNewObjectRow    = 0
                   dNewObjectHeight = dDesiredHeight
                   dNewObjectWidth  = dDesiredWidth.
                
        RUN resizeAndMoveSomething ( INPUT  piPageNumber,  
                                     INPUT  cObjectTypeCode,
                                     INPUT  hObjectInstanceHandle,        
                                     INPUT  pdTopLeftColumn,
                                     INPUT  pdTopLeftRow,
                                     INPUT  dNewObjectColumn, 
                                     INPUT  dNewObjectRow,
                                     INPUT  dNewObjectWidth,
                                     INPUT  dNewObjectHeight         ).
    END.    /* CENTRE */
        
    ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize05) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize05 Procedure 
PROCEDURE resize05 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     TreeView Layout
  Parameters:  <none>
  Notes:       To re-layout objects on a TreeView Container.

               We know that the Dynamic TreeView will have a top toolbar, a 
               TreeView object, a Resize Fill-In widget and a possible filter
               viewer.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber       AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerWidth   AS DECIMAL    NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerHeight  AS DECIMAL    NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn    AS DECIMAL    NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow       AS DECIMAL    NO-UNDO.
        
    DEFINE VARIABLE hPageInstanceQuery      AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer      AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hObjectInstanceHandle   AS HANDLE    NO-UNDO.
          
    DEFINE VARIABLE hTreeViewOCX            AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hFilterViewer           AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hTopToolbar             AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hTitleBar               AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hResizeBar              AS HANDLE    NO-UNDO.
        
    DEFINE VARIABLE dFilterViewerHeight     AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dFilterViewerWidth      AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTopToolbarHeight       AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTopToolbarWidth        AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTreeViewHeight         AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dTreeViewWidth          AS DECIMAL   NO-UNDO. 
    DEFINE VARIABLE dObjectWidth            AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dObjectHeight           AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dRow                    AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE cObjectTypeCode         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iLoop                   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cContainerTargets       AS CHARACTER NO-UNDO.
 
    /* First get the things we know about. These are the hard-coded (non Repository-based)
       components used by the treeview.
     */
    ASSIGN hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN ghSourceProcedure)
           hTitleBar    = DYNAMIC-FUNCTION("getTitleBar":U IN ghSourceProcedure)
           hResizeBar   = DYNAMIC-FUNCTION("getResizeBar":U IN ghSourceProcedure).
    
    /* The top toolbar will be on the end of the ContainerToolbar link. */
    ASSIGN hTopToolbar = WIDGET-HANDLE({fnarg linkHandles '"ContainerToolbar-Source"' ghSourceProcedure}) NO-ERROR.
    /* The filter viewer will be on the front of the TreeFilter link. */
    ASSIGN hFilterViewer = WIDGET-HANDLE({fnarg linkHandles '"TreeFilter-Source"' ghSourceProcedure}) NO-ERROR.    
    
    /* Now we have the sizes of the objects, let's reposition them.
       The TopToolbar will always be in the top left corner
     */
    IF VALID-HANDLE(hTopToolbar) THEN 
    DO:
        {get Height dTopToolbarHeight hTopToolbar}.
        
        RUN repositionObject IN hTopToolbar (INPUT 1, INPUT 1) NO-ERROR.
        RUN resizeObject IN hTopToolbar (INPUT dTopToolbarHeight, INPUT pdContainerWidth) NO-ERROR.
        
        ASSIGN dRow = 1 + dTopToolbarHeight + 0.24.
    END.    /* valid top toolbar */
    
    /* If there is a filter viewer, it should be just below the Top Toolbar */
    IF VALID-HANDLE(hFilterViewer) THEN
    DO:
        {get Height dFilterViewerHeight hFilterViewer}.
        
        RUN repositionObject IN hFilterViewer (INPUT dRow, INPUT 1) NO-ERROR.
        RUN resizeObject IN hFilterViewer (INPUT dFilterViewerHeight, INPUT pdContainerWidth) NO-ERROR.
        
        ASSIGN dRow = dRow + dFilterViewerHeight + 0.24.
    END.    /* valid filter */
    
    /* The TreeView OCX should be just below the Top Toolbar or 
       just below the Filter Viewer (if any).
     */
    IF VALID-HANDLE(hTreeViewOCX) THEN
    DO:
        {get Width  dTreeViewWidth  hTreeViewOCX}.
        {get Height dTreeViewHeight hTreeViewOCX}.
        
        RUN repositionObject IN hTreeViewOCX (INPUT dRow, INPUT 1) NO-ERROR.
        RUN resizeObject IN hTreeViewOCX (INPUT (pdContainerHeight - dRow) + 1, INPUT dTreeViewWidth) NO-ERROR.
    END.    /* treeview OCX */
    
    /* For the Resize Bar we should not be setting the COLUMN since this is handled by code
       in the TreeView super procedure to resize the width of the TreeView OCX. We just need
       to ensure that the row is set correctly
     */
    IF VALID-HANDLE(hResizeBar) THEN
        ASSIGN hResizeBar:ROW    = dRow
               hResizeBar:HEIGHT = (pdContainerHeight - dRow) + 1
               NO-ERROR.
    
    /* The Title Fill-IN will need to be moved and resized
     */
    IF VALID-HANDLE(hTitleBar) THEN
        ASSIGN hTitleBar:WIDTH = 1 /* First size smaller to move */
               hTitleBar:ROW   = dRow
               hTitleBar:COL   = dTreeViewWidth + 3
               hTitleBar:WIDTH = pdContainerWidth - dTreeViewWidth - 2.5
               NO-ERROR.

    /* Now resize any remaining objects on the window. */
    /* Get all of the objects on the treeview. */
    {get ContainerTarget cContainerTargets ghSourceProcedure}.
    
    DO iLoop = 1 TO NUM-ENTRIES(cContainerTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cContainerTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
        
        /* We know about some of the things ... */
        IF hObjectInstanceHandle EQ hTreeViewOCX  OR
           hObjectInstanceHandle EQ hTitleBar     OR
           hObjectInstanceHandle EQ hResizeBar    OR
           hObjectInstanceHandle EQ hTopToolbar   OR
           hObjectInstanceHandle EQ hFilterViewer THEN
            NEXT.
        
        /* The stuff that's left will typically be the child information folder windows. */            
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
                                
        RUN resizeAndMoveSomething IN TARGET-PROCEDURE ( INPUT  piPageNumber,
                                                         INPUT  cObjectTypeCode,
                                                         INPUT  hObjectInstanceHandle,
                                                         INPUT  pdTopLeftColumn,
                                                         INPUT  pdTopLeftRow,
                                                         INPUT  hResizeBar:COLUMN + hResizeBar:WIDTH + 0.24, /* pdNewColumn */
                                                         INPUT  hTitleBar:ROW,                               /* pdNewRow */
                                                         INPUT  hTitleBar:WIDTH,                             /* pdNewWidth */
                                                         INPUT  pdContainerHeight - hTitleBar:ROW - 0.24     /* pdNewHeight */ ).
    END.           /* loop for all objects on the page */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resize05 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize06) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize06 Procedure 
PROCEDURE resize06 :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Resize program for Relative layout.
  Parameters:  
            INPUT piPageNumber      AS INTEGER
            INPUT pdContainerHeight AS DECIMAL
            INPUT pdTopLeftColumn   AS DECIMAL
            INPUT pdTopLeftRow      AS DECIMAL
  Notes:    
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber             AS INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerWidth         AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerHeight        AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn          AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow             AS DECIMAL          NO-UNDO.
    
    DEFINE VARIABLE cLayoutPosition         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLayoutCode             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iVarWidthInstances      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iNumVarHeightRows       AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iLayoutRow              AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iRowNum                 AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iMaxRow                 AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE dTotalFixedHeight       AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dAverageRowHeight       AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dAvailableHeight        AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dAvailableWidth         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dDesiredHeight          AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dDesiredWidth           AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dAverageWidth           AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dNewObjectColumn        AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dNewObjectHeight        AS DECIMAL                  NO-UNDO.   
    DEFINE VARIABLE dNewObjectWidth         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dNewObjectRow           AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dPrevRowHeight          AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dBottomRow              AS DECIMAL                  NO-UNDO.

    DEFINE BUFFER bttInstance  FOR ttInstance.
    DEFINE BUFFER bttRow       FOR ttRow.

    /* Determine the maximum area we can work in. */
    ASSIGN dDesiredWidth  = pdContainerWidth  - 1
           dDesiredHeight = pdContainerHeight - 0.24.
           
    /* Populate the ttRow and ttInstance temp-tables. */
    DYNAMIC-FUNCTION("buildRowsAndInstances":U IN TARGET-PROCEDURE,
                     INPUT ghSourceProcedure,
                     INPUT piPageNumber       ).
                     
    /* Now that we've populated the Row table, we need to go back through it    
     * to reapportion any remaining available height among the variable height rows.
     * This takes two passes, one to calculate the number of variable height rows and
     * the total fixed height to allocate before resizing those variable height rows,
     * and then a second pass to actually adjust the height of the variable rows.     */
    FOR EACH bttRow WHERE
             bttRow.SourceProcedure = ghSourceProcedure AND
             bttRow.PageNum         = piPageNumber
             BY bttRow.RowNum:
        ASSIGN iMaxRow = MAX(iMaxRow, bttRow.RowNum).
        
        IF bttRow.FixedHeight THEN
            ASSIGN dTotalFixedHeight = dTotalFixedHeight + bttRow.RowHeight + 0.24.
        ELSE
            ASSIGN iNumVarHeightRows = iNumVarHeightRows + 1.
    END.   /* END first FOR EACH bttRow */
    
    /* If the row height, calculated by dividing the non-fixed height by the number of variable
     * rows, is less than the minimum height of any of the rows, the row heights of these rows
     * must be set to the row's minimum height. The remainder of the available height will be
     * shared out between the rows which do not have minumum heights.                        */
    IF iNumVarHeightRows GT 0 THEN
    DO:
        ASSIGN dAvailableHeight  = dDesiredHeight - dTotalFixedHeight
               dAverageRowHeight = dAvailableHeight / iNumVarHeightRows
               .
        /* First reserve space for those rows with minimum heights that
         * are greater than the height they would be alocated by default. */
        FOR EACH bttRow WHERE
                 bttRow.SourceProcedure = ghSourceProcedure AND
                 bttRow.PageNum         = piPageNumber      AND
                 bttRow.Fixedheight     = NO:
            IF bttRow.MinHeight GT dAverageRowHeight THEN
                ASSIGN bttRow.RowHeight  = bttRow.MinHeight
                       dAvailableHeight  = dAvailableHeight - bttRow.RowHeight
                       iNumVarHeightRows = iNumVarHeightRows - 1.
            ELSE
                ASSIGN bttRow.MinHeight = 0.
        END.    /* rows with min heights min heights.*/

        /* If there are any rows left, ensure that they are at least their minimum heights.
         * Exclude any rows catered for above.                                              */  
        IF iNumVarHeightRows GT 0 THEN
        DO:
            ASSIGN dAverageRowHeight = dAvailableHeight / iNumVarHeightRows.
            /* Allocate the remaining height available between all remaining rows */
            FOR EACH bttRow WHERE
                     bttRow.SourceProcedure = ghSourceProcedure AND
                     bttRow.PageNum         = piPageNumber      AND
                     bttRow.Fixedheight     = NO                AND
                     bttRow.MinHeight       = 0 :
                ASSIGN bttRow.RowHeight = dAverageRowHeight.
            END.    /* rows without a minimum height. */
        END.    /* ther are min var height rows available. */
    END.    /* variable height rows exist. */

    /* Calculate the widths of the objects in each row, ensuring that an object cannot be sized 
     * smaller that its individual MinWidth. */
    FOR EACH bttRow WHERE             
             bttRow.SourceProcedure = ghSourceProcedure AND
             bttRow.PageNum         = piPageNumber
             BY bttRow.RowNum:
        ASSIGN dAvailableWidth    = dDesiredWidth - bttRow.FixedHorizontalSize
               iVarWidthInstances = bttRow.NumResizeHorizontal
               dAverageWidth      = (dAvailableWidth) / iVarWidthInstances - 1
               .
        FOR EACH bttInstance WHERE
                 bttInstance.SourceProcedure = ghSourceProcedure AND
                 bttInstance.PageNum         = bttRow.PageNum    AND
                 bttInstance.RowNum          = bttRow.RowNum     AND
                 bttInstance.FixedWidth      = NO                :
            IF bttInstance.MinWidth GT dAverageWidth THEN
                ASSIGN bttInstance.ObjectWidth = bttInstance.MinWidth
                       dAvailableWidth         = dAvailableWidth    - bttInstance.ObjectWidth
                       iVarWidthInstances      = iVarWidthInstances - 1.
            ELSE
                ASSIGN bttInstance.MinWidth = 0.
        END.    /* each instance on a row */
    
        IF iVarWidthInstances GT 0 THEN
        DO:
            ASSIGN dAverageWidth = (dAvailableWidth) / iVarWidthInstances - 1.
    
            FOR EACH bttInstance WHERE
                     bttInstance.SourceProcedure = ghSourceProcedure AND
                     bttInstance.PageNum         = piPageNumber      AND
                     bttInstance.RowNum          = bttRow.RowNum     AND
                     bttInstance.MinWidth        = 0                 AND
                     bttInstance.FixedWidth      = NO                :
                ASSIGN bttInstance.ObjectWidth = dAverageWidth.
            END.    /* each instance on a row where the min height is 0 */
        END.    /* there are still some variable width instances. */
    END.    /* each page, per row. */
    
    /* Now make a second pass through the objects by reading the Instance temp-table.
     * Adjust the size of each based on the characteristics of the row and the available size. */
    ASSIGN iRowNum       = 0
           dNewObjectRow = 0
           .
    FOR EACH bttInstance WHERE
             bttInstance.SourceProcedure = ghSourceProcedure AND
             bttInstance.PageNum         = piPageNumber             
             BY bttInstance.RowCol:
        ASSIGN cLayoutCode  = IF bttInstance.JustifyPosition EQ "":U THEN "M":U ELSE bttInstance.JustifyPosition
               iLayoutRow   = bttInstance.RowNum.
        IF iLayoutRow > iRowNum THEN
        DO:
            /* Start on the objects in a new row. */
            ASSIGN iRowNum = iLayoutRow
                   /* A top toolbar is positioned at column 0;
                    * other objects at column 1. */
                   dNewObjectColumn = (IF {fnarg InstanceOf 'SmartToolbar' bttInstance.ObjectInstanceHandle} AND 
                                          iLayoutRow EQ 1 THEN 0 ELSE 1).
            ASSIGN dPrevRowHeight = (IF AVAILABLE bttRow THEN bttRow.RowHeight ELSE 0).
            FIND bttRow WHERE
                 bttRow.SourceProcedure = ghSourceProcedure AND
                 bttRow.PageNum         = piPageNumber      AND
                 bttRow.RowNum          = iLayoutRow
                 NO-ERROR.
            /* If this is the bottom row, then position it at the bottom and leave it out
             * of the rolling calculation of newObjectRow. */
            IF AVAILABLE bttRow AND bttRow.BottomSection THEN
                ASSIGN dBottomRow = dDesiredHeight - bttRow.RowHeight. /* + .24 ?? */
            ELSE
            IF iLayoutRow NE 1 THEN
                /* Always shift the object down slightly, even if this is a toolbar we are dealing with.
                 * This is because the this is not the top row.                                         */
                ASSIGN dNewObjectRow = dNewObjectRow + dPrevRowHeight + 0.12.
        END.     /* END DO IF new iLayoutRow */
        /* If this isn't the first object in the row, then increment the column position
         * by the width of the previous object (dNewObjectWidth still has this value). */
        ELSE
            ASSIGN dNewObjectColumn = dNewObjectColumn + dNewObjectWidth + 1.

        ASSIGN dNewObjectHeight = (IF NOT bttInstance.FixedHeight THEN 
                                   /* If this is the bottom row, and this is a resizable object, then 
                                      trim a little more space off the bottom so that things fit nicely.
                                    */
                                   bttRow.RowHeight - (0.13  + (IF iMaxRow EQ bttRow.RowNum THEN 0.24 ELSE 0) )
                                   ELSE bttInstance.ObjectHeight).

        /* We have already calculated the individual object widths. */
        ASSIGN dNewObjectWidth = bttInstance.ObjectWidth.

        CASE bttInstance.JustifyPosition:
            WHEN "R":U THEN
                ASSIGN dNewObjectColumn = pdContainerWidth - dNewObjectWidth
                       dNewObjectColumn = IF dNewObjectColumn <= 0 THEN 1 ELSE dNewObjectColumn.
            WHEN "C":U THEN
            DO:
                /* Can only be centered if the only object on this row */
                IF bttRow.NumObjects <= 1 THEN
                    ASSIGN dNewObjectColumn = (pdContainerWidth / 2) - (dNewObjectWidth / 2)
                           dNewObjectColumn = IF dNewObjectColumn <= 0 THEN 1 ELSE dNewObjectColumn.
            END.    /* C */
        END CASE.   /* Justify Code */
        
        RUN resizeAndMoveSomething IN TARGET-PROCEDURE ( INPUT  piPageNumber,
                                                         INPUT  bttInstance.ObjectTypeCode,
                                                         INPUT  bttInstance.ObjectInstanceHandle,
                                                         INPUT  pdTopLeftColumn,
                                                         INPUT  pdTopLeftRow,
                                                         INPUT  dNewObjectColumn,
                                                         INPUT  (IF dBottomRow > 0 THEN dBottomRow ELSE dNewObjectRow),
                                                         INPUT  dNewObjectWidth,
                                                         INPUT  dNewObjectHeight      ).    
        ASSIGN dBottomRow = 0.       /* Don't use this special row more than once. */
    END.        /* END FOR EACH bttInstance */

    /* Clean out the rows used by this instance of the procedure. */
    FOR EACH bttRow WHERE 
             bttRow.SourceProcedure = ghSourceProcedure AND
             bttRow.PageNum         = piPageNumber:
        DELETE bttRow.
    END.    /* each row */
    
    FOR EACH bttInstance WHERE 
             bttInstance.SourceProcedure = ghSourceProcedure AND
             bttInstance.PageNum         = piPageNumber:
        DELETE bttInstance.     
    END.    /* each instance */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resize06 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeAndMoveSomething) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeAndMoveSomething Procedure 
PROCEDURE resizeAndMoveSomething :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     To move and resize object on page
  Parameters:  <none>
  Notes:       Uses repositionObject and resizeObject in objects themselves
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber         AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER pcObjectType         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER phObjectInstance     AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn      AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow         AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewColumn          AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewRow             AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewWidth           AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewHeight          AS DECIMAL              NO-UNDO.
    
    DEFINE VARIABLE iPageNumber         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE hFrame              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hOldSourceProcedure AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cLayoutCode         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cPageLayoutInfo     AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE dColumn             AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE lPageInit           AS LOGICAL                      NO-UNDO.   
    DEFINE VARIABLE dTabColumn          AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dTabRow             AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dTabWidth           AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dTabHeight          AS DECIMAL                      NO-UNDO.
    
    /* WARNING:  LayoutManagers operate on Cartezian Co-ordinates, where top left is 0,0.  Progess (in
       character units) uses 1,1.  For this reason, 1 is added to each of the ROW and COLUMN positions in the
       repositionObject call */                                                       
    
    IF VALID-HANDLE(phObjectInstance) THEN
    DO:
        /* If there is a localised resizeAndMoveObject procedure, run that. */
        IF {fnarg Signature 'resizeAndMoveObject' phObjectInstance} NE "":U THEN
            RUN resizeAndMoveObject IN phObjectInstance ( INPUT pdNewHeight,
                                                          INPUT pdNewWidth,
                                                          INPUT pdNewRow + pdTopLeftRow + 1,
                                                          INPUT pdNewColumn + pdTopLeftColumn + 1) NO-ERROR.
        ELSE
        DO:
            IF CAN-QUERY(phObjectInstance, "COLUMN":U) THEN
              dColumn = phObjectInstance:COLUMN.
            ELSE
            DO:
              {get ContainerHandle hFrame phObjectInstance}.
          
              IF VALID-HANDLE(hFrame) AND CAN-QUERY(hFrame, "COLUMN":U) THEN
                dColumn = hFrame:COLUMN.
              ELSE
                dColumn = pdNewColumn + pdTopLeftColumn + 1.
            END.    /* no column attribute */
            
            IF pdNewColumn + pdTopLeftColumn + 1 < dColumn THEN
            DO:
                RUN repositionObject IN phObjectInstance (INPUT pdNewRow + pdTopLeftRow + 1,
                                                          INPUT pdNewColumn + pdTopLeftColumn + 1) NO-ERROR.
                RUN resizeObject IN phObjectInstance (INPUT pdNewHeight, INPUT pdNewWidth) NO-ERROR.

            END.
            ELSE
            DO:
                RUN resizeObject IN phObjectInstance (INPUT pdNewHeight, INPUT pdNewWidth) NO-ERROR.                
                RUN repositionObject IN phObjectInstance (INPUT pdNewRow + pdTopLeftRow + 1,
                                                          INPUT pdNewColumn + pdTopLeftColumn + 1) NO-ERROR.
            END.
        END.    /* no resizeAndMoveObject procedure */
    END.    /* valid object instance */
    
    IF {fnarg InstanceOf 'SmartFolder' phObjectInstance} THEN
    DO:
        RUN getClientRectangle IN phObjectInstance ( OUTPUT dTabColumn,
                                                     OUTPUT dTabRow,
                                                     OUTPUT dTabWidth,
                                                     OUTPUT dTabHeight   ).
        IF piPageNumber EQ 0 THEN
        DO:
            {get PageLayoutInfo cPageLayoutInfo ghSourceProcedure}.
            DO iPageNumber = 1 TO NUM-ENTRIES(cPageLayoutInfo, "|":U):
                ASSIGN cLayoutCode = ENTRY(iPageNumber, cPageLayoutInfo, "|":U)
                       /* If there are no pageN targets, then the page has not yet been
                          initialised.
                        */
                       lPageInit   = ( DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                        INPUT ghSourceProcedure, INPUT iPageNumber) NE "":U).
                
                IF lPageInit THEN
                    RUN resizeLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,
                                                           INPUT  iPageNumber,
                                                           INPUT  dTabWidth,
                                                           INPUT  dTabHeight,
                                                           INPUT  dTabColumn - 1,
                                                           INPUT  dTabRow - 1      ).
            END.        /* loop through the pages. */
        END.    /* we are not requesting page 0 */
    END.    /* SmartFolder */
    ELSE
    /* Cater for DynFrames and other contained window containers, 
       such as those run by the treeview window.
     */    
    IF {fnarg InstanceOf 'DynContainer' phObjectInstance} then
    DO:
        /* Get the layout code */
        {get Page0LayoutManager cLayoutCode phObjectInstance}.
        
        /* The ghSourceProcedure is used to find the relevant objects. Since a global variable
         * is used we need to fool this resize procedure.                                     */
        ASSIGN hOldSourceProcedure = ghSourceProcedure
               ghSourceProcedure   = phObjectInstance.
        
        /* Always resize the frame on page zero. If there is a folder page on the frame,
         * it will resize correctly s a result of the folder resizing code.             
         *
         * The top left row and column are always passed in as zero because we are positioning on
         * a new frame completely, and always want to start in the top left corner. The frame itself
         * has been repositioned (and resized) by a call a little earlier in this procedure.        */
        RUN resizeLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,           /* pcLayoutCode    */
                                               INPUT  0,                     /* piPageNumber    */
                                               INPUT  pdNewWidth,            /* pdMinWidth      */
                                               INPUT  pdNewHeight,           /* pdMinHeight     */
                                               INPUT  0,                     /* pdTopLeftColumn */
                                               INPUT  0 ).                   /* pdTopLeftRow    */
        
        /* Resize frame if necessary. The DynFrame will set the ResizeMe value to Pending
           if the frame is being resized smaller. If this is the case, then the resize is not
           performed until all of the objects on the DynFrame have been made smaller. If we don't
           do this there is a good chance of errors.
         */
        IF DYNAMIC-FUNCTION("getUserProperty":U IN phObjectInstance, INPUT "ResizeMe":U) EQ "Pending":U THEN
            RUN resizeObject IN phObjectInstance ( INPUT pdNewHeight, INPUT pdNewWidth).
        
        ASSIGN ghSourceProcedure = hOldSourceProcedure.
    END.    /* DynFrame */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeAndMoveSomething */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeLayout Procedure 
PROCEDURE resizeLayout :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     To re-layout window contents after a resize
  Parameters:  <none>
  Notes:       called internally from packwindow or resizewindow
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLayoutCode         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER piPageNumber         AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER pdMinWidth           AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdMinHeight          AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn      AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow         AS DECIMAL              NO-UNDO.

    IF NOT CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES, "resize":U + pcLayoutCode) THEN
        RETURN.

    RUN VALUE("resize" + pcLayoutCode) ( INPUT piPageNumber,
                                         INPUT pdMinWidth,
                                         INPUT pdMinHeight,
                                         INPUT pdTopLeftColumn,
                                         INPUT pdTopLeftRow         ) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF NOT (RETURN-VALUE = "":U OR RETURN-VALUE = ?) THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeLayout */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindow Procedure 
PROCEDURE resizeWindow :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     To relayout window to new window dimensions.
  Parameters:  input layout code, e.g. top/centre/bottom
               input buffer handle of page instance temp-table
               input buffer handle of page temp-table
               input window handle
               input frame handle
  Notes:       Called from resizeWindow procedure in dynamic container
               rydyncontw.w
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLayoutCode         AS CHARACTER                NO-UNDO.
    DEFINE INPUT PARAMETER phWindow             AS HANDLE                   NO-UNDO.
    DEFINE INPUT PARAMETER phFrame              AS HANDLE                   NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL                  NO-UNDO.
    DEFINE INPUT PARAMETER phObjectBuffer       AS HANDLE                   NO-UNDO.
    DEFINE INPUT PARAMETER phPageBuffer         AS HANDLE                   NO-UNDO.
    
    DEFINE VARIABLE dColumn             AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dRow                AS DECIMAL                      NO-UNDO.
    
    /* Used by resize06 */
    EMPTY TEMP-TABLE ttRow.
    EMPTY TEMP-TABLE ttInstance.
    /* Used by resize03 */
    EMPTY TEMP-TABLE ttCentre.   
    
    /* Give the frame lots of room to paint on. */
    ASSIGN phFrame:SCROLLABLE     = TRUE
    
           phFrame:VIRTUAL-WIDTH  = phWindow:MAX-WIDTH
           phFrame:VIRTUAL-HEIGHT = phWindow:MAX-HEIGHT
    
           phFrame:WIDTH          = MAX(phFrame:WIDTH,  phWindow:WIDTH)
           phFrame:HEIGHT         = MAX(phFrame:HEIGHT, phWindow:HEIGHT)
           
           phFrame:SCROLLABLE     = FALSE
           
           dRow                   = 0
           dColumn                = 0
           NO-ERROR.
    
    /* Set the source procedure variable. For details of why then
     * 'resizeWindowFromSuper' is checked, see that API for details why. */
    IF NOT PROGRAM-NAME(2) BEGINS "resizeWindowFromSuper":U THEN
        ASSIGN ghSourceProcedure = SOURCE-PROCEDURE.

    IF VALID-HANDLE(ghSourceProcedure) THEN
        RUN getTopLeft IN ghSourceProcedure (OUTPUT dRow, OUTPUT dColumn) NO-ERROR.
        
    RUN resizeLayout( INPUT  pcLayoutCode,
                      INPUT  0,
                      INPUT  phWindow:WIDTH,
                      INPUT  phWindow:HEIGHT,
                      INPUT  dColumn,
                      INPUT  dRow           ) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF NOT (RETURN-VALUE = "":U OR RETURN-VALUE = ?) THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      
    /* Set the frame's actual and virtual sizes. */
    ASSIGN phFrame:SCROLLABLE     = TRUE
    
           phFrame:WIDTH          = phWindow:WIDTH
           phFrame:HEIGHT         = phWindow:HEIGHT
           phFrame:VIRTUAL-WIDTH  = phFrame:WIDTH
           phFrame:VIRTUAL-HEIGHT = phFrame:HEIGHT
                      
           phFrame:SCROLLABLE     = FALSE
           NO-ERROR.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeWindowFromSuper) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindowFromSuper Procedure 
PROCEDURE resizeWindowFromSuper :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Wrapper for resizeWindow.
  Parameters:  As per resizeWindow
               phSourceProcedure - the TARGET-PROCEDURE of the caller.
  Notes:       * This procedure acts as a wrapper for resizeWindow() since the API
                 signature cannot be changed. There should be no other code in this,
                 than the setting of the ghSourceProcedure handle and the calling of
                 the resizeWindow() API.
               * The only thing that this API does is
                 to set the value of the ghSourceProcedure variable to the passed
                 in value. This is needed because the SOURCE-PROCEDURE handle returns
                 the name of the calling procedure itself (and not the TARGET-PROCEDURE
                 of that caller). The Window and Frame code relies on the TARGET-PROCEDURE
                 to distinguish running instances and so this value needs to be 
                 correct otherwise the resizing fails.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLayoutCode         AS CHARACTER                NO-UNDO.
    DEFINE INPUT PARAMETER phWindow             AS HANDLE                   NO-UNDO.
    DEFINE INPUT PARAMETER phFrame              AS HANDLE                   NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL                  NO-UNDO.
    DEFINE INPUT PARAMETER phObjectBuffer       AS HANDLE                   NO-UNDO.
    DEFINE INPUT PARAMETER phPageBuffer         AS HANDLE                   NO-UNDO.
    DEFINE INPUT PARAMETER phSourceProcedure    AS HANDLE                   NO-UNDO.
            
    /* Set the value of the source procedure handle */
    ASSIGN ghSourceProcedure = phSourceProcedure.
    
    IF NOT VALID-HANDLE(ghSourceProcedure) THEN
        ASSIGN ghSourceProcedure = SOURCE-PROCEDURE.
    
    RUN resizeWindow ( INPUT pcLayoutCode,
                       INPUT phWindow, 
                       INPUT phFrame,
                       INPUT pdInstanceId,
                       INPUT phObjectBuffer,
                       INPUT phPageBuffer    ).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeWindowFromSuper */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildRowsAndInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildRowsAndInstances Procedure 
FUNCTION buildRowsAndInstances RETURNS LOGICAL
    ( INPUT phTargetProcedure       AS HANDLE,
      INPUT piPageNumber            AS INTEGER  ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Builds the ttRow and ttInstance Temp-tables for a given object.
    Notes:  * This function is PRIVATE to the Layout Manager.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dObjectHeight               AS DECIMAL              NO-UNDO.   
    DEFINE VARIABLE dObjectWidth                AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE dMinHeight                  AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMinWidth                   AS DECIMAL              NO-UNDO.  
    DEFINE VARIABLE iPageNumber                 AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iOldPageNumber              AS INTEGER              NO-UNDO.    
    DEFINE VARIABLE hPageQuery                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLocalPageBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPageInstanceQuery          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFolderPageInstanceBuffer   AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE               NO-UNDO.        
    DEFINE VARIABLE cObjectTypeCode             AS CHARACTER            NO-UNDO. 
    DEFINE VARIABLE iOldLayoutRow               AS INTEGER              NO-UNDO.
    DEFINE VARIABLE lResizeVertical             AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lResizeHorizontal           AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hPageObjectLayoutCode       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPageInstanceHandle         AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPageObjectPageNumber       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cPageObjectTypeCode         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dFolderMinHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE lQueryObject                AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE dRowMinHeight               AS DECIMAL    EXTENT 9  NO-UNDO.
    DEFINE VARIABLE iRowLoop                    AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cLayoutCode                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLayoutPosition             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cJustifyCode                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLayoutRow                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iRowNum                     AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cPageNTargets               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAllPageTargets             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPageLayoutInfo             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hOldSourceProcedure         AS HANDLE               NO-UNDO.

    DEFINE BUFFER bttInstance  FOR ttInstance.
    DEFINE BUFFER bttRow       FOR ttRow.
    
    /* Get all of the objects on the specified page.
     * There is currently no support for Page0 in the PageN functionality,
     * so the objects on page zero need to be derived from the 
     */
    IF piPageNumber EQ 0 THEN
    DO:
        &SCOPED-DEFINE xp-assign
        /* We need all container targets to loop through. */
        {get ContainerTarget cPageNTargets ghSourceProcedure}
                
        /* The PageN property stores all PageN object handles */
        {get PageNTarget cAllPageTargets ghSourceProcedure}.
        &UNDEFINE xp-assign
        /* This procedure doesn't care which page an obejct is on, just whether it
         * is on a page at all. */
        ASSIGN cAllPageTargets = REPLACE(cAllPageTargets, "|":U, ",":U).
    END.    /* page 0 */
    ELSE
        ASSIGN cPageNTargets = DYNAMIC-FUNCTION("PageNTargets":U IN ghSourceProcedure,
                                                INPUT ghSourceProcedure,
                                                INPUT piPageNumber          ).
                                                
    DO iLoop = 1 TO NUM-ENTRIES(cPageNTargets):
        ASSIGN hObjectInstanceHandle = WIDGET-HANDLE(ENTRY(iLoop, cPageNTargets)) NO-ERROR.
        
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN NEXT.
                
        /* If we are looking for page zero objects, and the object exists on another page,
         * ignore it and move right on.
         */
        IF piPageNumber EQ 0 AND CAN-DO(cAllPageTargets, STRING(hObjectInstanceHandle)) THEN
            NEXT.
        
        &SCOPED-DEFINE xp-assign
        {get LayoutPosition cLayoutPosition hObjectInstanceHandle}
        {get ClassName cObjectTypeCode hObjectInstanceHandle}.
        &UNDEFINE xp-assign
        
        /* No need to try and reposition or size non-visible objects */
        {get QueryObject lQueryObject hObjectInstanceHandle} NO-ERROR.
        IF lQueryObject THEN
            NEXT.
        
        ASSIGN cLayoutCode  = SUBSTRING(cLayoutPosition, 1, 1)
               iLayoutRow   = INTEGER(SUBSTRING(cLayoutPosition, 2, 1))
               cJustifyCode = SUBSTR(ENTRY(1,cLayoutPosition), LENGTH(ENTRY(1,cLayoutPosition)), 1)
               NO-ERROR.
        /* Make sure that there is a justification code specified */
        IF cJustifyCode <> "C":U AND cJustifyCode <> "R":U THEN
            ASSIGN cJustifyCode = "":U. /* Default - Left */

        IF cLayoutPosition EQ "":U OR iLayoutRow EQ 0 THEN
            NEXT.
        &SCOPED-DEFINE xp-assign                
        {get Width dObjectWidth hObjectInstanceHandle}
        {get Height dObjectHeight hObjectInstanceHandle}.
        &UNDEFINE xp-assign
        
        /* Hang onto needed info for each visual object to be used later. */
        CREATE bttInstance.  
        ASSIGN bttInstance.SourceProcedure      = phTargetProcedure
               bttInstance.PageNum              = piPageNumber
               bttInstance.RowNum               = iLayoutRow
               bttInstance.LayoutPosition       = cLayoutPosition
               bttInstance.ObjectWidth          = dObjectWidth
               bttInstance.ObjectHeight         = dObjectHeight
               bttInstance.ObjectTypeCode       = cObjectTypeCode
               bttInstance.ObjectInstanceHandle = hObjectInstanceHandle
               bttInstance.JustifyPosition      = cJustifyCode
               bttInstance.RowCol               = SUBSTRING(cLayoutPosition, 2, 2)
               /* The setting of the ColumnNum needs to be the last thing
                * that this ASSIGN statement does, because for Centred objects
                * the last char is a 'C' (eg layout position M2C). This will 
                * raise the error-status flag and cause any subsequent 
                * lines in this assign statement not to execute.                */
               bttInstance.ColumnNum            = INTEGER(SUBSTRING(cLayoutPosition, 3, 1))
               NO-ERROR.
                    
        FIND FIRST bttRow WHERE
                   bttRow.SourceProcedure = phTargetProcedure AND
                   bttRow.PageNum         = piPageNumber      AND
                   bttRow.RowNum          = iLayoutRow
                   NO-ERROR.
        IF NOT AVAILABLE bttRow THEN
        DO:
            /* Create a record to describe this new row if it's not already there. */
            CREATE bttRow.
            ASSIGN bttRow.SourceProcedure = phTargetProcedure
                   bttRow.PageNum         = piPageNumber
                   bttRow.RowNum          = iLayoutRow
                   bttRow.FixedHeight     = YES          /* defaults if not reset */
                   bttRow.FixedWidth      = YES
                   bttRow.BottomSection   = (IF cLayoutCode EQ "B":U THEN YES ELSE NO)
                   iRowNum                = iLayoutRow.
        END.    /* END DO IF new row -- iLayoutRow > iRowNum */

        ASSIGN bttRow.NumObjects = bttRow.NumObjects + 1.
        
        &SCOPED-DEFINE xp-assign
        {get ResizeVertical   lResizeVertical hObjectInstanceHandle}
        {get ResizeHorizontal lResizeHorizontal hObjectInstanceHandle}.
        &UNDEFINE xp-assign
        
        /* In some cases the Attribute might not be set - then use object type
         * to determine what sizing is allowd */
        IF lResizeVertical EQ ? OR lResizeHorizontal EQ ? THEN
        DO:
          IF {fnarg InstanceOf 'Browser' hObjectInstanceHandle}     OR
             {fnarg InstanceOf 'SmartFolder' hObjectInstanceHandle} THEN
              ASSIGN lResizeVertical   = IF lResizeVertical EQ ? THEN YES ELSE lResizeVertical
                     lResizeHorizontal = IF lResizeHorizontal EQ ? THEN YES ELSE lResizeHorizontal.
          ELSE
              IF {fnarg InstanceOf 'Viewer' hObjectInstanceHandle} THEN
                  ASSIGN lResizeVertical   = IF lResizeVertical EQ ? THEN NO ELSE lResizeVertical
                         lResizeHorizontal = IF lResizeHorizontal EQ ? THEN NO ELSE lResizeHorizontal.
              ELSE
                  IF {fnarg InstanceOf 'SmartToolbar' hObjectInstanceHandle} THEN
                      ASSIGN lResizeVertical   = IF lResizeVertical EQ ? THEN NO ELSE lResizeVertical
                             lResizeHorizontal = IF lResizeHorizontal EQ ? THEN YES ELSE lResizeHorizontal.
                  ELSE
                      ASSIGN lResizeVertical   = IF lResizeVertical EQ ? THEN NO ELSE lResizeVertical
                             lResizeHorizontal = IF lResizeHorizontal EQ ? THEN NO ELSE lResizeHorizontal.
        END.    /* resize* flags not set. */

        /* Determine the smallest size the folder can be,
         * by reading through the pages and determining the dimensions
         * of the pages.                                               */                
        IF {fnarg InstanceOf 'SmartFolder' hObjectInstanceHandle} THEN
        DO:
            ASSIGN dMinHeight    = 0
                   dMinWidth     = 0
                   dObjectHeight = 0
                   dObjectWidth  = 0.
            
            /* The layouts for all pages stored here, |-delimited. */
            {get PageLayoutInfo cPageLayoutInfo phTargetProcedure}.
            
            DO iPageNumber = 1 TO NUM-ENTRIES(cPageLayoutInfo, "|":U):
                ASSIGN cLayoutCode = ENTRY(iPageNumber, cPageLayoutInfo, "|":U).
                
                RUN packLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,
                                                     INPUT  iPageNumber,
                                                     INPUT  iPageNumber,
                                                     OUTPUT dObjectWidth,
                                                     OUTPUT dObjectHeight   ).
                ASSIGN dMinHeight = MAX(dMinHeight, dObjectHeight)
                       dMinWidth  = MAX(dMinWidth, dObjectWidth).
            END.    /* there are pages */
            
            ASSIGN dMinHeight            = dMinHeight + {fn getTabRowHeight hObjectInstanceHandle} + 0.48
                   bttInstance.MinWidth  = dMinWidth
                   bttInstance.MinHeight = dMinHeight.
        END.    /* F-O-L: SmartFolder */
        ELSE
	    /* Cater for DynFrames and other contained window containers, 
	       such as those run by the treeview window.
	     */
        IF {fnarg InstanceOf 'DynContainer' hObjectInstanceHandle} then
        DO:
            &SCOPED-DEFINE xp-assign
            {get Page0LayoutManager cLayoutCode hObjectInstanceHandle}
            {get CurrentPage iPageNumber hObjectInstanceHandle}.
            &UNDEFINE xp-assign

            /* The ghSourceProcedure is used to find the relevant objects. Since a global variable
               is used we need to fool this resize procedure.
             */
            ASSIGN hOldSourceProcedure = ghSourceProcedure
                   ghSourceProcedure   = hObjectInstanceHandle.
            
            RUN packLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,
                                                 INPUT  0,
                                                 INPUT  iPageNumber,
                                                 OUTPUT bttInstance.MinWidth,
                                                 OUTPUT bttInstance.MinHeight   ).
            
            ASSIGN ghSourceProcedure = hOldSourceProcedure.                                                     
        END.    /* Dynamic frame */            
        ELSE            
        DO:
            &SCOPED-DEFINE xp-assign
            {get minWidth  bttInstance.MinWidth  hObjectInstanceHandle}
            {get minHeight bttInstance.MinHeight hObjectInstanceHandle}.
            &UNDEFINE xp-assign
        END.    /* non-folder objects */

        /* Ensure that there are no null value in the min* fields. */
        IF bttInstance.MinHeight EQ ? THEN ASSIGN bttInstance.MinHeight = 0.
        IF bttInstance.MinWidth EQ ?  THEN ASSIGN bttInstance.MinWidth  = 0.
        
        ASSIGN bttInstance.FixedHeight = NOT lResizeVertical
               bttInstance.FixedWidth  = NOT lResizeHorizontal.
        
        /* If the  object is a static viewer, then use the Height and Width as
           the minimums. It is possible that the MinHeight and MinWidth attributes
           are set to incorrect values, which results in the viewer not displaying
           properly.
		   
		   This is a work-around for the fact that there may be bum MinHeight and
		   MinWidth data.
         */
        IF {fnarg InstanceOf 'StaticSDV'   hObjectInstanceHandle} OR
           {fnarg InstanceOf 'SmartViewer' hObjectInstanceHandle} OR
           {fnarg InstanceOf 'StaticSO'    hObjectInstanceHandle} THEN
        DO:
	        IF bttInstance.FixedHeight THEN
	            ASSIGN bttInstance.MinHeight = bttInstance.ObjectHeight.
	        
	        IF bttInstance.FixedWidth THEN
	            ASSIGN bttInstance.MinWidth = bttInstance.ObjectWidth.
        END.    /* Static viewer */
        
        /* The Row's Minimum Height and Width depend on the instance's Minimum Height and Width. */
        ASSIGN bttRow.MinHeight = MAX(bttRow.MinHeight, bttInstance.MinHeight)
               bttRow.MinWidth  = bttRow.MinWidth + bttInstance.MinWidth + (IF bttRow.MinWidth NE 0 THEN 1 ELSE 0).
                    
        /* We don't want to go from a variable height row to a fixed height row.             
         * We do want to allow going from a Fixed to a Variable height row.
         *
         * The FixedHeight value should alwasy be set for the first object 
         * in the row, and thereafter only if the row is already a FixedHeight
         * row.                                                                 */           
        IF bttRow.NumObjects EQ 1 OR bttRow.FixedHeight THEN
            ASSIGN bttRow.FixedHeight = NOT lResizeVertical.

        /* The height of the tallest object in the row (in terms of initial
         * size) determines the initial height of the row.                  */
        IF bttRow.FixedHeight EQ YES AND dObjectHeight > bttRow.RowHeight THEN
            ASSIGN bttRow.RowHeight = dObjectHeight.
        
        /* If there's any variable width object in the row, then the row
         * as a whole is variable width. */            
        IF bttRow.NumObjects EQ 1 OR bttRow.FixedWidth THEN
            ASSIGN bttRow.FixedWidth = NOT lResizeHorizontal.
        
        IF lResizeHorizontal THEN
            ASSIGN bttRow.NumResizeHorizontal = bttRow.NumResizeHorizontal + 1.
        ELSE
            ASSIGN bttRow.FixedHorizontalSize = bttRow.FixedHorizontalSize 
                                              /* Use the MinWidth (rather than ObjectWidth ) because the first time the
                                               * resizing is done, because the ObjectWidth is only set correctly after
                                               * this calculation is done. For subsequent runs, then ObjectWidth and MinWidth
                                               * have the same value (well, they would, wouldn't they seeing as how the object
                                               * cannot be resized.) and so the resizing works correctly. */
                                              + bttInstance.MinWidth
                                              + 1 /* NB: right gap? */
                bttInstance.ObjectWidth = bttInstance.MinWidth.
        
        ASSIGN bttRow.RowWidth = bttRow.RowWidth 
                               + (IF bttInstance.FixedWidth THEN bttInstance.MinWidth ELSE bttInstance.ObjectWidth)
                               + (IF bttRow.RowWidth NE 0 THEN 1 ELSE 0).
    END.           /* loop for all objects on the page */
    
    RETURN TRUE.
END FUNCTION.   /* buildRowsAndInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


