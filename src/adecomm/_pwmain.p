/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/******************************************************************************

Procedure: _pwmain.p

Syntax   :
       RUN adecomm/_pwmain.p (INPUT p_Parent_ID    /* PW Parent ID  */ ,
                              INPUT File_List      /* Files to open */ ,
                              INPUT p_Edit_Command /* PW Command    */ ).

Purpose  :          
    Open one or more PROGRESS Procedure Windows to edit procedure or
    include files or to open an Untitled procedure in a Procedure Window.

Description:
    This PROGRESS procedure is the main program for creating Procedure Windows.
    
    You use Procedure Windows to open, view, edit, create, and save PROGRESS
    procedure (.p) and include (.i) files.  You can open as many Procedure
    Windows as you want, so you can easily edit and view any number of
    procedure (.p or .i) files and copy and paste between them.  You can edit
    only one procedure file at a time in a Procedure Window. 

    This procedure can be called as often as desired and each call will
    open a Procedure Window, or multiple Procedure Windows if a File List
    to open is passed.
    
    There is no WAIT-FOR or other blocking statement in this program.
       
Parameters:
    INPUT p_Parent_ID  (CHARACTER)
        - String value indicating "Parent" of Procedure Window.
          Pass Null ("") if no parent. The p_Parent_ID parameter should be
          the name of the calling tool.  When the tool exits, it calls
          adecomm/_pwexit.p and passes p_Parent_ID again. This procedure
          uses p_Parent_ID to determine which Procedure Windows to close.

          Its best to pass the application's or tool's startup procedure
          name. This allows adecomm/_pwexit.p to determine if the caller
          is the startup routine. If it is, then all PW's are closed,
          not just those owned by the caller. This takes care of those
          PW's created by PRO*Tools.

    INPUT p_FileList   (CHAR)
        - Comma-delimited list of OS files - each of which will be opened
          in its own Procedure Window.  Pass Null ("") to open one
          Procedure Window with an Untitled procedure.
        
        - If NULL (""), sets current buffer to (Untitled).
        
        - If a file cannot be found, a warning message is given in
          an alert box.
          
        - If the file to be opened exists on a remote WebSpeed agent, the OS
          file name will contain three CHR(3)-delimited parts; file name, 
          local temp file name, and Broker URL to use to save the file.

    INPUT p_Edit_Command
        - Either "" for no special processing or
                 "UNTITLED" to force a template file to be opened Untitled.

Notes :

Author: John Palazzo, Wm.T.Wood

Created : January, 1994
Modified: 06/09/98 adams added support for 9.0A remote file managment

*****************************************************************************/

/*-----------------------------  DEFINE VARS  -------------------------------*/
{adecomm/oeideservice.i}

/* ADE Standards Include. */
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Procedure Window application-global contstants. */
{ adecomm/_pwglob.i }
{ adecomm/_adetool.i } /* Add ADEPersistent IP stub to prevent editor from being
                        * destroyed by the UIB and Procedure Editor */

/*--------------------------------------------------------------------------
                       System-Wide Defines for Editor 
--------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_Parent_ID    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_File_List    AS CHARACTER NO-UNDO.
  /* Files editor should open automatically on start-up. */
DEFINE INPUT PARAMETER p_Edit_Command AS CHARACTER NO-UNDO.
  /* If "UNTITLED" then open untitled    */

/* Define various handles needed to reference the ...  */
DEFINE VARIABLE h_win        AS WIDGET    NO-UNDO. /*... The tinyedit window  */
DEFINE VARIABLE h_frame      AS WIDGET    NO-UNDO. /*... Frame in the  window */
DEFINE VARIABLE h_ed         AS WIDGET    NO-UNDO. /*... the editor itself    */
DEFINE VARIABLE h_menu       AS WIDGET    NO-UNDO. /*... Menu-bar             */
DEFINE VARIABLE h            AS WIDGET    NO-UNDO. /*... generic handle       */

DEFINE VARIABLE Broker_URL   AS CHARACTER NO-UNDO.
DEFINE VARIABLE Private_Data AS CHARACTER NO-UNDO. /* File name in PW.        */
DEFINE VARIABLE Proc_Name    AS CHARACTER NO-UNDO. /* File name in PW.        */
DEFINE VARIABLE PW_Opened    AS LOGICAL   NO-UNDO. /* Did at least one PW open? */
DEFINE VARIABLE Read_OK      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Temp_File    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Temp_Name    AS CHARACTER NO-UNDO.
DEFINE VARIABLE List_Item    AS INTEGER   NO-UNDO.
DEFINE VARIABLE Web_File     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE RelPath      AS CHARACTER NO-UNDO INIT ?.


/* --- Begin SCM changes --- */
DEFINE VARIABLE scm_ok       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE scm_event    AS CHARACTER NO-UNDO.
DEFINE VARIABLE scm_file     AS CHARACTER NO-UNDO.
/* --- End SCM changes ----- */

/* proc-main */
DO ON STOP UNDO, LEAVE:

  /** ******
   ** Step 0: Initialize Procedure Window stuff.
   ** ******
   **/
  /* Create persistent widget pool for all Procedure Windows. 
     The ASSIGN NO-ERROR clears the ERROR-STATUS handle.
  */
  CREATE WIDGET-POOL {&PW_Pool} PERSISTENT NO-ERROR.
  ASSIGN NO-ERROR.
  
  DO List_Item = 1 TO MAX( 1 , NUM-ENTRIES( p_File_List ) ) :
    /* If File List is empty, get an Untitled procedure name. Otherwise,
       process the file list.
    */
    IF OEIDEIsRunning AND p_Edit_Command = "UNTITLED":U AND NUM-ENTRIES(p_File_List) > 0 THEN
    DO:
        /* Open file in IDE Editor */
        openEditor(?, ENTRY( List_Item, p_File_List ), "UNTITLED":U, ?).
        PW_Opened = TRUE.
        
          /* --- Begin SCM changes --- */
          /* Do custom setup -- this is generally a no-op, but it can
             be used to initialize custom modifications. */
          RUN adecomm/_adeevnt.p (INPUT  {&PW_NAME},
                                  INPUT  "STARTUP", 
                                  INPUT  ?, 
                                  INPUT  ?,
                                  OUTPUT scm_ok ).
                  
          ASSIGN scm_event = "NEW"
                 scm_file  = ? .
                     
          RUN adecomm/_adeevnt.p (INPUT  {&PW_NAME},
                                  INPUT  scm_event, 
                                  INPUT  ?, 
                                  INPUT  scm_file,
                                  OUTPUT scm_ok).
      
          /* --- End SCM changes ----- */
        
    END.
    ELSE DO:
        ASSIGN Web_File = FALSE.
        
        IF NUM-ENTRIES( p_File_List ) = 0 OR p_Edit_Command = "UNTITLED":U
          THEN RUN adecomm/_pwgetun.p ( OUTPUT Proc_Name ).
        ELSE DO:
          ASSIGN Proc_Name = ENTRY( List_Item , p_File_List ).
          IF NUM-ENTRIES(Proc_Name, CHR(3)) = 4 THEN
            ASSIGN Web_File   = TRUE
                   Temp_File  = ENTRY( 2, Proc_Name, CHR(3))
                   Broker_URL = ENTRY( 3, Proc_Name, CHR(3))
                   RelPath    = ENTRY( 4, Proc_Name, CHR(3))
                   Proc_Name  = ENTRY( 1, Proc_Name, CHR(3))
                   RelPath    = (IF RelPath = ? OR RelPath = "" THEN Proc_Name ELSE RelPath).
        END.
        
        /** ******
         ** Step 1: Create the MENU-BAR so we can add it to the window.
         ** ******
         **/
        RUN adecomm/_pwmbar.p ( INPUT NO /* p_Popup */,
                                INPUT IF p_Edit_Command MATCHES "*READ-ONLY*":U THEN "READ-ONLY":U
                                      ELSE "":U,
                                OUTPUT h_menu /* PW Menubar Handle */ ).
    
     
        /** ******
         ** Step 2: Create the Procedure Window (including frame and editor widget)
         ** ******  as well as the additional PW Attributes for persistent data. 
         **         This also attaches default triggers for WINDOW-CLOSE,
         **         WINDOW-RESIZE, and HELP.  Override them if you wish.
         **/
        RUN adecomm/_pwcreat.p ( INPUT  p_Parent_ID /* Parent ID   */ ,
                                 INPUT  {&PW_Name}  /* Window Name */ ,
                                 INPUT  {&PW_Title_Leader} + 
                                        (IF Web_File THEN RelPath ELSE Proc_Name) /* Title */ +
                                        (IF NOT Web_File THEN "" ELSE (CHR(3) + 
                                            Temp_File + CHR(3) + Broker_URL + CHR(3) +
                                            (IF RelPath NE Proc_Name THEN Proc_Name ELSE "")) ),
                                 INPUT  h_menu      /* Menubar     */ ,
                                 OUTPUT h_win       /* Window H    */ ).
        
        /* Get widget handles of Procedure Window and its editor widget. */
        RUN adecomm/_pwgeteh.p ( INPUT h_win , OUTPUT h_ed ).
        ASSIGN h_frame   = h_ed:FRAME.
        ASSIGN h_ed:NAME = (IF Web_File THEN RelPath ELSE Proc_Name).
        
        /* Load up cute icon file */
        IF h_win:LOAD-ICON("adeicon/editor") THEN.
        
        /* Attach popup menu. */
        RUN adecomm/_pwmbar.p ( INPUT  YES    /* p_Popup */,
                                INPUT  "":U,
                                OUTPUT h_menu /* PW Menubar Handle */ ).
        ASSIGN h_ed:POPUP-MENU = h_menu.
         
        /** ******
         ** Step 3: If the current Proc_Name is not Untitled, try to read the file.
         ** ******
         **/
        /* If p_Edit_Command is "UNTITLED" set Proc_Name to (and h_ed:NAME) to
         proper name */
        IF p_Edit_Command = "UNTITLED" AND 
          List_Item > 0 AND List_Item <= NUM-ENTRIES(p_File_List) 
        THEN DO:
          ASSIGN Temp_name = Proc_Name
                 Proc_Name = ENTRY( List_Item , p_File_List ).
          IF NUM-ENTRIES(Proc_Name, CHR(3)) = 3 THEN
            ASSIGN Temp_File  = ENTRY( 2, Proc_Name, CHR(3))
                   Broker_URL = ENTRY( 3, Proc_Name, CHR(3))
                   Proc_Name  = ENTRY( 1, Proc_Name, CHR(3)).
        END.
        
        /* If not Untitled, try to read specified file. */
        IF NOT h_ed:NAME BEGINS {&PW_Untitled} OR p_Edit_Command = "UNTITLED":U THEN
        DO ON STOP UNDO, LEAVE:
            /*  Try to read specified file into editor widget. If successful,
                pw_Editor:NAME and pw_Window:TITLE are updated to reflect file
                name read.  If not successful, delete the PW opened. 
            */
            RUN adecomm/_pwrdfl.p (INPUT  h_ed,
                                   INPUT  ((IF Web_File THEN RelPath ELSE Proc_Name) + 
                                          (IF NOT Web_File THEN ""
                                           ELSE CHR(3) + Temp_File + CHR(3) + 
                                               (IF RelPath NE Proc_Name THEN Proc_Name ELSE "") )),
                                   OUTPUT Read_OK).
            /* If read unsuccessful, delete the PW. */
            IF NOT Read_OK THEN 
              RUN adecomm/_pwdelpw.p ( INPUT h_win ).
            ELSE
              /* Running peditor.i here to set source type of the editor.
               * Rather than change the editor to handle .cls files like 
               * .p files, SetEdBufType now tells the editor to pretend 
               * a .cls is a .p.
               * After an editor reads or saves a file, internally it changes 
               * the source type based on the extension, so we will
               * lose the 4GL syntax highlighting for a .cls file. 
               * Running SetEdBufType here resets the 4GL syntax highlighting.
               */
              /* adecomm/peditor.i */
              RUN SetEdBufType(INPUT h_ed,INPUT Proc_Name).
        
        END.
        /* If read successful or Untitled, enter the window for editing. */
        IF VALID-HANDLE( h_ed ) THEN DO:
          IF p_Edit_Command = "UNTITLED":U THEN 
          ASSIGN Proc_Name = Temp_name
                 h_ed:NAME = Temp_name
                 h_win:TITLE = {&PW_Title_Leader} + Proc_name.
            
          /* --- Begin SCM changes --- */
          /* Do custom setup -- this is generally a no-op, but it can
             be used to initialize custom modifications. */
          RUN adecomm/_adeevnt.p (INPUT  {&PW_NAME},
                                  INPUT  "STARTUP", 
                                  INPUT  STRING( h_win ), 
                                  INPUT  STRING( h_win:PRIVATE-DATA ),
                                  OUTPUT scm_ok ).
                  
          IF h_ed:NAME BEGINS {&PW_Untitled} THEN
            ASSIGN scm_event = "NEW"
                   scm_file  = ? .
          ELSE
            ASSIGN scm_event = "OPEN"
                   scm_file  = h_ed:NAME .
    
          IF p_Edit_Command MATCHES "*READ-ONLY*":U THEN h_ed:READ-ONLY = TRUE.
                     
          RUN adecomm/_adeevnt.p (INPUT  {&PW_NAME},
                                  INPUT  scm_event, 
                                  INPUT  STRING( h_ed ), 
                                  INPUT  scm_file,
                                  OUTPUT scm_ok).
      
          /* --- End SCM changes ----- */
      
          ASSIGN PW_Opened = TRUE.
            /* If wait cursor is on, the APPLY "ENTRY" won't take. So
               be sure its "off".
            */
            RUN adecomm/_setcurs.p ( INPUT "" ).
            APPLY "ENTRY" TO h_ed.
        END.
    END.    
  END. /* DO List_Items */
  
  /** ******
   ** Step 4: Did any PW get opened? If not, open an Untitled PW.
   ** ******
   **/
  IF PW_Opened = FALSE
  THEN RUN adecomm/_pwmain.p (INPUT p_Parent_ID /* PW Parent ID  */ ,
                           INPUT ""          /* Files to open */ ,
                           INPUT ""          /* PW Command    */ ).
  RETURN.
END. /* proc-main */

{ adecomm/peditor.i }   /* Editor procedures. */

/* _pwmain.p - end of file */
