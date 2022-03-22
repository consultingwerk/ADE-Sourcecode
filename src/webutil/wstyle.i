&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Include
&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
&IF FALSE &THEN
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

  webtuil/wstyle.i -- workshop common styles

  This include file holds all the common code that is re-used by workshop 
  files to get a common look and feel.  It defines key variables and 
  function prototypes for standard colors, html tags, and format phrases.
  It defines a global, ws-style-hdl, that contains the actual function 
  declarations.
 
  Parameters:
    RESET - if defined, then the old ws-style-hdl is destroyed.
 
  Author:  Wm.T.Wood    
  Created: 4/1/97
------------------------------------------------------------------------*/
&ENDIF
&IF DEFINED(wsstyle) = 0 &THEN
  /* only define these variables and prototypes once per file. */
  &GLOBAL wsstyle yes

  /* global definitions --                                                 */
  DEFINE NEW GLOBAL SHARED VARIABLE ws-style-hdl AS HANDLE NO-UNDO.
  
  &IF "{&RESET}" ne "" &THEN
    /* Get a clean copy of the ws-style-hdl. */
    IF VALID-HANDLE(ws-style-hdl) THEN 
      RUN dispatch IN ws-style-hdl ('destroy':U).
  &ENDIF
  
  /* Make sure there is a style handle. */
  IF NOT VALID-HANDLE(ws-style-hdl) THEN
    RUN webutil/_wstyle.w PERSISTENT SET ws-style-hdl.

  /* function prototypes --                                                */

  /* format an error for display in workshop */
  FUNCTION format-error RETURNS CHARACTER
   (INPUT p_text        AS CHARACTER,
    INPUT p_highlite    AS CHARACTER,
    INPUT p_options     AS CHARACTER) in ws-style-hdl.

  /* format a filename for display in workshop */
  FUNCTION format-filename RETURNS CHARACTER
     (input p_filename    as character,
      input p_text        as character,
      input p_options     as character) in ws-style-hdl.

  /* format a titlebar for display in workshop */
  FUNCTION format-titlebar RETURNS CHARACTER
     (input p_title       as character,
      input p_image       as character,
      input p_options     as character) in ws-style-hdl.

  /* format a label (eg. <p_label>). There are three types of labels:
       SIDE (default), ROW and COLUMN. */
  FUNCTION format-label returns character
   (input p_label       as character,
    input p_type        as character,
    input p_options     as character) in ws-style-hdl.

  /* format text with a label (eg. <p_label>: <p_text> ) */
  FUNCTION format-label-text RETURNS CHARACTER
   (input p_label       as character,
    input p_text        as character) in ws-style-hdl.

  /* Format text with each of the options listed. */
  FUNCTION format-text RETURNS CHARACTER
   (input p_text        as character,
    input p_options     as character) in ws-style-hdl.
 
  /* return the phrase part of a <body[ phrase]> tag used for Workshop frames. */
  FUNCTION get-body-phrase RETURNS CHARACTER
     (input p_BodyName as character) in ws-style-hdl.
  
  /* return the phrase part of a <table[ phrase]> tag used for Workshop tables. */
  FUNCTION get-table-phrase RETURNS CHARACTER
     (INPUT p_options AS CHARACTER) IN ws-style-hdl:

  /* return the color name (eg. "purple") or number (eg. "#99ff00") to
     use in standard uses. */
  function get-color returns character 
     (input p_nameofcolor as char) in ws-style-hdl.

  /* return the location HREF relative to the HTTP Host for particular 
     html names (eg. "blank" returns "/webspeed/assist/blank.html".  */
  function get-location returns character 
     (input p_name as char) in ws-style-hdl.

  /* return a standard hard rule tag image.  */
  function get-rule-tag returns character 
     (input p_width   as character,
      input p_options as character) in ws-style-hdl.
  					
  /* return the window settings to use in a JavaScript:
        window.open (URL, name, 'settings') */
  function get-window-settings returns character
     (input p_name    as character,
      input p_opitons as character) in ws-style-hdl.

/* --- end of wstyle.i --- */
&ENDIF

&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

 

