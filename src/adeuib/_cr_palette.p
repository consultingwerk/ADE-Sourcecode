
/*------------------------------------------------------------------------
    File        : _cr_palette.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Mon Nov 17 00:30:14 EST 2008
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hwin AS HANDLE NO-UNDO.

{adeuib/sharvars.i}
{adecomm/_adetool.i} /* ADEpersistent */

/* Menus for the Toolbox */
DEFINE SUB-MENU m_tb_options
       &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
       MENU-ITEM mi_top_only      LABEL "&Top-Only Window"   TOGGLE-BOX
       &ENDIF
       MENU-ITEM mi_menu_only     LABEL "Show &Menu Only"    TOGGLE-BOX
       MENU-ITEM mi_save_palette  LABEL "&Save Palette"
       .

DEFINE SUB-MENU m_ocx_options
       MENU-ITEM mi_ocx_palette     LABEL "Add as &Palette Icon"
       MENU-ITEM mi_ocx_submenu     LABEL "Add to Palette &SubMenu"
       .
DEFINE SUB-MENU m_Toolbox
       SUB-MENU m_tb_options       LABEL "&Options"
       MENU-ITEM mi_get_custom     LABEL "&Use Custom..."
       SUB-MENU m_ocx_options	   LABEL "&Add OCX"
       RULE
       /* The rest of this menu is created Dynamically */
       .

DEFINE MENU mb_toolbox MENUBAR
       SUB-MENU m_Toolbox       LABEL "&Menu"
       .
  hwin =  _h_object_win.     
  /* Create object palette window */
  RUN adeuib/_cr_palw.p(MENU mb_toolbox:HANDLE).
  
/*  /* Set initial states on palette menubar */                     */
/*  IF _palette_menu THEN                                           */
/*    ASSIGN MENU-ITEM mi_menu_only:CHECKED IN MENU m_toolbox = yes.*/
/*  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN                    */
/*  IF _palette_top  THEN                                           */
/*    ASSIGN MENU-ITEM mi_top_only:CHECKED IN MENU m_toolbox = yes. */
/*  &ENDIF                                                          */

  /* Create the widget palette icons (and custom widget extensions). */
  RUN adeuib/_cr_pal.p (no).  

  RUN adeuib/_cr_cmnu.p(MENU m_toolbox:HANDLE). /* create custom menus */
  _h_object_win = hwin.     
        