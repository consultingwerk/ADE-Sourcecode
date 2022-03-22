&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    Library     : browser.i  
    Purpose     : Base ADM methods for Browser objects
  
    Syntax      : {src/adm/method/browser.i}

    Description :
  
    Author(s)   :
    Created     :
    HISTORY: 
--------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE adm-sts           AS LOGICAL NO-UNDO.
DEFINE VARIABLE adm-brs-in-update AS LOGICAL NO-UNDO INIT no.
DEFINE VARIABLE adm-brs-initted   AS LOGICAL NO-UNDO INIT no.

&IF DEFINED(adm-browser) = 0 &THEN
&GLOBAL adm-browser yes

&GLOBAL adm-open-query yes

/* Dialog program to run to set runtime attributes - if not defined in master */
&IF DEFINED(adm-attribute-dlg) = 0 &THEN
&SCOP adm-attribute-dlg adm/support/browserd.w
&ENDIF

/* +++ This is the list of attributes whose values are to be returned
   by get-attribute-list, that is, those whose values are part of the
   definition of the object instance and should be passed to init-object
   by the UIB-generated code in adm-create-objects. */
&IF DEFINED(adm-attribute-list) = 0 &THEN
&SCOP adm-attribute-list Initial-Lock,Hide-on-Init,Disable-on-Init,Key-Name,~
Layout,Create-On-Add,SortBy-Case
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 6.86
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm/method/smart.i}
{src/adm/method/tableio.i}
{src/adm/method/record.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* Keep newly added entries from being at the top of the viewport. */
  adm-sts = {&BROWSE-NAME}:SET-REPOSITIONED-ROW
    ({&BROWSE-NAME}:DOWN,"CONDITIONAL":U). 

  /* Initialize attributes for update processing objects. */
  RUN set-attribute-list ('FIELDS-ENABLED=no,ADM-NEW-RECORD=no':U).

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-set-size) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-size Method-Library 
PROCEDURE set-size :
/*------------------------------------------------------------------------------
  Purpose:     To allow browsers to resize when placed into a SmartWindow at
               design time
  Parameters:  pd_height AS DECIMAL - The desired height (in rows)
               pd_width  AS DECIMAL - The desired width (in columns)
               
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE hBrowse     AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFieldGroup AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFrame      AS HANDLE           NO-UNDO.
  DEFINE VARIABLE htmpWidget  AS HANDLE           NO-UNDO.
  DEFINE VARIABLE otherWidget AS LOGICAL          NO-UNDO.

  /* Assure that it doesn't get too small */
  ASSIGN pd_height = MAX(pd_height, 2.0)
         pd_width  = MAX(pd_width, 2.0)
  /* Get the handles of the browse and its frame */
         hBrowse     = {&BROWSE-NAME}:HANDLE IN FRAME {&FRAME-NAME}
         hFieldGroup = hBrowse:PARENT          /* Field Group */
         htmpWidget  = hFieldGroup:FIRST-CHILD /* Perhaps a sibling */
         hFrame      = hFieldGroup:PARENT.     /* The frame ! */

  /* Search for Siblings.  We will not attempt to resize things if there
     are any sublings.                                                   */
  Search-For-Siblings:
  REPEAT WHILE VALID-HANDLE(htmpWidget):
    IF htmpWidget NE hBrowse THEN DO:
      IF htmpWidget:TYPE NE "BUTTON" OR
         htmpWidget:X    NE 4 OR
         htmpWidget:Y    NE 4 THEN DO:  /* This isn't the Affordance button */
        RETURN.
      END.  /* Not the affordance button */
    END.  /* If we have a potoential sibling */
    htmpWidget = htmpWidget:NEXT-SIBLING.
  END.  /* Repeat while valid handle*/
  
  
  /* If the width is getting smaller, do the browse first else the frame */
  IF pd_width < hBrowse:WIDTH THEN
    ASSIGN hBrowse:WIDTH = pd_width
           hFrame:WIDTH  = pd_width     NO-ERROR.
  ELSE
    ASSIGN hFrame:WIDTH  = pd_width
           hBrowse:WIDTH = pd_width     NO-ERROR.
           
  /* If the height is getting smaller, do the browse first else the frame */
  IF pd_height < hBrowse:HEIGHT THEN
    ASSIGN hBrowse:HEIGHT = pd_height
           hFrame:HEIGHT  = pd_height     NO-ERROR.
  ELSE
    ASSIGN hFrame:HEIGHT  = pd_height
           hBrowse:HEIGHT = pd_height     NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

