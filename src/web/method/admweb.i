&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Method-Library
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000,2016 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    File        : admweb.i  
    Purpose     : Provides basic ADM functionality for Web based applications
                  without including most of the ADM code.
  
    Syntax      : {src/web/method/admweb.i}

    Modifications:  Add new attribute - Web Time Remaining -  nhorn 1/31/97 
		    for web objects.  
  
    Author(s)   : Wm.T.Wood
    Created     : June 1996
    Notes       : Based on ADM Version 1.0 code
--------------------------------------------------------------------------*/
/*            This .i file was created with WebSpeed Workshop             */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED (adm-admweb) = 0 AND DEFINED (adm-smart) = 0 &THEN
&GLOBAL adm-admweb

/* ADM-WEB version number. */
&Scoped-Define ADM-VERSION WEB1.0

/* WEB-related attributes */
DEFINE VARIABLE adm-web-state          AS CHARACTER NO-UNDO INITIAL "state-less":U.
DEFINE VARIABLE adm-web-timeout        AS DECIMAL   NO-UNDO.
DEFINE VARIABLE adm-web-tohdlr         AS CHARACTER NO-UNDO.
DEFINE VARIABLE adm-web-time-remaining AS DECIMAL   NO-UNDO.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ***************************  Main Block  *************************** */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-destroy) = 0 &THEN
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-destroy 
PROCEDURE adm-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Delete this procedure (if it is PERSISTENT).
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE. 
END PROCEDURE.
&ANALYZE-RESUME
&ENDIF

&IF DEFINED(EXCLUDE-adm-timing-out) = 0 &THEN
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-timing-out 
PROCEDURE adm-timing-out :
/*------------------------------------------------------------------------------
  Purpose:     This procedure sets web state to timed-out.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN set-attribute-list IN THIS-PROCEDURE ('Web-State = Timed-Out':U).

END PROCEDURE.
&ANALYZE-RESUME
&ENDIF

&IF DEFINED(EXCLUDE-dispatch) = 0 &THEN
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE dispatch 
PROCEDURE dispatch :
/* -----------------------------------------------------------
   Purpose:    Determines whether to run the LOCAL or STANDARD (adm-)
               or no-prefix version of a method in the current procedure.
   Parameters: INPUT base method name (with no prefix)
   Notes:      In addition, if the developer has defined a custom prefix
               as ADM-DISPATCH-QUALIFIER, then a method with this prefix
               will be searched for after "local-" and before "adm-".
               If the preprocessor ADM-SHOW-DISPATCH-ERRORS is defined
               then the show-errors method will be dispatched if a
               method name is not found in any form. This can be 
               useful for debugging purposes.
   -------------------------------------------------------------*/   

  DEFINE INPUT PARAMETER p-method-name    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE caller-name             AS CHARACTER NO-UNDO.

  IF p-method-name BEGINS "adm-":U THEN /* Remove any adm prefix. */ 
    p-method-name = SUBSTRING(p-method-name,5,-1,"CHARACTER":U).
  ASSIGN caller-name = ENTRY(1, program-name(2), " ":U).

  IF (caller-name NE "local-":U + p-method-name) 
    &IF "{&ADM-DISPATCH-QUALIFIER}":U NE "":U &THEN
    AND (caller-name NE "{&ADM-DISPATCH-QUALIFIER}":U + "-":U + p-method-name)
    &ENDIF
    AND (LOOKUP("local-":U + p-method-name, THIS-PROCEDURE:INTERNAL-ENTRIES) NE 0) 
         THEN p-method-name = "local-":U + p-method-name.
  
  &IF "{&ADM-DISPATCH-QUALIFIER}":U NE "":U &THEN
  ELSE IF (caller-name NE "{&ADM-DISPATCH-QUALIFIER}":U + "-":U 
    + p-method-name)
       AND (LOOKUP("{&ADM-DISPATCH-QUALIFIER}":U + "-":U + p-method-name,
          THIS-PROCEDURE:INTERNAL-ENTRIES) NE 0) 
            THEN p-method-name = "{&ADM-DISPATCH-QUALIFIER}":U + "-":U 
               + p-method-name.
  &ENDIF

  ELSE IF (caller-name NE "adm-":U + p-method-name) AND
      (LOOKUP("adm-":U + p-method-name, 
          THIS-PROCEDURE:INTERNAL-ENTRIES) NE 0) 
            THEN p-method-name = "adm-":U + p-method-name.

  /* Run the method. */
  RUN VALUE(p-method-name) IN THIS-PROCEDURE NO-ERROR.
  
  /* Catch ADM-detected update errors. */
  IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U. 

  IF ERROR-STATUS:ERROR THEN DO:
    /* The SHOW-DISPATCH-ERRORS preprocessor causes "procedure not found"
       errors to be displayed for debugging purposes. Otherwise these
       are suppressed. */
    &IF DEFINED(ADM-SHOW-DISPATCH-ERRORS) EQ 0 &THEN
    IF ERROR-STATUS:GET-NUMBER(1) <> 2129 AND 
       ERROR-STATUS:GET-NUMBER(1) <> 6456 THEN  /* procedure not found */ 
    &ENDIF
    DO:
      RUN dispatch IN web-utilities-hdl ('show-errors':U).
      RETURN "ADM-ERROR":U.
    END.
  END.
      
  RETURN.
END PROCEDURE.
&ANALYZE-RESUME
&ENDIF

&IF DEFINED(EXCLUDE-get-attribute) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-attribute 
PROCEDURE get-attribute :
/* -------------------------------------------------------------
   Purpose:     Returns the value of a standard Web-related 
                attributes.
   Parameters:  INPUT attribute name, RETURN-VALUE (string)
   Notes:       
   -------------------------------------------------------------*/   
                
  DEFINE INPUT PARAMETER p_attr-name AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE attr-value         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE p_period           AS DECIMAL   NO-UNDO.

  CASE (p_attr-name):    
    WHEN 'Type':U                THEN attr-value = "{&PROCEDURE-TYPE}":U.
    WHEN 'Version':U             THEN attr-value = "{&ADM-VERSION}":U.
    WHEN 'Web-State':U           THEN attr-value = adm-web-state.
    WHEN 'Web-Timeout':U         THEN attr-value = STRING(adm-web-timeout).
    WHEN 'Web-Timeout-Handler':U THEN attr-value = adm-web-tohdlr.
    WHEN 'Web-Time-Remaining':U  THEN DO:
      RUN get-time-remaining IN web-utilities-hdl (THIS-PROCEDURE, OUTPUT p_period). 
      attr-value = STRING(p_period). 
    END.
    OTHERWISE DO:  
      RUN special-get-attribute IN THIS-PROCEDURE (p_attr-name) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN attr-value = RETURN-VALUE.
      ELSE attr-value = ?.
    END.
  END CASE.
 
  /* Return the new name */
  RETURN attr-value.
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE set-attribute-list 
PROCEDURE set-attribute-list :
/* -----------------------------------------------------------
      Purpose:     Accepts the value of the complete object attribute list
                   and runs procedures to set individual attributes.
      Parameters:  INPUT comma-separated attribute list.
      Notes:       Not all attributes are settable. Those which are a
                   part of an event such as enable/disable (which set
                   ENABLED on/off) or hide/view (which set HIDDEN on/off)
                   can be queried through get-attribute but cannot be set.
    -------------------------------------------------------------*/   
                
  DEFINE INPUT PARAMETER p-attr-list    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cntr             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE attr-name        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE attr-value       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE attr-entry       AS CHARACTER NO-UNDO.  
  
  DO cntr = 1 TO NUM-ENTRIES(p-attr-list):
    attr-entry = ENTRY(cntr, p-attr-list).
    IF INDEX(attr-entry,"=":U) = 0 THEN DO:
      MESSAGE 
        "Invalid element in set-attribute call:" SKIP
        attr-entry SKIP "in" THIS-PROCEDURE:FILE-NAME
        VIEW-AS ALERT-BOX WARNING.
      NEXT.
    END.
    attr-name = TRIM(SUBSTRING(attr-entry, 1, INDEX(attr-entry, "=":U) - 1,
        "CHARACTER":U)).
    attr-value = TRIM(SUBSTRING(attr-entry, INDEX(attr-entry, "=":U) + 1,
        -1, "CHARACTER":U)).

    CASE attr-name:
      WHEN "Web-Timeout":U         THEN adm-web-timeout = DECIMAL(attr-value) NO-ERROR.
      WHEN "Web-State":U           THEN adm-web-state   = attr-value.
      WHEN "Web-Timeout-Handler":U THEN adm-web-tohdlr  = attr-value.
      OTHERWISE 
        RUN special-set-attribute IN THIS-PROCEDURE 
          (attr-name, INPUT attr-value) NO-ERROR.
    END CASE. 
  END. /* DO... */

END PROCEDURE.

/******************************* End of admweb.i *********************************/
&ENDIF  /* this closes the opening "IF" in the Definitions section */
&ANALYZE-RESUME

&ENDIF

/* admweb.i - end of file */
