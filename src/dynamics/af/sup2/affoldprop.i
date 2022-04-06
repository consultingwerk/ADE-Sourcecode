&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : affoldprop.i

    Purpose     : Get/Set Properties for folders
                  Copied from SmartPak3 src/adm2/FoldProp.i File

    Syntax      : af/sup2/affoldprop.i

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderLabels Include 
FUNCTION getFolderLabels RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderMenu Include 
FUNCTION getFolderMenu RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderTabType Include 
FUNCTION getFolderTabType RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHotkey Include 
FUNCTION getHotkey RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageDisabled Include 
FUNCTION getImageDisabled RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageEnabled Include 
FUNCTION getImageEnabled RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageHeight Include 
FUNCTION getImageHeight RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageWidth Include 
FUNCTION getImageWidth RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageXOffset Include 
FUNCTION getImageXOffset RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageYOffset Include 
FUNCTION getImageYOffset RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInheritColor Include 
FUNCTION getInheritColor RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabelOffset Include 
FUNCTION getLabelOffset RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageTarget Include 
FUNCTION getPageTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageTargetEvents Include 
FUNCTION getPageTargetEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelOffset Include 
FUNCTION getPanelOffset RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupSelectionEnabled Include 
FUNCTION getPopupSelectionEnabled RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectorBGcolor Include 
FUNCTION getSelectorBGcolor RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectorFGcolor Include 
FUNCTION getSelectorFGcolor RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectorFont Include 
FUNCTION getSelectorFont RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectorWidth Include 
FUNCTION getSelectorWidth RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabBGcolor Include 
FUNCTION getTabBGcolor RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabEnabled Include 
FUNCTION getTabEnabled RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabFGcolor Include 
FUNCTION getTabFGcolor RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabFont Include 
FUNCTION getTabFont RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabHeight Include 
FUNCTION getTabHeight RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabHidden Include 
FUNCTION getTabHidden RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabINColor Include 
FUNCTION getTabINColor RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabPosition Include 
FUNCTION getTabPosition RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabSize Include 
FUNCTION getTabSize RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabsPerRow Include 
FUNCTION getTabsPerRow RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabVisualization Include 
FUNCTION getTabVisualization RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTooltip Include 
FUNCTION getTooltip RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getVisibleRows Include 
FUNCTION getVisibleRows RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderLabels Include 
FUNCTION setFolderLabels RETURNS LOGICAL
  ( pcLabels AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderMenu Include 
FUNCTION setFolderMenu RETURNS LOGICAL
  ( INPUT pFolderMenu AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderTabType Include 
FUNCTION setFolderTabType RETURNS LOGICAL
  ( piTabType AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHotkey Include 
FUNCTION setHotkey RETURNS LOGICAL
  ( INPUT pHotkey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageDisabled Include 
FUNCTION setImageDisabled RETURNS LOGICAL
  ( INPUT pImageDisabled AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageEnabled Include 
FUNCTION setImageEnabled RETURNS LOGICAL
  ( INPUT pImageEnabled AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageHeight Include 
FUNCTION setImageHeight RETURNS LOGICAL
  ( INPUT pImageHeight AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageWidth Include 
FUNCTION setImageWidth RETURNS LOGICAL
  ( INPUT pImageWidth AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageXOffset Include 
FUNCTION setImageXOffset RETURNS LOGICAL
  ( INPUT pImageXOffset AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageYOffset Include 
FUNCTION setImageYOffset RETURNS LOGICAL
  ( INPUT pImageYOffset AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInheritColor Include 
FUNCTION setInheritColor RETURNS LOGICAL
  ( INPUT pInheritColor AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabelOffset Include 
FUNCTION setLabelOffset RETURNS LOGICAL
  ( INPUT pLabelOffset AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPageTarget Include 
FUNCTION setPageTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPanelOffset Include 
FUNCTION setPanelOffset RETURNS LOGICAL
  ( INPUT pPanelOffset AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPopupSelectionEnabled Include 
FUNCTION setPopupSelectionEnabled RETURNS LOGICAL
  (plValue AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectorBGcolor Include 
FUNCTION setSelectorBGcolor RETURNS LOGICAL
  ( INPUT pSelectorBGcolor AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectorFGcolor Include 
FUNCTION setSelectorFGcolor RETURNS LOGICAL
  ( INPUT pSelectorFGcolor AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectorFont Include 
FUNCTION setSelectorFont RETURNS LOGICAL
  ( INPUT pSelectorFont AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectorWidth Include 
FUNCTION setSelectorWidth RETURNS LOGICAL
  ( INPUT pSelectorWidth AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabBGcolor Include 
FUNCTION setTabBGcolor RETURNS LOGICAL
  ( INPUT pTabBGcolor AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabEnabled Include 
FUNCTION setTabEnabled RETURNS LOGICAL
  ( INPUT pTabEnabled AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabFGcolor Include 
FUNCTION setTabFGcolor RETURNS LOGICAL
  ( INPUT pTabFGcolor AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabFont Include 
FUNCTION setTabFont RETURNS LOGICAL
  ( INPUT pTabFont AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabHeight Include 
FUNCTION setTabHeight RETURNS LOGICAL
  ( INPUT pTabHeight AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabHidden Include 
FUNCTION setTabHidden RETURNS LOGICAL
  ( INPUT pTabHidden AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabINColor Include 
FUNCTION setTabINColor RETURNS LOGICAL
  ( INPUT pTabINcolor AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabPosition Include 
FUNCTION setTabPosition RETURNS LOGICAL
  ( INPUT pTabPosition AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabSize Include 
FUNCTION setTabSize RETURNS LOGICAL
  ( INPUT pTabSize AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabsPerRow Include 
FUNCTION setTabsPerRow RETURNS LOGICAL
  ( INPUT pTabsPerRow AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabVisualization Include 
FUNCTION setTabVisualization RETURNS LOGICAL
  (pcValue  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTooltip Include 
FUNCTION setTooltip RETURNS LOGICAL
  ( INPUT pTooltip AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setVisibleRows Include 
FUNCTION setVisibleRows RETURNS LOGICAL
  ( INPUT pVisibleRows AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Include 
/* ************************* Included-Libraries *********************** */

{af/sup2/afspcommfn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderLabels Include 
FUNCTION getFolderLabels RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the folder labels property.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pFolderLabels AS CHARACTER NO-UNDO.

{get FolderLabels pFolderLabels}.

RETURN pFolderLabels.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderMenu Include 
FUNCTION getFolderMenu RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pFolderMenu AS CHARACTER NO-UNDO.

{get FolderMenu pFolderMenu}.

RETURN pFolderMenu.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderTabType Include 
FUNCTION getFolderTabType RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the folder tab type, 1 or 2
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pFolderTabType AS INTEGER NO-UNDO.

{get FolderTabType pFolderTabType}.

RETURN pFolderTabType.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHotkey Include 
FUNCTION getHotkey RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pHotkey AS CHARACTER NO-UNDO.

{get Hotkey pHotkey}.

RETURN pHotkey.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageDisabled Include 
FUNCTION getImageDisabled RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pImageDisabled AS CHARACTER NO-UNDO.

{get ImageDisabled pImageDisabled}.

RETURN pImageDisabled.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageEnabled Include 
FUNCTION getImageEnabled RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pImageEnabled AS CHARACTER NO-UNDO.

{get ImageEnabled pImageEnabled}.

RETURN pImageEnabled.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageHeight Include 
FUNCTION getImageHeight RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pImageHeight AS INTEGER NO-UNDO.

{get ImageHeight pImageHeight}.

RETURN pImageHeight.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageWidth Include 
FUNCTION getImageWidth RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pImageWidth AS INTEGER NO-UNDO.

{get ImageWidth pImageWidth}.

RETURN pImageWidth.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageXOffset Include 
FUNCTION getImageXOffset RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pImageXOffset AS INTEGER NO-UNDO.

{get ImageXOffset pImageXOffset}.

RETURN pImageXOffset.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageYOffset Include 
FUNCTION getImageYOffset RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pImageYOffset AS INTEGER NO-UNDO.

{get ImageYOffset pImageYOffset}.

RETURN pImageYOffset.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInheritColor Include 
FUNCTION getInheritColor RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the folder tab type, 1 or 2
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pInheritColor AS LOGICAL NO-UNDO.

{get InheritColor pInheritColor}.

RETURN pInheritColor.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabelOffset Include 
FUNCTION getLabelOffset RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pLabelOffset AS INTEGER NO-UNDO.

{get LabelOffset pLabelOffset}.

RETURN pLabelOffset.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageTarget Include 
FUNCTION getPageTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the folder's "PageTarget", normally its container.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get PageTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageTargetEvents Include 
FUNCTION getPageTargetEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the events the folder expects to receive from
            its PageTarget (normally its container).
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get PageTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelOffset Include 
FUNCTION getPanelOffset RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pPanelOffset AS INTEGER NO-UNDO.

{get PanelOffset pPanelOffset}.

RETURN pPanelOffset.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupSelectionEnabled Include 
FUNCTION getPopupSelectionEnabled RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lValue  AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xpPopupSelectionEnabled
  {get PopupSelectionEnabled lValue}.
  &UNDEFINE xpPopupSelectionEnabled

  RETURN lValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectorBGcolor Include 
FUNCTION getSelectorBGcolor RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pSelectorBGColor AS CHARACTER NO-UNDO.

{get SelectorBGColor pSelectorBGColor}.

RETURN pSelectorBGColor.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectorFGcolor Include 
FUNCTION getSelectorFGcolor RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pSelectorFGColor AS CHARACTER NO-UNDO.

{get SelectorFGColor pSelectorFGColor}.

RETURN pSelectorFGColor.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectorFont Include 
FUNCTION getSelectorFont RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pSelectorFont AS INTEGER NO-UNDO.

{get SelectorFont pSelectorFont}.

RETURN pSelectorFont.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectorWidth Include 
FUNCTION getSelectorWidth RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pSelectorWidth AS INTEGER NO-UNDO.

{get SelectorWidth pSelectorWidth}.

RETURN pSelectorWidth.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabBGcolor Include 
FUNCTION getTabBGcolor RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabBGColor AS CHARACTER NO-UNDO.

{get TabBGColor pTabBGColor}.

RETURN pTabBGColor.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabEnabled Include 
FUNCTION getTabEnabled RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE pTabEnabled AS CHARACTER NO-UNDO.

    {get TabEnabled pTabEnabled}.

    RETURN pTabEnabled.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabFGcolor Include 
FUNCTION getTabFGcolor RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabFGColor AS CHARACTER NO-UNDO.

{get TabFGColor pTabFGColor}.

RETURN pTabFGColor.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabFont Include 
FUNCTION getTabFont RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabFont AS INTEGER NO-UNDO.

{get TabFont pTabFont}.

RETURN pTabFont.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabHeight Include 
FUNCTION getTabHeight RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabHeight AS INTEGER NO-UNDO.

{get TabHeight pTabHeight}.

RETURN pTabHeight.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabHidden Include 
FUNCTION getTabHidden RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabHidden AS CHARACTER NO-UNDO.

{get TabHidden pTabHidden}.

RETURN pTabHidden.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabINColor Include 
FUNCTION getTabINColor RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabINColor AS CHARACTER NO-UNDO.

{get TabINColor pTabINColor}.

RETURN pTabINColor.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabPosition Include 
FUNCTION getTabPosition RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabPosition AS CHARACTER NO-UNDO.

{get TabPosition pTabPosition}.
IF pTabPosition = "":U THEN
    ASSIGN pTabPosition = "UPPER":U.

RETURN pTabPosition.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabSize Include 
FUNCTION getTabSize RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabSize AS CHARACTER NO-UNDO.

{get TabSize pTabSize}.

RETURN pTabSize.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabsPerRow Include 
FUNCTION getTabsPerRow RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTabsPerRow AS INTEGER NO-UNDO.

{get TabsPerRow pTabsPerRow}.

RETURN pTabsPerRow.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabVisualization Include 
FUNCTION getTabVisualization RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue  AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xpTabVisualization
  {get TabVisualization cValue}.
  &UNDEFINE xpTabVisualization

  IF cValue = "":U THEN
      ASSIGN cValue = "TABS":U.

  RETURN cValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTooltip Include 
FUNCTION getTooltip RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pTooltip AS CHARACTER NO-UNDO.

{get Tooltip pTooltip}.

RETURN pTooltip.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getVisibleRows Include 
FUNCTION getVisibleRows RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE pVisibleRows AS INTEGER NO-UNDO.

{get VisibleRows pVisibleRows}.

RETURN pVisibleRows.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderLabels Include 
FUNCTION setFolderLabels RETURNS LOGICAL
  ( pcLabels AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets folder labels.
    Notes:  Basic folder property.
------------------------------------------------------------------------------*/

{set FolderLabels pcLabels}.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderMenu Include 
FUNCTION setFolderMenu RETURNS LOGICAL
  ( INPUT pFolderMenu AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
ASSIGN pFolderMenu = TRIM(pFolderMenu).

{set FolderMenu pFolderMenu}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderTabType Include 
FUNCTION setFolderTabType RETURNS LOGICAL
  ( piTabType AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the folder tab type to 1 or 2
    Notes:  
------------------------------------------------------------------------------*/

{set FolderTabType piTabType}.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHotkey Include 
FUNCTION setHotkey RETURNS LOGICAL
  ( INPUT pHotkey AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set Hotkey pHotkey}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageDisabled Include 
FUNCTION setImageDisabled RETURNS LOGICAL
  ( INPUT pImageDisabled AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set ImageDisabled pImageDisabled}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageEnabled Include 
FUNCTION setImageEnabled RETURNS LOGICAL
  ( INPUT pImageEnabled AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set ImageEnabled pImageEnabled}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageHeight Include 
FUNCTION setImageHeight RETURNS LOGICAL
  ( INPUT pImageHeight AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set ImageHeight pImageHeight}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageWidth Include 
FUNCTION setImageWidth RETURNS LOGICAL
  ( INPUT pImageWidth AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set ImageWidth pImageWidth}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageXOffset Include 
FUNCTION setImageXOffset RETURNS LOGICAL
  ( INPUT pImageXOffset AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set ImageXOffset pImageXOffset}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageYOffset Include 
FUNCTION setImageYOffset RETURNS LOGICAL
  ( INPUT pImageYOffset AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set ImageYOffset pImageYOffset}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInheritColor Include 
FUNCTION setInheritColor RETURNS LOGICAL
  ( INPUT pInheritColor AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set InheritColor pInheritColor}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLabelOffset Include 
FUNCTION setLabelOffset RETURNS LOGICAL
  ( INPUT pLabelOffset AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set LabelOffset pLabelOffset}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPageTarget Include 
FUNCTION setPageTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the PageTarget object handle, normally the folder's container.
    Notes:  
------------------------------------------------------------------------------*/
{set PageTarget pcTarget}.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPanelOffset Include 
FUNCTION setPanelOffset RETURNS LOGICAL
  ( INPUT pPanelOffset AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set PanelOffset pPanelOffset}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPopupSelectionEnabled Include 
FUNCTION setPopupSelectionEnabled RETURNS LOGICAL
  (plValue AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpPopupSelectionEnabled
  {set PopupSelectionEnabled plValue}.
  &UNDEFINE xpPopupSelectionEnabled

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectorBGcolor Include 
FUNCTION setSelectorBGcolor RETURNS LOGICAL
  ( INPUT pSelectorBGcolor AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set SelectorBGcolor pSelectorBGcolor}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectorFGcolor Include 
FUNCTION setSelectorFGcolor RETURNS LOGICAL
  ( INPUT pSelectorFGcolor AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set SelectorFGcolor pSelectorFGcolor}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectorFont Include 
FUNCTION setSelectorFont RETURNS LOGICAL
  ( INPUT pSelectorFont AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set SelectorFont pSelectorFont}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectorWidth Include 
FUNCTION setSelectorWidth RETURNS LOGICAL
  ( INPUT pSelectorWidth AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set SelectorWidth pSelectorWidth}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabBGcolor Include 
FUNCTION setTabBGcolor RETURNS LOGICAL
  ( INPUT pTabBGcolor AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabBGcolor pTabBGcolor}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabEnabled Include 
FUNCTION setTabEnabled RETURNS LOGICAL
  ( INPUT pTabEnabled AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabEnabled pTabEnabled}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabFGcolor Include 
FUNCTION setTabFGcolor RETURNS LOGICAL
  ( INPUT pTabFGcolor AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabFGcolor pTabFGcolor}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabFont Include 
FUNCTION setTabFont RETURNS LOGICAL
  ( INPUT pTabFont AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabFont pTabFont}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabHeight Include 
FUNCTION setTabHeight RETURNS LOGICAL
  ( INPUT pTabHeight AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabHeight pTabHeight}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabHidden Include 
FUNCTION setTabHidden RETURNS LOGICAL
  ( INPUT pTabHidden AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabHidden pTabHidden}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabINColor Include 
FUNCTION setTabINColor RETURNS LOGICAL
  ( INPUT pTabINcolor AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabINcolor pTabINcolor}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabPosition Include 
FUNCTION setTabPosition RETURNS LOGICAL
  ( INPUT pTabPosition AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabPosition pTabPosition}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabSize Include 
FUNCTION setTabSize RETURNS LOGICAL
  ( INPUT pTabSize AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set TabSize pTabSize}.

RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabsPerRow Include 
FUNCTION setTabsPerRow RETURNS LOGICAL
  ( INPUT pTabsPerRow AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

ASSIGN pTabsPerRow = MINIMUM(MAXIMUM(1,pTabsPerRow),{&MAX-TABS}).

{set TabsPerRow pTabsPerRow}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabVisualization Include 
FUNCTION setTabVisualization RETURNS LOGICAL
  (pcValue  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpTabVisualization
  {set TabVisualization pcValue}.
  &UNDEFINE xpTabVisualization

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTooltip Include 
FUNCTION setTooltip RETURNS LOGICAL
  ( INPUT pTooltip AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set Tooltip pTooltip}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setVisibleRows Include 
FUNCTION setVisibleRows RETURNS LOGICAL
  ( INPUT pVisibleRows AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

ASSIGN pVisibleRows = MINIMUM(pVisibleRows,{&MAX-ROWS}).

IF pVisibleRows = 0 
OR pVisibleRows = ?
THEN
    ASSIGN pVisibleRows = 1.

{set VisibleRows pVisibleRows}. 

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

