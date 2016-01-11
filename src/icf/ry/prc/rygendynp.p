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
/*---------------------------------------------------------------------------------
  File: rygendynp.p

  Description:  Procedure that generates a dynamic objec

  Purpose:      This procedure is parallel to adeshar/_gen4gl.p (which writes AppBuilder
                design windows out as 4GL files.)  rygendynp.p is designed to write
                any window designed in the AppBuilder into the Dynamics repository in the
                form of a dynamic object.
                
                In the first pass, only SmartDataViewers and SmartDataBrowsers will
                be supported. Future versions will support more kinds of objects.

  Parameters:   INPUT  pPrecid - the Recid of the _P record to write
                OUTPUT pError  - Error message if object can't be written

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/13/2002  Author:     Ross Hunter

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rygendynp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

&GLOBAL-DEFINE Add-To-Name-List    cAttributeNames  = cAttributeNames + ",":U + cAttr
&GLOBAL-DEFINE Add-To-Value-List   cAttributeValues = cAttributeValues + CHR(3) +
&GLOBAL-DEFINE If-not-default      IF hAttributeBuffer:BUFFER-FIELD(cAttr):BUFFER-VALUE() NE
&GLOBAL-DEFINE RUN-CreateInstAttr  RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr,
&GLOBAL-DEFINE RUN-CreateMastAttr  RUN CreateAttributeRow(INPUT "MASTER":U, INPUT dSmartobject_obj, INPUT cAttr,

{src/adm2/globals.i}

  DEFINE INPUT  PARAMETER pPrecid AS RECID      NO-UNDO.
  DEFINE OUTPUT PARAMETER pError  AS CHARACTER  NO-UNDO.

  {adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
  {adeuib/custwidg.i}     /* _custom & _palette_item temp-table defs           */
  {adeuib/layout.i}       /* Layout temp-table definitions                     */
  {adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
  {adeuib/brwscols.i}     /* Browse Column Temp-table                          */
  {adeuib/sharvars.i}     /* Shared variables                                  */
  {adeuib/links.i}
  {ry/inc/ryrepatset.i}   /* Temp-table definition for ttAttribute             */
  {af/app/afdatatypi.i}   /* Standard icf data-type includes                   */
  {adeuib/bld_tbls.i}     /* Build table list procedure                        */
  {ry/app/rydefrescd.i}   /* Defines the DEFAULT-RESULT-CODE result codes. */

  &GLOBAL-DEFINE Create-Log-Instance  {&RUN-CreateInstAttr} INPUT {&LOGICAL-DATA-TYPE}, ?, ?, ?,
  &GLOBAL-DEFINE Create-Char-Instance {&RUN-CreateInstAttr} INPUT {&CHARACTER-DATA-TYPE},
  &GLOBAL-DEFINE Create-Int-Instance  {&RUN-CreateInstAttr} INPUT {&INTEGER-DATA-TYPE}, ?, ?,
  &GLOBAL-DEFINE Create-Dec-Instance  {&RUN-CreateInstAttr} INPUT {&DECIMAL-DATA-TYPE}, ?,

  &GLOBAL-DEFINE Create-Log-Master  {&RUN-CreateMastAttr} INPUT {&LOGICAL-DATA-TYPE}, ?, ?, ?,
  &GLOBAL-DEFINE Create-Char-Master {&RUN-CreateMastAttr} INPUT {&CHARACTER-DATA-TYPE},
  &GLOBAL-DEFINE Create-Int-Master  {&RUN-CreateMastAttr} INPUT {&INTEGER-DATA-TYPE}, ?, ?,
  &GLOBAL-DEFINE Create-Dec-Master  {&RUN-CreateMastAttr} INPUT {&DECIMAL-DATA-TYPE}, ?,
  
  &GLOBAL-DEFINE Delete-Instance-Attribute IF LOOKUP(cWhereStored,"4,5,6,7,12,13,14,15":U) > 0 THEN ~
                                           RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr)
  &GLOBAL-DEFINE Delete-Master-Attribute   IF lookup(cWhereStored,"2,3,6,7,10,11,14,15":U) > 0 THEN ~
                                           RUN DeleteAttributeRow (INPUT "MASTER":U, INPUT dSmartobject_obj, INPUT cAttr)
  

  &GLOBAL-DEFINE IF-SDO   IF VALID-HANDLE(hDataSource) AND DYNAMIC-FUNCTION(
  &GLOBAL-DEFINE SAME-AS  IN hDataSource, b_U._NAME) =
  &GLOBAL-DEFINE NO-OP    THEN DO: END.
  
  /* DeleteAttribute is the temp-table that is passed to RemoveAttributeValues to delete
     attributes */
  DEFINE TEMP-TABLE DeleteAttribute LIKE ttStoreAttribute.
  
  DEFINE TEMP-TABLE DeleteUIEvent LIKE ttStoreUIEvent.

  DEFINE VARIABLE BrowseRecid          AS RECID                   NO-UNDO.
  DEFINE VARIABLE cAttributeValues     AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cAttributeNames      AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cAttr                AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cClassName           AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cContainer           AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cDBName              AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cFont                AS CHARACTER  INITIAL "?"  NO-UNDO.
  DEFINE VARIABLE cLookupVal           AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cObjClassType        AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cOBJProductModule    AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cResultCodes         AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cSuperPref           AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cWhereStored         AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE FrameRecid           AS RECID                   NO-UNDO.
  DEFINE VARIABLE gcProfileData        AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE lMigration           AS LOGICAL                 NO-UNDO.
  DEFINE VARIABLE MinHeight            AS DECIMAL                 NO-UNDO.
  DEFINE VARIABLE MinWidth             AS DECIMAL                 NO-UNDO.
  DEFINE VARIABLE QueryRecid           AS RECID                   NO-UNDO.
  DEFINE VARIABLE sdoName              AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE hDataSource          AS HANDLE                  NO-UNDO.
  DEFINE VARIABLE cObjectName          AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE dSmartObject         AS DECIMAL                 NO-UNDO.
  DEFINE VARIABLE cFldSmartObject      AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE dDynObject_obj       AS DECIMAL                 NO-UNDO.
  DEFINE VARIABLE dSmartObject_obj     AS DECIMAL                 NO-UNDO.
  DEFINE VARIABLE i                    AS INTEGER                 NO-UNDO.
  DEFINE VARIABLE WhereStoredNumEntries   AS INTEGER              NO-UNDO.
  DEFINE VARIABLE gcUpdColsByTable     AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE gcTableList          AS CHARACTER               NO-UNDO.
         /* BldSeq is the sequence in which DynCombo's get built */

  /* The following are necessary to get the class attributes for the object */
  DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE             NO-UNDO.
  DEFINE VARIABLE hClassBufferCache         AS HANDLE             NO-UNDO.
  DEFINE VARIABLE hAttributeBuffer          AS HANDLE             NO-UNDO.
  DEFINE VARIABLE hClassTable               AS HANDLE  EXTENT 32  NO-UNDO.
  DEFINE VARIABLE hUnknown                  AS HANDLE             NO-UNDO.

  /* The handle to the SCM tool is needed in some places to get info from the SCM tool */
  DEFINE VARIABLE ghSCMTool                 AS HANDLE                  NO-UNDO.          
      
  /* define variables to use for the message formatting */
  DEFINE VARIABLE cIgnore                   AS CHARACTER          NO-UNDO.
  DEFINE VARIABLE lIgnore                   AS LOGICAL            NO-UNDO.

  DEFINE TEMP-TABLE sdoHandle NO-UNDO
     FIELD SDOName AS CHARACTER
     FIELD SDOHandle AS HANDLE
    INDEX sdoName sdoName.

  DEFINE TEMP-TABLE tResultCodes NO-UNDO
     FIELD cRC AS CHARACTER
     FIELD dContainerObj AS DECIMAL LABEL "Master Obj"
    INDEX cRC cRC.

  DEFINE STREAM P_4GLSDO.

  /* FUNCTION PROTOTYPE */
  FUNCTION db-tbl-name RETURNS CHARACTER
    (INPUT db-tbl AS CHARACTER) IN _h_func_lib.

  FUNCTION dbtt-fld-name RETURNS CHARACTER
    (INPUT _BC-Recid AS RECID) IN _h_func_lib.

  {afcheckerr.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckCustomChanges Procedure 
FUNCTION CheckCustomChanges RETURNS CHARACTER
  ( INPUT p_LRecid AS RECID, plCreate AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: ry/prc
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
         HEIGHT             = 17.48
         WIDTH              = 73.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE designAction AS CHARACTER  NO-UNDO.

ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                      INPUT "RepositoryDesignManager":U).

/* Write the gsc_object (and its associated ryc_smartobject record) record for this object */
RUN writeObject (INPUT  pPrecid,   /* Recid of _P record in the AppBuilder    */
                 OUTPUT pError).   /* Error message (if any)                  */

IF pError EQ "" OR 
   pError BEGINS "Associated SDO" THEN
  /* Write 4GL super procedure if a new viewer or browser */
  RUN writeSuperProc (INPUT  pPrecid,   /* Recid of _P record in the AppBuilder */
                      OUTPUT pError).   /* Error message (if any)               */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-AppendToPError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AppendToPError Procedure 
PROCEDURE AppendToPError :
/*------------------------------------------------------------------------------
  Purpose:     When an error is found, either in the ERROR-STATUS handle or
               a RETURN-VALUE, this appends it to pError so that it can be
               either placed in the log file of the migration tool or displayed
               on the screen. 
  Parameters:
        INPUT pcReturnValue        - Return value of last procedure called
        INPUT-OUTPUT pError        - Current pError string
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER pcReturnValue  AS CHARACTER             NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pError         AS CHARACTER             NO-UNDO.

  DEFINE VARIABLE iErrorLoop AS INTEGER                                 NO-UNDO.

  IF pcReturnValue NE "":U THEN DO:
    /* This has been formatted by CheckErr.i - reformat it by afmessagep.p before
       adding it to pError.                                                    */

    IF VALID-HANDLE(gshAstraAppServer) THEN
      RUN af/app/afmessagep.p ON gshAstraAppserver
                             (INPUT  pcReturnValue,
                              INPUT  "":U,
                              INPUT  "":U,
                              OUTPUT pcReturnValue,
                              OUTPUT cIgnore,
                              OUTPUT cIgnore,
                              OUTPUT cIgnore,
                              OUTPUT lIgnore,
                              OUTPUT lIgnore) 
                              NO-ERROR.
    pError = pError + (IF pError = "":U THEN "":U ELSE CHR(10)) + pcReturnValue.
  END. /* If the return value is non-blank */
  ELSE DO:
    /* Copy all ERROR-STATUS messages to pError */
    DO iErrorLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
      pError = pError + (IF pError = "":U THEN "":U ELSE CHR(10)) +
                 ERROR-STATUS:GET-MESSAGE(iErrorLoop).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-BuildSDOFieldListsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildSDOFieldListsByTable Procedure 
PROCEDURE BuildSDOFieldListsByTable :
/*------------------------------------------------------------------------------
  Purpose:     Several SDO attributes are fields broken by Table.  This procedure 
               contructs them.  (In particular... cAssignList, cUpdateColumnsByTable
               and cDataColumnsByTable
  Parameters:
     INPUT  pURecid              = Recid of _U for query of SDO
            pcTables             - The list of tables participating in the SDO
     OUTPUT pcAssignList         - List of fields that have different names from
                                   their DB field counterparts
            pcUpdatableColumnsByTable
            pcDataColumnsByTable  
  Notes: The 3 output lists are comma delimited but each table group is separated
         with a semi-colon (;) 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pURecid                     AS RECID          NO-UNDO.
  DEFINE INPUT  PARAMETER pcTables                    AS CHARACTER      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAssignList                AS CHARACTER      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUpdatableColumnsByTable   AS CHARACTER      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcDataColumnsByTable        AS CHARACTER      NO-UNDO.

  DEFINE VARIABLE i                                   AS INTEGER        NO-UNDO.

  DEFINE VARIABLE lCalcColumn                         AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE lUpdtCalcColumn                     AS LOGICAL        NO-UNDO.

  DO i = 1 TO NUM-ENTRIES(pcTables):

    /* pcAssignList */
    pcAssignList = pcAssignList + ";":U.
    FOR EACH _BC WHERE _BC._x-recid = pURecid 
                   AND _BC._DBNAME <> "_<CALC>":U
                   AND _BC._TABLE = ENTRY(i,pcTables)
                   AND _BC._DISP-NAME <> _BC._NAME 
                   AND _BC._DISP-NAME <> ?
                   AND _BC._DISP-NAME <> "":U
                   AND _BC._NAME <> "":U
                   AND _BC._NAME <> ?
                 BY _BC._SEQUENCE:
      ASSIGN pcAssignList = pcAssignList + _BC._DISP-NAME + ",":U + 
                                           _BC._NAME + ",":U.
    END. /* FOR EACH _BC */
    pcAssignList = TRIM(pcAssignList, ",":U).

      
    /* pcDataColumnsByTable and pcUpdatableColumnsByTable */
    ASSIGN pcDataColumnsByTable      = pcDataColumnsByTable + ";":U
           pcUpdatableColumnsByTable = pcUpdatableColumnsByTable + ";":U.
    FOR EACH _BC WHERE _BC._x-recid = pURecid 
                 AND _BC._DBNAME <> "_<CALC>":U
                 AND _BC._TABLE = ENTRY(i,pcTables)
                 AND _BC._DISP-NAME <> ?
                 AND _BC._DISP-NAME <> "":U
                 BY _BC._SEQUENCE:
      ASSIGN pcDataColumnsByTable = pcDataColumnsByTable + _BC._DISP-NAME + ",":U.
      IF _BC._ENABLED THEN
        ASSIGN pcUpdatableColumnsByTable = pcUpdatableColumnsByTable + 
                                           _BC._DISP-NAME + ",":U.
    END. /* FOR EACH _BC */
    ASSIGN pcDataColumnsByTable      = TRIM(pcDataColumnsByTable,",":U)
           pcUpdatableColumnsByTable = TRIM(pcUpdatableColumnsByTable,",":U).
  END.  /* Do i for all of the tables */
  /* Remove 1st ";" */
  ASSIGN pcAssignList              = SUBSTRING(pcAssignList, 2, -1, "CHARACTER":U)
         pcDataColumnsByTable      = SUBSTRING(pcDataColumnsByTable, 2, -1, "CHARACTER":U)
         pcUpdatableColumnsByTable = SUBSTRING(pcUpdatableColumnsByTable, 2, -1, "CHARACTER":U).

  /* Now that all of the table columns are done, add any calculated fields to
     pcDataColumnsByTable and pcUpdatableColumnsByTable */
  ASSIGN lCalcColumn              = NO
         lUpdtCalcColumn          = NO.
  FOR EACH _BC WHERE _BC._x-recid = pURecid 
               AND _BC._DBNAME = "_<CALC>":U
               AND _BC._DISP-NAME <> ?
               AND _BC._DISP-NAME <> "":U
               BY _BC._SEQUENCE:
    ASSIGN pcDataColumnsByTable = pcDataColumnsByTable + 
                                    (IF NOT lCalcColumn THEN ";":U ELSE ",") + 
                                        _BC._DISP-NAME
           lCalcColumn          = YES.      /* We have one */
    IF _BC._ENABLED THEN
      ASSIGN pcUpdatableColumnsByTable = pcUpdatableColumnsByTable + 
                                           (IF NOT lUpdtCalcColumn THEN ";":U ELSE ",") +
                                           _BC._DISP-NAME 
             lUpdtCalcColumn           = YES.  /* We have one */
  END. /* FOR EACH _BC */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-BuildSDOSimpleLists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildSDOSimpleLists Procedure 
PROCEDURE BuildSDOSimpleLists :
/*------------------------------------------------------------------------------
  Purpose:    To construct simple list of SDO informationthat map directly to 
              _BC records.  These lists are: cDataColumns, cUpdatableColumns, 
              cQBFieldDataTypes, cQBFieldDBNames, cQBFieldWidths 
              and cQBInhVals
  Parameters:
     INPUT  pURecid              - Record id of _U of SDO query
     OUTPUT pcDataColumns        - Names (displayNames) of the columns of the SDO
     OUTPUT pcUpdatableColumns   - Name of columns that are updatable
     OUTPUT pcInstanceColumns    - Columns whose attributes are stored at the instnace level
     OUTPUT pcQBFieldDataTypes   - Data-types of the columns
     OUTPUT pcQBFieldDBNames     - DBNAMEs of the columns
     OUTPUT pcQBFieldWidths      - Integer widths of the fields
     OUTPUT pcQBInhVals          - List of Yes/No values indicating if dictionary
                                   validation is to be used
  Notes:  pcQBFieldFormats, pcQBFieldHelp and pcQBFieldLabels are delimited by CHR(5), 
          the rest are by comma (,)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pURecid                  AS RECID            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDataColumns            AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcUpdatableColumns       AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcInstanceColumns        AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldDataTypes       AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldDBNames         AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldWidths          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBInhVals              AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE curTableName                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE hField                           AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hTableBuffer                     AS HANDLE           NO-UNDO.
    DEFINE VARIABLE i                                AS INTEGER          NO-UNDO.
    DEFINE VARIABLE lFormatsBlank                    AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lHelpBlank                       AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lLabelsBlank                     AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lValidateBlank                   AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lWidthsBlank                     AS LOGICAL          NO-UNDO.


    curTableName = "":U.
    FOR EACH _BC WHERE _BC._x-recid = pURecid
             AND _BC._DISP-NAME <> ?
             AND _BC._DISP-NAME <> "":U
             BY _BC._SEQUENCE:

      /* To determine the default width - create a buffer and ask */
      IF curTableName NE _BC._TABLE THEN DO:
        IF VALID-HANDLE(hTableBuffer) THEN DELETE WIDGET hTablebuffer.
        CREATE BUFFER hTableBuffer FOR TABLE _BC._TABLE NO-ERROR.
      END.
      IF VALID-HANDLE(hTableBuffer) THEN
        hField = hTableBuffer:BUFFER-FIELD(_BC._NAME) NO-ERROR.

      ASSIGN pcDataColumns      = pcDataColumns      + _BC._DISP-NAME              + ",":U
             pcQBFieldDataTypes = pcQBFieldDataTypes + _BC._DATA-TYPE              + ",":U
             pcQBFieldDBNames   = pcQBFieldDBNames   + _BC._DBNAME                 + ",":U
             pcQBFieldWidths    = pcQBFieldWidths    + (IF VALID-HANDLE(hField) AND INTEGER(_BC._WIDTH)
                                                          = INTEGER(hField:WIDTH) THEN "?":U ELSE
                                                            STRING(INTEGER(_BC._WIDTH))) + ",":U
             pcQBInhVals        = pcQBInhVals        + IF _BC._INHERIT-VALIDATION 
                                                       THEN "Yes,":U ELSE "No,":U.

      IF _BC._ENABLED THEN
        ASSIGN pcUpdatableColumns = pcUpdatableColumns + _BC._DISP-NAME + ",":U.
      IF _BC._INSTANCE-LEVEL THEN
        ASSIGN pcInstanceColumns  = pcInstanceColumns  + _BC._DISP-NAME + ",":U.
    END. /* FOR EACH _BC */

    /* Trim trailing delimiter */
    ASSIGN pcDataColumns      = RIGHT-TRIM(pcDataColumns,      ",":U)
           pcUpdatableColumns = RIGHT-TRIM(pcUpdatableColumns, ",":U)
           pcQBFieldDataTypes = RIGHT-TRIM(pcQBFieldDataTypes, ",":U)
           pcQBFieldDBNames   = RIGHT-TRIM(pcQBFieldDBNames,   ",":U)
           pcQBFieldWidths    = RIGHT-TRIM(pcQBFieldWidths,    ",":U)
           pcQBInhVals        = RIGHT-TRIM(pcQBInhVals,        ",":U)
           pcInstanceColumns  = RIGHT-TRIM(pcInstanceColumns,  ",":U).
    /* Note: it is possible if the last few help strings are blank, that you could TRIM too
       many CHR(5)'s from its string.  It is better to just remove the one that we know is
       there. We will do this after we determine that we can't blank out the entire string */

    /* We want to blank out attributes that have all default values so as to not write
       the attribute to the repository                                                    */
    ASSIGN lFormatsBlank  = YES
           lHelpBlank     = YES
           lLabelsBlank   = YES
           lValidateBlank = YES
           lWidthsBlank   = YES.
    DO i = 1 TO NUM-ENTRIES(pcQBInhVals):
      IF ENTRY(i,pcQBInhVals) NE "NO":U               THEN lValidateBlank = NO.
      IF ENTRY(i,pcQBFieldWidths) NE "?":U            THEN lWidthsBlank   = NO.
    END.

    IF lValidateBlank THEN pcQBInhVals      = "":U.
    IF lWidthsBlank   THEN pcQBFieldWidths  = "":U.

   IF VALID-HANDLE(hTableBuffer) THEN DELETE WIDGET hTableBuffer.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkDataFieldMaster) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkDataFieldMaster Procedure 
PROCEDURE checkDataFieldMaster :
/*------------------------------------------------------------------------------
  Purpose:     To make sure we don't override master datafield attributes with 
               identical instance attributes.
  Parameters:  pcObjectFilename  Name of the datafield being modified
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectFilename AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdInstance_obj   AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cDel                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDelete                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRadioSet                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iEnt                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSearch                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rDelimiterAttribute      AS RECID      NO-UNDO.

  FIND ryc_smartObject NO-LOCK
      WHERE ryc_smartObject.object_filename = pcObjectFilename NO-ERROR.
  
  IF NOT AVAILABLE ryc_smartObject THEN DO:
      pError = perror + (IF perror = "" THEN "" ELSE (Chr(10)+ CHR(10)) )
                      + pcObjectFilename 
                      + " datafield has no master object in the repository." + CHR(10) 
                      + "Run the Object Generator to create it.".
    RETURN.
  END.

  /* Before we begin, collect some info and reformat Radio-Set buttons */
  FIND ttStoreAttribute WHERE ttStoreAttribute.tAttributeParent = "INSTANCE":U AND
          ttStoreAttribute.tAttributeParentObj = pdInstance_obj AND
          ttStoreAttribute.tAttributeLabel = "VisualizationType" NO-ERROR.
  IF AVAILABLE ttStoreAttribute AND 
      LOOKUP(ttStoreAttribute.tCharacterValue,"RADIO-SET,COMBO-BOX,SELECTION-LIST":U) > 0 THEN DO:
    /* We have a radio-set, combo or selection list */

    /* Set a flag to indicate a radio-set for special processing later*/
    lRadioset = (ttStoreAttribute.tCharacterValue = "RADIO-SET":U).

    FIND ttStoreAttribute WHERE  ttStoreAttribute.tAttributeParent = "INSTANCE":U AND
              ttStoreAttribute.tAttributeParentObj = pdInstance_obj AND
              ttStoreAttribute.tAttributeLabel = "Delimiter" NO-ERROR.

    IF AVAILABLE ttStoreAttribute  THEN /* Save the delimiter */
      cDel = ttStoreAttribute.tCharacterValue.

    IF lRadioSet THEN DO:
      /* Radio-Buttons need to have the Quotes, Spaces and <CR>s trimmed */
      FIND ttStoreAttribute WHERE  ttStoreAttribute.tAttributeParent = "INSTANCE":U AND
             ttStoreAttribute.tAttributeParentObj = pdInstance_obj AND
             ttStoreAttribute.tAttributeLabel = "RADIO-BUTTONS":U
             NO-ERROR.
      IF AVAILABLE ttStoreAttribute THEN DO:
        ttStoreAttribute.tCharacterValue = REPLACE(ttStoreAttribute.tCharacterValue, CHR(10), "":U).
        DO iEnt = 1 TO NUM-ENTRIES(ttStoreAttribute.tCharacterValue, cDel):
          ENTRY(iEnt, ttStoreAttribute.tCharacterValue, cDel) = 
               TRIM(ENTRY(iEnt, ttStoreAttribute.tCharacterValue, cDel), ' "':U).
        END. /* Loop to trim entries */
      END.  /* If the record is available */
    END.  /* if a radio-set */
  END.  /* If a radio-set, combo or Selection-list */


  FOR EACH ttStoreAttribute
    WHERE ttStoreAttribute.tAttributeParent = "INSTANCE":U AND
          ttStoreAttribute.tAttributeParentObj = pdInstance_obj AND
          LOOKUP(ttStoreAttribute.tAttributeLabel, "ROW,COLUMN":U) = 0:
    
    /* Get the master attribute */
    FIND ryc_attribute_value NO-LOCK
         WHERE ryc_attribute_value.smartobject_obj = ryc_smartObject.smartobject_obj AND
               ryc_attribute_value.object_instance_obj = 0.0 AND
               ryc_attribute_value.attribute_label = ttStoreAttribute.tAttributeLabel AND
               ryc_attribute_value.object_type_obj = ryc_smartobject.object_type_obj NO-ERROR.
    IF AVAILABLE ryc_attribute_value THEN DO: /* Compare the master value */
      FIND ryc_attribute NO-LOCK /* Need to know the datatype */
          WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label NO-ERROR.
      IF AVAILABLE ryc_attribute THEN DO:
        lDelete = FALSE.
        CASE ryc_attribute.data_type:
           WHEN {&DECIMAL-DATA-TYPE}   THEN 
               IF ryc_attribute_value.decimal_value = ttStoreAttribute.tDecimalValue 
               THEN lDelete = TRUE.
           WHEN {&INTEGER-DATA-TYPE}   THEN 
               IF ryc_attribute_value.integer_value = ttStoreAttribute.tIntegerValue 
               THEN lDelete = TRUE.
           WHEN {&DATE-DATA-TYPE}      THEN 
               IF ryc_attribute_value.date_value = ttStoreAttribute.tDateValue 
               THEN lDelete = TRUE.
           WHEN {&RAW-DATA-TYPE}       THEN
               DO:   /* Not supported yet */
               END.
           WHEN {&LOGICAL-DATA-TYPE}   THEN 
               IF ryc_attribute_value.logical_value = ttStoreAttribute.tLogicalValue 
               THEN lDelete = TRUE.
           WHEN {&CHARACTER-DATA-TYPE} THEN 
               IF ryc_attribute_value.character_value = ttStoreAttribute.tCharacterValue 
               THEN lDelete = TRUE.
        END CASE.
        IF lDelete THEN DELETE ttStoreAttribute.
      END.  /* If we have the attribute record */
    END.  /* If we have the Master attribute record */
  END. /* FOR EACH ttStoreAttribute */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-collectBrowseColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectBrowseColumns Procedure 
PROCEDURE collectBrowseColumns :
/*------------------------------------------------------------------------------
  Purpose:     To make a single pass through the _BC records of a browse
               and retrieve all attribute information on them. 
  Parameters:  INPUT bRecid_U - The recid of the _U of the browse
               OUTPUT fldList        - comma delimited list of browse column name
                      cEnabledFields - comma delimited list of enabled fields
                      cColBGCs       - CHR(5) delimited list of Background colors
                      cColFGCs       - CHR(5) delimited list of Foreground colors
                      cColFonts      - CHR(5) delimited list of Fonts
                      cColFormats    - CHR(5) delimited list of Formats
                      cLblBGCs       - CHR(5) delimited list of label BGCs
                      cLblFGCs       - CHR(5) delimited list of label FGCs
                      cLblFonts      - CHR(5) delimited list of label Fonts
                      cLabels        - CHR(5) delimited list of labels
                      cWidths        - CHR(5) delimited list of widths (integer 
                                       values only)
  Notes:  All CHR(5) delimited list must have the same number of entries as the
          fldlist.
          IF all values of a CHR(5) delimited list is the default value (usually
          ? or blank, then the entire list is blank   
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER bRecid_U           AS RECID      NO-UNDO.
  DEFINE OUTPUT PARAMETER fldList            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cEnabledFields     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cColBGCs           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cColFGCs           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cColFonts          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cColFormats        AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cLblBGCs           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cLblFGCs           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cLblFonts          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cLabels            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER cWidths            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE         iLoop              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         NumCols            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iColBGCs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iColFGCs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iColFonts          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iColFormats        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iLblBGCs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iLblFGCs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iLblFonts          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iLabels            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         hcol-hdl           AS HANDLE     NO-UNDO.

  DEFINE BUFFER brws_U FOR _U.

  /* First resequence the columns as the user may have shuffled them with the mouse */
  FIND brws_U WHERE RECID(brws_U) = bRecid_U.
  ASSIGN iLoop    = 1
         hcol-hdl = brws_U._HANDLE:FIRST-COLUMN WHEN VALID-HANDLE(brws_U._HANDLE).
  FOR EACH _BC WHERE _BC._x-recid = bRecid_U:
     _BC._SEQUENCE = _BC._SEQUENCE * -1.
  END.
  DO WHILE VALID-HANDLE(hcol-hdl):
    FIND _BC WHERE _BC._x-recid    = bRecid_U AND
                   _BC._COL-HANDLE = hcol-hdl NO-ERROR.
    IF AVAILABLE _BC THEN
      ASSIGN _BC._SEQ = iLoop
             iLoop    = iLoop + 1.
    hcol-hdl  = hcol-hdl:NEXT-COLUMN.
  END.  /* DO WHILE VALID-HANDLE */

  FOR EACH _BC WHERE _BC._x-recid = bRecid_U:
    ASSIGN fldList = fldList + "," + _BC._NAME
           cEnabledFields = cEnabledFields + (IF _BC._ENABLED THEN ",":U + _BC._NAME ELSE "":U)
           cColBGCs       = cColBGCs    + CHR(5) + IF _BC._BGCOLOR = ? THEN "?":U
                                                   ELSE STRING(_BC._BGCOLOR)
           cColFGCs       = cColFGCs    + CHR(5) + IF _BC._FGCOLOR = ? THEN "?":U
                                                   ELSE STRING(_BC._FGCOLOR)
           cColFonts      = cColFonts   + CHR(5) + IF _BC._FONT = ? THEN "?":U
                                                   ELSE STRING(_BC._FONT)
           cColFormats    = cColFormats + CHR(5) + IF _BC._FORMAT = _BC._DEF-FORMAT THEN "?":U
                                                   ELSE _BC._FORMAT
           cLblBGCs       = cLblBGCs    + CHR(5) + IF _BC._LABEL-BGCOLOR = ? THEN "?":U
                                                   ELSE STRING(_BC._LABEL-BGCOLOR)
           cLblFGCs       = cLblFGCs    + CHR(5) + IF _BC._LABEL-FGCOLOR = ? THEN "?":U
                                                   ELSE STRING(_BC._LABEL-FGCOLOR)
           cLblFonts      = cLblFonts   + CHR(5) + IF _BC._LABEL-FONT = ? THEN "?":U
                                                   ELSE STRING(_BC._LABEL-FONT)
           cLabels        = cLabels     + CHR(5) + IF _BC._LABEL = _BC._DEF-LABEL THEN "?":U
                                                   ELSE _BC._LABEL
           cWidths        = cWidths     + CHR(5) + STRING(INTEGER(_BC._WIDTH))

           NumCols        = NumCols     + 1
           iColBGCs       = iColBGCs    + IF _BC._BGCOLOR = ?              THEN 0 ELSE 1
           iColFGCs       = iColFGCs    + IF _BC._FGCOLOR = ?              THEN 0 ELSE 1
           iColFonts      = iColFonts   + IF _BC._FONT = ?                 THEN 0 ELSE 1
           iColFormats    = iColFormats + IF _BC._FORMAT = _BC._DEF-FORMAT THEN 0 ELSE 1
           iLblBGCs       = iLblBGCs    + IF _BC._LABEL-BGCOLOR = ?        THEN 0 ELSE 1
           iLblFGCs       = iLblFGCs    + IF _BC._LABEL-FGCOLOR = ?        THEN 0 ELSE 1
           iLblFonts      = iLblFonts   + IF _BC._LABEL-FONT = ?           THEN 0 ELSE 1
           iLabels        = iLabels     + IF _BC._LABEL = _BC._DEF-LABEL   THEN 0 ELSE 1
           .
  END.   /* Have looped through the fields and collected all of the info */

  /* Now TRIM and blank out all output parameters that are all defaults */

  ASSIGN fldList        = LEFT-TRIM(fldList, ",":U)
         cEnabledFields = LEFT-TRIM(cEnabledFields, ",":U)
         cColBGCs       = IF iColBGCs    GT 0 THEN SUBSTRING(cColBGCs,2,-1,"CHARACTER")    ELSE "":U
         cColFGCs       = IF iColFGCs    GT 0 THEN SUBSTRING(cColFGCs,2,-1,"CHARACTER")    ELSE "":U
         cColFonts      = IF iColFonts   GT 0 THEN SUBSTRING(cColFonts,2,-1,"CHARACTER")   ELSE "":U
         cColFormats    = IF iColFormats GT 0 THEN SUBSTRING(cColFormats,2,-1,"CHARACTER") ELSE "":U
         cLblBGCs       = IF iLblBGCs    GT 0 THEN SUBSTRING(cLblBGCs,2,-1,"CHARACTER")    ELSE "":U
         cLblFGCs       = IF iLblFGCs    GT 0 THEN SUBSTRING(cLblFGCs,2,-1,"CHARACTER")    ELSE "":U
         cLblFonts      = IF iLblFonts   GT 0 THEN SUBSTRING(cLblFonts,2,-1,"CHARACTER")   ELSE "":U
         cLabels        = IF iLabels     GT 0 THEN SUBSTRING(cLabels,2,-1,"CHARACTER")     ELSE "":U
         cWidths        = SUBSTRING(cWidths,2,-1,"CHARACTER").
         .
    /*
    MESSAGE "NumCols:" NumCols                SKIP
            "fldList:"  fldList               SKIP
            "cEnabledFields:"  cEnabledFields SKIP
            "cColBGCs:"        cColBGCs       SKIP
            "cColFGCs:"        cColFGCs       SKIP
            "cColFonts:"       cColFonts      SKIP
            "cColFormats:"     cColFormats    SKIP
            "cLblBGCs:"        cLblBGCs       SKIP
            "cLblFGCs:"        cLblFGCs       SKIP
            "cLblFonts:"       cLblFonts      SKIP
            "cLabels:"         cLabels        SKIP
            "cWidths:"         cWidths    VIEW-AS ALERT-BOX.
      */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ConstructTableList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ConstructTableList Procedure 
PROCEDURE ConstructTableList :
/*------------------------------------------------------------------------------
  Purpose:    To create a list of SDO tables
  Parameters: 
     INPUT  pURecid       - recid of _U of SDO window
     INPUT  pcQueryTables - List of tables in query (includes external tables)
     OUTPUT pcTables      - List that gets created
              
  Notes: This code was stolen from put_tbllist_internal in adeuib/_genproc.i     
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pPRecid         AS RECID                   NO-UNDO.
    DEFINE INPUT  PARAMETER pURecid         AS RECID                   NO-UNDO.
    DEFINE INPUT  PARAMETER pcQueryTables   AS CHARACTER               NO-UNDO.
    DEFINE OUTPUT PARAMETER pcTables        AS CHARACTER               NO-UNDO.
    
    DEFINE VARIABLE cnt                     AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE i                       AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE TblName                 AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE tbls-in-q               AS CHARACTER               NO-UNDO.

    /* Handle freeform query case if it exists */
    FIND _TRG WHERE _TRG._wRECID = pURecid AND
                    _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
    IF AVAILABLE _TRG THEN DO:
      ASSIGN tbls-in-q = pcQueryTables.

      RUN build_table_list (INPUT _TRG._tCODE, INPUT ",":U, 
                            INPUT NO, /* If this flag is set to yes, temp-tables
                                         do not work. */
                            INPUT-OUTPUT tbls-in-q).
    END.
    ELSE tbls-in-q = pcQueryTables.
    
    /* Build the tblList excluding external tables */
    cnt = NUM-ENTRIES(tbls-in-q).
    DO i = 1 TO cnt:
      TblName = ENTRY (1, TRIM (ENTRY (i,tbls-in-q)), " ").
      IF NOT CAN-DO (_P._xTblList, TblName) THEN DO:
        IF NUM-ENTRIES(TblName,".":U) > 1 THEN
          TblName = db-tbl-name(TblName).
        IF NOT CAN-DO(pcTables, TblName) THEN
          pcTables = pcTables + ",":U + TblName.
      END.  /* If not in the external table list */
    END.  /* DO i 1 to cnt */
  
    pcTables = LEFT-TRIM(pcTables, ",":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CreateAttributeRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateAttributeRow Procedure 
PROCEDURE CreateAttributeRow :
/*------------------------------------------------------------------------------
  Purpose:     To create another row in the ttAttribute table to pass to the 
               StoreAttributeValues to set attributes in the repository 
  Parameters:
        INPUT pcObjectLevel        - Must be CLASS, MASTER or INSTANCE
        INPUT pdSmartObject_obj    - Object id of the SmartObject
        INPUT pcAttributeLabel     - Label of the attribute to set
        INPUT piDataType           - DataType of the attribute
        INPUT pcValue              - Character Value
        INPUT pdeValue             - Decimal Value
        INPUT piValue              - Integer Value
        INPUT plValue              - Logical Value
        INPUT pdaValue             - Date Value
        INPUT prValue              - Raw Value
  Notes:  We assume that the constant value is always No and never do we get a 
          date or raw attribute.     
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectLevel      AS CHARACTER              NO-UNDO.
  DEFINE INPUT  PARAMETER pdSmartObject_obj  AS DECIMAL                NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeLabel   AS CHARACTER              NO-UNDO.
  DEFINE INPUT  PARAMETER piDataType         AS INTEGER                NO-UNDO.
  DEFINE INPUT  PARAMETER pcValue            AS CHARACTER              NO-UNDO.
  DEFINE INPUT  PARAMETER pdeValue           AS DECIMAL                NO-UNDO.
  DEFINE INPUT  PARAMETER piValue            AS INTEGER                NO-UNDO.
  DEFINE INPUT  PARAMETER plValue            AS LOGICAL                NO-UNDO.
  DEFINE INPUT  PARAMETER pdaValue           AS DATE                   NO-UNDO.
  DEFINE INPUT  PARAMETER prValue            AS RAW                    NO-UNDO.

  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = pcObjectLevel
         ttStoreAttribute.tAttributeParentObj = pdSmartObject_obj
         ttStoreAttribute.tAttributeLabel     = pcAttributeLabel
         ttStoreAttribute.tConstantValue      = NO.  /* Always no, otherwise we wouldn't be setting it */

  CASE piDataType:
      WHEN {&CHARACTER-DATA-TYPE} THEN ttStoreAttribute.tCharacterValue = pcValue.
      WHEN {&DECIMAL-DATA-TYPE}   THEN ttStoreAttribute.tDecimalValue   = pdeValue.
      WHEN {&INTEGER-DATA-TYPE}   THEN ttStoreAttribute.tIntegerValue   = piValue.
      WHEN {&LOGICAL-DATA-TYPE}   THEN ttStoreAttribute.tLogicalValue   = plValue.
      WHEN {&DATE-DATA-TYPE}      THEN ttStoreAttribute.tDateValue      = pdaValue.
      WHEN {&RAW-DATA-TYPE}       THEN ttStoreAttribute.tRawValue       = prValue.
      OTHERWISE                        ttStoreAttribute.tCharacterValue = pcValue.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CreateMasterSDF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateMasterSDF Procedure 
PROCEDURE CreateMasterSDF :
/*------------------------------------------------------------------------------
  Purpose:     To create a new MasterSDF
  Parameters:  
     INPUT     ph_s          - Handle to the running (in design mode) SDF to create
               pcSDFFileName - name of the SDF to create
               pcClassName   - Class name of the object to create
     OUTPUT    pdObjectId    - Object id of newly created master (0 if failed )
                            
  Notes:       This procedure is called when converting a static viewer containing
               an SDF that has no master.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER ph_s                             AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcSDFFileName                    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcClassName                      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pdObjectId                       AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cAttr                                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomSuperProc                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToolTip                                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue                                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dTmpObj                                  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE i                                        AS INTEGER    NO-UNDO.

  DEFINE BUFFER b_U FOR _U.
  DEFINE BUFFER b_P FOR _P.


  /* Get the underlying _P and _S temp-tables so we can create the master */
  FIND _S  WHERE _S._HANDLE = ph_s.
  FIND b_U WHERE b_U._x-recid = RECID(_S).
  FIND b_P WHERE b_P._window-handle = b_U._window-handle.

  /* Create ttAttribute records that will be used when creating the SDF   */

  /* Save dSmartobject_obj to be restored later.  It needs to be set to ?
     so that the CreateMasterAttribute proprocessors will work            */
  ASSIGN dTmpObj          = dSmartObject_obj
         dSmartObject_obj = ?.

  /* Loop through instance setting to create master attributes */
  DO i = 1 TO NUM-ENTRIES(_S._settings, CHR(3)):
    ASSIGN cAttr = ENTRY(i, _S._settings, CHR(3))
           cValue = ENTRY(2, cAttr, CHR(4))
           cAttr  = ENTRY(1, cAttr, CHR(4)).
    IF cValue NE "":U OR cAttr = "SDFFileName":U THEN DO:
      CASE cAttr:
        WHEN "SDFFileName":U THEN DO:
          {&Create-Char-Master} pcSDFFileName, ?, ?, ?, ?, ?).
        END.

        WHEN "FieldToolTip":U THEN DO:
          ASSIGN cToolTip = cValue.
          {&Create-Char-Master} cToolTip, ?, ?, ?, ?, ?).
        END.

        WHEN "CustomSuperProc":U THEN DO:
          ASSIGN cCustomSuperProc = cValue.
          {&Create-Char-Master} cCustomSuperProc, ?, ?, ?, ?, ?).
        END.

        WHEN "InnerLines":U or
        WHEN "BuildSequence":U THEN DO:
          {&Create-int-Master} cValue, ?, ?, ?).
        END.

        WHEN "Secured":U OR
        WHEN "EnableField":U OR
        WHEN "DisplayField":U OR
        WHEN "HideOnInit":U THEN DO:
          {&Create-log-Master} cValue, ?, ?).
        END.

        OTHERWISE
          {&Create-Char-Master} cValue, ?, ?, ?, ?, ?).
      END CASE.

    END. /* If there is a non-blank property value */
  END. /* loop through settings */

  /* Restore dSmartObject_obj */
  ASSIGN dSmartObject_obj = dTmpObj.

  /* Create master SDF object */
  DEFINE VARIABLE hTmp AS HANDLE     NO-UNDO.
  hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.

  RUN insertObjectMaster IN ghRepositoryDesignManager
    ( INPUT pcSDFFileName,           /* Object Name                         */
      INPUT "":U,                    /* Result Code                         */
      INPUT b_P.product_module_code, /* The Product Module                  */
      INPUT pcClassName,             /* Object Type Code                    */
      INPUT "Autogenerated Master":U + pcClassName +
            " from instance during migration", /* Description               */
      INPUT "":U,                    /* Path                                */
      INPUT "":U,                    /* Associated SDO                      */
      INPUT cCustomSuperProc,        /* SuperProcedure Name                 */
      INPUT NO,                      /* Not a template                      */
      INPUT NO,                      /* Don't treat as a static object      */
      INPUT "":U,                    /* Rendering Engine (Use Default)      */
      INPUT YES,                     /* Run persistently                    */
      INPUT cTooltip,                /* Tooltip                             */
      INPUT "":U,                    /* Required DB List                    */
      INPUT "":U,                    /* LayoutCode                          */
      INPUT hTmp,                    /* Attr Table Buffer handle            */
      INPUT TABLE-HANDLE hUnknown,   /* Table handle for attribute table    */
      OUTPUT pdObjectID) NO-ERROR.            /* Obj number for this object          */

   IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
     RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).
   
   /* Empty the temp-table */
   EMPTY TEMP-TABLE ttStoreAttribute.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CreateSBODLP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateSBODLP Procedure 
PROCEDURE CreateSBODLP :
/*------------------------------------------------------------------------------
  Purpose:     To create the DLP of an SBO
  
  Parameters:
    INPUT pcDLPName    - The name of the DLP
    INPUT prURecid     - Recid of the top level SBO _U
          
     
-------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDLPName                      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pRURecid                       AS RECID      NO-UNDO.

  DEFINE VARIABLE cFile                                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName                            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjName                               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTemplate                              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO                                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount                                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE LINE                                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE State                                  AS INTEGER    NO-UNDO.

  DEFINE BUFFER _U-PARENT FOR _U.
  DEFINE BUFFER _U-OBJECT FOR _U.

  ASSIGN cObjectName = REPLACE(pcDLPName, "~\":U, "~/":U)
         cObjectName = ENTRY(NUM-ENTRIES(cObjectName, "~/":U), cObjectName, "~/":U).
  IF NUM-ENTRIES(cObjectName, ".":U) = 2 THEN
    cObjectName = ENTRY(1, cObjectName, ".":U).

  /* Get the template to copy */
  SearchForPlip:
  FOR EACH _custom WHERE _custom._type = "Procedure":U:
    ASSIGN cTemplate = REPLACE(_custom._name,"&&":U,CHR(13))
           cTemplate = REPLACE(cTemplate,"&":U,"")
           cTemplate = REPLACE(cTemplate,CHR(13),"&":U).
    IF cTemplate = "Structured PLIP" THEN DO:
      FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(_attr),13,-1,"CHARACTER")).
      cTemplate = FILE-INFO:FULL-PATHNAME.
      LEAVE SearchForPlip.
    END.  /* We have the right custom record */
  END. /* Loop finding the right template */

  INPUT FROM VALUE(cTemplate).
  OUTPUT TO VALUE(pcDLPName).
  state = 1.
  REPEAT:
    IMPORT UNFORMATTED LINE.
    IF LENGTH(LINE) = 0 THEN LINE = " ":U.

    IF State = 1 THEN DO:
      IF LINE BEGINS "/* Procedure Descr":U THEN DO:
        DO WHILE LINE NE "&ANALYZE-RESUME":U:
          IMPORT UNFORMATTED LINE.
        END. /* Skip Template description */

        /* Write out the AppServer stuff */
        PUT UNFORMATTED LINE SKIP
                        "~{adecomm/appserv.i}" SKIP
                        "DEFINE VARIABLE h_Astra             AS HANDLE              NO-UNDO":U SKIP.
        IMPORT UNFORMATTED LINE.
        state = 2.
      END. /* If we find the template description */
    END. /* When State 1 */

    IF state < 3 THEN DO:
      IF LINE MATCHES '*_XFTR "Create Wizard"*':U THEN DO:
        IMPORT UNFORMATTED LINE. /* Skip ove the create wizard */
        DO WHILE NOT LINE BEGINS "&ANALYZE-SUSPEND":U:
          IMPORT UNFORMATTED LINE.
        END.  /* until we get to the next block */
        state = 3.
      END. /* If we are at the "Create Wizard */
    END.  /* When State 2 */

    IF state < 4 THEN DO:
      IF LINE MATCHES "&ANALYZE-SUS*_CUSTOM _DEFINITIONS*":U THEN DO:
        PUT UNFORMATTED LINE SKIP.
        DO WHILE NOT LINE BEGINS "/*---":U:
          IMPORT UNFORMATTED LINE.
        END.  /* While scanning for the 1st real line of the definition section */
        state = 4.
      END. /* When we find the definition section */
    END. /* When state 3 */

    IF state < 5 THEN DO:
      IF LINE MATCHES "*File:*":U THEN DO:
        ASSIGN LINE = "  File: " + pcDLPName.
        PUT UNFORMATTED LINE SKIP
                        " "  SKIP
                        "  Description:  SBO DataLogicProcedure":U SKIP
                        " " SKIP
                        "  Purpose:":U SKIP
                        " " SKIP
                        "  Parameters:   <none>":U SKIP
                        " " SKIP.
        DO WHILE NOT LINE MATCHES "*History*":U:
          IMPORT UNFORMATTED LINE.
        END.
        state = 5.
      END.  /* The line contains File: */
    END. /* When state 4 */

    IF state < 6 THEN DO:
      IF LINE MATCHES "*(v:010000)*" THEN DO:
        LINE = REPLACE(LINE, "6065":U, "   0":U).
        PUT UNFORMATTED LINE SKIP.
        IMPORT UNFORMATTED LINE.
        LINE = REPLACE(LINE, "20/06/2000":U, STRING(TODAY, "99/99/9999")).
        LINE = REPLACE(LINE, "Anthony Swindells":U, "":U).
        PUT UNFORMATTED LINE SKIP
                        " " SKIP
                        "  Udate Notes: Create from template ry/app/rytemplipp.p":U SKIP.
        DO WHILE NOT LINE MATCHES "*-------------------------*/":U:
          IMPORT UNFORMATTED LINE.
        END. /* Scanning for the end of the comment */
        state = 6.
      END. /* if at the version 010000 line */
    END. /* Whne state 5 */

    IF state < 7 THEN DO:
      IF LINE BEGINS "&scop object-name" THEN
        ASSIGN LINE = "&scop object-name       " + cObjectName
               state = 7.
    END. /* When state 6 */

    IF state < 8 THEN DO:
      IF LINE BEGINS "~{src/adm2/globals.i}":U THEN DO:
        PUT UNFORMATTED LINE SKIP
                        " ":U SKIP.
        LINE = " ":U.

        /* Put in preprocessor */
        FIND _U-Parent WHERE RECID(_U-Parent) = prURecid.
        FOR EACH _U-Object WHERE _U-Object._PARENT-RECID = RECID(_U-Parent)
                             AND _U-Object._STATUS <> "DELETED":U
                             AND _U-Object._TYPE = "SmartObject":U
                             AND _U-Object._SUBTYPE = "SmartDataObject":U:
          FIND _S WHERE RECID(_S) = _U-Object._x-recid.
          hSDO = _S._HANDLE.

          iCount = iCount + 1.
          cObjName = DYNAMIC-FUNCTION("getObjectName":U IN hSDO).
          PUT UNFORMATTED "&Scoped-Define UpdTable":U
                          + STRING(iCount) + " " + cObjName SKIP.

          cFile = DYNAMIC-FUNCTION("getDataFieldDefs":U IN hSDO).
          cFile = REPLACE(cFile,"~\","~/").
          PUT UNFORMATTED "&Scoped-Define SDOInclude":U
                           + STRING(iCount) + " " +  cFile SKIP.
        END.  /* FOR EACH SDO */
        ASSIGN state = 8.
      END.  /* We gfind the globals include */
    END. /* When state 7 */

    IF state < 9 THEN DO:
      IF LINE BEGINS "&Scoped-define PROCEDURE-TYPE" THEN
        ASSIGN LINE = "&Scoped-define PROCEDURE-TYPE DataLogicProcedure":U
               state = 9.
    END. /* When state 8 */

    IF state < 10 THEN DO:
      IF LINE BEGINS "   Type: Procedure":U THEN
        ASSIGN LINE = "   Type: DataLogicProcedure":U
               state = 10.
    END. /* When state 9 */

    IF state < 11 THEN DO:
      IF LINE BEGINS "   Other Settings:" THEN
        ASSIGN LINE = "   Other Settings: CODE-ONLY COMPILE APPSERVER":U
               state = 11.
    END. /* When state 10 */

    IF state < 12 THEN DO:
      IF LINE BEGINS "~{src/adm/method":U THEN
        ASSIGN LINE = "~{src/adm2/sbologic.i}":U
               state = 12.
    END. /* When state 11 */

    PUT UNFORMATTED LINE SKIP.

  END. /* Repeat */

  INPUT CLOSE.
  OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteAttributeRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteAttributeRow Procedure 
PROCEDURE DeleteAttributeRow :
/*------------------------------------------------------------------------------
  Purpose:     Create a DeleteAttribute temp-table record for an attribute 
               value to be removed from the repository if it exists
  Parameters:
        INPUT pcObjectLevel        - Must be CLASS, MASTER or INSTANCE
        INPUT pdSmartObject_obj    - Object id of the SmartObject
        INPUT pcAttributeLabel     - Label of the attribute to set
        
  Notes:  This temp-table is passed to RemoveAttributeValues in the design
          manager to actually remove the the attributes
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectLevel      AS CHARACTER              NO-UNDO.
  DEFINE INPUT  PARAMETER pdSmartObject_obj  AS DECIMAL                NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeLabel   AS CHARACTER              NO-UNDO.

  CREATE DeleteAttribute.
  ASSIGN DeleteAttribute.tAttributeParent    = pcObjectLevel
         DeleteAttribute.tAttributeParentObj = pdSmartObject_obj
         DeleteAttribute.tAttributeLabel     = pcAttributeLabel
         DeleteAttribute.tConstantValue      = NO.  /* Always no, otherwise we wouldn't be setting it */ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DetermineSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DetermineSize Procedure 
PROCEDURE DetermineSize :
/*------------------------------------------------------------------------------
  Purpose:    Given a window _U and a layout, return the minheight and width.
  Parameters:
        INPUT p_Urecid        - Recid of Window
        INPUT pcCode          - Layout Code
        OUTPUT minHeight
        OUTPUT minWidth
        
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_URecid           AS RECID                  NO-UNDO.
  DEFINE INPUT  PARAMETER pcCode             AS CHARACTER              NO-UNDO.
  DEFINE OUTPUT PARAMETER minHeight          AS DECIMAL                NO-UNDO.
  DEFINE OUTPUT PARAMETER minWidth           AS DECIMAL                NO-UNDO.

  DEFINE BUFFER b_U FOR _U.
  DEFINE BUFFER b_C FOR _C.

  /* Create some attribute records to set when we create this master viewer */
  /* Calculate MinHeight and MinWidth */
  ASSIGN MinHeight = 0
         MinWidth  = 0.
  FIND _U WHERE RECID(_U) = p_URecid.

  FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                     b_U._STATUS = "Normal":U:
      IF cClassName = "DynBrow":U AND
         b_U._TYPE = "BROWSE":U THEN BrowseRecid = RECID(b_U).
      IF cClassName = "DynView":U AND
         b_U._TYPE = "FRAME":U THEN FrameRecid = RECID(b_U).
      IF cClassName = "DynSDO":U AND
         b_U._TYPE = "Query":U THEN QueryRecid = RECID(b_U).

      FIND _L WHERE _L._LO-NAME = pcCode AND 
                    _L._u-recid = RECID(b_U) NO-ERROR.

      IF AVAILABLE _L THEN DO:
        IF b_U._TYPE NE "FRAME":U AND b_U._TYPE NE "WINDOW":U AND
           b_U._TYPE NE "QUERY":U THEN
          ASSIGN MinHeight = MAX(MinHeight, _L._ROW -
                                 (IF cClassName = "DynBrow":U THEN 1 ELSE 0)
                                           + _L._Height)
                 MinWidth  = MAX(MinWidth, _L._COL -
                                 (IF cClassName = "DynBrow":U THEN 1 ELSE 0)
                                  + _L._WIDTH).
        ELSE IF b_U._TYPE = "QUERY" THEN
          ASSIGN MinHeight = MAX(MinHeight, _L._Height)
                 MinWidth  = MAX(MinWidth, _L._WIDTH).
        ELSE /* Get the font of the frame or window.  Here we assume that
                the static viewer only has font specified for the Frame.
                I believe that is how the AppBuilder codes it.         */
          ASSIGN cFont     = IF cFont = "?" AND _L._FONT NE ? 
                                THEN STRING(_L._FONT)
                                ELSE cFont.
        IF b_U._TYPE EQ "FRAME":U THEN DO:
          /* Need to support Size-to-fit */
          FIND b_C WHERE RECID(b_C) = b_U._x-recid.
          IF NOT b_C._SIZE-TO-FIT THEN
            ASSIGN MinHeight = _L._HEIGHT
                   MinWidth  = _L._WIDTH.
        END.  /* If a Frame */
      END. /* IF available _L */
    END. /* For each object in this window, glean necessary info */

    /* Store MinHeight and MinWidth in frame's _L */
    FIND _L WHERE _L._LO-NAME = pcCode AND _L._u-recid = FrameRecid NO-ERROR.
    IF AVAILABLE _L THEN
      ASSIGN _L._HEIGHT = MinHeight
             _L._WIDTH  = MinWidth.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObjectAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataObjectAttributes Procedure 
PROCEDURE setDataObjectAttributes :
/*------------------------------------------------------------------------------
  Purpose:     To set the attributes of a Dynamic SDO
  Parameters:  pRecid - Recid of _U of the query.
               cInstanceColumns - list of fields with attributes to be stored 
                                  at the instance level
  Notes:       Should be part of setObjectMaster Attributes, but the case statement
               got too big for the Section Editor
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRecid           AS RECID                NO-UNDO.
    DEFINE OUTPUT PARAMETER cInstanceColumns AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cAssignList              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cBaseQuery               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataColumns             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataColumnsByTable      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDLProcName              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDLProcFullName          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDLProcRootPath          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDLProcRelPath           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE change-to-blank          AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE cTables                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cUpdatableColumns        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cUpdatableColumnsByTable AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQBFieldDataTypes        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQbFieldDBNames          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQBFieldWidths           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQBInhVals               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQBJoinCode              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQBWhereClauses          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cToken                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE httClassBuffer           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPropLib                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPropBuffer              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPropQuery               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lDBsBlank                AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE cResultCode              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataType                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cValue                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDLProcBaseName         AS CHARACTER             NO-UNDO.
        
    DEFINE BUFFER b_U FOR _U.

    /* First find _C of Window because it has the name of the data logic procedure in it. */
    FIND _C WHERE RECID(_C) = _U._x-recid.
    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_code = _C._DATA-LOGIC-PROC-PMOD
      NO-ERROR.
    IF AVAILABLE gsc_product_module
    THEN DO:
      IF VALID-HANDLE(ghScmTool) THEN DO:
        RUN scmGetModuleDir IN ghScmTool (INPUT gsc_product_module.product_module_code, OUTPUT cDLProcRelPath). 
        ASSIGN 
          cDLProcRelPath = REPLACE(cDLProcRelPath, "~\":U, "~/":U)
          .                
      END.
      ELSE
        cDLProcRelPath = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"~/":U),"~/":U).
    END.
    ELSE cDLProcRelPath = TRIM(REPLACE(_P.object_path                  ,"~\":U,"~/":U),"~/":U).
         
    IF _C._DATA-LOGIC-PROC <> "":U THEN DO:        
      ASSIGN cDLProcFullName = _C._DATA-LOGIC-PROC
             cDLProcFullName = REPLACE(cDLProcFullName,"~\":U,"~/":U)
             cDLProcBaseName = SUBSTRING(cDLProcFullName, R-INDEX(cDLProcFullName, "~/":U) + 1). 
             
      ASSIGN cDLProcName = IF TRIM(cDLProcRelPath) <> "":U THEN cDLProcRelPath + "~/":U + cDLProcBaseName ELSE cDLProcFullName.
    END.  /* If the data logic procedure has been specified */

    /* Else we keep it blank as per IZ 7518 */

    /* Now get _U, _C and _Q of the query */
    FIND b_U WHERE RECID(b_U) = pRecid.
    FIND _C WHERE RECID(_C) = b_U._x-recid.
    FIND _Q WHERE RECID(_Q) eq _C._q-recid.

    RUN ConstructTableList(INPUT pRecid, INPUT RECID(_U), INPUT _Q._TblList, OUTPUT cTables).
 
    /* Use cTables to build cAssignList, cUpdatableColumnsByTable and cDataColumnsByTable */
    RUN BuildSDOFieldListsByTable(INPUT RECID(b_U),
                                  INPUT  cTables,
                                  OUTPUT cAssignList,
                                  OUTPUT cUpdatableColumnsByTable,
                                  OUTPUT cDataColumnsByTable).
    /* Assign to global variables to be used later for generating Data logic proc */
    ASSIGN  gcTableList      = cTables
            gcUpdColsByTable = cUpdatableColumnsByTable.

    /* Build cDataColumns, cUpdateableColumns and other lists necessary for SDOs to be read
       back into the AppBuilder from the repository                                         */
    RUN BuildSDOSimpleLists(INPUT RECID(b_U),
                            OUTPUT cDataColumns,
                            OUTPUT cUpdatableColumns,
                            OUTPUT cInstanceColumns,
                            OUTPUT cQBFieldDataTypes,
                            OUTPUT cQBFieldDBNames,
                            OUTPUT cQBFieldWidths,
                            OUTPUT cQBInhVals).


    /* Build Query Builder internal lists */
    DO i = 1 TO NUM-ENTRIES(_Q._TblList):
      ASSIGN cQBJoinCode     = cQBJoinCode + CHR(5) + 
                                  (IF _Q._JoinCode[i] = ? THEN "?":U ELSE _Q._JoinCode[i])
             cQBWhereClauses = cQBWhereClauses + CHR(5) + 
                                  (IF _Q._Where[i] = ? THEN "?":U ELSE _Q._Where[i]).
    END. /* Do i = 1 to num-tables */
 
    
    /* Remove the 1st character (which is a CHR(5) of all of these */
    ASSIGN cQBJoinCode     = SUBSTRING(cQBJoinCode, 2, -1, "CHARACTER")
           cQBWhereClauses = SUBSTRING(cQBWhereClauses, 2, -1, "CHARACTER").
    
    IF cQBJoinCode NE "":U THEN DO:
        Change-to-Blank = TRUE.
        JCSearch:
        DO i = 1 TO NUM-ENTRIES(cQBJoinCode,CHR(5)):
          IF ENTRY(i, cQBJoinCode, CHR(5)) NE "?":U THEN DO:
            change-to-blank = FALSE.
            LEAVE JCSearch.
          END. /* If not ? */
        END. /* DO i = 1 to num-entries */
        IF change-to-blank THEN cQBJoinCode = "":U.
    END.   /* If cQBJoinCode NE "" */

    IF cQBWhereClauses NE "":U THEN DO:
        Change-to-Blank = TRUE.
        WCSearch:
        DO i = 1 TO NUM-ENTRIES(cQBWhereClauses,CHR(5)):
          IF ENTRY(i, cQBWhereClauses, CHR(5)) NE "?":U THEN DO:
            change-to-blank = FALSE.
            LEAVE WCSearch.
          END. /* If not ? */
        END. /* DO i = 1 to num-entries */
        IF change-to-blank THEN cQBWhereClauses = "":U.
    END.   /* If cQBWhereClauses NE "" */

    /* Need to strip DB name from base query so that query-prepare can handle it */
    cBaseQuery = "FOR":U.
    DO i = 1 TO NUM-ENTRIES(_Q._4GLQury," ":U):
      cToken = ENTRY(i, _Q._4GLQury, " ":U).
      IF NUM-ENTRIES(cToken,".":U) = 2 AND
        LOOKUP(ENTRY(1, cToken, ".":U), cQBFieldDBNames) > 0 THEN 
          cToken = ENTRY(2, cToken, ".":U).
      IF NUM-ENTRIES(cToken,".":U) = 3 AND
        LOOKUP(ENTRY(1, cToken, ".":U), cQBFieldDBNames) > 0 THEN
          cToken = ENTRY(2, cToken, ".":U) + ".":U + ENTRY(3, cToken, ".":U).
      cBaseQuery = cBaseQuery + " ":U + cToken.
    END.

    cDbName = ENTRY(1, _Q._TblList, ".":U).
    /* Blank out cQBFieldDBNames if they all belong to cDBName */
    lDBsBlank = YES.
    DB-LOOP:
    DO i = 1 TO NUM-ENTRIES(cQbFieldDBNames):
      IF ENTRY(i,cQbFieldDBNames) NE cDBName THEN ldbsBlank = NO.
    END.
    IF lDBsBlank THEN cQBFieldDBNames = "":U.



    /* Update the repository */
    httClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                  cObjClassType).

    IF httClassBuffer:AVAILABLE THEN DO:
      /* Have the Buffer conatining handle of the temp-table containing the attributes
         of the DynSDO Class */
      ASSIGN hAttributeBuffer = httClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE
             WhereStoredNumEntries = NUM-ENTRIES(_U._WHERE-STORED).
      hAttributeBuffer:BUFFER-CREATE.  /* Causes intial values to be created in native data-type */

      IF hAttributeBuffer:AVAILABLE THEN DO:
        /* Only write attributes that are not default values */
        DO i = 1 TO hAttributeBuffer:NUM-FIELDS:
         
          ASSIGN cAttr        = hAttributeBuffer:BUFFER-FIELD(i):NAME
                 cWhereStored = IF (i < WhereStoredNumEntries) THEN ENTRY(i, _U._WHERE-STORED)
                                ELSE "3":U.  /* Three is safe... we will attempt to delete it */
                                
          IF CAN-DO("CLASS":U, DYNAMIC-FUNCTION("getWhereConstantLevel":U in gshRepositoryManager,
                                                                  INPUT hAttributeBuffer,INPUT hAttributeBuffer:BUFFER-FIELD(i)))
          THEN NEXT.
          CASE cAttr:

            WHEN "AppService":U THEN
              {&If-not-default} _P._Partition AND _P._Partition NE "":U THEN
                 {&Create-Char-Master} _P._Partition, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "AssignList":U THEN
              {&If-not-default} cAssignList THEN
                 {&Create-Char-Master} cAssignList, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "BaseQuery":U THEN
              {&If-not-default} cBaseQuery THEN
                 {&Create-Char-Master} cBaseQuery, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "DataColumns":U THEN
              {&If-not-default} cDataColumns THEN
                 {&Create-Char-Master} cDataColumns, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "DataColumnsByTable":U THEN
              {&If-not-default} cDataColumnsByTable THEN
                 {&Create-Char-Master} cDataColumnsByTable, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "DataLogicProcedure":U THEN
              {&If-not-default} cDLProcName THEN
                 {&Create-Char-Master} cDLProcName, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.            

            WHEN "QueryBuilderDBNames":U THEN
              {&If-not-default} cQBFieldDBNames THEN
                 {&Create-Char-Master} cQBFieldDBNames, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderFieldDataTypes":U THEN DO:
              /* Normally we don't write out data-types because they never change,
                 but we have to if we have a calculated field                 */
              IF CAN-DO(cQbFieldDBNames,"_<CALC>":U) THEN DO:
                {&If-not-default} cQBFieldDataTypes THEN
                   {&Create-Char-Master} cQBFieldDataTypes, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              END. /* If there is a calculated field */
            END.  /* When qbFieldDataTypes */

            WHEN "QueryBuilderFieldWidths":U THEN
              {&If-not-default} cQBFieldWidths THEN
                 {&Create-Char-Master} cQBFieldWidths, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderInheritValidations":U THEN
              {&If-not-default} cQBInhVals THEN
                 {&Create-Char-Master} cQBInhVals, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderJoinCode":U THEN
              {&If-not-default} cQBJoinCode THEN
                 {&Create-Char-Master} cQBJoinCode, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderOptionList":U THEN
              {&If-not-default} _Q._OptionList THEN
                 {&Create-Char-Master} _Q._OptionList, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderOrderList":U THEN
              {&If-not-default} _Q._OrdList THEN
                 {&Create-Char-Master} _Q._OrdList, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderTableOptionList":U THEN
              {&If-not-default} _Q._TblOptList THEN
                 {&Create-Char-Master} _Q._TblOptList, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderTableList":U THEN
              {&If-not-default} _Q._TblList THEN
                 {&Create-Char-Master} _Q._TblList, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderTuneOptions":U THEN
              {&If-not-default} _Q._TuneOptions THEN
                 {&Create-Char-Master} _Q._TuneOptions, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "QueryBuilderWhereClauses":U THEN
              {&If-not-default} cQBWhereClauses THEN
                 {&Create-Char-Master} cQBWhereClauses, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "Tables":U THEN
              {&If-not-default} cTables THEN
                 {&Create-Char-Master} cTables, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "UpdatableColumns":U THEN
              {&If-not-default} cUpdatableColumns THEN
                 {&Create-Char-Master} cUpdatableColumns, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.

            WHEN "UpdatableColumnsByTable":U THEN
              {&If-not-default} cUpdatableColumnsByTable THEN
                 {&Create-Char-Master} cUpdatableColumnsByTable, ?, ?, ?, ?, ?).
              ELSE {&Delete-Master-Attribute}.
            
          END CASE.
        END. /* Loop through attributes */
        
        hAttributeBuffer:BUFFER-DELETE.
        /* Retrieve the Dynamic Property Sheet modified values */
        IF VALID-HANDLE(_h_menubar_proc) THEN
        DO:
          hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
          IF VALID-HANDLE(hPropLib) THEN 
          DO:
            ASSIGN hPropBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hPropLib, "ttAttribute":U).
            CREATE QUERY hPropQuery.
            hPropQuery:SET-BUFFERS(hPropBuffer).
            hPropQuery:QUERY-PREPARE(" FOR EACH " + hPropBuffer:NAME + " WHERE "
                                  + hPropBuffer:NAME + ".callingProc = '":U + STRING(_h_menubar_proc) + "' AND ":U 
                                  + hPropBuffer:NAME + ".containerName = '":U + STRING(b_U._Window-handle) + "' AND ":U
                                  + hPropBuffer:NAME + ".resultCode = '":U + cResultCode + "' AND ":U
                                  + hPropBuffer:NAME + ".objectName = '":U + STRING(b_U._Window-handle) + "' AND "
                                  + hPropBuffer:NAME + ".RowModified = 'true'") NO-ERROR.
            hPropQuery:QUERY-OPEN().
            hPropQuery:GET-FIRST().
            
            DO WHILE hPropBuffer:AVAILABLE:
              /* check whether the attribute was modified and if it's override flag is set */
               ASSIGN cDataType = hPropBuffer:BUFFER-FIELD("dataType":U):BUFFER-VALUE
                      cValue    = hPropBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE
                      cAttr     = hPropBuffer:BUFFER-FIELD("attrLabel":U):BUFFER-VALUE.
              IF hPropBuffer:BUFFER-FIELD("RowOverride":U):BUFFER-VALUE = TRUE THEN
              DO:
               
                CASE cDataType:
                  WHEN "CHARACTER":U OR WHEN "CHAR":U THEN
                     {&Create-Char-Master} cValue, ?, ?, ?, ?, ?).
                  WHEN "INTEGER":U OR WHEN "INT":U THEN
                     {&Create-int-Master} cValue, ?, ?, ?).
                  WHEN "DECIMAL":U OR WHEN "DEC":U THEN
                    {&Create-dec-Master} cValue, ?, ?, ?, ?).
                  WHEN "LOGICAL":U OR WHEN "LOG":U THEN
                     {&Create-log-Master} cValue, ?, ?).
                  WHEN "DATE":U THEN
                     RUN CreateAttributeRow(INPUT "MASTER":U, INPUT ?, INPUT cAttr,?,?,?,?,?,cValue,?).
                END CASE.
              END.  /* if an attribute was modified and overridden */
              ELSE 
                 /* Override was de-selected to remove attribute */
                  RUN DeleteAttributeRow (INPUT "MASTER":U, INPUT dSmartobject_obj, INPUT cAttr)     .        

              hPropQuery:GET-NEXT().
            END. /* End DO WHILE hPropBuffer:AVAILABLE   */
            IF VALID-HANDLE(hPropQuery) THEN
               DELETE OBJECT hPropQuery NO-ERROR.
          END.  /* If hPropLib is valid */
        END.  /* if _h_menubar_proc is valid */ 
    
      END. /* If we have a valid DYNSDO buffer handle */
    END.  /* If we have the class buffer handle */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setObjectEvents Procedure 
PROCEDURE setObjectEvents :
/*------------------------------------------------------------------------------
  Purpose:     Set the events in the temp tables.
  Parameters:  puRecid       Recid of _U record for widget
               pdObjectObj   Object ID of widget
               pcParent      INSTANCE
                             MASTER
               pcResultCode  Custom Result code
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER puRecid      AS RECID      NO-UNDO.
DEFINE INPUT  PARAMETER pdObjectobj  AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcParent     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pclayout     AS CHARACTER  NO-UNDO.

DEFINE BUFFER b_U FOR _U.

DEFINE VARIABLE hPropLib       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPropBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPropQuery     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cEventName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode    AS CHARACTER  NO-UNDO.

IF pcLayout = "Master Layout":U THEN 
     cResultCode = "".
  ELSE
     cResultCode = pcLayout.

FIND b_U WHERE RECID(b_U) = puRecid NO-ERROR.

IF VALID-HANDLE(_h_menubar_proc) THEN 
DO:
   ASSIGN hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
   IF VALID-HANDLE(hPropLib) THEN
   DO:
     ASSIGN hPropBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hPropLib, "ttEvent":U).
     CREATE QUERY hPropQuery.                                                                                
     hPropQuery:ADD-BUFFER(hPropBuffer). 
     hPropQuery:QUERY-PREPARE(" FOR EACH " + hPropBuffer:NAME + " WHERE " 
                            + hPropBuffer:NAME + ".callingProc = '":U + STRING(_h_menubar_proc) + "' AND ":U 
                            + hPropBuffer:NAME + ".containerName = '":U + STRING(b_U._Window-handle) + "' AND ":U
                            + hPropBuffer:NAME + ".resultCode = '":U + cResultCode + "' AND ":U
                            + hPropBuffer:NAME + ".objectName = '":U + STRING(b_U._HANDLE) + "' AND "
                            + hPropBuffer:NAME + ".RowModified = true":U  ). 
     hPropQuery:QUERY-OPEN().                                                                                
     hPropQuery:GET-FIRST(). 
     DO WHILE hPropBuffer:AVAILABLE:
        cEventName = hPropBuffer:BUFFER-FIELD("EventName":U):BUFFER-VALUE.
        /* check whether the attribute was modified and if it's override flag is set */
        IF  hPropBuffer:BUFFER-FIELD("RowOverride":U):BUFFER-VALUE = TRUE THEN
        DO:
           CREATE ttStoreUIEvent.
           ASSIGN tEventParent    = pcParent
                  tEventParentObj = pdObjectobj
                  tEventName      = cEventName
                  tEventAction    = hPropBuffer:BUFFER-FIELD("EventAction":U):BUFFER-VALUE
                  tActionType     = hPropBuffer:BUFFER-FIELD("EventType":U):BUFFER-VALUE 
                  tActionTarget   = hPropBuffer:BUFFER-FIELD("EventTarget":U):BUFFER-VALUE
                  tEventParameter = hPropBuffer:BUFFER-FIELD("EventParameter":U):BUFFER-VALUE 
                  tEventDisabled  = hPropBuffer:BUFFER-FIELD("EventDisabled":U):BUFFER-VALUE
                  NO-ERROR.
          
        END.
        ELSE
        DO: /* Remove the event from the repository */
           CREATE DeleteUIEvent.
           ASSIGN DeleteUIEvent.tEventParent    = "INSTANCE":U
                  DeleteUIEvent.tEventParentObj = pdObjectobj
                  DeleteUIEvent.tEventName      = cEventName
                  NO-ERROR.
        END.

        hPropQuery:GET-NEXT().   
     END.
     
     IF VALID-HANDLE(hPropQuery) THEN
        DELETE OBJECT hPropQuery NO-ERROR.
   END.  /* End  VALID-HANDLE(hUIEventBuffer) AND valid-handle(hPropLib) */
END. /* END Valid-handle(hClassBufferCache */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectInstanceAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setObjectInstanceAttributes Procedure 
PROCEDURE setObjectInstanceAttributes :
/*------------------------------------------------------------------------------
  Purpose:     To load the StoreAttributes tt with AttributeValues 
  Parameters:  puRecid - RECID of the _U record of the widget whose attributes
                         need to be loaded.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER puRecid           AS RECID          NO-UNDO.
  DEFINE INPUT  PARAMETER cMasterObjectName AS CHARACTER      NO-UNDO.
  DEFINE INPUT  PARAMETER dObject_obj       AS DECIMAL        NO-UNDO.
  DEFINE INPUT  PARAMETER cLayout           AS CHARACTER      NO-UNDO.

  DEFINE BUFFER b_U FOR _U.

  DEFINE VARIABLE dObjectBufferID      AS DECIMAL        NO-UNDO.
  DEFINE VARIABLE iEntry               AS INTEGER        NO-UNDO.
  DEFINE VARIABLE lTmp                 AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE cTmp                 AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE hAttributeBuffer     AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hObjectBuffer        AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hPropBuffer          AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hPropLib             AS HANDLE         NO-UNDO.
  DEFINE VARIABLE cResultCode          AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cDataType            AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cValue               AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE hPropQuery           AS HANDLE         NO-UNDO.

  FIND b_U WHERE RECID(b_U) = puRecid.
  FIND _F WHERE RECID(_F) = b_U._x-recid NO-ERROR.
  FIND _L WHERE _L._LO-NAME = cLayout AND _L._u-recid = RECID(b_U) NO-ERROR.

  IF cLayout = "Master Layout":U THEN DO:
    /* The ObjectBuffer and AttributeBuffer records should be available after the cacheObjectOnClient call. */
    ASSIGN hObjectBuffer    = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
   
    IF VALID-HANDLE(hObjectBuffer) THEN DO:
      /* Have the handle of the Temp-Table containing handles to the temp-tables 
         contianing attributes of all cached objects                              */
      hObjectBuffer:FIND-FIRST("WHERE ":U + hObjectBuffer:NAME + ".tLogicalObjectName = '":U +
                               cMasterObjectName + "'":U) NO-ERROR.
  
      IF hObjectBuffer:AVAILABLE THEN DO:
        ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               dObjectBufferId  = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
  
        hAttributeBuffer:FIND-FIRST("WHERE " + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + 
                                     QUOTER(dObjectBufferId) ) NO-ERROR.
  
        IF hAttributeBuffer:AVAILABLE THEN DO:    
          WhereStoredNumEntries = NUM-ENTRIES(b_U._WHERE-STORED).
  
          /* Only write attributes that are not default values */
          DO i = 1 TO hAttributeBuffer:NUM-FIELDS:
  
            ASSIGN cAttr        = hAttributeBuffer:BUFFER-FIELD(i):NAME
                   cWhereStored = IF (i < WhereStoredNumEntries) THEN ENTRY(i, b_U._WHERE-STORED)
                                  ELSE "5":U.  /* Five is safe... we will attempt to delete it */
                                  
            IF CAN-DO("CLASS,MASTER":U, DYNAMIC-FUNCTION("getWhereConstantLevel":U in gshRepositoryManager,
                                                          INPUT hAttributeBuffer,INPUT hAttributeBuffer:BUFFER-FIELD(i)))
            THEN NEXT.
            
            CASE cAttr:
                
              WHEN "AUTO-COMPLETION":U THEN
                {&If-not-default} _F._AUTO-COMPLETION THEN
                   {&Create-log-instance} _F._AUTO-COMPLETION, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "AUTO-END-KEY":U THEN
                {&If-not-default} _F._AUTO-ENDKEY THEN
                   {&Create-log-instance} _F._AUTO-ENDKEY, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "AUTO-GO":U THEN
                {&If-not-default} _F._AUTO-GO THEN
                   {&Create-log-instance} _F._AUTO-GO, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "AUTO-INDENT":U THEN
                {&If-not-default} _F._AUTO-INDENT THEN
                   {&Create-log-instance} _F._AUTO-INDENT, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "AUTO-RESIZE":U THEN
                {&If-not-default} _F._AUTO-RESIZE THEN
                   {&Create-log-instance} _F._AUTO-RESIZE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "AUTO-RETURN":U THEN
                {&If-not-default} _F._AUTO-RETURN THEN
                   {&Create-log-instance} _F._AUTO-RETURN, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "BGCOLOR":U THEN 
                {&If-not-default} _L._BGCOLOR THEN
                   {&Create-Int-instance} _L._BGCOLOR, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "BLANK":U THEN
                {&If-not-default} _F._BLANK THEN
                   {&Create-log-instance} _F._BLANK, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "BOX":U THEN
                {&If-not-default} (NOT _L._NO-BOX) THEN
                   {&Create-log-instance} NOT _L._NO-BOX, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "CHECKED":U THEN DO:
                 lTmp = (_F._INITIAL-DATA BEGINS "Y":U OR _F._INITIAL-DATA BEGINS "T":U).
                 {&If-not-default} lTmp THEN
                    {&Create-log-instance} lTmp, ?, ?).
                 ELSE {&Delete-Instance-Attribute}.
              END. /* Checked */
              WHEN "COLUMN":U THEN
                {&If-not-default} _L._COL THEN
                   {&Create-dec-instance} _L._COL, ?, ?, ?, ?).
              WHEN "ColumnLabel":U THEN DO:
                {&IF-SDO} "columnColumnLabel" {&SAME-AS} b_U._LABEL {&NO-OP}
                ELSE DO:
                  cTmp = IF LOOKUP(b_U._TYPE,"Editor":U) > 0 THEN "" ELSE b_U._LABEL.
                  {&If-not-default} b_U._LABEL THEN
                     {&Create-Char-Instance} cTmp, ?, ?, ?, ?, ?).
                  ELSE {&Delete-Instance-Attribute}.
                END.
              END.
              WHEN "CONTEXT-HELP-ID":U THEN
                {&If-not-default} b_U._CONTEXT-HELP-ID THEN
                   {&Create-dec-instance} b_U._CONTEXT-HELP-ID, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "CONVERT-3D-COLORS":U THEN
                {&If-not-default} _L._CONVERT-3D-COLORS THEN
                   {&Create-log-instance} _L._CONVERT-3D-COLORS, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "DATA-TYPE":U THEN
                {&If-not-default} _F._DATA-TYPE THEN
                   {&Create-Char-Instance} _F._DATA-TYPE, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "DEBLANK":U THEN
                {&If-not-default} _F._DEBLANK THEN
                   {&Create-log-instance} _F._DEBLANK, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "DEFAULT":U THEN
                {&If-not-default} _F._DEFAULT THEN
                   {&Create-log-instance} _F._DEFAULT, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "DELIMITER":U THEN
                {&If-not-default} _F._DELIMITER THEN
                   {&Create-Char-Instance} _F._DELIMITER, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "DisplayField":U THEN
                {&If-not-default} b_U._DISPLAY THEN
                   {&Create-log-instance} b_U._DISPLAY, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "DISABLE-AUTO-ZAP":U THEN
                {&If-not-default} _F._DISABLE-AUTO-ZAP THEN
                   {&Create-log-instance} _F._DISABLE-AUTO-ZAP, ?, ?).
              WHEN "DRAG-ENABLED":U THEN
                {&If-not-default} _F._DRAG-ENABLED THEN
                   {&Create-log-instance} _F._DRAG-ENABLED, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "DROP-TARGET":U THEN
                {&If-not-default} b_U._DROP-TARGET THEN
                   {&Create-log-instance} b_U._DROP-TARGET, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "EDGE-PIXELS":U THEN
                {&If-not-default} _L._EDGE-PIXELS THEN
                   {&Create-Int-instance} _L._EDGE-PIXELS, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "ENABLED":U THEN
                {&If-not-default} b_U._ENABLE THEN
                   {&Create-log-instance} b_U._ENABLE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "EXPAND":U THEN
                {&If-not-default} _F._EXPAND THEN
                   {&Create-log-instance} _F._EXPAND, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "FGCOLOR":U THEN
                {&If-not-default} _L._FGColor THEN
                   {&Create-Int-instance} _L._FGColor, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "FILLED":U THEN
                {&If-not-default} _L._Filled THEN
                   {&Create-log-instance} _L._Filled, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "FLAT-BUTTON":U THEN
                {&If-not-default} _F._FLAT THEN
                   {&Create-log-instance} _F._FLAT, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "FONT":U THEN
                {&If-not-default} _L._FONT THEN
                   {&Create-Int-instance} _L._FONT, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "FORMAT":U THEN DO:
                {&IF-SDO} "columnFORMAT" {&SAME-AS} _F._FORMAT OR
                LOOKUP(b_U._TYPE,"FILL-IN,COMBO-BOX,TEXT":U) = 0 {&NO-OP}
                ELSE
                {&If-not-default} _F._FORMAT THEN
                   {&Create-Char-Instance}
                                     (IF _F._FORMAT = ? OR _F._FORMAT = "":U 
                                      THEN "X(":U + STRING(MAX(2,LENGTH(_F._INITIAL-DATA))) + ")":U
                                      ELSE _F._FORMAT), ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              END.
              WHEN "GRAPHIC-EDGE":U THEN
                {&If-not-default} _L._Graphic-Edge THEN
                   {&Create-log-instance} _L._Graphic-Edge, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "HEIGHT-CHARS":U THEN
                {&If-not-default} _L._HEIGHT THEN
                   {&Create-dec-instance} _L._HEIGHT, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "HELP":U THEN DO:
                {&IF-SDO} "columnHelp" {&SAME-AS} b_U._HELP {&NO-OP}
                ELSE
                {&If-not-default} b_U._HELP THEN
                   {&Create-Char-Instance} b_U._HELP, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              END.
              WHEN "HIDDEN":U THEN
                {&If-not-default} b_U._HIDDEN THEN
                   {&Create-log-instance} b_U._HIDDEN, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "HORIZONTAL":U THEN
                {&If-not-default} _F._HORIZONTAL THEN
                   {&Create-log-instance} _F._HORIZONTAL, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "IMAGE-FILE":U THEN
                {&If-not-default} _F._IMAGE-FILE THEN
                   {&Create-Char-Instance} _F._IMAGE-FILE, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "InitialValue":U THEN
                {&If-not-default} _F._INITIAL-DATA THEN
                   {&Create-Char-Instance} IF _F._INITIAL-DATA = ? 
                                     THEN "?":U ELSE _F._INITIAL-DATA, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "INNER-LINES":U THEN
               {&If-not-default} _F._INNER-LINES THEN
                  {&Create-Int-instance} _F._INNER-LINES, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "LABEL":U THEN DO:
                {&IF-SDO} "columnLabel" {&SAME-AS} b_U._LABEL {&NO-OP}
                ELSE DO:
                  cTmp = IF LOOKUP(b_U._TYPE,"Editor":U) > 0 THEN "" ELSE _L._LABEL.
                  {&If-not-default} _L._LABEL THEN
                     {&Create-Char-Instance} cTmp, ?, ?, ?, ?, ?).
                  ELSE {&Delete-Instance-Attribute}.
                END.
              END.
              WHEN "LABELS":U THEN  /* Careful! Switching NO-LABELS to LABELS */
                {&If-not-default} (NOT _L._NO-LABELS) THEN
                   {&Create-log-instance} IF _L._NO-LABELS THEN NO ELSE YES, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "LARGE":U THEN
                {&If-not-default} _F._LARGE THEN
                   {&Create-log-instance} _F._LARGE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "LIST-ITEMS":U OR
              WHEN "RADIO-BUTTONS" THEN DO:
                IF b_U._TYPE NE "RADIO-SET":U AND cAttr = "LIST-ITEMS":U OR
                   b_U._TYPE EQ "RADIO-SET":U AND cAttr = "RADIO-BUTTONS":U THEN DO:
                   IF b_U._TYPE NE "RADIO-SET":U THEN
                     cTmp = REPLACE(_F._LIST-ITEMS, CHR(10), _F._DELIMITER).
                   ELSE DO: /* RADIO-BUTTONS need TO have quotes, spaces AND CHR(10)'s removed */
                      cTmp = REPLACE(_F._LIST-ITEMS, ":U":U, "":U).  /* Remove the :U's */
                      DO iEntry = 1 TO NUM-ENTRIES(cTmp, _F._DELIMITER):
                         ENTRY(iEntry, cTmp, _F._DELIMITER) = 
                            TRIM(TRIM(ENTRY(iEntry, cTmp, _F._DELIMITER)), '"').
                      END.
                   END.
                  {&If-not-default} cTmp AND (cTmp NE "":U AND cTmp NE ?) THEN
                     {&Create-Char-Instance} cTmp, ?, ?, ?, ?, ?).
                  ELSE {&Delete-Instance-Attribute}.
                END.  /* Right Attribute for right object */
              END.
              WHEN "LIST-ITEM-PAIRS":U THEN DO:
                cTmp = "":U.
                DO iEntry = 1 to NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
                  cTmp = CTmp + ENTRY(iEntry,_F._LIST-ITEM-PAIRS,CHR(10)) + 
                        (IF iEntry < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) AND 
                        SUBSTRING(ENTRY(iEntry,_F._LIST-ITEM-PAIRS,CHR(10)),
                        LENGTH(ENTRY(iEntry,_F._LIST-ITEM-PAIRS,CHR(10))),1,"CHARACTER":U) <> _F._DELIMITER 
                        THEN _F._DELIMITER ELSE "").
                END.  /* do i = 1 to num */
                {&If-not-default} cTmp AND (cTmp NE "":U AND cTmp NE ?) THEN
                   {&Create-Char-Instance} cTmp, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              END.
              WHEN "MANUAL-HIGHLIGHT":U THEN
                {&If-not-default} b_U._MANUAL-HIGHLIGHT THEN
                   {&Create-log-instance} b_U._MANUAL-HIGHLIGHT, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "MAX-CHARS":U THEN
                {&If-not-default} _F._MAX-CHARS THEN
                   {&Create-int-instance} _F._MAX-CHARS, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "MOVABLE":U THEN
                {&If-not-default} b_U._MOVABLE THEN
                   {&Create-log-instance} b_U._MOVABLE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "MULTIPLE":U THEN
                {&If-not-default} _F._MULTIPLE THEN
                   {&Create-log-instance} _F._MULTIPLE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "NAME":U THEN
                {&If-not-default} b_U._NAME THEN
                   {&Create-Char-Instance} b_U._NAME, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "NO-FOCUS":U THEN
                {&If-not-default} _L._NO-FOCUS THEN
                   {&Create-log-instance} _L._NO-FOCUS, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "Order":U THEN DO:
                IF b_U._TAB-ORDER > 0 THEN DO:
                  {&If-not-default} b_U._TAB-ORDER THEN
                       {&Create-Int-instance} b_U._TAB-ORDER, ?, ?, ?).
                  ELSE {&Delete-Instance-Attribute}.
                END.  /* Only apply a non-zero tab order */
              END. /* When Order */
              WHEN "PRIVATE-DATA":U THEN
                {&If-not-default} b_U._PRIVATE-DATA THEN
                   {&Create-Char-Instance} b_U._PRIVATE-DATA, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "READ-ONLY":U THEN
                {&If-not-default} _F._READ-ONLY THEN
                   {&Create-log-instance} _F._READ-ONLY, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "RESIZABLE":U THEN
                {&If-not-default} b_U._RESIZABLE THEN
                   {&Create-log-instance} b_U._RESIZABLE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "RETAIN-SHAPE":U THEN
                {&If-not-default} _F._RETAIN-SHAPE THEN
                   {&Create-log-instance} _F._RETAIN-SHAPE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "RETURN-INSERTED":U THEN
                {&If-not-default} _F._RETURN-INSERTED THEN
                   {&Create-log-instance} _F._RETURN-INSERTED, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "ROW":U THEN
                {&If-not-default} _L._ROW THEN
                   {&Create-dec-instance} _L._ROW, ?, ?, ?, ?).
              WHEN "SCROLLBAR-HORIZONTAL":U THEN
                {&If-not-default} _F._SCROLLBAR-H THEN
                   {&Create-log-instance} _F._SCROLLBAR-H, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "SCROLLBAR-VERTICAL":U THEN
                {&If-not-default} b_U._SCROLLBAR-V THEN
                   {&Create-log-instance} b_U._SCROLLBAR-V, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "SELECTABLE":U THEN
                {&If-not-default} b_U._SELECTABLE THEN
                   {&Create-log-instance} b_U._SELECTABLE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "SENSITIVE":U THEN
                {&If-not-default} b_U._SENSITIVE THEN
                   {&Create-log-instance} b_U._SENSITIVE, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
             WHEN "SHOWPOPUP":U THEN
                {&If-not-default} b_U._SHOW-POPUP THEN
                   {&Create-log-instance} b_U._SHOW-POPUP, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "SORT":U THEN
                {&If-not-default} _F._SORT THEN
                   {&Create-log-instance} _F._SORT, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "STRETCH-TO-FIT":U THEN
                {&If-not-default} _F._STRETCH-TO-FIT THEN
                   {&Create-log-instance} _F._STRETCH-TO-FIT, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "SUBTYPE":U THEN DO:  /*
                IF b_U._TYPE EQ "FILL-IN":U AND  b_U._SUBTYPE EQ "":U THEN
                  b_U._SUBTYPE = "PROGRESS":U.
                /* Don't set fill-in subtype to blank */
                {&If-not-default} b_U._SUBTYPE THEN
                   {&Create-Char-Instance} b_U._SUBTYPE, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}. */
              END.
              WHEN "TAB-STOP":U THEN  /* Careful! Switching NO-TAB-STOP to TAB-STOP */
                {&If-not-default} (NOT b_U._NO-TAB-STOP) THEN
                   {&Create-log-instance} NOT b_U._NO-TAB-STOP, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "TOOLTIP":U THEN
                {&If-not-default} b_U._TOOLTIP THEN
                  {&Create-Char-Instance} b_U._TOOLTIP, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "THREE-D":U THEN
                {&If-not-default} _L._3-D THEN
                   {&Create-log-instance} _L._3-D, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "TRANSPARENT":U THEN
                {&If-not-default} _F._TRANSPARENT THEN
                   {&Create-log-instance} _F._TRANSPARENT, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "VISIBLE":U THEN DO:
                {&If-not-default} (NOT b_U._HIDDEN) THEN
                   {&Create-log-instance} NOT b_U._HIDDEN, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
                
                {&If-not-default} (NOT _L._REMOVE-FROM-LAYOUT) THEN
                  {&Create-log-instance} NOT _L._REMOVE-FROM-LAYOUT, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              END.
              WHEN "VisualizationType":U THEN DO:
                IF b_U._TYPE = "FILL-IN":U AND b_U._SUBTYPE = "TEXT":U THEN DO:
                  /* This is a fill-in viewed as text */
                  {&If-not-default} b_U._SUBTYPE THEN
                     {&Create-Char-Instance} b_U._SUBTYPE, ?, ?, ?, ?, ?).
                  ELSE {&Delete-Instance-Attribute}.
                END.
                ELSE DO: /* Normal action */
                  {&If-not-default} b_U._TYPE THEN
                     {&Create-Char-Instance} b_U._TYPE, ?, ?, ?, ?, ?).
                  ELSE {&Delete-Instance-Attribute}.
                END.  /* Normal Action */
              END.  /* Visualization Type */
              WHEN "WidgetName":U THEN  /* Not used any more - NAME */
                {&If-not-default} b_U._NAME THEN
                   {&Create-Char-Instance} b_U._NAME, ?, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              WHEN "WIDTH-CHARS":U THEN DO:
                {&IF-SDO} "columnWidth" {&SAME-AS} _L._WIDTH {&NO-OP}
                ELSE
                {&If-not-default} _L._WIDTH THEN
                   {&Create-dec-instance} _L._WIDTH, ?, ?, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
              END.
              WHEN "WORD-WRAP":U THEN
                 {&If-not-default} _F._WORD-WRAP THEN
                    {&Create-log-instance} _F._WORD-WRAP, ?, ?).
                ELSE {&Delete-Instance-Attribute}.
            END CASE.
          END. /* Loop through fields */
        END.  /* Buffer is available */
      END.  /* Cache is available */
    END.  /* HAndle is valid */
  END. /* If cLayout = "Master Layout":U */  
  ELSE /* If this is a custom layout, only create records that differ from the master */
      RUN ProcessCustomAttributes(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT RECID(_L)).
  
  IF cLayout = "Master Layout":U THEN 
     cResultCode = "".
  ELSE
     cResultCode = cLayout.
  /* Retrieve the Dynamic Property Sheet modified values */
  IF VALID-HANDLE(_h_menubar_proc) THEN
  DO:
    hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
   IF VALID-HANDLE(hPropLib) THEN 
   DO:
     ASSIGN hPropBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hPropLib, "ttAttribute":U).
     CREATE QUERY hPropQuery.
     hPropQuery:SET-BUFFERS(hPropBuffer).
     hPropQuery:QUERY-PREPARE(" FOR EACH " + hPropBuffer:NAME + " WHERE " 
                  + hPropBuffer:NAME + ".callingProc = '":U + STRING(_h_menubar_proc) + "' AND ":U 
           + hPropBuffer:NAME + ".containerName = '":U + STRING(b_U._Window-handle) + "' AND ":U
           + hPropBuffer:NAME + ".resultCode = '":U + cResultCode + "' AND ":U
           + hPropBuffer:NAME + ".objectName = '":U + STRING(b_U._HANDLE) + "' AND "
           + hPropBuffer:NAME + ".RowModified = 'true'" ).
     hPropQuery:QUERY-OPEN().
     hPropQuery:GET-FIRST().
     DO WHILE hPropBuffer:AVAILABLE:
     /* check whether the attribute was modified and if it's override flag is set */
       ASSIGN cDataType = hPropBuffer:BUFFER-FIELD("dataType":U):BUFFER-VALUE
              cValue    = hPropBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE
              cAttr     = hPropBuffer:BUFFER-FIELD("attrLabel":U):BUFFER-VALUE.


       IF hPropBuffer:BUFFER-FIELD("RowOverride":U):BUFFER-VALUE = TRUE THEN
       DO:
          CASE cDataType:
           WHEN "CHARACTER":U OR WHEN "CHAR":U THEN
            {&Create-Char-Instance} cValue, ?, ?, ?, ?, ?).
           WHEN "INTEGER":U OR WHEN "INT":U THEN
            {&Create-int-instance} cValue, ?, ?, ?).
           WHEN "DECIMAL":U OR WHEN "DEC":U THEN
            {&Create-dec-instance} cValue, ?, ?, ?, ?).
           WHEN "LOGICAL":U OR WHEN "LOG":U THEN
            {&Create-log-instance} cValue, ?, ?).
           WHEN "DATE":U THEN
            RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr,?,?,?,?,?,cValue,?).
          END CASE.
       END.
       ELSE
         /* Modified and override equals no so delete it */
         RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr).
       hPropQuery:GET-NEXT().
     END. /* Do while available */
     IF VALID-HANDLE(hPropQuery) THEN
        DELETE OBJECT hPropQuery NO-ERROR.
   END. /* If valid-handle hpropLib */
  END.  /* if valid handle _h_menubar_proc */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMasterAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setObjectMasterAttributes Procedure 
PROCEDURE setObjectMasterAttributes :
/*------------------------------------------------------------------------------
  Purpose:     To set the attributes for a master dynamic smartObject
  Parameters:  INPUT pRecid - Recid of the _U of the Frame of a Dynamic Viewer
                              or the _U of the Browse of a Dynamic Browser
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRecid           AS RECID                NO-UNDO.
    DEFINE INPUT  PARAMETER dSmartObject_obj AS DECIMAL              NO-UNDO.
    DEFINE INPUT  PARAMETER cLayout          AS CHARACTER            NO-UNDO.


    DEFINE VARIABLE cBrowseFields         AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cEnabledFields        AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColBGColors      AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColFGColors      AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColFonts         AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColFormats       AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColLabelBGColors AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColLabelFGColors AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColLabelFonts    AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColLabels        AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cBrwsColWidths        AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE hPropBuffer           AS HANDLE                  NO-UNDO.
    DEFINE VARIABLE hPropLib              AS HANDLE                  NO-UNDO.
    DEFINE VARIABLE httClassBuffer        AS HANDLE                  NO-UNDO.
    DEFINE VARIABLE cResultCode           AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cDataType             AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cValue                AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE hPropQuery            AS HANDLE     NO-UNDO.

    DEFINE BUFFER b_U  FOR _U.
    DEFINE BUFFER b2_U FOR _U.

    /* If this is a new master, set SmartObject_obj to unknown */
    IF dSmartObject_obj = 0 THEN dSmartObject_obj = ?.

    FIND b_U WHERE RECID(b_U) = pRecid.
    FIND b2_U WHERE b2_U._HANDLE = b_U._WINDOW-HANDLE.
    FIND _C WHERE RECID(_C) = b_U._x-recid NO-ERROR.
    FIND _L WHERE _L._LO-NAME = cLayout AND _L._u-recid = RECID(b_U) NO-ERROR.

    IF cLayout = "Master Layout":U THEN DO:
      httClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                        cObjClassType).
          
      IF httClassBuffer:AVAILABLE THEN DO:
        /* Have the Buffer conatining handle of the temp-table containing the attributes
           of the DynView Class */
        ASSIGN hAttributeBuffer = httClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE
               WhereStoredNumEntries = NUM-ENTRIES(b_U._WHERE-STORED).
        hAttributeBuffer:BUFFER-CREATE. /* Causes intial values to be created in native data-type */
   
        IF hAttributeBuffer:AVAILABLE THEN DO:
  
          IF cClassName = "DynBrow":U THEN /* if a browser */
          DO:
              RUN collectBrowseColumns( INPUT pRecid,
                                        OUTPUT cBrowseFields,
                                        OUTPUT cEnabledFields,
                                        OUTPUT cBrwsColBGColors,
                                        OUTPUT cBrwsColFGColors,
                                        OUTPUT cBrwsColFonts,
                                        OUTPUT cBrwsColFormats,
                                        OUTPUT cBrwsColLabelBGColors,
                                        OUTPUT cBrwsColLabelFGColors,
                                        OUTPUT cBrwsColLabelFonts,
                                        OUTPUT cBrwsColLabels,
                                        OUTPUT cBrwsColWidths).
              /* If this is a conversion from a static browse, make sure that the 
               * EnabledFields property is set to DisplayedFields property.
               * The migration tool need to ensure that instances 
               * of adm2/dynbrowser.w where the EnabledFields is 
               * set to blank stores the same value as the 
               * DisplayedFields in this property. 
               *
               * This is needed to ensure that the browwser 
               * behaves as it did before it was migrated. 
               * browser.p initializeObject automatically sets 
               * EnabledFields to the same as DisplayedFields if 
               * the property is blank, but issue 3868 was fixed 
               * to remove this behavior for repository objects.              */
  
              IF lMigration AND cEnabledFields EQ "":U THEN
                  ASSIGN cEnabledFields = cBrowseFields.
          END.    /* Browser */
  
          /* Only write attributes that are not default values */
          DO i = 1 TO hAttributeBuffer:NUM-FIELDS:
  
            ASSIGN cAttr = hAttributeBuffer:BUFFER-FIELD(i):NAME
                   cWhereStored = IF (i < WhereStoredNumEntries) THEN ENTRY(i, b_U._WHERE-STORED)
                                  ELSE "3":U.  /* Three is safe... we will attempt to delete it */
            
            IF CAN-DO("CLASS":U, DYNAMIC-FUNCTION("getWhereConstantLevel":U in gshRepositoryManager,
                                                  INPUT hAttributeBuffer,
                                                  INPUT hAttributeBuffer:BUFFER-FIELD(i)))
            THEN NEXT.
            
            CASE cAttr:
  
              WHEN "ALLOW-COLUMN-SEARCHING":U THEN
                {&if-not-default} _C._COLUMN-SEARCHING THEN
                   {&Create-log-Master} _C._COLUMN-SEARCHING, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "AUTO-VALIDATE":U THEN
                {&if-not-default} (NOT _C._NO-AUTO-VALIDATE) THEN
                   {&Create-log-Master} (NOT _C._NO-AUTO-VALIDATE), ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "BGCOLOR":U THEN
                {&if-not-default} _L._BGCOLOR THEN
                   {&Create-int-Master} _L._BGCOLOR, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.                                      
              WHEN "BrowseColumnBGColors":U THEN
                {&if-not-default} cBrwsColBGColors THEN
                   {&Create-char-Master} cBrwsColBGColors, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "BrowseColumnFGColors":U THEN
                {&if-not-default} cBrwsColFGColors THEN
                   {&Create-char-Master} cBrwsColFGColors, ?, ?, ?, ?, ?).           
                ELSE {&Delete-Master-Attribute}.                    
              WHEN "BrowseColumnFonts":U THEN
                {&if-not-default} cBrwsColFonts THEN
                   {&Create-char-Master} cBrwsColFonts, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.                    
              WHEN "BrowseColumnFormats":U THEN
                {&if-not-default} cBrwsColFormats THEN
                   {&Create-char-Master} cBrwsColFormats, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "BrowseColumnLabelBGColors":U THEN
                {&if-not-default} cBrwsColLabelBGColors THEN
                   {&Create-char-Master} cBrwsColLabelBGColors, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "BrowseColumnLabelFGColors":U THEN
                {&if-not-default} cBrwsColLabelFGColors THEN
                   {&Create-char-Master} cBrwsColLabelFGColors, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "BrowseColumnLabelFonts":U THEN
                {&if-not-default} cBrwsColLabelFonts THEN
                   {&Create-char-Master} cBrwsColLabelFonts, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "BrowseColumnLabels":U THEN
                {&if-not-default} cBrwsColLabels THEN
                   {&Create-char-Master} cBrwsColLabels, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "BrowseColumnWidths":U THEN
                {&if-not-default} cBrwsColWidths THEN
                   {&Create-char-Master} cBrwsColWidths, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "BOX":U THEN
                {&if-not-default} (NOT _L._NO-BOX) THEN
                   {&Create-log-Master} (NOT _L._NO-BOX), ?, ?).
                ELSE {&Delete-Master-Attribute}.                   
              WHEN "BOX-SELECTABLE":U THEN
                {&if-not-default} _C._BOX-SELECTABLE THEN
                   {&Create-log-Master} _C._BOX-SELECTABLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.                   
              WHEN "COLUMN-MOVABLE":U THEN
                {&if-not-default} _C._COLUMN-MOVABLE THEN
                   {&Create-log-Master} _C._COLUMN-MOVABLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "COLUMN-RESIZABLE":U THEN
                {&if-not-default} _C._COLUMN-RESIZABLE THEN
                   {&Create-log-Master} _C._COLUMN-RESIZABLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "COLUMN-SCROLLING":U THEN
                {&if-not-default} _C._COLUMN-SCROLLING THEN
                   {&Create-log-Master} _C._COLUMN-SCROLLING, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "CONTEXT-HELP-ID":U THEN
                {&if-not-default} _U._CONTEXT-HELP-ID THEN
                   {&Create-int-Master} _U._CONTEXT-HELP-ID, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "DisplayedFields":U THEN
                {&if-not-default} cBrowseFields THEN
                   {&Create-char-Master} cBrowseFields, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "DOWN":U THEN
                {&if-not-default} _C._DOWN THEN
                   {&Create-log-Master} _C._DOWN, ?, ?).
                ELSE {&Delete-Master-Attribute}.                   
              WHEN "DROP-TARGET":U THEN
                {&if-not-default} b_U._DROP-TARGET THEN
                   {&Create-log-Master} b_U._DROP-TARGET, ?, ?).
                ELSE {&Delete-Master-Attribute}.  
              WHEN "EnabledFields":U THEN
                {&if-not-default} cEnabledFields THEN
                   {&Create-char-Master} cEnabledFields, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "FGCOLOR":U THEN
                {&if-not-default} _L._FGCOLOR THEN
                   {&Create-int-Master} _L._FGCOLOR, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.            
              WHEN "FIT-LAST-COLUMN":U THEN
                {&if-not-default} _C._FIT-LAST-COLUMN THEN
                   {&Create-log-Master} _C._FIT-LAST-COLUMN, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "FolderWindowToLaunch":U THEN
                {&if-not-default} _C._FOLDER-WINDOW-TO-LAUNCH THEN
                   {&Create-char-Master} _C._FOLDER-WINDOW-TO-LAUNCH, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "FONT":U THEN
                {&if-not-default} _L._FONT THEN
                   {&Create-int-Master} _L._FONT, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "HELP":U THEN
                {&if-not-default} b_U._HELP THEN
                   {&Create-char-Master} b_U._HELP, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "HIDDEN":U THEN
                {&if-not-default} b_U._HIDDEN THEN
                   {&Create-log-Master} b_U._HIDDEN, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "MANUAL-HIGHLIGHT":U THEN
                {&if-not-default} b_U._MANUAL-HIGHLIGHT THEN
                   {&Create-log-Master} b_U._MANUAL-HIGHLIGHT, ?, ?).
                ELSE {&Delete-Master-Attribute}.             
              WHEN "MAX-DATA-GUESS":U THEN
                {&if-not-default} _C._MAX-DATA-GUESS THEN
                   {&Create-int-Master} _C._MAX-DATA-GUESS, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "MinHeight":U THEN
                {&if-not-default} MinHeight THEN
                   {&Create-dec-Master} MinHeight, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "MinWidth":U THEN
                {&if-not-default} MinWidth THEN
                   {&Create-dec-Master} MinWidth, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "MOVABLE":U THEN
                {&if-not-default} b_U._MOVABLE THEN
                   {&Create-log-Master} b_U._MOVABLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.            
              WHEN "MULTIPLE":U THEN
                {&if-not-default} _C._MULTIPLE THEN
                   {&Create-log-Master} _C._MULTIPLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "NO-EMPTY-SPACE":U THEN
                {&if-not-default} _C._NO-EMPTY-SPACE THEN
                   {&Create-log-Master} _C._NO-EMPTY-SPACE, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "NUM-LOCKED-COLUMNS":U THEN
                {&if-not-default} _C._NUM-LOCKED-COLUMNS THEN
                   {&Create-int-Master} _C._NUM-LOCKED-COLUMNS, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "OVERLAY":U THEN
                {&if-not-default} _C._OVERLAY THEN
                   {&Create-log-Master} _C._OVERLAY, ?, ?).
                ELSE {&Delete-Master-Attribute}.            
              WHEN "PAGE-BOTTOM":U THEN
                {&if-not-default} _C._PAGE-BOTTOM THEN
                   {&Create-log-Master} _C._PAGE-BOTTOM, ?, ?).
                ELSE {&Delete-Master-Attribute}.             
              WHEN "PAGE-TOP":U THEN
                {&if-not-default} _C._PAGE-TOP THEN
                   {&Create-log-Master} _C._PAGE-TOP, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "PRIVATE-DATA":U THEN
                {&if-not-default} b_U._PRIVATE-DATA THEN
                   {&Create-char-Master} b_U._PRIVATE-DATA, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "RESIZABLE":U THEN
                {&if-not-default} b_U._RESIZABLE THEN
                   {&Create-log-Master} b_U._RESIZABLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "ROW-HEIGHT-CHARS":U THEN
                {&if-not-default} _C._ROW-HEIGHT THEN
                   {&Create-dec-Master} _C._ROW-HEIGHT, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.                
              WHEN "ROW-MARKERS":U THEN
                {&if-not-default} (NOT _C._NO-ROW-MARKERS) THEN
                   {&Create-log-Master} (NOT _C._NO-ROW-MARKERS), ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "SCROLLABLE":U THEN
                {&if-not-default} _C._SCROLLABLE THEN
                   {&Create-log-Master} _C._SCROLLABLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "SCROLLBAR-VERTICAL":U THEN
                {&if-not-default} b_U._SCROLLBAR-V THEN
                   {&Create-log-Master} b_U._SCROLLBAR-V, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "SELECTABLE":U THEN
                {&if-not-default} b_U._SELECTABLE THEN
                   {&Create-log-Master} b_U._SELECTABLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "SENSITIVE":U THEN
                {&if-not-default} b_U._SENSITIVE THEN
                   {&Create-log-Master} b_U._SENSITIVE, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "SEPARATOR-FGCOLOR":U THEN
                {&if-not-default} _L._SEPARATOR-FGCOLOR THEN
                   {&Create-int-Master} _L._SEPARATOR-FGCOLOR, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "SEPARATORS":U THEN
                {&if-not-default} _L._SEPARATORS THEN
                   {&Create-log-Master} _L._SEPARATORS, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "ShowPopup":U THEN
                {&if-not-default} b_U._SHOW-POPUP THEN
                   {&Create-log-Master} b_U._SHOW-POPUP, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "SIDE-LABELS":U THEN
                {&if-not-default} _C._SIDE-LABELS THEN
                   {&Create-log-Master} _C._SIDE-LABELS, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "SizeToFit" THEN
                {&if-not-default} _C._SIZE-TO-FIT THEN
                   {&Create-log-Master} _C._SIZE-TO-FIT, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "TAB-STOP":U THEN
                {&if-not-default} (NOT b_U._NO-TAB-STOP) THEN
                   {&Create-log-Master} (NOT b_U._NO-TAB-STOP), ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "THREE-D":U THEN
                {&if-not-default} _L._3-D THEN
                   {&Create-log-Master} _L._3-D, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              /* This isn't working and I don't know why 
              WHEN "TITLE":U THEN
                {&if-not-default} _C._TITLE THEN
                   {&Create-log-Master} _C._TITLE, ?, ?).
                ELSE {&Delete-Master-Attribute}.               */
              WHEN "TOOLTIP":U THEN
                {&if-not-default} b_U._TOOLTIP THEN
                   {&Create-char-Master} b_U._TOOLTIP, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.
              WHEN "WindowTitleField":U THEN
                {&if-not-default} _C._WINDOW-TITLE-FIELD THEN
                   {&Create-char-Master} _C._WINDOW-TITLE-FIELD, ?, ?, ?, ?, ?).
                ELSE {&Delete-Master-Attribute}.              
              /* These attributes are not manipulated in the AppBuilder  */
            END CASE.
          END. /* Loop through attributes */
        END.  /* If we have the Attribute buffer for the object Class */
        hAttributeBuffer:BUFFER-DELETE.
      END. /* If we get back a valid handle for the cache */
    END.  /* If cLayout = Master Layout */
    ELSE  /* If this is a custom layout, create record only if the attributes differ from the Master */
    IF cLayout NE "Master Layout":U THEN
      RUN ProcessCustomAttributes(INPUT "MASTER":U, INPUT dSmartobject_obj, INPUT RECID(_L)).  
      
    IF VALID-HANDLE(_h_menubar_proc) THEN
    DO:
      hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
   IF VALID-HANDLE(hPropLib) THEN 
   DO:
        ASSIGN hPropBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hPropLib, "ttAttribute":U)
                cResultCode = IF cLayout = "Master Layout":U THEN "" ELSE cLayout.
         CREATE QUERY hPropQuery.
         hPropQuery:SET-BUFFERS(hPropBuffer).
   hPropQuery:QUERY-PREPARE
            (" FOR EACH " + hPropBuffer:NAME + " WHERE " 
              + hPropBuffer:NAME + ".callingProc = '":U + STRING(_h_menubar_proc) + "' AND ":U 
        + hPropBuffer:NAME + ".containerName = '":U + STRING(b2_U._Window-handle) + "' AND ":U
        + hPropBuffer:NAME + ".resultCode = '":U + cResultCode + "' AND ":U
         + hPropBuffer:NAME + ".objectName = '":U + STRING(b2_U._HANDLE) + "' AND "
          + hPropBuffer:NAME + ".RowModified = 'true'" ).
    hPropQuery:QUERY-OPEN().
   hPropQuery:GET-FIRST().
   DO WHILE hPropBuffer:AVAILABLE:
        /* check whether the attribute was modified and if it's override flag is set */
      ASSIGN cDataType = hPropBuffer:BUFFER-FIELD("dataType":U):BUFFER-VALUE
       cValue    = hPropBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE
       cAttr     = hPropBuffer:BUFFER-FIELD("attrLabel":U):BUFFER-VALUE.
   IF hPropBuffer:BUFFER-FIELD("RowOverride":U):BUFFER-VALUE = TRUE THEN
   DO:
     CASE cDataType:
       WHEN "CHARACTER":U OR WHEN "CHAR":U THEN
         {&Create-Char-Master} cValue, ?, ?, ?, ?, ?).
       WHEN "INTEGER":U OR WHEN "INT":U THEN
         {&Create-int-Master} cValue, ?, ?, ?).
       WHEN "DECIMAL":U OR WHEN "DEC":U THEN
      {&Create-dec-Master} cValue, ?, ?, ?, ?).
    WHEN "LOGICAL":U OR WHEN "LOG":U THEN
      {&Create-log-Master} cValue, ?, ?).
    WHEN "DATE":U THEN
      RUN CreateAttributeRow(INPUT "MASTER":U, INPUT dSmartObject_obj, INPUT cAttr,?,?,?,?,?,cValue,?).
     END CASE.
   END.  /* if an attribute was modified and overridden */
   ELSE 
   /* Override was de-selected to remove attribute */
        RUN DeleteAttributeRow (INPUT "MASTER":U, INPUT dSmartobject_obj, INPUT cAttr)     .        

   hPropQuery:GET-NEXT().
  END. /* DO WHILE hPropBuffer AVAIL */
        IF VALID-HANDLE(hPropQuery) THEN
          DELETE OBJECT hPropQuery NO-ERROR.
   END.  /* If hPropLib is valid */
    END.  /* if _h_menubar_proc is valid */ 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSmartDataFieldValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSmartDataFieldValues Procedure 
PROCEDURE setSmartDataFieldValues :
/*------------------------------------------------------------------------------
  Purpose:     To load the the cAttributeValues field with a CHR(3) delimited
               list of a Dynamic Combo boxes widget's attributes.
  Parameters:  puRecid     - RECID of the _U record of the widget whose attributes
                             need to be loaded.
               dViewer_obj - Parent Viewer Object obj
  Notes:       This procedure is used to map SmartSelect SmartDataFields and 
               their associated SDOs to the Dynamics Dyanmic Lookup Combo-Box.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER puRecid      AS RECID      NO-UNDO.
  DEFINE INPUT  PARAMETER dViewer_obj  AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER cLayout      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pError       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE i               AS INTEGER         NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE cBaseName       AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE cDataType       AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE cObjectName     AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE cFormat         AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE cObject_type_code  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cOBJFileName    AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE cSDFFileName    AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE dDataFieldMaster_Obj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObject_obj     AS DECIMAL         NO-UNDO.
  DEFINE VARIABLE cTmp            AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE dValue          AS DECIMAL         NO-UNDO.
  DEFINE VARIABLE FldName         AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE foundIt         AS LOGICAL         NO-UNDO.
  DEFINE VARIABLE hObjectBuffer   AS HANDLE          NO-UNDO.
  DEFINE VARIABLE httClassBuffer  AS HANDLE          NO-UNDO.
  DEFINE VARIABLE hTmp            AS HANDLE          NO-UNDO.
  DEFINE VARIABLE iCnt            AS INTEGER         NO-UNDO.
  DEFINE VARIABLE iValue          AS INTEGER         NO-UNDO.
  DEFINE VARIABLE lValue          AS LOGICAL         NO-UNDO.
  DEFINE VARIABLE lConverting     AS LOGICAL         NO-UNDO.
  DEFINE VARIABLE hPropBuffer     AS HANDLE          NO-UNDO.
  DEFINE VARIABLE hPropLib        AS HANDLE          NO-UNDO.
  DEFINE VARIABLE cResultCode     AS CHARACTER       NO-UNDO.
  DEFINE VARIABLE lNeedToDelete   AS LOGICAL         NO-UNDO.
  DEFINE VARIABLE hPropQuery      AS HANDLE          NO-UNDO.
  
 
  DEFINE BUFFER b_U  FOR _U.
  DEFINE BUFFER df_U FOR _U.

  FIND b_U WHERE RECID(b_U) = puRecid.

  FIND _S WHERE RECID(_S) = b_U._x-recid.
  FIND _L WHERE _L._LO-NAME = cLayout AND _L._u-recid = RECID(b_U).    

  dObject_obj = b_U._OBJECT-OBJ.       /* object obj of the SDF Instance*/

  /* Establish cObject_type_code */
  _S._FILE-NAME = REPLACE(_S._FILE-NAME, "~\":U, "~/":U).
  CASE _S._FILE-NAME:
    WHEN "adm2/dyncombo.w":U  THEN cObject_type_code = "DynCombo":U.
    WHEN "adm2/dynselect.w":U THEN cObject_type_code = "DynSelect":U.
    WHEN "adm2/dynlookup.w":U THEN cObject_type_code = "DynLookup":U.
    OTHERWISE DO:
       cTmp = ENTRY(NUM-ENTRIES(_S._FILE-NAME,"~/":U), _S._FILE-NAME, "~/":U).
       foundIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                  INPUT cTmp,
                                  INPUT ?,
                                  INPUT ?,
                                  INPUT YES).
       IF NOT foundIt THEN    /* Try it without the extension */
         foundIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                  INPUT ENTRY(1, cTmp, ".":U),
                                  INPUT ?,
                                  INPUT ?,
                                  INPUT YES).
       IF NOT foundIT THEN DO:
         pError = "Unable to locate " + _S._FILE-NAME + " in the repository." + CHR(10) +
                  "Please register it." + CHR(10) .
         RETURN.
       END. /* If not found */

       /* We have found the SDF, get some info */
       hObjectBuffer = DYNAMIC-FUNC("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

       ASSIGN cObject_type_code = hObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
              b_U._CLASS-NAME   = cObject_type_code
              cOBJFilename      = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE.

    END. /* Otherwise */
  END CASE.


  /* Collect some info we will need later */
  IF cOBJFileName = "":U AND VALID-HANDLE(_S._HANDLE) THEN
    ASSIGN cOBJFileName = DYNAMIC-FUNCTION('getSDFFileName' IN _S._HANDLE) NO-ERROR.
  IF cOBJFileName = "":U AND VALID-HANDLE(_S._HANDLE) THEN /* This will be the case when converting a static viewer */
    ASSIGN cObjFilename = SUBSTRING(b_U._NAME, 3, -1, "CHARACTER":U)
           lConverting  = TRUE.
  ASSIGN FldName      = DYNAMIC-FUNCTION('getFieldName' IN _S._HANDLE).

  IF dObject_obj = 0 THEN DO: /* This is new, create it */
    /* If converting, it is possible that no master exists, if so then first create
       master */
    IF lConverting AND VALID-HANDLE(_S._HANDLE) THEN DO:
      /* Get the name of the master object, if it is blank, then we need to create it */
      cSDFFileName = DYNAMIC-FUNCTION('getSDFFileName':U IN _S._HANDLE) NO-ERROR.
      IF cSDFFileName = "":U THEN DO:
        ASSIGN cSDFFileName = cObject_type_code + ENTRY(1, DYNAMIC-FUNCTION('getQueryTables':U IN _S._HANDLE))
               icnt         = 0
               cBaseName    = cSDFFileName.
        /* If already in the repository, add an integer to the name */
        foundIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                  INPUT cSDFFilename,
                                  INPUT ?,
                                  INPUT ?,
                                  INPUT NO).  /* By saying no to design mode we refresh the cache */
        DO WHILE foundIt:
          ASSIGN icnt    = icnt + 1
                 cSDFFileName = cBaseName + STRING(icnt)
                 foundIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                    INPUT cSDFFilename,
                                    INPUT ?,
                                    INPUT ?,
                                    INPUT NO).
        END.  /* Do while we have found an object of the name cSDFFileName */

        RUN CreateMasterSDF(INPUT _S._HANDLE, 
                            INPUT cSDFFileName, 
                            INPUT cObject_type_code, 
                            OUTPUT dDataFieldMaster_Obj ).

        IF dDataFieldMaster_obj NE 0 THEN
          cOBJFileName = cSDFFileName.
      END.  /* No SDFFileName, create the master */
    END.  /* If converting */


    RUN insertObjectInstance IN ghRepositoryDesignManager
        ( INPUT dViewer_obj,                  /* Container Viewer                  */
          INPUT cOBJFileName,                 /* Object Name                       */                  
          INPUT IF b_U._LAYOUT-NAME = "Master Layout":U
                THEN "":U ELSE b_U._LAYOUT-NAME,    /* Result Code                 */
          INPUT b_U._NAME,                    /* Instance Name                     */
          INPUT "SmartDataField of type ":U + cObject_type_code, /* Description    */
          INPUT "":U,                         /* Layout Position                   */
          INPUT NO,                           /* Force creation                    */
          INPUT ?,                            /* Buffer handle for attribute table */
          INPUT TABLE-HANDLE hUnKnown,        /* Table handle for attribute table  */
          OUTPUT dDataFieldMaster_Obj,        /* Master obj                        */
          OUTPUT dObject_Obj )                /* Instance Obj                      */
          NO-ERROR.
  END.  /* Creating a new instance in the viewer */
 
  /* Bring the object into the cache */
  foundIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                  INPUT cObjFilename,
                                  INPUT ?,
                                  INPUT ?,
                                  INPUT YES).

  /* The cache_object Buffer and AttributeBuffer records should be available after 
     the cacheObjectOnClient call. */
  ASSIGN hObjectBuffer    = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, 
                                             INPUT ?).

  IF VALID-HANDLE(hObjectBuffer) THEN DO:
    /* Have the handle of the cache_object Temp-Table containing the SDF instanceand master    */
    /* Get any record for this SDF so we can then find the c_cache buffer and the master record */
    hObjectBuffer:FIND-FIRST("WHERE " + hObjectBuffer:NAME + ".tLogicalObjectName = ":U +
                             quoter(cObjFilename)).
    ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

    /* Get the master attributes */
    hAttributeBuffer:FIND-FIRST("WHERE " + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + 
                     QUOTER(hObjectBuffer:BUFFER-FIELD("tMasterRecordIdentifier":U):BUFFER-VALUE)) NO-ERROR.

    IF hAttributeBuffer:AVAILABLE THEN DO:
      WhereStoredNumEntries = NUM-ENTRIES(b_U._WHERE-STORED).

      /* Only write attributes that are not default values */
      DO i = 1 TO hAttributeBuffer:NUM-FIELDS:

        ASSIGN cAttr        = hAttributeBuffer:BUFFER-FIELD(i):NAME
               cWhereStored = IF (i < WhereStoredNumEntries) THEN ENTRY(i, b_U._WHERE-STORED)
                              ELSE "5":U.  /* Five is safe... we will attempt to delete it */

        IF CAN-DO("CLASS,MASTER":U, DYNAMIC-FUNCTION("getWhereConstantLevel":U in gshRepositoryManager,
                                        INPUT hAttributeBuffer,INPUT hAttributeBuffer:BUFFER-FIELD(i)))
        THEN NEXT.
        CASE cAttr:
                
            /* Character Attributes */
            WHEN "BaseQueryString":U OR
            WHEN "BrowseFieldDataTypes":U OR
            WHEN "BrowseFieldFormats":U OR
            WHEN "BrowseFields":U OR
            WHEN "BrowseTitle":U OR
            WHEN "ColumnFormat":U OR
            WHEN "ColumnLabels":U OR
            WHEN "ComboFlag":U OR
            WHEN "DescSubstitute":U OR
            WHEN "DisplayDataType":U OR
            WHEN "DisplayedField":U OR
            WHEN "DisplayFormat":U OR
            WHEN "FieldLabel":U OR
            WHEN "FieldName":U OR
            WHEN "FieldToolTip":U OR
            WHEN "FlagValue":U OR
            WHEN "KeyDataType" OR
            WHEN "KeyField":U OR
            WHEN "KeyFormat":U OR
            WHEN "LinkedFieldDataTypes":U OR
            WHEN "LinkedFieldFormats":U OR
            WHEN "LookupImage":U OR
            WHEN "MaintenanceObject":U OR
            WHEN "MaintenanceSDO":U OR
            WHEN "ParentField":U OR
            WHEN "ParentFilterQuery":U OR
            WHEN "QueryTables":U OR
            WHEN "SDFTemplate":U OR
            WHEN "ViewerLinkedFields":U OR
            WHEN "ViewerLinkedWidgets":U
            THEN DO:
              cValue = DYNAMIC-FUNCTION('get':U + cAttr IN _S._HANDLE) NO-ERROR.
              {&If-not-default} cValue THEN
                 {&Create-Char-instance} cValue, ?, ?, ?, ?, ?).
              ELSE {&Delete-instance-Attribute}.
            END.

            /* Special case for SDFFileName when converting from a static viewer */
            WHEN "SDFFileName":U THEN DO:
              cValue = DYNAMIC-FUNCTION('get':U + cAttr IN _S._HANDLE) NO-ERROR.
              {&If-not-default} cValue AND cValue NE "":U THEN
                 {&Create-Char-instance} cValue, ?, ?, ?, ?, ?).
              ELSE {&Delete-instance-Attribute}.
            END.
        
            /* Integer Attributes */
            WHEN "BuildSequence":U OR
            WHEN "InnerLines":U OR
            WHEN "RowsToBatch":U
            THEN DO:
              iValue = DYNAMIC-FUNCTION('get' + cAttr IN _S._HANDLE) NO-ERROR.
              {&If-not-default} iValue THEN
                 {&Create-Int-instance} iValue, ?, ?, ?).
              ELSE {&Delete-instance-Attribute}.
            END.
        
            /* Logical Attributes */
            WHEN "DisplayField":U OR
            WHEN "DisableOnInit":U OR
            WHEN "EnableField":U OR
            WHEN "LocalField":U OR
            WHEN "BlankOnNotAvail":U OR
            WHEN "PopupOnAmbiguous":U OR
            WHEN "PopupOnNotAvail":U OR
            WHEN "PopupOnUniqueAmbiguous":U
            THEN DO:
              lValue = DYNAMIC-FUNCTION('get':U + cAttr IN _S._HANDLE) NO-ERROR.
                {&If-not-default} lValue THEN
                  {&Create-Log-instance} lValue, ?, ?).
              ELSE {&Delete-instance-Attribute}.
            END.
        
            /* Attributes from the temp-tables */ 
            WHEN "HEIGHT-CHARS":U THEN
              {&If-not-default} _L._HEIGHT THEN
                 {&Create-Dec-instance} _L._HEIGHT, ?, ?, ?, ?).
              ELSE {&Delete-instance-Attribute}.
            WHEN "MasterFile":U THEN
              {&If-not-default} _S._FILE-NAME THEN
                {&Create-Char-instance} _S._FILE-NAME, ?, ?, ?, ?, ?).
              ELSE {&Delete-instance-Attribute}.  
            WHEN "WIDTH-CHARS":U THEN
              {&If-not-default} _L._WIDTH THEN
                 {&Create-Dec-Instance} _L._WIDTH, ?, ?, ?, ?).
              ELSE {&Delete-instance-Attribute}.
            WHEN "Order":U THEN
             {&If-not-default} b_U._TAB-ORDER THEN
                 {&Create-Int-instance} b_U._TAB-ORDER, ?, ?, ?).
              ELSE {&Delete-instance-Attribute}.

        END CASE.
      END. /* Loop though buffer fields */
    END. /* IF hAttributeBuffer:AVAILABLE */
  END.  /*IF VALID-HANDLE(hObjectBuffer) */

  /* Retrieve the dynamic property sheet attributes that have been modified, and assign them */
  IF VALID-HANDLE(_h_menubar_proc) THEN
  DO:
     hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
     IF VALID-HANDLE(hPropLib) THEN 
     DO:
        ASSIGN hPropBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hPropLib, "ttAttribute":U).
        CREATE QUERY hPropQuery.
        hPropQuery:SET-BUFFERS(hPropBuffer).
        hPropQuery:QUERY-PREPARE(" FOR EACH " + hPropBuffer:NAME + " WHERE " 
                          + hPropBuffer:NAME + ".callingProc = '":U + STRING(_h_menubar_proc) + "' AND ":U 
                          + hPropBuffer:NAME + ".containerName = '":U + STRING(b_U._Window-handle) + "' AND ":U
                          + hPropBuffer:NAME + ".resultCode = '":U + cResultCode + "' AND ":U
                          + hPropBuffer:NAME + ".objectName = '":U + STRING(b_U._HANDLE) + "' AND "
                          + hPropBuffer:NAME + ".RowModified = 'true'" ).
        hPropQuery:QUERY-OPEN().
        hPropQuery:GET-FIRST().
        DO WHILE hPropBuffer:AVAILABLE:
           /* check whether the attribute was modified and if it's override flag is set */
           ASSIGN cDataType = hPropBuffer:BUFFER-FIELD("dataType":U):BUFFER-VALUE
                  cValue    = hPropBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE
                  cAttr     = hPropBuffer:BUFFER-FIELD("attrLabel":U):BUFFER-VALUE.

           /* check whether the attribute was modified and if it's override flag is set */
           IF hPropBuffer:BUFFER-FIELD("RowOverride":U):BUFFER-VALUE = TRUE THEN
           DO:
             CASE cDataType:
               WHEN "CHARACTER":U OR WHEN "CHAR":U THEN
                  {&Create-Char-Instance} cValue, ?, ?, ?, ?, ?).
               WHEN "INTEGER":U OR WHEN "INT":U THEN
                  {&Create-int-Instance} INT(cValue), ?, ?, ?).
               WHEN "DECIMAL":U OR WHEN "DEC":U THEN
                 {&Create-dec-Instance} DEC(cValue), ?, ?, ?, ?).
               WHEN "LOGICAL":U OR WHEN "LOG":U THEN
                  {&Create-log-Instance} LOGICAL(cValue), ?, ?).
               WHEN "DATE":U THEN
                  RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_Obj, INPUT cAttr,
                         INPUT {&DATE-DATA-TYPE}, ?, ?, ?, ?, DATE(cValue), ?).
             END CASE.
           END.  /* if an attribute was modified and overridden */
           ELSE 
             /* Override was de-selected to remove attribute */
              RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_Obj, INPUT cAttr)     .        

           hPropQuery:GET-NEXT().
        END. /* DO WHILE hPropBuffer:AVAIL */
        IF VALID-HANDLE(hPropQuery) THEN
           DELETE OBJECT hPropQuery NO-ERROR.
     END.  /* If hPropLib is valid */
  END.  /* if _h_menubar_proc is valid */ 
  /* Set the Fieldname, row, col, height and width */
  RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_Obj, INPUT "FieldName":U,
                         INPUT {&CHARACTER-DATA-TYPE}, FldName, ?, ?, ?, ?, ?).
  RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_Obj, INPUT "COLUMN":U, 
                         INPUT {&DECIMAL-DATA-TYPE}, ?, INPUT _L._COL , ?, ?, ?, ?).
  RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_Obj, INPUT "ROW":U, 
                         INPUT {&DECIMAL-DATA-TYPE}, ?, INPUT _L._ROW , ?, ?, ?, ?).

  hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
  RUN StoreAttributeValues IN gshRepositoryManager
      (INPUT hTmp ,
       INPUT TABLE-HANDLE hUnKnown) NO-ERROR.  /* Compiler requires a variable with unknown */
       
  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
    RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

  /* Empty the temp-table */
  EMPTY TEMP-TABLE ttStoreAttribute.


  IF lNeedToDelete THEN
    hAttributeBuffer:BUFFER-DELETE.

  /* If we are setting something back to its default value */
  IF CAN-FIND(FIRST DeleteAttribute) THEN DO:
    hTmp = TEMP-TABLE DeleteAttribute:DEFAULT-BUFFER-HANDLE.
    RUN RemoveAttributeValues IN ghRepositoryDesignManager
       (INPUT hTmp,
         INPUT TABLE-HANDLE hUnknown).
 
    EMPTY TEMP-TABLE DeleteAttribute.
  END. /* If there are any records */
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SuperProcEventReg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SuperProcEventReg Procedure 
PROCEDURE SuperProcEventReg :
/*------------------------------------------------------------------------------
  Purpose:     For a new super procedure that is being migrated,
               register all new events in the repository.
  Parameters:  prRecird     RECID of buf_P table
               pdCustomID   Custom Super procedure smartObjectObj ID
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pRec        AS RECID      NO-UNDO.
 
 DEFINE VARIABLE hUnKnown      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hEventBuffer  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cEventName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEventAction  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSelfName     AS CHARACTER  NO-UNDO.
 
 DEFINE BUFFER buf_P FOR _P.
 DEFINE BUFFER buf_U FOR _U.
 DEFINE BUFFER buf_TRG FOR _TRG.

 FIND buf_P WHERE RECID(buf_P) = pRec .
 

 /* Empty the temp-table */
 EMPTY TEMP-TABLE ttStoreUIEvent.
 
  
  /* loop through each field in the specified object */
 WIDGET-LOOP:
 FOR EACH buf_U WHERE buf_U._WINDOW-HANDLE = buf_P._WINDOW-HANDLE
               AND buf_U._STATUS <> "DELETED" :
 
    /* Skip this section if no triggers.  */
    IF buf_U._TYPE NE "BROWSE":U 
       AND NOT CAN-FIND(FIRST buf_TRG WHERE buf_TRG._wRECID   EQ RECID (buf_U)
                                     AND buf_TRG._STATUS   EQ "NORMAL":U
                                     AND buf_TRG._tSECTION EQ "_CONTROL":U) THEN 
       NEXT WIDGET-LOOP.

    IF buf_U._TYPE = "BROWSE":U THEN 
    CHECK-BROWSE:
    DO:
      IF NOT CAN-FIND(FIRST buf_TRG WHERE buf_TRG._wRECID   EQ RECID (buf_U)
                                   AND buf_TRG._STATUS   EQ  "NORMAL":U
                                   AND buf_TRG._tSECTION EQ "_CONTROL":U
                                   AND NOT CAN-DO("DISPLAY,OPEN_QUERY,DEFINE_QUERY",buf_TRG._tEVENT)) THEN 
      DO:
        /* BROWSE HAS NO TRIGGER - see if COLUMNS DO */
        FOR EACH _BC WHERE _BC._x-recid = RECID(buf_U):
          IF CAN-FIND(FIRST buf_TRG WHERE buf_TRG._wRECID   EQ RECID(_BC)
                                   AND buf_TRG._STATUS   EQ "NORMAL":U
                                   AND buf_TRG._tSECTION EQ "_CONTROL":U) THEN
            LEAVE CHECK-BROWSE.                                          
        END. /* For each browse column */
        /* Only get here if both browse and _BC's don't have triggers */
        NEXT WIDGET-LOOP.
      END. /* IF browse doesn't have any triggers */
    END. /* CHECK-BROWSE */



    TRIGGER-BLOCK:
    FOR EACH buf_TRG WHERE buf_TRG._wRECID   EQ RECID(buf_U)
                  AND   buf_TRG._tSECTION EQ "_CONTROL":U
                  AND   buf_TRG._STATUS   EQ "NORMAL":U
                  USE-INDEX _RECID-EVENT:

        /* skip non-supported events */
       IF CAN-DO("DISPLAY,OPEN_QUERY,DEFINE_QUERY",buf_TRG._tEVENT) THEN  
          NEXT TRIGGER-BLOCK.
       IF  buf_U._TYPE = "BROWSE":U 
           AND CAN-DO("CTRL-END,CTRL-HOME,END,HOME,OFF-END,OFF-HOME,ROW-ENTRY,ROW-LEAVE,SCROLL-NOTIFY,VALUE-CHANGED":U,
                  buf_TRG._tEVENT) THEN 
          NEXT TRIGGER-BLOCK.
       
       
       ASSIGN cSelfName = IF (buf_U._DBNAME EQ ? OR (AVAILABLE _F AND _F._DISPOSITION EQ "LIKE":U))
                          THEN buf_U._NAME
                          ELSE db-tbl-name(buf_U._DBNAME + "." + buf_U._TABLE) + "." + buf_U._NAME
              cSelfName = IF NUM-ENTRIES(cSelfName,".") > 1 
                          THEN ENTRY(NUM-ENTRIES(cSelfName,"."),cSelfName,".")
                          ELSE cSelfName 
              cEventName   = buf_TRG._tEvent
              cEventAction = cSelfName + buf_TRG._tEvent
              NO-ERROR.

     
       IF  buf_U._OBJECT-OBJ > 0 THEN
       DO:
         CREATE ttStoreUIEvent.
         ASSIGN tEventParent    = "INSTANCE":U
                tEventParentObj = buf_U._OBJECT-OBJ
                tEventName      = cEventName
                tEventAction    = cEventAction
                tActionType     = "RUN":U
                tActionTarget   = "SELF":U
                NO-ERROR.
       END.
    END. /* END For each TRIGGER-BLOCK: */
 END. /* END for WIDGET-BLOCK */

 /* Update the Events for this object */
 hEventBuffer = TEMP-TABLE ttStoreUIEvent:DEFAULT-BUFFER-HANDLE.
 RUN insertUIEvents IN ghRepositoryDesignManager
            (INPUT hEventBuffer ,
             INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */

 /* Empty the temp-table */
 EMPTY TEMP-TABLE ttStoreUIEvent.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ProcessCustomAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessCustomAttributes Procedure 
PROCEDURE ProcessCustomAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Custom layouts should not specify their attributes if they are the 
               same a the their default layout counterpart.  
               
               Also, if the custom attribute differs from the default attribute,
               we must be sure to create it.

  Parameters:
        INPUT pcObjectLevel        - MASTER or INSTANCE
        INPUT pdSmartObject_obj    - Object id of the SmartObject
        INPUT r_LRECID             - Recid of the custom _L
        
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectLevel      AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pdSmartObject_obj  AS DECIMAL     NO-UNDO.
  DEFINE INPUT  PARAMETER r_LRECID           AS RECID       NO-UNDO.

  DEFINE VARIABLE cAttr                      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE CustomizableAttrs          AS CHARACTER   NO-UNDO INITIAL
    "BGCOLOR,BOX,COLUMN,CONVERT-3D-COLORS,EDGE-PIXELS,FGCOLOR,FILLED,FONT,GRAPHIC-EDGE,~
HEIGHT-CHARS,LABELS,NO-FOCUS,ROW,SEPARATOR-FGCOLOR,SEPARATOR-FGCOLOR,THREE-D,WIDTH-CHARS":U.

  DEFINE BUFFER m_L FOR _L.

  /* If we are working on a custom layout remove all attributes that are the same a in
     the default layout ... based on the _L records                                  */
  FIND _L  WHERE RECID(_L) = r_LRECID.
  FIND m_L WHERE m_L._LO-NAME = "Master Layout":U AND m_L._u-recid = _L._u-recid.


  cAttr = "BGCOLOR":U.
  IF _L._BGCOLOR = m_L._BGCOLOR THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&INTEGER-DATA-TYPE}, INPUT ?, ?, _L._BGCOLOR, ?, ?, ?).
  

  cAttr = "BOX":U.
  IF _L._NO-BOX = m_L._NO-BOX THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, (NOT _L._NO-BOX), ?, ?).

  
  cAttr = "COLUMN":U.
  IF _L._COL = m_L._COL THEN 
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&DECIMAL-DATA-TYPE}, INPUT ?, _L._COL, ?, ?, ?, ?).


  cAttr = "CONVERT-3D-COLORS":U.
  IF _L._CONVERT-3D-COLORS = m_L._CONVERT-3D-COLORS THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, _L._CONVERT-3D-COLORS, ?, ?).


  cAttr = "EDGE-PIXELS":U.
  IF _L._EDGE-PIXELS = m_L._EDGE-PIXELS THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&INTEGER-DATA-TYPE}, INPUT ?, ?, _L._EDGE-PIXELS, ?,  ?, ?).


  cAttr = "FGCOLOR":U.
  IF _L._FGCOLOR = m_L._FGCOLOR THEN 
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&INTEGER-DATA-TYPE}, INPUT ?, ?, _L._FGCOLOR, ?, ?, ?).


  cAttr = "FieldLabel":U.
  IF _L._LABEL = m_L._LABEL THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&CHARACTER-DATA-TYPE}, INPUT _L._LABEL, ?, ?, ?, ?, ?).
  
  
  cAttr = "FILLED":U.
  IF _L._FILLED = m_L._FILLED THEN 
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, _L._FILLED, ?, ?).


  cAttr = "FONT":U.
  IF _L._FONT = m_L._FONT THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&INTEGER-DATA-TYPE}, INPUT ?, ?, _L._FONT, ?, ?, ?).


  cAttr = "GRAPHIC-EDGE":U.
  IF _L._GRAPHIC-EDGE = m_L._GRAPHIC-EDGE THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, _L._GRAPHIC-EDGE, ?, ?).


  cAttr = "HEIGHT-CHARS":U.
  IF pcObjectLevel = "MASTER":U THEN cAttr = "minHeight":U.
  IF _L._HEIGHT = m_L._HEIGHT THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&DECIMAL-DATA-TYPE}, INPUT ?, _L._HEIGHT, ?, ?, ?, ?).
 
  cAttr = "LABEL":U.
  IF _L._LABEL = m_L._LABEL THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&CHARACTER-DATA-TYPE}, INPUT _L._LABEL, ?, ?, ?, ?, ?).

  cAttr = "LABELS":U.
  IF _L._NO-LABELS = m_L._NO-LABELS THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, (NOT _L._NO-LABELS), ?, ?).


  cAttr = "NO-FOCUS":U.
  IF _L._NO-FOCUS = m_L._NO-FOCUS THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, _L._NO-FOCUS, ?, ?).


  cAttr = "ROW":U.
  IF _L._ROW = m_L._ROW THEN
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&DECIMAL-DATA-TYPE}, INPUT ?, _L._ROW, ?, ?, ?, ?).


  cAttr = "SEPARATOR-FGCOLOR":U.
  IF _L._SEPARATOR-FGCOLOR = m_L._SEPARATOR-FGCOLOR THEN 
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                              INPUT {&INTEGER-DATA-TYPE}, INPUT ?, ?, _L._SEPARATOR-FGCOLOR, ?, ?, ?).


  cAttr = "SEPARATOR-FGCOLOR":U.
  IF _L._SEPARATORS = m_L._SEPARATORS THEN 
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                              INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, _L._SEPARATORS, ?, ?).


  cAttr = "THREE-D":U.
  IF _L._3-D = m_L._3-D THEN 
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                              INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, _L._3-D, ?, ?).


  cAttr = "VISIBLE":U.
  IF _L._REMOVE-FROM-LAYOUT = m_L._REMOVE-FROM-LAYOUT THEN 
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                              INPUT {&LOGICAL-DATA-TYPE}, INPUT ?, ?, ?, NOT _L._REMOVE-FROM-LAYOUT, ?, ?).


  cAttr = "WIDTH-CHARS":U.
  IF pcObjectLevel = "MASTER":U THEN cAttr = "minWidth":U.
  IF _L._WIDTH = m_L._WIDTH THEN 
    RUN DeleteAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr).
  ELSE RUN CreateAttributeRow (INPUT pcObjectLevel, INPUT pdSmartObject_obj, INPUT cAttr,
                               INPUT {&DECIMAL-DATA-TYPE}, INPUT ?, _L._WIDTH, ?, ?, ?, ?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeFieldLevelObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeFieldLevelObjects Procedure 
PROCEDURE writeFieldLevelObjects :
/*------------------------------------------------------------------------------
  Purpose:    To write the field level objects of a dynamic viewer to the 
              repository 
  Parameters:
     INPUT  pPrecid - recid of _P to be written
     OUTPUT pError  - Error message if object can't be written
          
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pPrecid AS RECID                    NO-UNDO.
  DEFINE INPUT  PARAMETER cLayout AS CHARACTER                NO-UNDO.
  DEFINE OUTPUT PARAMETER pError  AS CHARACTER                NO-UNDO.

  DEFINE BUFFER b_U             FOR _U.
  DEFINE BUFFER m_L             FOR _L.

  /* b_U is an extra buffer for field level objects */
  DEFINE VARIABLE cAssignList          AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cAttrDiffs           AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cCalculatedColumns   AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cCode                AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cColumnTable         AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cDataSourceType      AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cDescription         AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cInstanceName        AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cMasterObjectName    AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cObjectTypeCode      AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cSDOList             AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cTableAssigns        AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cTableList           AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cTmpCodes            AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE dSmartViewer         AS DECIMAL                 NO-UNDO.
  DEFINE VARIABLE hsboSDO              AS HANDLE                  NO-UNDO.
  DEFINE VARIABLE hTmp                 AS HANDLE                  NO-UNDO.
  DEFINE VARIABLE iCode                AS INTEGER                 NO-UNDO.
  DEFINE VARIABLE iTableNum            AS INTEGER                 NO-UNDO.
  DEFINE VARIABLE iPos                 AS INTEGER                 NO-UNDO.
  DEFINE VARIABLE cDataSource          AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE cDSLogicalName       AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE lCalculatedField     AS LOGICAL                 NO-UNDO.
  DEFINE VARIABLE lIsSDO               AS LOGICAL                 NO-UNDO.

  /* Get the _P record of the dynamic viewer being written  */
  FIND _P WHERE RECID(_P) = pPrecid.
  FIND _U WHERE RECID(_U) = _P._u-recid.

  dSmartViewer = _P.SmartOBJECT_obj.  /* default ... should be the case for Master Layout */

  FIND tResultCodes WHERE tResultCodes.cRC = cLayout NO-ERROR.
  IF AVAILABLE tResultCodes THEN dSmartViewer = tResultCodes.dContainerObj.

  /* Get the associated SDO of the viewer */
  IF _P._DATA-OBJECT NE "" THEN    
  DO:  
    cDataSource = _P._DATA-OBJECT.
    RUN StartDataObject IN gshRepositoryManager (INPUT cDataSource, OUTPUT hDataSource) NO-ERROR.
    IF hDataSource = ? AND NUM-ENTRIES(cDataSource, ".":U) > 1 
                AND ENTRY(2, cDataSource, ".":U) = "w":U THEN /* Try again without the extension */
      RUN StartDataObject IN gshRepositoryManager (INPUT ENTRY(1, cDataSource, ".":U), OUTPUT hDataSource).

    /* It may be static and not registered */
    IF hDataSource = ? THEN 
    DO:
      IF SEARCH(cDataSource) = ? THEN 
      DO:
        cDataSource = ryc_smartobject.object_path + (IF ryc_smartobject.object_path = "" THEN "" ELSE "/") 
                                                  + cDataSource.
        IF SEARCH(cDataSource) = ? THEN
        DO:  /* Give up */
           perror = "    Unable to find " + sdoName + "." + CHR(10) +
                    "    Cannot add fields to Viewer.".
           RETURN.
        END.
      END.  /* If we can't find the file as is */

      /* Only get here if SEARCH is successful */
      RUN VALUE(SEARCH(cDataSource)) PERSISTENT SET hDataSource NO-ERROR.
      IF NOT VALID-HANDLE(hDataSource) THEN 
      DO:
        perror = "    Unable to run " + sdoName + "." + CHR(10) +
                 "    Cannot add fields to Viewer.".
        RETURN.
      END.
      RUN CreateObjects IN hDataSource NO-ERROR.
    END. /* End If sdo handle isn't valid */

    /* Get the logical name of the datasource */
    cDSLogicalName = REPLACE(cDataSource, "~\":U, "~/":U).
    cDSLogicalName = ENTRY(1, ENTRY(NUM-ENTRIES(cDSLogicalName, "~/":U), cDSLogicalName, "~/":U), ".":U).

    /* Data Source is either some kind of SDO (extends class DATA) or SBO (extends class container) */
    lIsSDO = DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager, cDSLogicalName, "Data":U).
    IF lIsSDO = ? THEN DO: /* This object isn't in the repository, ask it what it is */
      cDataSourceType = DYNAMIC-FUNCTION("getObjectType":U IN hDataSource).
      cDataSourceType = IF cDataSourceType = "SmartBusinessObject":U THEN "SBO":U ELSE "SDO":U.
    END. /* When not found in the repository */
    ELSE
      cDataSourceType = IF lIsSDO THEN "SDO":U ELSE "SBO":U.
    
    IF cDataSourceType = "SDO":U THEN
      ASSIGN cDBName     = DYNAMIC-FUNCTION("getDBNames":U IN hDataSource)
             cTableList  = DYNAMIC-FUNCTION("getTables":U IN hDataSource)
             cAssignList = DYNAMIC-FUNCTION("getAssignList":U IN hDataSource) NO-ERROR.
    ELSE DO:  /* SBOs work differently */
      ASSIGN cDBName     = "TEMP-TABLES":U
             cTableList  = "":U.

      /* Scan Datafields in the viewer to create a list of SDOs used by the viewer */
      FOR EACH  b_U WHERE b_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                          b_U._STATUS = "NORMAL":U AND
                          NOT b_U._NAME BEGINS "_LBL-":U AND
                          b_U._DBNAME = "TEMP-TABLES":U:
        IF LOOKUP(b_U._TABLE, cSDOList) = 0 THEN
          cSDOList = cSDOList + ",":U + b_U._TABLE.
      END.  /* For each datafield in the viewer */

      ASSIGN cSDOList    = LEFT-TRIM(cSDOList, ",":U)
             cAssignList = cSDOList.
    END.  /* Else an SBO */
  END.  /* If there is an data source associated with this object */
  ELSE  DO:  /* This is a V8 SmartViewer, find the DB that it is associated with */
    DB-Search:
    FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                       b_U._STATUS = "NORMAL":U AND
                       NOT b_U._NAME BEGINS "_LBL-":U AND
                       b_U._TYPE NE "WINDOW":U AND
                       b_U._TYPE NE "FRAME":U:
       /* Assume that the 1st DBNAME we find is the correct one */
       IF b_U._DBNAME NE "":U AND b_U._DBNAME NE ? THEN DO:
         cDBName = b_U._DBNAME.
         LEAVE DB-SEARCH.
       END. /* IF we have found a DB name */
    END.  /* FOR EACH b_U child object */
  END. /* Else there is no SDO, find DBNAME from a child widget */

  /* Delete instances when cLayout = Master Layout, as this code remove then from all layouts
     simultaneously */
  IF cLayout = "Master Layout":U THEN DO:
    IF VALID-HANDLE(hDataSource) THEN  /* Could be converting a V8 SDV */
       cCalculatedColumns = DYNAMIC-FUNCTION("getCalculatedColumns":U in hDataSource).

    /* Loop through the Child widgets and remove the ones that have been deleted */
    Child-DELETE:
    FOR EACH b_U WHERE b_U._STATUS = "DELETED":U AND
                       NOT b_U._NAME BEGINS "_LBL-":U AND
                       b_U._TYPE NE "WINDOW":U AND
                       b_U._TYPE NE "FRAME":U:
      ASSIGN cObjectName = "":U.
      /* Try to calculate the instance name of a datafield */
      IF VALID-HANDLE(hDataSource) THEN DO: 
        cColumnTable = DYNAMIC-FUNCTION("columnTable":U IN hDataSource, b_U._NAME).
        IF NUM-ENTRIES(cColumnTable, ".":U) = 2 THEN
          cColumnTable = ENTRY(2, cColumnTable, ".":U).
        lCalculatedField = LOOKUP(b_U._NAME, cCalculatedColumns) > 0.
      END. /* If there is a valid data source */

      ASSIGN cObjectName = IF b_U._TABLE = "RowObject":U OR 
                              b_U._BUFFER = "RowObject":U THEN
                             cColumnTable + ".":U + b_U._NAME
                           ELSE IF b_U._TABLE NE "":U THEN b_U._TABLE + ".":U + b_U._NAME 
                           ELSE b_U._NAME
             cObjectName = IF cObjectName = "":U OR cObjectName = ? OR lCalculatedField
                           THEN  b_U._NAME  /* use the widget name */
                           ELSE cObjectName.

      IF cObjectName NE "":U THEN DO:
        cTmpCodes = IF cResultCodes = "":U THEN "{&DEFAULT-RESULT-CODE}":U ELSE cTmpCodes.
        /* Loop through all ResultCodes */
        DO iCode = 1 TO NUM-ENTRIES(cTmpCodes):
          cCode = ENTRY(iCode, cTmpCodes).
 
          /* Don't delete the underlying field of a data field.  ... even though it is marked */
          RUN removeObjectInstance IN ghRepositoryDesignManager   /* This works for datafields */
                         ( INPUT cContainer,                      /* Container name        */
                           INPUT cCode,                           /* Container result code */
                           INPUT cObjectName,                     /* pcInstanceObjectName  */
                           INPUT "":U,                            /* pcInstanceName        */
                           INPUT cCode)                           /* Instance resultCode   */
                           NO-ERROR.
          IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U OR 
            /* This is necessary to remove objects like SDF on "STATE" where "STATE" is also
               a master object.  There is a record in ryc_smartObject for an 'Entity' State. 
               In other words the instance name "happens" to be the same as an unrelated 
               object name. */
            LOOKUP(b_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                     INPUT "DataField":U)) = 0  THEN
              /* Try using the instance name this works for other widgets */
              RUN removeObjectInstance IN ghRepositoryDesignManager
                             ( INPUT cContainer,                  /* Container name        */
                               INPUT cCode,                       /* Container result code */
                               INPUT "":U,                        /* pcInstanceObjectName  */
                               INPUT cObjectName,                 /* pcInstanceName        */
                               INPUT cCode  )                     /* Instance resultCode   */
                               NO-ERROR.
        END.  /* Looping through the Result Codes */
      END.  /* If the ObjectName isn't blank */
    END.  /* Child-Delete */
  END.  /* If master layout */

  /* Loop though every widget and add as instance to Object */
  Child-Search:
  FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                     b_U._STATUS = "NORMAL":U AND
                     NOT b_U._NAME BEGINS "_LBL-":U AND
                     b_U._TYPE NE "WINDOW":U AND
                     b_U._TYPE NE "FRAME":U:

    FIND _F WHERE RECID(_F) = b_U._x-recid NO-ERROR.
    FIND _L WHERE _L._LO-NAME = cLayout AND _L._u-recid = RECID(b_U) NO-ERROR.
    IF NOT AVAILABLE _L AND cLayout NE "MASTER LAYOUT":U THEN DO:
      /* This _U is missing its _L, create one and populate it like the Master */
      CREATE _L.
      ASSIGN _L._LO-NAME = cLayout
             _L._u-recid = RECID(b_U).
      FIND m_L WHERE m_L._LO-NAME = "MASTER LAYOUT":U AND 
                     m_L._u-recid = RECID(b_U) NO-ERROR.
      IF AVAILABLE m_L THEN
        BUFFER-COPY m_L EXCEPT _LO-NAME _u-recid TO _L.
    END.

    IF (NOT AVAILABLE _F AND b_U._TYPE NE "SmartObject":U)
       OR NOT AVAILABLE _L THEN NEXT Child-Search.

    /* Before doing any more work, if this saving a customization and it doesn't differ from the
       master layout, then skip it because we don't insert it.                               */
    IF cLayout NE "Master Layout":U THEN
      cAttrDiffs = CheckCustomChanges(RECID(_L), /* Layout to check                   */
                                      FALSE).    /* Don't do these customizations now */

    ASSIGN cColumnTable = "":U
           cObjectName  = "":U.
    IF VALID-HANDLE(hDataSource) THEN DO:
      IF cDataSourceType = "SDO":U THEN DO:
        cColumnTable = DYNAMIC-FUNCTION("columnTable":U IN hDataSource, b_U._NAME).
        IF NUM-ENTRIES(cColumnTable, ".":U) = 2 THEN
          cColumnTable = ENTRY(2, cColumnTable, ".":U).
        iTableNum = LOOKUP(cColumnTable, cTableList).
      END. /* If it is an SDO of some kind */
      ELSE DO: /* It must be an SBO */
        ASSIGN cColumnTable = b_U._TABLE  /* A lie, this is not a table but an SDO! */
               iTableNum    = LOOKUP(cColumnTable, cSDOList).
      END. /* Else an SBO */
    END.  /* If we have a valid datasource handle */

    /* Determine object Name and see if it is a datafield */
    IF (b_U._TABLE = "RowObject":U OR b_U._BUFFER = "RowObject":U) AND 
        iTableNum > 0 AND VALID-HANDLE(hDataSource) THEN DO:
      /* Determine the name of the datafield and see if it is in the AssignList */
      ASSIGN cTableAssigns = ENTRY(iTableNum, cAssignList, CHR(1))
             iPos          = LOOKUP(b_U._NAME, cTableAssigns).
      IF iPos > 0 AND NUM-ENTRIES(cTableAssigns) > iPos THEN
        ASSIGN cObjectName = cColumnTable + ".":U + ENTRY(iPos + 1, cTableAssigns).
      ELSE
        ASSIGN cObjectName = cColumnTable + ".":U + b_U._NAME.
    END.  /* If a datafield */
    ELSE IF (NOT VALID-HANDLE(hDataSource) OR cDataSourceType = "SBO":U) 
           AND b_U._TABLE NE "":U AND b_U._TABLE <> ? THEN  
      /* Construct a datafield name from a V8 SV field or an SBO field */
      ASSIGN cObjectName = b_U._TABLE + ".":U + b_U._NAME.
    ELSE 
      ASSIGN cObjectName =  b_U._NAME.  /* Not a data field */

    IF VALID-HANDLE(hDataSource) THEN
      lCalculatedField = LOOKUP(cObjectName, cCalculatedColumns) > 0.

    /* The class name is based on the palette repository and is assigned  when the object 
       was dropped onto the design window. (adeuib/)drawobj.p)  If somehow it's blank, use 
       the default based on the type.     */
    ASSIGN cObjectTypeCode = b_U._CLASS-NAME.
    IF cObjectTypeCode = "" THEN 
      ASSIGN
      cObjectTypeCode =  IF b_U._TYPE = "FILL-IN":U             THEN "DynFillin":U
                         ELSE IF b_U._TYPE = "BUTTON":U         THEN "DynButton":U
                         ELSE IF b_U._TYPE = "RECTANGLE":U      THEN "DynRectangle":U
                         ELSE IF b_U._TYPE = "EDITOR":U         THEN "DynEditor":U
                         ELSE IF b_U._TYPE = "IMAGE":U          THEN "DynImage":U
                         ELSE IF b_U._TYPE = "TEXT":U           THEN "DynText":U
                         ELSE IF b_U._TYPE = "TOGGLE-BOX":U     THEN "DynToggle":U
                         ELSE IF b_U._TYPE = "SELECTION-LIST":U THEN "DynSelection":U
                         ELSE IF b_U._TYPE = "COMBO-BOX":U      THEN "DynComboBox":U
                         ELSE IF b_U._TYPE = "RADIO-SET":U      THEN "DynRadioSet":U
                         ELSE "":U.

    ASSIGN dDynObject_obj   = b_U._Object-OBJ.

    /* For SmartDataObjects */
    IF  b_U._TYPE = "SmartObject":U THEN 
    DO:
      FIND _S WHERE RECID(_S) = b_U._x-recid.
      IF b_U._SUBTYPE = "SmartDataField":U THEN DO:
        RUN setSmartDataFieldValues(INPUT RECID(b_U), 
                                    INPUT dSmartViewer, 
                                    INPUT "Master Layout":U,
                                    OUTPUT pError).
        IF pError NE "":U THEN RETURN.
      END.
      ELSE NEXT Child-Search.
    END.
    ELSE IF cObjectTypeCode > "" THEN
    DO:
      /* Before inserting the object instance run cacheObjectOnClient to make sure
         that the master is in the cache */
     cMasterObjectName = IF NUM-ENTRIES(cObjectName,".":U) = 2 OR lCalculatedField
                         THEN cObjectName 
                         ELSE (IF b_U._OBJECT-NAME > ""  /* Use the object name as defined in the palette */
                              THEN b_U._OBJECT-NAME  
                              ELSE cObjectTypeCode).
      /* If a datafield from an SBO, make the cMasterObjectName be the datafield name */
      IF NUM-ENTRIES(cMasterObjectName,".":U) = 2 AND cDataSourceType = "SBO":U AND 
        NOT lCalculatedField THEN DO:
        FIND FIRST sdoHandle WHERE sdoHandle.SDOName = b_U._TABLE NO-ERROR.
        IF AVAILABLE sdoHandle THEN
          hsboSDO = sdoHandle.SDOHandle.
        ELSE DO: /* Run the SDO and get the table name */
          hsboSDO = DYNAMIC-FUNCTION("dataObjectHandle":U IN hDataSource, b_U._TABLE).
          IF NOT VALID-HANDLE(hsboSDO) THEN
            RUN StartDataObject IN gshRepositoryManager 
                (INPUT b_U._TABLE, OUTPUT hsboSDO) NO-ERROR.
          IF NOT VALID-HANDLE(hsboSDO) AND SEARCH(b_U._TABLE) NE ? THEN
            RUN VALUE(SEARCH(b_U._TABLE)) PERSISTENT SET hsboSDO NO-ERROR.
          IF VALID-HANDLE(hsboSDO) THEN DO:
            CREATE sdoHandle.
            ASSIGN sdoHandle.SDOName = b_U._TABLE
                   sdoHandle.SDOHandle = hsboSDO.
          END.  /* If we successfully started */
        END.  /* Can't find so start it */

        IF VALID-HANDLE(hsboSDO) THEN
          cMasterObjectName = DYNAMIC-FUNCTION("columnDBColumn":U IN hsboSDO, b_U._NAME).
        ELSE perror = perror + CHR(10) +
                      "    Unable to start SBO contained SDO " + b_U._NAME + ".":U.
      END.  /* If working on a datafield from an SBO */

      /* Check whether the objectName is an extent field. Since brackets are not used in the object name
         for the instances, remove the brackets. */
      ASSIGN cMasterObjectName = REPLACE(cMasterObjectName,"[","")
             cMasterObjectName = REPLACE(cMasterObjectName,"]","").

      IF lCalculatedField AND NUM-ENTRIES(cMasterObjectName, ".":U) = 2 THEN
        cMasterObjectName = ENTRY(2, cMasterObjectName, ".":U).
      
      IF NOT DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                  INPUT cMasterObjectName,
                                  INPUT ?,
                                  INPUT ?,
                                  INPUT NO) THEN
      DO:
        IF NOT lCalculatedField THEN
        DO:
          /* Trying to insert a DataField instance, but there is no master ... Tell user
             he must generate one */
          ASSIGN pError = pError + (IF perror = "" THEN "" ELSE CHR(10) )
                           + "Field '" + cObjectname  + "' was not created. ".
          NEXT Child-Search.
        END.
        ELSE DO: 
          RUN generateCalculatedField IN ghRepositoryDesignManager
            (INPUT cMasterObjectName,   /* calcFieldName   */
             INPUT _F._DATA-TYPE,       /* Data Type       */
             INPUT _F._FORMAT,          /* Format          */
             INPUT b_U._LABEL,          /* Label           */
             INPUT b_U._HELP,           /* Help            */
             INPUT cOBJProductModule,   /* Product Module  */
             INPUT "":U,                /* Result Code     */
             INPUT "CalculatedField":U).
          DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                               INPUT cMasterObjectName,
                               INPUT ?,
                               INPUT ?,
                               INPUT NO).
        END.  /* else calculated field */
      END.  /* no master object */

      IF NUM-ENTRIES(cObjectName,".") = 2 AND cDataSourceType NE "SBO":U AND 
        NOT lCalculatedField THEN
        ASSIGN cInstanceName = ENTRY(2, cObjectName, ".":U) /* Datafield instance names are just the field */
               cDescription  = "DataField of type ":U + b_U._TYPE.
      ELSE
        ASSIGN cInstanceName = cObjectName
               cDescription  = "Dynamic ":U + b_U._TYPE.


      IF cLayout NE "Master Layout":U THEN DO:
        /* Need to get the object_obj of the customization if it exists */
        FIND ryc_object_instance WHERE
               ryc_object_instance.container_smartobject_obj = dSmartViewer AND
               ryc_object_instance.instance_name = cInstanceName
             NO-LOCK NO-ERROR.
        dDynObject_Obj = IF AVAILABLE ryc_object_instance 
                         THEN ryc_object_instance.object_instance_obj 
                         ELSE 0.
      END.  /* If not the default layout */

      IF cLayout NE "Master Layout":U AND cAttrDiffs = "":U THEN DO:
        RUN removeObjectInstance IN ghRepositoryDesignManager
               ( INPUT cContainer,                  /* Container name        */
                 INPUT cLayout,                     /* Container result code */
                 INPUT "":U,                        /* pcInstanceObjectName  */
                 INPUT cInstanceName,               /* pcInstanceName        */
                 INPUT "":U   )                     /* Instance resultCode   */
              NO-ERROR.
        NEXT Child-SEARCH.
      END.  /* If customization is like the master */


      /* Create this object in the repository if it doesn't exist */
      IF (cLayout = "Master Layout":U AND b_U._Object-OBJ = 0) OR
         (cLayout NE "Master Layout":U AND dDynObject_Obj = 0) THEN 
      DO:
         
        IF cLayout = "Master Layout":U OR cAttrDiffs NE "":U THEN DO:
          RUN insertObjectInstance IN ghRepositoryDesignManager
            ( INPUT dSmartViewer,             /* Container Viewer                  */
              INPUT cMasterObjectName,        /* Object Name                       */
              INPUT IF cLayout = "Master Layout":U
                    THEN "":U ELSE cLayout,   /* Result Code                       */
              INPUT cInstanceName,            /* Instance Name                     */
              INPUT cDescription,             /* Description                       */
              INPUT "":U,                     /* Layout Position                   */
              INPUT YES,                      /* Force creation                    */
              INPUT ?,                        /* Buffer handle for attribute table */
              INPUT TABLE-HANDLE hUnKnown,    /* Table handle for attribute table  */
              OUTPUT dSmartObject_Obj,        /* Master obj                        */
              OUTPUT dDynObject_Obj ) NO-ERROR.        /* Instance Obj                      */
              
          IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
            RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

          IF cLayout = "Master Layout":U THEN 
            ASSIGN b_U._OBJECT-OBJ = dDynObject_obj.
        END. /* if it is the Master or there are differences */
      END. /* End If b_U._Object_obj = 0 it isn't already there */

      IF cLayout = "Master Layout":U OR cAttrDiffs NE "":U THEN DO:
        RUN setObjectInstanceAttributes (INPUT RECID(b_U),        /* _U with current attributes */
                                         INPUT cMasterObjectName, /* Object Type                    */
                                         INPUT dDynObject_Obj,
                                         INPUT cLayout).
        /* In case the name has changed, write it to the repository now */
        IF NUM-ENTRIES(cInstanceName,".":U) < 2 THEN
          RUN renameObjectInstance IN ghRepositoryDesignManager 
              (dDynObject_obj, b_U._NAME).
      END.


      RUN setObjectEvents (INPUT RECID(b_U),   /* _U with current attributes */
                           INPUT dDynObject_Obj,
                           INPUT "INSTANCE":U,
                           INPUT cLayout).
    END.  /* End If cObjecTypeCode > "" When a simple field level object */

    /* Before setting the attributes of a datafield, check them against the 
       master attributes of the datafield.  Remove those which are the same */
    IF (b_U._BUFFER = 'RowObject':U AND cColumnTable NE "":U) OR 
        NUM-ENTRIES(cObjectName,".":U) = 2 THEN
      RUN checkDataFieldMaster(cObjectName, dDynObject_Obj).

    /* Update the Attributes for this object */
    IF CAN-FIND(FIRST DeleteAttribute) THEN 
    DO:
      hTmp = TEMP-TABLE DeleteAttribute:DEFAULT-BUFFER-HANDLE.
      RUN RemoveAttributeValues IN ghRepositoryDesignManager
         (INPUT hTmp,
          INPUT TABLE-HANDLE hUnknown).

      EMPTY TEMP-TABLE DeleteAttribute.
    END.  /* If there are any records */

    IF CAN-FIND(FIRST ttStoreAttribute) THEN
    DO:
      hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
      RUN StoreAttributeValues IN gshRepositoryManager
          (INPUT hTmp ,
           INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */
      /* Empty the temp-table */
      EMPTY TEMP-TABLE ttStoreAttribute.
    END.
   
  END.  /* Child-Search FOR EACH loop */
  IF perror > "" THEN
     perror = perror + CHR(10) 
                + "You need to first generate datafields by running the 'Object Generator' or the 'Entity Import'.".

  IF cLayout = "Master Layout":U THEN DO:
    /* Update the Events for this object */
    IF CAN-FIND(FIRST ttStoreUIEvent) THEN
    DO:
      hTmp = TEMP-TABLE ttStoreUIEvent:DEFAULT-BUFFER-HANDLE.
      RUN insertUIEvents IN ghRepositoryDesignManager
          (INPUT hTmp ,
           INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */
      /* Empty the temp-table */
      EMPTY TEMP-TABLE ttStoreUIEvent.
    END.

    /*Update the events that were deleted */
    IF CAN-FIND(FIRST DeleteUIEvent) THEN
    DO:
      hTmp = TEMP-TABLE DeleteUIEvent:DEFAULT-BUFFER-HANDLE.
      RUN removeUIEvents IN ghRepositoryDesignManager
          (INPUT hTmp ,
           INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */
      /* Empty the temp-table */
      EMPTY TEMP-TABLE DeleteUIEvent.
    END.

    /* Iterate through custom layouts calling this procedure */
    IF NUM-ENTRIES(cResultCodes) > 1 THEN DO:
      DO iCode = 2 TO NUM-ENTRIES(cResultCodes):  /* First one is the Master */
        cCode = ENTRY(iCode, cResultCodes).
        RUN writeFieldLevelObjects (INPUT  pPrecid,
                                    INPUT  cCode,
                                    OUTPUT pError).
      END.
    END.  /* If there are customizations */

    /* Now shutdown the SDOs */
    IF VALID-HANDLE(hDataSource) THEN RUN destroyobject IN hDataSource NO-ERROR.
    IF VALID-HANDLE(hDataSource) THEN DELETE OBJECT hDataSource.

    FOR EACH sdoHandle:
      IF VALID-HANDLE(sdoHandle.SDOHandle) THEN DO:
        RUN destroyObject IN sdoHandle.sdoHandle NO-ERROR.
        IF VALID-HANDLE(sdoHandle.sdoHandle) THEN DELETE OBJECT sdoHandle.sdoHandle.
      END.  /* If sdo is running */
      DELETE sdoHandle.
    END.  /* For each shoHandle Record */
  END.  /* Only do this stuff if saving the Master */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeObject Procedure 
PROCEDURE writeObject :
/*------------------------------------------------------------------------------
  Purpose:    To write a high level object to the repository 
  Parameters:
     INPUT  pPrecid - recid of _P to be written
     OUTPUT pError  - Error message if object can't be written
          
  Notes:  In the first pass _P must represent a SDV or a SDB.  More types can
          be added in the future.
          
          When an object is written, we first look to see if it already exists,
          if so, the the existing record(s) are used.  Otherwise new records
          are created.     
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pPrecid AS RECID                    NO-UNDO.
    DEFINE OUTPUT PARAMETER pError  AS CHARACTER                NO-UNDO.

    DEFINE BUFFER b_U             FOR _U.
    /* b_U is an extra buffer for field level objects */

    DEFINE VARIABLE cColumnTable         AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cObjectTypeCode      AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cTemp                AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE dDynamicObject       AS DECIMAL                 NO-UNDO.
    DEFINE VARIABLE hTmp                 AS HANDLE                  NO-UNDO.
    DEFINE VARIABLE rRowid               AS ROWID                   NO-UNDO.
    DEFINE VARIABLE sdoFileName          AS CHARACTER               NO-UNDO.

    /* Get the _P record to write */
    FIND _P WHERE RECID(_P) = pPrecid.
    FIND _U WHERE RECID(_U) = _P._u-recid.

    /* First set migration flag and fetch migration profile preferences */
    IF CAN-DO(_P.design_action, "MIGRATE":U) THEN DO:
      ASSIGN lMigration = YES
             rRowid     = ?.
      RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                               INPUT "Preference":U,      /* Profile code          */
                                               INPUT "GenerateObjects":U, /* Profile data key      */
                                               INPUT "NO":U,              /* Get next record flag  */
                                               INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                               OUTPUT gcProfileData).     /* Found profile data.   */

    END. /* If Migrating */

    /* Create a list of Result Codes for this object */
    FOR EACH _L WHERE _L._u-recid = RECID(_U):
      IF _L._LO-NAME NE "Master Layout":U THEN
        cResultCodes = cResultCodes + ",":U + _L._LO-NAME.
    END.  /* For each _L */  
    /* Note, we don't trim the left comma, because the Master Layout uses a blank RC */

    EMPTY TEMP-TABLE tResultCodes.

    /* Write the object (Viewer, Browser or SDO) */
    RUN writeObjectToRepository (INPUT pPrecid, 
                                 OUTPUT dDynamicObject, 
                                 OUTPUT pError) NO-ERROR.
                                 
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
      RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

    IF dDynamicObject > 0 THEN  /* The object was created in the repository, 
                                   store the Object_obj in the _P record */
      ASSIGN _P.Smartobject_obj = dDynamicObject.

    /* Don't go on unless the only error is that the SDO couldn't be registered */
    IF pError NE "" AND 
       NOT pError BEGINS "Associated SDO" THEN RETURN.

    /* Now write out the field level widgets */
    IF cClassName = "DynView":U THEN DO:
      RUN writeFieldLevelObjects (INPUT pPrecid,
                                  INPUT "Master Layout":U,
                                  OUTPUT pError) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
        RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).
    END.
      
    /* Mark that this file has been saved */
    _P._FILE-SAVED = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-WriteObjectToRepository) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WriteObjectToRepository Procedure 
PROCEDURE WriteObjectToRepository :
/*------------------------------------------------------------------------------
  Purpose:    To object to the repository 
  Parameters:
     INPUT  pPrecid      - recid of _P to be written
     OUTPUT dMDynamicObj - object id of the viewer for the Master Layout
            pError       - Error message if object can't be written
          
  Notes:  _P must represent a SDV, SDB or SDO.
          
          When an object is written, we first look to see if it already exists,
          if so, the the existing record(s) are used.  Otherwise new records
          are created.     
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pPrecid       AS RECID                   NO-UNDO.
    DEFINE OUTPUT PARAMETER dMDynamicObj  AS DECIMAL                 NO-UNDO.
    DEFINE OUTPUT PARAMETER pError        AS CHARACTER               NO-UNDO.

    DEFINE BUFFER b_U             FOR _U.
    /* b_U is an extra buffer for field level objects */
    DEFINE BUFFER b_C             FOR _C.
    /* b_C is an extra buffer for frames              */
    DEFINE BUFFER b_L             FOR _L.
    /* b_L is an extra buffer for _L records          */
    DEFINE BUFFER sync_L          FOR _L.
    /* sync_L is a buffer to hold _L's that have labels in sync with the master layout */
    DEFINE BUFFER dlp_P   FOR _P.
    /* dlp_P is an extra buffer for a DataLogic Procedure when converting SDOs */
    DEFINE BUFFER dlp_TRG FOR _TRG.
    /* dlp_TRG is for copying _TRG records from SDOs to DLPs */
    DEFINE BUFFER w_U     FOR _U.
    /* Needed for when we have 2 windows open simultaneously (SDOs and DLPs)  */

    DEFINE VARIABLE cAnswer               AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cButton               AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cSavedPath            AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cOBJFullName          AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cOBJRootDir           AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cOBJRelativeDir       AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cOBJFileName          AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cDataObjectType       AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cDLPProductModule     AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cDLPFullName          AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cDLPRootDir           AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cDLPRelativeDir       AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cDLPFileName          AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cFirstEnabledTable    AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cCode                 AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cColumnTable          AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cDBName               AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cIncludeFileName      AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cSDORepos             AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cSDOFileName          AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cObjectDescription    AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cTableName            AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cTablesInSDO          AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cTemp                 AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cTmpName              AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cValue                AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE dDynamicObj           AS DECIMAL                 NO-UNDO.
    DEFINE VARIABLE dObject_Obj           AS DECIMAL                 NO-UNDO.
    DEFINE VARIABLE FoundIt               AS LOGICAL                 NO-UNDO.
    DEFINE VARIABLE hDo                   AS HANDLE                  NO-UNDO.
    DEFINE VARIABLE hStoreAttribute       AS HANDLE                  NO-UNDO.
    DEFINE VARIABLE i                     AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE iCode                 AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE iNumEntries           AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE pcInstanceColumns     AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE dInstance             AS DECIMAL                 NO-UNDO.
    DEFINE VARIABLE sdoFileName           AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE dSDO_obj              AS DECIMAL                 NO-UNDO.
    DEFINE VARIABLE cName                 AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE WindowRecid           AS RECID                   NO-UNDO.
    DEFINE VARIABLE cValidValidates       AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE lSuppressValidation   AS LOGICAL                 NO-UNDO.
    DEFINE VARIABLE lnewObject            AS LOGICAL                 NO-UNDO.

    DEFINE VARIABLE cSCMWorkspace         AS CHARACTER               NO-UNDO.
    
    /* Get the various SCM related values that may be needed */
    ghSCMTool      = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, "PRIVATE-DATA:SCMTool":U).
    cSCMWorkspace = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, "_scm_current_workspace":U).

    ASSIGN cValidValidates = 
          "PreTransaction,BeginTransaction,EndTransaction,PostTransaction,RowObject,":U +
          "CreatePreTrans,CreateBeginTrans,CreateEndTrans,CreatePostTrans,":U +
          "WritePreTrans,WriteBeginTrans,WriteEndTrans,WritePostTrans,":U +
          "DeletePreTrans,DeleteBeginTrans,DeleteEndTrans,DeletePostTrans":U.

    /* Get the _P record to write */
    FIND _P WHERE RECID(_P) = pPrecid.
    FIND _U WHERE RECID(_U) = _P._u-recid.  /* Window */

    /* The cClassName is the base class name, cObjClassType from the user profile for their
       preferred subClass of cClassName                                                    */
    ASSIGN cClassName = DYNAMIC-FUNCTION("RepositoryDynamicClass" IN _h_func_lib, INPUT _P._TYPE)
           cObjClassType = cClassName.

    IF lMigration THEN DO: /* Establish User preferences */
      /* cObjClassType is the preferred subClass to create */
      cLookupVal = IF cClassName = "DynBrow":U THEN "SDB_Type":U ELSE
                   IF cClassName = "DynView":U THEN "SDV_Type":U ELSE
                   IF cClassName = "DynSDO":U  THEN "SDO_Type":U ELSE
                   "SBO_Type":U.
      cTemp = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                               cLookupVal,
                               gcProfileData,
                               TRUE,
                               CHR(3)).
      /* Make sure it is defined */
      IF cTemp NE "":U AND cTemp NE ? THEN cObjClassType = cTemp.
      cTemp = "":U.
      
      /* cSupPreference is Super Proc preferences */
      cLookupVal = IF cClassName = "DynBrow":U THEN "SDB_SupOpt":U ELSE
             IF cClassName = "DynView":U THEN "SDV_SupOpt":U ELSE
             IF cClassName = "DynSDO":U  THEN "SDO_DlpOpt":U ELSE
             "SBO_DlpOpt":U.
      cSuperPref = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                    cLookupVal,
                                    gcProfileData,
                                    TRUE,
                                    CHR(3)).
      IF cSuperPref = "":U OR cSuperPref = ? THEN
        cSuperPref = IF LOOKUP(cClassName,"DynBrow,DynView":U) > 0 THEN "None":U ELSE
                     "ValOnly":U.
    END.  /* If migration ... get their preferred subClass to create */

    
    /* Use what we have in the _P */
    ASSIGN cOBJFullName       = _P.object_filename
           cOBJProductModule  = _P.product_module_code
           cObjClassType      = IF NOT lMigration AND _P.Object_type_code > "" 
                                THEN _P.Object_type_code
                                ELSE cObjClassType.
             
             
          
   cContainer = cOBJFullName.

    IF _P.object_filename = "":U THEN
       _P.object_filename = cOBJFullName.

    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_code = cOBJProductModule
      NO-ERROR.
    IF AVAILABLE gsc_product_module THEN
      /* Check if the SCM API is available - as this is an indication of the SCM tool being available. */
      IF VALID-HANDLE(ghSCMTool) THEN DO:
        /* Get the SCM relative module paths - as these may be different from the 
           relative paths in the Dynamics repository. OIF we are using an SCM tool, then 
           the relative path for the corresponding product module selected takes 
           precedence over the relative path from the Dynamics repository.
        */
        RUN scmGetModuleDir IN ghSCMTool (INPUT gsc_product_module.product_module_code, OUTPUT cOBJRelativeDir).          
        ASSIGN 
          cOBJRelativeDir = REPLACE(cOBJRelativeDir,"~\":U,"~/":U)          
          .
      END.
      ELSE
        ASSIGN cOBJRelativeDir = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"~/":U),"~/":U).
    ELSE ASSIGN cOBJRelativeDir = TRIM(REPLACE(_P.object_path                  ,"~\":U,"~/":U),"~/":U).

    ASSIGN cOBJFullName = REPLACE(cOBJFullName,"~\":U,"~/":U).
    
    RUN adecomm/_osprefx.p (INPUT cOBJFullName, OUTPUT cOBJRootDir, OUTPUT cOBJFileName).

    /* IF SCM variables are set, we need to use these instead of the defaults. 
       The root directory for the workspace is important to use here, 
       as this is critical to puttnig the files in the correct place. */
    IF VALID-HANDLE(ghSCMTool) THEN DO:
      IF cSCMWorkspace <> "":U THEN
        ASSIGN 
          cOBJRootDir = DYNAMIC-FUNCTION('getSessionRootDirectory':U IN THIS-PROCEDURE)
          . 
    END.    
    ELSE DO:
       RUN adecomm/_osprefx.p (INPUT _P._SAVE-AS-FILE, OUTPUT cOBJRootDir, OUTPUT cOBJFileName).
    END.

    ASSIGN cOBJRootDir  = TRIM(cOBJRootDir,"~/":U).

    IF cObjRelativeDir NE "":U AND cOBJRootDir MATCHES "*":U + cObjRelativeDir THEN
      /* If cOBJRootDir ends with cOBJRelativeDir, then remove it */
      cOBJRootDir = SUBSTRING(cOBJRootDir, 1, LENGTH(cOBJRootDir,"CHARACTER") -
                                              LENGTH("/":U + cObjRelativeDir,"CHARACTER"),
                                              "CHARACTER").

    /* Before doing anything, make sure the associated SDO is registered in the repository */
    /* get the SDO name without the extension and path name.  This works with a V9 SDV. */
    IF _P._data-object NE "":U THEN DO:  /* There is an SDO associated with this object */

      RUN adecomm/_osprefx.p (INPUT _P._data-object, OUTPUT cSavedPath, OUTPUT cSDOFileName).
      ASSIGN sdoName = ENTRY(1, cSDOFileName, ".":U).

      ASSIGN cSDORepos = "":U.
      /* Look to see if the SDO is already registered */
      IF cSDORepos = "":U THEN
      FIND ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.object_filename = sdoName
        NO-ERROR.
      IF AVAILABLE ryc_smartobject
      THEN ASSIGN cSDORepos = ryc_smartobject.object_filename.

      IF cSDORepos = "":U
      THEN
      FIND ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.object_filename = cSDOFileName
        NO-ERROR.
      IF AVAILABLE ryc_smartobject
      THEN ASSIGN cSDORepos = ryc_smartobject.object_filename.

      IF cSDORepos = "":U THEN DO:
        /* This SDO is not registered.  Need to do it */

        /* Is this an SDO or an SBO?  Since it isn't registered, we have to run it to find out */
        RUN value(SEARCH(_P._data-object)) PERSISTENT SET hdo.
        cDataObjectType = "":U.
        IF VALID-HANDLE(hdo) THEN DO:
          cDataObjectType = DYNAMIC-FUNCTION("getObjectType":U IN hdo).
          RUN destroyObject IN hdo NO-ERROR.
          IF VALID-HANDLE(hdo) THEN DELETE OBJECT hdo.
        END.
        RUN af/sup2/afsdocrdbp.p
          (INPUT _P._data-object, 
           INPUT cDataObjectType, 
           INPUT cOBJProductModule, /* This should be the SDO product module and not the Object Product Module */
           INPUT "From data.w - Template for SmartDataObjects in the ADM":U, 
           INPUT _P.deployment_type,
           INPUT _P.design_only,
           INPUT NO /* prompt for PM */, 
           OUTPUT pError) NO-ERROR.
           
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
          RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

        IF (pError <> "") THEN
        DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
            pError = "Associated DO " + _P._data-object + " not registered in" + CHR(10) + 
                     "the repository because " + pError.
        END.  /* If an error regisitering the SDO */
        ELSE DO:
           ASSIGN cSDORepos = REPLACE(_P._data-object, "~\":U, "~/":U)
                  cSDORepos = ENTRY(NUM-ENTRIES(cSDORepos, "~/":U), cSDORepos, "~/":U).
           FIND ryc_smartobject NO-LOCK
              WHERE ryc_smartobject.OBJECT_filename = cSDORepos NO-ERROR.
           IF NOT AVAILABLE ryc_smartobject AND NUM-ENTRIES(cSDORepos, ".":U) = 2 THEN
             FIND ryc_smartobject NO-LOCK
                WHERE ryc_smartobject.OBJECT_filename = ENTRY(1,cSDORepos,".":U)
                  AND ryc_smartobject.object_extension = entry(2,cSDORepos,".":U)  NO-ERROR.
        END.  /* If no error */
      END.  /* If need to register the SDO */
    END. /* If an SDO is associated with this object */
    IF AVAILABLE ryc_smartobject /* And there should be here if not an SDO or SBO */
      THEN ASSIGN dSDO_obj  = ryc_smartobject.smartobject_obj
                  cSDORepos = ryc_smartobject.object_filename.

    /* Calculate the Min-Height and Width of Master Object in master layout */
    RUN DetermineSize(INPUT RECID(_U), 
                     INPUT "Master Layout":U,
                     OUTPUT MinHeight,
                     OUTPUT MinWidth).

    ASSIGN cTemp              = REPLACE(_P._SAVE-AS-FILE,"~\":U,"/":U)
           cObjectDescription = IF _P.object_description = ""
                                THEN ( "Dynamic " +
                                      (IF _P._TYPE MATCHES "*View*":U THEN "Viewer":U
                                      ELSE IF _P._TYPE MATCHES "*BROW*":U THEN "Browser":U
                                      ELSE "DataObject":U) +
                                       " from ":U + 
                                       ENTRY(NUM-ENTRIES(cTemp,"/":U), cTemp, "/":U))
                                ELSE _P.object_description.
    IF _P._DESC = "":U THEN _P._DESC = cObjectDescription.

    /* There is no reason to have 2 versions of setObjectAttributes (setObjectMasterAttributes
       for viewers and browsers and setDataObjectAttributes for SDOs), except that the case 
       statement is too big for the section editor to handle.  These can 
       be combined to one procedure when the section editor can handle more than 32k */
    IF lookup(cClassName,"DynView,DynBrow":U) > 0 THEN DO:
      /* Before doing anything copy the labels of the _U to the current layout _L */
      FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _h_win:
        FIND b_L WHERE b_L._LO-NAME = _U._LAYOUT-NAME AND b_L._u-recid = RECID(b_U) NO-ERROR.
        IF AVAILABLE b_L THEN DO:
          /* If the curent layout is the master change the _L of all labels that are 
             in sync with the master */
          IF b_L._LO-NAME = "Master Layout":U THEN DO:
            FOR EACH sync_L WHERE sync_L._u-recid = b_L._u-recid AND
                                  sync_L._LABEL   = b_L._LABEL:
              sync_L._LABEL = b_U._LABEL.  /* b_U._LABEL has the latest version */
            END.  /* Updated all labels in sync with the master */
          END.  /* If we're morphing away from the master layout */
          b_L._LABEL = b_U._LABEL.  /* Update _L of what we are morphing away from */
        END.  /* If this object has an _L */
      END.  /* Copy labels for layout morphing away from */

      RUN setObjectMasterAttributes (INPUT IF cClassName = "DynView":U THEN FrameRecid 
                                                                       ELSE BrowseRecid,
                                     _U._OBJECT-OBJ,
                                     "Master Layout":U) NO-ERROR.

      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
        RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).
    END.  /* A dynamic viewer or browser */

    ELSE IF cClassName = "DynSDO":U THEN DO: /* DynSDO case here */
      /* If this is a new master, set SmartObject_obj to unknown */
      ASSIGN dSmartObject_obj = IF _U._OBJECT-obj = 0 THEN ? ELSE _U._OBJECT-OBJ.

      /* Before writing anything, check that all datafields are present */
      DataFieldSearch:
      FOR EACH _BC WHERE _BC._x-recid = QueryRecid:
        ASSIGN cName = REPLACE(_BC._NAME,"]","")
               cName = REPLACE(cName,"[","").

        IF _BC._DBNAME NE "_<CALC>":U THEN 
        DO:
          IF NOT CAN-FIND(FIRST ryc_smartobject WHERE 
             ryc_smartobject.OBJECT_filename = _BC._TABLE + ".":U + cName) THEN
          DO:
            pError = "SDO field " + _BC._TABLE + ".":U + _BC._NAME + " has no datafield." + CHR(10) +
                  "You must generate DataFields for all SDO fields." + CHR(10) + CHR(10) +
                  "Aborting the saving of SDO " + cOBJFullName + ".":U.
            RETURN.
          END.  /* if not found */
        END.  /* else not calc field */
        ELSE DO:
          /* If there is an existing master object for this calculated field and it is a newly added field or
             it is a field whose name was changed then ask the user whether to reuse, create an instance or
             cancel the save.  */
          IF CAN-FIND(FIRST ryc_smartobject WHERE ryc_smartobject.object_filename = _BC._DISP-NAME) AND 
             ((_BC._STATUS = "NEW":U) OR 
              (_BC._STATUS BEGINS "UPDATE":U AND ENTRY(2,_BC._STATUS) NE _BC._DISP-NAME) OR
              (lMigration AND _BC._STATUS = "":U)) THEN
          DO:
            pError = "A Calculated Field already exists for field ":U + _BC._DISP-NAME +
                     ".  Calculated Field names must be unique.":U.
            RETURN.
          END.  /* if calc field already exists */
        END.  /* if calc field */
      END. /* FOR EACH _BC */

      FIND _C WHERE RECID(_C)   = _U._x-recid.   /* _C of window */
      IF _C._DATA-LOGIC-PROC-PMOD = ? THEN _C._DATA-LOGIC-PROC-PMOD = cObjProductModule.
      RUN setDataObjectAttributes (INPUT QueryRecid, OUTPUT pcInstanceColumns).
    END. /* Else if an SDO */

    ELSE IF cClassName = "DynSBO":U THEN DO: /* DynSBO case here */
      /* Should this SBO have a DLP attribute */
      IF cSuperPref NE "None":U THEN DO:
        /* We need to create a DLP for this SBO.  Determine the object name of the DLP
           and create a DataLogicProcedure Master attribute for this SBO */
        FIND _C WHERE RECID(_C) = _U._x-recid.  /* _C of window */
        cDLPFileName = ENTRY(NUM-ENTRIES(_C._DATA-LOGIC-PROC, "~/":U), _C._DATA-LOGIC-PROC, "~/":U).
        IF NUM-ENTRIES(cDLPFileName, ".":U) = 2 THEN
          cDLPFileName = ENTRY(1, cDLPFileName, ".":U).
        cAttr = "DataLogicProcedure":U.
        {&Create-Char-Master} cDLPFileName, ?, ?, ?, ?, ?).
      END. /* If we need to generate a DLP */
    END.  /* If we are migrating an SBO */
    
    /* Debugging code: This block writes out to the working directory first the
       attributes to be deleted, then the attributes to be changed.           */
    /*
    OUTPUT TO attrs.tmp.

    PUT UNFORMATTED SKIP (2) "_U._OBJECT-OBJ:" _U._object-obj SKIP(1)
        "DELETES:" SKIP.

    FOR EACH DeleteAttribute:
      PUT UNFORMATTED tAttributeParent + " " + STRING(tAttributeParentObj) + " " +
                      tAttributeLabel + ": " + tCharacterValue + " " + 
                      STRING(tDecimalValue) + " " + STRING(tIntegerValue) SKIP.
    END.

    PUT UNFORMATTED SKIP(2) "CHANGES:" SKIP.

    FOR EACH ttStoreAttribute:
      PUT UNFORMATTED ttStoreAttribute.tAttributeParent + " " + 
                      STRING(ttStoreAttribute.tAttributeParentObj) + " " +
                      ttStoreAttribute.tAttributeLabel + ": " + 
                      ttStoreAttribute.tCharacterValue + " " + 
                      STRING(ttStoreAttribute.tDecimalValue) + " " + 
          STRING(ttStoreAttribute.tIntegerValue) SKIP.
    END.
    OUTPUT CLOSE.
    */ 
    /*END of debugging code */

    IF _U._OBJECT-OBJ = 0 THEN DO:  /* If it doesn't exist */ 
      /* Work around until new API is complete, this establishes the internal structure */
      DEFINE VARIABLE hTmp AS HANDLE     NO-UNDO.
      ASSIGN hTmp       = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
             lNewObject = YES.

      RUN insertObjectMaster IN ghRepositoryDesignManager
        ( INPUT cOBJFileName,            /* Object Name                         */
          INPUT "":U,                    /* Master Layout Result Code           */
          INPUT cOBJProductModule,       /* The Product Module                  */
          INPUT cObjClassType,           /* Object Type Code                    */
          INPUT cObjectDescription,      /* Description                         */
          INPUT "":U,                    /* Path                                */
          INPUT cSDORepos,               /* Associated SDO                      */
          INPUT "":U,                    /* SuperProcedure Name                 */
          INPUT NO,                      /* Not a template                      */
          INPUT NO,                      /* Treat as a static object            */
          INPUT "":U,                    /* Rendering Engine (Use Default)      */
          INPUT NO,                      /* Doesn't need to be run persistently */
          INPUT _U._TOOLTIP,             /* Tooltip                             */
          INPUT "":U,                    /* Required DB List                    */
          INPUT "":U,                    /* LayoutCode                          */
          INPUT hTmp,                    /* Attr Table Buffer handle            */
          INPUT TABLE-HANDLE hUnknown,   /* Table handle for attribute table    */
          OUTPUT dDynamicObj) NO-ERROR.  /* Obj number for this object          */

      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
        RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

      ASSIGN _U._OBJECT-OBJ = dDynamicObj
             dMDynamicObj   = dDynamicObj.
      CREATE tResultCodes.
      ASSIGN tResultCodes.cRC = "":U
             tResultCodes.dContainerObj = dDynamicObj.
    END.  /* If the object didn't exist */

    ELSE DO:  /* Else works because if it is new, there are no attributes 
                 to delete and the insert did all added attribute records */
      /* If we are setting something back to its default value */
      IF CAN-FIND(FIRST DeleteAttribute) THEN DO:
        hTmp = TEMP-TABLE DeleteAttribute:DEFAULT-BUFFER-HANDLE.
        RUN RemoveAttributeValues IN ghRepositoryDesignManager
           (INPUT hTmp,
            INPUT TABLE-HANDLE hUnknown) NO-ERROR.     

        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
          RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

        EMPTY TEMP-TABLE DeleteAttribute.
      END.  /* If there are any records */

      hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
      RUN StoreAttributeValues IN gshRepositoryManager
          (INPUT hTmp ,
           INPUT TABLE-HANDLE hUnKnown) NO-ERROR.  /* Compiler requires a variable with unknown */

      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
        RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

      dSmartObject = _U._OBJECT-OBJ.
      CREATE tResultCodes.
      ASSIGN tResultCodes.cRc = "":U
             tResultCodes.dContainerObj = _U._OBJECT-OBJ.
    END.
    
    RUN setObjectEvents (INPUT RECID(_U),   /* _U with current attributes */
                         INPUT _U._OBJECT-OBJ,
                         INPUT "MASTER":U,
                         INPUT "").
    /* Update the Events for this object */
    IF CAN-FIND(FIRST ttStoreUIEvent) THEN
    DO:
       hTmp = TEMP-TABLE ttStoreUIEvent:DEFAULT-BUFFER-HANDLE.
       RUN insertUIEvents IN ghRepositoryDesignManager
            (INPUT hTmp ,
             INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */
      /* Empty the temp-table */
      EMPTY TEMP-TABLE ttStoreUIEvent.
    END.
    /*Update the events that were deleted */
    IF CAN-FIND(FIRST DeleteUIEvent) THEN
    DO:
      hTmp = TEMP-TABLE DeleteUIEvent:DEFAULT-BUFFER-HANDLE.
      RUN removeUIEvents IN ghRepositoryDesignManager
           (INPUT hTmp ,
            INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */
      /* Empty the temp-table */
      EMPTY TEMP-TABLE DeleteUIEvent.
    END.                     
                         
    IF LOOKUP(cClassName,"DynView,DynBrow":U) > 0  THEN DO:
      FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj = _U._OBJECT-OBJ NO-ERROR.
      IF AVAILABLE ryc_smartobject THEN 
        ASSIGN ryc_smartobject.sdo_smartobject_obj = dSDO_obj.
    END.


    /* Empty the ttStoreAttribute temp-table */
    EMPTY TEMP-TABLE ttStoreAttribute.

    /* Empty the ttStoreUIEventtemp-table */
    EMPTY TEMP-TABLE ttStoreUIEvent.

    /* Now that the master layout master object has been written, Write  master objects for 
       the other layouts */
    IF NUM-ENTRIES(cResultCodes) > 1 AND LOOKUP(cClassName,"DynView,DynBrow":U) > 0 THEN DO:
      /* We have other layouts to write */
      DO iCode = 2 TO NUM-ENTRIES(cResultCodes):
         cCode = ENTRY(iCode, cResultCodes).

        /* Calculate the Min-Height and Width of Master Object in cCode layout */
        RUN DetermineSize(INPUT RECID(_U), 
                          INPUT cCode,
                          OUTPUT MinHeight,
                          OUTPUT MinWidth).

        /* Need to get the object_obj of the customization if it exists */
        FIND ryc_customization_result WHERE ryc_customization_result.customization_result_code = 
                                            cCode NO-LOCK.
        FIND ryc_smartobject WHERE ryc_smartobject.object_filename = cObjFileName AND
                                   ryc_smartobject.customization_result_obj = 
                                       ryc_customization_result.customization_result_obj
                                   NO-LOCK NO-ERROR.

        dDynamicObj = IF AVAILABLE ryc_smartobject THEN ryc_smartobject.smartobject_obj 
                                                   ELSE 0.

        RUN setObjectMasterAttributes (INPUT IF cClassName = "DynView":U THEN FrameRecid 
                                                                         ELSE BrowseRecid,
                                       dDynamicObj,
                                       cCode).

        IF dDynamicObj = 0 THEN DO:  /* If it doesn't exist */ 
          /* Work around until new API is complete, this establishes the internal structure */
          hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.

          RUN insertObjectMaster IN ghRepositoryDesignManager
              ( INPUT cOBJFileName,            /* Object Name                         */
                INPUT cCode,                   /* Result Code                         */
                INPUT cOBJProductModule,       /* The Product Module                  */
                INPUT cObjClassType,           /* Object Type Code                    */
                INPUT cObjectDescription,      /* Description                         */
                INPUT "":U,                    /* Path                                */
                INPUT cSDORepos,               /* Associated SDO                      */
                INPUT "":U,                    /* SuperProcedure Name                 */
                INPUT NO,                      /* Not a template                      */
                INPUT NO,                      /* Treat as a static object            */
                INPUT "":U,                    /* Rendering Engine (Use Default)      */
                INPUT NO,                      /* Doesn't need to be run persistently */
                INPUT _U._TOOLTIP,             /* Tooltip                             */
                INPUT "":U,                    /* Required DB List                    */
                INPUT "":U,                    /* LayoutCode                          */
                INPUT hTmp,                    /* Attr Table Buffer handle            */
                INPUT TABLE-HANDLE hUnknown,   /* Table handle for attribute table    */
                OUTPUT dDynamicObj) NO-ERROR.  /* Obj number for this object          */

          IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
            RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

          CREATE tResultCodes.
          ASSIGN tResultCodes.cRC = cCode
                 tResultCodes.dContainerObj = dDynamicObj.
        END.  /* If the object didn't exist */

        ELSE DO:  /* Else works because if it is new, there are no attributes 
                     to delete and the insert did all added attribute records */
          /* If we are setting something back to its default value */
          IF CAN-FIND(FIRST DeleteAttribute) THEN DO:
            hTmp = TEMP-TABLE DeleteAttribute:DEFAULT-BUFFER-HANDLE.
            RUN RemoveAttributeValues IN ghRepositoryDesignManager
                (INPUT hTmp,
                 INPUT TABLE-HANDLE hUnknown) NO-ERROR.

           IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
             RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

            EMPTY TEMP-TABLE DeleteAttribute.
          END.  /* If there are any records */

          hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
          RUN StoreAttributeValues IN gshRepositoryManager
              (INPUT hTmp ,
               INPUT TABLE-HANDLE hUnKnown) NO-ERROR.  /* Compiler requires a variable with unknown */

          IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
            RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

          CREATE tResultCodes.
          ASSIGN tResultCodes.cRC = cCode
                 tResultCodes.dContainerObj = dDynamicObj.
        END. /* Else this is something old */

        RUN setObjectEvents (INPUT RECID(_U),   /* _U with current attributes */
                         INPUT dDynamicObj,
                         INPUT "MASTER":U,
                         INPUT cCode).
        /* Update the Events for this object */
        IF CAN-FIND(FIRST ttStoreUIEvent) THEN
        DO:
           hTmp = TEMP-TABLE ttStoreUIEvent:DEFAULT-BUFFER-HANDLE.
           RUN insertUIEvents IN ghRepositoryDesignManager
                (INPUT hTmp ,
                 INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */
          /* Empty the temp-table */
          EMPTY TEMP-TABLE ttStoreUIEvent.
        END.
        /*Update the events that were deleted */
        IF CAN-FIND(FIRST DeleteUIEvent) THEN
        DO:
          hTmp = TEMP-TABLE DeleteUIEvent:DEFAULT-BUFFER-HANDLE.
          RUN removeUIEvents IN ghRepositoryDesignManager
               (INPUT hTmp ,
                INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */
          /* Empty the temp-table */
          EMPTY TEMP-TABLE DeleteUIEvent.
        END.
        IF CAN-FIND(FIRST ttStoreAttribute) THEN
          EMPTY TEMP-TABLE ttStoreAttribute.
        IF CAN-FIND(FIRST DeleteAttribute) THEN
          EMPTY TEMP-TABLE DeleteAttribute. 
      END.  /* Looping through the customizations */
    END.  /* If there are any customizations */

    /* If this is a Dynamic SDO, write out its logic procedure */
    IF cClassName = "DynSDO":U THEN DO:
        
      /* Default DLP is ValOnly */
      IF NOT lMigration THEN cSuperPref = "ValOnly":U.

      FIND b_U WHERE RECID(b_U) = QueryRecid.    /* _U of _query */
      FIND _C WHERE RECID(_C)   = b_U._x-recid.  /* _C of query  */
      FIND _Q WHERE RECID(_Q)   = _C._q-recid.   /* _Q of query  */
      FIND _C WHERE RECID(_C)   = _U._x-recid.   /* _C of window */

      /* Determine Table list */
      DO i = 1 TO NUM-ENTRIES(_Q._TblList):
        cTableName = ENTRY(1, ENTRY(i , _Q._TblList), " ":U).
        IF NUM-ENTRIES(cTableName,".":U) = 2 THEN
            cTableName = ENTRY(2,cTableName,".":U).
        cTablesInSDO = cTablesInSDO + "," + cTableName.
        IF cFirstEnabledTable = "" AND CAN-FIND(FIRST _BC
           WHERE _BC._x-recid = RECID(b_U) AND _BC._TABLE = cTableName AND _BC._ENABLED) THEN
          cFirstEnabledTable = cTableName.
      END.
      cTablesInSDO = LEFT-TRIM(cTablesInSDO, ",":U).

      /* Write out include file */
      /* If RTB is running, then we handle the processing of the include file name and path 
         differently from when RTB is not running.  */
      IF VALID-HANDLE(ghSCMTool) THEN 
      DO:
        FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj = _U._OBJECT-OBJ NO-LOCK NO-ERROR.
        
        IF cOBJRelativeDir NE "":U THEN
          FILE-INFO:FILE-NAME = (IF cOBJRootDir NE "":U
                                 THEN RIGHT-TRIM(cOBJRootDir,"~/":U) + "/":U ELSE "":U) +
                                 cOBJRelativeDir.
                                 
          IF FILE-INFO:FILE-TYPE MATCHES "D*W*":U THEN
            cIncludeFilename = FILE-INFO:FULL-PATHNAME + "/":U + ryc_smartobject.object_filename +
                                 ".i":U.
          ELSE cIncludeFileName = (IF cOBJRootDir NE "":U
                                    THEN RIGHT-TRIM(cOBJRootDir,"~/":U) + "/":U
                                    ELSE "":U) + 
                                    (IF ryc_smartobject.object_path NE "":U
                                     THEN RIGHT-TRIM(ryc_smartobject.object_path,"~/":U) + "/":U
                                     ELSE "":U) + 
                                     ryc_smartobject.object_filename + ".i":U.             
        cIncludeFilename = REPLACE(cIncludeFileName, "~\":U, "~/":U).
      END.
      ELSE DO: /* SCM Tool is not running */
        FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj = _U._OBJECT-OBJ NO-LOCK NO-ERROR.
        FILE-INFO:FILE-NAME = ryc_smartobject.object_path.
        IF FILE-INFO:FILE-TYPE MATCHES "D*W*":U THEN
          cIncludeFileName = ryc_smartobject.object_path + "/":U + ryc_smartobject.object_filename
                                    + ".i":U.
        
        ELSE DO:  /* If this isn't a writeable directory */
          IF cOBJRelativeDir NE "":U THEN
            FILE-INFO:FILE-NAME = (IF cOBJRootDir NE "":U
                                   THEN RIGHT-TRIM(cOBJRootDir,"~/":U) + "/":U ELSE "":U) +
                                   cOBJRelativeDir.
            IF FILE-INFO:FILE-TYPE MATCHES "D*W*":U THEN
              cIncludeFilename = FILE-INFO:FULL-PATHNAME + "/":U + ryc_smartobject.object_filename +
                                   ".i":U.
            ELSE cIncludeFileName = (IF cOBJRootDir NE "":U
                                      THEN RIGHT-TRIM(cOBJRootDir,"~/":U) + "/":U
                                      ELSE "":U) + 
                                      (IF ryc_smartobject.object_path NE "":U
                                       THEN RIGHT-TRIM(ryc_smartobject.object_path,"~/":U) + "/":U
                                       ELSE "":U) + 
                                       ryc_smartobject.object_filename + ".i":U.
        END.      
      END.
   
      OUTPUT STREAM P_4GLSDO TO VALUE(cIncludeFileName).

      FOR EACH _BC WHERE _BC._x-recid = RECID(b_U) BREAK BY _BC._SEQUENCE:
        IF _BC._DBNAME <> "_<CALC>":U THEN
          ASSIGN cTemp = "  FIELD ":U + _BC._DISP-NAME + " LIKE ":U +
                   dbtt-fld-name(RECID(_BC)).
        ELSE
          ASSIGN cTemp   = "  FIELD ":U + _BC._DISP-NAME + " AS ":U + CAPS(_BC._DATA-TYPE)
                 cDBName = _BC._DBNAME.

        PUT STREAM P_4GLSDO UNFORMATTED cTemp.
        /* valid field-options FORMAT and LABEL */
        ASSIGN cTemp = "":U.
        IF _BC._INHERIT-VALIDATION AND _BC._DBNAME <> "_<CALC>":U THEN
           cTemp = cTemp + ' VALIDATE '.
        IF _BC._FORMAT NE ? AND 
           _BC._FORMAT NE "":U AND
           _BC._FORMAT NE _BC._DEF-FORMAT THEN 
           cTemp = cTemp + ' FORMAT "':U + TRIM(_BC._FORMAT) + '"':U.
        IF _BC._LABEL NE ? AND 
           _BC._LABEL NE "":U AND
           _BC._LABEL NE _BC._DEF-LABEL THEN
           cTemp = cTemp + ' LABEL "':U + TRIM(_BC._LABEL) + '"':U.
        IF _BC._HELP NE ? AND 
           _BC._HELP NE "":U AND
           _BC._HELP NE _BC._DEF-HELP THEN 
           cTemp = cTemp + ' HELP "':U + TRIM(_BC._HELP) + '"':U.
              
        PUT STREAM P_4GLSDO UNFORMATTED cTemp.
        IF NOT LAST(_BC._SEQUENCE) THEN 
          PUT STREAM P_4GLSDO UNFORMATTED "~~":U.
        PUT STREAM P_4GLSDO UNFORMATTED SKIP.
      END. /* FOR EACH _BC */
      OUTPUT STREAM P_4GLSDO CLOSE.

      ASSIGN cDLPProductModule = (IF _C._DATA-LOGIC-PROC-PMOD <> "":U THEN _C._DATA-LOGIC-PROC-PMOD 
                                                                      ELSE cOBJProductModule).
      FIND FIRST gsc_product_module NO-LOCK
        WHERE gsc_product_module.product_module_code = cDLPProductModule
        NO-ERROR.
      IF AVAILABLE gsc_product_module THEN DO:
      IF VALID-HANDLE(ghSCMTool) THEN DO:
        /* Get the SCM relative module paths - as these may be different from the 
           relative paths in the Dynamics repository. OIF we are using an SCM tool, then 
           the relative path for the corresponding product module selected takes 
           precedence over the relative path from the Dynamics repository.
        */
        RUN scmGetModuleDir IN ghSCMTool (INPUT gsc_product_module.product_module_code, OUTPUT cDLPRelativeDir).          
        ASSIGN 
          cDLPRelativeDir = TRIM(REPLACE(cDLPRelativeDir,"~\":U,"~/":U),"~/":U)          
          .
      END.
      ELSE
        ASSIGN cDLPRelativeDir = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"~/":U),"~/":U).      
      END.
      ELSE ASSIGN cDLPRelativeDir = TRIM(REPLACE(_P.object_path                  ,"~\":U,"~/":U),"~/":U).

      ASSIGN cDLPFullName = REPLACE(_C._DATA-LOGIC-PROC,"~\":U,"~/":U).
      RUN adecomm/_osprefx.p (INPUT cDLPFullName, OUTPUT cDLPRootDir, OUTPUT cDLPFileName).
      ASSIGN cDLPRootDir = TRIM(cDLPRootDir,"~/":U).

      IF cDLPRelativeDir NE "":U AND cDLPRootDir = cDLPRelativeDir THEN
        /* Make the RootDir "":U */
        cDLPRootDir = "":U.

      IF cDLPRelativeDir NE "":U AND cDLPRootDir MATCHES "*":U + cDLPRelativeDir THEN
        /* If cDLPRootDir ends with cDLPRelativeDir, then remove it */
        cDLPRootDir = SUBSTRING(cDLPRootDir, 1, LENGTH(cDLPRootDir,"CHARACTER") -
                                                LENGTH("/":U + cDLPRelativeDir,"CHARACTER"),
                                                "CHARACTER").

      /* There are several ways that this procedure is called.  Sometimes it is called from a batch process,
         sometimes it is called from a save-as dynamic process.  If the root directory is invalid 
         generateDataLogicObject returns an error condition which backs out all of the transaction. It must 
         have a valid value. */
      IF cDLPRootDir = ? OR cDLPRootDir = "?":U OR cDLPRootDir = "":U THEN
        ASSIGN cDLPRootDir  = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, 'AB_source_code_directory').
      /* If the root directory is still invalid make it the working directory */
      IF cDLPRootDir = ? OR cDLPRootDir = "?":U OR cDLPRootDir = "":U
        THEN ASSIGN cDLPRootDir = ".":U.

      cButton = "&YES":U.
      IF SEARCH(cDLPRelativeDir + "/":U + cDLPFileName) NE ? THEN cButton = "&NO":U.
      /* IZ 5852 says to not make this prompt.  Until it makes a difference we will not overwrite
         an existing data-logic procedure 
      IF cButton = "&No":U AND VALID-HANDLE(gshSessionManager) THEN
        RUN askQuestion IN gshSessionManager (INPUT "File " + cDLPRelativeDir + "/":U + cDLPFileName +
                           " already exists.  Do you want to overwrite it?",      /* messages */
                           INPUT "&Yes,&No":U,     /* button list */
                           INPUT "&No":U,          /* default */
                           INPUT "&No":U,          /* cancel */
                           INPUT "Question":U,     /* title */
                           INPUT "":U,             /* datatype */
                           INPUT "":U,             /* format */
                           INPUT-OUTPUT cAnswer,   /* answer */
                           OUTPUT cButton          /* button pressed */
                           ).
      */
      /* Only generate the DLP if it's  a new object, else just register it */
      IF cButton = "&YES":U AND _C._DATA-LOGIC-PROC NE "":U AND lNewObject THEN 
      DO:
        /* Assign updatable fields for validation purposes */
        ASSIGN cFirstEnabledTable = gcTableList + CHR(1) + gcUpdColsByTable.
        /* Get the Index and server validation parameters. These are also used in the OG.*/

        /* Go ahead and generate the DLP */
        RUN generateDataLogicObject IN ghRepositoryDesignManager 
           ( INPUT cDBName,
             INPUT cFirstEnabledTable,           /* table name          */
             INPUT "":U,                         /* dump name           */
             INPUT cOBJFileName,                 /* SDO Name            */
             INPUT cDLPProductModule,
             INPUT IF b_U._LAYOUT-NAME = "Master Layout":U
                THEN "":U ELSE b_U._LAYOUT-NAME, /* Result Code         */
             INPUT YES,                         /* Suppress Validation */
             INPUT cDLPFileName,
             INPUT "DLProc":U,                   /* Object Type         */
             INPUT "ry/obj/rytemlogic.p",        /* Template            */
             INPUT cOBJRelativeDir,              /* SDO    relative */
             INPUT cDLPRelativeDir,              /* DLProc relative */
             INPUT cDLPRootDir,                  /* Root Directory  */
             INPUT "/":U,                        /* FolderIndicator     */
             INPUT NO                            /* Don't create Folder */
             ) NO-ERROR.

        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
          RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

        /* Now we have written a vanilla "generated" logic procedure and
           it associated _CL file.  

           If this is a migration of a static SDO and the user preference is
           "StandVal" then we are finished.  If it is "ValOnly" or "All", 
           then we want to strip out any of the generated validation code.  
           If it is "All", then we want to insert all of the old code.  If it
           is "ValOnly" then we want to only add in any procedures and/or 
           functions from the original SDO that we are converting.  
           To do this, we will open the new DLP silently and delete the 
           unwanted code sections then code the wanted SDO code sections to 
           it before rewriting it. */

        IF lMigration AND cSuperPref NE "StandVal":U THEN DO:

          /* First step is to load DLP into the Appbuilder */
          RUN adeuib/_qssuckr.p (INPUT cDLPRootDIR + "/":U +
                                       cDLPRelativeDir + "/":U +
                                       cDLPFileName,          /* File to read        */
                                 INPUT "",                 /* WebObject           */
                                 INPUT "WINDOW-SILENT":U,  /* Import mode         */
                                 INPUT FALSE).             /* Reading from schema */

          IF RETURN-VALUE BEGINS "_ABORT":U THEN DO:
            pError = RETURN-VALUE.
            IF LENGTH(pError,"CHARACTER") > 7 THEN
              pError = SUBSTRING(pError, 8, -1, "CHARACTER").
            ELSE pError = "":U.
            RETURN.
          END.

          FIND dlp_P WHERE dlp_P._WINDOW-HANDLE = _h_win.
          FIND w_U WHERE w_U._HANDLE = _h_win.
          WindowRecid = RECID(w_U).

          /* Remove unwanted validation sections from the DLP */
          FOR EACH _TRG WHERE _TRG._pRECID = RECID(dlp_P):
            IF LOOKUP(_TRG._tSECTION,"_PROCEDURE,_FUNCTION":U) > 0
              AND LOOKUP(_TRG._tEVENT,
                  "createPreTransValidate,isFieldBlank,rowObjectValidate,WritePreTransValidate":U) > 0 
              THEN DELETE _TRG.
          END.  /* Looking for validation procedures to remove */

          /* Copy desired _TRG records from SDO to DLP */
          FOR EACH _TRG WHERE _TRG._pRECID = RECID(_P):
            IF cSuperPref = "ValOnly":U THEN DO:
              IF LOOKUP(_TRG._tSECTION,"_PROCEDURE,_FUNCTION":U) > 0
                 AND _TRG._tEVENT MATCHES "*VALIDATE" 
                 AND _TRG._STATUS = "NORMAL":U THEN DO:
                /* For now only copy the traditional validation procedures */
                /* Remove the "VALIDATE" from the Event to check it better */
                cTmpName = REPLACE(_TRG._tEVENT, "VALIDATE":U, "":U).
                IF LOOKUP(cTmpName,cValidValidates) > 0 OR
                  CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(b_U) AND
                           _BC._NAME = cTmpName) THEN DO:
                  CREATE dlp_TRG.
                  BUFFER-COPY _TRG EXCEPT _pRECID _wRECID TO dlp_TRG
                    ASSIGN _pRECID = RECID(dlp_P)
                           _wRECID = WindowRecid.
                END.  /* If it is one of the proper validates */
              END.  /* If it is a procedure or function that ends with VALIDATE */
            END.  /* If Val only */
            ELSE DO:  /* Must be "All", copy all code */
              CREATE dlp_Trg.
              BUFFER-COPY _TRG EXCEPT _pRECID _wRECID TO dlp_TRG
                ASSIGN _pRECID = RECID(dlp_P)
                       _wRECID = WindowRecid.
            END.  /* Else copy all */
          END. /* Looking for custom code to copy */

          /* Save the updated DLP */
          RUN adeshar/_gen4gl.p ("SAVE").

          /* The Xftr caused the _P to be marked dirty, set it back */
          dlp_P._FILE-SAVED = YES.

          /* Close the DLP */
          RUN wind-close IN _h_uib (_h_win).
        END.  /* If migrating */
      END. /* Don't ovewrite an existing Logic procedure unless told to */

      /* Always recompile the logic procedure (unless migrating because we just compiled it) */
      IF NOT lMigration AND SEARCH(cDLPRelativeDir + "~/":U + cDLPFileName) NE ? THEN DO:
        COMPILE VALUE(cDLPRelativeDir + "~/":U + cDLPFileName) SAVE.
        COMPILE VALUE(cDLPRelativeDir + "~/":U +
                      REPLACE(cDLPFileName,".p":U,"_cl.P":U)) SAVE.
      END.

      /* Force Updated version to be found */
      DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                       INPUT cObjFileName, INPUT ?, INPUT ?, INPUT YES).

      /* Generate any calaculated fields in the repository */
      FOR EACH _BC WHERE _BC._x-recid = RECID(b_U) AND _BC._DBNAME = "_<CALC>":U:
        RUN generateCalculatedField IN ghRepositoryDesignManager
          (INPUT _BC._DISP-NAME,     /* calcFieldName   */
           INPUT _BC._DATA-TYPE,     /* Data Type       */
           INPUT _BC._FORMAT,        /* Format          */
           INPUT _BC._LABEL,         /* Label           */
           INPUT _BC._HELP,          /* Help            */
           INPUT cOBJProductModule,  /* Product Module  */
           INPUT "":U,               /* Result Code     */
           INPUT "CalculatedField":U).
        ASSIGN _BC._STATUS = "UPDATE,":U + _BC._DISP-NAME.
      END.  /* for each calc field */

    END.  /* If generating a dynSDO */

    /* Else if we are generating an SBO */
    ELSE IF cClassName = "DynSBO":U THEN DO:
      /* Create Object Instances of the contained SDOs */
      FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND 
                         b_U._STATUS        = "NORMAL":U AND
                         b_U._TYPE          = "SmartObject":U AND
                         b_U._SUBTYPE       = "SmartDataObject":U:

        FIND _S WHERE RECID(_S) = b_U._x-recid.

        /* Initialize dObject_obj to 0 so that the attributes get set during the 
           insetObjectInstance */
        dObject_obj = 0.

        /* Loop through instance setting to create attributes */
        SETTINGS-SEARCH:
        DO i = 1 TO NUM-ENTRIES(_S._settings, CHR(3)):
          ASSIGN cAttr = ENTRY(i, _S._settings, CHR(3))
                 cValue = ENTRY(2, cAttr, CHR(4))
                 cAttr  = ENTRY(1, cAttr, CHR(4)).
          IF cAttr = "ObjectName":U THEN
            cObjFileName = cValue.
          IF cAttr = "ForeignFields":U AND cValue NE "":U THEN DO:
            IF NUM-ENTRIES(ENTRY(1, cValue), ".":U) = 2 THEN
              ENTRY(1, cValue) = ENTRY(2, ENTRY(1, cValue), ".":U).
           {&Create-Char-Instance} cValue, ?, ?, ?, ?, ?).
          END.
        END.  /* Do I = 1 to num settings */

        hStoreAttribute = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
        RUN insertObjectInstance IN ghRepositoryDesignManager
             ( INPUT dDynamicObj,                  /* Container Viewer                  */
               INPUT cOBJFileName,                 /* Object Name                       */                  
               INPUT IF b_U._LAYOUT-NAME = "Master Layout":U
                     THEN "":U ELSE b_U._LAYOUT-NAME,    /* Result Code                 */
               INPUT cObjFileName,                 /* Instance Name                     */
               INPUT "SDO of SBO":U,               /* Description    */
               INPUT "":U,                         /* Layout Position                   */
               INPUT NO,                           /* Force creation                    */
               INPUT hStoreAttribute,              /* Buffer handle for attribute table */
               INPUT TABLE-HANDLE hUnKnown,        /* Table handle for attribute table  */
               OUTPUT dSDO_Obj,                    /* Master obj                        */
               OUTPUT dObject_Obj )                /* Instance Obj                      */
               NO-ERROR.

        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
          RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

        /* Empty the ttStoreAttribute temp-table */
        EMPTY TEMP-TABLE ttStoreAttribute.

        /* Save the instance obj so we can make the ryc_smartLinks */
        b_U._OBJECT-OBJ = dObject_obj.

      END. /* FOR EACH b_U: Looping through the SDOs */

      /* Create the smart links for the SBO */
      FOR EACH _admlinks WHERE _admlinks._P-RECID = RECID(_P).
        FIND ryc_smartlink_type WHERE ryc_smartlink_type.link_name = _admlinks._link-type
                                NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_smartlink_type THEN DO:
          FIND b_U WHERE RECID(b_U) = INTEGER(_admlinks._link-source).
          CREATE ryc_smartlink.
          ASSIGN ryc_smartlink.container_smartobject_obj  = dDynamicObj
                 ryc_smartlink.smartlink_type_obj         = ryc_smartlink_type.smartlink_type_obj
                 ryc_smartlink.link_name                  = ryc_smartlink_type.link_name
                 ryc_smartlink.SOURCE_object_instance_obj = b_U._OBJECT-OBJ.

          FIND b_U WHERE RECID(b_U) = INTEGER(_admlinks._link-dest).
          ASSIGN ryc_smartlink.TARGET_object_instance_obj = b_U._OBJECT-OBJ.
        END.
      END.

      /* Should we generate a DLP for this SBO? */
      IF cSuperPref NE "None":U THEN DO:
        RUN createSBODLP (INPUT _C._DATA-LOGIC-PROC, _P._u-recid) NO-ERROR.

        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
          RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

        /* We must open an save this to make it finalize itself.  If
           the cSuperPref is to copy validation logic, then we will do that
           too */

        /* First step is to load DLP into the Appbuilder */
        RUN adeuib/_qssuckr.p (INPUT _C._DATA-LOGIC-PROC, /* File to read        */
                               INPUT "",                  /* WebObject           */
                               INPUT "WINDOW-SILENT":U,   /* Import mode         */
                               INPUT FALSE).              /* Reading from schema */

        IF RETURN-VALUE BEGINS "_ABORT":U THEN DO:
          pError = RETURN-VALUE.
          IF LENGTH(pError,"CHARACTER") > 7 THEN
            pError = SUBSTRING(pError, 8, -1, "CHARACTER").
          ELSE pError = "":U.
          RETURN.
        END.

        FIND dlp_P WHERE dlp_P._WINDOW-HANDLE = _h_win.
        FIND w_U WHERE w_U._HANDLE = _h_win.
        WindowRecid = RECID(w_U).

        /* Copy desired _TRG records from SDO to DLP */
        FOR EACH _TRG WHERE _TRG._pRECID = RECID(_P):
          IF cSuperPref = "ValOnly":U THEN DO:
            IF LOOKUP(_TRG._tSECTION,"_PROCEDURE,_FUNCTION":U) > 0
               AND _TRG._tEVENT MATCHES "*VALIDATE" 
               AND _TRG._STATUS = "NORMAL":U THEN DO:
              /* For now only copy the traditional validation procedures */
              /* Remove the "VALIDATE" from the Event to check it better */
              cTmpName = REPLACE(_TRG._tEVENT, "VALIDATE":U, "":U).
              IF LOOKUP(cTmpName,cValidValidates) > 0 THEN DO:
                CREATE dlp_TRG.
                BUFFER-COPY _TRG EXCEPT _pRECID _wRECID TO dlp_TRG
                  ASSIGN dlp_TRG._pRECID = RECID(dlp_P)
                         dlp_TRG._wRECID = WindowRecid.
              END.  /* If it is one of the proper validates */
            END.  /* If it is a procedure or function that ends with VALIDATE */
          END.  /* If Val only */
          ELSE DO:  /* Must be "All", copy all code */
            CREATE dlp_Trg.
            BUFFER-COPY _TRG EXCEPT _pRECID _wRECID TO dlp_TRG
              ASSIGN dlp_TRG._pRECID = RECID(dlp_P)
                     dlp_TRG._wRECID = WindowRecid.
          END.  /* Else copy all */
        END. /* Looking for custom code to copy */

        /* Save the updated DLP */
        RUN adeshar/_gen4gl.p ("SAVE").

        /* Register this in the Repository */
        RUN af/sup2/afsdocrdbp.p
            (INPUT SEARCH(_C._DATA-LOGIC-PROC), /* Fully qualified path name of object to register  */
             INPUT "DLProc":U,                  /* Register with object_type "DLProc"               */
             INPUT _C._DATA-LOGIC-PROC-PMOD,    /* Register with this product module                */
             INPUT "",                          /* Blank description                                */
             INPUT "":U,                        /* Deployment Type                                  */
             INPUT NO,                          /* Design only                                      */
             INPUT NO,                          /* Don't prompt for product module                  */
             OUTPUT pError) NO-ERROR.                    /* Error text occurred                              */

        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
          RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

        /* The Xftr caused the _P to be marked dirty, set it back */
        dlp_P._FILE-SAVED = YES.

        /* Close the DLP */
        RUN wind-close IN _h_uib (_h_win).
      
      END.  /* If we need a DLP */

    END. /* Else if we are generating an SBO */

    /* Empty the ttStoreAttribute temp-table */
    EMPTY TEMP-TABLE ttStoreAttribute.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeSuperProc Procedure 
PROCEDURE writeSuperProc :
/*------------------------------------------------------------------------------
  Purpose:    To write out a custom Super procedure for this Dynamic Object 
  Parameters:
     INPUT  pPrecid - recid of _P to be written
     OUTPUT pError  - Error message if object can't be written
          
  Notes:  In the first pass _P must represent a SDV or a SDB.  More types can
          be added in the future.
          
          When an object is written to the repository, we first look to see 
          if it already has an associated Super procedure.  If so,  we regenetate
          it using the same name.  Otherwise we create a new name which is the 
          same as the object being written + "Super.p".  This file is written in
          the directory associated with the module that the dynamic object
          belongs to.     
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pPrecid   AS RECID                    NO-UNDO.
  DEFINE OUTPUT PARAMETER pError    AS CHARACTER                NO-UNDO.

  DEFINE VARIABLE cDesc             AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE dCustomSuper      AS DECIMAL                  NO-UNDO.
  DEFINE VARIABLE dCustomResultObj  AS DECIMAL                  NO-UNDO.
  DEFINE VARIABLE dSuperProcObj     AS DECIMAL                  NO-UNDO.
  DEFINE VARIABLE hAttributeTable   AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE SvSaveAS          AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvType            AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvDesc            AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvDataObject      AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvAdmVers         AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvFileType        AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvSupLinks        AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvPPLists         AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvMaxFrmCnt       AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE SvPersOnly        AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE SvRunPers         AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE SvName            AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvLabel           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE SvMinHgt          AS DECIMAL                  NO-UNDO.
  DEFINE VARIABLE SvMinWdth         AS DECIMAL                  NO-UNDO.

  DEFINE VARIABLE cCSPProductModule AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cCSPFullName      AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cCSPRootDir       AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cCSPRelativeDir   AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cCSPFileName      AS CHARACTER                NO-UNDO.

  DEFINE BUFFER sup_P FOR _P.

 
  /* Get the _P record to write */
  FIND _P WHERE RECID(_P) = pPrecid.
  FIND _U WHERE RECID(_U) = _P._u-recid.
  FIND _C WHERE RECID(_C) = _U._x-recid.
  
  /* The user doesn't want a customer super procedure generated */
  IF _C._CUSTOM-SUPER-PROC = "":U THEN RETURN.
  IF lMigration AND cSuperPref = "None":U THEN RETURN.
    
  ASSIGN _P.run_persistent = YES
         cCSPProductModule = "":U
         cCSPRelativeDir   = "":U.

  /* IF module is specified, retrieve module and relative directory */
  IF _C._CUSTOM-SUPER-PROC-PMOD <> "":U AND _C._CUSTOM-SUPER-PROC-PMOD <> ? THEN
    FIND FIRST gsc_product_module NO-LOCK
         WHERE gsc_product_module.product_module_code = _C._CUSTOM-SUPER-PROC-PMOD NO-ERROR.
  IF NOT AVAILABLE gsc_product_module AND _P.product_module_code <> "":U THEN
    FIND FIRST gsc_product_module NO-LOCK
         WHERE gsc_product_module.product_module_code = _P.product_module_code NO-ERROR.

  IF AVAILABLE gsc_product_module THEN DO:
    cCSPProductModule = gsc_product_module.product_module_code.
    IF VALID-HANDLE(ghSCMTool) THEN DO:
      /* Get the SCM relative module paths - as these may be different from the 
         relative paths in the Dynamics repository. OIF we are using an SCM tool, then 
         the relative path for the corresponding product module selected takes 
         precedence over the relative path from the Dynamics repository. */
      RUN scmGetModuleDir IN ghSCMTool (INPUT gsc_product_module.product_module_code, OUTPUT cCSPRelativeDir).          
      ASSIGN cCSPRelativeDir = TRIM(REPLACE(cCSPRelativeDir,"~\":U,"~/":U),"~/":U).
    END.
    ELSE ASSIGN cCSPRelativeDir = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"~/":U),"~/":U).      
  END. /* If available gsc_product_module */
  ELSE ASSIGN cCSPRelativeDir = TRIM(REPLACE(_P.object_path                  ,"~\":U,"~/":U),"~/":U).
  
  ASSIGN cCSPFullName    = REPLACE(_C._CUSTOM-SUPER-PROC,"~\":U,"~/":U).

  RUN adecomm/_osprefx.p (INPUT cCSPFullName, OUTPUT cCSPRootDir, OUTPUT cCSPFileName).
  ASSIGN cCSPRootDir   = TRIM(cCSPRootDir,"~/":U)
         cCSPRootDir   = IF cCSPRelativeDir NE "":U 
                         THEN TRIM(REPLACE(cCSPRootDir, cCSPRelativeDir,"":U),"~/":U)
                         ELSE cCSPRootDir
         _save_file    = cCSPFullName NO-ERROR.

  /* Before doing anything, see if _save_file exists.  We don't want to overwrite an exisitng file */
  IF SEARCH(_save_file) = ? AND _C._CUSTOM-SUPER-PROC <> ? THEN 
  DO:
     /* We want adeshar/_gen4gl.p to do all of the heavy lifting so first we massage
       the _P, _U and _C to make this look like a structured procedure.  We will
       save the values so that they can be restored after everything has been written out. */
     ASSIGN
       SvSaveAS     = _P._SAVE-AS-FILE
       SvType       = _P._TYPE
       SvAdmVers    = _P._adm-version
       SvDesc       = _P._DESC
       SvDataObject = _P._data-object
       SvFileType   = _P._file-type
       SvSupLinks   = _P._links
       SvPPLists    = _P._lists
       SvMaxFrmCnt  = _P._max-frame-count
       SvPersOnly   = _P._persistent-only
       SvRunPers    = _P._run-persistent
       SvName       = _U._NAME
       SvLabel      = _U._LABEL
       SvMinHgt     = _C._MIN-HEIGHT
       svMinWdth    = _C._MIN-WIDTH
       /* Now put in the Procedure Values */
       SESSION:NUMERIC-FORMAT = "AMERICAN":U
       _P._SAVE-AS-FILE      = _save_file
       _P._TYPE              = "Procedure":U
       _P._DESC              = "Super Procedure for ":U + SvDesc
       _P._data-object       = "":U
       _P._adm-version       = "":U
       _P._file-type         = "p":U
       _P._links             = "":U
       _P._lists             = "List-1,List-2,List-3,List-4,List-5,List-6":U
       _P._max-frame-count   = 0
       _P._persistent-only   = NO
       _P._run-persistent    = YES
       _U._NAME              = "Procedure":U
       _U._LABEL             = "Custom Super Procedure":U
       _C._MIN-HEIGHT        = 1.00
       _C._MIN-WIDTH         = 1.00 
        NO-ERROR.
  
     /* Call _gen4gl.p */
     RUN adeshar/_gen4gl.p ("SAVESuperProc":U + IF cSuperPref = "empty":U THEN cSuperPref ELSE "":U ).

     ASSIGN cDesc   = _U._LABEL + ' for ':U + cCSPFileName /* OLD : _P.object_filename */
            hAttributeBuffer = ?
            hAttributeTable  = ?
            .
     RUN insertObjectMaster IN ghRepositoryDesignManager ( 
           INPUT  cCSPFileName,                             /* pcObjectName         */
           INPUT  IF _U._LAYOUT-NAME ="Master Layout":U 
                  THEN "{&DEFAULT-RESULT-CODE}":U 
                  ELSE _U._LAYOUT-NAME,                     /* pcResultCode    */
           INPUT  cCSPProductModule,                        /* pcProductModuleCode  */
           INPUT  "Procedure":U,                            /* pcObjectTypeCode     */
           INPUT  cDesc,                                    /* pcObjectDescription  */
           INPUT  "":U,                                     /* pcObjectPath         */
               /* db. changed _P._data_object to ""  */
           INPUT  "",                                      /* pcSDOName            */
           INPUT  "":U,                                     /* pcSuperProcedureName */
           INPUT  NO,                                       /* plIsTemplate         */
           INPUT  YES,                                      /* plIsStatic           */
           INPUT  "":U,                                     /* pcPhysicalObjectName */
           INPUT  NO,                                       /* plRunPersistent      */
           INPUT  "":U,                                     /* pcTooltipText        */
           INPUT  "":U,                                     /* pcRequiredDBList     */
           INPUT  "":U,                                     /* pcLayoutCode         */
           INPUT  hAttributeBuffer,
           INPUT  TABLE-HANDLE hAttributeTable,
           OUTPUT dCustomSuper                              ) NO-ERROR.

     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
       RUN AppendToPError (INPUT RETURN-VALUE, INPUT-OUTPUT pError).

     /* Register this as the super procedure of the DynObject */
     IF dCustomSuper NE 0 THEN DO:
       FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj = _P.SmartOBJECT_obj NO-ERROR.
       IF AVAILABLE ryc_smartobject THEN ryc_smartobject.custom_smartobject_obj = dCustomSuper.
     END. /* We have a vaild super procedure */

     /* Register newly created events in repository */
     RUN SuperProcEventReg IN THIS-PROCEDURE (pPrecid ).

     /* Restore original values */
     ASSIGN _P._SAVE-AS-FILE      = SvSaveAs
            _P._TYPE              = SvType
            _P._adm-version       = SvAdmVers
            _P._DESC              = SvDesc
            _P._data-object       = SvDataObject
            _P._file-type         = SvFileType
            _P._links             = SvSupLinks
            _P._lists             = SvPPLists
            _P._max-frame-count   = SvMaxFrmCnt
            _P._persistent-only   = SvPersOnly
            _P._run-persistent    = SvRunPers
            _P._FILE-SAVED        = YES
            _U._NAME              = SvName
            _U._LABEL             = SvLabel
            _C._MIN-HEIGHT        = SvMinHgt
            _C._MIN-WIDTH         = SvMinWdth.
      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

      /* Because the sequence of code is not correct and there is unwwanted
         preprocesors created, read the new super procedure back in, and 
         write it back out.  This fixes many things                       */
      RUN adeuib/_qssuckr.p (INPUT _save_file,          /* File to read        */
                       INPUT "",                        /* WebObject           */
                       INPUT "WINDOW-SILENT":U,         /* Import mode         */
                       INPUT FALSE).                    /* Reading from schema */

      IF RETURN-VALUE BEGINS "_ABORT":U THEN DO:
        pError = RETURN-VALUE.
        IF LENGTH(pError,"CHARACTER") > 7 THEN
          pError = SUBSTRING(pError, 8, -1, "CHARACTER").
        ELSE pError = "":U.
        RETURN.
      END.

      FIND sup_P WHERE sup_P._WINDOW-HANDLE = _h_win.

      /* Re-save the updated Super procedure */
      RUN adeshar/_gen4gl.p ("SAVESuperProc").

      /* The Xftr caused the _P to be marked dirty, set it back */
      sup_P._FILE-SAVED = YES.

      /* Close the SUP */
      RUN wind-close IN _h_uib (_h_win).

   END.  /* If the file doesn't already exist */
   /* If It already exist, re-register the super procedure */
   ELSE 
   DO:
      /* If set to null, unregister the custom super procedure */
      IF _C._CUSTOM-SUPER-PROC <> ? THEN
      DO:
         /* Get the current resultCode */
         IF _U._LAYOUT-NAME = "Master LAYOUT":U OR _U._LAYOUT-NAME = "" THEN 
            ASSIGN dCustomResultObj = 0.
         ELSE DO:
           FIND FIRST ryc_customization_result WHERE
                      ryc_customization_result.customization_result_code = _U._LAYOUT-NAME
                      NO-LOCK NO-ERROR.
           IF AVAILABLE ryc_customization_result THEN
               ASSIGN dCustomResultObj = ryc_customization_result.customization_result_Obj.
         END.    
         /* Get the smartObjectObj for the super procedure and re-register this as the super procedure of the DynObject */
         ASSIGN dSuperProcObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN ghRepositoryDesignManager, INPUT cCSPFileName, INPUT dCustomResultObj).
      END.

      FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj = _P.smartobject_obj NO-ERROR.
      IF AVAILABLE ryc_smartobject THEN 
         ryc_smartobject.custom_smartobject_obj = dSuperProcObj.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CheckCustomChanges Procedure 
FUNCTION CheckCustomChanges RETURNS CHARACTER
  ( INPUT p_LRecid      AS RECID,
    INPUT plCreate   AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Checks to see if there are any customizations for this layout
  
  Parameters: p_LRecid  - A _L of a custom layout
              pLCreate  - If TRUE then insert any differences into the repository
                          Else just return a list of the Attributes that differ
                          from the master
                                                 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttrDiffs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPropLib    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hPropBuffer AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cWhere      AS CHARACTER  NO-UNDO.

  DEFINE BUFFER m_L FOR _L.
  DEFINE BUFFER m_U FOR _U.

  FIND _L WHERE RECID(_L) = p_LRecid.
  FIND m_L WHERE m_L._LO-NAME = "Master Layout":U AND m_L._u-recid = _L._u-recid.
  FIND m_U WHERE RECID(m_U)   = _L._u-Recid.  

  BUFFER-COMPARE _L EXCEPT _LO-NAME _VIRTUAL-WIDTH _VIRTUAL-HEIGHT TO m_L SAVE cAttrDiffs.
  /* Check whether any changes were made in the property sheet for custom layouts */
  IF VALID-HANDLE(_h_menubar_proc) AND cAttrDiffs = "" THEN
  DO:
     hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
     IF VALID-HANDLE(hPropLib) THEN 
     DO:
        ASSIGN hPropBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hPropLib, "ttAttribute":U)
               cWhere      = " WHERE ":U
                               + hPropBuffer:NAME + ".callingProc = '":U + STRING(_h_menubar_proc) + "' AND ":U 
                               + hPropBuffer:NAME + ".containerName = '":U + STRING(m_U._Window-handle) + "' AND ":U
                               + hPropBuffer:NAME + ".resultCode = '":U + _L._LO-NAME + "' AND ":U
                               + hPropBuffer:NAME + ".objectName = '":U + STRING(m_U._handle) + "' AND "
                               + hPropBuffer:NAME + ".RowModified = 'true'".

        hPropBuffer:FIND-FIRST(cWhere) NO-ERROR.
        IF hPropBuffer:AVAILABLE AND cAttrDiffs = "" THEN
           cAttrDiffs = "Found".
     END.   
  END.
  
  RETURN cAttrDiffs.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
