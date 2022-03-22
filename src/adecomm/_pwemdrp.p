/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwemdrp.p
    
    Purpose:   On the MENU-DROP event for a Procedure Window Edit menu or
               Popup Menu, set the sensitive state of the menu items.

    Syntax :    RUN adecomm/_pwemdrp.p.

    Parameters:
    Description:
    Notes  :    This procedure dynamically walks the menu. As long
                as the labels match what's defined in adecomm/_pwmbar.p,
                this routine should be order independent.
                
    Authors: John Palazzo
    Date   : July, 1995
**************************************************************************/
  
DEFINE VARIABLE Sub_Menu_Label   AS CHARACTER NO-UNDO.
DEFINE VARIABLE h_Menu_Item      AS WIDGET    NO-UNDO.
DEFINE VARIABLE pw_Window        AS WIDGET    NO-UNDO.
DEFINE VARIABLE pw_Editor        AS WIDGET    NO-UNDO.
DEFINE VARIABLE Read_Only        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Text_Is_Selected AS LOGICAL   NO-UNDO.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN  
DO ON STOP UNDO, LEAVE:
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
  
    IF NOT CAN-DO("SUB-MENU,MENU" , SELF:TYPE) THEN
    DO:
        MESSAGE "Menu Drop procedure" PROGRAM-NAME(1) "executed from" SKIP
                "widget of type" SELF:TYPE "- must be MENU or SUB-MENU type."
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    
    ASSIGN
        Read_Only        = pw_Editor:READ-ONLY
        Text_Is_Selected = pw_Editor:TEXT-SELECTED
        h_Menu_Item      = SELF:FIRST-CHILD
        . /* END ASSIGN. */
        
    DO WHILE VALID-HANDLE(h_Menu_Item):
      IF h_Menu_Item:LABEL <> ? THEN
      DO:
        CASE REPLACE(h_Menu_Item:LABEL, "&", ""):
        
            WHEN "Check Syntax" OR
            WHEN "Insert" OR
            WHEN "Insert File..." OR
            WHEN "Insert Fields..." THEN
                ASSIGN h_Menu_Item:SENSITIVE = /* TRUE IF...*/
                        ( NOT Read_Only ).
            
            WHEN "Format Selection" THEN
                ASSIGN h_Menu_Item:SENSITIVE = /* TRUE IF... */
                        ( Text_Is_Selected ) AND ( NOT Read_Only ).

            WHEN "Undo" THEN
                ASSIGN h_Menu_Item:SENSITIVE = /* TRUE IF... */
                        ( pw_Editor:EDIT-CAN-UNDO ) AND ( pw_Editor:MODIFIED ).

            WHEN "Cut" THEN
                ASSIGN h_Menu_Item:SENSITIVE = /* TRUE IF... */
                        ( Text_Is_Selected  ) AND ( NOT Read_Only ).

            WHEN "Copy" THEN
                ASSIGN h_Menu_Item:SENSITIVE = /* TRUE IF... */
                        ( Text_Is_Selected  ).
                            
            WHEN "Paste" THEN
                ASSIGN h_Menu_Item:SENSITIVE = /* TRUE IF... */
                        ( pw_Editor:EDIT-CAN-PASTE ) AND ( NOT Read_Only ).
        END CASE.
        
      END.
      ASSIGN h_Menu_Item = h_Menu_Item:NEXT-SIBLING.
    END. /* DO WHILE */
END. /* DO ON STOP */
&ENDIF
 
RETURN.
