/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*******************************************************************************
    Procedure : _dlgmnua.p

    Syntax    : RUN adecomm/_dlgmnua.p ( INPUT p_MenuBar , INPUT p_Exclude ) .

    Purpose   : Dialog box to allow user to query and assign menu accelerator
		keys.

    Parameters: INPUT
        INPUT     p_MenuBar : Handle to menu/menubar to query/assign.
                
        INPUT     p_Exclude : Comma-delimited list of Menu Labels (of a 
                              menubar) to exclude from the Menu lists.  
                              Pass Null ("") or Unknown (?) to not exclude
                              any menus.  If the & is passed for each menu
                              name, this routine strips the &'s out for you.
                            
                              Example: "Tools,Options,Help"

        RETURN-VALUE        : "OK" when user presses OK. Not set otherwise.
        
    Date      : 12/92

    Author    : John Palazzo
*******************************************************************************/

DEFINE INPUT PARAMETER p_MenuBar AS WIDGET-HANDLE NO-UNDO .
DEFINE INPUT PARAMETER p_Exclude AS CHAR          NO-UNDO .

/* ADE Standards Include */
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Help Context */
{ adecomm/commeng.i }

DEFINE WORK-TABLE w_MenuObject NO-UNDO
	FIELD hMenu AS WIDGET-HANDLE
	FIELD Menu_Label AS CHAR
	FIELD Menu_Item_Label AS CHAR
	FIELD Menu_Item_Key  AS CHAR 
	FIELD Menu_Accelerator AS CHAR
	.

DEFINE VARIABLE First_Menu_Label AS CHARACTER NO-UNDO.
DEFINE VARIABLE Temp_Logical     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE OK_Pressed       AS LOGICAL   NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Menus_List AS CHAR LABEL ""
    VIEW-AS COMBO-BOX INNER-LINES 7 SIZE 25 BY 1
            FONT ? NO-UNDO.

DEFINE VARIABLE MenuItems_List AS CHAR LABEL ""
    VIEW-AS SELECTION-LIST SINGLE SIZE 25 BY 6
            /* INNER-CHARS 15 INNER-LINES 9 */ 
            SCROLLBAR-V FONT ? NO-UNDO.

DEFINE VARIABLE Accelerators_List LIKE MenuItems_List LABEL "".

DEFINE BUTTON btn_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.

DEFINE BUTTON btn_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.

DEFINE BUTTON btn_Help LABEL "&Help"
    {&STDPH_OKBTN}.

DEFINE BUTTON btn_Record LABEL "&Record..."
    SIZE 15.00 BY {&H_OKBTN}.

DEFINE BUTTON btn_Clear LABEL "&Clear"
    SIZE 15.00 BY {&H_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE MA_Btn_Box    {&STDPH_OKBOX}.
&ENDIF
/* Dialog Box */    
FORM
    SKIP( {&TFM_WID} )
    " "   {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID}  )
    Menus_List {&AT_OKBOX} 
    SKIP ( {&TFM_WID} )  
    " " {&AT_OKBOX} VIEW-AS TEXT 
    " " AT 28 VIEW-AS TEXT
    MenuItems_List {&AT_OKBOX} 
    Accelerators_List
    { adecomm/okform.i
        &BOX    ="MA_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  =" "
        &HELP   ="btn_Help" 
    }
    btn_Record AT ROW-OF Accelerators_List COLUMN 58
    SKIP( {&VM_WID} )
    btn_Clear  AT 58
    WITH FRAME dlg_Menus TITLE  "Menu Accelerators"  SIDE-LABEL
         VIEW-AS DIALOG-BOX
         DEFAULT-BUTTON btn_OK 
         CANCEL-BUTTON btn_Cancel.

/* Explicitly position and display labels. */
RUN PutLabel ( INPUT Menus_list:HANDLE IN FRAME dlg_Menus ,
               INPUT "x" ). /* kludge: need to put out first time because of core change */               
RUN PutLabel ( INPUT Menus_list:HANDLE IN FRAME dlg_Menus ,
               INPUT "&Menu" ). 
RUN PutLabel ( INPUT MenuItems_list:HANDLE IN FRAME dlg_Menus ,
               INPUT "x" ). /* kludge: need to put out first time because of core change */               
RUN PutLabel ( INPUT MenuItems_list:HANDLE IN FRAME dlg_Menus ,
               INPUT "Menu &Items" ).
RUN PutLabel ( INPUT Accelerators_List:HANDLE IN FRAME dlg_Menus ,
               INPUT "&Accelerator Keys" ).  

{ adecomm/okrun.i
    &FRAME  = "FRAME dlg_Menus"
    &BOX    = "MA_Btn_Box"
    &OK     = "btn_OK"
    &HELP   = "btn_Help"
}

/*------------------- UI Triggers -------------------*/
ON HELP OF FRAME DLG_Menus ANYWHERE
  RUN adecomm/_adehelp.p
      ( INPUT "comm" , INPUT "CONTEXT" , INPUT {&Menu_Accelerators} , INPUT ? ).

ON CHOOSE OF btn_Help IN FRAME DLG_Menus
  RUN adecomm/_adehelp.p
      ( INPUT "comm" , INPUT "CONTEXT" , INPUT {&Menu_Accelerators} , INPUT ? ).

ON VALUE-CHANGED OF Menus_List IN FRAME DLG_Menus
DO:

  DEFINE VARIABLE vMenu_Label        AS CHAR NO-UNDO .  
  DEFINE VARIABLE vMenuItems_List    AS CHAR NO-UNDO.
  DEFINE VARIABLE vAccelerators_List AS CHAR NO-UNDO.
  
  vMenu_Label = Menus_List:SCREEN-VALUE IN FRAME DLG_Menus.

  /* Re-Build the Menu Item list for the new item. Build list first and then
     replace the entire LIST-ITEMS intead of using ADD-LAST.
  */
  FOR EACH w_MenuObject WHERE w_MenuObject.Menu_Label = vMenu_Label:
    /* Exclude Most Recently Used file list menu items - MRU file menu items
       begins with a number 1-9 followed by the file name */
    IF ( LOOKUP ( SUBSTRING(w_MenuObject.Menu_Item_Label, 1, 1), "1,2,3,4,5,6,7,8,9") > 0 )
      THEN NEXT.

    ASSIGN vMenuItems_List    = vMenuItems_List + "," +
                                w_MenuObject.Menu_Item_Label
           vAccelerators_List = vAccelerators_List + "," +
                                w_MenuObject.Menu_Accelerator
           .
  END.
  
  /* Display new lists.  SUBSTRING is used to remove leading comma added from
     the above FOR EACH.
  */
  ASSIGN
    vMenuItems_List    = SUBSTRING(vMenuItems_List,2,-1,"CHARACTER":u)
    vAccelerators_List = SUBSTRING(vAccelerators_List,2,-1,"CHARACTER":u)
    MenuItems_List:LIST-ITEMS IN FRAME DLG_Menus = ( vMenuItems_List )
    Accelerators_List:LIST-ITEMS IN FRAME DLG_Menus = ( vAccelerators_List )
  
    MenuItems_List:SCREEN-VALUE IN FRAME DLG_Menus = 
		   ENTRY( 1 , MenuItems_List:LIST-ITEMS IN FRAME DLG_Menus )
    Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus = 
		   ENTRY( 1 , Accelerators_List:LIST-ITEMS IN FRAME DLG_Menus )
    . /* END ASSIGN */

  RUN ClearButtonSetState .  /* Toggles Enable State as needed. */
END.

ON VALUE-CHANGED OF MenuItems_List IN FRAME DLG_Menus
DO:
  DEFINE VARIABLE vMenu_Label AS CHAR NO-UNDO .
  DEFINE VARIABLE vMenu_Item_Label AS CHAR NO-UNDO .

  vMenu_Label = Menus_List:SCREEN-VALUE IN FRAME DLG_Menus.
  vMenu_Item_Label = MenuItems_List:SCREEN-VALUE IN FRAME DLG_Menus.

  FIND FIRST w_MenuObject WHERE w_MenuObject.Menu_Label = vMenu_Label AND
  			w_MenuObject.Menu_Item_Label = vMenu_Item_Label.
  Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus = 
  				( IF ( w_MenuObject.Menu_Accelerator = ? )
  				  THEN ""
    				  ELSE w_MenuObject.Menu_Accelerator ) .
  RUN ClearButtonSetState .  /* Toggles Enable State as needed. */
END.

ON VALUE-CHANGED OF Accelerators_List IN FRAME DLG_Menus
DO:

  DEFINE VARIABLE vMenu_Label AS CHAR NO-UNDO .
  DEFINE VARIABLE vMenu_Accelerator AS CHAR NO-UNDO .

  IF (Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus <> ? AND
      Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus <> "") THEN
  DO: 
    ASSIGN vMenu_Label       = Menus_List:SCREEN-VALUE IN FRAME DLG_Menus
           vMenu_Accelerator = Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus.
  
    FIND FIRST w_MenuObject WHERE ( w_MenuObject.Menu_Label = vMenu_Label ) AND
  				  ( w_MenuObject.Menu_Accelerator = 
                                    vMenu_Accelerator )
  			    NO-ERROR.
    ASSIGN MenuItems_List:SCREEN-VALUE IN FRAME DLG_Menus = 
                          w_MenuObject.Menu_Item_Label.
    RUN ClearButtonSetState .  /* Toggles Enable State as needed. */
  END.
  ELSE
  DO:
    /* We can't tell which menu item to select based on the Accelerator
       Key. So reset selected item in Accelerator selection list to
       correspond to what's currently selected in Menu Item list.
    */
    APPLY "VALUE-CHANGED" TO MenuItems_List.
  END.
END.


ON CHOOSE OF btn_Clear IN FRAME DLG_Menus
DO:
  DEFINE VARIABLE vMenu_Label AS CHAR NO-UNDO .
  DEFINE VARIABLE vMenu_Item_Label AS CHAR NO-UNDO .
  DEFINE VARIABLE vMenu_Accelerator AS CHAR NO-UNDO .

  /* Do I need to test for this?  ClearButtonSetState disables btn_Clear. */
  IF Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus = ? THEN RETURN.
  
  vMenu_Label = Menus_List:SCREEN-VALUE IN FRAME DLG_Menus.
  vMenu_Item_Label = MenuItems_List:SCREEN-VALUE IN FRAME DLG_Menus.
  vMenu_Accelerator = Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus.
  /*------------------------------------------------------------------------- 
     Clear the Accelerator Key by replacing its value with Null (""). 
     Cannot use UNKNOWN(?) - not a value assignable to SELECTION-LIST:VALUE
     or :LIST-ITEM.
  -------------------------------------------------------------------------*/
  Temp_Logical = Accelerators_List:REPLACE( "" , Accelerators_List:SCREEN-VALUE 
  				IN FRAME DLG_Menus ) IN FRAME DLG_Menus .

  FIND FIRST w_MenuObject WHERE w_MenuObject.Menu_Label = vMenu_Label AND
  			w_MenuObject.Menu_Item_Label = vMenu_Item_Label AND
  			w_MenuObject.Menu_Accelerator = vMenu_Accelerator.
  w_MenuObject.Menu_Accelerator = "".
  RUN ClearButtonSetState .  /* Toggles Enable State as needed. */
END.

ON DEFAULT-ACTION OF Menus_List           IN FRAME DLG_Menus
   OR DEFAULT-ACTION OF MenuItems_List    IN FRAME DLG_Menus
   OR DEFAULT-ACTION OF Accelerators_List IN FRAME DLG_Menus
APPLY "CHOOSE" TO btn_Record IN FRAME DLG_Menus .

ON CHOOSE OF btn_Record IN FRAME DLG_Menus
DO:
  DEFINE VARIABLE vMenu_Label        AS CHAR NO-UNDO .
  DEFINE VARIABLE vMenu_Item_Label   AS CHAR NO-UNDO.
  DEFINE VARIABLE vMenu_Accelerator  AS CHAR NO-UNDO.
  DEFINE VARIABLE vAccelerators_List AS CHAR NO-UNDO.

  vMenu_Label      = Menus_List:SCREEN-VALUE     IN FRAME DLG_Menus.
  vMenu_Item_Label = MenuItems_List:SCREEN-VALUE IN FRAME dlg_Menus.
  FIND FIRST w_MenuObject WHERE ( w_MenuObject.Menu_Label      = vMenu_Label )
  			  AND	( w_MenuObject.Menu_Item_Label = 
                                                            vMenu_Item_Label )
  			  . 
  vMenu_Accelerator = w_MenuObject.Menu_Accelerator .

  RUN adecomm/_dlgrecm.p (INPUT vMenu_Item_Label , INPUT-OUTPUT vMenu_Accelerator ) .
  IF vMenu_Accelerator = w_MenuObject.Menu_Accelerator THEN RETURN.

  FIND FIRST w_MenuObject WHERE ( w_MenuObject.Menu_Accelerator =
                                  vMenu_Accelerator )
  			AND	( ( w_MenuObject.Menu_Label <> vMenu_Label  ) OR
				( w_MenuObject.Menu_Item_Label <>
                                  vMenu_Item_Label ) )
  			NO-ERROR.
  IF AVAILABLE ( w_MenuObject )
  THEN DO:
    MESSAGE vMenu_Accelerator
      SKIP(1.0)
      "Cannot assign accelerator key."
      SKIP(1.0)
      "This key sequence is already assigned to"
       w_MenuObject.Menu_Item_Label "on the" w_MenuObject.Menu_Label "menu."
      SKIP
      "Try a different key sequence or clear the existing one and record again."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.

  /*------------------------------------------------------------------------- 
     Only pressing OK saves the new accelerators to the menu items.
     Until then, it is stored in the worktable field.
  -------------------------------------------------------------------------*/
  FIND FIRST w_MenuObject WHERE (w_MenuObject.Menu_Label      = vMenu_Label )
                          AND  (w_MenuObject.Menu_Item_Label = vMenu_Item_Label)
  			  .
  ASSIGN w_MenuObject.Menu_Accelerator = vMenu_Accelerator.

  /* Re-Build the Accelerator list. */
  FOR EACH w_MenuObject WHERE ( w_MenuObject.Menu_Label = vMenu_Label ) :
    ASSIGN vAccelerators_List = vAccelerators_List + "," + 
                                w_MenuObject.Menu_Accelerator
           .
  END.
  ASSIGN vAccelerators_List = SUBSTRING(vAccelerators_List,2,-1,"CHARACTER":u)
         Accelerators_List:LIST-ITEMS IN FRAME DLG_Menus = vAccelerators_List
         . /* END ASSIGN */
         
  APPLY "VALUE-CHANGED" TO MenuItems_List IN FRAME DLG_Menus.
  APPLY "ENTRY" TO MenuItems_List IN FRAME Dlg_Menus. 
  
END.

ON GO OF FRAME DLG_Menus
DO:
    DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY:
      IF NOT RETRY
      THEN DO:
        RUN adecomm/_setcurs.p ( INPUT "WAIT" ) NO-ERROR.
        /* <> "" Skips Top-level Menubar items & Items which are sub-menu items. */
        FOR EACH w_MenuObject WHERE w_MenuObject.Menu_Label <> "" :
    	   /* Cannot assign (?) to :ACCELERATOR, so re-assign as NULL(""). */
    	   w_MenuObject.Menu_Accelerator = ( IF (w_MenuObject.Menu_Accelerator = ?)
    					       THEN ""
    					       ELSE w_MenuObject.Menu_Accelerator ).
            w_MenuObject.hMenu:ACCELERATOR = w_MenuObject.Menu_Accelerator.
        END. 
      END.
      RUN adecomm/_setcurs.p ( INPUT "" ) NO-ERROR.
      ASSIGN OK_Pressed = YES.
    END. /* ON STOP */
END.
        
PROCEDURE PutLabel.
    DEFINE INPUT PARAMETER p_Widget AS WIDGET     NO-UNDO.
    DEFINE INPUT PARAMETER p_Label  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hLabel AS WIDGET NO-UNDO.
   
ASSIGN hLabel       = p_Widget:SIDE-LABEL-HANDLE.
ASSIGN hLabel:WIDTH = FONT-TABLE:GET-TEXT-WIDTH-CHARS ( p_Label , hLabel:FONT ) NO-ERROR.
ASSIGN hLabel:SCREEN-VALUE = p_Label NO-ERROR.
ASSIGN hLabel:ROW   = p_Widget:ROW - 1  /* ( 1 - {&VM_WID} ) Ryan 9/94 */ NO-ERROR.
ASSIGN hLabel:COL   = p_Widget:COL NO-ERROR.

END PROCEDURE.


PROCEDURE ClearButtonSetState .

  btn_Clear:SENSITIVE IN FRAME DLG_Menus = 
  		( Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus <> ? )
  	   AND	( Accelerators_List:SCREEN-VALUE IN FRAME DLG_Menus <> "" ).
  
END PROCEDURE.


PROCEDURE MenuTree.

  DEFINE INPUT PARAMETER p_Menu AS WIDGET-HANDLE.
  DEFINE INPUT PARAMETER p_Parent AS CHAR.

  DEFINE VAR hMenu_Item AS WIDGET-HANDLE.
  DEFINE VAR Item_Label AS CHAR.

  IF CAN-QUERY( p_Menu , "LABEL" ) 
  THEN DO:
       Item_Label = p_Menu:LABEL .
       Item_Label = REPLACE( Item_Label , "&" , "" ). /* Take out if you want & */
  END.
  IF ( Item_Label <> ? ) AND ( Item_Label <> "" )
  THEN DO:
       CREATE w_MenuObject.
       ASSIGN w_MenuObject.hMenu = p_Menu
              w_MenuObject.Menu_Label = IF CAN-QUERY( p_Menu , "FIRST-CHILD" )
              				THEN "" ELSE p_Parent
              w_MenuObject.Menu_Item_Label = Item_Label /* ie, p_Menu:LABEL */
              .
       IF CAN-QUERY( p_Menu , "ACCELERATOR" )
       THEN w_MenuObject.Menu_Accelerator = 
       				( IF ( p_Menu:ACCELERATOR <> ? )
            			  THEN p_Menu:ACCELERATOR
            			  ELSE "" ) .
       ELSE p_Parent = Item_Label . /* ie, p_Menu:LABEL */
  END.
    
  IF CAN-QUERY ( p_Menu , "FIRST-CHILD" ) 
  THEN DO:
       hMenu_Item = p_Menu:FIRST-CHILD.
       IF ( hMenu_Item <> ? )
       THEN RUN MenuTree( hMenu_Item , p_Parent ).
  END.
  IF ( CAN-QUERY( p_Menu , "NEXT-SIBLING" ) = FALSE )
      THEN RETURN.
  ASSIGN hMenu_Item = p_Menu:NEXT-SIBLING.
  IF ( hMenu_Item <> ? )
  THEN RUN MenuTree( hMenu_Item , p_Parent ).
  
END PROCEDURE.


MAIN:
DO ON STOP   UNDO, RETRY
   ON ERROR  UNDO, RETRY
   ON ENDKEY UNDO, RETRY:

  IF NOT RETRY
  THEN DO:

    IF ( p_MenuBar = ? ) THEN RETURN.

    RUN adecomm/_setcurs.p ( INPUT "WAIT" ) NO-ERROR.


    /* Build the Work-Table which contains the Menu Tree information */
    RUN MenuTree ( p_MenuBar  , "" ).

    /* Remove unwanted menus and menu items. */
    IF ( p_Exclude <> "" ) AND ( p_Exclude <> ? )
    THEN DO:
        /* Be sure there are no &'s imbedded in the Menus to exclude list. */
        ASSIGN p_Exclude = REPLACE( p_Exclude , "&" , "" ).
        FOR EACH w_MenuObject:
            /* Remove unwanted menus. */
            IF ( w_MenuObject.Menu_Label = "" ) AND
                ( LOOKUP( w_MenuObject.Menu_Item_Label , p_Exclude ) > 0 )
                THEN DELETE w_MenuObject.
            /* Remove unwanted menu items. */
            ELSE IF ( LOOKUP( w_MenuObject.Menu_Label , p_Exclude ) > 0 )
                THEN DELETE w_MenuObject.
        END.
    END.

    /* Build the Menus List. */
    FOR EACH w_MenuObject WHERE w_MenuObject.Menu_Label = "":
        Temp_Logical = Menus_List:ADD-LAST( w_MenuObject.Menu_Item_Label )
    					       IN FRAME DLG_Menus  .
    END.

    /* Build the Menu Item list for the first item. */
    FIND FIRST w_MenuObject WHERE w_MenuObject.Menu_Label = "" .
    First_Menu_Label = w_MenuObject.Menu_Item_Label.
    FOR EACH w_MenuObject WHERE w_MenuObject.Menu_Label = First_Menu_Label:

        /* Exclude Most Recently Used file list menu items - MRU file menu items
           begins with a number 1-9 followed by the file name */
        IF ( LOOKUP ( SUBSTRING(w_MenuObject.Menu_Item_Label, 1, 1), "1,2,3,4,5,6,7,8,9") > 0 )
          THEN NEXT.

        Temp_Logical = MenuItems_List:ADD-LAST(  w_MenuObject.Menu_Item_Label )
                                                    IN FRAME DLG_Menus .
        Temp_Logical = Accelerators_List:ADD-LAST( w_MenuObject.Menu_Accelerator )
                                                    IN FRAME DLG_Menus.
    END.

    ASSIGN Menus_List:SCREEN-VALUE IN FRAME dlg_Menus = 
                ENTRY( 1 , Menus_List:LIST-ITEMS IN FRAME dlg_Menus )
                                             
           MenuItems_List:SCREEN-VALUE IN FRAME dlg_Menus = 
                ENTRY( 1 , MenuItems_List:LIST-ITEMS IN FRAME Dlg_Menus )

           Accelerators_List:SCREEN-VALUE IN FRAME dlg_Menus =
                ENTRY( 1 , Accelerators_List:LIST-ITEMS IN FRAME DLG_Menus )
    . /* END ASSIGN */

    ENABLE Menus_List MenuItems_List Accelerators_list
            btn_Record btn_Clear btn_OK btn_Cancel btn_Help
            WITH FRAME dlg_Menus.

    RUN ClearButtonSetState.
    
    RUN adecomm/_setcurs.p ( INPUT "" ) NO-ERROR.
 
    SET Menus_List GO-ON( GO,WINDOW-CLOSE )
        WITH FRAME DLG_Menus.
  END.  /* IF NOT RETRY */

  RUN adecomm/_setcurs.p ( INPUT "" ) NO-ERROR.
  IF OK_Pressed THEN RETURN "OK":U.
  
END. /* MAIN */
