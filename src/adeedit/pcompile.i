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
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

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
  DEFINE VARIABLE Read_OK          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE wfrun            AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Save_OK          AS LOGICAL   NO-UNDO.

  /* --- Begin SCM changes --- */
  DEFINE VARIABLE scm_ok             AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE scm_action         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE scm_context        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE scm_filename       AS CHARACTER NO-UNDO.
  /* --- End SCM changes ----- */

  

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
  
      Save_OK = ProEditor:SAVE-FILE(Compile_FileName).

      /* adecomm/peditor.i */
      RUN SetEdBufType (INPUT ProEditor, INPUT ProEditor:PRIVATE-DATA).

      IF ( NOT Save_OK )
      THEN DO:
        RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
        MESSAGE "Unable to create compile file. Compilation cancelled."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN.
      END.
      ProEditor:MODIFIED = Buffer_Modified. /* Reset due to Save-File. */
  
      IF ( SEARCH( Compile_FileName ) = ? )
      THEN DO:
        RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

        MESSAGE "Cannot " + rf_Action + ". Unable to find temporary file."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN.
      END.


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


      REPEAT ON STOP UNDO, RETRY:
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
          OUTPUT CLOSE.
          LEAVE.
      END.
  
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
               IF ( p_Mode = "DEBUG" )
               THEN DO:
                    RUN DebugInit .
                    /* Use -1 to set break at first executable line in
                       main PROCEDURE. */
                    RUN DebugSetBreakpoint (INPUT Compile_FileName ,
                                            INPUT -1 , TRUE /* Set Break */ ).
               END.
               /* No compiler errors, so run the program. */
               RUN ExecuteRun 
                 ( INPUT win_Proedit, 
                   INPUT Run_Window, 
                   INPUT Editor_Name + " - Run",
                   INPUT Compile_FileName ,
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
      OS-DELETE VALUE( Compile_FileName ) VALUE( Compiler_Message_Log ) .

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


