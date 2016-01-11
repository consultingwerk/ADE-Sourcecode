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
    File        : field.p
    Purpose     : Super procedure for SmartDataField objects

    Syntax      : adm2/field.p

    Modified    : June 23, 1999 Version 9.1A
    Modified    : 16/11/2001    Mark Davies (MIP)
                  Added functions getSDFFrameHandle to return the frame
                  handle of any SDF frame. This is used to move away
                  from using PRIVATE-DATA in ADM procedures.
                  17 Nov 2001   Peter Judge
                  Added support for SDF's on local fill-ins. The FieldName
                  attribute of SDF's on local fill-in's must be "<Local>".
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell fieldprop.i that this is the Super procedure. */
  &SCOP ADMSuper field.p
  
  {src/adm2/custom/fieldexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue Procedure 
FUNCTION getDataValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayField Procedure 
FUNCTION getDisplayField RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayValue Procedure 
FUNCTION getDisplayValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnableField Procedure 
FUNCTION getEnableField RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldEnabled Procedure 
FUNCTION getFieldEnabled RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldName Procedure 
FUNCTION getFieldName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyFieldValue Procedure 
FUNCTION getKeyFieldValue RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSavedScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedScreenValue Procedure 
FUNCTION getSavedScreenValue RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFFrameHandle Procedure 
FUNCTION getSDFFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue Procedure 
FUNCTION setDataValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayField Procedure 
FUNCTION setDisplayField RETURNS LOGICAL
  ( plDisplay AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayValue Procedure 
FUNCTION setDisplayValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnableField Procedure 
FUNCTION setEnableField RETURNS LOGICAL
  ( plEnable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldEnabled Procedure 
FUNCTION setFieldEnabled RETURNS LOGICAL
  ( plEnabled AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldName Procedure 
FUNCTION setFieldName RETURNS LOGICAL
  ( pcField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyFieldValue Procedure 
FUNCTION setKeyFieldValue RETURNS LOGICAL
  ( pcValue AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSavedScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSavedScreenValue Procedure 
FUNCTION setSavedScreenValue RETURNS LOGICAL
  ( pcValue AS CHAR )  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/fieldprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Special code for initializing SmartDataFields.
  Parameters:  <none>
  Notes:       This procedure stores the procedure handle of the 
               SmartDataField in the PRIVATE-DATA of its Frame, in
               order that the procedure can be located from the frame.
               It also adds itself to the DisplayedFields property
               of its containing SmartDataViewer if the DisplayField 
               logical property is true, and, if EnableField is true, 
               to the EnabledFields property as well.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hFrame          AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE cField          AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cPropertyName   AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE lResult         AS LOGICAL                          NO-UNDO.
    DEFINE VARIABLE hSOurce         AS HANDLE                           NO-UNDO.

    {get ContainerSource hSource}.
    IF VALID-HANDLE(hSource) THEN
    DO:
        {get ContainerHandle hFrame}.
        IF VALID-HANDLE(hFrame) THEN
            ASSIGN hFrame:PRIVATE-DATA = STRING(TARGET-PROCEDURE).

        {get FieldName cField}.
        {get DisplayField lResult}.
        /* Local SmartDataFields will have names along the lines of <Local> or <FieldName> */
        IF lResult AND NOT cField BEGINS "<":U THEN
            RUN modifyListProperty IN TARGET-PROCEDURE (hSource, 'ADD':U, 'DisplayedFields':U, cField).

        {get EnableField lResult}.
        IF lResult THEN
        DO:
            IF cField BEGINS "<":U THEN
                ASSIGN cPropertyName = "EnabledObjFlds":U.
            ELSE
                ASSIGN cPropertyName = "EnabledFields":U.

            RUN modifyListProperty IN TARGET-PROCEDURE (hSource, 'ADD':U, cPropertyName, cField).
        END.    /* EnableField = yes */
    END.   /* END DO IF ContainerSource */

    RUN SUPER.
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Resize the Field
  
  Parameters:  INPUT pidHeight decimal New height of component 
               INPUT pidWidth decimal New width of component
  
  Notes:  The procedure steps through all the widgets on the frame and, resizes
          the frame and the widgets (where the programmer wants the widgets to
          be resized). If a programmer does not want a widget to be resized,
          the string 'NO-RESIZE' must be inserted into the widget's PRIVATE-DATA
          
          *** NB: No Buttons nor the height or label (LITERAL) of ANY object / widget
                  will be adjusted by default. For this teh programmer needs to create
                  an override procedure in his SmartDataField write his / her own code,
                  seeing that it would be fairly specific to his / her SmartDataField.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pidWidth  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE dFrameMinimumHeight AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFrameMinimumWidth  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hChildWidget        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFieldGroup         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame              AS HANDLE     NO-UNDO.
  
  {get ContainerHandle hFrame}.
  
  /* Assign the variables to check the height and the width with */
  ASSIGN
      dFrameMinimumWidth  = pidWidth
      dFrameMinimumHeight = pidHeight
      
      /* Set up the variables to step through the widgets */
      hFieldGroup  = hFrame
      hFieldGroup  = hFieldGroup:FIRST-CHILD
      hChildWidget = hFieldGroup:FIRST-CHILD.
  
  /* Walk through all the widgets on the frame and get and the minimum width and height of the frame */
  REPEAT WHILE VALID-HANDLE(hChildWidget):
    IF CAN-QUERY(hChildWidget, "PRIVATE-DATA":U) AND
       CAN-QUERY(hChildWidget, "COLUMN":U)       AND
       CAN-QUERY(hChildWidget, "WIDTH":U)        AND
       CAN-QUERY(hChildWidget, "TYPE":U)         AND
       hChildWidget:TYPE <> "LITERAL":U          AND
       hChildWidget:TYPE <> "BUTTON":U           THEN
    DO:
      IF INDEX("NO-RESIZE":U, hChildWidget:PRIVATE-DATA) <> 0 AND
         INDEX("NO-RESIZE":U, hChildWidget:PRIVATE-DATA) <> ? THEN
      DO:
        /* The non resizable field is wider than the current frame width */
        IF hChildWidget:COLUMN + hChildWidget:WIDTH > dFrameMinimumWidth THEN
          ASSIGN
              dFrameMinimumWidth = hChildWidget:COLUMN + hChildWidget:WIDTH.
      END.
      
      /* If the field is resizable, make sure we don't make the frame smaller than the furthest field */
      IF dFrameMinimumWidth < hChildWidget:COLUMN THEN
        ASSIGN
            dFrameMinimumWidth = hChildWidget:COLUMN.

      /* The field's position and height is more than the current frame height */
      IF hChildWidget:ROW + 0.05 > dFrameMinimumHeight THEN
        ASSIGN
            dFrameMinimumHeight = hChildWidget:ROW + 0.05.
    END.

    /* Move on to the next widget */
    ASSIGN hChildWidget = hChildWidget:NEXT-SIBLING.
  END.

  /* Adjust the frame size */
  ASSIGN
      dFrameMinimumHeight         = dFrameMinimumHeight
      hFrame:SCROLLABLE           = TRUE
      hFrame:WIDTH-CHARS          = dFrameMinimumWidth
      hFrame:HEIGHT-CHARS         = dFrameMinimumHeight
      hFrame:VIRTUAL-WIDTH-CHARS  = hFrame:WIDTH-CHARS
      hFrame:VIRTUAL-HEIGHT-CHARS = hFrame:HEIGHT-CHARS
      hFrame:SCROLLABLE           = FALSE.

  /* Put the child widget back to the first widget on the frame */
  hChildWidget = hFieldGroup:FIRST-CHILD.
  
  /* Walk through all the widgets on the frame */
  REPEAT WHILE VALID-HANDLE(hChildWidget):
    /* Check to see if the relevant properties can be queried and the adjust the width accordingly */
    IF CAN-QUERY(hChildWidget, "PRIVATE-DATA":U) AND
       CAN-QUERY(hChildWidget, "COLUMN":U)       AND
       CAN-QUERY(hChildWidget, "WIDTH":U)        AND
       CAN-QUERY(hChildWidget, "TYPE":U)         AND
       hChildWidget:TYPE <> "LITERAL":U          AND
       hChildWidget:TYPE <> "BUTTON":U           THEN
    DO:
      /* Check if the object should be resized */
      IF INDEX("NO-RESIZE":U, hChildWidget:PRIVATE-DATA) = 0 OR 
         INDEX("NO-RESIZE":U, hChildWidget:PRIVATE-DATA) = ? THEN
        /* Will the size for the widget be valid ? */
        IF dFrameMinimumWidth - hChildWidget:COLUMN > 0 THEN
          ASSIGN
              hChildWidget:WIDTH = dFrameMinimumWidth - hChildWidget:COLUMN.
    END. /* IF CAN-QUERY */
    
    /* Move on to the next widget */
    ASSIGN hChildWidget = hChildWidget:NEXT-SIBLING.
  END.  /* REPEAT */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the SmartDataField value has been
            changed but not saved, otherwise false.
   Params:  <none>
------------------------------------------------------------------------------*/

 DEFINE VARIABLE lModified AS LOGICAL NO-UNDO.
  
 ASSIGN  ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DataModified':U)
         lModified = ghProp:BUFFER-VALUE NO-ERROR.

  RETURN lModified.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue Procedure 
FUNCTION getDataValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of a SmartDataField.
   Params:  <none>
------------------------------------------------------------------------------*/

 DEFINE VARIABLE cDataValue AS CHARACTER NO-UNDO.
  
 &SCOPED-DEFINE xpDataValue
 {get DataValue cDataValue}.
 &UNDEFINE xpDataValue

  RETURN cDataValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayField Procedure 
FUNCTION getDisplayField RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the SmartDataField is to be displayed
            along with other fields in its Container, otherwise false.
   Params:  <none>
    Notes:  This instance property is initialized by the AppBuilder
            in adm-create-objects.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lDisplay AS LOGICAL NO-UNDO.
  
  {get DisplayField lDisplay}.
  RETURN lDisplay.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayValue Procedure 
FUNCTION getDisplayValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the saved screen/display value of a SmartDataField.
   Params:  <none>
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cDisplayValue AS CHARACTER NO-UNDO.
 &SCOPED-DEFINE xpDisplayValue
 {get DisplayValue cDisplayValue}.
 &UNDEFINE xpDisplayValue  
  
 RETURN cDisplayValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnableField Procedure 
FUNCTION getEnableField RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the SmartDataField is to be enabled for user
            input along with other fields in its Container, otherwise false.
   Params:  <none>
    Notes:  This instance property is initialized by the AppBuilder
            in adm-create-objects.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lEnable AS LOGICAL NO-UNDO.
  
  {get EnableField lEnable}.
  RETURN lEnable.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldEnabled Procedure 
FUNCTION getFieldEnabled RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the SmartDataField is enabled for user
            input, otherwise false.
   Params:  <none>
    Notes:  This property is set by user-defined SDF procedures
            enableField and disableField.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lEnabled AS LOGICAL NO-UNDO.
  
  {get FieldEnabled lEnabled}.
  RETURN lEnabled.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldName Procedure 
FUNCTION getFieldName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the SDO field this object maps to.
   Params: <none>  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cField AS CHARACTER NO-UNDO.
  {get FieldName cField}.
  RETURN cField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyFieldValue Procedure 
FUNCTION getKeyFieldValue RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: See DataValue  
    Notes: Obsolete, but kept for backwards compatibility with ICF 0.9  
------------------------------------------------------------------------------*/
  RETURN {fn getDataValue}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSavedScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedScreenValue Procedure 
FUNCTION getSavedScreenValue RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: See DisplayValue  
    Notes: Obsolete, but kept for backwards compatibility with ICF 0.9  
------------------------------------------------------------------------------*/
  RETURN {fn getDisplayValue}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFFrameHandle Procedure 
FUNCTION getSDFFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame  AS HANDLE     NO-UNDO.

  {get ContainerSource hSource}.
  IF VALID-HANDLE(hSource) THEN DO:
    {get ContainerHandle hFrame}. 
    IF VALID-HANDLE(hFrame) THEN
      RETURN hFrame.
  END.
  
  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DataModified property of the SmartDataField,
            and uses a standard event to notify the containing
            SmartDataViewer of this change.
   Params:  plModified AS LOGICAL
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lEnabled    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lContainMod AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpDataModified
  {set DataModified plModified}.
  &UNDEFINE xpDataModified
  
  IF plModified THEN  /* If it's "yes" then... */
  DO:
    {get ContainerSource hContainer}.  /* pass on to our parent. */
       /* the viewer.i has this logic on U10, but it does not handle browsers 
       (smartselect) and also requires focus to valid  */  
    IF VALID-HANDLE(hContainer) THEN
    DO:
      {get FieldsEnabled lEnabled hContainer}.
       /* Only if the object's enable for input.*/
      IF lEnabled THEN 
      DO:
        {get DataModified lContainMod hContainer}.
        IF NOT lContainMod THEN   /* Don't send the event more than once. */
          {set DataModified YES hContainer}.
       END.
    END. /* valid container */
  END.  /* END DO IF plModified */
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue Procedure 
FUNCTION setDataValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpDataValue
  {set DataValue pcValue}.
  &UNDEFINE xpDataValue
  
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayField Procedure 
FUNCTION setDisplayField RETURNS LOGICAL
  ( plDisplay AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DisplayField property of the SmartDataField.
   Params:  plDisplay AS LOGICAL
    Notes:  This property determines whether the field is to be Displayd
            along with other fields in its Container.
------------------------------------------------------------------------------*/

  {set DisplayField plDisplay}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayValue Procedure 
FUNCTION setDisplayValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpDisplayValue
  {set DisplayValue pcValue}.
  &UNDEFINE xpDisplayValue

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnableField Procedure 
FUNCTION setEnableField RETURNS LOGICAL
  ( plEnable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the EnableField property of the SmartDataField.
   Params:  plEnable AS LOGICAL
    Notes:  This property determines whether the field is to be enabled
            along with other fields in its Container.
------------------------------------------------------------------------------*/

  {set EnableField plEnable}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldEnabled Procedure 
FUNCTION setFieldEnabled RETURNS LOGICAL
  ( plEnabled AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FieldEnabled property of the SmartDataField.
   Params:  plEnabled AS LOGICAL
    Notes:  This property is set from user-defined procedures
            enableField and disableField
------------------------------------------------------------------------------*/

  {set FieldEnabled plEnabled}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldName Procedure 
FUNCTION setFieldName RETURNS LOGICAL
  ( pcField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FieldName property of the SmartDataField, 
            identifying the name of the SDO field this maps to.
   Params:  pcField AS CHARACTER
    Notes:  This is run from the containing SmartDataViewer.
------------------------------------------------------------------------------*/

  {set FieldName pcField}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyFieldValue Procedure 
FUNCTION setKeyFieldValue RETURNS LOGICAL
  ( pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: See DataValue 
    Notes: Kept for backwards compatibility with ICF 0.9  
------------------------------------------------------------------------------*/
  RETURN {set DataValue pcValue}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSavedScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSavedScreenValue Procedure 
FUNCTION setSavedScreenValue RETURNS LOGICAL
  ( pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: See DisplayValue 
    Notes: Kept for backwards compatibility with ICF 0.9  
------------------------------------------------------------------------------*/
  RETURN {set DisplayValue pcValue}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
