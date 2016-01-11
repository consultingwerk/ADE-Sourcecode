&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
/* Copyright (C) 1984-2007 by Progress Software Corporation. All rights
   reserved. Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: adeuib/_dynsckr.p

  Description:  Re-write of old version 
                Suck in dynamic objects -- This regenerates a UIB session.
                Moved from ry/prc/rydynsckrp.p
    
  NOTE:         This is a stipped down version of _qssuckr.p that has been
                modified for the sole purpose of reading dynamic objects
                into the AppBuilder for editing.

  Parameters:   open_file   File name (should be a dynamic object name) to suck in.
                import_mode  Mode for operation.
                             "WINDOW" - open a .w file (Window or Dialog Box)
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/21/2003  Author:  Don Bulua
 Update Notes: created from _qssuckr.p
-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _dynsckr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* object identifying preprocessor */
&glob   AstraProcedure    yes

DEFINE INPUT PARAMETER open_file    AS CHARACTER NO-UNDO .   /* File to open    */
DEFINE INPUT PARAMETER import_mode  AS CHARACTER NO-UNDO. /* "WINDOW"  */

{adecomm/oeideservice.i}
{src/adm2/globals.i}
{adeuib/timectrl.i}      /* Controls inclusion of profiling code */
{adecomm/adefext.i}
{adeuib/uniwidg.i}       /* Universal Widget TEMP-TABLE definition           */
{adeuib/brwscols.i}      /* Temp-table to browser columns                    */
{adeuib/triggers.i}      /* Trigger TEMP-TABLE definition                    */
{adeuib/xftr.i}          /* XFTR TEMP-TABLE definition                       */
{adeuib/layout.i}        /* Layout temp-table definitions                    */
{adeuib/name-rec.i NEW}  /* Name indirection table                           */
{adeuib/sharvars.i}      /* Shared variables                                 */
{adeuib/frameown.i NEW}  /* Frame owner temp table definition                */
{adecomm/adeintl.i}
{adeshar/mrudefs.i}      /* MRU FileList shared vars and temp table definition */
{destdefi.i}             /* Definitions for dynamics design-time temp-tables. */
{defrescd.i}             /* Defines default result codes */

/* Standard End-of-line character */
&Scoped-define EOL &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN "~r" + &ENDIF CHR(10)
/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

DEFINE NEW SHARED STREAM _P_QS.
DEFINE NEW SHARED STREAM _P_QS2.

DEFINE NEW SHARED VAR _inp_line       AS CHAR       EXTENT 100         NO-UNDO.
DEFINE NEW SHARED VAR adj_joincode    AS LOGICAL    INITIAL NO         NO-UNDO.
DEFINE NEW SHARED VAR _can_butt       AS CHAR       INITIAL ?          NO-UNDO.
DEFINE NEW SHARED VAR _def_butt       AS CHAR       INITIAL ?          NO-UNDO.
DEFINE NEW SHARED VAR tab-number      AS INTEGER                       NO-UNDO.
DEFINE NEW SHARED VAR adm_version     AS CHARACTER                     NO-UNDO.
DEFINE NEW SHARED VAR cDataFieldMapping AS CHARACTER                   NO-UNDO.
/* ok to load if not connected to the backend database that made the qs file */
DEFINE NEW SHARED VARIABLE dot-w-file AS CHAR   FORMAT "X(40)"         NO-UNDO.
DEFINE NEW SHARED VARIABLE def_found  AS LOGICAL INITIAL FALSE         NO-UNDO.
DEFINE NEW SHARED VARIABLE main_found AS LOGICAL INITIAL FALSE         NO-UNDO.

/* Variables required for appBuilder  {adeuib/vrfyimp.i} */
DEFINE VARIABLE AbortImport           AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE adv_choice            AS CHAR       NO-UNDO.
DEFINE VARIABLE adv_never             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE FileHeader            AS CHAR INITIAL "" NO-UNDO.
DEFINE VARIABLE err_msgs              AS CHAR       NO-UNDO.
DEFINE VARIABLE file_ext              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE file_version          AS CHAR       NO-UNDO.
DEFINE VARIABLE h_xml                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE i                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE notVisual             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE pressed-ok            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE temp_file             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE web_file              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE web_temp_file         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelPathWeb           AS CHARACTER  NO-UNDO INIT ?.

DEFINE VARIABLE gcAssignList              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrowseFields            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColBGColors         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColFGColors         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColFonts            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColFormats          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColLabelBGColors    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColLabelFGColors    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColLabelFonts       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColLabels           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColWidths           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColTypes            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColDelimiters       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColItems            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColItemPairs        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColInnerLines       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColSorts            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColMaxChars         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColAutoCompletions  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrwsColUniqueMatches    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCalcFieldList           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCountTmp                AS INTEGER    EXTENT {&WIDGET-COUNT-DIMENSION} NO-UNDO.
DEFINE VARIABLE gcDataColumns             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDataColumnsByTable      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynClass                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynExtClass             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynTempFile             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEnabledFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE grFrameRecid              AS RECID      NO-UNDO.
DEFINE VARIABLE gcInheritClasses          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPhysicalTables          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQBDBNames               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQBFieldDataTypes        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQBFieldWidths           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQBInhVals               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQBJoinCode              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQBWhereClauses          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcReturnValue             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSDOName                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSettingsList            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTables                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTempTableDefinition     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTempTables              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcUpdatableColumns        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcUpdatableColumnsByTable AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdFrameMaxWidth           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdFrameMaxHeight          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghSDO                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE glisRyObject              AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE glSBODataSource           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghDesignManager           AS HANDLE     NO-UNDO.
DEFINE VARIABLE glCustomOnlyField         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE glDynObject               AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE glMasterLayout            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE grParentRecid             AS RECID      NO-UNDO.

DEFINE BUFFER x_U             FOR _U.
DEFINE BUFFER x_L             FOR _L.
DEFINE BUFFER f_U             FOR _U.
DEFINE BUFFER f_F             FOR _F.
DEFINE BUFFER f_L             FOR _L.
DEFINE BUFFER m_L             FOR _L.
DEFINE BUFFER b_ttObject      FOR ttObject.

DEFINE TEMP-TABLE SDFttObject           LIKE ttObject .
DEFINE TEMP-TABLE SDFttObjectAttribute  LIKE ttObjectAttribute .

FUNCTION get-sdo-hdl RETURNS HANDLE 
   (INPUT pcName AS CHARACTER,
    INPUT phOwner AS HANDLE) IN _h_func_lib.
 
 FUNCTION shutdown-sdo RETURNS LOGICAL  
   (INPUT phOwner AS HANDLE) IN _h_func_lib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-findAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findAttributeValue Procedure 
FUNCTION findAttributeValue RETURNS CHARACTER
  ( pcAttribute AS CHAR,
    pcLevel AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttributeValue Procedure 
FUNCTION setAttributeValue RETURNS LOGICAL
 ( pcAttribute AS CHAR,
    pcLevel AS CHAR ,
    pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRadioButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRadioButtons Procedure 
FUNCTION setRadioButtons RETURNS CHARACTER
  ( pcValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFSetting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDFSetting Procedure 
FUNCTION setSDFSetting RETURNS LOGICAL
  ( pcAttribute AS CHAR,
    pcValue     AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowAlreadyOpened) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD windowAlreadyOpened Procedure 
FUNCTION windowAlreadyOpened RETURNS LOGICAL
  (OUTPUT pcReturnValue AS CHAR)  FORWARD.

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
         HEIGHT             = 21.05
         WIDTH              = 58.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
 /* Make the _ryObject record available to all internal procs */
 FIND _RyObject WHERE _RyObject.object_filename = open_file NO-LOCK NO-ERROR.
 ASSIGN glisRyObject = AVAILABLE _RyObject.
 
 /* Validate repository object requests. */
 RUN validateRepositoryObject.
 IF RETURN-VALUE = "_ABORT":U THEN RETURN "_ABORT":U.

 /* If the mode is not WINDOW put a message and abort importing the file.*/
 IF NOT CAN-DO("IMPORT,WINDOW,WINDOW UNTITLED":U, import_mode) THEN DO:
  MESSAGE "Unknown {&UIB_NAME} load mode " + import_mode + ". Aborting load." 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  RETURN "_ABORT":U.
 END.

 ASSIGN SESSION:NUMERIC-FORMAT = "AMERICAN":U.

 ASSIGN dot-w-file = open_file
        pressed-OK = TRUE .

 /* Check whether the window is already opened */
 IF windowAlreadyOpened(OUTPUT gcReturnValue) THEN
     RETURN gcReturnValue .

 /* get temporary unique file name for appBuilder */
 RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB_QS}, OUTPUT temp_file).

 /*  In a dynamic object, dot-w-file contains only the object name. Set the dot-w-file 
     variable to the name of a copy of the dynamic object's template file, which the 
     AB uses for opening such objects. Variable dot-w-file is set back to the object 
     name (stored in open_file) after the analyze is complete. */
 ASSIGN _save_file = dot-w-file
        dot-w-file = gcDynTempFile.
 
  /* Analyse and Verify the file we are looking at. If there is a problem then exit */
  AbortImport = no.
 {adeuib/vrfyimp.i} /* This Runs ANALYSE ... NO-ERROR. */

 IF AbortImport THEN 
 DO:
    RUN dynsucker_cleanup.
    RETURN "_ABORT":U.
 END.

 /* Deselect any selected objects prior to loading (because loading will load a new set). */
 FOR EACH _U WHERE _U._SELECTEDib:
   _U._SELECTEDib = no.
   IF VALID-HANDLE(_U._HANDLE) AND CAN-SET(_U._HANDLE,"SELECTED")
   THEN _U._HANDLE:SELECTED = NO.
 END.

 /* Save current count */
 DO i = 1 TO {&WIDGET-COUNT-DIMENSION}:
   gcCountTmp[i] = _count[i].
 END.
 
 /*  Reset variable dot-w-file to the object name. */
 ASSIGN dot-w-file = open_file
        _count       = 0 
        _h_frame     = ?
        _h_win       = ?.
 
 /* Import the static file from temp file */
 RUN scanFile IN THIS-PROCEDURE.
 IF RETURN-VALUE = "_ABORT":U THEN 
    RETURN "_ABORT":U.

ASSIGN AbortImport = no.

 /* Set _P values */
 ASSIGN _P._Desc                = IF gcDynClass = "DynView":U      THEN "Dynamic SmartDataViewer":U
                                  ELSE IF gcDynClass = "DynBrow":U THEN "Dynamic SmartDataBrowser":U
                                  ELSE IF gcDynClass = "DynSDO":U  THEN "Dynamic SmartDataObject":U
                                  ELSE "Dynamic Object":U
        _P._Template            = NO
        _P.static_object        = NO
        _P._RUN-PERSISTENT      = YES
        _P._LISTS               = "ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6":U
        _ryObject.design_precid = RECID(_P)
        _P.object_type_code     = _RyObject.object_type_code
        _P.product_module_code  = _RyObject.product_module_code
        _P.object_filename      = _RyObject.object_filename
        _P._Save-as-File        = _RyObject.object_filename
        _P.design_action        = "OPEN":U
        _P.design_ryobject      = YES
        _P._ALLOW               = IF gcDynClass = "DynBrow":U THEN  "":U ELSE _P._ALLOW 
        _h_win:TITLE            = (IF gcDynClass = "DynDataView":U THEN "SmartDataView":U ELSE _P._type) + "(" + _P.OBJECT_type_code + ") - " + _P.OBJECT_filename.


 /* Assign the repository design manager handle */
 ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, 
                                      INPUT "RepositoryDesignManager":U) NO-ERROR.

/* Get the object from the repository and create necessary internal appbuilder tables and fields */
RUN processMasterObject IN THIS-PROCEDURE.
IF RETURN-VALUE > "" THEN RETURN RETURN-VALUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignBrowser Procedure 
PROCEDURE assignBrowser :
/*------------------------------------------------------------------------------
  Purpose:  Assign appBuilder temp table fields for browsers
  Parameters:  
  Notes:    Called from processMasterObject   
------------------------------------------------------------------------------*/
/* Create _U, _C and _L for it */
 VALIDATE _U.
 VALIDATE _C.
 VALIDATE _L.

 ASSIGN grParentRecid   = RECID(_U).

 IF glMasterLayout THEN 
 DO:
   CREATE _U.
   CREATE _C.
 END.
 ELSE DO: /* If not Master Layout */
   FIND _U WHERE _U._NAME = ttObject.tLogicalObjectName
             AND _U._TYPE = "Browse":U AND _U._WINDOW-HANDLE = _h_win.
   FIND _C WHERE RECID(_C) = _U._x-recid.
 END.
 CREATE _L.
 IF NOT glMasterLayout THEN DO:
   /* Initialize with Master Layout because we only read changes */
   FIND m_L WHERE RECID(m_L) = _U._lo-recid.
   ASSIGN _L._u-recid = RECID(_U)
          _L._LO-NAME = ttObject.tResultCode.
   BUFFER-COPY m_L EXCEPT _u-recid _LO-NAME _REMOVE-FROM-LAYOUT TO _L.
 END.

 IF glMasterLayout THEN
   ASSIGN _U._NAME          = ttObject.tLogicalObjectName
          _U._TYPE          = "BROWSE":U
          _U._HELP-SOURCE   = IF CAN-FIND(FIRST ttObjectAttribute 
                                           WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                             AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                                             AND ttObjectAttribute.tAttributeLabel    = 'HELP':U )
                               THEN "E":U ELSE "D" 
          _U._LABEL-SOURCE  = IF CAN-FIND(FIRST ttObjectAttribute 
                                           WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                             AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                                             AND ttObjectAttribute.tAttributeLabel    = 'LABEL':U )
                              THEN "E":U ELSE "D"              
          
          _U._CLASS-NAME    = gcDynExtClass
          _U._LAYOUT-NAME   = "Master Layout":U
          _U._lo-recid      = RECID(_L)
          _U._OBJECT-OBJ    = _RyObject.smartobject_obj
          _U._PARENT        = _h_frame:FIRST-CHILD
          _U._PARENT-RECID  = grParentRecid
          _U._SENSITIVE     = YES
          _U._WINDOW-HANDLE = _h_win
          _U._x-recid       = RECID(_C)
          _C._CUSTOM-SUPER-PROC = ttObject.tCustomSuperProcedure.

 ASSIGN _L._LO-NAME       = IF glMasterLayout THEN "Master Layout":U ELSE ttObject.tResultCode
        _L._u-recid       = RECID(_U)
        _L._WIN-TYPE      = YES
        _L._ROW           = 1
        _L._COL           = 1
        _L._COL-MULT      = 1
        _L._ROW-MULT      = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignDataFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDataFields Procedure 
PROCEDURE assignDataFields :
/*------------------------------------------------------------------------------
  Purpose:    Goes through all _BC records and fetches the datafields and retrieves 
              the master to calculate the LABEL, HELP and FORMAT values.
  Parameters:  <none>
  Notes:       Called from processMaterObject
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cInheritClasses  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataFieldFormat AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataFieldHelp   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataFieldLabel  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataFieldColLabel AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDLPObject       AS CHARACTER  NO-UNDO.

 FOR EACH _BC WHERE _BC._x-recid = grFrameRecid :
  /* fetch the class attributes in case the master attributes are not found */
    IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = "DataField":U) THEN
       RUN retrieveDesignClass IN ghDesignManager
                        ( INPUT  "DataField":U,
                          OUTPUT cInheritClasses,
                          OUTPUT TABLE ttClassAttribute ,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttSupportedLink    ) NO-ERROR.  
    IF _BC._DBNAME = "_<CALC>":U THEN
      ASSIGN cObjectName = _BC._NAME.
    ELSE IF _BC._DBNAME = "Temp-Tables":U THEN
    DO:
      FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
        _TT._NAME = _BC._TABLE NO-ERROR.
      IF AVAILABLE _TT AND _TT._TABLE-TYPE = "B":U THEN
        cObjectName = _TT._LIKE-TABLE + ".":U + _BC._NAME.
      ELSE 
        cObjectName = _BC._TABLE + "." + _BC._NAME.
    END.  /* if temp-table or buffer */ 
    ELSE
      ASSIGN cObjectName = _BC._TABLE + "." + _BC._NAME.
    
    RUN retrieveDesignObject IN ghDesignManager 
                                     ( INPUT  cObjectName,
                                       INPUT  "",  /* Get  default result Codes */
                                       OUTPUT TABLE b_ttObject,
                                       OUTPUT TABLE ttPage,
                                       OUTPUT TABLE ttLink,
                                       OUTPUT TABLE ttUiEvent,
                                       OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
        NEXT.
    FIND FIRST ttObject WHERE ttObject.tLogicalObjectName       = cObjectName 
                          AND ttObject.tContainerSmartObjectObj = 0  NO-ERROR.
    IF AVAIL ttObject THEN 
    DO:
       ASSIGN cDataFieldFormat = findAttributeValue("Format":U,"MASTER":U)
              cDataFieldHelp = findAttributeValue("Help":U,"MASTER":U)
              cDataFieldLabel = findAttributeValue("Label":U,"MASTER":U)
              cDataFieldColLabel = findAttributeValue("ColumnLabel":U,"MASTER":U).
       IF cDataFieldFormat <> ? THEN
           ASSIGN _BC._FORMAT = cDataFieldFormat.
       IF cDataFieldHelp <> ? THEN
           ASSIGN _BC._HELP = cDataFieldHelp.
       IF cDataFieldLabel <> ? THEN
           ASSIGN _BC._LABEL = cDataFieldLabel.
       IF cDataFieldColLabel <> ? THEN
           ASSIGN _BC._COL-LABEL = cDataFieldColLabel.
       ASSIGN _BC._HAS-DATAFIELD-MASTER = TRUE.
    END.
END.
/* fetch the master Object of the registered data logic procedure and assign the product module */
IF _C._DATA-LOGIC-PROC > "" THEN
DO:
  ASSIGN cDLPObject = ENTRY(1,ENTRY(NUM-ENTRIES(_C._DATA-LOGIC-PROC,"/":U),_C._DATA-LOGIC-PROC,"/"),".").
  RUN retrieveDesignObject IN ghDesignManager 
                                     ( INPUT  cDLPObject,
                                       INPUT  "",  /* Default result Code */
                                       OUTPUT TABLE ttObject,
                                       OUTPUT TABLE ttPage,
                                       OUTPUT TABLE ttLink,
                                       OUTPUT TABLE ttUiEvent,
                                       OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
  FIND FIRST ttObject WHERE ttObject.tLogicalObjectName =   cDLPObject NO-ERROR.
  IF AVAIL ttObject THEN 
     ASSIGN _C._DATA-LOGIC-PROC-PMOD = ttObject.tProductModuleCode.
  
   DEFINE BUFFER p_C             FOR _C.
   DEFINE BUFFER p_U             FOR _U.
  /* We have read _C._DATA-LOGIC-PROC into the _C for Query.
     It needs to be in the _C for the Window. */
   FIND p_U WHERE RECID(p_U) = grParentRecid.
   FIND p_C WHERE RECID(p_C) = p_U._x-recid.
   ASSIGN p_C._DATA-LOGIC-PROC      = _C._DATA-LOGIC-PROC
          p_C._DATA-LOGIC-PROC-PMOD = _C._DATA-LOGIC-PROC-PMOD.
END.

IF grFrameRecid <> ? THEN
  RUN adeuib/_undqry.p (INPUT grFrameRecid).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignInstanceCase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignInstanceCase Procedure 
PROCEDURE assignInstanceCase :
/*------------------------------------------------------------------------------
  Purpose:     Defines the case statement for instance objects. This is called twice,
               once for the object attributes, and once for the class attributes
  Parameters:  pcLabel  Attribute label
               pcvaleu  Attribtue value
               pcLevel OBJECT Called from the attributes defines at the instance
                              level. (From ttObjectAttribute)
                       CLASS  Called from the attributes defines at the instance's
                              class  (From ttClassAttribute)
  Notes:       - Called from assignInstanceAttrs and assignInstanceClassAttrs
               - setSDFSetting used for assigning SmartDataField attributes
               - setATtributeValue used to assign specific attribute cases that
                 require more code than just assigning a value. (Also used to cut
                 down on the size of this procedure 
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcLabel AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcvalue AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcLevel AS CHARACTER  NO-UNDO.

 
 IF glMasterLayout THEN
 DO:
   CASE pcLabel:
     WHEN "AutoFill":U         THEN setSDFSetting("AutoFill":U,pcValue).
     WHEN "AUTO-COMPLETION":U  THEN f_F._AUTO-COMPLETION = LOGICAL(pcValue).
     WHEN "AUTO-END-KEY":U     THEN f_F._AUTO-ENDKEY     = LOGICAL(pcValue).
     WHEN "AUTO-GO":U          THEN f_F._AUTO-GO         = LOGICAL(pcValue).
     WHEN "AUTO-INDENT":U      THEN f_F._AUTO-INDENT     = LOGICAL(pcValue).
     WHEN "AUTO-RESIZE":U      THEN f_F._AUTO-RESIZE     = LOGICAL(pcValue).
     WHEN "AUTO-RETURN":U      THEN f_F._AUTO-RETURN     = LOGICAL(pcValue).
     WHEN "BaseQueryString":U  THEN setSDFSetting("BaseQueryString":U,pcValue).
     WHEN "BLANK":U            THEN f_F._BLANK           = LOGICAL(pcValue).
     WHEN "BuildSequence":U    THEN setSDFSetting("BuildSequence":U,pcValue).
     WHEN "BGColor":U          THEN f_L._BGCOLOR         = INTEGER(pcValue).
     WHEN "BOX":U              THEN f_L._NO-BOX          = NOT LOGICAL(pcValue).
     WHEN "CHECKED":U          THEN f_F._INITIAL-DATA    = IF LOGICAL(pcValue)
                                                           THEN "YES" ELSE "NO".
     WHEN "COLUMN":U           THEN f_L._COL             = DECIMAL(pcValue).
     WHEN "ComboDelimiter":U   THEN setSDFSetting("ComboDelimiter":U,pcValue).
     WHEN "ComboFlag":U        THEN setSDFSetting("ComboFlag":U,pcValue).
     WHEN "CONTEXT-HELP-ID":U  THEN f_U._CONTEXT-HELP-ID = INTEGER(pcValue).
     WHEN "CONVERT-3D-COLORS":U THEN f_L._CONVERT-3D-COLORS = LOGICAL(pcValue).
     WHEN "CurrentDescValue":U THEN setSDFSetting("CurrentDescValue":U,pcValue).
     WHEN "CurrentKeyValue":U  THEN setSDFSetting("CurrentKeyValue":U,pcValue).
     WHEN "DataBaseName":U     THEN setAttributeValue("DataBaseName":U,pclevel,pcValue).
     WHEN "DataSourceName":U   THEN setSDFSetting("DataSourceName":U,pcValue).
     WHEN "Data-Type":U        THEN IF pcValue NE ? THEN
                                       f_F._DATA-TYPE       = pcValue.
     WHEN "DEBLANK":U          THEN f_F._DEBLANK         = LOGICAL(pcValue).
     WHEN "DEFAULT":U          THEN ASSIGN f_F._DEFAULT          = LOGICAL(pcValue)
                                           _C._default-btn-recid = RECID(f_U). 
     WHEN "DELIMITER":U        THEN f_F._DELIMITER       = pcValue.
     WHEN "DescSubstitute":U   THEN setSDFSetting("DescSubstitute":U,pcValue).
     WHEN "DISABLE-AUTO-ZAP":U THEN f_F._DISABLE-AUTO-ZAP = LOGICAL(pcValue).
     WHEN "DisableOnInit"      THEN setSDFSetting("DisableOnInit":U,pcValue).
     WHEN "DisplayField":U     THEN IF LOOKUP(f_U._TYPE,"SmartObject,SmartDataField":U) > 0 THEN
                                    setSDFSetting("DisplayField":U,pcValue).
                                    ELSE f_U._DISPLAY    = LOGICAL(pcValue).
     WHEN "DisplayedField":U   THEN setSDFSetting("DisplayedField":U,pcValue).
     WHEN "DisplayFormat":U    THEN setSDFSetting("DisplayFormat":U,pcValue).
     WHEN "DisplayDataType":U  THEN setSDFSetting("DisplayDataType":U,pcValue).
     WHEN "DRAG-ENABLED":U     THEN f_F._DRAG-ENABLED    = LOGICAL(pcValue).
     WHEN "DROP-TARGET":U      THEN f_U._DROP-TARGET     = LOGICAL(pcValue).
     WHEN "EDGE-PIXELS":U      THEN f_L._EDGE-PIXELS     = INTEGER(pcValue).
     WHEN "Enabled":U          THEN f_U._ENABLE          = LOGICAL(pcValue).
     WHEN "EnableField":U      THEN setSDFSetting("EnableField":U,pcValue).
     WHEN "EXPAND":U           THEN f_F._EXPAND          = LOGICAL(pcValue).
     WHEN "FGCOLOR":U          THEN f_L._FGCOLOR         = INTEGER(pcValue).
     WHEN "FieldLabel":U       THEN setSDFSetting("FieldLabel":U,pcValue).
     WHEN "FieldName":U        THEN 
     DO:
       setSDFSetting("FieldName":U,pcValue).
       IF AVAIL f_U THEN f_U._TABLE = ENTRY(1,pcValue,".").
     END.
     WHEN "FieldToolTip":U     THEN setSDFSetting("FieldToolTip":U,pcValue).
     WHEN "FILLED":U           THEN f_L._FILLED          = LOGICAL(pcValue).
     WHEN "FlagValue":U        THEN setSDFSetting("FlagValue":U,pcValue).
     WHEN "ComboFlagValue":U   THEN setSDFSetting("ComboFlagValue":U,pcValue).
     WHEN "FLAT-BUTTON":U      THEN f_F._FLAT            = LOGICAL(pcValue).
     WHEN "FONT":U             THEN f_L._FONT            = INTEGER(pcValue).
     WHEN "FORMAT":U           THEN setAttributeValue("FORMAT":U,pclevel,pcValue).
     WHEN "GRAPHIC-EDGE":U     THEN f_L._GRAPHIC-EDGE    = LOGICAL(pcValue).
     WHEN "GROUP-BOX":U        THEN f_L._GROUP-BOX       = LOGICAL(pcValue).
     WHEN "HEIGHT-CHARS":U     THEN f_L._HEIGHT          = DECIMAL(pcValue).
     WHEN "HELP":U             THEN setAttributeValue("HELP":U,pclevel,pcValue).
     WHEN "HIDDEN":U           THEN ASSIGN f_U._HIDDEN   = LOGICAL(pcValue)
                                           f_U._VISIBLE  = NOT LOGICAL(pcValue).
     WHEN "HideOnInit":U       THEN  
              ASSIGN f_L._REMOVE-FROM-LAYOUT = IF f_L._LO-NAME = "Master Layout":U AND glCustomOnlyField THEN TRUE
                                               ELSE IF LOOKUP(f_U._TYPE,"SmartObject,SmartDataField":U) > 0 
                                               THEN LOGICAL(pcValue)
                                               ELSE  f_L._REMOVE-FROM-LAYOUT.
     WHEN "Horizontal":U       THEN f_F._HORIZONTAL      = LOGICAL(pcValue).
     WHEN "InitialValue":U     THEN f_F._INITIAL-DATA    = pcValue.
     WHEN "Inner-Lines":U      THEN f_F._INNER-LINES     = INTEGER(pcValue).
     WHEN "InnerLines":U       THEN setSDFSetting("InnerLines":U,pcValue).
     WHEN "LARGE":U            THEN f_F._LARGE           = LOGICAL(pcValue).
     WHEN "IMAGE-FILE":U       THEN f_F._IMAGE-FILE      = pcValue.
     WHEN "KeyDataType":U      THEN  setSDFSetting("KeyDataType":U,pcValue).
     WHEN "KeyField":U         THEN  setSDFSetting("KeyField":U,pcValue).
     WHEN "KeyFormat":U        THEN  setSDFSetting("KeyFormat":U,pcValue).
     WHEN "LABEL":U      OR
          WHEN "FieldLabel":U THEN  setAttributeValue("LABEL":U,pclevel,pcValue).
     WHEN "LABELS":U           THEN f_L._NO-LABEL  = NOT LOGICAL(pcValue).
     WHEN "ListItemPairs":U    THEN setSDFSetting("ListItemPairs":U,pcValue).
     WHEN "MappedFields":U     THEN setSDFSetting("MappedFields":U,pcValue).
     WHEN "UseCache":U         THEN setSDFSetting("UseCache":U,pcValue).
     WHEN "MAX-CHARS":U        THEN f_F._MAX-CHARS = INTEGER(pcValue).
     WHEN "MOVABLE":U          THEN f_U._MOVABLE   = LOGICAL(pcValue).
     WHEN "MULTIPLE":U         THEN f_F._MULTIPLE  = LOGICAL(pcValue).
     WHEN "NO-FOCUS":U         THEN f_L._NO-FOCUS        = LOGICAL(pcValue).
     WHEN "LIST-ITEM-PAIRS":U  THEN f_F._LIST-ITEM-PAIRS = pcValue.
     WHEN "LIST-ITEMS":U       THEN IF f_U._TYPE NE "RADIO-SET":U THEN
                                       ASSIGN f_F._LIST-ITEMS      = pcValue.
     WHEN "MANUAL-HIGHLIGHT":U THEN f_U._MANUAL-HIGHLIGHT = LOGICAL(pcValue).
     WHEN "ObjectLayout":U     THEN setSDFSetting("ObjectLayout":U,pcValue).
     WHEN "ORDER":U            THEN ASSIGN f_U._TAB-ORDER       = INTEGER(pcValue).
     WHEN "ParentField":U      THEN setSDFSetting("ParentField":U,pcValue).
     WHEN "ParentFieldQuery":U OR
     WHEN "ParentFilterQuery":U THEN setSDFSetting("ParentFilterQuery":U,pcValue).
     WHEN "PASSWORD-FIELD":U   THEN f_F._PASSWORD-FIELD  = LOGICAL(pcValue).
     WHEN "PRIVATE-DATA":U     THEN f_U._PRIVATE-DATA    = pcValue.
     WHEN "QueryTables":U      THEN setSDFSetting("QueryTables":U,pcValue).
     WHEN "RADIO-BUTTONS":U    THEN IF f_U._TYPE = "RADIO-SET":U THEN
                                       f_F._LIST-ITEMS   = setRadioButtons(pcValue).
                                       
     WHEN "READ-ONLY":U        THEN f_F._READ-ONLY       = LOGICAL(pcValue).
     WHEN "RESIZABLE":U        THEN f_U._RESIZABLE       = LOGICAL(pcValue).
     WHEN "RETAIN-SHAPE":U     THEN f_F._RETAIN-SHAPE    = LOGICAL(pcValue).
     WHEN "RETURN-INSERTED":U  THEN f_F._RETURN-INSERTED = LOGICAL(pcValue).
     WHEN "ROUNDED":U          THEN f_L._ROUNDED         = LOGICAL(pcValue).
     WHEN "ROW":U              THEN f_L._ROW             = DECIMAL(pcValue).
     WHEN "SCROLLBAR-HORIZONTAL":U THEN f_F._SCROLLBAR-H = LOGICAL(pcValue).
     WHEN "SCROLLBAR-VERTICAL":U   THEN f_U._SCROLLBAR-V   = LOGICAL(pcValue).
     WHEN "SDFFileName":U      THEN  setSDFSetting("SDFFileName":U,pcValue).
     WHEN "SDFTemplate":U      THEN setSDFSetting("SDFTemplate":U,pcValue).
     WHEN "Secured":U          THEN setSDFSetting("Secured":U,pcValue).
     WHEN "SELECTABLE":U       THEN f_U._SELECTABLE      = LOGICAL(pcValue).
     WHEN "SENSITIVE":U        THEN f_U._SENSITIVE       = LOGICAL(pcValue).
     WHEN "ShowPopup":U        THEN f_U._SHOW-POPUP      = LOGICAL(pcValue).
     WHEN "SORT":U             THEN 
     DO:
                                     f_F._SORT            = LOGICAL(pcValue).
                                     setSDFSetting("Sort":U,pcValue).
     END.
     WHEN "STRETCH-TO-FIT":U   THEN f_F._STRETCH-TO-FIT  = LOGICAL(pcValue).
     WHEN "SubType":U          THEN IF f_U._SUBTYPE NE "TEXT":U THEN 
                                    f_U._SUBTYPE         = pcValue.
     WHEN "TAB-STOP":U         THEN f_U._NO-TAB-STOP     = NOT LOGICAL(pcValue).
     WHEN "TableName":U        THEN setAttributeValue("TableName":U,pclevel,pcvalue).
     WHEN "TempLocation":U     THEN setSDFSetting("TempLocation":U,pcValue).
     WHEN "THREE-D":U          THEN f_L._3-D             = LOGICAL(pcValue).
     WHEN "Tooltip":U          THEN f_U._TOOLTIP         = pcValue.
     WHEN "TRANSPARENT":U      THEN f_F._TRANSPARENT     = LOGICAL(pcValue).
     WHEN "VISIBLE":U          THEN ASSIGN f_U._HIDDEN          = NOT LOGICAL(pcValue)
                                           f_U._VISIBLE         = LOGICAL(pcValue).                                          
/* The visualizationtype is set in the calling procedure before since other attribute values are conditional 

   on it, and there is no guarantee this attribute is set before the others. Remarked out 12/21/04 db  */ 

     WHEN "VisualizationType":U THEN setAttributeValue("VisualizationType":U,pclevel,pcvalue).
     WHEN "WIDTH-CHARS":U             THEN f_L._WIDTH = INTEGER(pcValue).
     WHEN "LocalField":U              THEN setSDFSetting("LocalField":U,pcValue).
     WHEN "BlankOnNotAvail":U         THEN setSDFSetting("BlankOnNotAvail":U,pcValue).
     WHEN "BrowseFieldDataTypes":U    THEN setSDFSetting("BrowseFieldDataTypes":U,pcValue).
     WHEN "BrowseFieldFormats":U      THEN setSDFSetting("BrowseFieldFormats":U,pcValue).
     WHEN "BrowseFields":U            THEN setSDFSetting("BrowseFields":U,pcValue).
     WHEN "BrowseTitle":U             THEN setSDFSetting("BrowseTitle":U,pcValue).
     WHEN "ColumnFormats":U           THEN setSDFSetting("ColumnFormats":U,pcValue).
     WHEN "ColumnLabels":U            THEN setSDFSetting("ColumnLabels":U,pcValue).
     WHEN "FieldWidth":U              THEN setSDFSetting("FieldWidth":U,pcValue).
     WHEN "LinkedFieldDataTypes":U    THEN setSDFSetting("LinkedFieldDataTypes":U,pcValue).
     WHEN "LinkedFieldFormats":U      THEN setSDFSetting("LinkedFieldFormats":U,pcValue).
     WHEN "MaintenanceObject":U       THEN setSDFSetting("MaintenanceObject":U,pcValue).
     WHEN "MaintenanceSDO":U          THEN setSDFSetting("MaintenanceSDO":U,pcValue).
     WHEN "PhysicalTableNames":U      THEN setSDFSetting("PhysicalTableNames":U,pcValue).
     WHEN "PopupOnAmbiguous":U        THEN setSDFSetting("PopupOnAmbiguous":U,pcValue).
     WHEN "PopupOnUniqueAmbiguous":U  THEN setSDFSetting("PopupOnUniqueAmbiguous":U,pcValue).
     WHEN "PopupOnNotAvail":U         THEN setSDFSetting("PopupOnNotAvail":U,pcValue).
     WHEN "QueryBuilderJoinCode":U    THEN setSDFSetting("QueryBuilderJoinCode":U,pcValue).
     WHEN "QueryBuilderOptionList":U  THEN setSDFSetting("QueryBuilderOptionList":U,pcValue).
     WHEN "QueryBuilderOrderList":U   THEN setSDFSetting("QueryBuilderOrderList":U,pcValue).
     WHEN "QueryBuilderTableOptionList":U THEN setSDFSetting("QueryBuilderTableOptionList":U,pcValue).
     WHEN "QueryBuilderTuneOptions":U THEN setSDFSetting("QueryBuilderTuneOptions":U,pcValue).
     WHEN "QueryBuilderWhereClauses":U THEN setSDFSetting("QueryBuilderWhereClauses":U,pcValue).
     WHEN "RowsToBatch":U             THEN setSDFSetting("RowsToBatch":U,pcValue).
     WHEN "TempTables":U              THEN setSDFSetting("TempTables":U,pcValue).
     WHEN "ViewerLinkedFields":U      THEN setSDFSetting("ViewerLinkedFields":U,pcValue).
     WHEN "ViewerLinkedWidgets":U     THEN setSDFSetting("ViewerLinkedWidgets":U,pcValue).
     WHEN "WORD-WRAP":U               THEN f_F._WORD-WRAP       = LOGICAL(pcValue).
   END CASE.
 END.  /* End if master layout */
 ELSE DO:
    CASE pcLabel:
       WHEN "BGColor":U          THEN f_L._BGCOLOR     = INTEGER(pcValue).
       WHEN "BOX":U              THEN f_L._NO-BOX      = NOT LOGICAL(pcValue).
       WHEN "COLUMN":U           THEN f_L._COL         = DECIMAL(pcValue).
       WHEN "CONVERT-3D-COLORS":U THEN f_L._CONVERT-3D-COLORS = LOGICAL(pcValue).
       WHEN "EDGE-PIXELS":U      THEN f_L._EDGE-PIXELS = INTEGER(pcValue).
       WHEN "FGCOLOR":U          THEN f_L._FGCOLOR     = INTEGER(pcValue).
       WHEN "FILLED":U           THEN f_L._FILLED      = LOGICAL(pcValue).
       WHEN "FONT":U             THEN f_L._FONT        = INTEGER(pcValue).
       WHEN "GRAPHIC-EDGE":U     THEN f_L._GRAPHIC-EDGE = LOGICAL(pcValue).
       WHEN "GROUP-BOX":U        THEN f_L._GROUP-BOX   = LOGICAL(pcValue).
       WHEN "HEIGHT-CHARS":U     THEN f_L._HEIGHT      = DECIMAL(pcValue).
       WHEN "HideOnInit":U       THEN IF LOOKUP(f_U._TYPE,"SmartObject,SmartDataField":U) > 0 THEN
                                      f_L._REMOVE-FROM-LAYOUT = LOGICAL(pcValue).
       WHEN "LABEL":U OR
       WHEN "FieldLabel":U       THEN f_L._LABEL        = pcValue.
       WHEN "LABELS":U           THEN f_L._NO-LABEL     = NOT LOGICAL(pcValue).
       WHEN "NO-FOCUS":U         THEN f_L._NO-FOCUS     = LOGICAL(pcValue).
       WHEN "ROUNDED":U          THEN f_L._ROUNDED      = LOGICAL(pcValue).
       WHEN "ROW":U              THEN f_L._ROW          = DECIMAL(pcValue).
       WHEN "THREE-D":U          THEN f_L._3-D   = LOGICAL(pcValue).
       WHEN "VISIBLE":U          THEN f_L._REMOVE-FROM-LAYOUT = NOT LOGICAL(pcValue).
       WHEN "WIDTH-CHARS":U      THEN f_L._WIDTH = DECIMAL(pcValue).
    END CASE.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignMasterCase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignMasterCase Procedure 
PROCEDURE assignMasterCase :
/*------------------------------------------------------------------------------
  Purpose:    Defines the case statement for master objects. This is called twice,
              once for the object attributes, and once for the class attributes
  Parameters: pcLabel  Attribute label
              pcvaleu  Attribtue value
              pcLevel OBJECT Called from the attributes defines at the instance
                             level. (From ttObjectAttribute)
                      CLASS  Called from the attributes defines at the instance's
                             class  (From ttClassAttribute)
  Notes:      Called from assignmasterAttrs and assignMasterClassAttrs
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcLabel AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcvalue AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcLevel AS CHARACTER  NO-UNDO.

 IF glMasterLayout THEN
 DO:
    CASE pcLabel:
       WHEN "AppService":U                 THEN _P._PARTITION         = pcValue.
       WHEN "AssignList":U                 THEN gcAssignList          = pcValue.
       WHEN "ALLOW-COLUMN-SEARCHING":U     THEN _C._COLUMN-SEARCHING  = LOGICAL(pcValue).
       WHEN "AppBuilderTabbing":U          THEN _C._TABBING           = pcValue.
       WHEN "AUTO-VALIDATE":U              THEN _C._NO-AUTO-VALIDATE  = NOT LOGICAL(pcValue).
       WHEN "BaseQuery":U                  THEN 
         ASSIGN _Q._4GLQury = TRIM(pcValue)
                _Q._4GLQury = IF _Q._4glQury BEGINS "FOR ":U 
                              THEN SUBSTRING(_Q._4GLQury, 5, -1, "CHARACTER":U) ELSE _Q._4GLQury.
       WHEN "BGCOLOR":U                    THEN _L._BGCOLOR           = INTEGER(pcValue).
       WHEN "BrowseColumnBGColors":U       THEN gcBrwsColBGColors      = pcValue.
       WHEN "BrowseColumnFGColors":U       THEN gcBrwsColFGColors      = pcValue.
       WHEN "BrowseColumnFonts":U          THEN gcBrwsColFonts         = pcValue.
       WHEN "BrowseColumnFormats":U        THEN gcBrwsColFormats       = pcValue.
       WHEN "BrowseColumnLabelBGColors":U  THEN gcBrwsColLabelBGColors = pcValue.
       WHEN "BrowseColumnLabelFGColors":U  THEN gcBrwsColLabelFGColors = pcValue.
       WHEN "BrowseColumnLabelFonts":U     THEN gcBrwsColLabelFonts    = pcValue.
       WHEN "BrowseColumnLabels":U         THEN gcBrwsColLabels        = pcValue.
       WHEN "BrowseColumnWidths":U         THEN gcBrwsColWidths        = pcValue.
       WHEN "BrowseColumnTypes":U          THEN gcBrwsColTypes         = pcValue.
       WHEN "BrowseColumnDelimiters":U     THEN gcBrwsColDelimiters = pcValue.
       WHEN "BrowseColumnItems":U          THEN gcBrwsColItems = pcValue.
       WHEN "BrowseColumnItemPairs":U      THEN gcBrwsColItemPairs = pcValue.
       WHEN "BrowseColumnInnerLines":U     THEN gcBrwsColInnerLines = pcValue.
       WHEN "BrowseColumnSorts":U          THEN gcBrwsColSorts = pcValue.
       WHEN "BrowseColumnMaxChars":U       THEN gcBrwsColMaxChars = pcValue.
       WHEN "BrowseColumnAutoCompletions":U THEN gcBrwsColAutoCompletions = pcValue.
       WHEN "BrowseColumnUniqueMatches":U   THEN gcBrwsColUniqueMatches = pcValue.
       WHEN "BOX":U                        THEN IF gcDynClass = "DynView":U
                                                 THEN x_L._NO-BOX = NOT LOGICAL(pcValue).
                                                 ELSE _L._NO-BOX  = NOT LOGICAL(pcValue).
       WHEN "BOX-SELECTABLE":U             THEN _C._BOX-SELECTABLE    = LOGICAL(pcValue).
       WHEN "CalcFieldList":U              THEN gcCalcFieldList       = pcValue.
       WHEN "COLUMN-MOVABLE":U             THEN _C._COLUMN-MOVABLE    = LOGICAL(pcValue).
       WHEN "COLUMN-RESIZABLE":U           THEN _C._COLUMN-RESIZABLE  = LOGICAL(pcValue).
       WHEN "COLUMN-SCROLLING":U           THEN _C._COLUMN-SCROLLING  = LOGICAL(pcValue).
       WHEN "CONTEXT-HELP-ID":U            THEN _U._CONTEXT-HELP-ID   = INTEGER(pcValue).
       WHEN "DataColumns":U                THEN gcDataColumns          = pcValue.
       WHEN "DataColumnsByTable":U         THEN gcDataColumnsByTable   = pcValue.
       WHEN "DataLogicProcedure":U         THEN _C._DATA-LOGIC-PROC    = REPLACE(pcValue,"~\":U,"/":U).
       WHEN "DisplayedFields":U                THEN gcBrowseFields         = pcValue.
       WHEN "DOWN":U                           THEN _C._DOWN              = LOGICAL(pcValue).
       WHEN "DROP-TARGET":U                    THEN _U._DROP-TARGET       = LOGICAL(pcValue).
       WHEN "EnabledFields":U                  THEN gcEnabledFields        = pcValue.
       WHEN "FGCOLOR":U                        THEN _L._FGCOLOR           = INTEGER(pcValue).
       WHEN "FIT-LAST-COLUMN":U                THEN _C._FIT-LAST-COLUMN   = LOGICAL(pcValue).
       WHEN "FolderWindowToLaunch":U           THEN _C._FOLDER-WINDOW-TO-LAUNCH = pcValue.
       WHEN "FONT":U                           THEN _L._FONT              = INTEGER(pcValue).
       WHEN "HELP":U                           THEN _U._HELP              = pcValue.
       WHEN "HIDDEN":U                         THEN _U._HIDDEN            = LOGICAL(pcValue).
       WHEN "LogicalObjectName":U              THEN IF pcValue > "" THEN
                                                       _P._save-as-file   = pcValue.
       WHEN "MANUAL-HIGHLIGHT":U               THEN _U._MANUAL-HIGHLIGHT  = LOGICAL(pcValue).
       WHEN "MAX-DATA-GUESS":U                 THEN _C._MAX-DATA-GUESS    = INTEGER(pcValue).
       WHEN "MinHeight":U                      THEN _L._HEIGHT            = DECIMAL(pcValue).
       WHEN "MinWidth":U                       THEN _L._WIDTH             = DECIMAL(pcValue).
       WHEN "MOVABLE":U                        THEN _U._MOVABLE           = LOGICAL(pcValue).
       WHEN "MULTIPLE":U                       THEN _C._MULTIPLE          = LOGICAL(pcValue).
       WHEN "NO-EMPTY-SPACE":U                 THEN _C._NO-EMPTY-SPACE    = LOGICAL(pcValue).
       WHEN "NUM-LOCKED-COLUMNS":U             THEN _C._NUM-LOCKED-COLUMNS = INTEGER(pcValue).
       WHEN "ObjectType":U                     THEN _P.object_type_code   = pcValue.
       WHEN "OVERLAY":U                        THEN _C._OVERLAY           = LOGICAL(pcValue).
       WHEN "PAGE-BOTTOM":U                    THEN _C._PAGE-BOTTOM       = LOGICAL(pcValue).
       WHEN "PAGE-TOP":U                       THEN _C._PAGE-TOP          = LOGICAL(pcValue).
       WHEN "PhysicalTables":U                 THEN gcPhysicalTables      = pcValue.
       WHEN "PRIVATE-DATA":U                   THEN _U._PRIVATE-DATA      = pcValue.
       WHEN "QueryBuilderFieldDataTypes":U     THEN gcQBFieldDataTypes    = pcValue.
       WHEN "QueryBuilderDBNames":U            THEN gcQBDBNames           = pcValue.
       WHEN "QueryBuilderFieldWidths":U        THEN gcQBFieldWidths       = pcValue.
       WHEN "QueryBuilderInheritValidations":U THEN gcQBInhVals           = pcValue.
       WHEN "QueryBuilderJoinCode":U           THEN gcQBJoinCode          = pcValue.
       WHEN "QueryBuilderOptionList":U         THEN _Q._OptionList        = pcValue.
       WHEN "QueryBuilderOrderList":U          THEN _Q._OrdList           = pcValue.
       WHEN "QueryBuilderTableList":U          THEN _Q._TblList           = pcValue.
       WHEN "QueryBuilderTableOptionList":U    THEN _Q._TblOptList        = pcValue.
       WHEN "QueryBuilderTuneOptions":U        THEN _Q._TuneOptions       = pcValue.
       WHEN "QueryBuilderWhereClauses":U       THEN gcQBWhereClauses      = pcValue.
       WHEN "QueryTempTableDefinitions"        THEN gcTempTableDefinition = pcValue.
       WHEN "RESIZABLE":U                      THEN _U._RESIZABLE         = LOGICAL(pcValue).
       WHEN "ROW-HEIGHT-CHARS":U               THEN _C._ROW-HEIGHT        = DECIMAL(pcValue).
       WHEN "ROW-MARKERS":U                    THEN _C._NO-ROW-MARKERS    = NOT LOGICAL(pcValue).
       WHEN "SCROLLABLE":U                     THEN _C._SCROLLABLE        = LOGICAL(pcValue).
       WHEN "SCROLLBAR-VERTICAL":U             THEN _U._SCROLLBAR-V       = LOGICAL(pcValue).
       WHEN "SELECTABLE":U                     THEN _U._SELECTABLE        = LOGICAL(pcValue).
       WHEN "SENSITIVE":U                      THEN _U._SENSITIVE         = LOGICAL(pcValue).
       WHEN "SEPARATOR-FGCOLOR":U 
         OR WHEN "SeparatorFGColor":U          THEN _L._SEPARATOR-FGCOLOR = INTEGER(pcValue).
       WHEN "SEPARATORS":U                     THEN _L._SEPARATORS        = LOGICAL(pcValue).
       WHEN "ShowPopup":U                      THEN _U._SHOW-POPUP        = LOGICAL(pcValue).
       WHEN "SIDE-LABELS":U                    THEN _C._SIDE-LABELS       = LOGICAL(pcValue).
       WHEN "SizeToFit":U                      THEN _C._SIZE-TO-FIT       = LOGICAL(pcValue).
       WHEN "TAB-STOP":U                       THEN _U._NO-TAB-STOP       = NOT LOGICAL(pcValue).
       WHEN "Tables":U                         THEN gcTables              = pcValue.
       WHEN "TempTables":U                     THEN gcTempTables          = pcValue.
       WHEN "THREE-D":U                        THEN IF gcDynClass = "DynView":U
                                                       THEN x_L._3-D = LOGICAL(pcValue).
                                                       ELSE _L._3-D  = LOGICAL(pcValue).
       WHEN "TOOLTIP":U                        THEN _U._TOOLTIP           = pcValue.
       WHEN "UpdatableColumns":U               THEN gcUpdatableColumns    = pcValue.
       WHEN "UpdatableColumnsByTable":U        THEN gcUpdatableColumnsByTable = pcValue.
       WHEN "WindowTitleField":U               THEN _C._WINDOW-TITLE-FIELD = pcValue.
       
    END CASE. 
 END. /* End if master layout */
 ELSE DO: /* The case for all other layouts */
    CASE pcLabel:
      WHEN "BGCOLOR":U                        THEN _L._BGCOLOR           = INTEGER(pcValue).
      WHEN "BOX":U                            THEN IF gcDynClass = "DynView":U
                                                   THEN x_L._NO-BOX = NOT LOGICAL(pcValue).
                                                   ELSE _L._NO-BOX  = NOT LOGICAL(pcValue).
      WHEN "FGCOLOR":U                        THEN _L._FGCOLOR           = INTEGER(pcValue).
      WHEN "FONT":U                           THEN _L._FONT              = INTEGER(pcValue).
      WHEN "MinHeight":U                      THEN _L._HEIGHT            = DECIMAL(pcValue) NO-ERROR.
      WHEN "MinWidth":U                       THEN _L._WIDTH             = DECIMAL(pcValue) NO-ERROR.
      WHEN "SEPARATOR-FGCOLOR":U              THEN _L._SEPARATOR-FGCOLOR = INTEGER(pcValue).
      WHEN "SEPARATORS":U                     THEN _L._SEPARATORS        = LOGICAL(pcValue).
      WHEN "THREE-D":U                        THEN IF gcDynClass = "DynView":U
                                                    THEN x_L._3-D = LOGICAL(pcValue).
                                                    ELSE _L._3-D  = LOGICAL(pcValue).
    END CASE. 
 END.  /* Else do the case for other layouts */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignSDO Procedure 
PROCEDURE assignSDO :
/*------------------------------------------------------------------------------
  Purpose:   Assign appBuilder temp table fields for SDOs  
  Parameters:  <none>
  Notes:      Called from processMasterObject 
------------------------------------------------------------------------------*/
 /* CREATE _U, _C, _L and _Q for SDO's query */
  VALIDATE _U.
  VALIDATE _C.
  VALIDATE _L.

  ASSIGN grParentRecid   = RECID(_U).

  CREATE _U.   /* Query _U */
  CREATE _C.   /* Query _C */
  CREATE _Q.   /* Query record of the query  */
  CREATE _L.   /* Query _L (not really used) */

  ASSIGN _U._NAME              = "Query-Main"
         _U._TYPE              = "QUERY":U
         _C._q-RECID           = RECID(_Q)
         _U._HELP-SOURCE       = "E":U
         _U._LABEL-SOURCE      = "E":U
         _U._CLASS-NAME        = gcDynExtClass
         _U._LAYOUT-NAME       = "Master Layout":U
         _U._lo-recid          = RECID(_L)
         _U._OBJECT-OBJ        = _RyObject.smartobject_obj
         _U._PARENT-RECID      = grParentRecid
         _U._SENSITIVE         = YES
         _U._WINDOW-HANDLE     = _h_win
         _U._SUBTYPE           = "SmartDataObject":U 
         _U._x-recid           = RECID(_C)
         _L._LO-NAME           = _U._LAYOUT-NAME
         _L._u-recid           = RECID(_U)
         _L._ROW               = 1
         _L._COL               = 1
         _L._COL-MULT          = 1
         _L._ROW-MULT          = 1 
         _C._CUSTOM-SUPER-PROC = ttObject.tCustomSuperprocedure .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignViewerAndBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignViewerAndBrowser Procedure 
PROCEDURE assignViewerAndBrowser :
/*------------------------------------------------------------------------------
  Purpose:    Assign appBuilder common temp table fields for viewers & Browsers  
  Parameters:  <none>
  Notes:      Called from processMasterObject 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE dMinHeight    AS DECIMAL NO-UNDO.
 DEFINE VARIABLE dMinWidth     AS DECIMAL NO-UNDO.
 
ASSIGN dMinHeight = DECIMAL(findAttributeValue("minHeight":U,"MASTER":U))
       dMinWidth  = DECIMAL(findAttributeValue("minWidth":U,"MASTER":U))
       dMinHeight        = IF dMinHeight = ? THEN 1 ELSE dMinheight
       dMinWidth         = IF dMinWidth = ?  THEN 1 ELSE dMinWidth
       _L._HEIGHT        = MAX(1,dMinHeight)
       _L._VIRTUAL-HEIGHT = _L._HEIGHT
       _L._WIDTH          = MAX(1,dMinWidth)
       _L._VIRTUAL-WIDTH  = _L._WIDTH
       _L._FONT           = ?
       _L._WIN-TYPE       = YES
       gdFrameMaxWidth     = MAX(_L._WIDTH,gdFrameMaxWidth)
       gdFrameMaxHeight    = MAX(_L._HEIGHT,gdFrameMaxHeight)
       NO-ERROR.

 /* Do the same for the frame */
 FIND _U WHERE _U._TYPE EQ "FRAME":U AND
               _U._WINDOW-HANDLE EQ _h_win AND
               _U._STATUS NE "DELETED":U.
 FIND _C WHERE RECID(_C) = _U._x-recid.
 
 /* Assign the custom superprocedure value to the _C record */
 ASSIGN _C._CUSTOM-SUPER-PROC = ttObject.tCustomSuperProcedure.
 

 IF glMasterLayout THEN /* Master Layout */
   FIND x_L WHERE RECID(x_L) = _U._lo-recid.
 ELSE DO:  /* All other layouts */
   CREATE x_L.
   ASSIGN x_L._u-recid = RECID(_U)
          x_L._LO-NAME = ttObject.tResultCode.

   /* Initialize with Master Layout because we only read changes */
   FIND m_L WHERE RECID(m_L) = _U._lo-recid.
   BUFFER-COPY m_L EXCEPT _u-recid _LO-NAME _REMOVE-FROM-LAYOUT TO x_L.
 END.

 ASSIGN x_L._HEIGHT         = _L._HEIGHT
        x_L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT
        x_L._WIDTH          = _L._WIDTH
        x_L._VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH
        x_L._FONT           = _L._FONT.

 IF glMasterLayout THEN DO:  /* Only render Master Layout */
   IF _L._WIDTH > _h_win:WIDTH THEN
     ASSIGN _h_win:WIDTH   = _L._WIDTH
            _h_frame:WIDTH = _L._WIDTH.
   ELSE IF _L._WIDTH < _h_win:WIDTH THEN
     ASSIGN _h_frame:WIDTH = _L._WIDTH
            _h_win:WIDTH   = _L._WIDTH.

   IF _L._HEIGHT > _h_win:HEIGHT THEN
     ASSIGN _h_win:HEIGHT   = _L._HEIGHT
            _h_frame:HEIGHT = _L._HEIGHT.
   ELSE IF _L._HEIGHT < _h_win:HEIGHT THEN
     ASSIGN _h_frame:HEIGHT = _L._HEIGHT
            _h_win:HEIGHT   = _L._HEIGHT.
 END.  /* if Master Layout */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildSettingsList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildSettingsList Procedure 
PROCEDURE buildSettingsList :
/*------------------------------------------------------------------------------
  Purpose:     Build gcSettingsList
  Parameters:  <none>
  Notes:       Was part of processInstances but processInstances became
               too big to maintain in the AppBuilder
------------------------------------------------------------------------------*/

    ASSIGN gcSettingsList = 
        "DisplayedField":U          + CHR(4) + CHR(3) + "KeyField":U                    + CHR(4) + CHR(3) +
        "FieldLabel":U              + CHR(4) + CHR(3) + "FieldName":U                   + CHR(4) + CHR(3) +
        "FieldToolTip":U            + CHR(4) + CHR(3) + "KeyFormat":U                   + CHR(4) + CHR(3) +
        "KeyDataType":U             + CHR(4) + CHR(3) + "DisplayFormat":U               + CHR(4) + CHR(3) +
        "DisplayDataType":U         + CHR(4) + CHR(3) + "BaseQueryString":U             + CHR(4) + CHR(3) +
        "QueryTables":U             + CHR(4) + CHR(3) + "SDFFileName":U                 + CHR(4) + CHR(3) +
        "SDFTemplate":U             + CHR(4) + CHR(3) + "ParentField":U                 + CHR(4) + CHR(3) +
        "ParentFilterQuery":U       + CHR(4) + CHR(3) + "DescSubstitute":U              + CHR(4) + CHR(3) +
        "CurrentKeyValue":U         + CHR(4) + CHR(3) + "ComboDelimiter":U              + CHR(4) + CHR(3) +
        "ListItemPairs":U           + CHR(4) + CHR(3) + "CurrentDescValue":U            + CHR(4) + CHR(3) +
        "InnerLines":U              + CHR(4) + CHR(3) + "ComboFlag":U                   + CHR(4) + CHR(3) +
        "FlagValue":U               + CHR(4) + CHR(3) + "BuildSequence":U               + CHR(4) + CHR(3) +
        "Secured":U                 + CHR(4) + CHR(3) + "DisplayField":U                + CHR(4) + CHR(3) +
        "EnableField":U             + CHR(4) + CHR(3) + "LocalField":U                  + CHR(4) + CHR(3) +
        "BlankOnNotAvail":U         + CHR(4) + CHR(3) + "BrowseFieldDataTypes":U        + CHR(4) + CHR(3) +
        "BrowseFieldFormats":U      + CHR(4) + CHR(3) + "BrowseFields":U                + CHR(4) + CHR(3) +
        "BrowseTitle":U             + CHR(4) + CHR(3) + "ColumnFormats":U               + CHR(4) + CHR(3) +
        "ColumnLabels":U            + CHR(4) + CHR(3) + "FieldWidth":U                  + CHR(4) + CHR(3) +
        "LinkedFieldDataTypes":U    + CHR(4) + CHR(3) + "LinkedFieldFormats":U          + CHR(4) + CHR(3) +
        "MaintenanceObject":U       + CHR(4) + CHR(3) + "MaintenanceSDO":U              + CHR(4) + CHR(3) +
        "PhysicalTableNames":U      + CHR(4) + CHR(3) + "PopupOnAmbiguous":U            + CHR(4) + CHR(3) +
        "PopupOnUniqueAmbiguous":U  + CHR(4) + CHR(3) + "PopupOnNotAvail":U             + CHR(4) + CHR(3) +
        "QueryBuilderJoinCode":U    + CHR(4) + CHR(3) + "QueryBuilderOptionList":U      + CHR(4) + CHR(3) +
        "QueryBuilderOrderList":U   + CHR(4) + CHR(3) + "QueryBuilderTableOptionList":U + CHR(4) + CHR(3) +
        "QueryBuilderTuneOptions":U + CHR(4) + CHR(3) + "QueryBuilderWhereClauses":U    + CHR(4) + CHR(3) +
        "RowsToBatch":U             + CHR(4) + CHR(3) + "TempTables":U                  + CHR(4) + CHR(3) +
        "ViewerLinkedFields":U      + CHR(4) + CHR(3) + "ViewerLinkedWidgets":U         + CHR(4) + CHR(3) + 
        "MappedFields":U            + CHR(4) + CHR(3) + "UseCache":U                    + CHR(4) + CHR(3) +
        "DisableOnInit":U           + CHR(4) + CHR(3) + "DisplayField":U                + CHR(4) + CHR(3) + 
        "EnableField":U             + CHR(4) + CHR(3) + "ObjectLayout":U                + CHR(4) + CHR(3) + 
        "AutoFill":U                + CHR(4) + CHR(3) + "TempLocation":U                + CHR(4) + CHR(3) + 
        "Sort":U                    + CHR(4) + CHR(3) + "DataSourceName":U              + CHR(4).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createBrowseBC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowseBC Procedure 
PROCEDURE createBrowseBC :
/*------------------------------------------------------------------------------
  Purpose:    Create _BC records for Browse columns 
  Parameters:  <none>
  Notes:      Called from processMasterObject 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE inumCol    AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iTable     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cViewAs    AS CHARACTER  NO-UNDO.
 
 DO inumCol = 1 TO NUM-ENTRIES(gcBrowseFields):
   cField = ENTRY(inumCol,gcBrowseFields).
   IF VALID-HANDLE(ghSDO) 
       AND DYNAMIC-FUNCTION("ColumnHandle":U IN ghSDO, cField) = ? THEN
      NEXT.
   CREATE _BC.
   ASSIGN _BC._x-recid   = RECID(_U)
          _BC._NAME      = ENTRY(NUM-ENTRIES(cField,'.':U),cField,'.':U)
          _BC._TABLE     = IF NUM-ENTRIES(cField,'.':U) = 2 
                           THEN ENTRY(1,cField,'.':U)
                           ELSE "RowObject":U
          _BC._DISP-NAME = IF NUM-ENTRIES(cField,'.':U) = 2 
                           THEN _BC._TABLE + '.':U + _BC._NAME
                           ELSE _BC._NAME
          _BC._BGCOLOR   = IF gcBrwsColBGColors = "" THEN ?
                           ELSE INTEGER(ENTRY(inumCol, gcBrwsColBGColors, CHR(5))).

   IF VALID-HANDLE(ghSDO) THEN
     ASSIGN _BC._DATA-TYPE  = DYNAMIC-FUNCTION("ColumnDataType":U IN ghSDO, _BC._DISP-NAME)
            _BC._DBNAME     = "_<SDO>":U
            _BC._DEF-FORMAT = DYNAMIC-FUNCTION("ColumnFormat":U IN ghSDO, _BC._DISP-NAME)
            _BC._DEF-HELP   = DYNAMIC-FUNCTION("ColumnHelp":U IN ghSDO, _BC._DISP-NAME)
            _BC._DEF-LABEL  = DYNAMIC-FUNCTION("ColumnColumnLabel":U IN ghSDO, _BC._DISP-NAME)
            _BC._DEF-WIDTH  = MIN(120,MAX(DYNAMIC-FUNCTION("columnWidth" IN ghSDO,_BC._DISP-NAME),
                                  FONT-TABLE:GET-TEXT-WIDTH(ENTRY(1,_BC._DEF-LABEL,"!":U)))).

   ASSIGN _BC._ENABLED    = LOOKUP(_BC._DISP-NAME, gcEnabledFields) > 0
          _BC._FGCOLOR    = IF gcBrwsColFGColors = "" THEN ?
                            ELSE INTEGER(ENTRY(inumCol, gcBrwsColFGColors, CHR(5)))
          _BC._FONT       = IF gcBrwsColFonts = "" THEN ?
                            ELSE INTEGER(ENTRY(inumCol, gcBrwsColFonts, CHR(5)))
          _BC._FORMAT     = IF gcBrwsColFormats = "" THEN _BC._DEF-FORMAT 
                            ELSE IF ENTRY(inumCol, gcBrwsColFormats, CHR(5)) = "?" THEN _BC._DEF-FORMAT
                            ELSE ENTRY(inumCol, gcBrwsColFormats, CHR(5))
          _BC._HELP       = _BC._DEF-HELP
          _BC._LABEL      = IF gcBrwsColLabels = "" THEN _BC._DEF-LABEL
                            ELSE IF ENTRY(inumCol, gcBrwsColLabels, CHR(5)) = "?" THEN _BC._DEF-LABEL
                            ELSE ENTRY(inumCol, gcBrwsColLabels, CHR(5))
          _BC._LABEL-BGCOLOR = IF gcBrwsColLabelBGColors = "" THEN ?
                               ELSE INTEGER(ENTRY(inumCol, gcBrwsColLabelBGColors, CHR(5)))
          _BC._LABEL-FGCOLOR = IF gcBrwsColLabelFGColors = "" THEN ?
                               ELSE INTEGER(ENTRY(inumCol, gcBrwsColLabelFGColors, CHR(5)))
          _BC._LABEL-FONT = IF gcBrwsColLabelFonts = "" THEN ?
                            ELSE INTEGER(ENTRY(inumCol, gcBrwsColLabelFonts, CHR(5)))
          _BC._SEQUENCE   = inumCol
          _BC._WIDTH      = IF gcBrwsColWidths = "" THEN _BC._DEF-WIDTH
                            ELSE IF ENTRY(inumCol, gcBrwsColWidths, CHR(5)) EQ "?" THEN _BC._DEF-WIDTH
                            ELSE DECIMAL(ENTRY(inumCol, gcBrwsColWidths, CHR(5)))
          _BC._VIEW-AS-DELIMITER       = IF gcBrwsColDelimiters = ? OR gcBrwsColDelimiters = "" THEN ""
                                         ELSE ENTRY(inumCol, gcBrwsColDelimiters, CHR(5))
          _BC._VIEW-AS-ITEMS           = IF gcBrwsColItems = ? OR gcBrwsColItems = "" THEN ?
                                         ELSE ENTRY(inumCol, gcBrwsColItems, CHR(5))
          _BC._VIEW-AS-ITEM-PAIRS      = IF gcBrwsColItemPairs = ? OR gcBrwsColItemPairs = "" THEN ?
                                         ELSE ENTRY(inumCol, gcBrwsColItemPairs, CHR(5)).
          _BC._VIEW-AS-INNER-LINES     = IF gcBrwsColInnerLines = ? OR gcBrwsColInnerLines = "" THEN 5
                                         ELSE ENTRY(inumCol, gcBrwsColInnerLines, CHR(5)).
          _BC._VIEW-AS-SORT            = IF gcBrwsColSorts = ? OR gcBrwsColSorts = "" THEN NO
                                         ELSE IF ENTRY(inumCol, gcBrwsColSorts, CHR(5)) BEGINS "Y":U THEN YES
                                         ELSE NO.
          _BC._VIEW-AS-MAX-CHARS       = IF gcBrwsColMaxChars = ? OR gcBrwsColMaxChars = "" THEN 0
                                         ELSE ENTRY(inumCol, gcBrwsColMaxChars, CHR(5)).
          _BC._VIEW-AS-AUTO-COMPLETION = IF gcBrwsColAutoCompletions = ? OR gcBrwsColAutoCompletions = "" THEN NO
                                         ELSE IF ENTRY(inumCol, gcBrwsColAutoCompletions, CHR(5)) BEGINS "Y":U THEN YES
                                         ELSE NO.
          _BC._VIEW-AS-UNIQUE-MATCH    = IF gcBrwsColUniqueMatches = ? OR gcBrwsColUniqueMatches = "" THEN NO
                                         ELSE IF ENTRY(inumCol, gcBrwsColUniqueMatches, CHR(5)) BEGINS "Y":U THEN YES
                                         ELSE NO.

   IF gcBrwsColTypes = ? OR gcBrwsColTypes = "" THEN
      ASSIGN _BC._VIEW-AS-TYPE = "Fill-in":U.

   ELSE DO:
        ASSIGN cViewAs = ENTRY(inumCol, gcBrwsColTypes, CHR(5)).

        CASE cViewAs:
            WHEN ? OR WHEN "?" OR WHEN "FI":U OR WHEN "" THEN ASSIGN _BC._VIEW-AS-TYPE = "Fill-in".
            WHEN "TB":U  THEN ASSIGN _BC._VIEW-AS-TYPE = "Toggle-box":U.
            WHEN "DD":U  THEN ASSIGN _BC._VIEW-AS-TYPE = "DROP-DOWN":U.
            WHEN "DDL":U THEN ASSIGN _BC._VIEW-AS-TYPE = "DROP-DOWN-LIST":U.
        END CASE.
  END.

 END.  /* Do for each Browse Field */
 
 RUN adeuib/_undbrow.p (RECID(_U)).
 CREATE _Q.
 ASSIGN _C._q-RECID = RECID(_Q)
        _Q._tblList = dynamic-function("getViewTables":U IN GhSDO).

 DO iTable = 1 TO NUM-ENTRIES(_Q._tblList):
   _Q._4GLQury  = _Q._4GLQury
                + (IF iTable = 1 THEN "EACH " ELSE ",FIRST ")
                + ENTRY(iTable,_Q._tblList).
 END.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSDOfields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createSDOfields Procedure 
PROCEDURE createSDOfields :
/*------------------------------------------------------------------------------
  Purpose:     IF object is an SDO, create required temp table records
  Parameters:  <none>
  Notes:       Called from processMasterObject
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColumn              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTempTableEntry      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ctableName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE inumCol              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTable               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTableBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColumnsInThisTable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAssignsInThisTable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledInThisTable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDispName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCalcFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumCalc             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE numcol               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTmpFldList          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTable       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcMasterName      AS CHARACTER  NO-UNDO.

 
  DO i = 1 TO NUM-ENTRIES(_Q._TblList):
    IF NUM-ENTRIES(gcQBJoinCode, CHR(5)) > 0 THEN
      _Q._JoinCode[i] = IF ENTRY(i,gcQBJoinCode,CHR(5)) = "?":U THEN ? ELSE ENTRY(i,gcQBJoinCode,CHR(5)).

    IF NUM-ENTRIES(gcQBWhereClauses,CHR(5)) > 0 THEN
      _Q._Where[i] = IF ENTRY(i,gcQBWhereClauses,CHR(5)) = "?":U THEN ? ELSE ENTRY(i,gcQBWhereClauses,CHR(5)).
  END.  
  
  /* Check whether the table in the 4gl query is from a temp table, if so append 'Temp-Tables.' */
  IF gcTempTables > "" THEN
  DO i = 1 TO NUM-ENTRIES(_Q._4glQury, " "):
    IF LOOKUP(TRIM(ENTRY(i,_Q._4glQury, " ")), gcTempTables) > 0 AND NUM-ENTRIES(ENTRY(i,_Q._4glQury, " "),".") =  1 THEN
       ENTRY(i,_Q._4glQury, " ") = "Temp-Tables." + ENTRY(i,_Q._4glQury, " ") .
  END.
  
  /* If the SDO is based on a buffer or temp table, create appropriate _TT record */
  IF gcTempTableDefinition > "" THEN
  DO:
     /* Ensure there are no double spaces in gcTempTableDefinition */
     REMOVE-LOOP:
     DO WHILE TRUE ON STOP UNDO, LEAVE:
        gcTempTableDefinition = REPLACE(gcTempTableDefinition, "  ":U," ":U).
        IF INDEX(gcTempTableDefinition,"  ") = 0 THEN
            LEAVE REMOVE-LOOP.
     END.
     /* Multiple TTs are CHR(3) delimtied */
     DO i = 1 TO NUM-ENTRIES(gcTempTableDefinition,CHR(3)):
        cTempTableEntry = ENTRY(i,gcTempTableDefinition,CHR(3)).
        IF NUM-ENTRIES(cTempTableEntry," ") >= 6 THEN
        DO:
           CREATE _TT.
           ASSIGN _TT._p-recid            = RECID(_P)
                  _TT._NAME               = ENTRY(1,cTempTableEntry," ")
                  _TT._TABLE-TYPE         = ENTRY(2,cTempTableEntry," ")
                  _TT._SHARE-TYPE         = IF ENTRY(3,cTempTableEntry," ") = "?"
                                            THEN "":U  
                                            ELSE ENTRY(3,cTempTableEntry," ")
                  _TT._UNDO-TYPE          = IF ENTRY(4,cTempTableEntry," ") = "?"
                                            THEN "":U  
                                            ELSE ENTRY(4,cTempTableEntry," ")
                  _TT._LIKE-DB            = ENTRY(5,cTempTableEntry," ")
                  _TT._LIKE-TABLE         = ENTRY(6,cTempTableEntry," ").
          
           IF NUM-ENTRIES(ctempTableEntry," ") >= 7 AND ENTRY(7,cTempTableEntry," ") > "" THEN       
               ASSIGN _TT._ADDITIONAL_FIELDS  = TRIM(SUBSTRING(cTempTableEntry,  
                                                          INDEX(cTempTableEntry," " + ENTRY(7,ctempTableEntry," ") + " "), -1)) NO-ERROR.
        END.                                                
     END.
  END.

  /* We need to create the _BC records, but the attribute lists we have read in have had 
     their tables stripped off.  These can be discerned by using the DataColumnsByTable and 
     the Tables attributes together.  The DataColumnsByTable attribute is a list of columns 
     separated by commas, but with breaks denoted by colons.  If there are 3 tables,
     then there are 3 colon delimited breaks corresponding to the tables. */
  ASSIGN inumCol     = 0
         cTmpFldList = gcDataColumns.

  /* Create _BC records table by table */
  TABLE-LOOP:
  DO iTable = 1 TO NUM-ENTRIES(gcPhysicalTables):
    ASSIGN 
        cPhysicalTable = ENTRY(iTable, gcPhysicalTables).
        cTableName     = ENTRY(iTable, gcTables).
    /* Use Buffer on db table to calculate the field info  */
    CREATE BUFFER hTableBuffer FOR TABLE cPhysicalTable NO-ERROR.
    /* If not connected to database, might generate an error */
    IF ERROR-STATUS:ERROR THEN
    DO:
       MESSAGE "Could not create buffer for table '" cPhysicalTable "'  for the object '" _P.object_filename "'." SKIP 
               "This may be because you are not connected to the appropriate database."
               view-as alert-box ERROR.
       RETURN "ERROR":U.
    END.   
    ASSIGN cColumnsInThisTable = TRIM(ENTRY(iTable, gcDataColumnsByTable, ";":U))
           cAssignsInThisTable = IF gcAssignList EQ "":U 
                                    THEN "":U  ELSE ENTRY(iTable, gcAssignList, ";":U)
           cEnabledInThisTable = IF NUM-ENTRIES(gcUpdatableColumnsByTable, ";":U) GE iTable 
                                   THEN ENTRY(iTable, gcUpdatableColumnsByTable, ";":U)
                                   ELSE "":U.
    COLUMN-LOOP:
    DO iColumn = 1 TO NUM-ENTRIES(cColumnsInThisTable):
      ASSIGN cColumnName = ENTRY(icolumn, cColumnsInThisTable)
             cDispName   = cColumnName.
      IF LOOKUP(cColumnName, cAssignsInThisTable) > 0 THEN
        cColumnName = ENTRY(LOOKUP(cColumnName, cAssignsInTHisTable) + 1 , cAssignsInThisTable).

      /* Need to remove extent before getting the handle of the buffer field */
      cColumnName = SUBSTRING(cColumnName,1,INDEX(cColumnName,'[':U) - 1).
      IF VALID-HANDLE(hTableBuffer) THEN
        hField = hTableBuffer:BUFFER-FIELD(cColumnName). /* Get handle to the field to get default info */

      /* Determine the correct sequence number */
      inumCol = LOOKUP(cDispName, cTmpFldList).
      /* Remove name from the temporary list of fields, but keep a place holder */
      ENTRY(inumCol,cTmpFldList) = "_".
      
      /* NOTE:  The Format, Label and Help will be re-assigned later in assignDataFields. Cannot re-fetch from
              repository until we are finished with the  fetchinfg of the master object*/
      /* Create the _BC record and assign the fields. */
      CREATE _BC.
      ASSIGN _BC._x-recid    = RECID(_U)
             grFrameRecid     = RECID(_U)
             _BC._SEQUENCE   = inumCol
             _BC._DBNAME     = IF gcQBDBNames = "":U OR 
                                  ENTRY(inumCol, gcQBDBNames) = "?":U THEN hField:DBNAME 
                                  ELSE ENTRY(inumCol, gcQBDBNames)
             _BC._DBNAME     = IF _BC._DBNAME = "temp-db":U OR LOOKUP(cPhysicalTable,gcTempTables) > 0 
                               THEN "Temp-Tables":U ELSE _BC._DBNAME                     
             _BC._TABLE      = cTableName
             _BC._DATA-TYPE  = IF gcQBFieldDataTypes = "":U OR
                                  ENTRY(inumCol, gcQBFieldDataTypes) = "?":U THEN hField:DATA-TYPE
                                  ELSE ENTRY(inumCol, gcQBFieldDataTypes)
             _BC._DISP-NAME  = IF gcDataColumns = "":U OR
                                 ENTRY(inumCol, gcDataColumns) = "?":U THEN hField:NAME 
                                 ELSE ENTRY(inumCol, gcDataColumns)                   
             _BC._NAME       = IF LOOKUP(_BC._DISP-NAME,cAssignsInThisTable) > 0
                               THEN ENTRY(LOOKUP(_BC._DISP-NAME,cAssignsInThisTable) + 1,
                                          cAssignsInThisTable)
                               ELSE _BC._DISP-NAME
             _BC._DEF-FORMAT = hField:FORMAT
             _BC._FORMAT     = hField:FORMAT
             _BC._DEF-HELP   = hField:HELP
             _BC._DEF-LABEL  = hField:LABEL
             _BC._DEF-COLLABEL = hField:COLUMN-LABEL
             _BC._DEF-WIDTH  = 10      /* Haven't saved this */
             _BC._ENABLED    = LOOKUP(_BC._DISP-NAME, cEnabledInThisTable) > 0
             _BC._HELP       = hField:HELP
             _BC._LABEL      = hField:LABEL
             _BC._COL-LABEL  = IF hField:LABEL = hField:COLUMN-LABEL THEN ?
                               ELSE hField:COLUMN-LABEL
             _BC._WIDTH      = IF gcQBFieldWidths = "":U or
                                 ENTRY(inumCol,gcQBFieldWidths) = "?":U THEN hField:WIDTH-CHARS
                                 ELSE DECIMAL(ENTRY(inumCol,gcQBFieldWidths))
             _BC._INHERIT-VALIDATION = IF gcQBInhVals = "":U OR
                                        ENTRY(inumCol, gcQBInhVals) = "NO":U THEN NO
                                        ELSE YES
             .
        
    END.  /* FOr each column in the table */
    
  END. /* DO for each table */
 
  ASSIGN gcTempTables = "".  
  /* Calculated fields are stored in DataColumnsByTable last separated by ;
     like an additional table.  If there are more entries in 
     DataColumnsByTable than number of tables, these are calculated fields. */
  IF NUM-ENTRIES(gcDataColumnsByTable,";":U) GT NUM-ENTRIES(gcTables) THEN
  DO:
    ASSIGN 
      cCalcFields         = ENTRY(NUM-ENTRIES(gcDataColumnsByTable,";":U), gcDataColumnsByTable, ";":U)
      cEnabledInThisTable = IF NUM-ENTRIES(gcUpdatableColumnsByTable, ";":U) = NUM-ENTRIES(gcDataColumnsByTable, ";":U)
                            THEN ENTRY(NUM-ENTRIES(gcDataColumnsByTable,";":U), gcUpdatableColumnsByTable, ";":U)
                            ELSE "":U
                            .
    DO iNumCalc = 1 TO NUM-ENTRIES(cCalcFields):
      numCol = LOOKUP(ENTRY(iNumCalc,cCalcFields), cTmpFldList).
      ENTRY(numCol,cTmpFldList) = "_".

      /* Gets calculated field master name from the calcFieldList */
      cCalcMasterName = IF gcCalcFieldList NE '':U THEN
                        DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                         INPUT ENTRY(iNumCalc,cCalcFields),
                                         INPUT gcCalcFieldList,
                                         INPUT TRUE,
                                         INPUT ",":U)
                        ELSE ENTRY(iNumCalc,cCalcFields).

      CREATE _BC.
      ASSIGN _BC._x-recid        = RECID(_U)
             _BC._SEQUENCE       = numCol
             _BC._DISP-NAME      = ENTRY(iNumCalc,cCalcFields)
             _BC._NAME           = cCalcMasterName
             _BC._DBNAME         = "_<CALC>":U
             _BC._TABLE          = ?
             _BC._LABEL          = ""
             _BC._FORMAT         = "x(8)":U
             _BC._DATA-TYPE      = IF NUM-ENTRIES(gcQBFieldDataTypes) >= numCol 
                                   THEN ENTRY(numCol, gcQBFieldDataTypes) ELSE ?
             _BC._HELP           = ""
             _BC._WIDTH          = IF NUM-ENTRIES(gcQBFieldWidths) >= numCol
                                   THEN DECIMAL(ENTRY(numCol, gcQBFieldWidths)) ELSE 0
             _BC._ENABLED        = LOOKUP(_BC._DISP-NAME, cEnabledInThisTable) > 0
             .
    END.  /* do to number calc fields */
  END.  /* if have calc fields */

  RUN adeuib/_undqry.p (INPUT RECID(_U)).


  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dynsucker_cleanup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dynsucker_cleanup Procedure 
PROCEDURE dynsucker_cleanup :
/* ---------------------------------------------------------------------
      Description: Close open file streams and restore cursor.  This
                   should be called everywhere we return from _qssuckr
          
      Parameters:  None
      Non-local effects: _P_QS
   ------------------------------------------------------------------------*/ 
  INPUT STREAM _P_QS CLOSE.           /* Close Streams                     */
  IF temp_file ne "" THEN DO:
    OS-DELETE VALUE(temp_file).       /* Delete disk garbage               */
    OS-DELETE VALUE(temp_file + "2"). /* Delete disk garbage               */
  END.

  /*  jep-icf: Cleanup repository related stuff. */
  IF glisRyObject THEN
  DO:
    /*  jep-icf: Delete the temporary template file for dynamic repository objects. */
    IF glDynObject AND FALSE THEN
      OS-DELETE VALUE(gcDynTempFile).

    /*  jep-icf: If _qssuckr ended via an abort, delete the _RyObject. It's not 
        used beyond the NEW or OPEN processing. */
    IF AbortImport THEN
    DO:
      IF NOT AVAILABLE _RyObject THEN
        FIND _RyObject WHERE _RyObject.object_filename = open_file NO-ERROR.
      IF AVAILABLE _RyObject THEN
        DELETE _RyObject.
    END. /* AbortImport */
  END.
      
  /* The _rd* procedures may have started an sdo */
  shutdown-sdo(THIS-PROCEDURE).
  ghSDO = ?.  
  CURRENT-WINDOW = _h_menu_win.       /* Make sure we reset current-window */
  RUN adecomm/_setcurs.p ("").        /* Restore cursor pointers           */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRepositoryObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchRepositoryObject Procedure 
PROCEDURE fetchRepositoryObject :
/*------------------------------------------------------------------------------
  Purpose:    Uses design-time repository API to retrieve objects  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcObjectName   AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcResultCode   AS CHARACTER  NO-UNDO.
 
 
 /* Retrieve the objects and instances for the current object opened in the appBuilder */
 RUN retrieveDesignObject IN ghDesignManager 
                                     ( INPUT  pcObjectName,
                                       INPUT  pcResultCode,  /* Get  result Codes */
                                       OUTPUT TABLE ttObject,
                                       OUTPUT TABLE ttPage,
                                       OUTPUT TABLE ttLink,
                                       OUTPUT TABLE ttUiEvent,
                                       OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 
IF RETURN-VALUE > "" THEN
   RETURN RETURN-VALUE.
 IF NOT CAN-FIND(FIRST ttObject) THEN
   RETURN "_ABORT":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchSDO Procedure 
PROCEDURE launchSDO :
/*------------------------------------------------------------------------------
  Purpose:    launches the specified SDO for the current ttObject
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDesignDataObject AS CHARACTER  NO-UNDO.
  FIND ttObject WHERE ttObject.tLogicalObjectName = _ryObject.object_filename 
                  AND ttObject.tResultCode        = "{&DEFAULT-RESULT-CODE}":U NO-ERROR.
  
  IF ttObject.tSDOObjectName > '' THEN
    cDesignDataObject = ttObject.tSDOObjectName.
  ELSE 
    cDesignDataObject  = findAttributeValue('DesignDataObject':U,'master':U).

  IF cDesignDataObject > '' THEN
  DO:
    /* Let the appbuilder start the sdo */
    ghSDO = get-sdo-hdl(cDesignDataObject,THIS-PROCEDURE).
    IF NOT VALID-HANDLE(ghSDO) THEN
       RETURN "ERROR":U.
  
    glSBODataSource = IF {fn getObjectType ghSDO} = 'SmartBusinessObject':U
                      THEN TRUE
                      ELSE FALSE.  
    
    _P._DATA-OBJECT = cDesignDataObject.
  END.
  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processInstances Procedure 
PROCEDURE processInstances :
/*------------------------------------------------------------------------------
  Purpose:    Process Instances for dynamic viewers. Loop through all instances
              from the repository and retrieve the attributes of the class and write
              out to the temp table fields. Continue with attributes of the master,
              and then the instance. 
  Parameters:  <none>
  Notes:      Called from processMasterObject 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cName           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dWidgetHeight   AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dWidgetRow      AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dWidgetWidth    AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dWidgetCol      AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE iCnt            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE ctmp            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSDFFileName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumnName     AS CHARACTER  NO-UNDO.
 
 /* Loop through all retrieved object instances for the current ttObject */
 CHILD-LOOP:
 FOR EACH b_ttObject WHERE b_ttObject.tContainerSmartObjectObj = ttObject.tSmartObjectObj:
                       
    IF NUM-ENTRIES(b_ttObject.tObjectInstanceName,".":U) > 1 THEN
      ASSIGN cName = ENTRY(2, b_ttObject.tObjectInstanceName, ".":U).
    ELSE IF NUM-ENTRIES(b_ttObject.tLogicalObjectName," ":U) > 1 THEN
      ASSIGN cName = ENTRY(2, b_ttObject.tObjectInstanceName, " ":U).
    ELSE
      ASSIGN cName = b_ttObject.tObjectInstanceName.

    /* If the instance only exists in a custom layout , create the master _U,_F and _L records */
    IF NOT glMasterLayout THEN
       ASSIGN  glCustomOnlyField = NOT CAN-FIND(f_U WHERE f_U._NAME = cName AND f_U._WINDOW-HANDLE EQ _h_win)
               glMasterLayout   =  glCustomOnlyField.
    ELSE
       glCustomOnlyField = FALSE.
    
     /* fetch the class attributes in case the master attributes are not found */
    IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = b_ttObject.tClassName) THEN
       RUN retrieveDesignClass IN ghDesignManager
                        ( INPUT  b_ttObject.tClassname,
                          OUTPUT gcInheritClasses,
                          OUTPUT TABLE ttClassAttribute ,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttSupportedLink         ) NO-ERROR.                          
  
    /* Make sure this is a valid object to place on a Viewer.  This should never happen, 
       but it has due to bad data (object type codes) in the repository.                */
    IF LOOKUP("Query":U,gcInheritClasses) = 0
       AND LOOKUP("Visual":U,gcInheritClasses) = 0   
       AND LOOKUP("ProgressWidget":U,gcInheritClasses) = 0 
       AND LOOKUP("DataField":U,gcInheritClasses) = 0   THEN 
    DO:
        MESSAGE b_ttObject.tClassName b_ttObject.tObjectInstanceName "is not a valid child object of a dynamic viewer."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
      NEXT Child-Loop.
    END.
     /* If the Master Layout */
    IF glMasterLayout THEN 
    DO:  
       CREATE f_U.
       CREATE f_F.
       CREATE f_L.
       ASSIGN f_U._ALIGN         = "C":U        
              f_U._lo-recid      = RECID(f_L)
              f_U._PARENT        = _h_frame:FIRST-CHILD
              f_U._PARENT-RECID  = RECID(_U)
              f_U._OBJECT-OBJ    = b_ttObject.tObjectInstanceObj
              f_U._CLASS-NAME    = b_ttObject.tClassName
              f_U._OBJECT-NAME   = b_ttObject.tLogicalObjectName
              f_U._NAME          = cName
              f_U._SENSITIVE     = YES
              f_U._SUBTYPE       = ""
              f_U._x-recid       = RECID(f_F)
              f_U._WINDOW-HANDLE = _h_win
              f_U._LAYOUT-NAME   = "Master Layout":U 
             NO-ERROR.   
       
       IF VALID-HANDLE(ghSDO) THEN
       DO:
         /* If the data source is a DataView (DbAware is false) then the column names must be qualified.  
            f_U._TABLE cannot be used to qualify the column name because the processing of attributes 
            has not happened at this point.  f_U._OBJECT-NAME was set from the logical object name for 
            the instance which is the correct qualified column name. */
         cColumnName = IF {fn getDbAware ghSDO} THEN f_U._NAME
                       ELSE f_U._OBJECT-NAME.
         IF DYNAMIC-FUNCTION("columnDataType":U IN ghSDO, INPUT cColumnName) = "CLOB":U THEN
           ASSIGN f_F._SOURCE-DATA-TYPE = "CLOB":U.
       END.

       /* Check whether the format, label and help are defined on the instance */
       FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                                      AND ttObjectAttribute.tObjectInstanceObj = b_ttObject.tObjectInstanceObj
                                      AND ttObjectAttribute.tAttributeLabel    = 'HELP':U NO-ERROR.
       IF AVAIL ttObjectAttribute AND (ttObjectAttribute.tAttributeValue <> "?" AND ttObjectAttribute.tAttributeValue <> ?)
       THEN f_U._HELP-SOURCE   = "E":U.
       ELSE f_U._HELP-SOURCE   = "D":U.

       FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                                      AND ttObjectAttribute.tObjectInstanceObj = b_ttObject.tObjectInstanceObj
                                      AND ttObjectAttribute.tAttributeLabel    = 'LABEL':U NO-ERROR.
       IF AVAIL ttObjectAttribute AND (ttObjectAttribute.tAttributeValue <> "?" AND ttObjectAttribute.tAttributeValue <> ?)
       THEN f_U._LABEL-SOURCE   = "E":U.
       ELSE f_U._LABEL-SOURCE   = "D":U. 

       FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                                      AND ttObjectAttribute.tObjectInstanceObj = b_ttObject.tObjectInstanceObj
                                      AND ttObjectAttribute.tAttributeLabel    = 'FORMAT':U NO-ERROR.
       IF AVAIL ttObjectAttribute AND (ttObjectAttribute.tAttributeValue <> "?" AND ttObjectAttribute.tAttributeValue <> ?)
       THEN f_F._FORMAT-SOURCE   = "E":U.
       ELSE f_F._FORMAT-SOURCE   = "D":U. 
       IF glSBODataSource AND NUM-ENTRIES(b_ttObject.tObjectInstanceName, ".":U) = 2 THEN
          gcSDOName = ENTRY(1, b_ttObject.tObjectInstanceName, ".":U). 
          
       ASSIGN f_U._TYPE = findAttributeValue("VisualizationType":U,"INSTANCE":U).

       /* Make sure we know the type before reading other attributes */
     
       IF LOOKUP("Field":U,gcInheritClasses) > 0  THEN
           ASSIGN f_U._TYPE = "SmartDataField":U.
       IF f_U._TYPE = "TOGGLE-BOX" THEN 
           ASSIGN f_F._DATA-TYPE = "LOGICAL":U.
       ELSE IF f_U._TYPE = "SELECTION-LIST":U THEN
           ASSIGN f_F._DATA-TYPE = "CHARACTER":U.

       ASSIGN f_L._ROW-MULT           = 1
              f_L._COL-MULT           = 1
              f_L._u-recid            = RECID(f_U)
              f_L._WIN-TYPE           = YES
              f_L._LO-NAME            = "Master Layout":U
              f_L._REMOVE-FROM-LAYOUT = IF glCustomOnlyField THEN TRUE ELSE FALSE.
    END.   /* End if master layout */
    
    IF NOT glMasterLayout OR glCustomOnlyField THEN /* All other custom Layouts */
    DO:                         
      IF glCustomOnlyField THEN 
      DO:
         /* Create _L for this layout */
         FIND m_L WHERE RECID(m_L) = RECID(f_L) NO-ERROR.
         CREATE f_L.
         ASSIGN f_L._LO-NAME = b_ttObject.tResultCode
                f_L._u-recid = RECID(f_U).
         BUFFER-COPY m_l EXCEPT _LO-NAME _u-recid _REMOVE-FROM-LAYOUT TO f_L. 
      END.
      FIND f_U WHERE f_U._NAME          = cName AND
                     f_U._WINDOW-HANDLE = _h_win NO-ERROR.
                     
      IF NOT AVAILABLE f_U AND NUM-ENTRIES(b_ttObject.tObjectInstanceName, ".":U) > 1 THEN
        FIND f_U WHERE f_U._NAME = ENTRY(2, b_ttObject.tObjectInstanceName, ".":U) AND
                       f_U._WINDOW-HANDLE = _h_win NO-ERROR.
     
      FIND f_F WHERE RECID(f_F) = f_U._x-recid NO-ERROR.  /* won't have one for SDF */
      
      FIND f_L WHERE f_L._LO-NAME = b_ttObject.tResultCode AND f_L._u-recid = RECID(f_U) NO-ERROR.
      
    END.
   
    /* Get the widget Row,Col,Height and Width */
    ASSIGN dWidgetRow    = DECIMAL(findAttributeValue("Row":U,"INSTANCE":U))
           dWidgetCol    = DECIMAL(findAttributeValue("Column":U,"INSTANCE":U))
           dWidgetHeight = DECIMAL(findAttributeValue("HEIGHT-CHARS":U,"INSTANCE":U))
           dWidgetWidth  = DECIMAL(findAttributeValue("WIDTH-CHARS":U,"INSTANCE":U)) NO-ERROR.
      
    /* Safety measure until bug gets fixed */
    IF dWidgetHeight = 0 OR dWidgetHeight = ? THEN dWidgetHeight = 1.
    IF dWidgetWidth  = 0 OR dWidgetWidth = ?  THEN dWidgetWidth  = 2.
    
    /* Calculate the maximum width and height of the widgets */
    ASSIGN gdFrameMaxWidth  = MAX(gdFrameMaxWidth, dWidgetCol + dWidgetWidth - 1)
           gdFrameMaxHeight = MAX(gdFrameMaxHeight, dWidgetRow + dWidgetHeight - 1).
        
    /* Build empty string for SDF field. */
    RUN buildSettingsList.

    /* Set the inheritted attributes from the class for this instance only for master objects */
    IF glMasterLayout THEN
    DO:
      FOR EACH ttClassAttribute WHERE ttClassAttribute.tClassname = b_ttObject.tClassname:
         RUN assignInstanceCase(ttClassAttribute.tAttributeLabel,ttClassAttribute.tAttributeValue,"CLASS":U). 
      END. 
      /* Process the object attributes of the instances' master object  */
      FOR EACH ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                                   AND ttObjectAttribute.tObjectInstanceObj = 0:
          RUN assignInstanceCase(ttObjectAttribute.tAttributeLabel,ttObjectAttribute.tAttributeValue,"OBJECT":U). 
      END.  /* End For each ttobjectAttribute */
    END.  

   /* Retrieve the master object for SDF fields with auto-attach */
   ASSIGN cSDFFileName = findAttributeValue("SDFFileName":U,"INSTANCE":U).  
   IF glMasterLayout AND cSDFFileName > "" THEN
   DO:
      ASSIGN f_U._TYPE = "SmartDataField":U.
      RUN retrieveDesignObject IN ghDesignManager 
                                     ( INPUT  cSDFFileName,
                                       INPUT  "",  /* Get  result Codes */
                                       OUTPUT TABLE SDFttObject,
                                       OUTPUT TABLE ttPage,
                                       OUTPUT TABLE ttLink,
                                       OUTPUT TABLE ttUiEvent,
                                       OUTPUT TABLE SDFttObjectAttribute ) NO-ERROR. 
      IF RETURN-VALUE > "" THEN RETURN RETURN-VALUE.                                 
      FIND FIRST SDFttObject WHERE SDFttObject.tLogicalObjectName =   cSDFFileName NO-ERROR.
      IF AVAIL SDFttObject THEN 
      DO:
         ASSIGN f_U._CLASS-NAME = SDFttObject.tClassname.
         /* Process class attributes for auto-attached field */
         RUN retrieveDesignClass IN ghDesignManager
                        ( INPUT  SDFttObject.tClassname,
                          OUTPUT gcInheritClasses,
                          OUTPUT TABLE ttClassAttribute ,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttSupportedLink         ) NO-ERROR.                                  
         FOR EACH ttClassAttribute WHERE ttClassAttribute.tClassname = SDFttObject.tClassname:
            RUN assignInstanceCase(ttClassAttribute.tAttributeLabel,ttClassAttribute.tAttributeValue,"CLASS":U). 
         END. 
             
         /* Process the master attributes */
         FOR EACH SDFttObjectAttribute WHERE SDFttObjectAttribute.tSmartObjectObj    = SDFttObject.tSmartObjectObj
                                         AND SDFttObjectAttribute.tObjectInstanceObj = SDFttObject.tObjectInstanceObj:
             RUN assignInstanceCase(SDFttObjectAttribute.tAttributeLabel,SDFttObjectAttribute.tAttributeValue,"OBJECT":U). 
         END.  /* End For each ttobjectAttribute */      
      END.
   END.   

   /* Assign instance attributes defined on the master level */
   FOR EACH ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                              AND ttObjectAttribute.tObjectInstanceObj = b_ttObject.tObjectInstanceObj:
      /* Checks each attribute in a case statement and maps the appBuilder temp table field with the 
       repository attribute */
      RUN assignInstanceCase(ttObjectAttribute.tAttributeLabel,ttObjectAttribute.tAttributeValue,"OBJECT":U). 
   END.  
   
   /* If we have a datafield whose width is 0, then ask the SDO */
    IF f_L._WIDTH = ? AND VALID-HANDLE(ghSDO) AND 
       LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
              INPUT "DataField":U)) <> 0 THEN
      f_L._WIDTH = DYNAMIC-FUNCTION("ColumnWidth":U IN ghSDO, f_U._NAME).

    /* Safety measure */
    IF f_L._WIDTH  = 0 THEN f_L._WIDTH  = dWidgetWidth.
    IF f_L._HEIGHT = 0 THEN f_L._HEIGHT = dWidgetHeight.

    IF glMasterLayout THEN DO: /* Master Layout */
      /* Now that we have read all of the attributes in, and know the delimiter (if any),
         fix list-items and list-item-pairs */
      IF f_F._LIST-ITEMS NE ? AND f_U._TYPE NE "RADIO-SET":U
        THEN f_F._LIST-ITEMS = REPLACE(f_F._LIST-ITEMS, f_F._DELIMITER, CHR(10)).
      ELSE IF f_U._TYPE EQ "RADIO-SET" THEN DO:
        /* Put <CR> after the values */
        IF NUM-ENTRIES(f_F._LIST-ITEMS, f_F._DELIMITER) > 3 AND
           NUM-ENTRIES(f_F._LIST-ITEMS, CHR(10)) < 2 THEN DO:
          DO iCnt = 3 TO NUM-ENTRIES(f_F._LIST-ITEMS, f_F._DELIMITER) BY 2:
            ENTRY(iCnt, f_F._LIST-ITEMS, f_F._DELIMITER) = CHR(10) + 
                ENTRY(iCnt, f_F._LIST-ITEMS, f_F._DELIMITER).
          END.
        END.  /* There are more than 1 item and no <CR>s */
        ELSE IF f_F._LIST-ITEMS = "" OR f_F._LIST-ITEMS = ? THEN
           ASSIGN f_F._LIST-ITEMS = "Item1,1".             
      END.

      IF f_F._LIST-ITEM-PAIRS NE ? AND f_F._LIST-ITEM-PAIRS NE "":U THEN DO: 
        cTmp = "":U.
        DO iCnt = 1 TO NUM-ENTRIES(f_F._LIST-ITEM-PAIRS, f_F._DELIMITER):
          cTmp = cTmp + f_F._DELIMITER + 
                        (IF iCnt MOD 2 = 1 THEN CHR(10) ELSE "") +
                        ENTRY(iCnt, f_F._LIST-ITEM-PAIRS, f_F._DELIMITER). 
        END.
        f_F._LIST-ITEM-PAIRS = TRIM(cTmp, CHR(10) + f_F._DELIMITER).
      END. /* IF List ITEM PAIRS is non blank */
    END.  /* End if the Master Layout */

    /* Reset the parent frames Width and height  */
    /* Find window _U and populate */
    FIND _U WHERE _U._TYPE EQ "WINDOW":U AND
                  _U._WINDOW-HANDLE EQ _h_win AND
                  _U._STATUS NE "DELETED":U.
    FIND _L WHERE _L._u-recid = RECID(_U) AND 
                  _L._LO-NAME = IF glMasterLayout THEN "Master Layout":U ELSE b_ttObject.tResultCode.
           
    ASSIGN _L._HEIGHT         = gdFrameMaxHeight
           _L._Virtual-Height = _L._HEIGHT
           _L._WIDTH          = gdFrameMaxWidth
           _L._VIRTUAL-WIDTH  = _L._WIDTH.

    /* Do the same for the frame */
    FIND _U WHERE _U._TYPE EQ "FRAME":U AND
                  _U._WINDOW-HANDLE EQ _h_win AND
                  _U._STATUS NE "DELETED":U.
    FIND _C WHERE RECID(_C) = _U._x-recid.
    FIND x_L WHERE x_L._u-recid = RECID(_U) AND
                   x_L._LO-NAME = IF glMasterLayout THEN "Master Layout":U ELSE  b_ttObject.tResultCode.

    ASSIGN x_L._HEIGHT         = _L._HEIGHT
           x_L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT
           x_L._WIDTH          = _L._WIDTH
           x_L._VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH
           x_L._BGCOLOR        = _L._BGCOLOR
           x_L._FONT           = _L._FONT
           x_L._FGCOLOR        = _L._FGCOLOR.

    IF glMasterLayout THEN 
    DO:  /* Only realize Master layout */
      IF _L._WIDTH > _h_win:WIDTH THEN
        ASSIGN _h_win:WIDTH   = _L._WIDTH
               _h_frame:WIDTH = _L._WIDTH.
      ELSE IF _L._WIDTH < _h_win:WIDTH THEN
        ASSIGN _h_frame:WIDTH = _L._WIDTH
               _h_win:WIDTH   = _L._WIDTH.

      IF _L._HEIGHT > _h_win:HEIGHT THEN
        ASSIGN _h_win:HEIGHT   = _L._HEIGHT
               _h_frame:HEIGHT = _L._HEIGHT.
      ELSE IF _L._HEIGHT < _h_win:HEIGHT THEN
        ASSIGN _h_frame:HEIGHT = _L._HEIGHT
               _h_win:HEIGHT   = _L._HEIGHT.

      IF gcDynClass = "DynView":U AND
         (_L._BGCOLOR NE ? OR _L._FONT NE ? OR _L._FGCOLOR NE ?) THEN
        ASSIGN _h_frame:BGCOLOR = _L._BGCOLOR
               _h_frame:FGCOLOR = _L._FGCOLOR
               _h_frame:FONT    = _L._FONT.
    END.  /* If Master Layout */

    IF glCustomOnlyField THEN 
    DO:
       /* Assign custom layout equal to master layout */
       FIND f_U WHERE f_U._NAME          = cName AND
                      f_U._WINDOW-HANDLE = _h_win NO-ERROR.           
                     
       FIND f_L WHERE f_L._LO-NAME = b_ttObject.tResultCode AND f_L._u-recid = RECID(f_U) NO-ERROR.
       
       FIND m_L WHERE m_L._LO-NAME = "Master Layout":U      AND m_L._u-recid = RECID(f_U) NO-ERROR.
       BUFFER-COPY f_l EXCEPT _LO-NAME _u-recid _REMOVE-FROM-LAYOUT TO m_L. 
    END.
    RUN realizeWidget IN THIS-PROCEDURE .
    IF glCustomOnlyField THEN glMasterLayout = FALSE.
 END. /* End for each b_ttObject */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processMasterObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processMasterObject Procedure 
PROCEDURE processMasterObject :
/*------------------------------------------------------------------------------
  Purpose:    Retrieve the object and processes the master object for the 
              specified object opened in the appBuilder
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cInheritClasses AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE added_fields    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE h               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hfgp            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lDummy          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cBrokerURL      AS CHARACTER  NO-UNDO.
 
 DEFINE BUFFER parent_NAME-REC FOR _NAME-REC.
 
 /* Run design time API to fetch the ttObject and ttObjectAttribute temp tables */
 RUN fetchRepositoryObject IN THIS-PROCEDURE(INPUT _ryObject.object_filename, /* Object Name TO retrieve */
                                             INPUT "":U ).                     /* Retrieve all result codes */
 IF RETURN-VALUE > "" THEN RETURN RETURN-VALUE.
 
 /* Get master object for default and retrieve the SDO ObjectName if this object
    is a dynviewer or dynbrowser. Then start it up. 
    Note: gcDynClass is assigned in validateRepositoryObject*/
 IF gcDynClass = "DynView":U OR gcDynClass = "DynBrow":U THEN
 DO:
     RUN launchSDO IN THIS-PROCEDURE.
     IF RETURN-VALUE > "" THEN 
     DO:
        IF VALID-HANDLE(_h_win) THEN 
           RUN wind-close IN _h_uib (INPUT _h_win).   
        RUN dynsucker_cleanup.
        RETURN "_ABORT":U.
     END.   
     /* Refetch ttObject as launchSDO may have fetched the SDO object*/
     RUN fetchRepositoryObject IN THIS-PROCEDURE(INPUT _ryObject.object_filename, /* Object Name TO retrieve */
                                                 INPUT "*":U ).  
     IF RETURN-VALUE > "" THEN RETURN RETURN-VALUE.                                            
 END.
   
/* Loop through master default object*/
 FOR EACH ttObject WHERE ttObject.tContainerSmartObjectObj = 0
                    AND ttObject.tResultCode = "{&DEFAULT-RESULT-CODE}":
    /* get inherited values of the class once */
    IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = ttObject.tClassName) THEN
       RUN retrieveDesignClass IN ghDesignManager
                      ( INPUT  ttObject.tClassname,
                        OUTPUT cInheritClasses,
                        OUTPUT TABLE ttClassAttribute,
                        OUTPUT TABLE ttUiEvent,
                        OUTPUT TABLE ttSupportedLink         ) NO-ERROR.  
    /* Find window _U and populate */
    FIND _U WHERE _U._TYPE EQ "WINDOW":U AND
                  _U._WINDOW-HANDLE EQ _h_win AND
                  _U._STATUS NE "DELETED":U.
    
    ASSIGN glMasterLayout = TRUE.

    FIND _L WHERE RECID(_L) = _U._lo-recid.
    /* Assign the smartObject_obj, this lets us know that the object already exists */
    ASSIGN _U._OBJECT-OBJ = _RyObject.smartobject_obj NO-ERROR.
    /* Set the Custom super procedure */
    FIND _C WHERE RECID(_C) = _U._x-recid.
    ASSIGN _C._CUSTOM-SUPER-PROC = ttObject.tCustomSuperProcedure.
    
    /* Assign temp table fields specific to browsers and viewers */
    IF gcDynClass EQ "DynView":U OR gcDynClass = "DynBrow":U THEN 
        RUN assignViewerAndBrowser IN THIS-PROCEDURE.
      
    IF gcDynClass EQ "DynBrow":U THEN 
       RUN assignBrowser IN THIS-PROCEDURE.
    ELSE IF gcDynClass EQ "DynSDO":U THEN 
       RUN assignSDO IN THIS-PROCEDURE.      

    /* Assign master attributes defined on the class level */
    FOR EACH ttClassAttribute WHERE ttClassAttribute.tClassname = ttObject.tClassname:
       /* Assigns the appBuilder temp table field with the repository attribute value of the class */
       RUN assignMasterCase(ttClassAttribute.tAttributeLabel,ttClassAttribute.tAttributeValue,"CLASS":U). 
    END. 

    /* Assign master attributes defined on the master level */
    FOR EACH ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                              AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj :
       /* Assigns the appBuilder temp table field with the repository attribute value of the master */
       RUN assignMasterCase(ttObjectAttribute.tAttributeLabel,ttObjectAttribute.tAttributeValue,"OBJECT":U). 
    END. /* For each ttObjectAttribute */

    /* Create _BC records for browse object for master layout */
    IF _U._TYPE = "BROWSE":U  THEN       /* if object is a DynBrowse */
        RUN createBrowseBC IN THIS-PROCEDURE.
    ELSE IF _U._TYPE = "QUERY":U  THEN  /* if object is a DynSDO */
    DO:
       RUN CreateSDOfields IN THIS-PROCEDURE. 
       IF RETURN-VALUE > "" THEN 
       DO:
          IF VALID-HANDLE(_h_win) THEN 
             RUN wind-close IN _h_uib (INPUT _h_win).   
          RUN dynsucker_cleanup.
          RETURN "_ABORT":U.
     END.   
    END.    
    ELSE IF _U._TYPE = "FRAME":U THEN                     /* if object is a dynamic viewer */   
       /* Process the instances for the current object for dynamic viewers*/
       RUN processInstances IN THIS-PROCEDURE.

    /* Create a _TT for each SDO, each SDO in the SBO, and for each data source table 
       in the DataView.  _TT records are not needed for dynamic browsers.
     */
    if _P._Data-Object gt '':U AND gcDynClass NE "DynBrow":U then     
        RUN adeuib/_upddott.w (RECID(_P)).
    
    IF _h_frame = ? and _h_win = ? THEN 
    DO:
      RUN adecomm/_setcurs.p ("").
      MESSAGE "Aborting import." 
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RUN dynsucker_cleanup. /* Close everything qssucker does */
      RETURN "_ABORT":U. 
    END. /* If no frame and no window */

    /* A valid file should always have a Custom Definitions and Main-Code block 
       (even if they are empty).  As protection, make sure we have these sections
       even if one was not in the input file. [Note - don't add these sections 
       if we are importing a section of .w file]. */
    IF import_mode <> "IMPORT" AND ((def_found = no) OR (main_found = no)) THEN 
    DO:
      FIND _U WHERE _U._HANDLE = _h_win.
      IF NOT def_found 
         AND NOT CAN-FIND(FIRST _TRG WHERE _TRG._wRECID = RECID(_U) 
                                       AND _TRG._tEvent ="_DEFINITIONS":U) THEN 
      DO:
        CREATE _TRG.
        ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
               _TRG._tSECTION = "_CUSTOM":U
               _TRG._wRECID   = RECID(_U)
               _TRG._tEVENT   = "_DEFINITIONS":U.
        RUN adeshar/_coddflt.p ("_DEFINITIONS":U, RECID(_U), OUTPUT _TRG._tCODE). 
      END. /* If not found a definitions section */
      IF NOT main_found AND NOT CAN-FIND(FIRST _TRG WHERE _TRG._wRECID = RECID(_U) 
                                       AND _TRG._tEvent ="_MAIN-BLOCK":U) THEN 
      DO:
        CREATE _TRG.
        ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
               _TRG._tSECTION = "_CUSTOM":U
               _TRG._wRECID   = RECID(_U)
               _TRG._tEVENT   = "_MAIN-BLOCK":U
               _TRG._tCODE    = "". 
      END. /* If not a main section found */
    END. /* If importing and we haven't found either a main of definitions section */

    /* Restore counts */
    DO i = 1 TO {&WIDGET-COUNT-DIMENSION}:
      _count[i] = MAX(gcCountTmp[i],_count[i]).
    END.

    /* Cleanup after ourselves. */
    RUN dynsucker_cleanup.

    /* Now force the current window visible and on the screen.  This gets around
       bug where the some other window-system window has moved to the foreground. */
    FIND _U WHERE _U._HANDLE eq _h_win.
    IF _U._TYPE = "DIALOG-BOX" THEN h = _U._HANDLE:PARENT. /* the "real" window */
    ELSE h = _h_win.

    /* Don't show the dummy wizard for HTML files in design mode. */
    IF NOT AVAILABLE (_P) OR _P._file-type <> "HTML" OR _P._TEMPLATE THEN DO:
         h:VISIBLE = TRUE.
    END.
    /* It's important to do this for hidden windows also,
       if not window triggers in the wizard will fire for the last entered window */ 
    IF h:MOVE-TO-TOP() THEN APPLY "ENTRY":U TO h.      

    /* Having read in the values for the Procedure, check if this is a special `
       ADM SmartObject and reset the _P record according to ADM standards */
    IF import_mode BEGINS "WINDOW":U THEN 
    DO:
      FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
      IF _P._TYPE BEGINS "Smart":U THEN 
        RUN adeuib/_admpset.p (RECID(_P)).
      IF LOOKUP(_P._TYPE, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                          INPUT "SmartBrowser":U)) <> 0 AND _P._ADM-VERSION > "ADM1" THEN DO:
        ASSIGN h    = _h_win:FIRST-CHILD  /* The Frame       */
               hfgp = h:FIRST-CHILD       /* The field group */
               h    = hfgp:FIRST-CHILD.   /* The browse      */
        DO WHILE VALID-HANDLE(h):
          IF h:TYPE = "BROWSE":U THEN
            ASSIGN h:HIDDEN = TRUE.
          ASSIGN h = h:NEXT-SIBLING.
        END. /* Do while valid handle */
      END.  /* If a SmartBrowser and > adm1 */
    END.  /* If import begins window */
     
    IF import_mode ne "IMPORT" THEN 
    DO:
      IF NOT AVAILABLE(_P) THEN 
        FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.

      /* Copy all _RyObject fields to _P */
      BUFFER-COPY _RyObject TO _P.

      /* Send event to notify anyone interested that the UIB has opened a file.
         Note that opening a window UNTITLED counts as a NEW event.  */
      CASE import_mode:
        WHEN "WINDOW":U THEN
          RUN adecomm/_adeevnt.p 
              (INPUT  "UIB":U, "OPEN":U, STRING(_P._u-recid), _P._SAVE-AS-FILE,
               OUTPUT ldummy).
        WHEN "WINDOW UNTITLED":U THEN
          RUN adecomm/_adeevnt.p
              (INPUT  "UIB":U, "NEW":U, STRING(_P._u-recid), ?,
               OUTPUT ldummy).
      END CASE.

      /* Add procedure to MRU Filelist - we need to make sure that import mode
         is not "window untitled" so that templates do not display in the MRU 
         filelist. */
      IF import_mode NE "WINDOW UNTITLED" AND _mru_filelist THEN DO:
        ASSIGN cBrokerURL = IF _mru_broker_url NE "" THEN _mru_broker_url ELSE _BrokerURL.
        RUN adeshar/_mrulist.p (open_file, "":U).  
      END.  /* if import_mode and _mru_filelist */
    END. /* IF import_mode ne "IMPORT"  */ 

 END. /* End for each ttObject (Master)*/
 
 /* Loop through all custom objects */
 FOR EACH ttObject WHERE ttObject.tContainerSmartObjectObj = 0
                    AND ttObject.tResultCode <> "{&DEFAULT-RESULT-CODE}":
     /* get inherited values of the class once */
    IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = ttObject.tClassName) THEN
       RUN retrieveDesignClass IN ghDesignManager
                      ( INPUT  ttObject.tClassname,
                        OUTPUT cInheritClasses,
                        OUTPUT TABLE ttClassAttribute,
                        OUTPUT TABLE ttUiEvent,
                        OUTPUT TABLE ttSupportedLink         ) NO-ERROR.                  
      /* Find window _U and populate */
    FIND _U WHERE _U._TYPE EQ "WINDOW":U AND
                  _U._WINDOW-HANDLE EQ _h_win AND
                  _U._STATUS NE "DELETED":U.              
                  
    ASSIGN glMasterLayout = FALSE.
    CREATE _L.

    /* Initialize with Master Layout because we only read changes */
    FIND m_L WHERE RECID(m_L) = _U._lo-recid.
    ASSIGN _L._u-recid = RECID(_U)
           _L._LO-NAME = ttObject.tResultCode.
    BUFFER-COPY m_L EXCEPT _u-recid _LO-NAME TO _L.                
    /* Assign temp table fields specific to browsers and viewers */
    
    IF gcDynClass EQ "DynView":U OR gcDynClass = "DynBrow":U THEN 
        RUN assignViewerAndBrowser IN THIS-PROCEDURE.
      
    IF gcDynClass EQ "DynBrow":U THEN 
       RUN assignBrowser IN THIS-PROCEDURE.
    ELSE IF gcDynClass EQ "DynSDO":U THEN 
       RUN assignSDO IN THIS-PROCEDURE.

    /* Assign master attributes defined on the master level */
    FOR EACH ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                              AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj :
       /* Assigns the appBuilder temp table field with the repository attribute value of the master */
       RUN assignMasterCase(ttObjectAttribute.tAttributeLabel,ttObjectAttribute.tAttributeValue,"OBJECT":U). 
    END. /* For each ttObjectAttribute */

    IF _U._TYPE = "FRAME":U THEN                     /* if object is a dynamic viewer */   
    DO:                                   
      /* Create _Ls for all contained widgets, because the repository only gives us the differences 
         and the AppBuilder requires all of the info.  We will change the
          copied info when we get the changes.                                                       */
       FOR EACH f_U WHERE f_U._PARENT-RECID = RECID(_U):
         FIND m_L WHERE RECID(m_L) = f_U._lo-recid NO-ERROR.  /* Should be the master LO */
         IF AVAILABLE m_l THEN DO:
           /* Create _L for this layout */
           CREATE f_L.
           ASSIGN f_L._LO-NAME = ttObject.tResultCode
                  f_L._u-recid = RECID(f_U).
           BUFFER-COPY m_l EXCEPT _LO-NAME _u-recid TO f_L.
         END.  /* If we find the master _L */
       END.  /* for each child of the frame */
       
       /* Process the instances for the current object for dynamic viewers*/
       RUN processInstances IN THIS-PROCEDURE.
    END.            
    
 END.  /* END for each ttObject custom layouts */                   
 
 /* Retrieve the datafield masters and assign the format, help and label attribtues */
 IF gcDynClass = "DynSDO":U THEN
    RUN assignDataFields IN THIS-PROCEDURE.
 

 /* The _rd* procedures may have started an sdo */
  DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).
     
  /* If Treeview design window, refresh the Treeview. */
  RUN TreeviewUpdate.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-realizeWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE realizeWidget Procedure 
PROCEDURE realizeWidget :
/*------------------------------------------------------------------------------
  Purpose:     realize the widget for master layouts 
  Parameters:  <none>
  Notes:       Called from ProcessInstances
------------------------------------------------------------------------------*/
DEFINE VARIABLE tmpName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ilnth       AS INTEGER    NO-UNDO.
DEFINE VARIABLE newDigit    AS INTEGER    NO-UNDO.
DEFINE VARIABLE lLocalField AS LOGICAL    NO-UNDO.
def var dSmartobjectObj as decimal no-undo.

DEFINE BUFFER l_U             FOR _U.
DEFINE BUFFER l_F             FOR _F.

/* The height is defaulted to 1, the field is not populated above so do it explicitly */
IF f_U._TYPE = "FILL-IN":U  THEN
   IF f_L._HEIGHT = 0 THEN f_L._HEIGHT = 1.

IF glMasterLayout  THEN
 CASE f_U._TYPE:
   WHEN "FILL-IN":U THEN 
   DO:
     /* Make the label _U for this fill-in */
     CREATE l_U.
     CREATE l_F.
     ASSIGN f_U._l-recid       = RECID(l_U)
            l_U._l-recid       = RECID(f_U)
            l_U._x-recid       = RECID(l_F)
            l_U._PARENT-RECID  = f_U._PARENT-RECID
            l_U._PARENT        = _h_frame:FIRST-CHILD
            l_F._FRAME         = f_F._FRAME
            l_U._SUBTYPE       = "LABEL":U
            l_U._NAME          = "_LBL-":U + f_U._NAME
            l_U._TYPE          = "TEXT":U
            l_F._DATA-TYPE     = "Character":U
            l_U._WINDOW-HANDLE = _h_win.
     RUN adeuib/_undfill.p (RECID(f_U)).
   END.  /* End Fill-in case */
   WHEN "EDITOR":U         THEN RUN adeuib/_undedit.p (RECID(f_U)).
   WHEN "RECTANGLE":U      THEN RUN adeuib/_undrect.p (RECID(f_U)).
   WHEN "BUTTON":U         THEN RUN adeuib/_undbutt.p (RECID(f_U)).
   WHEN "IMAGE":U          THEN RUN adeuib/_undimag.p (RECID(f_U)).
   WHEN "RADIO-SET":U      THEN RUN adeuib/_undRadi.p (RECID(f_U)).
   WHEN "SELECTION-LIST":U THEN RUN adeuib/_undSele.p (RECID(f_U)).
   WHEN "TOGGLE-BOX":U     THEN RUN adeuib/_undtogg.p (RECID(f_U)).
   WHEN "TEXT":U           THEN RUN adeuib/_undtext.p (RECID(f_U)).
   WHEN "COMBO-BOX":U      THEN RUN adeuib/_undcomb.p (RECID(f_U)).
   WHEN "SmartDataField":U THEN 
   DO:
     /* We need to create an _S for the SDF */
     DELETE f_F.
     CREATE _S.

     tmpName = "h_":U + f_U._CLASS-NAME.
     DO WHILE CAN-FIND(X_U WHERE X_U._NAME = tmpName AND 
                       RECID(X_U) NE RECID(f_U)):
       IF LOOKUP(tmpName,"h_DynLookup,h_DynCombo,h_DynSelect":U) > 0 THEN
         tmpName = tmpName + "1":U.
       ELSE DO:
         ilnth = LENGTH(tmpName). 
         ASSIGN newDigit = INTEGER(SUBSTRING(tmpName, ilnth, 1)) + 1
                tmpName  = SUBSTRING(tmpName, 1, ilnth - 1) + STRING(newDigit).
       END. /* Else DO */
     END. /* Do while looking for a unique name */

     
     /* This is for backward compatibility */
     IF NUM-ENTRIES(f_U._NAME,".":U) > 1 THEN f_U._NAME = tmpName.

     /* Override some of the stuff above */
     ASSIGN f_U._ALIGN          = "L":U
            f_U._TYPE           = "SmartObject":U
            f_U._SUBTYPE        = "SmartDataField":U
            f_U._x-recid        = RECID(_S).
     ASSIGN _S._FILE-NAME       = IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN 
                                           gshRepositoryManager, INPUT "DynCombo":U)) <> 0
                                    THEN "adm2\dyncombo.w":U
                                  ELSE IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN 
                                           gshRepositoryManager, INPUT "DynLookup":U)) <> 0
                                    THEN "adm2\dynlookup.w":U
                                  ELSE IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN 
                                           gshRepositoryManager, INPUT "DynSelect":U)) <> 0
                                    THEN "adm2\dynselect.w":U
                                  ELSE f_U._OBJECT-NAME.
     ASSIGN _S._SETTINGS = gcSettingsList.
            
     IF SEARCH(_S._FILE-NAME) = ? THEN
     DO:
         dSmartObjectObj = dynamic-function('getSmartObjectObj':u in gshRepositoryManager, 
                                             _S._File-Name, 0).
        _S._File-name = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager, dSmartObjectObj).         
     END. /* Can't find the file */

     /* Try it again */
     IF SEARCH(_S._FILE-NAME) = ? THEN DO:
       MESSAGE "Unable to locate" _S._File-name + ".":U SKIP
               "Can't instantiate it."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
     END.

     RUN adeuib/_undsmar.p (RECID(f_U)).
     
     /* If the SDF is for a local field rather than a datafield, _TABLE
        needs to be ? so that the object name is enabled in the 
        Appbuilder main window.  */
     IF VALID-HANDLE(_S._HANDLE) THEN
       lLocalField = DYNAMIC-FUNCTION("getLocalField" IN _S._HANDLE).
     IF lLocalField THEN f_U._TABLE = ?.

   END.  /* When a SmartData Field */
 END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scanFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scanFile Procedure 
PROCEDURE scanFile :
/*------------------------------------------------------------------------------
  Purpose: Save the file position, we scan down to the Analyzer widget definitions 
           and process them, then come back to this point to process code blocks
  Parameters:  <none>
  Notes:   For the case of a single window with NO frames, there will be no
           ANALYZER_BEGIN section. So the 2nd exit condition is if we get an error
           reading from the file.    
           Called from Main block.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE block_pointer       AS INTEGER  NO-UNDO.
 DEFINE VARIABLE no-block-flag       AS LOGICAL  NO-UNDO.
 DEFINE VARIABLE import_unnamedframe AS LOGICAL  NO-UNDO.
 DEFINE VARIABLE h_frame_init        AS HANDLE     NO-UNDO.

 
 block_pointer = SEEK(_P_QS).
 SCAN-FILE:
 REPEAT WHILE NOT _inp_line[1] begins "_ANALYZER_BEGIN" 
        ON END-KEY UNDO SCAN-FILE, RETRY SCAN-FILE:   /* Ignore "." lines in a file */
   IMPORT STREAM _P_QS UNFORMATTED _inp_line[1] NO-ERROR. /* Catch END-OF-FILE here */
   IF ERROR-STATUS:ERROR THEN DO:
     no-block-flag = TRUE.
     LEAVE SCAN-FILE.                                 
   END.        

   /* Catch ? as the only entry. Bug #96-06-06-10*/
   IF _inp_line[1] eq ? THEN _inp_line[1] = "?":U.
   
   /* In 7.4A, the _CREATE-WINDOW is preceded by a _PROCEDURE-SETTINGS section */
   IF _inp_line[1] BEGINS " _PROCEDURE-SETTINGS":U THEN DO:
     /* For WDT_v2 objects, we have already created a _P, since the Procedure
        type and template info is stored along with the version number on the
        first line. */
     IF NOT AVAILABLE _P THEN CREATE _P.
     _P._file-version = file_version.  /* Its important to save file_version early */
     RUN adeuib/_rdproc.p (RECID(_P)).
   END.

   /* We need to read the Window definition before we create the frame */
   IF _inp_line[1] BEGINS " _CREATE-WINDOW" THEN DO:
     /* 7.3 Compatilitity: There will not be a _P if the .w file is old. */
     IF NOT AVAILABLE (_P) THEN DO:
       CREATE _P.
       ASSIGN _P._TYPE         = "Window":U
              _P._file-version = file_version.
     END.
     RUN adeuib/_rdwind.p (RECID(_P)).
     FIND _U WHERE _U._HANDLE = _h_win.
     ASSIGN _U._PARENT-RECID = RECID(_U)
            _U._WIN-TYPE     = YES.
   END. /* End of window creation block */
   
   IF _inp_line[1] BEGINS "/* REPARENT FRAME":U THEN DO:
     _inp_line = "".
     REPEAT WHILE INDEX(_inp_line[5],".":U) = 0 AND INDEX(_inp_line[6],".":U) = 0:
       IMPORT STREAM _P_QS _inp_line.
       i = IF _inp_line[1] = "ASSIGN":U THEN 1 ELSE 0.
       CREATE _frame_owner_tt.
       ASSIGN _frame_owner_tt._child  = ENTRY(1,_inp_line[i + 2],":":U)
              _frame_owner_tt._parent = ENTRY(1,_inp_line[i + 5],":":U).
     END.  /* Repeat till period is found. */   
     SEEK STREAM _P_QS TO block_pointer.
     LEAVE SCAN-FILE.
   END.
 END.  /* SCAN-FILE */

 IF no-block-flag THEN DO:
   INPUT STREAM _P_QS CLOSE.
   INPUT STREAM _P_QS FROM VALUE(temp_file) {&NO-MAP}.
   SEEK STREAM _P_QS TO block_pointer.
 END.

 /* Check to see if this exists */
 FILE-INFO:FILE-NAME = temp_file + "2":U.
 IF FILE-INFO:FILE-TYPE = ? THEN
   _inp_line[1] = "".
 ELSE DO:
   INPUT STREAM _P_QS2 FROM VALUE(temp_file + "2":U) {&NO-MAP}.
   IMPORT STREAM _P_QS2 UNFORMATTED _inp_line[1] NO-ERROR.
 END.

 /*  Now we are at the start of the ANALYZER DEFINITIONS.  */
 IF _inp_line[1] begins "_ANALYZER_BEGIN" THEN
 WIDGET-LOOP:
 REPEAT ON END-KEY UNDO WIDGET-LOOP, LEAVE WIDGET-LOOP:
   /* Let the user know we are working on something */
   RUN adecomm/_setcurs.p ("WAIT":U).

   /* Read the next line */
   _inp_line = "".
   IMPORT STREAM _P_QS2 _inp_line.
   /* Check to see if we have a valid window to place things into.    */           
   IF _h_win = ? AND _inp_line[1] NE "FR" AND /* May be a dialog      */
      NOT _inp_line[1] BEGINS "M"  /* Menus can come any time - they  */
                                   /* get parented later              */
   THEN DO:   
     MESSAGE "There is no window or dialog-box to place things in.  Aborting" SKIP
             "the opening of" dot-w-file + "."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     RETURN "_ABORT":U.
   END.

   CASE _inp_line[1]:
                                         
     WHEN "FR":U THEN DO:  /* Read static FRAME information              */
       ASSIGN _def_butt = ?
              _can_butt = ?.
       /* The UNNAMED frame does not have to be read-in when we are importing. 
          It indicates a frame the UIB used to cut field-level widgets.  */
       IF NOT (import_mode = "IMPORT":U AND _inp_line[2] = "") THEN DO:
         /* Before importing a frame, restore the initial _h_frame so that we
            can parent it, if we need to. */
         _h_frame = h_frame_init.
         tab-number = 0.
         RUN adeuib/_rdfram.p (INPUT-OUTPUT import_mode). 
         
         IF import_mode = "ABORT" THEN DO:
           /* Reset the cursor for user input.*/
           RUN adecomm/_setcurs.p ("").
           MESSAGE "Aborting import." 
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
           RUN dynsucker_cleanup. /* Close everything qssucker does */
           RETURN "_ABORT":U. 
         END.
       END.  /* If importing from the default frame */
       ELSE /* We have found the unnamed frame in import mode.  Be sure to  */
       DO:  /* set the current frame back to the initial in order to parent */
            /* the upcoming widgets */
            ASSIGN _h_frame = h_frame_init.
            /* Set a var to track that the import file is for an unnamed frame.
               Used later when importing an export file to determine which frame's
               properties to set and when setting tab order items. -jep */
            ASSIGN import_unnamedframe = TRUE.
       END.
       /* If a dialog, set menu window handles, and attach it to the procedure.*/
       FIND _U WHERE _U._HANDLE = _h_frame.
       IF _U._TYPE = "DIALOG-BOX" THEN DO:
         /* Attach to Procedure record. */
         IF import_mode NE "IMPORT" THEN DO:
           /* We will have already read in Procedure Settings (and created a _P) but
              the associated _U-recid will not have been set. [unless the file is old].
              -------
              7.3 Compatilitity: There will not be a _P if the .w file is old. */
           IF NOT AVAILABLE (_P) OR _P._u-recid NE ? THEN DO:
             CREATE _P.
             ASSIGN _P._TYPE         = "Dialog-Box":U.
           END.
           ASSIGN _P._SAVE-AS-FILE  = _save_file
                  _P._file-version  = file_version
                  _P._WINDOW-HANDLE = _U._WINDOW-HANDLE
                  _P._u-recid       = RECID(_U).
         END.
         /* Set Menu - Popup menus have been created and attatched to the
            CURRENT-WINDOW (because the dialog-box _h_win was not created
            when the menus were built).  Reparent them*/
         FOR EACH x_U WHERE x_U._WINDOW-HANDLE = CURRENT-WINDOW AND
                           x_U._TYPE BEGINS "MENU":
           x_U._WINDOW-HANDLE = _U._HANDLE.
         END.
       END.
     END.  /* END FR CASE */

     OTHERWISE NEXT WIDGET-LOOP.
   END CASE.
   
   IF RETURN-VALUE = "_ABORT":U THEN DO:
     IF VALID-HANDLE(_h_win) THEN 
        RUN wind-close IN _h_uib (INPUT _h_win).   
     RUN dynsucker_cleanup. /* Close everything qssucker does */
     RETURN "_ABORT":U.
   END.

 END.  /* WIDGET-LOOP */

 /* Finished reading the analyzer definitions, reset file to begining of code  */
 /* block information                                                          */
 INPUT STREAM _P_QS2 CLOSE.
 
 SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-TreeviewUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeviewUpdate Procedure 
PROCEDURE TreeviewUpdate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* If Treeview design window, refresh the Treeview to show fields,
  code sections, etc. */

  FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
  IF VALID-HANDLE(_P._tv-proc) THEN
    RUN createTree IN _P._tv-proc (RECID(_P)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateRepositoryObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRepositoryObject Procedure 
PROCEDURE validateRepositoryObject :
/*------------------------------------------------------------------------------
  Purpose: Validate a request to create a new or open an existing repository 
           object. Check whether object is either an Smart DataObject, A Smart DataViewer,
           or a Smart DataBrowser.  Handles both static and dynamic objects.      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lIsValidClass AS LOGICAL NO-UNDO.

 IF AVAIL _RyObject THEN
 DO:
   ASSIGN glDynObject = (NOT _RyObject.static_object).
   IF glDynObject THEN
   DO:
     ASSIGN gcDynTempFile = _Ryobject.design_template_file.

     /* If we can't determine the template file or the property sheet procedure, we can't open the 
        object, unless it is a Dynamic Viewer */
     ASSIGN gcDynClass    = DYNAMIC-FUNCTION("RepositoryDynamicClass" IN _h_func_lib, INPUT _RyObject.object_type_code)
            gcDynExtClass = _RyObject.object_type_code.


     /* Check that the class of the dynamic object is a child of either a DynView, DynBrow or DynSDO class.
        These are the only supported dynamic objects in the appBuilder */
     lIsValidClass = DYNAMIC-FUNCTION("isDynamicClassNative":U IN _h_func_lib, gcDynExtClass).
     IF NOT lIsValidClass OR SEARCH(_Ryobject.design_template_file) = ? THEN 
     DO:    
     
       /* Reset the cursor for user input.*/
       RUN adecomm/_setcurs.p ("").
       IF NOT lIsValidClass THEN
          MESSAGE "Cannot open or create the dynamic object" 
                   + (IF _RyObject.object_filename > "" THEN " '" + _RyObject.object_filename + "'." ELSE "."  )  + CHR(10) + CHR(10)
                   + "The object is specified as a dynamic object, but the object type is '" + gcDynExtClass + "'." + CHR(10) 
                   + "The only supported dynamic objects are 'DynView, DynBrow, DynSDO, or their extensions." + CHR(10) 
                   + "Check in the Repository Maintenance tool whether the object is defined as a static or dynamic object."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       ELSE IF _Ryobject.design_template_file = "" THEN
          MESSAGE "Cannot open or create the dynamic object" 
                   + (IF _RyObject.object_filename > "" THEN " '" + _RyObject.object_filename + "'." ELSE "."  )  + CHR(10) + CHR(10)
                   + "The dynamic object's template file or property sheet procedure could not be found." + CHR(10)
                   + "Check that the appropriate custom object files (.cst) are loaded from either the static"  + CHR(10)
                   + ".cst files, or from the repository.  If from static .cst files, the object type must be specified" + CHR(10)
                   + "and there must be an entry for the 'NEW-TEMPLATE' property and the 'PROPERTY-SHEET' attribute." + CHR(10)
                   + "If it's loading from the repository, ensure there is an object and object instance in the appropriate 'Template'" + CHR(10)
                   + "and 'Palette' class and that the 'PaletteNewTemplate' and the TemplatePropertySheet' attributes are set."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       ELSE IF SEARCH(_Ryobject.design_template_file) = ?  THEN
         MESSAGE "Cannot open or create the dynamic object" 
                   + (IF _RyObject.object_filename > "" THEN " '" + _RyObject.object_filename + "'." ELSE "."  )  + CHR(10) + CHR(10)
                   + "The dynamic object's template file '" + _Ryobject.design_template_file + "' could not be found." + CHR(10) 
                   + "If the system is loading a static custom .cst file, ensure that the entry for the 'NEW-TEMPLATE'" + CHR(10) 
                   + "property and the 'PROPERTY-SHEET' attribute can be found in the PROPATH."
                   + "If its loading the .cst from the repository, ensure that the 'PaletteNewTemplate' and the TemplatePropertySheet'" + CHR(10)
                   + "attributes are set and can be found in the PROPATH."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

       ASSIGN AbortImport = Yes.
       RUN dynsucker_cleanup. /* Close everything qssucker does */
       RETURN "_ABORT":U.
     END. /* Can't find template or prop sheet. */
   END.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-findAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findAttributeValue Procedure 
FUNCTION findAttributeValue RETURNS CHARACTER
  ( pcAttribute AS CHAR,
    pcLevel AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Finds the attribute value from the current ttObjectAttribute and
            ttclassAttribute buffer.
   Parems:  pcAttribute  Name of attribute to find
            pclevel      MASTER   attribute in master  (Usees ttObject)
                         INSTANCE attribute in instance(Uses b_ttObject)
    Notes:  Called from procedure processInstances 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

  ASSIGN cValue = ?.
  IF pclevel = "MASTER":U THEN
  DO:
      FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                     AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                     AND ttObjectAttribute.tAttributeLabel    = pcAttribute NO-ERROR.
      IF AVAIL ttObjectAttribute THEN
            ASSIGN cValue = ttObjectAttribute.tAttributeValue.
      ELSE DO:
            FIND FIRST ttClassAttribute WHERE ttClassAttribute.tClassName      = ttObject.tClassName
                                          AND ttClassAttribute.tAttributeLabel = pcAttribute NO-ERROR.
            IF AVAIL ttClassAttribute THEN
               ASSIGN cValue = ttClassAttribute.tAttributeValue.
      END.
  END.
  ELSE DO:  /* For Instance */
    FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                                   AND ttObjectAttribute.tObjectInstanceObj = b_ttObject.tObjectInstanceObj 
                                   AND ttObjectAttribute.tAttributeLabel    = pcAttribute NO-ERROR.
    IF AVAIL ttObjectAttribute THEN
       ASSIGN cValue = ttObjectAttribute.tAttributeValue.
    ELSE DO: /* Find the attribute for the instance's master object */
       FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                                      AND ttObjectAttribute.tObjectInstanceObj = 0 
                                      AND ttObjectAttribute.tAttributeLabel    = pcAttribute NO-ERROR.
       IF AVAIL ttObjectAttribute THEN
          ASSIGN cValue = ttObjectAttribute.tAttributeValue.
       ELSE DO:  /* Find the attribute from the class */
         FIND FIRST ttClassAttribute WHERE ttClassAttribute.tClassName      = b_ttObject.tClassName
                                       AND ttClassAttribute.tAttributeLabel = pcAttribute NO-ERROR.
         IF AVAIL ttClassAttribute THEN
           ASSIGN cValue = ttClassAttribute.tAttributeValue.
       END.
    END.   
  END.
  RETURN cValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttributeValue Procedure 
FUNCTION setAttributeValue RETURNS LOGICAL
 ( pcAttribute AS CHAR,
    pcLevel AS CHAR ,
    pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:   Sets specific attributes to the temp table fields
   Params:   pcAttribute   Name of attribute to set
             pcLevel       "OBJECT" Attribute is retrieved from object
                           "CLASS"  Attribute is retrieved from class
             pcValue      Value of attribute
    Notes:  Called from assignInstanceCase
------------------------------------------------------------------------------*/
  DEFINE BUFFER B_ttObjectAttribute FOR ttObjectAttribute.
  DEFINE VARIABLE cColumnTable AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE cColumnName  AS CHARACTER  NO-UNDO.
  
  /* Set column name variable to use in column calls in the data source.  If the data 
     source is a DataView (DbAware is false) then the column names must be qualified.  
     f_U._TABLE cannot be used to qualify the column name because it may not be set before
     the processing of the attributes that need it since they are set in alphbetical order.
     f_U._OBJECT-NAME was set from the logical object name for the instance which is
     the correct qualified column name. */
  IF VALID-HANDLE(ghSDO) THEN
    cColumnName = IF {fn getDbAware ghSDO} THEN f_U._NAME
                  ELSE f_U._OBJECT-NAME.

  CASE pcAttribute:
    WHEN "DataBaseName" THEN
    DO:
       ASSIGN f_U._DBNAME  = pcValue.
       
       IF LOOKUP("DataField":U,gcInheritClasses) > 0 THEN
             ASSIGN f_U._DBNAME = "Temp-Tables":U
                    f_U._TABLE = IF glSBODataSource THEN gcSDOName ELSE "RowObject":U.
    END.
    WHEN "TableName":U THEN
    DO:
      ASSIGN f_U._BUFFER          = pcvalue
             f_U._TABLE           = pcValue.
      IF LOOKUP("DataField":U,gcInheritClasses) > 0 
      AND VALID-HANDLE(ghSDO) THEN   
      DO:
         IF {fn getDbAware ghSDO} THEN
         DO:
           IF glSBODataSource THEN  /* Viewer was built against an SBO */
              ASSIGN f_U._TABLE = gcSDOName.
           ELSE     
              ASSIGN cColumnTable = DYNAMIC-FUNCTION("columnPhysicalTable":U IN ghSDO, f_U._NAME)
                     f_U._TABLE  = IF NUM-ENTRIES(cColumnTable, ".":U) = 2 
                                   THEN  ENTRY(2, cColumnTable, ".":U) ELSE cColumnTable
                     f_U._BUFFER = "RowObject":U.
         END.
      END.                      
    END.
    WHEN "VisualizationType":U THEN
    DO:
      IF pcLevel = "Object":U THEN
      DO:
        f_U._ALIGN = IF LOOKUP(f_U._TYPE,"RADIO-SET,IMAGE,SELECTION-LIST,EDITOR":U) > 0
                     THEN "L":U ELSE "C":U.
        IF f_U._TYPE = "TEXT":U AND 
               (LOOKUP("DataField":U,gcInheritClasses) > 0 OR
               LOOKUP("DynFillin":U,gcInheritClasses) > 0 ) THEN 
        DO: 
          ASSIGN f_U._TYPE    = "FILL-IN":U
                 f_U._SUBTYPE = "TEXT":U.
          IF LOOKUP("DataField":U,gcInheritClasses) > 0 THEN
            f_F._DATA-TYPE = IF VALID-HANDLE(ghSDO) 
                             THEN  DYNAMIC-FUNCTION("ColumnDataType":U IN ghSDO, cColumnName)
                             ELSE "Character":U.
        END.  /* If a view-as fill-in */
       END.
    END. /* Visualization Type */
    WHEN "FORMAT":U THEN
    DO:
      IF pclevel = "CLASS":U AND  LOOKUP("DataField":U,gcInheritClasses) > 0 
                             AND VALID-HANDLE(ghSDO) THEN
         ASSIGN f_F._FORMAT = DYNAMIC-FUNCTION("columnFormat":U IN ghSDO, cColumnName).
      ELSE 
         ASSIGN f_F._FORMAT  = pcValue.
    
    END.
    WHEN "LABEL":U THEN
    DO:    
      IF pclevel = "CLASS":U AND LOOKUP("DataField":U,gcInheritClasses) > 0 
                             AND VALID-HANDLE(ghSDO) THEN
         ASSIGN f_U._LABEL = DYNAMIC-FUNCTION("columnLabel":U IN ghSDO, cColumnName).
      ELSE 
         ASSIGN f_U._LABEL = pcValue. 
      
      IF f_U._LABEL = ? OR f_U._LABEL = "":U THEN
      DO:
        FIND b_ttObjectAttribute WHERE b_ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                                   AND b_ttObjectAttribute.tObjectInstanceObj = b_ttObject.tObjectInstanceObj
                                   AND b_ttObjectAttribute.tAttributeLabel    = "NAME":U NO-ERROR.
        IF AVAIL b_ttObjectAttribute THEN
          f_U._LABEL = b_ttObjectAttribute.tAttributeValue.
        ELSE DO:
           FIND b_ttObjectAttribute WHERE b_ttObjectAttribute.tSmartObjectObj    = b_ttObject.tSmartObjectObj
                                      AND b_ttObjectAttribute.tObjectInstanceObj = 0
                                      AND b_ttObjectAttribute.tAttributeLabel    = "NAME":U NO-ERROR.
           IF AVAIL b_ttObjectAttribute THEN
              f_U._LABEL = b_ttObjectAttribute.tAttributeValue.
        END.
      END.
                        
      ASSIGN f_L._LABEL = f_U._LABEL.   /* Set Master Layout _L label same as _U _label */  
    END.
    WHEN "HELP":U THEN
    DO:
      IF pclevel = "CLASS":U AND LOOKUP("DataField":U,gcInheritClasses) > 0 
                             AND VALID-HANDLE(ghSDO) THEN
         ASSIGN f_U._HELP = DYNAMIC-FUNCTION("columnHelp":U IN ghSDO, cColumnName).
      ELSE 
         ASSIGN f_U._HELP = pcValue.

    END.
    
  END CASE.
  RETURN TRUE.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRadioButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRadioButtons Procedure 
FUNCTION setRadioButtons RETURNS CHARACTER
  ( pcValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Quotes the radio-buttons accordingly based on the data type, since 
            the repository does not store the quotes, but they are required for 
            appBuilder internal fields
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iLoop  AS INTEGER     NO-UNDO.
 DEFINE VARIABLE cEntry AS CHARACTER   NO-UNDO.
 
 IF AVAIL f_U AND AVAIL f_F THEN
 DO:
   DO iLoop = 1 TO NUM-ENTRIES(pcValue, f_F._DELIMITER):
      cEntry = ENTRY(iLoop,pcValue, f_F._DELIMITER).
       /* Add string quotes for all odd entries, and for all even entires that are character data types */
      IF iLoop MODULO 2 NE 0 OR f_F._DATA-TYPE = "CHARACTER":U THEN
         ENTRY(iLoop,pcValue, f_F._DELIMITER) = '"' + ENTRY(iLoop,pcValue, f_F._DELIMITER) + '"'.
   END.
 END.
 
 RETURN pcValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFSetting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDFSetting Procedure 
FUNCTION setSDFSetting RETURNS LOGICAL
  ( pcAttribute AS CHAR,
    pcValue     AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns the variable gcSettingsList for attributes that
            apply to SmartDataFields. This variable is later used to populate the
            _S._SETTINGS field. 
    Notes:  Called from Assign instanceCase
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cEntry      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttribute  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lFound      AS LOGICAL    NO-UNDO.

IF pcValue = ? THEN
  RETURN FALSE.
  
Settings-Loop:
DO iLoop = 1 TO NUM-ENTRIES(gcSettingsList, CHR(3)):
  ASSIGN cEntry = ENTRY(iLoop,gcSettingsList, CHR(3))
         cAttribute = trim(ENTRY(1,cEntry,CHR(4)))
         cValue     = trim(ENTRY(2,cEntry,CHR(4)))
         NO-ERROR.
  IF cAttribute = trim(pcAttribute) THEN 
  DO:
     ASSIGN ENTRY(2,cEntry,CHR(4))            = pcValue
            ENTRY(iLoop,gcSettingsList,CHR(3)) = cEntry.
     lFound = true.       
     LEAVE Settings-Loop.
   END. /* End found attribute */
END. /* End loop through _SETTINGS */

RETURN lFound.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowAlreadyOpened) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION windowAlreadyOpened Procedure 
FUNCTION windowAlreadyOpened RETURNS LOGICAL
  (OUTPUT pcReturnValue AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: If the user is trying to open a window that is already open then
           tell caller. The caller should then make that window the active one.
           Do not open the window twice. The UIB can open the same window twice.
           However, the windows are disjoint and cause usability problems since
           the windows are not in synch.
           
           This situation handles reopening a file via "Edit Master...".
           
           We don't need to do this if import_mode is "WINDOW UNTITLED".
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE BUFFER x_P FOR _P.
   
   DEFINE VARIABLE h AS HANDLE  NO-UNDO.

   IF import_mode eq "WINDOW":U THEN 
   DO:
    /* Search the universal records for a window with the same file name and,
       if on a remote WebSpeed file, the same broker URL. */
    FIND x_P WHERE x_P._SAVE-AS-FILE EQ dot-w-file NO-ERROR.
    IF AVAILABLE x_P THEN DO:
      h = x_P._WINDOW-HANDLE.
      /* Get the real window for a dialog-box _U */
      IF h:TYPE ne "WINDOW":U THEN h = h:PARENT.
      IF h:TYPE EQ "WINDOW":U THEN 
      DO:
          h:MOVE-TO-TOP().
          IF h:WINDOW-STATE = WINDOW-MINIMIZED THEN      
                        ASSIGN h:WINDOW-STATE = WINDOW-NORMAL.
      END.

      RUN adecomm/_setcurs.p ("").
      /* Tell caller file already exists using "reopen" message. */
      pcReturnvalue = "_REOPEN,":U + STRING(h).
      RETURN TRUE.
    END.
  END.  /* If import mode is "WINDOW" */

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

