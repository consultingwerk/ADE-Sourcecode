&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*--------------------------------------------------------------------------
    File        : visual.p
    Purpose     : Code common to all objects with a visualization, including
                  Viewers, Browsers, Windows, and Frames

    Syntax      : adm2/visual.p

    Modified    : May 19, 1999 Version 9.1A
    Modified    : 11/14/2001          Mark Davies (MIP)
                  Renamed property 'DisplayFieldsSecurity' to 'FieldSecurity'
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell visattr.i that this is the Super procedure. */
   &SCOP ADMSuper visual.p

  {src/adm2/custom/visualexclcustom.i}
  
DEFINE VARIABLE giColor3DFace          AS INTEGER    NO-UNDO.
DEFINE VARIABLE giColor3DHighLight     AS INTEGER    NO-UNDO.
DEFINE VARIABLE giColor3DShadow        AS INTEGER    NO-UNDO.

&SCOPED-DEFINE COLOR_3DFACE      15
&SCOPED-DEFINE COLOR_3DSHADOW    16
&SCOPED-DEFINE COLOR_3DHIGHLIGHT 20

/* External Procedure Declaration */
PROCEDURE GetSysColor EXTERNAL "USER32.DLL" :
    DEFINE INPUT  PARAMETER iIndex  AS LONG NO-UNDO.
    DEFINE RETURN PARAMETER iRGB    AS LONG NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-createDynamicColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createDynamicColor Procedure 
FUNCTION createDynamicColor RETURNS INTEGER
  ( pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAllFieldHandles Procedure 
FUNCTION getAllFieldHandles RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAllFieldNames Procedure 
FUNCTION getAllFieldNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCol) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCol Procedure 
FUNCTION getCol RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DFace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColor3DFace Procedure 
FUNCTION getColor3DFace RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DHighLight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColor3DHighLight Procedure 
FUNCTION getColor3DHighLight RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DShadow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColor3DShadow Procedure 
FUNCTION getColor3DShadow RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDefaultLayout Procedure 
FUNCTION getDefaultLayout RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisableOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisableOnInit Procedure 
FUNCTION getDisableOnInit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjFlds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledObjFlds Procedure 
FUNCTION getEnabledObjFlds RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjHdls) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledObjHdls Procedure 
FUNCTION getEnabledObjHdls RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldSecurity Procedure 
FUNCTION getFieldSecurity RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHeight Procedure 
FUNCTION getHeight RETURNS DECIMAL
    (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLayoutOptions Procedure 
FUNCTION getLayoutOptions RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutVariable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLayoutVariable Procedure 
FUNCTION getLayoutVariable RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMinHeight Procedure 
FUNCTION getMinHeight RETURNS DECIMAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMinWidth Procedure 
FUNCTION getMinWidth RETURNS DECIMAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectEnabled Procedure 
FUNCTION getObjectEnabled RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectLayout Procedure 
FUNCTION getObjectLayout RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeHorizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResizeHorizontal Procedure 
FUNCTION getResizeHorizontal RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeVertical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResizeVertical Procedure 
FUNCTION getResizeVertical RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRow Procedure 
FUNCTION getRow RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidth Procedure 
FUNCTION getWidth RETURNS DECIMAL
    (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAllFieldHandles Procedure 
FUNCTION setAllFieldHandles RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAllFieldNames Procedure 
FUNCTION setAllFieldNames RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultLayout Procedure 
FUNCTION setDefaultLayout RETURNS LOGICAL
  ( pcDefault AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisableOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisableOnInit Procedure 
FUNCTION setDisableOnInit RETURNS LOGICAL
  ( plDisable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledObjFlds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnabledObjFlds Procedure 
FUNCTION setEnabledObjFlds RETURNS LOGICAL
    ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldSecurity Procedure 
FUNCTION setFieldSecurity RETURNS LOGICAL
  ( pcSecurityType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHideOnInit Procedure 
FUNCTION setHideOnInit RETURNS LOGICAL
  ( plHide AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLayoutOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLayoutOptions Procedure 
FUNCTION setLayoutOptions RETURNS LOGICAL
  ( pcOptions AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMinHeight Procedure 
FUNCTION setMinHeight RETURNS LOGICAL
    ( INPUT pdHeight            AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMinWidth Procedure 
FUNCTION setMinWidth RETURNS LOGICAL
    ( INPUT pdWidth            AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectLayout Procedure 
FUNCTION setObjectLayout RETURNS LOGICAL
  ( pcLayout AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResizeHorizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setResizeHorizontal Procedure 
FUNCTION setResizeHorizontal RETURNS LOGICAL
  ( INPUT plResizeHorizontal AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResizeVertical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setResizeVertical Procedure 
FUNCTION setResizeVertical RETURNS LOGICAL
  ( INPUT plResizeVertical AS LOGICAL )  FORWARD.

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
         WIDTH              = 59.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/visprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN initWinColors IN TARGET-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyLayout Procedure 
PROCEDURE applyLayout :
/*------------------------------------------------------------------------------
  Purpose:     Apply the value of the Layout Attribute. This changes the
               object display to an alternate layout when multiple layouts
               have been defined for the object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLayout    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLayoutVar AS CHARACTER NO-UNDO.
  
  /* Get the layout name. */
  {get ObjectLayout cLayout}.
  IF cLayout eq ? THEN cLayout = "":U.
  
  /* A blank cLayout means return to the Default-Layout. If there is
     no default-layout, then return to the Master Layout. */

  IF cLayout eq "":U THEN DO:
    {get defaultLayout cLayout}.
    IF cLayout eq ? THEN cLayout = "":U.
    IF cLayout eq "":U THEN cLayout = "Master Layout":U.
  END. /* IF cLayout eq ... */
  
  /* Does the layout REALLY need changing, or is it already in use? */
  
  {get LayoutVariable cLayoutVar}.
  IF cLayoutVar ne cLayout THEN DO:
    /* Always change layouts by FIRST resetting to the Master Layout. 
       (assuming that the layout isn't already the Master.) */
    IF cLayoutVar ne "Master Layout":U THEN 
      RUN VALUE(cLayoutVar + "s":U) IN TARGET-PROCEDURE ("Master Layout":U).
    /* Now change to the desired layout. */
    IF cLayout ne "Master Layout":U THEN 
      RUN VALUE(cLayoutVar + "s":U) IN TARGET-PROCEDURE (cLayout).
    /* NOTE: DISPLAY-FIELDS NEEDS A VALUE LIST ARGUMENT 
    RUN displayFields IN TARGET-PROCEDURE ("").  /* redisplay any newly viewed fields. */
    */
  END. /* IF...LAYOUT...ne cLayout... */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableObject Procedure 
PROCEDURE disableObject :
/* -----------------------------------------------------------------------------
      Purpose:     Disables all enabled objects in the frame.
                   Note that this includes RowObject fields if any.
      Parameters:  <none>
      Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEnabledObjHdls AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iField          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lObjectHidden   AS LOGICAL   NO-UNDO.  

  {get EnabledObjHdls cEnabledObjHdls}.
  IF cEnabledObjHdls NE "":U THEN
  DO iField = 1 TO NUM-ENTRIES(cEnabledObjHdls):
     hField = WIDGET-HANDLE(ENTRY(iField, cEnabledObjHdls)).

     /* Cater for local SDF's */
     IF hField:TYPE EQ "PROCEDURE":U THEN
     DO:
         {get ObjectHidden lObjectHidden}.
         IF NOT lObjectHidden THEN
             RUN DisableField IN hField.
     END. /* Procedure: SDF */
     ELSE
     IF CAN-SET(hField, "HIDDEN":U) AND
        NOT hField:HIDDEN THEN   /* Skip fields hidden for multi-layout etc.*/
         ASSIGN hField:SENSITIVE = NO.
  END.   /* END DO iField */
    
  RUN disableFields IN TARGET-PROCEDURE ("ALL":U) NO-ERROR.
  {set ObjectEnabled no}.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObject Procedure 
PROCEDURE enableObject :
/* -----------------------------------------------------------------------------
      Purpose:    Enable an object - all components except RowObject fields,
                  which are enabled using EnableFields().
      Parameters:  <none>
      Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cEnabledObjHdls AS CHARACTER                         NO-UNDO.
    DEFINE VARIABLE iField          AS INTEGER                           NO-UNDO.
    DEFINE VARIABLE hField          AS HANDLE                            NO-UNDO.
    DEFINE VARIABLE lObjectHidden   AS LOGICAL                          NO-UNDO.

    {get EnabledObjHdls cEnabledObjHdls}.
    IF cEnabledObjHdls NE "":U THEN
    DO iField = 1 TO NUM-ENTRIES(cEnabledObjHdls):
        ASSIGN hField = WIDGET-HANDLE(ENTRY(iField, cEnabledObjHdls)).

        /* Cater for local SDF's */
        IF hField:TYPE EQ "PROCEDURE":U THEN
        DO:
            {get ObjectHidden lObjectHidden}.
            IF NOT lObjectHidden THEN
                RUN enableField IN hField.
        END. /* Procedure: SDF */
        ELSE
        IF CAN-SET(hField, "HIDDEN":U) AND
           NOT hField:HIDDEN THEN   /* Skip fields hidden for multi-layout etc.*/
            ASSIGN hField:SENSITIVE = YES.
    END.    /* loop thorough handles */

    {set ObjectEnabled yes}.  

    /* We also run enable_UI from here. */ 
    RUN enable_UI IN TARGET-PROCEDURE NO-ERROR.
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:  Initialization code specific to visualizations.
   Params:  <none>
    Notes:  Enables and views the object depending on the values of 
            DisableOnInit and HideOnInit instance properties.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHideOnInit        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lDisableOnInit     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cLayout            AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE hContainer         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSource            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cEnabledObjFlds    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledObjHdls    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFrameField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cResult            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lResult            AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cAllFieldHandles   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAllFieldNames     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainerSource   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iSDFLoop           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cContainerTargets  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDFHandle         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSDFFrameHandle    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrameProc         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cFieldName         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFrameHandles      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFrame             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSDF               AS INTEGER   NO-UNDO.

  RUN SUPER.
 
  IF RETURN-VALUE = "ADM-ERROR":U THEN 
    RETURN "ADM-ERROR":U.

  /* Skip all intiialization except viewing in design mode. */
  {get UIBMode cResult}.
  IF cResult BEGINS "Design":U THEN
  DO:
    RUN viewObject IN TARGET-PROCEDURE.
    RETURN.                      
  END.       /* END DO design mode */
       
  /* Set the procedure's CURRENT-WINDOW to its parent window container
     (which may be several levels up). This will assure correct parenting
     of alert boxes, etc. */
  {get ContainerHandle hContainer}.
  IF NOT VALID-HANDLE(hContainer) THEN
    RETURN.       /* If no container then skip all visual initialization. */
 
  hParent = hContainer.
  
  IF hContainer:TYPE = "Window":U THEN 
    {get WindowFrameHandle hFrame}.
  ELSE 
    hFrame = hContainer. 
  
  DO WHILE VALID-HANDLE(hParent:PARENT) AND hParent:TYPE NE "WINDOW":U:
    hParent = hParent:PARENT.
  END.
  
  IF VALID-HANDLE(hParent) AND hParent:TYPE = "WINDOW":U THEN
     TARGET-PROCEDURE:CURRENT-WINDOW = hParent.
  
  /* Build a list of frame handles corresponding to containertargets list to use 
     later when checking for SmartObjects  */
  cContainerTargets = DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "Container-Target":U) NO-ERROR.
  
  IF cContainerTargets <> "":U THEN 
  DO:
    cFrameHandles = FILL(",":U, NUM-ENTRIES(cContainerTargets) - 1).
    DO iSDFLoop = 1 TO NUM-ENTRIES(cContainerTargets):
      ASSIGN
        hSDFHandle      = WIDGET-HANDLE(ENTRY(iSDFLoop,cContainerTargets)).
        hSDFFramehandle = ?. 
      
      IF VALID-HANDLE(hSDFHandle) THEN
      DO:
        {get ContainerHandle hSDFFrameHandle hSDFHandle}.  
      END.
      /* if the containerHandle is a child of this object's frame then add it to the list */   
      ENTRY(iSDFLoop,cFrameHandles) = IF VALID-HANDLE(hSDFFrameHandle)
                                      AND hSDFFrameHandle:TYPE = 'FRAME':U 
                                      AND hFrame = hSDFFrameHandle:FRAME
                                      THEN STRING(hSDFFrameHandle)
                                      ELSE "?":U.

    END. /* end isdfloop */
  END. /* end if ccontainertargets <> ""*/ 
  
    /* Build a list of the handles of ENABLED-OBJECTS, for enable/disableObject.
     These are *non*-db fields. */
  IF VALID-HANDLE(hFrame) AND hFrame:FIRST-CHILD NE ? THEN  
  DO:
    {get EnabledObjFlds cEnabledObjFlds}.
  
    /* Ensure that the order of the fields and handles is the same. */
    ASSIGN 
      cEnabledObjHdls = FILL(",":U, NUM-ENTRIES(cEnabledObjFlds) - 1)
      hFrameField = hFrame:FIRST-CHILD          /* Field Group */
      hFrameField = hFrameField:FIRST-CHILD.   /* First actual field. */
 
    DO WHILE VALID-HANDLE(hFrameField):        
      IF LOOKUP(hFrameField:NAME, cEnabledObjFlds) > 0 THEN 
      DO:
        IF LOOKUP(hFrameField:TYPE,"FILL-IN,RADIO-SET,EDITOR,COMBO-BOX,SELECTION-LIST,SLIDER,TOGGLE-BOX,BROWSE,BUTTON":U) NE 0 THEN 
          ENTRY(LOOKUP(hFrameField:NAME, cEnabledObjFlds), cEnabledObjHdls) = STRING(hFrameField).
        
        /* If not a 'supported' field widget, delete it from the enabledObjFlds list and 
           ensure the enabledObjHdls list that was preset with entries above is in synch */ 
        ELSE 
          ASSIGN
            cEnabledObjHdls = DYNAMIC-FUNCTION ('deleteEntry':U IN TARGET-PROCEDURE, LOOKUP(hFrameField:NAME, cEnabledObjFlds),  cEnabledObjHdls, ",":U) 
            cEnabledObjFlds = DYNAMIC-FUNCTION ('deleteEntry':U IN TARGET-PROCEDURE, LOOKUP(hFrameField:NAME, cEnabledObjFlds),  cEnabledObjFlds, ",":U).       
      END. /* end if hFrameField:name... */

      /* Assign the SDF's PROCEDURE Handle and not the FRAME Handle */
      /* Check for existance of SDFs */
      ASSIGN
        cFieldName = "":U
        hFrameProc = ?.
      
      IF hFrameField:TYPE = "FRAME":U AND cContainerTargets <> "":U THEN
      DO:
        /* If this is a SmartObject (one of the frames we found in the container targets) 
           then we need to use the proc handle and field name or objectname in the lists */
        iSDF = LOOKUP(STRING(hFrameField),cFrameHandles).
        IF iSDF > 0 THEN
        DO:
          hFrameProc = WIDGET-HANDLE(ENTRY(iSDF,cContainerTargets)).
          IF VALID-HANDLE(hFrameProc) THEN 
          DO:
            cFieldName = DYNAMIC-FUNCTION('getFieldName':U IN hFrameProc) NO-ERROR.
            IF cFieldName = ? THEN
              cFieldName = DYNAMIC-FUNCTION('getObjectName':U IN hFrameProc) NO-ERROR. 
            /* SDFs are currently not in the object list, but ...  */
            ENTRY(LOOKUP(cFieldName, cEnabledObjFlds), cEnabledObjHdls) = STRING(hFrameProc) NO-ERROR.
            ENTRY(LOOKUP(cFieldName, cEnabledObjFlds), cEnabledObjFLds) = cFieldName NO-ERROR.
          END.
        END.
      END.
      ELSE
        hFrameProc = ?.
             
      ASSIGN
        cAllFieldHandles = cAllFieldHandles 
                         + (IF cAllFieldHandles <> "":U THEN ",":U ELSE "":U)
                         + (IF hFrameProc = ? 
                            THEN STRING(hFrameField) 
                            ELSE STRING(hFrameProc))
        cAllFieldNames   = cAllFieldNames 
                         + (IF cAllFieldNames <> "":U THEN ",":U ELSE "":U) 
                         + (IF cFieldName <> "":U 
                            THEN cFieldName 
                            ELSE IF CAN-QUERY(hFrameField,"name":U) AND hFrameField:NAME <> ? 
                                 THEN hFrameField:NAME 
                                 ELSE "?":U )
        hFrameField = hFrameField:NEXT-SIBLING .                              
    END.

    /* Strip out any invalid handles. */
    ASSIGN cEnabledObjHdls = TRIM(cEnabledObjHdls, ",":U).

    {set EnabledObjHdls cEnabledObjHdls}.
    {set EnabledObjFlds cEnabledObjFlds}.    /* we might have deleted text fields*/
    {set AllFieldHandles cAllFieldHandles}.
    {set AllFieldNames cAllFieldNames}.
 
  END.  /* if valid-handle(container) */

  
  IF hContainer:TYPE <> "window":U THEN
  DO:
    {get DisableOnInit lDisableOnInit}.   
    IF NOT lDisableOnInit THEN
      RUN enableObject IN TARGET-PROCEDURE. 
  END.

   /* Before Viewing, change the object to the correct layout
     if there are multiple layouts.  */
  {get LayoutVariable cLayout}.
  IF cLayout NE "":U THEN
  DO:
    {get ObjectLayout cLayout}.
    IF cLayout NE "":U THEN 
      RUN applyLayout IN TARGET-PROCEDURE.
    ELSE DO:  
      {get defaultLayout cLayout}.
      IF cLayout ne "":U THEN DO:
        {set ObjectLayout cLayout}.
        RUN applyLayout IN TARGET-PROCEDURE. 
      END.   /* END DO IF NE "" */
    END.     /* END ELSE DO     */
  END.       /* END DO IF LayoutVariable */
  
  IF hContainer:TYPE <> "window":U THEN
  DO:
    {get HideOnInit lHideOnInit}.
    IF NOT lHideOnInit THEN 
      RUN viewObject IN TARGET-PROCEDURE.
    ELSE 
      PUBLISH "LinkState":U FROM TARGET-PROCEDURE ('inactive':U).
  END.

  /* set-up widgets */
  {get ContainerSource hContainerSource}.
  IF NOT VALID-HANDLE(hContainerSource) THEN 
    ASSIGN hContainerSource = TARGET-PROCEDURE.
  
  IF hContainer:TYPE = "window":U THEN
    hContainer = hContainer:FIRST-CHILD.
  
  IF VALID-HANDLE(hContainer) AND VALID-HANDLE(gshSessionManager) THEN
    RUN widgetWalk IN gshSessionManager (INPUT hContainerSource, 
                                         INPUT TARGET-PROCEDURE, 
                                         INPUT hContainer, 
                                         INPUT "setup":U).

  RETURN.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initWinColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initWinColors Procedure 
PROCEDURE initWinColors :
/*------------------------------------------------------------------------------
  Purpose:  Defines 3D colors dynamically    
  Parameters:  <none>
  Notes:    These are class properties so this is run from the main block    
------------------------------------------------------------------------------*/
  giColor3DFace = {fnarg createDynamicColor 'Color3DFace':U}.
  IF giColor3DFace = ? THEN
    giColor3DFace = 8. /* default to Grey */
  
  giColor3DHighLight = {fnarg createDynamicColor 'Color3DHighLight':U}.
  IF giColor3DHighLight = ? THEN
    giColor3DHighLight = 15. /* default to White */

  giColor3DShadow = {fnarg createDynamicColor 'Color3DShadow':U}.
  IF giColor3DShadow = ? THEN
    giColor3DShadow = 7. /* default to DarkGrey */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processAction Procedure 
PROCEDURE processAction :
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure to process keyboard and mouse actions for
               visual objects.
  Parameters:  input name of action
  Notes:       Typically a generic event will be put in visualcustom.i that
               will run this procedure in order to do the work. It can not do the
               work nornmally itself as container handles, etc. are not valid
               yet. Also this keeps the code size down.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcAction               AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hContainerSource              AS HANDLE     NO-UNDO.

{get containersource hContainerSource}.
IF NOT VALID-HANDLE(hContainerSource) THEN 
  ASSIGN hContainerSource = TARGET-PROCEDURE.

CASE pcAction:
  WHEN "Ctrl-page-up":U THEN
    PUBLISH "selectPrevTab":U FROM hContainerSource.
  WHEN "ctrl-page-down":U THEN
    PUBLISH "selectNextTab":U FROM hContainerSource.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-createDynamicColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createDynamicColor Procedure 
FUNCTION createDynamicColor RETURNS INTEGER
  ( pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Creates a Progress 3D color in the color-table and returns its 
           number.
Parameter: pcName - colorname to add to the ADM section in .ini                         
    Notes: Returns unknown if the color could not be created.
         - The color is added to the color-table ans the .ini file if it 
           doesn't exist, menaing that this code is the originator of the 
           entry in the .ini.
         - It is also possible to manually add or change the entries in 
           the .ini to point to some other color. This color will be made 
           dynamic unless it is one of the 16 (0 - 15) reserved colors.   
         - See initWinColors for usage  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColor      AS INTEGER    NO-UNDO.
  
  GET-KEY-VALUE SECTION 'ADM':U KEY pcName VALUE cValue.
  
  iColor = INT(cValue).
  
  IF iColor > 255 THEN 
    RETURN ?.
  
  /* If not defined or not enough entries in the color-table then add it */
  IF iColor = ? OR COLOR-TABLE:NUM-ENTRIES < iColor + 1 THEN
  DO:
    /* If undefined; get new number and add it to the ini file. */
    IF iColor = ? THEN
    DO:
      iColor = COLOR-TABLE:NUM-ENTRIES.    
      /* only put to 'adm' section if within max entries */
      IF iColor < 256 THEN
        PUT-KEY-VALUE SECTION 'ADM':U KEY pcName VALUE STRING(iColor).
      ELSE iColor = ?.
    END.
    
    /* add an entry to the color table */
    IF iColor <> ? THEN
      COLOR-TABLE:NUM-ENTRIES = iColor + 1.  
  END.
  
  /* Don't mess with the default ADE colors */ 
  IF iColor > 15 THEN
    COLOR-TABLE:SET-DYNAMIC(iColor,TRUE).  

  RETURN iColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAllFieldHandles Procedure 
FUNCTION getAllFieldHandles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get allFieldHandles cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAllFieldNames Procedure 
FUNCTION getAllFieldNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get allFieldNames cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCol) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCol Procedure 
FUNCTION getCol RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the Col(umn) of the object 
    Notes: Use repositionObject to set the COL.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.

  RETURN IF VALID-HANDLE(hContainer) THEN hContainer:COL ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DFace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColor3DFace Procedure 
FUNCTION getColor3DFace RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iRGB AS INTEGER    NO-UNDO.
 RUN GetSysColor ({&COLOR_3DFACE}, OUTPUT iRGB). 
 COLOR-TABLE:SET-RGB-VALUE(giColor3DFace,iRGB) NO-ERROR.
 RETURN giColor3DFace.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DHighLight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColor3DHighLight Procedure 
FUNCTION getColor3DHighLight RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRGB AS INTEGER    NO-UNDO.
  RUN GetSysColor ({&COLOR_3DHIGHLIGHT}, OUTPUT iRGB). 
  COLOR-TABLE:SET-RGB-VALUE(giColor3DHighLight,iRGB) NO-ERROR. 
  RETURN giColor3DHighLight.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DShadow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColor3DShadow Procedure 
FUNCTION getColor3DShadow RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRGB AS INTEGER    NO-UNDO.
  RUN GetSysColor ({&COLOR_3DSHADOW}, OUTPUT iRGB). 
  COLOR-TABLE:SET-RGB-VALUE(giColor3DShadow,iRGB) NO-ERROR.

  RETURN giColor3DShadow.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDefaultLayout Procedure 
FUNCTION getDefaultLayout RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the default for this object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cDefault AS CHARACTER NO-UNDO.
  {get DefaultLayout cDefault}.
  RETURN cDefault.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisableOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisableOnInit Procedure 
FUNCTION getDisableOnInit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether the current object should be
            left disabled when it is first initialized.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lDisable AS LOGICAL NO-UNDO.
  {get DisableOnInit lDisable}.
  RETURN lDisable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjFlds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledObjFlds Procedure 
FUNCTION getEnabledObjFlds RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the field names of widgets enabled in this object
            not associated with data fields.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.
  {get EnabledObjFlds cFields}.
  RETURN cFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjHdls) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledObjHdls Procedure 
FUNCTION getEnabledObjHdls RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the handles of widgets enabled in this object
            not associated with data fields.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cHdls AS CHARACTER NO-UNDO.
  {get EnabledObjHdls cHdls}.
  RETURN cHdls.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldSecurity Procedure 
FUNCTION getFieldSecurity RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value  (in a list form, comma-seperated) 
            of the security type corresponding to AllFieldHandles.
            <security type>,<security type>...
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSecurityType AS CHARACTER NO-UNDO.
  {get FieldSecurity cSecurityType}.
  RETURN cSecurityType.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHeight Procedure 
FUNCTION getHeight RETURNS DECIMAL
    (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the height of the object 
    Notes: Use resizeObject to set the height. 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hContainer              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dHeight                 AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE lDynamicObject          AS LOGICAL                  NO-UNDO.

    ASSIGN dHeight = ?.

    {get ContainerHandle hContainer}.

    IF VALID-HANDLE(hContainer) AND
       hContainer:TYPE = "FRAME":U THEN
    DO:
        {get DynamicObject lDynamicObject}.
        
        IF lDynamicObject THEN
            {get MinHeight dHeight}.
        ELSE
            ASSIGN dHeight = hContainer:HEIGHT.
    END.    /* Frame */
    ELSE
    IF VALID-HANDLE(hContainer) THEN 
        ASSIGN dHeight = hContainer:HEIGHT.

    RETURN dHeight.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLayoutOptions Procedure 
FUNCTION getLayoutOptions RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of multi-layout options for the 
            object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLayout AS CHARACTER NO-UNDO.
  {get LayoutOptions cLayout}.
  RETURN cLayout.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutVariable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLayoutVariable Procedure 
FUNCTION getLayoutVariable RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the &LAYOUT-VARIABLE preprocessor for the 
            object, which is used as a prefix to the name of the procedure 
            which resets it.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLayout AS CHARACTER NO-UNDO.
  {get LayoutVariable cLayout}.
  RETURN cLayout.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMinHeight Procedure 
FUNCTION getMinHeight RETURNS DECIMAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the pre-determined minimum height of a visual object
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dHeight             AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lDynamicObject      AS LOGICAL    NO-UNDO.
    
    {get DynamicObject lDynamicObject}.

    IF lDynamicObject THEN DO:
      &SCOPED-DEFINE xpMinHeight
      {get MinHeight dHeight}.
      &UNDEFINE xpMinHeight
    END.
    ELSE
      {get Height dHeight}.

    RETURN dHeight.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMinWidth Procedure 
FUNCTION getMinWidth RETURNS DECIMAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the pre-determined minimum width of a visual object
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dWidth              AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lDynamicObject      AS LOGICAL    NO-UNDO.
    
    {get DynamicObject lDynamicObject}.

    IF lDynamicObject THEN DO:
      &SCOPED-DEFINE xpMinWidth
      {get MinWidth dWidth}.
      &UNDEFINE xpMinWidth
    END.
    ELSE
      {get Width dWidth}.

    RETURN dWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectEnabled Procedure 
FUNCTION getObjectEnabled RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether the current object is enabled.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lEnabled AS LOGICAL NO-UNDO.
  {get ObjectEnabled lEnabled}.
  RETURN lEnabled.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectLayout Procedure 
FUNCTION getObjectLayout RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current Layout Name for the object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLayout AS CHARACTER NO-UNDO.
  {get ObjectLayout cLayout}.
  RETURN cLayout.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeHorizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResizeHorizontal Procedure 
FUNCTION getResizeHorizontal RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE of the object can be resized horizontal
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lResizeHorizontal AS LOGICAL NO-UNDO.

    {get ResizeHorizontal lResizeHorizontal}.

    RETURN lResizeHorizontal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeVertical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResizeVertical Procedure 
FUNCTION getResizeVertical RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE of the object can be resized vertical
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lResizeVertical AS LOGICAL NO-UNDO.

    {get ResizeVertical lResizeVertical}.

    RETURN lResizeVertical.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRow Procedure 
FUNCTION getRow RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the height of the object 
    Notes: Use repositionObject to set the Row.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.

  RETURN IF VALID-HANDLE(hContainer) THEN hContainer:ROW ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidth Procedure 
FUNCTION getWidth RETURNS DECIMAL
    (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the width of the object 
    Notes: Use resizeObject to set the Width. 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hContainer              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dWidth                  AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE lDynamicObject          AS LOGICAL                  NO-UNDO.

    ASSIGN dWidth = ?.

    {get ContainerHandle hContainer}.

    IF VALID-HANDLE(hContainer) AND
       hContainer:TYPE = "FRAME":U THEN
    DO:
        {get DynamicObject lDynamicObject}.
        
        IF lDynamicObject THEN
            {get MinWidth dWidth}.
        ELSE
            ASSIGN dWidth = hContainer:WIDTH.
    END.    /* Frame */
    ELSE
    IF VALID-HANDLE(hContainer) THEN 
        ASSIGN dWidth = hContainer:WIDTH.

    RETURN dWidth.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAllFieldHandles Procedure 
FUNCTION setAllFieldHandles RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:    
    Notes:   
------------------------------------------------------------------------------*/
  {set AllFieldHandles pcValue}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAllFieldNames Procedure 
FUNCTION setAllFieldNames RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:    
    Notes:   
------------------------------------------------------------------------------*/
  {set AllFieldNames pcValue}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultLayout Procedure 
FUNCTION setDefaultLayout RETURNS LOGICAL
  ( pcDefault AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  sets the default layout name for this object.
   Params:  pcDefault AS CHARACTER
------------------------------------------------------------------------------*/

  {set DefaultLayout pcDefault}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisableOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisableOnInit Procedure 
FUNCTION setDisableOnInit RETURNS LOGICAL
  ( plDisable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a flag indicating whether the object should be disabled when
            it's first realized.
   Params:  plDisable AS LOGICAL -- true if object should be disabled on init.
------------------------------------------------------------------------------*/
  {set DisableOnInit plDisable}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledObjFlds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnabledObjFlds Procedure 
FUNCTION setEnabledObjFlds RETURNS LOGICAL
    ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:    
    Notes:   
------------------------------------------------------------------------------*/
    {set EnabledObjFlds pcValue}.

    RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldSecurity Procedure 
FUNCTION setFieldSecurity RETURNS LOGICAL
  ( pcSecurityType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a character value  (in a list form, comma-seperated) 
            of the security type corresponding to AllFieldHandles.
            e.g. <security type>,<security type>...
   Params:  <none>
------------------------------------------------------------------------------*/
  
  {set FieldSecurity pcSecurityType}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHideOnInit Procedure 
FUNCTION setHideOnInit RETURNS LOGICAL
  ( plHide AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a flag indicating whether the object should be hidden when
            it's first realized.
   Params:  plHide AS LOGICAL -- true if the object should hidden when first
            initialized.
    Notes:  basic Visual Object property.
------------------------------------------------------------------------------*/
  {set HideOnInit plHide}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLayoutOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLayoutOptions Procedure 
FUNCTION setLayoutOptions RETURNS LOGICAL
  ( pcOptions AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of different multi-layout option names for this object.
   Params:  pcOptions AS CHARACTER -- comma-separated list of layout names.  
------------------------------------------------------------------------------*/

  {set LayoutOptions pcOptions}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMinHeight Procedure 
FUNCTION setMinHeight RETURNS LOGICAL
    ( INPUT pdHeight            AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the minimum height of a visual object
    Notes:  
------------------------------------------------------------------------------*/
    &SCOPED-DEFINE xpMinHeight
    {set MinHeight pdHeight}.
    &UNDEFINE xpMinHeight

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMinWidth Procedure 
FUNCTION setMinWidth RETURNS LOGICAL
    ( INPUT pdWidth            AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the minimum width of a visual object
    Notes:  
------------------------------------------------------------------------------*/
    
    &SCOPED-DEFINE xpMinWidth
    {set MinWidth pdWidth}.
    &UNDEFINE xpMinWidth

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectLayout Procedure 
FUNCTION setObjectLayout RETURNS LOGICAL
  ( pcLayout AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Layout of the object for Alternate Layout support.
   Params:  <none>
------------------------------------------------------------------------------*/

  {set ObjectLayout pcLayout}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResizeHorizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setResizeHorizontal Procedure 
FUNCTION setResizeHorizontal RETURNS LOGICAL
  ( INPUT plResizeHorizontal AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets TRUE of the object can be resized horizontally
    Notes:  
------------------------------------------------------------------------------*/
    {set ResizeHorizontal plResizeHorizontal}.

    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResizeVertical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setResizeVertical Procedure 
FUNCTION setResizeVertical RETURNS LOGICAL
  ( INPUT plResizeVertical AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets TRUE of the object can be resized vertically
    Notes:  
------------------------------------------------------------------------------*/

    {set ResizeVertical plResizeVertical}.

    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

