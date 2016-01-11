/***********************************************************************
* Copyright (C) 2005-2010 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*---------------------------------------------------------------------------------
         File: afsestranw.i
  
  Description: Include file for translateWidgets() API in
  			   Dynamics Session Manager (af/app/afsesmngrp.i).

  Purpose:      

  Parameters:   
  DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER phFrame  AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER TABLE FOR ttTranslate.
    
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                DATE:   06/30/2005  Author:    pjudge 

  Update Notes: Initial Implementation. Code moved here to avoid
   			    blowing up Section Editor limits.
   			    
   			    Program flow:
                1. Get translated strings from Translation Manager
                2. Calculate column offsets so as to fit translated labels on frame
                3. Resize frame
                4. Apply translations to field-level widgets
---------------------------------------------------------------------------------*/      
  DEFINE VARIABLE hDataSource               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSideLabel                AS HANDLE     NO-UNDO.  
  DEFINE VARIABLE cRadioButtons             AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE dNewLabelLength           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLabelWidth               AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dAddCol                   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iEntry                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cListItemPairs            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLabelHandle              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iFont                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dColumn                   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dWidth                    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hWidget                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cAllFieldHandles          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllFieldNames            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelText                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dMinFrameWidth            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hSDFParentFrame           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cResizeForTranslation     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLabel                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lHasFieldLabel            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lIsSmartDataField         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTranslatedTextsAndValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRadioLoop                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRadioOption              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dOptionWidth              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dRadioSetWidth            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lFrameVisible             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWidgetName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lKeepChildPositions       AS LOGICAL    NO-UNDO.
  define variable lShowLabelTooltip         as logical    no-undo.
  define variable lLookupField              as logical no-undo.
  define variable lSdf                      as logical no-undo.
  define variable hRealContainer            as handle  no-undo.
  define variable dPrevColPos               as decimal no-undo.
  define variable dPrevColWidth             as decimal no-undo.
  define variable hParentFrame              as handle no-undo.
  
  DEFINE BUFFER btViewerCol FOR ttViewerCol.
  define buffer lbTranslate for ttTranslate.
  
  /* first things first: get translations, and check if there actually are any.
     if not, don't bother doing any more work. */  
  RUN multiTranslation IN gshTranslationManager (INPUT NO, INPUT-OUTPUT TABLE ttTranslate).
  
  ASSIGN cResizeForTranslation = {fnarg getUserProperty "'ResizeForTranslation'" phObject}.  
  IF NOT CAN-FIND(FIRST ttTranslate
                  WHERE ttTranslate.cTranslatedLabel <> "":U
                     OR ttTranslate.cTranslatedTooltip <> "":U) 
  AND cResizeForTranslation <> "YES":U THEN
      RETURN.
  
  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource phObject}
  {get AllFieldHandles cAllFieldHandles phObject}
  {get AllFieldNames cAllFieldNames phObject}
  .
  &UNDEFINE xp-assign
  
  /* outside the xp-assign because of the no-error */
  {get KeepChildPositions lKeepChildPositions phObject} NO-ERROR.
 
    /* Find all the DataField translations, and apply them to
       the widgets that don't have actual translations. We do this here 
       because the next look ignores any untranslated records, and we need
       to perform the actual translation per widget type.	*/
    for each ttTranslate where
             ttTranslate.cWidgetType = 'DataField':u and
             ttTranslate.cTranslatedLabel <> '':u and
             ttTranslate.iWidgetEntry = 1,    /* labels only */
       first lbTranslate where
             lbTranslate.hWidgetHandle = ttTranslate.hWidgetHandle and
             lbTranslate.cWidgetType <> 'DataField':u and
             lbTranslate.cTranslatedLabel = '':u and
             lbTranslate.iWidgetEntry = 0:    /* labels only */
        lbTranslate.cTranslatedLabel = ttTranslate.cTranslatedLabel.                   
    end.    /* datafield translations */
 
  EMPTY TEMP-TABLE ttViewerCol.
         
  /* Cater for single SDFs */
  IF /* Deep CreateObjects means there are always values here */  
     ({fnarg InstanceOf 'LookupField' phObject} or {fnarg InstanceOf 'Select' phObject}) then
  DO:
    ASSIGN cAllFieldHandles = STRING(phObject).
    {get ContainerSource hSDFParentFrame phObject}.
    IF VALID-HANDLE(hSDFParentFrame) THEN
    do:
       DYNAMIC-FUNCTION("setUserProperty":U IN hSDFParentFrame, INPUT "ResizeForTranslation", INPUT "YES":U).
       /* Follow the 5th commandment (honour thy parents) */
       {get KeepChildPositions lKeepChildPositions hSDFParentFrame} NO-ERROR.
    end.
  END.  /* this is a single SDF */
  
  /* only want this logic once. */
  if lKeepChildPositions eq ? then
      /* Default behaviour is to resize */
      lKeepChildPositions = No.

  /* [PJ] moved the logic outside of the KeepChildPositions check since we always
     need this information. */
  assign lHasFieldLabel    = false
         lIsSmartDataField = false.
  
  lHasFieldLabel = {fnarg InstanceOf 'LookupField' phObject}.
  if not lHasFieldLabel then
    lHasFieldLabel = {fnarg InstanceOf 'Select' phObject}.
        
  if {fn getObjectType phObject} eq 'SmartDataField':U then
    lIsSmartDataField = true.

  /* BUG 20040312-024 describes a core bug which results in the 
       translated label of a static SDF not showing until the viewer
       has been hidden and then re-viewed. If the SDF's frame is not hidden, 
       then we hide the viewer first, then perform the translations and
       then re-un-hide the SDF's frame. I am deliberately saying hidden/un-hidden
       because the :HIDDEN attribute must be used for this and not the :VISIBLE 
       attribute.
     */
  ASSIGN lFrameVisible = NOT phFrame:HIDDEN.
  IF lFrameVisible THEN
    ASSIGN phFrame:HIDDEN = YES.
            
   /* Calculate column offsets. We don't want to do this if KeepChildPositions
      is true, since no moving and shaking will take place. */
    if not lKeepChildPositions eq true then
    do:
      IF cAllFieldHandles > "":U  THEN 
      DO:
        field-loop:
        DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):  
          ASSIGN 
            hWidget     = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)).
            cWidgetName = ENTRY(iLoop,cAllFieldNames).
          
          /* Currently we take the qualifier off SBO fields */
          IF NUM-ENTRIES(cWidgetName,'.') > 1 THEN 
            cWidgetName = ENTRY(NUM-ENTRIES(cWidgetName,'.'),cWidgetName,'.').
    
          IF NOT VALID-HANDLE(hWidget)
          OR LOOKUP(hWidget:TYPE, "button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box,procedure":U) = 0 
          OR (hWidget:TYPE = "BUTTON":U AND hWidget:LABEL = "...":U) THEN
              NEXT field-loop.
              
          /* All procedures in here are either SmartDataFields or SmartLOBField 
             (per viewer.p:updateFieldProperties) */
          lSdf = hWidget:Type eq 'procedure':u.
          if lSdf then
          do:
            lLookupField = {fnarg InstanceOf 'LookupField' hWidget}.
            if not lLookupField then
                lLookupField = {fnarg InstanceOf 'Select' hWidget}.
          end.
          
          /* Determine what font we're using for this widget */
          ASSIGN iFont = ?.
          if lSDf and lLookupField then
          DO:
              {get LabelHandle hLabelHandle hWidget}.
              IF VALID-HANDLE(hLabelHandle) AND CAN-QUERY(hLabelHandle,"FONT":U) THEN
                  ASSIGN iFont = hLabelHandle:FONT.
          END.  /* is this any SDF? */
          ELSE
          IF CAN-QUERY(hWidget,"FONT":U) THEN 
              ASSIGN iFont = hWidget:FONT.
          
          /* Calculate what the width of the new label is going to be */
          if lSDf and lLookupField then
          DO:
              ASSIGN cLabelText = "":U.
              /* Check for SDF */
              /* The LabelHandle only exists for dynamic SDFs such as
                 dyn lookups and dyn combos. It should not exist for
                 static SDFs and is used to distinguish between the
                 static and dynamic objects.
                 
                 This distinction is important because the dynlookups/combos
                 place their labels on their containing viewers' frames and
                 not on their own frame. This means that even though the
                 translation has already taken place (via a call into this 
                 procedure, translateWidgets()) the viewer still needs to 
                 adjust for this.
                 
                 Static SDFs will handle all frame and label moving internally,
                 and since the label is placed on the static SDF's frame, it is 
                 not neccessary to make any adjustments to the viewer columns. 
                 "All" that is needed is for static SDF to be reposition (if necessary).                
               */
              /* Dynlookups/combos have their labels translated already */
              {get Label cLabelText hWidget}.
              ASSIGN dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cLabelText + " :   ":U, iFont).
          END.  /* this is any SDF. */
          ELSE
          IF CAN-QUERY(hWidget,"LABEL":U) THEN else-blk: DO:
              IF hWidget:TYPE = "radio-set":U THEN 
              DO:
                  ASSIGN cLabelText      = "":U
                         dNewLabelLength = 0.
                  LEAVE else-blk.
              END.  /* radio-set */

              ASSIGN cLabelText = hWidget:LABEL.

              FIND FIRST ttTranslate
                   WHERE ttTranslate.cWidgetName = cWidgetName 
                     AND ttTranslate.cTranslatedLabel <> "":U
                   NO-ERROR.

              IF AVAILABLE ttTranslate THEN
              DO:
                  /* Always assume we're going to have to take the colon into account as well */
                  ASSIGN cLabelText = ttTranslate.cTranslatedLabel.

                  /* Let the 4gl handle adding of colons, except for PGEN where we need 
	                 to do it ourselves. */
                  if can-query(ttTranslate.hWidgetHandle, 'Side-Label-Handle':U) and
                     valid-handle(ttTranslate.hWidgetHandle:side-label-handle) and
                     ttTranslate.hWidgetHandle:SIDE-LABEL-HANDLE:DYNAMIC and
                     INDEX(cLabelText, ":":U) = 0 THEN
                     cLabelText = cLabelText + ":":u.
                  
                  dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cLabelText, iFont)
                                  /* Pad the width by 3 pixels, as done when actually writing the translated label.
	                                 Convert this into column PPUs because that's what we're working with here.     */
                                  + (3 / session:pixels-per-column).
              END.  /* there is a translation. */
              ELSE
                  ASSIGN dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cLabelText, iFont).
          END.  /* ELSE-BLK: there is a LABEL attribute */
          
          /* Get the widget column */
          IF CAN-QUERY(hWidget,"COLUMN":U) THEN
              ASSIGN dColumn = hWidget:COLUMN.
          ELSE DO:
              /* Check for SDF */
              if lSdf then
              DO:
                  {get Col dColumn hWidget}.
                  IF dColumn = ? OR dColumn < 0 THEN
                      ASSIGN dColumn = 1.
              END.  /* any SDF */
          END.  /* there is no 4GL column attribute */

          /* Get the widget width */
          IF CAN-QUERY(hWidget,"WIDTH":U) THEN 
          DO:
              IF hWidget:TYPE = "RADIO-SET":U THEN 
              DO:
                  IF CAN-FIND(FIRST ttTranslate
                              WHERE ttTranslate.cWidgetName = cWidgetName 
                                AND ttTranslate.cTranslatedLabel <> "":U
                                AND ttTranslate.iWidgetEntry > 0) THEN 
                  DO:
                      /* We need to calculate how wide the radio-set is going to be after translation */
                      ASSIGN cRadioButtons = hWidget:RADIO-BUTTONS
                             dWidth        = 0
                             dOptionWidth  = 0.

                      FOR EACH ttTranslate
                         WHERE ttTranslate.cWidgetName = hWidget:NAME 
                           AND ttTranslate.cTranslatedLabel <> "":U
                           AND ttTranslate.iWidgetEntry > 0:
    
                          ASSIGN iEntry = (ttTranslate.iWidgetEntry * 2) - 1
                                 ENTRY(iEntry, cRadioButtons) = ttTranslate.cTranslatedLabel.
                      END.  /* loop through individual radio button translations */

                      /* Calc the width */
                      IF NOT hWidget:HORIZONTAL THEN 
                      DO:
                          DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:
                              ASSIGN cRadioOption = ENTRY(iRadioLoop, cRadioButtons).
                              ASSIGN dOptionWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cRadioOption, iFont) + 3.8. /* to reserve space for the UI (circle) */
                              ASSIGN dWidth = MAX(dWidth,dOptionWidth).
                          END.  /* loop through buttons */
                      END.  /* vertical alignment */
                      ELSE DO:
                          ASSIGN dWidth = 0.
                          DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:
                              ASSIGN cRadioOption = ENTRY(iRadioLoop, cRadioButtons).
                              ASSIGN dOptionWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cRadioOption, iFont).
                              ASSIGN dWidth = dWidth + dOptionWidth + 3.8. /* to reserve space for the UI (circle) */.
                          END.  /* loop through buttons */
                      END.  /* horizontal alignment */
                  END.  /* can find a translation for the radio-set */
                  ELSE
                      ASSIGN dWidth = hWidget:WIDTH.
              END.  /* widget is a radio-set */
              ELSE
                  ASSIGN dWidth = hWidget:WIDTH.
          END.  /* there is a 4GL WIDTH attribute */
          ELSE DO:
              /* Check for SDF */
              if lSdf then
              DO:
                  {get Width dWidth hWidget}.
                  IF dWidth = ? OR dWidth < 0 THEN
                      ASSIGN dWidth = 10.
              END.  /* any SDF */
          END.  /* no 4GL width attribute */
          
          /* Assign the column width and space needed for the label to the column temp-table */
          /* Try to reduce amount of TT finds we do */
          IF AVAILABLE ttViewerCol and ttViewerCol.dColumn ne dColumn then
          FIND FIRST ttViewerCol
               WHERE ttViewerCol.dColumn = dColumn
               NO-ERROR.
          IF NOT AVAILABLE ttViewerCol 
          THEN DO:
              CREATE ttViewerCol.
              ASSIGN ttViewerCol.dColumn = dColumn.
          END.  /* create a viewercol record */
          
          /* We care about the column position and the potentially-translated things:
             the label in most cases, and the width for radio-sets. Note that these
             values are for TRANSLATED strings even though the actual translations
             have not been done yet (except for SDFs). */
          ASSIGN ttViewerCol.dColWidth = MAXIMUM(ttViewerCol.dColWidth,dWidth)
                 ttViewerCol.dMaxLabel = MAXIMUM(ttViewerCol.dMaxLabel, dNewLabelLength).
        END.    /* FIELD-LOOP: loop through all field handles */
      END.  /* there are valid values in the field handles */
      
      /* Check if we need to shift columns to the right to make space for translated widgets */
      {get MinWidth dMinFrameWidth phObject}.

      /* dNewCol will always be greater than dCol */
      FOR EACH ttViewerCol by ttViewerCol.dColumn:
        FIND LAST btViewerCol WHERE 
                  btViewerCol.dColumn < ttViewerCol.dColumn 
                  no-error.
        if available btViewerCol THEN
            assign dPrevColPos = btViewerCol.dNewCol
                   dPrevColWidth = btViewerCol.dColWidth.
        else                   
            assign dPrevColPos   = 0
                   dPrevColWidth = 0.
        
        ASSIGN ttViewerCol.dNewCol = MAXIMUM(ttViewerCol.dColumn,
                                             dPrevColPos + dPrevColWidth + ttViewerCol.dMaxLabel + 2.4)
               dMinFrameWidth = MAXIMUM(dMinFrameWidth,(ttViewerCol.dNewCol + ttViewerCol.dColWidth)).
      END.  /* loop through all viewer columns */
      
      /* If the new size causes the viewer to be larger than the session's max width
	     we need to trim the translations down a bit */     
      IF dMinFrameWidth > (SESSION:WIDTH - 5) THEN
      DO:
        run showWarningMessages in target-procedure ({errortxt.i 'RY' '21'}, 'WAR':u, '':u).
        
        /* Reset frame visibility upon returning */
        IF lFrameVisible THEN
            ASSIGN phFrame:HIDDEN = NO.
        RETURN.
      END.  /* frame too big for monitor. */
      
      /* Need to resize frame to fit new labels */
      IF CAN-FIND(FIRST ttViewerCol WHERE ttViewerCol.dColumn <> ttViewerCol.dNewCol) THEN 
      DO:
          dAddCol = 0.
          /* If this is a dynlookup/dyncombo/smartselect then the width of the frame should not
             change; only the position (if relevant). This is because the *parent* frame will 
             resize.
           */
          if lHasFieldLabel then
          do:
              {get ContainerSource hRealContainer phObject}.
              {get ContainerHandle hParentFrame hRealContainer}.
              
              /* resize parent frame */ 
              RUN resizeNormalFrame IN TARGET-PROCEDURE (hRealContainer, hParentFrame, dMinFrameWidth).
          end.  /* dynlookup/dyncombo/smartselect  */          
          ELSE
          /* Static SDFs, SmartLobs etc */
          IF lIsSmartDataField THEN 
              RUN resizeSDFFrame IN TARGET-PROCEDURE (INPUT phObject, INPUT phFrame, INPUT dAddCol). 
          else
          do:
              {get Width dAddCol phObject}.
              IF dAddCol = ? OR dAddCol < 0 THEN
                ASSIGN dAddCol = 0.
              ASSIGN dAddCol = dMinFrameWidth - dAddCol.
              
              IF dAddCol < 0 OR dAddCol = ? THEN
                ASSIGN dAddCol = 0.    
              IF dAddCol > 0 
              THEN DO:
                  RUN resizeNormalFrame IN TARGET-PROCEDURE (INPUT phObject, INPUT phFrame, INPUT dMinFrameWidth).
                  RUN adjustWidgets IN TARGET-PROCEDURE (INPUT phObject, INPUT phFrame, INPUT dAddCol).
              END.  /* there are columns to add */
          end.  /* normal viewer */
      END.  /* we need to move some stuff to the right */
      /* If lHasFieldLabel then this is a dynamic lookup or dynamic combo.  The labels for 
	     dynamic lookups and dynamic combos are on their viewer frames, not the lookup/combo 
	     frames so there should never be a need to resize the lookup/combo frame.  There is logic 
	     above to invoke resizeLookupFrame but that code block is for objects that have multipe 
	     widgets (which lookup and combos would not have) so it probably never runs but it will 
	     be left intact to minimize the risk of regressions. */
      ELSE IF NOT lHasFieldLabel THEN 
      DO:
          ASSIGN dAddCol = DYNAMIC-FUNCTION("getWidth":U IN phObject) NO-ERROR.
          IF dAddCol = ? OR dAddCol < 0 THEN
              ASSIGN dAddCol = 0.
          ASSIGN dAddCol = dMinFrameWidth - dAddCol.
          IF dAddCol > 0 THEN
              RUN resizeNormalFrame IN TARGET-PROCEDURE (INPUT phObject, INPUT phFrame, INPUT dMinFrameWidth).
      END.  /* no fieldlabel */
    end.    /* keep child positions */

  /* Now apply the translations to the widgets */
  translate-loop:
  FOR EACH ttTranslate:
    hSideLabel = ?.
    
    IF NOT VALID-HANDLE(ttTranslate.hWidgetHandle)
    OR (ttTranslate.cTranslatedLabel = "":U 
    AND ttTranslate.cTranslatedTooltip = "":U) THEN 
        NEXT translate-loop.
    
    CASE ttTranslate.cWidgetType:
      when 'DataField':u then
          /* Skip all DataField translations - we've already dealt with them. */
          next TRANSLATE-LOOP.
      WHEN "browse":U THEN 
      DO:
          IF ttTranslate.cTranslatedLabel <> "":U THEN 
           DO:
              ASSIGN ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel NO-ERROR.
              IF VALID-HANDLE(hDataSource) THEN 
              DO:
                  DYNAMIC-FUNCTION("assignColumnLabel":U IN hDataSource,
                                   INPUT (IF ttTranslate.hWidgetHandle:NAME = ? THEN "":U ELSE ttTranslate.hWidgetHandle:NAME),
                                   INPUT ttTranslate.hWidgetHandle:LABEL).
                  DYNAMIC-FUNCTION("assignColumnColumnLabel":U IN hDataSource,
                                   INPUT (IF ttTranslate.hWidgetHandle:NAME = ? THEN "":U ELSE ttTranslate.hWidgetHandle:NAME),
                                   INPUT ttTranslate.hWidgetHandle:LABEL).
              END.
          END.
          IF ttTranslate.cTranslatedTooltip <> "":U THEN
              ASSIGN ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip NO-ERROR.
      END.    /* browser */
      WHEN "COMBO-BOX":U OR 
      WHEN "SELECTION-LIST":U THEN 
      DO:
          IF ttTranslate.cTranslatedLabel NE "":U AND ttTranslate.cTranslatedLabel NE ? THEN
          DO:
              /* The widget entry indicates the label. Entries > 0 are items in the combo/sellist */
              IF ttTranslate.iWidgetEntry EQ 0 THEN 
              DO:
                  IF CAN-QUERY(ttTranslate.hWidgetHandle,"FILE-NAME":U) 
                  AND INDEX(ttTranslate.cObjectName, ":":U) <> 0 
                  AND lHasFieldLabel THEN
                      DYNAMIC-FUNCTION("setLabel":U IN phObject, INPUT ttTranslate.cTranslatedLabel).                                  
                  ELSE DO:
                    if can-query(ttTranslate.hWidgetHandle, 'Side-Label-Handle':u) then
                        hSideLabel = ttTranslate.hWidgetHandle:side-label-handle.
                    else
                        hSideLabel = ?.                        
                    
                    /* The AppBuilder doesn't allow  explicit adding of labels to selection lists */
                    if valid-handle(hSideLabel) then
                    do:
                        /* The colon to the static fill-ins are added by the 4GL, for
                           dynamics fill-ins we need to manually add the colon*/
                        IF hSideLabel:DYNAMIC THEN
                           ASSIGN ttTranslate.cTranslatedLabel = ttTranslate.cTranslatedLabel
                                                            + (IF INDEX(ttTranslate.cTranslatedLabel, ":":U) eq 0 THEN ":":U ELSE "":U).

                        IF CAN-SET(hSideLabel, "FORMAT":U) THEN
                            ASSIGN hSideLabel:FORMAT = "x(" + STRING(LENGTH(ttTranslate.cTranslatedLabel, "Column":U)) + ")":U.
                        
                        /* The length of the newly translated label, in pixels. 
                           We shold not assume that labels have the same fonts as the widget. This is
                           especially important for decimal or data combos, that we want to align
                           using a fixed font. */
                        dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttTranslate.cTranslatedLabel, hSideLabel:FONT)
                                        /* Prevent colon being hard up against the fill-in */
                                        + 3.
                        
                        /* KeepChldPositions is True */
                        IF lKeepChildPositions THEN
                        do:
                            /* Only show the label tooltip if the translated label is longer than the
		                       original. */
                            lShowLabelTooltip = (hSideLabel:X + dNewLabelLength gt ttTranslate.hWidgetHandle:X).
                            assign hSideLabel:SCREEN-VALUE = SUBSTRING(ttTranslate.cTranslatedLabel, 1, 
                                                                      INTEGER(hSideLabel:WIDTH-CHARS))
                                   hSideLabel:TOOLTIP      = ttTranslate.cTranslatedLabel when lShowLabelTooltip
                                   NO-ERROR.
                        end.    /* KCP = Yes */
                        ELSE
                        /* KeepChildPositions = No */
                        DO:
                            /** Position the label. We use pixels here since X and WIDTH-PIXELS
			                 *  are denominated in the same units, unlike COLUMN and WIDTH-CHARS.
			                 *----------------------------------------------------------------------- **/
                            IF dNewLabelLength > ttTranslate.hWidgetHandle:X THEN
                                ASSIGN dLabelWidth = ttTranslate.hWidgetHandle:X - 1
                                    lShowLabelTooltip = yes.
                            ELSE
                                ASSIGN dLabelWidth = dNewLabelLength
                                       lShowLabelTooltip = no.
            
                            IF dLabelWidth LE 0 THEN
                                ASSIGN dLabelWidth = 1.

                            ASSIGN hSideLabel:SCREEN-VALUE = ttTranslate.cTranslatedLabel NO-ERROR.
                            /* Make sure we leave enough room for the label and the colon. */
                            ASSIGN hSideLabel:X            = ttTranslate.hWidgetHandle:X - dLabelWidth - 3 NO-ERROR.
                            /* Ensure that label is large enough to take all the space from the
		                       left edge of the text to the widget. */
                            ASSIGN hSideLabel:WIDTH-PIXELS = dLabelWidth + 3 NO-ERROR.
                        END.    /* KCP = NO */                        
                    end.    /* valid side-label-handle */
                  END.    /* non-SDF */
              END.  /* label translation */
              ELSE DO:
                  ASSIGN iEntry         = (ttTranslate.iWidgetEntry * 2) - 1
                         cListItemPairs = ttTranslate.hWidgetHandle:LIST-ITEM-PAIRS
                         ENTRY(iEntry, cListItemPairs , ttTranslate.hWidgetHandle:DELIMITER) = ttTranslate.cTranslatedLabel.
                         ttTranslate.hWidgetHandle:LIST-ITEM-PAIRS = cListItemPairs NO-ERROR.
              END.  /* list-items */
          END.    /* translated label has a value */
          
          /* Only take the tooltip from the object itself, not any of the items. */
          IF ttTranslate.cTranslatedTooltip NE "":U AND ttTranslate.cTranslatedTooltip NE ? 
          AND ttTranslate.iWidgetEntry = 0 THEN 
          DO:
              IF CAN-QUERY(ttTranslate.hWidgetHandle,"FILE-NAME":U) THEN 
              DO: 
                  IF ttTranslate.cWidgetType = "COMBO-BOX":U THEN
                      DYNAMIC-FUNCTION("setFieldTooltip":U IN ttTranslate.hWidgetHandle, ttTranslate.cTranslatedTooltip).
              END.
              ELSE
                  ASSIGN ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.          
          END.    /* translate tooltip */

      END.  /* combo or selection list */
      WHEN "radio-set":U 
      THEN DO:
          /* the program that creates ttTranslate table refers to the entries as 
           * 1,2,3 as opposed to 1,3,5 (there is a label,value pair)
           * so we have to calculate the right position. Plus we need to
           * re-assign radio-buttons to new value when done (fixes bug iz 1440)
           */  
          ASSIGN cRadioButtons = ttTranslate.hWidgetHandle:RADIO-BUTTONS
                 iEntry = (ttTranslate.iWidgetEntry * 2) - 1.

          IF ttTranslate.cTranslatedLabel <> "":U THEN
              ASSIGN ENTRY(iEntry, cRadioButtons) = ttTranslate.cTranslatedLabel.

          IF ttTranslate.cTranslatedTooltip <> "":U THEN
              ASSIGN ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.

          IF NOT lKeepChildPositions THEN
          DO:
              /* Now resize the radio-set */
              IF NOT ttTranslate.hWidgetHandle:HORIZONTAL THEN 
              DO:
                  DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:
                    ASSIGN cRadioOption = ENTRY(iRadioLoop, cRadioButtons).
                    ASSIGN dOptionWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cRadioOption, ttTranslate.hWidgetHandle:FONT) + 3.8. /* to reserve space for the UI (sircle) */
                    ASSIGN dRadioSetWidth = MAX(dRadioSetWidth,dOptionWidth).
                  END.
              END.
              ELSE DO:
                  ASSIGN dRadioSetWidth = 0.
                  DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:
                    ASSIGN cRadioOption = ENTRY(iRadioLoop, cRadioButtons).
                    ASSIGN dOptionWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cRadioOption, ttTranslate.hWidgetHandle:FONT).
                    ASSIGN dRadioSetWidth = dRadioSetWidth + dOptionWidth + 3.8 /* to reserve space for the UI (sircle) */.
                  END.
              END.
              ASSIGN ttTranslate.hWidgetHandle:WIDTH-CHARS = IF ttTranslate.hWidgetHandle:WIDTH-CHARS < dRadioSetWidth
                                                             THEN dRadioSetWidth
                                                             ELSE ttTranslate.hWidgetHandle:WIDTH-CHARS NO-ERROR.
          END.
          ASSIGN ttTranslate.hWidgetHandle:RADIO-BUTTONS = cRadioButtons NO-ERROR.
      END.    /* radio-set */
      WHEN "text":U THEN 
      DO:
          IF CAN-SET(ttTranslate.hWidgetHandle, "PRIVATE-DATA":U) THEN
              ASSIGN ttTranslate.hWidgetHandle:PRIVATE-DATA = ttTranslate.cTranslatedLabel NO-ERROR.

          IF lKeepChildPositions THEN
          DO:
              IF CAN-SET(ttTranslate.hWidgetHandle, "SCREEN-VALUE":U) THEN
                  ASSIGN ttTranslate.hWidgetHandle:SCREEN-VALUE = SUBSTRING(ttTranslate.cTranslatedLabel, 1, 
                         INTEGER(ttTranslate.hWidgetHandle:WIDTH-CHARS)) NO-ERROR.
              IF CAN-SET(ttTranslate.hWidgetHandle, "TOOLTIP":U) THEN
                  ASSIGN ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedLabel NO-ERROR.
          END.
          ELSE DO:
              IF CAN-SET(ttTranslate.hWidgetHandle, "SCREEN-VALUE":U) THEN
                  ASSIGN ttTranslate.hWidgetHandle:SCREEN-VALUE = ttTranslate.cTranslatedLabel NO-ERROR.
              IF CAN-SET(ttTranslate.hWidgetHandle, "WIDTH":U) THEN
                  ASSIGN ttTranslate.hWidgetHandle:WIDTH = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ttTranslate.hWidgetHandle:SCREEN-VALUE, ttTranslate.hWidgetHandle:FONT) NO-ERROR.
          END.
          ASSIGN cTranslatedTextsAndValues = cTranslatedTextsAndValues
                                           + (IF cTranslatedTextsAndValues = "":U THEN "":U ELSE CHR(27))
                                           + STRING(ttTranslate.hWidgetHandle) + CHR(2) + ttTranslate.cTranslatedLabel.
      END.    /* text */
      OTHERWISE DO:
          /* Check for Dynamic Lookups and combos */
          IF ttTranslate.cTranslatedLabel <> "":U 
          AND CAN-QUERY(ttTranslate.hWidgetHandle,"FILE-NAME":U) 
          AND INDEX(ttTranslate.cObjectName, ":":U) <> 0 
          AND lHasFieldLabel THEN
            {set Label ttTranslate.cTranslatedLabel phObject}.
          ELSE 
          IF ttTranslate.cTranslatedLabel <> "":U 
          AND INDEX(ttTranslate.cObjectName, ":":U) <> 0 
          AND ttTranslate.cOriginalLabel = "nolabel":U THEN 
          DO:          
            ASSIGN ttTranslate.hWidgetHandle:SCREEN-VALUE = REPLACE(ttTranslate.cTranslatedLabel,":":U,"":U) + ":":U NO-ERROR.
            ASSIGN ttTranslate.hWidgetHandle:MODIFIED = NO NO-ERROR.
          END.
          ELSE IF ttTranslate.cTranslatedLabel <> "":U THEN
          DO:
            /* Cater for widgets like TOGGLE-BOXes which do not have a side label 
             * Buttons would also fall into this category.                        */
            IF CAN-QUERY(ttTranslate.hWidgetHandle, "SIDE-LABEL-HANDLE":U) THEN
                ASSIGN hSideLabel = ttTranslate.hWidgetHandle:SIDE-LABEL-HANDLE.
            ELSE
                ASSIGN hSideLabel = ?.

            /* We need to manually resize, move and change to format of labels for
             * objects on the viewer. */             
            IF VALID-HANDLE(hSideLabel)
            THEN DO:
                /*The colon to the static fill-ins are added by the 4GL, for
                  dynamics fill-ins we need to manually add the colon*/
                IF hSideLabel:DYNAMIC THEN
                   ASSIGN ttTranslate.cTranslatedLabel = ttTranslate.cTranslatedLabel
                                                    + (IF INDEX(ttTranslate.cTranslatedLabel, ":":U) eq 0 THEN ":":U ELSE "":U).
                
                IF CAN-SET(hSideLabel, "FORMAT":U) THEN
                    ASSIGN hSideLabel:FORMAT = "x(" + STRING(LENGTH(ttTranslate.cTranslatedLabel, "Column":U)) + ")":U.
                
                /* The length of the newly translated label, in pixels. 
                   We shold not assume that labels have the same fonts as the widget. This is
                   especially important for decimal or data combos, that we want to align
                   using a fixed font. */
                dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttTranslate.cTranslatedLabel, hSideLabel:FONT)
                                /* Prevent colon being hard up against the fill-in */
                                + 3.
                
                /* KeepChldPositions is True */
                IF lKeepChildPositions THEN
                do:
                    /* Only show the label tooltip if the translated label is longer than the
                       original. */
                    lShowLabelTooltip = (hSideLabel:X + dNewLabelLength gt ttTranslate.hWidgetHandle:X).
                    assign hSideLabel:SCREEN-VALUE = SUBSTRING(ttTranslate.cTranslatedLabel, 1, 
                                                              INTEGER(hSideLabel:WIDTH-CHARS))
                           hSideLabel:TOOLTIP      = ttTranslate.cTranslatedLabel when lShowLabelTooltip
                           NO-ERROR.
                end.    /* KCP = Yes */
                ELSE
                /* KeepChildPositions = No */
                DO:
                    /** Position the label. We use pixels here since X and WIDTH-PIXELS
	                 *  are denominated in the same units, unlike COLUMN and WIDTH-CHARS.
	                 *----------------------------------------------------------------------- **/
                    IF dNewLabelLength > ttTranslate.hWidgetHandle:X THEN
                        ASSIGN dLabelWidth = ttTranslate.hWidgetHandle:X - 1
                            lShowLabelTooltip = yes.
                    ELSE
                        ASSIGN dLabelWidth = dNewLabelLength
                               lShowLabelTooltip = no.
                    
                    ASSIGN dLabelWidth = MAX(dLabelWidth, 1)
                           hSideLabel:SCREEN-VALUE = ttTranslate.cTranslatedLabel
                           /* Make sure we leave enough room for the label and the colon. */ 
                           hSideLabel:X            = ttTranslate.hWidgetHandle:X - dLabelWidth - 3
                           /* Ensure that label is large enough to take all the space from the
                              left edge of the text to the widget. */
                           hSideLabel:WIDTH-PIXELS = dLabelWidth + 3.
                END.    /* KCP = NO */
            END.   /* valid side-label */
            ELSE
                ASSIGN ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel NO-ERROR.
          END.  /* there is a translation */
          
          IF ttTranslate.cTranslatedTooltip <> "":U THEN 
          DO:
              IF CAN-QUERY(ttTranslate.hWidgetHandle,"FILE-NAME":U) AND lHasFieldLabel THEN 
                  DYNAMIC-FUNCTION("setFieldTooltip":U IN ttTranslate.hWidgetHandle, ttTranslate.cTranslatedTooltip).
              ELSE DO:
                  IF VALID-HANDLE(ttTranslate.hWidgetHandle) 
                  AND CAN-SET(ttTranslate.hWidgetHandle,"TOOLTIP":U) THEN
                      ASSIGN ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip NO-ERROR.
              END.
          END.
      END.    /* other widget types */
    END CASE. /* widget type */
  END.    /* TRANSLATE-LOOP: each ttTranslate */

  /* We need to store translated FILL-IN VIEW-AS TEXTs and their translated   *
   * values in the viewer.  This is because the untranslated text is stored   *
   * in the INITIAL-VALUE of the fill-in, and displayed by the displayObjects *
   * API (in datavis.i).  This API overwrites our translations, but will then *
   * check this property and redisplay the translated label. */
  IF VALID-HANDLE(phObject) 
  AND cTranslatedTextsAndValues <> "":U THEN 
  DO:
      {fnarg setUserProperty "'TranslatedObjectHandlesAndValues':U, cTranslatedTextsAndValues" phObject} NO-ERROR.
      ASSIGN ERROR-STATUS:ERROR = NO.
  END.

    /* Reset frame visibility. */
    IF lFrameVisible THEN
        ASSIGN phFrame:HIDDEN = NO.                
/* *** EOF *** */