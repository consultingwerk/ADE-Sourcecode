&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rytrenodep.p

  Description:  Child Node Retrival Procedure

  Purpose:     This procedure loads all the node details into a temp-table that
               will be used to Cache the node details.
  Parameters:  I pcParentNodeCode - The root_node_code for this Instance (first
                                    time only) From TreeView
                 phTargetProcedure - The handle of the calling TreeView procedure
                                     for which we are creating the temp-table
                                     records.
               O ttNode           - Temp table created to load data into.

  History:
  --------
  (v:010000)    Task:   101000001   UserRef:    
                Date:   08/13/2001  Author:     Mark Davies

  Update Notes: Created from Template rytemplipp.p
                Child Node Retrival Procedure

  (v:010001)    Task:           0   UserRef:    
                Date:   01/15/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3020 - 'Menu Item' security and Treeview.
                Added security check for menu items
  
  (v:010002)    Task:           0   UserRef:    
                Date:   04/10/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3071 - It's not possible to translate menus
                Added menu translation features for TreeView Menu structures

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rytrenodep.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes
 
{src/adm2/globals.i}

/* Define temp-tables required - changed to use ADM2 temp-table as this originally pulled
   in the temp-table from ry/inc/rytrettdef.i which was defined LIKE and the temp table in the
   ADM2 include file was hard coded - causing mismatch errors after schema changes.
*/ 
{src/adm2/treettdef.i}

DEFINE INPUT  PARAMETER pcParentNodeCode  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER phTargetProcedure AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttNode.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-returnSDOName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnSDOName Procedure 
FUNCTION returnSDOName RETURNS CHARACTER
  ( INPUT pcSDOSBOName AS CHARACTER  )  FORWARD.

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
         HEIGHT             = 15.19
         WIDTH              = 52.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
RUN cacheNodeTableRecursive (INPUT pcParentNodeCode,  
                             pcParentNodeCode,  /* root node code */
                             INPUT phTargetProcedure).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cacheNodeTableRecursive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheNodeTableRecursive Procedure 
PROCEDURE cacheNodeTableRecursive :
/*------------------------------------------------------------------------------
  Purpose:     This procedure recursively copies node records to a temp-table
  Parameters:  pdParentNodeObj - The node_obj of the parent node for which the
                                 child node records should be oopied
               phTargetProcedure - The handle of the calling TreeView procedure
                                   for which we are creating the temp-table
                                   records.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeCode        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNodeCode  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phTargetProcedure AS HANDLE     NO-UNDO.
  DEFINE BUFFER bNode FOR gsm_node.
    
  FIND gsm_node NO-LOCK WHERE gsm_node.node_code = pcNodeCode NO-ERROR.  
  IF NOT AVAILABLE gsm_node THEN RETURN.

  CREATE ttNode.

  BUFFER-COPY gsm_node TO ttNode.
  ASSIGN ttNode.hTargetProcedure = phTargetProcedure
         ttNode.parent_node_code = pcParentNodeCode.

  IF ttNode.data_source_type  = "SDO":U AND 
     ttNode.data_source      <> "":U THEN
    ASSIGN ttNode.data_source = returnSDOName(ttNode.data_source).
  IF ttNode.primary_sdo <> "":U THEN
    ASSIGN ttNode.primary_sdo = returnSDOName(ttNode.primary_sdo).

  FOR EACH bNode NO-LOCK WHERE bNode.parent_node_obj  = ttNode.node_obj:
    RUN cacheNodeTableRecursive (INPUT bNode.node_code,  
                                 INPUT pcNodeCode,  
                                 INPUT phTargetProcedure).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-returnSDOName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnSDOName Procedure 
FUNCTION returnSDOName RETURNS CHARACTER
  ( INPUT pcSDOSBOName AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will add a relative path to the SDO/SBO name passed to it
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST ryc_smartobject 
       WHERE ryc_smartobject.object_filename = pcSDOSBOName
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN
    RETURN pcSDOSBOName.
  
  /* Dynamic objects have no object path, so we only check for the existence of the path
   * for static objects.  */
  IF LOGICAL(ryc_smartobject.static_object) AND (ryc_smartobject.object_path = "":U OR ryc_smartobject.object_path = ?) THEN
    RETURN pcSDOSBOName.
  ELSE
    ASSIGN pcSDOSBOName = ryc_smartobject.object_path + "/":U + pcSDOSBOName
           pcSDOSBOName = REPLACE(pcSDOSBOName,"~\":U,"/":U).
  
  IF ryc_smartobject.object_extension <> "":U AND
     NUM-ENTRIES(pcSDOSBOName,".":U) < 2 THEN
    pcSDOSBOName = pcSDOSBOName + ".":U + ryc_smartobject.object_extension.

  RETURN pcSDOSBOName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

