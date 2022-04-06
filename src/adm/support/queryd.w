&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: queryd.w 

  Description: Dialog for getting settable attributes for a SmartQuery.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartQuery.

  Output Parameters:
      <none>

  History:
    wood 5/15/96 Add KEY-NAME support
                 Change Layout of Dialog
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-Btn YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE attr-list  AS CHARACTER NO-UNDO.

/* Define the value of the "don't use foreign keys" option. */
&Scoped-define no-key [none]

/* Define the value of the "Use Default SortBy-Case" option. */
&Scoped-define no-sort [default]

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-OBJECTS c_SortBy c_Key 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE c_Key AS CHARACTER FORMAT "X(256)":U 
     LABEL "Request &Key" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE c_SortBy AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Sort Option" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 32 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     c_SortBy AT ROW 2.1 COL 5.6
     c_Key AT ROW 3.14 COL 4
     " Advanced Query Options" VIEW-AS TEXT
          SIZE 49 BY .62 AT ROW 1.29 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(0.71) SKIP(2.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartQuery Attributes":L.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   L-To-R                                                               */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX c_Key IN FRAME Attribute-Dlg
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR COMBO-BOX c_SortBy IN FRAME Attribute-Dlg
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* SmartQuery Attributes */
DO:
  /* Put the attributes back into the SmartObject. */

  ASSIGN c_Key    = c_Key:SCREEN-VALUE    WHEN c_Key:SENSITIVE
         c_SortBy = c_SortBy:SCREEN-VALUE WHEN c_SortBy:SENSITIVE
         attr-list = ""
         .
  /* Check the name of the sort-case, key and layout. Don't bother assigning them 
     if they weren't sensitive. */
  IF c_SortBy:SENSITIVE 
  THEN ASSIGN c_SortBy = "" WHEN c_SortBy eq "{&no-sort}":U
              attr-list = attr-list + ",SortBy-Case =":U + c_SortBy.
  IF c_Key:SENSITIVE 
  THEN ASSIGN c_Key = "" WHEN c_Key eq "{&no-key}":U
              attr-list = attr-list + ",Key-Name =":U + c_Key.
  /* Remove leading comma. */
  attr-list = LEFT-TRIM(attr-list, ",":U).
  IF attr-list ne "" THEN RUN set-attribute-list IN p_hSMO (INPUT attr-list).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartQuery Attributes */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* ************************ Standard Setup **************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartQuery_Attributes_Dlg_Box} }

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
  /* Enable the interface. */         
  RUN enable_UI.
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Attribute-Dlg _DEFAULT-DISABLE
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
  HIDE FRAME Attribute-Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Attribute-Dlg _DEFAULT-ENABLE
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
  DISPLAY c_SortBy c_Key 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes Attribute-Dlg 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR ldummy AS LOGICAL NO-UNDO.
  
  /* Get the attributes used in this Instance Attribute dialog-box. */
  DO WITH FRAME {&FRAME-NAME}:   
    /* Check accepted keys (and the key to use). */
    RUN get-attribute IN p_hSMO ("Keys-Accepted":U).
    ASSIGN 
      c_key:LIST-ITEMS  = IF RETURN-VALUE ne ? THEN RETURN-VALUE ELSE "" 
      ldummy            = c_key:ADD-FIRST ("{&no-key}":U)
      c_key:SENSITIVE   = c_key:NUM-ITEMS > 1
      c_key:INNER-LINES = MIN(10,MAX(3, c_key:NUM-ITEMS + 1)).
    RUN get-attribute IN p_hSMO ("Key-Name":U).
    c_key = IF RETURN-VALUE eq ? OR RETURN-VALUE eq "":U THEN "{&no-key}":U 
            ELSE RETURN-VALUE. 
       
    /* Check sort-by options keys (and the key to use). */
    c_sortby:DELIMITER   = "|":U.
    RUN get-attribute IN p_hSMO ("SortBy-Options":U).
    ASSIGN 
      c_sortby:LIST-ITEMS  = IF RETURN-VALUE ne ? THEN REPLACE(RETURN-VALUE,",":U,"|":U) ELSE "" 
      ldummy               = c_sortby:ADD-FIRST ("{&no-sort}":U)
      c_sortby:SENSITIVE   = c_sortby:NUM-ITEMS > 1
      c_sortby:INNER-LINES = MIN(10,MAX(3, c_sortby:NUM-ITEMS + 1)).
    RUN get-attribute IN p_hSMO ("SortBy-Case":U).
    c_sortby = IF RETURN-VALUE eq ? OR RETURN-VALUE eq "":U THEN "{&no-sort}":U 
               ELSE RETURN-VALUE.    
  END. /* DO WITH FRAME... */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


