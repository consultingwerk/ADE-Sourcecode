&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
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
/* Copyright (C) 2007 by Progress Software Corporation. All rights    
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: ryclspropbsupr.p

  Description:  Class Properties Browser Super

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/22/2004  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryclspropbsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* contains preprocessors converting data type integer values into chars. */
{af/app/afdatatypi.i}

/* ttLocalContext stores local/temporary properties 
   that are not in the repository, particularly things
   like the handles of widgets created on-the-fly.
 */
DEFINE temp-table ttLocalContext        no-undo
    field TargetProcedure    as handle
    field ContextName        as character
    field ContextValue       as character
    index idxName    as primary unique
        TargetProcedure
        ContextName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-adjustAttributeLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD adjustAttributeLinks Procedure 
FUNCTION adjustAttributeLinks RETURNS LOGICAL PRIVATE
    ( INPUT pcAction    AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildOverlayWidgets Procedure 
FUNCTION buildOverlayWidgets RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyOverlayWidgets Procedure 
FUNCTION destroyOverlayWidgets RETURNS LOGICAL PRIVATE
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableLabelColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableLabelColumn Procedure 
FUNCTION disableLabelColumn RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableLabelColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableLabelColumn Procedure 
FUNCTION enableLabelColumn RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeLookup Procedure 
FUNCTION getAttributeLookup RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeSdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeSdo Procedure 
FUNCTION getAttributeSdo RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDialogButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDialogButton Procedure 
FUNCTION getDialogButton RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDropDownIndicator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDropDownIndicator Procedure 
FUNCTION getDropDownIndicator RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLookupList Procedure 
FUNCTION getLookupList RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTextEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTextEditor Procedure 
FUNCTION getTextEditor RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hideOverlayWidgets Procedure 
FUNCTION hideOverlayWidgets RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttributeLookup Procedure 
FUNCTION setAttributeLookup RETURNS LOGICAL PRIVATE
  ( INPUT phAttributeLookup AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDialogButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDialogButton Procedure 
FUNCTION setDialogButton RETURNS LOGICAL PRIVATE
  ( INPUT phDialogButton AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDropDownIndicator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDropDownIndicator Procedure 
FUNCTION setDropDownIndicator RETURNS LOGICAL PRIVATE
  ( INPUT phDropDownIndicator AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLookupList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLookupList Procedure 
FUNCTION setLookupList RETURNS LOGICAL PRIVATE
  ( INPUT phLookupList AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTextEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTextEditor Procedure 
FUNCTION setTextEditor RETURNS LOGICAL PRIVATE
  ( INPUT phTextEditor AS HANDLE)  FORWARD.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hLookup            as handle                        no-undo.
        
    {fn enableLabelColumn}.
    
    run super.
    
    run overlayWidget in target-procedure.
    
    return.
END PROCEDURE.    /* addRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run super.
    
    {fn disableLabelColumn}.
    {fn hideOverlayWidgets}.
    
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeColumnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeColumnValue Procedure 
PROCEDURE changeColumnValue :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PROTECTED
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hSdo             as handle                        no-undo.
    DEFINE variable hColumn          as handle                        no-undo.
    DEFINE variable hOverlayWidget   as handle                        no-undo.
    DEFINE variable hFrame           as handle                        no-undo.
    DEFINE variable hBrowse          as handle                        no-undo.
    DEFINE variable cAttributeList   as character                     no-undo.
    DEFINE variable cDataTargets     as character                     no-undo.
    DEFINE variable iLoop            as integer                       no-undo.
    DEFINE variable lRowAvailable    as logical                       no-undo.
    
    {get AttributeSdo hSdo}.
    {get ContainerHandle hFrame}.
    {get BrowseHandle hBrowse}.
    hColumn = {fnarg widgetHandle 'tAttributeLabel'}.
        
    /* if we try to do thi for blanks, we'll get everything. */
    if hColumn:SCREEN-VALUE eq '' or hColumn:SCREEN-VALUE eq ? then
        return.
    
    /* build the sdo query to find the relevant objects */
    {set QueryWhere '' hSdo}.
    if index(hColumn:screen-value, '*') eq 0 then 
        dynamic-function('assignQuerySelection':U IN hSdo,
                         'attribute_label':U, hColumn:SCREEN-VALUE,'Begins':U).   
    else
        dynamic-function('assignQuerySelection':U IN hSdo,
                         'attribute_label':U, hColumn:SCREEN-VALUE,'Matches':U).
    {fn openQuery hSdo}.
    
    /* get all matching attributes 
       and put them into the lookup list 
     */
    run fetchFirst in hSdo.
    lRowAvailable = {fnarg rowAvailable 'Current' hSdo}.
    
    /* allow a new attribute to be added */        
    do while lRowAvailable:
        cAttributeList = cAttributeList + chr(3)
                       + {fnarg columnValue 'attribute_label' hSdo}.
        
        lRowAvailable = {fnarg rowAvailable 'Next' hSdo}.
        if lRowAvailable then
            run fetchNext in hSdo.
    end.    /* row available true. */
    cAttributeList = left-trim(cAttributeList, chr(3)).
    
    {set QueryWhere '' hSdo}.
    if index(hColumn:screen-value, '*') eq 0 then 
        dynamic-function('removeQuerySelection':U IN hSdo,
                         'attribute_label':U, 'Begins':U).
    else
        dynamic-function('removeQuerySelection':U IN hSdo,
                         'attribute_label':U, 'Matches':U).
    
    {get AttributeLookup hOverlayWidget}.
    if valid-handle(hOverlayWidget) then
    do:
        assign hOverlayWidget:HEIGHT = MAX(1,MIN(6,INT(NUM-ENTRIES(cAttributeList,CHR(3)) / 2 ) ))
               hOverlayWidget:WIDTH-Pixels = hColumn:WIDTH-Pixels + 6
               hOverlayWidget:Y = (IF hColumn:Y + hBrowse:Y + hColumn:HEIGHT-PIXELS + hOverlayWidget:HEIGHT-Pixels lt hFrame:HEIGHT-Pixels 
                                  THEN hColumn:Y + hBrowse:Y + hColumn:HEIGHT-PIXELS 
                                  ELSE hColumn:Y + hBrowse:Y - hOverlayWidget:HEIGHT-Pixels)
               hOverlayWidget:X = hColumn:X + hBrowse:X - 2
               no-error.
        hOverlayWidget:MOVE-TO-TOP().
        
        assign hOverlayWidget:DELIMITER = CHR(3)
               hOverlayWidget:LIST-ITEMS = cAttributeList.
        
        assign hOverlayWidget:hidden = no
               hOverlayWidget:SCREEN-VALUE = hColumn:SCREEN-VALUE
               no-error.
    end.    /* lookup value has value */
    
    return.
END PROCEDURE.    /* changeColumnValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeSelectedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeSelectedValue Procedure 
PROCEDURE changeSelectedValue :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE variable hValueColumn             as handle                 no-undo.    
    DEFINE VARIABLE cOriginalValue           AS CHARACTER              NO-UNDO.
    
    /* Since the selection list is emulating a combo-box, only apply change when the
     * user either clicks on an item on presses enter. Not when using cursor.
     */
    assign hValueColumn = {fnarg widgetHandle 'tAttributeValue'}
           cOriginalValue = hValueColumn:SCREEN-VALUE
           hValueColumn:SCREEN-VALUE = SELF:SCREEN-VALUE
           SELF:hidden = yes
           NO-ERROR.
    
    /* apply the changes */
    if cOriginalValue ne hValueColumn:SCREEN-VALUE then
    do:
        {set DataModified yes}.
        run rowLeave in target-procedure.
    end.    /* change value */
    
    return.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseDropDownButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseDropDownButton Procedure 
PROCEDURE chooseDropDownButton :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Event procedure when the drop-down button is pressed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE input parameter phSelectedWidget    as handle             no-undo.
    
    DEFINE variable hDataSource            as handle                 no-undo.
    DEFINE variable hLookupList            as handle                 no-undo.
    DEFINE variable hTextEditor            as handle                 no-undo.
    DEFINE VARIABLE hOverlayWidget         AS HANDLE                 NO-UNDO.
    DEFINE variable hBrowse                as handle                 no-undo.
    DEFINE variable hFrame                 as handle                 no-undo.
    DEFINE variable hValueColumn           as handle                 no-undo.
    DEFINE variable cLookupType            as character              no-undo.
    DEFINE variable cLookupValue           as character              no-undo.
    DEFINE variable iDataType              as integer                no-undo.
    
    {get DataSource hDataSource}.        
    {get ContainerHandle hFrame}.
    {get BrowseHandle hBrowse}.
    
    cLookupType = {fnarg columnValue 'tLookupType' hDataSource}.
    
    /* A blank lookup type means that the button was provided because
       of the data type. In these cases this code will provide default 
       behaviour and will not be taken from the db.
     */
    case cLookupType:
        when '' then
        do:
            iDataType = {fnarg columnValue 'tDataType' hDataSource}.
            case iDataType:
                when {&LOGICAL-DATA-TYPE} then
                do:
                    {get LookupList hLookupList}.
                    cLookupValue = 'Yes' + chr(3) + 'YES' + chr(3) + 'No' + chr(3) + 'NO' + chr(3) + 'Null' + chr(3) + '?'.
                end.    /* logical */
                when {&CHARACTER-DATA-TYPE} then
                do:
                    {get TextEditor hTextEditor}.                                        
                    cLookupValue = ''.
                end.    /* char */
            end case.    /* data type */
        end.    /* blank lookup type */
        otherwise
        do:
            {get LookupList hLookupList}.
            IF cLookupType eq "PROC":U THEN 
            DO:
                RUN VALUE(cLookupValue) NO-ERROR.
                ASSIGN cLookupValue = RETURN-VALUE.
            END.    /* proc */
            else
                cLookupValue = {fnarg columnValue 'tLookupValue' hDataSource}.                
        end.    /* not blank lookup type */            
    end case.    /* lookup type */
    
    if valid-handle(hLookupList) then
        hOverlayWidget = hLookupList.
    else
        hOverlayWidget = hTextEditor.
    
    if valid-handle(hOverlayWidget) then
    do:        
        /* If selection button is selected, display the selection list if not visible */
        if not hOverlayWidget:hidden then
            hOverlayWidget:hidden = yes.
        else
        do:                 
            hValueColumn = {fnarg widgetHandle 'tAttributeValue'}.
            
            if valid-handle(hLookupList) then
                hOverlayWidget:HEIGHT = MAX(1,MIN(6,INT(NUM-ENTRIES(cLookupValue,CHR(3)) / 2 ) )).
            else
                hOverlayWidget:HEIGHT = 3.
            
            assign hOverlayWidget:WIDTH-Pixels = hValueColumn:WIDTH-Pixels + 6
                   hOverlayWidget:Y = (IF hValueColumn:Y + hBrowse:Y + hValueColumn:HEIGHT-PIXELS + hOverlayWidget:HEIGHT-Pixels lt hFrame:HEIGHT-Pixels 
                                      THEN hValueColumn:Y + hBrowse:Y + hValueColumn:HEIGHT-PIXELS 
                                      ELSE hValueColumn:Y + hBrowse:Y - hOverlayWidget:HEIGHT-Pixels)
                   hOverlayWidget:X = hValueColumn:X + hBrowse:X - 2
                   no-error.
            hOverlayWidget:MOVE-TO-TOP().
            
            if valid-handle(hLookupList) then
                assign hOverlayWidget:DELIMITER = CHR(3)
                       hOverlayWidget:LIST-ITEM-PAIRS = cLookupValue.
            
            assign hOverlayWidget:SCREEN-VALUE = hValueColumn:SCREEN-VALUE
                   hOverlayWidget:hidden = no.
        
            apply "ENTRY":U TO hOverlayWidget.
        end.    /* not visible */
    end.    /* lookup value has value */
    
    return.
END PROCEDURE.    /* chosseDropDownButton */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hLookup            as handle                     no-undo.

    {fn enableLabelColumn}.
    
    run super.
    
    run overlayWidget in target-procedure.
        
    return.
END PROCEDURE.    /* copyRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input parameter pcRelative        as character                no-undo.
    
    DEFINE variable hSdo                     as handle                    no-undo.
    DEFINE variable cAttributeLabel          as character                 no-undo.
    DEFINE variable cMode                    as character                 no-undo.

    run super (pcRelative).
    
    {get ObjectMode cMode}.
    if cMode ne 'View' then
        run overlayWidget in target-procedure.
    else
        {fn hideOverlayWidgets}.
    
    /* force the child (attribute) data object to
       repository correctly. the child data doesn't 
       update correctly because there are no foreign fields
       available - this is because the child sdo (attribute) is
       re-used by the attribute lookup in addition to 
       being used as a data provider to its visual objects.
     */
    cAttributeLabel = {fnarg widgetValue 'tAttributeLabel'}.
    
    {get AttributeSdo hSdo}.
    if valid-handle(hSdo) then
        dynamic-function('findRowWhere' in hSdo, 'attribute_label', cAttributeLabel, '=').
    
    return.
END PROCEDURE.    /* dataAvailable */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Procedure 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hContainer            as handle                    no-undo.
    DEFINE variable hToolbar              as handle                    no-undo.
    DEFINE variable hDataSource           as handle                    no-undo.
    DEFINE variable hClassDataSource      as handle                    no-undo.
    DEFINE variable cButtonPressed        as character                 no-undo.
    DEFINE variable cValidClasses         as character                 no-undo.
    DEFINE variable cWhereStored          as character                 no-undo.
    
    &scoped-define xp-assign
    {get ContainerSource hContainer}
    {get TableioSource hToolbar}
    {get DataSource hDataSource}.
    &undefine xp-assign
    
    /* if the where stored is not the current class and 
       not the custom class then disallow deleted.       
     */         
    publish "findCustomizingClass" from hContainer (output cValidClasses).     
        
    assign cValidClasses = cValidClasses + ',' + {fnarg columnValue 'tClassName' hDataSource}
           cValidClasses = left-trim(cValidClasses, ',')
           cWhereStored = {fnarg columnValue 'tWhereStored' hDataSource}.
    
    if not can-do(cValidClasses, cWhereStored) then
            RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'af' '40' '?' '?'
                                                          "'Only attributes stored at one of these classes:' + cValidClasses + ' can be deleted.'" },
                                                   INPUT  "ERR",          /* error type */
                                                   INPUT  "&OK",    /* button list */
                                                   INPUT  "&OK",           /* default button */ 
                                                   INPUT  "&OK",       /* cancel button */
                                                   INPUT  "Delete disallowed", /* error window title */
                                                   INPUT  YES, /* display if empty */ 
                                                   INPUT  hContainer,
                                                   OUTPUT cButtonPressed       ).
    else
    do:
        run super.
        
        if return-value ne 'adm-error' then
        do:
            /* Clear the client cache */
            run destroyClassCache in gshRepositoryManager.
            
            {get DataSource hClassDataSource hDataSource}.
                /* force the class data (and thus child data) to refresh. */
            run refreshRow in hClassDataSource.            
        end.    /* no delete errors */
    end.    /*delete the record */

    
    return.
END PROCEDURE.    /* deleteRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hAttributeLookup         as handle                    no-undo.
    
    run super.
    
    {fn destroyOverlayWidgets}.
    
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dialogLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dialogLookup Procedure 
PROCEDURE dialogLookup :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:    Called upon selecting the dialog button from within
              a value field. 
  Parameters:  <none>
  Notes:       All procedures called must have the same signature,
                 Input-output character
                 Output       logical
------------------------------------------------------------------------------*/
    DEFINE variable hDataSource            as handle                   no-undo.
    DEFINE variable hValueColumn           as handle                   no-undo.
    DEFINE variable cLookupType            as character                no-undo.
    DEFINE variable cLookupValue           as character                no-undo.    
    DEFINE variable cScreenValue           as character                no-undo.
    DEFINE variable cOriginalValue         as character                no-undo.
    DEFINE variable lOk                    as logical                  no-undo.
    {get DataSource hDataSource}.
    cLookupValue = {fnarg columnValue 'tLookupValue' hDataSource}.
    cLookupType = {fnarg columnValue 'tLookupType' hDataSource}.
    hValueColumn = {fnarg widgetHandle 'tAttributeValue'}.
    
    IF R-INDEX(cLookupValue,".p":U) > 0 OR R-INDEX(cLookupValue,".w":U) > 0 THEN
    DO:
        IF SEARCH(cLookupValue)                          NE ? OR
           SEARCH(REPLACE(cLookupValue, ".p":U, ".r":U)) NE ? THEN
        DO:
            /* Read-only dialogs take their 'base' values from the value in
               database/temp-table: there is no user interaction allowed
               except via the dialog.
             */
            if cLookupType eq 'Dialog-R' then
                cScreenValue = {fnarg widgetValue 'tAttributeValue'}.
            ELSE
                cScreenValue = hValueColumn:SCREEN-VALUE.
            
            RUN VALUE(cLookupValue) (INPUT-OUTPUT cScreenValue, OUTPUT lOK) NO-ERROR.
            IF lOK THEN 
            DO:
                            assign cOriginalValue = hValueColumn:SCREEN-VALUE
                                   hValueColumn:SCREEN-VALUE = cScreenValue
                                   NO-ERROR.
                            
                            /* apply the changes */
                            if cOriginalValue ne hValueColumn:SCREEN-VALUE then
                            do:
                    {set DataModified yes}.
                    run rowLeave in target-procedure.
                            end.    /* change value */
            END.    /* dialog returned ok */
        END.    /* found procedure to run */
    END.    /* there is a valid value. */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* dialogLookup */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {fn hideOVerlayWidgets}.
    
    run super.
    return.
END PROCEDURE.    /* hideObejct */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE variable hColumn            as handle                       no-undo.
        
    run super.
    
    /* Wait til the super has run before building widgets
        because otherwise the widget handles will be added
        to the AllFieldNames/~Handles lists and be disabled
        automatically. Currently we want to manage this stuff 
        ourselves.
     */
    {fn buildOverlayWidgets}.
        
    /* these triggers will only fire when the 
       attribute label column is enabled, i.e.
       on add or copy.
     */
    hColumn = {fnarg widgetHandle 'tAttributeLabel'}.
    on value-changed of hColumn persistent run changeColumnValue in target-procedure.
    on leave of hColumn persistent run selectAttribute in target-procedure.
    
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-overlayWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE overlayWidget Procedure 
PROCEDURE overlayWidget :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hFrame               as handle                    no-undo.
    DEFINE variable hBrowse              as handle                    no-undo.
    DEFINE variable hCol                 as handle                    no-undo.
    DEFINE variable hOverlayWidget       as handle                    no-undo.
    DEFINE variable hValueColumn         as handle                    no-undo.
    DEFINE variable hDataSource          as handle                    no-undo.
    DEFINE VARIABLE cLookupType          AS CHARACTER                 NO-UNDO.
    DEFINE variable iDataType            as integer                   no-undo.
    
    {get DataSource hDataSource}.
    
    /* Hide all overlay widgets */
    {fn hideOverlayWidgets}.
    
    /* find overlay for this row */
    cLookupType = {fnarg columnValue 'tLookupType' hDataSource}.
    iDataType = {fnarg columnValue 'tDataType' hDataSource}.
    
    case cLookupType:
        when 'List' or when 'Proc' then
            {get DropDownIndicator hOverlayWidget}.
        when "DIALOG":U OR when "DIALOG-R":U then
            {get DialogButton hOverlayWidget}.
        otherwise
        /* Get some defaults per data type.
         */
        case iDataType:
            when {&LOGICAL-DATA-TYPE} or when {&CHARACTER-DATA-TYPE} then
                    {get DropDownIndicator hOverlayWidget}.
        end case.    /* data type */
    end case.    /* lookup type */
    
    if valid-handle(hOverlayWidget) then
    do:
        {get ContainerHandle hFrame}.
        {get BrowseHandle hBrowse}.
        
        hValueColumn = {fnarg widgetHandle 'tAttributeValue'}.
        
        IF hValueColumn:Y lt 0 OR
           hValueColumn:X lt 0 OR 
           hValueColumn:X + hValueColumn:WIDTH-Pixels + hOverlayWidget:WIDTH-Pixels gt hBrowse:WIDTH-Pixels THEN
           hOverlayWidget:hidden = yes.
        ELSE
        DO:
            ASSIGN hOverlayWidget:Y = hValueColumn:Y + hBrowse:Y
                   hOverlayWidget:X = hValueColumn:X + hBrowse:X + hValueColumn:WIDTH-PIXELS
                                    - hOverlayWidget:WIDTH-PIXELS + 4
                   hOverlayWidget:hidden = no
                   NO-ERROR.
            hOverlayWidget:MOVE-TO-TOP().
        end.    /* make it visible */            
    end.    /* valid overlay widget */
    
    error-status:error = no.        
    return.
END PROCEDURE.    /* overlayWidget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run super.
    
    /* on reset, get the values back. this includes the
       attribute lookup.
     */
    {fn hideOverlayWidgets}.
    run overlayWidget in target-procedure.
    
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input parameter pdHeight            as decimal                 no-undo.
    DEFINE input parameter pdWidth             as decimal                 no-undo.
    
    DEFINE variable hFrame            as handle                         no-undo.
    DEFINE variable hBrowse           as handle                         no-undo.
    
    /* The standard browser resizing code checks for the existence of 
       other widgets on the browser and doesn't resize if it can find 
       any. This means that the browser resizing should be managed here.
       
       The resizing code is taken from browser.p's resizeObject and 
       does the same as there, except that it doesn't care about other
       widgets. 
     */
    {get BrowseHandle hBrowse}.
    {get ContainerHandle hFrame}.
    
    /* Assure that it doesn't get too small */
    ASSIGN pdHeight = MAX(pdHeight, 2)
           pdWidth  = MAX(pdWidth, 2).
           
    IF pdWidth lt hBrowse:WIDTH THEN
        ASSIGN hBrowse:WIDTH = pdWidth - (hBrowse:COLUMN - 1)
               hFrame:WIDTH  = pdWidth
               NO-ERROR.
    ELSE
        ASSIGN hFrame:WIDTH  = pdWidth
               hBrowse:WIDTH = pdWidth - (hBrowse:COLUMN - 1)
               NO-ERROR.           
               
    /* If the height is getting smaller, do the browse first else the frame */
    IF pdHeight < hBrowse:HEIGHT THEN                                                            
        ASSIGN hBrowse:HEIGHT = pdHeight - (hBrowse:ROW - 1)
               hFrame:HEIGHT  = pdHeight
               NO-ERROR.
    ELSE
        ASSIGN hFrame:HEIGHT  = pdHeight
               hBrowse:HEIGHT = pdHeight - (hBrowse:ROW - 1)
               NO-ERROR.
    
    run super(pdHeight,pdWidth).
    
    /* Don't try to show stuff if the frame is hidden at the moment.
     */
    if not hFrame:hidden then
    do:
        if {fn getObjectMode} eq 'View' then
            {fn hideOverlayWidgets}.
        else
            run overlayWidget in target-procedure.
    end.    /* frame visible */
    
    return.
END PROCEDURE.    /* resizeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowLeave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave Procedure 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hEntered             as handle                     no-undo.
    DEFINE variable hParent              as handle                     no-undo.
    DEFINE variable hFrame               as handle                     no-undo.
    DEFINE variable hThisFrame           as handle                     no-undo.    
    DEFINE variable lRunSuper            as logical                    no-undo.
    
    /* Check where we've gone. If we've left
       the row to select something from a lookup,
       then don't leave the row.
     */
    hEntered = LAST-EVENT:WIDGET-ENTER.                
    IF VALID-HANDLE(hEntered) THEN
        hParent = hEntered:PARENT.
    
    IF VALID-HANDLE(hParent) AND hParent:TYPE NE "BROWSE":U THEN
        hFrame = hEntered:FRAME.  /* Can't check FRAME on Brs flds */
    
    /* get the handle of the lookup. */
    {get ContainerHandle hThisFrame}.
    
    /* if we have left the browse column to
       pick an attribute, then don't do the default
       behaviour.
         */
    if valid-handle(hThisFrame) and 
       valid-handle(hFrame) and 
       hThisFrame eq hFrame then
           lRunSuper = no.
    else
        lRunSuper = yes.
    
    if lRunSuper then
        run super.
    
    return.
END PROCEDURE.    /* rowLeave */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectAttribute Procedure 
PROCEDURE selectAttribute :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Event procedure when an attribute is selected from the list of
               attributes presented.
  Parameters:  <None>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE variable hColumn                  as handle                 no-undo.
    DEFINE variable hAttributeLookup         as handle                 no-undo.
    
    /* Since the selection list is emulating a combo-box, only apply change when the
     * user either clicks on an item on presses enter. Not when using cursor.
     */
    {get AttributeLookup hAttributeLookup}.     
    assign hColumn = {fnarg widgetHandle 'tAttributeLabel'}
           hColumn:SCREEN-VALUE = hAttributeLookup:SCREEN-VALUE
           hAttributeLookup:hidden = yes
           NO-ERROR.
    
    /* move on ... */
    hColumn = {fnarg widgetHandle 'tAttributeValue'}.
    apply 'Entry' to hColumn.
    
    return.
END PROCEDURE.    /* selectAttribute */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode Procedure 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input parameter pcMode            as character            no-undo.
    
    run super (pcMode).
    
    if pcMode eq 'View' then
        {fn hideOverlayWidgets}.
    else
        run overlayWidget in target-procedure.
    
    return.
END PROCEDURE.    /* updateMode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable cTagCode            as character                    no-undo.
    DEFINE variable cClassName          as character                    no-undo.
    DEFINE variable cAnswer             as character                    no-undo.
    DEFINE variable cButton             as character                    no-undo.
    DEFINE variable cCustomClass        as character                    no-undo.
    DEFINE variable cAttributeLabel     as character                    no-undo.    
    DEFINE variable hDataSource         as handle                       no-undo.
    DEFINE variable hClassDataSource    as handle                       no-undo.
    DEFINE variable hContainer          as handle                       no-undo.
    DEFINE variable hRDM                as handle                       no-undo.
    DEFINE variable hRowObjectBuffer    as handle                       no-undo.
    DEFINE variable dClassObj           as decimal                      no-undo.
    DEFINE VARIABLE rRowid              AS ROWID                        NO-UNDO.
    DEFINE VARIABLE cProfileData        AS CHARACTER                    NO-UNDO.
    DEFINE variable lCreateCustomClass  as logical                      no-undo.
    define variable hROBuf              as handle no-undo.
    define variable lDup                as logical no-undo.
    
    {get ContainerSource hContainer}.
    
    /* If we are customising a standard Dynamics class - one that has the 
       RY_OWN tag - by changing attribute values, ask first whether to 
       create a new custom class. This is so that customers are prevented
       from losing customisations.
       This should apply to all actions (including deletes) since all actions
       change the behaviour of a class.	*/
    {get DataSource hDataSource}.
    {get DataSource hClassDataSource hDataSource}.
    {get RowObject hRowObjectBuffer hDataSource}.
    
    /* The label is used for a couple of things,
       so get it first. */
    cAttributeLabel = {fnarg widgetValue 'tAttributeLabel'}.
    
    /* Make sure that a duplicate record is not being created.
       Obviously only do this in Add or Copy mode. */
    if {fn getNewRecord} ne 'no' then
    do:
        /* Search the rowobject buffer using a named buffer so as not 
	       to disturb the SDO's query (which findRowWhere() will do) since
	       that will cause the browser to reposition.	*/
        create buffer hROBuf for table hRowObjectBuffer buffer-name 'lbRO':u.
        
        hROBuf:find-first(' where ':u + hROBuf:name + '.tAttributeLabel = ':u + quoter(cAttributeLabel)) no-error.
        lDup = hROBuf:available.
        delete object hROBuf no-error.
        hROBuf = ?.
	    
        if lDup then
        do:
            if valid-handle(gshSessionManager) then
                RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '40' '?' '?'
                                                              "'An attribute called ' + cAttributeLabel + ' already exists for this class'"},
                                                       INPUT  "ERR", /* error type */
                                                       INPUT  "&OK", /* button list */
                                                       INPUT  "&OK", /* default button */ 
                                                       INPUT  "&OK", /* cancel button */
                                                       INPUT  "Duplicate attribute ~'" + cAttributeLabel + "~'", /* window title */
                                                       INPUT  YES, /* display if empty */ 
                                                       INPUT  hContainer,
                                                       OUTPUT cButton       ).
            return 'adm-error':u.
        end.    /* found a duplicate */
    end.    /* add or copy */
        
    /* Get the tags off the class.
     */
    cTagCode = {fnarg columnValue 'DataTags' hClassDataSource}.
    
    publish "findCustomizingClass" from hContainer (output cCustomClass).
    
    if cCustomClass eq '' and can-do(cTagCode, 'RY_OWN') then
    do:
        /* Get the user profile as to whether a new class should be created. 
        */
        if valid-handle(gshProfileManager) then
            RUN getProfileData IN gshProfileManager (INPUT                "General":U,
                                                     INPUT                "UpdCustCls":U,
                                                     INPUT                "UpdCustCls":U,
                                                     INPUT        NO,
                                                     INPUT-OUTPUT rRowid,
                                                           OUTPUT cProfileData) no-error.
        
        case cProfileData:
            when "Always" then lCreateCustomClass = yes.
            when "Never" then lCreateCustomClass = no.
            otherwise lCreateCustomClass = ?.
        end case.    /* profile data */
        
        /* ask if to need to create a new class */
        if lCreateCustomClass eq ? then
        do:
            cClassName = {fnarg columnValue 'object_type_code' hClassDataSource}.
            
            if valid-handle(gshSessionManager) then
                RUN askQuestion IN gshSessionManager (INPUT ('You have changed the ' + cClassName
                                                            + ' class that is owned by the central Dynamics repository.'
                                                            + ' Would you like to create a custom class for it?'
                                                            + '~nThis is the recommended approach.'),
                                                      INPUT '&Yes,&Always,&No,Ne&ver,&Cancel':U,    /* button list */
                                                      INPUT '&Always':U, /* default button */ 
                                                      INPUT '&Cancel',       /* cancel button */
                                                      INPUT 'Create custom class',             /* window title */
                                                      INPUT '':U,      /* data type of question */ 
                                                      INPUT '':U,          /* format mask for question */ 
                                                      INPUT-OUTPUT cAnswer,
                                                      OUTPUT cButton         ) no-error.
            /* get rid of the ampersand */
            cButton = replace(cButton, '&', '').
            
            /* Give a way out. */
            if cButton eq 'Cancel' then
                return 'adm-error'.
            
            /* decide whether to create a class or not. */
            if can-do('Yes,Always', cButton) then
                lCreateCustomClass = yes.
            else
            if can-do('No,Never', cButton) then
                lCreateCustomClass = no.
                                
            /* always and never are stored as profile data */
            if can-do('Always,Never', cButton) then
            do:
                IF VALID-HANDLE(gshProfileManager) THEN
                    RUN setProfileData IN gshProfileManager (INPUT 'General',
                                                             INPUT 'UpdCustCls':U,         /* Profile code */
                                                             INPUT 'UpdCustCls',         /* Profile data key */
                                                             INPUT ?,                   /* Rowid of profile data */
                                                             INPUT cButton,        /* Profile data value */
                                                             INPUT NO,                  /* Delete flag */
                                                             INPUT "PER":u) no-error. /* Save flag (permanent) */
            end.    /* always or never. */                
        end.    /* ask whether to create a custom class */
        
        /* create class */
        if lCreateCustomClass then
        do:
            /* need the container to store the
               custom class name and for error
               messages, if any.
             */
            {get ContainerSource hContainer}.
                        
            /* we may not have a class name yet, especially
               if the 'Always' option has been chosen.
             */             
            if cClassName eq '' then
                cClassName = {fnarg columnValue 'object_type_code' hClassDataSource}.
            
            /* create a default value */
            cAnswer = cClassName + '_Custom'.
            if valid-handle(gshSessionManager) then
                RUN askQuestion IN gshSessionManager (INPUT 'Enter the name of the customizing class',
                                                      INPUT '&Ok,&Cancel':U, /* button list */
                                                      INPUT '&Ok':U, /* default button */ 
                                                      INPUT '&Cancel', /* cancel button */
                                                      INPUT 'Custom class name', /* window title */
                                                      INPUT 'Character':U,      /* data type of question */ 
                                                      INPUT 'x(35)':U,          /* format mask for question */ 
                                                      INPUT-OUTPUT cAnswer,
                                                            OUTPUT cButton         ) no-error.
            /* Give a way out. */
            if replace(cButton, '&','') eq 'Cancel' then
                return 'adm-error'.
            
            /* create the class */
            hRDM = {fnarg getManagerHandle 'RepositoryDesignManager'}.
            if valid-handle(hRDM) then
            do:
                /* Add a new class. Default as many values as possible 
                   to the current class.
                 */
                run insertClass in hRDM ( input  cAnswer,    /* class name */
                                          input  ('Customizing class for ' + cClassName), /*pcClassDescription*/
                                          input  '', /* no parent class by default; pcExtendsClassName */
                                          input  '', /* no custom class by default; pcCustomClassName */
                                          input  {fnarg columnValue 'disabled' hClassDataSource},
                                          input  {fnarg columnValue 'layout_supported' hClassDataSource},
                                          input  {fnarg columnValue 'deployment_type' hClassDataSource},
                                          input  {fnarg columnValue 'static_object' hClassDataSource},
                                          input  {fnarg columnValue 'cache_on_client' hClassDataSource},
                                          input  '', /* no class object name; pcClassObjectName */
                                          output dClassObj ) no-error.
                if error-status:error or return-value ne '' then
                do:
                    if valid-handle(gshSessionManager) then
	                    RUN showMessages IN gshSessionManager (INPUT  return-value,
	                                                           INPUT  "ERR", /* error type */
	                                                           INPUT  "&OK", /* button list */
	                                                           INPUT  "&OK", /* default button */ 
	                                                           INPUT  "&OK", /* cancel button */
	                                                           INPUT  "Error creating class " + cAnswer, /* window title */
	                                                           INPUT  YES, /* display if empty */ 
	                                                           INPUT  hContainer,
	                                                           OUTPUT cButton       ).
                    return 'adm-error'.
                end.    /* error creating custom class. */
                
                /* Add the new custom class to the existing class 
                   unknown values mean use what's there.
                 */
                run insertClass in hRDM ( input  cClassName,
                                          input  ?,
                                          input  ?,
                                          input  cAnswer, /* pcCustomClassName */
                                          input  ?, /* disabled */
                                          input  ?,     /* layout supported */
                                          input  ?, /* deployment type */
                                          input  ?, /* static object */
                                          input  ?, /* cache on client */
                                          input  ?, /* pcClassObjectName */
                                          output dClassObj ) no-error.
                if error-status:error or return-value ne '' then
                do:
                    if valid-handle(gshSessionManager) then
	                    RUN showMessages IN gshSessionManager (INPUT  return-value,
	                                                           INPUT  "ERR", /* error type */
	                                                           INPUT  "&OK", /* button list */
	                                                           INPUT  "&OK", /* default button */ 
	                                                           INPUT  "&OK", /* cancel button */
	                                                           INPUT  "Error updating class " + cClassName, /* window title */
	                                                           INPUT  YES, /* display if empty */ 
	                                                           INPUT  hContainer,
	                                                           OUTPUT cButton       ).                                                           
                    return 'adm-error'.                                        
                end.    /* error creating custom class. */
                
                /* store the name of the custom class for use 
                   by the data obejct.
                 */
                dynamic-function('setUserProperty' in hContainer,
                                 'CustomClass', cAnswer).
            end.    /* valid RDM */
        end.    /* create custom class */
    end.    /* warn re customisation */

    run super.
    
    if return-value eq 'adm-error' then
        run resetRecord in target-procedure.
    else
    /* If the save event fails, don't kill off the updateable field.
     */
    do:
        /* we only need the label column enabled for adds and copies. */
        {fn disableLabelColumn}.
        {fn hideOverlayWidgets}.
        
        /* Clear the client cache */
        run destroyClassCache in gshRepositoryManager.
        
        /* force the class data (and thus child data) to refresh. */
        run refreshRow in hClassDataSource.
        
        /* reposition */
        dynamic-function('findRowWhere' in hDataSource, 'tAttributeLabel', cAttributeLabel, '=').
    end.    /* no error */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* updateRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run super.
    
    if {fn getObjectMode} eq 'View' then
        {fn hideOverlayWidgets}.
    else
        run overlayWidget in target-procedure.
    
    return.
END PROCEDURE.    /* viewobject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-adjustAttributeLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION adjustAttributeLinks Procedure 
FUNCTION adjustAttributeLinks RETURNS LOGICAL PRIVATE
    ( INPUT pcAction    AS CHARACTER ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Remove or add the data links from the attribute sdo to 
           its visual object so that the UI behaves corectly.
    Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hSdo            as handle                        no-undo.
    DEFINE variable iLoop           as integer                       no-undo.
    DEFINE variable cDataTargets    as character                     no-undo.
    
    {get AttributeSdo hSdo}.
    {get DataTarget cDataTargets hSdo}.
    
    do iLoop = 1 to num-entries(cDataTargets):     
            dynamic-function('changeLinkState' in widget-handle(entry(iLoop, cDataTargets)),
                             pcAction, 'DataSource', hSdo).
    end.    /* loop through data targets */
    
    return true.
END FUNCTION.    /* adjustAttributeLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildOverlayWidgets Procedure 
FUNCTION buildOverlayWidgets RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Builds widgets used for overlaying the browse 'Value' column.
        Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hWidget            as handle                no-undo.
    DEFINE variable hFrame             as handle                no-undo.
    
    {get ContainerHandle hFrame}.
        
    /* Drop-down list indicator */
    {get DropDownIndicator hWidget}.
    if not valid-handle(hWidget) then
    do:
        create button hWidget
            assign frame = hFrame
                   name = "buDropDown"
                   label = ""
                   no-focus = yes
                   bgcolor = 8
                   width-chars = 3.6 
                   height-chars = 0.76
                   sensitive = yes
                   visible = no
            triggers:
                on choose persistent run chooseDropDownButton in target-procedure (hWidget).
            end triggers.
        hWidget:load-image('ry/img/afarrwdn.gif').
        {set DropDownIndicator hWidget}.
    end.    /* not valid handle - sel button */
    
    /* indicates a procedure to run.*/
    {get DialogButton hWidget}.
    if not valid-handle(hWidget) then
    do:
        create button hWidget
            assign frame = hFrame
                   name = "buDialogButton"
                   label = "..."
                   no-focus = yes
                   bgcolor = 8
                   width-chars = 3.6 
                   height-chars = 0.76
                   sensitive = yes
                   visible = no                   
            triggers:
                on choose persistent run dialogLookup in target-procedure (hWidget).
            end triggers.
        {set DialogButton hWidget}.
    end.    /* not valid handle - dialog button */
    
    /* lookup list */
    {get LookupList hWidget}.
    if not valid-handle(hWidget) then
    do:
        create selection-list hWidget
            assign frame = hFrame
                   multiple = no
                   scrollbar-vertical = yes
                   height-chars = 2.05
                   width-chars = 24
                   font = 3
                   sensitive = yes
                   visible = no
            triggers:
                on value-changed persistent run changeSelectedValue in target-procedure.
                on default-action persistent run changeSelectedValue in target-procedure.
            end triggers.
        {set LookupList hWidget}.
    end.    /* not valid sel list */
    
    /* editor for large values */
    {get TextEditor hWidget}.
    if not valid-handle(hWidget) then
    do:
        create editor hWidget
            assign frame = hFrame
                   scrollbar-vertical = yes
                   word-wrap = yes
                   height-chars = 6
                   width-chars = 24
                   font = 3
                   sensitive = yes
                   visible = no
            triggers:
                on tab persistent run changeSelectedValue in target-procedure.
                on leave persistent run changeSelectedValue in target-procedure.
                on default-action persistent run changeSelectedValue in target-procedure.
            end triggers.
        {set TextEditor hWidget}.
    end.    /* not valid sel list */
    
    /* attribute list.
       this is a different widget to the 
       lookup list since it needs different trigger behaviour.
     */
    {get AttributeLookup hWidget}.
    if not valid-handle(hWidget) then
    do:
        create selection-list hWidget
            assign name = "seSelectAttribute"
                   frame = hFrame
                   multiple = no
                   scrollbar-vertical = yes
                   height-chars = 2.05
                   width-chars = 24
                   font = 3
                   sensitive = yes
                   visible = no
            triggers:
                on value-changed persistent run selectAttribute in target-procedure.
                on leave persistent run selectAttribute in target-procedure.
                on default-action persistent run selectAttribute in target-procedure.
            end triggers.
        {set AttributeLookup hWidget}.
    end.    /* not valid sel list */

    return true.
END FUNCTION.    /* buildOverlayWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyOverlayWidgets Procedure 
FUNCTION destroyOverlayWidgets RETURNS LOGICAL PRIVATE
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hWidget            as handle                        no-undo.
    
    {get DropDownIndicator hWidget}.
    if valid-handle(hWidget) then
        delete object hWidget no-error.
    
    {get DialogButton hWidget}.
    if valid-handle(hWidget) then
        delete object hWidget no-error.
    
    {get LookupList hWidget}.  
    if valid-handle(hWidget) then
        delete object hWidget no-error.
    
    {get TextEditor hWidget}.          
    if valid-handle(hWidget) then
        delete object hWidget no-error.

    {get AttributeLookup hWidget}.          
    if valid-handle(hWidget) then
        delete object hWidget no-error.
    
    hWidget = ?.
        
    return true.
END FUNCTION.    /* destroyOverlayWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableLabelColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableLabelColumn Procedure 
FUNCTION disableLabelColumn RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Disables the 'Attribute Label' column.  
    Notes:  * this function disabled the column in the UI and also removes
              the column from the EnabledFields list
------------------------------------------------------------------------------*/
    {fnarg disableWidget 'tAttributeLabel'}.
    run modifyListProperty in target-procedure
        (target-procedure, 'Remove', 'EnabledFields', 'tAttributeLabel').
    
    {fnarg adjustAttributeLinks 'Active'}.
    
    return true.
END FUNCTION.    /* disableLabelColumn */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableLabelColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableLabelColumn Procedure 
FUNCTION enableLabelColumn RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Enables the 'Attribute Label' column.  
    Notes:  * this function enables the column in the UI and also adds
                  the column to the EnabledFields list
------------------------------------------------------------------------------*/    
    {fnarg enableWidget 'tAttributeLabel'}.
    run modifyListProperty in target-procedure
        (target-procedure, 'Add', 'EnabledFields', 'tAttributeLabel').
    
    {fnarg adjustAttributeLinks 'Inactive'}.
    
    return true.
END FUNCTION.    /* enableLabelColumn */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeLookup Procedure 
FUNCTION getAttributeLookup RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'AttributeLookup' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
        return ?.
END FUNCTION.    /* getAttributeLookup */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeSdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeSdo Procedure 
FUNCTION getAttributeSdo RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE variable hDataSource                as handle                no-undo.
    DEFINE variable hSdo                       as handle                no-undo.
    DEFINE variable cDataTargets               as character             no-undo.
    DEFINE variable iLoop                      as integer               no-undo.
    DEFINE variable lQueryObject               as logical               no-undo.
    
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'AttributeSdo' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
    do:
        {get DataSource hDataSource}.
        {get DataTarget cDataTargets hDataSource}.
        
        do iLoop = 1 to num-entries(cDataTargets):
            hSdo = widget-handle(entry(iLoop, cDataTargets)).
            if valid-handle(hSdo) then
            do:
                {get QueryObject lQueryObject hSdo}.
                if lQueryObject then
                    leave.
                else
                    hSdo = ?.
            end.    /* valid sdo */
        end.    /* loop through data targets */
                
        /* create in context so we don't have to go through
           the whole rigmarole next time.
         */
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'AttributeSdo'
               ttLocalContext.ContextValue = string(hSdo).
        
        return hSdo.
    end.    /* n/a AttributeSdo */
END FUNCTION.    /* getAttributeSdo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDialogButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDialogButton Procedure 
FUNCTION getDialogButton RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where 
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'DialogButton' 
         no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
        return ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDropDownIndicator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDropDownIndicator Procedure 
FUNCTION getDropDownIndicator RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where 
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'DropDownIndicator' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
        return ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLookupList Procedure 
FUNCTION getLookupList RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'LookupList' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
        return ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTextEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTextEditor Procedure 
FUNCTION getTextEditor RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'TextEditor' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
        return ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hideOverlayWidgets Procedure 
FUNCTION hideOverlayWidgets RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Hides overlay widgets.
    Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hWidget        as handle                        no-undo.
    
    {get DialogButton hWidget}.
    if valid-handle(hWidget) then
        hWidget:hidden = yes.
    
    {get DropDownIndicator hWidget}.
    if valid-handle(hWidget) then
        hWidget:hidden = yes.

    {get LookupList hWidget}.
    if valid-handle(hWidget) then
        hWidget:hidden = yes.

    {get TextEditor hWidget}.
    if valid-handle(hWidget) then
        hWidget:hidden = yes.
    
    {get AttributeLookup hWidget}.
    if valid-handle(hWidget) then
        hWidget:hidden = yes.        
    
    return true.
END FUNCTION.    /* hideOverlayWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttributeLookup Procedure 
FUNCTION setAttributeLookup RETURNS LOGICAL PRIVATE
  ( INPUT phAttributeLookup AS HANDLE ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where 
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'AttributeLookup' no-error.
    if not available ttLocalContext then
    do:
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'AttributeLookup'.
    end.
    
    ttLocalContext.ContextValue = string(phAttributeLookup).    

    RETURN true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDialogButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDialogButton Procedure 
FUNCTION setDialogButton RETURNS LOGICAL PRIVATE
  ( INPUT phDialogButton AS HANDLE ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where 
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'DialogButton' no-error.
    if not available ttLocalContext then
    do:
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'DialogButton'.
    end.
    
    ttLocalContext.ContextValue = string(phDialogButton).    

    RETURN true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDropDownIndicator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDropDownIndicator Procedure 
FUNCTION setDropDownIndicator RETURNS LOGICAL PRIVATE
  ( INPUT phDropDownIndicator AS HANDLE ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
             ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'DropDownIndicator' no-error.
    if not available ttLocalContext then
    do:
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'DropDownIndicator'.
    end.
    
    ttLocalContext.ContextValue = string(phDropDownIndicator).
    
    return true.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLookupList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLookupList Procedure 
FUNCTION setLookupList RETURNS LOGICAL PRIVATE
  ( INPUT phLookupList AS HANDLE ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'LookupList' no-error.
    if not available ttLocalContext then
    do:
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'LookupList'.
    end.
    
    ttLocalContext.ContextValue = string(phLookupList).
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTextEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTextEditor Procedure 
FUNCTION setTextEditor RETURNS LOGICAL PRIVATE
  ( INPUT phTextEditor AS HANDLE) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where 
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'TextEditor' no-error.
    if not available ttLocalContext then
    do:
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'TextEditor'.
    end.
    
    ttLocalContext.ContextValue = string(phTextEditor).
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

