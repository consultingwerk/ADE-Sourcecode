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
  File: ry/prc/rygendynp.p

  Description:  Saves a dynamic object into the repository 

  Purpose:     This procedure  is designed to write any window designed in the AppBuilder 
               into the Dynamics repository in the form of a dynamic object.
               
               Supports the saving of SmartDataViewers, SmartDatabrowsers and SmartDataObjects

  Parameters:   INPUT  gprPrecid  - the Recid of the _P record to write
                OUTPUT gpcError   - Error message if object can't be written

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/25/2003  Author:    Don Bulua 

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

 DEFINE INPUT  PARAMETER gprPrecid AS RECID      NO-UNDO.
 DEFINE OUTPUT PARAMETER gpcError  AS CHARACTER  NO-UNDO.

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

 {src/adm2/globals.i}
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
 {ry/app/rydefrescd.i}   /* Defines the DEFAULT-RESULT-CODE result codes.     */
 {destdefi.i}             /* Definitions for dynamics design-time temp-tables. */

  /* DeleteAttribute is the temp-table that is passed to RemoveAttributeValues to delete
     attributes */
 DEFINE TEMP-TABLE DeleteAttribute LIKE ttStoreAttribute.
 DEFINE TEMP-TABLE DeleteUIEvent   LIKE ttStoreUIEvent.

 DEFINE BUFFER b_U     FOR _U.   /* For field level objects */
 DEFINE BUFFER b_L     FOR _L.   /* For _L records          */

 DEFINE VARIABLE gcAttributeList      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcClassName          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcContainer          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcDBName             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcDLPFileName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcFullPathName       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcOBJFileName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcOBJProductModule   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcObjClassType       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcObjectDescription  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcObjectName         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcOutputObjectName   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcProfileData        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcResultCodes        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcSCMRelativeDir     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcSDOName            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcSDORepos           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcSuperPref          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcTableList          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gcUpdColsByTable     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE gdDynamicObj         AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE gdMinHeight          AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE gdMinWidth           AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE gdSmartObject_obj    AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE ghRepDesignManager   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE ghUnknown            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE glMigration          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE glnewObject          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE grBrowseRecid        AS RECID      NO-UNDO.
 DEFINE VARIABLE grFrameRecid         AS RECID      NO-UNDO.
 DEFINE VARIABLE grQueryRecid         AS RECID      NO-UNDO.
 DEFINE VARIABLE grRowid              AS ROWID      NO-UNDO.


 DEFINE TEMP-TABLE tResultCodes NO-UNDO
    FIELD cRC           AS CHARACTER
    FIELD dContainerObj AS DECIMAL LABEL "Master Obj"
   INDEX cRCidx cRC.

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

&IF DEFINED(EXCLUDE-checkCustomChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkCustomChanges Procedure 
FUNCTION checkCustomChanges RETURNS CHARACTER
( INPUT p_LRecid      AS RECID,
   INPUT plCreate   AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeChar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttributeChar Procedure 
FUNCTION setAttributeChar RETURNS LOGICAL
  ( pcLevel   AS CHAR,
    pcABValue AS CHAR,
    pcLabel   AS CHAR,
    pcValue  AS CHAR,
    pdObj     AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeDec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttributeDec Procedure 
FUNCTION setAttributeDec RETURNS LOGICAL
   ( pcLevel   AS CHAR,
     pdABValue AS DEC,
     pcLabel   AS CHAR,
     pcValue   AS CHAR,
     pdObj     AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeInt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttributeInt Procedure 
FUNCTION setAttributeInt RETURNS LOGICAL
 ( pcLevel   AS CHAR,
   piABValue AS INT,
   pcLabel   AS CHAR,
   pcValue   AS CHAR,
   pdObj     AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttributeLog Procedure 
FUNCTION setAttributeLog RETURNS LOGICAL
  ( pcLevel   AS CHAR,
    plABValue AS LOG,
    pcLabel   AS CHAR,
    pcValue   AS CHAR,
    pdObj     AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMigrationPreferences) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMigrationPreferences Procedure 
FUNCTION setMigrationPreferences RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD verifyObjectType Procedure 
FUNCTION verifyObjectType RETURNS CHARACTER
  ( pcWidgetType AS CHAR,
    pcObjectTypeCode AS CHAR)  FORWARD.

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
         HEIGHT             = 27
         WIDTH              = 59.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
 
 ASSIGN ghRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                         INPUT "RepositoryDesignManager":U).
  
 /* Get the _P record to write */
 FIND _P WHERE RECID(_P) = gprPrecid.
 FIND _U WHERE RECID(_U) = _P._u-recid.

 /* First set migration flag and fetch migration profile preferences */
 IF CAN-DO(_P.design_action, "MIGRATE":U) THEN 
  DO:
      ASSIGN glMigration = YES
             grRowid     = ?.
      RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                               INPUT "Preference":U,      /* Profile code          */
                                               INPUT "GenerateObjects":U, /* Profile data key      */
                                               INPUT "NO":U,              /* Get next record flag  */
                                               INPUT-OUTPUT grRowid,       /* Rowid of profile data */
                                               OUTPUT gcProfileData) NO-ERROR.     /* Found profile data.   */
 END. /* If Migrating */

 /* Create a list of Result Codes for this object */
 FOR EACH _L WHERE _L._u-recid = RECID(_U):
    IF _L._LO-NAME NE "Master Layout":U THEN
        gcResultCodes = gcResultCodes + ",":U + _L._LO-NAME.
 END.  /* For each _L */  
  /* Note, we don't trim the left comma, because the Master Layout uses a blank RC */

 EMPTY TEMP-TABLE tResultCodes.

 TRANS-BLOCK:
 DO TRANSACTION:
   /* Write the object (Viewer, Browser or SDO) */
   RUN writeObjectToRepository  NO-ERROR.           
                                  /* The object was created in the repository, */
   IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN 
   DO:
     UNDO TRANS-BLOCK, LEAVE TRANS-BLOCK.
     RETURN.
   END.

   
   /* Now write out the field level widgets */
   IF gcClassName = "DynView":U THEN
     RUN writeFieldLevelObjects (INPUT "Master Layout":U ) NO-ERROR.
   IF gpcError NE "" AND NOT gpcError BEGINS "Associated data":U THEN 
   DO:
     UNDO TRANS-BLOCK, LEAVE TRANS-BLOCK.
     RETURN.
   END.
 END.  /* Trans-Block */
 /* Mark that this file has been saved */
  _P._FILE-SAVED = YES.        
 /* Write 4GL super procedure if a new viewer or browser */
 IF gpcError EQ "" OR gpcError BEGINS "Associated data":U THEN
    RUN writeSuperProc IN THIS-PROCEDURE NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-AppendToPError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AppendToPError Procedure 
PROCEDURE AppendToPError :
/*------------------------------------------------------------------------------
  Purpose:     When an error is found, either in the ERROR-STATUS handle or
               a RETURN-VALUE, this appends it to gpcError so that it can be
               either placed in the log file of the migration tool or displayed
               on the screen. 
  Parameters:
        INPUT pcReturnValue        - Return value of last procedure called
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcReturnValue  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE iErrorLoop AS INTEGER NO-UNDO.
  DEFINE VARIABLE cIgnore                   AS CHARACTER          NO-UNDO.
  DEFINE VARIABLE lIgnore                   AS LOGICAL            NO-UNDO.

  IF pcReturnValue NE "":U THEN DO:
    /* This has been formatted by CheckErr.i - reformat it by afmessagep before
       adding it to pError.                                                    */
    IF VALID-HANDLE(gshAstraAppServer) THEN
      RUN afmessagep IN gshSessionManager
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
    IF pcReturnValue MATCHES "*Associated datasource*" THEN DO: /* Put this one first */
      /* Remove the (RY:19) */
      IF pcReturnValue MATCHES "*(RY:19)*":U THEN
        pcReturnValue = Entry(1, pcReturnValue, "(":U) + ENTRY(2, pcReturnValue, ")":U).
      gpcError = pcReturnValue + (IF gpcError = "":U THEN "":U ELSE CHR(10)) + gpcError.
    END.
    ELSE  /* Appending is standard */
      gpcError = gpcError + (IF gpcError = "":U THEN "":U ELSE CHR(10)) + pcReturnValue.
  END. /* If the return value is non-blank */
  ELSE DO:
    /* Copy all ERROR-STATUS messages to pError */
    DO iErrorLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
      gpcError = gpcError + (IF gpcError = "":U THEN "":U ELSE CHR(10)) +
                 ERROR-STATUS:GET-MESSAGE(iErrorLoop).
    END.
  END.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignMasterAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignMasterAttributes Procedure 
PROCEDURE assignMasterAttributes :
/*------------------------------------------------------------------------------
  Purpose:   Assigns the master attributes to the temp table  
  Parameters:  <none>
  Notes:     Called from WriteObjectToRepository  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cName            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cInstanceColumns AS CHARACTER  NO-UNDO.

 DEFINE BUFFER sync_L  FOR _L.   /* For  _L's that have labels in sync with the master layout */
 DEFINE BUFFER b_TT    FOR _TT.  /* Temp table buffer */

 IF lookup(gcClassName,"DynView,DynBrow":U) > 0 THEN 
 DO:
    /* Copy the labels of the _U to the current layout _L */
    FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _h_win:
      FIND b_L WHERE b_L._LO-NAME = _U._LAYOUT-NAME AND b_L._u-recid = RECID(b_U) NO-ERROR.
      IF AVAILABLE b_L THEN DO:
        /* If the curent layout is the master, change the _L of all labels that are in sync 
           with the master, if the field is defined on the master(remove_from_layout = No) */
        IF b_L._LO-NAME = "Master Layout":U AND NOT b_L._REMOVE-FROM-LAYOUT THEN 
        DO:
          FOR EACH sync_L WHERE sync_L._u-recid = b_L._u-recid AND
                                sync_L._LABEL   = b_L._LABEL:
            sync_L._LABEL = b_U._LABEL.  /* b_U._LABEL has the latest version */
          END.  /* Updated all labels in sync with the master */
        END.  /* If we're morphing away from the master layout */
        b_L._LABEL = b_U._LABEL.  /* Update _L of what we are morphing away from */
      END.  
    END.  /* Copy labels for layout morphing away from */

    RUN setObjectMasterAttributes (INPUT IF gcClassName = "DynView":U THEN grFrameRecid 
                                                                     ELSE grBrowseRecid,
                                   _U._OBJECT-OBJ,
                                   "Master Layout":U) NO-ERROR.
      IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
    
 END.  /* A dynamic viewer or browser */

 ELSE IF gcClassName = "DynSDO":U THEN  /* DynSDO case here */
 DO: 
   /* If this is a new master, set SmartObject_obj to unknown */
   ASSIGN gdSmartObject_obj = IF _U._OBJECT-obj = 0 THEN ? ELSE _U._OBJECT-OBJ.

   /* Before writing anything, check that all datafields are present */
   DataFieldSearch:
   FOR EACH _BC WHERE _BC._x-recid = grQueryRecid:
     ASSIGN cName = REPLACE(_BC._NAME,"]","")
            cName = REPLACE(cName,"[","").

     IF _BC._DBNAME NE "_<CALC>":U THEN 
     DO:
       IF _BC._DBNAME = "temp-tables":U THEN
          FIND b_TT WHERE b_TT._p-RECID = RECID(_P)
                      AND b_TT._name    = _BC._TABLE NO-ERROR.
       ELSE
          RELEASE b_TT.
       IF NOT CAN-FIND(FIRST ryc_smartobject WHERE 
          ryc_smartobject.OBJECT_filename = ( IF AVAIL b_TT
                                              THEN b_TT._LIKE-TABLE
                                              ELSE _BC._TABLE )
                                             + ".":U + cName) THEN
       DO:
         IF _BC._DBNAME = "temp-tables":U AND AVAIL b_TT THEN
         DO:        /* For temp-tables */
            IF b_TT._TABLE-TYPE = "T":U THEN 
               gpcError =  "Temp-table SDO field '" + _BC._TABLE + ".":U + _BC._NAME + "' has no datafield defined in the repository"
                          + (IF _BC._TABLE <> b_TT._LIKE-TABLE THEN " for like table '" + b_TT._LIKE-TABLE + "'." ELSE ".") + CHR(10)
                          + "You must generate dataFields for all SDO fields including temp-table fields." + CHR(10) + CHR(10) 
                          + "Aborting the saving of SDO " + _P.object_filename + ".":U.
            ELSE   /*  For Buffers */               
               gpcError =   "SDO field '" + _BC._TABLE + ".":U + _BC._NAME + "' defined in a buffer has no datafield defined in the repository for the actual table '" + b_TT._LIKE-TABLE + "'."
                        +  CHR(10) 
                        + "You must generate DataFields for all SDO fields." + CHR(10) + CHR(10)
                        + "Aborting the saving of SDO " + _P.object_filename + ".":U.

         END.
         ELSE
           gpcError = "SDO field " + _BC._TABLE + ".":U + _BC._NAME + " has no datafield defined in the repository." + CHR(10) +
                    "You must generate DataFields for all SDO fields." + CHR(10) + CHR(10) +
                    "Aborting the saving of SDO " + _P.object_filename + ".":U.
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
           (glMigration AND _BC._STATUS = "":U)) THEN
       DO:
         gpcError = "A Calculated Field already exists for field ":U + _BC._DISP-NAME +
                  ".  Calculated Field names must be unique.":U.
         RETURN.
       END.  /* if calc field already exists */
     END.  /* if calc field */
   END. /* FOR EACH _BC */

   FIND _C WHERE RECID(_C)   = _U._x-recid.   /* _C of window */
   IF _C._DATA-LOGIC-PROC-PMOD = ? THEN _C._DATA-LOGIC-PROC-PMOD = gcOBJProductModule.
   RUN setDataObjectAttributes (INPUT grQueryRecid, OUTPUT cInstanceColumns) NO-ERROR.
 END. /* Else if an SDO */

 ELSE IF gcClassName = "DynSBO":U THEN  /* DynSBO case here */
 DO: 
   /* Should this SBO have a DLP attribute */
   IF gcSuperPref NE "None":U THEN DO:
     /* We need to create a DLP for this SBO.  Determine the object name of the DLP
        and create a DataLogicProcedure Master attribute for this SBO */
     FIND _C WHERE RECID(_C) = _U._x-recid.  /* _C of window */
     gcDLPFileName = _C._DATA-LOGIC-PROC.
     IF NUM-ENTRIES(gcDLPFileName, ".":U) = 2 THEN
       gcDLPFileName = ENTRY(1, gcDLPFileName, ".":U).
     RUN CreateAttributeRow("MASTER":U, gdSmartObject_obj, "DataLogicProcedure":U, 
                            {&CHARACTER-DATA-TYPE},gcDLPFileName, ?, ?, ?, ?, ?) NO-ERROR.
     IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.

   END. /* If we need to generate a DLP */
 END.  /* If we are migrating an SBO */
    
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildSDOFieldListsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildSDOFieldListsByTable Procedure 
PROCEDURE buildSDOFieldListsByTable :
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
         with a semi-colon (;) Called from setDataObjectAttributes
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

&IF DEFINED(EXCLUDE-buildSDOSimpleLists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildSDOSimpleLists Procedure 
PROCEDURE buildSDOSimpleLists :
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
          the rest are by comma (,) Called from setDataObjectAttributes
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pURecid                  AS RECID            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDataColumns            AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcUpdatableColumns       AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcInstanceColumns        AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldDataTypes       AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldDBNames         AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldWidths          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBInhVals              AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE hField                           AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hTableBuffer                     AS HANDLE           NO-UNDO.
    DEFINE VARIABLE i                                AS INTEGER          NO-UNDO.
    DEFINE VARIABLE lValidateBlank                   AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lWidthsBlank                     AS LOGICAL          NO-UNDO.

    FOR EACH _BC WHERE _BC._x-recid = pURecid
             AND _BC._DISP-NAME <> ?
             AND _BC._DISP-NAME <> "":U
             BY _BC._SEQUENCE:

      /* To determine the default width - create a buffer and ask */
      IF _BC._TABLE NE "" THEN DO:
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
    ASSIGN lValidateBlank = YES
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
    Notes:     Called from writeFieldLevelObjects
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectFilename AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdInstance_obj   AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDel                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDelete                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRadioSet                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iEnt                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSearch                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rDelimiterAttribute      AS RECID      NO-UNDO.

  FIND ryc_smartObject NO-LOCK
      WHERE ryc_smartObject.object_filename = pcObjectFilename NO-ERROR.
  
  IF NOT AVAILABLE ryc_smartObject THEN DO:
    cError = {af/sup2/aferrortxt.i 'RY' '14' 'ryc_smartobject' 'object_filename' "pcObjectFilename"}.
    RUN AppendToPError (INPUT cError).
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

&IF DEFINED(EXCLUDE-checkStaticObjectPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkStaticObjectPath Procedure 
PROCEDURE checkStaticObjectPath :
/*------------------------------------------------------------------------------
  Purpose:     Before registering a static object make sure it exists in the
               correct path so that we don't register it if it isn't.
  Parameters:  pcObjectName    - Name of object without any path info
               pcProductModule - Product module code
               pcError         - Error message if it is not in the correct path
      Notes:   Called from processAttachedSDO & processsedMigratedSBO         
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcProductModule  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcError          AS CHARACTER  NO-UNDO.

  /* now have a valid product module code */
  FIND FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_code = pcProductModule NO-ERROR.
  IF NOT AVAILABLE gsc_product_module THEN DO:
    ASSIGN pcError = pcObjectName + " not added to repository. Product module does not exist".
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.
  ELSE DO:
    /* Since a valid product module was specified, the object better be there or
       we don't register it */
    /* Strip the relative path from the data object name */   
    ASSIGN pcObjectName = REPLACE(pcObjectName,"~\","/")
           pcObjectName = ENTRY(NUM-ENTRIES(pcObjectName,"/":U),pcObjectName,"/":U)
           NO-ERROR.
    IF SEARCH(gsc_product_module.relative_path 
              + (IF gsc_product_module.relative_path > "" THEN "~/":U ELSE "")
              + pcObjectName ) = ? THEN 
    DO:  /* File is not in the right directory */
      ASSIGN pcError = pcObjectName +
                       " is not in the '" + gsc_product_module.relative_path +
                       "' directory. ":U + CHR(10) + "The file must be located in the same directory as the product module's relative path.":U.
      RETURN.
    END.  /* If not found */
  END.  /* Else we have a valid product module */

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
          Called from setObjectMasterAttributes
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
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructTableList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructTableList Procedure 
PROCEDURE constructTableList :
/*------------------------------------------------------------------------------
  Purpose:    To create a list of SDO tables
  Parameters: 
     INPUT  pURecid       - recid of _U of SDO window
     INPUT  pcQueryTables - List of tables in query (includes external tables)
     OUTPUT pcTables      - List that gets created
              
  Notes: This code was stolen from put_tbllist_internal in adeuib/_genproc.i  
         Called from setDataObjectAttributes
------------------------------------------------------------------------------*/
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
                            INPUT-OUTPUT tbls-in-q) NO-ERROR.
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

&IF DEFINED(EXCLUDE-createAttributeRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createAttributeRow Procedure 
PROCEDURE createAttributeRow :
/*------------------------------------------------------------------------------
  Purpose:     To create another row in the ttAttribute table to pass to the 
               StoreAttributeValues to set attributes in the repository 
  Parameters:
        INPUT pcObjectLevel        - Must be CLASS, MASTER or INSTANCE
        INPUT pdInputObj           - Object id of the SmartObject or Instance,d epending on the level
        INPUT pcAttributeLabel     - Label of the attribute to set
        INPUT piDataType           - DataType of the attribute
        INPUT pcValue              - Character Value
        INPUT pdeValue             - Decimal Value
        INPUT piValue              - Integer Value
        INPUT plValue              - Logical Value
        INPUT pdaValue             - Date Value
        INPUT prValue              - Raw Value
  Notes:  We assume that the constant value is always No and never do we get a 
          date or raw attribute. Called throughout to add attribtues.    
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectLevel      AS CHARACTER              NO-UNDO.
  DEFINE INPUT  PARAMETER pdInputObj         AS DECIMAL                NO-UNDO.
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
         ttStoreAttribute.tAttributeParentObj = pdInputObj
         ttStoreAttribute.tAttributeLabel     = pcAttributeLabel
         ttStoreAttribute.tConstantValue      = NO.  /* Always no, otherwise we wouldn't be setting it */

  CASE piDataType:
      WHEN {&CHARACTER-DATA-TYPE} THEN ttStoreAttribute.tCharacterValue = pcValue.
      WHEN {&DECIMAL-DATA-TYPE}   THEN ttStoreAttribute.tDecimalValue   = pdeValue.
      WHEN {&INTEGER-DATA-TYPE}   THEN ttStoreAttribute.tIntegerValue   = piValue.
      WHEN {&LOGICAL-DATA-TYPE}   THEN ttStoreAttribute.tLogicalValue   = plValue.
      WHEN {&DATE-DATA-TYPE}      THEN ttStoreAttribute.tDateValue      = pdaValue.
      WHEN {&RAW-DATA-TYPE}       THEN ttStoreAttribute.tRawValue       = prValue.
      OTHERWISE           
          ASSIGN   ttStoreAttribute.tCharacterValue = pcValue.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createCustomAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createCustomAttributes Procedure 
PROCEDURE createCustomAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Create Objects and store attributes for custom layouts only
  Parameters:  pcResultCode    Layout Code
  Notes:       Called from writeObjectToRepository
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcResultCode AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTmp AS HANDLE     NO-UNDO.

IF gdDynamicObj = 0 THEN  /* If it doesn't exist */ 
DO:  
  hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
  RUN insertObjectMaster IN ghRepDesignManager
      ( INPUT gcOBJFileName,            /* Object Name                         */
        INPUT pcResultCode,                   /* Result Code                         */
        INPUT gcOBJProductModule,       /* The Product Module                  */
        INPUT gcObjClassType,           /* Object Type Code                    */
        INPUT gcObjectDescription,      /* Description                         */
        INPUT "":U,                    /* Path                                */
        INPUT gcSDORepos,               /* Associated SDO                      */
        INPUT "":U,                    /* SuperProcedure Name                 */
        INPUT NO,                      /* Not a template                      */
        INPUT NO,                      /* Treat as a static object            */
        INPUT "":U,                    /* Rendering Engine (Use Default)      */
        INPUT NO,                      /* Doesn't need to be run persistently */
        INPUT _U._TOOLTIP,             /* Tooltip                             */
        INPUT "":U,                    /* Required DB List                    */
        INPUT "":U,                    /* LayoutCode                          */
        INPUT hTmp,                    /* Attr Table Buffer handle            */
        INPUT TABLE-HANDLE ghUnknown,   /* Table handle for attribute table    */
        OUTPUT gdDynamicObj) NO-ERROR.  /* Obj number for this object          */

  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN 
  DO:
    RUN AppendToPError (RETURN-VALUE).
    RETURN.
  END.

  IF NOT CAN-FIND(FIRST tResultCodes WHERE tResultCodes.cRC = pcResultCode) THEN
  DO:
    CREATE tResultCodes.
    ASSIGN tResultCodes.cRC = pcResultCode
           tResultCodes.dContainerObj = gdDynamicObj.
  END.       
END.  /* If the object didn't exist */

ELSE DO:  /* Else works because if it is new, there are no attributes 
             to delete and the insert did all added attribute records */
  /* If we are setting something back to its default value */
  IF CAN-FIND(FIRST DeleteAttribute) THEN DO:
    hTmp = TEMP-TABLE DeleteAttribute:DEFAULT-BUFFER-HANDLE.
    RUN RemoveAttributeValues IN ghRepDesignManager
        (INPUT hTmp,
         INPUT TABLE-HANDLE ghUnknown) NO-ERROR.

   IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
     RUN AppendToPError (RETURN-VALUE).
     RETURN.
   END.

    EMPTY TEMP-TABLE DeleteAttribute.
  END.  /* If there are any records */

  hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
  RUN StoreAttributeValues IN gshRepositoryManager
      (INPUT hTmp ,
       INPUT TABLE-HANDLE ghUnknown) NO-ERROR.  /* Compiler requires a variable with unknown */

  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
    RUN AppendToPError (RETURN-VALUE).


  IF NOT CAN-FIND(FIRST tResultCodes WHERE tResultCodes.cRC = pcResultCode) THEN
  DO:
    CREATE tResultCodes.
    ASSIGN tResultCodes.cRC = pcResultCode
           tResultCodes.dContainerObj = gdDynamicObj.
  END.
END. /* Else this is something old */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDPSAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDPSAttribute Procedure 
PROCEDURE createDPSAttribute :
/*------------------------------------------------------------------------------
  Purpose:    Retrieves the attributes from the DPS and creates temp-table
              records for modified attributes.
  Parameters: pcLayout      Custom Layout 
              pcLevel       MASTER or INSTANCE
              pdObj         ObjectId of Instance or master depending on level
              phWindowHandle Handle of container
              ph_UHandle     Handle of widget 
  Notes:      Called from setDataObjectAttributes, setObjectInstanceAttributes,
              stObjectMAsterAttributes, setSmartDataFieldValues
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcLayout       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcLevel        AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pdObj          AS DECIMAL    NO-UNDO.
 DEFINE INPUT  PARAMETER phWindowHandle AS HANDLE     NO-UNDO.
 DEFINE INPUT  PARAMETER ph_UHandle     AS HANDLE     NO-UNDO.

 DEFINE VARIABLE hPropQuery  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hPropLib    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hPropBuffer AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cDataType   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cResultCode AS CHARACTER  NO-UNDO.

 IF pcLayout = "Master Layout":U THEN
    cresultCode = "".
  ELSE
    cResultCode = pcLayout.
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
                         + hPropBuffer:NAME + ".callingProc = '":U   + STRING(_h_menubar_proc) + "' AND ":U 
                         + hPropBuffer:NAME + ".containerName = '":U + STRING(phWindowHandle) + "' AND ":U
                         + hPropBuffer:NAME + ".resultCode = '":U    + cResultCode + "' AND ":U
                         + hPropBuffer:NAME + ".objectName = '":U    + STRING( ph_UHandle ) + "' AND "
                         + hPropBuffer:NAME + ".RowModified = 'true'" ).
       hPropQuery:QUERY-OPEN().
       hPropQuery:GET-FIRST().
       DO WHILE hPropBuffer:AVAILABLE:
          /* check whether the attribute was modified and if it's override flag is set */
          ASSIGN cDataType = hPropBuffer:BUFFER-FIELD("dataType":U):BUFFER-VALUE
                 cValue    = hPropBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE
                 cLabel     = hPropBuffer:BUFFER-FIELD("attrLabel":U):BUFFER-VALUE.

          /* check whether the attribute was modified and if it's override flag is set */
          IF hPropBuffer:BUFFER-FIELD("RowOverride":U):BUFFER-VALUE = TRUE THEN
          DO:          
            CASE cDataType:
              WHEN "CHARACTER":U OR WHEN "CHAR":U THEN
                 RUN CreateAttributeRow(pclevel,pdObj,cLabel,{&CHARACTER-DATA-TYPE},cValue,?,?,?,?,?).
              WHEN "DECIMAL":U OR WHEN "DEC":U THEN
                 RUN CreateAttributeRow(pclevel,pdObj,cLabel,{&DECIMAL-DATA-TYPE},?,DEC(cValue),?,?,?,?).
              WHEN "INTEGER":U OR WHEN "INT":U THEN
                 RUN CreateAttributeRow(pclevel,pdObj,cLabel,{&INTEGER-DATA-TYPE},?,?,INT(cValue),?,?,?).
              WHEN "LOGICAL":U OR WHEN "LOG":U THEN
                RUN CreateAttributeRow(pclevel,pdObj,cLabel,{&LOGICAL-DATA-TYPE},?,?,?,LOGICAL(cValue),?,?).
              WHEN "DATE":U THEN
                RUN CreateAttributeRow(pclevel, pdObj,cLabel,{&DATE-DATA-TYPE}, ?, ?, ?, ?, DATE(cValue), ?).
            END CASE.
          END.  /* if an attribute was modified and overridden */
          ELSE 
            /* Override was de-selected to remove attribute */
             RUN DeleteAttributeRow (INPUT pclevel, INPUT  pdObj, INPUT cLabel)     .        

          hPropQuery:GET-NEXT().
       END. /* DO WHILE hPropBuffer:AVAIL */
       IF VALID-HANDLE(hPropQuery) THEN
          DELETE OBJECT hPropQuery NO-ERROR.
    END.  /* If hPropLib is valid */
 END.  /* if _h_menubar_proc is valid */ 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDynSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDynSDO Procedure 
PROCEDURE createDynSDO :
/*------------------------------------------------------------------------------
  Purpose:    If the Object is a DynSDO, create the Includefile 
             and the DataLogic procedure
              if the field _C._DATA-LOGIC-PROCEDURE is specified. 
  Parameters:  <none>
  Notes:      called from writeObjectToRepository 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cTableName            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTablesInSDO          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFirstEnabledTable    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOBJRelativeDir       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjRootDir           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBaseName             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cIncludeFileName      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFullPathIncludeFile  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE i                     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE ctemp                 AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLPProductModule     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLPFullName          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLPRootDir           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLPRelativeDir       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNotused              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cError                AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLProcType           AS CHARACTER  NO-UNDO INITIAL "DLProc":U.
 DEFINE VARIABLE cTableType            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTempTableDef         AS CHARACTER  NO-UNDO.



/* Default DLP is ValOnly */
 IF NOT glMigration THEN gcSuperPref = "ValOnly":U.

 FIND b_U WHERE RECID(b_U) = grQueryRecid.    /* _U of _query */
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
/* get the include file info */
 RUN calculateObjectPaths IN gshRepositoryManager 
            (INPUT  "":U,                  INPUT  _U._OBJECT-OBJ,           /* Object Name , Object _obj value  */
             INPUT  "":U,                  INPUT  _C._DATA-LOGIC-PROC-PMOD, /* Object Type ,Product Module      */
             INPUT  "Include":U,           INPUT  "":U,                     /* Object Parameter, Name space n.a */
             OUTPUT cOBJRootDir,           OUTPUT cOBJRelativeDir,          /* Root Dir, Relative dir           */
             OUTPUT gcSCMRelativeDir,      OUTPUT gcFullPathName,           /* SCM Relative dir, Full path Name */
             OUTPUT gcOutputObjectName,    OUTPUT cIncludeFileName,         /* Output Object Name, calculated file */
             OUTPUT cError) NO-ERROR.
 IF cError <> "":U THEN DO:
   RUN AppendToPError (cError).
   RETURN.
 END.
  
 IF glNewObject THEN  /* New SDO */
 DO:
   /* Check to see if a different root directory has been specified */
   RUN adecomm/_osprefx.p (INPUT _C._DATA-LOGIC-PROC,
                           OUTPUT cOBJRootDir,
                           OUTPUT cBaseName) NO-ERROR.

   ASSIGN cOBJRootDir     = TRIM(cOBJRootDir, "~/":U)
          cOBJRelativeDir = IF gcSCMRelativeDir > "" THEN gcSCMRelativeDir ELSE cOBJRelativeDir.
   IF cOBJRelativeDir NE "":U AND cOBJRootDir MATCHES "*~/":U + cObjRelativeDir THEN /* Strip off relative directory */
      ASSIGN cOBJRootDir = SUBSTRING(cOBJRootDir, 1, LENGTH(cOBJRootDir,"CHARACTER") -
                                     LENGTH("~/":U + cObjRelativeDir, "CHARACTER"),
                                     "CHARACTER").

   ASSIGN cIncludeFileName = (IF cOBJRootDir NE "":U THEN
                                RIGHT-TRIM(cOBJRootDir,"~/":U) + "~/":U ELSE "":U ) +
                             (IF cObjRelativeDir NE "":U THEN
                                RIGHT-TRIM(cObjRelativeDir, "~/":U) + "~/":U ELSE "":U) +
                             cIncludeFileName.
 END. /* If the Save-as-File has been specified */
 ELSE  /* If not a new SDO */
   ASSIGN cFullPathIncludeFile = SEARCH(RIGHT-TRIM(cObjRelativeDir, "~/":U)
                                          + "~/":U + cIncludeFileName)
          cIncludeFileName     =  IF cFullPathIncludeFile NE ? 
                                  THEN cFullPathIncludeFile ELSE RIGHT-TRIM(gcFullPathName,"~/":U) + "~/":U + cIncludeFileName.
 /* Write out the include file */
 OUTPUT STREAM P_4GLSDO TO VALUE(cIncludeFileName).
 FOR EACH _BC WHERE _BC._x-recid = RECID(b_U) BREAK BY _BC._SEQUENCE:
   IF _BC._DBNAME <> "_<CALC>":U THEN
     ASSIGN cTemp = "  FIELD ":U + _BC._DISP-NAME + " LIKE ":U +
              dbtt-fld-name(RECID(_BC)).
   ELSE
     ASSIGN cTemp   = "  FIELD ":U + _BC._DISP-NAME + " AS ":U + CAPS(_BC._DATA-TYPE)
            gcDBName = _BC._DBNAME.

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

 ASSIGN cDLPProductModule = IF _C._DATA-LOGIC-PROC-PMOD <> "":U 
                             THEN _C._DATA-LOGIC-PROC-PMOD ELSE gcOBJProductModule.
 RUN calculateObjectPaths IN gshRepositoryManager 
            (INPUT  _C._DATA-LOGIC-PROC,   INPUT  0.0,               /* Object Name , Object _obj value  */
             INPUT  "":U,                  INPUT  cDLPProductModule, /* Object Type ,Product Module      */
             INPUT  "":U,                  INPUT  "":U,              /* Object Parameter, Name space n.a */
             OUTPUT cDLPRootDir,           OUTPUT cOBJRelativeDir,   /* Root Dir, Relative dir           */
             OUTPUT gcSCMRelativeDir,      OUTPUT gcFullPathName,     /* SCM Relative dir, Full path Name */
             OUTPUT gcOutputObjectName,    OUTPUT gcDLPFileName,     /* Output Object Name, calculated file */
             OUTPUT cError) NO-ERROR.
 IF cError <> "":U THEN DO:
   RUN AppendToPError (cError).
   RETURN.
 END.
 ASSIGN cDLPRelativeDir =  IF gcSCMRelativeDir <> "":U 
                           THEN gcSCMRelativeDir ELSE cOBJRelativeDir
        cDLPFullName    = REPLACE(_C._DATA-LOGIC-PROC,"~\":U,"~/":U)
        cDLPRootDir     =  IF cDLPRootDir = ? OR cDLPRootDir = "?":U OR cDLPRootDir = "":U 
                           THEN DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, 'AB_source_code_directory') ELSE cDLPRootDir
        cDLPRootDir     =  IF cDLPRootDir = ? OR cDLPRootDir = "?":U OR cDLPRootDir = "":U THEN ".":U  ELSE cDLPRootDir
        NO-ERROR.
 /* Only generate the DLP if it's  a new object, else just register it */
 IF SEARCH(cDLPRelativeDir + "/":U + gcDLPFileName) EQ ? 
     AND _C._DATA-LOGIC-PROC NE "":U AND glnewObject     THEN   
 DO:
  /* Assign updatable fields for validation purposes */
   ASSIGN cFirstEnabledTable = gcTableList + CHR(1) + gcUpdColsByTable
          cDlProcType        = IF _C._DATA-LOGIC-PROC-TYPE > "" 
                               THEN  _C._DATA-LOGIC-PROC-TYPE ELSE cDlProcType.
      
   /* Construct the DEFINE TEMP-TABLE OR BUFFER statement to be passed to the DLP generator */   
   FOR EACH _TT WHERE _TT._p-recid = RECID(_P) :
     /* Check whether first table is a temp table or buffer */
     IF _TT._NAME = ENTRY(1,gcTableList) AND (_TT._TABLE-TYPE = "T":U OR _TT._TABLE-TYPE = "B":U ) THEN 
          cTableType =  _TT._TABLE-TYPE. 
     IF  _TT._TABLE-TYPE = "T":U THEN
        ASSIGN  cTempTableDef = cTempTableDef +  "DEFINE ":U 
                         + (IF _TT._SHARE-TYPE NE ""  THEN (_TT._SHARE-TYPE + " ":U) 
                                                      ELSE "") 
                         + "TEMP-TABLE " 
                         + (IF _TT._NAME = ? THEN _TT._LIKE-TABLE 
                                             ELSE _TT._NAME) 
                         + (IF _TT._UNDO-TYPE = "NO-UNDO":U THEN " NO-UNDO":U 
                                                            ELSE "":U) 
                         + " LIKE ":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE 
                         + (IF _TT._ADDITIONAL_FIELDS NE "":U THEN (CHR(10) + "       ":U 
                                                                   + REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),CHR(10) + "       ":U) + ".":U) 
                                                              ELSE ".") + CHR(10).

     ELSE IF  _TT._TABLE-TYPE = "B":U THEN
       ASSIGN cTempTableDef =  cTempTableDef + "&IF '~{&DB-REQUIRED~}' = 'TRUE' OR DEFINED~(DB-REQUIRED~) = 0  &THEN":U 
                       + CHR(10) + "DEFINE ":U 
                       + (IF _TT._SHARE-TYPE NE "" THEN (_TT._SHARE-TYPE + " ":U) 
                                                   ELSE "") 
                       + "BUFFER " + _TT._NAME +  " FOR ":U + _TT._LIKE-DB + ".":U 
                       + _TT._LIKE-TABLE + ".":U +  CHR(10) 
                       + "&ENDIF":U + CHR(10).
   END. /* End For each _TT */                        

   /* Get the correct RootDir */
   IF _C._DATA-LOGIC-PROC NE "":U THEN
     IF _C._DATA-LOGIC-PROC MATCHES "*~/":U + cDLPRelativeDir + "~/":U + gcDLPFileName THEN
       cDLPRootDir = SUBSTRING(_C._DATA-LOGIC-PROC, 1, LENGTH(_C._DATA-LOGIC-PROC, "CHARACTER") -
                               LENGTH("/":U + cDLPRelativeDir + "/":U + gcDLPFileName, "CHARACTER"),
                               "CHARACTER").
   /* Go ahead and generate the DLP */
   RUN generateDLP in THIS-PROCEDURE
        ( INPUT cFirstEnabledTable,           /* First enabled table name and updatable fields  */
          INPUT cTableType,                    /* Temp Table (T) , Buffer (B) or neither */
          INPUT gcOBJFileName,                 /* SDO Name            */
          INPUT cDLPProductModule,           /* product Module */
          INPUT gcDLPFileName,                /* Unqualified DLP file name */
          INPUT cDlProcType,                  /* Object Type (Default= DLProc)        */
          INPUT "ry/obj/rytemlogic.p",        /* Template            */
          INPUT cOBJRelativeDir,              /* SDO    relative */
          INPUT cDLPRelativeDir,              /* DLProc relative */
          INPUT cDLPRootDir,                  /* Root Directory  */
          INPUT NO         ,                   /* Don't create Folder */
          INPUT cTempTableDef
          ) NO-ERROR.
   IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
     RUN AppendToPError (RETURN-VALUE).
     RETURN.
   END.
   IF glMigration AND gcSuperPref NE "StandVal":U THEN 
   DO:
       RUN processMigratedSDO IN THIS-PROCEDURE (INPUT cDLPRootDir, INPUT cDLPRelativeDir, INPUT gcDLPFileName). 
       IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
   END.

 END. /* End only generate the DLP if it's  a new object */

  /* Always recompile the logic procedure (unless migrating because we just compiled it) */
 IF NOT glMigration AND SEARCH(cDLPRelativeDir + "~/":U + gcDLPFileName) NE ? THEN 
 DO:
   COMPILE VALUE(cDLPRelativeDir + "~/":U + gcDLPFileName) SAVE.
   COMPILE VALUE(cDLPRelativeDir + "~/":U +
                 REPLACE(gcDLPFileName,".p":U,"_cl.P":U)) SAVE.
 END.

 /* Generate any calculated fields in the repository */
 FOR EACH _BC WHERE _BC._x-recid = RECID(b_U) AND _BC._DBNAME = "_<CALC>":U:
   RUN generateCalculatedField IN ghRepDesignManager
     (INPUT _BC._DISP-NAME,     /* calcFieldName   */
      INPUT _BC._DATA-TYPE,     /* Data Type       */
      INPUT _BC._FORMAT,        /* Format          */
      INPUT _BC._LABEL,         /* Label           */
      INPUT _BC._HELP,          /* Help            */
      INPUT gcOBJProductModule,  /* Product Module  */
      INPUT "":U,               /* Result Code     */
      INPUT "CalculatedField":U) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
     RUN AppendToPError (RETURN-VALUE).
     RETURN.
    END.

   ASSIGN _BC._STATUS = "UPDATE,":U + _BC._DISP-NAME.
 END.  /* for each calc field */
     
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMasterAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createMasterAttributes Procedure 
PROCEDURE createMasterAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Inserts master object in repository and sets attribtues
  Parameters:  <none>
  Notes:       called from writeObjectToRepository
------------------------------------------------------------------------------*/
 IF _U._OBJECT-OBJ = 0 THEN DO:  /* If it doesn't exist */ 
      /* Work around until new API is complete, this establishes the internal structure */
      DEFINE VARIABLE hTmp AS HANDLE     NO-UNDO.
      ASSIGN hTmp       = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
             glnewObject = YES.
             
      
      RUN insertObjectMaster IN ghRepDesignManager
        ( INPUT gcOBJFileName,            /* Object Name                         */
          INPUT "":U,                    /* Master Layout Result Code           */
          INPUT gcOBJProductModule,       /* The Product Module                  */
          INPUT gcObjClassType,           /* Object Type Code                    */
          INPUT gcObjectDescription,      /* Description                         */
          INPUT "":U,                    /* Path                                */
          INPUT gcSDORepos,               /* Associated SDO                      */
          INPUT "":U,                    /* SuperProcedure Name                 */
          INPUT NO,                      /* Not a template                      */
          INPUT NO,                      /* Treat as a static object            */
          INPUT "":U,                    /* Rendering Engine (Use Default)      */
          INPUT NO,                      /* Doesn't need to be run persistently */
          INPUT _U._TOOLTIP,             /* Tooltip                             */
          INPUT "":U,                    /* Required DB List                    */
          INPUT "":U,                    /* LayoutCode                          */
          INPUT hTmp,                    /* Attr Table Buffer handle            */
          INPUT TABLE-HANDLE ghUnknown,   /* Table handle for attribute table    */
          OUTPUT gdDynamicObj) NO-ERROR.  /* Obj number for this object          */

      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
        RUN AppendToPError (RETURN-VALUE).
        RETURN.
      END.
      ASSIGN _U._OBJECT-OBJ = gdDynamicObj.
     
     IF NOT CAN-FIND(FIRST tResultCodes WHERE tResultCodes.cRC = "") THEN
     DO:
        CREATE tResultCodes.
        ASSIGN tResultCodes.cRC = "":U
               tResultCodes.dContainerObj = gdDynamicObj.
     END.          
    END.  /* If the object didn't exist */

    ELSE DO:  /* Else works because if it is new, there are no attributes 
                 to delete and the insert did all added attribute records */
      /* If we are setting something back to its default value */
      IF CAN-FIND(FIRST DeleteAttribute) THEN DO:
        hTmp = TEMP-TABLE DeleteAttribute:DEFAULT-BUFFER-HANDLE.
        RUN RemoveAttributeValues IN ghRepDesignManager
           (INPUT hTmp,
            INPUT TABLE-HANDLE ghUnknown) NO-ERROR.     
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
          RUN AppendToPError (RETURN-VALUE).
          RETURN.
        END.
        EMPTY TEMP-TABLE DeleteAttribute.
      END.  /* If there are any records */

      hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
      RUN StoreAttributeValues IN gshRepositoryManager
          (INPUT hTmp ,
           INPUT TABLE-HANDLE ghUnknown) NO-ERROR.  /* Compiler requires a variable with unknown */
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
          RUN AppendToPError (RETURN-VALUE).
          RETURN.
      END.

      /*  dSmartObject = _U._OBJECT-OBJ.  This was removed as it was never referenced */
      IF NOT CAN-FIND(FIRST tResultCodes WHERE tResultCodes.cRC = "") THEN
      DO:
        CREATE tResultCodes.
        ASSIGN tResultCodes.cRc = "":U
               tResultCodes.dContainerObj = _U._OBJECT-OBJ.
      END.         
    END.
    IF gdDynamicObj > 0 THEN     /*  store the Object_obj in the _P record */
     ASSIGN _P.Smartobject_obj = gdDynamicObj.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSBODLP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createSBODLP Procedure 
PROCEDURE createSBODLP :
/*------------------------------------------------------------------------------
  Purpose:     To create the DLP of an SBO
  
  Parameters:
    INPUT pcDLPName    - The name of the DLP
    INPUT prURecid     - Recid of the top level SBO _U
          
      Notes:   called from processMigratedSBO
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
    END. /* When state 5 */

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
        INPUT pdInputObj             - Object id of the SmartObject or Instance
        INPUT pcAttributeLabel     - Label of the attribute to set
        
  Notes:  This temp-table is passed to RemoveAttributeValues in the design
          manager to actually remove the the attributes
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectLevel      AS CHARACTER              NO-UNDO.
  DEFINE INPUT  PARAMETER pdInputObj         AS DECIMAL                NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeLabel   AS CHARACTER              NO-UNDO.

  CREATE DeleteAttribute.
  ASSIGN DeleteAttribute.tAttributeParent    = pcObjectLevel
         DeleteAttribute.tAttributeParentObj = pdInputObj
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
  Notes:  called from writeObjectToRepository 2x
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_URecid           AS RECID                  NO-UNDO.
  DEFINE INPUT  PARAMETER pcCode             AS CHARACTER              NO-UNDO.

  DEFINE VARIABLE cFont  AS CHARACTER  INITIAL "?"  NO-UNDO.

  DEFINE BUFFER b_U FOR _U.
  DEFINE BUFFER b_C FOR _C.

  /* Create some attribute records to set when we create this master viewer */
  /* Calculate MinHeight and MinWidth */
  ASSIGN gdMinHeight = 0
         gdMinWidth  = 0.
  FIND _U WHERE RECID(_U) = p_URecid.

  FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                     b_U._STATUS = "Normal":U:

     IF gcClassName = "DynBrow":U AND b_U._TYPE = "BROWSE":U THEN 
         grBrowseRecid = RECID(b_U).
     ELSE IF gcClassName = "DynView":U AND b_U._TYPE = "FRAME":U THEN 
         grFrameRecid = RECID(b_U).
     ELSE IF gcClassName = "DynSDO":U AND b_U._TYPE = "Query":U THEN 
         grQueryRecid = RECID(b_U).

     FIND _L WHERE _L._LO-NAME = pcCode AND 
                   _L._u-recid = RECID(b_U) NO-ERROR.

     IF AVAILABLE _L THEN 
     DO:
        IF b_U._TYPE NE "FRAME":U AND b_U._TYPE NE "WINDOW":U AND
           b_U._TYPE NE "QUERY":U THEN
          ASSIGN gdMinHeight = MAX(gdMinHeight, _L._ROW -
                                 (IF gcClassName = "DynBrow":U THEN 1 ELSE 0)
                                           + _L._Height)
                 gdMinWidth  = MAX(gdMinWidth, _L._COL -
                                 (IF gcClassName = "DynBrow":U THEN 1 ELSE 0)
                                  + _L._WIDTH).
        ELSE IF b_U._TYPE = "QUERY" THEN
          ASSIGN gdMinHeight = MAX(gdMinHeight, _L._Height)
                 gdMinWidth  = MAX(gdMinWidth, _L._WIDTH).
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
            ASSIGN gdMinHeight = _L._HEIGHT
                   gdMinWidth  = _L._WIDTH.
        END.  /* If a Frame */
     END. /* IF available _L */
  END. /* For each object in this window, glean necessary info */

  /* Store MinHeight and MinWidth in frame's _L */
  FIND _L WHERE _L._LO-NAME = pcCode AND _L._u-recid = grFrameRecid NO-ERROR.
  IF AVAILABLE _L THEN
    ASSIGN _L._HEIGHT = gdMinHeight
           _L._WIDTH  = gdMinWidth.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateDLP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDLP Procedure 
PROCEDURE generateDLP :
/*------------------------------------------------------------------------------
  Purpose:     Generates the DLP for the SDO, compiles it and registers it.
  Parameters:  pcTableName               Comma delimited list of supported tables OR 
                     can also contain enabled fields in the format:  
                     Table1,Table2,... CHR(1) field1,field2,field3...CHR(1)field1,field2,..
                     The first list of fields (after the chr(1) delim) corresponds to Table1, etc..
               pcTableType               T - TempTable 
                                         B - Buffer    
                  (if either a temp table or buffer, no validation is perfromed)
               pcDataObjectName          Name of SDO object 
               pcProductModule           Product module of DLP
               pcLogicProcedureName      Name of new logic procedure to be created
               pcLogicObjectType         Logic type of new procedure (i.e. DLCProc)
               pcLogicProcedureTemplate  Template file to base DLP
               pcDataObjectRelativePath  Relative path of SDO
               pcDataLogicRelativePath   Relative path of object to be saved
               pcRootFolder              Root directory   (i.e. "C:\workarea")
               plCreateMissingFolder     Yes.  Create new directory if it doesn't exist
               pcTempTableDef            Temp Table or Buffer definition statement
               
    Notes:    called from  createDynSDO          
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcTableName              AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcTableType              AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcDataObjectName         AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcProductModule          AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcLogicProcedureName     AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcLogicObjectType        AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcLogicProcedureTemplate AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcDataObjectRelativePath AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcDataLogicRelativePath  AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcRootFolder             AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER plCreateMissingFolder    AS LOGICAL    NO-UNDO.
 DEFINE INPUT PARAMETER pcTempTableDef           AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE hAttributeBuffer                AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hAttributeTable                 AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cAbsolutePathedName             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCompileError                   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRelativelyPathedName           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDefinitionIncludeName          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOldPropath                     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValidationFields               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValidateFrom                   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iLoop2                          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cValidateCheck                  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewValidateCheck               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFieldList                      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFieldListEntry                 AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTableList                      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hObjectBuffer                   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hObjectQuery                    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cMasterObject                   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMasterDataType                 AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMasterLabel                    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lMasterMandatory                AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE dRecordIdentifier               AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE cMandatoryList                  AS CHARACTER  NO-UNDO.

 /* Ensure the data logic procedure contains a .p extension */
 IF NUM-ENTRIES(pcLogicProcedureName,".") < 2 THEN
    ASSIGN pcLogicProcedureName = pcLogicProcedureName + ".p":U.

 /* Create Logic Procedure */
 IF pcDataLogicRelativePath = "/":U OR pcDataLogicRelativePath = "~\":U  OR pcDataLogicRelativePath = "":U THEN 
    ASSIGN cRelativelyPathedName = pcLogicProcedureName
           cAbsolutePathedName   = RIGHT-TRIM(pcRootFolder,"/":U)  + "/":U + pcLogicProcedureName .
 ELSE
    ASSIGN cRelativelyPathedName = RIGHT-TRIM(pcDataLogicRelativePath,"/":U) + "/":U + pcLogicProcedureName
           cAbsolutePathedName   = RIGHT-TRIM(pcRootFolder,"/":U) + "/":U + RIGHT-TRIM(pcDataLogicRelativePath,"/":U)
                                                                  + "/":U + pcLogicProcedureName
                           .
 IF pcDataObjectRelativePath = "/":U OR pcDataObjectRelativePath = "~\":U OR pcDataObjectRelativePath = "":U THEN
   ASSIGN  cDefinitionIncludeName = IF INDEX(pcDataObjectName,".w":U) > 0
                                     THEN REPLACE(pcDataObjectName,".w":U,".i":U)
                                     ELSE pcDataObjectName + ".i":U.
 ELSE
   ASSIGN  cDefinitionIncludeName = RIGHT-TRIM(pcDataObjectRelativePath,"/":U)  + "/":U
                                        + IF INDEX(pcDataObjectName,".w":U) > 0
                                          THEN REPLACE(pcDataObjectName,".w":U,".i":U)
                                          ELSE pcDataObjectName + ".i":U.

 /* See if there are any overrides to the standard behaviour that determines how the rowObjectValidate 
  * procedure is built. By default, both fields that are mandatory and fields that are part of an index 
  * have code added to rowObjectValidate that will ensure that they are not left blank.                            
  *
  * This behaviour can be overridden by setting the OG_ValidateFrom session parameter to contain a CSV list 
  * of values that determine which fields are to be used as part of the rowObjectvalidate procedure. */
 ASSIGN cValidateFrom = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE, INPUT "OG_ValidateFrom":U).
 IF cValidateFrom EQ ? THEN
     ASSIGN cValidateFrom = "*":U.

 /* Since the parameter pcTablename can also contain enabled fields, check whether this is so */
 IF NUM-ENTRIES(pcTableName,CHR(1)) > 1 THEN
    ASSIGN cTableList = ENTRY(1,pcTableName,CHR(1))
           cFieldList = SUBSTRING(pcTableName,INDEX(pcTableName,CHR(1)) + 1).
 ELSE
    ASSIGN cTableList = pcTableName
           cFieldList = "".

 /* We need to derive the index fields and generate list */
 IF pcTableType = "" AND CAN-DO(cValidateFrom,"INDEX":U) THEN
 DO:
    /* IF passing only table names */
    IF cFieldList = "" THEN
    DO iLoop = 1 to NUM-ENTRIES(cTableList):
            cValidationFields = cValidationFields + (IF cValidationFields = "" then "" else CHR(1))
                                   +  DYNAMIC-FUNCTION("getIndexFieldsUnique":U IN ghRepDesignManager, INPUT ENTRY(iLoop,cTableList)).
    END.        
    ELSE DO:  /* If passing table names and field names */
       DO iLoop = 1 to NUM-ENTRIES(cFieldList,CHR(1)):
          ASSIGN cFieldListEntry = ENTRY(iLoop,cFieldList,CHR(1)) NO-ERROR.
                 cValidateCheck     = DYNAMIC-FUNCTION("getIndexFieldsUnique":U in ghRepDesignManager, INPUT ENTRY(iLoop,cTableList)).
          /* IF the pcTableName is being used to pass a list of enabled fields, ensure 
             the index field is contained in this list */
          ASSIGN 
              cNewValidateCheck = cNewValidateCheck + (IF cNewValidateCheck = "" then "" else CHR(1)).
              DO iLoop2 = 1 to NUM-ENTRIES(cValidateCheck,CHR(2)) BY 3:
                 IF LOOKUP(ENTRY(iLoop2,cValidateCheck,CHR(2)),cFieldListEntry) > 0 THEN
                    cNewValidateCheck = cNewValidateCheck + (IF cNewValidateCheck = "" then "" else CHR(2))
                                             + ENTRY(iLoop2,cValidateCheck,CHR(2)) +  CHR(2) 
                                             + ENTRY(iLoop2 + 1,cValidateCheck,CHR(2)) + CHR(2) 
                                             + ENTRY(iLoop2 + 2,cValidateCheck,CHR(2))  .
              END.
       END.
       ASSIGN cValidationFields = cNewValidateCheck.
    END.   
 END.

 /* Now derive the mandatoy fields from the repository*/
 IF pcTableType = "" AND CAN-DO(cValidateFrom,"MANDATORY":U) THEN
 DO iLoop = 1 to NUM-ENTRIES(cTableList):
    RUN retrieveDesignObject IN ghRepDesignManager 
                                     ( INPUT  ENTRY(iLoop,cTableList),
                                       INPUT  "":U ,
                                       OUTPUT TABLE ttObject,
                                       OUTPUT TABLE ttPage,
                                       OUTPUT TABLE ttLink,
                                       OUTPUT TABLE ttUiEvent,
                                       OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 
    /* Get all object instances */
    FOR EACH  ttObject WHERE ttObject.tLogicalObjectName        =  ENTRY(iLoop,cTableList) 
                         AND ttObject.tContainerSmartObjectObj = 0 :
       ASSIGN cMandatoryList = ""
              cMasterObject = ttObject.tLogicalObjectName.
      
        /* Strip off the table name */
       ASSIGN cMasterObject    = ENTRY(NUM-ENTRIES(cMasterObject,"."),cMasterObject,".") 
              lMasterMandatory = FALSE.
         
       FIND ttObjectAttribute  WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                 AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                 AND ttObjectAttribute.tAttributeLabel    = "DATA-TYPE":U NO-ERROR.
       IF AVAIL ttObjectAttribute THEN
          cMasterDataType = ttObjectAttribute.tAttributeValue.
       ELSE DO:
          FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                   AND ttObjectAttribute.tObjectInstanceObj = 0
                                   AND ttObjectAttribute.tAttributeLabel    = "DATA-TYPE":U NO-ERROR.
          IF AVAIL ttObjectAttribute THEN
             cMasterDataType = ttObjectAttribute.tAttributeValue.
       END.

       FIND ttObjectAttribute  WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                 AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                 AND ttObjectAttribute.tAttributeLabel    = "LABEL":U NO-ERROR .
       IF AVAIL ttObjectAttribute THEN
          cMasterLabel = ttObjectAttribute.tAttributeValue.
       ELSE DO:
          FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                   AND ttObjectAttribute.tObjectInstanceObj = 0
                                   AND ttObjectAttribute.tAttributeLabel    = "LABEL":U NO-ERROR.
          IF AVAIL ttObjectAttribute THEN
             cMasterLabel = ttObjectAttribute.tAttributeValue.
       END.
       FIND ttObjectAttribute  WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                 AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                 AND ttObjectAttribute.tAttributeLabel    = "Mandatory":U NO-ERROR.
       IF AVAIL ttObjectAttribute THEN
          lMasterMandatory = LOGICAL(ttObjectAttribute.tAttributeValue) NO-ERROR.
       ELSE DO:
          FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                   AND ttObjectAttribute.tObjectInstanceObj = 0
                                   AND ttObjectAttribute.tAttributeLabel    = "Mandatory":U NO-ERROR.
          IF AVAIL ttObjectAttribute THEN
             lMasterMandatory = LOGICAL(ttObjectAttribute.tAttributeValue).
       END.

         IF lMasterMandatory THEN 
            IF cFieldList = "" OR (cFieldList  > "" AND LOOKUP(cMasterObject, cFieldList) > 0 )THEN
                cMandatoryList  = cMandatoryList + (IF cMandatoryList = "" THEN "" ELSE CHR(2))
                                                 + cMasterObject + CHR(2) + cMasterDataType + CHR(2) 
                                                 + (IF cMasterLabel = ? THEN cMasterObject ELSE cMasterLabel).
    END.  /* End fOR EACH ttObject */

   IF cMandatoryList > "" THEN
   DO:
     IF NUM-ENTRIES(cValidationFields,CHR(1)) = NUM-ENTRIES(cTableList) THEN
        ENTRY(iLoop,cValidationFields,CHR(1)) = ENTRY(iLoop,cValidationFields,CHR(1)) 
                                                + (IF ENTRY(iLoop,cValidationFields,CHR(1)) = "" THEN "" ELSE CHR(2))
                                                + cMandatoryList.
     ELSE
       cValidationFields = cValidationFields + (IF cValidationFields = "" THEN "" ELSE CHR(1))
                                                + cMandatoryList.
   END.

 END.     /* End DO iLoop per table */ 

 /* Run static sdo Data Logic file generator */
 RUN af/app/afgendlogp.p ( INPUT cRelativelyPathedName,
                           INPUT (RIGHT-TRIM(pcRootFolder,"/":U) + "/":U ),
                           INPUT pcLogicProcedureTemplate,
                           INPUT cTableList,
                           INPUT cFieldList,
                           INPUT cValidationFields,
                           INPUT cDefinitionIncludeName,
                           INPUT plCreateMissingFolder   ,
                           INPUT NO,
                           INPUT pcTempTableDef) NO-ERROR.

 IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
     RUN AppendToPError (RETURN-VALUE).
     RETURN.
 END.
 
 /** Compile the objects just created.
  *  ----------------------------------------------------------------------- **/
 /* Make sure that the root folder is in the PROPATH */
 ASSIGN
   cOldPropath = PROPATH.

 ASSIGN
   PROPATH = pcRootFolder + (IF INDEX(PROPATH, ";":U) GT 0 THEN ";":U ELSE ",":U) + PROPATH.

 IF SEARCH(cAbsolutePathedName) EQ ?
 THEN
   RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure: ' + cAbsolutePathedName"}.

 COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.

 ASSIGN cAbsolutePathedName = REPLACE(cAbsolutePathedName, ".p":U, "_cl.p":U).

 IF SEARCH(cAbsolutePathedName) EQ ?
 THEN
   RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure client proxy: ' + cAbsolutePathedName"}.        

 COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.

 IF COMPILER:ERROR THEN
   cCompileError = "Compiling of DataLogic Client Proxy Failed : " + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).

 /* Reset the PROPATH. */
 ASSIGN PROPATH = cOldPropath.

 /* Generate the Logic Procedure Object */
 /* There are currently no attributes for this object. */
 ASSIGN hAttributeBuffer = ?
        hAttributeTable  = ?
        .

 RUN insertObjectMaster IN ghRepDesignManager
                        ( INPUT  pcLogicProcedureName,
                          INPUT  "",                                    /* pcResultCode         */
                          INPUT  pcProductModule,                        /* pcProductModuleCode  */
                          INPUT  pcLogicObjectType,                      /* pcObjectTypeCode     */
                          INPUT  "Logic Procedure for ":U 
                                          + ENTRY(1,pcTablename,CHR(1)), /* pcObjectDescription  */
                          INPUT  pcDataLogicRelativePath,                /* pcDataLogicRelativePath */ 
                          INPUT  pcDataObjectName,                       /* pcSdoObjectName      */
                          INPUT  "":U,                                   /* pcSuperProcedureName */
                          INPUT  NO,                                     /* plIsTemplate         */
                          INPUT  YES,                                    /* plIsStatic           */
                          INPUT  "":U,                                   /* pcPhysicalObjectName */
                          INPUT  NO,                                     /* plRunPersistent      */
                          INPUT  "":U,                                   /* pcTooltipText        */
                          INPUT  "":U,                                   /* pcRequiredDBList     */
                          INPUT  "":U,                                   /* pcLayoutCode         */
                          INPUT  hAttributeBuffer,
                          INPUT  TABLE-HANDLE hAttributeTable,
                          OUTPUT dSmartObjectObj
                          ) NO-ERROR.

 IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
     RUN AppendToPError (RETURN-VALUE).
     RETURN.
 END.

 IF cCompileError NE "":U THEN 
  RETURN cCompileError.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataSource Procedure 
PROCEDURE getDataSource :
/*------------------------------------------------------------------------------
  Purpose:     Start the Associated SDO
  Parameters:  <none>
  Notes:    Called from writeFieldLevelObjects   
------------------------------------------------------------------------------*/
 DEFINE OUTPUT PARAMETER pcDataSourceType AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER pcTableList      AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER pcAssignList     AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER phDataSource     AS HANDLE     NO-UNDO.
 DEFINE OUTPUT PARAMETER pcSDOList        AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cError         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataSource    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDSLogicalName AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lIsSDO         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE dObjectObj     AS DECIMAL    NO-UNDO.
 
 cDataSource = _P._DATA-OBJECT.
 RUN StartDataObject IN gshRepositoryManager (INPUT cDataSource, OUTPUT phDataSource) NO-ERROR.
 IF phDataSource = ? AND NUM-ENTRIES(cDataSource, ".":U) > 1 
             AND ENTRY(2, cDataSource, ".":U) = "w":U THEN /* Try again without the extension */
   RUN StartDataObject IN gshRepositoryManager (INPUT ENTRY(1, cDataSource, ".":U), OUTPUT phDataSource) NO-ERROR.

 /* It may be static and not registered */
 IF phDataSource = ? THEN 
 DO:
   IF SEARCH(cDataSource) = ? THEN 
   DO:
     cDataSource = ryc_smartobject.object_path + (IF ryc_smartobject.object_path = "" THEN "" ELSE "/") 
                                               + cDataSource.
     IF SEARCH(cDataSource) = ? THEN
     DO:  /* Give up */
        cError = {af/sup2/aferrortxt.i 'RY' '16' '?' '?' "gcSDOName"}.
        RUN AppendToPError (INPUT cError).
        RETURN.
     END.
   END.  /* If we can't find the file as is */

   /* Only get here if SEARCH is successful */
   RUN VALUE(SEARCH(cDataSource)) PERSISTENT SET phDataSource NO-ERROR.
   IF NOT VALID-HANDLE(phDataSource) THEN 
   DO:
     cError = {af/sup2/aferrortxt.i 'RY' '17' '?' '?' "gcSDOName"}.
     RUN AppendToPError (INPUT cError).
     RETURN.
   END.
   RUN CreateObjects IN phDataSource NO-ERROR.
 END. /* End If sdo handle isn't valid */

 /* Get the logical name of the datasource */
 cDSLogicalName = REPLACE(cDataSource, "~\":U, "~/":U).
 cDSLogicalName = ENTRY(1, ENTRY(NUM-ENTRIES(cDSLogicalName, "~/":U), cDSLogicalName, "~/":U), ".":U).

 /* Data Source is either some kind of SDO (extends class DATA) or SBO (extends class container) */
 dObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN ghRepDesignManager, INPUT cDSLogicalName, INPUT 0) NO-ERROR.
 lIsSDO = DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager, dObjectObj, "Data":U).
 IF lIsSDO = ? THEN DO: /* This object isn't in the repository, ask it what it is */
   pcDataSourceType = DYNAMIC-FUNCTION("getObjectType":U IN phDataSource).
   pcDataSourceType = IF pcDataSourceType = "SmartBusinessObject":U THEN "SBO":U ELSE "SDO":U.
 END. /* When not found in the repository */
 ELSE
   pcDataSourceType = IF lIsSDO THEN "SDO":U ELSE "SBO":U.
 
 IF pcDataSourceType = "SDO":U THEN
   ASSIGN gcDBName     = DYNAMIC-FUNCTION("getDBNames":U IN phDataSource)
          pcTableList  = DYNAMIC-FUNCTION("getPhysicalTables":U IN phDataSource)
          pcAssignList = DYNAMIC-FUNCTION("getAssignList":U IN phDataSource) NO-ERROR.
 ELSE DO:  /* SBOs work differently */
   ASSIGN gcDBName     = "TEMP-TABLES":U
          pcTableList  = "":U.

   /* Scan Datafields in the viewer to create a list of SDOs used by the viewer */
   FOR EACH  b_U WHERE b_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                       b_U._STATUS = "NORMAL":U AND
                       NOT b_U._NAME BEGINS "_LBL-":U AND
                       b_U._DBNAME = "TEMP-TABLES":U:
     IF LOOKUP(b_U._TABLE, pcSDOList) = 0 THEN
       pcSDOList = pcSDOList + ",":U + b_U._TABLE.
   END.  /* For each datafield in the viewer */

   ASSIGN pcSDOList    = LEFT-TRIM(pcSDOList, ",":U)
          pcAssignList = pcSDOList.
 END.  /* Else an SBO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processAttachedSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processAttachedSDO Procedure 
PROCEDURE processAttachedSDO :
/*------------------------------------------------------------------------------
  Purpose:  Make sure the associated SDO is registered in the repository. 
            Get the SDO name without the extension and path name.  This works with 
            a V9 SDV. 
  Parameters:  <none>
  Notes:    Called from WriteRepositoryObject   
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cSavedpath       AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE cSDOFileName     AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE hDO              AS HANDLE      NO-UNDO.
 DEFINE VARIABLE cDataObjectType  AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE cPM              AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE cReason          AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE hAttributeBuffer AS HANDLE      NO-UNDO.
 DEFINE VARIABLE hAttributeTable  AS HANDLE      NO-UNDO.
 DEFINE VARIABLE dDlObj           AS DECIMAL     NO-UNDO.
 DEFINE VARIABLE cError           AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE cLookupVal       AS CHARACTER   NO-UNDO.

 RUN adecomm/_osprefx.p (INPUT _P._data-object, OUTPUT cSavedPath, OUTPUT cSDOFileName) NO-ERROR.
 ASSIGN gcSDOName = ENTRY(1, cSDOFileName, ".":U).
 /* Look to see if the SDO is already registered */
 FIND ryc_smartobject NO-LOCK
   WHERE ryc_smartobject.object_filename =  ENTRY(1, cSDOFileName, ".":U) NO-ERROR.
 IF AVAILABLE ryc_smartobject THEN ASSIGN gcSDORepos = ryc_smartobject.object_filename.

 IF gcSDORepos = "":U THEN
    FIND ryc_smartobject NO-LOCK  
         WHERE ryc_smartobject.object_filename = cSDOFileName NO-ERROR.
 IF AVAILABLE ryc_smartobject THEN ASSIGN gcSDORepos = ryc_smartobject.object_filename.

 IF gcSDORepos = "":U THEN 
 DO:
   /* Is this an SDO or an SBO?  Since it isn't registered, we have to run it to find out */
   RUN value(SEARCH(_P._data-object)) PERSISTENT SET hDO NO-ERROR.
   cDataObjectType = "":U.
   IF VALID-HANDLE(hDO) THEN 
   DO:
     cDataObjectType = DYNAMIC-FUNCTION("getObjectType":U IN hDO).
     RUN destroyObject IN hDO NO-ERROR.
     IF VALID-HANDLE(hDO) THEN DELETE OBJECT hDO.
   END.

   /* set-up real object type as defined in repository */
   IF cDataObjectType = "SmartDataObject":U  THEN
       ASSIGN cDataObjectType = "SDO":U.
   ELSE IF cDataObjectType = "SmartBusinessObject":U THEN
       ASSIGN cDataObjectType = "SBO":U.
   
   /* Check to see if DataObject is in the right path before registering it */
   IF glMigration THEN DO: /* Establish User preference for PM */
     /* gcObjClassType is the preferred subClass to create */
     cLookupVal = IF cDataObjectType = "SDO":U  THEN "SDO_PM":U ELSE
                  "SBO_PM":U.
     cPM = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                             cLookupVal,
                             gcProfileData,
                             TRUE,
                             CHR(3)).
   END. /* If migrating */
   ELSE cPM = gcOBJProductModule.

   RUN checkStaticObjectPath(_P._data-object, cPM, OUTPUT cReason).
   IF cReason NE "":U THEN DO:
     cReason = "Associated datasource " + cReason.
     RUN AppendToPError (INPUT cReason).
   END.
   ELSE DO:
     /* Call Dynamics procedure to save static object to repository. You'll see
        a similar call in save_window_static  IN _h_uib. */
     RUN insertObjectMaster IN ghRepDesignManager 
         ( INPUT  _P._data-object,                /* pcObjectName         */
           INPUT  "":U,                           /* pcResultCode         */
           INPUT  cPM,                            /* pcProductModuleCode  */
           INPUT  cDataObjectType,                /* pcObjectTypeCode     */
           INPUT  "From data.w - Template for SmartDataObjects in the ADM":U, 
                                                  /* pcObjectDescription  */
           INPUT  "":U,                           /* pcObjectPath         */
           INPUT  "":U,                           /* pcSdoObjectName      */
           INPUT  "":U,                           /* pcSuperProcedureName */
           INPUT  NO,                             /* plIsTemplate         */
           INPUT  YES,                            /* plIsStatic           */
           INPUT  "":U,                           /* pcPhysicalObjectName */
           INPUT  NO,                             /* plRunPersistent      */
           INPUT  "":U,                           /* pcTooltipText        */
           INPUT  "":U,                           /* pcRequiredDBList     */
           INPUT  "":U,                           /* pcLayoutCode         */
           INPUT  hAttributeBuffer,
           INPUT  TABLE-HANDLE hAttributeTable,
           OUTPUT dDlObj                                   ) NO-ERROR.

     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
       cReason = RETURN-VALUE.
       RUN AppendToPError (RETURN-VALUE).
     END.

     IF dDlObj NE 0 AND _P.deployment_type NE "" THEN DO:
       RUN updateDeploymentType IN ghRepDesignManager (INPUT dDlObj, 
                                                       INPUT _P.deployment_type) NO-ERROR.
       IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
         cReason = RETURN-VALUE.
         RUN AppendToPError (INPUT cReason).
       END.
     END.

     IF (cReason <> "") THEN
     DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
       cError = {af/sup2/aferrortxt.i 'RY' '19' '?' '?' "_P._data-object"}.
       RUN AppendToPError (INPUT cError).
     END.  /* If an error regisitering the SDO */
     ELSE DO:
        ASSIGN gcSDORepos = REPLACE(_P._data-object, "~\":U, "~/":U)
               gcSDORepos = ENTRY(NUM-ENTRIES(gcSDORepos, "~/":U), gcSDORepos, "~/":U).
        FIND ryc_smartobject NO-LOCK
           WHERE ryc_smartobject.OBJECT_filename = gcSDORepos NO-ERROR.
        IF NOT AVAILABLE ryc_smartobject AND NUM-ENTRIES(gcSDORepos, ".":U) = 2 THEN
          FIND ryc_smartobject NO-LOCK
             WHERE ryc_smartobject.OBJECT_filename = ENTRY(1,gcSDORepos,".":U)
               AND ryc_smartobject.object_extension = entry(2,gcSDORepos,".":U)  NO-ERROR.
     END.  /* If no error */
   END.  /* If we registered the DataObject */
 END.  /* If need to register the SDO */
 
 
  
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
        INPUT pcObjectLevel  - MASTER or INSTANCE
        INPUT pdInputObj    - Object id of the SmartObject
        INPUT r_LRECID      - Recid of the custom _L
        
  Notes: called from setObjectInstanceAttributes & setObjectMasterAttributes
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectLevel AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pdInputObj    AS DECIMAL     NO-UNDO.
  DEFINE INPUT  PARAMETER r_LRECID      AS RECID       NO-UNDO.

  DEFINE BUFFER b_L FOR _L.
  DEFINE BUFFER b_U  FOR _U.
  DEFINE BUFFER m_L FOR _L.
  /* If we are working on a custom layout remove all attributes that are the same a in
     the default layout ... based on the _L records                                  */   
  FIND _L  WHERE RECID(_L) = r_LRECID.
  FIND b_U WHERE RECID(b_U) = _L._u-recid.
  FIND b_L WHERE b_L._LO-NAME = _L._BASE-LAYOUT AND b_L._u-recid = _L._u-recid NO-ERROR.
  IF NOT AVAILABLE b_L THEN /* Possibly could have been deleted */
     FIND b_L WHERE b_L._LO-NAME = "Master Layout":U AND b_L._u-recid = _L._u-recid.
  FIND m_L WHERE m_L._LO-NAME = "Master Layout":U AND m_L._u-recid = _L._u-recid.   

  IF _L._BGCOLOR = b_L._BGCOLOR AND NOT m_L._REMOVE-FROM-LAYOUT THEN
    RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "BGCOLOR":U).
  ELSE IF _L._BGCOLOR NE b_L._BGCOLOR THEN
    RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "BGCOLOR":U,{&INTEGER-DATA-TYPE},?,?,_L._BGCOLOR,?,?,?).

  IF _L._FGCOLOR = b_L._FGCOLOR AND NOT m_L._REMOVE-FROM-LAYOUT THEN 
    RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "FGCOLOR":U).
  ELSE IF _L._FGCOLOR NE b_L._FGCOLOR THEN
    RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "FGCOLOR":U,{&INTEGER-DATA-TYPE},?,?,_L._FGCOLOR,?,?,?).    

  IF _L._NO-BOX = b_L._NO-BOX AND NOT m_L._REMOVE-FROM-LAYOUT THEN
    RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "BOX":U).
  ELSE IF _L._NO-BOX NE b_L._NO-BOX  THEN
    RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "BOX":U,{&LOGICAL-DATA-TYPE},?,?,?,(NOT _L._NO-BOX),?,?).
    
  IF _L._FONT = b_L._FONT  AND NOT m_L._REMOVE-FROM-LAYOUT THEN
    RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "FONT":U).
  ELSE IF _L._FONT NE b_L._FONT THEN
    RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "FONT":U, {&INTEGER-DATA-TYPE},?,?,_L._FONT,?,?,?).
  
  IF _L._3-D = b_L._3-D AND NOT m_L._REMOVE-FROM-LAYOUT THEN 
    RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "THREE-D":U).
  ELSE IF _L._3-D NE b_L._3-D THEN
    RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "THREE-D":U,{&LOGICAL-DATA-TYPE},?,?,?,_L._3-D,?,?).

  IF _L._HEIGHT = b_L._HEIGHT AND NOT m_L._REMOVE-FROM-LAYOUT THEN
     RUN DeleteAttributeRow (pcObjectLevel, pdInputObj,IF pcObjectLevel = "MASTER":U THEN "minHeight":U ELSE "HEIGHT-CHARS":U).
   ELSE IF _L._HEIGHT NE b_L._HEIGHT THEN
     RUN CreateAttributeRow (pcObjectLevel, pdInputObj,IF pcObjectLevel = "MASTER":U THEN "minHeight":U ELSE "HEIGHT-CHARS":U,
                                   {&DECIMAL-DATA-TYPE},?,_L._HEIGHT,?,?,?,?).    
                                   
  IF _L._WIDTH = b_L._WIDTH AND NOT m_L._REMOVE-FROM-LAYOUT THEN 
     RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, IF pcObjectLevel = "MASTER":U THEN "minWidth":U ELSE "WIDTH-CHARS":U).
  ELSE IF _L._WIDTH NE b_L._WIDTH THEN
     RUN CreateAttributeRow (pcObjectLevel, pdInputObj, IF pcObjectLevel = "MASTER":U THEN "minWidth":U ELSE "WIDTH-CHARS":U,
                                  {&DECIMAL-DATA-TYPE},?,_L._WIDTH,?,?,?,?).                                   
 
  IF pcObjectLevel = "INSTANCE":U THEN
  DO:
     IF _L._COL = b_L._COL AND NOT m_L._REMOVE-FROM-LAYOUT THEN   /* COL must be specified for custom only fields */
       RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "COLUMN":U).
     ELSE IF _L._COL NE b_L._COL OR  b_L._REMOVE-FROM-LAYOUT THEN
       RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "COLUMN":U,{&DECIMAL-DATA-TYPE},?,_L._COL,?,?,?,?).

     IF _L._CONVERT-3D-COLORS = b_L._CONVERT-3D-COLORS AND NOT m_L._REMOVE-FROM-LAYOUT THEN
       RUN DeleteAttributeRow (pcObjectLevel,pdInputObj, "CONVERT-3D-COLORS":U).
     ELSE IF _L._CONVERT-3D-COLORS NE b_L._CONVERT-3D-COLORS THEN
       RUN CreateAttributeRow (pcObjectLevel,pdInputObj, "CONVERT-3D-COLORS":U,{&LOGICAL-DATA-TYPE},?,?,?,_L._CONVERT-3D-COLORS,?,?).

     IF _L._EDGE-PIXELS = b_L._EDGE-PIXELS AND NOT m_L._REMOVE-FROM-LAYOUT THEN
       RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "EDGE-PIXELS":U).
     ELSE IF _L._EDGE-PIXELS NE b_L._EDGE-PIXELS THEN
       RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "EDGE-PIXELS":U,{&INTEGER-DATA-TYPE},?,?,_L._EDGE-PIXELS,?,?,?).

     IF b_U._TYPE = "SmartObject":U THEN
     DO:
       IF _L._LABEL = b_L._LABEL AND NOT m_L._REMOVE-FROM-LAYOUT THEN
         RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "FieldLabel":U).
       ELSE IF _L._LABEL NE b_L._LABEL THEN
         RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "FieldLabel":U,{&CHARACTER-DATA-TYPE},_L._LABEL,?,?,?,?,?).
     END.
     IF _L._FILLED = b_L._FILLED AND NOT m_L._REMOVE-FROM-LAYOUT THEN 
       RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "FILLED":U).
     ELSE IF _L._FILLED NE b_L._FILLED THEN
       RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "FILLED":U, {&LOGICAL-DATA-TYPE},?,?,?,_L._FILLED,?,?).

     IF _L._GRAPHIC-EDGE = b_L._GRAPHIC-EDGE AND NOT m_L._REMOVE-FROM-LAYOUT THEN
       RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "GRAPHIC-EDGE":U).
     ELSE IF _L._GRAPHIC-EDGE NE b_L._GRAPHIC-EDGE THEN
       RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "GRAPHIC-EDGE":U, {&LOGICAL-DATA-TYPE},?,?,?,_L._GRAPHIC-EDGE,?,?).

     IF _L._LABEL = b_L._LABEL AND NOT m_L._REMOVE-FROM-LAYOUT THEN
       RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "LABEL":U).
     ELSE IF _L._LABEL NE b_L._LABEL THEN
       RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "LABEL":U, {&CHARACTER-DATA-TYPE}, _L._LABEL,?,?,?,?,?).

     IF _L._NO-LABELS = b_L._NO-LABELS AND NOT m_L._REMOVE-FROM-LAYOUT THEN
       RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "LABELS":U).
     ELSE IF _L._NO-LABELS NE b_L._NO-LABELS THEN
       RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "LABELS":U, {&LOGICAL-DATA-TYPE},?,?,?,(NOT _L._NO-LABELS),?,?).

     IF _L._NO-FOCUS = b_L._NO-FOCUS AND NOT m_L._REMOVE-FROM-LAYOUT THEN
       RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "NO-FOCUS":U).
     ELSE IF _L._NO-FOCUS NE b_L._NO-FOCUS THEN
       RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "NO-FOCUS":U, {&LOGICAL-DATA-TYPE},?,?,?,_L._NO-FOCUS,?,?).

     IF _L._ROW = b_L._ROW AND NOT m_L._REMOVE-FROM-LAYOUT THEN  /* ROW must be specified for custom only fields */
       RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "ROW":U).
     ELSE IF _L._ROW NE b_L._ROW OR b_L._REMOVE-FROM-LAYOUT THEN
       RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "ROW":U, {&DECIMAL-DATA-TYPE}, ?,_L._ROW,?,?,?,?).

     IF NOT m_L._REMOVE-FROM-LAYOUT THEN
     DO:
       IF _L._REMOVE-FROM-LAYOUT = b_L._REMOVE-FROM-LAYOUT  THEN 
         RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "VISIBLE":U).
       ELSE 
         RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "VISIBLE":U,{&LOGICAL-DATA-TYPE},?,?,?,NOT _L._REMOVE-FROM-LAYOUT,?,?).
     END.  
  END.
  
  IF pcObjectLevel = "MASTER":U THEN
  DO:
    IF _L._SEPARATOR-FGCOLOR = b_L._SEPARATOR-FGCOLOR AND NOT m_L._REMOVE-FROM-LAYOUT THEN 
      RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "SEPARATOR-FGCOLOR":U).
    ELSE IF _L._SEPARATOR-FGCOLOR NE b_L._SEPARATOR-FGCOLOR THEN
      RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "SEPARATOR-FGCOLOR":U,{&INTEGER-DATA-TYPE},?,?,_L._SEPARATOR-FGCOLOR,?,?,?).

    IF _L._SEPARATORS = b_L._SEPARATORS AND NOT m_L._REMOVE-FROM-LAYOUT THEN 
      RUN DeleteAttributeRow (pcObjectLevel, pdInputObj, "SEPARATOR-FGCOLOR":U).
    ELSE IF _L._SEPARATORS NE b_L._SEPARATORS THEN
      RUN CreateAttributeRow (pcObjectLevel, pdInputObj, "SEPARATOR-FGCOLOR":U,{&LOGICAL-DATA-TYPE},?,?,?,_L._SEPARATORS,?,?).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processMigratedSBO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processMigratedSBO Procedure 
PROCEDURE processMigratedSBO :
/*------------------------------------------------------------------------------
  Purpose:    If a Smartbusiness Object has been migrated, save as DynSBO 
  Parameters:  <none>
  Notes:      called from  writeObjectToRepository
------------------------------------------------------------------------------*/
 DEFINE VARIABLE dObject_Obj     AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE cInheritClasses AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE i               AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAttr           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hStoreAttribute AS HANDLE     NO-UNDO.
 DEFINE VARIABLE dSDO_Obj        AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE iValue          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE dvalue          AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE WindowRecid     AS RECID      NO-UNDO.
 DEFINE VARIABLE cTmpName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValidValidates AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cReason         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hAttributeTable  AS HANDLE    NO-UNDO.
 DEFINE VARIABLE dDlObj           AS DECIMAL   NO-UNDO.
 
 ASSIGN cValidValidates = 
          "PreTransaction,BeginTransaction,EndTransaction,PostTransaction,RowObject,":U +
          "CreatePreTrans,CreateBeginTrans,CreateEndTrans,CreatePostTrans,":U +
          "WritePreTrans,WriteBeginTrans,WriteEndTrans,WritePostTrans,":U +
          "DeletePreTrans,DeleteBeginTrans,DeleteEndTrans,DeletePostTrans":U.

  DEFINE BUFFER dlp_P   FOR _P.
  DEFINE BUFFER dlp_TRG FOR _TRG. /* For copying _TRG records from SDOs to DLPs */
  DEFINE BUFFER w_U     FOR _U.    /* For when we have 2 windows open simultaneously (SDOs and DLPs)  */

/* Create Object Instances of the contained SDOs */
 FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND 
                    b_U._STATUS        = "NORMAL":U AND
                    b_U._TYPE          = "SmartObject":U AND
                    b_U._SUBTYPE       = "SmartDataObject":U:

   FIND _S WHERE RECID(_S) = b_U._x-recid.

   /* Set dObject_obj to 0 so the attributes get set during the insertObjectInstance */
   dObject_obj = 0.

   RUN retrieveDesignClass IN ghRepDesignManager
                     ( INPUT  "Data",
                       OUTPUT cInheritClasses,
                       OUTPUT TABLE ttClassAttribute ,
                       OUTPUT TABLE ttUiEvent    ) NO-ERROR.  

  /* Loop through instance setting to create attributes */
  SETTINGS-SEARCH:
  DO i = 1 TO NUM-ENTRIES(_S._settings, CHR(3)):
    ASSIGN cAttr = ENTRY(i, _S._settings, CHR(3))
           cValue = ENTRY(2, cAttr, CHR(4))
           cAttr  = ENTRY(1, cAttr, CHR(4)).
    IF cAttr = "ObjectName":U THEN
      gcOBJFileName = cValue.
    ELSE IF cAttr = "ForeignFields":U AND cValue NE "":U THEN DO:
      IF NUM-ENTRIES(ENTRY(1, cValue), ".":U) = 2 THEN
        ENTRY(1, cValue) = ENTRY(2, ENTRY(1, cValue), ".":U).
      RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr, {&CHARACTER-DATA-TYPE}, cValue, ?, ?, ?, ?, ?).
    END.
    ELSE DO:  /* Generic Case */
        FIND ttClassAttribute WHERE ttClassAttribute.tClassname      = "Data":U 
                                AND ttClassAttribute.tAttributeValue = cValue NO-ERROR.
        IF AVAIL ttClassAttribute THEN
        CASE ttClassAttribute.tDataType:
          WHEN {&LOGICAL-DATA-TYPE} THEN DO:
            IF cValue = "":U THEN cValue = "no":U.
            IF LOGICAL(cValue) NE LOGICAL(ttClassAttribute.tAttributeValue) THEN
              RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr, {&LOGICAL-DATA-TYPE}, ?,?,?,LOGICAL(cValue),?,?).
          END.
          WHEN {&INTEGER-DATA-TYPE} THEN DO:
            iValue = INTEGER(cValue) NO-ERROR.
            IF NOT ERROR-STATUS:ERROR AND iValue NE INT(ttClassAttribute.tAttributeValue) THEN
               RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr, {&INTEGER-DATA-TYPE}, ?,?,iValue,?,?,?).
          END.
          WHEN {&DECIMAL-DATA-TYPE} THEN DO:
            dValue = DECIMAL(cValue) NO-ERROR.
            IF NOT ERROR-STATUS:ERROR AND dValue NE DECIMAL(ttClassAttribute.tAttributeValue) THEN
                RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr, {&DECIMAL-DATA-TYPE}, ?,dValue,?,?,?,?).
          END.
          WHEN {&CHARACTER-DATA-TYPE} THEN DO:
            IF cAttr = "PromptColumns":U AND cValue = "(All)":U THEN
              cValue = "":U.
            IF cAttr NE "DataColumns":U THEN DO: /* Data Columns are handled at the Master level */
              IF cValue NE ttClassAttribute.tAttributeValue THEN
                 RUN CreateAttributeRow(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cAttr, {&CHARACTER-DATA-TYPE}, cValue,?,?,?,?,?).
            END.
          END.
        END CASE.
         
      END.
   END.  /* Do I = 1 to num settings */

   hStoreAttribute = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
   RUN insertObjectInstance IN ghRepDesignManager
        ( INPUT gdDynamicObj,                  /* Container SBO                     */
          INPUT gcOBJFileName,                 /* Object Name                       */                  
          INPUT IF b_U._LAYOUT-NAME = "Master Layout":U
                THEN "":U ELSE b_U._LAYOUT-NAME,    /* Result Code                 */
          INPUT gcOBJFileName,                 /* Instance Name                     */
          INPUT "SDO of SBO":U,               /* Description    */
          INPUT "":U,                         /* Layout Position                   */
          INPUT ?,                            /* Page number - not applicable      */
          INPUT b_U._TAB-ORDER,               /* Page sequence                     */
          INPUT NO,                           /* Force creation                    */
          INPUT hStoreAttribute,              /* Buffer handle for attribute table */
          INPUT TABLE-HANDLE ghUnknown,        /* Table handle for attribute table  */
          OUTPUT dSDO_Obj,                    /* Master obj                        */
          OUTPUT dObject_Obj )                /* Instance Obj                      */
          NO-ERROR.

   IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
     RUN AppendToPError (RETURN-VALUE).
     RETURN.
    END.

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
     ASSIGN ryc_smartlink.container_smartobject_obj  = gdDynamicObj
            ryc_smartlink.smartlink_type_obj         = ryc_smartlink_type.smartlink_type_obj
            ryc_smartlink.link_name                  = ryc_smartlink_type.link_name
            ryc_smartlink.SOURCE_object_instance_obj = b_U._OBJECT-OBJ.

     FIND b_U WHERE RECID(b_U) = INTEGER(_admlinks._link-dest).
     ASSIGN ryc_smartlink.TARGET_object_instance_obj = b_U._OBJECT-OBJ.
   END.
 END.

 /* Should we generate a DLP for this SBO? */
 IF gcSuperPref NE "None":U THEN DO:
   RUN createSBODLP (INPUT _C._DATA-LOGIC-PROC, _P._u-recid) NO-ERROR.

   IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
     RUN AppendToPError (INPUT RETURN-VALUE).

   /* We must open an save this to make it finalize itself.  If
      the gcSuperPref is to copy validation logic, then we will do that
      too */

   /* First step is to load DLP into the Appbuilder */
   RUN adeuib/_qssuckr.p (INPUT _C._DATA-LOGIC-PROC, /* File to read        */
                          INPUT "",                  /* WebObject           */
                          INPUT "WINDOW-SILENT":U,   /* Import mode         */
                          INPUT FALSE) NO-ERROR.     /* Reading from schema */

   IF RETURN-VALUE BEGINS "_ABORT":U THEN DO:
     gpcError = RETURN-VALUE.
     IF LENGTH(RETURN-VALUE,"CHARACTER") > 7 THEN
       gpcError = SUBSTRING(gpcError, 8, -1, "CHARACTER").
     ELSE gpcError = "processMigratedSBO->_qssuckr.p:failed":U.
     RETURN.
   END.

   FIND dlp_P WHERE dlp_P._WINDOW-HANDLE = _h_win.
   FIND w_U WHERE w_U._HANDLE = _h_win.
   WindowRecid = RECID(w_U).

   /* Copy desired _TRG records from SDO to DLP */
   COPY2-BLOCK:
   FOR EACH _TRG WHERE _TRG._pRECID = RECID(_P):
     IF gcSuperPref = "ValOnly":U THEN DO:
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
       FIND dlp_Trg WHERE dlp_Trg._tEvent = _TRG._tEvent AND
                          dlp_Trg._wRECID = WindowRecid NO-ERROR.
       IF AVAILABLE dlp_Trg THEN
         NEXT COPY2-BLOCK.
       
       /* Don't copy XFTRs */
       IF _TRG._tSection NE "_XFTR":U THEN DO:
         CREATE dlp_Trg.
         BUFFER-COPY _TRG EXCEPT _pRECID _wRECID TO dlp_TRG
           ASSIGN dlp_TRG._pRECID = RECID(dlp_P)
                  dlp_TRG._wRECID = WindowRecid.
       END.  /* If not an _XFTR */
     END.  /* Else copy all */
   END. /* Looking for custom code to copy */

   /* Save the updated DLP */
   RUN adeshar/_gen4gl.p ("SAVE") NO-ERROR.
   
   RUN checkStaticObjectPath(_C._DATA-LOGIC-PROC, _C._DATA-LOGIC-PROC-PMOD, OUTPUT cReason).
   IF cReason NE "":U THEN DO:
     cReason = "Associated datalogic procedure " + cReason.
     RUN AppendToPError (INPUT cReason).
   END.
   ELSE DO:
       /* Call Dynamics procedure to save static object to repository. You'll see
          a similar call in save_window_static  IN _h_uib. */
       RUN insertObjectMaster IN ghRepDesignManager 
           ( INPUT  _C._DATA-LOGIC-PROC,            /* pcObjectName         */
             INPUT  "":U,                           /* pcResultCode         */
             INPUT  _C._DATA-LOGIC-PROC-PMOD,       /* pcProductModuleCode  */
             INPUT  "DLProc":U,                     /* pcObjectTypeCode     */
             INPUT  "":U,                           /* pcObjectDescription  */
             INPUT  "":U,                           /* pcObjectPath         */
             INPUT  "":U,                           /* pcSdoObjectName      */
             INPUT  "":U,                           /* pcSuperProcedureName */
             INPUT  NO,                             /* plIsTemplate         */
             INPUT  YES,                            /* plIsStatic           */
             INPUT  "":U,                           /* pcPhysicalObjectName */
             INPUT  NO,                             /* plRunPersistent      */
             INPUT  "":U,                           /* pcTooltipText        */
             INPUT  "":U,                           /* pcRequiredDBList     */
             INPUT  "":U,                           /* pcLayoutCode         */
             INPUT  ?,
             INPUT  TABLE-HANDLE hAttributeTable,
             OUTPUT dDlObj                                   ) NO-ERROR.
       IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
          RUN AppendToPError (RETURN-VALUE).
          RETURN.
       END.
       
   END.
   /* The Xftr caused the _P to be marked dirty, set it back */
   dlp_P._FILE-SAVED = YES.

   /* Close the DLP */
   RUN wind-close IN _h_uib (_h_win) NO-ERROR.
 
 END.  /* If we need a DLP */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processMigratedSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processMigratedSDO Procedure 
PROCEDURE processMigratedSDO :
/*------------------------------------------------------------------------------
  Purpose: If this is a migration of a static SDO and the user preference is
           "StandVal" then we are finished.  If it is "ValOnly" or "All", 
           then we want to strip out any of the generated validation code.  
           If it is "All", then we want to insert all of the old code.  If it
           is "ValOnly" then we want to only add in any procedures and/or 
           functions from the original SDO that we are converting.  
           To do this, we will open the new DLP silently and delete the 
           unwanted code sections then code the wanted SDO code sections to 
           it before rewriting it. 
  Parameters:  <none>
  Notes:      Called from createDynSDO 
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcDLPRootDIR     AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcDLPRelativeDir AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcDLPFileName     AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE WindowRecid           AS RECID                   NO-UNDO.
 DEFINE VARIABLE cTmpName AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValidValidates       AS CHARACTER               NO-UNDO.

 ASSIGN cValidValidates = 
        "PreTransaction,BeginTransaction,EndTransaction,PostTransaction,RowObject,":U +
        "CreatePreTrans,CreateBeginTrans,CreateEndTrans,CreatePostTrans,":U +
        "WritePreTrans,WriteBeginTrans,WriteEndTrans,WritePostTrans,":U +
        "DeletePreTrans,DeleteBeginTrans,DeleteEndTrans,DeletePostTrans":U.
  
 DEFINE BUFFER dlp_P   FOR _P.
 DEFINE BUFFER dlp_TRG FOR _TRG. /* For copying _TRG records from SDOs to DLPs */
 DEFINE BUFFER w_U     FOR _U.    /* For when we have 2 windows open simultaneously (SDOs and DLPs)  */
/* First step is to load DLP into the Appbuilder */
 RUN adeuib/_qssuckr.p (INPUT pcDLPRootDIR + "/":U +
                              pcDLPRelativeDir + "/":U +
                              pcDLPFileName,          /* File to read        */
                        INPUT "",                 /* WebObject           */
                        INPUT "WINDOW-SILENT":U,  /* Import mode         */
                        INPUT FALSE) NO-ERROR.             /* Reading from schema */

 IF RETURN-VALUE BEGINS "_ABORT":U THEN DO:
   gpcError = RETURN-VALUE.
   IF LENGTH(gpcError,"CHARACTER") > 7 THEN
     gpcError = SUBSTRING(gpcError, 8, -1, "CHARACTER").
   ELSE gpcError = "":U.
   RETURN "_ABORT":U.
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
 COPY-BLOCK:
 FOR EACH _TRG WHERE _TRG._pRECID = RECID(_P):
   IF gcSuperPref = "ValOnly":U THEN DO:
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
     FIND dlp_Trg WHERE dlp_Trg._tEvent = _TRG._tEvent AND
                        dlp_Trg._wRECID = WindowRecid NO-ERROR.
     IF AVAILABLE dlp_Trg THEN
       NEXT COPY-BLOCK.

     /* Don't copy XFTRs */
     IF _TRG._tSection NE "_XFTR":U THEN DO:
       CREATE dlp_Trg.
       BUFFER-COPY _TRG EXCEPT _pRECID _wRECID TO dlp_TRG
         ASSIGN _pRECID = RECID(dlp_P)
                _wRECID = WindowRecid.
     END.  /* If not XFTR */
   END.  /* Else copy all */
 END. /* Looking for custom code to copy */

 /* Save the updated DLP */
 RUN adeshar/_gen4gl.p ("SAVE") NO-ERROR.

 /* The Xftr caused the _P to be marked dirty, set it back */
 dlp_P._FILE-SAVED = YES.

 /* Close the DLP */
 RUN wind-close IN _h_uib (_h_win) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDeletedInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeDeletedInstances Procedure 
PROCEDURE removeDeletedInstances :
/*------------------------------------------------------------------------------
  Purpose:    Removes object instances that have been deleted 
  Parameters:  pcLayout     Layout to remove
               phDataSource Handle of DataSource
               pcCalculatedColumns  Calc fields list
               pcColumnTable        Column Table list 
  Notes:      called from writeFieldLevelObjects 
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcLayout            AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER phDataSource        AS HANDLE     NO-UNDO.
 DEFINE OUTPUT PARAMETER pcCalculatedColumns AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER pcColumnTable       AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE lCalculatedField AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cTmpCodes        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCode            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cCode            AS CHARACTER  NO-UNDO.

 IF pcLayout = "Master Layout":U THEN 
 DO:
   IF VALID-HANDLE(phDataSource) THEN  /* Could be converting a V8 SDV */
      pcCalculatedColumns = DYNAMIC-FUNCTION("getCalculatedColumns":U in phDataSource).

   /* Loop through the Child widgets and remove the ones that have been deleted */
   Child-DELETE:
   FOR EACH b_U WHERE b_U._STATUS = "DELETED":U AND
                      NOT b_U._NAME BEGINS "_LBL-":U AND
                      b_U._TYPE NE "WINDOW":U AND
                      b_U._TYPE NE "FRAME":U AND
                      b_U._DELETED = NO:
     
     IF b_U._NAME  NE "":U THEN 
     DO:
       cTmpCodes = IF gcResultCodes = "":U THEN "{&DEFAULT-RESULT-CODE}":U ELSE gcResultCodes.
       /* Loop through all ResultCodes */
       
       DO iCode = 1 TO NUM-ENTRIES(cTmpCodes):
         cCode = ENTRY(iCode, cTmpCodes).
         /* Delete the instance  */
         RUN removeObjectInstance IN ghRepDesignManager
                         ( INPUT gcContainer,               /* Container name       */
                           INPUT cCode,                    /* Container result code */
                           INPUT "":U,                     /* pcInstanceObjectName  */
                           INPUT b_U._NAME,                /* pcInstanceName        */
                           INPUT "")                       /* Always default        */
                           NO-ERROR.
         
         IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
           RUN AppendToPError (RETURN-VALUE).
           RETURN.
         END.
         
       END.  /* Looping through the Result Codes */
       b_U._DELETED = YES.
     END.  /* If the ObjectName isn't blank */
   END.  /* Child-Delete */
 END.  /* End DELETE INSTANCES */
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
  Notes:       called from assignMasterAttributes
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pRecid           AS RECID                NO-UNDO.
 DEFINE OUTPUT PARAMETER cInstanceColumns AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cAssignList              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBaseQuery               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLProcBaseName          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLProcName              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLProcRelPath           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataColumns             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataColumnsByTable      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataType                AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEntityFields            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEntityValues            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFirstTable              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cInheritClasses          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLabel                   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPhysicalTables          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQBFieldDataTypes        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQBFieldWidths           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQBInhVals               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQBJoinCode              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQBWhereClauses          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQbFieldDBNames          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSDOLabel                AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTables                  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTempTableDef            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTempTables              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cToken                   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cUpdatableColumns        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cUpdatableColumnsByTable AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue                   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE change-to-blank          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hPropBuffer              AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hPropLib                 AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hPropQuery               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE i                        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iPosition                AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lDBsBlank                AS LOGICAL    NO-UNDO.
 /* Variables to support the calculateObjectpaths API */
 DEFINE VARIABLE cRootDir                 AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDummy                   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cError                   AS CHARACTER  NO-UNDO.

 DEFINE BUFFER b_U FOR _U.
 DEFINE BUFFER b_TT FOR _TT.

 /* First find _C of Window because it has the name of the data logic procedure in it. */
 FIND _C WHERE RECID(_C) = _U._x-recid.
 
 /* Find _TT of Window if it exists to write out QueryTempTableDefinition property */
 FOR EACH _TT WHERE _TT._p-recid = RECID(_P) :
    ASSIGN cTempTableDef =  cTempTableDef   + (IF cTempTableDef = "" then "" ELSE CHR(3))
                          + _TT._NAME + " " 
                          + _TT._TABLE-TYPE + " " 
                          + (IF _TT._SHARE-TYPE = ? OR _TT._SHARE-TYPE = "" THEN "?" ELSE _TT._SHARE-TYPE) + " "
                          + (IF _TT._UNDO-TYPE = ? OR _TT._UNDO-TYPE = "" THEN "?" ELSE _TT._UNDO-TYPE) + " "
                          + (IF _TT._LIKE-DB  = ? OR _TT._LIKE-DB = "" THEN "?" ELSE _TT._LIKE-DB)      + " "
                          + (IF _TT._LIKE-TABLE  = ? OR _TT._LIKE-TABLE = "" THEN "?" ELSE _TT._LIKE-TABLE) + " "
                          + (IF _TT._ADDITIONAL_FIELDS  = ? OR _TT._ADDITIONAL_FIELDS = "" THEN "" ELSE _TT._ADDITIONAL_FIELDS)
          cTempTableDef  = TRIM(cTempTableDef).               
 END.

 /* If we have to write a DLP get the Root path, Full path, Relative Path etc. */
 IF _C._DATA-LOGIC-PROC <> "":U THEN DO:        
   RUN calculateObjectpaths IN gshRepositoryManager 
                   (INPUT  _C._DATA-LOGIC-PROC,   INPUT  0,                        /* Object Name, smartobject_obj  */                
                    INPUT  gcObjClassType,         INPUT  _C._DATA-LOGIC-PROC-PMOD, /* Object Type , Product Module */
                    INPUT  "":U,                  INPUT  "":U,                     /* objectParameter, name Space  */ 
                    OUTPUT cRootDir,              OUTPUT cDLProcRelPath,           /* Root Dir,Relative Dir */
                    OUTPUT gcSCMRelativeDir, OUTPUT gcFullPathName,            /* SCM Relative dir,Full path Name */
                    OUTPUT cDummy,                OUTPUT cDLProcBaseName,          /* Object Name, Physical file name */
                    OUTPUT cError) NO-ERROR.   

   IF ERROR-STATUS:ERROR OR cError <> "" THEN DO:
           RUN AppendToPError (cError).
           RETURN.
    END.
   
   ASSIGN cDLProcName = IF TRIM(gcSCMRelativeDir) <> "":U THEN 
                           RIGHT-TRIM(gcSCMRelativeDir,"/") + (IF gcSCMRelativeDir > "" THEN "/":U ELSE "") + cDLProcBaseName 
                        ELSE 
                           RIGHT-TRIM(cDLProcRelPath,"/") + (IF cDLProcRelPath > "" THEN "/":U ELSE "") + cDLProcBaseName .
 END.  /* If the data logic procedure has been specified */

 /* Now get _U, _C and _Q of the query */
 FIND b_U WHERE RECID(b_U) = pRecid.
 FIND _C WHERE RECID(_C) = b_U._x-recid.
 FIND _Q WHERE RECID(_Q) eq _C._q-recid.

 RUN ConstructTableList(INPUT RECID(_U), INPUT _Q._TblList, OUTPUT cTables).

 /* Construct the physical tables in case the table is a buffer and construct the temp table list */
 DO i = 1 to NUM-ENTRIES(cTables):
    FIND b_TT WHERE b_TT._p-RECID = RECID(_P)
                AND b_TT._NAME    = ENTRY(i,cTables) NO-ERROR.

    cPhysicalTables = cPhysicalTables + (IF cPhysicalTables = "" THEN "" ELSE ",")
                                      + (IF AVAIL b_TT AND b_TT._TABLE-TYPE = "B":U 
                                         THEN db-tbl-name(b_TT._LIKE-DB + "." +  b_TT._LIKE-TABLE)
                                         ELSE ENTRY(i,cTables)).
    IF AVAIL b_TT AND  b_TT._TABLE-TYPE = "T":U  THEN                                      
      cTempTables = cTempTables + (IF cTempTables = "" THEN "" ELSE ",")
                                +  ENTRY(i,cTables).
    RELEASE b_TT.                                                   
 END.
 
 /* Use cTables to build cAssignList, cUpdatableColumnsByTable and cDataColumnsByTable */
 RUN BuildSDOFieldListsByTable(INPUT RECID(b_U),
                               INPUT  cTables,                      OUTPUT cAssignList,
                               OUTPUT cUpdatableColumnsByTable,     OUTPUT cDataColumnsByTable).

 /* Determine what the label should be for the SDO */
 TableLoop:
 DO iPosition = 1 TO NUM-ENTRIES(cTables):
   IF ENTRY(iPosition, cUpdatableColumnsByTable,";":U) <> "":U THEN
     LEAVE TableLoop.
 END.  /* tableloop */
 IF iPosition > 0 THEN
   cFirstTable = ENTRY(iPosition, cPhysicalTables) NO-ERROR.
 IF cFirstTable > "":U THEN
 DO:
   RUN getEntityDetail IN gshGenManager
     (INPUT cFirstTable,
      OUTPUT cEntityFields,
      OUTPUT cEntityValues).
   IF NUM-ENTRIES(cEntityFields, CHR(1)) > 0 THEN
     IF LOOKUP("entity_mnemonic_short_desc":U,cEntityFields,CHR(1)) <> 0 THEN
       cSDOLabel = ENTRY(LOOKUP("entity_mnemonic_short_desc",cEntityFields,CHR(1)) ,cEntityValues,CHR(1) ).
   IF cSDOLabel = "":U THEN
     cSDOLabel = cFirstTable.
 END.  /* if cFirstTable > "" */
 
 /* Ensure the first letter is capitalized and the remaining name is lower case */
 IF LENGTH(cSDOLabel) > 1 THEN
   cSDOLabel = CAPS(SUBSTR(cSDOLabel,1,1)) + LC(SUBSTR(cSDOLabel,2)) NO-ERROR. 
 IF cSDOLabel = "":U THEN
   cSDOLabel = _P.object_filename.

 /* Assign to global variables to be used later for generating Data logic proc */
 ASSIGN  gcTableList      = cTables
         gcUpdColsByTable = cUpdatableColumnsByTable.

 /* Build cDataColumns, cUpdateableColumns and other lists necessary for SDOs to be read
    back into the AppBuilder from the repository                                         */
 RUN BuildSDOSimpleLists(INPUT RECID(b_U),         OUTPUT cDataColumns,
                         OUTPUT cUpdatableColumns, OUTPUT cInstanceColumns,
                         OUTPUT cQBFieldDataTypes, OUTPUT cQBFieldDBNames,
                         OUTPUT cQBFieldWidths,    OUTPUT cQBInhVals).

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
 
 IF cQBJoinCode NE "":U THEN 
 DO:
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

 IF cQBWhereClauses NE "":U THEN 
 DO:
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

 /* Need to strip DB name from base query if suppress_dbname is Yes and dbName is temp-db or temp-tables*/
 cBaseQuery = "FOR":U.
 DO i = 1 TO NUM-ENTRIES(_Q._4GLQury," ":U):
   cToken = ENTRY(i, _Q._4GLQury, " ":U).
   IF NUM-ENTRIES(cToken,".":U) = 2 AND
     LOOKUP(ENTRY(1, cToken, ".":U), cQBFieldDBNames) > 0 THEN 
         cToken = db-tbl-name(cToken). 
   ELSE IF NUM-ENTRIES(cToken,".":U) = 3 AND
     LOOKUP(ENTRY(1, cToken, ".":U), cQBFieldDBNames) > 0 THEN
       cToken =  db-tbl-name(ENTRY(1, cToken, ".":U) + ".":U + ENTRY(2, cToken, ".":U))
                  + ".":U + ENTRY(3, cToken, ".":U).
                
   ASSIGN cBaseQuery = cBaseQuery + " ":U + cToken.
 END.

 gcDBName = ENTRY(1, _Q._TblList, ".":U).
 /* Blank out cQBFieldDBNames if they all belong to gcDBName */
 lDBsBlank = YES.
 DB-LOOP:
 DO i = 1 TO NUM-ENTRIES(cQbFieldDBNames):
   IF ENTRY(i,cQbFieldDBNames) NE gcDBName THEN ldbsBlank = NO.
 END.
 IF lDBsBlank THEN cQBFieldDBNames = "":U.

 IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = gcObjClassType) THEN
    RUN retrieveDesignClass IN ghRepDesignManager 
                        ( INPUT  gcObjClassType,
                          OUTPUT cInheritClasses,
                          OUTPUT TABLE ttClassAttribute ,
                          OUTPUT TABLE ttUiEvent    ) NO-ERROR.  
 /* Get the master dynSDO object and retrieve its attributes  */
 RUN retrieveDesignObject IN ghRepDesignManager 
                        ( INPUT   _P.object_filename,
                          INPUT  "":U ,
                          OUTPUT TABLE ttObject,
                          OUTPUT TABLE ttPage,
                          OUTPUT TABLE ttLink,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttObjectAttribute ) NO-ERROR.

 FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = _P.object_filename AND
            ttObject.tContainerSmartObjectObj          = 0 NO-ERROR.
 
 /* Assign master attributes defined on the class level */
 ASSIGN gcAttributeList = "".
 FOR EACH ttClassAttribute:
    /* Skip attributes that can only be modified on the class level */
    IF ttClassAttribute.tWhereConstant = "CLASS":U  THEN
       NEXT.
    ASSIGN cLabel = ttClassAttribute.tAttributeLabel 
           cValue = ttClassAttribute.tAttributeValue .
    
    FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                             AND ttObjectAttribute.tObjectInstanceObj  = ttObject.tObjectInstanceObj
                             AND ttObjectAttribute.tAttributeLabel    = cLabel NO-ERROR.
    /* Build string of attributes defined on the instance. These are candidates for removal 
       if the values are the same */                              
    IF AVAIL ttObjectAttribute THEN
        ASSIGN cValue          = ttObjectAttribute.tAttributeValue
               gcAttributeList = gcAttributeList + (IF gcAttributeList = "" THEN "" ELSE ",") 
                                                 + ttObjectAttribute.tAttributelabel.   
    CASE cLabel:
       WHEN "AppService":U THEN
          setAttributeChar("MASTER":U,_P._Partition,cLabel, cValue,gdSmartObject_obj).
       WHEN "AssignList":U THEN
            setAttributeChar("MASTER":U,cAssignList,cLabel, cValue,gdSmartObject_obj).
       WHEN "BaseQuery":U THEN
            setAttributeChar("MASTER":U,cBaseQuery,cLabel, cValue,gdSmartObject_obj).
       WHEN "DataColumns":U THEN
            setAttributeChar("MASTER":U,cDataColumns,cLabel, cValue,gdSmartObject_obj).
       WHEN "DataColumnsByTable":U THEN
          setAttributeChar("MASTER":U,cDataColumnsByTable,cLabel, cValue,gdSmartObject_obj).
       WHEN "DataLogicProcedure":U THEN
            setAttributeChar("MASTER":U,cDLProcName,cLabel, cValue,gdSmartObject_obj).
       WHEN "Label":U THEN
         IF NOT AVAIL ttObjectAttribute THEN
           setAttributeChar("MASTER":U,cSDOLabel,cLabel, cValue,gdSmartObject_obj).
       WHEN "PhysicalTables":U THEN
            setAttributeChar("MASTER":U,cPhysicalTables,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderDBNames":U THEN
            setAttributeChar("MASTER":U,cQBFieldDBNames,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderFieldDataTypes":U THEN 
         /* Normally data-types never change except for a calculated field  */
         IF CAN-DO(cQbFieldDBNames,"_<CALC>":U) THEN
             setAttributeChar("MASTER":U,cQBFieldDataTypes,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderFieldWidths":U THEN
            setAttributeChar("MASTER":U,cQBFieldWidths,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderInheritValidations":U THEN
            setAttributeChar("MASTER":U,cQBInhVals,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderJoinCode":U THEN
            setAttributeChar("MASTER":U,cQBJoinCode,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderOptionList":U THEN
            setAttributeChar("MASTER":U,_Q._OptionList,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderOrderList":U THEN
            setAttributeChar("MASTER":U,_Q._OrdList,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderTableOptionList":U THEN
            setAttributeChar("MASTER":U,_Q._TblOptList,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderTableList":U THEN
            setAttributeChar("MASTER":U,_Q._TblList,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderTuneOptions":U THEN
            setAttributeChar("MASTER":U,_Q._TuneOptions,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryBuilderWhereClauses":U THEN
            setAttributeChar("MASTER":U,cQBWhereClauses,cLabel, cValue,gdSmartObject_obj).
       WHEN "QueryTempTableDefinitions":U THEN
            setAttributeChar("MASTER":U,cTempTableDef,cLabel, cValue,gdSmartObject_obj).
       WHEN "Tables":U THEN
            setAttributeChar("MASTER":U,cTables,cLabel, cValue,gdSmartObject_obj).
       WHEN "TempTables":U THEN
            setAttributeChar("MASTER":U,cTempTables,cLabel, cValue,gdSmartObject_obj).
       WHEN "UpdatableColumns":U THEN
            setAttributeChar("MASTER":U,cUpdatableColumns,cLabel, cValue,gdSmartObject_obj).
       WHEN "UpdatableColumnsByTable":U THEN
            setAttributeChar("MASTER":U,cUpdatableColumnsByTable,cLabel, cValue,gdSmartObject_obj).
    END CASE.
 END. /* For each ttClassAttribute */
 
 /* Retrieve the Dynamic Property Sheet modified values */
 RUN createDPSAttribute IN THIS-PROCEDURE ("", "MASTER":U,gdSmartObject_obj,b_U._Window-handle,b_U._Window-handle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setObjectEvents Procedure 
PROCEDURE setObjectEvents :
/*------------------------------------------------------------------------------
  Purpose:  Get events defined in the DPS   
  Parameters:  <none>
  Notes:    called from writeFieldLevelObjects and writeObjectToRepository
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
 DEFINE VARIABLE hTmp           AS HANDLE     NO-UNDO.

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

/* Update the Events for this object */
 IF CAN-FIND(FIRST ttStoreUIEvent) THEN
 DO:
    hTmp = TEMP-TABLE ttStoreUIEvent:DEFAULT-BUFFER-HANDLE.
    RUN insertUIEvents IN ghRepDesignManager
         (INPUT hTmp ,
          INPUT TABLE-HANDLE ghUnknown) NO-ERROR.  /* Compiler requires a variable with unknown */

    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
       RUN AppendToPError ( RETURN-VALUE).
       RETURN.
    END.
    
    /* Empty the temp-table */
    EMPTY TEMP-TABLE ttStoreUIEvent.
 END.
 /*Update the events that were deleted */
 IF CAN-FIND(FIRST DeleteUIEvent) THEN
 DO:
   hTmp = TEMP-TABLE DeleteUIEvent:DEFAULT-BUFFER-HANDLE.
   RUN removeUIEvents IN ghRepDesignManager
        (INPUT hTmp ,
         INPUT TABLE-HANDLE ghUnknown) NO-ERROR.  /* Compiler requires a variable with unknown */

  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
     RUN AppendToPError (RETURN-VALUE).
     RETURN.
    END.
   /* Empty the temp-table */
   EMPTY TEMP-TABLE DeleteUIEvent.
 END.                     

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
  Notes:       called from writeFieldLevelObjects
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER puRecid           AS RECID          NO-UNDO.
 DEFINE INPUT  PARAMETER cMasterObjectName AS CHARACTER      NO-UNDO.
 DEFINE INPUT  PARAMETER dObject_obj       AS DECIMAL        NO-UNDO.
 DEFINE INPUT  PARAMETER cLayout           AS CHARACTER      NO-UNDO.
 DEFINE INPUT  PARAMETER lnewInstance      AS LOGICAL        NO-UNDO.

 DEFINE BUFFER b_U FOR _U.

 DEFINE VARIABLE iEntry               AS INTEGER        NO-UNDO.
 DEFINE VARIABLE lTmp                 AS LOGICAL        NO-UNDO.
 DEFINE VARIABLE cTmp                 AS CHARACTER      NO-UNDO.
 DEFINE VARIABLE hPropBuffer          AS HANDLE         NO-UNDO.
 DEFINE VARIABLE hPropLib             AS HANDLE         NO-UNDO.
 DEFINE VARIABLE cResultCode          AS CHARACTER      NO-UNDO.
 DEFINE VARIABLE cDataType            AS CHARACTER      NO-UNDO.
 DEFINE VARIABLE cValue               AS CHARACTER      NO-UNDO.
 DEFINE VARIABLE hPropQuery           AS HANDLE         NO-UNDO.
 DEFINE VARIABLE cInheritClasses      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLabel               AS CHARACTER  NO-UNDO.


 FIND b_U WHERE RECID(b_U) = puRecid.
 FIND _F WHERE RECID(_F) = b_U._x-recid NO-ERROR.
 FIND _L WHERE _L._LO-NAME = cLayout AND _L._u-recid = RECID(b_U) NO-ERROR.

 /* get the instance Object (if it exists) and determine the attributes that are defined on the instance */
  IF lNewInstance OR NOT CAN-FIND(FIRST ttObject WHERE ttObject.tLogicalObjectName = _P.object_filename) THEN
     RUN retrieveDesignObject IN ghRepDesignManager 
                     ( INPUT   _P.object_filename,
                       INPUT  IF cLayout ="Master Layout":U 
                              THEN "{&DEFAULT-RESULT-CODE}":U 
                              ELSE cLayout,  /* Get  result Codes */
                       OUTPUT TABLE ttObject,
                       OUTPUT TABLE ttPage,
                       OUTPUT TABLE ttLink,
                       OUTPUT TABLE ttUiEvent,
                       OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 

 FIND FIRST ttObject WHERE ttObject.tLogicalObjectName =  cMasterObjectName AND
            ttObject.tObjectInstanceObj                =  dObject_obj NO-ERROR.
 
 IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = ttObject.tClassName) THEN
    RUN retrieveDesignClass IN ghRepDesignManager
                     ( INPUT  ttObject.tClassname,
                       OUTPUT cInheritClasses,
                       OUTPUT TABLE ttClassAttribute ,
                       OUTPUT TABLE ttUiEvent    ) NO-ERROR.

 IF cLayout NE "Master Layout":U THEN 
     RUN ProcessCustomAttributes(INPUT "INSTANCE":U, INPUT dObject_obj, INPUT RECID(_L)).
 ELSE DO:
   ASSIGN gcAttributeList = "".
   FOR EACH ttClassAttribute:
     /* Skip attributes that can only be modified on the class level */
     IF ttClassAttribute.tWhereConstant = "CLASS":U  THEN
           NEXT.

     ASSIGN clabel = ttClassAttribute.tAttributeLabel
            cValue = ttClassAttribute.tAttributeValue.
     
        /* Find Instance value */
     IF AVAIL ttObject THEN
        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                 AND ttObjectAttribute.tObjectInstanceObj  = ttObject.tObjectInstanceObj
                                 AND ttObjectAttribute.tAttributeLabel     = cLabel NO-ERROR.
     /* Build string of attributes defined on the instance. These are candidates for removal 
        if the values are the same */                              
     IF AVAIL ttObjectAttribute THEN
        ASSIGN cValue          = ttObjectAttribute.tAttributeValue
               gcAttributeList = gcAttributeList + (IF gcAttributeList = "" THEN "" ELSE ",") 
                                                 + ttObjectAttribute.tAttributelabel.
     ELSE DO:
        /* Find master value */
       FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj     = ttObject.tSmartObjectObj
                                AND ttObjectAttribute.tObjectInstanceObj  = 0
                                AND ttObjectAttribute.tAttributeLabel     = cLabel NO-ERROR.
       IF AVAIL ttObjectAttribute THEN                         
          cValue = ttObjectAttribute.tAttributeValue.          
     END.
     RELEASE ttObjectAttribute.
     /* Find Master Object */
     FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj     = ttObject.tSmartObjectObj
                              AND ttObjectAttribute.tObjectInstanceObj  = 0
                              AND ttObjectAttribute.tAttributeLabel     = cLabel NO-ERROR.
     CASE cLabel:
      WHEN "AUTO-COMPLETION":U THEN
          setAttributeLog("INSTANCE":U,_F._AUTO-COMPLETION,cLabel, cValue,dObject_obj).
       WHEN "AUTO-END-KEY":U THEN
          setAttributeLog("INSTANCE":U,_F._AUTO-ENDKEY,cLabel, cValue,dObject_obj).
       WHEN "AUTO-GO":U THEN
          setAttributeLog("INSTANCE":U,_F._AUTO-GO,cLabel, cValue,dObject_obj).
       WHEN "AUTO-INDENT":U THEN
          setAttributeLog("INSTANCE":U,_F._AUTO-INDENT,cLabel, cValue,dObject_obj).
       WHEN "AUTO-RESIZE":U THEN
          setAttributeLog("INSTANCE":U,_F._AUTO-RESIZE,cLabel, cValue,dObject_obj).
       WHEN "AUTO-RETURN":U THEN
           setAttributeLog("INSTANCE":U,_F._AUTO-RETURN,cLabel, cValue,dObject_obj).
       WHEN "BGCOLOR":U THEN 
         setAttributeInt("INSTANCE":U,_L._BGCOLOR,cLabel, cValue,dObject_obj).
       WHEN "BLANK":U THEN
         setAttributeLog("INSTANCE":U,_F._BLANK,cLabel, cValue,dObject_obj).
       WHEN "BOX":U THEN
          setAttributeLog("INSTANCE":U,NOT _L._NO-BOX,cLabel, cValue,dObject_obj).
       WHEN "CHECKED":U THEN DO:
          lTmp = (_F._INITIAL-DATA BEGINS "Y":U OR _F._INITIAL-DATA BEGINS "T":U).
          setAttributeLog("INSTANCE":U,lTmp,cLabel, cValue,dObject_obj).
       END. /* Checked */
       WHEN "COLUMN":U THEN
         setAttributeDec("INSTANCE":U,_L._COL,cLabel, cValue,dObject_obj).
       WHEN "CONTEXT-HELP-ID":U THEN
          setAttributeInt("INSTANCE":U,b_U._CONTEXT-HELP-ID, cLabel, cValue,dObject_obj).
       WHEN "CONVERT-3D-COLORS":U THEN
         setAttributeLog("INSTANCE":U, _L._CONVERT-3D-COLORS,cLabel, cValue,dObject_obj).
       WHEN "DATA-TYPE":U THEN
         setAttributeChar("INSTANCE":U,_F._DATA-TYPE,cLabel, cValue,dObject_obj).
       WHEN "DEBLANK":U THEN
          setAttributeLog("INSTANCE":U,_F._DEBLANK,cLabel, cValue,dObject_obj).
       WHEN "DEFAULT":U THEN
          setAttributeLog("INSTANCE":U,_F._DEFAULT,cLabel, cValue,dObject_obj).
       WHEN "DELIMITER":U THEN
          setAttributeChar("INSTANCE":U,_F._DELIMITER,cLabel, cValue,dObject_obj).
       WHEN "DisplayField":U THEN
         setAttributeLog("INSTANCE":U,b_U._DISPLAY,cLabel, cValue,dObject_obj).
       WHEN "DISABLE-AUTO-ZAP":U THEN
         setAttributeLog("INSTANCE":U,_F._DISABLE-AUTO-ZAP,cLabel, cValue,dObject_obj).
       WHEN "DRAG-ENABLED":U THEN
         setAttributeLog("INSTANCE":U,_F._DRAG-ENABLED,cLabel, cValue,dObject_obj).
       WHEN "DROP-TARGET":U THEN
         setAttributeLog("INSTANCE":U,b_U._DROP-TARGET,cLabel, cValue,dObject_obj).
       WHEN "EDGE-PIXELS":U THEN
         setAttributeInt("INSTANCE":U,_L._EDGE-PIXELS,cLabel, cValue,dObject_obj).
       WHEN "ENABLED":U THEN
         setAttributeLog("INSTANCE":U,b_U._ENABLE,cLabel, cValue,dObject_obj).
       WHEN "EXPAND":U THEN
         setAttributeLog("INSTANCE":U,_F._EXPAND,cLabel, cValue,dObject_obj).
       WHEN "FGCOLOR":U THEN
          setAttributeInt("INSTANCE":U,_L._FGColor,cLabel, cValue,dObject_obj).
       WHEN "FILLED":U THEN
         setAttributeLog("INSTANCE":U,_L._Filled,cLabel, cValue,dObject_obj).
       WHEN "FLAT-BUTTON":U THEN
         setAttributeLog("INSTANCE":U,_F._FLAT,cLabel, cValue,dObject_obj).
       WHEN "FONT":U THEN
         setAttributeInt("INSTANCE":U,_L._FONT,cLabel, cValue,dObject_obj).
       WHEN "FORMAT":U THEN DO:
         cTmp =  IF _F._FORMAT = ? OR _F._FORMAT = "":U 
                 THEN  "X(":U + STRING(MAX(2,LENGTH(_F._INITIAL-DATA))) + ")":U ELSE _F._FORMAT.
         setAttributeChar("INSTANCE":U,cTmp,cLabel, cValue,dObject_obj).
       END.
       WHEN "GRAPHIC-EDGE":U THEN
         setAttributeLog("INSTANCE":U,_L._Graphic-Edge,cLabel, cValue,dObject_obj).
       WHEN "HEIGHT-CHARS":U THEN 
         setAttributeDec("INSTANCE":U,_L._HEIGHT,cLabel, cValue,dObject_obj).
       WHEN "HELP":U THEN 
         setAttributeChar("INSTANCE":U, b_U._HELP,cLabel, cValue,dObject_obj).
       WHEN "HIDDEN":U THEN
         setAttributeLog("INSTANCE":U, b_U._HIDDEN,cLabel, cValue,dObject_obj).
       WHEN "HORIZONTAL":U THEN
         setAttributeLog("INSTANCE":U,_F._HORIZONTAL,cLabel, cValue,dObject_obj).
       WHEN "IMAGE-FILE":U THEN
          setAttributeChar("INSTANCE":U,_F._IMAGE-FILE,cLabel, cValue,dObject_obj).
       WHEN "InitialValue":U THEN DO:
         cTmp = IF _F._INITIAL-DATA = ? THEN "?":U ELSE _F._INITIAL-DATA.
         setAttributeChar("INSTANCE":U,cTmp,cLabel, cValue,dObject_obj).
       END.
       WHEN "INNER-LINES":U THEN
         setAttributeInt("INSTANCE":U,_F._INNER-LINES,cLabel, cValue,dObject_obj).
       WHEN "LABEL":U THEN 
           setAttributeChar("INSTANCE":U,_L._LABEL,cLabel, cValue,dObject_obj).
       WHEN "LABELS":U THEN  /* Careful! Switching NO-LABELS to LABELS */
           setAttributeLog("INSTANCE":U,NOT _L._NO-LABELS,cLabel, cValue,dObject_obj).
       WHEN "LARGE":U THEN
         setAttributeLog("INSTANCE":U, _F._LARGE,cLabel, cValue,dObject_obj).
       WHEN "LIST-ITEMS":U OR
       WHEN "RADIO-BUTTONS" THEN 
       DO:
         IF b_U._TYPE NE "RADIO-SET":U AND cLabel = "LIST-ITEMS":U OR
            b_U._TYPE EQ "RADIO-SET":U AND cLabel = "RADIO-BUTTONS":U THEN 
         DO:
            IF b_U._TYPE NE "RADIO-SET":U THEN
              cTmp = REPLACE(_F._LIST-ITEMS, CHR(10), _F._DELIMITER).
            ELSE DO: /* RADIO-BUTTONS need TO have quotes, spaces AND CHR(10)'s removed */
               cTmp = REPLACE(_F._LIST-ITEMS, ":U":U, "":U).  /* Remove the :U's */
               DO iEntry = 1 TO NUM-ENTRIES(cTmp, _F._DELIMITER):
                  ENTRY(iEntry, cTmp, _F._DELIMITER) = 
                     TRIM(TRIM(ENTRY(iEntry, cTmp, _F._DELIMITER)), '"').
               END.
            END.
            setAttributeChar("INSTANCE":U,cTmp,cLabel, cValue,dObject_obj).
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
         setAttributeChar("INSTANCE":U,cTmp,cLabel, cValue,dObject_obj).
       END.
       WHEN "MANUAL-HIGHLIGHT":U THEN
         setAttributeLog("INSTANCE":U, b_U._MANUAL-HIGHLIGHT,cLabel, cValue,dObject_obj).
       WHEN "MAX-CHARS":U THEN
         setAttributeInt("INSTANCE":U, _F._MAX-CHARS,cLabel, cValue,dObject_obj).
       WHEN "MOVABLE":U THEN
         setAttributeLog("INSTANCE":U,b_U._MOVABLE,cLabel, cValue,dObject_obj).
       WHEN "MULTIPLE":U THEN
          setAttributeLog("INSTANCE":U, _F._MULTIPLE,cLabel, cValue,dObject_obj).
       WHEN "NO-FOCUS":U THEN
         setAttributeLog("INSTANCE":U,_L._NO-FOCUS,cLabel, cValue,dObject_obj).
       WHEN "Order":U THEN DO:
         IF b_U._TAB-ORDER > 0 THEN 
         DO:
            IF b_U._TAB-ORDER NE INT(cValue) THEN DO:
              /* The order attribute will be deprecated, the rendering currently uses
                 object sequence for tab order but the order attribute is still maintained
                 and kept in sync with _U._TAB-ORDER by the AppBuilder. */
              FIND ryc_object_instance WHERE 
                  ryc_object_instance.object_instance_obj = dObject_obj EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE ryc_object_instance THEN
                ryc_object_instance.object_sequence = b_U._TAB-ORDER.
              RELEASE ryc_object_instance.
            END.
            setAttributeInt("INSTANCE":U,b_U._TAB-ORDER,cLabel, cValue,dObject_obj).
         END.
       END. /* When Order */
       WHEN "PRIVATE-DATA":U THEN
         setAttributeChar("INSTANCE":U,b_U._PRIVATE-DATA,cLabel, cValue,dObject_obj).
       WHEN "READ-ONLY":U THEN
         setAttributeLog("INSTANCE":U, _F._READ-ONLY,cLabel, cValue,dObject_obj).
       WHEN "RESIZABLE":U THEN
         setAttributeLog("INSTANCE":U,b_U._RESIZABLE,cLabel, cValue,dObject_obj).
       WHEN "RETAIN-SHAPE":U THEN
         setAttributeLog("INSTANCE":U,_F._RETAIN-SHAPE,cLabel, cValue,dObject_obj).
       WHEN "RETURN-INSERTED":U THEN
         setAttributeLog("INSTANCE":U,_F._RETURN-INSERTED,cLabel, cValue,dObject_obj).
       WHEN "ROW":U THEN
         setAttributeDec("INSTANCE":U, _L._ROW,cLabel, cValue,dObject_obj).
       WHEN "SCROLLBAR-HORIZONTAL":U THEN
         setAttributeLog("INSTANCE":U,_F._SCROLLBAR-H,cLabel, cValue,dObject_obj).
       WHEN "SCROLLBAR-VERTICAL":U THEN
         setAttributeLog("INSTANCE":U, b_U._SCROLLBAR-V,cLabel, cValue,dObject_obj).
       WHEN "SELECTABLE":U THEN
          setAttributeLog("INSTANCE":U,b_U._SELECTABLE,cLabel, cValue,dObject_obj).
       WHEN "SENSITIVE":U THEN
         setAttributeLog("INSTANCE":U,b_U._SENSITIVE,cLabel, cValue,dObject_obj).
      WHEN "SHOWPOPUP":U THEN
         setAttributeLog("INSTANCE":U,b_U._SHOW-POPUP,cLabel, cValue,dObject_obj).
       WHEN "SORT":U THEN
         setAttributeLog("INSTANCE":U, _F._SORT,cLabel, cValue,dObject_obj).
       WHEN "STRETCH-TO-FIT":U THEN
           setAttributeLog("INSTANCE":U,_F._STRETCH-TO-FIT,cLabel, cValue,dObject_obj).
       WHEN "SUBTYPE":U THEN
         IF b_U._TYPE EQ "COMBO-BOX":U  THEN 
            setAttributeChar("INSTANCE":U,b_U._SUBTYPE,cLabel, cValue,dObject_obj).
       WHEN "TAB-STOP":U THEN  /* Careful! Switching NO-TAB-STOP to TAB-STOP */
          setAttributeLog("INSTANCE":U,NOT b_U._NO-TAB-STOP,cLabel, cValue,dObject_obj).
       WHEN "TOOLTIP":U THEN
         setAttributeChar("INSTANCE":U,b_U._TOOLTIP,cLabel, cValue,dObject_obj).
       WHEN "THREE-D":U THEN
         setAttributeLog("INSTANCE":U,_L._3-D,cLabel, cValue,dObject_obj).
       WHEN "TRANSPARENT":U THEN
         setAttributeLog("INSTANCE":U,_F._TRANSPARENT,cLabel, cValue,dObject_obj).
       WHEN "VISIBLE":U THEN
          setAttributeLog("INSTANCE":U,NOT b_U._HIDDEN,cLabel, cValue,dObject_obj).
       WHEN "VisualizationType":U THEN DO:
         IF b_U._TYPE = "FILL-IN":U AND b_U._SUBTYPE = "TEXT":U THEN
            setAttributeChar("INSTANCE":U,b_U._SUBTYPE,cLabel, cValue,dObject_obj).
         ELSE  /* Normal action */
            setAttributeChar("INSTANCE":U,b_U._TYPE,cLabel, cValue,dObject_obj).
       END.  /* Visualization Type */
       WHEN "WidgetName":U THEN  /* Not used any more - NAME */
         setAttributeChar("INSTANCE":U,b_U._NAME,cLabel, cValue,dObject_obj).
       WHEN "WIDTH-CHARS":U THEN 
          setAttributeDec("INSTANCE":U,_L._WIDTH,cLabel, cValue,dObject_obj).
       WHEN "WORD-WRAP":U THEN
          setAttributeLog("INSTANCE":U,_F._WORD-WRAP,cLabel, cValue,dObject_obj).
     END CASE.
   END.
 END.
 /* If the dynamic propertysheet is active, retrieve those attribtues that have been modified and assign */
 RUN createDPSAttribute IN THIS-PROCEDURE (cLayout, "INSTANCE":U,dObject_obj,b_U._Window-handle,b_U._HANDLE).
 
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMasterAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setObjectMasterAttributes Procedure 
PROCEDURE setObjectMasterAttributes :
/*------------------------------------------------------------------------------
  Purpose:     To set the attributes for a master dynamic smartObject
  Parameters:  INPUT prRecid - Recid of the _U of the Frame of a Dynamic Viewer
                              or the _U of the Browse of a Dynamic Browser
  Notes:       called from writeObjectToRepository
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER prRecid     AS RECID                NO-UNDO.
 DEFINE INPUT  PARAMETER pdObj       AS DECIMAL              NO-UNDO.
 DEFINE INPUT  PARAMETER pcLayout    AS CHARACTER            NO-UNDO.

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
 DEFINE VARIABLE cResultCode           AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE cDataType             AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE cValue                AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE hPropQuery            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cInheritClasses       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLabel                AS CHARACTER  NO-UNDO.

 DEFINE BUFFER b_U  FOR _U.
 DEFINE BUFFER b2_U FOR _U.

    /* If this is a new master, set SmartObject_obj to unknown */
 IF pdObj = 0 THEN pdObj = ?.

 FIND b_U WHERE RECID(b_U) = prRecid.
 FIND b2_U WHERE b2_U._HANDLE = b_U._WINDOW-HANDLE.
 FIND _C WHERE RECID(_C) = b_U._x-recid NO-ERROR.
 FIND _L WHERE _L._LO-NAME = pcLayout AND _L._u-recid = RECID(b_U) NO-ERROR.

 
 IF pcLayout NE "Master Layout":U THEN
   RUN ProcessCustomAttributes(INPUT "MASTER":U, INPUT pdObj, INPUT RECID(_L)). 
 ELSE DO:
    
    /* get the master Object (if it exists) and determine the attributes that are defined on the master */
    RUN retrieveDesignObject IN ghRepDesignManager 
                  ( INPUT   _P.object_filename,
                    INPUT  IF pcLayout ="Master Layout":U 
                           THEN "{&DEFAULT-RESULT-CODE}":U 
                           ELSE pcLayout,  /* Get  result Codes */
                    OUTPUT TABLE ttObject,
                    OUTPUT TABLE ttPage,
                    OUTPUT TABLE ttLink,
                    OUTPUT TABLE ttUiEvent,
                    OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 
    FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = _P.object_filename AND
               ttObject.tContainerSmartObjectObj          = 0 NO-ERROR.
   
    RUN retrieveDesignClass IN ghRepDesignManager
                     ( INPUT  gcObjClassType,
                       OUTPUT cInheritClasses,
                       OUTPUT TABLE ttClassAttribute ,
                       OUTPUT TABLE ttUiEvent    ) NO-ERROR.  


    IF gcClassName = "DynBrow":U THEN /* if a browser */
    DO:
       RUN collectBrowseColumns( INPUT prRecid,
                                 OUTPUT cBrowseFields,        OUTPUT cEnabledFields,
                                 OUTPUT cBrwsColBGColors,     OUTPUT cBrwsColFGColors,
                                 OUTPUT cBrwsColFonts,        OUTPUT cBrwsColFormats,
                                 OUTPUT cBrwsColLabelBGColors,OUTPUT cBrwsColLabelFGColors,
                                 OUTPUT cBrwsColLabelFonts,   OUTPUT cBrwsColLabels,
                                 OUTPUT cBrwsColWidths).

       IF glMigration AND cEnabledFields EQ "":U THEN
           ASSIGN cEnabledFields = cBrowseFields.
    END.
    
    ASSIGN gcAttributeList = "".
    /* For each attribute check classvalue and compare to Temp table field values */
    FOR EACH ttClassAttribute:
        /* Skip attributes that can only be modified on the class level */
       IF ttClassAttribute.tWhereConstant = "CLASS":U  THEN
           NEXT.

       ASSIGN cValue = ttClassAttribute.tAttributeValue
              cLabel = ttClassAttribute.tAttributeLabel .
       
       FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                AND ttObjectAttribute.tObjectInstanceObj = 0 
                                AND ttObjectAttribute.tAttributeLabel    = cLabel NO-ERROR.
       /* Build string of attributes defined on the master object ,
          These attributes are candidates for removal if the values are the same*/                         
       IF AVAIL ttObjectAttribute THEN 
       DO:
          ASSIGN cValue          = ttObjectAttribute.tAttributeValue
                 gcAttributeList = gcAttributeList + (IF gcAttributeList = "" THEN "" ELSE ",") 
                                                   + ttObjectAttribute.tAttributelabel.       
       END.                                   
       CASE cLabel:
          WHEN "ALLOW-COLUMN-SEARCHING":U THEN
             setAttributeLog("MASTER":U,_C._COLUMN-SEARCHING,cLabel, cValue,pdObj).
          WHEN "AppBuilderTabbing":U THEN 
             setAttributeChar("MASTER":U,_C._TABBING,cLabel,cValue,pdObj).
          WHEN "AUTO-VALIDATE":U THEN
             setAttributeLog("MASTER":U,NOT _C._NO-AUTO-VALIDATE,cLabel,cvalue,pdObj).
          WHEN "BGCOLOR":U THEN
             setAttributeInt("MASTER":U,_L._BGCOLOR,cLabel,cValue,pdObj).
          WHEN "BrowseColumnBGColors":U THEN
             setAttributeChar("MASTER":U,cBrwsColBGColors,cLabel,cValue,pdObj).
          WHEN "BrowseColumnFGColors":U THEN
             setAttributeChar("MASTER":U,cBrwsColFGColors,cLabel,cValue,pdObj).
          WHEN "BrowseColumnFonts":U THEN
             setAttributeChar("MASTER":U,cBrwsColFonts,cLabel,cValue,pdObj).
          WHEN "BrowseColumnFormats":U THEN
             setAttributeChar("MASTER":U,cBrwsColFormats,cLabel,cValue,pdObj).
          WHEN "BrowseColumnLabelBGColors":U THEN
             setAttributeChar("MASTER":U,cBrwsColLabelBGColors,cLabel,cValue,pdObj).
          WHEN "BrowseColumnLabelFGColors":U THEN
             setAttributeChar("MASTER":U,cBrwsColLabelFGColors,cLabel,cValue,pdObj).
          WHEN "BrowseColumnLabelFonts":U THEN
             setAttributeChar("MASTER":U,cBrwsColLabelFonts,cLabel,cValue,pdObj).
          WHEN "BrowseColumnLabels":U THEN
             setAttributeChar("MASTER":U,cBrwsColLabels,cLabel,cValue,pdObj).
          WHEN "BrowseColumnWidths":U THEN
             setAttributeChar("MASTER":U,cBrwsColWidths,cLabel,cValue,pdObj).
          WHEN "BOX":U THEN
               setAttributeLog("MASTER":U,NOT _L._NO-BOX,cLabel, cValue,pdObj).
          WHEN "BOX-SELECTABLE":U THEN
              setAttributeLog("MASTER":U,_C._BOX-SELECTABLE,cLabel, cValue,pdObj).
          WHEN "COLUMN-MOVABLE":U THEN
            setAttributeLog("MASTER":U,_C._COLUMN-MOVABLE,cLabel, cValue,pdObj).
          WHEN "COLUMN-RESIZABLE":U THEN
             setAttributeLog("MASTER":U,_C._COLUMN-RESIZABLE,cLabel, cValue,pdObj).
          WHEN "COLUMN-SCROLLING":U THEN
              setAttributeLog("MASTER":U,_C._COLUMN-SCROLLING,cLabel, cValue,pdObj).
          WHEN "CONTEXT-HELP-ID":U THEN
              setAttributeInt("MASTER":U,_U._CONTEXT-HELP-ID,cLabel, cValue,pdObj).
          WHEN "DisplayedFields":U THEN
             setAttributeChar("MASTER":U,cBrowseFields,cLabel,cValue,pdObj).
          WHEN "DOWN":U THEN
            setAttributeLog("MASTER":U,_C._DOWN,cLabel, cValue,pdObj).
          WHEN "DROP-TARGET":U THEN
            setAttributeLog("MASTER":U,b_U._DROP-TARGET,cLabel, cValue,pdObj).
          WHEN "EnabledFields":U THEN
            setAttributeChar("MASTER":U,cEnabledFields,cLabel,cValue,pdObj).
          WHEN "FGCOLOR":U THEN
              setAttributeInt("MASTER":U,_L._FGCOLOR,cLabel, cValue,pdObj).
          WHEN "FIT-LAST-COLUMN":U THEN
              setAttributeLog("MASTER":U,_C._FIT-LAST-COLUMN,cLabel, cValue,pdObj).
          WHEN "FolderWindowToLaunch":U THEN
              setAttributeChar("MASTER":U,_C._FOLDER-WINDOW-TO-LAUNCH,cLabel,cValue,pdObj).
          WHEN "FONT":U THEN
            setAttributeInt("MASTER":U,_L._FONT,cLabel, cValue,pdObj).
          WHEN "HELP":U THEN
              setAttributeChar("MASTER":U, b_U._HELP,cLabel,cValue,pdObj).
          WHEN "HIDDEN":U THEN
            setAttributeLog("MASTER":U,b_U._HIDDEN,cLabel,cValue,pdObj).
          WHEN "MANUAL-HIGHLIGHT":U THEN
            setAttributeLog("MASTER":U,b_U._MANUAL-HIGHLIGHT,cLabel,cValue,pdObj).
          WHEN "MAX-DATA-GUESS":U THEN
            setAttributeInt("MASTER":U, _C._MAX-DATA-GUESS,cLabel, cValue,pdObj).
          WHEN "MinHeight":U THEN
             setAttributeDec("MASTER":U, gdMinHeight,cLabel, cValue,pdObj).
          WHEN "MinWidth":U THEN
             setAttributeDec("MASTER":U, gdMinWidth,cLabel, cValue,pdObj).
          WHEN "MOVABLE":U THEN
            setAttributeLog("MASTER":U,b_U._MOVABLE,cLabel,cValue,pdObj).
          WHEN "MULTIPLE":U THEN
            setAttributeLog("MASTER":U,_C._MULTIPLE,cLabel,cValue,pdObj).
          WHEN "NO-EMPTY-SPACE":U THEN
            setAttributeLog("MASTER":U, _C._NO-EMPTY-SPACE,cLabel,cValue,pdObj).
          WHEN "NUM-LOCKED-COLUMNS":U THEN
             setAttributeInt("MASTER":U, _C._NUM-LOCKED-COLUMNS,cLabel,cValue,pdObj).
          WHEN "OVERLAY":U THEN
            setAttributeLog("MASTER":U, _C._OVERLAY,cLabel,cValue,pdObj).
          WHEN "PAGE-BOTTOM":U THEN
            setAttributeLog("MASTER":U, _C._PAGE-BOTTOM,cLabel,cValue,pdObj).
          WHEN "PAGE-TOP":U THEN
            setAttributeLog("MASTER":U, _C._PAGE-TOP,cLabel,cValue,pdObj).
          WHEN "PRIVATE-DATA":U THEN
             setAttributeChar("MASTER":U, b_U._PRIVATE-DATA,cLabel,cValue,pdObj).
          WHEN "RESIZABLE":U THEN
            setAttributeLog("MASTER":U, b_U._RESIZABLE,cLabel,cValue,pdObj).
          WHEN "ROW-HEIGHT-CHARS":U THEN
             setAttributeDec("MASTER":U,_C._ROW-HEIGHT,cLabel,cValue,pdObj).
          WHEN "ROW-MARKERS":U THEN
            setAttributeLog("MASTER":U,NOT _C._NO-ROW-MARKERS,cLabel,cValue,pdObj).
          WHEN "SCROLLABLE":U THEN
            setAttributeLog("MASTER":U,_C._SCROLLABLE,cLabel,cValue,pdObj).
          WHEN "SCROLLBAR-VERTICAL":U THEN
             setAttributeLog("MASTER":U, b_U._SCROLLBAR-V,cLabel,cValue,pdObj).
          WHEN "SELECTABLE":U THEN
             setAttributeLog("MASTER":U, b_U._SELECTABLE,cLabel,cValue,pdObj).
          WHEN "SENSITIVE":U THEN
             setAttributeLog("MASTER":U, b_U._SENSITIVE,cLabel,cValue,pdObj).
          WHEN "SEPARATOR-FGCOLOR":U OR 
            WHEN "SeparatorFGColor":U THEN
             setAttributeInt("MASTER":U,_L._SEPARATOR-FGCOLOR,cLabel,cValue,pdObj).
          WHEN "SEPARATORS":U THEN
            setAttributeLog("MASTER":U, _L._SEPARATORS,cLabel,cValue,pdObj).
          WHEN "ShowPopup":U THEN
            setAttributeLog("MASTER":U, b_U._SHOW-POPUP,cLabel,cValue,pdObj).
          WHEN "SIDE-LABELS":U THEN
             setAttributeLog("MASTER":U,_C._SIDE-LABELS,cLabel,cValue,pdObj).
          WHEN "SizeToFit" THEN
            setAttributeLog("MASTER":U,_C._SIZE-TO-FIT,cLabel,cValue,pdObj).
          WHEN "SuperProcedure":U THEN
               setAttributeChar("MASTER":U, IF _C._CUSTOM-SUPER-PROC = ? THEN "" ELSE _C._CUSTOM-SUPER-PROC,cLabel,cValue,pdObj).
          WHEN "TAB-STOP":U THEN
            setAttributeLog("MASTER":U,NOT b_U._NO-TAB-STOP,cLabel,cValue,pdObj).
          WHEN "THREE-D":U THEN
            setAttributeLog("MASTER":U,_L._3-D,cLabel,cValue,pdObj).
          WHEN "TITLE":U THEN
            setAttributeLog("MASTER":U,_C._TITLE,cLabel,cValue,pdObj).
          WHEN "TOOLTIP":U THEN
            setAttributeChar("MASTER":U, b_U._TOOLTIP,cLabel,cValue,pdObj).
          WHEN "WindowTitleField":U THEN 
              setAttributeChar("MASTER":U,_C._WINDOW-TITLE-FIELD,cLabel,cValue,pdObj).
           
       END CASE.
    END. /* For each ttClassAttribtue */
 END.
 
 /* If the dynamic propertysheet is active, retrieve those attribtues that have been modified and assign */
 RUN createDPSAttribute IN THIS-PROCEDURE (pcLayout, "MASTER":U,pdObj,b2_U._Window-handle,b2_U._HANDLE).

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFInstanceAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSDFInstanceAttributes Procedure 
PROCEDURE setSDFInstanceAttributes :
/*------------------------------------------------------------------------------
  Purpose:    Sets attributes for SmartDataFields. 
  Parameters:  <none>
  Notes:      Called from setSmartDataFieldvalues 
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER puRecid       AS RECID      NO-UNDO.
 DEFINE INPUT  PARAMETER pcLayout      AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER dObject_obj   AS DECIMAL    NO-UNDO.
 DEFINE INPUT  PARAMETER pcClass       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcObjFileName AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcFldname     AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cInherit     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLabel       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectValue AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cABValue     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iABVALUE     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lABValue     AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hTmp         AS HANDLE     NO-UNDO.

 DEFINE BUFFER b_U       FOR _U.
 DEFINE BUFFER mstr_L    FOR _L.

 FIND b_U WHERE RECID(b_U) = puRecid.
 FIND _S WHERE RECID(_S) = b_U._x-recid.
 FIND _L WHERE _L._LO-NAME = pcLayout AND _L._u-recid = RECID(b_U).
 IF pcLayout NE "Master Layout":U THEN
    FIND mstr_L WHERE mstr_L._LO-NAME = "Master Layout":U AND mstr_L._u-recid = RECID(b_U).

 IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassName = pcClass) THEN
    RUN retrieveDesignClass IN ghRepDesignManager
                   ( INPUT  pcClass,
                     OUTPUT cInherit,
                     OUTPUT TABLE ttClassAttribute ,
                     OUTPUT TABLE ttUiEvent    ) NO-ERROR. 

 /* Retrieve SDF instance to calculate it's attributes defined on the instance level */
 RUN retrieveDesignObject IN ghRepDesignManager 
               (INPUT gcContainer,     INPUT  IF pcLayout ="Master Layout":U OR pcLayout = ""
                                              THEN "":U 
                                              ELSE pcLayout,  /* Get  result Codes */
                OUTPUT TABLE ttObject, OUTPUT TABLE ttPage,
                OUTPUT TABLE ttLink,   OUTPUT TABLE ttUiEvent,
                OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 
 
 FIND FIRST ttObject WHERE ttObject.tLogicalObjectName        = pcObjFileName
                       AND ttObject.tObjectInstanceObj        = dObject_obj  NO-ERROR.
  
 ASSIGN gcAttributeList = "".
 FOR EACH ttClassAttribute:
     /* Skip attributes that can only be modified on the class or MAster level */
    IF ttClassAttribute.tWhereConstant = "CLASS":U  
    OR ttClassAttribute.tWhereConstant = "MASTER":U  THEN
       NEXT.
        
    ASSIGN clabel       = ttClassAttribute.tAttributeLabel
           cObjectValue = ttClassAttribute.tAttributeValue.
    /* Get the value stored on the instance  */
    FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                             AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                             AND ttObjectAttribute.tAttributeLabel    = cLabel NO-ERROR.
    IF AVAIL ttObjectAttribute THEN
       ASSIGN cObjectValue    = ttObjectAttribute.tAttributeValue
              gcAttributeList = gcAttributeList + (IF gcAttributeList = "" THEN "" ELSE ",") 
                                                + ttObjectAttribute.tAttributelabel.
    /* if not avail, check the master */
    ELSE DO:
       FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                               AND ttObjectAttribute.tObjectInstanceObj  = 0
                               AND ttObjectAttribute.tAttributeLabel     = cLabel NO-ERROR.
       IF AVAIL ttObjectAttribute THEN
          cObjectValue = ttObjectAttribute.tAttributeValue.   
    END. 
    RELEASE ttObjectAttribute.
    /* Find the master to be used to compare against the appBuilder value */
    FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                             AND ttObjectAttribute.tObjectInstanceObj  = 0
                             AND ttObjectAttribute.tAttributeLabel     = cLabel NO-ERROR.
    CASE cLabel:
      WHEN "BaseQueryString":U OR  WHEN "BrowseFieldDataTypes":U OR WHEN "BrowseFieldFormats":U OR
      WHEN "BrowseFields":U    OR  WHEN "BrowseTitle":U          OR WHEN "ColumnFormat":U OR
      WHEN "ColumnLabels":U    OR  WHEN "ComboFlag":U            OR WHEN "DescSubstitute":U OR
      WHEN "DisplayDataType":U OR  WHEN "DisplayedField":U       OR WHEN "DisplayFormat":U OR
      WHEN "FieldLabel":U      OR  WHEN "FieldName":U            OR WHEN "FieldToolTip":U OR
      WHEN "FlagValue":U       OR  WHEN "KeyDataType"            OR WHEN "KeyField":U OR
      WHEN "KeyFormat":U       OR  WHEN "LinkedFieldDataTypes":U OR WHEN "LinkedFieldFormats":U OR
      WHEN "LookupImage":U     OR  WHEN "MaintenanceObject":U    OR WHEN "MaintenanceSDO":U OR
      WHEN "ParentField":U     OR  WHEN "ParentFilterQuery":U    OR WHEN "QueryTables":U OR
      WHEN "SDFTemplate":U     OR  WHEN "ViewerLinkedFields":U   OR WHEN "ViewerLinkedWidgets":U OR
      WHEN "MappedFields":U    OR  WHEN "UseCache":U
      THEN DO:
        cABValue = DYNAMIC-FUNCTION('get':U + cLabel IN _S._HANDLE) NO-ERROR.
        IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
        DO:
           IF (AVAIL ttObjectAttribute AND cABValue EQ ttObjectAttribute.tAttributeValue)
           OR (NOT AVAIL ttObjectAttribute  AND cABValue EQ ttClassAttribute.tAttributeValue) THEN
              RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
           ELSE IF cABValue <> cObjectValue AND pcLayout EQ "Master Layout":U THEN
              RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&CHARACTER-DATA-TYPE},cABValue,?,?,?,?,?).
        END.   
        ELSE IF cABValue NE cObjectValue AND pcLayout EQ "Master Layout":U THEN
            RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&CHARACTER-DATA-TYPE},cABValue,?,?,?,?,?). 
      END.
      
      WHEN "SDFFileName":U THEN DO:
        cABValue = DYNAMIC-FUNCTION('get':U + cLabel IN _S._HANDLE) NO-ERROR.
        IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
        DO:
           IF (AVAIL ttObjectAttribute AND cABValue EQ ttObjectAttribute.tAttributeValue)
           OR (NOT AVAIL ttObjectAttribute  AND cABValue EQ ttClassAttribute.tAttributeValue) THEN
              RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
           ELSE IF cABValue <> cObjectValue AND cABValue NE "":U THEN
              RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&CHARACTER-DATA-TYPE},cABValue,?,?,?,?,?).
        END.   
        ELSE IF cABValue NE cObjectValue AND cABValue NE "":U THEN
            RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&CHARACTER-DATA-TYPE},cABValue,?,?,?,?,?). 
      END.
      
      WHEN "BuildSequence":U  OR  WHEN "InnerLines":U OR WHEN "RowsToBatch":U
      THEN DO:
        iABValue = DYNAMIC-FUNCTION('get' + cLabel IN _S._HANDLE) NO-ERROR.
        setAttributeInt("INSTANCE":U,iABValue,cLabel, cObjectValue,dObject_obj).
      END.
      WHEN "DisplayField":U    OR WHEN "DisableOnInit":U    OR WHEN "EnableField":U OR
      WHEN "LocalField":U      OR WHEN "BlankOnNotAvail":U  OR WHEN "PopupOnAmbiguous":U OR
      WHEN "PopupOnNotAvail":U OR WHEN "PopupOnUniqueAmbiguous":U
      THEN DO:
        lABValue = DYNAMIC-FUNCTION('get':U + cLabel IN _S._HANDLE) NO-ERROR.
        setAttributeLog("INSTANCE":U,lABValue,cLabel, cObjectValue,dObject_obj).
      END.
      
      WHEN "COLUMN":U THEN
      IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
      DO:
         IF (AVAIL ttObjectAttribute AND _L._COL EQ DECIMAL(ttObjectAttribute.tAttributeValue))
         OR (NOT AVAIL ttObjectAttribute  AND _L._COL EQ DECIMAL(ttClassAttribute.tAttributeValue)) THEN
            RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
         ELSE IF _L._COL <> DEC(cObjectValue) AND (pcLayout EQ "Master Layout":U OR _L._COL NE mstr_L._COL)THEN
           RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&DECIMAL-DATA-TYPE},?,_L._COL,?,?,?,?).
      END.   
      ELSE IF _L._COL NE DEC(cObjectValue) AND (pcLayout EQ "Master Layout":U OR _L._COL NE mstr_L._COL) THEN
        RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&DECIMAL-DATA-TYPE},?,_L._COL,?,?,?,?). 
      
      WHEN "FieldName":U THEN
      IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
      DO:
         IF (AVAIL ttObjectAttribute AND pcFldname EQ ttObjectAttribute.tAttributeValue)
         OR (NOT AVAIL ttObjectAttribute  AND pcFldname EQ ttClassAttribute.tAttributeValue) THEN
            RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
         ELSE IF pcFldname <> cObjectValue AND pcLayout EQ "Master Layout":U THEN
            RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&CHARACTER-DATA-TYPE},pcFldname,?,?,?,?,?).
      END.   
      ELSE IF pcFldname NE cObjectValue AND pcFldname NE "":U THEN
         RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&CHARACTER-DATA-TYPE},pcFldname,?,?,?,?,?). 
      
      WHEN "HEIGHT-CHARS":U THEN
      IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
      DO:
         IF (AVAIL ttObjectAttribute AND _L._HEIGHT EQ DECIMAL(ttObjectAttribute.tAttributeValue))
         OR (NOT AVAIL ttObjectAttribute  AND _L._HEIGHT EQ DECIMAL(ttClassAttribute.tAttributeValue)) THEN
            RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
         ELSE IF _L._HEIGHT <> DEC(cObjectValue) AND (pcLayout EQ "Master Layout":U OR _L._HEIGHT NE mstr_L._HEIGHT)THEN
           RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&DECIMAL-DATA-TYPE},?,_L._HEIGHT,?,?,?,?).
      END.   
      ELSE IF _L._HEIGHT NE DEC(cObjectValue) AND (pcLayout EQ "Master Layout":U OR _L._HEIGHT NE mstr_L._HEIGHT) THEN
        RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&DECIMAL-DATA-TYPE},?,_L._HEIGHT,?,?,?,?).       
      
      WHEN "HideOnInit":U THEN 
      IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
      DO:
         IF (AVAIL ttObjectAttribute AND _L._REMOVE-FROM-LAYOUT EQ LOGICAL(ttObjectAttribute.tAttributeValue))
         OR (NOT AVAIL ttObjectAttribute  AND _L._REMOVE-FROM-LAYOUT EQ LOGICAL(ttClassAttribute.tAttributeValue)) THEN
            RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
         ELSE IF _L._REMOVE-FROM-LAYOUT <> LOGICAL(cObjectValue) 
              AND (pcLayout EQ "Master Layout":U OR _L._REMOVE-FROM-LAYOUT NE mstr_L._REMOVE-FROM-LAYOUT) THEN
            RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&LOGICAL-DATA-TYPE},?,?,?,_L._REMOVE-FROM-LAYOUT,?,?).
      END.   
      ELSE IF _L._REMOVE-FROM-LAYOUT NE LOGICAL(cObjectValue) 
           AND (pcLayout EQ "Master Layout":U OR _L._REMOVE-FROM-LAYOUT NE mstr_L._REMOVE-FROM-LAYOUT) THEN
         RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&LOGICAL-DATA-TYPE},?,?,?,_L._REMOVE-FROM-LAYOUT,?,?).
            
      WHEN "MasterFile":U THEN
      IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
      DO:
         IF (AVAIL ttObjectAttribute AND _S._FILE-NAME EQ ttObjectAttribute.tAttributeValue)
         OR (NOT AVAIL ttObjectAttribute  AND _S._FILE-NAME EQ ttClassAttribute.tAttributeValue) THEN
            RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
         ELSE IF _S._FILE-NAME <> cObjectValue AND pcLayout EQ "Master Layout":U THEN
            RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&CHARACTER-DATA-TYPE},_S._FILE-NAME,?,?,?,?,?).
      END.   
      ELSE IF _S._FILE-NAME NE cObjectValue AND pcLayout EQ "Master Layout":U THEN
         RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&CHARACTER-DATA-TYPE},_S._FILE-NAME,?,?,?,?,?). 
         
      WHEN "ROW":U THEN
      IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
      DO:
         IF (AVAIL ttObjectAttribute AND _L._ROW EQ DECIMAL(ttObjectAttribute.tAttributeValue))
         OR (NOT AVAIL ttObjectAttribute  AND  _L._ROW EQ DECIMAL(ttClassAttribute.tAttributeValue)) THEN
            RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
         ELSE IF _L._ROW <> DEC(cObjectValue) AND (pcLayout EQ "Master Layout":U OR _L._ROW NE mstr_L._ROW)THEN
           RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&DECIMAL-DATA-TYPE},?,_L._ROW,?,?,?,?).
      END.   
      ELSE IF _L._ROW NE DEC(cObjectValue) AND (pcLayout EQ "Master Layout":U OR _L._ROW NE mstr_L._ROW) THEN
        RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&DECIMAL-DATA-TYPE},?,_L._ROW,?,?,?,?). 
        
      WHEN "WIDTH-CHARS":U THEN
      IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
      DO:
         IF (AVAIL ttObjectAttribute AND _L._WIDTH EQ DECIMAL(ttObjectAttribute.tAttributeValue))
         OR (NOT AVAIL ttObjectAttribute  AND  _L._WIDTH EQ DECIMAL(ttClassAttribute.tAttributeValue)) THEN
            RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
         ELSE IF _L._WIDTH <> DEC(cObjectValue) AND (pcLayout EQ "Master Layout":U OR _L._WIDTH NE mstr_L._WIDTH)THEN
           RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&DECIMAL-DATA-TYPE},?,_L._WIDTH,?,?,?,?).
      END.   
      ELSE IF _L._WIDTH NE DEC(cObjectValue) AND (pcLayout EQ "Master Layout":U OR _L._WIDTH NE mstr_L._WIDTH) THEN
        RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&DECIMAL-DATA-TYPE},?,_L._WIDTH,?,?,?,?). 
        
      WHEN "Order":U THEN
      DO:
        IF b_U._TAB-ORDER NE INTEGER(cObjectValue) THEN
        DO:
          /* The order attribute will be deprecated, the rendering currently uses
             object sequence for tab order but the order attribute is still maintained
             and kept in sync with _U._TAB-ORDER by the AppBuilder. */
          FIND ryc_object_instance WHERE 
            ryc_object_instance.object_instance_obj = dObject_obj EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE ryc_object_instance THEN
            ryc_object_instance.object_sequence = b_U._TAB-ORDER.
          RELEASE ryc_object_instance.
        END.
        IF LOOKUP(clabel,gcAttributeList) > 0 THEN 
        DO:
           IF (AVAIL ttObjectAttribute AND b_U._TAB-ORDER EQ INTEGER(ttObjectAttribute.tAttributeValue))
           OR (NOT AVAIL ttObjectAttribute  AND  b_U._TAB-ORDER EQ INTEGER(ttClassAttribute.tAttributeValue)) THEN
              RUN DeleteAttributeRow (INPUT "INSTANCE":U, INPUT dObject_obj, INPUT cLabel).       
           ELSE IF b_U._TAB-ORDER <> INTEGER(cObjectValue) AND pcLayout EQ "Master Layout":U THEN
              RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&INTEGER-DATA-TYPE},?,?,b_U._TAB-ORDER,?,?,?).
        END.   
        ELSE IF b_U._TAB-ORDER NE INTEGER(cObjectValue) AND pcLayout EQ "Master Layout":U  THEN
          RUN CreateAttributeRow("INSTANCE":U,dObject_obj,cLabel,{&INTEGER-DATA-TYPE},?,?,b_U._TAB-ORDER,?,?,?). 
      END.  /* when order */
    END CASE.
 END. /* End for each ttClassAttrtibute */

 RUN createDPSAttribute IN THIS-PROCEDURE (pcLayout, "INSTANCE":U,dObject_obj,b_U._Window-handle,b_U._HANDLE).

 hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
 RUN StoreAttributeValues IN gshRepositoryManager
      (INPUT hTmp,
       INPUT TABLE-HANDLE ghUnknown) NO-ERROR.  /* Compiler requires a variable with unknown */
 IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
    RUN AppendToPError (RETURN-VALUE).
  
 IF CAN-FIND(FIRST DeleteAttribute) THEN DO:
    hTmp = TEMP-TABLE DeleteAttribute:DEFAULT-BUFFER-HANDLE.
    RUN RemoveAttributeValues IN ghRepDesignManager
       (INPUT hTmp,
         INPUT TABLE-HANDLE ghUnknown)  NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
        RUN AppendToPError ( RETURN-VALUE).
        RETURN.
    END.
    EMPTY TEMP-TABLE DeleteAttribute NO-ERROR.
 END.

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
               called from writeFieldLevelObjects
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER puRecid     AS RECID      NO-UNDO.
 DEFINE INPUT  PARAMETER dViewer_obj AS DECIMAL    NO-UNDO.
 DEFINE INPUT  PARAMETER pcLayout    AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE cAttrDiffs      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cError          AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cClass          AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cOBJFileName    AS CHARACTER NO-UNDO.
 DEFINE VARIABLE dSDFObj         AS DECIMAL   NO-UNDO.
 DEFINE VARIABLE dObject_obj     AS DECIMAL   NO-UNDO.
 DEFINE VARIABLE cFileNameNoPath AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cFldName        AS CHARACTER NO-UNDO.
 
 DEFINE BUFFER b_U  FOR _U.
 
 FIND b_U WHERE RECID(b_U) = puRecid.
 FIND _S WHERE RECID(_S) = b_U._x-recid.
 FIND _L WHERE _L._LO-NAME = pcLayout AND _L._u-recid = RECID(b_U).
 
 ASSIGN _S._FILE-NAME = REPLACE(_S._FILE-NAME, "~\":U, "~/":U)
         dObject_obj = b_U._OBJECT-OBJ. /* object obj of the SDF Instance*/ 
 /* We need to determine the associated class for the SDF field. If it is not already
    stored in the _U._Class-name field (i.e. if the .cst isn't from the repository, or we are converting,
    or we are saving a static viewer as dynamic, then _class-name is blank), then calculate the class. */
 CASE _S._FILE-NAME:
   WHEN "adm2/dyncombo.w":U  THEN cClass = "DynCombo":U.
   WHEN "adm2/dynlookup.w":U THEN cClass = "DynLookup":U.
   WHEN "adm2/dynselect.w":U THEN /* We don't support smartSelects for dynamic viewers. */
   DO:
      cError = {aferrortxt.i 'AF' '5' '?' '?' "'SmartSelect SDF for field ' + b_U._NAME "}.
      RUN AppendToPError (INPUT cError).
      RETURN.
   END.
   OTHERWISE DO:
     cFileNameNoPath = ENTRY(NUM-ENTRIES(_S._FILE-NAME,"~/":U), _S._FILE-NAME, "~/":U).
     /* We have found the SDF, get some info */
     RUN retrieveDesignObject IN ghRepDesignManager 
            (INPUT  cFileNameNoPath,  INPUT  IF pcLayout ="Master Layout":U OR pcLayout = ""
                                             THEN "{&DEFAULT-RESULT-CODE}":U 
                                             ELSE pcLayout,  /* Get  result Codes */
             OUTPUT TABLE ttObject,   OUTPUT TABLE ttPage,
             OUTPUT TABLE ttLink,     OUTPUT TABLE ttUiEvent,
             OUTPUT TABLE ttObjectAttribute ) NO-ERROR.

     IF RETURN-VALUE > "":U THEN
     DO:
       /* Due to bug in retrieveDesignObject, need to refind object without extension */
        cFileNameNoPath = ENTRY(1,cFileNameNoPath,".":U).  
        RUN retrieveDesignObject IN ghRepDesignManager 
                  (INPUT  cFileNameNoPath,  INPUT  IF pcLayout ="Master Layout":U OR pcLayout = ""
                                                   THEN "{&DEFAULT-RESULT-CODE}":U 
                                                   ELSE pcLayout,  /* Get  result Codes */
                   OUTPUT TABLE ttObject,   OUTPUT TABLE ttPage,
                   OUTPUT TABLE ttLink,     OUTPUT TABLE ttUiEvent,
                   OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
        IF RETURN-VALUE > "":U THEN
        DO:
           cError = {aferrortxt.i 'RY' '15' '?' '?' "_S._FILE-NAME"}.
           RUN AppendToPError (INPUT cError).
           RETURN.
        END.
     END.         
     
     FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = cFileNameNoPath 
                           AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR. 
     IF AVAIL ttObject THEN
       ASSIGN cClass            = ttObject.tClassName
              b_U._CLASS-NAME   = ttObject.tClassName
              cOBJFilename      = ttObject.tLogicalObjectName.            
   END. /* Otherwise */
 END CASE.

 /* If the getSDFFileName procedure is in the SDF, call it to return the master SDF file name that is
    stored in the repository. This procedure is in the Dynamics provided dyncombo and dynlookup supers */
 IF VALID-HANDLE(_S._HANDLE) AND LOOKUP("getSDFFileName":U,_S._HANDLE:INTERNAL-ENTRIES) > 0 THEN  
    cOBJFileName = DYNAMIC-FUNCTION('getSDFFileName' IN _S._HANDLE) NO-ERROR. 
    
 /* Ensure the master object exists */
 IF NOT DYNAMIC-FUNCTION("ObjectExists":U IN ghRepDesignManager,INPUT cOBJFileName) THEN
 DO:
     cError = {aferrortxt.i 'RY' '15' '?' '?' "cOBJFileName"}.
     RUN AppendToPError (INPUT cError).
     RETURN.
 END.
 
 IF VALID-HANDLE(_S._HANDLE) THEN
    cFldName = DYNAMIC-FUNCTION('getFieldName' IN _S._HANDLE) NO-ERROR.
    
 /* User may have changed the name */
 IF cFldName NE b_U._Name THEN 
 DO:
   /* If this was a static viewer saved as a dynamic viewer,
      set the name (instance name) equal to the SDF fieldname */
   IF b_U._Object-Name = "" THEN
     ASSIGN b_U._NAME       = cFldName
            b_U._CLASS-NAME = cClass.
   ELSE DO:
      ASSIGN cFldName = b_U._name.
      DYNAMIC-FUNCTION('setFieldName' IN _S._HANDLE, cFldName).
      IF dObject_obj > 0 THEN /* The instance already exists */
        RUN renameObjectInstance IN ghRepDesignManager 
                (dObject_obj, b_U._NAME)  NO-ERROR.
   END.              
 END. /* If the name has changed */

 /* CUSTOM LAYOUTS */
 IF pcLayout NE "Master Layout":U THEN 
 DO:
   cAttrDiffs = CheckCustomChanges(RECID(_L), FALSE). /* Don't do these customizations now */
   /* Need to get the object_obj of the customization if it exists */
   FIND ryc_object_instance WHERE
        ryc_object_instance.container_smartobject_obj = dViewer_obj AND
        ryc_object_instance.instance_name = cObjFileName
      NO-LOCK NO-ERROR.
   dObject_obj = IF AVAILABLE ryc_object_instance 
                 THEN ryc_object_instance.object_instance_obj 
                 ELSE 0.
   /* If customization is like the master, remove the custom layout and return */
   IF cAttrDiffs = "":U THEN 
   DO:
     RUN removeObjectInstance IN ghRepDesignManager
           ( INPUT gcContainer,     /* Container name        */
             INPUT pcLayout,         /* Container result code */
             INPUT "":U,            /* pcInstanceObjectName  */
             INPUT cObjFileName,    /* pcInstanceName        */
             INPUT pcLayout   )     /* Instance resultCode   */
           NO-ERROR.
     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN 
       RUN AppendToPError ( RETURN-VALUE).
     RETURN.
   END.  
 END.

 /* Create this object in the repository if it doesn't exist */
 IF (pcLayout = "Master Layout":U AND b_U._Object-OBJ = 0) 
   OR (pcLayout NE "Master Layout":U AND dObject_Obj = 0) THEN 
 DO:

   RUN insertObjectInstance IN ghRepDesignManager
       ( dViewer_obj,                  /* Container Viewer   */
         cOBJFileName,                 /* Object Name        */                  
         IF pcLayout = "Master Layout":U
         THEN "":U ELSE pcLayout,       /* Result Code       */
         b_U._NAME,                    /* Instance Name      */
         "SmartDataField of type ":U + cClass, /* Descr.     */
         "":U,                         /* Layout Position    */
         ?,                            /* Page number - NA   */
         b_U._TAB-ORDER,               /* Page sequence - NA */
         NO,                           /* Force creation     */
         ?,                            /* attribute buffer   */
         TABLE-HANDLE ghUnknown,        /* atribute Table handle */
        OUTPUT dSDFObj,                     /* Master obj    */
        OUTPUT dObject_Obj )                /* Instance Obj  */
        NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
       RUN AppendToPError ( RETURN-VALUE).
       RETURN.
    END.

 END.  /* Creating a new instance in the viewer */
 
 /* Set the SDF attributes */
 RUN setSDFInstanceAttributes (puRecid, pclayout,dObject_Obj,cClass,cObjFilename,cFldname).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-superProcEventReg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE superProcEventReg Procedure 
PROCEDURE superProcEventReg :
/*------------------------------------------------------------------------------
  Purpose:     For a new super procedure that is being migrated,
               register all new events in the repository.
  Parameters:  prRecird     RECID of buf_P table
               pdCustomID   Custom Super procedure smartObjectObj ID
  Notes:       called from writeSuperProc
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hEventBuffer  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cEventName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEventAction  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSelfName     AS CHARACTER  NO-UNDO.
 
 DEFINE BUFFER buf_P FOR _P.
 DEFINE BUFFER buf_U FOR _U.
 DEFINE BUFFER buf_TRG FOR _TRG.

 FIND buf_P WHERE RECID(buf_P) = gprPrecid .

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
 RUN insertUIEvents IN ghRepDesignManager
            (INPUT hEventBuffer ,
             INPUT TABLE-HANDLE ghUnknown) NO-ERROR.  /* Compiler requires a variable with unknown */

 IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
    RUN AppendToPError (RETURN-VALUE).
    RETURN.
 END.

 /* Empty the temp-table */
 EMPTY TEMP-TABLE ttStoreUIEvent.


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
             cLayout Layout of viewer
      Notes:  called from main-block and recursively
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcLayout AS CHARACTER      NO-UNDO.
 
 DEFINE BUFFER b_U             FOR _U.
 DEFINE BUFFER m_L             FOR _L.

 /* b_U is an extra buffer for field level objects */
 DEFINE VARIABLE cAssignList        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAttrDiffs         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalculatedColumns AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCode              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCode              AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cColumnTable       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataSourceType    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDescription       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cError             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cInstanceName      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMasterObjectName  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectTypeCode    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSDOList           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTableAssigns      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTableList         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dSmartViewer       AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hsboSDO            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hTmp               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iTableNum          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iPos               AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lCalculatedField   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE dDynObject_obj     AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE lNewInstance       AS LOGICAL    NO-UNDO.

 /* Get the _P record of the dynamic viewer being written  */
 FIND _P WHERE RECID(_P) = gprPrecid.
 FIND _U WHERE RECID(_U) = _P._u-recid.

 dSmartViewer = _P.SmartOBJECT_obj.  /* default ... should be the case for Master Layout */

  /* Call _tabordr to reset the field's tab order based on the tabbing option
    of the frame */
 RUN adeuib/_tabordr.p (INPUT "NORMAL":U, INPUT grFrameRecid) NO-ERROR.

 FIND FIRST tResultCodes WHERE tResultCodes.cRC = IF pcLayout = "Master Layout":U THEN "" ELSE pcLayout NO-ERROR.
 IF AVAILABLE tResultCodes THEN 
   dSmartViewer = tResultCodes.dContainerObj.

 /* Get the associated SDO of the viewer */
 IF _P._DATA-OBJECT NE "" THEN DO:
     RUN getDataSource (OUTPUT cDataSourceType, OUTPUT cTableList,OUTPUT cAssignList,
                        OUTPUT hDataSource,OUTPUT cSDOList) NO-ERROR.
     IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.                   
 END.                       
 ELSE DO:  /* This is a V8 SmartViewer, find the DB that it is associated with */
   DB-Search:
   FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                      b_U._STATUS = "NORMAL":U AND
                      NOT b_U._NAME BEGINS "_LBL-":U AND
                      b_U._TYPE NE "WINDOW":U AND
                      b_U._TYPE NE "FRAME":U:
      /* Assume that the 1st DBNAME we find is the correct one */
      IF b_U._DBNAME NE "":U AND b_U._DBNAME NE ? THEN DO:
        gcDBName = b_U._DBNAME.
        LEAVE DB-SEARCH.
      END. /* IF we have found a DB name */
   END.  /* FOR EACH b_U child object */
 END.
 /* DELETE INSTANCES  */
 IF pcLayout = "Master Layout":U THEN
    RUN removeDeletedInstances IN THIS-PROCEDURE (INPUT pcLayout, INPUT hDataSource, 
                                                  OUTPUT cCalculatedColumns,OUTPUT cColumnTable).
                                                  
 /* ADD INSTANCES  */
 Child-Search:
 FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                    b_U._STATUS = "NORMAL":U AND
                    NOT b_U._NAME BEGINS "_LBL-":U AND
                    b_U._TYPE NE "WINDOW":U AND
                    b_U._TYPE NE "FRAME":U:
   
   FIND _F WHERE RECID(_F) = b_U._x-recid NO-ERROR.
   FIND _L WHERE _L._LO-NAME = pcLayout AND _L._u-recid = RECID(b_U) NO-ERROR.
   FIND m_L WHERE m_L._LO-NAME = "MASTER LAYOUT":U AND m_L._u-recid = RECID(b_U) NO-ERROR.
   
   IF NOT AVAILABLE _L AND pcLayout NE "MASTER LAYOUT":U THEN 
   DO:
     /* This _U is missing its _L, create one and populate it like the Master */
     CREATE _L.
     ASSIGN _L._LO-NAME = pcLayout
            _L._u-recid = RECID(b_U).
     IF AVAILABLE m_L THEN
       BUFFER-COPY m_L EXCEPT _LO-NAME _u-recid TO _L.
   END.
    /* If this instance belongs for a custom layout only, do not
         insert an instance for the master, only for the custom(s)   */
    IF _L._REMOVE-FROM-LAYOUT AND pcLayout = "Master Layout":U 
                              AND NUM-ENTRIES(gcResultCodes) > 1 THEN 
      
       NEXT Child-Search.
   
   IF (NOT AVAILABLE _F AND b_U._TYPE NE "SmartObject":U)
       OR NOT AVAILABLE _L THEN NEXT Child-Search.

   ASSIGN cColumnTable = "":U
          gcObjectName  = "":U.
   
   IF VALID-HANDLE(hDataSource) THEN DO:
     IF cDataSourceType = "SDO":U THEN DO:
       ASSIGN cColumnTable = DYNAMIC-FUNCTION("columnPhysicalTable":U IN hDataSource, b_U._NAME).
       IF NUM-ENTRIES(cColumnTable, ".":U) = 2 THEN
         cColumnTable = ENTRY(2, cColumnTable, ".":U).
       iTableNum = LOOKUP(cColumnTable, cTableList).
     END. /* If it is an SDO of some kind */
     ELSE /* It must be an SBO */
       ASSIGN cColumnTable = b_U._TABLE  /* A lie, this is not a table but an SDO! */
              iTableNum    = LOOKUP(cColumnTable, cSDOList).
   END.  /* If we have a valid datasource handle */

   /* Determine object Name and see if it is a datafield */
   IF (b_U._TABLE = "RowObject":U OR b_U._BUFFER = "RowObject":U) AND 
       iTableNum > 0 AND VALID-HANDLE(hDataSource) THEN 
   DO:
     /* Determine the name of the datafield and see if it is in the AssignList */
     ASSIGN cTableAssigns = ENTRY(iTableNum, cAssignList, {&adm-tabledelimiter})
            iPos          = LOOKUP(b_U._NAME, cTableAssigns)
            gcObjectName  = IF iPos > 0 AND NUM-ENTRIES(cTableAssigns) > iPos 
                            THEN cColumnTable + ".":U + ENTRY(iPos + 1, cTableAssigns)
                            ELSE cColumnTable + ".":U + b_U._NAME 
                            NO-ERROR.
   END.
   ELSE IF cDataSourceType = "SBO":U AND b_U._object-Name > "" THEN
     gcObjectName = b_U._object-Name.
   ELSE IF (NOT VALID-HANDLE(hDataSource) OR cDataSourceType = "SBO":U) 
          AND b_U._TABLE NE "":U AND b_U._TABLE <> ? THEN  
     /* Construct a datafield name from a V8 SV field or an SBO field */
     ASSIGN gcObjectName = b_U._TABLE + ".":U + b_U._NAME.
   ELSE 
     ASSIGN gcObjectName =  b_U._NAME.  /* Not a data field */

   IF VALID-HANDLE(hDataSource) THEN
     lCalculatedField = LOOKUP(gcObjectName, cCalculatedColumns) > 0.

   /* The class name is based on the palette repository and is assigned  when the object 
      was dropped onto the design window. (adeuib/)drawobj.p)  Verify it.  */
   ASSIGN cObjectTypeCode = b_U._CLASS-NAME
          cObjectTypeCode = verifyObjectType(INPUT b_U._TYPE, INPUT cObjectTypeCode).
   /* If user has changed the visualization, change the object type accordingly.
      This requires removing the instance and recreating it. */
   IF cObjectTypeCode NE b_U._CLASS-NAME AND b_U._CLASS-NAME NE "":U AND b_U._NAME <> "" THEN 
   DO:    /* Do not remove instances if they are only contained on the custom layout */             
     RUN removeObjectInstance IN ghRepDesignManager
                     ( INPUT gcContainer,               /* Container name        */
                       INPUT IF pcLayout = "Master Layout":U 
                             THEN "" ELSE pcLayout, /* Container result code */
                       INPUT "":U,                      /* pcInstanceObjectName  */
                       INPUT b_U._NAME,                 /* pcInstanceName        */
                       INPUT IF pcLayout = "Master Layout":U 
                             THEN "" ELSE pcLayout)     /*  Instance resultCode   */
                       NO-ERROR.
     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN 
     DO:
       RUN AppendToPError (RETURN-VALUE).
       RETURN.
     END.
     ASSIGN b_U._Object-obj  = 0.0  /* Show that this instance doesn't exist and needs to be created */
            b_U._CLASS-NAME  = cObjectTypeCode
            b_U._OBJECT-NAME = "":U.
   END.  /* If user has changed the object type */
   
   ASSIGN dDynObject_obj   = b_U._Object-OBJ.
   
   IF  b_U._TYPE = "SmartObject":U THEN 
   DO:
     FIND _S WHERE RECID(_S) = b_U._x-recid.
     IF b_U._SUBTYPE = "SmartDataField":U THEN DO:
       RUN setSmartDataFieldValues(INPUT RECID(b_U), 
                                   INPUT dSmartViewer, 
                                   INPUT pcLayout ).
       IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
     END.
     ELSE NEXT Child-Search.
   END.

   ELSE IF cObjectTypeCode > "" THEN
   DO:
     /* Before inserting the object instance run objectExists to make sure
        that the master is valid */
    cMasterObjectName = IF b_U._OBJECT-NAME > "" 
                        THEN b_U._OBJECT-NAME
                        ELSE IF gcObjectName > ""  AND NUM-ENTRIES(gcObjectName,".") > 1 
                        THEN gcObjectName ELSE cObjectTypeCode.
    
     /* Check whether the objectName is an extent field. Since brackets are not used in the object name
        for the instances, remove the brackets. */
     ASSIGN cMasterObjectName = REPLACE(cMasterObjectName,"[","")
            cMasterObjectName = REPLACE(cMasterObjectName,"]","").

     IF lCalculatedField AND NUM-ENTRIES(cMasterObjectName, ".":U) = 2 THEN
       cMasterObjectName = ENTRY(2, cMasterObjectName, ".":U).
   
     IF NOT DYNAMIC-FUNCTION("ObjectExists":U IN ghRepDesignManager, INPUT cMasterObjectName) THEN
     DO:
       /* Cannot insert a DataField instance if there is no master */
       cError = {af/sup2/aferrortxt.i 'RY' '14' '?' '?' "gcObjectName"}.
       RUN AppendToPError (INPUT cError).
       NEXT Child-Search.
     END.  /* no master object */

     IF NUM-ENTRIES(gcObjectName,".") = 2 AND cDataSourceType NE "SBO":U AND 
       NOT lCalculatedField THEN
       ASSIGN cInstanceName = b_U._NAME /* Datafield instance names are just the field */
              cDescription  = "DataField of type ":U + b_U._TYPE.
     ELSE
       ASSIGN cInstanceName = b_U._NAME
              cDescription  = "Dynamic ":U + b_U._TYPE.

     IF pcLayout NE "Master Layout":U THEN 
     DO:
       cAttrDiffs = CheckCustomChanges(RECID(_L), FALSE).    /* Don't do these customizations now */

       /* Need to get the object_obj of the customization if it exists */
       FIND ryc_object_instance WHERE
            ryc_object_instance.container_smartobject_obj = dSmartViewer AND
            ryc_object_instance.instance_name = cInstanceName
            NO-LOCK NO-ERROR.
       dDynObject_Obj = IF AVAILABLE ryc_object_instance 
                        THEN ryc_object_instance.object_instance_obj 
                        ELSE 0.
     END.  /* If not the default layout */
     
     IF pcLayout NE "Master Layout":U AND cAttrDiffs = "":U THEN DO:
      RUN removeObjectInstance IN ghRepDesignManager
              ( INPUT gcContainer,                  /* Container name        */
                INPUT pcLayout,                     /* Container result code */
                INPUT "":U,                        /* pcInstanceObjectName  */
                INPUT cInstanceName,               /* pcInstanceName        */
                INPUT pcLayout   )                 /* Instance resultCode   */
             NO-ERROR.

       IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
          RUN AppendToPError (RETURN-VALUE).

       NEXT Child-SEARCH.
     END.  /* If customization is like the master */
     
     /* Create this object in the repository if it doesn't exist */
     ASSIGN lnewInstance = NO.
     
     IF (pcLayout = "Master Layout":U AND b_U._Object-OBJ = 0) OR
        (pcLayout NE "Master Layout":U AND dDynObject_Obj = 0) THEN 
     DO:
       IF pcLayout = "Master Layout":U OR cAttrDiffs NE "":U 
            OR (m_L._REMOVE-FROM-LAYOUT AND pcLayout NE  "Master Layout":U) THEN DO:
         RUN insertObjectInstance IN ghRepDesignManager
           ( INPUT dSmartViewer,             /* Container Viewer                  */
             INPUT cMasterObjectName,        /* Object Name                       */
             INPUT IF pcLayout = "Master Layout":U
                   THEN "":U ELSE pcLayout,   /* Result Code                       */
             INPUT cInstanceName,            /* Instance Name                     */
             INPUT cDescription,             /* Description                       */
             INPUT "":U,                     /* Layout Position                   */
             INPUT ?,                        /* Page number - not applicable */
             INPUT b_U._TAB-ORDER,           /* Page sequence - not applicable */
             INPUT YES,                      /* Force creation                    */
             INPUT ?,                        /* Buffer handle for attribute table */
             INPUT TABLE-HANDLE ghUnknown,    /* Table handle for attribute table  */
             OUTPUT gdSmartObject_obj,        /* Master obj                        */
             OUTPUT dDynObject_Obj ) NO-ERROR.        /* Instance Obj                      */

          IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
             RUN AppendToPError (RETURN-VALUE).
             RETURN.
          END.
         ASSIGN lnewInstance = YES. 
         IF pcLayout = "Master Layout":U THEN 
           ASSIGN b_U._OBJECT-OBJ = dDynObject_obj.
       END. /* if it is the Master or there are differences */
     END. /* End If b_U._Object_obj = 0 it isn't already there */
     IF pcLayout = "Master Layout":U OR cAttrDiffs NE "":U THEN 
     DO:
       RUN setObjectInstanceAttributes (INPUT RECID(b_U),        /* _U with current attributes */
                                        INPUT cMasterObjectName, /* Object Type                    */
                                        INPUT dDynObject_Obj,
                                        INPUT pcLayout,
                                        INPUT lnewInstance) NO-ERROR.
                              
       IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
         
       /* In case the name has changed, write it to the repository now */
       IF NUM-ENTRIES(cInstanceName,".":U) < 2 THEN 
          RUN renameObjectInstance IN ghRepDesignManager 
               (dDynObject_obj, b_U._NAME) NO-ERROR.         
               
     END.
     RUN setObjectEvents (INPUT RECID(b_U),   /* _U with current attributes */
                          INPUT dDynObject_Obj,
                          INPUT "INSTANCE":U,
                          INPUT pcLayout) NO-ERROR.
     IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.

   END.  /* End If cObjecTypeCode > "" When a simple field level object */

  /* Before setting the attributes of a datafield, check them against the 
      master attributes of the datafield.  Remove those which are the same */
   IF (b_U._BUFFER = 'RowObject':U AND cColumnTable NE "":U) OR 
       NUM-ENTRIES(gcObjectName,".":U) = 2 THEN DO:
     RUN checkDataFieldMaster(cMasterObjectName, dDynObject_Obj).
     IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
   END.
   /* Update the Attributes for this object */   
   IF CAN-FIND(FIRST DeleteAttribute) THEN 
   DO:
     hTmp = TEMP-TABLE DeleteAttribute:DEFAULT-BUFFER-HANDLE.
     RUN RemoveAttributeValues IN ghRepDesignManager
        (INPUT hTmp,
         INPUT TABLE-HANDLE ghUnknown) NO-ERROR.
   /*  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
        RUN AppendToPError (IF ERROR-STATUS:ERROR  
                            THEN RETURN-VALUE + "(writeFieldlevelObejcts->RemoveAttributeValues:failed)"  ELSE RETURN-VALUE).
        RETURN.
     END.
     */
   
     EMPTY TEMP-TABLE DeleteAttribute.
   END. 
   
   IF CAN-FIND(FIRST ttStoreAttribute) THEN
   DO:
     hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
 
     RUN StoreAttributeValues IN gshRepositoryManager
         (INPUT hTmp ,
          INPUT TABLE-HANDLE ghUnknown) NO-ERROR.  /* Compiler requires a variable with unknown */
     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
       RUN AppendToPError (RETURN-VALUE).
       RETURN.
     END.
     EMPTY TEMP-TABLE ttStoreAttribute.
   END.
 END. /* End Child Loop */

/* Update the Events for this object */
 IF CAN-FIND(FIRST ttStoreUIEvent) THEN
 DO:
   hTmp = TEMP-TABLE ttStoreUIEvent:DEFAULT-BUFFER-HANDLE.
   RUN insertUIEvents IN ghRepDesignManager
       (INPUT hTmp ,
        INPUT TABLE-HANDLE ghUnknown) NO-ERROR.  /* Compiler requires a variable with unknown */
   IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
     RUN AppendToPError (RETURN-VALUE).
   /* Empty the temp-table */
   EMPTY TEMP-TABLE ttStoreUIEvent.
 END.
 /*Update the events that were deleted */
 IF CAN-FIND(FIRST DeleteUIEvent) THEN
 DO:
   hTmp = TEMP-TABLE DeleteUIEvent:DEFAULT-BUFFER-HANDLE.
   RUN removeUIEvents IN ghRepDesignManager
       (INPUT hTmp ,
        INPUT TABLE-HANDLE ghUnknown) NO-ERROR.
   IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
       RUN AppendToPError (RETURN-VALUE).
       RETURN.
   END.
   /* Empty the temp-table */
   EMPTY TEMP-TABLE DeleteUIEvent.
 END.
 
 IF pcLayout = "Master Layout":U THEN 
 DO:
   /* Iterate through custom layouts calling this procedure */
   IF NUM-ENTRIES(gcResultCodes) > 1 THEN DO:
     DO iCode = 2 TO NUM-ENTRIES(gcResultCodes):  /* First one is the Master */
        cCode = ENTRY(iCode, gcResultCodes).
        RUN writeFieldLevelObjects (INPUT cCode ).
     END.
   END.  /* If there are customizations */

   /* Now shutdown the SDOs */
   IF VALID-HANDLE(hDataSource) THEN RUN destroyobject IN hDataSource NO-ERROR.
   IF VALID-HANDLE(hDataSource) THEN DELETE OBJECT hDataSource.
   
 END.  /* Only do this stuff if saving the Master */
 ELSE DO:  /* Shutdown SDO (or SBO) started for this layout */
   IF VALID-HANDLE(hDataSource) THEN RUN destroyobject IN hDataSource NO-ERROR.
   IF VALID-HANDLE(hDataSource) THEN DELETE OBJECT hDataSource.
 END.  /* Else not the master layout */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeObjectToRepository) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeObjectToRepository Procedure 
PROCEDURE writeObjectToRepository :
/*------------------------------------------------------------------------------
  Purpose:    To write object to the repository 
  Parameters:
                        
  Notes:  _P must represent a SDV, SDB or SDO.
          
          When an object is written, we first look to see if it already exists,
          if so, the the existing record(s) are used.  Otherwise new records
          are created.   Called from main-block  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cOBJRootDir           AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE cOBJRelativeDir       AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE cError                AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE cTemp                 AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE i                     AS INTEGER                 NO-UNDO.
 DEFINE VARIABLE iResultCode           AS INTEGER                 NO-UNDO.
 DEFINE VARIABLE cResultCode           AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE cName                 AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE WindowRecid           AS RECID                   NO-UNDO.
 DEFINE VARIABLE lSuppressValidation   AS LOGICAL                 NO-UNDO.
 DEFINE VARIABLE cDLProcType           AS CHARACTER               NO-UNDO INITIAL "DLProc":U.
 DEFINE VARIABLE cTempTableDef         AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE cTableType            AS CHARACTER               NO-UNDO.
 
 DEFINE BUFFER b_C     FOR _C.   /* For frames              */
  
 /* The gcClassName is the base class name, gcObjClassType from the user profile for their
    preferred subClass of gcClassName                                                    */
 ASSIGN gcClassName = DYNAMIC-FUNCTION("RepositoryDynamicClass" IN _h_func_lib, INPUT _P._TYPE)
        gcObjClassType = gcClassName.

 /* If migrating code, set global variables for superprocedure and Super options */
 IF glMigration THEN
    setMigrationPreferences().

 /* Set variables based on intial values in _P */
 ASSIGN gcOBJProductModule  = _P.product_module_code
        gcObjClassType      = IF NOT glMigration AND _P.Object_type_code > "" 
                             THEN _P.Object_type_code ELSE gcObjClassType
        gcContainer         = _P.object_filename
        cTemp              = REPLACE(_P._SAVE-AS-FILE,"~\":U,"/":U)
        gcObjectDescription = IF _P.object_description = ""
                             THEN ( "Dynamic " +
                                   (IF _P._TYPE MATCHES "*View*":U THEN "Viewer":U
                                   ELSE IF _P._TYPE MATCHES "*BROW*":U THEN "Browser":U
                                   ELSE "DataObject":U) +
                                    " from ":U + 
                                    ENTRY(NUM-ENTRIES(cTemp,"/":U), cTemp, "/":U))
                               ELSE _P.object_description
         _P._DESC          = IF _P._DESC = "":U THEN gcObjectDescription ELSE _P._DESC.

 RUN calculateObjectPaths IN gshRepositoryManager 
            (INPUT  _P.object_filename,    INPUT  0.0,               /* Object Name , Object _obj value  */
             INPUT  gcObjClassType,        INPUT  gcOBJProductModule, /* Object Type ,Product Module      */
             INPUT  "":U,                  INPUT  "":U,              /* Object Parameter, Name space n.a */
             OUTPUT cOBJRootDir,           OUTPUT cOBJRelativeDir,   /* Root Dir, Relative dir           */
             OUTPUT gcSCMRelativeDir,      OUTPUT gcFullPathName,     /* SCM Relative dir, Full path Name */
             OUTPUT gcOutputObjectName,    OUTPUT gcOBJFileName,     /* Output Object Name, calculated file */
             OUTPUT cError) NO-ERROR.
 IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
    RUN AppendToPError (cError).
    RETURN.
 END.
 ASSIGN cOBJRelativeDir = IF gcSCMRelativeDir <> "":U THEN gcSCMRelativeDir ELSE cOBJRelativeDir
        gcOBJFileName   = IF gcOBJFileName = "":U THEN  gcOutputObjectName ELSE  gcOBJFileName.
    
 IF gcOBJFileName = "":U THEN
      ASSIGN gcOBJFileName = gcOutputObjectName. 
      
 IF _P._data-object NE "":U THEN DO:
   RUN processAttachedSDO.
   IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
 END.
  /* Calculate the Min-Height and Width of Master Object in master layout 
    and determine the browse, query and frame recids*/
 RUN DetermineSize(INPUT RECID(_U),INPUT "Master Layout":U).
 /* Assign all attributes to the internal temp tables for later writing to repository */
 RUN assignMasterAttributes IN THIS-PROCEDURE.
 IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
 /* Invoke repository API to create master object in repository */
 RUN createMasterAttributes IN THIS-PROCEDURE .
 IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
 RUN setObjectEvents IN THIS-PROCEDURE 
                       (INPUT RECID(_U),   /* _U with current attributes */
                        INPUT _U._OBJECT-OBJ,
                        INPUT "MASTER":U,
                        INPUT "").
 IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
 /* Empty the ttStoreAttribute temp-table */
 EMPTY TEMP-TABLE ttStoreAttribute.

 /* Empty the ttStoreUIEventtemp-table */
 EMPTY TEMP-TABLE ttStoreUIEvent.

/*  CUSTOM LAYOUTS for viewers and browsers  */
 IF NUM-ENTRIES(gcResultCodes) > 1 AND LOOKUP(gcClassName,"DynView,DynBrow":U) > 0 THEN 
 DO iResultCode = 2 TO NUM-ENTRIES(gcResultCodes):
    cresultCode = ENTRY(iResultCode, gcResultCodes).

   /* Calculate the Min-Height and Width of Master Object in cresultCode layout */
   RUN DetermineSize(INPUT RECID(_U), INPUT cResultCode).
                     
   /* Need to get the object_obj of the customization if it exists */
   FIND ryc_customization_result WHERE ryc_customization_result.customization_result_code = 
                                       cresultCode NO-LOCK.
   FIND ryc_smartobject WHERE ryc_smartobject.object_filename = gcOBJFileName 
                          AND ryc_smartobject.customization_result_obj = 
                                  ryc_customization_result.customization_result_obj NO-LOCK NO-ERROR.

   gdDynamicObj = IF AVAILABLE ryc_smartobject THEN ryc_smartobject.smartobject_obj 
                                              ELSE 0.

   RUN setObjectMasterAttributes (INPUT IF gcClassName = "DynView":U 
                                        THEN grFrameRecid ELSE grBrowseRecid,
                                  gdDynamicObj,
                                  cresultCode).
   IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
   RUN createCustomAttributes IN THIS-PROCEDURE (cresultCode).
   IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
   RUN setObjectEvents IN THIS-PROCEDURE 
                        (INPUT RECID(_U),   /* _U with current attributes */
                         INPUT gdDynamicObj,
                         INPUT "MASTER":U,
                         INPUT cresultCode).
   IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
   IF CAN-FIND(FIRST ttStoreAttribute) THEN
      EMPTY TEMP-TABLE ttStoreAttribute.
   IF CAN-FIND(FIRST DeleteAttribute) THEN
      EMPTY TEMP-TABLE DeleteAttribute. 
 END. /* End loop through custom layouts */

 IF gcClassName = "DynSDO":U THEN 
 DO:
   RUN createDynSDO IN THIS-PROCEDURE.
   IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
 END.
 /* Else if we are migrating an SBO */
 ELSE IF gcClassName = "DynSBO":U THEN 
 DO:
   RUN processMigratedSBO IN THIS-PROCEDURE.
   IF gpcError NE "" AND NOT gpcError BEGINS "Associated data" THEN RETURN.
 END.
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
  Parameters: <none>
          
  Notes:  In the first pass _P must represent a SDV or a SDB.  More types can
          be added in the future.
          
          When an object is written to the repository, we first look to see 
          if it already has an associated Super procedure.  If so,  we regenetate
          it using the same name.  Otherwise we create a new name which is the 
          same as the object being written + "Super.p".  This file is written in
          the directory associated with the module that the dynamic object
          belongs to.    called from main-block 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDesc             AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE dCustomSuper      AS DECIMAL                  NO-UNDO.
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
  DEFINE VARIABLE cSuperProcType    AS CHARACTER                NO-UNDO INITIAL "Procedure":U.
  DEFINE VARIABLE cError            AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cError2           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE ghSCMTool         AS HANDLE                   NO-UNDO.          
  DEFINE VARIABLE htmp              AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE ghUnknown         AS HANDLE                   NO-UNDO.
  DEFINE BUFFER sup_P FOR _P.
  DEFINE BUFFER rycso_sdo         FOR ryc_smartObject.
 
  /* Get the _P record to write */
  FIND _P WHERE RECID(_P) = gprPrecid.
  FIND _U WHERE RECID(_U) = _P._u-recid.
  FIND _C WHERE RECID(_C) = _U._x-recid.
  
  /* The user doesn't want a customer super procedure generated */
  IF _C._CUSTOM-SUPER-PROC = "":U THEN RETURN.
  IF glMigration AND gcSuperPref = "None":U THEN RETURN.
    
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
      RUN scmGetModuleDir IN ghSCMTool (INPUT gsc_product_module.product_module_code, INPUT "":U, OUTPUT cCSPRelativeDir) NO-ERROR.          
      ASSIGN cCSPRelativeDir = TRIM(REPLACE(cCSPRelativeDir,"~\":U,"~/":U),"~/":U).
    END.
    ELSE ASSIGN cCSPRelativeDir = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"~/":U),"~/":U).      
  END. /* If available gsc_product_module */
  ELSE ASSIGN cCSPRelativeDir = TRIM(REPLACE(_P.object_path,"~\":U,"~/":U),"~/":U).
  
  ASSIGN cCSPFullName    = REPLACE(_C._CUSTOM-SUPER-PROC,"~\":U,"~/":U).

  RUN adecomm/_osprefx.p (INPUT cCSPFullName, OUTPUT cCSPRootDir, OUTPUT cCSPFileName) NO-ERROR.
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
     RUN adeshar/_gen4gl.p ("SAVESuperProc":U + IF gcSuperPref = "empty":U THEN gcSuperPref ELSE "":U ) NO-ERROR.

     ASSIGN cDesc   = _U._LABEL + ' for ':U + cCSPFileName /* OLD : _P.object_filename */
            hAttributeTable  = ?
            cSuperProcType   = IF AVAIL _C AND _C._CUSTOM-SUPER-PROC-TYPE > "" 
                               THEN _C._CUSTOM-SUPER-PROC-TYPE ELSE cSuperProcType.
     RUN insertObjectMaster IN ghRepDesignManager ( 
           INPUT  cCSPFileName,                             /* pcObjectName         */
           INPUT  IF _U._LAYOUT-NAME ="Master Layout":U 
                  THEN "{&DEFAULT-RESULT-CODE}":U 
                  ELSE _U._LAYOUT-NAME,                     /* pcResultCode    */
           INPUT  cCSPProductModule,                        /* pcProductModuleCode  */
           INPUT  cSuperProcType,                            /* pcObjectTypeCode     */
           INPUT  cDesc,                                    /* pcObjectDescription  */
           INPUT  "":U,                                     /* pcObjectPath         */
           INPUT  "",                                      /* pcSDOName            */
           INPUT  "":U,                                     /* pcSuperProcedureName */
           INPUT  NO,                                       /* plIsTemplate         */
           INPUT  YES,                                      /* plIsStatic           */
           INPUT  "":U,                                     /* pcPhysicalObjectName */
           INPUT  NO,                                       /* plRunPersistent      */
           INPUT  "":U,                                     /* pcTooltipText        */
           INPUT  "":U,                                     /* pcRequiredDBList     */
           INPUT  "":U,                                     /* pcLayoutCode         */
           INPUT  ?,
           INPUT  TABLE-HANDLE hAttributeTable,
           OUTPUT dCustomSuper                              ) NO-ERROR.

     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
       RUN AppendToPError (RETURN-VALUE).
       RETURN.
     END.

     /* Register this as the super procedure of the DynObject */
     IF dCustomSuper NE 0 THEN 
     DO:  
        EMPTY TEMP-TABLE ttStoreAttribute.
        RUN CreateAttributeRow("MASTER":U,gdDynamicObj,"SuperProcedure":U ,{&CHARACTER-DATA-TYPE},_C._CUSTOM-SUPER-PROC,?,?,?,?,?).
        hTmp = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.
        RUN StoreAttributeValues IN gshRepositoryManager
            (INPUT hTmp ,
             INPUT TABLE-HANDLE ghUnknown)  NO-ERROR.  /* Compiler requires a variable with unknown */             
     END.
    
     /* Register newly created events in repository */
     RUN SuperProcEventReg IN THIS-PROCEDURE.

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
                       INPUT FALSE) NO-ERROR.                    /* Reading from schema */

      IF RETURN-VALUE BEGINS "_ABORT":U THEN DO:
        cError = RETURN-VALUE.
        IF LENGTH(cError,"CHARACTER") > 7 THEN
          cError = SUBSTRING(cError, 8, -1, "CHARACTER").
        ELSE cError = "":U.
        gpcError = gpcError + (IF gpcError = "":U THEN "":U ELSE CHR(10)) + cError.
        RETURN.
      END.

      FIND sup_P WHERE sup_P._WINDOW-HANDLE = _h_win.

      /* Re-save the updated Super procedure */
      RUN adeshar/_gen4gl.p ("SAVESuperProc") NO-ERROR.

      /* The Xftr caused the _P to be marked dirty, set it back */
      sup_P._FILE-SAVED = YES.

      /* Close the SUP */
      RUN wind-close IN _h_uib (_h_win) NO-ERROR.

   END.  /* If the file doesn't already exist */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-checkCustomChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkCustomChanges Procedure 
FUNCTION checkCustomChanges RETURNS CHARACTER
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
  DEFINE VARIABLE cmAttrDiffs AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPropLib    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPropBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWhere      AS CHARACTER  NO-UNDO.

  DEFINE BUFFER b_L FOR _L.
  DEFINE BUFFER m_L FOR _L.
  DEFINE BUFFER m_U FOR _U.
  
  FIND _L WHERE RECID(_L) = p_LRecid.
  FIND m_L WHERE m_L._LO-name = "Master Layout":U AND m_L._u-recid = _L._u-recid.
  FIND b_L WHERE b_L._LO-NAME = _L._BASE-LAYOUT AND b_L._u-recid = _L._u-recid NO-ERROR.
  IF NOT AVAILABLE b_L THEN 
    FIND b_L WHERE b_L._LO-NAME = "Master Layout":U AND b_L._u-recid = _L._u-recid.
  FIND m_U WHERE RECID(m_U)   = _L._u-Recid.  

  BUFFER-COMPARE _L EXCEPT _LO-NAME _BASE-LAYOUT _VIRTUAL-WIDTH _VIRTUAL-HEIGHT TO b_L SAVE cAttrDiffs.

  IF cAttrDiffs NE "":U AND _L._BASE-LAYOUT NE "Master Layout":U THEN DO:
    /* _L has changed from its base, see if it has reverted to the Master (Default) layout */
    BUFFER-COMPARE _L EXCEPT _LO-NAME _BASE-LAYOUT _VIRTUAL-WIDTH _VIRTUAL-HEIGHT TO m_L SAVE cmAttrDiffs.
    IF cmAttrDiffs = "":U THEN DO:
        MESSAGE 'In layout "' + _L._LO-NAME + '",' m_U._NAME "has reverted to be identical"
                "to its layout in the Default layout." "This is not fully supported and"
                "may not work correctly at run-time." SKIP (1)
                "Also, when reading from the repository, the AppBuilder is unable to"
                "determine if this is intended to explicitly override another layout"
                "or not and will assume that it should not override another layout. "
                'Therefore some of its attributes may change when editing the "' + 
                _L._LO-NAME + '" layout in the future.' 
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END. /* If reverted to master */
  END. /* If changes were made from */

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
         
        ASSIGN hPropBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hPropLib, "ttEvent":U).
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

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeChar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttributeChar Procedure 
FUNCTION setAttributeChar RETURNS LOGICAL
  ( pcLevel   AS CHAR,
    pcABValue AS CHAR,
    pcLabel   AS CHAR,
    pcValue  AS CHAR,
    pdObj     AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Creates character attributes in the temp table for addition to the repository
   Params: pcLevel   MASTER or INSTANCE
           pcABField Value of appBuilder temp-table field
           pcLabel   Attribute label
           pcValue   Inherrited attribute Value for the master or instance
           pdObj     Object_obj of the smartObject
    
    Notes: Called from setObjectMasterAttribtues 
      
           gcAttributeList contains a list of attributes stored on the Master Level (if
           pclevel = MASTER) or stored on the Instance level (if pclevel = INSTANCE).
------------------------------------------------------------------------------*/
  /* If the attribute is defined on the master or instance*/
  IF LOOKUP(pclabel,gcAttributeList) > 0 THEN 
  DO:
     IF pcLevel = "MASTER":U AND pcABValue EQ ttClassAttribute.tAttributeValue THEN
        RUN DeleteAttributeRow (INPUT pcLevel, INPUT pdObj, INPUT pcLabel).  
     ELSE IF (pcLevel = "INSTANCE":U AND AVAIL ttObjectAttribute 
                                     AND pcABValue EQ ttObjectAttribute.tAttributeValue)
          OR (pcLevel = "INSTANCE":U AND NOT AVAIL ttObjectAttribute 
                                     AND pcABValue EQ ttClassAttribute.tAttributeValue) THEN
        RUN DeleteAttributeRow (INPUT pcLevel, INPUT pdObj, INPUT pcLabel).       
     ELSE IF pcABValue <> pcValue THEN
        RUN CreateAttributeRow(pclevel,pdObj,pcLabel,{&CHARACTER-DATA-TYPE},pcABValue,?,?,?,?,?).
  END.   
  ELSE IF pcABValue NE pcValue THEN
      RUN CreateAttributeRow(pclevel,pdObj,pcLabel,{&CHARACTER-DATA-TYPE},pcABValue,?,?,?,?,?).
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeDec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttributeDec Procedure 
FUNCTION setAttributeDec RETURNS LOGICAL
   ( pcLevel   AS CHAR,
     pdABValue AS DEC,
     pcLabel   AS CHAR,
     pcValue   AS CHAR,
     pdObj     AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Creates decimal attributes in the temp table for addition to the repository
   Params: pcLevel    MASTER or INSTANCE
           pcABField  Value of appBuilder temp-table field
           pcLabel    Attribute label
           pcValue    Attribute Value
           pdObj     Object_obj of the smartObject
    Notes: Called from setObjectmasterAttribtues 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dValue AS DECIMAL    NO-UNDO.
  
  ASSIGN dValue = DECIMAL(pcValue) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
      RETURN FALSE.
          
    /* If the attribute is defined on the master or instance*/
  IF LOOKUP(pclabel,gcAttributeList) > 0 THEN 
  DO:
     IF pcLevel = "MASTER":U AND pdABValue EQ DECIMAL(ttClassAttribute.tAttributeValue) THEN
        RUN DeleteAttributeRow (INPUT pcLevel, INPUT pdObj, INPUT pcLabel).  
     ELSE IF (pcLevel = "INSTANCE":U AND AVAIL ttObjectAttribute 
                                     AND pdABValue EQ DECIMAL(ttObjectAttribute.tAttributeValue))
          OR (pcLevel = "INSTANCE":U AND NOT AVAIL ttObjectAttribute 
                                     AND pdABValue EQ DECIMAL(ttClassAttribute.tAttributeValue)) THEN
        RUN DeleteAttributeRow (INPUT pcLevel, INPUT pdObj, INPUT pcLabel).       
     ELSE IF pdABValue <> dValue THEN
         RUN CreateAttributeRow(pclevel,pdObj,pcLabel,{&DECIMAL-DATA-TYPE},?,pdABValue,?,?,?,?).  
  END.   
  ELSE IF pdABValue NE dValue THEN
       RUN CreateAttributeRow(pclevel,pdObj,pcLabel,{&DECIMAL-DATA-TYPE},?,pdABValue,?,?,?,?).          
          

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeInt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttributeInt Procedure 
FUNCTION setAttributeInt RETURNS LOGICAL
 ( pcLevel   AS CHAR,
   piABValue AS INT,
   pcLabel   AS CHAR,
   pcValue   AS CHAR,
   pdObj     AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Creates integer attributes in the temp table for addition to the repsoitory
  Params: pcLevel    MASTER or INSTANCE
           pcABField  Value of appBuilder temp-table field
           pcLabel    Attriobute label
           pcValue    Attribute Value from repos
           pdObj     Object_obj of the smartObject
    Notes: Called from setObjectmasterAttribtues 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iValue AS INTEGER    NO-UNDO.

  ASSIGN iValue = INT(pcValue) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
      RETURN FALSE.

 /* If the attribute is defined on the master or instance*/
  IF LOOKUP(pclabel,gcAttributeList) > 0 THEN 
  DO:
     IF pcLevel = "MASTER":U AND piABValue EQ INTEGER(ttClassAttribute.tAttributeValue) THEN
        RUN DeleteAttributeRow (INPUT pcLevel, INPUT pdObj, INPUT pcLabel).  
     ELSE IF (pcLevel = "INSTANCE":U AND AVAIL ttObjectAttribute 
                                     AND piABValue EQ INTEGER(ttObjectAttribute.tAttributeValue))
          OR (pcLevel = "INSTANCE":U AND NOT AVAIL ttObjectAttribute 
                                     AND piABValue EQ INTEGER(ttClassAttribute.tAttributeValue)) THEN
        RUN DeleteAttributeRow (INPUT pcLevel, INPUT pdObj, INPUT pcLabel).       
     ELSE IF piABValue <> iValue THEN
         RUN CreateAttributeRow(pclevel,pdObj,pcLabel,{&INTEGER-DATA-TYPE},?,?,piABValue,?,?,?).    
  END.   
  ELSE IF piABValue NE iValue THEN
      RUN CreateAttributeRow(pclevel,pdObj,pcLabel,{&INTEGER-DATA-TYPE},?,?,piABValue,?,?,?).        
      
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttributeLog Procedure 
FUNCTION setAttributeLog RETURNS LOGICAL
  ( pcLevel   AS CHAR,
    plABValue AS LOG,
    pcLabel   AS CHAR,
    pcValue   AS CHAR,
    pdObj     AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Creates logical attributes in the temp table for addition to the repository
   Params: pcLevel    MASTER or INSTANCE
           pcABField  Value of appBuilder temp-table field
           pcLabel    Attriobute label
           plCreate   YE-Create attribute  NO-Delete attribute
           pdObj     Object_obj of the smartObject
    Notes: Called from setObjectmasterAttribtues 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lValue AS LOGICAL   NO-UNDO.

  ASSIGN lValue = LOGICAL(pcValue) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
      RETURN FALSE.
  
 /* If the attribute is defined on the master or instance*/
  IF LOOKUP(pclabel,gcAttributeList) > 0 THEN 
  DO:
     IF pcLevel = "MASTER":U AND plABValue EQ LOGICAL(ttClassAttribute.tAttributeValue) THEN
        RUN DeleteAttributeRow (INPUT pcLevel, INPUT pdObj, INPUT pcLabel).  
     ELSE IF (pcLevel = "INSTANCE":U AND AVAIL ttObjectAttribute 
                                     AND plABValue EQ LOGICAL(ttObjectAttribute.tAttributeValue))
          OR (pcLevel = "INSTANCE":U AND NOT AVAIL ttObjectAttribute 
                                     AND plABValue EQ LOGICAL(ttClassAttribute.tAttributeValue)) THEN
        RUN DeleteAttributeRow (INPUT pcLevel, INPUT pdObj, INPUT pcLabel).       
     ELSE IF plABValue <> lValue THEN
         RUN CreateAttributeRow(pclevel,pdObj,pcLabel,{&LOGICAL-DATA-TYPE},?,?,?,plABValue,?,?).   
  END.   
  ELSE IF plABValue NE lValue THEN
      RUN CreateAttributeRow(pclevel,pdObj,pcLabel,{&LOGICAL-DATA-TYPE},?,?,?,plABValue,?,?).   

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMigrationPreferences) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMigrationPreferences Procedure 
FUNCTION setMigrationPreferences RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets various glbal variables for migration preferences
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cLookupVal AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTemp      AS CHARACTER  NO-UNDO.

   /* gcObjClassType is the preferred subClass to create */
   cLookupVal =      IF gcClassName = "DynBrow":U THEN "SDB_Type":U 
                ELSE IF gcClassName = "DynView":U THEN "SDV_Type":U 
                ELSE IF gcClassName = "DynSDO":U  THEN "SDO_Type":U 
                ELSE "SBO_Type":U.
   cTemp = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                            cLookupVal,
                            gcProfileData,
                            TRUE,
                            CHR(3)).
   /* Make sure it is defined */
   IF cTemp NE "":U AND cTemp NE ? THEN 
       ASSIGN gcObjClassType = cTemp.
   
   /* cSupPreference is Super Proc preferences */
   cLookupVal =      IF gcClassName = "DynBrow":U THEN "SDB_SupOpt":U 
                ELSE IF gcClassName = "DynView":U THEN "SDV_SupOpt":U 
                ELSE IF gcClassName = "DynSDO":U  THEN "SDO_DlpOpt":U 
                ELSE "SBO_DlpOpt":U.
   gcSuperPref = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                 cLookupVal,
                                 gcProfileData,
                                 TRUE,
                                 CHR(3)).
   IF gcSuperPref = "":U OR gcSuperPref = ? THEN
     gcSuperPref = IF LOOKUP(gcClassName,"DynBrow,DynView":U) > 0 THEN "None":U ELSE
                  "ValOnly":U.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION verifyObjectType Procedure 
FUNCTION verifyObjectType RETURNS CHARACTER
  ( pcWidgetType AS CHAR,
    pcObjectTypeCode AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Verify the specified object type is valid for the widget. If the 
            object type is the default dynamics object type for that widget type
            (i.e. DynFillIn for Fill-in) then don't bother to check the class.
    Notes:  Called from writeFieldLevelObejct
------------------------------------------------------------------------------*/
 IF NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DataField":U) THEN 
 DO:
   CASE pcWidgetType:
     WHEN "FILL-IN":U THEN
       IF pcObjectTypeCode NE "DynFillin":U 
          AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynFillin":U) THEN 
         ASSIGN pcObjectTypeCode = "DynFillin":U.
     WHEN "BUTTON":U THEN
       IF pcObjectTypeCode NE "DynButton":U 
          AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynButton":U) THEN 
         ASSIGN pcObjectTypeCode = "DynButton":U.
     WHEN "RECTANGLE":U THEN
       IF pcObjectTypeCode NE "DynRectangle":U 
          AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynRectangle":U) THEN 
         ASSIGN pcObjectTypeCode = "DynRectangle":U.
     WHEN "EDITOR":U THEN
         IF pcObjectTypeCode NE "DynEditor":U 
            AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynEditor":U) THEN 
         ASSIGN pcObjectTypeCode = "DynEditor":U.
     WHEN "IMAGE":U THEN
       IF pcObjectTypeCode NE "DynImage":U 
          AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynImage":U) THEN
         ASSIGN pcObjectTypeCode = "DynImage":U.
     WHEN "TEXT":U THEN
       IF pcObjectTypeCode NE "DynText":U
          AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynText":U) THEN
         ASSIGN pcObjectTypeCode = "DynText":U.
     WHEN "TOGGLE-BOX":U THEN
       IF pcObjectTypeCode NE "DynToggle":U 
          AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynToggle":U) THEN
         ASSIGN pcObjectTypeCode = "DynToggle":U.
     WHEN "SELECTION-LIST":U THEN
       IF pcObjectTypeCode NE "DynSelection":U 
          AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynSelection":U) THEN
         ASSIGN pcObjectTypeCode = "DynSelection":U.
     WHEN "COMBO-BOX":U THEN
       IF pcObjectTypeCode NE "DynComboBox":U 
          AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynComboBox":U) THEN
         ASSIGN pcObjectTypeCode = "DynComboBox":U.
     WHEN "RADIO-SET":U THEN
       IF pcObjectTypeCode NE "DynRadioSet":U 
           AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynRadioSet":U) THEN
         ASSIGN pcObjectTypeCode = "DynRadioSet":U.
     WHEN "SLIDER":U THEN
       IF pcObjectTypeCode NE "DynSlider":U 
           AND NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, pcObjectTypeCode, "DynSlider":U) THEN
         ASSIGN pcObjectTypeCode = "DynSlider":U.
   END CASE.
 END.
 
 RETURN pcObjectTypeCode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

