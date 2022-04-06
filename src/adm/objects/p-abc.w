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

  File: p-abc.w

  Description: 
      A Filter-Source that has a button for every letter of the
      alphabet, and which sends requests to:
          RUN set-attribute-list IN <Filter-Target> ('FILTER-VALUE = <letter>':U)
      The Filter-Source will also automatically dispatch 'open-query'
      to the Filter-Target if the attribute "dispatch-open-query" is
      set to 'yes'.
               
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Authors: Rick Kuzyk and Wm.T.Wood
  Created: November 1995
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

/* ADM Preprocessor Defintions ---                                      */
&Scoped-define adm-attribute-dlg adm/support/abcd.w

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartPanel

&Scoped-define ADM-SUPPORTED-LINKS Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 b-a b-b b-c b-d b-e b-f b-g b-h b-i ~
b-j b-k b-l b-m b-n b-o b-p b-q b-r b-s b-t b-u b-v b-w b-x b-y b-z b-all 

/* Custom List Definitions                                              */
/* Box-Rectangle,List-2,List-3,List-4,List-5,List-6                     */
&Scoped-define Box-Rectangle RECT-1 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON b-a 
     LABEL "A" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-all 
     LABEL "*" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-b 
     LABEL "B" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-c 
     LABEL "C" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-d 
     LABEL "D" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-e 
     LABEL "E" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-f 
     LABEL "F" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-g 
     LABEL "G" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-h 
     LABEL "H" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-i 
     LABEL "I" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-j 
     LABEL "J" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-k 
     LABEL "K" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-l 
     LABEL "L" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-m 
     LABEL "M" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-n 
     LABEL "N" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-o 
     LABEL "O" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-p 
     LABEL "P" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-q 
     LABEL "Q" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-r 
     LABEL "R" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-s 
     LABEL "S" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-t 
     LABEL "T" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-u 
     LABEL "U" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-v 
     LABEL "V" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-w 
     LABEL "W" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-x 
     LABEL "X" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-y 
     LABEL "Y" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE BUTTON b-z 
     LABEL "Z" 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 1.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     b-a AT ROW 1.12 COL 1.43
     b-b AT ROW 1.12 COL 2.86
     b-c AT ROW 1.12 COL 4.29
     b-d AT ROW 1.12 COL 5.72
     b-e AT ROW 1.12 COL 7.14
     b-f AT ROW 1.12 COL 8.57
     b-g AT ROW 1.12 COL 10
     b-h AT ROW 1.12 COL 11.43
     b-i AT ROW 1.12 COL 12.86
     b-j AT ROW 1.12 COL 14.29
     b-k AT ROW 1.12 COL 15.72
     b-l AT ROW 1.12 COL 17.14
     b-m AT ROW 1.12 COL 18.57
     b-n AT ROW 1.12 COL 20
     b-o AT ROW 1.12 COL 21.43
     b-p AT ROW 1.12 COL 22.86
     b-q AT ROW 1.12 COL 24.29
     b-r AT ROW 1.12 COL 25.72
     b-s AT ROW 1.12 COL 27.14
     b-t AT ROW 1.12 COL 28.57
     b-u AT ROW 1.12 COL 30
     b-v AT ROW 1.12 COL 31.43
     b-w AT ROW 1.12 COL 32.86
     b-x AT ROW 1.12 COL 34.29
     b-y AT ROW 1.12 COL 35.72
     b-z AT ROW 1.12 COL 37.14
     b-all AT ROW 1.12 COL 38.57
     RECT-1 AT ROW 1 COL 1
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
         HEIGHT             = 1.42
         WIDTH              = 40.72.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW s-object
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

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
{src/adm/method/panelsiz.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-a
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-a s-object
ON CHOOSE OF b-a IN FRAME F-Main /* A */
OR CHOOSE OF b-all, b-b, b-c, b-d, b-e, b-f, b-g, b-h, b-i, b-j, b-k, b-l, b-m, 
             b-n, b-o, b-p, b-q, b-r, b-s, b-t, b-u, b-v, b-w, b-x, b-y, b-z
DO:
  DEF VAR c-list   AS CHAR NO-UNDO.
  DEF VAR h_target AS HANDLE NO-UNDO.
  DEF VAR i        AS INTEGER NO-UNDO.
  DEF VAR iCnt     AS INTEGER NO-UNDO.
  
  /* 
   * Get all the FILTER-TARGETS - Tell them to set their filter value.
   */
  RUN get-link-handle IN adm-broker-hdl 
             (THIS-PROCEDURE, 'Filter-Target':U, OUTPUT c-list).
  iCnt = NUM-ENTRIES (c-list).
  IF iCnt = 0 
  THEN MESSAGE "No Filter-Target exists for this object."  VIEW-AS ALERT-BOX WARNING.
  ELSE 
    DO i = 1 TO iCnt:
      h_target = WIDGET-HANDLE (ENTRY(i,c-list)).
      IF VALID-HANDLE (h_target) THEN DO:
        RUN set-attribute-list IN h_target 
               ('Filter-Value =':U + (IF SELF:LABEL eq '*':U THEN '':U ELSE SELF:LABEL)).
        /* 
         * Only open the query in the Filter-Target if necessary. 
         */
        RUN get-attribute IN THIS-PROCEDURE ('Dispatch-Open-Query':U).
        IF RETURN-VALUE eq 'yes':U THEN RUN dispatch IN h_target ('open-query':U).

      END.
    END.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK s-object 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN  
    /* Code needed to test this object (when run directly from the UIB) */       
    RUN dispatch IN THIS-PROCEDURE ('initialize').        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
    /* Set default values for Parameters */
    RUN get-attribute ('Button-Font':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Button-Font = 4':U).
    RUN get-attribute ('Dispatch-Open-Query':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Dispatch-Open-Query = yes':U).
    RUN get-attribute ('Edge-Pixels':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Edge-Pixels = 2':U).
    RUN get-attribute ('Margin-Pixels':U).
    IF RETURN-VALUE eq ? THEN RUN set-attribute-list ('Margin-Pixels = 5':U).
        
    /* Make sure the object has been sized correctly. (This will process
       edge-pixels and margin-pixels. */
    RUN set-size IN THIS-PROCEDURE 
        (FRAME {&FRAME-NAME}:HEIGHT, FRAME {&FRAME-NAME}:WIDTH).
        
    /* Mark this as having been drawn. */
    RUN set-attribute-list ('Drawn-in-UIB=yes':U).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-button-font s-object 
PROCEDURE use-button-font :
/*------------------------------------------------------------------------------
  Purpose:  Get the current value of 'button-font' and set the font of all
            buttons to this value.   
  Parameters:  p_attr-value -- the new Button Font
  Notes: The desired font is checked against Button b-a. If b-a has the desired
         font then no change is made.    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_attr-value AS CHAR NO-UNDO.
  
  DEFINE VAR iFont AS INTEGER NO-UNDO INITIAL ?.
  DEFINE VAR h     AS WIDGET NO-UNDO.
 
  /* Convert attribute string to an INTEGER font value. */
  iFont = IF p_attr-value eq "?" THEN ? ELSE INTEGER(p_attr-value) NO-ERROR.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* Is the correct font set already? */
    IF iFont ne b-a:FONT THEN DO:
      /* Walk the widget tree and set the font of all buttons in this frame . */
      ASSIGN h = FRAME {&FRAME-NAME}:CURRENT-ITERATION
             h = h:FIRST-CHILD.
      DO WHILE VALID-HANDLE (h):
        IF h:TYPE eq 'BUTTON':U THEN h:FONT = iFont.
        h = h:NEXT-SIBLING.
      END. /* DO WHILE...h... */
    END. /* IF iFont ne b-a:FONT... */
  END. /* DO WITH FRAME... */
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


