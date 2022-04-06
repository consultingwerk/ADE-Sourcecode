&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"Template Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" C-Win _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" C-Win _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" C-Win _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* New Program Wizard
Welcome to the New Program Wizard! During the next few steps, the wizard will lead you through all the stages necessary to create this type of object. If you cancel the wizard at any time, then all your changes will be lost. Once the wizard is completed, it is possible to recall parts of the wizard using the LIST option from the section editor. Press Next to proceed.
af/cod/aftemwiziw.w,af/cod/aftemwizpw.w,af/cod/aftemwizew.w 
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" C-Win _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: aftemwizdw.w

  Description:  Template wizard window

  Purpose:      Template Wizard Window. Use this template to create wizard windows
                executed as part of a set and controlled by aftemwizcw.
                To flag this wizard screen as ok to finish, use the code:
                APPLY "U1":U TO ip_hwizard. /* ok to finish */
                To flag this wizard screen as not ok to finish, use the code:
                APPLY "U2":U TO ip_hwizard. /* not ok to finish */

  Parameters:   ip_hwizard (handle) - handle of Wizard controller

  History:
  --------
  (v:010000)    Task:          41   UserRef:    AS0
                Date:   05/02/1998  Author:     Anthony Swindells

  Update Notes: Implement Wizard Controller

  (v:010001)    Task:          72   UserRef:    TEMPNAME
                Date:   27/02/1998  Author:     Alec Tucker

  Update Notes: Added mip-wizard globally defined preprocessor

  (v:010004)    Task:         103   UserRef:    
                Date:   20/03/1998  Author:     Anthony Swindells

  Update Notes: Fix WRX problems.

  (v:010006)    Task:         297   UserRef:    
                Date:   08/06/1998  Author:     Anthony Swindells

  Update Notes: Add more standard procedures

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftemwizdw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* MIP object identifying preprocessor */
&glob   mip-wizard  yes

/*{ adm/support/admhlp.i} /* ADM Help File Defs */*/

/* Parameters Definitions ---                                           */

&IF DEFINED(UIB_is_Running) NE 0 &THEN
    DEFINE VARIABLE ip_hwizard AS WIDGET-HANDLE NO-UNDO.
&ELSE
    DEFINE INPUT PARAMETER ip_hwizard AS WIDGET-HANDLE NO-UNDO.
&ENDIF

/* UIB API call general variables */
DEFINE VARIABLE lv_uibinfo                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_srecid                       AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_code                         AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fr_main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi_window_title 
&Scoped-Define DISPLAYED-OBJECTS fi_window_title 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi_window_title AS CHARACTER FORMAT "X(256)":U 
     LABEL "Window title" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 TOOLTIP "Enter the window title for this folder" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fr_main
     fi_window_title AT ROW 1.67 COL 19 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1.05
         SIZE 127.6 BY 16.38
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 16.43
         WIDTH              = 128
         MAX-HEIGHT         = 16.43
         MAX-WIDTH          = 128
         VIRTUAL-HEIGHT     = 16.43
         VIRTUAL-WIDTH      = 128
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fr_main
   UNDERLINE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
IF VALID-HANDLE(ip_hwizard) THEN
    ASSIGN FRAME {&FRAME-NAME}:FRAME    = ip_hwizard.

ASSIGN FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P =  FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  =  FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       .

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

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
  RUN enable_UI.

  RUN setup.

  IF VALID-HANDLE(ip_hwizard) THEN
    APPLY "U1":U TO ip_hwizard. /* ok to finish */

  {af/sup/afendcmain.i}
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  HIDE FRAME fr_main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY fi_window_title 
      WITH FRAME fr_main.
  ENABLE fi_window_title 
      WITH FRAME fr_main.
  {&OPEN-BROWSERS-IN-QUERY-fr_main}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-block C-Win 
PROCEDURE find-block :
/*------------------------------------------------------------------------------
  Purpose:     To return a | delimited block of text between ip_lookup1 and ip_lookup2
  Parameters:  INPUT  ip_lookup1
               INPUT  ip_lookup2
               INPUT  ip_text
               INPUT  ip_start_posn
               OUTPUT op_result
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  ip_lookup1      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  ip_lookup2      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  ip_text         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  ip_start_posn   AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER op_result       AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_posn         AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_start_posn   AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_end_posn     AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_lf_posn      AS INTEGER INITIAL 0 NO-UNDO.

ASSIGN  ip_text = REPLACE(ip_text,"|":U, " ":U)
        lv_start_posn = INDEX(ip_text,ip_lookup1,ip_start_posn)
        lv_end_posn = INDEX(ip_text,ip_lookup2,lv_start_posn + 1)
        lv_posn = lv_start_posn + LENGTH(ip_lookup1)
        op_result = "".

IF lv_start_posn > 0 AND lv_end_posn > 0 THEN
    DO WHILE (lv_posn < lv_end_posn):
        ASSIGN  lv_lf_posn = INDEX(ip_text,CHR(10),lv_posn).
        IF lv_lf_posn = 0 THEN LEAVE.
        IF lv_lf_posn < lv_end_posn THEN
            ASSIGN op_result =  op_result +
                                    (IF NUM-ENTRIES(op_result,"|":U) > 0 THEN "|":U ELSE "":U) +
                                    TRIM(SUBSTRING(ip_text,lv_posn,lv_lf_posn - lv_posn)).                                    
        ASSIGN lv_posn = lv_lf_posn + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-text C-Win 
PROCEDURE find-text :
/*------------------------------------------------------------------------------
  Purpose:     To return trimmed text after the lookup string and before a <cr> or comment
  Parameters:  INPUT  ip_lookup
               INPUT  ip_text
               OUTPUT op_result
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  ip_lookup   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  ip_text     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_result   AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_start_posn   AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_end_posn     AS INTEGER INITIAL 0 NO-UNDO.

ASSIGN  lv_start_posn = INDEX(ip_text,ip_lookup)
        lv_end_posn = INDEX(ip_text,CHR(10),lv_start_posn + 1)
        op_result = "".

IF lv_end_posn = 0 THEN
    ASSIGN lv_end_posn = lv_start_posn + LENGTH(ip_lookup).

IF lv_start_posn <> 0 THEN
    ASSIGN op_result = TRIM(SUBSTRING(ip_text,lv_start_posn + LENGTH(ip_lookup), lv_end_posn - (lv_start_posn + LENGTH(ip_lookup)))).

/* remove comment off the end */
IF INDEX(op_result,"/*") > 0 THEN
    ASSIGN op_result = SUBSTRING(op_result,1,INDEX(op_result,"/*") - 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-field-database C-Win 
PROCEDURE get-field-database :
/*------------------------------------------------------------------------------
  Purpose:     To return the database name that the table belongs to
  Parameters:  INPUT table
               OUTPUT database
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip_table AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_database AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_loop AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lv_table_exists AS LOGICAL INITIAL NO NO-UNDO.

DO WHILE lv_loop <= NUM-DBS:
    CREATE ALIAS db_metaschema FOR DATABASE VALUE (LDBNAME(lv_loop)) NO-ERROR.
    RUN af/sup/aftablelup.p (INPUT ip_table, OUTPUT lv_table_exists).
    IF lv_table_exists THEN
        ASSIGN op_database = LDBNAME(lv_loop)
               lv_loop = NUM-DBS. 
    ASSIGN lv_loop = lv_loop + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remove-trailing-lfs C-Win 
PROCEDURE remove-trailing-lfs :
/*------------------------------------------------------------------------------
  Purpose:     Remove trailing line feeds from string passed in
  Parameters:  INPUT-OUTPUT iop_text
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER   iop_text        AS CHARACTER NO-UNDO.

DEFINE VARIABLE                 lv_loop         AS INTEGER NO-UNDO.

ASSIGN lv_loop = LENGTH(iop_text).
IF NUM-ENTRIES(iop_text,CHR(10)) > 1 THEN
  DO WHILE lv_loop > 1 AND SUBSTRING(iop_text,lv_loop,1) = CHR(10):
    ASSIGN lv_loop = lv_loop - 1.            
  END.
ASSIGN iop_text = TRIM(SUBSTRING(iop_text,1,lv_loop)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setup C-Win 
PROCEDURE setup :
DEFINE VARIABLE lv_result AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_start_posn AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_end_posn AS INTEGER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

    /* Get the current contents of the definition section */
    RUN adeuib/_accsect.p( "GET":U, ?, "DEFINITIONS":U,
                           INPUT-OUTPUT lv_srecid,
                           INPUT-OUTPUT lv_code ).

    RUN find-text(  INPUT   "&scop window-title":U,
                    INPUT   lv_code,
                    OUTPUT  lv_result).
    DISPLAY lv_result @ fi_window_title.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE strip-db-from-editor C-Win 
PROCEDURE strip-db-from-editor :
/*------------------------------------------------------------------------------
  Purpose:     To strip the databases from the passed in editor (if any)
  Parameters:  INPUT-OUTPUT iop_editor_text
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER iop_editor_text AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.

DB-LOOP:
DO lv_loop = 1 TO NUM-DBS:  /* num-dbs = number of connected databases */
    ASSIGN
        iop_editor_text = REPLACE( iop_editor_text, (TRIM(LDBNAME(lv_loop)) + ".":U), "":U). 
END. /* db-loop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE strip-db-from-field C-Win 
PROCEDURE strip-db-from-field :
/*------------------------------------------------------------------------------
  Purpose:     To strip the database prefix from the passed in field (if any)
  Parameters:  INPUT-OUTPUT iop_field
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER iop_field AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.

IF NUM-ENTRIES(iop_field, ".":U) <= 1 THEN RETURN.

DB-LOOP:
DO lv_loop = 1 TO NUM-DBS:  /* num-dbs = number of connected databases */

    IF TRIM(LC(ENTRY(1, iop_field, ".":U))) = TRIM(LC(LDBNAME(lv_loop))) THEN
      DO:
        ASSIGN iop_field = REPLACE(iop_field, ENTRY( 1, iop_field, ".":U ) + ".":U, "":U).
        LEAVE DB-LOOP.
      END.

END. /* db-loop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-definition-section C-Win 
PROCEDURE update-definition-section :
/*------------------------------------------------------------------------------
  Purpose:     To update the screen values to the definition section
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lv_lookup1          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lv_lookup2          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lv_start_posn       AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE lv_end_posn         AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE lv_posn             AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE lv_loop             AS INTEGER              NO-UNDO.
DEFINE VARIABLE lv_loop2            AS INTEGER              NO-UNDO.
DEFINE VARIABLE lv_num_entries      AS INTEGER              NO-UNDO.
DEFINE VARIABLE lv_error            AS LOGICAL              NO-UNDO.
DEFINE VARIABLE lv_procedure_name   AS CHARACTER            NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
        fi_window_title
        .

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.

    /* Get the current contents of the definition section */
    RUN adeuib/_accsect.p( "GET":U, ?, "DEFINITIONS":U,
                           INPUT-OUTPUT lv_srecid,
                           INPUT-OUTPUT lv_code ).

    ASSIGN
        lv_lookup1 = "&scop window-title":U
        lv_start_posn = INDEX(lv_code,lv_lookup1)
        lv_end_posn = INDEX(lv_code,CHR(10),lv_start_posn + 1)
        lv_posn = INDEX(lv_code,"/*":U,lv_start_posn + 1).
    IF lv_posn > 0 AND lv_posn < lv_end_posn THEN ASSIGN lv_end_posn = lv_posn. /* Ignore comment at end */
    IF lv_end_posn = 0 THEN
        ASSIGN lv_end_posn = lv_start_posn + LENGTH(lv_lookup1).

    SUBSTRING(lv_code,lv_start_posn + LENGTH(lv_lookup1),lv_end_posn - (lv_start_posn + LENGTH(lv_lookup1))) = 
        " ":U + TRIM(fi_window_title) + " ":U.

    /* Write back new definition section */
    RUN adeuib/_accsect.p( "SET":U, ?, "DEFINITIONS":U,
                           INPUT-OUTPUT lv_srecid,
                           INPUT-OUTPUT lv_code ).

    /* Finally, mark the window as unsaved. */

    RUN adeuib/_uibinfo( INPUT  ?,              /* Don't know the context ID               */
                         INPUT  "WINDOW ?",     /* We want the handle of the design window */
                         INPUT  "HANDLE",       /* We want the handle                      */
                         OUTPUT lv_uibinfo ).   /* Returns a string of the handle          */

    RUN adeuib/_winsave( WIDGET-HANDLE( lv_uibinfo ), TRUE ).

    IF SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate-window C-Win 
PROCEDURE validate-window :
/*------------------------------------------------------------------------------
  Purpose:     To validate whether the window is correct and return an error
               if not. If the return-value is returned as "ERROR" then no warning
               will be given, otherwise a warning of the return-value will be
               given to the user. 
               Any return value will cause the window not to be closed, as controlled
               by the wizard controller.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1st update definition section */
RUN update-definition-section.

DO WITH FRAME {&FRAME-NAME}:


END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

