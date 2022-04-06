&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
/* Procedure Description
"Query Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _wizkey.w

  Description: Query/Browse key wizard page 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Wm. T. Wood

  Created: June 1996

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
{ src/adm/support/admhlp.i } /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Shared Variable Definitions ---                                      */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c_info       AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_exttbls    AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_key-phrase AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_query-dfnd AS LOGICAL NO-UNDO.
DEFINE VARIABLE key-object   AS CHARACTER NO-UNDO.
DEFINE VARIABLE smo-type     AS CHARACTER NO-UNDO.
DEFINE VARIABLE obj-ID       AS INTEGER NO-UNDO.
DEFINE VARIABLE proc-ID      AS INTEGER NO-UNDO.
DEFINE VARIABLE xftr-ID      AS INTEGER NO-UNDO.
DEFINE VARIABLE xftrcode     AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Wizard-Page

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Page-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 e_msg c_keys-supplied RECT-3 ~
c_keys-accepted b_Help 
&Scoped-Define DISPLAYED-OBJECTS e_msg c_keys-supplied c_keys-accepted 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Edit 
     LABEL "Define Foreign Keys" 
     SIZE 26 BY 1.1.

DEFINE BUTTON b_Help 
     LABEL "Help on Foreign Keys" 
     SIZE 26 BY 1.1.

DEFINE VARIABLE c_keys-accepted AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
     SIZE 49 BY 2.76
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c_keys-supplied AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
     SIZE 49 BY 2.76
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 5.38
     BGCOLOR 8  NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 4.38.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 4.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Page-Frame
     e_msg AT ROW 1.71 COL 57 NO-LABEL
     c_keys-supplied AT ROW 2.19 COL 5 NO-LABEL
     c_keys-accepted AT ROW 6.71 COL 5 NO-LABEL
     b_Edit AT ROW 8.14 COL 57
     b_Help AT ROW 9.57 COL 57
     " Keys Supplied" VIEW-AS TEXT
          SIZE 15 BY .71 AT ROW 1.48 COL 5
     RECT-4 AT ROW 1.71 COL 3
     "(Keys this object can pass on to others)" VIEW-AS TEXT
          SIZE 40 BY .81 AT ROW 5.05 COL 5
     " Keys Accepted" VIEW-AS TEXT
          SIZE 16 BY .67 AT ROW 6.05 COL 5
     RECT-3 AT ROW 6.24 COL 3
     "(Keys this object can receive)" VIEW-AS TEXT
          SIZE 31 BY .81 AT ROW 9.57 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 83.6 BY 10.24
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Wizard-Page
   Allow: Basic,Browse,DB-Fields
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
  CREATE WINDOW C-Win ASSIGN
         HEIGHT             = 10.24
         WIDTH              = 83.6.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Page-Frame
   UNDERLINE Default                                                    */
/* SETTINGS FOR BUTTON b_Edit IN FRAME Page-Frame
   NO-ENABLE                                                            */
ASSIGN 
       c_keys-accepted:READ-ONLY IN FRAME Page-Frame        = TRUE.

ASSIGN 
       c_keys-supplied:READ-ONLY IN FRAME Page-Frame        = TRUE.

ASSIGN 
       e_msg:READ-ONLY IN FRAME Page-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME Page-Frame
/* Query rebuild information for FRAME Page-Frame
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME Page-Frame */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/support/keyprocs.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b_Edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Edit C-Win
ON CHOOSE OF b_Edit IN FRAME Page-Frame /* Define Foreign Keys */
DO:
   RUN edit-keys.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help C-Win
ON CHOOSE OF b_Help IN FRAME Page-Frame /* Help on Foreign Keys */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Wiz_Foreign_Keys}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P =  FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  =  FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       .
/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT c_info).
proc-ID = INTEGER(c_info).
/* Get the type of SmartObject. */
RUN adeuib/_uibinfo.p (proc-id, ? , "TYPE":U, OUTPUT smo-type).

/* Does this object have External-Tables (if so, it cannot also accept 
    foreign keys)? */
RUN adeuib/_uibinfo.p (proc-id, ? , "EXTERNAL-TABLES":U, OUTPUT c_info).
l_exttbls = c_info ne "":U AND c_info ne ?.
  
/* Get the 'Foreign Keys' XFTR section of this procedure. */  
RUN adeuib/_accsect.p 
  (INPUT "GET":U,               /* retrieve the current contents */
   INPUT proc-ID,               /* context ID */
   INPUT "XFTR:Foreign Keys":U, /* name of section. */  
   INPUT-OUTPUT xftr-ID,        /* section ID is returned */
   INPUT-OUTPUT xftrcode).      /* contents of xftr section */

/* Find out the KEY-OBJECT.  This should be either &BROWSE-NAME or &QUERY-NAME.
   Get the 4GL Query associated with this object.  If it does not contain the
   expression "{&KEY-PHRASE}", then keys are not accepted. */
IF xftrcode ne "":U THEN DO:
  RUN adm/support/_tagdat.p ("GET":U, "KEY-OBJECT":U, 
                        INPUT-OUTPUT key-object, INPUT-OUTPUT xftrcode).
  IF CAN-DO ("&QUERY-NAME,&BROWSE-NAME":U, key-object) THEN DO:
    /* Ask the procedure for the CONTEXT ID of the key-object. */
    RUN adeuib/_uibinfo.p (proc-ID, ?, key-object, OUTPUT c_info).
    obj-ID = INTEGER(c_info).
    /* Get the 4GLquery for this object. */
    RUN adeuib/_uibinfo.p (obj-ID, ?, "4GL-Query", OUTPUT c_info).
    /* Was the query defined, and if so, does it use a key-phrase? */
    ASSIGN l_query-dfnd = LENGTH(c_info) > 0
           l_key-phrase = l_query-dfnd AND 
                          INDEX(c_info, "~~~{&KEY-PHRASE}":U) > 0.
    /* If there are NO foreign keys yet, then create the foreign keys. */
    IF l_query-dfnd THEN DO:
      RUN adm/support/_tagdat.p ("GET":U, "FOREIGN-KEYS":U,                               
                                 INPUT-OUTPUT c_info, INPUT-OUTPUT xftrcode).
      IF c_info eq "" THEN RUN create-foreign-keys.
    END. /* IF...query defined...*/
  END. /* IF CAN-DO(&QUERY-NAME...key-object... */
END. /* IF xftrcode... */
   
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
  RUN set-screen-elements.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-foreign-keys C-Win 
PROCEDURE create-foreign-keys :
/*------------------------------------------------------------------------------
  Purpose:     Find all the keys that are relevent to the p_table.  Store
               these in the XFTR with id xftr-ID.  
  Parameters:  <none>
  External Variables Used:
      xftr-ID - the context of the Foreign Keys XFTR section.
      xftrcode - the contents of the Foreign Keys XFTR code section.
      obj-ID - The context ID of the key-object
      key-object - The name of the key-object (ie. &BROWSE-NAME or &QUERY-NAME)
 ------------------------------------------------------------------------------*/
  DEFINE VAR accept-list   AS CHAR          NO-UNDO.
  DEFINE VAR cnt           AS INTEGER       NO-UNDO.
  DEFINE VAR fld_name      AS CHAR          NO-UNDO.
  DEFINE VAR foreign-keys  AS CHAR          NO-UNDO.
  DEFINE VAR i             AS INTEGER       NO-UNDO.
  DEFINE VAR l_answer      AS LOGICAL       NO-UNDO.
  DEFINE VAR l_ok2accept   AS LOGICAL       NO-UNDO.
  DEFINE VAR key-table     AS CHAR          NO-UNDO.
  DEFINE VAR supply-list   AS CHAR          NO-UNDO.
  DEFINE VAR temp          AS CHAR          NO-UNDO.
  DEFINE VAR unique-list   AS CHAR          NO-UNDO.
  
  /* Get the first table used by the key-object. */
  RUN adeuib/_uibinfo.p (obj-ID, ?, "TABLES":U, OUTPUT key-table).
  IF NUM-ENTRIES(key-table) > 1 THEN key-table = ENTRY(1, key-table).
  IF key-table ne "" THEN DO:    
    /* Guess at the keys?  */
    RUN adeuib/_keygues.p (INPUT  key-table,
                           OUTPUT unique-list,
                           OUTPUT accept-list,  
                           OUTPUT supply-list).
    /* For queries and browses, it is a good idea not to accept keys that are
       unique (they will find only one record.) Remove unique keys from the
       accept-list. Only do this if we can define accepted keys.  That is, if
       there are no external tables, AND there is a KEY-PHRASE. */
    l_ok2accept = (l_exttbls eq NO) AND l_key-phrase.
    IF l_ok2accept THEN DO:
      ASSIGN temp = ""
             cnt = NUM-ENTRIES(accept-list).
      DO i = 1 TO cnt:
        fld_name = ENTRY(i, accept-list).
        IF NOT CAN-DO (unique-list,fld_name)
        THEN temp = temp + ",":U + fld_name.
      END. /* DO i... */
      /* Copy the temp list back to accept-list, removing the initial ",". */
      accept-list = LEFT-TRIM(temp, ",":U).
      
      /* Create a list for the foreign-keys. This list is of the form:
             key-name|y(if accepted)|y(if supplied)|key-field
         Assume the key-name is the same as the field-name.
         Also assume that anything accepted can also by supplied.
         At the same time, create the list of accepted names. */
      cnt = NUM-ENTRIES(accept-list).
      DO i = 1 TO cnt:
        ASSIGN fld_name     = ENTRY(i, accept-list)
               foreign-keys = foreign-keys + CHR(10)
                             + SUBSTITUTE("&1|y|y|&2.&1":U, /* Accepted & supplied */
                                         fld_name,    /* Key Name     */
                                         key-table).  /* db.tbl */
      END. /* DO i... */
    END. /* IF..ok2accept... */
    /* Add the supply list to the foreign-keys. Don't add things that are accepted.*/
    cnt = NUM-ENTRIES(supply-list).
    DO i = 1 TO cnt:
      fld_name = ENTRY(i, supply-list).
      IF (l_ok2accept eq NO) OR (CAN-DO (accept-list, fld_name) eq NO)
      THEN foreign-keys = foreign-keys + CHR(10) 
                         + SUBSTITUTE("&1||y|&2":U,  /* Just supplied */
                                fld_name,            /* Key Name     */
                                key-table + ".":U + fld_name).  /* db.tbl.fld */
    END. /* DO i... */
    
   IF foreign-keys ne "":U THEN DO:
     /* Build the XFTR section. */
     RUN build-xftr-section (foreign-keys, key-object, OUTPUT xftrcode).
     /* Store the section. */
     RUN adeuib/_accsect.p ('SET':U, ?, ?,
                            INPUT-OUTPUT xftr-ID,
                            INPUT-OUTPUT xftrcode).
                              
     /* Make sure the SmartObject has the correct internal procedures. */
     RUN check-procedures (proc-ID, key-object).  
   END. /* IF foreign-keys... */
  END. /* IF key-table ne ""... */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win _DEFAULT-DISABLE
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
  HIDE FRAME Page-Frame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE edit-keys C-Win 
PROCEDURE edit-keys :
/*------------------------------------------------------------------------------
  Purpose:     Call up the 'Foreign-Keys' Edit dialog for this procedure.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR c_code     AS CHAR    NO-UNDO.
  /* Pass the xftr code to the Edit handler for Foreign Keys. 
     Save a copy to check if there were any changes. */
  c_code = xftrcode.
  RUN adm/support/keyedit.w (INPUT xftr-ID, INPUT-OUTPUT c_code).
  
  /* Did anything change? */
  IF c_code ne xftrcode THEN DO:
    /* Store the 'Foreign Keys' section. */
    xftrcode = c_code.
    RUN adeuib/_accsect.p 
      (INPUT "SET":U,          /* retrieve the current contents */
       INPUT ?,                /* context - default is current procedure */
       INPUT ?,                /* name - not needed if section ID is valid */      
       INPUT-OUTPUT xftr-ID,   /* section ID is known */
       INPUT-OUTPUT xftrcode). /* new contents of section */
       
    /* Show the changes. */
    RUN show-keys.
    
  END. /* IF c_code ne xcode... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-screen-elements C-Win 
PROCEDURE set-screen-elements :
/*------------------------------------------------------------------------------
  Purpose:     Set the contents and sensitivity of the elements on the screen
               based on contents.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Set the message.  This message will depend on:
        * is there a query defined?
        * does the query use a KEY-PHRASE?
        * are there external tables? */
  e_msg = "You now need to define foreign keys for this " + smo-type + ".".
  IF l_query-dfnd eq NO THEN DO:
    e_msg = e_msg + chr(10) + chr(10) +
            "(This must be done after a query has been defined.)".
  END.
  ELSE IF l_exttbls THEN DO:
    e_msg = e_msg + chr(10) + chr(10) +
            "(No keys can be accepted because this SmartObject has 'External Tables'.)".
  END.
  ELSE IF l_key-phrase eq no THEN DO:
    e_msg = e_msg + chr(10) + chr(10) +
            "(No keys can be accepted because the query does not have a KEY-PHRASE.)".
  END.
  DISPLAY e_msg WITH FRAME {&FRAME-NAME}.
  
  /* Set the values of the fields that show keys. */
  RUN show-keys.
  
  /* Set object sensitivity. */
  ASSIGN b_Edit:SENSITIVE = l_query-dfnd AND (xftr-ID ne ?).
  ENABLE {&ENABLED-OBJECTS} WITH FRAME {&FRAME-NAME}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-keys C-Win 
PROCEDURE show-keys :
/*------------------------------------------------------------------------------
  Purpose:     Populate the lists based on the contents of the XFTR code section.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR foreign-keys AS CHAR NO-UNDO.
  DEF VAR ch AS CHAR NO-UNDO.
  DEF VAR key AS CHAR NO-UNDO.
  DEF VAR i AS INTEGER NO-UNDO.
  DEF VAR cnt AS INTEGER NO-UNDO.
  DEF VAR c_label AS CHAR NO-UNDO.
  
  /* Get the 'FOREIGN-KEYS' section of the xftr code. */
  RUN adm/support/_tagdat.p ('GET':U, 'FOREIGN-KEYS':U,
                             INPUT-OUTPUT foreign-keys,
                             INPUT-OUTPUT xftrcode).
  ASSIGN cnt = NUM-ENTRIES(foreign-keys, CHR(10))
         c_keys-accepted = "":U 
         c_keys-supplied = "":U.
  DO i = 1 TO cnt:
    /* Each line of foreign-keys is of the form:
          key-name|y(if accepted)|y(if supplied)|key-field 
       Parse this line, but remember to ignore accepted keys if there are
       external tables, or if there is NO key-phrase in the query. */
    ASSIGN ch = ENTRY(i, foreign-keys, CHR(10))
           key = ENTRY(1, ch, "|":U).
    IF (NOT l_exttbls) AND l_key-phrase AND ENTRY(2, ch, "|":U) eq "y":U
    THEN c_keys-accepted = c_keys-accepted + CHR(10) + key. 
    IF ENTRY(3, ch, "|":U) eq "y":U
    THEN c_keys-supplied = c_keys-supplied + CHR(10) + key. 
  END. /* DO... */
  
  /* Trim the leading CHR(10). */
  ASSIGN c_keys-accepted = LEFT-TRIM(c_keys-accepted)
         c_keys-supplied = LEFT-TRIM(c_keys-supplied).
  /* The label of the "Add" button changes from "Define" to Modify". */
  c_label = IF l_query-dfnd eq NO
            THEN ("No query defined")
            ELSE ((IF c_keys-accepted eq "":U AND c_keys-supplied eq "":U 
                   THEN "Define" ELSE "Modify") + " Foreign Keys").
  DO WITH FRAME {&FRAME-NAME}:
    IF c_label NE b_Edit:LABEL THEN b_Edit:LABEL = c_label.

    /* Replace empty lists with "[none]". */
    IF c_keys-accepted eq "":U THEN c_keys-accepted = "[none]":U.
    IF c_keys-supplied eq "":U THEN c_keys-supplied = "[none]":U.                     
    DISPLAY c_keys-accepted c_keys-supplied WITH FRAME {&FRAME-NAME}.
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


