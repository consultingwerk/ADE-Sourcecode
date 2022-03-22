&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

  File: folder.w - ADM SmartFolder program

  Description:

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

    DEFINE VARIABLE        number-of-pages    AS INTEGER   NO-UNDO.

/* Dialog program to run to set runtime attributes - Remove value if none. */
&SCOP adm-attribute-dlg adm/support/folderd.w

/* +++ This is the list of attributes whose values are to be returned
   by get-attribute-list, that is, those whose values are part of the
   definition of the object instance and should be passed to init-object
   by the UIB-generated code in admcreate-objects. */
&IF DEFINED(adm-attribute-list) = 0 &THEN
&SCOP adm-attribute-list FOLDER-LABELS,FOLDER-TAB-TYPE
&ENDIF

&SCOP max-labels 20
&SCOP tab-height 25

  /***********************  DEFINITIONS  *************************/
                           
  DEFINE VARIABLE up-image             AS HANDLE NO-UNDO.  
  DEFINE VARIABLE tab-type          AS INT NO-UNDO. /* 1,2 */
  DEFINE VARIABLE container-hdl        AS HANDLE NO-UNDO.
  DEFINE VARIABLE char-hdl             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE page-label           AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE image-hdl            AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE page-enabled         AS LOGICAL EXTENT {&max-labels} NO-UNDO.

  DEF VAR width-tab-values    AS INT INIT [110,72] EXTENT 2 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFolder

&Scoped-define ADM-SUPPORTED-LINKS Page-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Folder-Frm

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Rect-Main Rect-Top Rect-Left Rect-Right ~
Rect-Bottom 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE Rect-Bottom
     EDGE-PIXELS 0  
     SIZE 33.57 BY .12
     BGCOLOR 7 .

DEFINE RECTANGLE Rect-Left
     EDGE-PIXELS 0  
     SIZE .57 BY 4.23
     BGCOLOR 15 .

DEFINE RECTANGLE Rect-Main
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 33.72 BY 4.31
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE Rect-Right
     EDGE-PIXELS 0  
     SIZE .57 BY 4.35
     BGCOLOR 7 .

DEFINE RECTANGLE Rect-Top
     EDGE-PIXELS 0  
     SIZE 33.57 BY .12
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Folder-Frm
     Rect-Main AT ROW 1.69 COL 1
     Rect-Top AT ROW 1.73 COL 1.14
     Rect-Left AT ROW 1.77 COL 1.14
     Rect-Right AT ROW 1.85 COL 34.14
     Rect-Bottom AT ROW 6 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 49.14 BY 6.69.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFolder
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
  CREATE WINDOW C-Win ASSIGN
         HEIGHT             = 6.69
         WIDTH              = 49.14.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Folder-Frm
   NOT-VISIBLE Default                                                  */
ASSIGN 
       FRAME Folder-Frm:HIDDEN           = TRUE
       FRAME Folder-Frm:HEIGHT           = 6.69
       FRAME Folder-Frm:WIDTH            = 49.14.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME Folder-Frm
/* Query rebuild information for FRAME Folder-Frm
     _Query            is NOT OPENED
*/  /* FRAME Folder-Frm */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Best default for GUI applications is...                              */       
PAUSE 0 BEFORE-HIDE.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change-folder-page C-Win 
PROCEDURE change-folder-page :
/* -----------------------------------------------------------
      Purpose:    Changes the folder visualization when a new page is
                  selected (from the folder or elsewhere). 
      Parameters:  <none>
      Notes: 
    -------------------------------------------------------------*/   

    DEFINE VARIABLE sts     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE page#   AS INTEGER NO-UNDO.
   
    IF VALID-HANDLE (container-hdl) THEN DO:
        RUN get-attribute IN container-hdl ('CURRENT-PAGE':U).
        ASSIGN page# = INT(RETURN-VALUE).  
    END.
    ELSE ASSIGN page# = 1.    /* For design mode. */
    
      IF page# > 0 AND page# <= {&max-labels} AND
          VALID-HANDLE (page-label[page#]) THEN
      DO: 
        ASSIGN
        up-image:X      =     page-label[page#]:X -  9
        up-image:Y      =     page-label[page#]:Y -  4 
        up-image:HIDDEN =     no
        sts             =     up-image:MOVE-TO-TOP().
      END.
 
    RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-folder-label C-Win 
PROCEDURE create-folder-label :
/* -----------------------------------------------------------
      Purpose:     Defines an image for a single tab and sets its label.
      Parameters:  INPUT page number, label
      Notes:       
    -------------------------------------------------------------*/   
     
    DEFINE INPUT PARAMETER p-page#        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-page-label   AS CHARACTER NO-UNDO.

    DEFINE VARIABLE sts                     AS LOG NO-UNDO.
  
      CREATE IMAGE image-hdl[p-page#]
      ASSIGN 
      FRAME             = FRAME {&FRAME-NAME}:HANDLE
      X                 = (p-page# - 1) * width-tab-values[tab-type] 
      Y                 = 2   
      WIDTH-PIXEL       = width-tab-values[tab-type]
      HEIGHT-PIXEL      = {&tab-height}
      PRIVATE-DATA      = "Tab-Folder":U
      SENSITIVE         = YES
      TRIGGERS:      
        ON MOUSE-SELECT-CLICK 
           PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
      END TRIGGERS.         

                        
      CREATE TEXT page-label[p-page#]
      ASSIGN 
      FRAME             = FRAME {&FRAME-NAME}:HANDLE
      Y                 = image-hdl[p-page#]:Y + 2     
      X                 = image-hdl[p-page#]:X + 9
      WIDTH-PIXEL       = image-hdl[p-page#]:WIDTH-PIXEL - 18
      HEIGHT-PIXEL      = image-hdl[p-page#]:HEIGHT-PIXEL - 4
      FORMAT            = "X(13)":U
      SENSITIVE         = YES 
      FONT              = IF tab-type = 1 THEN ? ELSE 4 /* smaller for narrow */
      BGCOLOR           = 8                 /* Light gray to match the image */
      SCREEN-VALUE      = p-page-label
      PRIVATE-DATA      = "Tab-Folder":U
      TRIGGERS:      
        ON MOUSE-SELECT-CLICK 
           PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
      END TRIGGERS.
      
      ASSIGN      
      sts = image-hdl[p-page#]:LOAD-IMAGE("adeicon/ts-dn":U + 
                STRING(width-tab-values[tab-type])).
      sts = image-hdl[p-page#]:MOVE-TO-TOP().
      sts = page-label[p-page#]:MOVE-TO-TOP().

    ASSIGN page-enabled[p-page#] = yes
           image-hdl[p-page#]:HIDDEN = no     /* Set HIDDEN off explicitly */
           page-label[p-page#]:HIDDEN = no.   /*  or it may come up hidden. */
  
    RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-folder-page C-Win 
PROCEDURE create-folder-page :
/* -----------------------------------------------------------
      Purpose:     Create a new tab label after initialization.
      Parameters:  INPUT new page number, new tab label
      Notes:       Usage: RUN get-link-handle IN adm-broker-hdl
                      (THIS-PROCEDURE, 'PAGE-SOURCE',OUTPUT page-hdl).
                          RUN create-folder-page 
                             IN WIDGET-HANDLE(page-hdl) (<page,label>)
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-new-label  AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i             AS INTEGER NO-UNDO.
    DEFINE VARIABLE num-labels    AS INTEGER NO-UNDO. 
    DEFINE VARIABLE labels        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE new-labels    AS CHARACTER NO-UNDO INIT "".
   
    RUN get-attribute ('FOLDER-LABELS':U).
    ASSIGN labels = RETURN-VALUE.   
    IF labels = ? THEN labels = "". 
    
    num-labels = NUM-ENTRIES(labels,'|':U).
    /* If the new label is on a page that already exists, replace it. */
    IF p-page# <= num-labels THEN
    DO i = 1 TO num-labels:
        new-labels = new-labels + 
            IF i = p-page# THEN p-new-label
            ELSE ENTRY(i, labels, '|':U).
        IF i < num-labels THEN new-labels = new-labels + '|':U.
    END.
    ELSE DO:
        /* If this is higher than the current labels, insert the
           right number of elimiters to make room for it. */
        new-labels = labels.
        DO i = 1 TO p-page# - num-labels - IF num-labels = 0 THEN 1 ELSE 0:
            new-labels = new-labels + '|':U. 
        END.
        new-labels = new-labels + p-new-label.   
    END.                      
    
    RUN set-attribute-list IN THIS-PROCEDURE 
        ('FOLDER-LABELS = ':U + new-labels).
    RUN initialize-folder.
        
    RETURN.
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-folder-page C-Win 
PROCEDURE delete-folder-page :
/* -----------------------------------------------------------
      Purpose:     Remove the tab for a page
      Parameters:  INPUT page number to delete
      Notes:       Usage: RUN get-link-handle IN adm-broker-hdl
                      (THIS-PROCEDURE, 'PAGE-SOURCE',OUTPUT page-hdl).
                          RUN delete-folder-page 
                             IN WIDGET-HANDLE(page-hdl) (<page-number>)
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.

    DEFINE VARIABLE i       AS INTEGER NO-UNDO.
    DEFINE VARIABLE pos1    AS INTEGER NO-UNDO INIT 0.
    DEFINE VARIABLE pos2    AS INTEGER NO-UNDO. 
    DEFINE VARIABLE labels  AS CHARACTER NO-UNDO.
   
    RUN get-attribute ('FOLDER-LABELS':U).
    ASSIGN labels = RETURN-VALUE.

    IF VALID-HANDLE (page-label[p-page#]) THEN /* Make sure this page exists */
        DELETE WIDGET page-label[p-page#].
    IF VALID-HANDLE (image-hdl[p-page#]) THEN  
        DELETE WIDGET image-hdl[p-page#].  
                          
    /* Remove the label from the FOLDER-LABELS attribute list */
    DO i = 1 TO p-page# - 1:                                      
        pos1 = INDEX(labels,'|':U, pos1 + 1).
    END.
    pos2 = INDEX(labels,'|':U, pos1 + 1).
    labels = IF pos2 ne 0 THEN SUBSTR(labels, 1, pos1, "CHARACTER":U) +
                                  SUBSTR(labels, pos2, -1, "CHARACTER":U)       
                          ELSE SUBSTR(labels, 1, pos1 - 1, "CHARACTER":U).
    RUN set-attribute-list IN THIS-PROCEDURE 
         ('FOLDER-LABELS = ':U + labels).

    RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable-folder-page C-Win 
PROCEDURE disable-folder-page :
/* -----------------------------------------------------------
      Purpose:     Disable and gray out the tab for a page
      Parameters:  INPUT page number to disable
      Notes:       Usage: RUN get-link-handle IN adm-broker-hdl
                      (THIS-PROCEDURE, 'PAGE-SOURCE',OUTPUT page-hdl).
                          RUN disable-folder-page 
                             IN WIDGET-HANDLE(page-hdl) (<page-number>)
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.

    ASSIGN page-enabled[p-page#] = no
           page-label[p-page#]:FGCOLOR = 7.  /* Gray out the text */
    RETURN. 
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
  HIDE FRAME Folder-Frm.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable-folder-page C-Win 
PROCEDURE enable-folder-page :
/* -----------------------------------------------------------
      Purpose:     Enable the tab for a page
      Parameters:  INPUT page number to enable
      Notes:       Usage: RUN get-link-handle IN adm-broker-hdl
                      (THIS-PROCEDURE, 'PAGE-SOURCE',OUTPUT page-hdl).
                          RUN enable-folder-page 
                             IN WIDGET-HANDLE(page-hdl) (<page-number>)
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.

    ASSIGN page-enabled[p-page#] = yes
           page-label[p-page#]:FGCOLOR = ?.  /* Restore the text */
    RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize-folder C-Win 
PROCEDURE initialize-folder :
/* -----------------------------------------------------------
      Purpose:     Creates the dynamic images for a tab or notebook
                   folder.
      Parameters:  <none>
      Notes:       Run automatically as part of folder startup.
    -------------------------------------------------------------*/   

    DEFINE VARIABLE        folder-labels      AS CHARACTER NO-UNDO.  

    DEFINE VARIABLE        i                  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE        temp-hdl           AS HANDLE    NO-UNDO.             
    DEFINE VARIABLE        del-hdl            AS HANDLE    NO-UNDO.             
    DEFINE VARIABLE        rebuild            AS LOGICAL   NO-UNDO INIT no.
    DEFINE VARIABLE        sts                AS LOGICAL   NO-UNDO.
   
    RUN get-attribute IN THIS-PROCEDURE ('FOLDER-LABELS':U).
    ASSIGN folder-labels = IF RETURN-VALUE = ? THEN "":U
                           ELSE RETURN-VALUE.

    RUN get-attribute IN THIS-PROCEDURE ('FOLDER-TAB-TYPE':U).
    ASSIGN tab-type = IF RETURN-VALUE = ? THEN 1 ELSE INT(RETURN-VALUE).

    ASSIGN 
    number-of-pages =   NUM-ENTRIES(folder-labels,'|':U).
    RUN set-size (FRAME {&FRAME-NAME}:HEIGHT, FRAME {&FRAME-NAME}:WIDTH).
    
    /* Get the folder's CONTAINER for triggers.
       Note that in design mode the CONTAINER may not be specified;
       the code takes this into account. Also the broker will not
       be available in design mode. */
    IF valid-handle(adm-broker-hdl) THEN DO:
        RUN get-link-handle IN adm-broker-hdl
           (INPUT THIS-PROCEDURE, INPUT 'CONTAINER-SOURCE':U, OUTPUT char-hdl).
        ASSIGN container-hdl = WIDGET-HANDLE(char-hdl).
    END.
      
    IF VALID-HANDLE(up-image) THEN DO:  /* Rebuilding an existing folder */
       temp-hdl = FRAME {&FRAME-NAME}:HANDLE.
       temp-hdl = temp-hdl:FIRST-CHILD.    /* Field group */
       temp-hdl = temp-hdl:FIRST-CHILD.   /* First dynamic widget */
       DO WHILE VALID-HANDLE(temp-hdl):  
          del-hdl = temp-hdl.
          temp-hdl = temp-hdl:NEXT-SIBLING.
          IF del-hdl:PRIVATE-DATA = "Tab-Folder":U THEN DELETE WIDGET del-hdl.  
       END.
    END.

    CREATE IMAGE up-image
    ASSIGN 
    FRAME             = FRAME {&FRAME-NAME}:HANDLE
    X                 = 0
    Y                 = 0
    WIDTH-PIXEL       = width-tab-values[tab-type]
    HEIGHT-PIXEL      = {&tab-height} + 4
    PRIVATE-DATA      = "Tab-Folder":U
    SENSITIVE         = YES
    HIDDEN            = NO.  /* Do this explicitly or it's sometimes hidden. */

    ASSIGN
    sts            =   up-image:LOAD-IMAGE("adeicon/ts-up":U +
         STRING(width-tab-values[tab-type])).
      
    DO i = 1 TO number-of-pages:       
       IF ENTRY(i,folder-labels,'|':U) NE "":U THEN /*Allow skipping of pos'ns*/
            RUN create-folder-label (i, ENTRY(i, folder-labels,'|':U)).
    END. 
    
    VIEW FRAME {&FRAME-NAME}.  
    sts = FRAME {&FRAME-NAME}:MOVE-TO-BOTTOM().
    RUN change-folder-page.
     
    RETURN.
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE label-trigger C-Win 
PROCEDURE label-trigger :
/*------------------------------------------------------------------------------
  Purpose:     This procedure serves as the trigger code for each tab label.
  Parameters:  INPUT page number
  Notes:       Used internally only in the definition of tab labels.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-page# AS INTEGER NO-UNDO.
  
  IF VALID-HANDLE(container-hdl) AND page-enabled[p-page#] THEN 
       RUN select-page IN container-hdl (INPUT p-page#).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Win 
PROCEDURE local-initialize :
/* -----------------------------------------------------------
      Purpose:     Local version of the initialize method which starts up
                   the folder object. This runs initialize-folder with
                   the folder attributes.
      Parameters:  <none>
      Notes:       The folder initialization is suppressed in character mode.
    -------------------------------------------------------------*/   
&IF "{&WINDOW-SYSTEM}":U <> "TTY":U &THEN
  RUN initialize-folder.
  RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-size C-Win 
PROCEDURE set-size :
/*------------------------------------------------------------------------------
  Purpose:     Sets the size of the rectangles which make up the folder
               "image" whenever it is resized.
  Parameters:  INPUT height and width.
  Notes:       Run automatically when the folder is initialized or resized.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER p-width  AS DECIMAL NO-UNDO.
  
&IF "{&WINDOW-SYSTEM}":U <> "TTY":U &THEN  
  DEFINE VARIABLE sts AS LOGICAL.
 
  /* This is the minimum height needed for all the tabs and rectangles to exist: */
  IF p-height < 1.35 THEN p-height = 1.35.
  
  DO WITH FRAME {&FRAME-NAME}:
     
      ASSIGN Rect-Main:HIDDEN = yes
             Rect-Top:HIDDEN = yes
             Rect-Bottom:HIDDEN = yes
             Rect-Left:HIDDEN = yes
             Rect-Right:HIDDEN = yes 
             Rect-Main:HEIGHT = 1
             Rect-Main:WIDTH  = 1
             Rect-Top:WIDTH  = 1
             Rect-Bottom:ROW    = FRAME {&FRAME-NAME}:ROW
             Rect-Bottom:WIDTH  = 1
             Rect-Left:HEIGHT = 1
             Rect-Right:COL    = FRAME {&FRAME-NAME}:COL
             Rect-Right:HEIGHT = 1
   
   /* Adjust the virtual height to match the new height, to avoid
            scrollbars - note that the frame can't be made non-scrollable
            because that may cause errors *during* a resize. 
            Also adjust the virtual width to match the new width or the
            required width of the tab images, whichever is greater;
            in the latter case scrollbars will appear. */
         FRAME {&FRAME-NAME}:HEIGHT = p-height
         FRAME {&FRAME-NAME}:WIDTH  = p-width
         FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-PIXELS = 
             FRAME {&FRAME-NAME}:HEIGHT-PIXELS
         FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS  = 
             IF (tab-type = 0)    /* May not have been set yet. */
             OR (number-of-pages <= 
                 (FRAME {&FRAME-NAME}:WIDTH-PIXELS 
                   / width-tab-values[tab-type] ))
            THEN FRAME {&FRAME-NAME}:WIDTH-PIXELS
            ELSE number-of-pages * width-tab-values[tab-type] + 2.
            
  ASSIGN Rect-Main:X               = 0
         Rect-Main:Y               = {&tab-height} 
         Rect-Main:WIDTH-PIXELS    = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS
         Rect-Main:HEIGHT-PIXELS   = FRAME {&FRAME-NAME}:HEIGHT-PIXELS 
                                     - {&tab-height} 
         Rect-Top:X                = 1
         Rect-Top:Y                = {&tab-height} + 1
         Rect-Top:WIDTH-PIXELS     = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS 
                                     - 3
         Rect-Top:HEIGHT-PIXELS    = 3
         Rect-Bottom:X             = 1
         Rect-Bottom:Y             = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 4 
         Rect-Bottom:HEIGHT-PIXELS = 3
         Rect-Bottom:WIDTH-PIXELS  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS 
                                     - 2
         Rect-Left:X               = 1
         Rect-Left:Y               = {&tab-height} + 1
         Rect-Left:WIDTH-PIXELS    = 3
         Rect-Left:HEIGHT-PIXELS   = FRAME {&FRAME-NAME}:HEIGHT-PIXELS 
                                     - {&tab-height} - 2
         Rect-Right:X              = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS 
                                     - 4
         Rect-Right:Y              = {&tab-height} + 4
         Rect-Right:WIDTH-PIXELS   = 3         Rect-Right:HEIGHT-PIXELS  = FRAME {&FRAME-NAME}:HEIGHT-PIXELS
                                     - {&tab-height} - 5
         Rect-Main:HIDDEN   = no
         Rect-Top:HIDDEN    = no
         Rect-Bottom:HIDDEN = no
         Rect-Left:HIDDEN   = no
         Rect-Right:HIDDEN  = no. 
  END.
          
  RETURN.
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-current-page C-Win 
PROCEDURE show-current-page :
/*------------------------------------------------------------------------------
  Purpose:     Shows the tab for "current" folder page
  Parameters:  page# - (INTEGER) The current page.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER page# AS INTEGER NO-UNDO.

  DEFINE VARIABLE sts     AS LOGICAL NO-UNDO.

  IF page# > 0 AND page# <= {&max-labels} AND
      VALID-HANDLE (page-label[page#]) 
  THEN ASSIGN
          up-image:X      =     page-label[page#]:X -  9
          up-image:Y      =     page-label[page#]:Y -  4 
          up-image:HIDDEN =     no
          sts             =     up-image:MOVE-TO-TOP().
  /* If there are no tabs at all leave the up-image viewed for appearance.
     Otherwise if the user has selected page 0, hide the up-image in order
     to visually deselect all pages. */
  ELSE IF number-of-pages > 0 THEN
       ASSIGN up-image:HIDDEN = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


