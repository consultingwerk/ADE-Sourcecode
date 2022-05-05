/* Copyright (C) 1984 - 2010 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */   
/*---------------------------------------------------------------------------------
         File: afseswiwlk.i  
  Description: Include file for widgetWalk() API in
  			   Dynamics Session Manager (af/app/afsesmngrp.i).
  Purpose:      

  Parameters:   
    DEFINE INPUT PARAMETER phContainer      AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER phObject         AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER phFrame          AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER pcAction         AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER plPopupsInFields AS LOGICAL   NO-UNDO.
  
    
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   2006-09-15  Author:    pjudge 

  Update Notes: Initial Implementation. Code moved here to avoid
   			    blowing up Section Editor limits.
---------------------------------------------------------------------------------*/  
DEFINE VARIABLE hRealContainer       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cContainerName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRunAttribute        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName          AS CHARACTER NO-UNDO.
DEFINE VARIABLE hWidgetGroup         AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDataSource          AS HANDLE    NO-UNDO.
DEFINE VARIABLE hWidget              AS HANDLE    NO-UNDO.
DEFINE VARIABLE hLookup              AS HANDLE    NO-UNDO.
DEFINE VARIABLE iLoop                AS INTEGER   NO-UNDO.
DEFINE VARIABLE iEntry               AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk                  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hLabel               AS HANDLE    NO-UNDO.
DEFINE VARIABLE hColumn              AS HANDLE    NO-UNDO.
DEFINE VARIABLE cFieldName           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSecurityFieldName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRadioButtons        AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRadioLoop           AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBrowseLoop          AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSecuredTokens       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSecuredFields       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cShowPopup           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHiddenFields        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cParentField         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAllFieldHandles     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAllFieldNames       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldSecurity       AS CHARACTER NO-UNDO.
DEFINE VARIABLE iFieldPos            AS INTEGER   NO-UNDO.
DEFINE VARIABLE cObjectType          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lObjectSecured       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lObjectTranslated    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cFieldPopupMapping   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimiter           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cListItems           AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCnt                 AS INTEGER   NO-UNDO.
DEFINE VARIABLE lHasFieldLabel       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lHasFieldName        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hField               AS HANDLE    NO-UNDO.
DEFINE VARIABLE hObjectFrame         AS HANDLE    NO-UNDO.
DEFINE VARIABLE lNoSmart             AS LOGICAL   NO-UNDO.
define variable cDataColumns         as character no-undo.
define variable cFullFieldName       as character no-undo.
define variable cDataSourceType      as character no-undo.
define variable cDataSourceNames     as character no-undo.

EMPTY TEMP-TABLE ttTranslate.

IF NOT VALID-HANDLE(phContainer) then 
  phContainer = phObject. 

IF NOT VALID-HANDLE(phContainer) 
OR NOT VALID-HANDLE(phObject) 
OR NOT VALID-HANDLE(phFrame) THEN 
  RETURN.

ASSIGN cObjectType       = DYNAMIC-FUNCTION("getObjectType":U IN phObject)
       lObjectTranslated = DYNAMIC-FUNCTION("getObjectTranslated":U IN phObject ) NO-ERROR.

IF lObjectTranslated EQ ? THEN ASSIGN lObjectTranslated = NO.

ASSIGN lObjectSecured = DYNAMIC-FUNCTION("getObjectSecured":U IN phObject ) NO-ERROR.
IF lObjectSecured EQ ? THEN ASSIGN lObjectSecured = NO.

/* If both object security and translation have been performed, then there is nothing
 * to do here. Both of these values are usually set at the same time, but there may be
 * cases where only one of these values is set. We need to cater for this.  */
IF lObjectTranslated EQ YES AND lObjectSecured EQ YES THEN
  RETURN.

/* Where should field calendar and calculator popups go?  Default is RIGHT */
IF plPopupsInFields = ? THEN
    ASSIGN plPopupsInFields = NO.

ASSIGN 
   hDataSource       = DYNAMIC-FUNCTION("getDataSource":U IN phObject)
   cAllFieldHandles  = DYNAMIC-FUNCTION("getAllFieldHandles":U IN phObject) 
   NO-ERROR.

if valid-handle(hDataSource) then
do:
    /* Do this once only */
    if {fnarg instanceOf 'DataView' hDataSource} then
        cDataSourceType = 'DataView':u.
    else
        {get ObjectType cDataSourceType hDataSource}.

    /* Get the data source names in case this is a viewer and
       the viewer has been built against an SDO (see comment later 
       in this procedure). */
    if cDataSourceType eq 'SmartBusinessObject':u then
        {get DataSourceNames cDataSourceNames phObject}.
        
    {get DataColumns cDataColumns hDataSource} no-error.
end.    /* valid data source*/
else
    cDataColumns = '':u.

/* FieldSecurity will be set for SmartDataBrowsers for browse columns only, not for objects on the 
   SmartDataBrowser's frame */
IF cAllFieldHandles <> "":U AND cObjectType NE "SmartDataBrowser":U THEN
   cFieldSecurity = FILL(",":U,NUM-ENTRIES(cAllFieldHandles) - 1).

IF phFrame:TYPE = "window":U THEN phFrame = phFrame:FIRST-CHILD.

/* FolderFrame is the name of the folder frame in afspfoldrw.w */
IF VALID-HANDLE(phFrame) AND phFrame:NAME <> "FolderFrame":U THEN 
DO:
  lHasFieldName = {fnarg InstanceOf 'Field' phObject}.

  IF pcAction = "setup":U THEN 
  DO:
    /* get real container name and run attribute (if sdf container is viewer !) */    
    IF lHasFieldName THEN
      hRealContainer = DYNAMIC-FUNCTION("getcontainersource":U IN phContainer) NO-ERROR.
    IF NOT VALID-HANDLE(hRealContainer) THEN 
      ASSIGN hRealContainer = phContainer.

    {get LogicalObjectName cContainerName hRealContainer} NO-ERROR.
     /* If still no Name (running from inside static container) then use FILE-NAME 
        and remove directories */
    IF cContainerName = "":U OR cContainerName = ? THEN
      ASSIGN 
        cContainerName = hRealContainer:FILE-NAME
        cContainerName = LC(TRIM(REPLACE(cContainerName,"~\":U,"/":U)))
        cContainerName = SUBSTRING(cContainerName,R-INDEX(cContainerName,"/":U) + 1).

    ASSIGN
      cRunAttribute = ''
      cRunAttribute = DYNAMIC-FUNCTION('getRunAttribute':U IN hRealContainer) NO-ERROR.  

    /* get object name to use */    
    IF lHasFieldName OR phFrame:NAME = "Panel-Frame":U THEN
    DO: /* for toolbars and SDF's - use container name for translations */
      {get LogicalObjectName cObjectName phContainer} NO-ERROR.
      
      /* If still no Name (running from inside static container) then use FILE-NAME 
         and remove directories */
      IF cObjectName = "":U OR cObjectName = ? THEN
        ASSIGN 
          cObjectName = phContainer:FILE-NAME
          cObjectName = LC(TRIM(REPLACE(cObjectName,"~\":U,"/":U)))
          cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1).

      IF lHasFieldName THEN
        cObjectName = cObjectName + ":":U + dynamic-function('getFieldName':u in phObject).
    END.
    ELSE
    DO: /* otherwise use object name for translations */      
      {get LogicalObjectName cObjectName phObject} NO-ERROR.
      /* If still no Name (running from inside static container) then use FILE-NAME 
         and remove directories */
      IF cObjectName = "":U OR cObjectName = ? THEN
        ASSIGN 
          cObjectName = phObject:FILE-NAME
          cObjectName = LC(TRIM(REPLACE(cObjectName,"~\":U,"/":U)))
          cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1).
    END.
  END.

  ASSIGN
    hwidgetGroup = phFrame:HANDLE
    hwidgetGroup = hwidgetGroup:FIRST-CHILD
    hWidget = hwidgetGroup:FIRST-CHILD.

  /* deal with lookups and smartselects not initialized yet */
  lHasFieldLabel = {fnarg InstanceOf 'LookupField' phObject}.
  if not lHasFieldLabel then
    lHasFieldLabel = {fnarg InstanceOf 'Select' phObject}.
    
  IF pcAction = "setup":U 
  AND INDEX(cObjectName, ":":U) <> 0 
  AND lObjectTranslated NE YES AND lHasFieldLabel THEN
  DO:
    CREATE ttTranslate.
    ASSIGN
      ttTranslate.dLanguageObj = 0
      ttTranslate.cObjectName = cObjectName
      ttTranslate.lGlobal = NO
      ttTranslate.lDelete = NO
      ttTranslate.cWidgetType = "fill-in":U
      ttTranslate.cWidgetName = "fiLookup":U
      ttTranslate.hWidgetHandle = phObject
      ttTranslate.iWidgetEntry = 0
      ttTranslate.cOriginalLabel = "nolabel":U
      ttTranslate.cTranslatedLabel = "":U
      ttTranslate.cOriginalTooltip = "nolabel":U
      ttTranslate.cTranslatedTooltip = "":U
      .
    /* For Dynamic Combos we should set the Widget Type and Name correctly */
    if {fnarg instanceOf 'DynCombo' phObject} then
      ASSIGN ttTranslate.cWidgetType = "COMBO-BOX":U
             ttTranslate.cWidgetName = "fiCombo":U.
  END.

  /* check field security and token security */
  ASSIGN cHiddenFields = "":U.
  IF pcAction = "setup":U AND lObjectSecured NE YES THEN 
  DO:
    IF cObjectName = ? OR cObjectName = "":U THEN 
      {get logicalObjectName cObjectName phObject}.
    RUN fieldAndTokenSecurityCheck IN gshSecurityManager 
                                        (INPUT cContainerName,
                                         INPUT cRunAttribute,
                                         INPUT YES, /* Check field security */
                                         INPUT YES, /* Check token security */
                                         OUTPUT cSecuredFields,
                                         OUTPUT cSecuredTokens).
    /* At this point, mark security as done. */
    {set ObjectSecured Yes phObject} no-error.                                         
  END.  
  
  cAllFieldNames =  DYNAMIC-FUNCTION("getAllFieldNames":U IN phObject).
    
    /* If this is a viewer, get the PopupFieldMapping property.
       If it is blank/empty, then no popups have yet been created;
       if not blank, then the popups need to be created here. There
       may be cases where widgetWalk() needs to perform security or
       translations and the popups have been created; and in these
       cases the popups shouldn't be created again.              
     */
    if {fnarg InstanceOf 'DynView' phObject} then
        {get FieldPopupMapping cFieldPopupMapping phObject}.
        
  /* obtain right list of fields for recursive non-smart frame 
    (visual.p calls this also for child frames for translation) */
  IF phFrame:TYPE = "FRAME" THEN 
  DO:
    {get ContainerHandle hObjectFrame phObject}.
    if valid-handle(hObjectFrame) and hObjectFrame:type = 'WINDOW':U then
       {get WindowFrameHandle hObjectFrame phObject} no-error. 
     
    IF phFrame NE hObjectFrame THEN 
    DO:
      ASSIGN
        hField = phFrame:FIRST-CHILD /* field group */
        hField = hField:FIRST-CHILD  /* first widget */
        lNoSmart         = TRUE  /* no pop ups..  */
        cAllFieldHandles = ""
        cAllFieldNames = "".          
      DO WHILE VALID-HANDLE(hField):
        ASSIGN
          cAllFieldHandles = cAllFieldHandles 
                           + (IF cAllFieldHandles = "" THEN "" ELSE ",") 
                           + IF hField = ? THEN "?" ELSE STRING(hField)
          cAllFieldNames   = cAllFieldNames 
                           + (IF cAllFieldNames = "" THEN "" ELSE ",")
                           + IF hField:NAME = ? THEN "?" ELSE hField:NAME
          hField = hField:NEXT-SIBLING.
      END.
    END.
  END.  /* if frame */
        
  widget-walk:
  DO WHILE VALID-HANDLE (hWidget):
    /* check if european format and if so and this is a decimal widget and the delimiter 
       is a comma, then set the delimiter to chr(3) because comma is a decimal separator 
       in european format */
    IF pcAction = "setup":U 
    AND LOOKUP(hWidget:TYPE,"selection-list,radio-set,combo-box":U) <> 0 
    AND CAN-QUERY(hWidget,"data-type":U) 
    AND hWidget:DATA-TYPE = "decimal":U 
    AND CAN-QUERY(hWidget,"delimiter":U) 
    AND hWidget:DELIMITER = ",":U 
    AND SESSION:NUMERIC-DECIMAL-POINT = ",":U THEN
      hWidget:DELIMITER = CHR(3).    

    /* Set secured fields for Dynamic Combos and Lookups */
    IF pcAction = "setup":U 
    AND lObjectSecured NE YES 
    AND hWidget:TYPE = "FRAME":U THEN
      cFieldSecurity = DYNAMIC-FUNCTION("setSecurityForDynObjects":U IN TARGET-PROCEDURE,hWidget,cSecuredFields,cAllFieldHandles,cFieldSecurity,phObject).
      
    /* use database help for tooltip if no tooltip set-up */
    IF pcAction = "setup":U AND CAN-QUERY(hWidget,"tooltip":U) THEN
      ASSIGN hWidget:TOOLTIP = (IF hWidget:TOOLTIP <> ? AND hWidget:TOOLTIP <> "":U 
                                THEN hWidget:TOOLTIP 
                                ELSE hWidget:HELP).

    /* Translation and security. */
    IF pcAction = "Setup":U 
    AND CAN-DO("text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U, hWidget:TYPE) THEN
    DO:
      ASSIGN
        iFieldPos = LOOKUP(STRING(hWidget),cAllFieldHandles)
        cFieldName = '':u
        cFieldName = ENTRY(iFieldPos,cAllFieldNames) 
        no-error.
      
      IF cFieldName = ? OR cFieldName = "":U THEN 
      DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.

      ASSIGN cSecurityFieldName = cFieldName.
      IF NUM-ENTRIES(cFieldName, " ":U) = 2 THEN
        ASSIGN cFieldName         = ENTRY(2, cFieldName, " ":U)
               cSecurityFieldName = cFieldName.
      ELSE DO:
        /* Remove a table qualifier if present. 
           Fields in an SBO will be qualified with an SDO name, but we 
           use the unqualified name for security purposes. */     
        IF NUM-ENTRIES(cFieldName, ".":U) = 2 THEN
           ASSIGN cSecurityFieldName = ENTRY(2, cFieldName, ".":U).
      END.

      /* check security */
      IF lObjectSecured  <> YES 
      AND hWidget:TYPE    = "button":U 
      AND cSecuredTokens <> "":U 
      AND LOOKUP(cFieldName,cSecuredTokens) <> 0 THEN
        ASSIGN hWidget:SENSITIVE               = FALSE
               iFieldPos                       = LOOKUP(STRING(hWidget),cAllFieldHandles)
               ENTRY(iFieldPos,cFieldSecurity) = "ReadOnly":U.

      IF lObjectSecured NE YES 
      AND NOT CAN-DO("button":U, hWidget:TYPE) 
      AND cSecuredFields <> "":U 
      AND LOOKUP(cSecurityFieldName,cSecuredFields) <> 0 THEN 
      DO:
        ASSIGN iEntry = LOOKUP(cSecurityFieldName,cSecuredFields). /* Look for field in list */
        IF NUM-ENTRIES(cSecuredFields) > iEntry THEN 
        DO:
          CASE ENTRY(iEntry + 1, cSecuredFields):
            WHEN "hidden":U THEN 
            DO:
              ASSIGN 
                hWidget:HIDDEN = TRUE
                cHiddenFields  = (IF cHiddenFields <> "":U 
                                  THEN cHiddenFields + ",":U + cFieldName 
                                  ELSE cFieldName).
              IF iFieldPos <> 0 THEN
                ENTRY(iFieldPos,cFieldSecurity) = "Hidden":U NO-ERROR.
            END.
            WHEN "Read Only":U THEN 
            DO:
              hWidget:SENSITIVE = FALSE.
              IF CAN-SET(hWidget,"READ-ONLY":U) THEN
                hWidget:READ-ONLY = TRUE.
              IF iFieldPos <> 0 THEN
                ENTRY(iFieldPos,cFieldSecurity) = "ReadOnly":U NO-ERROR.
            END.
          END CASE.
          ASSIGN hWidget:MODIFIED = FALSE.
        END.
      END. /* if lObjectSecured */

      /* Avoid duplicates */
      IF lObjectTranslated NE YES 
      AND CAN-FIND(FIRST ttTranslate
                   WHERE ttTranslate.dLanguageObj = 0
                     AND ttTranslate.cObjectName  = cObjectName
                     AND ttTranslate.cWidgetType  = hWidget:TYPE
                     AND ttTranslate.cWidgetName  = cFieldName) THEN 
      DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.

      IF lObjectTranslated NE YES THEN 
      DO:
        /* Process LIST-ITEM-PAIRs */
        IF CAN-DO("COMBO-BOX,SELECTION-LIST":U, hWidget:TYPE) 
        AND CAN-QUERY(hWidget, "LIST-ITEM-PAIRS":U) THEN 
        DO:
          ASSIGN 
            cListItems = hWidget:LIST-ITEM-PAIRS
            cDelimiter = hWidget:DELIMITER.

          IF cListItems NE ? AND NUM-ENTRIES(cListItems, cDelimiter) GE 2 THEN 
          DO iRadioLoop = 1 TO NUM-ENTRIES(cListItems, cDelimiter) BY 2:
            CREATE ttTranslate.
            ASSIGN ttTranslate.dLanguageObj        = 0
                   ttTranslate.cObjectName         = cObjectName
                   ttTranslate.lGlobal             = NO
                   ttTranslate.lDelete             = NO
                   ttTranslate.cWidgetType         = hWidget:TYPE
                   ttTranslate.cWidgetName         = cFieldName
                   ttTranslate.hWidgetHandle       = hWidget
                   ttTranslate.iWidgetEntry        = (iRadioLoop + 1) / 2
                   ttTranslate.cOriginalLabel      = ENTRY(iRadioLoop, cListItems, cDelimiter)
                   ttTranslate.cTranslatedLabel    = "":U
                   ttTranslate.cOriginalTooltip    = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
                   ttTranslate.cTranslatedTooltip  = "":U.                
          END.
        END. /* combo or selection and can-query(list-item-pairs) */

        IF hWidget:TYPE <> "RADIO-SET":U THEN 
        DO:
          CREATE ttTranslate.
          ASSIGN ttTranslate.dLanguageObj       = 0
                 ttTranslate.cObjectName        = cObjectName
                 ttTranslate.lGlobal            = NO
                 ttTranslate.lDelete            = NO
                 ttTranslate.cWidgetType        = hWidget:TYPE
                 ttTranslate.cWidgetName        = cFieldName
                 ttTranslate.hWidgetHandle      = hWidget
                 ttTranslate.iWidgetEntry       = 0
                 ttTranslate.cOriginalLabel     = (IF CAN-QUERY(hWidget,"LABEL":U) AND hWidget:LABEL <> ? THEN hWidget:LABEL ELSE "":U)
                 ttTranslate.cTranslatedLabel   = "":U
                 ttTranslate.cOriginalTooltip   = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
                 ttTranslate.cTranslatedTooltip = "":U.
            /* deal with SDF's where label is separate */
          IF INDEX(cObjectName, ":":U) <> 0 AND ttTranslate.cOriginalLabel = "":U THEN 
          DO:
            {get LabelHandle hLabel phObject} NO-ERROR.
            IF VALID-HANDLE(hLabel) 
            AND hLabel:SCREEN-VALUE <> ? 
            AND hLabel:SCREEN-VALUE <> "":U THEN
              ASSIGN ttTranslate.cOriginalLabel = "nolabel":U
                     ttTranslate.hWidgetHandle  = hLabel.
          END.
          
          /* Get entity translations.
             Entity translations are only valid for fields that have
             a data source. */
          if can-do('Combo-Box,Fill-In,Button,Editor,Toggle-Box,Selection-List', hWidget:type) and
               /* SDVs built on SDOs and SDVs built on SBOs and run against the SAME configuration
                  will have matching quialifiers. For example:
                  SDOs = AFN: "field1,field2,...,fieldn" and DC: "field1,field2,...,fieldn" 
                  SBOs = AFN: "sdo1.field1,sdo1.field2,...,
                                sdoN.fieldn,sdoN.field1,sdoN.field2,...,sdoN.fieldn" 
                        and DC: "sdo1.field1,sdo1.field2,...,
                                sdoN.fieldn,sdoN.field1,sdoN.field2,...,sdoN.fieldn" 
                  A simple CAN-DO will determine whether the field we're working with - taken
                  from AllFieldNames - is in the DataColumns list.
                  
                  However, we can also build a SDV against an SDO and run it against an SBO:
                  AFN: "sdo1.field1,sdo1.field2,...,
                  DC:  "sdo1.field1,sdo1.field2,...,
                        sdoN.fieldn,sdoN.field1,sdoN.field2,...,sdoN.fieldn"
                  In order to detemrine whether the current widget is in the data source,
                  the SDO name (the datasourcename) is added to the widget name.
                  
                  The 4gl short-cuts the logic in the OR statement, so typically, only
                  the first can-do() will be executed. */
             ( can-do(cDataColumns, cFieldName) or
               ( cDataSourceNames gt '':u and
                 can-do(cDataColumns, cDataSourceNames + '.':u + cFieldName) ) ) then
          do:
              /* The field name varies depending on the datasource type */
              if cDataSourceType eq 'DataView':u then
                  cFullFieldName = cFieldName.
              else
                  /* SDOs and SBOs both support columnDbColumn */
                  cFullFieldName = {fnarg columnDbColumn cFieldName hDataSource}.
              
              /* Calculated fields are in the DataColumns list, but aren't real DB fields. */
              if num-entries(cFullFieldName, '.':u) ge 2 then
              do:
                  create ttTranslate.
                  assign ttTranslate.dLanguageObj = 0
                         ttTranslate.lGlobal = no
                         ttTranslate.lDelete = no
                         ttTranslate.cWidgetType = 'DataField':u
                         ttTranslate.hWidgetHandle = hWidget
                         ttTranslate.iWidgetEntry = 1    /* labels only */
                         ttTranslate.cOriginalLabel = (if can-query(hWidget, 'Label':u) and hWidget:label ne ? then hWidget:label else '':u)
                         ttTranslate.cTranslatedLabel = '':u
                         ttTranslate.cOriginalTooltip = (if can-query(hWidget, 'Tooltip':u) and hWidget:tooltip ne ? then hWidget:label else '':u)
                         ttTranslate.cTranslatedTooltip = '':u
                         ttTranslate.cObjectName = entry(num-entries(cFullFieldName, '.':u) - 1, cFullFieldName, '.':u)
                         ttTranslate.cWidgetName = entry(num-entries(cFullFieldName, '.':u),     cFullFieldName, '.':u).
              end.    /* not a calc field */
          end. /* entity translation */
        END. /* not a radio-set */
        ELSE DO: /* It is a radio-set */          
          cRadioButtons = hWidget:RADIO-BUTTONS.
          radio-loop:
          DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:
            CREATE ttTranslate.
            ASSIGN ttTranslate.dLanguageObj       = 0
                   ttTranslate.cObjectName        = cObjectName
                   ttTranslate.lGlobal            = NO
                   ttTranslate.lDelete            = NO
                   ttTranslate.cWidgetType        = hWidget:TYPE
                   ttTranslate.cWidgetName        = cFieldName
                   ttTranslate.hWidgetHandle      = hWidget
                   ttTranslate.iWidgetEntry       = (iRadioLoop + 1) / 2
                   ttTranslate.cOriginalLabel     = ENTRY(iRadioLoop, cRadioButtons)
                   ttTranslate.cTranslatedLabel   = "":U
                   ttTranslate.cOriginalTooltip   = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
                   ttTranslate.cTranslatedTooltip = "":U.
          END. /* radio-loop */
        END. /* else (radio-set) */
      END. /* lObjectTranslated <> yes */

      IF lObjectSecured NE YES AND cObjectType = "SmartDataBrowser":U AND cFieldSecurity <> "":U THEN
        DYNAMIC-FUNCTION("setFieldSecurity":U IN phObject, cFieldSecurity) NO-ERROR.
    END. /* action = setup and can-do( */ 
    else
    /* Browser translations and security belong in a separate section, 
       because the column handles are not stored in the AllField*
       properties.
     */
    if pcAction eq 'Setup' and hWidget:type eq 'Browse' then
    do:
        if not lObjectSecured and cObjectType eq 'SmartDataBrowser' then
            cFieldSecurity = Fill(',', hWidget:Num-Columns - 1).
        
        hColumn = hWidget:FIRST-COLUMN.
        COLUMN-LOOP:
        do while valid-handle(hColumn):
            assign iBrowseLoop = iBrowseLoop + 1
                   cFieldName = IF hColumn:NAME > "":U THEN hColumn:NAME ELSE hColumn:LABEL.

            IF cObjectType NE 'SmartDataBrowser':U THEN
                ASSIGN cFieldName = (IF hColumn:TABLE > "":U THEN (hColumn:TABLE + ".":U) ELSE "":U)
                                  + cFieldName.
            
            /* We should always have a valid column name in the 
               fieldname variable, but if we don't then bug out.
             */
            if cFieldName eq ? or cFieldName eq '' then
            do:
                hColumn = hColumn:Next-Column.
                next COLUMN-LOOP.
            end.    /* field name invalid */
            
            /* First attempt the translations */
            if not lObjectTranslated then
            do:
                /* Don't try to translate the same column more than once. */
                if can-find(first ttTranslate where
                                  ttTranslate.dLanguageObj = 0 and
                                  ttTranslate.cObjectName = cObjectName and
                                  ttTranslate.cWidgetType = hWidget:Type and /* always Browser here */
                                  ttTranslate.cWidgetName = cFieldName ) then
                do:
                    hColumn = hColumn:Next-Column.
                    next COLUMN-LOOP.
                end.    /* duplicate found */
                
                create ttTranslate.
                assign ttTranslate.dLanguageObj       = 0
                       ttTranslate.cObjectName        = cObjectName
                       ttTranslate.lGlobal            = NO
                       ttTranslate.lDelete            = NO
                       ttTranslate.cWidgetType        = hWidget:TYPE
                       ttTranslate.cWidgetName        = cFieldName
                       ttTranslate.hWidgetHandle      = hColumn
                       ttTranslate.iWidgetEntry       = 0
                       ttTranslate.cOriginalLabel     = hColumn:Label
                       ttTranslate.cTranslatedLabel   = ''
                       ttTranslate.cOriginalTooltip   = ''    /* Browse columns don't have tooltips */
                       ttTranslate.cTranslatedTooltip = ''.
            end.    /* columns not yet translated */
            
            /* Now do the security. */
            if not lObjectSecured and cObjectType eq 'SmartDataBrowser' then
            do:
                iEntry = lookup(cFieldName, cSecuredFields).
                if iEntry gt 0 and num-entries(cSecuredFields) gt iEntry then
                do:
                    entry(iBrowseLoop, cFieldSecurity) = entry(iEntry + 1, cSecuredFields).
                    case entry(iBrowseLoop, cFieldSecurity):
                        when 'Hidden' then hColumn:Visible = no.
                        when 'Read Only' then hColumn:Column-Read-Only = yes no-error.
                    end case.    /* type of security */
                end.    /* the field is secured */
            end.    /* object not yet secured */
            
            hColumn = hColumn:Next-Column.
        end.    /* COLUMN-LOOP: */
            
        /* Now tell the browser which fields (columns in this case) are secured. */
        if not lObjectSecured and
           cObjectType eq 'SmartDataBrowser' and
           cFieldSecurity ne '' then
            {set FieldSecurity cFieldSecurity phObject} no-error.
    end.    /* Setup for the browser. */
    
    /*-----------------------------------*
     * Put popup on fields if applicable *
     *-----------------------------------*/

    /* Only Date, Decimal, Integer or INT64 Fill-ins will ever have popups.
       (we don't add  pop-ups to static no smart frames) */
    IF  pcAction = "setup":U
    AND LOOKUP(hWidget:TYPE, "FILL-IN":U) NE 0 
    AND CAN-QUERY(hWidget, "DATA-TYPE":U) 
    AND LOOKUP(hWidget:DATA-TYPE, "DATE,DECIMAL,INTEGER,INT64":U) NE 0 
    AND lNoSmart = FALSE THEN 
    DO:
      /* Check whether the ShowPopup property has been explicitly set.
         If so, use this value. If not, act according to the defaults. */

      cShowPopup = "":U.
      IF  CAN-QUERY(hWidget, "PRIVATE-DATA":U)             
      AND LOOKUP("ShowPopup":U, hWidget:PRIVATE-DATA) GT 0 THEN
        ASSIGN cShowPopup = ENTRY(LOOKUP("ShowPopup":U, hWidget:PRIVATE-DATA) + 1, hWidget:PRIVATE-DATA).
      
      /* Get the name of the field for which popup is to be created only if 
         there are hidden fields here */
      IF cHiddenFields <> "":U THEN 
      DO:
        cParentField = (IF CAN-QUERY(hWidget, "TABLE":U) AND LENGTH(hWidget:TABLE) > 0 AND hWidget:TABLE <> "RowObject":U 
                        THEN (hWidget:TABLE + ".":U) 
                        ELSE "":U) 
                      + hWidget:NAME.

         IF  cParentField <> "":U AND cParentField <> ? 
         AND LOOKUP(cParentField,cHiddenFields) <> 0 THEN /* Don't create popup for hidden fields */
           ASSIGN cShowPopup = "NO".
           
            /* The popup may already have been created by a generated viewer in 
               certain circumstances; if the current field has been hidden by security,
               then the popup needs to be destroyed.
             */
            iEntry = lookup(string(hWidget), cFieldPopupMapping) no-error.
            if can-do(cHiddenFields, cFieldName) and iEntry gt 0 then
            do:
                hLookup = widget-handle(entry(iEntry + 1, cFieldPopupMapping)) no-error.
                /* If there is a popup, destroy it and remove it from the list. */
                if valid-handle(hLookup) then
                do:                    
                    delete object hLookup no-error.
                    hLookup = ?.
                    entry(iEntry + 1, cFieldPopupMapping) = '?'.
                end.    /* there is a popup for the secured field */
                                        
                /* No need to go further. */
                cShowPopup = 'No'.
            end.    /* popup already created for secured field */
      END.    /* there are hidden fields */


      /* Only check for ShowPopups = NO. If it is YES, create the popup. */
      IF cShowPopup EQ "NO":U THEN 
      DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.    /* ShowPopup is NO */
      ELSE
      IF cShowPopup NE "YES":U THEN 
      DO:
        /* By default there is no popup for integer widgets. */
        IF CAN-QUERY(hWidget, "DATA-TYPE":U) 
        AND (hWidget:DATA-TYPE EQ "INTEGER":U OR hWidget:DATA-TYPE EQ "INT64":U)THEN 
        DO:
          ASSIGN hWidget = hWidget:NEXT-SIBLING.
          NEXT widget-walk.
        END.    /* integer default. */

        /* Kept for backwards compatability. */
        IF (phFrame:PRIVATE-DATA NE ? AND INDEX(phFrame:PRIVATE-DATA, "NoLookups":U) NE 0) 
        OR (hWidget:PRIVATE-DATA NE ? AND INDEX(hWidget:PRIVATE-DATA, "NoLookups":U) NE 0) THEN
        DO:
          ASSIGN hWidget = hWidget:NEXT-SIBLING.
          NEXT widget-walk.
        END.    /* NOLOOKUPS set in private data */
      END.    /* default */
      
      /* If the popup has already been created, then there is no need to
         create it again. Move on.
       */
      if can-do(cFieldPopupMapping, string(hWidget)) then
      do:
          hWidget = hWidget:next-sibling.
          next.
      end.    /* popup exists */

      /* create a lookup button for pop-up calendar or calculator */
      CREATE BUTTON hLookup
        ASSIGN FRAME         = phFrame
               NO-FOCUS      = TRUE
               WIDTH-PIXELS  = 15
               LABEL         = "...":U
               PRIVATE-DATA  = "POPUP":U 
               HIDDEN        = hWidget:Hidden
        /* this is currently called AFTER enableObjects, so ensure the popup has 
           the right state */      
               SENSITIVE     = hWidget:SENSITIVE 
                               AND CAN-SET(hWidget,'READ-ONLY':U) 
                               AND NOT hWidget:READ-ONLY
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN runLookup IN TARGET-PROCEDURE(INPUT hWidget).
            END TRIGGERS.
        /* The lookup widget should be placed outside of the fill-in.  If the frame width is exceeded, widen it. */
        IF plPopupsInFields = NO THEN 
        DO:
          ASSIGN hLookup:HEIGHT-PIXELS = hWidget:HEIGHT-PIXELS - 4
                 hLookup:Y             = hWidget:Y + 2.

          IF hWidget:COLUMN + hWidget:WIDTH-CHARS + hLookup:WIDTH-CHARS > phFrame:WIDTH THEN 
            /* We're going to widen the frame to make space for the button. */
            RUN increaseFrameforPopup IN TARGET-PROCEDURE (phObject,
                                                           phFrame,
                                                           hLookup,
                                                           hWidget).
          ELSE
            ASSIGN hLookup:X = hWidget:X + hWidget:WIDTH-PIXELS - 3.

          ASSIGN hWidget:WIDTH-PIXELS = hWidget:WIDTH-PIXELS + 14.
        END.
        ELSE
          ASSIGN hLookup:HEIGHT-PIXELS = hWidget:HEIGHT-PIXELS - 4
                 hLookup:Y             = hWidget:Y + 2
                 hWidget:WIDTH-PIXELS  = hWidget:WIDTH-PIXELS
                 hLookup:X             = (hWidget:X + hWidget:WIDTH-PIXELS) - 17.

        hLookup:MOVE-TO-TOP().
        IF VALID-HANDLE(hLookup) THEN
          cFieldPopupMapping = cFieldPopupMapping
                             + (IF cFieldPopupMapping = "":U THEN "":U ELSE ",":U)
                             + STRING(hWidget)
                             + ",":U
                             + STRING(hLookup).
        /* Add F4 trigger to widget */
        ON F4 OF hWidget PERSISTENT RUN runLookup IN TARGET-PROCEDURE (hWidget).
    END. /* setup of lookups */
    ASSIGN hWidget = hWidget:NEXT-SIBLING.
  END. /* widget-walk */
  /* Store the mapping of fields and popup handles */
  IF cFieldPopupMapping > '':U THEN
    DYNAMIC-FUNCTION('setFieldPopupMapping':U IN phObject,cFieldPopupMapping) NO-ERROR.   

END.  /* valid-handle(phframe) */

/* translate widgets */
IF lObjectTranslated NE YES AND pcAction = "setup":U AND CAN-FIND(FIRST ttTranslate) THEN
  RUN translateWidgets (INPUT phobject, INPUT phFrame, INPUT TABLE ttTranslate).

/* At this point, mark translations as done. Even if there were no 
   translations done, we performed the action of translation discovery,
   and that means we don't have to do it again. */
{set ObjectTranslated true phObject}.

  /* Now we need to set the Secured fields for objects that are not SmartDataBrowsers.  
   SmartDataBrowsers support field security for its browse columns only.  */
IF lObjectSecured NE YES AND cFieldSecurity <> "":U AND cObjectType NE "SmartDataBrowser":U THEN
  DYNAMIC-FUNCTION("setFieldSecurity":U IN phObject, cFieldSecurity) NO-ERROR.

/* *** EOF *** */
