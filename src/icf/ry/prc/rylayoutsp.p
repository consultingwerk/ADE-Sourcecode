&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
DEFINE VARIABLE giUniqenessGuarantor    AS INTEGER                  NO-UNDO.

ASSIGN dCharsPerRowPixel      = SESSION:HEIGHT-CHARS / SESSION:HEIGHT-PIXELS
       dCharsPerColumnPixel   = SESSION:WIDTH-CHARS  / SESSION:WIDTH-PIXELS
       .
{afglobals.i}

DEFINE TEMP-TABLE ttCentre              NO-UNDO
    FIELD hInstanceHandle   AS HANDLE
    FIELD lToolbar          AS LOGICAL
    FIELD lResize           AS LOGICAL
    INDEX key1
        hInstanceHandle
        lResize
    .

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
      INPUT pdInstanceId            AS DECIMAL,
      INPUT piPageNumber            AS INTEGER,
      INPUT phObjectBuffer          AS HANDLE,
      INPUT phPageBuffer            AS HANDLE  )  FORWARD.

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
         HEIGHT             = 21.24
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
  Purpose:     To work out width and height of object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER phObjectBuffer          AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER phPageBuffer            AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectType            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER phObjectInstance        AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL          NO-UNDO.

    DEFINE VARIABLE hOldSourceProcedure         AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cLayoutCode                 AS CHARACTER            NO-UNDO.     
    DEFINE VARIABLE dMinWidth                   AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMinHeight                  AS DECIMAL              NO-UNDO.   
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hPageInitField              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lPageInit                   AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lResizeHorizontal           AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lResizeVertical             AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE iFrameCurrentPage           AS INTEGER              NO-UNDO.

    IF NOT VALID-HANDLE(phObjectInstance) THEN
        RETURN.

    /* No need to try and reposition or size non-visible objects */
    IF {fnarg signature 'getHeight':U phObjectInstance} = '':U THEN
      RETURN.

    IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectType, INPUT "SmartFolder":U) AND
       piLayoutForPage EQ 0 AND piPageNumber NE 0 THEN
    DO:
        ASSIGN pdPackedWidth  = 0
               pdPackedHeight = 0
               .
        /* There will only ever be one container_Page record per page per object. */
        phPageBuffer:FIND-FIRST(" WHERE ":U
                                + phPageBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                + phPageBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) + " AND ":U
                                + phPageBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber)  ) NO-ERROR.

        IF phPageBuffer:AVAILABLE THEN
        DO:
            ASSIGN cLayoutCode = phPageBuffer:BUFFER-FIELD("tLayoutCode"):BUFFER-VALUE.

            RUN packLayout ( INPUT  cLayoutCode,
                             INPUT  piPageNumber,
                             INPUT  piPageNumber,
                             INPUT  phObjectBuffer,
                             INPUT  phPageBuffer,
                             INPUT  pdInstanceId,
                             OUTPUT dMinWidth,
                             OUTPUT dMinHeight           ).
            ASSIGN pdPackedHeight = MAX(pdPackedHeight,dMinHeight)
                   pdPackedWidth  = MAX(pdPackedWidth,dMinWidth)
                   .
        END.    /* page buffer available */

        /* Make sure there's enough space for all the tabs on the window. */
        ASSIGN dMinWidth = DYNAMIC-FUNCTION("getPanelsMinWidth":U IN phObjectInstance) NO-ERROR.

        ASSIGN pdPackedWidth = MAX(dMinWidth, pdPackedWidth).

        /* Add the space a folder needs for its labels and margins.  We calculate the number of tab rows * 1.14 (hardcoded tab height). *
         * The tab folder currently only supports 1 row, when it's changed to support more than 1, uncomment the part after the assign. */

        ASSIGN pdPackedHeight = pdPackedHeight + {fn getTabRowHeight phObjectInstance} + 0.48
               pdPackedWidth  = pdPackedWidth + 1.8.

        /* We may already have dimensioned another page on this folder object. 
         * We get the previous min size and save the larger. Both of these will have the
         * manual adjustments above done to them, so there is no need to do thema gain. */
        {get MinHeight dMinHeight phObjectInstance}.
        {get MinWidth  dMinWidth  phObjectInstance}.

        ASSIGN pdPackedHeight = MAX(pdPackedHeight,dMinHeight)
               pdPackedWidth  = MAX(pdPackedWidth,dMinWidth)
               .       
        /* Set these minimum (packed) heights/widths */
        {set MinHeight pdPackedHeight phObjectInstance}.
        {set MinWidth  pdPackedWidth  phObjectInstance}.
    END.    /* SmartFolder */
    ELSE
    IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectType, INPUT "DynFrame":U) OR
       /* This is to cater for instances where a container is forcibly run using the dynamic frame */
       phObjectInstance:FILENAME MATCHES "*rydynframw*":U                                             THEN
    DO:
        ASSIGN pdPackedWidth  = 0
               pdPackedHeight = 0.

        /* Get the instanceID of the DynFrame instance. */
        {get InstanceId dInstanceId phObjectInstance}.
        {get CurrentPage iFrameCurrentPage phObjectInstance}.

        /* Get the layout code */
        phPageBuffer:FIND-FIRST(" WHERE ":U
                                + phPageBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(phObjectInstance) + ") AND ":U
                                + phPageBuffer:NAME + ".tPageNumber = 0 ":U ).
        ASSIGN cLayoutCode = phPageBuffer:BUFFER-FIELD("tLayoutCode"):BUFFER-VALUE.

        /* The ghSourceProcedure is used to find the relevant objects. Since a global variable
         * is used we need to fool this resize procedure.                                     */
        ASSIGN hOldSourceProcedure = ghSourceProcedure
               ghSourceProcedure   = phObjectInstance.

        /* The valud of the LayoutForPage variable is zero because
         * we need it to force the packing in the event of there being 
         * a SmartFolder object on the frame.
         * 
         * We also pack for the currently selected page on the DynFrame,
         * which may not be the same that is passed in.                  */
        RUN packLayout IN TARGET-PROCEDURE( INPUT  cLayoutCode,
                                            INPUT  0,                   /* piLayoutForPage */
                                            INPUT  iFrameCurrentPage,   /* piPageNumber */
                                            INPUT  phObjectBuffer,
                                            INPUT  phPageBuffer,
                                            INPUT  dInstanceId,
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

        IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectType, INPUT "SmartToolbar":U)  THEN            
        DO:
            {get MinHeight pdPackedHeight phObjectInstance}.
            IF pdPackedHeight = 0 OR pdPackedHeight = ? THEN
                ASSIGN pdPackedHeight  = DYNAMIC-FUNCTION("getHeight"  IN phObjectInstance).

            /* The Toolbar must be at least 1.24 characters high, if no other size is set. */
            IF pdPackedHeight = 0 OR pdPackedHeight = ? THEN
            DO:
                ASSIGN pdPackedHeight  = 1.24.
                {set MinHeight pdPackedHeight phObjectInstance}.
            END.

            {get MinWidth  pdPackedWidth phObjectInstance}.
            IF pdPackedWidth = 0 OR pdPackedWidth = ? THEN
            DO:
                ASSIGN pdPackedWidth  = DYNAMIC-FUNCTION("getWidth"  IN phObjectInstance).
                {set MinWidth pdPackedWidth phObjectInstance}.
            END.    /* no min width set */
        END.    /* toolbar */
        ELSE
        DO:
            ASSIGN
                lResizeHorizontal = DYNAMIC-FUNCTION("getResizeHorizontal":U IN phObjectInstance)
                lResizeVertical   = DYNAMIC-FUNCTION("getResizeVertical":U   IN phObjectInstance)
                pdPackedHeight    = (IF lResizeVertical    THEN DYNAMIC-FUNCTION("getMinHeight" IN phObjectInstance)
                                                           ELSE DYNAMIC-FUNCTION("getHeight"    IN phObjectInstance))
                pdPackedWidth     = (IF lResizeHorizontal  THEN DYNAMIC-FUNCTION("getMinWidth"  IN phObjectInstance)
                                                           ELSE DYNAMIC-FUNCTION("getWidth"     IN phObjectInstance))
                pdPackedHeight    = (IF pdPackedHeight = 0 THEN DYNAMIC-FUNCTION("getHeight"    IN phObjectInstance) ELSE pdPackedHeight)
                pdPackedWidth     = (IF pdPackedWidth  = 0 THEN DYNAMIC-FUNCTION("getWidth"     IN phObjectInstance) ELSE pdPackedWidth).
        END.    /* not a toolbar */
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
  Purpose:     Work out minimum size of a widnow based on its contents
  Parameters:  <none>
  Notes:       No layout specified
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER phObjectBuffer          AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER phPageBuffer            AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL   NO-UNDO.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack01) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack01 Procedure 
PROCEDURE pack01 :
/*------------------------------------------------------------------------------
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
    DEFINE INPUT  PARAMETER phObjectBuffer          AS HANDLE          NO-UNDO.
    DEFINE INPUT  PARAMETER phPageBuffer            AS HANDLE          NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL         NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL         NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL         NO-UNDO.

    DEFINE VARIABLE dObjectHeight                   AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dObjectWidth                    AS DECIMAL          NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                      AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dMaxWidth                       AS DECIMAL          NO-UNDO.            
    DEFINE VARIABLE hPageInstanceQuery              AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer              AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hObjectInstanceHandle           AS HANDLE           NO-UNDO.     
    DEFINE VARIABLE cObjectTypeCode                 AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cLayoutPosition                 AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cWidgetPool                     AS CHARACTER        NO-UNDO.

    ASSIGN cWidgetPool          = "pack01":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1
           .
    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.
    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.

    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = " + QUOTER(piLayoutForPage)).

    hPageInstanceQuery:QUERY-OPEN().
    hPageInstanceQuery:GET-FIRST().

    DO WHILE hLocalObjectBuffer:AVAILABLE:
        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE
               cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName"):BUFFER-VALUE
               cLayoutPosition       = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition"):BUFFER-VALUE
               .
        RUN dimensionSomething( INPUT  piLayoutForPage,
                                INPUT  piPageNumber,
                                INPUT  phObjectBuffer,
                                INPUT  phPageBuffer,
                                INPUT  cObjectTypeCode,
                                INPUT  hObjectInstanceHandle,
                                INPUT  pdInstanceId,
                                OUTPUT dObjectWidth,
                                OUTPUT dObjectHeight               ).

        IF dObjectHeight NE ? THEN ASSIGN dMaxHeight = MAX(dMaxHeight, dObjectHeight).
        IF dObjectWidth <> ?  THEN ASSIGN dMaxWidth  = MAX(dMaxWidth, dObjectWidth).

        hPageInstanceQuery:GET-NEXT().
    END.    /* avail page instance buffer */

    hPageInstanceQuery:QUERY-CLOSE().

    DELETE OBJECT hPageInstanceQuery NO-ERROR.
    ASSIGN hPageInstanceQuery = ?.

    DELETE WIDGET-POOL cWidgetPool.

    ASSIGN pdPackedWidth  = dMaxWidth + 2
           pdPackedHeight = dMaxHeight + 0.48
           .
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack02) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack02 Procedure 
PROCEDURE pack02 :
/*------------------------------------------------------------------------------
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
    DEFINE INPUT  PARAMETER phObjectBuffer    AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER phPageBuffer            AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL         NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL          NO-UNDO.
    
    DEFINE VARIABLE dObjectHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dObjectWidth                AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                  AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMaxWidth                   AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE hPageInstanceQuery          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE               NO-UNDO.     
    DEFINE VARIABLE cObjectTypeCode             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLayoutPosition             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dCenterMaxHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dTopMaxHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dBottomMaxHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cWidgetPool                     AS CHARACTER        NO-UNDO.

    ASSIGN cWidgetPool          = "pack02":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1
           .

    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.
    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
    
    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U 
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = " + QUOTER(piLayoutForPage)).

    hPageInstanceQuery:QUERY-OPEN().
    hPageInstanceQuery:GET-FIRST().

    DO WHILE hLocalObjectBuffer:AVAILABLE:
        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle"):BUFFER-VALUE
               cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName"):BUFFER-VALUE
               cLayoutPosition       = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition"):BUFFER-VALUE
               .
        RUN dimensionSomething ( INPUT  piLayoutForPage,
                                 INPUT  piPageNumber,
                                 INPUT  phObjectBuffer,
                                 INPUT  phPageBuffer,
                                 INPUT  cObjectTypeCode,
                                 INPUT  hObjectInstanceHandle,
                                 INPUT  pdInstanceId,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight             ).

        IF dObjectHeight NE ? AND cLayoutPosition NE "":U THEN
        DO:
            ASSIGN cLayoutPosition = ENTRY(1, cLayoutPosition)
                   cLayoutPosition = SUBSTRING(cLayoutPosition,1,1)
                   .
            CASE cLayoutPosition:
                WHEN "T" THEN ASSIGN dTopMaxHeight    = MAX(dTopMaxHeight,dObjectHeight).
                WHEN "C" THEN ASSIGN dCenterMaxHeight = MAX(dCenterMaxHeight,dObjectHeight) + 0.24.
                WHEN "B" THEN ASSIGN dBottomMaxHeight = MAX(dBottomMaxHeight,dObjectHeight).
            END CASE.   /* layout position */
        END.    /* height a valid value */

        IF dObjectWidth <> ?  THEN
            ASSIGN dMaxWidth  = MAX(dMaxWidth, dObjectWidth).

        hPageInstanceQuery:GET-NEXT().
    END.    /* available page instance */

    ASSIGN dMaxHeight     = dTopMaxHeight + dCenterMaxHeight + dBottomMaxHeight
           pdPackedWidth  = dMaxWidth + 2
           pdPackedHeight = dMaxHeight + 0.24
           .

    hPageInstanceQuery:QUERY-CLOSE().

    DELETE OBJECT hPageInstanceQuery.
    ASSIGN hPageInstanceQuery = ?.

    DELETE WIDGET-POOL cWidgetPool.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack03 Procedure 
PROCEDURE pack03 :
/*------------------------------------------------------------------------------
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
    DEFINE INPUT  PARAMETER phObjectBuffer          AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER phPageBuffer            AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL         NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL          NO-UNDO.
    
    DEFINE VARIABLE dObjectHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dObjectWidth                AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                  AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMaxWidth                   AS DECIMAL              NO-UNDO.            
    DEFINE VARIABLE hPageInstanceQuery          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE               NO-UNDO.     
    DEFINE VARIABLE cObjectTypeCode             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLayoutPosition             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dCenterMaxHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dTopMaxHeight               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dBottomMaxHeight            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cWidgetPool                     AS CHARACTER        NO-UNDO.

    ASSIGN cWidgetPool          = "pack03":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1
           .

    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.
    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.

    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = ":U + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = " + QUOTER(piLayoutForPage)).

    hPageInstanceQuery:QUERY-OPEN().
    hPageInstanceQuery:GET-FIRST().

    DO WHILE hLocalObjectBuffer:AVAILABLE:
        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE
               cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
               cLayoutPosition       = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE
               .
        RUN dimensionSomething ( INPUT  piLayoutForPage,
                                 INPUT  piPageNumber,
                                 INPUT  phObjectBuffer,
                                 INPUT  phPageBuffer,
                                 INPUT  cObjectTypeCode,
                                 INPUT  hObjectInstanceHandle,
                                 INPUT  pdInstanceId,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight          ).            

        IF dObjectHeight NE ? AND cLayoutPosition NE "":U THEN
        DO:
            ASSIGN cLayoutPosition = ENTRY(1, cLayoutPosition)
                   cLayoutPosition = SUBSTRING(cLayoutPosition,1,1)
                   .
            CASE cLayoutPosition:
                WHEN "T" THEN ASSIGN dTopMaxHeight    = MAX(dTopMaxHeight,dObjectHeight).
                WHEN "C" THEN ASSIGN dCenterMaxHeight = MAX(dCenterMaxHeight,(dCenterMaxHeight + dObjectHeight + 0.24 )). /* many centre objects */
                WHEN "B" THEN ASSIGN dBottomMaxHeight = MAX(dBottomMaxHeight,dObjectHeight).
            END CASE.   /* layout position */
        END.

        IF dObjectWidth <> ?  THEN ASSIGN dMaxWidth  = MAX(dMaxWidth, dObjectWidth).

        hPageInstanceQuery:GET-NEXT().
    END.    /* available local page instance */

    ASSIGN dMaxHeight     = dTopMaxHeight + dCenterMaxHeight + dBottomMaxHeight
           pdPackedWidth  = dMaxWidth + 2
           pdPackedHeight = dMaxHeight + 0.24
           .

    hPageInstanceQuery:QUERY-CLOSE().

    DELETE OBJECT hPageInstanceQuery.
    ASSIGN hPageInstanceQuery = ?.

    DELETE WIDGET-POOL cWidgetPool.

    RETURN.
END PROCEDURE.  /* pack03 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack04) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack04 Procedure 
PROCEDURE pack04 :
/*------------------------------------------------------------------------------
  Purpose:     Pack Routine for left/centre/right layout
  Parameters:  <none>
  Notes:       Work out minimum size of a window based on its contents
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER phObjectBuffer    AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER phPageBuffer            AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL   NO-UNDO.
    
    DEFINE VARIABLE dObjectHeight               AS DECIMAL NO-UNDO INITIAL 50.
    DEFINE VARIABLE dObjectWidth                AS DECIMAL NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dMaxWidth                   AS DECIMAL NO-UNDO.            
    DEFINE VARIABLE hPageInstanceQuery          AS HANDLE NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE NO-UNDO.
    DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE NO-UNDO.     
    DEFINE VARIABLE cObjectTypeCode             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLayoutPosition             AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE dCenterMaxWidth     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dRightMaxWidth      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dLeftMaxWidth       AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cWidgetPool                     AS CHARACTER        NO-UNDO.

    ASSIGN cWidgetPool          = "pack04":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1
           .
    CREATE WIDGET-POOL cWidgetPool.
    
    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
    CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.

    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = " + QUOTER(piLayoutForPage)).
    hPageInstanceQuery:QUERY-OPEN().
    
    REPEAT:
        hPageInstanceQuery:GET-NEXT().
        IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.
    
        hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE.
        cObjectTypeCode = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.
        cLayoutPosition = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE.
    
        RUN dimensionSomething(    
            INPUT  piLayoutForPage,    
            INPUT  piPageNumber,  
            INPUT  phObjectBuffer,
            INPUT  phPageBuffer,
            INPUT  cObjectTypeCode,
            INPUT  hObjectInstanceHandle,        
            INPUT  pdInstanceId,
            OUTPUT dObjectWidth,
            OUTPUT dObjectHeight
            ).            
    
        IF dObjectWidth <> ? AND cLayoutPosition <> "":U THEN
        DO:
            ASSIGN
              cLayoutPosition = ENTRY(1, cLayoutPosition)
              cLayoutPosition = SUBSTRING(cLayoutPosition,1,1)
              .
            CASE cLayoutPosition:
                WHEN "R" THEN dRightMaxWidth  = MAX(dRightMaxWidth,dObjectWidth).
                WHEN "C" THEN dCenterMaxWidth = MAX(dCenterMaxWidth,(dObjectWidth / 2)).
                WHEN "L" THEN dLeftMaxWidth   = MAX(dLeftMaxWidth,dObjectWidth).
            END CASE.
        END.
        IF dObjectWidth <> ?  THEN dMaxHeight = MAX(dMaxHeight, dObjectHeight).
    END.
    
    dMaxWidth = dRightMaxWidth + dCenterMaxWidth + dLeftMaxWidth.
    
    ASSIGN 
      pdPackedWidth  = dMaxWidth + 2
      pdPackedHeight = dMaxHeight + 0.24
      .
    
    hPageInstanceQuery:QUERY-CLOSE().
    DELETE OBJECT hPageInstanceQuery.
    ASSIGN hPageInstanceQuery = ?.

    DELETE WIDGET-POOL cWidgetPool.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack05) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack05 Procedure 
PROCEDURE pack05 :
/*------------------------------------------------------------------------------
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
DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER phObjectBuffer    AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER phPageBuffer            AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pdPackedWidth           AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pdPackedHeight          AS DECIMAL   NO-UNDO.

DEFINE VARIABLE dObjectHeight               AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectWidth                AS DECIMAL    NO-UNDO.            
DEFINE VARIABLE dMaxHeight                  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dMaxWidth                   AS DECIMAL    NO-UNDO.            
DEFINE VARIABLE hPageInstanceQuery          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLocalObjectBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectInstanceHandleField  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE     NO-UNDO.     
DEFINE VARIABLE cObjectTypeCode             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLayoutPosition             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE dCenterMaxHeight            AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dTopMaxHeight               AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dBottomMaxHeight            AS DECIMAL    NO-UNDO.

DEFINE VARIABLE dColumn                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dRow                        AS DECIMAL    NO-UNDO.

DEFINE VARIABLE hFolder                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFolderToolbar            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerToolbar         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTitleFillIn              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTreeViewOCX              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hResizeFillIn             AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRectangle                AS HANDLE     NO-UNDO.
DEFINE VARIABLE lStatusBarVisible         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hFilterViewer             AS HANDLE     NO-UNDO.

DEFINE VARIABLE dContainerToolbarWidth    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerToolbarHeight   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFolderToolbarWidth       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFolderToolbarHeight      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dOCXWidth                 AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dOCXHeight                AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFilterViewerWidth        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFilterViewerHeight       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dTitleHeight              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dRectangleHeight          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cWidgetPool                     AS CHARACTER        NO-UNDO.

ASSIGN cWidgetPool          = "pack05":U + STRING(giUniqenessGuarantor)
       giUniqenessGuarantor = giUniqenessGuarantor + 1
       .

IF VALID-HANDLE(ghSourceProcedure) AND 
   LOOKUP("getTreeObjects":U, ghSourceProcedure:INTERNAL-ENTRIES) <> 0 THEN
  RUN getTreeObjects IN ghSourceProcedure (OUTPUT hFolder,
                                           OUTPUT hFolderToolbar,
                                           OUTPUT hContainerToolbar,
                                           OUTPUT hTitleFillIn,
                                           OUTPUT hResizeFillIn,
                                           OUTPUT hTreeViewOCX,
                                           OUTPUT hRectangle,
                                           OUTPUT lStatusBarVisible,
                                           OUTPUT hFilterViewer) NO-ERROR.
                                
CREATE WIDGET-POOL cWidgetPool.
CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.

hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).
hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                 + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                 + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                 + hLocalObjectBuffer:NAME + ".tPageNumber = " + QUOTER(piLayoutForPage)).
hPageInstanceQuery:QUERY-OPEN().

REPEAT:
    hPageInstanceQuery:GET-NEXT().
    IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.

    hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE.
    cObjectTypeCode = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.
    cLayoutPosition = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE.

    IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
      NEXT.

    RUN dimensionSomething(    
        INPUT  piLayoutForPage,    
        INPUT  piPageNumber,  
        INPUT  phObjectBuffer,
        INPUT  phPageBuffer,
        INPUT  cObjectTypeCode,
        INPUT  hObjectInstanceHandle,        
        INPUT  pdInstanceId,
        OUTPUT dObjectWidth,
        OUTPUT dObjectHeight
        ).            

    /* Get ContainerToolbar Size */
    IF VALID-HANDLE(hContainerToolbar) AND
       hContainerToolbar = hObjectInstanceHandle THEN
       ASSIGN dContainerToolbarWidth  = dObjectWidth
              dContainerToolbarHeight = dObjectHeight.
    /* Get FilterViewer Size */
    IF VALID-HANDLE(hFilterViewer) AND
       hFilterViewer = hObjectInstanceHandle THEN
       ASSIGN dFilterViewerWidth  = dObjectWidth
              dFilterViewerHeight = dObjectHeight.
    /* Get TreeViewOCX Size */
    IF VALID-HANDLE(hTreeViewOCX) AND
       hTreeViewOCX = hObjectInstanceHandle THEN
       ASSIGN dOCXWidth  = dObjectWidth
              dOCXHeight = dObjectHeight.
    
    /* Get FolderToolbar Size */
    IF VALID-HANDLE(hFolderToolbar) AND
       hFolderToolbar = hObjectInstanceHandle THEN DO:
      ASSIGN dFolderToolbarWidth  = dObjectWidth
             dFolderToolbarHeight = dObjectHeight.
    END.

END.

hPageInstanceQuery:QUERY-CLOSE().
DELETE OBJECT hPageInstanceQuery.
ASSIGN hPageInstanceQuery = ?.

DELETE WIDGET-POOL cWidgetPool.

IF dOCXWidth = ? OR
   dOCXWidth = 0 AND
   VALID-HANDLE(hResizeFillIn) THEN
   dOCXWidth = hResizeFillIn:COL NO-ERROR.

IF VALID-HANDLE(hTitleFillIn) THEN
   dTitleHeight = hTitleFillIn:HEIGHT NO-ERROR.

/* The minimum width would be the following:    */
/* Width of the OCX + 1 for a spacer +          */
/* Width of the FolderToolbar + 1 for a spacer  */
IF dOCXWidth = 0 OR dOCXWidth = ? THEN
  dOCXWidth = 5. /* Must be at least 5 */
IF dFolderToolbarWidth = 0 OR dFolderToolbarWidth = ? THEN
  dFolderToolbarWidth = 15. /* This should be the minimum - we have a fillin that has to be in view */
  
pdPackedWidth = dOCXWidth + 1 + dFolderToolbarWidth + 1.

/* The minimum height would be the following:     */
/* Container Height + 0.24 for a spacer +         */
/* Filter Viewer Height + 0.24 for a spacer +     */
/* Title field height + 0.24 for a spacer +       */
/* FolderToolbar height + 0.24 for a spacer +     */
/* a minimum of 5 for the folderwindow/dOCXHeight */

IF dContainerToolbarHeight = 0 OR dContainerToolbarHeight = ? THEN
  dContainerToolbarHeight = /* 1.5 */ ( 1 + 5 / 10 ).
IF dFilterViewerHeight = 0 OR dFilterViewerHeight = ? THEN
  dFilterViewerHeight = 0.
IF dOCXHeight = 0 OR dOCXHeight = ? OR dOCXHeight < 5 THEN
  dOCXHeight = 5.
IF dFolderToolbarHeight = 0 OR dFolderToolbarHeight = ? THEN
  dFolderToolbarHeight = 0.
IF dTitleHeight = 0 OR dTitleHeight = ? THEN
  dTitleHeight = 1.
IF VALID-HANDLE(hRectangle) THEN
  dRectangleHeight = hRectangle:HEIGHT.
ELSE
  dRectangleHeight = 5.
  

pdPackedHeight = dContainerToolbarHeight + 0.24 + 
                 dFilterViewerHeight     + 0.24 + 
                 dRectangleHeight        + 1.


IF pdPackedHeight <= 10 THEN
  pdPackedHeight = 10.

IF dContainerToolbarWidth > pdPackedWidth THEN
  pdPackedWidth = dContainerToolbarWidth.
  
/**
IF VALID-HANDLE(ghSourceProcedure) AND 
   LOOKUP("getTopLeft":U, ghSourceProcedure:INTERNAL-ENTRIES) > 0 THEN
  RUN getTopLeft IN ghSourceProcedure (OUTPUT dRow, OUTPUT dColumn) NO-ERROR.
**/

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pack06) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pack06 Procedure 
PROCEDURE pack06 :
/*------------------------------------------------------------------------------
  Purpose:     Pack Routine for Relative layout
  Parameters:  piLayoutForPage
               piPageNumber
               phObjectBuffer
               phPageBuffer
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
    DEFINE INPUT  PARAMETER phObjectBuffer         AS HANDLE            NO-UNDO.
    DEFINE INPUT  PARAMETER phPageBuffer           AS HANDLE            NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId           AS DECIMAL           NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedWidth          AS DECIMAL           NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPackedHeight         AS DECIMAL           NO-UNDO.

    DEFINE VARIABLE dObjectHeight                   AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dObjectWidth                    AS DECIMAL          NO-UNDO.            
    DEFINE VARIABLE dMaxHeight                      AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dMaxWidth                       AS DECIMAL          NO-UNDO.            
    DEFINE VARIABLE hPageInstanceQuery              AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer              AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hObjectInstanceHandle           AS HANDLE           NO-UNDO.
    DEFINE VARIABLE cObjectTypeCode                 AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cLayoutPosition                 AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cLayoutCode                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE iLayoutRow                      AS INTEGER          NO-UNDO.
    DEFINE VARIABLE dMainHeight                     AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dMainWidth                      AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dRowHeight                      AS DECIMAL          NO-UNDO EXTENT 9.
    DEFINE VARIABLE dRowWidth                       AS DECIMAL          NO-UNDO EXTENT 9.
    DEFINE VARIABLE iExtentLoop                     AS INTEGER          NO-UNDO.
    DEFINE VARIABLE iMaxRow                         AS INTEGER          NO-UNDO.
    DEFINE VARIABLE cWidgetPool                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE lQueryObject                    AS LOGICAL          NO-UNDO.

    ASSIGN cWidgetPool          = "pack06":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1
           .

    CREATE WIDGET-POOL cWidgetPool.
    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
    CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.
    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).

    /* Read through instances for the page by row number, regardless of layout code */
    hPageInstanceQuery:QUERY-PREPARE(" FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U

                                     /* Skip the container itself. */
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure <> ":U + hLocalObjectBuffer:NAME + ".tObjectInstanceHandle AND ":U

                                     + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piLayoutForPage) ).
    hPageInstanceQuery:QUERY-OPEN().

    REPEAT:
        hPageInstanceQuery:GET-NEXT().
        IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.

        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE
               cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
               cLayoutPosition       = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE
               .
        /* Skip blank layouts for non-visual objects. Note that these are assigned a
         * position of CENTRE by other code so we must skip that also. */
        {get QueryObject lQueryObject hObjectInstanceHandle} NO-ERROR.

        IF cLayoutPosition =  "":U OR LENGTH(cLayoutPosition) < 3 OR lQueryObject OR NOT VALID-HANDLE(hObjectInstanceHandle) THEN
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
                                 INPUT  phObjectBuffer,
                                 INPUT  phPageBuffer,
                                 INPUT  cObjectTypeCode,
                                 INPUT  hObjectInstanceHandle,
                                 INPUT  pdInstanceId,
                                 OUTPUT dObjectWidth,
                                 OUTPUT dObjectHeight         ).
        IF dObjectHeight + dObjectWidth <> ? THEN
            ASSIGN dRowWidth[iLayoutRow]  = dRowWidth[iLayoutRow] + dObjectWidth + (IF dRowWidth[iLayoutRow] NE 0 THEN 1 ELSE 0)
                   dRowHeight[iLayoutRow] = MAX(dRowHeight[iLayoutRow], dObjectHeight)
                   iMaxRow                = MAX(iMaxRow, iLayoutRow)
                   .
    END.           /* END REPEAT loop for all objects on the page */
    hPageInstanceQuery:QUERY-CLOSE().

    DO iExtentLoop = 1 TO iMaxRow:
        ASSIGN dMainHeight = dMainHeight + dRowHeight[iExtentLoop] + 
                           (IF iExtentLoop NE 1 AND dRowHeight[iExtentLoop] NE 0 THEN 0.24 ELSE 0)
               dMainWidth  = MAX(dMainWidth, dRowWidth[iExtentLoop])
               .
    END.    /* extent loop */

    ASSIGN pdPackedWidth  = dMainWidth  + 2
           pdPackedHeight = dMainHeight + 0.24
           .
    DELETE OBJECT hPageInstanceQuery.
    ASSIGN hPageInstanceQuery  = ?.

    DELETE WIDGET-POOL cWidgetPool.

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
  Purpose:     Called from packwindow - to work out minumum window size
               according to contents.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcLayoutCode            AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER piLayoutForPage         AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber            AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER phObjectBuffer          AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER phPageBuffer            AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdMinWidth              AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdMinHeight             AS DECIMAL   NO-UNDO.

    IF NOT CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES, ("pack":U + pcLayoutCode) ) THEN
        RETURN.

    RUN VALUE("pack" + pcLayoutCode) ( INPUT  piLayoutForPage,
                                       INPUT  piPageNumber,
                                       INPUT  phObjectBuffer,
                                       INPUT  phPageBuffer,
                                       INPUT  pdInstanceId,
                                       OUTPUT pdMinWidth,
                                       OUTPUT pdMinHeight           ).

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
    
    DEFINE VARIABLE cButtonPressed      AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE dPackedWidth        AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dPackedHeight       AS DECIMAL                      NO-UNDO.

    /* These used later, by resize 06 for example. */
    EMPTY TEMP-TABLE ttRow.
    EMPTY TEMP-TABLE ttInstance.

    /* Some hard coded defaults */
    IF pdMinPackedWidth  EQ ? THEN ASSIGN pdMinPackedWidth = 81.
    IF pdMinPackedHeight EQ ? THEN ASSIGN pdMinPackedHeight = 10.14 .

    /* Avoid resizing beyond session width and height */
    IF pdMaxWidth EQ ?  OR pdMaxWidth  GT SESSION:WIDTH - 1  THEN ASSIGN pdMaxWidth  = SESSION:WIDTH  - 1.
    IF pdMaxHeight EQ ? OR pdMaxHeight GT SESSION:HEIGHT - 1 THEN ASSIGN pdMaxHeight = SESSION:HEIGHT - 1.

    /* Set the source procedure variable. For details of why then
     * 'packWindowFromSuper' is checked, see that API for details why. */
    IF NOT PROGRAM-NAME(2) BEGINS "packWindowFromSuper":U THEN
        ASSIGN ghSourceProcedure = SOURCE-PROCEDURE.

    /* Work out packed width and height for page */
    RUN packLayout( INPUT  pcLayoutCode,
                    INPUT  0,               /* layout for page */
                    INPUT  piPageNumber,
                    INPUT  phObjectBuffer,
                    INPUT  phPageBuffer,
                    INPUT  pdInstanceId,
                    OUTPUT dPackedWidth,
                    OUTPUT dPackedHeight        ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN RETURN-VALUE.

    /* Ensure does not got smaller then previous minimum */
    ASSIGN dPackedWidth  = MAX(dPackedWidth, pdMinPackedWidth)
           dPackedHeight = MAX(dPackedHeight, pdMinPackedHeight)
           .
    /* If the packed size exceeds the size of the session,
     * report an error and do not continue.               */
    IF dPackedHeight GT SESSION:HEIGHT-CHARS OR dPackedWidth  GT SESSION:WIDTH-CHARS THEN
        RETURN {aferrortxt.i 'AF' '15' '?' '?' '"this window`s smallest size is larger than the space available on the desktop. This can be solved by changing the screen`s resolution or by redesigning the window."'}.

    /* Set new window minimums and maximums */
    ASSIGN phWindow:MIN-WIDTH  = dPackedWidth
           phWindow:MIN-HEIGHT = dPackedHeight
           phWindow:MAX-WIDTH  = pdMaxWidth
           phWindow:MAX-HEIGHT = pdMaxHeight
           NO-ERROR.

    /* Resize will only be passed as YES if no saved size exists */
    IF plResize AND
       (piPageNumber = 0 OR
        phWindow:MIN-WIDTH-CHARS < phWindow:WIDTH-CHARS OR
        phWindow:MIN-HEIGHT-CHARS < phWindow:HEIGHT-CHARS) THEN
    DO:
        ASSIGN phFrame:SCROLLABLE     = TRUE
               phFrame:VIRTUAL-WIDTH  = MAX(phFrame:VIRTUAL-WIDTH,dPackedWidth)
               phFrame:VIRTUAL-HEIGHT = MAX(phFrame:VIRTUAL-HEIGHT,dPackedHeight)
               NO-ERROR.

        RUN resizeLayout( INPUT  pcLayoutCode,
                          INPUT  0,
                          INPUT  phObjectBuffer,
                          INPUT  phPageBuffer,
                          INPUT  dPackedWidth,
                          INPUT  dPackedHeight,
                          INPUT  0,
                          INPUT  0,
                          INPUT  pdInstanceId        ).

        ASSIGN phFrame:VIRTUAL-WIDTH  = dPackedWidth      phFrame:VIRTUAL-HEIGHT = dPackedHeight       
               phFrame:WIDTH          = dPackedWidth      phFrame:HEIGHT         = dPackedHeight
               phWindow:WIDTH         = dPackedWidth      phWindow:HEIGHT        = dPackedHeight
               phFrame:SCROLLABLE     = FALSE
               NO-ERROR.
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-packWindowFromSuper) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packWindowFromSuper Procedure 
PROCEDURE packWindowFromSuper :
/*------------------------------------------------------------------------------
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
                     INPUT plResize         ) .

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
  Purpose:     No layout specified
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber         AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER phObjectBuffer AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER phPageBuffer         AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerWidth     AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerHeight    AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn      AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow         AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL   NO-UNDO.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize01) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize01 Procedure 
PROCEDURE resize01 :
/*------------------------------------------------------------------------------
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
DEFINE INPUT PARAMETER phObjectBuffer AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phPageBuffer         AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pdContainerWidth     AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerHeight AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftColumn   AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftRow      AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL                  NO-UNDO.


DEFINE VARIABLE dObjectHeight               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dObjectWidth                AS DECIMAL      NO-UNDO.            
DEFINE VARIABLE dMaxHeight                  AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dMaxWidth                   AS DECIMAL      NO-UNDO.            
DEFINE VARIABLE hPageInstanceQuery          AS HANDLE       NO-UNDO.
DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE       NO-UNDO.        
DEFINE VARIABLE cObjectTypeCode             AS CHARACTER    NO-UNDO.

DEFINE VARIABLE dNewObjectWidth             AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectHeight            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectColumn            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dNewObjectRow               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE cWidgetPool                 AS CHARACTER    NO-UNDO.

    ASSIGN cWidgetPool          = "resize01":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1
           .

    dObjectWidth  = pdContainerWidth  - (1 + 1).                                 
    dObjectHeight = pdContainerHeight - 0.48.

    CREATE WIDGET-POOL cWidgetPool.
    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
/*     hLocalObjectBuffer = phObjectBuffer:DEFAULT-BUFFER-HANDLE. */
    CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.
    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U 
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber)).

    hPageInstanceQuery:QUERY-OPEN().

    REPEAT:
        hPageInstanceQuery:GET-NEXT().
        IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.   

        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE                             
               cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.

        dNewObjectWidth = dObjectWidth.
        dNewObjectHeight = dObjectHeight.
        dNewObjectColumn = 1.
        dNewObjectRow = 0.24.

        RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
            INPUT  piPageNumber,  
            INPUT  phObjectBuffer,
            INPUT  phPageBuffer,
            INPUT  cObjectTypeCode,
            INPUT  hObjectInstanceHandle,        
            INPUT  pdTopLeftColumn,
            INPUT  pdTopLeftRow,
            INPUT  dNewObjectColumn, 
            INPUT  dNewObjectRow,
            INPUT  dNewObjectWidth,
            INPUT  dNewObjectHeight,
            INPUT  pdInstanceId         ).            
    END.

    hPageInstanceQuery:QUERY-CLOSE().
    DELETE OBJECT hPageInstanceQuery.
    ASSIGN hPageInstanceQuery = ?.

    DELETE WIDGET-POOL cWidgetPool.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize02) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize02 Procedure 
PROCEDURE resize02 :
/*------------------------------------------------------------------------------
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
  DEFINE INPUT PARAMETER phObjectBuffer     AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER phPageBuffer       AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pdContainerWidth   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdContainerHeight  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdTopLeftColumn    AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdTopLeftRow       AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdInstanceId       AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dDesiredHeight            AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dDesiredWidth             AS DECIMAL      NO-UNDO.  
  DEFINE VARIABLE dObjectHeight             AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dObjectWidth              AS DECIMAL      NO-UNDO.            
  DEFINE VARIABLE dMaxHeight                AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dMaxWidth                 AS DECIMAL      NO-UNDO.            
  DEFINE VARIABLE hPageInstanceQuery        AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hLocalObjectBuffer        AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObjectInstanceHandle     AS HANDLE       NO-UNDO.        
  DEFINE VARIABLE cObjectTypeCode           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iCenterTopRow             AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE iCenterBottomRow          AS DECIMAL      NO-UNDO. 
  DEFINE VARIABLE dNewObjectWidth           AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectHeight          AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectColumn          AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectRow             AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE cWidgetPool               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lTopObjects               AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE lBottomObjects            AS LOGICAL      NO-UNDO.

  ASSIGN
      cWidgetPool          = "resize02":U + STRING(giUniqenessGuarantor)
      giUniqenessGuarantor = giUniqenessGuarantor + 1
      dDesiredWidth        = pdContainerWidth  - 2
      dDesiredHeight       = pdContainerHeight - 0.24 - (IF piPageNumber = 0 THEN 0 ELSE 0.24)
      iCenterTopRow        =  0
      iCenterBottomRow     = iCenterTopRow + dDesiredHeight.      

  CREATE WIDGET-POOL cWidgetPool.
  CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
  CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.

  /* Check for the availablity of objects on TOP, CENTER, BOTTOM as this affects spacing */
  hLocalObjectBuffer:FIND-FIRST("WHERE tTargetProcedure           = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") ":U
                                + "AND tContainerRecordIdentifier = ":U + QUOTER(pdInstanceId) + " ":U
                                + "AND tPageNumber                = ":U + QUOTER(piPageNumber) + " ":U
                                + "AND tLayoutPosition       BEGINS 'TOP'":U) NO-ERROR.

  lTopObjects = hLocalObjectBuffer:AVAILABLE.

  /* Check for the availablity of objects on TOP, CENTER, BOTTOM as this affects spacing */
  hLocalObjectBuffer:FIND-FIRST("WHERE tTargetProcedure           = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") ":U
                                + "AND tContainerRecordIdentifier = ":U + QUOTER(pdInstanceId) + " ":U
                                + "AND tPageNumber                = ":U + QUOTER(piPageNumber) + " ":U
                                + "AND tLayoutPosition       BEGINS 'BOT'":U) NO-ERROR.

  lBottomObjects = hLocalObjectBuffer:AVAILABLE.

  hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).

  /* manage TOP components */

  hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                   + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                   + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                   + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                   + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'TOP' ":U).
  hPageInstanceQuery:QUERY-OPEN().

  top-blk:
  REPEAT:
    hPageInstanceQuery:GET-NEXT().

    IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.    

    hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE.

    IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
      NEXT top-blk.
    
    cObjectTypeCode = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.

    dObjectHeight = DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.                                
    dObjectWidth  = DYNAMIC-FUNCTION("getWidth"  IN hObjectInstanceHandle) NO-ERROR.                             

    IF hObjectInstanceHandle:FILE-NAME = "ry/obj/rydyntoolt.w" THEN 
      ASSIGN
          dNewObjectRow    = 0
          dNewObjectColumn = 0
          dNewObjectWidth  = dDesiredWidth + 2.
    ELSE
      ASSIGN 
          dNewObjectColumn = 1
          dNewObjectWidth  = dDesiredWidth
          dNewObjectRow    = 0.48.

    ASSIGN
        dNewObjectHeight = dObjectHeight
        iCenterTopRow    = MAX(iCenterTopRow, dNewObjectRow + dObjectHeight).        

    RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
        INPUT  piPageNumber,
        INPUT  phObjectBuffer,
        INPUT  phPageBuffer,
        INPUT  cObjectTypeCode,
        INPUT  hObjectInstanceHandle,
        INPUT  pdTopLeftColumn,
        INPUT  pdTopLeftRow,
        INPUT  dNewObjectColumn,
        INPUT  dNewObjectRow,
        INPUT  dNewObjectWidth,
        INPUT  dNewObjectHeight,
        INPUT  pdInstanceId).
  END.

  hPageInstanceQuery:QUERY-CLOSE().

  /* manage BOTTOM components */    
  hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                   + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                   + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                   + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                   + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'BOTTOM' ":U).
  hPageInstanceQuery:QUERY-OPEN().

  bottom-blk:
  REPEAT:
    hPageInstanceQuery:GET-NEXT().

    IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.

    ASSIGN
        hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE                                                      
        cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.

    IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
      NEXT bottom-blk.

    dObjectHeight = DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.                                
    dObjectWidth  = DYNAMIC-FUNCTION("getWidth"  IN hObjectInstanceHandle) NO-ERROR.              
    
    ASSIGN
        dNewObjectColumn = 1
        dNewObjectRow    = 0.24 + dDesiredHeight - dObjectHeight
        dNewObjectHeight = dObjectHeight
        dNewObjectWidth  = dDesiredWidth
        iCenterBottomRow = MIN(iCenterBottomRow, dNewObjectRow).

    IF hObjectInstanceHandle:FILE-NAME = "ry/obj/rydyntoolt.w" THEN
      /* all toolbars positioned in bottom are drawn one pixel higher up the screen, and one pixel deeper */            
      dNewObjectRow = dNewObjectRow - (1 * dCharsPerRowPixel).

    RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
        INPUT  piPageNumber,  
        INPUT  phObjectBuffer,
        INPUT  phPageBuffer,
        INPUT  cObjectTypeCode,
        INPUT  hObjectInstanceHandle,        
        INPUT  pdTopLeftColumn,
        INPUT  pdTopLeftRow,
        INPUT  dNewObjectColumn, 
        INPUT  dNewObjectRow,
        INPUT  dNewObjectWidth,
        INPUT  dNewObjectHeight,
        INPUT  pdInstanceId             ).  
  END.

  hPageInstanceQuery:QUERY-CLOSE().

  /* Manage CENTER components */
  hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                   + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                   + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                   + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                   + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'CENT' ":U).

  hPageInstanceQuery:QUERY-OPEN().

  cent-blk:
  REPEAT:
    hPageInstanceQuery:GET-NEXT().

    IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.

    ASSIGN
        hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE                                                            
        cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.    

    IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
        NEXT cent-blk.

    ASSIGN
        dNewObjectColumn = 1
        dNewObjectRow    = (IF lTopObjects THEN 0.24 ELSE 0) + iCenterTopRow
        dNewObjectHeight = iCenterBottomRow - iCenterTopRow - 0.24 - (IF lBottomObjects AND piPageNumber = 0 THEN 0.24 ELSE 0)
        dNewObjectWidth  = dDesiredWidth.

    RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
        INPUT  piPageNumber,  
        INPUT  phObjectBuffer,
        INPUT  phPageBuffer,
        INPUT  cObjectTypeCode,
        INPUT  hObjectInstanceHandle,        
        INPUT  pdTopLeftColumn,
        INPUT  pdTopLeftRow,
        INPUT  dNewObjectColumn, 
        INPUT  dNewObjectRow,
        INPUT  dNewObjectWidth,
        INPUT  dNewObjectHeight,
        INPUT  pdInstanceId).
  END.

  hPageInstanceQuery:QUERY-CLOSE().
  DELETE WIDGET-POOL cWidgetPool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize03 Procedure 
PROCEDURE resize03 :
/*------------------------------------------------------------------------------
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
DEFINE INPUT PARAMETER phObjectBuffer  AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phPageBuffer          AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pdContainerWidth  AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerHeight AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftColumn   AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftRow      AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL                  NO-UNDO.

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
DEFINE VARIABLE hHandle                     AS HANDLE       NO-UNDO.       
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
DEFINE VARIABLE dHeight                     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dCentreResizeHeight         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dGaps                       AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dHeightLeft                 AS DECIMAL      NO-UNDO.
DEFINE VARIABLE cWidgetPool                 AS CHARACTER        NO-UNDO.

    ASSIGN cWidgetPool          = "resize03":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1
      .

dDesiredWidth  = pdContainerWidth  - (1 + 1).                                 
dDesiredHeight = pdContainerHeight - 0.24.
iCenterTopRow =  0.
iCenterBottomRow = iCenterTopRow + dDesiredHeight.      

CREATE WIDGET-POOL cWidgetPool.
CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.

hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).

/* manage TOP components */
hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                 + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                 + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                 + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                 + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'TOP' ":U).

hPageInstanceQuery:QUERY-OPEN().

REPEAT:
  hPageInstanceQuery:GET-NEXT().
  IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.    

  ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE           
         cObjectTypeCode = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.           

  dObjectHeight = DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.                                
  dObjectWidth  = DYNAMIC-FUNCTION("getWidth"  IN hObjectInstanceHandle) NO-ERROR.                             

  IF hObjectInstanceHandle:FILE-NAME = "ry/obj/rydyntoolt.w" THEN 
  DO: 
      dNewObjectRow   = 0.       
      dNewObjectColumn = 0.       
      dNewObjectWidth = dDesiredWidth + 2.
  END.
  ELSE DO: 
      dNewObjectColumn = 1.       
      dNewObjectWidth = dDesiredWidth.
      dNewObjectRow   = 1.       
  END.

  dNewObjectHeight = dObjectHeight.

  iCenterTopRow = MAX(iCenterTopRow, dNewObjectRow + dObjectHeight).        

  RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
      INPUT  piPageNumber,  
      INPUT  phObjectBuffer,
      INPUT  phPageBuffer,
      INPUT  cObjectTypeCode,
      INPUT  hObjectInstanceHandle,        
      INPUT  pdTopLeftColumn - 0.12,
      INPUT  pdTopLeftRow,
      INPUT  dNewObjectColumn, 
      INPUT  dNewObjectRow,
      INPUT  dNewObjectWidth,
      INPUT  dNewObjectHeight,
      INPUT  pdInstanceId           ).
END.
hPageInstanceQuery:QUERY-CLOSE().

/* manage BOTTOM components */
hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                 + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                 + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                 + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                 + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'BOTTOM' ":U).
hPageInstanceQuery:QUERY-OPEN().

REPEAT:
  hPageInstanceQuery:GET-NEXT().
  IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.

  ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE                                                      
         cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.    

  dObjectHeight = DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.                                
  dObjectWidth  = DYNAMIC-FUNCTION("getWidth"  IN hObjectInstanceHandle) NO-ERROR.              
  dNewObjectColumn = 1.
  dNewObjectRow = 0.24 + dDesiredHeight - dObjectHeight.
  dNewObjectHeight = dObjectHeight.
  dNewObjectWidth = dDesiredWidth.
  iCenterBottomRow = MIN(iCenterBottomRow, dNewObjectRow). 

  IF hObjectInstanceHandle:FILE-NAME = "ry/obj/rydyntoolt.w" THEN
  DO:
      /* all toolbars positioned in bottom are drawn one pixel higher up the screen, and one pixel deeper */            
      dNewObjectRow = dNewObjectRow - (1 * dCharsPerRowPixel).
  END.

  RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
      INPUT  piPageNumber,  
      INPUT  phObjectBuffer,
      INPUT  phPageBuffer,
      INPUT  cObjectTypeCode,
      INPUT  hObjectInstanceHandle,        
      INPUT  pdTopLeftColumn - 0.12,
      INPUT  pdTopLeftRow,
      INPUT  dNewObjectColumn, 
      INPUT  dNewObjectRow,
      INPUT  dNewObjectWidth,
      INPUT  dNewObjectHeight,
      INPUT  pdInstanceId           ).  
END.
hPageInstanceQuery:QUERY-CLOSE().

/* Manage CENTRE components, In order, e.g. centre1, centre2, etc. */
EMPTY TEMP-TABLE ttCentre.
ASSIGN
  iNumStatic = 0
  iNumToolbar = 0
  iNumResize = 0
  dStaticHeight = 0.


hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                 + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                 + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                 + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                 + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'CENT' ":U
                                 + " BY ":U + hLocalObjectBuffer:NAME + ".tLayoutPosition ":U ).

hPageInstanceQuery:QUERY-OPEN().
centre-loop:
REPEAT:
  hPageInstanceQuery:GET-NEXT().
  IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE centre-loop.

  ASSIGN
    hHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE.

  IF NOT VALID-HANDLE(hHandle) THEN NEXT centre-loop.

  ASSIGN dHeight = ?.
  ASSIGN dHeight = DYNAMIC-FUNCTION("getHeight" IN hHandle) NO-ERROR.

  IF dHeight = ? THEN NEXT centre-loop. /* Ignore non visual objects */

  CREATE ttCentre.
  ASSIGN
    ttCentre.hInstanceHandle = hHandle
    ttCentre.lToolbar = hHandle:FILE-NAME = "ry/obj/rydyntoolt.w"
    ttCentre.lResize = NOT ttCentre.lToolbar AND LOOKUP("resizeObject":U, hHandle:INTERNAL-ENTRIES) <> 0
    .

  IF ttCentre.lResize THEN
  DO:
    ASSIGN
      iNumResize = iNumResize + 1.
  END.
  ELSE
  DO:
    IF NOT ttCentre.lToolbar THEN
      ASSIGN iNumStatic = iNumStatic + 1.
    ELSE
      ASSIGN iNumToolbar = iNumToolbar + 1.

    IF dHeight <> ? THEN
      ASSIGN dStaticHeight = dStaticHeight + dHeight.
  END.
END.

/* Work out height of resizable centre objects */
IF iNumResize = 0 THEN
  ASSIGN
    dCentreResizeHeight = 0.
ELSE
  ASSIGN
    dGaps = (iNumStatic + iNumResize) * 0.24
    dHeightLeft = iCenterBottomRow - iCenterTopRow - 0.24 - dGaps - dStaticHeight
    dCentreResizeHeight = IF dHeightLeft > 0 THEN (dHeightLeft / iNumResize) ELSE 0
    .

/* now process centre objects in order */
ASSIGN
  dCentreRow = 0.24 + iCenterTopRow.

hPageInstanceQuery:QUERY-CLOSE().
hPageInstanceQuery:QUERY-OPEN().
centre-loop2:
REPEAT:
  hPageInstanceQuery:GET-NEXT().
  IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.

  ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE                                                            
          cObjectTypeCode      = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.    

  FIND FIRST ttCentre
       WHERE ttCentre.hInstanceHandle = hObjectInstanceHandle
       NO-ERROR.
  IF NOT AVAILABLE ttCentre THEN NEXT centre-loop2.

  IF ttCentre.lToolbar THEN
    ASSIGN dCentreRow = dCentreRow - 0.24.  /* no gap for toolbars */

  ASSIGN
    dNewObjectColumn = 1
    dNewObjectWidth = dDesiredWidth
    dNewObjectRow = dCentreRow
    dNewObjectHeight = ?
    .
  IF ttCentre.lResize AND dCentreResizeHeight <> 0 THEN
    ASSIGN dNewObjectHeight = dCentreResizeHeight.
  ELSE
    ASSIGN dNewObjectHeight = DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.

  RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
      INPUT  piPageNumber,  
      INPUT  phObjectBuffer,
      INPUT  phPageBuffer,
      INPUT  cObjectTypeCode,
      INPUT  hObjectInstanceHandle,        
      INPUT  pdTopLeftColumn - 0.12,
      INPUT  pdTopLeftRow,
      INPUT  dNewObjectColumn, 
      INPUT  dNewObjectRow,
      INPUT  dNewObjectWidth,
      INPUT  dNewObjectHeight,
      INPUT  pdInstanceId       ).

  /* get next row position */
  ASSIGN
    dCentreRow = dCentreRow + dNewObjectHeight + 0.24.

END.

hPageInstanceQuery:QUERY-CLOSE().

DELETE WIDGET-POOL cWidgetPool.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize04) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize04 Procedure 
PROCEDURE resize04 :
/*------------------------------------------------------------------------------
  Purpose:     Layout = left/centre/right
  Parameters:  <none>
  Notes:       Not used yet and needs testing / reworking !!!!
               Will be for associative entity layouts with 2 browsers side by
               side and a vertical toolbar between them.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPageNumber      AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER phObjectBuffer  AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phPageBuffer          AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pdContainerWidth  AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdContainerHeight AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftColumn   AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdTopLeftRow      AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL                  NO-UNDO.

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
    DEFINE VARIABLE cWidgetPool                     AS CHARACTER        NO-UNDO.

    ASSIGN cWidgetPool          = "resize04":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1
           .

    dDesiredWidth  = (pdContainerWidth / 2) - 8.
    dDesiredHeight = pdContainerHeight - 3.    
    iCenterLeftCol =  1.

    CREATE WIDGET-POOL cWidgetPool.
    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
    CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.

    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'LEFT' ":U).

    hPageInstanceQuery:QUERY-OPEN().

    REPEAT:
        hPageInstanceQuery:GET-NEXT().
        IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.    

        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE           
               cObjectTypeCode = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.           

        dObjectHeight = DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.                                
        dObjectWidth  = DYNAMIC-FUNCTION("getWidth"  IN hObjectInstanceHandle) NO-ERROR.                             

        IF hObjectInstanceHandle:FILE-NAME = "ry/obj/rydyntoolt.w" THEN DO: 
            dNewObjectColumn = 1.
            dNewObjectWidth  = 0.
        END.
        ELSE DO:
            dNewObjectRow    = 0.
            dNewObjectHeight = dDesiredHeight.
        END.

        dNewObjectWidth = dDesiredWidth.

        iCenterLeftCol = MAX(iCenterLeftCol, dNewObjectColumn + dObjectWidth).        

        RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
            INPUT  piPageNumber,  
            INPUT  phObjectBuffer,
            INPUT  phPageBuffer,
            INPUT  cObjectTypeCode,
            INPUT  hObjectInstanceHandle,        
            INPUT  pdTopLeftColumn,
            INPUT  pdTopLeftRow,
            INPUT  dNewObjectColumn, 
            INPUT  dNewObjectRow,
            INPUT  dNewObjectWidth,
            INPUT  dNewObjectHeight,
            INPUT  pdInstanceId             ).
    END.
    hPageInstanceQuery:QUERY-CLOSE().

    /* manage RIGHT components */
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'RIGHT' ":U).

    hPageInstanceQuery:QUERY-OPEN().

    REPEAT:
        hPageInstanceQuery:GET-NEXT().
        IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.

        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE                                                      
               cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.    

        dObjectHeight = DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.                                
        dObjectWidth  = DYNAMIC-FUNCTION("getWidth"  IN hObjectInstanceHandle) NO-ERROR.

        dNewObjectColumn = pdContainerWidth - dDesiredWidth - 1.

        dNewObjectRow = 0.
        dNewObjectHeight = dDesiredHeight.
        dNewObjectWidth = dDesiredWidth.
        iCenterBottomRow = MIN(iCenterBottomRow, dNewObjectRow). 

        IF hObjectInstanceHandle:FILE-NAME = "ry/obj/rydyntoolt.w" THEN
        DO:
            /* all toolbars positioned in bottom are drawn one pixel higher up the screen, and one pixel deeper */            
            dNewObjectRow = dNewObjectRow - (1 * dCharsPerRowPixel).
        END.

        RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
            INPUT  piPageNumber,  
            INPUT  phObjectBuffer,
            INPUT  phPageBuffer,
            INPUT  cObjectTypeCode,
            INPUT  hObjectInstanceHandle,        
            INPUT  pdTopLeftColumn,
            INPUT  pdTopLeftRow,
            INPUT  dNewObjectColumn, 
            INPUT  dNewObjectRow,
            INPUT  dNewObjectWidth,
            INPUT  dNewObjectHeight,
            INPUT  pdInstanceId             ).  
    END.
    hPageInstanceQuery:QUERY-CLOSE().

    /* Manage CENTER components */
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber) + " AND ":U
                                     + hLocalObjectBuffer:NAME + ".tLayoutPosition BEGINS 'CENT' ":U).

    hPageInstanceQuery:QUERY-OPEN().

    REPEAT:
        hPageInstanceQuery:GET-NEXT().
        IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.

        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE                                                            
               cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.    

        IF hObjectInstanceHandle:FILE-NAME = "ry/obj/rydyntoolt.w" THEN DO: 
            dNewObjectColumn = pdContainerWidth / 2.
            dNewObjectWidth  = 5.
        END.
        ELSE DO:
            dNewObjectColumn = MAX(iCenterLeftCol, dNewObjectColumn + dObjectWidth).        
            dNewObjectRow = 0.
            dNewObjectHeight = dDesiredHeight.
            dNewObjectWidth = dDesiredWidth.
        END.

        RUN resizeAndMoveSomething IN THIS-PROCEDURE (                       
            INPUT  piPageNumber,  
            INPUT  phObjectBuffer,
            INPUT  phPageBuffer,
            INPUT  cObjectTypeCode,
            INPUT  hObjectInstanceHandle,        
            INPUT  pdTopLeftColumn,
            INPUT  pdTopLeftRow,
            INPUT  dNewObjectColumn, 
            INPUT  dNewObjectRow,
            INPUT  dNewObjectWidth,
            INPUT  dNewObjectHeight,
            INPUT  pdInstanceId             ).


    END.

    hPageInstanceQuery:QUERY-CLOSE().

    DELETE WIDGET-POOL cWidgetPool.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize05) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize05 Procedure 
PROCEDURE resize05 :
/*------------------------------------------------------------------------------
  Purpose:     TreeView
  Parameters:  <none>
  Notes:       To re-layout objects on container.

               We know if an object is resizable by the existance of an internal
               procedure called resizeObject. The exception to this is for toolbars
               which we never resize vertically in this layout.

               This layout will cater for when a tree view object is placed on the
               left of the container and objects are instantiated in an application
               area (on the right of the container)
               This layout assumes all toolbars are horizontally aligned.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNumber       AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER phObjectBuffer     AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER phPageBuffer       AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pdContainerWidth   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdContainerHeight  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdTopLeftColumn    AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdTopLeftRow       AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdInstanceId       AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hFolder                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderToolbar            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerToolbar         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTitleFillIn              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hResizeFillIn             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRectangle                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lStatusBarVisible         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFilterViewer             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dPage0ObjectsHeight       AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dObjectHeight AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dBottom       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLeft         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTop          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dColumn       AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dRow          AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE dDesiredHeight              AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dDesiredWidth               AS DECIMAL      NO-UNDO.  
  DEFINE VARIABLE dObjectWidth                AS DECIMAL      NO-UNDO.            
  DEFINE VARIABLE dMaxHeight                  AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dMaxWidth                   AS DECIMAL      NO-UNDO.            
  DEFINE VARIABLE hPageInstanceQuery          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hLocalPageBuffer            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObjectInstanceHandle       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hPageLayoutCode             AS HANDLE       NO-UNDO.
  
  DEFINE VARIABLE cObjectTypeCode             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iPageNumber                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cLayoutCode                 AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iCenterLeftCol              AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE iCenterBottomRow            AS DECIMAL      NO-UNDO. 

  DEFINE VARIABLE dNewObjectWidth             AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectHeight            AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectColumn            AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dNewObjectRow               AS DECIMAL      NO-UNDO.
  
  DEFINE VARIABLE hMenuFolder                 AS HANDLE       NO-UNDO.
  DEFINE VARIABLE dFolderToolbarHeight        AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE cWidgetPool                 AS CHARACTER    NO-UNDO.

  ASSIGN cWidgetPool          = "resize05":U + STRING(giUniqenessGuarantor)
         giUniqenessGuarantor = giUniqenessGuarantor + 1
         .

  IF NOT VALID-HANDLE(ghSourceProcedure) OR
         LOOKUP("getTreeObjects":U, ghSourceProcedure:INTERNAL-ENTRIES) = 0 THEN RETURN.

  RUN getTreeObjects IN ghSourceProcedure (OUTPUT hFolder,
                                           OUTPUT hFolderToolbar,
                                           OUTPUT hContainerToolbar,
                                           OUTPUT hTitleFillIn,
                                           OUTPUT hResizeFillIn,
                                           OUTPUT hTreeViewOCX,
                                           OUTPUT hRectangle,
                                           OUTPUT lStatusBarVisible,
                                           OUTPUT hFilterViewer) NO-ERROR.

  IF ERROR-STATUS:ERROR THEN RETURN.

  /* > FROM HERE < */

  /* Check if a container toolbar exists */
  IF VALID-HANDLE(hContainerToolbar) AND
     hContainerToolbar <> ghSourceProcedure THEN
    dTop = DYNAMIC-FUNCTION("getHeight" IN hContainerToolbar) + 1.
  ELSE
    dTop = 1.
  
  /* Now check for a filter viewer */
  IF VALID-HANDLE(hFilterViewer) THEN DO:
    RUN repositionObject IN hFilterViewer (dTop, 1) NO-ERROR.
    dTop = dTop + DYNAMIC-FUNCTION("getHeight" IN hFilterViewer).
  END.

  ASSIGN
      dTop    = dTop + 0.24
      dBottom = pdContainerHeight - 0.24
      dLeft   = hResizeFillIn:COLUMN + hResizeFillIn:WIDTH + 0.12

      /* Rectangle */
      hRectangle:COLUMN = 2
      hRectangle:WIDTH  = pdContainerWidth - 2
      hRectangle:ROW    = dTop
      hRectangle:HEIGHT = dBottom - dTop + 1 /* Check code at VALID-HANDLE (hContainerToolbar) */

      /* Title fill in */
      hTitleFillIn:WIDTH  = 1 /*hRectangle:WIDTH - (hResizeFillIn:COLUMN + hResizeFillIn:WIDTH + 0.24) + 1*/
      hTitleFillIn:COLUMN = dLeft
      hTitleFillIn:WIDTH  = hRectangle:WIDTH - hTitleFillIn:COLUMN + 1
      hTitleFillIn:ROW    = hRectangle:ROW + 0.12

      /* OCX Size indicator */
      hResizeFillIn:ROW    = hTitleFillIn:ROW
      hResizeFillIn:HEIGHT = hRectangle:HEIGHT - 0.36
      NO-ERROR.

  /* TreeViewViewer */
  RUN repositionObject IN hTreeViewOCX (hTitleFillIn:ROW, hRectangle:COLUMN + 0.75) NO-ERROR.
  RUN resizeObject     IN hTreeViewOCX (hResizeFillIn:HEIGHT, hResizeFillIn:COLUMN - hRectangle:COLUMN) NO-ERROR.

  /* Make sure that minimum and maximum sizes have been checked at this point...! */

  /* Folder toolbar */
  dTop = hTitleFillIn:ROW + hTitleFillIn:HEIGHT + 0.12.

  IF VALID-HANDLE(hFolderToolbar) AND 
     DYNAMIC-FUNCTION("getObjectHidden" IN hFolderToolbar) = FALSE THEN
  DO:
    ASSIGN
        dObjectHeight = DYNAMIC-FUNCTION("getHeight":U IN hFolderToolbar).

    IF DYNAMIC-FUNCTION("getWidth":U IN hFolderToolbar) > hTitleFillIn:WIDTH THEN DO:
      RUN resizeObject     IN hFolderToolbar (dObjectHeight, hTitleFillIn:WIDTH) NO-ERROR.
      RUN repositionObject IN hFolderToolbar (dTop, dLeft) NO-ERROR.
    END.
    ELSE DO:
      RUN repositionObject IN hFolderToolbar (dTop, dLeft) NO-ERROR.
      RUN resizeObject     IN hFolderToolbar (dObjectHeight, hTitleFillIn:WIDTH) NO-ERROR.
    END.
    dTop = dTop + dObjectHeight.
  END.
  ELSE DO:
    IF VALID-HANDLE(hFolderToolbar) AND 
       DYNAMIC-FUNCTION("getObjectHidden" IN hFolderToolbar) = TRUE THEN
      ASSIGN dFolderToolbarHeight = DYNAMIC-FUNCTION("getHeight":U IN hFolderToolbar).
  END.
  /* Folder */
  IF VALID-HANDLE(hFolder) THEN
  DO:
    ASSIGN
        dObjectHeight = hRectangle:HEIGHT + hRectangle:ROW - dTop - 0.48
        dTop          = dTop + 0.24.
    
    /* > CHECK OF ANY OTHER OBJECTS SHOULD BE ON PAGE 0 - ONLY WHEN TREE IS NOT USED AS A MENU < */
    CREATE WIDGET-POOL cWidgetPool.
    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
    CREATE BUFFER hLocalPageBuffer   FOR TABLE phPageBuffer IN WIDGET-POOL cWidgetPool.
    CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.

    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer, hLocalPageBuffer).

    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND " 
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = 0":U + ", ":U
                                     + " FIRST ":U + hLocalPageBuffer:NAME + " WHERE ":U
                                     + hLocalPageBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalPageBuffer:NAME + ".tRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalPageBuffer:NAME + ".tPageNumber = ":U + hLocalObjectBuffer:NAME + ".tPageNumber ":U
                                     + " BY ":U + hLocalObjectBuffer:NAME + ".tPageNumber ":U ).
    dPage0ObjectsHeight = 0.
    hPageInstanceQuery:QUERY-OPEN().
    REPEAT:
        hPageInstanceQuery:GET-NEXT().
        IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.    
        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE
               cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
               cLayoutCode           = hLocalPageBuffer:buffer-field("tLayoutCode":U):BUFFER-VALUE
               .
        IF VALID-HANDLE(hObjectInstanceHandle) THEN
        DO:
          IF hObjectInstanceHandle = hContainerToolbar OR
             hObjectInstanceHandle = hFolder OR
             hObjectInstanceHandle = hFolderToolbar OR
             hObjectInstanceHandle = hFilterViewer THEN
             NEXT.
          dPage0ObjectsHeight = dPage0ObjectsHeight + DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.
          /* We also need to move this object in the correct position */
          RUN repositionObject IN hObjectInstanceHandle (dTop, dLeft) NO-ERROR.
          dTop = dTop + DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle).

        END.  /* valid instance. */
    END.

    hPageInstanceQuery:QUERY-CLOSE().

    DELETE WIDGET-POOL cWidgetPool.
    
    IF dPage0ObjectsHeight <> 0 THEN 
      ASSIGN dObjectHeight = dObjectHeight - dPage0ObjectsHeight.
  
    IF DYNAMIC-FUNCTION("getHeight":U IN hFolder) > dObjectHeight THEN
      RUN resizeObject     IN hFolder (dObjectHeight, hTitleFillIn:WIDTH) NO-ERROR.
    IF DYNAMIC-FUNCTION("getWidth":U IN hFolder) > hTitleFillIn:WIDTH THEN DO:
      RUN resizeObject     IN hFolder (dObjectHeight, hTitleFillIn:WIDTH) NO-ERROR.
      RUN repositionObject IN hFolder (dTop, dLeft) NO-ERROR.
    END.
    ELSE DO:
      RUN repositionObject IN hFolder (dTop, dLeft) NO-ERROR.
      RUN resizeObject     IN hFolder (dObjectHeight, hTitleFillIn:WIDTH) NO-ERROR.
    END.
  END.

  /* Container Toolbar */
  IF VALID-HANDLE(hContainerToolbar) THEN
  DO:
    ASSIGN
        dObjectHeight = DYNAMIC-FUNCTION("getHeight":U IN hContainerToolbar).

    RUN resizeObject IN hContainerToolbar (dObjectHeight, pdContainerWidth) NO-ERROR.
  END.

  /* Set the top left coordinates in the source procedure */
  IF VALID-HANDLE(ghSourceProcedure) AND 
     LOOKUP("setTopLeft":U,ghSourceProcedure:INTERNAL-ENTRIES) > 0 THEN
    IF VALID-HANDLE(hFolder) THEN
      RUN setTopLeft IN ghSourceProcedure (/*(dTop  + 2)*/ {fn getInnerRow hFolder} - 0.75, (dLeft + 1)).
    ELSE
      RUN setTopLeft IN ghSourceProcedure ((dTop + 2), (dLeft + 1)).

  IF VALID-HANDLE(ghSourceProcedure) AND 
     LOOKUP("getTopLeft":U, ghSourceProcedure:INTERNAL-ENTRIES) > 0 THEN
    RUN getTopLeft IN ghSourceProcedure (OUTPUT dRow, OUTPUT dColumn) NO-ERROR.

  /* > NOW RESIZE AND MOVE OTHER OBJECTS < */
  CREATE WIDGET-POOL cWidgetPool.
  CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL cWidgetPool.
  CREATE BUFFER hLocalPageBuffer         FOR TABLE phPageBuffer IN WIDGET-POOL cWidgetPool.
/*     hLocalObjectBuffer = phObjectBuffer:DEFAULT-BUFFER-HANDLE. */

  CREATE QUERY hPageInstanceQuery IN WIDGET-POOL cWidgetPool.

  hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer, hLocalPageBuffer).

  IF DYNAMIC-FUNCTION("getMenuMaintenance":U IN ghSourceProcedure) THEN
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + ","                                     + " FIRST ":U + hLocalPageBuffer:NAME + " WHERE ":U
                                     + hLocalPageBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalPageBuffer:NAME + ".tRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalPageBuffer:NAME + ".tPageNumber = ":U + hLocalObjectBuffer:NAME + ".tPageNumber ":U
                                     + " BY ":U + hLocalObjectBuffer:NAME + ".tPageNumber ":U ).
  ELSE
    hPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND " 
                                     + hLocalObjectBuffer:NAME + ".tPageNumber <> 0, ":U
                                     + " FIRST ":U + hLocalPageBuffer:NAME + " WHERE ":U
                                     + hLocalPageBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalPageBuffer:NAME + ".tRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalPageBuffer:NAME + ".tPageNumber = ":U + hLocalObjectBuffer:NAME + ".tPageNumber ":U
                                     + " BY ":U + hLocalObjectBuffer:NAME + ".tPageNumber ":U ).

  hPageInstanceQuery:QUERY-OPEN().
  iPageNumber = ?.

  REPEAT:
      hPageInstanceQuery:GET-NEXT().
      IF NOT hLocalObjectBuffer:AVAILABLE THEN LEAVE.    

      ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE
             cObjectTypeCode       = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
             cLayoutCode           = hLocalPageBuffer:buffer-field("tLayoutCode":U):BUFFER-VALUE
             .
      IF VALID-HANDLE(hObjectInstanceHandle) AND NOT VALID-HANDLE(hFolder) AND 
          /*LOOKUP(cObjectTypeCode, gcSmartFolderClasses) > 0 */
          DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, INPUT cObjectTypeCode, INPUT "SmartFolder":U) THEN
          ASSIGN hMenuFolder = hObjectInstanceHandle.

      IF iPageNumber = hLocalPageBuffer:BUFFER-FIELD("tPageNumber":U):BUFFER-VALUE THEN
          NEXT.

      ASSIGN iPageNumber = hLocalPageBuffer:BUFFER-FIELD("tPageNumber":U):BUFFER-VALUE.

      IF VALID-HANDLE(hObjectInstanceHandle) THEN
      DO:
          dObjectHeight = DYNAMIC-FUNCTION("getHeight" IN hObjectInstanceHandle) NO-ERROR.                                
          dObjectWidth  = DYNAMIC-FUNCTION("getWidth"  IN hObjectInstanceHandle) NO-ERROR.                             
    
          IF hObjectInstanceHandle = hContainerToolbar OR
             hObjectInstanceHandle = hFolder OR
             hObjectInstanceHandle = hFolderToolbar THEN
             NEXT.
          
          IF hObjectInstanceHandle:FILE-NAME = "ry/obj/rydyntoolt.w" THEN
              ASSIGN dNewObjectColumn = 1
                     dNewObjectWidth  = 0
                     .         
          ELSE
              ASSIGN dNewObjectRow    = 0
                     dNewObjectHeight = dDesiredHeight
                     .
      END.  /* valid instance. */
      ELSE
          ASSIGN dNewObjectRow    = 0
                 dNewObjectHeight = dDesiredHeight
                 .
      dNewObjectWidth = dDesiredWidth.

      iCenterLeftCol = MAX(iCenterLeftCol, dNewObjectColumn + dObjectWidth).        

      /* For some reason it sometimes finds its way to code 05,* 
       * this code will ensure that the program does not fall  *
       * into an endless loop - *****DO NOT REMOVE*****        *
       * This problem only occurs randomly and could therfore  *
       * not be traced and fixed. This however solves the      *
       * intermediate problem. (Mark Davies - MIP)             */
      IF cLayoutCode = "05":U THEN
        NEXT.
      
      IF iPageNumber >= 1 AND
         VALID-HANDLE(hMenuFolder) THEN DO:
        ASSIGN dColumn = DYNAMIC-FUNCTION("getCol":U IN hMenuFolder)
               dRow    = DYNAMIC-FUNCTION("getRow":U IN hMenuFolder) + ( 1 + 8 / 10 ).
      END.
      
      /* This will move the first object right to the top 
         where the Folder Toolbar usually sits, when the
         is not visible - usually for menu objects */
      IF dFolderToolbarHeight > 0 THEN
        ASSIGN dRow = dRow - dFolderToolbarHeight
               dFolderToolbarHeight = 0.

      RUN VALUE("resize" + cLayoutCode) IN THIS-PROCEDURE
               (INPUT iPageNumber,
                INPUT phObjectBuffer,
                INPUT phPageBuffer,
                INPUT pdContainerWidth - dColumn - 2,
                INPUT pdContainerHeight - dRow - (IF VALID-HANDLE(hFolder) THEN (IF {fn getTabPosition hFolder} = "Upper":U THEN 0 ELSE {fn getTabRowHeight hFolder} - 0.60) ELSE 0),
                INPUT dColumn - 1.00,
                INPUT (IF NOT VALID-HANDLE(hFolder) THEN dRow - /* 1.5 */ ( 1 + 5 / 10 ) ELSE {fn getInnerRow hFolder} - 0.75),
                INPUT pdInstanceId          ).

  END.

  hPageInstanceQuery:QUERY-CLOSE().

  DELETE WIDGET-POOL cWidgetPool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resize06) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize06 Procedure 
PROCEDURE resize06 :
/*------------------------------------------------------------------------------
  Purpose:     Resize program for Relative layout.
  Parameters:  
            INPUT piPageNumber      AS INTEGER
            INPUT phObjectBuffer  AS HANDLE
            INPUT phPageBuffer          AS HANDLE
            INPUT pdContainerHeight AS DECIMAL
            INPUT pdTopLeftColumn   AS DECIMAL
            INPUT pdTopLeftRow      AS DECIMAL
  Notes:    
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber             AS INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER phObjectBuffer           AS HANDLE           NO-UNDO.
    DEFINE INPUT PARAMETER phPageBuffer             AS HANDLE           NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerWidth         AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerHeight        AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn          AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow             AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId             AS DECIMAL          NO-UNDO.
    
    DEFINE VARIABLE cLayoutPosition         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLayoutCode             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iVarWidthInstances      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iNumVarHeightRows       AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iLayoutRow              AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iRowNum                 AS INTEGER                  NO-UNDO.
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
           dDesiredHeight = pdContainerHeight - 0.24
           .
    /* Populate the ttRow and ttInstance temp-tables. */
    DYNAMIC-FUNCTION("buildRowsAndInstances":U IN TARGET-PROCEDURE,
                     INPUT ghSourceProcedure,
                     INPUT pdInstanceId,
                     INPUT piPageNumber,
                     INPUT phObjectBuffer,
                     INPUT phPageBuffer         ).
    
    /* Now that we've populated the Row table, we need to go back through it    
     * to reapportion any remaining available height among the variable height rows.
     * This takes two passes, one to calculate the number of variable height rows and
     * the total fixed height to allocate before resizing those variable height rows,
     * and then a second pass to actually adjust the height of the variable rows.     */
    FOR EACH bttRow WHERE
             bttRow.SourceProcedure = ghSourceProcedure AND
             bttRow.PageNum         = piPageNumber
             BY bttRow.RowNum:
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
                       iVarWidthInstances      = iVarWidthInstances - 1
                       .
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
                   dNewObjectColumn = (IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT bttInstance.ObjectTypeCode, INPUT "SmartToolbar":U) AND 
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
                ASSIGN dNewObjectRow = dNewObjectRow + dPrevRowHeight + 0.24.
        END.     /* END DO IF new iLayoutRow */
        /* If this isn't the first object in the row, then increment the column position
         * by the width of the previous object (dNewObjectWidth still has this value). */
        ELSE
            ASSIGN dNewObjectColumn = dNewObjectColumn + dNewObjectWidth + 1.

        ASSIGN dNewObjectHeight = (IF NOT bttInstance.FixedHeight THEN bttRow.RowHeight - 0.13 ELSE bttInstance.ObjectHeight).

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
                                                         INPUT  phObjectBuffer,
                                                         INPUT  phPageBuffer,
                                                         INPUT  bttInstance.ObjectTypeCode,
                                                         INPUT  bttInstance.ObjectInstanceHandle,
                                                         INPUT  pdTopLeftColumn,
                                                         INPUT  pdTopLeftRow,
                                                         INPUT  dNewObjectColumn,
                                                         INPUT  (IF dBottomRow > 0 THEN dBottomRow ELSE dNewObjectRow),
                                                         INPUT  dNewObjectWidth,
                                                         INPUT  dNewObjectHeight,
                                                         INPUT  pdInstanceId          ).    
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
  Purpose:     To move and resize object on page
  Parameters:  <none>
  Notes:       Uses repositionObject and resizeObject in objects themselves
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNumber         AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER phObjectBuffer       AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phPageBuffer         AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER pcObjectType         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER phObjectInstance     AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn      AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow         AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewColumn          AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewRow             AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewWidth           AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewHeight          AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL              NO-UNDO.
    
    DEFINE VARIABLE hPageQuery          AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hLocalPageBuffer    AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE iPageNumber         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hFrame              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hOldSourceProcedure AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cLayoutCode         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE dColumn             AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dInstanceId         AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE lPageInit           AS LOGICAL                      NO-UNDO.   
    DEFINE VARIABLE cWidgetPool         AS CHARACTER                    NO-UNDO.
    
    ASSIGN cWidgetPool          = "resizeAndMoveSomething":U + STRING(giUniqenessGuarantor)
           giUniqenessGuarantor = giUniqenessGuarantor + 1.
    
    /* WARNING:  LayoutManagers operate on Cartezian Co-ordinates, where top left is 0,0.  Progess (in
       character units) uses 1,1.  For this reason, 1 is added to each of the ROW and COLUMN positions in the
       repositionObject call */                                                       
    
    IF VALID-HANDLE(phObjectInstance) THEN
    DO:                                                   
      IF LOOKUP("resizeAndMoveObject",phObjectInstance:INTERNAL-ENTRIES) > 0 THEN 
      DO:
          RUN resizeAndMoveObject IN phObjectInstance (
              INPUT pdNewHeight,
              INPUT pdNewWidth,
              INPUT pdNewRow + pdTopLeftRow + 1,
              INPUT pdNewColumn + pdTopLeftColumn + 1).
      END.
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
        END.
      
        IF pdNewColumn + pdTopLeftColumn + 1 < dColumn THEN
        DO:
          IF LOOKUP("repositionObject",phObjectInstance:INTERNAL-ENTRIES) > 0 THEN 
            RUN repositionObject IN phObjectInstance
                                (INPUT pdNewRow + pdTopLeftRow + 1,
                                 INPUT pdNewColumn + pdTopLeftColumn + 1).            
      
          IF LOOKUP("resizeObject",phObjectInstance:INTERNAL-ENTRIES) > 0 THEN 
            RUN resizeObject IN phObjectInstance
                            (INPUT pdNewHeight,
                             INPUT pdNewWidth).
        END.
        ELSE
        DO:
          IF LOOKUP("resizeObject",phObjectInstance:INTERNAL-ENTRIES) > 0 THEN 
            RUN resizeObject IN phObjectInstance
                            (INPUT pdNewHeight,
                             INPUT pdNewWidth).
      
          IF LOOKUP("repositionObject",phObjectInstance:INTERNAL-ENTRIES) > 0 THEN 
            RUN repositionObject IN phObjectInstance
                                (INPUT pdNewRow + pdTopLeftRow + 1,
                                 INPUT pdNewColumn + pdTopLeftColumn + 1).            
        END.
      END.
    END.
    
    IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectType, INPUT "SmartFolder":U) THEN
    DO:
        DEFINE VARIABLE dTabColumn AS DECIMAL.
        DEFINE VARIABLE dTabRow    AS DECIMAL.
        DEFINE VARIABLE dTabWidth  AS DECIMAL.
        DEFINE VARIABLE dTabHeight AS DECIMAL.
    
        RUN getClientRectangle IN phObjectInstance (
            OUTPUT dTabColumn,
            OUTPUT dTabRow,
            OUTPUT dTabWidth,
            OUTPUT dTabHeight
            ).
    
        IF piPageNumber <> 0 THEN
        DO:
            /* error - folder on page other than 0 */
        END.
        ELSE DO:
            CREATE WIDGET-POOL cWidgetPool.
    
            /* now loop through all pages, resizing the layout for each one */
            CREATE BUFFER hLocalPageBuffer FOR TABLE phPageBuffer IN WIDGET-POOL cWidgetPool.

            CREATE QUERY hPageQuery IN WIDGET-POOL cWidgetPool.
    
            hPageQuery:SET-BUFFERS(hLocalPageBuffer).
            hPageQuery:QUERY-PREPARE("FOR EACH ":U + hLocalPageBuffer:NAME + " WHERE ":U 
                                     + hLocalPageBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(ghSourceProcedure) + ") AND ":U
                                     + hLocalPageBuffer:NAME + ".tRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     + hLocalPageBuffer:NAME + ".tPageNumber <> 0 ":U).
            hPageQuery:QUERY-OPEN().
    
            REPEAT:
                hPageQuery:GET-NEXT().
                IF NOT hLocalPageBuffer:AVAILABLE THEN LEAVE.
    
                iPageNumber = hLocalPageBuffer:BUFFER-FIELD("tPageNumber":U):BUFFER-VALUE.
                cLayoutCode = hLocalPageBuffer:BUFFER-FIELD("tLayoutCode":U):BUFFER-VALUE.
                lPageInit   = hLocalPageBuffer:BUFFER-FIELD("tPageInitialized":U):BUFFER-VALUE.

                IF lPageInit THEN
                    RUN resizeLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,
                                                           INPUT  iPageNumber,
                                                           INPUT  phObjectBuffer,
                                                           INPUT  phPageBuffer,
                                                           INPUT  dTabWidth,
                                                           INPUT  dTabHeight,
                                                           INPUT  dTabColumn - 1,
                                                           INPUT  dTabRow - 1,
                                                           INPUT  pdInstanceId       ).
            END.
    
            hPageQuery:QUERY-CLOSE().
            DELETE OBJECT hPageQuery.
            ASSIGN hPageQuery = ?.
    
            DELETE WIDGET-POOL cWidgetPool.
        END.
    END.    /* SmartFolder */    
    ELSE
    IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectType, INPUT "DynFrame":U) OR
       /* This is to cater for instances where a container is forcibly run using the dynamic frame */
       phObjectInstance:FILENAME MATCHES "*rydynframw*":U                                             THEN
    DO:
        /* Get the instanceID of the DynFrame instance. */
        {get InstanceId dInstanceId phObjectInstance}.

        /* Get the layout code */
        phPageBuffer:FIND-FIRST(" WHERE ":U
                                + phPageBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(phObjectInstance) + ") AND ":U
                                + phPageBuffer:NAME + ".tPageNumber = 0 ":U ).

        ASSIGN cLayoutCode = phPageBuffer:BUFFER-FIELD("tLayoutCode"):BUFFER-VALUE.

        /* The ghSourceProcedure is used to find the relevant objects. Since a global variable
         * is used we need to fool this resize procedure.                                     */
        ASSIGN hOldSourceProcedure = ghSourceProcedure
               ghSourceProcedure   = phObjectInstance
               .
        /* Always resize the frame on page zero. If there is a folder page on the frame,
         * it will resize correctly s a result of the folder resizing code.             
         *
         * The top left row and column are always passed in as zero ebcasue we are positioning on
         * a new frame completely, and always want to start in the top left corner. The frame itself
         * has been repositioned (and resized) by a call a little earlier in this procedure.        */        
        RUN resizeLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,           /* pcLayoutCode    */
                                               INPUT  0,                     /* piPageNumber    */
                                               INPUT  phObjectBuffer,        /* phObjectBuffer  */
                                               INPUT  phPageBuffer,          /* phPageBuffer    */
                                               INPUT  pdNewWidth,            /* pdMinWidth      */
                                               INPUT  pdNewHeight,           /* pdMinHeight     */
                                               INPUT  0,                     /* pdTopLeftColumn */
                                               INPUT  0,                     /* pdTopLeftRow    */
                                               INPUT  dInstanceId       ).   /* pdInstanceId    */

        /* Resize frame if necessary. The DynFrame will set the ResizeMe value to Pending
         * if the frame is being resized smaller. If this is the case, then the resize is not
         * performed until all of the objects on the DynFrame have been made smaller. If we don't
         * do this there is a good chance of errors.                                             */
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
  Purpose:     To re-layout window contents after a resize
  Parameters:  <none>
  Notes:       called internally from packwindow or resizewindow
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLayoutCode         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER piPageNumber         AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER phObjectBuffer       AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phPageBuffer         AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER pdMinWidth           AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdMinHeight          AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftColumn      AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdTopLeftRow         AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId         AS DECIMAL              NO-UNDO.

    IF NOT CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES, "resize":U + pcLayoutCode) THEN
        RETURN.

    RUN VALUE("resize" + pcLayoutCode) ( INPUT piPageNumber,
                                         INPUT phObjectBuffer,
                                         INPUT phPageBuffer,
                                         INPUT pdMinWidth,
                                         INPUT pdMinHeight,
                                         INPUT pdTopLeftColumn,
                                         INPUT pdTopLeftRow,
                                         INPUT pdInstanceId         ).

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

    DEFINE BUFFER ttRow         FOR ttRow.
    DEFINE BUFFER ttInstance    FOR ttInstance.

    ASSIGN phFrame:SCROLLABLE     = FALSE
           phFrame:WIDTH          = MAX(phFrame:WIDTH,  phWindow:WIDTH)
           phFrame:HEIGHT         = MAX(phFrame:HEIGHT, phWindow:HEIGHT)
           dRow                   = 0
           dColumn                = 0
           NO-ERROR.

    /* Set the source procedure variable. For details of why then
     * 'resizeWindowFromSuper' is checked, see that API for details why. */
    IF NOT PROGRAM-NAME(2) BEGINS "resizeWindowFromSuper":U THEN
        ASSIGN ghSourceProcedure = SOURCE-PROCEDURE.

    FOR EACH ttRow WHERE ttRow.SourceProcedure = ghSourceProcedure:
        DELETE ttRow.
    END.    /* each row */

    FOR EACH ttInstance WHERE ttInstance.SourceProcedure = ghSourceProcedure:
        DELETE ttInstance.     
    END.    /* each instance */

    IF VALID-HANDLE(ghSourceProcedure)                                AND 
       LOOKUP("getTopLeft":U, ghSourceProcedure:INTERNAL-ENTRIES) > 0 THEN
        RUN getTopLeft IN ghSourceProcedure (OUTPUT dRow, OUTPUT dColumn) NO-ERROR.
    
    RUN resizeLayout( INPUT  pcLayoutCode,
                      INPUT  0,
                      INPUT  phObjectBuffer,
                      INPUT  phPageBuffer,
                      INPUT  phWindow:WIDTH,
                      INPUT  phWindow:HEIGHT,
                      INPUT  dColumn,
                      INPUT  dRow,
                      INPUT  pdInstanceId           ).

    ASSIGN phFrame:WIDTH  = phWindow:WIDTH
           phFrame:HEIGHT = phWindow:HEIGHT
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
      INPUT pdInstanceId            AS DECIMAL,
      INPUT piPageNumber            AS INTEGER,
      INPUT phObjectBuffer          AS HANDLE,
      INPUT phPageBuffer            AS HANDLE  ) :
/*------------------------------------------------------------------------------
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
    DEFINE VARIABLE cWidgetPool                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lQueryObject                AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE dRowMinHeight               AS DECIMAL    EXTENT 9  NO-UNDO.
    DEFINE VARIABLE iRowLoop                    AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cLayoutCode                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLayoutPosition             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cJustifyCode                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLayoutRow                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iRowNum                     AS INTEGER              NO-UNDO.

    DEFINE BUFFER bttInstance  FOR ttInstance.
    DEFINE BUFFER bttRow       FOR ttRow.

    CREATE BUFFER hLocalObjectBuffer FOR TABLE phObjectBuffer BUFFER-NAME "LocalObjectBuffer":U.
    CREATE QUERY hPageInstanceQuery.

    hPageInstanceQuery:SET-BUFFERS(hLocalObjectBuffer).
    hPageInstanceQuery:QUERY-PREPARE(" FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(phTargetProcedure) + ") AND ":U
                                     + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " AND ":U
                                     /* Skip the container itself. */
                                     + hLocalObjectBuffer:NAME + ".tTargetProcedure <> ":U + hLocalObjectBuffer:NAME + ".tObjectInstanceHandle AND ":U
                                     + hLocalObjectBuffer:NAME + ".tPageNumber = ":U + QUOTER(piPageNumber)
                                     + " BY SUBSTR(":U + hLocalObjectBuffer:NAME + ".tLayoutPosition, 2) ":U).

    hPageInstanceQuery:QUERY-OPEN().
    hPageInstanceQuery:GET-FIRST().
    DO WHILE hLocalObjectBuffer:AVAILABLE:
        ASSIGN hObjectInstanceHandle = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceHandle":U):BUFFER-VALUE.
        IF NOT VALID-HANDLE(hObjectInstanceHandle) THEN
        DO:
            hPageInstanceQuery:GET-NEXT().
            NEXT.
        END.

        ASSIGN cObjectTypeCode = hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
               cLayoutPosition = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE
               .
        /* No need to try and reposition or size non-visible objects */
        {get QueryObject lQueryObject hObjectInstanceHandle} NO-ERROR.
        IF lQueryObject THEN
        DO:
            hPageInstanceQuery:GET-NEXT().
            NEXT.
        END.

        ASSIGN cLayoutCode  = SUBSTR(cLayoutPosition, 1, 1)
               iLayoutRow   = INTEGER(SUBSTR(cLayoutPosition, 2, 1))
               cJustifyCode = SUBSTR(ENTRY(1,cLayoutPosition), LENGTH(ENTRY(1,cLayoutPosition)), 1)
               NO-ERROR.
        /* Make sure that there is a justification code specified */
        IF cJustifyCode <> "C":U AND cJustifyCode <> "R":U THEN
            ASSIGN cJustifyCode = "":U. /* Default - Left */

        IF cLayoutPosition = "":U OR iLayoutRow = 0 THEN
        DO:
            hPageInstanceQuery:GET-NEXT().
            NEXT.
        END.

        {get WIDTH dObjectWidth hObjectInstanceHandle}.
        {get HEIGHT dObjectHeight hObjectInstanceHandle}.

        IF dObjectHeight <> ? AND cLayoutPosition <> "":U THEN
        DO:
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

            {get ResizeVertical lResizeVertical hObjectInstanceHandle}.
            {get ResizeHorizontal lResizeHorizontal hObjectInstanceHandle}.

            /* In some cases the Attribute might not be set - then use object type
             * to determine what sizing is allowd */
            IF lResizeVertical = ? OR lResizeHorizontal = ? THEN
            DO:
              IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT cObjectTypeCode, INPUT "Browser":U) OR 
                 DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT cObjectTypeCode, INPUT "SmartFolder":U) THEN      
                  ASSIGN lResizeVertical   = IF lResizeVertical = ? THEN YES ELSE lResizeVertical
                         lResizeHorizontal = IF lResizeHorizontal = ? THEN YES ELSE lResizeHorizontal.
              ELSE
                  IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT cObjectTypeCode, INPUT "Viewer":U) THEN
                      ASSIGN lResizeVertical   = IF lResizeVertical = ? THEN NO ELSE lResizeVertical
                             lResizeHorizontal = IF lResizeHorizontal = ? THEN NO ELSE lResizeHorizontal.
                  ELSE
                      IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT cObjectTypeCode, INPUT "SmartToolbar":U) THEN
                          ASSIGN lResizeVertical   = IF lResizeVertical = ? THEN NO ELSE lResizeVertical
                                 lResizeHorizontal = IF lResizeHorizontal = ? THEN YES ELSE lResizeHorizontal.
                      ELSE
                          ASSIGN lResizeVertical   = IF lResizeVertical = ? THEN NO ELSE lResizeVertical
                                 lResizeHorizontal = IF lResizeHorizontal = ? THEN NO ELSE lResizeHorizontal.
            END.    /* resize* flags not set. */

            /* Determine the smallest size the folder can be,
             * by reading through the pages and determining the dimensions
             * of the pages.                                               */                
            IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT cObjectTypeCode, INPUT "SmartFolder":U) THEN
            DO:
                CREATE BUFFER hLocalPageBuffer FOR TABLE phPageBuffer BUFFER-NAME "LocalPageBuffer":U.
                CREATE QUERY hPageQuery.
                hPageQuery:SET-BUFFERS(hLocalPageBuffer).
                hPageQuery:QUERY-PREPARE("FOR EACH ":U + hLocalPageBuffer:NAME + "  WHERE ":U
                                         + hLocalPageBuffer:NAME + ".tTargetProcedure = WIDGET-HANDLE(":U + QUOTER(phTargetProcedure) + ") AND ":U
                                         + hLocalPageBuffer:NAME + ".tPageNumber  GT 0 NO-LOCK ":U).
                hPageQuery:QUERY-OPEN().
                hPageQuery:GET-FIRST().

                ASSIGN dMinHeight    = 0
                       dMinWidth     = 0
                       dObjectHeight = 0
                       dObjectWidth  = 0
                       .
                DO WHILE hLocalPageBuffer:AVAILABLE:
                    ASSIGN iPageNumber = hLocalPageBuffer:BUFFER-FIELD("tPageNumber":U):BUFFER-VALUE
                           cLayoutCode = hLocalPageBuffer:BUFFER-FIELD("tLayoutCode"):BUFFER-VALUE
                           .
                    RUN packLayout IN TARGET-PROCEDURE ( INPUT  cLayoutCode,
                                                         INPUT  iPageNumber,
                                                         INPUT  iPageNumber,
                                                         INPUT  phObjectBuffer,
                                                         INPUT  phPageBuffer,
                                                         INPUT  pdInstanceId,
                                                         OUTPUT dObjectWidth,
                                                         OUTPUT dObjectHeight   ).
                    ASSIGN dMinHeight = MAX(dMinHeight, dObjectHeight)
                           dMinWidth  = MAX(dMinWidth, dObjectWidth).

                    hPageQuery:GET-NEXT().
                END.    /* page buffer available */
                hPageQuery:QUERY-CLOSE().

                ASSIGN dMinHeight            = dMinHeight + {fn getTabRowHeight hObjectInstanceHandle} + 0.48
                       bttInstance.MinWidth  = dMinWidth
                       bttInstance.MinHeight = dMinHeight
                       .
                DELETE OBJECT hPageQuery NO-ERROR.
                DELETE OBJECT hLocalPageBuffer NO-ERROR.
                ASSIGN hLocalPageBuffer = ?
                       hPageQuery       = ?.
            END.    /* F-O-L: SmartFolder */
            ELSE
            DO:                
                {get minWidth  bttInstance.MinWidth  hObjectInstanceHandle}.
                {get minHeight bttInstance.MinHeight hObjectInstanceHandle}.
            END.    /* non-folder objects */

            /* Ensure that there are no null value in the min* fields. */
            IF bttInstance.MinHeight EQ ? THEN ASSIGN bttInstance.MinHeight = 0.
            IF bttInstance.MinWidth EQ ?  THEN ASSIGN bttInstance.MinWidth  = 0.

            ASSIGN bttInstance.FixedHeight = NOT lResizeVertical
                   bttInstance.FixedWidth  = NOT lResizeHorizontal.

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
        END.       /* END DO if there's a layout position and a size */

        hPageInstanceQuery:GET-NEXT().
    END.           /* END REPEAT loop for all objects on the page */
    hPageInstanceQuery:QUERY-CLOSE().

    DELETE OBJECT hPageInstanceQuery NO-ERROR.    
    DELETE OBJECT hLocalObjectBuffer NO-ERROR.

    ASSIGN hLocalObjectBuffer = ?
           hPageInstanceQuery = ?.
    RETURN TRUE.
END FUNCTION.   /* buildRowsAndInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

