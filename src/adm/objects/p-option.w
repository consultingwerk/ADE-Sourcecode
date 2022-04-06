&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

  File: p-option.w

  Description: 
      A SmartPanel that has a list of options. These options are retrieved from
      linked object at initialization.:
          RUN get-attribute IN <link> ('<Options-Attribute>':U).
      This list is displayed in either a combo-box, selection-list or radio-set.
      
      When the user changes the value of the list, then the linked object is sent
      the new value:
          RUN set-attribute-list IN <link> ('<Case-Attribute> = <value>':U)
          
      This panel will also automatically dispatch an additional event to
      the linked object if the 'Case-Changed-Event' is also set:
          RUN dispatch IN <link> ('<Case-Changed-Event>').
               
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Authors: Wm.T.Wood and Rick Kuzyk
  Created: March 1996
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR c_options-list AS CHAR NO-UNDO.            /* List of options.         */
DEF VAR c_initial-case AS CHAR NO-UNDO.            /* Initial Case             */
DEF VAR h_list AS WIDGET-HANDLE NO-UNDO.           /* Control to list options. */
DEF VAR c_delimiter AS CHAR NO-UNDO INITIAL ",":U. /* The delimiter to use.    */

/* ADM Preprocessor Defintions ---                                      */
&Scoped-define adm-attribute-dlg adm/support/optiond.w

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartPanel

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 

/* Custom List Definitions                                              */
/* Box-Rectangle,Label,List-3,List-4,List-5,List-6                      */
&Scoped-define Box-Rectangle RECT-1 
&Scoped-define Label c-Label 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-Label AS CHARACTER FORMAT "X(256)":U INITIAL "&Options" 
      VIEW-AS TEXT 
     SIZE 8 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 2.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-Label AT ROW 1 COL 2 NO-LABEL
     RECT-1 AT ROW 1.27 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FGCOLOR 1 .

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartPanel
   Allow: Basic
   Frames: 1
   Add Fields to: NEITHER
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
         HEIGHT             = 3.27
         WIDTH              = 28.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW s-object
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-Label IN FRAME F-Main
   NO-DISPLAY NO-ENABLE ALIGN-L 2                                       */
ASSIGN 
       c-Label:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME F-Main
   1                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB s-object 
/* ************************* Included-Libraries *********************** */

{src/adm/method/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK s-object 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN  
    /* Code needed to test this object (when run directly from the UIB) */       
    RUN dispatch IN THIS-PROCEDURE ('initialize').        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE apply-style s-object 
PROCEDURE apply-style :
/*------------------------------------------------------------------------------
  Purpose:     Create a control to show the options in. The type of control
               is based on the "Style" attribute.
  Parameters:  <none>
  Notes:       Create the handle, h_list, to show the option-list.
                    ***************************************************
               This is NOT a "use-style" method that is automatically called
               when the "style" attribute is set because we want explicit control
               over when the dynamic objects are created. The objects cannot be
               created until the parent frame has been parented and realized.
                    ***************************************************
------------------------------------------------------------------------------*/
  DEFINE VAR c_btns   AS CHAR    NO-UNDO.
  DEFINE VAR c_ibtn   AS CHAR    NO-UNDO.
  DEFINE VAR c_style  AS CHAR    NO-UNDO.
  DEFINE VAR ch       AS CHAR    NO-UNDO.
  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR iCnt     AS INTEGER NO-UNDO.
  DEFINE VAR i_margin AS INTEGER NO-UNDO.
  DEFINE VAR l_dummy  AS LOGICAL NO-UNDO.
  
  /* Delete the previous sample. */
  IF VALID-HANDLE(h_list) AND h_list:DYNAMIC THEN DELETE WIDGET h_list.
  
  /* Create a new item. */
  RUN get-attribute ('Style':U).
  c_style = RETURN-VALUE.
  RUN get-attribute ('UIB-Mode':U).
  IF RETURN-VALUE eq 'Design':U THEN DO:
    /* Show sample lists at design time. Make sure we set the delimiter in
       the list correctly. */
    CASE c_style:
      WHEN 'Selection-List':U THEN 
        c_options-list = 'Sample 1,Sample 2,Sample 3,Sample 4,Sample 5,Sample 6'.
      WHEN 'Horizontal Radio-Set':U THEN
        c_options-list = 'Sample 1,Sample 2'.
      OTHERWISE
        c_options-list = 'Sample 1,Sample 2,Sample 3'.
    END CASE.
    ASSIGN c_initial-case = ENTRY (1, c_options-list)
           c_options-list = REPLACE (c_options-list, ',':U, c_delimiter).
  END. 
  
  /* Create the list object based on the 'Style'. */
  CASE c_style:
    WHEN "SELECTION-LIST":U THEN
      /* NOTE: You can't set SCREEN-VALUE on Selection lists until they 
         have been parented and realized. */
      CREATE SELECTION-LIST h_list ASSIGN
        SCROLLBAR-VERTICAL = yes
        DELIMITER  = c_delimiter
        LIST-ITEMS = c_options-list
        .
    WHEN "COMBO-BOX":U THEN 
      CREATE COMBO-BOX h_list ASSIGN 
        DELIMITER    = c_delimiter
        FORMAT       = 'x(256)':U     /* Otherwise items get truncated. */
        LIST-ITEMS   = c_options-list
        INNER-LINES  = MAX(3, MIN ( 1 + h_list:NUM-ITEMS, 10))
        SCREEN-VALUE = c_initial-case
        .
    WHEN "HORIZONTAL RADIO-SET":U OR WHEN "VERTICAL RADIO-SET":U THEN DO:
      /* Copy the options list into a form that a radio-set understands. */
      ASSIGN c_btns = '':U
             c_ibtn = ?
             iCnt   = NUM-ENTRIES (c_options-list, c_delimiter).
      DO i = 1 TO iCnt:
        /* Get each entry and remove any commas. Create a comma delimited
           list of the form "option,1,option,2,etc.". This will be used to
           set the radio-buttons.*/
        ASSIGN ch = ENTRY(i, c_options-list, c_delimiter) 
               ch = REPLACE (ch, ",", '') 
               c_btns = c_btns + (IF i > 1 THEN ',':U ELSE '':U) + 
                        ch + ',':U + STRING(i).
        /* Remember the initial button. */
        IF c_initial-case eq ch THEN c_ibtn = STRING(i).
      END. /* DO i... */
      IF iCnt > 0 THEN 
        CREATE RADIO-SET h_list ASSIGN
          HORIZONTAL    = (c_style BEGINS "H":U)
          RADIO-BUTTONS = c_btns
          SCREEN-VALUE  = c_ibtn.
    END.     
  END CASE.
  
  /* Parent the list to the frame and size it using the default behavior
     of the resize algorithm. */
  IF VALID-HANDLE (h_list) THEN DO:
    /* Parent the list, and give it a label (with accelerator key). */
    ASSIGN h_list:FRAME = FRAME {&FRAME-NAME}:HANDLE
           h_list:SIDE-LABEL-HANDLE = c-Label:HANDLE IN FRAME {&FRAME-NAME}
           .
    
    /* Populate the list and add triggers (at run-time only). */
    RUN get-attribute ('UIB-Mode':U).
    IF RETURN-VALUE eq ? THEN DO:
      h_list:SENSITIVE = yes.      
      ON VALUE-CHANGED OF h_list PERSISTENT 
        RUN send-case-across-link IN THIS-PROCEDURE.
    END.
    
    /* Resize everthing. */
    RUN set-size (?, ?). 

    /* Make sure the options don't cover other controls on the frame
       (including the UIB-Mode "system" menu). */
    l_dummy = h_list:MOVE-TO-BOTTOM().
     
  END.
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize s-object 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Retrieve the list of options (at run-time). */
  RUN get-attribute ('UIB-Mode':U).
  IF RETURN-VALUE eq ? THEN RUN retrieve-options-list. 
  
  /* Make sure that there is some default style for the option list. */
  RUN get-attribute ('Style':U).
  IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Style = Selection-List':U).  
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Use the style - this will create the COMBO-BOX, SELECTION-LIST, etc. 
     NOTE that we require that the frame is visible before we create any
     of the contained widgets. */
  RUN get-attribute ('Hide-On-Init':U).
  IF RETURN-VALUE NE "YES":U THEN
    VIEW FRAME {&FRAME-NAME}.
  RUN apply-style.
 
  /* Selection-Lists cannot have there initial value set prior to visualization,
     so set those here. */
  IF VALID-HANDLE(h_list) 
     AND h_list:TYPE eq 'SELECTION-LIST':U 
     AND c_initial-case ne ?
  THEN h_list:SCREEN-VALUE = c_initial-case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-UIB-mode s-object 
PROCEDURE local-UIB-mode :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method. If the object has just been drawn
               in the UIB, then make sure it is sized correctly.
               
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'UIB-mode':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute ('Drawn-in-UIB':U).
  IF RETURN-VALUE eq ? THEN DO:
       
    /* Mark this as having been drawn. */
    RUN set-attribute-list ('Drawn-in-UIB=yes':U).

    /* Set default values for Parameters */
    RUN get-attribute ('Case-Attribute':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Case-Attribute = SortBy-Case':U).
    RUN get-attribute ('Case-Changed-Event':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Case-Changed-Event = Open-Query':U).
    RUN get-attribute ('Dispatch-Open-Query':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Dispatch-Open-Query = yes':U).
    RUN get-attribute ('Edge-Pixels':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Edge-Pixels = 2':U).
    RUN get-attribute ('Label':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Label = &Sort By':U).
    RUN get-attribute ('Link-Name':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Link-Name = SortBy-Target':U).
    RUN get-attribute ('Margin-Pixels':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Margin-Pixels = 10':U).
    RUN get-attribute ('Options-Attribute':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Options-Attribute = SortBy-Options':U).
     
    /* Allow the developer to edit these initial values at Design time
       (i.e. when UIB-Mode ne "Preview".) */
    RUN get-attribute ('UIB-Mode':U).
    IF RETURN-VALUE eq 'Design':U THEN RUN dispatch ('edit-attribute-list':U).
       
    /* Make sure the object has been sized correctly. (This will process
       edge-pixels and margin-pixels.) */
    RUN set-size IN THIS-PROCEDURE 
        (FRAME {&FRAME-NAME}:HEIGHT, FRAME {&FRAME-NAME}:WIDTH).
 
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieve-options-list s-object 
PROCEDURE retrieve-options-list :
/*------------------------------------------------------------------------------
  Purpose:     This procedure asks the relevant linked object to return the
               list of valid-options.
  Parameters:  <none>
  Notes:       Their can only be a single linked object.
               This routine also sets the DELIMITER for the options-list.
------------------------------------------------------------------------------*/
  DEF VAR c_list       AS CHAR NO-UNDO.
  DEF VAR case-attr    AS CHAR NO-UNDO.
  DEF VAR h_linked-SmO AS HANDLE NO-UNDO.
  DEF VAR iCnt         AS INTEGER NO-UNDO.
  DEF VAR link-name    AS CHAR NO-UNDO.
  DEF VAR options-attr AS CHAR NO-UNDO.
   
  /* 
   * Get all the objects linked using "link-name". Set the option attribute in
   * those objects.
   */
   
  /* STEP 1 - get the name of the link, and the attribute to set.
   *          Check for errors. */
  RUN get-attribute ('Link-Name':U).
  link-name = RETURN-VALUE.
  RUN get-attribute ('Options-Attribute':U).
  options-attr = RETURN-VALUE.
  RUN get-attribute ('Case-Attribute':U).
  case-attr = RETURN-VALUE.
  IF NOT (LENGTH(link-name) > 0         /* Check for UNKNOWN or blank */
          AND LENGTH(options-attr) > 0  /* Check for UNKNOWN or blank */
          AND LENGTH(case-attr) > 0)    /* Check for UNKNOWN or blank */
  THEN MESSAGE THIS-PROCEDURE:FILE-NAME SKIP
         "This SmartObject was not correctly initialized."
         IF NOT LENGTH(link-name) > 0    THEN CHR(10) + " - Link-Name not set"  ELSE ""
         IF NOT LENGTH(options-attr) > 0 THEN CHR(10) + " - Options-Attribute not set" ELSE ""
         IF NOT LENGTH(case-attr) > 0    THEN CHR(10) + " - Case-Attribute not set" ELSE ""
         VIEW-AS ALERT-BOX ERROR.
  ELSE DO:
    /* STEP 2 - get the linked object.
     *          Check for errors. */
    RUN get-link-handle IN adm-broker-hdl (THIS-PROCEDURE, link-name, OUTPUT c_list).
    iCnt = NUM-ENTRIES (c_list).
    IF iCnt > 1 THEN 
      MESSAGE "Multiple" link-name + "s exist for this SmartObject." 
              "Therefore the list of options cannot be retrieved."
              VIEW-AS ALERT-BOX WARNING.
    ELSE IF iCnt = 0 THEN RETURN.
    ELSE DO:
      /* STEP 3 - Get the option attribute and case attribute in the linked object.
       *          Check for errors. */
      h_linked-SmO = WIDGET-HANDLE (c_list).
      IF VALID-HANDLE (h_linked-SmO) THEN DO:
        RUN get-attribute IN h_linked-SmO (options-attr).
        c_options-list = RETURN-VALUE.
        IF c_options-list eq ? 
        THEN MESSAGE 'The SmartObject,' THIS-PROCEDURE:FILE-NAME + 
                     ', cannot retrieve the list of options from its'
                     link-name + ',' h_linked-SmO:FILE-NAME + 
                     ', because that SmartObject does not define the'
                     options-attr 'attribute.'  
                     VIEW-AS ALERT-BOX ERROR.
        ELSE DO:
          /* Get the initial value of the 'Case-Attribute'.
           * Assign the list of options, and this initial condition.  
           */
          RUN get-attribute IN h_Linked-SmO (case-attr).
          c_initial-case = RETURN-VALUE. 
        END.
        /* Look for a "Delimiter" attribute. If it is not there, then
         * guess at the delimiter. Assume it is ",", however also look for "|"
         * and CHR(10) if there are < 2 comma delimited options.
         */
        RUN get-attribute ('Delimiter':U).
        IF RETURN-VALUE eq ? OR RETURN-VALUE ne "" THEN DO: 
          c_delimiter = ",":U.
          IF NUM-ENTRIES(c_options-list, c_delimiter) < 2 THEN DO:
            IF NUM-ENTRIES(c_options-list, "|":U) > 1 THEN
              c_delimiter = "|":U.
            ELSE IF NUM-ENTRIES(c_options-list, CHR(10)) > 1 THEN 
              c_delimiter = CHR(10).      
          END. /* IF...delimiter) < 2... */ 
        END.
        ELSE DO:
          /* Check for special values. */
          CASE RETURN-VALUE:
            WHEN "COMMA":U     THEN c_delimiter = ",":U.
            WHEN "LINE-FEED":U THEN c_delimiter = CHR(10).
            WHEN "SPACE":U     THEN c_delimiter = " ":U.
            OTHERWISE  c_delimiter = SUBSTRING(RETURN-VALUE, 1, 1, "CHARACTER":U).
          END CASE.
        END. /* IF RETURN-VALUE... */
      END. /* IF VALID...h_linked-SmO... */
    END. /* ELSE DO...STEP 3 ... */
  END. /* ELSE DO...STEP 2 ... */    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-case-across-link s-object 
PROCEDURE send-case-across-link :
/*------------------------------------------------------------------------------
  Purpose:     Sends the option case to the linked target, and optionally 
               dispatches and event (such as 'open-query') to it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR c_case       AS CHAR NO-UNDO.
  DEF VAR c_list       AS CHAR NO-UNDO.
  DEF VAR case-attr    AS CHAR NO-UNDO.
  DEF VAR h_linked-SmO AS HANDLE NO-UNDO.
  DEF VAR iCnt         AS INTEGER NO-UNDO.
  DEF VAR link-name    AS CHAR NO-UNDO.
  
  /* 
   * Get all the objects linked using "link-name". Set the option attribute in
   * those objects.
   */
   
  /* STEP 1 - get the name of the link, and the attribute to set.
   *          Check for errors. */
  RUN get-attribute ('Link-Name':U).
  link-name = RETURN-VALUE.
  RUN get-attribute ('Case-Attribute':U).
  case-attr = RETURN-VALUE.
 /* Verify that everything is valid. [Errors would have been reported in
     the retrieve-options-list procedure.] */
  IF LENGTH(link-name) > 0        /* Check for UNKNOWN or blank */
     AND LENGTH(case-attr) > 0    /* Check for UNKNOWN or blank */
     AND VALID-HANDLE(h_list)
  THEN DO:
    /* STEP 2 - Get the list of linked objects.
     *          Check for errors. */
    RUN get-link-handle IN adm-broker-hdl (THIS-PROCEDURE, link-name, OUTPUT c_list).
    iCnt = NUM-ENTRIES (c_list).
    IF iCnt = 0 THEN 
      MESSAGE "No" link-name "exists for this object." VIEW-AS ALERT-BOX WARNING.
    ELSE IF iCnt > 1 THEN
      MESSAGE "Multiple" link-name + "s exist for this object." SKIP(1)
              "Command cancelled." 
              VIEW-AS ALERT-BOX WARNING.
    ELSE DO:
      /* STEP 3 - Set the option attributethe linked object.
       *          Check for errors.  NOTE: the value of the option is
       *          currently set in the the h_list widget, except for
       *          radio-sets where we need to take the entry and look
       *          it up in the option list. */
      ASSIGN h_linked-SmO = WIDGET-HANDLE (c_list)
             c_case       = h_list:SCREEN-VALUE.
      IF h_list:TYPE eq 'RADIO-SET':U
      THEN c_case = ENTRY(INTEGER(c_case), c_options-list, c_delimiter).
      IF VALID-HANDLE (h_linked-SmO) THEN DO:
        RUN set-attribute-list IN h_linked-SmO 
                (case-attr + '=':U + c_case).
        /* 
         * Dispatch any case processing event to the linked object (if necessary)
         */
        RUN get-attribute IN THIS-PROCEDURE ('Case-Changed-Event':U).
        IF NUM-ENTRIES(RETURN-VALUE) > 0 THEN RUN dispatch IN h_linked-SmO (RETURN-VALUE).

      END. /* IF VALID...h_linked-SmO... */
    END. /* ELSE DO...STEP 3 ... */
  END. /* ELSE DO...STEP 2 ... */    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-size s-object 
PROCEDURE set-size :
/*------------------------------------------------------------------------------
  Purpose: Changes the size and shape of the panel.  This routine
           spaces the list object and border elements to fill the 
           available space.  
  Parameters: 
           pd_height - the desired height (in rows)
           pd_width  - the desired width (in columns)
  Notes:       
           If pd_width or pd_height are ? then use the current values.
           (i.e. RUN set-size (?,?) resets the current size).
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
    
  DEFINE VAR btn-height-p  AS INTEGER NO-UNDO.
  DEFINE VAR btn-width-p   AS INTEGER NO-UNDO.  
  DEFINE VAR h             AS WIDGET  NO-UNDO.
  DEFINE VAR i_margin      AS INTEGER NO-UNDO. /* Margin from frame to buttons */
  DEFINE VAR i_border-h    AS INTEGER NO-UNDO. /* Horizontal frame border      */
  DEFINE VAR i_border-v    AS INTEGER NO-UNDO. /* Vertical frame border        */
  DEFINE VAR i_box-y       AS INTEGER NO-UNDO. /* Start of BOX-RECTANGLE       */
  DEFINE VAR i_lbl-hgt-p   AS INTEGER NO-UNDO. /* Height of (label) Font       */
  DEFINE VAR i_test        AS INTEGER NO-UNDO.    
  DEFINE VAR i_height-p    AS INTEGER NO-UNDO. /* Desired frame height, pixels */
  DEFINE VAR i_width-p     AS INTEGER NO-UNDO. /* Desired frame width, pixels  */
  DEFINE VAR l_box-hidden  AS LOGICAL NO-UNDO.
  DEFINE VAR l_hidden      AS LOGICAL NO-UNDO.
  DEFINE VAR l_selected    AS LOGICAL NO-UNDO.
  DEFINE VAR min-height    AS DECIMAL NO-UNDO. /* Minumum frame height, chars  */
  DEFINE VAR min-width     AS DECIMAL NO-UNDO. /* Minumum frame width, chars   */
  DEFINE VAR num-rows      AS INTEGER NO-UNDO.
  DEFINE VAR num-cols      AS INTEGER NO-UNDO.
  DEFINE VAR p-width-p     AS INTEGER NO-UNDO. /* Width of all panel buttons   */
  DEFINE VAR p-height-p    AS INTEGER NO-UNDO. /* Height of all panel buttons  */
  
  /* There is a case where we want to just run the resizing logic, without
     changing the size. If ? is passed in, use the current sizes. */
  IF pd_height eq ? THEN pd_height = FRAME {&FRAME-NAME}:HEIGHT.
  IF pd_width eq ?  THEN pd_width  = FRAME {&FRAME-NAME}:WIDTH.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* The margin is based on the standard column width, unless specified
       as an attribute. The margin is 0 for character mode SmartObjects. */
    &IF "{&WINDOW-SYSTEM}" eq "TTY" &THEN
      i_margin = 0.
    &ELSE
      RUN get-attribute IN THIS-PROCEDURE ('Margin-Pixels':U).
      IF RETURN-VALUE eq ? 
      THEN i_margin = SESSION:PIXELS-PER-COLUMN.
      ELSE i_margin = INTEGER(RETURN-VALUE).
    &ENDIF
    
    /* If there is a label, then this will move the top margin. */      
    &IF "{&Label}" ne "" &THEN
      IF {&Label}:SCREEN-VALUE ne "":U THEN DO:
       i_lbl-hgt-p = FONT-TABLE:GET-TEXT-HEIGHT-P (FRAME {&FRAME-NAME}:FONT).
       &IF "{&Box-Rectangle}" ne ""
       &THEN i_box-Y = MAX(0, i_lbl-hgt-p - {&Box-Rectangle}:EDGE-PIXELS) / 2.
       &ELSE i_box-Y = i_lbl-hgt-p.
       &ENDIF
      END.
    &ELSE
    ASSIGN i_lbl-hgt-p = 0
           i_box-Y     = 0.
    &ENDIF       
    /* Don't allow a size that won't hold the margins, the frame borders, the 
       label and the UIB "affordance" menu (about 16 pixels square, located at 
       (4,4)) [Add in an extra 2 pixels for a fudge factor].
       Note that if we need to increase the size based on a minumum, 
       then we will need to verify that the frame will still fit in its parent.  One final check
       is to guarantee that each row and column is at least one pixel (this is only
       a problem if you have more than about 16 buttons).  This minimum only applies
       on MS-Windows, because that is where the object will be used inside the UIB */
     &IF "{&WINDOW-SYSTEM}" eq "TTY" &THEN
       &Scoped-define min-p 0
     &ELSE
       &Scoped-define min-p 22
     &ENDIF
     ASSIGN 
       min-height = (MAX ({&min-p}, 1 + (2 * i_margin) + i_box-Y, i_lbl-hgt-p) / SESSION:PIXELS-PER-ROW) +
                    FRAME {&FRAME-NAME}:BORDER-TOP + 
                    FRAME {&FRAME-NAME}:BORDER-BOTTOM  
       min-width  = (MAX ({&min-p}, 1 + 2 * i_margin) / SESSION:PIXELS-PER-COLUMN) + 
                    FRAME {&FRAME-NAME}:BORDER-LEFT +
                    FRAME {&FRAME-NAME}:BORDER-RIGHT.   
    
    /* Hide the frame to reduce "flashing". Remember if it was already
       hidden, so we don't view it unnecessarily at the end of this
       procedure. (NOTE: Hiding a SELECTED frame turns off the Selection, 
       so we save the value to use when we make the Frame visible again.) */
    ASSIGN l_selected = FRAME {&FRAME-NAME}:SELECTED 
           l_hidden   = FRAME {&FRAME-NAME}:HIDDEN 
           FRAME {&FRAME-NAME}:HIDDEN = yes
           NO-ERROR.
           
    /* Do we need to adjust the size (and position). */
    IF min-height > pd_height OR min-width > pd_width THEN DO:
      /* Get the parent to insure that the frame will still fit inside it. */ 
      h = FRAME {&FRAME-NAME}:PARENT.
      IF h:TYPE ne "WINDOW":U THEN h = FRAME {&FRAME-NAME}:FRAME.
      /* Test width. */  
      IF min-width > pd_width THEN DO:
        ASSIGN pd_width  = min-width
               i_width-p = 1 + (pd_width * SESSION:PIXELS-PER-COLUMN)
               i_test    = IF h:TYPE eq "WINDOW":U OR h:SCROLLABLE
                           THEN h:VIRTUAL-WIDTH-P
                           ELSE h:WIDTH-P - h:BORDER-LEFT-P - h:BORDER-RIGHT-P.
        IF i_test < FRAME {&FRAME-NAME}:X + i_width-p 
        THEN ASSIGN FRAME {&FRAME-NAME}:X = MAX(0, i_test - i_width-p) NO-ERROR.
      END.
      /* Test height. */
      IF min-height > pd_height THEN DO:
        ASSIGN pd_height  = min-height 
               i_height-p = 1 + (pd_height * SESSION:PIXELS-PER-ROW)
               i_test     = IF h:TYPE eq "WINDOW":U OR h:SCROLLABLE
                            THEN h:VIRTUAL-HEIGHT-P
                            ELSE h:HEIGHT-P - h:BORDER-TOP-P - h:BORDER-BOTTOM-P.
        IF i_test < FRAME {&FRAME-NAME}:Y + i_height-p 
        THEN ASSIGN FRAME {&FRAME-NAME}:Y = MAX(0, i_test - i_height-p) NO-ERROR.
      END.
    END.
 
    /* Resize the frame and determine values based on the desired size. */
    ASSIGN 
        FRAME {&FRAME-NAME}:SCROLLABLE = yes
        FRAME {&FRAME-NAME}:WIDTH      = pd_width
        FRAME {&FRAME-NAME}:HEIGHT     = pd_height
        /* Convert from Decimal width and height be reading from the 
           FRAME itself. */
        i_width-p    = FRAME {&FRAME-NAME}:WIDTH-P
        i_height-p   = FRAME {&FRAME-NAME}:HEIGHT-P
        /* Save the calculation of frame borders */
        i_border-v   = FRAME {&FRAME-NAME}:BORDER-TOP-P +
                       FRAME {&FRAME-NAME}:BORDER-BOTTOM-P
        i_border-h   = FRAME {&FRAME-NAME}:BORDER-LEFT-P +
                       FRAME {&FRAME-NAME}:BORDER-RIGHT-P
        /* Compute the total width/height of the objects in the panel. 
           That is, subtract all the margins, decoration, and borders 
           from the frame size. */
        p-width-p    = i_width-p - i_border-h - (2 * i_margin)
        p-height-p   = i_height-p - i_border-v - i_box-Y - (2 * i_margin)
      NO-ERROR.
   
    /* Resize the list object. */
    IF VALID-HANDLE (h_list) THEN DO:
      ASSIGN h_list:HIDDEN   = yes 
             h_list:WIDTH-P  = p-width-p
             h_list:X        = i_margin
             h_list:Y        = i_box-Y + i_margin
           NO-ERROR.
      /* Height (and visibility) conditions will depend on the type of object. */
      IF h_list:TYPE eq 'COMBO-BOX':U THEN DO:
        /* Hide combo-box if frame is too small. */
        ASSIGN h_list:HIDDEN = (p-height-p < h_list:HEIGHT-P) NO-ERROR.
      END. /*...combo-box... */
      ELSE IF h_list:TYPE eq 'RADIO-SET':U AND NOT h_list:HORIZONTAL THEN DO:
        /* Size the Radio-Buttons based on the text-height */
        ASSIGN h_list:HEIGHT-P = MIN (p-height-p,
                                      (FONT-TABLE:GET-TEXT-HEIGHT-P (FRAME {&FRAME-NAME}:FONT) + 4) *
                                      NUM-ENTRIES(h_list:RADIO-BUTTONS) / 2)
               h_list:HIDDEN   = no
             NO-ERROR.
      END.
      ELSE DO:
        ASSIGN h_list:HEIGHT-P = p-height-p
               h_list:HIDDEN   = no
             NO-ERROR.
      END. /* ELSE DO:... */   
    END.
    
    /* If defined, set the Bounding Rectangle size. */
    &IF "{&Box-Rectangle}" ne "" &THEN
      ASSIGN l_box-hidden              = {&Box-Rectangle}:HIDDEN 
             {&Box-Rectangle}:HIDDEN   = yes
             {&Box-Rectangle}:X        = 0
             {&Box-Rectangle}:Y        = i_box-Y
             {&Box-Rectangle}:WIDTH-P  = i_width-p - i_border-h 
             /* If the contained object is shorter than the frame (e.g. for
                a combo-box, set the height of the rectangle based on the object. */
             {&Box-Rectangle}:HEIGHT-P =
                  MIN(i_height-p - i_border-v,
                      IF VALID-HANDLE(h_list)
                      THEN h_list:Y + h_list:HEIGHT-P + i_margin
                      ELSE i_height-p)
                   - i_box-Y
             {&Box-Rectangle}:HIDDEN   = l_box-hidden             
            NO-ERROR.
    &ENDIF

    /* If defined, set the LABEL width. */
    &IF "{&Label}" ne "" &THEN
      ASSIGN {&Label}:HIDDEN   = yes
             {&Label}:X        = i_margin
             {&Label}:Y        = 0 
             {&Label}:WIDTH-P  = MIN(FONT-TABLE:GET-TEXT-WIDTH-P 
                                     ({&Label}:SCREEN-VALUE, FRAME {&FRAME-NAME}:FONT),
                                    i_width-p - {&Label}:X - i_border-h) 
             {&Label}:HEIGHT-P = MIN(i_lbl-hgt-p, i_height-p - i_border-v)
             {&Label}:HIDDEN   = ({&LABEL}:SCREEN-VALUE eq "":U)                                
            NO-ERROR.
    &ENDIF

    /* Show the frame. Turn off SCROLLABLE to force virtual size to match
       viewport size.  We will turn SCROLLABLE back on so that the SmartPanel
       can be resized smaller. */
    ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE       = NO
           FRAME {&FRAME-NAME}:WIDTH-P          = i_width-p
           FRAME {&FRAME-NAME}:HEIGHT-P         = i_height-p
           NO-ERROR .  
    /* Frame must be SCROLLABLE if it is to be resized smaller than its
       contained buttons and rectangles. */    
    ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE = YES.
            
    /* View, and select, the frame, if necessary. */
    IF NOT l_hidden THEN FRAME {&FRAME-NAME}:HIDDEN   = no NO-ERROR.
    IF l_selected   THEN FRAME {&FRAME-NAME}:SELECTED = yes.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed s-object 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-edge-pixels s-object 
PROCEDURE use-edge-pixels :
/*------------------------------------------------------------------------------
  Purpose:     Use the current value of 'Edge-Pixels' in the {&Box-Rectangle}. 
  Parameters:  p_attr-value - (CHAR) the new value of the 'Font' Attribute
  Notes:       Default to 2 if unknown.) 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_attr-value AS CHAR NO-UNDO.
  
  /* We need do nothing is there is no box rectangle. */
  &IF NUM-ENTRIES("{&Box-Rectangle}") eq 1 &THEN    
    DEFINE VAR iEdge AS INTEGER NO-UNDO.
    
    /* Get the desired Edge-Pixels. */
    iEdge = INTEGER(p_attr-value) NO-ERROR.    
    /* Is the correct font set already? */
    DO WITH FRAME {&FRAME-NAME}:
      IF iEdge ne {&Box-Rectangle}:EDGE-PIXELS
      THEN {&Box-Rectangle}:EDGE-PIXELS = iEdge.
    END.
    
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-font s-object 
PROCEDURE use-font :
/*------------------------------------------------------------------------------
  Purpose:  Get the current value of 'font' and set the font of the FRAME to 
            this value.   
  Parameters:  p_attr-value -- the new Button Font attribute value
  Notes:    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_attr-value AS CHARACTER NO-UNDO.

  DEFINE VAR iFont AS INTEGER NO-UNDO INITIAL ?.
 
  /* Convert attribute string to an INTEGER font value. */
  iFont = IF p_attr-value eq "?" THEN ? ELSE INTEGER(p_attr-value) NO-ERROR.
    
  /* Is the correct font set already? */
  IF iFont ne FRAME {&FRAME-NAME}:FONT THEN DO:
    FRAME {&FRAME-NAME}:FONT = iFont.   
    /* If there is a LABEL, then resize the frame. */
    IF {&Label}:SCREEN-VALUE ne '':U 
    THEN RUN set-size IN THIS-PROCEDURE (?,?).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-label s-object 
PROCEDURE use-label :
/*------------------------------------------------------------------------------
  Purpose:     Get the current value of 'LABEL' and set the Label object to this
               value.   
  Parameters:  p_attr-value -- the new Label attribute value
  Notes:    
------------------------------------------------------------------------------*/  
  DEFINE INPUT PARAMETER p_attr-value AS CHARACTER NO-UNDO.

  DEFINE VAR h AS WIDGET NO-UNDO.
  
  /* Set the newdesired label.*/
  IF {&Label} ne p_attr-value THEN DO WITH FRAME {&FRAME-NAME}:
    {&Label} = p_attr-value.
  
    /* Reset the Label and its width. (If this FAILS, then we may need to 
       run the whole resize logic again. */
    ASSIGN {&Label}:SCREEN-VALUE = {&Label}
           {&Label}:HIDDEN = {&Label}:SCREEN-VALUE eq '':U
           {&Label}:WIDTH-P = FONT-TABLE:GET-TEXT-WIDTH-P
                                ({&Label}, FRAME {&FRAME-NAME}:FONT)
       NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RUN set-size IN THIS-PROCEDURE (?,?).
  END. /* IF.. THEN DO WITH FRAME... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-link-name s-object 
PROCEDURE use-link-name :
/*------------------------------------------------------------------------------
  Purpose:  Get the current value of 'Link-Name' and set the supported-links to
            be the inverse of this link.
  Parameters:  p_attr-value -- the new Label attribute value
  Notes:    
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER p_attr-value AS CHARACTER NO-UNDO.

  DEF VAR c_supported AS CHAR NO-UNDO.
  DEF VAR ch          AS CHAR NO-UNDO.
  DEF VAR cnt         AS INTEGER NO-UNDO.  
  
  /* The supported link is the OTHER end of the Link-Type shown in
     the LINK-NAME attribute value. */
  ASSIGN cnt         = NUM-ENTRIES (p_attr-value,"-":U)  
         c_supported = p_attr-value
         ch          = IF cnt < 2 THEN '':U 
                       ELSE ENTRY(cnt, p_attr-value, "-":U)
         .
  IF ch eq 'Source':U THEN ENTRY(cnt, c_supported, "-":U) = 'Target':U.
  ELSE IF ch eq 'Target' THEN ENTRY(cnt, c_supported, "-":U) = 'Source':U.
  ELSE DO:
    c_supported = IF cnt > 0 /* An empty Link-Name*/
                THEN c_supported + '-Source':U
                ELSE 'Option-Source':U.
                     
    /* Whoops! The Link-Name seems invalid...set it to something reasonable. */
    MESSAGE 'The Link-Name of the SmartObject does not indicate direction.'
            '(It does not specify "-Target" or "-Source".)' SKIP(1)
            'The ADM Supported Links will be set to' c_supported + '.':U
            VIEW-AS ALERT-BOX WARNING.
  END.
  /* Store the new supported link as an attribute. */
  RUN set-attribute-list ('Supported-Links=':U + c_supported).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


