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

/*--------------------------------------------------------------------------
  dedit.i
  Edit Defines for Editor
--------------------------------------------------------------------------*/

/* Tool should set these to their tool name to adhere to
   application style standards.
*/
DEFINE VARIABLE Edit_Error_Title     AS CHAR INIT "Error"   NO-UNDO.
DEFINE VARIABLE Edit_Selection_Start AS INTEGER INIT ? NO-UNDO.
DEFINE VARIABLE Edit_Selection_End   AS INTEGER INIT ? NO-UNDO.

/* Support for Insert Fields */
DEFINE VARIABLE Ed_Schema_Prefix   AS INTEGER   NO-UNDO.
DEFINE VARIABLE Ed_Schema_Database AS CHARACTER NO-UNDO.
DEFINE VARIABLE Ed_Schema_Table    AS CHARACTER NO-UNDO.

&IF DEFINED(ED_POPUP) <> 0 &THEN
/* Editor Popup Menu Definitions                                        */
DEFINE SUB-MENU m_Insert_Menu 
    &IF {&ED_POPUP} = "SE_POPUP" &THEN
       MENU-ITEM m_DB_Fields    LABEL "&Database Fields..."
       MENU-ITEM m_Event_Name   LABEL "&Event Name..."
       MENU-ITEM m_Procedure_Call LABEL "Procedure &Call..."
       MENU-ITEM m_Preprocessor_Name LABEL "&Preprocessor Name..."
       MENU-ITEM m_Query        LABEL "&Query..."     
       MENU-ITEM m_Object_Name  LABEL "&Object Name..."
       RULE
       MENU-ITEM m_File_Contents LABEL "&File Contents..."
       MENU-ITEM m_File_Name    LABEL "File &Name..." .
    &ELSE
       MENU-ITEM m_DB_Fields     LABEL "&Database Fields..."
       MENU-ITEM m_File_Contents LABEL "&File Contents...".
    &ENDIF

DEFINE SUB-MENU m_Format_Menu 
       MENU-ITEM m_Indent       LABEL "&Indent"       
       MENU-ITEM m_UnIndent     LABEL "&Unindent"
       MENU-ITEM m_Comment      LABEL "&Comment"      
       MENU-ITEM m_UnComment    LABEL "Unc&omment"  .

DEFINE MENU mnu_EdPopup
    &IF {&ED_POPUP} = "PE_POPUP" &THEN
       MENU-ITEM m_Run          LABEL "&Run"
    &ENDIF
       MENU-ITEM m_Check_Syntax LABEL "Chec&k Syntax"
       SUB-MENU  m_Insert_Menu  LABEL "&Insert"       
       SUB-MENU  m_Format_Menu  LABEL "&Format Selection"
       RULE
       MENU-ITEM m_Cut          LABEL "Cu&t"
       MENU-ITEM m_Copy         LABEL "&Copy"
       MENU-ITEM m_Paste        LABEL "&Paste"
       RULE
       MENU-ITEM m_Keyword_Help LABEL "Key&word Help"
       .
       
PROCEDURE EdPopupDrop.
/*---------------------------------------------------------------------------
    Syntax     RUN EdPopupDrop ( INPUT p_Editor ) .
   
    Purpose    On the MENU-DROP event for the Editor Popup Menu,
               set the enable/disable state of the Edit Menu selections. 
    
    Remarks    The p_Editor widget is presumed to be of :TYPE = "EDITOR".
    
    Return Values  NONE.
---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Editor AS HANDLE NO-UNDO.
  
    /* Works well under MS-WINDOWS only. */
    DEFINE VAR Read_Only        AS LOGICAL NO-UNDO.
    DEFINE VAR Text_Is_Selected AS LOGICAL NO-UNDO.

    ASSIGN
        Read_Only        = p_Editor:READ-ONLY
        Text_Is_Selected = p_Editor:TEXT-SELECTED
       
        SUB-MENU  m_Insert_Menu:SENSITIVE = (NOT Read_Only)

        SUB-MENU  m_Format_Menu:SENSITIVE = /* TRUE IF... */
                        ( NOT Read_Only ) AND ( Text_Is_Selected )
        
        MENU-ITEM m_Cut:SENSITIVE IN MENU mnu_EdPopup  = /* TRUE IF... */
                        ( NOT Read_Only ) AND ( Text_Is_Selected )

        MENU-ITEM m_Copy:SENSITIVE IN MENU mnu_EdPopup = /* TRUE IF...*/
                        ( Text_Is_Selected  )
                            
        MENU-ITEM m_Paste:SENSITIVE IN MENU mnu_EdPopup = /* TRUE IF... */
                        ( p_Editor:EDIT-CAN-PASTE ) AND ( NOT Read_Only )
        
        MENU-ITEM m_Check_Syntax:SENSITIVE IN MENU mnu_EdPopup = /* TRUE IF...*/
                        ( NOT Read_Only )
    . /* END ASSIGN. */

END PROCEDURE.

&ENDIF
