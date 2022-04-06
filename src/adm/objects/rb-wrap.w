&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: rb-wrap.w

  Description:  a SmartObject wrapper for the Report Builder. As the SmartObject
                is chosen and placed on the design window, the instance editor is
                automatically run allowing the developer to chose defaults for
                the object. The defaults are stored in the object's attribute-list,
                so it is fully accessible.
                
                The instance attributes can be updated at anytime during Design
                mode by accessing the object's Instance Attributes.
                
                Many instances of this object could exist in an application,
                each with its' own attributes.
                
                The instance editor is also presented to the user at run-time
                when the SETUP button is chosen. However, options which the 
                user should normally not be able to control are disabled. 
                      
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Rick Kuzyk  
  Editor: Wm.T.Wood  
               - adhere to SmartObject Marketplace Style Guide
  
  Created: February 1996

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

/* Define Instance Attribute Dialog ---                                 */
&Scoped-define adm-attribute-dlg adm/support/rb-wrapd.w

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 R-Report B-SETUP B-RUN 
&Scoped-Define DISPLAYED-OBJECTS R-Report 

/* Custom List Definitions                                              */
/* Box-rectangle,Label,List-3,List-4,List-5,List-6                      */
&Scoped-define Box-rectangle RECT-3 
&Scoped-define Label c-Label 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-RUN 
     LABEL "&Run" 
     SIZE 7.14 BY .85.

DEFINE BUTTON B-SETUP 
     LABEL "&Setup" 
     SIZE 7.14 BY .85.

DEFINE VARIABLE R-Report AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 16.57 BY 1.

DEFINE VARIABLE c-Label AS CHARACTER FORMAT "X(256)":U INITIAL "&Reports" 
      VIEW-AS TEXT 
     SIZE 8 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.72 BY 2.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-Report AT ROW 1.92 COL 3 NO-LABEL
     c-Label AT ROW 1 COL 3.72 NO-LABEL
     B-SETUP AT ROW 1.54 COL 21
     B-RUN AT ROW 2.35 COL 21
     RECT-3 AT ROW 1.27 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.69
         WIDTH              = 30.14.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-Label IN FRAME F-Main
   NO-DISPLAY NO-ENABLE ALIGN-L 2                                       */
ASSIGN 
       c-Label:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR COMBO-BOX R-Report IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR RECTANGLE RECT-3 IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/reports.i}
{src/adm/method/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-RUN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-RUN V-table-Win
ON CHOOSE OF B-RUN IN FRAME F-Main /* Run */
/*-------------------------------------------------------------------
  Purpose:  The RUN button first retrieves all the values
            from the attribute list for this SmartObject then
            runs the report. The functions have been seperated 
            to allow greater developer flexibility in maintaining
            the attribute list themselves and using common routines
---------------------------------------------------------------------*/
DO:  
  v-report = R-REPORT:SCREEN-VALUE.
  RUN get-report-parameters.
  RUN run-report.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-SETUP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-SETUP V-table-Win
ON CHOOSE OF B-SETUP IN FRAME F-Main /* Setup */
/*------------------------------------------------------------
   Purpose:   This will call up the EDIT-ATTRIBUTE-LIST
              dialog for this procedure. This dialog
              determines whether this is happening in run-time
              or not and will disable the appropriate options.
-------------------------------------------------------------*/
DO:
  RUN dispatch IN THIS-PROCEDURE ('edit-attribute-list':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Report
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Report V-table-Win
ON ENTRY OF R-Report IN FRAME F-Main
/*------------------------------------------------------------
  Purpose:    This event fire the FILL-REPORT-LIST procedure
              for this combo-box.
-------------------------------------------------------------*/
DO:
  RUN fill-report-list.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  {&label}:screen-value = "&Reports".
  
  run set-size (?,?).

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-report-list V-table-Win 
PROCEDURE fill-report-list :
/* -----------------------------------------------------------
  Purpose:      This PROCEDURE will populate the combo box 
                   with report names.               
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
  
    DEF VAR vreport AS CHAR NO-UNDO.
    RUN get-attribute ('Report-Library':U).
    
    IF RETURN-VALUE NE ? THEN DO:
    
          vreport = RETURN-VALUE.
          
          DEFINE VARIABLE cName  AS CHARACTER NO-UNDO.
          DEFINE VARIABLE iCount AS INTEGER   NO-UNDO.
     
          RUN aderb/_getname.p (VREPORT,
                          output cName, 
                          output iCount).
    
          ASSIGN  R-Report:sensitive    = yes
                  R-Report:list-items   = cName
                  R-Report:screen-value = ENTRY (1,cName).
          END.
          
    ELSE ASSIGN R-Report:list-items = "<none>"
                R-Report:screen-value = R-Report:List-items.
       
  END. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-UIB-mode V-table-Win 
PROCEDURE local-UIB-mode :
/*------------------------------------------------------
  Purpose: Override standard ADM method
  Notes:   
    Then the attribute dialog is called 
    as if it were an "instance wizard". 
-------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard
     behavior. */
  
  /* Is this the first time? Check if the object 
     has been drawn in the UIB. */
  
  RUN get-attribute ('UIB-MODE').
  
  IF RETURN-VALUE NE "PREVIEW" THEN DO:
    RUN get-attribute ('Drawn-in-UIB':U).
    IF RETURN-VALUE eq ? THEN DO:
        /* Run the normal Instance Attribute dialog. */
        RUN dispatch ('edit-attribute-list':U).
        /* Set Drawn-in-UIB this won't happen again.*/
        RUN set-attribute-list ('Drawn-in-UIB = yes':U).
    END.
    
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'UIB-mode':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-size V-table-Win 
PROCEDURE set-size :
/*------------------------------------------------------------------------------
  Purpose: Changes the size and shape of the panel.  This routine
           spaces the objects to fill the available space.  If the
           objects won't fit the available space, then they are hidden.
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
  DEFINE VAR l_stacked     AS LOGICAL NO-UNDO. /* Are buttons stacked? */
  DEFINE VAR min-height    AS DECIMAL NO-UNDO. /* Minumum frame height, chars  */
  DEFINE VAR min-width     AS DECIMAL NO-UNDO. /* Minumum frame width, chars   */
  DEFINE VAR num-rows      AS INTEGER NO-UNDO.
  DEFINE VAR num-cols      AS INTEGER NO-UNDO.
  DEFINE VAR p-width-p     AS INTEGER NO-UNDO. /* Width of all panel buttons   */
  DEFINE VAR p-height-p    AS INTEGER NO-UNDO. /* Height of all panel buttons  */
  DEFINE VAR b-width-p     AS INTEGER NO-UNDO.
  DEFINE VAR b-height-p    AS INTEGER NO-UNDO.
  
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
       a problem if you have more than about 16 buttons). This minimum only applies
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
      
    /* Position and hide the buttons. Hide them while we are setting up
       the sizes. */
    ASSIGN b-setup:HIDDEN = YES
           b-run:HIDDEN   = YES 
           b-height-p     = b-setup:HEIGHT-P
           b-width-p      = 28 + FONT-TABLE:GET-TEXT-WIDTH-P 
                                    ("Setup", FRAME F-Main:FONT).
         
    /* If the buttons cannot be stacked then assume they are in line. */
    IF p-height-p > (2 * b-height-p) 
    THEN l_stacked = YES.
    ELSE l_stacked = NO.
    
    /* Resize the combo-box object. */
    ASSIGN R-Report:HIDDEN   = yes 
           R-Report:WIDTH-P  = MAX (1, p-width-p 
                                      - (b-width-p * (IF l_stacked THEN 1 ELSE 2))
                                      - i_margin)
           R-Report:X        = i_margin
           R-Report:Y        = i_box-Y + i_margin + 
                               (IF l_stacked THEN b-height-p / 2 ELSE 0)
           NO-ERROR.
                          
    /* Keep the combo-box hidden if it is too small. */
    IF (p-height-p + i_margin >= R-Report:HEIGHT-P) AND
       (R-Report:WIDTH-P > R-Report:HEIGHT-P * 2) 
    THEN ASSIGN R-Report:HIDDEN = NO NO-ERROR.
    
    /* If the combo-box is hidden, then widen the buttons to fill the area. */
    IF R-Report:HIDDEN 
    THEN b-width-p = IF l_stacked THEN p-width-p ELSE (p-width-p / 2).
      
    /* Make sure the buttons will actually fit. */
    ASSIGN b-run:X          = i_margin + p-width-p - b-width-p
           b-run:Y          = IF NOT l_stacked THEN i_box-Y + i_margin
                              ELSE i_box-Y + i_margin + b-height-p
           b-setup:X        = IF l_stacked THEN b-run:X 
                              ELSE b-run:X - b-width-p
           b-setup:Y        = i_box-Y + i_margin
           b-run:WIDTH-P    = b-width-p 
           b-run:HEIGHT-P   = b-height-p
           b-setup:WIDTH-P  = b-width-p 
           b-setup:HEIGHT-P = b-height-p
           NO-ERROR.
    /* View the objects. */
    IF b-height-p > p-height-p THEN
        ASSIGN b-setup:HIDDEN = YES
               b-run:HIDDEN = YES.
    ELSE   ASSIGN b-run:HIDDEN = no
           b-setup:HIDDEN = no.

     
    /* If defined, set the Bounding Rectangle size. */
    &IF "{&Box-Rectangle}" ne "" &THEN
      ASSIGN l_box-hidden              = {&Box-Rectangle}:HIDDEN 
             {&Box-Rectangle}:HIDDEN   = yes
             {&Box-Rectangle}:X        = 0
             {&Box-Rectangle}:Y        = i_box-y
             {&Box-Rectangle}:WIDTH-P  = i_width-p - i_border-h 
             /* If the contained combo-box and buttons are much shorter than
                the frame, set the height of the rectangle based on these objects. */
             {&Box-Rectangle}:HEIGHT-P = MIN (b-run:Y + b-run:HEIGHT-P + i_margin,
                                              i_height-p - i_border-v) 
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
           FRAME {&FRAME-NAME}:HEIGHT-P         = MAX(i_height-p, b-height-p + i_margin)
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Receive ADM State-Changed requests.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
    /* No States Supported at this time. */
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


