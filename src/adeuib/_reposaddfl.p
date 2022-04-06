&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: _reposaddfl.p

  Description:  adeuib/_reposaddfl.p

  Purpose:      Runs 'Add to Repository' dialog and adds file to repository.
                Called directly by AB and called through API procedure
                adeuib/_reposaddfile.p for external file adds.
                
                This program utilizes shared AppBuilder temp-tables and 
                variables, callers other than AppBuilder (like _reposaddfile.p) 
                must define those shared elements as NEW to avoid data 
                conflicts with the AppBuilder.
                
                Part of IZ 2513 Error when trying to save structured include

  Parameters:   INPUT  phWindow        AS HANDLE
                INPUT  pPrecid         AS RECID
                INPUT  pcProductModule AS CHARACTER
                INPUT  pcFileName      AS CHARACTER
                INPUT  pcType          AS CHARACTER
                OUTPUT pressedOK       AS LOGICAL

  History:
  --------
  (v:010000)    Task:           0   UserRef:    IZ 2513
                Date:   11/18/2001  Author:     John Palazzo

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _reposaddfl.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

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
DEFINE VARIABLE gcFilename    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSavedPath   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcError       AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 8.1
         WIDTH              = 48.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    /* Call the Add to Repository dialog. Passes data back in an _RyObject record. */
    IF OEIDEIsRunning then 
    RUN adeuib/ide/_dialog_addreposfile.p 
        (INPUT phWindow,                /* Parent Window    */
         INPUT pcProductModule,         /* Product Module   */
         INPUT pcFileName,              /* Object to add    */
         INPUT pcType,                  /* File type        */
         OUTPUT pressedOK).
    else     
    RUN adeuib/_addreposfile.w 
        (INPUT phWindow,                /* Parent Window    */
         INPUT pcProductModule,         /* Product Module   */
         INPUT pcFileName,              /* Object to add    */
         INPUT pcType,                  /* File type        */
         OUTPUT pressedOK).

    IF pressedOK THEN
    DO:
        /* We need the base filename only to find the _RyObject record. */
        RUN adecomm/_osprefx.p (INPUT pcFileName, OUTPUT gcSavedPath, OUTPUT gcFilename).
        FIND _RyObject WHERE _RyObject.object_filename = gcFilename NO-ERROR.
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
        
        IF AVAILABLE _P THEN
          RUN save_ab_file_to_repos.
        ELSE
          RUN save_file_to_repos.
        /* This is redundant 
        IF (gcError <> "") THEN
        DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
            MESSAGE "Object not added to repository." SKIP(1)
                    gcError
              VIEW-AS ALERT-BOX.
        END. */
        IF (gcError = "") THEN
        DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
            if OEIDEIsRunning then
             run ShowOkMessage in hOEIDEService("Object was registered in the repository.",
                             "Information","?").
            else
            MESSAGE "Object was registered in the repository."
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
  Purpose:     Saves an AppBuilder file as a static repository object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO ON ERROR UNDO, LEAVE:
    RUN adecomm/_setcurs.p ("WAIT":U).
    
    /* Get the info we need to complete the add and save the window
       as a static repository object. */
    BUFFER-COPY _RyObject TO _P.
    RUN save_window_static  IN _h_uib (INPUT RECID(_P), OUTPUT gcError).
    
    /* Don't need this anymore. It's passed back the info we needed. */
    DELETE _RyObject.

    RUN adecomm/_setcurs.p ("":U).
END.

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
      if OEIDEIsRunning then
             run ShowOkMessage in hOEIDEService("No product module has been specified.",
                             "Error","?").
      else                         
      MESSAGE "No product module has been specified."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
    END.

    hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
        
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
      if OEIDEIsRunning then
             run ShowOkMessage in hOEIDEService(cCalcError,
                             "Error","?").
      else                         
      MESSAGE cCalcError VIEW-AS ALERT-BOX.
      DELETE _RYObject.
      RETURN.
    END.
    
    IF cCalcRelPathSCM > "" THEN
       cCalcRelativePath = cCalcRelPathSCM.    

    /* Call Dynamics procedure to save static object to repository. You'll see
       a similar call in save_window_static  IN _h_uib. */
    ASSIGN cObjectFileName = REPLACE(pcFileName, "~\", "/")
           cObjectFileName = TRIM(ENTRY(NUM-ENTRIES(cObjectFileName, "/":U), cObjectFileName, "/")).
    IF R-INDEX(cObjectFileName,".") > 0 
       AND SEARCH(cCalcRelativePath 
                  + (IF cCalcRelativePath > "" THEN "~/":U ELSE "") 
                  + cObjectFileName ) = ? THEN 
    DO:
       if OEIDEIsRunning then
             run ShowOkMessage in hOEIDEService(cObjectFileName +  " is not located in the '" 
                              + IF cCalcRelativePath > "" AND cCalcRelativePath <> "."
                                THEN cCalcRelativePath
                                ELSE "default"
                              + "' directory." + CHR(10) + 
                                "The file must be located in the same directory as the product module's relative path.":U,
                                "Error","?").
       else  
       MESSAGE cObjectFileName +  " is not located in the '" 
                      + IF cCalcRelativePath > "" AND cCalcRelativePath <> "."
                        THEN cCalcRelativePath
                        ELSE "default"
                      + "' directory." + CHR(10) + 
                      "The file must be located in the same directory as the product module's relative path.":U.

    END.                  
    ELSE DO:
        RUN insertObjectMaster IN hRepDesignManager 
            ( INPUT  pcFileName,                     /* pcObjectName         */
              INPUT  "":U,                           /* pcResultCode         */
              INPUT  _RyObject.product_module_code,  /* pcProductModuleCode  */
              INPUT  _RyObject.OBJECT_type_code,     /* pcObjectTypeCode     */
              INPUT  "":U,                           /* pcObjectDescription  */
              INPUT  _RyObject.object_path,          /* pcObjectPath         */
              INPUT  "",                             /* pcSdoObjectName      */
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


        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
        do:
          if OEIDEIsRunning then
             run ShowOkMessage in hOEIDEService(RETURN-VALUE,
                             "Error","?").
          else   
          MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        end.
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

