&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
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
  File: dcusitedatadump.p

  Description:  Dumps data for a specific site using programs specified in an input
                file. This is intended to be extended by customers for their own 
                use.

  Purpose:      This program is callable by the DCU and assumes that the file that
                is to be used has already been created.
                A harness (sitedatadump.w) 

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/14/2004  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       dcusitedataload.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{db/icf/dfd/ttdumpfileloc.i}
{db/icf/dfd/ttfixprogram.i}
{db/icf/dfd/ttdatafile.i}


DEFINE VARIABLE gcConfigFile          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcSiteDataDirectory   AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getProcPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProcPath Procedure 
FUNCTION getProcPath RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER) FORWARD.

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
         HEIGHT             = 19.62
         WIDTH              = 49.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
PUBLISH "DCU_WriteLog":U ("Loading site data...").
RUN initializeFixFramework.

IF NOT TEMP-TABLE ttFixProgram:HAS-RECORDS THEN
DO:
  PUBLISH "DCU_WriteLog":U ("WARNING: No import programs found.").
  RETURN.
END.

RUN loadSiteData. 
PUBLISH "DCU_WriteLog":U ("Site data load complete.").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-initializeFixFramework) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeFixFramework Procedure 
PROCEDURE initializeFixFramework :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSearchFile AS CHARACTER   NO-UNDO.

  /* Get the site data directory */
  ASSIGN
    FILE-INFO:FILE-NAME = "sitedatadump/.":U
    gcSiteDataDirectory = REPLACE(FILE-INFO:FULL-PATHNAME,"~\":U,"/":U)
  .
  IF gcSiteDataDirectory = ? THEN
  DO:
    PUBLISH "DCU_WriteLog":U ("WARNING: Site data directory not found in PROPATH.").
    RETURN.
  END.

  IF SUBSTRING(gcSiteDataDirectory, LENGTH(gcSiteDataDirectory)) <> "/":U THEN
    ASSIGN
      gcSiteDataDirectory = gcSiteDataDirectory + "/":U
    .
  PUBLISH "DCU_WriteLog":U ("Site data directory set to " + gcSiteDataDirectory).
  
  /* Find the file that contains the definition of how the fix programs 
     are run */
  cSearchFile = SEARCH("sitedatadump/dumpconfig.txt").

  IF cSearchFile = ? THEN
  DO:
    PUBLISH "DCU_WriteLog":U ("WARNING: Site data configuration file not found.").
    RETURN.
  END.

  gcConfigFile = cSearchFile.
  PUBLISH "DCU_WriteLog":U ("Reading site configuration data from " + gcConfigFile).


  RUN readConfigFile.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadSiteData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadSiteData Procedure 
PROCEDURE loadSiteData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  fix-loop:
  FOR EACH ttFixProgram:
    PUBLISH "DCU_WriteLog":U ("Dumping site data using program: " + ttFixProgram.cProgName).
  
    EMPTY TEMP-TABLE ttDumpFileLocation.
  
    FOR EACH ttDataFile 
      WHERE ttDataFile.iProgNo = ttFixProgram.iProgNo:
      FILE-INFO:FILE-NAME = ttDataFile.cDataFilePath.
      IF FILE-INFO:FULL-PATHNAME = ? THEN
      DO:
        PUBLISH "DCU_WriteLog":U ("Data file " + ttDataFile.cDataFilePath + " not found.").
        NEXT fix-loop.
      END.
  
      FIND ttDumpFileLocation
        WHERE ttDumpFileLocation.cDumpFile = ttDataFile.cDataFile
        NO-ERROR.
      IF NOT AVAILABLE(ttDumpFileLocation) THEN
      DO:
        CREATE ttDumpFileLocation.
        ASSIGN
          ttDumpFileLocation.cDumpFile      = ttDataFile.cDataFile
          ttDumpFileLocation.cDumpFilePath  = ttDataFile.cDataFilePath
        .
      END.
    END.
  
    PUBLISH "DCU_WriteLog":U ("Running import program " + ttFixProgram.cProgName).
    RUN VALUE(ttFixProgram.cFullProgPath) 
      (INPUT TABLE ttDumpFileLocation)
      NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      ERROR-STATUS:ERROR = NO.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readConfigFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readConfigFile Procedure 
PROCEDURE readConfigFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSiteNo     AS INTEGER     NO-UNDO.
  DEFINE VARIABLE dRevSite    AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE cRecType    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cString     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iNumber     AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSearchFile AS CHARACTER   NO-UNDO.

  INPUT FROM VALUE(gcConfigFile).
  REPEAT:
    IMPORT
      cRecType
      iNumber
      cString
    .
    CASE cRecType:
      WHEN "I":U THEN
      DO:
        cSearchFile = getProcPath(cString).
        IF cSearchFile <> ? THEN
        DO:
          /* Load all the programs that we need */
          FIND ttFixProgram 
            WHERE ttFixProgram.iProgNo    = iNumber
              AND ttFixProgram.cProgName  = cString
            NO-ERROR.
          IF NOT AVAILABLE(ttFixProgram) THEN
          DO:
            CREATE ttFixProgram.
            ASSIGN
              ttFixProgram.iProgNo    = iNumber
              ttFixProgram.cProgName  = cString
              ttFixProgram.cFullProgPath = cSearchFile
            .
          END.
        END.
        ELSE
        DO:
          PUBLISH "DCU_WriteLog":U ("WARNING: Import program " + cString + " not found.").
        END.
      END.
      WHEN "D":U THEN
      DO:
        /* Load all the data files that we need to clear */
        FIND ttDataFile 
          WHERE ttDataFile.iProgNo    = iNumber
            AND ttDataFile.cDataFile  = cString
          NO-ERROR.
        IF NOT AVAILABLE(ttDataFile) THEN
        DO:
          CREATE ttDataFile.
          ASSIGN
            ttDataFile.iProgNo       = iNumber
            ttDataFile.cDataFile     = cString
            ttDataFile.cDataFilePath = gcSiteDataDirectory + ttDataFile.cDataFile
          .
        END.
      END.
    END.
  END.
  INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getProcPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProcPath Procedure 
FUNCTION getProcPath RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSourceCode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRCode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootFile   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExtension  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRetVal     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRunSource  AS LOGICAL    NO-UNDO.

  iEntry = NUM-ENTRIES(pcFileName,".":U).

  IF iEntry > 1 THEN
    cExtension = ENTRY(iEntry, pcFileName, ".":U).
  cRootFile = SUBSTRING(pcFileName,1,LENGTH(pcFileName) - LENGTH(cExtension)).

  IF cExtension <> "r" THEN
  DO:
    cSourceCode = SEARCH(pcFileName).
    cRCode      = SEARCH(cRootFile + "r").
  END.
  ELSE
  DO:
    cSourceCode = ?.
    cRCode      = SEARCH(pcFileName).
  END.

  cRetVal = ?.

  IF cRCode <> ? THEN 
    cRetVal = cRCode.

  IF cSourceCode <> ? AND
     cRetVal = ? THEN
      cRetVal = cSourceCode.

  RETURN cRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

