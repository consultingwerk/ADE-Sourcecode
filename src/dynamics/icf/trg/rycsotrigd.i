&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
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
         HEIGHT             = 5.24
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* ryc_smartobject has ryc_attribute_value ON PARENT DELETE CASCADE */
&IF DEFINED(lbe_attribute_value) = 0 &THEN
  DEFINE BUFFER lbe_attribute_value FOR ryc_attribute_value.
  &GLOBAL-DEFINE lbe_attribute_value yes
&ENDIF
FOR EACH ryc_attribute_value NO-LOCK
   WHERE ryc_attribute_value.primary_smartobject_obj = ryc_smartobject.smartobject_obj
   ON STOP UNDO, RETURN ERROR "AF^104^rycsotrigd.p^delete ryc_attribute_value":U:
    FIND FIRST lbe_attribute_value EXCLUSIVE-LOCK
         WHERE ROWID(lbe_attribute_value) = ROWID(ryc_attribute_value)
         NO-ERROR.
    IF AVAILABLE lbe_attribute_value THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_attribute_value"}
      END.
END.

/* Issue 6732.. RESTRICT deletion of a default object if there still exists 
                a custom version */
DEFINE BUFFER buff_smartObject FOR ryc_smartObject.
IF ryc_smartobject.customization_result_obj = 0 
   AND CAN-FIND(FIRST buff_smartObject 
                WHERE buff_smartObject.object_filename = ryc_smartobject.object_filename
                  AND buff_smartObject.customization_result_obj > 0 ) THEN
DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 
             lv-include = ryc_smartObject.object_filename + "| a custom object":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


