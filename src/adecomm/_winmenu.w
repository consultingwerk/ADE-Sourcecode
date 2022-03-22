&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
/* Procedure Description
"Basic Window Template

Use this template to create a new window. Alter this default template or create new ones to accomodate your needs for different default sizes and/or attributes."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME WinMenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WinMenu 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File   : adecomm/_winmenu.w

    Purpose: Window Menu Manager Object manages a Window Menu's
             Active Window items.

    Notes  : 

    1.  The Window Menu and Active Window Items

        The Window menu's Active Window menu items are listed on
        the Window menu as follows:

             &Window
             +------------------+
             | Hide Palette     |
             +------------------+
             | &1 Title:1       |   
             |>&2 Title:2       |
             |    ....          |
             | &9 Title:9       |
             | &More Windows... |
             +------------------+

        * The Ampersand (&) indicates the menu access (mnemonic) keys.

        * The Window menu Active Window menu items are identified as the
          items starting from the bottom of the Window menu and going
          up until either there are no more items (all Window menu items
          are Active Window items) or until the first menu RULE is found.

          Given the example above, Hide Palette is not an Active Window
          menu item, but the items 1..9 and More are Active Window items.

        * The Window menu lists only 9 active windows. The menu labels are
          generally the Active Window Title Text. All active window items
          are check items. The (>) character in the example indicates
          the window that the user is currently active in.

        * If there are more than 9 active windows, a More Windows item
          displays as the last Window menu item. If the window the user
          is active in is not shown in the Window menu, the More Windows
          option is checked.

        * Choosing More Windows displays the Select Window dialog which
          lists the Active Window Titles in the order the windows were
          opened - from first opened to last.

        * When the user selects an active window from the Window menu or
          in the Select Window dialog, the Application should make the
          chosen window the active window. If the chosen window is an
          active window item on the Window menu, that item becomes checked.
          If it is not on the Window menu (i.e., part of More Windows),
          then More Windows becomes checked.


    2.  Window Menu Manager Object Responsibilities

        The Window Menu Manager Object Responsibilities are:

            * Add and remove active window menu items to/from a Window
              menu when called to do so by the Application.

            * Automatically renumber, check the active window menu
              item, and display/remove the More Windows menu item as
              active window items are added and removed by the Application.

            * Add new item's label text to Active window delimited list
              maintained in the MoreWindows NAME attribute and then
              make the MoreWindow the checked item.

              The delimited list maintained in the :NAME attribute to allow
              the Window Menu Object  to build the list to display in the Select
              Window dialog box.
              
            * Active Window items are identified by checking :PRIVATE-DATA
              = Unknown (?).

            * Attaches a callback trigger to the calling hProc using
              WinMenuChoose. The input to this procedure is the Label
              of the active window item chosen by the user.
              
              PROCEDURE WinMenuChoose must be maintained and properly
              written by the caller.

            * Displays the Select Windows dialog when the user
              chooses the More Windows option. Then calls PROCEDURE
              WinMenuChoose with the selected window title string.

    Author : J. Palazzo
    Created: April, 1995
    Updated:
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

DEFINE VAR Object-Name  AS CHARACTER INIT "_WINMENU"         NO-UNDO.
DEFINE VAR Ampersand    AS CHARACTER INIT "&"                NO-UNDO.
DEFINE VAR Nul          AS CHARACTER INIT ""                 NO-UNDO.
DEFINE VAR Delim        AS CHARACTER INIT ","                NO-UNDO.
DEFINE VAR Space_Char   AS CHARACTER INIT " "                NO-UNDO.
DEFINE VAR MoreWindows  AS CHARACTER INIT "&More Windows..." NO-UNDO.
DEFINE VAR hLastItem    AS HANDLE                            NO-UNDO.
DEFINE VAR MaxNum       AS INTEGER INIT 9                    NO-UNDO.
DEFINE VAR NextNum      AS INTEGER                           NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WinMenu AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_File_New     LABEL "&New"           ACCELERATOR "SHIFT-F3"
       MENU-ITEM m_Change_Item  LABEL "&Change Name..."
       MENU-ITEM m_Set_Active   LABEL "Set &Active"   
       MENU-ITEM m_Delete_Item  LABEL "&Delete Item..."
       MENU-ITEM m_File_Exit    LABEL "E&xit"         .

DEFINE SUB-MENU m_Window 
       MENU-ITEM m_Hide_Palette LABEL "Hide &Palette" .

DEFINE MENU MENU-BAR-WinMenu MENUBAR
       SUB-MENU  m_File         LABEL "&File"         
       SUB-MENU  m_Window       LABEL "&Window"       .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 16.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WinMenu ASSIGN
         HIDDEN             = YES
         TITLE              = "Window Menu Object"
         HEIGHT             = 16
         WIDTH              = 80
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-WinMenu:HANDLE.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WinMenu
  VISIBLE,,RUN-PERSISTENT                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WinMenu)
THEN WinMenu:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME WinMenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL WinMenu WinMenu
ON END-ERROR OF WinMenu /* Window Menu Object */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  RUN ClosePW.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL WinMenu WinMenu
ON WINDOW-CLOSE OF WinMenu /* Window Menu Object */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Change_Item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Change_Item WinMenu
ON CHOOSE OF MENU-ITEM m_Change_Item /* Change Name... */
DO:
  DEFINE VAR hItem      AS HANDLE   NO-UNDO.
  DEFINE VAR OldLabel   AS CHAR     FORMAT "x(30)" NO-UNDO.
  DEFINE VAR NewLabel   AS CHAR     FORMAT "x(30)" NO-UNDO.
  DEFINE VAR hWinMenu   AS HANDLE NO-UNDO.
  
  ASSIGN hItem = SELF:PARENT        /* File Menu */
         hItem = hItem:NEXT-SIBLING /* Window Menu */
         hWinMenu = hItem
         hItem = hWinMenu:LAST-CHILD
         OldLabel = hItem:NAME
         NewLabel = hItem:NAME.
         
  UPDATE OldLabel NewLabel
    WITH FRAME f VIEW-AS DIALOG-BOX IN WINDOW ACTIVE-WINDOW.
  
  RUN WinMenuChangeName IN THIS-PROCEDURE
      (INPUT hWinMenu ,
       INPUT OldLabel ,
       INPUT NewLabel ).
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Delete_Item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Delete_Item WinMenu
ON CHOOSE OF MENU-ITEM m_Delete_Item /* Delete Item... */
DO:
  DEFINE VAR hItem          AS HANDLE   NO-UNDO.
  DEFINE VAR hWinMenu       AS HANDLE   NO-UNDO.
  DEFINE VAR ActiveWindows  AS CHARACTER FORMAT "x(60)" 
                            VIEW-AS EDITOR SIZE 60 BY 5 NO-UNDO.
  DEFINE VAR ActiveItem     AS CHARACTER FORMAT "x(40)" NO-UNDO.
  
  ASSIGN hItem = SELF:PARENT        /* File Menu */
         hItem = hItem:NEXT-SIBLING /* Window Menu */
         hWinMenu = hItem
         . /* END ASSIGN */         

  RUN WinMenuGetActive IN THIS-PROCEDURE
      (OUTPUT ActiveWindows , OUTPUT ActiveItem ).
  
  UPDATE ActiveWindows SKIP
         ActiveItem
    WITH FRAME f VIEW-AS DIALOG-BOX IN WINDOW ACTIVE-WINDOW.

  RUN WinMenuRebuild IN THIS-PROCEDURE
      (INPUT hWinMenu ,
       INPUT ActiveWindows ,
       INPUT ActiveItem ,
       INPUT THIS-PROCEDURE ).
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_File_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_File_Exit WinMenu
ON CHOOSE OF MENU-ITEM m_File_Exit /* Exit */
DO:
  APPLY "WINDOW-CLOSE" TO {&WINDOW-NAME} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_File_New
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_File_New WinMenu
ON CHOOSE OF MENU-ITEM m_File_New /* New */
DO:
  DEFINE VAR hMenuItem  AS HANDLE NO-UNDO.
  

/*  RUN NewPW IN THIS-PROCEDURE. */
  
  RUN WinMenuAddItem IN THIS-PROCEDURE
     (INPUT   MENU m_Window:HANDLE ,
      INPUT   "Procedure Untitled:" + STRING( RANDOM(1,9) , "9") ,
      INPUT   THIS-PROCEDURE ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Set_Active
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Set_Active WinMenu
ON CHOOSE OF MENU-ITEM m_Set_Active /* Set Active */
DO:
  DEFINE VAR hItem      AS HANDLE   NO-UNDO.
  DEFINE VAR hWinMenu   AS HANDLE   NO-UNDO.
  DEFINE VAR ItemName   AS CHAR     FORMAT "x(30)" NO-UNDO.
  
  ASSIGN hItem = SELF:PARENT        /* File Menu */
         hItem = hItem:NEXT-SIBLING /* Window Menu */
         hWinMenu = hItem
         hItem = hItem:FIRST-CHILD  /* Hide Palette */
         hItem = hItem:NEXT-SIBLING /* Rule */
         hItem = hItem:NEXT-SIBLING
         ItemName = hItem:NAME
         . /* END ASSIGN */         
  
  UPDATE ItemName
    WITH FRAME f VIEW-AS DIALOG-BOX IN WINDOW ACTIVE-WINDOW.
  
  RUN WinMenuSetActive IN THIS-PROCEDURE
      ( INPUT hWinMenu , INPUT ItemName ).
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WinMenu 


/* ***************************  Main Block  *************************** */

/* This reference prevents the adecomm/_runcode.p procedure from deleting
   this persistent procedure.
*/
{adecomm/_adetool.i}

/* Don't set CURRENT-WINDOW. Dialog boxes should use ACTIVE-WINDOW. */
ASSIGN THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Enable the UI only of the window is not suppresed. */
  IF NOT {&WINDOW-NAME}:HIDDEN THEN
    RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Change_Name WinMenu 
PROCEDURE Change_Name :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_hMenuItem  AS HANDLE     NO-UNDO.
         /* Handle to Window menu Item to change label. */ 
  DEFINE INPUT PARAMETER p_OldName   AS CHARACTER  NO-UNDO.
         /* Old Menu Item Name text. */ 
  DEFINE INPUT PARAMETER p_NewName   AS CHARACTER  NO-UNDO.
         /* New Menu Item Name text. */ 

  DEFINE VAR hWinMenu  AS HANDLE NO-UNDO.
  DEFINE VAR hMenuItem AS HANDLE NO-UNDO.

  MAIN:
  DO:
    
    /* If the item to change is stored in the MoreWindow active
       window name list, update the list only. Note that when
       a Null is passed, treat it like removing the item. That's
       what the TRIM(REPLACE) does (kills double commas).
       
       Otherwise, change the label of the menu item passed by the caller.
    */
    IF ( p_hMenuItem:LABEL = MoreWindows ) THEN
    DO: 
        ASSIGN p_hMenuItem:NAME = REPLACE( p_hMenuItem:NAME ,
                                           p_OldName , p_NewName )
               p_hMenuItem:NAME = TRIM( REPLACE( p_hMenuItem:NAME, ",," , ","), ",")
        . /* END ASSIGN */
    END.
    ELSE
    DO:
        /* Change the menu item label. */
        ASSIGN p_hMenuItem:LABEL = REPLACE( p_hMenuItem:LABEL ,
                                            p_OldName , p_NewName )
               p_hMenuItem:NAME = p_NewName
               . /* END ASSIGN */
    END.
    RETURN.
    
  END. /* MAIN */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChooseItem WinMenu 
PROCEDURE ChooseItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_hMenuItem AS HANDLE      NO-UNDO.
         /* Handle to Window menu Item to "choose". */ 
  DEFINE INPUT  PARAMETER p_hProc    AS HANDLE      NO-UNDO.
         /* Handle to Procedure Object for the Window Menu. */ 

  DEFINE VAR hWinMenu  AS HANDLE NO-UNDO.
  DEFINE VAR hMenuItem AS HANDLE NO-UNDO.
  DEFINE VAR ItemName  AS CHAR   NO-UNDO.
  
  MAIN:
  DO ON STOP UNDO, LEAVE :
    
    IF (p_hMenuItem:LABEL = MoreWindows) THEN
    DO:
        RUN ChooseMoreWindows IN THIS-PROCEDURE
            ( INPUT p_hMenuItem , INPUT p_hProc , OUTPUT ItemName ).
        IF (ItemName = ?) OR (ItemName = "") THEN
        DO:
            ASSIGN SELF:CHECKED = NOT SELF:CHECKED .
            RETURN.
        END.
    END.        
    ELSE
        ASSIGN ItemName = p_hMenuItem:NAME .
        
    RUN WinMenuSetActive IN THIS-PROCEDURE
        (INPUT p_hMenuItem:PARENT /* Window menu */ ,
         INPUT ItemName ).
    RUN WinMenuChoose IN p_hProc ( INPUT ItemName ).
    
  END. /* MAIN */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChooseMoreWindows WinMenu 
PROCEDURE ChooseMoreWindows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_hMoreWindows AS HANDLE      NO-UNDO.
         /* Handle to Window menu More Windows Item. */ 
  DEFINE INPUT  PARAMETER p_hProc    AS HANDLE      NO-UNDO.
         /* Handle to Procedure Object for the Window Menu. */ 
  DEFINE OUTPUT PARAMETER p_ItemName     AS CHARACTER   NO-UNDO.
         /* Name of selected window. */ 

  DEFINE VAR ActiveWindows  AS CHARACTER NO-UNDO.

  MAIN:
  DO ON STOP UNDO, LEAVE :
    RUN WinMenuGetActive IN p_hProc
        (OUTPUT ActiveWindows , OUTPUT p_ItemName).
     
    RUN adecomm/_winmore.w (INPUT ActiveWindows , INPUT-OUTPUT p_ItemName ).

  END. /* MAIN */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClosePW WinMenu 
PROCEDURE ClosePW :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR OK_Close   AS LOGICAL NO-UNDO.
  
    /* Perform a Close All for any open Procedure Windows belonging to
       this object.
    */
    REPEAT ON STOP UNDO, LEAVE:
      RUN adecomm/_pwexit.p ( INPUT Object-Name /* PW Parent ID */ ,
                              OUTPUT OK_Close ).
      LEAVE.
    END.
    /* Cancel the close event. */
    IF OK_Close <> TRUE THEN RETURN ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateMenuItem WinMenu 
PROCEDURE CreateMenuItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_hWinMenu  AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER p_Name      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p_Data      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p_Label     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p_hProc     AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER p_hMenuItem AS HANDLE     NO-UNDO.
  
  /* MAIN */
  DO :
        CREATE MENU-ITEM p_hMenuItem
          ASSIGN TOGGLE-BOX     = TRUE
                 NAME           = p_Name
                 PRIVATE-DATA   = p_Data
                 LABEL          = p_Label
                 PARENT         = p_hWinMenu
          TRIGGERS:
                 ON VALUE-CHANGED
                    PERSISTENT RUN ChooseItem IN THIS-PROCEDURE
                                   (INPUT p_hMenuItem , INPUT p_hProc).
          END TRIGGERS
        . /* END CREATE */
        
  END. /* MAIN */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WinMenu _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WinMenu)
  THEN DELETE WIDGET WinMenu.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI WinMenu _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  VIEW FRAME DEFAULT-FRAME IN WINDOW WinMenu.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW WinMenu.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetItemHandle WinMenu 
PROCEDURE GetItemHandle :
/*----------------------------------------------------------------------
    Purpose   : Set a Window menu item as the only checked menu item.
    Notes     : Caller can run this procedure when a window becomes
                the active window.
----------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_hWinMenu  AS HANDLE    NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE INPUT  PARAMETER p_ItemName  AS CHARACTER NO-UNDO.
         /* Menu Item Name text. Typically the active window's title. */ 
  DEFINE OUTPUT PARAMETER p_hMenuItem AS HANDLE    NO-UNDO.
         /* Handle to Menu Item. */

  DEFINE VARIABLE hLastItem     AS HANDLE NO-UNDO.
  
  MAIN:
  DO ON STOP UNDO, LEAVE :

    /*------------------------------------------------------------
      Search from the last item on the Window menu up until
      either there are no more menu items or until first
      menu RULE is encountered. The RULE indicates the end of
      Active Window menu items.
    ------------------------------------------------------------*/
    IF NOT VALID-HANDLE( p_hWinMenu ) THEN RETURN.
    ASSIGN p_hMenuItem = p_hWinMenu:LAST-CHILD
           hLastItem   = p_hWinMenu:LAST-CHILD
           . /* END ASSIGN */
    
    /* Check active items 1..9 for the item. */
    DO WHILE VALID-HANDLE( p_hMenuItem )
             AND ( p_hMenuItem:SUBTYPE <> "RULE":U )
             AND ( p_hMenuItem:PRIVATE-DATA <> ? )
             AND ( p_hMenuItem:NAME <> p_ItemName ):
      ASSIGN p_hMenuItem = p_hMenuItem:PREV-SIBLING
             . /* END ASSIGN */
    END.
    IF VALID-HANDLE(p_hMenuItem)
       AND ( p_hMenuItem:SUBTYPE <> "RULE":U )
       AND ( p_hMenuItem:PRIVATE-DATA <> ? ) THEN RETURN.
    
    /* Otherwise, the item is a MoreWindows item, so return MoreWindows
       menu item handle.
    */
    IF (hLastItem:LABEL = MoreWindows) THEN
        ASSIGN p_hMenuItem = hLastItem.
    ELSE
        ASSIGN p_hMenuItem = ?.
        
  END. /* MAIN */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewPW WinMenu 
PROCEDURE NewPW :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO ON STOP UNDO, LEAVE:
    RUN adecomm/_pwmain.p (INPUT Object-Name
                                   /* PW Parent ID    */,
                         INPUT ""  /* Files to open   */,
                         INPUT ""  /* PW Command      */ ).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetChecked WinMenu 
PROCEDURE SetChecked :
/*----------------------------------------------------------------------
    Purpose   : Set a Window menu item as the active window.
    Notes     : Caller can run this procedure when a window becomes
                the active window.
----------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_hMenuItem AS HANDLE NO-UNDO.
         /* Handle to Window menu Item to set as the checked item. */ 

  DEFINE VAR hWinMenu  AS HANDLE NO-UNDO.
  DEFINE VAR hMenuItem AS HANDLE NO-UNDO.

  MAIN:
  DO ON STOP UNDO, LEAVE :
    
    IF NOT VALID-HANDLE( p_hMenuItem ) THEN RETURN.

    /*------------------------------------------------------------
      Search from the last item on the Window menu up until
      either there are no more menu items or until first
      menu RULE is encountered. The RULE indicates the end of
      Active Window menu items.

      Uncheck each Active Window menu item except for p_hMenuItem.
      That menu item gets checked.
    ------------------------------------------------------------*/
    ASSIGN hWinMenu  = p_hMenuItem:PARENT
           hMenuItem = hWinMenu:LAST-CHILD
           . /* END ASSIGN */
    
    DO WHILE VALID-HANDLE( hMenuItem )
             AND ( hMenuItem:SUBTYPE <> "RULE":U )
             AND ( hMenuItem:PRIVATE-DATA <> ? ):
      ASSIGN hMenuItem:CHECKED = ( hMenuItem = p_hMenuItem )
             hMenuItem         = hMenuItem:PREV-SIBLING
             . /* END ASSIGN */
    END.
  END. /* MAIN */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WinMenuAddItem WinMenu 
PROCEDURE WinMenuAddItem :
/*----------------------------------------------------------------------
    Purpose   : Add a Window menu Open Window menu item.
    Notes     : Run this procedure as the part of a File->Open process
                that opens a window you want on the Window menu.
----------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_hWinMenu  AS HANDLE    NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE INPUT  PARAMETER p_ItemLabel AS CHARACTER NO-UNDO.
         /* Menu Item Label text. Typically the window's title. */ 
  DEFINE INPUT  PARAMETER p_hProc    AS HANDLE    NO-UNDO.
         /* Handle to Procedure object for the Window. */ 
  
  DEFINE VAR hMenuItem AS HANDLE    NO-UNDO.
         /* Handle to Window menu item created. */ 
  DEFINE VAR hRule     AS HANDLE    NO-UNDO.
  
  MAIN:
  DO:
  
    IF NOT VALID-HANDLE( p_hWinMenu ) OR ( p_ItemLabel = Nul )
    THEN RETURN.

    ASSIGN hLastItem = p_hWinMenu:LAST-CHILD
           . /* END ASSIGN */
    IF hLastItem:LABEL = MoreWindows THEN RETURN.
    ELSE    
      DO:
        /*------------------------------------------------------------
          If the last item's PRIVATE-DATA is not Unknown, then
          treat it as a Window menu item this object needs to track.
          Since it is the last menu item, strip out the active window
          number. Otherwise, initialize as 1 and create a RULE above
          the first active window item.
        ------------------------------------------------------------*/
        /*------------------------------------------------------------
          Note: Substring starts at two to skip the (&) in the label
          and get right to the Window number.
        ------------------------------------------------------------*/
        IF (hLastItem:PRIVATE-DATA <> ?) THEN 
          NextNum  = INTEGER(SUBSTRING(hLastItem:LABEL,2,1,"CHARACTER":u)) + 1.
        ELSE DO:
            ASSIGN NextNum = 1.
            CREATE MENU-ITEM hRule
            ASSIGN SUBTYPE        = "RULE"
                   NAME           = "RULE":U
                   PRIVATE-DATA   = "RULE":U
                   PARENT         = p_hWinMenu
            . /* END CREATE */
        END.

        /*------------------------------------------------------------
          Add a numbered item to the Windows menu and make it the
          checked item.  If there are already the maximum nine (9)
          items, create the item as the MoreWindows item.
        ------------------------------------------------------------*/
        RUN CreateMenuItem IN THIS-PROCEDURE
            (INPUT p_hWinMenu               ,
             INPUT p_ItemLabel  /* :NAME */  ,
             INPUT p_ItemLabel /* :PRIVATE-DATA */ ,
             INPUT p_ItemLabel  /* :LABEL */ ,
             INPUT p_hProc     ,
             OUTPUT hMenuItem ).
        
        IF ( NextNum <= MaxNum ) THEN
          ASSIGN hMenuItem:LABEL = ( Ampersand
                                       + STRING( NextNum , "9" ) + Space_Char
                                       + p_ItemLabel ) .
        ELSE
          ASSIGN hMenuItem:LABEL        = MoreWindows
                 hMenuItem:NAME         = MoreWindows
                 hMenuItem:PRIVATE-DATA = MoreWindows
                 . /* END ASSIGN */
          
        RUN SetChecked IN THIS-PROCEDURE ( INPUT hMenuItem ) .
      END. /* OTHERWISE NOT MoreWindow */
      
  END. /* MAIN */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WinMenuChangeName WinMenu 
PROCEDURE WinMenuChangeName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_hWinMenu  AS HANDLE    NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE INPUT PARAMETER p_OldName   AS CHARACTER  NO-UNDO.
         /* Old Menu Item Name text. */ 
  DEFINE INPUT PARAMETER p_NewName   AS CHARACTER  NO-UNDO.
         /* New Menu Item Name text. */ 

  DEFINE VAR hMenuItem AS HANDLE NO-UNDO.

  MAIN:
  DO:
    RUN GetItemHandle ( INPUT p_hWinMenu , INPUT p_OldName , OUTPUT hMenuItem ).
    
    IF NOT VALID-HANDLE(hMenuItem) OR (hMenuItem:LABEL = MoreWindows) THEN RETURN.
    
    RUN Change_Name IN THIS-PROCEDURE
        (INPUT hMenuItem ,
         INPUT p_OldName ,
         INPUT p_NewName ).
         
  END. /* MAIN */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WinMenuChoose WinMenu 
PROCEDURE WinMenuChoose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_ItemName AS CHARACTER      NO-UNDO.
         /* Name of wctive window menu item chosen. */ 
    
  MESSAGE "NAME = " p_ItemName
    VIEW-AS ALERT-BOX IN WINDOW ACTIVE-WINDOW.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WinMenuGetActive WinMenu 
PROCEDURE WinMenuGetActive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER p_ActiveWindows AS CHARACTER  NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE OUTPUT PARAMETER p_ActiveItem    AS CHARACTER  NO-UNDO.

  DEFINE VAR hMenuItem AS HANDLE NO-UNDO.
  
  DO:
    ASSIGN hMenuItem = MENU m_Window:FIRST-CHILD.
    
    DO WHILE VALID-HANDLE( hMenuItem ) :
      IF ( hMenuItem:SUBTYPE <> "RULE":U )
         AND ( hMenuItem:PRIVATE-DATA <> ? )
         AND (hMenuItem:LABEL <> MoreWindows) THEN
          ASSIGN p_ActiveWindows = p_ActiveWindows + Delim + hMenuItem:NAME .
             
      ASSIGN hMenuItem   = hMenuItem:NEXT-SIBLING .
    END.
    ASSIGN p_ActiveWindows = TRIM(p_ActiveWindows , Delim)
           p_ActiveItem    = ENTRY( 1 , p_ActiveWindows )
           . /* END ASSIGN */
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WinMenuRebuild WinMenu 
PROCEDURE WinMenuRebuild :
/*------------------------------------------------------------------------------
  Purpose:    Rebuild the Window menu active window items and assign
              one as the current active window.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_hWinMenu      AS HANDLE    NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE INPUT PARAMETER p_ActiveWindows AS CHARACTER NO-UNDO.
         /* Delimited List of Active Window Names. */ 
  DEFINE INPUT PARAMETER p_ActiveItem    AS CHARACTER NO-UNDO.
         /* The Active Window Name to make the checked/active window. */
  DEFINE INPUT  PARAMETER p_hProc        AS HANDLE    NO-UNDO.
         /* Handle to Procedure object for the Window. */ 

  DEFINE VAR hMenuItem   AS HANDLE      NO-UNDO.
  DEFINE VAR hDeleteItem AS HANDLE      NO-UNDO.
  DEFINE VAR vItem       AS INTEGER     NO-UNDO.
  
  DO:
    ASSIGN hMenuItem = p_hWinMenu:FIRST-CHILD.
    
    /* Delete any existing active window items. */
    DO WHILE VALID-HANDLE( hMenuItem ) :
      IF ( hMenuItem:PRIVATE-DATA <> ? ) THEN
      DO:
        ASSIGN hDeleteItem = hMenuItem
               hMenuItem   = hMenuItem:NEXT-SIBLING
               . /* END ASSIGN */
        DELETE WIDGET hDeleteItem.
      END.
      ELSE
        ASSIGN hMenuItem   = hMenuItem:NEXT-SIBLING .
    END.
    
    /* Rebuild the active window items. */
    DO vItem = 1 TO NUM-ENTRIES( p_ActiveWindows ) :
        RUN WinMenuAddItem IN THIS-PROCEDURE
            (INPUT   p_hWinMenu ,
             INPUT   ENTRY( vItem , p_ActiveWindows ) ,
             INPUT   p_hProc ).
    END.
    
    /* Set the current active window as checked. */
    RUN WinMenuSetActive IN THIS-PROCEDURE
        ( INPUT p_hWinMenu , INPUT p_ActiveItem ).
    
    RETURN.
            
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WinMenuSetActive WinMenu 
PROCEDURE WinMenuSetActive :
/*----------------------------------------------------------------------
    Purpose   : Set a Window menu item as the only checked menu item.
    Notes     : Caller can run this procedure when a window becomes
                the active window.
----------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_hWinMenu  AS HANDLE    NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE INPUT  PARAMETER p_ItemName  AS CHARACTER NO-UNDO.
         /* Menu Item Name text. Typically the active window's title. */ 

  DEFINE VAR hMenuItem AS HANDLE NO-UNDO.

  MAIN:
  DO ON STOP UNDO, LEAVE :
    
    RUN GetItemHandle IN THIS-PROCEDURE
        (INPUT p_hWinMenu , INPUT p_ItemName , OUTPUT hMenuItem ).

    IF VALID-HANDLE( hMenuItem ) THEN
        RUN SetChecked IN THIS-PROCEDURE (INPUT hMenuItem ).
    
  END. /* MAIN */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


