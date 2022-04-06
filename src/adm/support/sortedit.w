&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS s-object 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: sortedit.w

  Description: A editor for SORT-OPTIONS in the Advanced Query section 
               of a SmartBrowser or SmartQuery
               
  Parameters:  <none>

  Author: Wm.T.Wood 

  Created: March, 1996
  
  Modified: 
    wood  12/26/96  Set attribute "SortBy-Case" in "save-changes" 
                    (the wrong attribute, "sort-case", was being set) 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */
DEFINE VAR h_container    AS HANDLE  NO-UNDO.
DEFINE VAR ldummy         AS LOGICAL NO-UNDO.
DEFINE VAR l_changes2save AS LOGICAL NO-UNDO.
DEFINE VAR obj-id         AS INTEGER NO-UNDO.
DEFINE VAR open-recid     AS RECID   NO-UNDO.
DEFINE VAR open-on-row    AS INTEGER NO-UNDO.
DEFINE VAR query-object   AS CHAR    NO-UNDO.  
DEFINE VAR query-tables   AS CHAR    NO-UNDO.  
DEFINE VAR sortby-options AS CHAR    NO-UNDO.
DEFINE VAR proc-ID        AS INTEGER NO-UNDO.
DEFINE VAR xftrcode       AS CHAR    NO-UNDO.

/* Temp-Table for browsing keys ---                                     */
DEFINE TEMP-TABLE tt NO-UNDO
  FIELD num AS INTEGER
  FIELD sort-case AS CHAR
  FIELD sort-build AS CHAR 
  FIELD sort-phrase AS CHAR 
  FIELD dflt-case AS LOGICAL
  FIELD freeform AS LOGICAL
  INDEX num IS PRIMARY num
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fr_sort
&Scoped-define BROWSE-NAME brws-list

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt

/* Definitions for BROWSE brws-list                                     */
&Scoped-define FIELDS-IN-QUERY-brws-list tt.sort-case   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brws-list ALL   
&Scoped-define SELF-NAME brws-list
&Scoped-define OPEN-QUERY-brws-list OPEN QUERY brws-list PRESELECT EACH tt.
&Scoped-define TABLES-IN-QUERY-brws-list tt
&Scoped-define FIRST-TABLE-IN-QUERY-brws-list tt


/* Definitions for FRAME fr_sort                                        */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK brws-list c_sort-phrase Btn_Cancel ~
Btn_Help RECT-8 
&Scoped-Define DISPLAYED-OBJECTS c_sort-phrase 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY DEFAULT 
     LABEL "Cancel" 
     SIZE 16 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help DEFAULT 
     LABEL "&Help" 
     SIZE 16 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     LABEL "OK" 
     SIZE 16 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON b_Insert 
     LABEL "&Insert Case" 
     SIZE 16 BY 1.1.

DEFINE BUTTON b_QB 
     LABEL "&Edit  Phrase..." 
     SIZE 17 BY 1.1.

DEFINE BUTTON b_quick-ins 
     LABEL "&Quick Insert..." 
     SIZE 16 BY 1.1.

DEFINE BUTTON b_Remove 
     LABEL "&Remove Case" 
     SIZE 16 BY 1.1.

DEFINE VARIABLE c_sort-phrase AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 32 BY 5.91
     FONT 2 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 8.1.

DEFINE VARIABLE tg_dflt-case AS LOGICAL INITIAL no 
     LABEL "Initial Sort &Case" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .76 NO-UNDO.

DEFINE VARIABLE tg_freeform AS LOGICAL INITIAL no 
     LABEL "&Freeform" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY 1.05 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brws-list FOR 
      tt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brws-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brws-list s-object _FREEFORM
  QUERY brws-list NO-LOCK DISPLAY
      tt.sort-case   FORMAT "X(256)" WIDTH 32 LABEL "Sort Case"
ENABLE ALL
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-COLUMN-SCROLLING SEPARATORS MULTIPLE SIZE 21 BY 6.48.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fr_sort
     Btn_OK AT ROW 1.52 COL 59
     brws-list AT ROW 2.1 COL 2
     c_sort-phrase AT ROW 2.1 COL 25 NO-LABEL
     Btn_Cancel AT ROW 2.86 COL 59
     b_Insert AT ROW 4.24 COL 59
     b_Remove AT ROW 5.57 COL 59
     b_quick-ins AT ROW 6.91 COL 59
     b_QB AT ROW 8.29 COL 26
     tg_freeform AT ROW 8.29 COL 45
     Btn_Help AT ROW 8.52 COL 59
     tg_dflt-case AT ROW 8.81 COL 3
     RECT-8 AT ROW 1.52 COL 24
     "Sort Case:" VIEW-AS TEXT
          SIZE 16 BY .76 AT ROW 1.29 COL 2
     " 'Sort By' Phrase" VIEW-AS TEXT
          SIZE 16 BY .76 AT ROW 1.29 COL 25
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW s-object ASSIGN
         HEIGHT             = 8.62
         WIDTH              = 74.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB s-object 
/* ************************* Included-Libraries *********************** */

{src/adm/method/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW s-object
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fr_sort
   Size-to-Fit                                                          */
/* BROWSE-TAB brws-list Btn_OK fr_sort */
ASSIGN 
       FRAME fr_sort:SCROLLABLE       = FALSE.

ASSIGN 
       brws-list:NUM-LOCKED-COLUMNS IN FRAME fr_sort     = 1
       brws-list:MAX-DATA-GUESS IN FRAME fr_sort         = 12.

/* SETTINGS FOR BUTTON b_Insert IN FRAME fr_sort
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_QB IN FRAME fr_sort
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_quick-ins IN FRAME fr_sort
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_Remove IN FRAME fr_sort
   NO-ENABLE                                                            */
ASSIGN 
       c_sort-phrase:RETURN-INSERTED IN FRAME fr_sort  = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg_dflt-case IN FRAME fr_sort
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg_freeform IN FRAME fr_sort
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brws-list
/* Query rebuild information for BROWSE brws-list
     _START_FREEFORM
OPEN QUERY brws-list PRESELECT EACH tt.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE brws-list */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fr_sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fr_sort s-object
ON GO OF FRAME fr_sort
DO:      
  /* Save the changes. */
  IF l_changes2save THEN RUN save-changes.
 
  /* Exit out of the container. */
  RUN notify ('exit':U).
              
  /* For testing...run the generic xedit.w. */
  /* RUN adm/support/xedit.w (?, INPUT-OUTPUT p_code).*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brws-list
&Scoped-define SELF-NAME brws-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brws-list s-object
ON ROW-LEAVE OF brws-list IN FRAME fr_sort
DO:
  IF AVAILABLE tt AND
     tt.sort-case:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ne tt.sort-case
  THEN 
    /* Note that something changed. */
    l_changes2save = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brws-list s-object
ON VALUE-CHANGED OF brws-list IN FRAME fr_sort
DO:
  RUN set-screen-elements.
  ASSIGN open-recid  = IF AVAILABLE tt THEN RECID(tt) ELSE ?
         open-on-row = SELF:FOCUSED-ROW.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel s-object
ON CHOOSE OF Btn_Cancel IN FRAME fr_sort /* Cancel */
DO:
  /* Exit out of the dialog-box */
  RUN notify ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help s-object
ON CHOOSE OF Btn_Help IN FRAME fr_sort /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  /* Define Context ID's for HELP files */
  { src/adm/support/admhlp.i }    
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&XFTR_SortBy_Options_Page}, "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Insert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Insert s-object
ON CHOOSE OF b_Insert IN FRAME fr_sort /* Insert Case */
DO:
  DEFINE VAR l_ok AS LOGICAL NO-UNDO.
  DEFINE VAR new-fld AS CHAR NO-UNDO.
  DEFINE VAR old-num AS INTEGER NO-UNDO.
  
  /* Create a new tt record and reopen the query on this row. */
  IF NOT available tt THEN FIND LAST tt NO-ERROR.
  IF available tt THEN old-num = tt.num.
  CREATE tt.
  RUN edit-sort-phrase.
  IF tt.sort-phrase eq "":U THEN DELETE tt.
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


&Scoped-define SELF-NAME b_QB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_QB s-object
ON CHOOSE OF b_QB IN FRAME fr_sort /* Edit  Phrase... */
DO:
  /* Change the current field name. */
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS ne 1 THEN SELF:SENSITIVE = no.
  ELSE DO:
    ldummy = {&BROWSE-NAME}:FETCH-SELECTED-ROW(1). 
    RUN edit-sort-phrase.
    c_sort-phrase:SCREEN-VALUE = tt.sort-phrase.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_quick-ins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_quick-ins s-object
ON CHOOSE OF b_quick-ins IN FRAME fr_sort /* Quick Insert... */
DO:
  DEFINE VAR cnt        AS INTEGER NO-UNDO.
  DEFINE VAR c_info     AS CHAR NO-UNDO.
  DEFINE VAR db-fld     AS CHAR NO-UNDO.
  DEFINE VAR field-list AS CHAR NO-UNDO.
  DEFINE VAR i          AS INTEGER NO-UNDO.
  DEFINE VAR i_added    AS INTEGER NO-UNDO.
  DEFINE VAR last-num   AS INTEGER NO-UNDO.
  DEFINE VAR isDefault  AS LOGICAL NO-UNDO.
  
  DEFINE BUFFER ipTT for tt.
  
  /* If there are no query-tables, then this button should not be enabled. */
  IF query-tables eq "":U THEN DO:
    MESSAGE "There are no tables defined for the associated query."
            VIEW-AS ALERT-BOX INFORMATION.
    SELF:SENSITIVE = no.
  END.
  ELSE DO:
    /* If this is a BROWSE, then suggest using the column fields as possible
       sort fields. */
    RUN adeuib/_uibinfo.p (obj-ID, ?, "TYPE":U, OUTPUT c_info).
    IF c_info eq "BROWSE":U THEN DO:
      RUN adeuib/_uibinfo.p (obj-ID, ?, "FIELDS":U, OUTPUT c_info).
      cnt = NUM-ENTRIES(c_info).
      DO i = 1 TO cnt:
        db-fld = TRIM(ENTRY(i, c_info)).
        /* Make sure this is of the form "db.tbl.fld" */
        IF NUM-ENTRIES(db-fld, " ":U) eq 1 AND NUM-ENTRIES(db-fld, ".":U) eq 3
        THEN DO:
          /* Is it already in the list? */
          FIND ipTT WHERE (ipTT.freeform eq NO)
                      AND ipTT.sort-build BEGINS db-fld + "|":U
                      AND NUM-ENTRIES(ipTT.sort-build) eq 1
                    NO-ERROR.
          IF NOT AVAILABLE (ipTT) THEN
            field-list = (IF field-list eq "":U THEN "":U ELSE field-list + ",":U)
                       + db-fld.
        END. /* IF ...db.tbl.fld...*/
      END. /* DO... */
    END. /* IF...BROWSE...*/
    
    /* Use the Multi-Field select dialog to quickly choose a series of 
       SortBy Options. */
    RUN adecomm/_mfldsel.p (query-tables,  /* Tables to use for field choice. */
                            ?,             /* SDO handle - not applicable for ADM1 */
                            ?,             /* No temp-table info yet */
                            "3",           /* Return db.tbl.fld */
                            ",":U,         /* List delimiter. */
                            "":U,          /* entries to exclude */
                            INPUT-OUTPUT field-list).
    RUN adecomm/_setcurs.p ("":U).
    IF RETURN-VALUE ne "Cancel":U AND field-list ne "":U THEN DO:
      /* See if there is a default sort option yet. */
      FIND ipTT WHERE ipTT.dflt-case NO-ERROR.
      IF AVAILABLE (ipTT) THEN isDefault = yes.
      
      /* For each item in field-list, add it as a SortBy option, unless it
         is already in a list. */
      ASSIGN cnt = NUM-ENTRIES (field-list)
             i_added = 0.
      FIND LAST ipTT NO-ERROR.
      last-num = IF AVAILABLE(ipTT) THEN ipTT.num ELSE 0.
      DO i = 1 TO cnt:
        /* Can we find a sort option that is just for this
           database field ? */
        db-fld = ENTRY (i, field-list).
        FIND ipTT WHERE (ipTT.freeform eq NO)
                    AND ipTT.sort-build BEGINS db-fld + "|":U
                    AND NUM-ENTRIES(ipTT.sort-build) eq 1
                  NO-ERROR.
        IF NOT AVAILABLE (ipTT) THEN DO:
          /* Add a new sort option. */
          CREATE ipTT.
          ASSIGN ipTT.num        = last-num + 2
                 last-num        = ipTT.num
                 i_added         = i_added + 1
                 ipTT.freeform   = NO
                 ipTT.sort-build = db-fld + "|yes":U
                 .
          RUN make-unique-name 
                (INPUT ENTRY(NUM-ENTRIES(db-fld,".":U), db-fld, ".":U),
                 INPUT RECID(ipTT),
                 OUTPUT ipTT.sort-case).

          /* If there is no default, as yet, then make this the default. */
          IF NOT isDefault THEN ASSIGN ipTT.dflt-case = yes
                                       isDefault    = yes.
          /* Build the sort-phrase. */
          RUN build-sort-phrase (ipTT.sort-build, OUTPUT ipTT.sort-phrase).
        END. /* IF NOT AVAIL...ipTT... */
      END. /* DO... */
      /* Tell the user is some of these items were not added. */
      IF i_added < cnt THEN DO:
        MESSAGE "Sort cases already existed for"
                (IF i_added eq 0 THEN "all" ELSE STRING(cnt - i_added))
                "of these fields. New cases for these fields were not created."
                VIEW-AS ALERT-BOX INFORMATION.
      END.
      
      /* Rebuild the list and reopen the query. */
      IF i_added > 0 THEN DO:
        l_changes2save = yes. /* Note changes. */
        RUN reorder-browse.
        ASSIGN open-on-row = 1.
        RUN reopen-query.
      END.
    END. /* IF field-list... */
  END. /* IF query-tables ne ""... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Remove s-object
ON CHOOSE OF b_Remove IN FRAME fr_sort /* Remove Case */
DO:
  DEFINE VAR i AS INTEGER NO-UNDO.
   
  DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
    ldummy = {&BROWSE-NAME}:FETCH-SELECTED-ROW(i). /* Inserted, and unassigned, rows */ 
    IF AVAILABLE (tt) THEN DELETE tt.              /* ...won't have a record.        */
  END.
  ldummy = {&BROWSE-NAME}:DELETE-SELECTED-ROWS().
  l_changes2save = YES.
  RUN set-screen-elements.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c_sort-phrase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c_sort-phrase s-object
ON LEAVE OF c_sort-phrase IN FRAME fr_sort
DO:
  IF tt.sort-phrase ne SELF:SCREEN-VALUE 
  THEN ASSIGN 
        l_changes2save = yes 
        tt.sort-phrase = TRIM(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg_dflt-case
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg_dflt-case s-object
ON VALUE-CHANGED OF tg_dflt-case IN FRAME fr_sort /* Initial Sort Case */
DO:
  DEFINE BUFFER ip_tt FOR tt.
  /* Change the logical value. */
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS ne 1 THEN SELF:SENSITIVE = no.
  ELSE DO:
    l_changes2save = yes.
    /* Uncheck any other "default". */
    IF SELF:CHECKED THEN DO:
      FOR EACH ip_tt WHERE ip_tt.dflt-case:
        ip_tt.dflt-case = no.
      END.
    END.
    /* Mark the current row as the Default. */
    ldummy = {&BROWSE-NAME}:FETCH-SELECTED-ROW(1). 
    IF AVAILABLE tt THEN DO:
        tt.dflt-case = SELF:CHECKED.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg_freeform
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg_freeform s-object
ON VALUE-CHANGED OF tg_freeform IN FRAME fr_sort /* Freeform */
DO:
  /* Change the logical value. */
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS ne 1 THEN SELF:SENSITIVE = no.
  ELSE DO:
    l_changes2save = yes.
    ldummy = {&BROWSE-NAME}:FETCH-SELECTED-ROW(1). 
    IF AVAILABLE tt THEN DO:
       tt.freeform = SELF:CHECKED.
       /* If we are making a NOT freeform phrase, then edit the phrase. */
       IF NOT tt.freeform THEN RUN edit-sort-phrase.
       RUN set-screen-elements.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK s-object 


/* ***************************  Main Block  *************************** */

/* Don't allow commas or | in the name. */
ON ",":U, "|":U OF tt.sort-case IN BROWSE {&BROWSE-NAME} RETURN NO-APPLY.

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-sort-phrase s-object 
PROCEDURE build-sort-phrase :
/*------------------------------------------------------------------------------
  Purpose: Rebuild a sort-phrase based on encoded build information (of the
           form:
                 "db.tbl.fld|yes,db.tbl.fld|no"
           That is, as comma-delimeted list of
                 "field-name|descending"
  Parameters:  
    INPUT  p_source - (CHAR) The input list
    OUTPUT p_phrase - (CHAR) The BY pharse
  Notes:       
-------------------------------------------------------------------------------- */ 
  DEFINE INPUT  PARAMETER p_source AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_phrase AS CHAR NO-UNDO.
  
  DEF VAR iby   AS INTEGER NO-UNDO.
  DEF VAR ipos  AS INTEGER NO-UNDO.
  DEF VAR cnt   AS INTEGER NO-UNDO.
  DEF VAR cBY   AS CHAR NO-UNDO.
  DEF VAR dbfld AS CHAR NO-UNDO.
  
  cnt = NUM-ENTRIES (p_source).
  DO iby = 1 TO cnt:
    ASSIGN cBY = ENTRY(iby, p_source)
           dbfld = ENTRY (1, cBY, "|":U).
    /* Remove DB names. */
    IF NUM-ENTRIES (dbfld, ".":U) eq 3 THEN DO:
      ASSIGN ipos = INDEX(dbfld, ".":U)
             dbfld = SUBSTRING(dbfld, ipos + 1, -1, "CHARACTER":U).
    END.
    IF iby > 1 THEN p_phrase = p_phrase + CHR(10) + FILL ("  ":U, iby - 1).
    p_phrase = p_phrase + "BY ":U + dbfld
                        + (IF ENTRY(2, cBY, "|":U) BEGINS "y":U
                           THEN "":U ELSE " DESCENDING":U).
  END. /* DO:... */ 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-procedures s-object 
PROCEDURE check-procedures :
/*------------------------------------------------------------------------------
  Purpose:     Make sure the target procedure has the "correct" 
               internal procedures. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Make sure there are adm-open-query procedures. */
  DEF VAR trg-id AS INTEGER NO-UNDO.
  DEF VAR ch AS CHAR NO-UNDO.
  DEF VAR c_type AS CHAR NO-UNDO.

  /* Get the type of this procedure. */
  RUN adeuib/_uibinfo.p (proc-id, ?, "TYPE", OUTPUT c_type).

  /* Make sure there are the correct procedures. */
  CASE c_type:
    /* QUERY-OBJECTS should have an adm-open-query-cases procedure. */
    WHEN "SmartBrowser":U OR WHEN "SmartQuery":U THEN DO:
      trg-id = ?.
      RUN adeuib/_accsect.p ("GET", proc-id, "PROCEDURE:adm-open-query-cases",
                             INPUT-OUTPUT trg-id, INPUT-OUTPUT ch).
      IF trg-id eq ? THEN
      RUN adeuib/_accsect.p ("SET", proc-id, "PROCEDURE:adm-open-query-cases:adm/support/_adm-opn.p",
                             INPUT-OUTPUT trg-id, INPUT-OUTPUT ch).
    END.
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI s-object  _DEFAULT-DISABLE
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
  HIDE FRAME fr_sort.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE edit-sort-phrase s-object 
PROCEDURE edit-sort-phrase :
/*------------------------------------------------------------------------------
  Purpose:     Call the query builder and edit the sort-by phrase.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR l_ok AS LOGICAL NO-UNDO.
  
  DEFINE BUFFER ip_tt FOR tt.
  /* Error condition. */
  IF NOT AVAILABLE (tt) THEN RETURN.
  ELSE DO:
    RUN adeuib/_callsrt.p 
            (INPUT        query-tables,
             INPUT-OUTPUT tt.sort-build,
             OUTPUT       l_ok).
    IF l_OK AND tt.sort-build NE "" THEN DO:
      l_changes2save = YES.
      /* Rebuild the sort-phrase. */
      RUN build-sort-phrase (tt.sort-build, OUTPUT tt.sort-phrase).
      /* Assign the Key-Name, if it is blank. For example, use the
         field name of the first sort object. That is, if sort-case was
         "sports.customer.state|yes", then use "name" as the default
         "state" for the sort-case. */
      IF tt.sort-case eq "" THEN DO:
        ASSIGN
          tt.sort-case = ENTRY(1, ENTRY(1, tt.sort-build), "|":U) 
          tt.sort-case = ENTRY(NUM-ENTRIES(tt.sort-case,".":U), tt.sort-case, ".":U).
        /* Make sure the name is unique. */
        RUN make-unique-name (tt.sort-case, RECID(tt), OUTPUT tt.sort-case).
      END. /* IF sort-case eq ""... */
      
      /* Make this the initial sort case, unless one is already defined. */
      FIND FIRST ip_tt WHERE ip_tt.dflt-case NO-ERROR.
      IF NOT AVAILABLE ip_tt THEN tt.dflt-case = yes.
    END. /* IF l_OK... */
  END. /* ... AVAILABLE tt ... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-query-tables s-object 
PROCEDURE find-query-tables :
/*------------------------------------------------------------------------------
  Purpose:     Get the name of the query to use. Also find the tables that
               this query uses.  The name of the query is stored in the
               "Foreign Keys" xftr section.               
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
  DEFINE VAR c_info   AS CHAR    NO-UNDO.

  /* Get the NAME of the query from the "Foreign Keys" XFTR section. This should 
     be a list of the form:
       KEY-OBJECT
     This will either be the name of a Query or Browse, or &QUERY-NAME or 
     &BROWSE-NAME
   */
  RUN adm/support/_xgetdat.p (proc-id, 'Foreign Keys':U, 'KEY-OBJECT':U,
                              OUTPUT query-object).

  /* Get the context of this object. */
  CASE query-object:
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
      RUN adeuib/_uibinfo.p (?, query-object, "CONTEXT":U, OUTPUT c_info).
      obj-id = INTEGER(c_info).
    END.
  END CASE.
    
  IF obj-id eq ? THEN ASSIGN query-object = ?
                             query-tables = "".
  ELSE RUN adeuib/_uibinfo.p (obj-id, ?, "TABLES":U, OUTPUT query-tables).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize s-object 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR ch             AS CHAR    NO-UNDO.
  DEFINE VAR cnt            AS INTEGER NO-UNDO.
  DEFINE VAR i              AS INTEGER NO-UNDO.
  DEFINE VAR ipos           AS INTEGER NO-UNDO.
  DEFINE VAR lngth          AS INTEGER NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior.
     This should not run at design time. */
  RUN get-attribute ('UIB-Mode':U).
   IF RETURN-VALUE eq ? THEN DO:
    /* Get the handle of the container. Ask the container for the context ID
       of the procedure, and for the xftr code. */
    RUN get-link-handle IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "Container-Source":U,
         OUTPUT ch).
    h_container = WIDGET-HANDLE(ch).
    IF VALID-HANDLE (h_container) THEN DO:
      RUN get-attribute IN h_container ('Procedure-Context':U).
      proc-ID = INTEGER(RETURN-VALUE).
      RUN get-xftrcode IN h_container.
      xftrcode = RETURN-VALUE.
     
      /* Get the associated query. */
      RUN find-query-tables.
      
      /* Get the sortby options from the code. */
      RUN adm/support/_tagdat.p ("GET":U, "SORTBY-OPTIONS":U, 
                                  INPUT-OUTPUT sortby-options, INPUT-OUTPUT xftrcode).
      cnt = NUM-ENTRIES(sortby-options, CHR(10)).
      DO i = 1 TO cnt:
        ch = ENTRY(i, sortby-options, CHR(10)).
        CREATE tt.
        ASSIGN tt.num         = i * 2
               tt.sort-case   = ENTRY(1, ch, "|":U)
               tt.dflt-case   = ENTRY(2, ch, "|":U) eq "y":U
               tt.freeform    = ENTRY(3, ch, "|":U) eq "y":U
               .
        /* Everything after the last expression is the sort-by phrase, or the
           sort-rebuild information. */
        ASSIGN lngth = LENGTH(ch, "CHARACTER":U) 
               ipos  = INDEX(ch, "|":U).      
        IF ipos > 0 AND ipos < lngth THEN ipos  = INDEX(ch, "|":U, ipos + 1).
        IF ipos > 0 AND ipos < lngth THEN ipos  = INDEX(ch, "|":U, ipos + 1).
        IF ipos eq lngth OR ipos eq 0 THEN tt.sort-phrase = "".
        ELSE DO:
          tt.sort-phrase = SUBSTRING(ch, ipos + 1, -1, "CHARACTER":U). 
          /* Place Line-Feeds into Free-form phrases, and move the data into the
             sort-by rebuild information if it is not freeform. */
          IF tt.freeform 
          THEN tt.sort-phrase = REPLACE (tt.sort-phrase, "/*lf*/":U, CHR(10)).
          ELSE DO:
            tt.sort-build = tt.sort-phrase.
            RUN build-sort-phrase (tt.sort-build, OUTPUT tt.sort-phrase).
          END. /* IF (not) freeform... */
        END.
      END. /* DO i = 1 to cnt... */
    END. /* IF VALID-HANDLE (h_container)... */
  END. /* IF not uib-mode... */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN reopen-query.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE make-unique-name s-object 
PROCEDURE make-unique-name :
/*------------------------------------------------------------------------------
  Purpose:     Make sure that the new name is not already taken. 
  Parameters: 
    p_suggestion - (INPUT CHAR) the suggested name
    p_recid      - (INPUT RECID) the recid of the new name. We don't want
                   to check this RECID.
    p_new-name   - (OUTPUT CHAR) A unique name
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT  PARAMETER p_suggestion AS CHAR NO-UNDO.
  DEF INPUT  PARAMETER p_recid AS RECID NO-UNDO.
  DEF OUTPUT PARAMETER p_new-name AS CHAR NO-UNDO.
  
  DEF VAR i AS INTEGER NO-UNDO INITIAL 1.
  DEF BUFFER ipTT FOR tt.
  
  p_new-name = p_suggestion.
  FIND FIRST ipTT WHERE ipTT.sort-case eq p_new-name 
                    AND RECID(ipTT) ne p_recid  NO-ERROR.
  DO WHILE AVAILABLE ipTT:
    ASSIGN i = i + 1
           p_new-name = p_suggestion + "-":U + TRIM(STRING(i,">>>>>9":U)).
    FIND FIRST ipTT WHERE ipTT.sort-case eq p_new-name 
                      AND RECID(ipTT) ne p_recid  NO-ERROR.
  END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopen-query s-object 
PROCEDURE reopen-query :
/*------------------------------------------------------------------------------
  Purpose:     Reopen the browse query, and set the interface correctly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i    AS INTEGER NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    {&OPEN-QUERY-{&BROWSE-NAME}}
    IF open-on-row > 0 THEN 
      ldummy = {&BROWSE-NAME}:SET-REPOSITIONED-ROW (open-on-row, "CONDITIONAL":U).
    REPOSITION {&BROWSE-NAME} TO RECID open-recid NO-ERROR.
    ldummy = {&BROWSE-NAME}:SELECT-ROW({&BROWSE-NAME}:FOCUSED-ROW) NO-ERROR.
    RUN set-screen-elements.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reorder-browse s-object 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save-changes s-object 
PROCEDURE save-changes :
/*------------------------------------------------------------------------------
  Purpose:     Save all the changes that have been made so far.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR case-list      AS CHAR    NO-UNDO.
  DEFINE VAR ch             AS CHAR    NO-UNDO.
  DEFINE VAR run-time-code  AS CHAR    NO-UNDO.

  IF l_changes2save THEN DO:
    /* Recreate the list sortby options from the temp-table. */
    ASSIGN sortby-options = ""
           case-list      = ""
          .
    FOR EACH tt:
      /* Ignore blank lines. */
      IF tt.sort-case ne "" AND tt.sort-case ne "New Case" AND tt.sort-phrase ne "" 
      THEN ASSIGN
            /* Strip commas and | from the name. */
            tt.sort-case   = REPLACE(REPLACE(tt.sort-case , ",":U, "":U), "|":U, "":U) 
            case-list      = (IF case-list eq "" THEN "" ELSE case-list + ",":U)
                             + tt.sort-case
            ch             = IF tt.freeform 
                             THEN REPLACE (tt.sort-phrase, CHR(10), "/*lf*/":U) 
                             ELSE tt.sort-build       
            sortby-options = (IF sortby-options eq "":U 
                              THEN "":U 
                              ELSE sortby-options + CHR(10))
                             + SUBSTITUTE ("&1|&2|&3|&4":U,
                                           tt.sort-case ,
                                           (IF tt.dflt-case THEN "y" ELSE ""),
                                           (IF tt.freeform  THEN "y" ELSE ""),
                                           ch).
    END.
   
    /* SortBy-Cases are supplied in a quoted list. */
    IF case-list ne "" THEN case-list = "'":U + case-list + "'":U.
    
    /* Get the default case. */
    FIND FIRST tt WHERE tt.dflt-case NO-ERROR.
    run-time-code = 
            "************************" + CHR(10)
          + "* Set attributes related to SORTBY-OPTIONS */" + CHR(10)
          + "RUN set-attribute-list (" + CHR(10)
          + "    'SortBy-Options = ""':U + " + case-list + " + '""," + CHR(10) 
          + "     SortBy-Case = ':U" + (IF AVAILABLE tt THEN (" + '" + tt.sort-case + "'") ELSE '')
          + ").":U + CHR(10) 
          +  CHR(10) 
          + "/* Tell the ADM to use the OPEN-QUERY-CASES. */" + CHR(10) 
          + "~&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U)."
          + CHR(10).
     
    /* Is this a SORTBY-TARGET? */
    IF NUM-ENTRIES(case-list) > 1 THEN DO:
       run-time-code =  run-time-code  +  CHR(10)
          + "/* This SmartObject is a valid SortBy-Target. */" + CHR(10) 
          + "&IF '~{&user-supported-links}':U ne '':U ~&THEN" + CHR(10)  
          + "  ~&Scoped-define user-supported-links ~{&user-supported-links},SortBy-Target" + CHR(10)
          + "~&ELSE" + CHR(10)
          + "  ~&Scoped-define user-supported-links SortBy-Target" + CHR(10)  
          + "~&ENDIF" + CHR(10).
    END.
    
    /* Add a blank line, and restart the comment for the structured data.*/
    run-time-code =  run-time-code  +  CHR(10)
          + "/************************".
    
    /* Save the run-time code as part of the structured data.  NOTE the use
       of comments around this code. */
    RUN adm/support/_tagdat.p ("SET":U, "SORTBY-RUN-CODE":U, 
                                INPUT-OUTPUT run-time-code, INPUT-OUTPUT xftrcode).
    
    /* Save the options themselves as structured data. */
    RUN adm/support/_tagdat.p ("SET":U, "SORTBY-OPTIONS":U, 
                                INPUT-OUTPUT sortby-options, INPUT-OUTPUT xftrcode).
    
    /* Save these changes in the container. */
    RUN set-xftrcode IN h_container (xftrcode).
  
    /* Make sure the SmartObject has the correct internal procedures. */
    IF sortby-options ne "":U THEN RUN check-procedures.  

    /* Note that there are no more changes to save. */
    l_changes2save = no.
    
  END. /* IF l_changes2save... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-screen-elements s-object 
PROCEDURE set-screen-elements :
/*------------------------------------------------------------------------------
  Purpose:     Set the sensitivity of buttons etc. in the interface.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      b_remove:SENSITIVE    = {&BROWSE-NAME}:NUM-SELECTED-ROWS > 0
      b_insert:SENSITIVE    = query-tables ne "":U
      b_quick-ins:SENSITIVE = b_insert:SENSITIVE
      .
    /* Show values. */
    IF AVAILABLE tt 
    THEN ASSIGN
        tg_dflt-case:SENSITIVE     = yes
        tg_freeform:SENSITIVE      = yes
        tg_dflt-case:CHECKED       = tt.dflt-case
        tg_freeform:CHECKED        = tt.freeform
        c_sort-phrase:SCREEN-VALUE = tt.sort-phrase
        c_sort-phrase:SENSITIVE    = yes
        c_sort-phrase:READ-ONLY    = NOT tt.freeform
        c_sort-phrase:BGCOLOR      = (IF tt.freeform THEN ? ELSE 8)
        b_qb:SENSITIVE             = NOT tt.freeform
        .
    ELSE ASSIGN
        tg_dflt-case:SENSITIVE     = no
        tg_freeform:SENSITIVE      = no
        tg_dflt-case:CHECKED       = no
        tg_freeform:CHECKED        = no
        c_sort-phrase:SCREEN-VALUE = ""
        c_sort-phrase:READ-ONLY    = yes
        c_sort-phrase:SENSITIVE    = no
        b_qb:SENSITIVE             = no
        .
    
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed s-object 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     State handling.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

