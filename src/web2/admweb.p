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
    File        : admweb.p
    Purpose     : General super procedure to keep track of the state for Web objects.
    Syntax      : web2/objects/admweb.p

    Description :

    Author(s)   : D.M.Adams
    Created     : March, 1998
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell web/method/admwprop.i that this is the Super Procedure */
&SCOPED-DEFINE ADMSuper admweb.p

{src/web2/custom/admwebexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getWebState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWebState Procedure 
FUNCTION getWebState RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWebTimeout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWebTimeout Procedure 
FUNCTION getWebTimeout RETURNS DECIMAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWebTimeRemaining) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWebTimeRemaining Procedure 
FUNCTION getWebTimeRemaining RETURNS DECIMAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWebToHdlr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWebToHdlr Procedure 
FUNCTION getWebToHdlr RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWebState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWebState Procedure 
FUNCTION setWebState RETURNS LOGICAL
  ( pdWebTimeout AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWebToHdlr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWebToHdlr Procedure 
FUNCTION setWebToHdlr RETURNS LOGICAL
  ( pcWebToHdlr AS CHARACTER )  FORWARD.

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
         HEIGHT             = 13.52
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/cgidefs.i}
{src/web2/admwprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroy Procedure 
PROCEDURE destroy :
/*------------------------------------------------------------------------------
  Purpose:    Deletes this procedure if it was run PERSISTENT.
  Parameters: <none>
  Notes:      The web-util.p calls destroy so we need this API.
              We cannot change web-util as code exists that may depend on that
              so we just make this call the correct API.  
------------------------------------------------------------------------------*/
    RUN destroyObject IN TARGET-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose: Destroy the procedure including the offset       
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/   
  RUN deleteOffsets IN TARGET-PROCEDURE NO-ERROR.
  
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAttribute Procedure 
PROCEDURE getAttribute :
/* --------------------------------------------------------------------
  Purpose:    Returns the value of a standard Web-related attribute.
  Parameters (INPUT): 
              p_attr-name (CHAR) - name of attribute.  Possible names are
                type, version, web-state, web-timeout, web-timeout-handler,
                web-time-remaining.  In addition, other names can be used
                provided the special-get-attribute procedure exists in the 
                target procedure to handle them.
  Notes:      Attribute string value is returned in RETURN-VALUE.
  --------------------------------------------------------------------*/   
                
  DEFINE INPUT PARAMETER p_attr-name AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE attr-value         AS CHAR    NO-UNDO.
  DEFINE VARIABLE cTimeOutHdl        AS CHAR    NO-UNDO.
  DEFINE VARIABLE cType              AS CHAR    NO-UNDO.
  DEFINE VARIABLE cVersion           AS CHAR    NO-UNDO.
  DEFINE VARIABLE cWebState          AS CHAR    NO-UNDO.
  DEFINE VARIABLE dWebTimeOut        AS DECIMAL NO-UNDO.
  DEFINE VARIABLE p_period           AS DECIMAL NO-UNDO.

  CASE (p_attr-name):    
    WHEN 'Type':U                THEN DO:
       {get ObjectType cType}.
       RETURN cType.
    END.
    WHEN 'Version':U             THEN DO:
       {get ObjectVersion cVersion}.
       RETURN cVersion.
    END.   
    WHEN 'Web-State':U           THEN DO:
       {get WebState cWebState}.
       RETURN cWebState.
    END.
    WHEN 'Web-Timeout':U         THEN DO:
       {get WebTimeout dWebTimeOut}.
       RETURN STRING(dWebTimeOut). 
    END.
    WHEN 'Web-Timeout-Handler':U THEN DO:
       {get WebToHdlr cTimeOutHdl}.
       RETURN cTimeOutHdl.
    END.
    WHEN 'Web-Time-Remaining':U  THEN DO:
      RUN get-time-remaining IN web-utilities-hdl (TARGET-PROCEDURE, 
                                                   OUTPUT p_period). 
      attr-value = STRING(p_period). 
    END.
    OTHERWISE DO:  
      RUN special-get-attribute IN TARGET-PROCEDURE (p_attr-name) NO-ERROR.
      attr-value = IF NOT ERROR-STATUS:ERROR THEN RETURN-VALUE ELSE ?.
    END.
  END CASE.
 
  /* Return the new name */
  RETURN string(attr-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-attribute-list Procedure 
PROCEDURE set-attribute-list :
/* ---------------------------------------------------------------------
  Purpose:    Accepts the value of the complete object attribute list and 
              runs procedures to set individual attributes.
  Parameters (INPUT):
              p-attr-list (CHAR)- comma-separated attribute list with the
                format "name=value".  Typical attributes are web-timeout, 
                web-state, and web-timeout-handler.  In addition, other names 
                can be used provided the special-get-attribute procedure 
                exists in the target procedure to handle them.
  Notes:      Not all attributes are settable. Those which are a part of an 
              event such as enable/disable (which set ENABLED on/off) or 
              hide/view (which set HIDDEN on/off) can be queried through 
              get-attribute, but are read-only.
------------------------------------------------------------------------*/   
  DEFINE INPUT PARAMETER p-attr-list    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cntr       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE attr-name  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE attr-value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE attr-entry AS CHARACTER NO-UNDO.  
  
  DO cntr = 1 TO NUM-ENTRIES(p-attr-list):
    attr-entry = ENTRY(cntr, p-attr-list).
    IF INDEX(attr-entry,"=":U) = 0 THEN DO:
      MESSAGE 
        "Invalid element in set-attribute call:" SKIP
        attr-entry SKIP "in" TARGET-PROCEDURE:FILE-NAME
        VIEW-AS ALERT-BOX WARNING.
      NEXT.
    END.
    
    ASSIGN
      attr-name      = TRIM(ENTRY(1,attr-entry,"=":U))
      attr-value     = TRIM(ENTRY(2,attr-entry,"=":U))
      .
    CASE attr-name:
      WHEN "Web-Timeout":U         THEN {set WebTimeout DECIMAL(attr-value)}.
      WHEN "Web-State":U           THEN {set WebState   attr-value}.
      WHEN "Web-Timeout-Handler":U THEN {set WebToHdlr  attr-value}.
      OTHERWISE 
        RUN special-set-attribute IN TARGET-PROCEDURE 
          (attr-name, INPUT attr-value) NO-ERROR.
    END CASE. 
  END. /* DO... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-timingOut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE timingOut Procedure 
PROCEDURE timingOut :
/*------------------------------------------------------------------------------
  Purpose:    Sets a Web object's Web state to timed-out.
  Parameters: <none>
  Notes:      
------------------------------------------------------------------------------*/

  {set WebState 'Timed-Out'}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getWebState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWebState Procedure 
FUNCTION getWebState RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns a Web object's Web state.
  Returns:    (CHAR) - Possible values are state-aware, state-less, timed-out
  Parameters: <none>
  Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cWebState AS CHARACTER NO-UNDO.
  
  {get WebState cWebState}.
  
  RETURN cWebState.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWebTimeout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWebTimeout Procedure 
FUNCTION getWebTimeout RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns a state-aware Web object's timeout in minutes.
  Returns:    (DECIMAL)
  Parameters: <none>
  Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dWebTimeout AS DECIMAL NO-UNDO.
  
  {get WebTimeout dWebTimeout}.
  
  RETURN dWebtimeout.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWebTimeRemaining) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWebTimeRemaining Procedure 
FUNCTION getWebTimeRemaining RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the time remaining for a state-aware Web object.
  Returns:    (DECIMAL)
  Parameters: <none>
  Notes:      
------------------------------------------------------------------------------*/
  DEF VAR dWebTimeRemaining AS DECIMAL NO-UNDO.
  
  RUN get-time-remaining IN web-utilities-hdl (TARGET-PROCEDURE,
                                               OUTPUT dWebTimeRemaining).
  RETURN dWebTimeRemaining.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWebToHdlr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWebToHdlr Procedure 
FUNCTION getWebToHdlr RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the name of the Web object/procedure to run when the 
              state-aware Web object that is currently running times out.
  Returns:    (CHAR)
  Parameters: <none>
  Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cWebToHdlr AS CHARACTER NO-UNDO.
  
  {get WebToHdlr cWebToHdlr}.
  
  RETURN cWebToHdlr.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWebState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWebState Procedure 
FUNCTION setWebState RETURNS LOGICAL
  ( pdWebTimeout AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the Web object's Web state to state-aware and its timeout.
  Returns:    (LOGICAL) - TRUE
  Parameters: pdWebTimeout (DECIMAL) - Number of minutes to remain state-aware
  Notes:    
------------------------------------------------------------------------------*/
  
  {set WebState 'state-aware'}.
  
  RUN set-web-state IN web-utilities-hdl (TARGET-PROCEDURE, pdWebTimeout).
    
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWebToHdlr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWebToHdlr Procedure 
FUNCTION setWebToHdlr RETURNS LOGICAL
  ( pcWebToHdlr AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the name of the Web object/procedure to run when the 
              state-aware Web object that is currently running times out.
  Returns:    (LOGICAL) - TRUE
  Parameters: pcWebToHdlr (CHAR) - Web object name
  Notes:      Web object must be on the Agent's PROPATH.
------------------------------------------------------------------------------*/

  {set WebToHdlr pcWebToHdlr}.
    
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

