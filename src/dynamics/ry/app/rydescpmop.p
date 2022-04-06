&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: rydescpmop.p

  Description:  RDM copyObjectMaster API procedure

  Purpose:      RDM copyObjectMaster API procedure. The code from the API has been
                temporarily copied into this procedure to avoid problems with the e-code
                segment limits.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/23/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydescpmop.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/** Temp-table definition for TT used in storeAttributeValues
 *  ----------------------------------------------------------------------- **/
{ ry/inc/ryrepatset.i }

/** Temp-table definition for TT used to store Object Links
 *  ----------------------------------------------------------------------- **/
{ ry/inc/ryreplnset.i }

/* This include file contains pre-processors for the different data types for attributes */
{af/app/afdatatypi.i}

/** Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes.
 *  ----------------------------------------------------------------------- **/
{ ry/app/rydefrescd.i }


DEFINE INPUT  PARAMETER pcSourceObjectName          AS CHARACTER        NO-UNDO.
DEFINE INPUT  PARAMETER pcSourceResultCode          AS CHARACTER        NO-UNDO.
DEFINE INPUT  PARAMETER pcTargetObjectName          AS CHARACTER        NO-UNDO.
DEFINE INPUT  PARAMETER pcTargetClass               AS CHARACTER        NO-UNDO.
DEFINE INPUT  PARAMETER pcTargetProductModule       AS CHARACTER        NO-UNDO.
DEFINE INPUT  PARAMETER pcTargetRelativePath        AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObjectObj            AS DECIMAL          NO-UNDO.

/** The following temp-tables are used for copyObjectMaster().
  *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttXref        NO-UNDO
    FIELD tElementType          AS CHARACTER
    FIELD tSourceData           AS CHARACTER
    FIELD tTargetData           AS CHARACTER
    INDEX idxSource
        tElementType
        tSourceData
    INDEX idxTarget
        tElementType
        tTargetData
    .

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
         HEIGHT             = 19.19
         WIDTH              = 51.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{ry/app/rydescpmoi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


