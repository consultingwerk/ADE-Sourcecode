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

&IF DEFINED(EXCLUDE-getDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayField Procedure 
FUNCTION getDisplayField RETURNS LOGICAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL )  FORWARD.

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

  DEFINE VARIABLE hFrame   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cField   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lResult  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hSOurce  AS HANDLE    NO-UNDO.
  
  {get ContainerSource hSource}.
  IF VALID-HANDLE(hSource) THEN
  DO:
    {get ContainerHandle hFrame}. 
    IF VALID-HANDLE(hFrame) THEN
      hFrame:PRIVATE-DATA = STRING(TARGET-PROCEDURE).

    {get FieldName cField}.
    {get DisplayField lResult}.
    IF lResult THEN
      RUN modifyListProperty IN TARGET-PROCEDURE
        (hSource, 'ADD':U, 'DisplayedFields':U, cField).

    {get EnableField lResult}.
    IF lResult THEN
      RUN modifyListProperty IN TARGET-PROCEDURE
        (hSource, 'ADD':U, 'EnabledFields':U, cField).
  END.   /* END DO IF ContainerSource */
  
  RUN SUPER.
  
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

  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DataModified':U)
         ghProp:BUFFER-VALUE = plModified NO-ERROR.
  
  IF plModified THEN  /* If it's "yes" then... */
  DO:
    {get ContainerSource hContainer}.   /* pass on to our parent. */
    IF VALID-HANDLE(hContainer) THEN
      APPLY 'U10':U TO hContainer.
  END.  /* END DO IF plModified */
  
  RETURN TRUE.

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

