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
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell visattr.i that this is the Super procedure. */
   &SCOP ADMSuper visual.p

  {src/adm2/custom/visualexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getCol) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCol Procedure 
FUNCTION getCol RETURNS DECIMAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHeight Procedure 
FUNCTION getHeight RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHideOnInit Procedure 
FUNCTION getHideOnInit RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-setObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectLayout Procedure 
FUNCTION setObjectLayout RETURNS LOGICAL
  ( pcLayout AS CHARACTER )  FORWARD.

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

{src/adm2/visprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

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
    IF cLayoutVar ne "Master Layout":U 
    THEN RUN VALUE(cLayoutVar + "s":U) IN TARGET-PROCEDURE ("Master Layout":U).
    /* Now change to the desired layout. */
    IF cLayout ne "Master Layout":U 
    THEN RUN VALUE(cLayoutVar + "s":U) IN TARGET-PROCEDURE (cLayout).
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
   
  {get EnabledObjHdls cEnabledObjHdls}.
  IF cEnabledObjHdls NE "":U THEN
  DO iField = 1 TO NUM-ENTRIES(cEnabledObjHdls):
     hField = WIDGET-HANDLE(ENTRY(iField, cEnabledObjHdls)).
     IF NOT hField:HIDDEN THEN   /* Skip fields hidden for multi-layout etc. */
       hField:SENSITIVE = no.
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

  DEFINE VARIABLE cEnabledObjHdls AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iField          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE    NO-UNDO.
  
    {get EnabledObjHdls cEnabledObjHdls}.
    IF cEnabledObjHdls NE "":U THEN
    DO iField = 1 TO NUM-ENTRIES(cEnabledObjHdls):
       hField = WIDGET-HANDLE(ENTRY(iField, cEnabledObjHdls)).
       IF NOT hField:HIDDEN THEN   /* Skip fields hidden for multi-layout etc.*/
         hField:SENSITIVE = yes.
    END.

    {set objectEnabled yes}.  
      
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

  DEFINE VARIABLE lHideOnInit      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lDisableOnInit   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cLayout          AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE hContainer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSource          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cEnabledObjFlds  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledObjHdls  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFrameField      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cResult          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lResult          AS LOGICAL   NO-UNDO.
  
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
   DO WHILE VALID-HANDLE(hParent:PARENT) AND hParent:TYPE NE "WINDOW":U:
     hParent = hParent:PARENT.
   END.
   IF VALID-HANDLE(hParent) AND hParent:TYPE = "WINDOW":U THEN
     TARGET-PROCEDURE:CURRENT-WINDOW = hParent.
   
  /* Build a list of the handles of ENABLED-OBJECTS, for enable/disableObject.
     These are *non*-db fields. */
  {get EnabledObjFlds cEnabledObjFlds}.
  IF cEnabledObjFlds NE "":U AND VALID-HANDLE(hContainer) AND 
    hContainer:FIRST-CHILD NE ? THEN  
  DO:
    ASSIGN hFrameField = hContainer:FIRST-CHILD     /* Field Group */
           hFrameField = hFrameField:FIRST-CHILD.   /* First actual field. */
         
    DO WHILE VALID-HANDLE(hFrameField):
      IF LOOKUP(hFrameField:TYPE,
    "FILL-IN,RADIO-SET,EDITOR,COMBO-BOX,SELECTION-LIST,SLIDER,TOGGLE-BOX,BROWSE,BUTTON":U)
        NE 0 AND hFrameField:TABLE EQ ? AND
          LOOKUP(hFrameField:NAME, cEnabledObjFlds) NE 0 THEN
            cEnabledObjHdls = cEnabledObjHdls + 
             (IF cEnabledObjHdls NE "":U THEN ",":U ELSE "":U) + STRING(hFrameField). 
    hFrameField = hFrameField:NEXT-SIBLING.
    END.
    {set EnabledObjHdls cEnabledObjHdls}.
  END.    /* END DO for EnabledObjFlds */
  
  {get HideOnInit lHideOnInit}.
  {get DisableOnInit lDisableOnInit}.
  
  IF NOT lDisableOnInit THEN
     RUN enableObject IN TARGET-PROCEDURE. 

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


  IF NOT lHideOnInit THEN 
     RUN viewObject IN TARGET-PROCEDURE.
  RETURN.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

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

&IF DEFINED(EXCLUDE-getHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHeight Procedure 
FUNCTION getHeight RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the height of the object 
    Notes: Use resizeObject to set the height. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.

  RETURN IF VALID-HANDLE(hContainer) THEN hContainer:HEIGHT ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHideOnInit Procedure 
FUNCTION getHideOnInit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether the current object should be
            left hidden when it is first initialized.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lHide AS LOGICAL NO-UNDO.
  {get HideOnInit lHide}.
  RETURN lHide.

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
    Notes: Use resizeObject to set the width.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.

  RETURN IF VALID-HANDLE(hContainer) THEN hContainer:WIDTH ELSE ?.    
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

