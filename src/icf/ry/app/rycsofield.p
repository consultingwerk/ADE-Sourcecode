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
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(server-side) = 0 &THEN
  /* Only define temp-table if on client as cannot define a temp-table in an 
     internal procedure and temp-table will already be defined in this case
  */
  /* include temp-table definitions */
  {ry/app/rycsofield.i}
&ENDIF

DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER.
DEFINE OUTPUT PARAMETER TABLE FOR ttSmartobjectField.
DEFINE OUTPUT PARAMETER TABLE FOR ttSdoField.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


    EMPTY TEMP-TABLE ttSmartobjectField.
    EMPTY TEMP-TABLE ttSdoField.

    DEFINE BUFFER sdo_smartobject FOR ryc_smartobject.

    /* server-side coding to be placed into a plip for execution in a stateless server-side context */

    FIND FIRST ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.object_filename = pcLogicalObjectName NO-ERROR.
    IF NOT AVAILABLE ryc_smartobject THEN
    DO:
        RETURN ERROR {af/sup2/aferrortxt.i 'RY' '01' '?' '?' pcLogicalObjectName}.
    END.

    /* bulk copy all fields into the table */

    FOR EACH ryc_smartobject_field NO-LOCK
        WHERE ryc_smartobject_field.smartobject_obj = ryc_smartobject.smartobject_obj:

        CREATE ttSmartObjectField.
        ASSIGN ttSmartObjectField.Logical_Object_Name = pcLogicalObjectName.
        BUFFER-COPY ryc_smartobject_field TO ttSmartobjectField.    

    END.

    FIND FIRST sdo_smartobject NO-LOCK
        WHERE sdo_smartobject.smartobject_obj = ryc_smartobject.sdo_smartobject_obj.
    FOR EACH ryc_smartobject_field NO-LOCK
        WHERE ryc_smartobject_field.smartobject_obj = sdo_smartobject.smartobject_obj:

        CREATE ttSdoField.
        ASSIGN ttSdoField.Logical_Object_Name = pcLogicalObjectName.
        BUFFER-COPY ryc_smartobject_field TO ttSdoField.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


