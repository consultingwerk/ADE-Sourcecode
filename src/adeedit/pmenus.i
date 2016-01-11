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

/*---------------------------------------------------------------------------
  pmenus.i
  Procedures for Editor Menus
----------------------------------------------------------------------------*/


PROCEDURE EditMenuDrop.
/*---------------------------------------------------------------------------
    Syntax     RUN EditMenuDrop ( INPUT p_Editor ) .
   
    Purpose    On the MENU-DROP event for the Edit Menu, set the enable/disable
               state of the Edit Menu selections. 
    
    Remarks    The p_Editor widget is presumed to be of :TYPE = "EDITOR".
               Must be run from a trigger, since SELF handle is used.
    
    Return Values  NONE.
---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Editor AS WIDGET-HANDLE NO-UNDO.
  
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN  
    /* Works well under MS-WINDOWS only. */
    DEFINE VAR Read_Only        AS LOGICAL NO-UNDO.
    DEFINE VAR Text_Is_Selected AS LOGICAL NO-UNDO.
    DEFINE VAR hItem            AS HANDLE  NO-UNDO.

    ASSIGN
        Read_Only        = p_Editor:READ-ONLY
        Text_Is_Selected = p_Editor:TEXT-SELECTED.
   
    hItem = SELF:FIRST-CHILD NO-ERROR.
    DO WHILE VALID-HANDLE(hItem):
      CASE hItem:NAME:
        WHEN '_Undo':U        THEN hItem:SENSITIVE = ( p_Editor:EDIT-CAN-UNDO ) AND ( p_Editor:MODIFIED ).
        WHEN '_Redo':U        THEN hItem:SENSITIVE = ( p_Editor:EDIT-CAN-REDO ) AND ( p_Editor:MODIFIED ).
        WHEN '_Cut':U         THEN hItem:SENSITIVE = ( NOT Read_Only ) AND ( Text_Is_Selected ).
        WHEN '_Copy':U        THEN hItem:SENSITIVE = ( Text_Is_Selected  ).
        WHEN '_Paste':U       THEN hItem:SENSITIVE = ( p_Editor:EDIT-CAN-PASTE ) AND ( NOT Read_Only ).
        WHEN '_Insert_File':U THEN hItem:SENSITIVE = ( NOT Read_Only ).
        WHEN '_Field_Selector':U THEN hItem:SENSITIVE = ( NOT Read_Only ).
      END CASE.
      hItem = hItem:NEXT-SIBLING.
    END.

  &ENDIF
END PROCEDURE.


PROCEDURE BufferMenuDrop.
/*---------------------------------------------------------------------------
    Syntax     RUN BufferMenuDrop.
   
    Purpose    On the MENU-DROP event for the Buffer Menu, set the 
               enable/disable state of the Buffer Menu selections. 
    
    Remarks    Must be run from a trigger, since SELF handle is used.
    
    Return Values  NONE.
---------------------------------------------------------------------------*/
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN  
  /* Works well under MS-WINDOWS only. */

  DEFINE VAR hItem            AS HANDLE  NO-UNDO.
  
  /* If more than one buffer open, enable Buffer Next and Prev. */
  RUN NumBuffers ( INPUT win_ProEdit, OUTPUT Buffers_Open ).

  hItem = SELF:FIRST-CHILD NO-ERROR.
  DO WHILE VALID-HANDLE(hItem):
    CASE hItem:NAME:
      WHEN '_Next':U  THEN hItem:SENSITIVE = ( Buffers_Open > 1 ).
      WHEN '_Prev':U  THEN hItem:SENSITIVE = ( Buffers_Open > 1 ).
    END CASE.
    hItem = hItem:NEXT-SIBLING.
  END.

  &ENDIF
      
END PROCEDURE.


PROCEDURE MenuInit .
/*---------------------------------------------------------------------------
    Syntax     RUN MenuInit . 

    Purpose    Initialize menu item accelerators and enable states.

    Remarks    

    Return Values  NONE.
---------------------------------------------------------------------------*/
  
  &IF OPSYS <> "VMS" &THEN
  RUN MenuDebugInit.
  &ENDIF

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* TTY, so just return - no :accelerator or Options support. */
  RETURN.
  &ENDIF

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DO:
      /* Starting in 9.1A, Save Settings on Exit menu item was removed. Settings
         are now saved when pressing OK in each Preferences dialog. */
      RUN MenuAccelInit ( INPUT g_Editor_Cached_Accels ).
      
  END.  /* "MS-WINDOWS or OSF/Motif" */
  &ENDIF

END PROCEDURE.


PROCEDURE MenuAccelInit.
/*---------------------------------------------------------------------------
    Syntax     RUN MenuAccelInit( INPUT p_Accels ). 

    Purpose    Initialize/assign menu item accelerators.

    Parameters
        INPUT  p_Accels   Comma-delimited list of Menu Items and their
                          accelerators in the form:
                                
                                    "MenuLabel:Accelerator,..."
                                
                          The menu labels have all &, spaces, and ellipses
                          removed.
                          
    Remarks    Must be kept in perfect sync with adeedit/dmenus.i.
               Except for Tools Menu Accelerators, defined by the ADE
               Standards Tools Menu Include toolmenu.i.  Editor does not
               support Menu Accelerators on the Tools menu.
    Return Values  NONE.
---------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_Accels AS CHAR NO-UNDO.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

DEFINE VARIABLE hMenu AS HANDLE NO-UNDO.
DEFINE VARIABLE hItem AS HANDLE NO-UNDO.

hMenu = win_ProEdit:MENUBAR.
hMenu = hMenu:FIRST-CHILD.
DO WHILE VALID-HANDLE(hMenu):
  hItem = hMenu:FIRST-CHILD.
  DO WHILE VALID-HANDLE(hItem):
    /*-----------   File Menu Accelerators --------------*/
    IF CAN-DO('_New,_Open,_Close,_New_PW,_Save,_Save_as,_AddRepos,_Print,_Exit':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Edit Menu Accelerators --------------*/
    ELSE IF CAN-DO('_Undo,_Cut,_Copy,_Paste,_Insert_File,_Field_Selector':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Search Menu Accelerators --------------*/
    ELSE IF CAN-DO('_Find,_Find_Next,_Find_Prev,_Replace,_Goto_Line':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Buffer Menu Accelerators --------------*/
    ELSE IF CAN-DO('_BuffList,_Next,_Prev,_BufFont,_BufSettings':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Compile Menu Accelerators --------------*/
    ELSE IF CAN-DO('_Run,_Check_Syntax,_Debug,_Comp_Msgs':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Options Menu Accelerators --------------*/
    ELSE IF CAN-DO('_Editor_Prefs,_Editing_Options,_Menu_Accels,_DefFont':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Help Menu Accelerators ---------------*/
    /* Keyboard option not in the GUI Help menu. */
    ELSE IF CAN-DO('_Help_Topics,_Menu_Messages,_Menu_Recent,_About':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).

    /*-----------   Tools Menu Accelerators --------------*/
    /* None - See Notes in header. */

    hItem = hItem:NEXT-SIBLING.

  END.
  hMenu = hMenu:NEXT-SIBLING.
END.

RETURN.

&ENDIF

END PROCEDURE.

PROCEDURE MenuAccelSet.
/*---------------------------------------------------------------------------
    Syntax     RUN MenuAccelSet ( INPUT p_Item, INPUT-OUTPUT p_Accels ).

    Purpose    Sets a menu item's accelerator.

    Parameters
        p_Item     Handle to menu item whose accelerator to be set.
        p_Accels   Comma-delimited list of Menu Items and their
                   accelerators in the form:
                                
                      "MenuLabel:Accelerator,..."
                                
                   The menu labels have all &, spaces, and ellipses removed.
                          
    Remarks    Must be kept in perfect sync with adeedit/dmenus.i.
               Except for Tools Menu Accelerators, defined by the ADE
               Standards Tools Menu Include toolmenu.i.  Editor does not
               support Menu Accelerators on the Tools menu.
               
               Once an item's accelerator is found among the p_Accels list,
               its entry in the p_Accels list is removed. This is for local
               optimization. It does not affect the global accelerator
               list maintained by the editor.
               
    Return Values  p_Accels via OUTPUT param.
---------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER p_Item   AS HANDLE NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Accels AS CHAR  NO-UNDO.
  
  DEFINE VARIABLE iItem     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLabel    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cListItem AS CHARACTER NO-UNDO.

  DO iItem = 1 TO NUM-ENTRIES(p_Accels):
    /* Remove the menu item label &, spaces, and ellipses. Must do this to
       correctly search the p_Accels list, which also has those chars removed.
       -jep 06/29/99 */
    ASSIGN cLabel = REPLACE(p_Item:LABEL, '&', '')
           cLabel = REPLACE(cLabel, ' ', '')
           cLabel = REPLACE(cLabel, '.', '').
    cListItem = ENTRY(iItem, p_Accels).
    IF cLabel = ENTRY(1, cListItem, ':') THEN
    DO:
      p_Item:ACCELERATOR = ENTRY(2, cListItem, ':').
      p_Accels = TRIM(REPLACE(p_Accels, cListItem, ''), ',').
      LEAVE.
    END.
  END.        

END PROCEDURE.


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

PROCEDURE MRUList .
/*---------------------------------------------------------------------------
    Syntax     RUN MRUList . 

    Purpose    Updates Most Recently Used File List.  This is called when a file 
               is opened or saved.  It is also called to adjust the list
               after the preference for the number of entries has changed

    Parameters
               INPUT  pcFileName - File name for the file just opened or saved

               If this is being called to adjust the number of entries, these parameter
               is blank
        
    Remarks    This logic must be keep in sync with adeshar/_mrulist.p 
               (_mrulist.p contains the same logic for the Appbuilder
               MRU Filelist)

    Return Values  NONE.
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFileName  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE iCount AS INTEGER INIT 0 NO-UNDO.

  FOR EACH MRU_Files USE-INDEX mru_idx_pos_desc:
    CREATE mruWork.
    BUFFER-COPY MRU_Files EXCEPT mru_position TO mruWork.
    ASSIGN mruWork.mru_position = MRU_Files.mru_position + 10.
    DELETE MRU_Files.
  END.  /* for each MRU_Files */

  IF pcFileName NE "":U THEN DO:
    FIND mruWork WHERE mruWork.mru_file = pcFileName NO-ERROR.
    IF AVAILABLE mruWork THEN ASSIGN mruWork.mru_position = 1. 
    ELSE DO:
      CREATE mruWork.
      ASSIGN mruWork.mru_file     = pcFileName
             mruWork.mru_position = 1.
    END.  /* else do - not avail mruWork */
  END.  /* if filename NE "" */

  FOR EACH mruWork:
    iCount = iCount + 1.
    IF iCount <= Sys_Options.MRU_Entries THEN DO:
      CREATE MRU_Files.
      ASSIGN MRU_Files.mru_position = iCount
             MRU_Files.mru_file     = mruWork.mru_file.
    END.  /* if iCound less than or equal to file list */
    DELETE mruWork.
  END.  /* for each mruWork */

  RUN MRUMenu.  

END PROCEDURE.

&ENDIF

PROCEDURE MRUMenu .
/*---------------------------------------------------------------------------
    Syntax     RUN MRUMenu . 

    Purpose    Creates menu items for MRU FileList.

    Remarks    

    Return Values  NONE.
---------------------------------------------------------------------------*/

DEFINE VARIABLE cAbbrevName AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cExitAccel  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i           AS INTEGER            NO-UNDO.
DEFINE VARIABLE hFileMenu   AS HANDLE             NO-UNDO.
  
  /* editor.i */
  RUN GetFileMenu (OUTPUT hFileMenu).

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

  i = 1.
  DO WHILE i < 10:
    IF VALID-HANDLE(mi_mrulist[i]) THEN DELETE WIDGET mi_mrulist[i].
    i = i + 1. 
  END.  /* do while */
  IF VALID-HANDLE(mi_rule) THEN DELETE WIDGET mi_rule.
  IF VALID-HANDLE(mi_Exit) THEN DO:
    ASSIGN cExitAccel = mi_Exit:ACCELERATOR.
    DELETE WIDGET mi_Exit.
  END.  /* if mi_Exit valid */
  
  FOR EACH MRU_Files:
    /* Get abbreviated filename to display in menu */
    RUN adecomm/_ossfnam.p 
      (INPUT MRU_Files.mru_file, 
       INPUT 30,
       INPUT ?,
       OUTPUT cAbbrevName).
    CREATE MENU-ITEM mi_mrulist[MRU_Files.mru_position]
      ASSIGN PARENT = hFileMenu
             LABEL = STRING(MRU_Files.mru_position) + " ":U + cAbbrevName
             TRIGGERS: ON CHOOSE PERSISTENT RUN OpenMRUFile (MRU_Files.mru_position). END TRIGGERS.
  END.  /* for each MRU_Files */
  FIND FIRST MRU_Files NO-ERROR.
  IF AVAIL MRU_Files THEN 
    CREATE MENU-ITEM mi_rule
      ASSIGN SUBTYPE = "RULE"
             PARENT  = hFileMenu.
          
&ENDIF
  
  CREATE MENU-ITEM mi_Exit
    ASSIGN NAME        = "_Exit"
           PARENT      = hFileMenu
           LABEL       = "E&xit"
           ACCELERATOR = cExitAccel
    TRIGGERS: ON CHOOSE PERSISTENT RUN ExitEditor. END TRIGGERS.

END PROCEDURE.  /* mru_menu */


PROCEDURE CreateFileMenuItems .
/*---------------------------------------------------------------------------
    Syntax     RUN CreateFileMenuItems . 

    Purpose    Creates these File menu items after Save As menu item:
    
               Add to Repos (Dynamics only)
               Rule
               Print
               Rule

    Remarks    Needed these menu items to be dynamic so 'Add to Repository'
               could be optionally added to the File menu if Dynamics is
               running.
               
               Added to support IZ 2513 Error when trying to save structured
               include in Dynamics framework.

    Return Values  NONE.
---------------------------------------------------------------------------*/

  DEFINE VARIABLE hFileMenu     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lIsICFRunning AS LOGICAL    NO-UNDO.

  /* Establish if Dynamics is running. */
   ASSIGN lIsICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
   ASSIGN lIsICFRunning = (lIsICFRunning = YES) NO-ERROR.

  /* editor.i */
  RUN GetFileMenu (OUTPUT hFileMenu).

  IF lIsICFRunning THEN
  DO:
    CREATE MENU-ITEM mi_AddRepos
      ASSIGN NAME        = "_AddRepos"
             PARENT      = hFileMenu
             LABEL       = "Add to &Repository..."
      TRIGGERS: ON CHOOSE PERSISTENT RUN AddtoRepos. END TRIGGERS.
  END.

  CREATE MENU-ITEM mi_rule_pr1
      ASSIGN SUBTYPE = "RULE"
             PARENT  = hFileMenu.

  CREATE MENU-ITEM mi_Print
    ASSIGN NAME        = "_Print"
           PARENT      = hFileMenu
           LABEL       = IF OPSYS = "UNIX":U THEN "&Print" ELSE "&Print..."
    TRIGGERS: ON CHOOSE PERSISTENT RUN FilePrintCall. END TRIGGERS.

  CREATE MENU-ITEM mi_rule_pr2
      ASSIGN SUBTYPE = "RULE"
             PARENT  = hFileMenu.

END PROCEDURE.  /* CreateFileMenuItems */
