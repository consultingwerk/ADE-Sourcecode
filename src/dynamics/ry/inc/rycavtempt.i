&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rycavtempt.i

  Description:  Attribute Value Temp-Table Include

  Purpose:      Attribute Value Temp-Table Include

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/31/2001  Author:     Mark Davies (MIP)

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* This temp-table will probably in most cases only
   contain 1 record indicating the action to be 
   taken for a selected attribute label */
DEFINE TEMP-TABLE ttAttributeOptions NO-UNDO
  FIELDS cAttributeLabel        AS CHARACTER
  FIELDS cNewAttributeLabel     AS CHARACTER
  FIELDS cAttributeValue        AS CHARACTER
  FIELDS cAction                AS CHARACTER /* ASSIGN/RENAME/DELETE */
  FIELDS dObjectTypeObj         AS DECIMAL
  FIELDS lSetInheritedNo        AS LOGICAL
  FIELDS lOverrideValues        AS LOGICAL
  FIELDS lGenerateADO           AS LOGICAL
  FIELDS lCheckOutObject        AS LOGICAL
  FIELDS lUpdateTypes           AS LOGICAL
  FIELDS lUpdateObject          AS LOGICAL
  FIELDS lUpdateObjectInstance  AS LOGICAL
  INDEX  Index1                 AS PRIMARY UNIQUE cAttributeLabel.
  
/* This temp-table will contain the details of the
   objects/object instances that need to be changed.
   When only an object type's attribute values must
   change this temp-table would be empty. */ 
DEFINE TEMP-TABLE ttObjects NO-UNDO
  FIELDS cAttributeLabel    AS CHARACTER
  FIELDS dSmartObjectObj    AS DECIMAL
  FIELDS cObjectFileName    AS CHARACTER
  FIELDS dObjectTypeObj     AS DECIMAL
  INDEX  Index1             AS PRIMARY UNIQUE cAttributeLabel dSmartObjectObj.

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
         HEIGHT             = 5.67
         WIDTH              = 43.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


