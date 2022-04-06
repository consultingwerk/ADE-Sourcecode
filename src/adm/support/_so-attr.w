&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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

  File: _so-attr.w

  Description: List all the SmartObject attributes.

  Input Parameters:
      p_hSMO - Handle of the SmartObject.

  Output Parameters:
      <none>

  Author: Wm.T.Wood

  Created: November 30, 1995

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) eq 0 &THEN
  DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.
&ELSE
  DEFINE VAR p_hSMO AS HANDLE NO-UNDO.
&ENDIF

/* Global Variable Definitions ---                                      */
DEF NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Define a temp table to hold the attributes and their values. */
DEFINE TEMP-TABLE tt NO-UNDO
    FIELD attr-name  AS CHAR FORMAT "X(36)"
    FIELD attr-value AS CHAR FORMAT "X(256)"
    FIELD type       AS CHAR FORMAT "X(1)" INITIAL "c":U
  INDEX attr-name IS PRIMARY attr-name.

/* Shared Variable Definitions ---                                      */
{ src/adm/support/admhlp.i } /* help definitions */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f
&Scoped-define BROWSE-NAME br_attr

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt

/* Definitions for BROWSE br_attr                                       */
&Scoped-define FIELDS-IN-QUERY-br_attr tt.attr-name tt.attr-value   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_attr   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_attr
&Scoped-define SELF-NAME br_attr
&Scoped-define OPEN-QUERY-br_attr OPEN QUERY br_attr FOR EACH tt.
&Scoped-define TABLES-IN-QUERY-br_attr tt
&Scoped-define FIRST-TABLE-IN-QUERY-br_attr tt


/* Definitions for DIALOG-BOX f                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f ~
    ~{&OPEN-QUERY-br_attr}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_attr Btn_Close b_Help 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Close AUTO-GO 
     LABEL "&Close":L 
     SIZE 12 BY 1.

DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 12 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_attr FOR 
      tt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_attr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_attr f _FREEFORM
  QUERY br_attr NO-LOCK DISPLAY
      tt.attr-name  LABEL "Attribute" WIDTH 29
tt.attr-value LABEL "Value"     WIDTH 256
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 72.2 BY 14
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f
     br_attr AT ROW 1.33 COL 2
     Btn_Close AT ROW 15.52 COL 2.2
     b_Help AT ROW 15.52 COL 62.2
     SPACE(0.99) SKIP(0.23)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         TITLE "SmartObject Attributes":L
         DEFAULT-BUTTON Btn_Close.

 

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
       FRAME f:SCROLLABLE       = FALSE.

ASSIGN 
       br_attr:NUM-LOCKED-COLUMNS IN FRAME f = 1.

/* SETTINGS FOR BUTTON Btn_Close IN FRAME f
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_attr
/* Query rebuild information for BROWSE br_attr
     _START_FREEFORM
OPEN QUERY br_attr FOR EACH tt.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE br_attr */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help f
ON CHOOSE OF b_Help IN FRAME f /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&SmartAttributes_Dlg_Box}, ? ).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_attr
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f 


/* ***************************  Main Block  *************************** */

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Get SmartObject Attributes. */
/* &MESSAGE [_so-attr.w] Support ADM1.0 style attributes. (Wm.T.Wood) */
RUN get-attribute IN p_hSmo ('Version':U).
IF RETURN-VALUE eq "ADM1.0":U
THEN RUN get_attributes_adm1.
ELSE RUN get_attributes.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
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
  ENABLE br_attr Btn_Close b_Help 
      WITH FRAME f.
  {&OPEN-BROWSERS-IN-QUERY-f}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_attributes f 
PROCEDURE get_attributes :
/* -----------------------------------------------------------
  Purpose:    Populate a list with the session attributes
              in the form "Attribute = value". This should only
              be called for SmartObjects that store attributes
              in the adm-broker-hdl.  
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEF VAR attr-list AS CHAR NO-UNDO.
  DEF VAR cLine     AS CHAR NO-UNDO.
  DEF VAR i    AS INTEGER NO-UNDO.
  DEF VAR iCnt AS INTEGER NO-UNDO.
  DEF VAR iPos AS INTEGER NO-UNDO.
    
  /* Get the standard attributes (that are in all SmartObjects). */
  
  /* Get the special attributes in the SmartObjects internal storage. 
     Ask for ALL attributes (i.e. "*"). */
  RUN broker-get-attribute-list IN adm-broker-hdl
        (INPUT p_hSmO, INPUT "*":U, OUTPUT attr-list) NO-ERROR.
  IF ERROR-STATUS:ERROR eq NO THEN DO:
    ASSIGN iCnt = NUM-ENTRIES (attr-list).
    DO i = 1 TO iCnt:
      /* Each line in the attribute list is of the form "attr = value". Parse
         this line. Note that there can be values that are QUOTED (if they
         contain a comma. So any line without a "=" can be appended to the
         last tt record.*/
      ASSIGN cLine = ENTRY(i, attr-list)
             iPos  = INDEX(cLine, "=":U).
      IF iPos > 1 THEN DO:
        CREATE tt.
        ASSIGN tt.attr-name = TRIM(SUBSTRING(cLine,1, iPos - 1, "CHARACTER":U))
               tt.attr-value = TRIM (SUBSTRING(cLine, iPos + 1, -1, "CHARACTER":U))
               .
      END.
      ELSE IF AVAILABLE tt THEN tt.attr-value = tt.attr-value + ",":U + cLine.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_attributes_adm1 f 
PROCEDURE get_attributes_adm1 :
/* -----------------------------------------------------------
  Purpose:    Populate a list with the session attributes
              in the form "Attribute = value"  for SmartObjects
              that have Version 1.0 of the ADM. [That is, the
              list of attributes is HARD-CODED, there is no
              way to get "all" the attributes.    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEF VAR attr-list AS CHAR NO-UNDO.
  DEF VAR cLine     AS CHAR NO-UNDO.
  DEF VAR i    AS INTEGER NO-UNDO.
  DEF VAR iCnt AS INTEGER NO-UNDO.
  DEF VAR iPos AS INTEGER NO-UNDO.
    
  /* Get the standard attributes (that are in all SmartObjects). */
  ASSIGN attr-list = 'ENABLED,HIDDEN,INITIALIZED,FIELDS-ENABLED,':U +
           'CURRENT-PAGE,ADM-NEW-RECORD,INITIAL-LOC,PROSPY-HANDLE,':U +
           'EXTERNAL-TABLES,INTERNAL-TABLES,VERSION,':U +
           'LAYOUT,TYPE,CONTAINER-TYPE,SUPPORTED-LINKS,UIB-MODE,':U +
           'ADM-OBJECT-HANDLE,ADM-PARENT,EDGE-PIXELS':U
         iCnt      = NUM-ENTRIES (attr-list).
  DO i = 1 TO iCnt:
    CREATE tt.
    ASSIGN tt.attr-name = ENTRY(i, attr-list).
    RUN get-attribute IN p_hSMO (tt.attr-name).
    tt.attr-value = RETURN-VALUE.
  END.
  
  /* Get the special attributes in the SmartObjects internal storage. */
  RUN get-attribute-list IN p_hSMO (OUTPUT attr-list) NO-ERROR.
  IF ERROR-STATUS:ERROR eq NO THEN DO:
    ASSIGN iCnt = NUM-ENTRIES (attr-list).
    DO i = 1 TO iCnt:
      /* Each line in the attribute list is of the form "attr = value". Parse
         this line. */
      ASSIGN cLine = ENTRY(i, attr-list)
             iPos  = INDEX(cLine, "=":U).
      IF iPos > 1 THEN DO:
        CREATE tt.
        ASSIGN tt.attr-name = TRIM(SUBSTRING(cLine,1, iPos - 1, "CHARACTER":U))
               tt.attr-value = TRIM (SUBSTRING(cLine, iPos + 1, -1, "CHARACTER":U))
               .
      END.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


