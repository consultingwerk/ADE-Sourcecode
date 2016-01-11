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

/*-----------------------------------------------------------------------------

    File        : _filname.p

    Syntax      :
        RUN adeshar/_filname.p 
         ( INPUT        p_Dlg_title ,    /* Dialog Title Bar */
           INPUT        p_PROG_portable, /* YES is \'s converted to /'s */
           INPUT        p_must_exist,    /* YES if file must exist */    
           INPUT        p_options,       /* Additional Options. */
           INPUT        p_filter1,       /* File Filter (eg. "Include") */
           INPUT        p_filespec1,     /* File Spec  (eg. *.i) */
           INPUT        p_help_tool,     /* ADE Tool (used for help call) */
           INPUT        p_help_context,  /* Context ID for HELP call */
           INPUT-OUTPUT p_File_Name ,    /* File Spec entered */
           OUTPUT       p_Return_Status  /* YES if user hits OK */
         ) .          
   
   NOTE: The parameter p_options allows us to add additional requirements
   to the file without having to change the calling convension.  
        p_options : a comma-delimited list of options including:
          "RUNNABLE" -- a file must be runnable.  That is, if the
                        user types in "test.w", we count it as existing
                        if test.r can be found.
          "USE-FILENAME" -- Use passed in filename for default instead of "progress.cst".

   Description :  File-name Dialog, where the user can type in any file
                  name.

  Input Output Parameters:
      p_File_Name        : File Reference name entered by user.


  Output Parameters:
      p_Return_Status    : Returns YES if user pressed OK; ? if user pressed
                           Cancel.

  Author       : Wm. T. Wood
  Date Created : 04/95

-----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER p_Dlg_title AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER p_PROG_portable AS LOGICAL NO-UNDO.
DEFINE INPUT        PARAMETER p_must_exist AS LOGICAL NO-UNDO.
DEFINE INPUT        PARAMETER p_options AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER p_filter1 AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER p_filespec1 AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER p_help_tool AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER p_help_context AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_File_Name AS CHAR FORMAT "X(256)" NO-UNDO.
DEFINE OUTPUT       PARAMETER p_Return_Status AS LOGICAL NO-UNDO.

/* ADE Standards Include */
&Scoped-define USE-3D    YES
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i }
{ adeuib/uibhlp.i }

IF NOT initialized_adestds
    THEN RUN adecomm/_adeload.p.

/* Help Context Definitions. */

/*--------------------------------------------------------------------------
  GET-FILE Definitions.
--------------------------------------------------------------------------*/
{ adeedit/dsysgetf.i }

/*--------------------------------------------------------------------------
  GET-FILE Procedures.
--------------------------------------------------------------------------*/
{ adeedit/psysgetf.i }

DEFINE VAR v_File_Name LIKE p_File_Name .

/* Define a dialog box                                          */

/* Definitions of the field level widgets                             */
DEFINE BUTTON btn_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO .
    
DEFINE BUTTON btn_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY .

DEFINE BUTTON btn_Browse LABEL "&Files..."
    {&STDPH_OKBTN} .

DEFINE BUTTON btn_Help  LABEL "&Help"
    {&STDPH_OKBTN} .

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE FS_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
DEFINE FRAME DIALOG-1
     SKIP( {&TFM_WID} )
     SPACE( {&HFM_WID} )
     p_File_Name LABEL "File &Name" VIEW-AS FILL-IN SIZE 50 BY 1 AT 4
        
    { adecomm/okform.i
        &BOX    ="FS_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) btn_Browse"
        &HELP   ="btn_Help" 
    }
    WITH OVERLAY NO-LABELS TITLE p_Dlg_Title
         VIEW-AS DIALOG-BOX THREE-D SIDE-LABELS
                 DEFAULT-BUTTON btn_OK
                 CANCEL-BUTTON  btn_Cancel.

  ASSIGN FRAME DIALOG-1:PARENT = ACTIVE-WINDOW.

    { adecomm/okrun.i
        &FRAME  = "FRAME DIALOG-1"
        &BOX    = "FS_Btn_Box"
        &OK     = "btn_OK"
        &HELP   = "btn_Help"
    }

/******************************************************************/
/*                     UI TRIGGERS                                */
/******************************************************************/
ON CHOOSE OF btn_Help IN FRAME DIALOG-1 OR HELP OF FRAME DIALOG-1 DO:
  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_adehelp.p (p_help_tool, "CONTEXT", p_help_context, ?).
  END.    
END.

ON GO OF FRAME DIALOG-1 DO:
    DEFINE VAR Focus_Widget      AS HANDLE.
    
    Focus_Widget = FOCUS.   
    DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY :    
        IF RETRY 
        THEN DO: 
            RUN ApplyEntry( Focus_Widget ). 
            RETURN NO-APPLY. 
        END.
        ELSE DO:
            RUN PressedOK ( OUTPUT p_Return_Status ).
            IF ( p_Return_Status = FALSE )
            THEN RUN ApplyEntry( Focus_Widget ).
        END.
    END.
END .

ON WINDOW-CLOSE OF FRAME DIALOG-1
  APPLY "END-ERROR" TO FRAME DIALOG-1.
    
ON CHOOSE OF btn_Cancel IN FRAME DIALOG-1
  RUN PressedCancel.

ON CHOOSE OF btn_Browse IN FRAME DIALOG-1 DO:
    DEFINE VAR Return_Status AS LOGICAL.
    DEFINE VAR Focus_Widget      AS WIDGET-HANDLE.
    
    Focus_Widget = FOCUS.   
    DO ON STOP UNDO, RETRY :    
        IF RETRY THEN RETURN NO-APPLY.
        ELSE DO:
            RUN BrowseFiles ( OUTPUT Return_Status ).
            IF ( Return_Status = TRUE )
            THEN 
                APPLY "ENTRY" TO btn_OK IN FRAME DIALOG-1.
            ELSE 
                APPLY "ENTRY" TO Focus_Widget .
        END.
    END.
    
END .


/****************************************************************
* Main Code Section                                             *
****************************************************************/

DO ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
    
    STATUS INPUT "".
    ASSIGN  p_Return_Status = FALSE  /* Cancel */
            v_File_Name     = p_File_Name
            .
            
    ENABLE ALL WITH FRAME DIALOG-1.
    
    DO ON STOP UNDO, LEAVE ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE: 
        DISPLAY p_File_Name WITH FRAME DIALOG-1.
        WAIT-FOR GO OF FRAME DIALOG-1. 
    END.

    STATUS INPUT.   
    HIDE FRAME DIALOG-1.
    
END. /* MAIN */
HIDE FRAME DIALOG-1.


/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

PROCEDURE ApplyEntry .
    DEFINE INPUT PARAMETER p_Widget AS WIDGET-HANDLE.

    IF ( p_Widget:SENSITIVE = TRUE )
    THEN APPLY "ENTRY" TO p_Widget.
END.

ON GO OF FRAME DIALOG-1 DO:  
  ASSIGN p_File_Name.
  IF p_must_exist AND SEARCH(p_File_Name) eq ? THEN DO:    
    MESSAGE p_File_Name SKIP
            "Cannot find this file." SKIP(1)
            "Please verify that the correct path and filename are given."
            VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.            
  END.
  
 
  /* User hit OK */
  p_Return_Status = YES.
         
END.

PROCEDURE PressedOK .

    DEFINE OUTPUT PARAMETER p_Return_Status AS LOGICAL INIT FALSE NO-UNDO.
    
    DEFINE VARIABLE search-file AS CHAR NO-UNDO.
    
    ASSIGN  INPUT FRAME DIALOG-1 p_File_Name
            p_File_Name = TRIM( p_File_Name )
            .
    
    IF p_must_exist THEN DO:
      FILE-INFO:FILENAME = TRIM( p_File_Name ) .  
      search-file = FILE-INFO:FULL-PATHNAME.
      /* Do we need a Progress r-code search? */
      IF search-file eq ? AND CAN-DO (p_options, "RUNNABLE":U)
      THEN RUN adecomm/_rsearch.p (INPUT p_File_Name, OUTPUT search-file).

      /* Report error. */
      IF search-file eq ? THEN DO:
        MESSAGE TRIM( p_File_Name ) SKIP
                "Cannot find this file." SKIP(1)
                "The file should be specified with a full path or exist" SKIP
                "in the PROGRESS PROPATH."
                VIEW-AS ALERT-BOX WARNING.
        RETURN ERROR.
      END. /* IF search... */
    END. /* IF p_must_exist... */
    
    /* Convert filenames to "Portable Progress" standards.  */
    IF p_PROG_portable THEN DO:
      p_File_Name = REPLACE(p_File_Name, "~\", "~/").  
      /* Use lower case for non-unix files */
      IF OPSYS ne "UNIX" THEN p_File_Name = LC(p_File_Name). 
    END.

    /* The value is OK. */
    p_Return_Status = TRUE.
    
END.


PROCEDURE PressedCancel .
    ASSIGN  p_Return_Status = FALSE  /* Cancel */
            p_File_Name     = v_File_Name
            . 
END.


PROCEDURE BrowseFiles .
  DEFINE OUTPUT PARAMETER p_Return_Status AS LOGICAL INIT FALSE NO-UNDO.
  
  DEFINE VAR v_GotFile  AS CHAR NO-UNDO.  
  DEFINE VAR StartDir   AS CHARACTER NO-UNDO.

  /* Ask the user for the name of the widget file (if appropriate). */
  /*
  ** Check to see if the current choice can be found. If so, establish the full
  ** path, then parse the directory from the file name. If it can't be
  ** found, then perhaps the path is bad or the file can't be located.
  ** When this happens, assign a default path to the name.  
  */     
  v_GotFile = p_File_Name:SCREEN-VALUE IN FRAME DIALOG-1.

  IF (SEARCH(v_GotFile) <> ?) THEN DO:
    RUN adecomm/_osprefx.p (v_GotFile, 
                            OUTPUT StartDir, OUTPUT v_GotFile).
    /* osprefx.p returns "" if there was no dirctory name. Treat this as
       the current directory. */
    ASSIGN 
      FILE-INFO:FILENAME = IF StartDir eq "" THEN "." ELSE StartDir
      StartDir           = FILE-INFO:FULL-PATHNAME.
  END.
  ELSE DO:
    IF NOT CAN-DO(p_options, "USE-FILENAME":U) THEN
    ASSIGN
      v_GotFile          = "progress.cst"
      StartDir           = "src/template"
      FILE-INFO:FILENAME = StartDir
      StartDir           = FILE-INFO:FULL-PATHNAME.
    ELSE
    ASSIGN
      v_GotFile          = v_GotFile
      StartDir           = "."
      FILE-INFO:FILENAME = StartDir
      StartDir           = FILE-INFO:FULL-PATHNAME.  
  END. 
   
  IF p_must_exist 
  THEN SYSTEM-DIALOG GET-FILE v_GotFile
      TITLE    "Find File"
      FILTERS  p_filter1          p_filespec1,
               "All Files (*.*)"  "*.*"
      USE-FILENAME
      MUST-EXIST   
      INITIAL-DIR StartDir
      RETURN-TO-START-DIR
      UPDATE   p_Return_Status.
  ELSE SYSTEM-DIALOG GET-FILE v_GotFile
      TITLE    "Find File"
      FILTERS  p_filter1          p_filespec1,
               "All Files (*.*)"  "*.*"
      USE-FILENAME
      INITIAL-DIR StartDir
      RETURN-TO-START-DIR
      UPDATE   p_Return_Status.

  IF ( p_Return_Status = NO ) THEN RETURN .

  IF p_PROG_portable THEN DO:
    v_GotFile = REPLACE(v_GotFile , "~\", "~/").          
    IF OPSYS ne "UNIX" THEN v_GotFile = LC( v_GotFile ).
  END.
  
  ASSIGN  p_File_Name:SCREEN-VALUE  IN FRAME DIALOG-1 = v_GotFile
  . /* END ASSIGN */
END.

