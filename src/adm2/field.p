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

{launch.i &define-only = YES }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-formattedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formattedValue Procedure 
FUNCTION formattedValue RETURNS CHARACTER
  (pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCustomSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCustomSuperProc Procedure 
FUNCTION getCustomSuperProc RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-getLocalField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLocalField Procedure 
FUNCTION getLocalField RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-setCustomSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCustomSuperProc Procedure 
FUNCTION setCustomSuperProc RETURNS LOGICAL
  ( INPUT pcCustomSuperProc AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setLocalField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLocalField Procedure 
FUNCTION setLocalField RETURNS LOGICAL
  ( plLocal AS LOGICAL )  FORWARD.

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
         HEIGHT             = 22.67
         WIDTH              = 58.4.
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
  Notes:       The SmartDataField adds itself to the DisplayedFields property
               of its containing SmartDataViewer if the DisplayField logical 
               property is true, and to the EnabledFields or, if localField, 
               EnabledObjFlds, if EnableField is true.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lInitialized      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lLocal            AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lEnable           AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lDisplay          AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE hSource           AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cCustomSuperProc  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cList             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lDisableOnInit    AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lHideOnInit       AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cEnabledObjFlds   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSecured          AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lTranslated       AS LOGICAL    NO-UNDO.

    DEFINE VARIABLE cSuperProcedureMode         AS CHARACTER          NO-UNDO.
    
    {get ObjectInitialized lInitialized}.
    IF lInitialized THEN 
       RETURN "adm-error":U. 

    {get ContainerSource hSource}.
    IF VALID-HANDLE(hSource) THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get FieldName cField}
      {get LocalField lLocal}
      {get EnableField lEnable}.
      &UNDEFINE xp-assign
      IF lLocal THEN
      DO:
        IF lEnable THEN
        DO:
          {get EnabledObjFlds cList hSource}.
          IF LOOKUP(cField,cList) = 0 THEN
          DO:
            cList = (IF cList > '':U THEN cList + ',':U ELSE '':U)
                  + cField.   
            {set EnabledObjFlds cList hSource}.
          END.
        END.
      END.
      ELSE DO:
        {get DisplayField lDisplay}.
        IF lEnable THEN
        DO:
          {get EnabledFields cList hSource}.
          IF LOOKUP(cField,cList) = 0 THEN
          DO:
            cList = (IF cList > '':U THEN cList + ',':U ELSE '':U)
                  + cField.   
            {set EnabledFields cList hSource}.
          END.
        END.
        IF lDisplay THEN
        DO:
          {get DisplayedFields cList hSource}.
          IF LOOKUP(cField,cList) = 0 THEN
          DO:
            cList = (IF cList > '':U THEN cList + ',':U ELSE '':U)
                  + cField.   
            {set DisplayedFields cList hSource}.
          END.
        END.
      END.
      
      /* Start the SDF's super procedure - if specified */
      {get CustomSuperProc cCustomSuperProc}.
      /* If the super procedure couldn't be found for in the CustomSuperProc
         property then we should test for it in SuperProcedure */
      IF cCustomSuperProc = "":U OR cCustomSuperProc = ? THEN
        {get SuperProcedure cCustomSuperProc}.

      IF cCustomSuperProc <> "":U AND cCustomSuperProc <> ? THEN
      DO:
          /* Default to STATEFUL mode because that is historically our default. */
          ASSIGN cSuperProcedureMode = "STATEFUL":U.
          
          /* Is Dynamics running? */
          IF VALID-HANDLE(gshSessionManager) THEN
          DO:
              {launch.i
                  &PLIP  = cCustomSuperProc
                  &IProc = ''
                  &OnApp = 'NO'
              }
              /* Add all the super procedures. */
              DYNAMIC-FUNCTION("addAsSuperProcedure":U IN gshSessionManager,
                               INPUT hPlip, INPUT TARGET-PROCEDURE).
          END.    /* session manager is running */
          ELSE
          DO:
              DO ON STOP UNDO, RETURN 'ADM-ERROR':U:
                  RUN VALUE(cCustomSuperProc) PERSISTENT SET hPlip.
              END.    /* run the super procedure */
              
              IF VALID-HANDLE(hPlip) THEN
                  TARGET-PROCEDURE:ADD-SUPER-PROCEDURE(hPlip, SEARCH-TARGET).
          END.    /* sesison manger not running */
          
          /* Store the handle of the super so that it is killed when
             this object shuts down. The destruction of this super procedure
             is done by the container (the viewer typically).
           */
          IF cSuperProcedureMode NE "STATELESS":U THEN
              {set SuperProcedureHandle STRING(hPlip)}.
      END.    /* super procedure existst */
    END.   /* END DO IF ContainerSource */
    
    /* The SUPER call adds a cost that, although small per object, adds a 
       substantial performance cost when there are many datafields on an viewer. 
       So we call SUPER 
       - when there are fields/widgets in EnabledObjFlds (static SDF built in 
         Appbuilder) as we then need to build the corresponding EnabledObjHdls
         and also call EnableObject to enable them.
       - when the object is not secured or translated as we then need the call 
         to widgetwalk in visual.p (Rep man does this, so this should only 
         be false when inside static viewers) */    

    &SCOPED-DEFINE xp-assign
    {get ObjectSecured lSecured}
    {get ObjectTranslated lTranslated}
    {get EnabledObjFlds cEnabledObjFlds}
     .
    &SCOPED-DEFINE xp-assign
    /* not (log = true) to treat unknown and false similar  */ 
    IF NOT (lSecured = TRUE) OR NOT (lTranslated = TRUE) OR (cEnabledObjFlds > '':U) THEN
      RUN SUPER.
    
    ELSE DO: /* Duplicate the important stuff that would happen in supers */      
      &SCOPED-DEFINE xp-assign
      {set ObjectInitialized YES}
      {get DisableOnInit lDisableOnInit}
      {get HideOnInit lHideOnInit}.
      &UNDEFINE xp-assign
      
      IF NOT lDisableOnInit AND lEnable THEN
        RUN enableObject IN TARGET-PROCEDURE. 

      IF NOT lHideOnInit THEN 
        RUN viewObject IN TARGET-PROCEDURE.
      ELSE 
        PUBLISH "LinkState":U FROM TARGET-PROCEDURE ('inactive':U).      
    END. /* No enabledObjFlds (dynselect etc.. ) */

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

&IF DEFINED(EXCLUDE-formattedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formattedValue Procedure 
FUNCTION formattedValue RETURNS CHARACTER
  (pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the formatted value of a passed value according to the 
           SmartSelect/Dynamic Combo/Dynamic Lookup/SDF format. 
Parameter: pcValue - The value that need to be formatted.      
    Notes: Used internally in order to ensure that unformatted data can be 
           applied to screen-value (setDataValue) or used as lookup in
           list-item-pairs in (getDisplayValue)  
           This code was moved from select.p into field.p to accomodate
           dynamic lookups and combos
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFormat    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER  NO-UNDO.

  {get SelectionHandle hSelection TARGET-PROCEDURE} NO-ERROR.
  /* For selection lists */
  IF VALID-HANDLE(hSelection) AND CAN-QUERY(hSelection,'FORMAT':U) THEN
    ASSIGN cFormat   = hSelection:FORMAT
           cDataType = hSelection:DATA-TYPE.
  /* For Dynamic Lookups and Combos */
  ELSE DO: 
    ASSIGN cFormat   = DYNAMIC-FUNCTION("getKeyFormat":U IN TARGET-PROCEDURE) NO-ERROR.
    ASSIGN cDataType = DYNAMIC-FUNCTION("getKeyDataType":U IN TARGET-PROCEDURE) NO-ERROR.
  END.

  /* Invalid Format */
  IF cFormat = "":U OR cFormat = ? OR cFormat = "?":U THEN
    RETURN pcValue.
  IF cDataType = "":U OR cDataType = ? OR cDataType = "?":U THEN
    RETURN pcValue.

  CASE cDataType:
    WHEN 'CHARACTER':U THEN
      pcValue = RIGHT-TRIM(STRING(pcValue,cFormat)).
    WHEN 'DATE':U THEN
      pcValue = STRING(DATE(pcValue),cFormat).
    WHEN 'DECIMAL':U THEN
      pcValue = STRING(DECIMAL(pcValue),cFormat).
    WHEN 'INTEGER':U THEN
      pcValue = STRING(INT(pcValue),cFormat).
    WHEN 'LOGICAL':U THEN
      pcValue = ENTRY(IF CAN-DO('yes,true':U,pcValue) THEN 1 ELSE 2,
                       cFormat,'/':U).
  END CASE.
  
  RETURN pcValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCustomSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCustomSuperProc Procedure 
FUNCTION getCustomSuperProc RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of a SmartDataField.
   Params:  <none>
------------------------------------------------------------------------------*/

 DEFINE VARIABLE cCustomSuperProc AS CHARACTER NO-UNDO.
  
 &SCOPED-DEFINE xpCustomSuperProc
 {get CustomSuperProc cCustomSuperProc}.
 &UNDEFINE xpCustomSuperProc

  RETURN cCustomSuperProc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
  
  &SCOPED-DEFINE xpDataModified
  {get DataModified lModified}.
  &UNDEFINE xpDataModified
 
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

&IF DEFINED(EXCLUDE-getLocalField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLocalField Procedure 
FUNCTION getLocalField RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE if the field name begins with "<" (backswards 
            compatibility where fields were called <Local> to indicate
            that they were local fields) or it returns the value
            of the LocalField property.
   Params:  <none>
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFieldName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lLocal     AS LOGICAL NO-UNDO.
  
  {get FieldName cFieldName}.
  IF cFieldName BEGINS '<':U THEN RETURN TRUE.

  &SCOPED-DEFINE xpLocalField
  {get LocalField lLocal}.
  &UNDEFINE xpLocalField
  
  RETURN lLocal.

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

&IF DEFINED(EXCLUDE-setCustomSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCustomSuperProc Procedure 
FUNCTION setCustomSuperProc RETURNS LOGICAL
  ( INPUT pcCustomSuperProc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpCustomSuperProc
  {set CustomSuperProc pcCustomSuperProc}.
  &UNDEFINE xpCustomSuperProc

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
    IF VALID-HANDLE(hContainer) THEN
      RUN fieldModified IN hContainer ( TARGET-PROCEDURE ).
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
    /* Set a variable to the value passed in to this function. This
       is because there is a 4GL bug in the 9.x family where, when
       assigning a field's INPUT-VALUE to a dynamic temp-table field,
       an error [** setDisplayValue adm2/field.p: Unable to evaluate 
       field for assignment. (143)] results if the input value 
       is the unknown value. This is logged as 20031205-002 (IZ13893),
       with the 4GL bug being 20030731-010.
       
       We get around this by using a literal unknown value when the 
       input-ed value is unknown, and using the passed in value in
       all other cases.
     */
  &SCOPED-DEFINE xpDisplayValue
  {set DisplayValue
      "(if pcValue eq ? then ? else pcValue)"
  }.
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

&IF DEFINED(EXCLUDE-setLocalField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLocalField Procedure 
FUNCTION setLocalField RETURNS LOGICAL
  ( plLocal AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the LocalField property of the SmartDataField.
   Params:  plLocal AS LOGICAL
    Notes:  This property determines whether the field provides data to
            a local field rather than a data field.
------------------------------------------------------------------------------*/

  &SCOPED-DEFINE xpLocalField
  {set LocalField plLocal}.
  &UNDEFINE xpLocalField
  
  RETURN TRUE.
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

