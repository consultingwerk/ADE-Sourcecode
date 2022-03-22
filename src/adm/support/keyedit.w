&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f-dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f-dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: keyedit.w

  Description: A editor for Accepted and Supplied keys

  Input Parameters:
      p_context - Context of the XFTR code section
      
  Input-Output parameters:
      p_code    - The code to update
      
  Output Parameters:
      <none>

  Author: Wm.T.Wood 

  Created: December 22, 1995
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&GLOBAL-DEFINE WIN95-BTN YES

&IF "{&UIB_is_Running}" eq "" &THEN
  DEFINE INPUT        PARAMETER p_context AS INTEGER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_code    AS CHAR NO-UNDO.
&ELSE
  DEFINE VARIABLE p_context AS INTEGER NO-UNDO.
  DEFINE VARIABLE p_code    AS CHAR NO-UNDO.
  /* Testing code */
  p_code =
"/* STRUCTURED-DATA
<FOREIGN-KEYS>
Cust-Num|y|y|Sports.Customer.Cust-Num" + CHR(10) +
"Sales-Rep||y|Sports.Customer.Sales-Rep
</FOREIGN-KEYS> */".

&ENDIF

/* Local Variable Definitions ---                                       */
DEFINE VAR ch              AS CHAR NO-UNDO.
DEFINE VAR cnt             AS INTEGER NO-UNDO.
DEFINE VAR foreign-keys    AS CHAR NO-UNDO.
DEFINE VAR i               AS INTEGER NO-UNDO.
DEFINE VAR none-accepted   AS LOGICAL NO-UNDO.
DEFINE VAR key-object      AS CHAR NO-UNDO.  
DEFINE VAR key-object-type AS CHAR NO-UNDO.  
DEFINE VAR key-table       AS CHAR NO-UNDO. 
DEFINE VAR ldummy          AS LOGICAL NO-UNDO.
DEFINE VAR open-recid      AS RECID   NO-UNDO.
DEFINE VAR open-on-row     AS INTEGER NO-UNDO.
DEFINE VAR proc-ID         AS INTEGER NO-UNDO.

/* Temp-Table for browsing keys ---                                     */
DEFINE TEMP-TABLE tt NO-UNDO
  FIELD num AS INTEGER
  FIELD key-name AS CHAR
  FIELD accepted AS LOGICAL FORMAT "yes/no" INITIAL no
  FIELD supplied AS LOGICAL FORMAT "yes/no" INITIAL yes
  FIELD db-field AS CHAR 
  INDEX num IS PRIMARY num
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-dlg
&Scoped-define BROWSE-NAME brws-keys

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt

/* Definitions for BROWSE brws-keys                                     */
&Scoped-define FIELDS-IN-QUERY-brws-keys tt.key-name tt.accepted tt.supplied tt.db-field   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brws-keys ALL   
&Scoped-define FIELD-PAIRS-IN-QUERY-brws-keys~
 ~{&FP1}ALL ~{&FP2}ALL ~{&FP3}
&Scoped-define SELF-NAME brws-keys
&Scoped-define OPEN-QUERY-brws-keys OPEN QUERY brws-keys PRESELECT EACH tt.
&Scoped-define TABLES-IN-QUERY-brws-keys tt
&Scoped-define FIRST-TABLE-IN-QUERY-brws-keys tt


/* Definitions for DIALOG-BOX f-dlg                                     */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brws-keys b_Insert RECT-8 b_Key-Guess 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_DB-Field 
     LABEL "&Modify Field..." 
     SIZE 15 BY 1.12.

DEFINE BUTTON b_Insert 
     LABEL "&Insert Key" 
     SIZE 15 BY 1.12.

DEFINE BUTTON b_Key-Guess 
     LABEL "Best &Guess..." 
     SIZE 15 BY 1.12.

DEFINE BUTTON b_Remove 
     LABEL "&Remove Key" 
     SIZE 15 BY 1.12.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 1.71.

DEFINE VARIABLE tg_accepted AS LOGICAL INITIAL no 
     LABEL "Key &Accepted" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .76 NO-UNDO.

DEFINE VARIABLE tg_supplied AS LOGICAL INITIAL no 
     LABEL "Key &Supplied" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .76 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brws-keys FOR 
      tt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brws-keys
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brws-keys f-dlg _FREEFORM
  QUERY brws-keys NO-LOCK DISPLAY
      tt.key-name  FORMAT "X(256)" WIDTH 16 LABEL "Key Name"
      tt.accepted  WIDTH 4 LABEL "Acc."
      tt.supplied  WIDTH 4 LABEL "Sup."
      tt.db-field FORMAT "X(128)" WIDTH 27 LABEL "Associated Field"   
ENABLE ALL
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 59 BY 8.1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-dlg
     brws-keys AT ROW 1.29 COL 2
     b_Insert AT ROW 1.29 COL 62
     b_Remove AT ROW 2.62 COL 62
     b_Key-Guess AT ROW 10.24 COL 62
     b_DB-Field AT ROW 10.29 COL 44
     tg_accepted AT ROW 10.43 COL 4
     tg_supplied AT ROW 10.43 COL 23
     " Details" VIEW-AS TEXT
          SIZE 8 BY .76 AT ROW 9.48 COL 4
     RECT-8 AT ROW 9.86 COL 2
     SPACE(15.99) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Foreign Keys".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f-dlg
   Default                                                              */
ASSIGN 
       FRAME f-dlg:SCROLLABLE       = FALSE.

ASSIGN 
       brws-keys:NUM-LOCKED-COLUMNS IN FRAME f-dlg = 1
       brws-keys:MAX-DATA-GUESS IN FRAME f-dlg     = 12.

/* SETTINGS FOR BUTTON b_DB-Field IN FRAME f-dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_Remove IN FRAME f-dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg_accepted IN FRAME f-dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg_supplied IN FRAME f-dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brws-keys
/* Query rebuild information for BROWSE brws-keys
     _START_FREEFORM
OPEN QUERY brws-keys PRESELECT EACH tt.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE brws-keys */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB f-dlg 
/* ************************* Included-Libraries *********************** */

{src/adm/support/keyprocs.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f-dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-dlg f-dlg
ON WINDOW-CLOSE OF FRAME f-dlg /* Foreign Keys */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brws-keys
&Scoped-define SELF-NAME brws-keys
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brws-keys f-dlg
ON DEFAULT-ACTION OF brws-keys IN FRAME f-dlg
DO:
  /* When DOUBLE-CLICKING on a line edit the associated DB-FIELD.
     ******
     NOTE: Dbl-clicks in enabled columns won't fire this trigger. So the only
     column where this works is normally the DB-FIELD column.
     ****** */
  IF AVAILABLE tt THEN DO:
    RUN edit-db-field.
    DISPLAY tt.db-field WITH BROWSE brws-keys.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brws-keys f-dlg
ON VALUE-CHANGED OF brws-keys IN FRAME f-dlg
DO:
  RUN set-screen-elements.
  ASSIGN open-recid  = IF AVAILABLE tt THEN RECID(tt) ELSE ?
         open-on-row = SELF:FOCUSED-ROW.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_DB-Field
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_DB-Field f-dlg
ON CHOOSE OF b_DB-Field IN FRAME f-dlg /* Modify Field... */
DO:
  /* Change the current field name. */
  IF brws-keys:NUM-SELECTED-ROWS ne 1 THEN SELF:SENSITIVE = no.
  ELSE DO:
    ldummy = brws-keys:FETCH-SELECTED-ROW(1). 
    RUN edit-db-field.
    DISPLAY tt.db-field WITH BROWSE {&BROWSE-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Insert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Insert f-dlg
ON CHOOSE OF b_Insert IN FRAME f-dlg /* Insert Key */
DO:
  DEFINE VAR l_ok AS LOGICAL NO-UNDO.
  DEFINE VAR new-fld AS CHAR NO-UNDO.
  DEFINE VAR old-num AS INTEGER NO-UNDO.

  IF key-table = "" THEN DO:
    MESSAGE "Foreign Keys cannot be choosen until at least"
            "one table has been defined for this query."
         VIEW-AS ALERT-BOX.
    RETURN NO-APPLY.
  END. 
  /* Create a new tt record and edit the db-field. */
  IF NOT available tt THEN FIND LAST tt NO-ERROR.
  IF available tt THEN old-num = tt.num.
  CREATE tt.
  RUN edit-db-field.
  IF tt.db-field eq "":U THEN DELETE tt.
  ELSE DO:
    tt.num = old-num + 1.
    RUN reorder-browse.
    ASSIGN open-recid = RECID(tt)
           open-on-row = open-on-row + 1
           . 
    RUN reopen-query. 
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Key-Guess
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Key-Guess f-dlg
ON CHOOSE OF b_Key-Guess IN FRAME f-dlg /* Best Guess... */
DO:
  DEFINE VAR accept-list   AS CHAR          NO-UNDO.
  DEFINE VAR cnt           AS INTEGER       NO-UNDO.
  DEFINE VAR db_name       AS CHAR          NO-UNDO.
  DEFINE VAR db-fld        AS CHAR          NO-UNDO.
  DEFINE VAR fld_name      AS CHAR          NO-UNDO.
  DEFINE VAR i             AS INTEGER       NO-UNDO.
  DEFINE VAR l_ok          AS LOGICAL       NO-UNDO.
  DEFINE VAR l_reopen      AS LOGICAL       NO-UNDO.
  DEFINE VAR last-num      AS INTEGER       NO-UNDO.
  DEFINE VAR supply-list   AS CHAR          NO-UNDO.
  DEFINE VAR tbl_name      AS CHAR          NO-UNDO.
  DEFINE VAR temp          AS CHAR          NO-UNDO.
  DEFINE VAR unique-list   AS CHAR          NO-UNDO.
  
  DEFINE BUFFER ipTT FOR tt.
 
  /* Guess at the keys that should be used. Use the key-table.  If there
     is not one, ask the user. */
  IF key-table eq "" THEN DO:
    RUN adecomm/_tblsel.p (FALSE,    /* Multiple Select = no */
                           ?,        /* no temp-table info yet */
                           INPUT-OUTPUT db_name,
                           INPUT-OUTPUT tbl_name,
                           OUTPUT l_OK).
    IF l_OK THEN key-table = db_name + ".":U + tbl_name.
  END.
  
  IF key-table ne "" THEN DO:
    /* Guess at the tables.  If the key is going to replace an external table
       in THIS-PROCEDURE then accept only unique keys. */
    RUN adeuib/_keygues.p (INPUT key-table,
                           OUTPUT unique-list,
                           OUTPUT accept-list,
                           OUTPUT supply-list).
    IF key-object eq "THIS-PROCEDURE":U
    THEN accept-list = unique-list.
    ELSE IF unique-list ne "" THEN DO:
      /* For BROWSE and QUERY objects, the unique-list should probably NOT
         be in the acceptatble keys because they imply a unique entry. */
      cnt = NUM-ENTRIES(accept-list).
      DO i = 1 TO cnt:
        fld_name = ENTRY(i, accept-list).
        IF NOT CAN-DO(unique-list, fld_name) 
        THEN temp = (IF temp eq "" THEN "" ELSE temp + ",":U) + fld_name.
      END.
      accept-list = temp.   
    END.
    
    /* Find the highest existing order number for ipTT records. */
    FIND LAST ipTT NO-ERROR.
    last-num = IF AVAILABLE (ipTT) THEN ipTT.num ELSE 0.
    
    /* Make sure there is a ipTT record for each element of the accept-list. */
    cnt = NUM-ENTRIES(accept-list).
    DO i = 1 TO cnt:
      ASSIGN fld_name = ENTRY(i, accept-list)
             db-fld = key-table + "." + fld_name.
      FIND FIRST ipTT WHERE ipTT.db-field eq db-fld NO-ERROR.
      IF NOT AVAILABLE ipTT THEN DO:
        CREATE ipTT.
        ASSIGN ipTT.num      = last-num + 2
               last-num      = ipTT.num
               ipTT.key-name = fld_name
               ipTT.accepted = yes
               ipTT.supplied = yes
               ipTT.db-field = db-fld
               l_reopen = yes.
      END.
      ELSE DO:
        IF ipTT.accepted = no THEN
          ASSIGN ipTT.accepted = yes
                 l_reopen = yes.    
      END.
    END. /* DO i... */
    
    /* Make sure there is a ipTT record for each element of the supply-list. */
    cnt = NUM-ENTRIES(supply-list).
    DO i = 1 TO cnt:
      ASSIGN fld_name = ENTRY(i, supply-list)
             db-fld = key-table + "." + fld_name.
      FIND FIRST ipTT WHERE ipTT.db-field eq db-fld NO-ERROR.
      IF NOT AVAILABLE ipTT THEN DO:
        CREATE ipTT.
        ASSIGN ipTT.num      = last-num
               last-num      = ipTT.num
               ipTT.key-name = fld_name
               ipTT.accepted = no
               ipTT.supplied = yes
               ipTT.db-field = db-fld
               l_reopen = yes.
      END.
      ELSE DO:
        IF ipTT.supplied = no THEN
          ASSIGN ipTT.supplied = yes
                 l_reopen = yes.    
      END.
    END. /* DO i... */
    
    /* Reopen the query if necessary. */
    IF l_reopen THEN DO:
      RUN reorder-browse.
      RUN reopen-query.
    END.
    ELSE MESSAGE "No new keys can be suggested." VIEW-AS ALERT-BOX INFORMATION.
  END. /* IF key-table ne ""... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Remove f-dlg
ON CHOOSE OF b_Remove IN FRAME f-dlg /* Remove Key */
DO:
  DEFINE VAR i AS INTEGER NO-UNDO.
   
  DO i = 1 TO brws-keys:NUM-SELECTED-ROWS:
    ldummy = brws-keys:FETCH-SELECTED-ROW(i). /* Inserted, and unassigned, rows */ 
    IF AVAILABLE (tt) THEN DELETE tt.         /* ...won't have a record.        */
  END.
  ldummy = brws-keys:DELETE-SELECTED-ROWS().
  RUN set-screen-elements.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg_accepted
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg_accepted f-dlg
ON VALUE-CHANGED OF tg_accepted IN FRAME f-dlg /* Key Accepted */
DO:
  /* Change the logical value. */
  IF brws-keys:NUM-SELECTED-ROWS ne 1 THEN SELF:SENSITIVE = no.
  ELSE DO:
    ldummy = brws-keys:FETCH-SELECTED-ROW(1). 
    IF AVAILABLE tt THEN DO:
       tt.accepted = SELF:CHECKED.
       DISPLAY tt.accepted WITH BROWSE {&BROWSE-NAME}. 
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg_supplied
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg_supplied f-dlg
ON VALUE-CHANGED OF tg_supplied IN FRAME f-dlg /* Key Supplied */
DO:
  /* Change the logical value. */
  IF brws-keys:NUM-SELECTED-ROWS ne 1 THEN SELF:SENSITIVE = no.
  ELSE DO:
    ldummy = brws-keys:FETCH-SELECTED-ROW(1). 
    IF AVAILABLE tt THEN DO:
       tt.supplied = SELF:CHECKED.
       DISPLAY tt.supplied WITH BROWSE {&BROWSE-NAME}.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f-dlg 


/* ****************** Standard Buttons and ADM Help ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&XFTR_Foreign_Keys_Dlg} }

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* What is the table that is going to supply the key. */
RUN find-key-table.

/* Check the error that we can't find an object to look at. */
IF key-table eq ? THEN DO:
  MESSAGE "Foreign Keys are not supported in this procedure."
          VIEW-AS ALERT-BOX INFORMATION.
  RETURN.
END.

/* Get the foreign keys from the code. */
RUN adm/support/_tagdat.p ("GET":U, "FOREIGN-KEYS":U, 
                            INPUT-OUTPUT foreign-keys, INPUT-OUTPUT p_code).
cnt = NUM-ENTRIES(foreign-keys, CHR(10)).
DO i = 1 TO cnt:
  ch = ENTRY(i, foreign-keys, CHR(10)).
  CREATE tt.
  ASSIGN tt.num      = i * 2                /* Leave room for an INSERT */
         tt.key-name = ENTRY(1, ch, "|":U)
         tt.accepted = ENTRY(2, ch, "|":U) ne ""  AND NOT none-accepted
         tt.supplied = ENTRY(3, ch, "|":U) ne "" 
         tt.db-field = ENTRY(4, ch, "|":U)
         .
END.

/* Don't allow commas or | in the name. */
ON ",":U, "|":U OF tt.key-name IN BROWSE brws-keys RETURN NO-APPLY.

/* Show READ-ONLY columns in a different color. */
ASSIGN tt.db-field:READ-ONLY = yes
       tt.db-field:COLUMN-BGCOLOR = 7.
/* The user can't type a value for accepted values if there are external tables. */
IF none-accepted THEN ASSIGN tt.accepted:READ-ONLY = yes
                             tt.accepted:COLUMN-BGCOLOR = 7.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.
  RUN reopen-query.
  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    
  /* Recreate the list foreign-keys from the temp-table. */
  ASSIGN foreign-keys = "".
  FOR EACH tt:
    /* Ignore blank lines. */
    IF tt.key-name ne "" and tt.db-field ne "" THEN DO:
      /* Strip commas and | from the name. */
      tt.key-name = REPLACE(REPLACE(tt.key-name, ",":U, "":U), "|":U, "":U).
      foreign-keys = (IF foreign-keys eq "" THEN "" ELSE foreign-keys + CHR(10)) +
                      SUBSTITUTE ("&1|&2|&3|&4":U,
                                      tt.key-name,
                                      IF tt.accepted THEN "y":U ELSE "",
                                      IF tt.supplied THEN "y":U ELSE "",
                                      tt.db-field).
    END.
  END.
  
  /* Build the xftr section for this object. */
  RUN build-xftr-section (foreign-keys, key-object, OUTPUT p_code).
  
  /* Make sure the SmartObject has the correct internal procedures. */
  IF foreign-keys ne "" AND p_context > 0  
  THEN RUN check-procedures (proc-ID, key-object).  
  
  /* Final check -- if running from the UIB. */
  &IF DEFINED(UIB_is_Running) ne 0 &THEN
    RUN adm/support/xedit.w (p_context, INPUT-OUTPUT p_code).
  &ENDIF
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f-dlg _DEFAULT-DISABLE
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
  HIDE FRAME f-dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE edit-db-field f-dlg 
PROCEDURE edit-db-field :
/*------------------------------------------------------------------------------
  Purpose:     Edit the DB Field of the current temp-table record.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR db_name       AS CHAR          NO-UNDO.
  DEFINE VAR fld_name      AS CHAR          NO-UNDO.
  DEFINE VAR l_ok          AS LOGICAL       NO-UNDO.
  DEFINE VAR tbl_name      AS CHAR          NO-UNDO.
  DEFINE VAR use_Prefix    AS INTEGER       NO-UNDO INITIAL ?.
  
  /* Error condition. */
  IF NOT AVAILABLE (tt) THEN RETURN.
  ELSE DO:
    IF NUM-ENTRIES (tt.db-field, ".":U) eq 3 THEN 
      ASSIGN db_name  = ENTRY(1, tt.db-field, ".":U)
             tbl_name = ENTRY(2, tt.db-field, ".":U)
             fld_name = ENTRY(3, tt.db-field, ".":U) .
    ELSE IF NUM-ENTRIES (key-table) ne 2 THEN
      ASSIGN db_name  = ENTRY(1, key-table, ".":U)
             tbl_name = ENTRY(2, key-table, ".":U) .
    use_Prefix = ?. /* Don't give user choice of changing prefix. */
    RUN adecomm/_fldsel.p (FALSE,       /* Multiple select = no */
                           ?,           /* All data-types       */
                           ?,           /* No temp-table info --- yet! */
                           INPUT-OUTPUT use_Prefix,
                           INPUT-OUTPUT db_name, 
                           INPUT-OUTPUT tbl_name,
                           INPUT-OUTPUT fld_name,
                           OUTPUT l_ok).
    IF l_OK THEN DO:
      /* Assign the field, and the Key-Name, if it is blank. */
      tt.db-field = db_name + ".":U + tbl_name + ".":U + fld_name.
      IF tt.key-name eq "" THEN tt.key-name = fld_name.
    END.
  END. /* ... AVAILABLE tt ... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f-dlg _DEFAULT-ENABLE
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
  ENABLE brws-keys b_Insert RECT-8 b_Key-Guess 
      WITH FRAME f-dlg.
  {&OPEN-BROWSERS-IN-QUERY-f-dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-key-table f-dlg 
PROCEDURE find-key-table :
/*------------------------------------------------------------------------------
  Purpose:     The primary table that foreign keys can be based on is the
               first table in the BROWSE or QUERY (i.e. the key-object). 
               The key-object can be THIS-PROCEDURE in which case we look
               at external tables.
  Parameters:  <none>
  Notes:       The procedure finds and sets three variables used elsewhere
               in this procedure:
                  proc-ID -- context ID of this procedure.
                  key-object -- the object that we will be be creating the
                                query on (This is either the name of an
                                object, or the special values:
                                  &QUERY-NAME, &BROWSE-NAME, or THIS-PROCEDURE
                  key-object-type -- the TYPE of the key-object (usually QUERY
                               or BROWSE (or the Procedure type).
                  key-table -- the table that keys will use.  This is either
                               the first table in the TABLES or key-object, or
                               the first external table.
------------------------------------------------------------------------------*/
  DEFINE VAR obj-id   AS INTEGER NO-UNDO.
  DEFINE VAR c_info   AS CHAR    NO-UNDO.
  DEFINE VAR ext-tbls AS CHAR    NO-UNDO.

  /* For testing, just use SPORTS.Customer. */
  &IF DEFINED(UIB_is_Running) &THEN
    ASSIGN key-source = "THIS-PROCEDURE"
           key-table  = "sports.customer".
  &ELSE  
    /* Get procedure context id. */
    RUN adeuib/_uibinfo.p (p_context, ?, "PROCEDURE":U, OUTPUT c_info).
    proc-id = INTEGER(c_info).

    /* Get the object that we will use to set the Foreign-keys. This will be
       the name of a BROWSE or QUERY, or &BROWSE-NAME or &QUERY-NAME if we
       are setting external tables. */
    RUN adm/support/_tagdat.p ("GET":U, "KEY-OBJECT":U, 
                               INPUT-OUTPUT key-object, INPUT-OUTPUT p_code).
    
    /* Emergency Test-- if key-object is undefined, use some defaults. */
    IF key-object eq "":U THEN DO:
      RUN adeuib/_uibinfo.p (proc-id, ?, "TYPE":U, OUTPUT c_info).
      key-object = IF c_info eq "SmartBrowser":U THEN "&BROWSE-NAME":U
                   ELSE IF c_info eq "SmartQuery":U THEN "&QUERY-NAME":U
                   ELSE "THIS-PROCEDURE":U.
    END.
    
    /* Look for External tables.  */
    RUN adeuib/_uibinfo.p (proc-id, ?, "EXTERNAL-TABLES":U, OUTPUT ext-tbls).
    IF ext-tbls eq ? THEN ext-tbls = "":U.
    
    /* If a key-source as been found, then get the context id of this object. */
    CASE key-object:
      WHEN "THIS-PROCEDURE":U THEN obj-id = proc-id.
      WHEN "&BROWSE-NAME" THEN DO:
        RUN adeuib/_uibinfo.p (proc-id, ?, "&BROWSE-NAME":U, OUTPUT c_info).
        obj-id = INTEGER(c_info).
      END.
      WHEN "&QUERY-NAME" THEN DO:
        RUN adeuib/_uibinfo.p (proc-id, ?, "&QUERY-NAME":U, OUTPUT c_info).
        obj-id = INTEGER(c_info).
      END.
      OTHERWISE DO:
        /* Find the object with this name in the current procedure. */
        RUN adeuib/_uibinfo.p (?, key-object, "CONTEXT":U, OUTPUT c_info).
        obj-id = INTEGER(c_info).
      END.
    END CASE.
    
    IF obj-id eq ? THEN ASSIGN key-object = ?
                               key-object-type = ?
                               key-table = ?
                               none-accepted = yes.
    ELSE DO:
      RUN adeuib/_uibinfo.p (obj-id, ?, "TYPE":U, OUTPUT key-object-type).
      IF CAN-DO ("QUERY,BROWSE":U, key-object-type) THEN DO:
        /* If the object is query/browse based, then get the tables from
           the object itself. NOTE: also check that the query uses the
           KEY-TABLE preprocessor.  If not, then no keys should be accepted. */
        RUN adeuib/_uibinfo.p (obj-id, ?, "TABLES":U, OUTPUT c_info).
        IF c_info ne "" THEN key-table  = ENTRY(1, c_info).  
        /* Check for KEY-PHRASE. */
        RUN adeuib/_uibinfo.p (obj-id, ?, "4GL-Query":U, OUTPUT c_info).
        IF c_info eq ? THEN c_info = "":U.   
        IF (ext-tbls ne "":U) OR 
           (c_info ne "":U AND INDEX(c_info, "~~~{&KEY-PHRASE}":U) eq 0)
        THEN none-accepted = yes.
      END.
      ELSE key-table = IF ext-tbls ne "":U  
                       THEN ENTRY(1, ext-tbls) ELSE "":U.                                  
    END. /* IF obj-id ne ? ... */
    
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopen-query f-dlg 
PROCEDURE reopen-query :
/*------------------------------------------------------------------------------
  Purpose:     Reopen the browse query, and set the interface correctly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i    AS INTEGER NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    {&OPEN-QUERY-brws-keys}
    IF open-on-row > 0 THEN 
      ldummy = brws-keys:SET-REPOSITIONED-ROW (open-on-row, "CONDITIONAL":U).
    REPOSITION brws-keys TO RECID open-recid NO-ERROR.
    ldummy = brws-keys:SELECT-ROW(brws-keys:FOCUSED-ROW) NO-ERROR.
    RUN set-screen-elements.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reorder-browse f-dlg 
PROCEDURE reorder-browse :
/*------------------------------------------------------------------------------
  Purpose:     Numbers the items in the browse by 2
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INTEGER NO-UNDO.
  DEF BUFFER xtt FOR tt.
  
  REPEAT PRESELECT EACH xtt BY xtt.num:
    FIND NEXT xtt.
    ASSIGN i = i + 2
           xtt.num = i.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-screen-elements f-dlg 
PROCEDURE set-screen-elements :
/*------------------------------------------------------------------------------
  Purpose:     Set the sensitivity of buttons etc. in the interface.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      b_remove:SENSITIVE    = brws-keys:NUM-SELECTED-ROWS > 0
      b_db-field:SENSITIVE  = brws-keys:NUM-SELECTED-ROWS eq 1
      tg_accepted:SENSITIVE = b_db-field:SENSITIVE AND NOT none-accepted
      tg_supplied:SENSITIVE = b_db-field:SENSITIVE
      tg_accepted:CHECKED   = AVAILABLE tt AND tt.accepted
      tg_supplied:CHECKED   = AVAILABLE tt AND tt.supplied.
      .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



