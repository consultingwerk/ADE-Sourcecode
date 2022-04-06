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
  File: gsmstttcch.i

  Description:  Status Temp Table Cache Include

  Purpose:      Status Temp Table Cache Include

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6644   UserRef:    
                Date:   05/09/2000  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ttStatusCache) = 0 &THEN
DEFINE TEMP-TABLE ttStatusCache         NO-UNDO
    FIELD tStatusObj            AS DECIMAL
    FIELD tCategoryType         AS CHARACTER
    FIELD tCategoryGroup        AS CHARACTER
    FIELD tCategorySubGroup     AS CHARACTER
    FIELD tStatusShortDesc      AS CHARACTER
    FIELD tStatusDescription    AS CHARACTER
    FIELD tStatusTLA            AS CHARACTER
    INDEX idxCategory
        tCategoryType
        tCategoryGroup
        tCategorySubGroup
    INDEX idxStatus         /*AS UNIQUE*/
        tStatusObj
    INDEX idxTLA
        tStatusTLA        
    .

&GLOBAL-DEFINE ttStatusCache
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


