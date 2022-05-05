&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME ZipFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ZipFrame 
/*********************************************************************
* Copyright (C) 2000,2012-2013 by Progress Software Corporation ("PSC"),  *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The contents of this file are subject to the Possenet End User     *
* Software License Agreement Version 1.0 (the "License"); you may not*
* use this file except in compliance with the License. You may obtain*
* a copy of the License at http://www.possenet.org/license.html      *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: adetran/common/_zipmgr.w

  Description: Manages zipping and unzipping operations for TranMan2
  
  Input Parameters:
      Mode (char)        - "ZIP" or "UNZIP" or "GETCOMMENT"
      ZipFileName (char) - name of zip file to create or operate on
      ZipDir (char)      - name of directory unzip into
	  BkupFile (char)    - name of bku file
      ItemList (char)    - space separated list of what to zip (e.g. "*.W *.P")
      ZCompFactor (int)  - Zip compression factor (1=lowest, 10=highest)
      Recursive (log)    - Should operation be recursive? (yes/no)
  Input-Output Parameters:
      ZipComment (char)  - Zipfile comment string.  
  Output Parameters:
      ZipStatus (log)    - Success or failure of zip/unzip operation

  Author: Gerry Seidl

  Created: 9/18/95
  Modified: 11/96 SLK Handle 32bit
                porting to win95 WINDOW-SYSTEM, OPSYS
                lc / caps
                in process on UNC, long filename, VBX
                OCX
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT         PARAMETER Mode        AS CHARACTER NO-UNDO.
DEFINE INPUT         PARAMETER ZipFileName AS CHARACTER NO-UNDO.
DEFINE INPUT         PARAMETER ZipDir      AS CHARACTER NO-UNDO.
DEFINE INPUT         PARAMETER BkupFile    AS CHARACTER NO-UNDO.
DEFINE INPUT         PARAMETER pItemList   AS CHARACTER NO-UNDO.
DEFINE INPUT         PARAMETER ZCompFactor AS INTEGER   NO-UNDO.
DEFINE INPUT         PARAMETER Recursive   AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT  PARAMETER ZipComment  AS CHARACTER NO-UNDO.
DEFINE OUTPUT        PARAMETER ZipStatus   AS LOGICAL   NO-UNDO INIT no.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE Type                AS INTEGER   NO-UNDO.

&IF LOOKUP("{&OPSYS}","MSDOS,WIN32":U) > 0 &THEN
    &SCOPED-DEFINE SLASH ~~~\
&ELSE
    &SCOPED-DEFINE SLASH /
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME ZipFrame

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME ZipFrame
     SPACE(66.61) SKIP(4.20)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Zip".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX ZipFrame
                                                                        */
ASSIGN 
       FRAME ZipFrame:SCROLLABLE       = FALSE
       FRAME ZipFrame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ZipFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ZipFrame ZipFrame
ON WINDOW-CLOSE OF FRAME ZipFrame /* Zip */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ZipFrame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  DEFINE VARIABLE fbasename AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fprefix AS CHARACTER NO-UNDO.

  IF mode <> "GETCOMMENT" THEN RUN enable_UI.
  IF mode = "ZIP":U THEN DO:
    /* Handle UNC and long filenames  */
    /* !!! check ZipFilename to see if filename or dir? */
        if not (zipFileName begins "/" or zipFileName begins "~\" or index(zipFileName,":") <> 0) then do:
            ASSIGN FILE-INFO:FILE-NAME = ".":U.
            ASSIGN fprefix = FILE-INFO:FULL-PATHNAME + "~\". 
            zipFileName = fprefix + zipFileName.    
        end.
        else do:     
            ASSIGN FILE-INFO:FILE-NAME = zipFileName. 
            RUN adecomm/_osprefx.p (INPUT FILE-INFO:FILE-NAME , OUTPUT fprefix, OUTPUT fbasename).
        end.

    RUN DriveType(INPUT fprefix, OUTPUT Type).
    CASE Type:
      WHEN 0 THEN DO:
        MESSAGE ZipFileName skip "The disk drive used is invalid."
          VIEW-AS ALERT-BOX ERROR.
        ASSIGN ZipStatus = no.
        RETURN.
      END.
    END CASE.
  END.
  RUN adecomm/_setcurs.p("WAIT":U).
   CASE mode:
    WHEN "ZIP":U THEN RUN Zip (INPUT  ZipFileName, 
	                         INPUT  BkupFile,
                             INPUT  pItemList,
							 INPUT  ZipDir, 
                             OUTPUT ZipStatus).
    WHEN "UNZIP":U THEN RUN Unzip (INPUT  ZipFileName,
                                 INPUT  ZipDir,
                                 OUTPUT ZipStatus).
    WHEN "GETCOMMENT":U THEN RUN Get_ZIP_Comment(INPUT  ZipFileName, 
                                               OUTPUT ZipComment,
                                               OUTPUT ZipStatus).
    OTHERWISE
    DO:
      MESSAGE "Unknown mode sent to zip manager." VIEW-AS ALERT-BOX ERROR.
      RUN adecomm/_setcurs.p("":U).
      RETURN.
    END.
  END CASE.  
  RUN adecomm/_setcurs.p("":U).
  /*WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS btnCancel.*/

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ZipFrame _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME ZipFrame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DriveType ZipFrame 
PROCEDURE DriveType :
/*
 Purpose:     Determines the drive type for a drive letter.
 Parameters:
       INPUT: DriveName 
                letter of drive followed by : (e.g. 'A:')
      OUTPUT: DriveType (int)    - type of drive where type can equal:
                                   0 - Drive type cannot be determined
                                   1 - Root dir does not exist
                                   2 - Removable DRIVE_REMOVABLE
                                   3 - Fixed Disk DRIVE_FIXED
                                   4 - Remote (Network) drive DRIVE_REMOTE
                                   5 - CD-ROM drive DRIVE-CDROM
                                   6 - RAM Disk DRIVE-RAMDISK
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER DriveName AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER DriveType   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE DriveNum            AS INTEGER   NO-UNDO.

  RUN GetDriveTypeA (INPUT DriveName, OUTPUT DriveType). /* Call Win API */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ZipFrame _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  VIEW FRAME ZipFrame.
  {&OPEN-BROWSERS-IN-QUERY-ZipFrame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_Zip_Comment ZipFrame 
PROCEDURE Get_Zip_Comment :
DEFINE INPUT  PARAMETER zipname    AS CHARACTER.
  DEFINE OUTPUT PARAMETER zipcomment AS CHARACTER.
  DEFINE OUTPUT PARAMETER zipstatus  AS LOGICAL INIT no.

  DEFINE VARIABLE commentLength AS INTEGER.
  DEFINE VARIABLE commentMem AS MEMPTR.
  
  ASSIGN FRAME {&FRAME-NAME}:HIDDEN = YES.

  SET-SIZE(commentMem) = 200.

  RUN zluGetGlobalComment(zipname, INPUT-OUTPUT commentMem, 200, OUTPUT commentLength).

  IF commentLength > 0 THEN DO:
     ASSIGN zipstatus = yes.
	 zipcomment = GET-STRING(commentMem, 1).
  END.
  ELSE DO:
     ASSIGN zipstatus = no
            zipcomment = "".
     RUN Unzip_Error(INPUT 1, INPUT "").
  END.

  SET-SIZE(commentMem) = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Unzip ZipFrame 
PROCEDURE Unzip :
/*------------------------------------------------------------------------------
  Purpose:     Unzip a file to a directory.
  Parameters:  
       INPUT: ZipName (char) - Name of zip file.
              DirName (char) - Directory to unzip into.    
      OUTPUT: ZipStatus (log) - Return flag (yes = ok, no = failed ) 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER zipname   AS CHARACTER.
  DEFINE INPUT  PARAMETER dirname   AS CHARACTER.
  DEFINE OUTPUT PARAMETER zipstatus AS LOGICAL INIT no.
  
  DEFINE VARIABLE res AS INTEGER NO-UNDO.
  
  /* Change dialog title */
  ASSIGN FRAME {&FRAME-NAME}:TITLE = "Unzipping " + zipname + " into " 
                                     + dirname + "...".

  RUN zluUnzip(zipname, dirname, 0, OUTPUT res).

  IF res = 0 THEN 
     ASSIGN zipstatus = yes.
  ELSE DO:
     ASSIGN zipstatus = no.
     RUN Unzip_Error(INPUT res, INPUT "").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Unzip_Error ZipFrame 
PROCEDURE Unzip_Error :
/*------------------------------------------------------------------------------
  Purpose:     Display error message based on return code from call to unzip.
  Parameters:  rc (int) - return code
  Notes: zip errors are the same from 16->32 bit      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER rc      AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER addText AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE        msgtext AS CHARACTER NO-UNDO.
  
  CASE rc:
    WHEN 0  THEN msgtext = "Successful operation.".
    WHEN 2  THEN msgtext = "Unexpected end of zip file.".
    WHEN 3  THEN msgtext = "Structure error in zip file.".
    WHEN 4  THEN msgtext = "Out of memory.".
    WHEN 5  THEN msgtext = "Out of memory.".
    WHEN 9  THEN msgtext = "File not found error.".
    WHEN 11 THEN msgtext = "Nothing to do.".
    WHEN 12 THEN msgtext = "Same volume for src and dest not allowed for.".
    WHEN 25 THEN msgtext = "Index out of bounds.".
    WHEN 28 THEN msgtext = "Error creating output file.".
    WHEN 29 THEN msgtext = "Error opening output file.".
    WHEN 39 THEN msgtext = "CRC error.".
    WHEN 40 THEN msgtext = "Application cancelled operation.".
    WHEN 41 THEN msgtext = "File skipped, encrypted.".
    WHEN 42 THEN msgtext = "Unknown compression method.".
    WHEN 44 THEN msgtext = "Bad or missing decrypt code.".
    WHEN 45 THEN msgtext = "Re-entry not permitted.".
    WHEN 46 THEN msgtext = "Can't unzip a volume item.".
    WHEN 47 THEN msgtext = "Bad command structure.".
    WHEN 48 THEN msgtext = "User cancelled this operation.".
    WHEN 49 THEN msgtext = "User skipped this operation.".
    WHEN 50 THEN msgtext = "Disk full.".
    OTHERWISE msgtext = "Unknown error." + addText.
  END CASE.  
  
  ASSIGN msgtext = "UnZip: " + msgtext + " (" + STRING(rc) + ")".
  MESSAGE msgtext VIEW-AS ALERT-BOX ERROR BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Win_API ZipFrame 
PROCEDURE Win_API :
/*------------------------------------------------------------------------------
  Purpose:     Procedure calls to the Windows API
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
END PROCEDURE.

PROCEDURE GetDriveTypeA EXTERNAL "kernel32.dll":U:
  DEFINE INPUT PARAMETER DriveLetter AS CHAR.
  DEFINE RETURN PARAMETER DriveType  AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Zip ZipFrame 
PROCEDURE Zip :
/*------------------------------------------------------------------------------
  Purpose:     Creates a zip file for the kit.
  Parameters:  
       INPUT:  ZipName (char)  - Name of zip file.
               ItemList (char) - What to zip up.
      OUTPUT:  ZipStatus (log) - Return flag (yes = ok, no = failure)
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER zipname   AS CHARACTER.
  DEFINE INPUT  PARAMETER BkupFile  AS CHARACTER.
  DEFINE INPUT  PARAMETER pItemList AS CHARACTER.
  DEFINE INPUT  PARAMETER dirname   AS CHARACTER.
  DEFINE OUTPUT PARAMETER zipstatus AS LOGICAL INIT no.
  
  DEFINE VARIABLE res AS INTEGER NO-UNDO.
  DEFINE VARIABLE nRecursive AS INTEGER NO-UNDO.

  nRecursive = IF Recursive THEN 1 ELSE 0.

  /* Change dialog title */
  ASSIGN FRAME {&FRAME-NAME}:TITLE = "Creating " + zipname + "...".

  RUN zlZip(zipname, dirname, BkupFile, pItemList, ZipComment, ZCompFactor - 1, nRecursive, 0, OUTPUT res).

  IF res = 0 THEN
        ASSIGN zipstatus = yes.
  ELSE DO:
        ASSIGN zipstatus = no.
        RUN Zip_Error(INPUT res, INPUT ""). 
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ZipAPI ZipFrame 
PROCEDURE ZipAPI :
/*------------------------------------------------------------------------------
  Purpose:     'Dummy' section to house the Zipper DLL procedure defs.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
END PROCEDURE.

PROCEDURE zlZip EXTERNAL "zipper.dll" CDECL PERSISTENT: 
    DEFINE INPUT  PARAMETER zipFileName AS CHARACTER.
    DEFINE INPUT  PARAMETER zipFolder   AS CHARACTER.
    DEFINE INPUT  PARAMETER zipBkupFile AS CHARACTER.
    DEFINE INPUT  PARAMETER zipExts     AS CHARACTER.
    DEFINE INPUT  PARAMETER zipComment  AS CHARACTER.
	DEFINE INPUT  PARAMETER zipCompLvl  AS LONG.
	DEFINE INPUT  PARAMETER zipRecurse  AS LONG.
    DEFINE INPUT  PARAMETER zipAppend   AS LONG.
    DEFINE RETURN PARAMETER res         AS LONG.
END PROCEDURE.

PROCEDURE zluUnzip EXTERNAL "zipper.dll" CDECL PERSISTENT: 
    DEFINE INPUT  PARAMETER zipFileName    AS CHARACTER.
    DEFINE INPUT  PARAMETER zipFolder      AS CHARACTER.
    DEFINE INPUT  PARAMETER ignoreFilePath AS LONG.
    DEFINE RETURN PARAMETER res            AS LONG.
END PROCEDURE.

PROCEDURE zluGetGlobalComment EXTERNAL "zipper.dll" CDECL PERSISTENT: 
    DEFINE INPUT        PARAMETER zipFileName AS CHARACTER.
    DEFINE INPUT-OUTPUT PARAMETER zipComment  AS MEMPTR.
    DEFINE INPUT        PARAMETER bufferLen   AS LONG.
    DEFINE RETURN       PARAMETER commentLen  AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Zip_Error ZipFrame 
PROCEDURE Zip_Error :
/*------------------------------------------------------------------------------
  Purpose:     Display error message based on return code from call to zip.
  Parameters:  rc (int) - return code
  Notes: zip errors are the same from 16->32 bit      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER rc      AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER addText AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        msgtext AS CHARACTER NO-UNDO.
  
  CASE rc:
    WHEN 0  THEN msgtext = "Success.".
    WHEN 1  THEN msgtext = "Can't reenter.".
    WHEN 2  THEN msgtext = "Unexpected end of zip file.".
    WHEN 3  THEN msgtext = "Zip file structure error.".
    WHEN 4  THEN msgtext = "Out of memory.".
    WHEN 5  THEN msgtext = "Internal logic error.".
    WHEN 6  THEN msgtext = "Entry too large to split.".
    WHEN 7  THEN msgtext = "Invalid comment format.".
    WHEN 8  THEN msgtext = "Zip test (-T) failed or out of memory.".
    WHEN 9  THEN msgtext = "User cancelled.".
    WHEN 10 THEN msgtext = "Error using a temp file.".
    WHEN 11 THEN msgtext = "Read or seek error.".
    WHEN 12 THEN msgtext = "Nothing to do.".
    WHEN 13 THEN msgtext = "Missing or empty zip file.".
    WHEN 14 THEN msgtext = "Error writing to a file.".
    WHEN 15 THEN msgtext = "Couldn't open to write.".
    WHEN 16 THEN msgtext = "Bad control parameters.".
    WHEN 17 THEN msgtext = "Could not complete operation.".
    WHEN 18 THEN msgtext = "Could not open a specified file to read.".
    WHEN 19 THEN msgtext = "Media error, disk not ready, HW r/w error, etc.".
    WHEN 20 THEN msgtext = "Bad Multi-Volume control parameters.".
    WHEN 21 THEN msgtext = "Improper usage of a Multi-Volume Zip File.".
    OTHERWISE msgtext = "Unknown error:" + addText.
  END CASE.  
  
  ASSIGN msgtext = "Zip: " + msgtext + " (" + STRING(rc) + ")".
  MESSAGE msgtext VIEW-AS ALERT-BOX ERROR BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

