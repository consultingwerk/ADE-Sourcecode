/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/**************************************************************************
    Procedure:  pcmpcls.i
    
    Purpose:    Generic procedures for handling compilation of .cls files

    Syntax :    { adecomm/pcmpcls.i }

    Parameters:
    
    Description:
        Defines some generic procedures for handling the compilation of
        .cls files, for the Procedure Editor and Procedure Window.

        We need to provide the same .cls-handling functionality in both 
        Procedure Window and Procedure Editor. Rather than re-code it, 
        this functionality was pulled into this include file. Although 
        it has some UI, this should be portable to both GUI and TTY
        Procedure Editors.

        For more information, refer to adeedit/pcompile.i, adecomm/_pwrun.p,
        webutil\_cpyfile.p

    Notes  :
    Authors: 
    Date   : May 2005
**************************************************************************/


/* Preprocessor to determine the correct dir delimiter to use for the OS */
&IF "{&OPSYS}" = "UNIX" &THEN
  &SCOPED-DEFINE DIRDELIM /  
&ELSE
  &SCOPED-DEFINE DIRDELIM ~~~\
&ENDIF

PROCEDURE GetUniqueDir:
/*--------------------------------------------------------------------------
    Purpose:        Returns a unique subdirectory name below the given dir

    Run Syntax: RUN GetUniqueDir(INPUT dir,INPUT prefix,INPUT suffix,OUTPUT subdir).
    Parameters:
      dir - parent directory for unique subdir. If ?, use SESSION:TEMP-DIR.
      prefix - prefix for the subdir name. If ?, use "".
      suffix - suffix for the subdir name. If ?, use "".
      subdir - unique subdirectory within SESSION:TEMP-DIR
    Description:
    Notes: DOES NOT GUARANTEE subdir IS WRITABLE, JUST UNIQUE
    Adapted from adecomm/_tmpfile.p
---------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cDir AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER cPrefix AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER cSuffix AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER cSubDir AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE cCheckName AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iBase AS INTEGER     NO-UNDO.
    
    ASSIGN 
        cDir = (IF cDir = ? THEN SESSION:TEMP-DIR ELSE cDir)
        cPrefix = (IF cPrefix = ? THEN "" ELSE cPrefix)
        cSuffix = (IF cSuffix = ? THEN "" ELSE cSuffix)
        cCheckName = "something".
 
    DO WHILE cCheckName <> ?:
      /* Take the lowest 5 digits (change the format so that everything works out to have exactly 5
         characters. */
      ASSIGN
        iBase = ( TIME * 1000 + ETIME ) MODULO 100000
        cSubDir = STRING(iBase,"99999":U).
 
      /* Add in the extension and directory into the name. */
      cSubDir = SESSION:TEMP-DIR + cPrefix + cSubDir + cSuffix.
 
      cCheckName = SEARCH(cSubDir).
    END.
END PROCEDURE.

PROCEDURE GetClassCompileName:
/*--------------------------------------------------------------------------
    Purpose:        Creates the necessary dir structure beneath the 
                    current working directory, creates the .cls file, 
                    and returns the fully qualified pathname to this dir.

    Run Syntax: RUN GetClassCompileName(ClassTmpDir,SrcFileName,ClassType,OUTPUT CompileFilename).
    Parameters:      
      ClassTmpDir - temp directory name for storing this class's directories
      SrcFileName - name of the source file, so we can strip off the basename
      ClassType   - package name of class, including the basename
      CompilerFilename - fully qualified name of file to compile
    Description:
    Notes:
      Although the compiler will give us the ClassType, we don't want to 
      use that for saving the file, as the user might have saved it as 
      something else. In this case, we want to make sure the directories 
      match the ClassType, but the basename match the SrcFileName.
      If there are any errors creating the necessary directories, don't
      handle them here, just return with a ? filename, and let the caller 
      handle the SAVE error.
---------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER ClassTmpDir AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER SrcFileName AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER ClassType AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER CompileFilename AS CHARACTER INIT ? NO-UNDO.

    DEFINE VARIABLE cDummy AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cBaseName AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iNumDirs AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iDir AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cDir AS CHARACTER   NO-UNDO.

    /* if ClassTmpDir is not available */
    FILE-INFO:FILE-NAME = ClassTmpDir.
    IF (FILE-INFO:FILE-TYPE = ?) THEN
    DO:
        /* create it */
        OS-CREATE-DIR VALUE(ClassTmpDir).
        /* if error occurred creating dir, then return */
        IF (OS-ERROR <> 0) THEN
            RETURN.
    END.

    /* count the number of dirs (separated by ".":U) in ClassType.
     * Skip the last one, as that is the filename */
    iNumDirs = NUM-ENTRIES(ClassType,".":U) - 1.
    CompileFilename = ClassTmpDir.
    /* for each entry in the ClassType (except the last one) */
    DO iDir = 1 TO iNumDirs:
        /* get the directory name */
        cDir = ENTRY(iDir,ClassType,".":U).
        /* add the subdir to the CompileFilename */
        CompileFilename = CompileFilename + "{&DIRDELIM}":U + cDir.
        /* create a subdir in the ClassTmpDir */
        OS-CREATE-DIR VALUE(CompileFilename).
        /* if error creating dir, then return */
        IF (OS-ERROR <> 0) THEN
            RETURN.
    END.

    /* get the basename from the SrcFileName */
    IF (SrcFileName = ?) THEN
        /* if no SrcFileName provided, use the last entry in ClassType, and append ".cls" */
        cBaseName = ENTRY(iNumDirs + 1,ClassType,".":U) + ".cls".
    ELSE
        /* Get the basename from SrcFileName, including the ".cls" */
        RUN adecomm/_osprefx.p ( SrcFileName, OUTPUT cDummy, OUTPUT cBaseName).

    /* append the basename to CompileFilename */
    CompileFileName = CompileFileName + "{&DIRDELIM}":U + cBaseName.
    
END PROCEDURE.

PROCEDURE CreateClassStub:
/*--------------------------------------------------------------------------
    Purpose:        Creates a stub file to instantiate an OO4GL class

    Run Syntax: 
        RUN CreateClassStub(
               INPUT cStubFile,INPUT cClassType).
    Parameters:
        cStubFile - filename of the stub to create
        cClassType - package of the class
    Description:
    Notes: Any errors returned in RETURN-VALUE.
---------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cStubFile AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER cClassType AS CHARACTER   NO-UNDO.

    OUTPUT TO VALUE(cStubFile) NO-ECHO.
    PUT UNFORMATTED
        "DEFINE VARIABLE rTemp AS CLASS ":U cClassType " NO-UNDO." SKIP(1)
        "DO ON ERROR  UNDO, LEAVE":U SKIP
        "   ON ENDKEY UNDO, LEAVE":U SKIP
        "   ON STOP   UNDO, LEAVE":U SKIP
        "   ON QUIT   UNDO, LEAVE:":U SKIP(1)
        "    rTemp = NEW ":U cClassType " ( ) .":U SKIP(1)
        "END.":U SKIP
        "DELETE OBJECT rTemp NO-ERROR.":U SKIP.
    OUTPUT CLOSE.
    RETURN ?.
END PROCEDURE.

PROCEDURE AskToSaveClass:
/*--------------------------------------------------------------------------
    Purpose:        Asks the user if they wish to save the class file on save

    Run Syntax: 
        RUN AskToSaveClass(
               INPUT lUntitled,
               INPUT cClassType,
               INPUT lSaveBeforeRun,
               OUTPUT lOK).
    Parameters:
        lUntitled      - TRUE if buffer is untitled
        cClassType     - Expected package name of file, for untitled buffer
        lSaveBeforeRun - AutoSaveCls value
        lOK            - Whether user indicated save or not
    Description:    Displays a dialog, telling the user they must save
                    a .cls file in order to run it. The dialog also displays
                    a toggle to indicate whether the procedure editor should
                    just save without asking in future .In the case of an 
                    untitled edit buffer, we hide this toggle. This 
                    auto-save toggle is passed back in lSaveBeforeRun.
    Notes: 
---------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER lUntitled AS LOGICAL     NO-UNDO.
    DEFINE INPUT        PARAMETER cClassType AS CHARACTER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER lSaveBeforeRun AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT       PARAMETER lOK AS LOGICAL INIT FALSE NO-UNDO.

    DEFINE VARIABLE lAutoSave AS LOGICAL INITIAL no 
         LABEL "Save .cls file automatically before run" 
         VIEW-AS TOGGLE-BOX SIZE 55 BY .81 NO-UNDO.
    DEFINE VARIABLE cSaveText1 AS CHARACTER FORMAT "x(60)" NO-UNDO.
    DEFINE BUTTON bYes AUTO-GO LABEL "Yes" SIZE 15 BY 1.14.
    DEFINE BUTTON bNo AUTO-END-KEY LABEL "No" SIZE 15 BY 1.14.
    DEFINE VARIABLE cClassFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cClassPath AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE ipos AS INTEGER     NO-UNDO.

    DEFINE FRAME fClassSave
         lAutoSave AT ROW 4.33 COL 4
         bYes AT ROW 5.52 COL 18
         bNo AT ROW 5.52 COL 35
         cSaveText1 VIEW-AS TEXT 
              SIZE 65 BY .95 AT ROW 1.48 COL 4 NO-LABEL
         "Do you wish to save this file now?" VIEW-AS TEXT
              SIZE 60 BY .95 AT ROW 2.43 COL 4
         SPACE(2.19) SKIP(3.61)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
             TITLE "Warning - .cls file not saved"
             DEFAULT-BUTTON bYes.

    ON GO OF FRAME fClassSave
    DO:
        lOK = TRUE.
        ASSIGN lAutoSave.
    END.

    lAutoSave = lSaveBeforeRun.

    IF lUntitled THEN
    DO:
        /* if we were passed a classtype */
        IF (cClassType <> ?) THEN
        DO:
            /* 20050920-014 Display this message as an alert-box, 
             * as we don't need the autosave checkbox if we don't
             * know the filename. */
            ipos = R-INDEX(cClassType,".":U).
            IF (ipos > 0) THEN
                ASSIGN 
                  cClassFile = SUBSTRING(cClassType,ipos + 1)
                  cClassPath = REPLACE(SUBSTRING(cClassType,1,ipos - 1),".":U,"{&DIRDELIM}":U).
            ELSE 
                 ASSIGN
                     cClassFile = cClassType
                     cClassPath = "".
            MESSAGE 
                "You must save this file as '":U + cClassFile + "'.cls":U + 
                (IF cClassPath <> "" THEN 
                     ", in a directory '":U + cClassPath + "'":U
                 ELSE 
                     "") SKIP
                "relative to PROPATH, in order to run.":U SKIP(1)
                "Do you wish to save this file now?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOK.
            RETURN.
        END.  /* if cClassType <> ? */
        ELSE
        DO:
            /* we were not passed a classtype: this is an error, and should never happen!
             * To handle it gracefully, just tell the user this must be saved as .cls 
             */
            cSaveText1 = "You must save this file as a .cls file in order to run.".
        END.

        /* display on the form */
        lAutoSave:VISIBLE IN FRAME fClassSave = FALSE.
        DISPLAY cSaveText1 WITH FRAME fClassSave.
        ENABLE bYes bNo WITH FRAME fClassSave.
    END.  /* if lUntitled */
    ELSE
    DO:
        cSaveText1 = "You must save a .cls file in order to run.":U .
        DISPLAY lAutoSave cSaveText1 WITH FRAME fClassSave.
        ENABLE ALL WITH FRAME fClassSave.
    END.
    VIEW FRAME fClassSave.

    DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        /* wait for GO or Cancel of fClassSave */
        WAIT-FOR GO OF FRAME fClassSave OR 
            WINDOW-CLOSE OF FRAME fClassSave.
    END.

    HIDE FRAME fClassSave.
    lSaveBeforeRun = IF (NOT lUntitled AND lOK) THEN lAutoSave ELSE lSaveBeforeRun.

END PROCEDURE.

PROCEDURE FindClassInPropath:
/*--------------------------------------------------------------------------
    Purpose:        Determines whether a file matching the package name of
                    cClassType is on the PROPATH, and if so, whether this
                    is the same file as cFileName. If so, Ask the user if
                    they REALLY want to execute this file.
                    
    Run Syntax: 
        RUN FindClassInPropath(
               INPUT cClassType,INPUT cFileName,OUTPUT lOK).
    Parameters:
        cClassType - package of the class to locate
        cFileName  - filename of the .cls file which contains this package
        lOK        - the user really wants to run this file.
    Description:    
    Notes: 
          TO DO: Things to consider:
                 - if a user saves his .cls file, but has its .r file in
                   the same dir, then what should we do? We will use the .r
                   even though it may not contain the latest code. 
---------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cClassType AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER cFileName AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER lOK AS LOGICAL INIT TRUE NO-UNDO.
    
    DEFINE VARIABLE cSrchPath AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSrchFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cFilePath AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cRPath AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cMsg AS CHARACTER INIT ? NO-UNDO.

    /* replace "." in cClassType with dir delimiter, and add ".cls".
     * Also get the .r equivalent */
    ASSIGN 
        cSrchPath = REPLACE(cClassType,".":U,"{&DIRDELIM}":U ) + ".cls":U
        cRPath = REPLACE(cClassType,".":U,"{&DIRDELIM}":U ) + ".r":U.

    /* in the TTY Procedure editor, the filename may not have a fully 
     * qualified path. If not, locate this based on search */
    ASSIGN 
        FILE-INFO:FILE-NAME = cFileName
        cFilePath = FILE-INFO:FULL-PATHNAME.

    /* look for r-code path first */
    cRPath = SEARCH(cRPath).
    /* if r-code exists in the PROPATH, then we will never end up 
     * running our .cls file */
    IF (cRPath <> ?) THEN
    DO:
        ASSIGN
          FILE-INFO:FILE-NAME = cRPath
            cRPath = FILE-INFO:FULL-PATHNAME.
        cMsg = "The file ":U + cRPath + " was found in the PROPATH,~n":U + 
            "so this will run instead of ":U + cFilePath + ".":U.
    END.
    ELSE
    DO:
        /* no r-code found, look for source path */
        cSrchFile = SEARCH(cSrchPath).
        IF cSrchFile <> ? THEN
            ASSIGN 
                FILE-INFO:FILE-NAME = cSrchFile
                cSrchFile = FILE-INFO:FULL-PATHNAME.
        IF (cSrchFile = ? OR cSrchFile <> cFilePath) THEN
            cMsg  = 
            (IF cSrchFile = ? THEN
                "File ":U + cSrchPath + " could not be found relative to PROPATH.":U
             ELSE
                "The file ":U + cSrchFile + " was found first in the PROPATH, so this will run instead of ":U + cFilePath + ".":U).
    END.

    IF (cMsg <> ?) THEN
        MESSAGE cMsg SKIP
        "If you continue, you may get errors or unexpected behavior.":U SKIP(1)
        "Do you wish to continue?":U
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
        UPDATE lOK.
END PROCEDURE.

FUNCTION IsValidClassChange RETURN LOGICAL (
    INPUT cFileName AS CHAR,
    INPUT cCurrentClassType AS CHAR,
    INPUT cCompileClassType AS CHAR):
/*--------------------------------------------------------------------------
    Purpose:        Checks if the classtype from the last compile
                    matches the pathname of the file, and that it matches
                    the classtype previously recorded.
    Run Syntax: 
        IF IsValidClassChange(
               INPUT cFileName,
               INPUT cCurrentClassType,
               INPUT cCompileClassType) THEN...
    Parameters:
        FileName          - fully qualified pathname of the .cls file 
        cCurrentClassType - package of the class when we last recorded it
        cCompileClassType - package of the class from the last compile
    Description:    
    Notes: 
---------------------------------------------------------------------------*/
  DEFINE VARIABLE lRet AS LOGICAL INIT NO    NO-UNDO.
  DEFINE VARIABLE cClassPath AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cBaseName AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFilePath AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE ipos AS INTEGER     NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iNumClassDir AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iNumPathDir AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cFileDir AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cClassDir AS CHARACTER   NO-UNDO.

  /* first, check whether the full pathname of the .cls file matches 
   * cCompileClassType. If these don't match, the user has put an 
   * invalid classtype into the file, and we should just tell them it is
   * an error. 
   * Of course, only do this if we have a filename
   */
  IF (cFilename <> ? AND cFilename <> "":U) THEN
  DO:
      /* make sure we get the fully qualified pathname */
      ASSIGN 
          FILE-INFO:FILE-NAME = cFileName
          cFileName = FILE-INFO:FULL-PATHNAME.
      /* get the base filename */
      RUN adecomm/_osprefx.p ( cFileName, OUTPUT cFilePath, OUTPUT cBaseName).
      ASSIGN 
          iNumClassDir = NUM-ENTRIES(cCompileClassType,".":U).

      /* compare to the last entry in cCompileClassType */
      IF (cBaseName <> 
          ENTRY(iNumClassDir,cCompileClassType,".":U) + ".cls":U) THEN
          /* basenames don't match, abort */
          RETURN FALSE.
      ELSE IF iNumClassDir > 1 THEN
      DO:
          /* the basenames matched, and there are dirs to check in cCompileClassType.
           * Move backwards through the dirs */
          iNumPathDir = NUM-ENTRIES(cFilePath,"{&DIRDELIM}":U) - 1.
          DO ipos = iNumClassDir - 1 TO 1 BY -1 :
              ASSIGN
                  cClassDir = ENTRY(ipos,cCompileClassType,".":U)
                  cFileDir = 
                      (IF iNumPathDir > 0 THEN
                      ENTRY(iNumPathDir,cFilePath,"{&DIRDELIM}":U)
                      ELSE "":U)
                  iNumPathDir = iNumPathDir - 1.
              IF (cClassDir <> cFileDir) THEN
                  /* we found a mismatch between cCompileClassType and cFileName */
                  RETURN FALSE.
          END.
      END.  /* if iNumClassDir > 1 */
  END.  /* if cFileName <> ? and cFileName <> "" */

  /* If we get to here, cCompileClassType matches cFileName, so we know the 
   * file contains a valid classtype (or else this is an untitled buffer).
   * Now, check to see if the last recorded classtype is a subset of the 
   * cCompileClassType, to know if the user just qualified the class with 
   * a package name. */
  IF cCompileClassType MATCHES ("*":U + cCurrentClassType) THEN
      RETURN TRUE.
   
  RETURN NO.

END.  /* CheckClassType */
