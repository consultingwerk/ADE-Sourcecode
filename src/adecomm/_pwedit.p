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

/**************************************************************************
    Procedure:  _pwedit.p
    
    Purpose:    Execute Procedure Window Edit menu commands and handle
                various other events, like TAB, BACK-TAB, and END-ERROR
                when they occur in the editor widget.

    Syntax :    RUN adecomm/_pwedit.p ( INPUT p_Action ) .

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds THEN RUN adecomm/_adeload.p.

/* Procedure Window Global Defines include. */
{ adecomm/_pwglob.i }

/* Procedure Window Attributes include. */
{ adecomm/_pwattr.i }

/* Edit defines and procedures. */
{ adecomm/dedit.i }
{ adecomm/pedit.i }       

DEFINE INPUT PARAMETER p_Action AS CHARACTER NO-UNDO.

DEFINE VARIABLE pw_Window       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hAttr_Field     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE l_ok            AS LOGICAL       NO-UNDO.
DEFINE VARIABLE h_cwin          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Private_Data    AS CHARACTER     NO-UNDO.


/* MAIN */
DO:
  REPEAT ON STOP UNDO, RETRY:
    IF RETRY THEN LEAVE.
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).

    /* Save current-window handle to restore later. */
    ASSIGN h_cwin         = CURRENT-WINDOW
           CURRENT-WINDOW = pw_Window.
    
    CASE p_Action:
    
        WHEN "UNDO"   THEN RUN EditUndo  ( pw_Editor ).

        WHEN "CUT"    THEN RUN EditCut   ( pw_Editor ).
        
        WHEN "COPY"   THEN RUN EditCopy  ( pw_Editor ).
        
        WHEN "PASTE"  THEN RUN EditPaste ( pw_Editor ).
        
        WHEN "INSERT-FILE" THEN RUN InsertFile ( INPUT pw_Editor ).
        
        WHEN "INSERT-FIELDS" THEN DO:
            ASSIGN Private_Data = pw_Editor:PRIVATE-DATA.
            
            /* Get the persistent Insert Field values. */
            ASSIGN ED_Schema_Prefix =
                INTEGER( ENTRY( {&PW_Schema_Prefix_Pos} ,
                                Private_Data ) ) .
            
            RUN FieldSelector ( INPUT pw_Editor ).
            
            /* Put the persistent data back into ed:Private-Data. */
            ASSIGN ENTRY( {&PW_Schema_Prefix_Pos} , Private_Data )
                        = STRING( ED_Schema_Prefix )
                   pw_Editor:PRIVATE-DATA = Private_Data.
        END.
        
        WHEN "INDENT-SELECTION"   THEN RUN ApplyTab( pw_Editor , YES ).
        WHEN "UNINDENT-SELECTION" THEN RUN ApplyBackTab( pw_Editor , YES ).

        WHEN "COMMENT-SELECTION" THEN RUN CommentSelection (pw_Editor, YES).

        WHEN "UNCOMMENT-SELECTION" THEN RUN CommentSelection (pw_Editor, NO).

        WHEN "TAB"      THEN RUN ApplyTab( pw_Editor , YES ).
        
        WHEN "BACK-TAB" THEN RUN ApplyBackTab( pw_Editor , YES ).

        WHEN "END-ERROR" THEN RETURN ERROR.

    END CASE.
    LEAVE.
  END. /* REPEAT */                                                   

  /* Repoint current-window. */
  IF VALID-HANDLE( h_cwin ) THEN ASSIGN CURRENT-WINDOW = h_cwin .
END. /* DO */
