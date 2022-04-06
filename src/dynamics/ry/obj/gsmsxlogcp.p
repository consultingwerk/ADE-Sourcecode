&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Data Logic Procedure Template
 
Use this template to create  a Data Logic Procedure."
*/
&ANALYZE-RESUME
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" DataLogicProcedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" DataLogicProcedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" DataLogicProcedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DataLogicProcedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmsxlogcp.p
 
  Description:  Logic Procedure for gsm_scm_xref
 
  Purpose:      A procedure library (PLIP) to support the maintenance of the gsm_scm_xref table
                The following internal procedures may be added or modified
                to act as validation to creation, modification, or deletion of
                records in the database table
                
                Client-side:
                rowObjectValidate***
                
                Server-side upon create:
                createPreTransValidate***
                createBeginTransValidate
                createEndTransValidate
                createPostTransValidate
                
                Server-side upon write (create and modify):
                writePreTransValidate***

  Parameters:

  History:
  --------
  (v:010000)    Task:          49   UserRef:    
                Date:   06/09/2003  Author:     Thomas Hansen

  Update Notes: Create maintenace tool for SCM tool

  (v:010001)    Task:          49   UserRef:    
                Date:   09/21/2003  Author:     Thomas Hansen

  Update Notes: 

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/
 
/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */
 
&scop object-name       gsmsxlogcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001
 
/* object identifying preprocessor */
&glob   AstraPlip    yes
 
DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
 
ASSIGN cObjectName = "{&object-name}":U.
 
&scop   mip-notify-user-on-plip-close   NO
 
 
/* Data Preprocessor Definitions */
&GLOB DATA-LOGIC-TABLE gsm_scm_xref
&GLOB DATA-FIELD-DEFS  "ry/obj/gsmsxfullo.i"
 
/* Error handling definitions */
{checkerr.i &define-only = YES}

{src/adm2/globals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DataLogicProcedure
&Scoped-define DB-AWARE yes


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF





/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calculatescmXrefOwningCode DataLogicProcedure  _DB-REQUIRED
FUNCTION calculatescmXrefOwningCode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isFieldBlank DataLogicProcedure 
FUNCTION isFieldBlank RETURNS LOGICAL
  ( INPUT pcFieldValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DataLogicProcedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE APPSERVER DB-AWARE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DataLogicProcedure ASSIGN
         HEIGHT             = 19.86
         WIDTH              = 68.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DataLogicProcedure 
/* ************************* Included-Libraries *********************** */
 
{src/adm2/logic.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DataLogicProcedure 


/* ***************************  Main Block  ******************************* */
 
{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPreTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE createPreTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate records server-side before the transaction scope upon create
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.
 
 
  ASSIGN
    ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject DataLogicProcedure  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cWhere                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cAttrValue            AS CHARACTER  NO-UNDO.

  /* Check if there is a run attribute set for filtering the result set of the
     SDO using the owning_entity_mnemonic */
  {get runAttribute cAttrValue}.
  IF cAttrValue NE "":U THEN
      ASSIGN cWhere = "gsm_scm_xref.owning_entity_mnemonic = " + QUOTER(cAttrValue).

  IF cWhere <> "":U THEN
  DO:
    DYNAMIC-FUNCTION("addQueryWhere":U IN TARGET-PROCEDURE, INPUT cWhere, ?, "AND":U).

    ASSIGN cWhere = cWhere +  CHR(3) + CHR(3) + "AND":U.
    {set manualAddQueryWhere cWhere}.
  END.    /* new WHERE clause is only included when there are valid attributes */

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip DataLogicProcedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  {ry/app/ryplipkill.i}
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription DataLogicProcedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/
 
  DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.
 
  ASSIGN cDescription = "Template PLIP".
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup DataLogicProcedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  {ry/app/ryplipsetu.i}  
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown DataLogicProcedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  {ry/app/ryplipshut.i}
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate DataLogicProcedure 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObject record client-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.
 
  IF b_gsm_scm_xref.scm_tool_obj = 0 OR b_gsm_scm_xref.scm_tool_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {aferrortxt.i 'AF' '1' 'gsm_scm_xref' 'scm_tool_obj' "'SCM tool obj'"}.
 
  IF isFieldBlank(b_gsm_scm_xref.owning_entity_mnemonic) THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {aferrortxt.i 'AF' '1' 'gsm_scm_xref' 'owning_entity_mnemonic' "'Owning entity'"}.

/*   IF isFieldBlank(b_gsm_scm_xref.owning_reference) THEN                                               */
/*     ASSIGN                                                                                            */
/*       cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + */
/*                     {aferrortxt.i 'AF' '1' 'gsm_scm_xref' 'owning_reference' "'Owning reference'"}.   */
  
  ASSIGN
    ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writePreTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE writePreTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate records server-side before the transaction scope upon write
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE cMessageList     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cValueList       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cOwningReference AS CHARACTER   NO-UNDO.
 
  IF b_gsm_scm_xref.owning_obj = 0 THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) +
                    {aferrortxt.i 'AF' '1' 'gsm_scm_xref' 'owning_obj' "'Owning obj'"}.
  
/* Assign the value of the gsm_scm_xref.owning-reference field 
     - this field is not visible in the maintenance viewer*/
  ASSIGN cOwningReference = REPLACE(STRING(b_gsm_scm_xref.owning_obj), SESSION:NUMERIC-DECIMAL-POINT, ".":U).
  IF b_gsm_scm_xref.owning_reference NE cOwningReference THEN
    ASSIGN b_gsm_scm_xref.owning_reference = cOwningReference.
  
  ASSIGN
    ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calculatescmXrefOwningCode DataLogicProcedure  _DB-REQUIRED
FUNCTION calculatescmXrefOwningCode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Calculate the code field value of the owning entity mnemonic. 
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hRowObject        AS HANDLE NO-UNDO.
DEFINE VARIABLE hOwningEntity     AS HANDLE NO-UNDO.
DEFINE VARIABLE hOwningEntityObj  AS HANDLE NO-UNDO.

DEFINE VARIABLE cEntityFields     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntityValues     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dOwningObj        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cObjFieldName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodeFieldValue AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodeFieldName  AS CHARACTER  NO-UNDO.

  hRowObject  = DYNAMIC-FUNCTION('getRowObject':U IN TARGET-PROCEDURE).
  hOwningEntityObj = hRowObject:BUFFER-FIELD('owning_obj':U).
  hOwningEntity    = hRowObject:BUFFER-FIELD('owning_entity_mnemonic':U).
 
  cObjFieldName = DYNAMIC-FUNCTION('getObjField' IN gshGenManager, INPUT hOwningEntity:BUFFER-VALUE).

  cCodeFieldName = replace(cObjFieldName, "_obj":U, "_code":U). 
  
  RUN getEntityDescription IN gshGenManager (INPUT hOwningEntity:BUFFER-VALUE,
                                             INPUT DECIMAL(hOwningEntityObj:BUFFER-VALUE),
                                             INPUT cCodeFieldName,
                                             OUTPUT cCodeFieldValue).
  IF cCodeFieldValue NE "":U THEN
    RETURN cCodeFieldValue. 
  ELSE  
    RETURN "".   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isFieldBlank DataLogicProcedure 
FUNCTION isFieldBlank RETURNS LOGICAL
  ( INPUT pcFieldValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Checks whether a character field is blank
    Notes:  
------------------------------------------------------------------------------*/
 
  IF LENGTH(TRIM(pcFieldValue)) = 0 OR LENGTH(TRIM(pcFieldValue)) = ? THEN
    RETURN TRUE.
  ELSE
    RETURN FALSE.   /* Function return value. */
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

