&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: _chsPM.p

  Description:  adeuib/_chsPM.p

  Purpose:      Runs 'Save As Dynamic Object' dialog and saves file to repository.
                Called directly by AB in choose_file_save_as_dynamic in uibmproa.i.
                
                This program utilizes shared AppBuilder temp-tables and 
                variables, callers other than AppBuilder must define those 
                shared elements as NEW to avoid data conflicts with the AppBuilder.

  Parameters:   INPUT  phWindow        AS HANDLE
                INPUT  pPrecid         AS RECID
                INPUT  pcProductModule AS CHARACTER
                INPUT  pcFileName      AS CHARACTER
                INPUT  pcType          AS CHARACTER
                OUTPUT pressedOK       AS LOGICAL

  History:
  --------
  (v:010000)  
                Date:   03/08/2002  Author:     Ross Hunter

  Update Notes: Created from Template adeuib/_reposaddfl.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _chspm.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{destdefi.i}             /* Definitions for dynamics design-time temp-tables. */

DEFINE INPUT  PARAMETER phWindow        AS HANDLE       NO-UNDO.
DEFINE INPUT  PARAMETER pPrecid         AS RECID        NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModule AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcFileName      AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcType          AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL      NO-UNDO.

/*  Need to use AppBuilder temp-tables and shared variables. They are defined 
    shared here so the caller can define the data values as new and this routine 
    pickes up the correct shared versions - when the caller is AppBuilder or 
    external caller. */
{adeuib/sharvars.i}.
{adeuib/uniwidg.i}.
{adecomm/oeideservice.i}
DEFINE VARIABLE gcFilename     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSavedPath    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcError        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE grRyObject     AS RECID      NO-UNDO.
DEFINE VARIABLE cRootDirectory AS CHARACTER  NO-UNDO.

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
   Compile into: 
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
         HEIGHT             = 8.1
         WIDTH              = 48.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    /* Call the Add to Repository dialog. Passes data back in an _RyObject record. */
    if OEIDEisRunning then
    RUN adeuib/ide/_dialog_saveasdynobject.p
        (INPUT phWindow,                /* Parent Window    */
         INPUT pcProductModule,         /* Product Module   */
         INPUT pcFileName,              /* Object to add    */
         INPUT pcType,                  /* File type        */
         INPUT pPrecid,                  /* _P recID */
         OUTPUT grRyObject,             /* RyObject created */
         OUTPUT pressedOK). 
    else
    RUN adeuib/_saveasdynobject.w
        (INPUT phWindow,                /* Parent Window    */
         INPUT pcProductModule,         /* Product Module   */
         INPUT pcFileName,              /* Object to add    */
         INPUT pcType,                  /* File type        */
         INPUT pPrecid,                  /* _P recID */
         OUTPUT grRyObject,             /* RyObject created */
         OUTPUT pressedOK).

    IF pressedOK THEN
    DO:
        /* We need the base filename only to find the _RyObject record. */

        FIND _RyObject WHERE RECID(_RyObject) = grRyObject NO-ERROR.
        IF NOT AVAILABLE _RyObject THEN LEAVE.
/****************************************************************
        MESSAGE "Saving object..." SKIP(1)
                "File:  " pcFileName                      SKIP
                "Name:  " _RyObject.object_filename       SKIP
                "PMCode:" _RyObject.product_module_code   SKIP
                "OType: " _RyObject.object_type_code      SKIP
                "Path:  " _RyObject.object_path           SKIP
                "Desc:  " _RyObject.object_description    SKIP
                "Action:" _RyObject.design_action         SKIP
                "RyObj?:" _RyObject.design_ryobject       SKIP.
****************************************************************/

        /* If _P is available, the Add came from the AppBuilder. Otherwise, it
           came from Procedure Editor or a Procedure Window or some other call. */
        FIND _P WHERE RECID(_P) = pPrecid NO-ERROR.
        FIND _U WHERE RECID(_U) = _P._u-recid NO-ERROR.
        FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
        IF AVAILABLE _P THEN
          RUN save_ab_file_to_repos.
        ELSE
          RUN save_file_to_repos.
        
        IF (gcError <> "" AND NOT gcError BEGINS "Associated data":U) THEN
        DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
          IF gcError NE "Shown":U THEN
          DO:
             
 
         /* Skip message if hosted in Eclipse
            - This is not really needed. if needed implement with "not show again" in Eclipse   
             note that there may also be lock issues due to save waiting when calling eclipse
            (progress waiting for eclipse waiting for progress) due to save/saveas                  
             from here */ 
                if NOT OEIDE_CanShowMessage() then                                       
/*                ShowOkMessageInIDE("Object not added to repository.","Error",?).*/
/*            else                                                                */
                    MESSAGE "Object not added to repository." SKIP(1)
                       gcError
                    VIEW-AS ALERT-BOX.
          END.   
        END.
        ELSE IF (gcError = "") THEN
        DO:
        /* Skip message if hosted in Eclipse
            - This is not really needed. if needed implement with "not show again" in Eclipse   
             note that there may also be lock issues due to save waiting when calling eclipse
            (progress waiting for eclipse waiting for progress) due to save/saveas                  
             from here */ 
               if NOT OEIDE_CanShowMessage() then                                       
/*                ShowOkMessageInIDE("Object not added to repository.","Error",?).*/
/*            else                                                                */
                    MESSAGE "Object was added to repository."
                    VIEW-AS ALERT-BOX INFORMATION.
        END.
    END. /* pressedOK */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-save_ab_file_to_repos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save_ab_file_to_repos Procedure 
PROCEDURE save_ab_file_to_repos :
/*------------------------------------------------------------------------------
  Purpose:     Saves an AppBuilder file as a dynamic repository object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h_title_win   AS WIDGET    NO-UNDO.
DEFINE VARIABLE OldTitle      AS CHARACTER NO-UNDO.
DEFINE VARIABLE phDataObject  AS HANDLE    NO-UNDO.
DEFINE VARIABLE cTableName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInheritClasses AS CHARACTER NO-UNDO.
DEFINE VARIABLE ghDesignManager AS HANDLE    NO-UNDO.
define variable cStaticObjectName as character no-undo.
define variable hAttributeBuffer as handle no-undo.
define variable hDummy           as handle    no-undo.
define variable cDummy           as character no-undo.
define variable lDummy           as logical no-undo.

AB-BLOCK:
DO TRANSACTION ON ERROR UNDO, LEAVE:
    RUN adecomm/_setcurs.p ("WAIT":U).
    
    /* Get the name of the static object that we're converting to dynamic.
       
       We use this name to find the properties that are stored against the 
       static master object, and that need to be created against the new dynamic
       object. Some properties are transferred, because they exist as fields in
       the _P (or other _* temp-tables), but there are a large number of properties 
       that are not managed this way (they are handled by the DPS) and these need
       to be created against the new (dynamic) object.       
     */
    /* _P is found in the main block */
    cStaticObjectName = _P.object_filename.
    
    /* Get the info we need to complete the add and save the window
       as a static repository object. */
    BUFFER-COPY _RyObject TO _P.
    
    _ryObject.design_precid = RECID(_P).
    /* Determine whether the object is based on a SBO data source. If yes, set the 
       object-name and class-name so that the object is saved without error.       */
    phDataObject = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, 
                                INPUT _P._DATA-OBJECT,
                                INPUT TARGET-PROCEDURE).
    IF VALID-HANDLE(phDataObject) AND
       DYNAMIC-FUNCTION("getObjectType":U IN phDataObject) = "SmartBusinessObject":U THEN 
    DO:
      FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                    AND _U._BUFFER        > "":

          ASSIGN cTableName      = DYNAMIC-FUNCTION("columnTable":U IN phDataObject, _U._BUFFER + "." + ENTRY(1,_U._NAME,"."))
                 _U._CLASS-NAME  = "DataField":U
                 _U._Object-NAME = cTableName + "." +  _U._NAME.
        
      END.
    END.
    DYNAMIC-FUNC("shutdown-sdo" IN _h_func_lib,INPUT TARGET-PROCEDURE).

 /* When saving a static as dynamic SDO, ensure partition is set as class default */
    IF _P._TYPE = "SmartDataObject":U and _P._Db-Aware AND _P._PARTITION = "" THEN
    DO:
        ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, "RepositoryDesignManager":U) NO-ERROR.
        RUN retrieveDesignClass IN ghDesignManager
                   ( INPUT  "Data":U,
                     OUTPUT cInheritClasses,
                     OUTPUT TABLE ttClassAttribute ,
                     OUTPUT TABLE ttUiEvent,
                     OUTPUT TABLE ttSupportedLink    ) NO-ERROR.  
       FIND FIRST ttClassAttribute WHERE  ttClassAttribute.tAttributeLabel = "AppService" NO-ERROR.
       IF AVAIL ttClassAttribute then
          _P._PARTITION = ttClassAttribute.tAttributeValue.       
    END.
    
    /* save_window_static is a misnomer.  It now does both dynamic and static */
    RUN save_window_static  IN _h_uib (INPUT RECID(_P), OUTPUT gcError).

    /* Don't need this anymore. It's passed back the info we needed. */
    DELETE _RyObject.
    
    /* save_window_static has displayed the error message, indicate that it has 
       been shown */
    IF gcError NE "" AND NOT gcError BEGINS "Associated data":U THEN 
    DO:
      gcError = "Shown":U.
      UNDO AB-BLOCK, LEAVE AB-BLOCK.
    END.
        
    IF gcError = "" OR gcError BEGINS "Associated data":U THEN
    DO:
        /* We now have a brand-new dynamic object. Get the properties off
           the static object and set in the dynamic object.
         */
        hAttributeBuffer = dynamic-function('copyReposProps':u in _h_menubar_proc, cStaticObjectName, recid(_P)).
        if valid-handle(hAttributeBuffer) then
        do:
            hDummy = ?.
            run storeAttributeValues in gshRepositoryManager (input hAttributeBuffer, input table-handle hDummy) no-error.
            if return-value ne '' or error-status:error then
            do:
                /* Let's format the error message before doing anything with it. */
                run afmessagep in gshSessionManager (input  return-value,
                                                     input  '':u,     /* pcButtonList */
                                                     input  '':u,     /* pcMessageTitle */
                                                     output cDummy,   /* cSummaryMessages */
                                                     output gcError,  /* cFullMessages */
                                                     output cDummy,   /* cButtonList */
                                                     output cDummy,   /* cMessageTitle */
                                                     output lDummy,   /* lUpdateErrorLog */
                                                     output lDummy ). /* lSuppressDisplay */
                
                undo AB-BLOCK, leave AB-BLOCK.
            end.    /* error storing attributes */
        end.    /* valid attribute buffer */
      
      ASSIGN
          h_title_win        = _P._WINDOW-HANDLE:WINDOW
          OldTitle           = h_title_win:TITLE
          h_title_win:TITLE  = _P._type + "(" 
                                   + _P.OBJECT_type_code + ") - " 
                                   + _P.OBJECT_filename
         _P._Save-as-file    = _P.OBJECT_filename.
      
      /* RUN adeuib/_wintitl.p (h_title_win, _U._LABEL, _U._LABEL-ATTR, 
                                 _P._SAVE-AS-FILE).  */                                 

     /* Change the active window title on the Window menu. */
      IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
        RUN WinMenuChangeName IN _h_WinMenuMgr
         (_h_WindowMenu, OldTitle, h_title_win:TITLE). 
      /* Notify the Section Editor of the window title change. Data after 
        "SE_PROPS" added for 19990910-003. */
      RUN call_sew IN _h_UIB ( "SE_PROPS":U ). 

      /* Update most recently used filelist */    
      IF  _mru_filelist THEN 
        RUN adeshar/_mrulist.p (_P._Save-as-file, IF _remote_file THEN _BrokerURL ELSE "").

      /* IZ 776 Redisplay current filename in AB Main window. */
      RUN display_current IN _h_uib.
    END.

END.
RUN adecomm/_setcurs.p ("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-save_file_to_repos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save_file_to_repos Procedure 
PROCEDURE save_file_to_repos :
/*------------------------------------------------------------------------------
  Purpose:     Saves a file as a static repository object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAssociatedDataObject AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dDlObj                AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hAttributeBuffer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAttributeTable       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRepDesignManager     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cObjectFileName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcRelativePath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcRootDir          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcRelPathSCM       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFullPath         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcObject           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFile             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcError            AS CHARACTER  NO-UNDO.


ASSIGN hAttributeBuffer = ?
       hAttributeTable  = ?.

DO ON ERROR UNDO, LEAVE:
    RUN adecomm/_setcurs.p ("WAIT":U).
    
    /* Prompt for Product Module if for some reason we don't have it. */
    IF (_RyObject.product_module_code = "":u) THEN DO:
      MESSAGE "No product module has been specified."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
    END.

    cAssociatedDataObject = "".
    hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) 
                        NO-ERROR.
    IF VALID-HANDLE(hRepDesignManager) AND _P._data-object NE "":U THEN DO:
      IF DYNAMIC-FUNCTION("ObjectExists":U IN hRepDesignManager, INPUT _P._data-object) THEN
        cAssociatedDataObject = _P._data-object.
    END.
    
   /* Check physical file is stored in same relative directory as module */ 
   RUN calculateObjectPaths IN gshRepositoryManager
                   ("",  /* ObjectName */          0.0, /* Object Obj */      
                    "",  /* Object Type */         _RyObject.product_module_code,  /* Product Module Code */
                    "", /* Param */                "",
                    OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                    OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                    OUTPUT cCalcObject,            OUTPUT cCalcFile,
                    OUTPUT cCalcError).
   
    IF cCalcError > "" THEN
    DO:
      MESSAGE cCalcError VIEW-AS ALERT-BOX.
      RETURN.
    END.
    
    IF cCalcRelPathSCM > "" THEN
       cCalcRelativePath = cCalcRelPathSCM.
    ASSIGN cObjectFileName = REPLACE(pcFileName, "~\", "/")
           cObjectFileName = TRIM(ENTRY(NUM-ENTRIES(cObjectFileName, "/":U), cObjectFileName, "/")).
    IF R-INDEX(cObjectFileName,".") > 0 
       AND SEARCH(cCalcRelativePath 
                  + (IF cCalcRelativePath > "" THEN "~/":U ELSE "") 
                  + cObjectFileName ) = ? THEN 
    DO:
       MESSAGE cObjectFileName +  " is not located in the '" 
                      + IF cCalcRelativePath > "" AND cCalcRelativePath <> "."
                        THEN cCalcRelativePath
                        ELSE "default"
                      + "' directory." + CHR(10) + 
                      "The file must be located in the same directory as the product module's relative path.":U.
      
    END.                  
    ELSE DO:
      /* Call Dynamics procedure to save static object to repository. You'll see
         a similar call in save_window_static  IN _h_uib. */
      RUN insertObjectMaster IN hRepDesignManager 
          ( INPUT  pcFileName,                     /* pcObjectName         */
            INPUT  "":U,                           /* pcResultCode         */
            INPUT  _RyObject.product_module_code,  /* pcProductModuleCode  */
            INPUT  _RyObject.OBJECT_type_code,     /* pcObjectTypeCode     */
            INPUT  "":U,                           /* pcObjectDescription  */
            INPUT  _RyObject.object_path,          /* pcObjectPath         */
            INPUT  cAssociatedDataObject,          /* pcSdoObjectName      */
            INPUT  "":U,                           /* pcSuperProcedureName */
            INPUT  NO,                              /* plIsTemplate         */
            INPUT  YES,                            /* plIsStatic           */
            INPUT  "":U,                           /* pcPhysicalObjectName */
            INPUT  NO,                             /* plRunPersistent      */
            INPUT  "":U,                           /* pcTooltipText        */
            INPUT  "":U,                           /* pcRequiredDBList     */
            INPUT  "":U,                           /* pcLayoutCode         */
            INPUT  hAttributeBuffer,
            INPUT  TABLE-HANDLE hAttributeTable,
            OUTPUT dDlObj                                   ) NO-ERROR.

      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
        MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR BUTTONS OK.

      IF dDlObj NE 0 AND _RyObject.deployment_type NE "" THEN DO:
        RUN updateDeploymentType IN hRepDesignManager (INPUT dDlObj, 
                                                      INPUT _RyObject.deployment_type)
                                                      NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
          MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      END.
    END.
    /* Don't need this anymore. It's passed back the info we needed. */
    DELETE _RyObject.

    RUN adecomm/_setcurs.p ("":U).
END. /* DO ON ERROR */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

