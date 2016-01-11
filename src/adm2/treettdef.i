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
/*---------------------------------------------------------------------------------
  File: rytrettdef.i.i

  Description:  Dynamic TreeView Data TT Definition
  
  Purpose:      Dynamic TreeView Data TT Definition

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        8816   UserRef:    
                Date:   23/05/2001  Author:     Chris Koster

  Update Notes: Created from Template ryteminclu.i
                Dynamic TreeView Data TT Definition

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

/* This temp-table will be populated with the parent
   and related child nodes required to build this 
   TreeView, this will help with speed increase, so 
   that we do not make any extra appServer calls to
   get the next node's details                      */
DEFINE TEMP-TABLE ttNode NO-UNDO
 FIELD node_obj                         AS DECIMAL   FORMAT "->>>>>>>>>>>>>>>>>9.999999999"
 FIELD node_code                        AS CHARACTER FORMAT "X(10)"
 FIELD node_description                 AS CHARACTER FORMAT "X(35)"
 FIELD parent_node_obj                  AS DECIMAL   FORMAT "->>>>>>>>>>>>>>>>>9.999999999"
 FIELD node_label                       AS CHARACTER FORMAT "X(28)"
 FIELD node_checked                     AS LOGICAL   FORMAT "YES/NO"
 FIELD data_source_type                 AS CHARACTER FORMAT "X(3)"
 FIELD data_source                      AS CHARACTER FORMAT "X(35)"
 FIELD logical_object                   AS CHARACTER FORMAT "X(35)"
 FIELD primary_sdo                      AS CHARACTER FORMAT "X(35)"
 FIELD run_attribute                    AS CHARACTER FORMAT "X(35)"
 FIELD fields_to_store                  AS CHARACTER FORMAT "X(70)"
 FIELD node_text_label_expression       AS CHARACTER FORMAT "X(70)"
 FIELD label_text_substitution_fields   AS CHARACTER FORMAT "X(70)"
 FIELD foreign_fields                   AS CHARACTER FORMAT "X(70)"
 FIELD image_file_name                  AS CHARACTER FORMAT "X(70)"
 FIELD selected_image_file_name         AS CHARACTER FORMAT "X(70)"
 INDEX XPKgsm_node                      AS UNIQUE PRIMARY node_obj ASCENDING 
 INDEX XAK1gsm_node                     AS UNIQUE node_code ASCENDING 
 INDEX XIE1gsm_node                     parent_node_obj ASCENDING.

DEFINE TEMP-TABLE ttLinksAdded NO-UNDO
  FIELDS hSourceHandle    AS HANDLE
  FIELDS cLinkName        AS CHARACTER
  FIELDS hTargetHandle    AS HANDLE
  INDEX  idx1             AS PRIMARY hSourceHandle
                                     cLinkName    
                                     hTargetHandle.

DEFINE TEMP-TABLE ttRunningSDOs NO-UNDO
  FIELD cSDOName    AS CHARACTER
  FIELD hSDOHandle  AS HANDLE
  FIELD cServerMode AS CHARACTER
  FIELD hParentSDO  AS HANDLE
  INDEX idx1        AS PRIMARY UNIQUE cSDOName.

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
         HEIGHT             = 12.1
         WIDTH              = 45.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


