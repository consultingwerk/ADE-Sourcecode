&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _modpath.w

  Description: Let the user view and modify the PROPATH attribute.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Wm.T.Wood 

  Created: 08/03/93 - 12:59 pm
  
  Modified: 1/94 by RPR
    wood 7/5/95 - Use standard "adeshar/_dirname.p" when user adds a directory
                - change label of b_Add to "Add..."

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER        pDirList     AS CHAR NO-UNDO. 
DEFINE INPUT PARAMETER        pShow3D      AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pCurrentPath AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER       pNewList     AS CHAR NO-UNDO.

DEFINE VARIABLE i                AS INTEGER NO-UNDO. 
DEFINE VARIABLE DirectoryPresent AS LOGICAL NO-UNDO. 

&GLOBAL-DEFINE WIN95-BTN YES
&IF LOOKUP(OPSYS, "MSDOS,WIN32":u) > 0 &THEN
  &Scoped-define DIR-SLASH ~~~\
&ELSE 
  &Scoped-define DIR-SLASH /
&ENDIF  

&Global-define SKP ""

/* Include Files.... */
{adecomm/commeng.i}   /* Help Context stings. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS path-list b_add b_delete RECT-6 b_move_up ~
b_move_down 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_add 
     LABEL "&Add...":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_delete 
     LABEL "&Remove":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_move_down 
     LABEL "Move &Down":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_move_up 
     LABEL "Move &Up":L 
     SIZE 15 BY 1.14.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 12 BY .19.

DEFINE VARIABLE path-list AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 34.8 BY 6.14 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f
     path-list AT ROW 1.52 COL 3 NO-LABEL
     b_add AT ROW 1.52 COL 38.8
     b_delete AT ROW 2.81 COL 38.8
     b_move_up AT ROW 5.05 COL 39
     b_move_down AT ROW 6.38 COL 39
     RECT-6 AT ROW 4.38 COL 39.8
     SPACE(2.99) SKIP(3.28)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         TITLE "Edit Path":L.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f
   UNDERLINE Default                                                    */
ASSIGN 
       FRAME f:SCROLLABLE       = FALSE
       FRAME f:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b_add IN FRAME f
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_delete IN FRAME f
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_move_down IN FRAME f
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_move_up IN FRAME f
   NO-DISPLAY                                                           */
/* SETTINGS FOR SELECTION-LIST path-list IN FRAME f
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX f
/* Query rebuild information for DIALOG-BOX f
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX f */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f f
ON WINDOW-CLOSE OF FRAME f /* Edit Path */
DO:
   /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_add f
ON CHOOSE OF b_add IN FRAME f /* Add... */
DO:    
  DEFINE VAR l_ok     AS LOGICAL NO-UNDO.
  DEFINE VAR new_dir  AS CHAR NO-UNDO.
  DEFINE VAR test_dir AS CHAR NO-UNDO.
  
  /* Get a new directory name. */
  RUN adeshar/_dirname.p
         ( INPUT        "Add Directory to Path", /* Dialog Title Bar */
           INPUT        NO,                      /* YES is \'s converted to /'s */
           INPUT        YES,                     /* YES if directory must exist */
           INPUT        "comm",                  /* ADE Tool (used for help call) */
           INPUT        {&Add_Dir_Path_Dlg_Box}, /* Context ID for HELP call */
           INPUT-OUTPUT new_dir ,                /* File Spec entered */
           OUTPUT       l_ok                     /* YES if user hits OK */
         ) .
  /* Make sure the user hit "OK".  Check the new directory to make sure
     it really is new. */
  IF l_ok THEN DO:    
    ASSIGN FILE-INFO:FILE-NAME = new_dir
           DirectoryPresent    = NO
           /* Convert the \'s to /'s for the upcoming test. */
           new_dir = REPLACE (new_dir, "~\":U, "~/":U)
           .
    /* Before adding this to the list-items, cycle through the list-items
       to insure that we don't already have this directory.  */ 
    TEST-BLOCK:
    DO i = 1 TO NUM-ENTRIES(path-list:LIST-ITEMS,","):  
      ASSIGN test_dir = TRIM(ENTRY(2, ENTRY(i,path-list:LIST-ITEMS,",":u),") ":u))
             test_dir = REPLACE (test_dir, "~\":U, "~/":U)
             .
      IF test_dir = new_dir THEN DO:
        DirectoryPresent = TRUE. 
        LEAVE TEST-BLOCK.
      END.
    END.
  
    IF DirectoryPresent THEN
      MESSAGE FILE-INFO:FILENAME SKIP(1)
              "This directory is already in the list." {&SKP}
              "It will not be added again."
        VIEW-AS ALERT-BOX ERROR.
    ELSE
      l_ok = path-list:ADD-FIRST ("  0) " + FILE-INFO:FILENAME).
    
    IF l_ok THEN DO:
      RUN number_path.
      path-list:SCREEN-VALUE = path-list:ENTRY(1).
    END.
  END.
END.      

/**************************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_delete f
ON CHOOSE OF b_delete IN FRAME f /* Remove */
DO:
  DEFINE VAR i      AS INTEGER NO-UNDO.
  DEFINE VAR choice AS CHAR NO-UNDO.
  DEFINE VAR l_ok   AS LOGICAL NO-UNDO.
  
  choice = path-list:SCREEN-VALUE. 
  IF Path-list:NUM-ITEMS <= 1 THEN DO:
    MESSAGE "You cannot delete all directories from a path list." 
      VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.
  
  DO i = 1 TO NUM-ENTRIES(choice):
    l_ok = path-list:DELETE(ENTRY(i,choice)).
  END.
  /* Renumber the path */
  RUN number_path.
  path-list:SCREEN-VALUE = path-list:ENTRY(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_move_down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_move_down f
ON CHOOSE OF b_move_down IN FRAME f /* Move Down */
DO:
  DEFINE VAR i           AS INTEGER NO-UNDO.
  DEFINE VAR ipos        AS INTEGER NO-UNDO.
  DEFINE VAR choice      AS CHAR NO-UNDO.
  DEFINE VAR swap-item   AS CHAR NO-UNDO.
  DEFINE VAR choice-item AS CHAR NO-UNDO.
  DEFINE VAR new-swap    AS CHAR NO-UNDO.
  DEFINE VAR new-choice  AS CHAR NO-UNDO.
  DEFINE VAR l_ok        AS LOGICAL NO-UNDO.
  
  ASSIGN choice = path-list:SCREEN-VALUE.
  DO i = NUM-ENTRIES(choice) TO 1 BY -1:
    ASSIGN choice-item = ENTRY(i,choice) 
           ipos        = INTEGER(SUBSTRING(choice-item,1,3, "CHARACTER":u)).
    IF ipos < path-list:NUM-ITEMS THEN DO:
      /* Get the item above the current choice and swap it with the current 
         choice.  Change the line numbers of the choice to the swapped line 
         number (this is the first 3 characters). */
      swap-item  = path-list:ENTRY(ipos + 1).
      IF LOOKUP(swap-item,choice) eq 0 THEN 
        ASSIGN
          new-choice      = choice-item
          new-swap        = swap-item
          SUBSTRING(new-swap,1,3, "CHARACTER":u)   = 
            SUBSTRING(choice-item,1,3, "CHARACTER":u)
          SUBSTRING(new-choice,1,3, "CHARACTER":u) = 
            SUBSTRING(swap-item,1,3, "CHARACTER":u)
          l_ok            = path-list:REPLACE(new-swap, choice-item)
          l_ok            = path-list:REPLACE(new-choice, swap-item)
          ENTRY(i,choice) = new-choice.
    END.
  END.
  /* reset the value of the choice. */
  path-list:SCREEN-VALUE = choice.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_move_up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_move_up f
ON CHOOSE OF b_move_up IN FRAME f /* Move Up */
DO:
  DEFINE VAR i           AS INTEGER NO-UNDO.
  DEFINE VAR ipos        AS INTEGER NO-UNDO.
  DEFINE VAR choice      AS CHAR NO-UNDO.
  DEFINE VAR swap-item   AS CHAR NO-UNDO.
  DEFINE VAR choice-item AS CHAR NO-UNDO.
  DEFINE VAR new-swap    AS CHAR NO-UNDO.
  DEFINE VAR new-choice  AS CHAR NO-UNDO.
  DEFINE VAR l_ok        AS LOGICAL NO-UNDO.
  
  ASSIGN choice = path-list:SCREEN-VALUE.
  DO i = 1 TO NUM-ENTRIES(choice):
    ASSIGN choice-item = ENTRY(i,choice) 
           ipos        = INTEGER(SUBSTRING(choice-item,1,3, "CHARACTER":u)).
    IF ipos > 1 THEN DO:
      /* Get the item above the current choice and swap it with the current 
         choice.  Change the line numbers of the choice to the swapped line 
         number (this is the first 3 characters). */
      swap-item  = path-list:ENTRY(ipos - 1).
      IF LOOKUP(swap-item,choice) eq 0 THEN 
        ASSIGN
          new-choice      = choice-item
          new-swap        = swap-item
          SUBSTRING(new-swap,1,3, "CHARACTER":u)   = 
            SUBSTRING(choice-item,1,3, "CHARACTER":u)
          SUBSTRING(new-choice,1,3, "CHARACTER":u) = 
            SUBSTRING(swap-item,1,3, "CHARACTER":u)
          l_ok            = path-list:REPLACE( new-swap, choice-item)
          l_ok            = path-list:REPLACE( new-choice, swap-item)
          ENTRY(i,choice) = new-choice.
    END.
  END.
  /* reset the value of the choice. */
  path-list:SCREEN-VALUE = choice.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f 


/* ********************* Sullival Bar Standards ********************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Make the Frame 3D. */
ASSIGN FRAME {&frame-name}:THREE-D = pShow3D.

{ adecomm/commeng.i }
{ adecomm/okbar.i &TOOL = "COMM"
                 &CONTEXT = {&Edit_Path_Dlg_Box} }

/* ***************************  Main Block  *************************** */

ASSIGN
  path-list:INNER-LINES IN FRAME {&FRAME-NAME} =
       INTEGER(path-list:INNER-LINES IN FRAME {&FRAME-NAME}).

/* Populate the selection list */
RUN get_path.

/* Now enable the interface and wait for the exit condition.            */
RUN enable_UI.
WAIT-FOR GO OF FRAME {&FRAME-NAME}.
RUN SetNewPath.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f _DEFAULT-ENABLE
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
  ENABLE path-list b_add b_delete RECT-6 b_move_up b_move_down 
      WITH FRAME f.
  VIEW FRAME f.
  {&OPEN-BROWSERS-IN-QUERY-f}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_path f 
PROCEDURE get_path :
/* -----------------------------------------------------------
  Purpose:     Fill the selection list with the contents of 
               PATH.  Note that we put line numbers on each line 
               (and we support up to 999 items in the path).
  Parameters:  <none>
 -------------------------------------------------------------*/
  DEFINE VAR plist   AS CHAR    NO-UNDO.
  DEFINE VAR i       AS INTEGER NO-UNDO.
  DEFINE VAR cnt     AS INTEGER NO-UNDO.
  DEFINE VAR pEntry  AS INTEGER NO-UNDO.  
  DEFINE VAR testval AS CHAR    NO-UNDO.

  cnt = NUM-ENTRIES(pDirList,",":u).
  IF cnt > 999 THEN DO:
    MESSAGE "Only the first 999 items in the path will be displayed."
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    cnt = 999.
  END.
  
  /* Add a number to the front of each line for uniqueness */
  DO i = 1 TO cnt: 
    plist = (IF i eq 1 THEN "" ELSE plist + ",":u) 
          + STRING(i,">>9":u) + ") ":u + ENTRY(i, pDirList, ",":u).
  END.
 
  path-list:LIST-ITEMS IN FRAME {&FRAME-NAME} = plist.
  
  i = 0.    
  DO i = 1 TO Cnt: 
    testval = ENTRY(2,ENTRY(i,Path-List:LIST-ITEMS,",":u),")":U). 
    IF TRIM(TestVal) = pCurrentPath THEN DO:
      pEntry = i. 
      LEAVE.
    END.
  END.

  ASSIGN
    pEntry                 = IF pEntry = 0 THEN 1 ELSE pEntry       
    Path-List:SCREEN-VALUE = Path-List:ENTRY(pEntry).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE number_path f 
PROCEDURE number_path :
/* -----------------------------------------------------------
  Purpose:     Change the first 3 characters of a line in path-list
               to be the line numbe (in format ">>9").
  Parameters:  <none>
 -------------------------------------------------------------*/
  DEFINE VAR plist AS CHAR    NO-UNDO.
  DEFINE VAR i     AS INTEGER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* Remove a number from each line.  */
    DO i = 1 TO path-list:NUM-ITEMS:
      plist = (IF i EQ 1 THEN "" ELSE plist + ",":u) 
            + STRING(i,">>9":u) 
            + SUBSTRING(path-list:ENTRY(i),4,-1, "CHARACTER":u).
    END.
    path-list:LIST-ITEMS = plist.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetNewPath f 
PROCEDURE SetNewPath :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR path  AS CHAR    CASE-SENSITIVE NO-UNDO.
  DEFINE VAR i     AS INTEGER                NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* Remove a number from each line.  */
    DO i = 1 TO path-list:NUM-ITEMS: 
      path = (IF i = 1 THEN "" ELSE path + ",":u) 
           + SUBSTRING(path-list:ENTRY(i),6,-1, "CHARACTER":u).
     END.
  END.    
   
  ASSIGN
    pNewList     = path
    pCurrentPath = IF path-list:SCREEN-VALUE <> "" 
                   THEN ENTRY(2,path-list:SCREEN-VALUE,")":U)
                   ELSE "".  
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


