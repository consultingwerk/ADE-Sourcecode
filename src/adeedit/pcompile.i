/*********************************************************************
* Copyright (C) 2005,2015 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
  pcompile.i
  Compile Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/


PROCEDURE RunFile.
/*--------------------------------------------------------------------------
    Purpose:    Executes the RUN command, compiling and executing the code
                in the edit buffer.

    Run Syntax: RUN RunFile ( INPUT p_Mode ) .

    Parameters:
        Input Parameters
            p_Mode (CHAR)
                RUN          :  Compile and run current buffer. (DEFAULT)
                CHECK-SYNTAX :  Compile only (check syntax) the current buffer.
                DEBUG        :  Compile debug the current buffer.
    Description:

    Notes:
---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Mode  AS CHAR    INIT "RUN" NO-UNDO .

  DEFINE VARIABLE Buffer_Modified  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE rf_Action        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Temp_Logical     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Return_Status    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Error_File_Name  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Compiler_Error   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Compiler_Stopped AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Compiler_ClassType AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Read_OK          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE wfrun            AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Save_OK          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE isClass          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE setClass         AS LOGICAL   INIT FALSE NO-UNDO.
  DEFINE VARIABLE isClassError     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE isWrongClass     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE ClassType        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE ipos             AS INTEGER     NO-UNDO.
  DEFINE VARIABLE Run_Filename     AS CHARACTER   INIT ? NO-UNDO.
  DEFINE VARIABLE lOK              AS LOGICAL     NO-UNDO.

  /* --- Begin SCM changes --- */
  DEFINE VARIABLE scm_ok             AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE scm_action         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE scm_context        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE scm_filename       AS CHARACTER NO-UNDO.
  /* --- End SCM changes ----- */

  /* We don't need p_Window because buffer handles are unique system-wide. */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = ProEditor.
  ASSIGN 
      isClass = (IF Edit_Buffer.Class_Type <> ? THEN YES ELSE NO)
      Compile_FileName = Edit_Buffer.Compile_Name
      ClassType = Edit_Buffer.Class_Type.
  
  RunFile_STOP:
  DO ON STOP UNDO RunFile_STOP , RETRY RunFile_STOP:
 
    IF NOT RETRY
    THEN DO:

      Quit_Pending = FALSE .  /* System Var assignment. */
      rf_Action = ( IF p_Mode = "CHECK-SYNTAX" THEN "check"
                    ELSE LC(p_Mode) /* run or debug */ ).

      IF ProEditor:EMPTY
      THEN DO:
        MESSAGE "Nothing in this buffer to " + rf_Action + "."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN.
      END.

      IF CAN-DO( "RUN,DEBUG" , p_Mode )
      THEN DO:
          /* Test if just a QUIT statement. If so, execute File->Exit. */
          RUN QuitBuffer ( INPUT ProEditor , OUTPUT Quit_Pending ) .
          IF Quit_Pending THEN
          DO:
              RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) . 
              RUN ExitEditor.
              RETURN.
          END.
      END.


      IF CAN-DO( "RUN,DEBUG" , p_Mode )
      THEN RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , 
                              "Compiling procedure..." , "WAIT" ).
      ELSE RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , 
                              "Checking syntax..." , "WAIT" ).
  
      ASSIGN
        Buffer_Modified = ProEditor:MODIFIED
      . /* END-ASSIGN */
  
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
     */

      SAVE_AND_COMPILE_BLOCK:
      REPEAT:

          /**** SAVE FILE ****/          
          /* First, get the correct Compile_Filename */

          /* If this is an untitled edit buffer, or not a .cls file*/
          IF (NOT isClass) THEN
              /* save to the default unique filename */
              Compile_Filename = Edit_Buffer.Compile_Name.
          ELSE 
          DO:
              /* this is a .cls file */
              
              /* if this is an untitled edit buffer, or a .cls file we just loaded */
              IF (ClassType = "") THEN
              DO:
                  /* replace .ped with .cls */
                  ipos = R-INDEX(Compile_Filename,".ped").
                  IF ipos > 0 THEN
                      SUBSTRING(Compile_Filename,ipos) = ".cls".
              END.
              ELSE
              DO:
                  /* this is a .cls file we have compiled before. */

                  /* If we don't have a Class_TmpDir, create one */
                  IF (Edit_Buffer.Class_TmpDir = ?) THEN
                      RUN GetUniqueDir(SESSION:TEMP-DIR,"p",?,OUTPUT Edit_Buffer.Class_TmpDir).

                  /* create the directories to store the ClassType
                   * beneath Class_TmpDir */
                  RUN GetClassCompileName(
                      Edit_Buffer.Class_TmpDir,
                      /* TO DO: Check if this is the correct way to get the filename, and "Untitled:" */
                      (IF ProEditor:PRIVATE-DATA BEGINS Untitled THEN ? ELSE ProEditor:PRIVATE-DATA),
                      ClassType,
                      OUTPUT Compile_Filename).
              END.
          END.  /* if isClass */

          /* save the file to the nominated filename */
          Save_OK = ProEditor:SAVE-FILE(Compile_FileName).

          /* adecomm/peditor.i */
          RUN SetEdBufType (INPUT ProEditor, INPUT ProEditor:PRIVATE-DATA).

          IF ( NOT Save_OK )
          THEN DO:
            RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
            MESSAGE "Unable to create compile file. Compilation cancelled."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* if this is a .cls file, we want to remove the 
             * temp dir structure we created */
            IF (isClass AND Edit_Buffer.Class_TmpDir <> ?) THEN
                OS-DELETE RECURSIVE VALUE(Edit_Buffer.Class_TmpDir) .
            RETURN.
          END.
          ProEditor:MODIFIED = Buffer_Modified. /* Reset due to Save-File. */

          IF ( SEARCH( Compile_FileName ) = ? )
          THEN DO:
            RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

            MESSAGE "Cannot " + rf_Action + ". Unable to find temporary file."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* if this is a .cls file, we want to remove the 
             * temp dir structure we created */
            IF (isClass AND Edit_Buffer.Class_TmpDir <> ?) THEN
                OS-DELETE RECURSIVE VALUE(Edit_Buffer.Class_TmpDir) .
            RETURN.
          END.


          /* NOTE: Now that we have SAVE_AND_COMPILE_BLOCK, this SCM event could 
           * fire up 3 times or one program. However, we cannot really take 
           * it out of the loop, as it sits between the save and compile, 
           * both integral parts of SACB */ 
          /* --- Begin SCM changes --- */
          ASSIGN
              scm_action   = "Before-" + p_Mode  /* RUN, CHECK-SYNTAX, DEBUG */
              scm_context  = STRING( ProEditor )
              scm_filename = ProEditor:PRIVATE-DATA.
          RUN adecomm/_adeevnt.p 
              (INPUT "Editor",
               INPUT scm_action, INPUT scm_context, scm_filename,
               OUTPUT scm_ok ).
          IF NOT scm_ok THEN
          DO:
            RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ).
            RETURN.
          END.
          /* --- End SCM changes ----- */

          /**** COMPILE FILE ****/
          COMPILE_BLOCK:
          REPEAT ON STOP UNDO COMPILE_BLOCK, RETRY COMPILE_BLOCK:
              IF NOT RETRY
              THEN DO:
                  /* Clear out previous compiler messages. */
                  Compiler_Messages:SCREEN-VALUE IN FRAME Compiler-Frame = "" .
                  OUTPUT TO VALUE(Compiler_Message_Log) UNBUFFERED KEEP-MESSAGES.
                  COMPILE VALUE( Compile_FileName ).
              END.
              /* Assign here to avoid problems with session compiles changing the
              COMPILER widget attributes. */
              Compiler_Error   = COMPILER:ERROR .
              Compiler_Stopped = COMPILER:STOPPED.
              Compiler_ClassType = COMPILER:CLASS-TYPE. 
              OUTPUT CLOSE.

              /* .cls support - only if not stopped and there was an error */
              IF (Compiler_Stopped = FALSE AND Compiler_Error = TRUE) THEN
              DO:
                  ASSIGN Read_OK = Compiler_Messages:READ-FILE(Compiler_Message_Log)
                         NO-ERROR.
                  IF (Read_OK) THEN
                  DO:
                      /* look for IS_CLASS_ERROR and IS_INTERFACE_ERROR */
                      isClassError = 
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&IS_CLASS_ERROR}) > 0 OR
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&IS_INTERFACE_ERROR}) > 0 OR
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&IS_ENUM_ERROR}) > 0.

                      /* look for WRONG_CLASS_TYPE_ERROR or WRONG_INTERFACE_TYPE_ERROR */
                      isWrongClass = 
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&WRONG_CLASS_TYPE_ERROR}) > 0 OR
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&WRONG_INTERFACE_TYPE_ERROR}) > 0 OR
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&WRONG_ENUM_TYPE_ERROR}) > 0.
                      /* if this is an untitled edit buffer */
                      IF (NOT isClass AND Edit_Buffer.hBuffer:PRIVATE-DATA BEGINS untitled) THEN
                      DO:
                          /* if a class or interface error */
                          IF isClassError THEN
                          DO:
                              /* mark this as a class with an empty ClassType */
                              ASSIGN 
                                  ClassType = ""
                                  isClass = TRUE.
                              /* remove the previous Compile_Filename */
                              OS-DELETE VALUE(Compile_Filename).
                              NEXT SAVE_AND_COMPILE_BLOCK.
                          END.
                      END.
                      /* If this is a class, but the compile showed the classtype was wrong 
                       * 20050809-041 Only do this if the Wrong Class Type error was raised 
                       * on the same file that was being compiled, in case an interface or
                       * ancestor class gives the same error. */                      
                      IF (isClass AND isWrongClass AND 
                          COMPILER:FILE-NAME = Compile_Filename) THEN
                      DO:
                          /* if the previous classtype is "" (just-loaded .cls)
                           * OR the file is an untitled edit buffer containing OO4GL
                           * OR classtype is a subset of COMPILER:CLASS-TYPE (user qualified the classtype)
                           * then we want to save the classname, and redo the save */
                          IF (ClassType = "" OR 
                              Edit_Buffer.hBuffer:PRIVATE-DATA BEGINS untitled OR
                              IsValidClassChange(
                                  IF (Edit_Buffer.hBuffer:PRIVATE-DATA BEGINS untitled) THEN ? ELSE Edit_Buffer.hBuffer:PRIVATE-DATA,
                                  ClassType,COMPILER:CLASS-TYPE))
                              THEN
                          DO:
                              ClassType = COMPILER:CLASS-TYPE.
                              /* remove the previous Compile_Filename */
                              OS-DELETE VALUE(Compile_Filename).
                              NEXT SAVE_AND_COMPILE_BLOCK.
                          END.
                          /* otherwise, fall through and display the wrong class error message */
                      END.
                  END.  /* if Read_OK */
              END.  /* if compiler_stopped */
              LEAVE SAVE_AND_COMPILE_BLOCK.
          END.  /* COMPILE_BLOCK */

      END.  /* SAVE_AND_COMPILE_BLOCK */
  
      RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

      IF ( Compiler_Stopped = FALSE ) /* User did not abort compile. */
      THEN DO:

          /*-------------------------------------------------------------
             Read the compiler messages file always.  Some messages can be
             generated (like warning and preprocessor messages) without
             raising the COMPILER:ERROR flag.
          -------------------------------------------------------------*/
          ASSIGN Read_OK = Compiler_Messages:READ-FILE(Compiler_Message_Log)
                 NO-ERROR.
          IF (Read_OK = FALSE) OR (ERROR-STATUS:ERROR = TRUE) OR
             (ERROR-STATUS:GET-MESSAGE(1) <> "")
          THEN MESSAGE "Unable to read Compiler Messages file."
                       VIEW-AS ALERT-BOX WARNING BUTTONS OK.

          IF ( Compiler_Error = TRUE ) 
          THEN DO:
              Return_Status = YES.
              IF ( COMPILER:FILENAME <> Compile_FileName )
                 AND ( SEARCH(COMPILER:FILENAME) <> SEARCH(Compile_FileName) )
              THEN DO:
                   RUN GetFile ( INPUT COMPILER:FILENAME ,
                                 INPUT-OUTPUT ProEditor ,
                                 OUTPUT Return_Status ).
              END.

              IF ( Return_Status = YES ) THEN
              &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                 /* LARGE MSW editor does not support :CURSOR-OFFSET. */
                 ASSIGN ProEditor:CURSOR-LINE = COMPILER:ERROR-ROW 
                        ProEditor:CURSOR-CHAR = COMPILER:ERROR-COLUMN
                        NO-ERROR.
              &ELSE
                 ASSIGN ProEditor:CURSOR-OFFSET = COMPILER:FILE-OFFSET NO-ERROR.
              &ENDIF
          END.

          /* if this is a .cls file, we want to set the Class_Type.
           * We want to do this if:
           * - this is an untitled edit buffer
           * - we opened the .cls file, and this is the first time compiling
           * However, we DON'T want to do this if:
           * - this is a .cls file, and the basename of the file is 
           *   is different from the basename of the class-type.
           *   If these are different, it means the user saved the file
           *   as foo.cls, when the file was defined as CLASS bar.
           *   We should be saving the file as foo.cls, as the user 
           *   wanted, not as we know it should be.
           */
          IF (isClass AND Edit_Buffer.Class_Type = "" AND 
              ClassType <> ?) THEN
              Edit_Buffer.Class_Type = ClassType.

          /* Show any compiler messages (warnings, etc) if any. */
          IF NOT Compiler_Messages:EMPTY 
              THEN RUN CompilerMessages.

          IF ( Compiler_Error <> TRUE ) AND CAN-DO( "RUN,DEBUG" , p_Mode )
          THEN DO:
            /* check if a tool is already running a program */
            RUN adecomm/_wfrun.p (INPUT "Procedure Editor", OUTPUT wfrun).
            IF wfrun THEN RETURN. /* another tool is running a procedure */
            Execute_Block :
            DO ON STOP UNDO Execute_Block , LEAVE Execute_Block :
               /* set up the file to run. 
                * For a .cls, this is not the same Compile_Filename */
               Run_Filename = Edit_Buffer.Compile_Name.
               /* .cls RUN processing */
               IF (isClass) THEN
               DO:
                   /* If .cls file is not saved */
                   IF Buffer_Modified THEN
                   DO:
                       /* if untitled or not autosave, offer to save */
                       IF (ProEditor:PRIVATE-DATA BEGINS Untitled OR
                           NOT Sys_Options.SaveClass_BeforeRun) THEN
                       DO:
                           lOK = TRUE.
                           /* offer to save(-as) */
                           RUN AskToSaveClass(
                               INPUT (IF ProEditor:PRIVATE-DATA BEGINS Untitled THEN YES ELSE NO) /* untitled */,
                               INPUT ClassType,  /* package name */
                               INPUT-OUTPUT Sys_Options.SaveClass_BeforeRun   /* AutoSaveCls setting  */,
                               OUTPUT lOK).
                           /* if not save, abort run */
                           IF (NOT lOK) THEN
                           DO:
                               /* abort run */
                               LEAVE Execute_Block.
                           END.
                           ELSE
                           DO:
                               /* Only the AutoSaveCls if using GUI */
                               &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                               /* save the Sys_Options.SaveClass_BeforeRun value */
                               PUT-KEY-VALUE SECTION KeyValue_Section 
                                   KEY "AutoSaveCls" 
                                   VALUE (IF Sys_Options.SaveClass_BeforeRun THEN "Yes" ELSE "") NO-ERROR.
                               &ENDIF
                           END.
                       END.  /* if untitled or not autosave */
                       /* record whether this was an untitled edit buffer */
                       lOK = (IF ProEditor:PRIVATE-DATA BEGINS Untitled THEN TRUE ELSE FALSE).
                       /* save the file. SaveFile will automagically run SaveAs if necessary */
                       RUN SaveFile(ProEditor).
                       IF RETURN-VALUE = "_CANCEL" THEN
                       DO:
                           /* TO DO: error, save failed, abort run? */
                           LEAVE Execute_Block.
                       END.
                       /* if this was an untitled edit buffer, 
                        * we need to reset some values after the save-as */
                       IF lOK THEN
                           Edit_buffer.Class_Type = ClassType.
                   END.  /* if Buffer_Modified */
                   /* search for this class in the PROPATH */
                   RUN FindClassInPropath(
                       INPUT ClassType,  /* expected classtype */
                       INPUT ProEditor:PRIVATE-DATA, /* name of file */
                       OUTPUT lOK).
                   /* file was not in PROPATH, user aborted */
                   IF (NOT lOK) THEN
                   DO:
                       /* abort run */
                       LEAVE Execute_Block.
                   END.
                   /* build the run stub here */
                   RUN CreateClassStub(Run_Filename,INPUT ClassType).
                   IF (RETURN-VALUE <> ?) THEN
                   DO:
                       /* TO DO: tidy this up */
                       MESSAGE RETURN-VALUE
                           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                       LEAVE Execute_Block.
                   END.
               END.  /* if isClass */
               IF ( p_Mode = "DEBUG" )
               THEN DO:
                    RUN DebugInit .
                    /* Use -1 to set break at first executable line in
                       main PROCEDURE. */
                    /* TO DO: for a .cls file, debug the original filename, 
                     * NOT the compile_filename */
                    RUN DebugSetBreakpoint (INPUT Compile_FileName ,
                                            INPUT -1 , TRUE /* Set Break */ ).
               END.
               /* No compiler errors, so run the program. */
               RUN ExecuteRun 
                 ( INPUT win_Proedit, 
                   INPUT Run_Window, 
                   INPUT Editor_Name + " - Run",
                   INPUT Run_FileName ,
                   INPUT FALSE /* Does not force a no-pause after run */ ).
            END. /* ON STOP Execute_Block */  
    
            /* Clear Debugger if Compile->Debug executed. */
            IF ( p_Mode = "DEBUG" ) THEN RUN DebugClear.
            
            ASSIGN wfRunning = "". /* reset flag */
          END.
          ELSE IF ( Compiler_Error <> TRUE ) AND ( p_Mode = "CHECK-SYNTAX" )
          THEN DO:
               MESSAGE "Syntax is correct." 
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
          END.
        END. /* COMPILER:STOPPED */
      END. /* IF NOT RETRY */
  
      OUTPUT CLOSE.
      OS-DELETE VALUE( Compile_FileName ).
      OS-DELETE VALUE( Compiler_Message_Log ).
      /* .cls support - remove temp dir. 
       * TO DO: Make sure this does not delete stuff it shouldn't */      
      IF (Edit_Buffer.Class_TmpDir <> ?) THEN
          OS-DELETE VALUE( Edit_Buffer.Class_TmpDir) RECURSIVE.
      /* if a .cls, remove the Run_FileName as well */
      IF (isClass AND Run_Filename <> ?) THEN
          OS-DELETE VALUE( Run_Filename ).

      /* --- Begin SCM changes --- */
      ASSIGN scm_action = p_Mode. /* RUN, CHECK-SYNTAX, DEBUG */
      RUN adecomm/_adeevnt.p 
          (INPUT "Editor",
           INPUT scm_action, INPUT scm_context, INPUT scm_filename,
           OUTPUT scm_ok ).
      /* --- End SCM changes ----- */

      RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
      RETURN.  /* Use to reset RETURN-VALUE function to Null (""). */

  END. /* RunFile_STOP DO ON STOP */
    
      
END PROCEDURE.        /* RunFile */



PROCEDURE CompilerMessages.
 
/*--------------------------------------------------------------------------
    Purpose:            Displays most recently generated compiler messages.

    Run Syntax:     RUN CompilerMessages.

    Parameters:

    Description:
    Notes:
 
---------------------------------------------------------------------------*/

  /* Help triggers */
  ON CHOOSE OF CW_Help_Button IN FRAME Compiler-Frame
     OR HELP OF FRAME Compiler-Frame
    RUN adecomm/_kwhelp.p ( INPUT Compiler_Messages:HANDLE, 
                            INPUT "edit"    , 
                            INPUT {&Compiler_Message_Dialog_Box} ).

  IF Compiler_Messages:EMPTY
  THEN DO:
    MESSAGE "No Compiler Messages to display."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
 
  /* Change temp file name in messages to null and make read-only. */
  ASSIGN System_Error = Compiler_Messages:REPLACE( Compile_FileName , 
                        "" , FIND-GLOBAL ) IN FRAME Compiler-Frame

         Compiler_Messages:READ-ONLY IN FRAME Compiler-Frame     = TRUE.

  ENABLE ALL EXCEPT CW_Help_Button WITH FRAME Compiler-Frame.
  ENABLE CW_Help_Button {&WHEN_HELP} WITH FRAME Compiler-Frame.
  
  UPDATE_BLK:
  DO ON STOP UNDO UPDATE_BLK, LEAVE UPDATE_BLK
     ON ERROR UNDO UPDATE_BLK, LEAVE UPDATE_BLK
     ON ENDKEY UNDO UPDATE_BLK, LEAVE UPDATE_BLK:
    UPDATE CW_Close_Button
           GO-ON ( GO,WINDOW-CLOSE )
           WITH FRAME Compiler-Frame.
  END.
    
  HIDE FRAME Compiler-Frame NO-PAUSE.
  DISABLE ALL WITH FRAME Compiler-Frame.
  APPLY "ENTRY" TO ProEditor.

END PROCEDURE. /* CompilerMessages */


PROCEDURE DebugInit.
/*--------------------------------------------------------------------------
    Purpose:        Initializes Progress Debugger.

    Run Syntax: RUN DebugInit.
    
    Parameters:
    Description:
    Notes:
---------------------------------------------------------------------------*/

  DEFINE VAR Return_Value AS LOGICAL NO-UNDO.
  
  DO:
    /* INITIATE() is a NO-OP if Debugger is already initiated. */
    ASSIGN Return_Value             = DEBUGGER:INITIATE()
    . /* END ASSIGN */
  END.
  
END PROCEDURE.


PROCEDURE DebugSetBreakpoint.
/*--------------------------------------------------------------------------
    Purpose:        Sets or cancels a Debugger breakpoint at specified line in
                specified procedure.

    Run Syntax: RUN DebugSetBreakpoint ( INPUT p_Proc_Name ,
                                         INPUT p_Line_Num  , 
                                         INPUT p_Break_State ).

    Parameters:
        INPUT
            p_Proc_Name (CHAR) - 
                Name of procedure in which to set or cancel breakpoint.
            p_Line_Num  (INTE) - 
                Line within p_Proc_Name at which to set or cancel a 
                breakpoint.
            p_Break_State(LOG) - 
                FALSE : Cancel breakpoint, if one is there.
                TRUE  : Set breakpoint at line in proc.

    Description:

    Notes:
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Proc_Name   AS CHARACTER NO-UNDO .
  DEFINE INPUT PARAMETER p_Line_Num    AS INTEGER   NO-UNDO .  
  DEFINE INPUT PARAMETER p_Break_State AS LOGICAL   NO-UNDO .

  DEFINE VAR Return_Value AS LOGICAL NO-UNDO.
  
  IF ( p_Break_State = TRUE ) /* Setting Break */
  THEN DO:
    ASSIGN Return_Value = DEBUGGER:SET-BREAK( p_Proc_Name , p_Line_Num )
    . /* END ASSIGN */
  END.
  ELSE DO:
    ASSIGN
      Return_Value = DEBUGGER:CANCEL-BREAK( p_Proc_Name , p_Line_Num )
    . /* END ASSIGN */
  END.
  
END PROCEDURE.


PROCEDURE DebugClear.
/*--------------------------------------------------------------------------
    Purpose:        Resets Debugger state by clearing breaks, etc.

    Run Syntax: RUN DebugClear.
    Parameters:
    Description:
    Notes:
---------------------------------------------------------------------------*/
    
    DEFINE VAR Return_Status       AS LOGICAL NO-UNDO .
        
    ASSIGN
        DEBUGGER:VISIBLE = FALSE
        Return_Status    = DEBUGGER:CLEAR()
    . /* END ASSIGN. */
END PROCEDURE.


