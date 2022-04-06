/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------
    Procedure	:  _mnkvals.p
    
    Syntax:     RUN adecomm/_mnkvals.p ( INPUT p_Menu , 
                                        INPUT p_Mode , 
                                        INPUT p_Section ,
                                        INPUT p_Exclude ,
                                        OUTPUT p_Menu_Accels ) .

  Description:

    On Save (PUT) Saves Menu Accelerator settings to current PROGRESS
    Environment file (e.g., PROGRESS.INI or .Xdefaults).  
   
    On Read (GET), assigns accelerators to p_Menu menu items.

  Parameters
        INPUT   p_Menu  Handle to menu whose accelerators you want to 
                        save/read.
        			        		
                p_Mode  Mode indicator for read or save.
                        "GET"  : Reads from current Env. file.
                        "PUT"  : Saves to current Env. file and does not report save errors.
                        "PUT-ERROR"  : Saves to current Env. file and reports save errors.
                  
                p_Section   Section to read or save in the Env. file.
                
                p_Exclude   Comma-delimited list of Menu Labels (of a menubar) to exclude
                            from the p_Menu_Accels list.  Must include the & if there is one.
                            Pass Null ("") to not exclude any menu.
                            
                            Example: "&Tools,&Options,&Help"
                
        OUTPUT  p_Menu_Accels   Comma-delimited list of Menu Items and their
                                accelerators in the form:
                                
                                    "MenuLabel:Accelerator,..."
                                
                                The menu labels have all &, spaces, and ellipses
                                removed. A trailing comma is left at the end of
                                the list.

  Notes
        If p_Menu is ?, exits without a message.

  Author: John Palazzo
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_Menu        AS WIDGET-HANDLE NO-UNDO .
DEFINE INPUT  PARAMETER p_Mode        AS CHAR          NO-UNDO .
DEFINE INPUT  PARAMETER p_Section     AS CHAR          NO-UNDO .
DEFINE INPUT  PARAMETER p_Exclude     AS CHAR          NO-UNDO .
DEFINE OUTPUT PARAMETER p_Menu_Accels AS CHAR          NO-UNDO .

DEFINE WORK-TABLE w_MenuObject NO-UNDO
	FIELD hMenu AS WIDGET-HANDLE
	FIELD Menu_Label AS CHAR
	FIELD Menu_Item_Label AS CHAR
	FIELD Menu_Item_Key AS CHAR
	FIELD Menu_Accelerator AS CHAR
	.

DEFINE VAR vKey         AS CHAR    NO-UNDO.
DEFINE VAR vKeyValue    AS CHAR    NO-UNDO.
DEFINE VAR Key_Value    AS CHAR    NO-UNDO.
DEFINE VAR Temp_Logical AS LOGICAL NO-UNDO.
DEFINE VAR Put_Failed   AS LOGICAL NO-UNDO INIT FALSE.

PROCEDURE MenuTree.

  DEFINE INPUT PARAMETER p_hMenu  AS WIDGET-HANDLE NO-UNDO .
  DEFINE INPUT PARAMETER p_Parent AS CHARACTER     NO-UNDO .

  DEFINE VAR hMenu_Item AS WIDGET-HANDLE.
  DEFINE VAR Item_Name  AS CHAR.
  
  IF ( p_hMenu = ? ) THEN RETURN.
  
  ELSE IF ( p_hMenu:TYPE = "MENU" )
  THEN DO:
    RUN MenuTree( p_hMenu:FIRST-CHILD , "" ).
    RETURN.
  END.
  
  ELSE IF ( p_hMenu:TYPE = "SUB-MENU" )
  THEN DO:
         CREATE w_MenuObject.
         ASSIGN w_MenuObject.hMenu      = p_hMenu
                w_MenuObject.Menu_Label = p_hMenu:LABEL
                w_MenuObject.Menu_Item_Label = p_hMenu:LABEL
         . /* END ASSIGN. */
        /*-------------------------------------------------------------------
            Special Character Handling for Menu Item Labels:
            - Strip out mnemonic character (&)
                ex. "Save &As..." -->  "Save As..."
            - Close up spaces
                ex. "Save As..."  -->  "SaveAs..."
            - Remove ellipses
                ex. "Save As..."  -->  "SaveAs"
        -------------------------------------------------------------------*/
         ASSIGN
           w_MenuObject.Menu_Item_Key = w_MenuObject.Menu_Item_Label
           w_MenuObject.Menu_Item_Key = REPLACE( w_MenuObject.Menu_Item_Key ,
         					 "&" , "" )
           w_MenuObject.Menu_Item_Key = REPLACE( w_MenuObject.Menu_Item_Key ,
         					 " " , "" )
           w_MenuObject.Menu_Item_Key = REPLACE( w_MenuObject.Menu_Item_Key ,
         					 "." , "" )
         . /* END ASSIGN */
         RUN MenuTree( p_hMenu:FIRST-CHILD , p_hMenu:LABEL ).
         RUN MenuTree( p_hMenu:NEXT-SIBLING , "" ).
         RETURN.
  END.
  
  ELSE IF ( p_hMenu:TYPE = "MENU-ITEM" ) AND 
          ( p_hMenu:SUBTYPE = "NORMAL" )
  THEN DO:
         CREATE w_MenuObject.
         ASSIGN w_MenuObject.hMenu      = p_hMenu
                w_MenuObject.Menu_Label = p_Parent
                w_MenuObject.Menu_Item_Label = p_hMenu:LABEL
         . /* END ASSIGN. */
        /*-------------------------------------------------------------------
            Special Character Handling for Menu Item Labels:
            - Strip out mnemonic character (&)
                ex. "Save &As..." -->  "Save As..."
            - Close up spaces
                ex. "Save As..."  -->  "SaveAs..."
            - Remove ellipses
                ex. "Save As..."  -->  "SaveAs"
        -------------------------------------------------------------------*/
         ASSIGN
           w_MenuObject.Menu_Item_Key = w_MenuObject.Menu_Item_Label
           w_MenuObject.Menu_Item_Key = REPLACE( w_MenuObject.Menu_Item_Key ,
         					 "&" , "" )
           w_MenuObject.Menu_Item_Key = REPLACE( w_MenuObject.Menu_Item_Key ,
         					 " " , "" )
           w_MenuObject.Menu_Item_Key = REPLACE( w_MenuObject.Menu_Item_Key ,
         					 "." , "" )
         . /* END ASSIGN */

        IF ( p_hMenu:ACCELERATOR <> ? )
        THEN ASSIGN w_MenuObject.Menu_Accelerator = p_hMenu:ACCELERATOR.
        RUN MenuTree( p_hMenu:NEXT-SIBLING , p_Parent ).
        RETURN.
  END.

  ELSE DO: /* SKIP to NEXT-SIBLING for RULES, SKIPs, etc */
    RUN MenuTree( p_hMenu:NEXT-SIBLING , p_Parent ).
    RETURN.
  END.  
  
END PROCEDURE.

PROC_MAIN:
DO ON STOP  UNDO, RETRY
   ON ERROR UNDO, RETRY:  /* proc-main */

  IF NOT RETRY
  THEN DO:
  
  IF p_Menu = ? THEN RETURN.
  RUN adecomm/_setcurs.p ( INPUT "WAIT" ).

  RUN MenuTree ( p_Menu , "" ).
  
  /* Be certain to reset to default Progress Environment File. */
  USE "" NO-ERROR.
          
  FOR EACH w_MenuObject:

    /* Process Menu-Items only, not SUB-MENUS. */
    IF ( w_MenuObject.hMenu:TYPE <> "MENU-ITEM" ) THEN NEXT.
    /* Exclude unwanted menus/menu-items. */
    IF ( LOOKUP( w_MenuObject.Menu_Label , p_Exclude ) > 0 ) THEN NEXT.
    /* Exclude Most Recently Used file list menu items - MRU file menu items
       begin with a number 1-9 followed by the file name */
    IF ( LOOKUP (SUBSTRING(w_MenuObject.Menu_Item_Key, 1, 1), "1,2,3,4,5,6,7,8,9") > 0 ) 
      THEN NEXT.

    ASSIGN  vKey        = w_MenuObject.Menu_Item_Key
            vKeyValue   = w_MenuObject.Menu_Accelerator
            Key_Value   = vKeyValue
    . /* END ASSIGN */
        
    /*-----------------------------------------------------------------
        Get the key value. Do this regadless of PUT or GET mode.
        Then, if PUT mode and the key's value is different than
        what's currently in environment file, go ahead and save
        the new value.
    -----------------------------------------------------------------*/
    GET-KEY-VALUE SECTION p_Section KEY vKey VALUE vKeyValue .
    IF ( p_Mode BEGINS "PUT" )
    THEN DO:
        IF ( Key_Value <> vKeyValue )
        THEN DO:
            ASSIGN vKeyValue = Key_Value .
            PUT-KEY-VALUE SECTION p_Section KEY vKey VALUE vKeyValue NO-ERROR.
            IF ERROR-STATUS:ERROR AND Put_Failed = FALSE
            THEN DO:
                ASSIGN Put_Failed = TRUE.
                IF p_Mode = "PUT-ERROR" THEN
                  RUN adeshar/_puterr.p ( INPUT "menu" , INPUT p_Menu:WINDOW ).
            END.
        END.
    END.
    ELSE IF ( vKeyValue <> ? ) /* ( p_Mode = "GET" ) is implicit. */
    THEN DO:
        ASSIGN w_MenuObject.hMenu:ACCELERATOR = vKeyValue
               w_MenuObject.Menu_Accelerator  = vKeyValue
        . /* END ASSIGN. */
    END.
    
    /* Leave trailing comma - it doesn't cause any harm. */
    ASSIGN
        p_Menu_Accels = p_Menu_Accels + w_MenuObject.Menu_Item_Key
                                      + ":" 
                                      + w_MenuObject.Menu_Accelerator
                                      + ",".
  END. /* FOR */
 
  END. /* IF NOT RETRY */
  
  RUN adecomm/_setcurs.p ( INPUT "" ).

END. /* proc-main */
