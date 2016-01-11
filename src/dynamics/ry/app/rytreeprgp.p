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
  File: rytreeprgp.p

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
                Date:   04/10/2004  Author:     Per Digre

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rytreeprgp.p
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
DEFINE INPUT  PARAMETER pcFilterValue AS CHARACTER  NO-UNDO.
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
&IF DEFINED(EXCLUDE-testOverride) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD testOverride Procedure
FUNCTION testOverride RETURNS CHARACTER PRIVATE
	(INPUT c1 AS CHARACTER, INPUT c2 AS CHARACTER ) FORWARD.

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
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProg                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghTreeData              AS HANDLE     NO-UNDO.

   /* From treeview.p - getTreeDataTable  */
CREATE TEMP-TABLE ghTreeData.
ghTreeData:ADD-NEW-FIELD('node_key':U,        'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('parent_node_key':U, 'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('node_obj':U,        'DECIMAL':U).
ghTreeData:ADD-NEW-FIELD('node_label':U,      'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('private_data':U,    'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('record_ref':U,      'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('key_fields':U,      'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('record_rowid':U,    'ROWID':U).
ghTreeData:ADD-NEW-FIELD('node_checked':U,    'LOGICAL':U, 0, ?, FALSE).
ghTreeData:ADD-NEW-FIELD('node_expanded':U,   'LOGICAL':U, 0, ?, FALSE).
ghTreeData:ADD-NEW-FIELD('image':U,           'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('selected_image':U,  'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('node_insert':U,     'INTEGER':U).
ghTreeData:ADD-NEW-FIELD('node_sort':U,       'LOGICAL':U,0,?,FALSE).
ghTreeData:ADD-NEW-FIELD('sdo_handle':U,      'HANDLE':U).
ghTreeData:ADD-NEW-FIELD('foreign_fields':U,  'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('foreign_values':U,  'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('node_type':U,       'CHARACTER':U).

/* Add Indices */
/* Node Handle - Primary - Unique */
ghTreeData:ADD-NEW-INDEX('puNodeKey':U, TRUE, TRUE).
ghTreeData:ADD-INDEX-FIELD('puNodeKey':U, 'node_key':U).

/* Parent Node Handle */
ghTreeData:ADD-NEW-INDEX('ParentNodeKey':U, FALSE, FALSE).
ghTreeData:ADD-INDEX-FIELD('ParentNodeKey':U, 'node_key':U).
ghTreeData:ADD-INDEX-FIELD('ParentNodeKey':U, 'parent_node_key':U).

/* Reference To Record's Data Loaded - Unique Identifier of the record (obj) */
ghTreeData:ADD-NEW-INDEX('record_ref':U, FALSE, FALSE).
ghTreeData:ADD-INDEX-FIELD('record_ref':U, 'record_ref':U).

/* The RowId of the record's data loaded into this node */
ghTreeData:ADD-NEW-INDEX('record_rowid':U, FALSE, FALSE).
ghTreeData:ADD-INDEX-FIELD('record_rowid':U, 'record_rowid':U).

ghTreeData:temp-table-prepare("tTreeData":U).

  FIND gsm_node NO-LOCK WHERE gsm_node.node_code = pcParentNodeCode. 

  hBuf = ghTreeData:DEFAULT-BUFFER-HANDLE.
  hBuf:buffer-create().
  ASSIGN hBuf:buffer-field('Node_Key'):BUFFER-VALUE = 'parent'
         hBuf:buffer-field('Record_Ref'):buffer-value = pcFilterValue.

  /* Run the program to populate the data */
  RUN VALUE(gsm_node.data_source) PERSISTENT SET hProg.
  RUN loadData IN hProg(
     INPUT pcParentNodeCode,      /* Nodekey */ 
     INPUT gsm_node.primary_sdo,     
     INPUT pcFilterValue, 
     INPUT-OUTPUT TABLE-HANDLE ghTreeData).
  DELETE PROCEDURE hProg.

  hBuf = ghTreeData:DEFAULT-BUFFER-HANDLE.
  CREATE QUERY hQry.
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.parent_node_key = "&2":U AND &1.node_obj = 0 BY &1.node_key':U, ghTreeData:NAME,pcParentNodeCode)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  /* Now we'll just add the other data from the gsm_node record */
  DO WHILE hBuf:AVAILABLE:
    CREATE ttNode.
    BUFFER-COPY gsm_node TO ttNode.
    ASSIGN
      ttNode.parent_node_code           = hBuf:BUFFER-FIELD('parent_node_key':U):BUFFER-VALUE
      ttNode.node_text_label_expression = testOverride(hBuf:BUFFER-FIELD('node_label':U):BUFFER-VALUE, gsm_node.node_text_label_expression)
      ttNode.image_file_name            = testOverride(hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE, gsm_node.image_file_name)
      ttNode.selected_image_file_name   = testOverride(hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE, gsm_node.selected_image_file_name)
      ttNode.private_Data               = hbuf:buffer-field('record_ref'):BUFFER-VALUE
      ttNode.fields_to_store            = hbuf:buffer-field('key_fields'):BUFFER-VALUE
      ttNode.node_label                 = testOverride(hBuf:BUFFER-FIELD('node_label':U):BUFFER-VALUE, gsm_node.node_label)
      ttNode.data_source_type           = testOverride(hBuf:BUFFER-FIELD('node_type':U):BUFFER-VALUE, gsm_node.data_source_type)
      ttNode.node_code                  = hbuf:BUFFER-FIELD('node_key'):BUFFER-VALUE
      .
    hQry:GET-NEXT().
  END.




/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */


/* ************************  Function Implementations ***************** */
&IF DEFINED(EXCLUDE-testOverride) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION testOverride Procedure
FUNCTION testOverride RETURNS CHARACTER PRIVATE
	(INPUT c1 AS CHARACTER, INPUT c2 AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  Returns c2 if c1 is blank or unknown
	Notes:
------------------------------------------------------------------------------*/
  RETURN IF c1 > '' THEN c1 ELSE c2.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF



