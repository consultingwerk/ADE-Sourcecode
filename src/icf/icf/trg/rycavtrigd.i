&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
* Contributors: MIP Holdings (Pty) Ltd ("MIP")                       *
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

DEFINE BUFFER rycav FOR ryc_attribute_value.                        
DEFINE VARIABLE cAttributeList  AS CHARACTER NO-UNDO.

IF ryc_attribute_value.OBJECT_instance_obj <> 0 AND 
   CAN-FIND(FIRST ryc_object_instance
            WHERE ryc_object_instance.object_instance_obj = ryc_attribute_value.OBJECT_instance_obj
              AND ryc_object_instance.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj) THEN
DO:
  cAttributeList = "".
  FOR EACH rycav NO-LOCK
      WHERE rycav.object_type_obj = ryc_attribute_value.object_type_obj
        AND rycav.smartobject_obj = ryc_attribute_value.smartobject_obj
        AND rycav.object_instance_obj = ryc_attribute_value.object_instance_obj
        AND ROWID(rycav) <> ROWID(ryc_attribute_value):

      IF cAttributeList <> "" THEN cAttributeList = cAttributeList + CHR(3).
      cAttributeList = cAttributeList + rycav.attribute_label + CHR(4) + rycav.attribute_value.
  END.

  /*   ON WRITE OF ryc_object_instance OVERRIDE DO: END. */
  IF CAN-FIND(FIRST ryc_object_instance
              WHERE ryc_object_instance.object_instance_obj = ryc_attribute_value.OBJECT_instance_obj
                AND ryc_object_instance.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj) THEN
  DO:
    FIND FIRST ryc_object_instance EXCLUSIVE-LOCK
         WHERE ryc_object_instance.object_instance_obj = ryc_attribute_value.OBJECT_instance_obj
           AND ryc_object_instance.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
         NO-ERROR.
    IF ERROR-STATUS:ERROR = NO AND AVAILABLE ryc_object_instance THEN
    DO:
      ASSIGN ryc_object_instance.attribute_list = cAttributeList.
      {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=ryc_object_instance}
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


