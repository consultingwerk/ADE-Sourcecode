&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS s-object 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: filtedit.w

  Description: A editor for Filter Attributes in the  Advanced Query section
               in a SmartBrowser or SmartQuery

  Parameters:  <none>
  
  Author: Wm.T.Wood 

  Created: June, 1995
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */
DEFINE VAR h_container    AS HANDLE  NO-UNDO.
DEFINE VAR ldummy         AS LOGICAL NO-UNDO.
DEFINE VAR l_changes2save AS LOGICAL NO-UNDO.
DEFINE VAR open-recid     AS RECID   NO-UNDO.
DEFINE VAR open-on-row    AS INTEGER NO-UNDO.
DEFINE VAR query-object   AS CHAR    NO-UNDO.  
DEFINE VAR query-tables   AS CHAR    NO-UNDO.  
DEFINE VAR filter-attrs   AS CHAR    NO-UNDO.
DEFINE VAR proc-ID        AS INTEGER NO-UNDO.
DEFINE VAR xftrcode       AS CHAR    NO-UNDO.

/* Temp-Table for browsing keys ---                                     */
DEFINE TEMP-TABLE tt NO-UNDO
  FIELD num AS INTEGER
  FIELD name AS CHAR
  FIELD initial AS CHAR 
  INDEX num IS PRIMARY num
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fr_filters
&Scoped-define BROWSE-NAME brws-list

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt

/* Definitions for BROWSE brws-list                                     */
&Scoped-define FIELDS-IN-QUERY-brws-list tt.name tt.initial   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brws-list ALL   
&Scoped-define FIELD-PAIRS-IN-QUERY-brws-list~
 ~{&FP1}ALL ~{&FP2}ALL ~{&FP3}
&Scoped-define OPEN-QUERY-brws-list OPEN QUERY brws-list PRESELECT EACH tt.
&Scoped-define TABLES-IN-QUERY-brws-list tt
&Scoped-define FIRST-TABLE-IN-QUERY-brws-list tt


/* Definitions for FRAME fr_filters                                     */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brws-list Btn_OK Btn_Cancel b_Insert ~
Btn_Help 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY DEFAULT 
     LABEL "Cancel" 
     SIZE 16 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help DEFAULT 
     LABEL "&Help" 
     SIZE 16 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     LABEL "OK" 
     SIZE 16 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON b_Insert 
     LABEL "&Insert Row" 
     SIZE 16 BY 1.08.

DEFINE BUTTON b_Remove 
     LABEL "&Remove Row" 
     SIZE 16 BY 1.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brws-list FOR 
      tt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brws-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brws-list s-object _FREEFORM
  QUERY brws-list NO-LOCK DISPLAY
      tt.name  FORMAT "X(32)"    WIDTH 28 LABEL "Name of Filter Attribute"
      tt.initial FORMAT "X(256)" WIDTH 25 LABEL "Initial Value"
ENABLE ALL
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-COLUMN-SCROLLING SEPARATORS MULTIPLE SIZE 56 BY 7.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fr_filters
     brws-list AT ROW 1.54 COL 2
     Btn_OK AT ROW 1.54 COL 59
     Btn_Cancel AT ROW 2.88 COL 59
     b_Insert AT ROW 4.23 COL 59
     b_Remove AT ROW 5.58 COL 59
     Btn_Help AT ROW 8.27 COL 59
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
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
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW s-object
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fr_filters
   Size-to-Fit                                                          */
ASSIGN 
       FRAME fr_filters:SCROLLABLE       = FALSE.

ASSIGN 
       brws-list:NUM-LOCKED-COLUMNS IN FRAME fr_filters = 1
       brws-list:MAX-DATA-GUESS IN FRAME fr_filters     = 12.

/* SETTINGS FOR BUTTON b_Remove IN FRAME fr_filters
   NO-ENABLE                                                            */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB s-object 
/* ************************* Included-Libraries *********************** */

{src/adm/method/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fr_filters
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fr_filters s-object
ON GO OF FRAME fr_filters
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
ON ROW-LEAVE OF brws-list IN FRAME fr_filters
DO:
  DEF VAR l_OK AS LOGICAL NO-UNDO.
  
  IF AVAILABLE tt THEN DO:
    /* Is the filter-name OK? It must be a valid progress name. */
    IF tt.name:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ne tt.name THEN DO:
      RUN adecomm/_valname.p (tt.name:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, 
                              INPUT TRUE, /* Allow a blank name. */ 
                              OUTPUT l_ok).
      IF NOT l_OK THEN RETURN NO-APPLY.
     
      /* Note that something changed, so changes will be saved. */
      l_changes2save = yes.
    END.
    ELSE IF tt.initial:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ne tt.initial THEN DO:
      /* Note that something changed, so changes will be saved. */
      l_changes2save = yes.
    END.
  END. /* IF AVAILABLE tt... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brws-list s-object
ON VALUE-CHANGED OF brws-list IN FRAME fr_filters
DO:
  RUN set-screen-elements.
  ASSIGN open-recid  = IF AVAILABLE tt THEN RECID(tt) ELSE ?
         open-on-row = SELF:FOCUSED-ROW.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel s-object
ON CHOOSE OF Btn_Cancel IN FRAME fr_filters /* Cancel */
DO:
  /* Exit out of the dialog-box */
  RUN notify ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help s-object
ON CHOOSE OF Btn_Help IN FRAME fr_filters /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  /* Define Context ID's for HELP files */
  { src/adm/support/admhlp.i }    
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&XFTR_Filter_Page} , "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Insert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Insert s-object
ON CHOOSE OF b_Insert IN FRAME fr_filters /* Insert Row */
DO:
  DEFINE VAR old-num AS INTEGER NO-UNDO.
  
  /* Create a new tt record and reopen the query on this row. */
  IF NOT available tt THEN FIND LAST tt NO-ERROR.
  IF available tt THEN old-num = tt.num.
  CREATE tt.
  tt.num = old-num + 1.
  RUN reorder-browse.
  ASSIGN open-recid = RECID(tt)
         open-on-row = open-on-row + 1
         . 
  RUN reopen-query. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Remove s-object
ON CHOOSE OF b_Remove IN FRAME fr_filters /* Remove Row */
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK s-object 


/* ***************************  Main Block  *************************** */

/* Don't allow commas or "=" in the name. */
ON ",":U, "=":U OF tt.name    IN BROWSE {&BROWSE-NAME} RETURN NO-APPLY.
ON ",":U, "'":U OF tt.initial IN BROWSE {&BROWSE-NAME} RETURN NO-APPLY.

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI s-object _DEFAULT-DISABLE
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
  HIDE FRAME fr_filters.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
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
  DEFINE VAR obj-id   AS INTEGER NO-UNDO.
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
  DEFINE VAR ok2create      AS LOGICAL NO-UNDO.
  
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
      
      /* Get the filter attributes from the code. This should be of the form:
         RUN set-attribute-list IN THIS-PROCEDURE ('
           attribute = value,
           attribute = value,
           attribute = value'). */
      RUN adm/support/_tagdat.p ("GET":U, "FILTER-ATTRIBUTES",
                                 INPUT-OUTPUT filter-attrs, INPUT-OUTPUT xftrcode).
      ASSIGN ok2create = NO
             cnt = NUM-ENTRIES(filter-attrs, CHR(10)).     
      DO i = 1 TO cnt:
        ch = ENTRY(i, filter-attrs, CHR(10)).
        IF NOT ok2create THEN DO:
          /* Start creating TT records on the line after the set-attribute-list. */
         IF INDEX(ch, 'set-attribute-list':U) > 0 THEN ok2create = yes.
        END.
        ELSE DO:
          /* Stop creating when NO ='s are found. */
          IF INDEX(ch, "=") > 0 THEN DO:
            /* Remove the trailing ') or comma. */
            ch = ENTRY(1, REPLACE(ch, "'":U, ",":U)).
            CREATE tt.
            ASSIGN tt.num         = i * 2
                   tt.name        = TRIM (ENTRY(1, ch, "=":U))
                  .
            /* Everything after the 2nd "=" is the initial-value or the
               sort-rebuild information. */
            ASSIGN ch    = TRIM(ch)
                   lngth = LENGTH(ch, "CHARACTER":U) 
                   ipos  = INDEX(ch, "=":U).      
            IF ipos eq lngth OR ipos eq 0 
            THEN tt.initial = "".
            ELSE tt.initial = SUBSTRING(ch, ipos + 1, -1, "CHARACTER":U). 
          END. /* IF INDEX..."=" > 0 ... */
        END. /* IF ok2create... */
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
  IF l_changes2save THEN DO:
    /* Recreate the list sortby options from the temp-table. */
    ASSIGN filter-attrs = "".
    FOR EACH tt:
      /* Ignore blank lines. */
      IF tt.name ne "":U
      THEN ASSIGN
            /* Strip commas and | from the name. Store the values in a structured
               comment AND in a set-attribute-list. */
            tt.name      = REPLACE(REPLACE(tt.name , ",":U, "":U), "=":U, "":U) 
            tt.initial   = REPLACE(REPLACE(tt.initial , ",":U, "":U), "'":U, "":U) 
            filter-attrs = (IF filter-attrs eq "":U 
                            THEN "":U ELSE filter-attrs + ",":U + CHR(10))
                         + SUBSTITUTE ("  &1=&2":U, tt.name, tt.initial).
    END.
    /* Get the default case. */
    IF filter-attrs ne "":U THEN DO:
      filter-attrs = 
            "************************" + CHR(10)
          + "* Initialize Filter Attributes */" + CHR(10)
          + "RUN set-attribute-list IN THIS-PROCEDURE ('":U + CHR(10) 
          + filter-attrs + "':U).":U + CHR(10) 
          + CHR(10)
          + "/* This SmartObject is a valid Filter-Target. */" + CHR(10) 
          + "&IF '~{&user-supported-links}':U ne '':U ~&THEN" + CHR(10)  
          + "  ~&Scoped-define user-supported-links ~{&user-supported-links},Filter-Target" + CHR(10)
          + "~&ELSE" + CHR(10)
          + "  ~&Scoped-define user-supported-links Filter-Target" + CHR(10)  
          + "~&ENDIF" + CHR(10) 
          + "/* Tell the ADM to use the OPEN-QUERY-CASES. */" + CHR(10)
          + "~&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U)."
          + CHR(10)
          /* Restart the comment for the structured data.*/
          + "/************************".
          
      /* Make sure the SmartObject has the correct internal procedures. */
      RUN check-procedures.
    END.
    
    /* Save the FILTER-ATTRIBUES code as part of the structured data.  NOTE the use
       of comments around this code. */
    RUN adm/support/_tagdat.p ("SET":U, "FILTER-ATTRIBUTES":U, 
                                INPUT-OUTPUT filter-attrs, INPUT-OUTPUT xftrcode).
    
    /* Save these changes in the container. */
    RUN set-xftrcode IN h_container (xftrcode).
 
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
      b_remove:SENSITIVE = {&BROWSE-NAME}:NUM-SELECTED-ROWS > 0
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


