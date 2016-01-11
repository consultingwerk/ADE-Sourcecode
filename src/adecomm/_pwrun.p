/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwrun.p
    
    Purpose:    Execute Procedure Window commands
                  Compile->Run
                  Compile->Check Syntax

    Syntax :    RUN adecomm/_pwrun.p (INPUT p_Action).

    Parameters:
    Description:
    Notes   :
    Authors : John Palazzo
    Date    : July, 1995
    Modified: 6/19/98 adams support for 9.0A remote file managment
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }
{ adecomm/_pwattr.i }

/* .cls definitions */
{ adecomm/dcmpcls.i }

/* PROGRESS Preprocessor system message number. */
&SCOPED-DEFINE PP-4345      4345

DEFINE INPUT PARAMETER p_Action AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wfRunning     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_ade_tool    AS HANDLE    NO-UNDO.

DEFINE VARIABLE h_menu        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_tool        AS HANDLE    NO-UNDO.
DEFINE VARIABLE pw_Editor     AS HANDLE    NO-UNDO.
DEFINE VARIABLE pw_Window     AS HANDLE    NO-UNDO.

DEFINE VARIABLE app_handle    AS HANDLE    NO-UNDO.
DEFINE VARIABLE Broker_URL    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Cannot_Run    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Comp_Err      AS INTEGER   NO-UNDO.
DEFINE VARIABLE Comp_File     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Comp_Stopped  AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE VARIABLE Dlg_Answer    AS LOGICAL   NO-UNDO.             
DEFINE VARIABLE Error_Col     AS INTEGER   NO-UNDO.
DEFINE VARIABLE Error_File    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Error_Found   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Error_Msg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Error_Offset  AS INTEGER   NO-UNDO.
DEFINE VARIABLE Error_Row     AS INTEGER   NO-UNDO.
DEFINE VARIABLE File_Ext      AS CHARACTER NO-UNDO.
DEFINE VARIABLE File_Modified AS LOGICAL   NO-UNDO.
DEFINE VARIABLE File_Name     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Html_File     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Private_Data   AS CHARACTER NO-UNDO.
DEFINE VARIABLE Proxy_Broker  AS CHARACTER NO-UNDO.
DEFINE VARIABLE Rel_Name      AS CHARACTER NO-UNDO.
DEFINE VARIABLE Remote_File   AS CHARACTER NO-UNDO.
DEFINE VARIABLE Run_Action    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Run_Msg       AS CHARACTER NO-UNDO.
DEFINE VARIABLE Saved_File    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Web_File      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE IsClass      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE ClassType    AS CHARACTER NO-UNDO.
DEFINE VARIABLE OldClassType AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ClassTmpDir  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCtr         AS INTEGER     NO-UNDO.
DEFINE VARIABLE isClassError AS LOGICAL     NO-UNDO.
DEFINE VARIABLE isWrongClass AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lAutoSaveCls AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE cAutoSaveCls AS CHARACTER   NO-UNDO.
DEFINE VARIABLE Run_File     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lOK          AS LOGICAL     NO-UNDO.

MAIN_BLOCK:
DO ON STOP UNDO, LEAVE:
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
    
    ASSIGN Run_Msg = REPLACE(LC(p_Action) , "-syntax":U , "").
    
    IF ( pw_Editor:EMPTY ) THEN
    DO:
        MESSAGE "Nothing in this procedure to " + Run_Msg + ".":U
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN.
    END.
    
    /* Put up the wait cursor. */
    RUN adecomm/_setcurs.p ("WAIT":U).

    /* Check if this is a .cls file, and if it has a known ClassType.
     * We store "" as the ClassType if this is NOT a .cls file.
     * We store "?" if this is a .cls file, but we don't know its
     * ClassType yet (i.e. when it has just been loaded).
     * If ClassType is not "", we assume this is a .cls file, 
     * and ClassType reflects the package of the defined class.
     * 20051014-003 If the ClassType is "", check the filename for 
     * the ".cls" extension in the filename before assigning IsClass. */
    ASSIGN
        ClassType = ENTRY( {&PW_Class_Type_Pos},pw_Editor:PRIVATE-DATA )
        IsClass = 
            (IF ClassType = "" THEN 
              (IF pw_Editor:NAME MATCHES "*.cls" THEN TRUE ELSE FALSE) 
             ELSE TRUE)
        ClassType = (IF isClass THEN (IF ClassType = "?" THEN "" ELSE ClassType) ELSE ?)
        OldClassType = ClassType
        Comp_File = ENTRY( {&PW_Compile_File_Pos}, pw_Editor:PRIVATE-DATA ).
        .
    
    /* SAVE_AND_COMPILE_BLOCK explanation
     * This block was implemented to support OO4GL and .cls files.
     * Background:
     * A piece of OO4GL code MUST meet the following criteria in order 
     * to compile correctly:
     * - its filename MUST have a ".cls" extension
     * - the end of its path MUST match the package declared in the CLASS 
     * e.g. CLASS foo.bar MUST have a pathname foo/bar.cls
     * If the compiler compiles OO4GL syntax in a file without a .cls extension, 
     * it will generate error (12622) for a CLASS and (12623) for an INTERFACE.
     * Also, if the compiler compiles a .cls file, and the pathname does NOT
     * match the package declared in the CLASS, it will generate error (12629),
     * and set the COMPILER:CLASS-TYPE attribute to the name of the declared CLASS
     * (note that the COMPILER:CLASS-TYPE attribute is NOT set unless you 
     * compile a file with a .cls extension).
     * Two other things to consider:
     * - when a user enters text into an untitled edit buffer, there is no way to
     *   tell (without compiling) whether the code contains OO4GL syntax or not.
     * - when a user loads a .cls file, there is no way to know what the 
     *   declared package of the class is (without compiling it).
     * This means that to successfully compile OO4GL code we need to determine
     * that it is OO4GL code first (by compiling), and then determine the
     * correct package (by compiling). This means we might need to save the code
     * up to 3 times with different names and compile up to 3 times in order to
     * CHECK SYNTAX or RUN. Rather than re-write the save and compile code 3 times, 
     * we make up to 3 iterations of the SAVE_AND_COMPILE_BLOCK.
     * 
     * To explain how the SAVE_AND_COMPILE_BLOCK (SACB) works, consider the following
     * situations:
     *
     * - untitled buffer, containing non-OO4GL code
     *   On the first pass through SACB, the buffer is saved to a temp file 
     *   with a non-.cls extension. If it compiles without a (12622) or (12623)
     *   error, then we assume it is NOT a .cls file, and leave SACB.
     *   
     * - untitled buffer, containing OO4GL code
     *   On the first pass through SACB, the buffer is saved to a temp file
     *   with a non-.cls extension. The compiler will return a (12622) or 
     *   (12623) error, which indicates this is OO4GL. We then set isClass to 
     *   indicate it is OO4GL, and force another pass of SACB.
     *   On the second pass of SACB, we know the buffer contains OO4GL, 
     *   but we don't know the correct class name. We change the extension of
     *   the temp file to .cls, and save the buffer to this file. The compile
     *   will then generate a (12629) error, indicating the file has the wrong 
     *   pathname for the declared class. We set the ClassType based on 
     *   COMPILER:CLASS-TYPE, and force another pass of SACB.
     *   On the third pass of SACB, we know the buffer contains OO4GL, 
     *   and we know what the classtype (and hence the pathname) should be.
     *   We then create a temporary directory under the SESSION:TEMP-DIR,
     *   and build a directory path to match the classtype of the class.
     *   We then save the buffer to the file in the temporary directory path.
     *   The compiler will then compile the temp file. At this point, 
     *   we leave SACB, to report the outcome of the compile. However, we save
     *   away the classtype and temp dir name for future use.
     *
     * - buffer loaded from a non-.cls file
     *   When loading the non-.cls file, we know the extension is not .cls,
     *   so this is treated the same as an untitled edit buffer. However, if 
     *   the code contains any OO4GL statements, we will not trap the (12622)
     *   or (12623) errors, since the file is already determined as non-OO4GL 
     *   by its extension. Regardless, we leave the SACB to report the outcome
     *   of the compile.
     *
     * - buffer loaded from a .cls file, never previously compiled
     *   When first loading the file, we know it is a class file by its
     *   .cls extension, so we flag this with a classtype of "", and 
     *   set isClass to true. 
     *   On the first pass of SACB, we have a temp file name with a non-.cls 
     *   extension, so we change the extension to .cls, and save the buffer
     *   to this file. We then compile it, which should give us the (12629)
     *   error, and the classtype in COMPILER:CLASS-TYPE. We then force
     *   another pass of SACB.
     *   On the second pass, we know the classtype, and that the file is a class,
     *   so we create a temp dir, and build the appropriate path beneath it to 
     *   match the classtype. We save the buffer to the .cls file in this 
     *   temp dir, and compile it. We then leave SACB, to report the 
     *   outcome of the compile. However, we save away the classtype and 
     *   temp-dir name for future use.
     *
     * - buffer loaded from a .cls file, previously compiled
     *   From previous compiles, we know that this buffer contains OO4GL,
     *   and we know its clastype and the name of the temp dir we have
     *   determined for it. We can go straight to building the appropriate
     *   dir structure underneath the temp dir, saving the buffer to this file,
     *   and compiling. We then leave SACB to report the outcome of the compile.
     *
     * And now for the fun part: remote development.
     * We still have to go through these steps for remote development. We just
     * have to save the buffer to the webspeed agent each pass through SACB,
     * telling it to use a specific save name for the file. Communicating 
     * .cls information with the webspeed agent happens in the following ways:
     * - if the buffer contains OO4GL (either a loaded .cls file, or 
     *   and untitled edit buffer), we pass the classtype as part of the 
     *   Filename param to adecomm/_webcom.w, delimited by a pipe "|".
     *   If we don't know the classtype, we will end up passing "", but 
     *   the existence of the delimiter will indicate that this is an 
     *   OO4GL file.
     * - The agent returns compile errors back through the RETURN-VALUE 
     *   from adecomm/_webcom.w. The RETURN-VALUE will contain the (12622),
     *   (12623) and (12629) errors, and we just parse the RETURN-VALUE
     *   for these errors the same way we parse the local compile output.
     * - If the agent (through _cpyfile.w) detects that COMPILER:CLASS-TYPE
     *   is set, it returns this to adecomm/_webcom.w, returned in the 
     *   first line of the RETURN-VALUE as:
     *     ERROR:CLASSTYPE:<ClassType>
     *   If there is an error, the first line of RETURN-VALUE begins with 
     *   ERROR <linenum>. We simply overload the first (space-delimited)
     *   entry of the RETURN-VALUE by adding our classtype in a colon-delimited 
     *   list, identified by the "CLASSTYPE" 
     *      
     */
    SAVE_AND_COMPILE_BLOCK:
    REPEAT:
        /* Generate a temporary filename for writing editor contents. */
        /* Remember the filename so it will be reused for subsequent runs.
        ** The debugger requires that the filename remain the same within
        ** a session so that breakpoints can be remembered for multiple
        ** files.
        */
        IF Comp_File = "" THEN
        DO:
            /* Generate the unique compiler file name for this buffer. */
            RUN adecomm/_uniqfil.p ( pw_Editor:NAME , ".cmp":U, OUTPUT Comp_File ).
    
            ASSIGN 
              Private_Data = pw_Editor:PRIVATE-DATA 
              ENTRY( {&PW_Compile_File_Pos}, Private_Data ) = Comp_File
              pw_Editor:PRIVATE-DATA = Private_Data.
        END.

        /* if this is a class, change Comp_File to have .cls extension */
        IF (isClass) THEN
        DO:
            /* if we don't know the ClassType yet, replace .cmp with .cls */
            IF (ClassType = "") THEN
            DO:
                /* replace .cmp with .cls */
                ictr = R-INDEX(Comp_File,".cmp":U).
                IF ictr > 0 THEN
                    SUBSTRING(Comp_File,ictr) = ".cls":U.
            END.  /* if ClassType = "" */
            ELSE
            DO: /* ClassType <> "" */
                /* we know the classtype for the .cls file.
                 * We need a temp file with a path that maps to the 
                 * class name */
                /* If we don't have a local temp dir for this, create one */
                ClassTmpDir = ENTRY( {&PW_Class_TmpDir_Pos},pw_Editor:PRIVATE-DATA ).
                IF (ClassTmpDir = "") THEN
                DO:
                    RUN GetUniqueDir(SESSION:TEMP-DIR,"p",?,OUTPUT ClassTmpDir).
                    ASSIGN 
                      Private_Data = pw_Editor:PRIVATE-DATA 
                      ENTRY( {&PW_Class_TmpDir_Pos}, Private_Data ) = ClassTmpDir
                      pw_Editor:PRIVATE-DATA = Private_Data.
                END.
                /* create Comp_File from the directory and classtype */
                RUN GetClassCompileName(
                    ClassTmpDir,
                    (IF pw_Editor:NAME BEGINS {&PW_Untitled} THEN ? ELSE pw_Editor:NAME),
                    ClassType,
                    OUTPUT Comp_File).                
            END.  /* ClassType <> "" */
        END.  /* if isClass */
    
        IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
        DO:
          RUN adeuib/_uibinfo.p ( ?, "SESSION":U, "Remote":U, 
                                 OUTPUT Remote_File) NO-ERROR.
          RUN adeuib/_uibinfo.p ( ?, "SESSION":U, "BrokerURL":U, 
                                 OUTPUT Proxy_Broker) NO-ERROR.
        END.
        
        RUN adecomm/_pwfmod.p ( INPUT pw_Editor, OUTPUT File_Modified).
        ASSIGN 
          File_Name  = pw_Editor:NAME
          Broker_URL = ENTRY ( {&PW_Broker_URL_Pos}, pw_Editor:PRIVATE-DATA )
          Run_Msg    = REPLACE(LC(p_Action) , "-":U , "").
          Run_Action = (IF p_Action BEGINS "check":U THEN "checked":U 
                        ELSE LC(p_Action)).
    
        RUN adecomm/_osfext.p ( File_Name, OUTPUT File_Ext).
        IF (File_Ext eq ".htm":U OR File_Ext eq ".html":U) THEN
          Html_File = TRUE.
        
        /* Do we want to run or check a remote web file? */  
        IF (File_Name BEGINS {&PW_Untitled} AND Remote_File eq "TRUE":U) OR
          Html_File OR Broker_URL ne "" THEN DO:
          
          /* Save changes to disk. */
          IF Html_File AND File_Modified THEN
            RUN adecomm/_pwsave.p (INPUT pw_Editor).
    
          /* File must be saved before running. */
          IF p_Action eq "run":U AND File_Modified THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT Dlg_Answer, "error":U, "ok":U,
              SUBSTITUTE("&1 has changes which must be saved before running.",
                File_Name)).
            RETURN.
          END.
    
          Web_File = TRUE.
          
          /* Save to a local temp file when checking syntax. */
          IF p_Action eq "check-syntax":U THEN DO:
            ASSIGN Saved_File = pw_Editor:SAVE-FILE (Comp_File) NO-ERROR.
            RUN SetEdBufType (INPUT pw_Editor, INPUT File_Name).    /* adecomm/peditor.i */
            IF NOT Saved_File THEN DO:
              RUN adecomm/_s-alert.p (INPUT-OUTPUT Dlg_Answer, "error":U, "ok":U,
                SUBSTITUTE("Cannot save to this file.  &1 is read-only or the path specified is invalid.",
                Comp_File)).
              RETURN.
            END.
          END.
          
          IF Broker_URL = "" AND Proxy_Broker ne ? THEN
            Broker_URL = Proxy_Broker.

          /* Run or check Web object. */
          /* If checking syntax of a .cls file, send the classtype 
           * with the File_name, delimited by "|":U */
          RUN adeweb/_webcom.w ( 
              ?, Broker_URL, 
              File_Name + 
                (IF p_Action = "check-syntax" AND isClass 
                 THEN "|":U + ClassType ELSE "":U), 
              Run_Msg, OUTPUT Rel_Name, INPUT-OUTPUT Comp_File ).
          IF RETURN-VALUE BEGINS "ERROR:":U THEN
          DO:
              /* check for .cls-related errors */
              /* look for IS_CLASS_ERROR and IS_INTERFACE_ERROR */
              isClassError = 
                  INDEX(RETURN-VALUE,{&IS_CLASS_ERROR}) > 0 OR
                  INDEX(RETURN-VALUE,{&IS_INTERFACE_ERROR}) > 0.
              /* look for WRONG_CLASS_TYPE_ERROR or WRONG_INTERFACE_TYPE_ERROR */
              isWrongClass = 
                  INDEX(RETURN-VALUE,{&WRONG_CLASS_TYPE_ERROR}) > 0 OR
                  INDEX(RETURN-VALUE,{&WRONG_INTERFACE_TYPE_ERROR}) > 0.
              /* if we have IsClassError and this is not a .cls AND
               * this is an untitled edit buffer */
              IF (isClassError AND NOT isClass AND 
                  pw_Editor:NAME BEGINS {&PW_Untitled} ) THEN
              DO:
                  /* mark this as a class with an empty ClassType */
                  ASSIGN 
                      ClassType = ""
                      isClass = TRUE.
                  /* remove the previous Comp_File */
                  OS-DELETE VALUE(Comp_File) NO-ERROR.
                  NEXT SAVE_AND_COMPILE_BLOCK.
              END.
              IF (isClass AND ClassType = "" AND isWrongClass) THEN
              DO:
                  /* check for ERROR:CLASSTYPE:<ClassType> in the RETURN-VALUE */
                  IF (NUM-ENTRIES(ENTRY(1,RETURN-VALUE," ":U),":":U) > 2) THEN
                      ClassType = ENTRY(3,ENTRY(1,RETURN-VALUE," ":U),":").
                  ELSE
                      ClassType = "".  /* something went wrong, classtype was not sent */
                  /* remove the previous Compile_Filename */
                  OS-DELETE VALUE(Comp_File) NO-ERROR.
                  NEXT SAVE_AND_COMPILE_BLOCK.
              END.
              ELSE 
              RUN returnValue (RETURN-VALUE, pw_Editor:NAME, Run_Action, 
                               OUTPUT Dlg_Answer).
          END.  /* if RETURN-VALUE BEGINS "ERROR:" */
          ELSE IF p_Action eq "CHECK-SYNTAX":U THEN
            MESSAGE "Syntax is correct."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END.  /* if run or check remote web file */
        
        /* Compile the contents of the editor widget. */
        ELSE DO:
          RUN adecomm/_pwcmpfl.p (INPUT  pw_Editor      /* Editor handle.   */ ,
                                  INPUT  "CMP_NOERROR"  /* Messages Dest.   */ ,
                                  INPUT  Comp_File      /* Compile file.    */ ,
                                  INPUT  ""             /* Messages file.   */ ,
                                  OUTPUT Comp_Stopped   /* Compile Stopped? */ ).
    
          /* Force out of the DO ON STOP and perform temp file deletions. */
          IF Comp_Stopped THEN STOP.
        END.
    
        ASSIGN Error_Found = COMPILER:ERROR.
        IF ( Error_Found = TRUE ) THEN
        DO:
            ASSIGN 
                isClassError = NO
                isWrongClass = NO.
            /* Check for .cls-related errors */
            DO ictr = 1 TO ERROR-STATUS:NUM-MESSAGES:
              ASSIGN
                isClassError = 
                  (IF ERROR-STATUS:GET-NUMBER(ictr) = {&IS_CLASS_ERROR_NUM} OR
                      ERROR-STATUS:GET-NUMBER(ictr) = {&IS_INTERFACE_ERROR_NUM}
                   THEN TRUE ELSE isClassError)
                isWrongClass = 
                  (IF ERROR-STATUS:GET-NUMBER(ictr) = {&WRONG_CLASS_TYPE_ERROR_NUM} OR
                      ERROR-STATUS:GET-NUMBER(ictr) = {&WRONG_INTERFACE_TYPE_ERROR_NUM}
                   THEN TRUE ELSE isWrongClass).
            END.
            /* if this is not a .cls file and is untitled */
            IF (NOT isClass AND File_Name BEGINS {&PW_Untitled} ) THEN 
            DO:
                /* if the compiler tells us this is a class */
                IF (IsClassError) THEN
                DO:
                  ASSIGN 
                    isClass = TRUE
                    ClassType = "".
                  /* remove the previous Comp_File */
                  OS-DELETE VALUE(Comp_File).
                  /* re-run SAVE_AND_COMPILE_BLOCK */
                  NEXT SAVE_AND_COMPILE_BLOCK.
                END. /* if isClassError */
            END.  /* if not isClass and untitled */
            /* if this is a class, but the last compile showed the wrong classtype 
             * 20050809-041 Only do this if the Wrong Class Type error was raised 
             * on the same file that was being compiled, in case an interface or
             * ancestor class gives the same error. */                      
            ELSE IF (isClass AND isWrongClass AND
                     COMPILER:FILE-NAME = Comp_File) THEN
            DO:
                /* if the previous classtype is "" (just-loaded .cls)
                 * OR the file is an untitled edit buffer containing OO4GL
                 * OR classtype is a subset of COMPILER:CLASS-TYPE (user qualified the classtype)
                 * then we want to save the classname, and redo the save */
                IF (ClassType = "" OR 
                    (File_Name BEGINS {&PW_Untitled}) OR
                    IsValidClassChange(
                        IF (File_Name BEGINS {&PW_Untitled}) THEN ? ELSE File_Name,
                        ClassType,COMPILER:CLASS-TYPE))
                    THEN
                DO:
                    ClassType = COMPILER:CLASS-TYPE.
                    /* remove the previous Comp_File */
                    OS-DELETE VALUE(Comp_File).
                    NEXT SAVE_AND_COMPILE_BLOCK.
                END.
            END.  /* if isClass and ClassType = "" and isWrongClass */

            /* Assign these COMPILER widget attributes to vars to prevent their
               current values from being overwritten by a session compile during
               development.
            */
            ASSIGN Error_File   = COMPILER:FILENAME
                   Error_Row    = COMPILER:ERROR-ROW
                   Error_Col    = COMPILER:ERROR-COLUMN
                   Error_Offset = COMPILER:FILE-OFFSET
                   . /* END ASSIGN */      
            /* If the error occurs in an include file, the names here will not be
               the same.  When this happens, we cannot move to the line with the
               error, because the COMPILER widget is reporting the error values
               relative to the include file, not the file being compiled.  So,
               only move the cursor if the error occurred in the file being
               compiled.
            */
            IF ( Error_File = Comp_File ) THEN
            DO:
              &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
               /* LARGE MSW editor does not support :CURSOR-OFFSET. */
               ASSIGN pw_Editor:CURSOR-LINE = Error_Row WHEN Error_Row <> 0
                      pw_Editor:CURSOR-CHAR = Error_Col WHEN Error_Col <> 0.
              &ELSE
               ASSIGN pw_Editor:CURSOR-OFFSET = Error_Offset
                                                WHEN Error_Offset <> 0.
              &ENDIF
            END.
        END.    
        /* if this is a class, and we previously didn't know the classtype, 
         * record it now */
        IF (isClass AND ClassType <> ? AND OldClassType <> ClassType) THEN
        DO:
            /* save .cls related information back to the PRIVATE-DATA */
            ASSIGN
                Private_Data = pw_Editor:PRIVATE-DATA
                ENTRY( {&PW_Class_Type_Pos}, Private_Data ) = ClassType
                /* ENTRY( {&PW_Compile_file_Pos}, Private_Data ) = Comp_File */
                pw_Editor:PRIVATE-DATA = Private_Data.
                
        END.
        /* if we get to here, the compile completed. Leave SAVE_AND_COMPILE_BLOCK */
        LEAVE SAVE_AND_COMPILE_BLOCK.
    END.  /* SAVE_AND_COMPILE_BLOCK */
        
    /* Remove the wait cursor. */
    RUN adecomm/_setcurs.p (INPUT "":U).

    /* WARNING:
       DO NOT USE THE NO-ERROR OPTION ON ANY STATEMENT BETWEEN
       RUN adecomm/_pwcmpfl.p AND THIS CALL TO _errmsgs.p.
       PROCEDURE _errmsgs.p relies on the ERROR-STATUS HANDLE
       TO CORRECTLY REPORT ERRORS.
    */
    /* Display preprocessor and error messages, if any. */
    IF NOT Web_File AND NOT Html_File THEN
      RUN adecomm/_errmsgs.p (INPUT pw_Window ,
                              INPUT Error_File ,
                              INPUT Comp_File ).
        
    IF Error_Found = FALSE AND NOT Web_File AND NOT Html_File THEN
    DO: /* No error. */
    CASE p_Action:

      WHEN "RUN":U THEN
      DO:
        RUN adecomm/_wfrun.p
            ( INPUT "A " + pw_Window:NAME + "," + STRING(pw_Window),
              OUTPUT Cannot_Run ).
        IF Cannot_Run = FALSE THEN
        Execute_Block:
        DO ON STOP UNDO, RETRY:
            ASSIGN h_tool = h_ade_tool.
            /* set up the file to run
             * for a .cls file, this will not be the compile file */
            Run_File = ENTRY( {&PW_Compile_file_Pos}, pw_Editor:PRIVATE-DATA ).
            IF NOT RETRY THEN
            DO:
                IF (isClass) THEN
                DO:
                    /* If .cls file is not saved */
                    IF File_Modified THEN
                    DO:
                        lOK = TRUE.
                        /* get the AutoSaveCls option from the registry */
                        /* This is not very elegant, hitting the registry each
                         * time the user runs the code to check for the AutoSaveCls
                         * value, but as the Procedure Window can run outside AB, 
                         * there is no "global" place to read and write it.
                         */
                        GET-KEY-VALUE SECTION "ProAB":U KEY "AutoSaveCls":U VALUE cAutoSaveCls.
                        lAutoSaveCls = (IF cAutoSaveCls = "Yes":U THEN YES ELSE NO).

                        /* if untitled or not autosave, offer to save */
                        IF (pw_Editor:NAME BEGINS {&PW_Untitled} OR
                            NOT lAutoSaveCls) THEN
                        DO:
                            /* offer to save(-as) */
                            RUN AskToSaveClass(
                                INPUT (IF pw_Editor:NAME BEGINS {&PW_Untitled} THEN YES ELSE NO) /* untitled */,
                                INPUT ClassType, /* package name */
                                INPUT-OUTPUT lAutoSaveCls   /* AutoSaveCls setting  */,
                                OUTPUT lOK).
                            /* if not save, abort run */
                            IF (NOT lOK) THEN
                            DO:
                                /* abort run */
                                LEAVE Execute_Block.
                            END.
                            ELSE IF lAutoSaveCls THEN
                                /* save the AutoSaveCls setting back to the registry */
                                PUT-KEY-VALUE SECTION "ProAB":U 
                                    KEY "AutoSaveCls":U 
                                    VALUE (IF lAutoSaveCls THEN "Yes":U ELSE "No":U) NO-ERROR.
                        END.  /* if untitled or not lAutoSaveCls */
                        /* record whether this was an untitled edit buffer */
                        lOK = (IF pw_Editor:NAME BEGINS {&PW_Untitled} THEN TRUE ELSE FALSE).
                        /* save the file. _pwsave.p will automagically run SaveAs if necessary */
                        RUN adecomm/_pwsave.p (INPUT pw_Editor).
                        /* if the save failed, or was cancelled, leave.
                         * The only reliable way to tell if the save failed is 
                         * if pw_Editor:MODIFIED is true, as _pwsave.p does not
                         * return an error if the user cancels the save-as */
                        IF pw_editor:MODIFIED THEN
                        DO:
                            /* save failed, abort run */
                            LEAVE Execute_Block .
                        END.
                        /* TO DO: if this was an untitled edit buffer, do we need to reset some values? */
                    END.  /* if File_Modified */
                    /* search for this class in the PROPATH */
                    RUN FindClassInPropath(
                        INPUT ClassType,  /* expected classtype */
                        INPUT pw_Editor:NAME, /* name of file */
                        OUTPUT lOK).
                    /* file was not in PROPATH, user aborted */
                    IF (NOT lOK) THEN
                    DO:
                        /* abort run */
                        LEAVE Execute_Block.
                    END.
                    /* build the run stub here */
                    RUN CreateClassStub(Run_File,INPUT ClassType).
                    IF (RETURN-VALUE <> ?) THEN
                    DO:
                        /* TO DO: tidy this up */
                        MESSAGE RETURN-VALUE
                            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                        LEAVE Execute_Block.
                    END.
                END.  /* if isClass */

              RUN disable_widgets IN h_tool NO-ERROR.
              ASSIGN pw_Window:VISIBLE = FALSE.
              RUN adecomm/_runcode.p
                  ( INPUT Run_File ,
                    INPUT "_PAUSE":U /* Run Flags */ ,
                    INPUT ?     /* p_Stop_Widget */ ,
                    OUTPUT app_handle ) .
            END. 
            RUN enable_widgets IN h_tool NO-ERROR.
            ASSIGN wfRunning = "".
            ASSIGN pw_Window:VISIBLE = TRUE.
         END.  /* Execute_Block */
      END. /* WHEN "RUN":U */

      WHEN "CHECK-SYNTAX":U THEN
         MESSAGE "Syntax is correct."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END CASE.
    END. /* Error_Found = FALSE */
END. /* MAIN_BLOCK - DO ON STOP */

OS-DELETE VALUE ( Comp_File ).
IF (isClass AND Run_File <> ? ) THEN
    OS-DELETE VALUE ( Run_File ) NO-ERROR.
/* remove any directory created for a .cls file */
IF ClassTmpDir <> "" THEN
    OS-DELETE VALUE ( ClassTmpDir ) RECURSIVE.
  
/* If compile stopped, ensure wait cursor is removed. */
IF Comp_Stopped THEN
  RUN adecomm/_setcurs.p (INPUT "":U).

APPLY "ENTRY":U TO pw_Editor.

/* .cls file handling */
{ adecomm/pcmpcls.i }

/* RETURN-VALUE error processing */
{ adecomm/rtnval.i }

{ adecomm/peditor.i }   /* Editor procedures. */

/* _pwrun.p - end of file. */
