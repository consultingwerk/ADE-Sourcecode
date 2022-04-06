&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"Version 9 SmartFolder object"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: folder.w - ADM SmartFolder program

  Description: Version 9 SmartFolder object

  Parameters: <none>
  Modified:      July 8, 1998

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

  &GLOB ADMClass folder

/* Local Variable Definitions ---                                       */

  
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
FolderLabels,FolderTabWidth,FolderFont

  &IF "{&xcTranslatableProperties}":U NE "":U &THEN
    &GLOB xcTranslatableProperties {&xcTranslatableProperties},
  &ENDIF
  &GLOB xcTranslatableProperties {&xcTranslatableProperties}~
FolderLabels

&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/folderd.w
&ENDIF

&SCOP max-labels 32
&SCOP tab-height 21
 
  /***********************  DEFINITIONS  *************************/
  /* minmum tab height */
  DEFINE VARIABLE xiTabMinHeightPxl    AS INT    NO-UNDO INIT 21.
  /* minimum width */ 
  DEFINE VARIABLE xiTabMinWidthPxl     AS INT    NO-UNDO INIT 12.
 
  /* label margin for variable width tab */
  DEFINE VARIABLE xiLblMarginPxl       AS INT    NO-UNDO INIT 10.
  /* Space for 'empty' variable width tab */
  DEFINE VARIABLE xiEmptyPxl           AS INT    NO-UNDO INIT 32.

  DEFINE VARIABLE giPrevPage           AS INTEGER NO-UNDO.
  DEFINE VARIABLE giTabHeightPxl       AS INTEGER NO-UNDO.  
  DEFINE VARIABLE number-of-pages      AS INTEGER NO-UNDO.
  DEFINE VARIABLE tab-type             AS INT NO-UNDO. /* 1,2 */
  DEFINE VARIABLE container-hdl        AS HANDLE NO-UNDO.
  DEFINE VARIABLE page-label           AS HANDLE EXTENT {&max-labels} NO-UNDO.
  
  DEFINE VARIABLE giColor3dFace      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE giColor3dHighlight AS INTEGER    NO-UNDO.
  DEFINE VARIABLE giColor3dShadow    AS INTEGER    NO-UNDO.


  DEFINE VARIABLE hLeftVertical        AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE hRightVertical1      AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE hRightVertical2      AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE hLeftDot             AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE hRightDot            AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE hTopHorizontal       AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE hFiller              AS HANDLE EXTENT {&max-labels} NO-UNDO.

  DEFINE VARIABLE page-enabled         AS LOGICAL EXTENT {&max-labels} NO-UNDO.
  
  DEF VAR width-tab-values    AS INT INIT [110,72] EXTENT 2 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFolder
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Page-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Folder-Frm

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Rect-Bottom Rect-Left Rect-Main Rect-Right ~
Rect-Top 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderFont C-Win 
FUNCTION getFolderFont RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderLabels C-Win 
FUNCTION getFolderLabels RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderTabType C-Win 
FUNCTION getFolderTabType RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderTabWidth C-Win 
FUNCTION getFolderTabWidth RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerCol C-Win 
FUNCTION getInnerCol RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerHeight C-Win 
FUNCTION getInnerHeight RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerRow C-Win 
FUNCTION getInnerRow RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerWidth C-Win 
FUNCTION getInnerWidth RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageTarget C-Win 
FUNCTION getPageTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageTargetEvents C-Win 
FUNCTION getPageTargetEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderFont C-Win 
FUNCTION setFolderFont RETURNS LOGICAL
  ( pdFont AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderLabels C-Win 
FUNCTION setFolderLabels RETURNS LOGICAL
  ( pcLabels AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderTabType C-Win 
FUNCTION setFolderTabType RETURNS LOGICAL
  ( piTabType AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderTabWidth C-Win 
FUNCTION setFolderTabWidth RETURNS LOGICAL
  ( pdWidth AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPageTarget C-Win 
FUNCTION setPageTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE Rect-Bottom
     EDGE-PIXELS 0  
     SIZE 33.6 BY .14
     BGCOLOR 7 .

DEFINE RECTANGLE Rect-Left
     EDGE-PIXELS 0  
     SIZE .6 BY 4.24
     BGCOLOR 15 .

DEFINE RECTANGLE Rect-Main
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.8 BY 4.33
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE Rect-Right
     EDGE-PIXELS 0  
     SIZE .6 BY 4.33
     BGCOLOR 7 .

DEFINE RECTANGLE Rect-Top
     EDGE-PIXELS 0  
     SIZE 33.6 BY .14
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Folder-Frm
     Rect-Bottom AT ROW 6 COL 1
     Rect-Left AT ROW 1.76 COL 1.2
     Rect-Main AT ROW 2.05 COL 3.2
     Rect-Right AT ROW 1.86 COL 34.2
     Rect-Top AT ROW 1.71 COL 1.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 204.8 BY 34.33.


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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW C-Win ASSIGN
         HEIGHT             = 7.76
         WIDTH              = 50.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Folder-Frm
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME Folder-Frm:HIDDEN           = TRUE
       FRAME Folder-Frm:HEIGHT           = 7.76
       FRAME Folder-Frm:WIDTH            = 50.4.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME Folder-Frm
/* Query rebuild information for FRAME Folder-Frm
     _Query            is NOT OPENED
*/  /* FRAME Folder-Frm */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

  /* Folder-specific properties which are in the property temp-table. */
  &GLOB xpFolderLabels       
  &GLOB xpFolderTabType      
  &GLOB xpPageTarget         
  &GLOB xpPageTargetEvents   
  &GLOB xpFolderFont       
  &GLOB xpFolderTabWidth       
  
  /* Now include the other props files which will start the ADMProps def. */
  {src/adm2/visprop.i}

  /* and then we add our folder property defs to that... */
  ghADMProps:ADD-NEW-FIELD('FolderLabels':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FolderTabType':U, 'INT':U, 0, ?, 1).
  ghADMProps:ADD-NEW-FIELD('PageTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('PageTargetEvents':U, 'CHAR':U, 0, ?, 'changeFolderPage,deleteFolderPage':U).    
  ghADMProps:ADD-NEW-FIELD('FolderFont':U, 'INT':U, 0, ?, -1).
  ghADMProps:ADD-NEW-FIELD('FolderTabWidth':U, 'DEC':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FolderTabHeight':U, 'DEC':U, 0, ?, ?).
  
  /* Now include our parent class file for visual objects. */
  {src/adm2/visual.i}

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFolderPage C-Win 
PROCEDURE changeFolderPage :
/* -----------------------------------------------------------
      Purpose:    Changes the folder visualization when a new page is
                  selected (from the folder or elsewhere). 
      Parameters:  <none>
      Notes: 
    -------------------------------------------------------------*/   
    DEFINE VARIABLE sts      AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE page#    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cUIBMode AS CHARACTER NO-UNDO.

    IF VALID-HANDLE (container-hdl) THEN 
      {get CurrentPage page# container-hdl}.
    ELSE IF giPrevPage <> 0 THEN
    DO: 
      {get UIBmode cUIBMode}.      
      IF cUIBmode = 'Design':U THEN
      DO:
        page# = giPrevPage.
        giPrevPage = 0.
      END.
    END.
 
    RUN ShowCurrentPage(page#).
     
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

    DEFINE VARIABLE sts        AS LOG  NO-UNDO.
    DEFINE VARIABLE ifont      AS INT  NO-UNDO.
    DEFINE VARIABLE dWidth     AS DEC  NO-UNDO.
    DEFINE VARIABLE iTabWidth  AS INT  NO-UNDO.
    DEFINE VARIABLE iLblHeight AS INT  NO-UNDO.
    DEFINE VARIABLE iLblWidth  AS INT  NO-UNDO.
    DEFINE VARIABLE iX         AS INT  NO-UNDO.
    DEFINE VARIABLE lFixed     AS LOG  NO-UNDO.
    DEFINE VARIABLE iLoop      AS INT  NO-UNDO.
    DEFINE VARIABLE cStripLbl  AS CHAR NO-UNDO.  
    
    {get FolderTabWidth dWidth}.
    {get FolderFont iFont}.

    ASSIGN
      lFixed     = dWidth <> 0 AND dWidth <> ?
      iFont      = IF iFont < 0 THEN ? ELSE iFont
      iLblHeight = FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(iFont)
      iLblWidth  = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(p-page-label,iFont)
                      /* don't calculate underscore & */
                    - (IF  INDEX(p-page-label,'&':U)  > 0
                       AND INDEX(p-page-label,'&&':U) = 0 
                       THEN FONT-TABLE:GET-TEXT-WIDTH-PIXELS('&':U,iFont)
                       ELSE 0)
      iTabWidth  = (IF NOT lFixed 
                    THEN iLblWidth + (xiLblMarginPxl  * 2)
                    ELSE MAX(dWidth * SESSION:PIXELS-PER-COLUMN,xiTabMinWidthPxl - 2)) 
      iX         = IF p-page# = 1 THEN 2
                   ELSE IF lFixed THEN ((p-page# - 1) * iTabWidth) + 2
                   ELSE 0.
    
     /* If variable width and not page 1 find the pos of the previous tab */
     IF iX = 0 THEN
     DO iLoop = p-page# - 1 TO 1 BY -1:
       IF VALID-HANDLE(hRightVertical2[iLoop]) THEN 
       DO:
         iX = iX + hRightVertical2[iLoop]:X 
                 + hRightVertical2[iloop]:WIDTH-PIXEL.
         LEAVE. 
       END.
       ELSE /* add space for empty tabs */ 
         iX = iX + xiEmptyPxl.
     END. /* if ix = 0 then do iloop =  */
    
   CREATE RECTANGLE hLeftVertical[p-page#]
     ASSIGN 
        FRAME             = FRAME {&FRAME-NAME}:HANDLE
        X                 = iX  
        Y                 = 4   
        WIDTH-PIXEL       = 1 
        HEIGHT-PIXEL      = giTabHeightPxl - 4
        PRIVATE-DATA      = "Tab-Folder":U
        EDGE-PIXELS       = 0
        FILLED            = YES
        BGCOLOR           = giColor3dHighlight
        /*CONVERT-3D-COLORS = YES*/
        SENSITIVE         = YES
       TRIGGERS:      
        ON MOUSE-SELECT-CLICK  
           PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
       END TRIGGERS.         
    
    CREATE RECTANGLE hFiller[p-page#]
        ASSIGN 
           FRAME             = FRAME {&FRAME-NAME}:HANDLE
           X                 = iX + 1 
           Y                 = 3   
           GRAPHIC-EDGE      = FALSE
           WIDTH-PIXEL       = iTabWidth - 3 
           HEIGHT-PIXEL      = giTabHeightPxl - 3
           PRIVATE-DATA      = "Tab-Folder":U
           EDGE-PIXELS       = 0
           FILLED            = YES
           BGCOLOR           = giColor3DFace
          /* CONVERT-3D-COLORS = YES  */
           SENSITIVE         = YES
         TRIGGERS:      
           ON MOUSE-SELECT-CLICK  
              PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
         END TRIGGERS.         


   CREATE RECTANGLE hLeftDot[p-page#]
     ASSIGN 
        FRAME             = FRAME {&FRAME-NAME}:HANDLE
        X                 = iX + 1 
        Y                 = 3   
        GRAPHIC-EDGE      = FALSE
        WIDTH-PIXEL       = 1
        HEIGHT-PIXEL      = 1
        PRIVATE-DATA      = "Tab-Folder":U
        EDGE-PIXELS       = 0 
        BGCOLOR           = giColor3dHighlight
        FILLED            = YES
        /*CONVERT-3D-COLORS = YES*/
        SENSITIVE         = YES
       TRIGGERS:      
         ON MOUSE-SELECT-CLICK  
            PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
       END TRIGGERS.         
    
   CREATE RECTANGLE hTopHorizontal[p-page#]
     ASSIGN 
        FRAME             = FRAME {&FRAME-NAME}:HANDLE
        X                 = iX + 2 
        Y                 = 2   
        GRAPHIC-EDGE      = FALSE
        WIDTH-PIXEL       = iTabWidth - 4 
        HEIGHT-PIXEL      = 1
        PRIVATE-DATA      = "Tab-Folder":U
        EDGE-PIXELS       = 0 
        BGCOLOR           = giColor3dHighlight
        FILLED            = YES
        /*CONVERT-3D-COLORS = YES*/
        SENSITIVE         = YES
      TRIGGERS:      
        ON MOUSE-SELECT-CLICK  
           PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
      END TRIGGERS.         

   CREATE RECTANGLE hRightVertical1[p-page#]
      ASSIGN 
        FRAME             = FRAME {&FRAME-NAME}:HANDLE
        X                 = iX + iTabWidth - 2
        Y                 = 4   
        WIDTH-PIXEL       = 1 
        HEIGHT-PIXEL      = giTabHeightPxl - 4
        PRIVATE-DATA      = "Tab-Folder":U
        EDGE-PIXELS       = 0        
        BGCOLOR           = giColor3dShadow
        FILLED            = YES
        /*CONVERT-3D-COLORS = YES*/
        SENSITIVE         = YES
      TRIGGERS:      
          ON MOUSE-SELECT-CLICK  
              PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
      END TRIGGERS.         
    
   CREATE RECTANGLE hRightVertical2[p-page#]
      ASSIGN 
         FRAME             = FRAME {&FRAME-NAME}:HANDLE
         X                 = iX + iTabWidth - 1
         Y                 = 4   
         WIDTH-PIXEL       = 1 
         HEIGHT-PIXEL      = giTabHeightPxl - 4
         PRIVATE-DATA      = "Tab-Folder":U
         EDGE-PIXELS       = 0
         FILLED            = YES
         BGCOLOR           = 0
         /*CONVERT-3D-COLORS = YES*/
         SENSITIVE         = YES
       TRIGGERS:      
          ON MOUSE-SELECT-CLICK  
             PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
       END TRIGGERS.         

   CREATE RECTANGLE hRightDot[p-page#]
      ASSIGN 
         FRAME             = FRAME {&FRAME-NAME}:HANDLE
         X                 = iX + iTabWidth - 2 
         Y                 = 3   
         GRAPHIC-EDGE      = FALSE
         EDGE-PIXEL        = 0
         WIDTH-PIXEL       = 1
         HEIGHT-PIXEL      = 1
         PRIVATE-DATA      = "Tab-Folder":U
         BGCOLOR           = 0
         FILLED            = YES
         
        /*CONVERT-3D-COLORS = YES*/
         SENSITIVE         = YES
      TRIGGERS:      
        ON MOUSE-SELECT-CLICK  
             PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
      END TRIGGERS.         
   
    CREATE TEXT page-label[p-page#]
       ASSIGN 
         FRAME         = FRAME {&FRAME-NAME}:HANDLE
          /* keep it nicely 2 pxls above the folder top line */
          Y            = hLeftVertical[p-page#]:Y + hLeftVertical[p-page#]:HEIGHT-PIXEL 
                         - iLblHeight
                         - 2 
          /* center label, but make sure X is 2 pxls left of tab:X 
             (visible when the tab to its left is selected) */
          X            = MAX(hLeftVertical[p-page#]:X + 2,
                         hLeftVertical[p-page#]:X + hTopHorizontal[p-page#]:WIDTH-PIXEL  + 2
                         - ((hTopHorizontal[p-page#]:WIDTH-PIXEL + 2 - iLblWidth) / 2)
                            - iLblWidth
                           ) 
          /* Never wider than 4 pxls less than tab (sam as top rectangle) */
          WIDTH-PIXEL  = MIN(hTopHorizontal[p-page#]:WIDTH-PIXEL,ilblWidth)
          HEIGHT-PIXEL = iLblHeight
          FORMAT       = "X(255)":U
          SENSITIVE    = YES 
          FONT         = iFont
          HIDDEN       = YES
          SCREEN-VALUE = p-page-label
          PRIVATE-DATA = "Tab-Folder":U    
         TRIGGERS:      
            ON MOUSE-SELECT-CLICK 
               PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
         END TRIGGERS.
      
    ASSIGN      
      /*
      sts = image-hdl[p-page#]:LOAD-IMAGE("adeicon/lefttab":U,
                                           0,
                                           0,
                                           iTabWidth - 2,
                                           giTabHeightPxl - 2)

      sts = image-hdl2[p-page#]:LOAD-IMAGE("adeicon/righttab":U)
      */
      sts = page-label[p-page#]:MOVE-TO-TOP()
      /*
      sts = hLeftVertical[p-page#]:MOVE-TO-TOP() 
      sts = hLeftDot[p-page#]:MOVE-TO-TOP() 
      sts = hTopHorizontal[p-page#]:MOVE-TO-TOP() 
      sts = hRightVertical1[p-page#]:MOVE-TO-TOP() 
      sts = hRightVertical2[p-page#]:MOVE-TO-TOP() 
      sts = hRightDot[p-page#]:MOVE-TO-TOP() 
      sts = hHideError[p-page#]:MOVE-TO-TOP() 
      */
      page-enabled[p-page#]     = yes
     
      page-label[p-page#]:HIDDEN = NO NO-ERROR.   /*  or it may come up hidden. */
  
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-folder-page C-Win 
PROCEDURE create-folder-page :
/* -----------------------------------------------------------
      Purpose:     Create a new tab label after initialization.
      Parameters:  INPUT new page number, new tab label
      Notes:       
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-new-label  AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i             AS INTEGER NO-UNDO.
    DEFINE VARIABLE num-labels    AS INTEGER NO-UNDO. 
    DEFINE VARIABLE labels        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE new-labels    AS CHARACTER NO-UNDO INIT "".
   
    {get FolderLabels labels}.   
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
    
    {set FolderLabels new-labels}.
    RUN initializeFolder.
        
    RETURN.
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteFolderPage C-Win 
PROCEDURE deleteFolderPage :
/* -----------------------------------------------------------
      Purpose:     Remove the tab for a page
      Parameters:  INPUT page number to delete
      Notes:       
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.

    DEFINE VARIABLE iCnt    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cLabels AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lActive AS LOGICAL    NO-UNDO.

    {get FolderLabels cLabels}.

    IF VALID-HANDLE (page-label[p-page#]) THEN /* Make sure this page exists */
        DELETE WIDGET page-label[p-page#].

    IF VALID-HANDLE (hLeftVertical[p-page#]) THEN  
        DELETE WIDGET hLeftVertical[p-page#].

    IF VALID-HANDLE (hLeftDot[p-page#]) THEN  
        DELETE WIDGET hLeftDot[p-page#].

    IF VALID-HANDLE (hTopHorizontal[p-page#]) THEN  
        DELETE WIDGET hTopHorizontal[p-page#].

    IF VALID-HANDLE (hRightVertical1[p-page#]) THEN  
        DELETE WIDGET hRightVertical1[p-page#].

    IF VALID-HANDLE (hRightVertical2[p-page#]) THEN  
        DELETE WIDGET hRightVertical2[p-page#].

    IF VALID-HANDLE (hFiller[p-page#]) THEN  
        DELETE WIDGET hFiller[p-page#].
    
    IF giPrevPage = p-page# THEN
        ASSIGN giPrevPage = 0.

    /* Remove the label from the FOLDER-LABELS attribute list */

    IF NUM-ENTRIES(cLabels,'|':U) >= p-page# 
    THEN DO:
        ASSIGN ENTRY(p-page#,cLabels,'|':U) = '':U.
    
        do-blk:
        DO iCnt = 1 TO NUM-ENTRIES(cLabels,'|':U):
            IF ENTRY(iCnt,cLabels,'|':U) NE '':U 
            THEN DO:
                ASSIGN lActive = TRUE.
                LEAVE do-blk.
            END.
        END.
        IF NOT lActive THEN
            ASSIGN cLabels = '':U.
    END.

    {set FolderLabels cLabels}.

    RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFolderPage C-Win 
PROCEDURE disableFolderPage :
/* -----------------------------------------------------------
      Purpose:     Disable and gray out the tab for a page
      Parameters:  INPUT page number to disable
      Notes:       
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.

    ASSIGN page-enabled[p-page#] = no
           page-label[p-page#]:FGCOLOR = 7.  /* Gray out the text */
    RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  HIDE FRAME Folder-Frm.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFolderPage C-Win 
PROCEDURE enableFolderPage :
/* -----------------------------------------------------------
      Purpose:     Enable the tab for a page
      Parameters:  INPUT page number to enable
      Notes:       
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.

    ASSIGN page-enabled[p-page#] = yes
           page-label[p-page#]:FGCOLOR = ?.  /* Restore the text */
    RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeFolder C-Win 
PROCEDURE initializeFolder :
/* -----------------------------------------------------------
      Purpose:     Creates the dynamic images for a tab or notebook
                   folder.
      Parameters:  <none>
      Notes:       Run automatically as part of folder startup.
    -------------------------------------------------------------*/   
 
    DEFINE VARIABLE folder-labels      AS CHARACTER NO-UNDO.  
    DEFINE VARIABLE char-hdl           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i                  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iLblHeight         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iFont              AS INTEGER   NO-UNDO.
    DEFINE VARIABLE temp-hdl           AS HANDLE    NO-UNDO.             
    DEFINE VARIABLE del-hdl            AS HANDLE    NO-UNDO.             
    DEFINE VARIABLE rebuild            AS LOGICAL   NO-UNDO INIT no.
    DEFINE VARIABLE hContainer         AS HANDLE    NO-UNDO.
    DEFINE VARIABLE lHidden            AS LOGICAL    NO-UNDO.
    
    {get Color3dFace giColor3dFace}.
    {get Color3dHighlight giColor3dHighlight}.
    {get Color3dShadow giColor3dShadow}.
    
    {get FolderFont   iFont}.
    {get FolderLabels folder-labels}.
    {get FolderTabType tab-type}.
    
    ASSIGN
      iFont           = IF iFont < 0 THEN ? ELSE iFont
      iLblHeight      = FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(iFont)
      giTabHeightPxl  = MAX(xiTabMinHeightPxl,iLblHeight + 8)  
      number-of-pages = NUM-ENTRIES(folder-labels,'|':U)
      rect-top:BGCOLOR IN FRAME {&FRAME-NAME}    = giColor3dHighlight  
      rect-left:BGCOLOR IN FRAME {&FRAME-NAME}   = giColor3dHighlight  
      rect-right:BGCOLOR IN FRAME {&FRAME-NAME}  = giColor3dShadow  
      rect-bottom:BGCOLOR IN FRAME {&FRAME-NAME} = giColor3dShadow  .

    /* Get the folder's CONTAINER for triggers.
       Note that in design mode the CONTAINER may not be specified;
       the code takes this into account. Also the broker will not
       be available in design mode. */
    ASSIGN char-hdl = dynamic-function('linkHandles':U, 'Container-Source':U)
           container-hdl = WIDGET-HANDLE(char-hdl).
      
      /* Rebuilding an existing folder */
    temp-hdl = FRAME {&FRAME-NAME}:HANDLE.
    temp-hdl = temp-hdl:FIRST-CHILD.    /* Field group */
    temp-hdl = temp-hdl:FIRST-CHILD.   /* First dynamic widget */
    DO WHILE VALID-HANDLE(temp-hdl):  
      del-hdl = temp-hdl.
      temp-hdl = temp-hdl:NEXT-SIBLING.
      IF del-hdl:PRIVATE-DATA = "Tab-Folder":U THEN DELETE WIDGET del-hdl.  
    END.
   
    {get ContainerSource hContainer}.
    IF VALID-HANDLE(hContainer) THEN
    DO:
     /* if the frame is hidden by its container, we unhide it now. as 
       there's a performance overhead of doing this after all widgets
       have been created. */  
      {get ObjectHidden lHidden hContainer}.
    END.

    IF lHidden THEN 
      FRAME {&FRAME-NAME}:HIDDEN = FALSE.   
    ELSE 
      FRAME {&FRAME-NAME}:HIDDEN = TRUE.
    
    DO i = 1 TO number-of-pages:       
       IF ENTRY(i,folder-labels,'|':U) NE "":U THEN /*Allow skipping of pos'ns*/
            RUN create-folder-label (i, ENTRY(i, folder-labels,'|':U)).
    END. 
 
    RUN resizeObject (FRAME {&FRAME-NAME}:HEIGHT, FRAME {&FRAME-NAME}:WIDTH).

    IF FRAME {&FRAME-NAME}:HIDDEN THEN
       FRAME {&FRAME-NAME}:HIDDEN = FALSE.   
    FRAME {&FRAME-NAME}:MOVE-TO-BOTTOM().

    RUN changeFolderPage.
    RETURN.
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject C-Win 
PROCEDURE initializeObject :
/* -----------------------------------------------------------
      Purpose:     Local version of the initialize method which starts up
                   the folder object. This runs initializeFolder with
                   the folder attributes.
      Parameters:  <none>
      Notes:       The folder initialization is suppressed in character mode.
    -------------------------------------------------------------*/   
&IF "{&WINDOW-SYSTEM}":U <> "TTY":U &THEN
  RUN initializeFolder.
  RUN SUPER.
&ENDIF
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
     RUN selectPage IN container-hdl (INPUT p-page#).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject C-Win 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Sets the size of the rectangles which make up the folder
               "image" whenever it is resized.
  Parameters:  INPUT height and width.
  Notes:       Run automatically when the folder is initialized or resized.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER p-width  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE cLabels    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumLabels AS INTEGER    NO-UNDO.

  {get FolderLabels cLabels}.
  ASSIGN iNumLabels = NUM-ENTRIES(cLabels,"|").

&IF "{&WINDOW-SYSTEM}":U <> "TTY":U &THEN  
  /* This is the minimum height needed for all the tabs and rectangles to exist: */
  p-Height = MAX((giTabHeightPxl / SESSION:PIXELS-PER-ROW) + 0.2,p-height) .

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN Rect-Main:HIDDEN = yes
             Rect-Top:HIDDEN = yes
             Rect-Bottom:HIDDEN = yes
             Rect-Left:HIDDEN = yes
             Rect-Right:HIDDEN = yes 
             Rect-Main:HEIGHT-P = 1
             Rect-Main:WIDTH-P  = 1
             Rect-Top:WIDTH-P  = 1
             Rect-Bottom:ROW    = FRAME {&FRAME-NAME}:ROW
             Rect-Bottom:WIDTH-P  = 1
             Rect-Left:HEIGHT-P = 1
             Rect-Right:COL    = FRAME {&FRAME-NAME}:COL
             Rect-Right:HEIGHT-P = 1
   
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
         /* May not have been set yet, or (Bug# 20010914-001) it may be blank or
            it may have been deleted. */
         FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS  = 
             IF (number-of-pages = 0 OR ENTRY(iNumLabels,cLabels,'|':U) EQ '':U)    
             THEN FRAME {&FRAME-NAME}:WIDTH-PIXELS
             ELSE MAX(FRAME {&FRAME-NAME}:WIDTH-PIXELS,
                     hRightVertical2[iNumLabels]:X 
                     + hRightVertical2[iNumLabels]:WIDTH-PIXEL + 2).

.
            
  ASSIGN Rect-Main:X               = 0
         Rect-Main:Y               = giTabHeightPxl 
         Rect-Main:WIDTH-PIXELS    = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS
         Rect-Main:HEIGHT-PIXELS   = FRAME {&FRAME-NAME}:HEIGHT-PIXELS 
                                     - giTabHeightPxl 
         Rect-Top:X                = 1
         Rect-Top:Y                = giTabHeightPxl
         Rect-Top:WIDTH-PIXELS     = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS 
                                     - 2
         Rect-Top:HEIGHT-PIXELS    = 1
         Rect-Bottom:X             = 1
         Rect-Bottom:Y             = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 2 
         Rect-Bottom:HEIGHT-PIXELS = 1
         Rect-Bottom:WIDTH-PIXELS  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS 
                                     - 2
         Rect-Left:X               = 0
         Rect-Left:Y               = giTabHeightPxl
         Rect-Left:WIDTH-PIXELS    = 1
         Rect-Left:HEIGHT-PIXELS   = FRAME {&FRAME-NAME}:HEIGHT-PIXELS 
                                     - (giTabHeightPxl + 1)
         Rect-Right:X              = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS 
                                     - 2
         Rect-Right:Y              = giTabHeightPxl + 1
         Rect-Right:WIDTH-PIXELS   = 1         
         Rect-Right:HEIGHT-PIXELS  = FRAME {&FRAME-NAME}:HEIGHT-PIXELS
                                     - (giTabHeightPxl + 2)
         Rect-Main:HIDDEN   = no
         Rect-Top:HIDDEN    = no
         Rect-Bottom:HIDDEN = no
         Rect-Left:HIDDEN   = no
         Rect-Right:HIDDEN  = no.
         Rect-left:MOVE-TO-TOP().
         Rect-Top:MOVE-TO-TOP().
  END.
          
  RETURN.
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showCurrentPage C-Win 
PROCEDURE showCurrentPage :
/*------------------------------------------------------------------------------
  Purpose:     Shows the tab for "current" folder page
  Parameters:  page# - (INTEGER) The current page.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER page# AS INTEGER NO-UNDO.
 
  DEFINE VARIABLE sts     AS LOGICAL NO-UNDO.
  

  IF page# = giPrevPage THEN
    RETURN.
  
  IF giPrevPage <> 0 AND giPrevPage <= {&max-labels}   
  AND VALID-HANDLE(page-label[giPrevPage]) THEN
  DO:
    /* Check that the label really is UP... This relieves us from having 
       to reset giprevpage in delete and create etc...  */
    IF hTopHorizontal[giPrevPage]:Y  = 0 THEN
     ASSIGN 
      page-label[giPrevPage]:Y           = page-label[giPrevPage]:Y + 1
      hLeftVertical[giPrevPage]:Y        = hLeftVertical[giPrevPage]:Y + 2 
      hLeftVertical[giPrevPage]:X        = hLeftVertical[giPrevPage]:X + 2 
      hLeftVertical[giPrevPage]:HEIGHT-P = hLeftVertical[giPrevPage]:HEIGHT-P - 2
      hLeftDot[giPrevPage]:X             = hLeftDot[giPrevPage]:X + 2
      hLeftDot[giPrevPage]:Y             = hLeftDot[giPrevPage]:Y + 2
      hTopHorizontal[giPrevPage]:Y       = 2
      hTopHorizontal[giPrevPage]:WIDTH-P = hTopHorizontal[giPrevPage]:WIDTH-P - 4 
      hTopHorizontal[giPrevPage]:X       = hTopHorizontal[giPrevPage]:X + 2      
      hFiller[giPrevPage]:X              = hFiller[giPrevPage]:X + 2 
      hFiller[giPrevPage]:WIDTH-P        = hFiller[giPrevPage]:WIDTH-P - 4 
      hFiller[giPrevPage]:Y              = hFiller[giPrevPage]:Y + 2 
      hFiller[giPrevPage]:HEIGHT-P       = hFiller[giPrevPage]:HEIGHT-P - 3 
      hRightDot[giPrevPage]:Y            = hRightDot[giPrevPage]:Y + 2
      hRightDot[giPrevPage]:X            = hRightDot[giPrevPage]:X - 2
      hRightVertical1[giPrevPage]:Y        = hRightVertical1[giPrevPage]:Y + 2 
      hRightVertical1[giPrevPage]:X        = hRightVertical1[giPrevPage]:X - 2 
      hRightVertical1[giPrevPage]:HEIGHT-P = hRightVertical1[giPrevPage]:HEIGHT-P - 3
      hRightVertical2[giPrevPage]:Y        = hRightVertical2[giPrevPage]:Y + 2 
      hRightVertical2[giPrevPage]:X        = hRightVertical2[giPrevPage]:X - 2 
      hRightVertical2[giPrevPage]:HEIGHT-P = hRightVertical2[giPrevPage]:HEIGHT-P - 3
  
    NO-ERROR.
  END.

  IF page# > 0 AND page# <= {&max-labels} 
  AND VALID-HANDLE (page-label[page#]) THEN 
  DO:
    /* Check that the label really is down... */
    IF hTopHorizontal[Page#]:Y  = 2 THEN

     ASSIGN 
   /* raise text (not as much as tab) */
     page-label[page#]:Y = page-label[page#]:Y - 1
     sts = hFiller[page#]:MOVE-TO-TOP()
     sts = hLeftDot[page#]:MOVE-TO-TOP()
     sts = hLeftVertical[page#]:MOVE-TO-TOP() 
     sts = hRightDot[page#]:MOVE-TO-TOP()
     sts = hRightVertical1[page#]:MOVE-TO-TOP()
     sts = hRightVertical2[page#]:MOVE-TO-TOP()
      
   
      hFiller[page#]:X              = hFiller[page#]:X - 2 
      hFiller[page#]:Y              = hFiller[page#]:Y - 2 
      hFiller[page#]:WIDTH-P        = hFiller[page#]:WIDTH-P + 4 
      hFiller[page#]:HEIGHT-P       = hFiller[page#]:HEIGHT-P + 3 

      hLeftVertical[page#]:Y        = hLeftVertical[page#]:Y - 2 
      hLeftVertical[page#]:X        = hLeftVertical[page#]:X - 2 
      hLeftVertical[page#]:HEIGHT-P = hLeftVertical[page#]:HEIGHT-P + 2
      hLeftDot[page#]:X             = hLeftDot[page#]:X - 2
      hLeftDot[page#]:Y             = hLeftDot[page#]:Y - 2
      hTopHorizontal[page#]:Y       = 0
      hTopHorizontal[page#]:WIDTH-P = hTopHorizontal[page#]:WIDTH-P + 4 
      hTopHorizontal[page#]:X       = hTopHorizontal[page#]:X - 2      
      hRightDot[page#]:Y            = hRightDot[page#]:Y - 2
      hRightDot[page#]:X            = hRightDot[page#]:X + 2
      hRightVertical1[page#]:Y        = hRightVertical1[page#]:Y - 2 
      hRightVertical1[page#]:X        = hRightVertical1[page#]:X + 2 
      hRightVertical1[page#]:HEIGHT-P = hRightVertical1[page#]:HEIGHT-P + 3
      hRightVertical2[page#]:Y        = hRightVertical2[page#]:Y - 2 
      hRightVertical2[page#]:X        = hRightVertical2[page#]:X + 2 
      hRightVertical2[page#]:HEIGHT-P = hRightVertical2[page#]:HEIGHT-P + 3
    NO-ERROR.
  END.

  giPrevPage = page#.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderFont C-Win 
FUNCTION getFolderFont RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  get Font of folder tab.
    Notes:    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dFont AS INT NO-UNDO.
  {get FolderFont dFont}.
  RETURN dFont.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderLabels C-Win 
FUNCTION getFolderLabels RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the folder labels property.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLabels AS CHARACTER NO-UNDO.
  {get FolderLabels cLabels}.
  RETURN cLabels.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderTabType C-Win 
FUNCTION getFolderTabType RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the folder tab type, 1 or 2
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iType AS INTEGER NO-UNDO.
  {get FolderTabType iType}.
  RETURN iType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderTabWidth C-Win 
FUNCTION getFolderTabWidth RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  get width of folder tab.
    Notes:  If 0 or ? use labelwidth  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dWidth AS DEC    NO-UNDO.
  {get FolderTabWidth dWidth}.
  RETURN dWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerCol C-Win 
FUNCTION getInnerCol RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return inner Col relative to container  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (2 / SESSION:PIXELS-PER-COL)
         + FRAME {&FRAME-NAME}:COL.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerHeight C-Win 
FUNCTION getInnerHeight RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return inner width   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN (FRAME {&FRAME-NAME}:HEIGHT-P 
          - (4 + giTabHeightPxl)) /  SESSION:PIXELS-PER-ROW. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerRow C-Win 
FUNCTION getInnerRow RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return inner Row relative to container 
    Notes:  
------------------------------------------------------------------------------*/
   RETURN   /*((IF lUpperTabs 
             THEN (iTabHeightPixels * iPanelTotal)
                   + {&TAB-PIXEL-OFFSET}
             ELSE 0) */
            (giTabHeightPxl + 2)  
            / SESSION:PIXELS-PER-ROW
            + FRAME {&FRAME-NAME}:ROW.
           
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerWidth C-Win 
FUNCTION getInnerWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return inner width   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN (FRAME {&FRAME-NAME}:WIDTH-P - 4) / SESSION:PIXELS-PER-COL.    
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageTarget C-Win 
FUNCTION getPageTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the folder's "PageTarget", normally its container.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get PageTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageTargetEvents C-Win 
FUNCTION getPageTargetEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the events the folder expects to receive from
            its PageTarget (normally its container).
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get PageTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderFont C-Win 
FUNCTION setFolderFont RETURNS LOGICAL
  ( pdFont AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose: Set Font to use for folder.
    Notes: 
------------------------------------------------------------------------------*/

  {set FolderFont pdFont}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderLabels C-Win 
FUNCTION setFolderLabels RETURNS LOGICAL
  ( pcLabels AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets folder labels.
    Notes:  Basic folder property.
------------------------------------------------------------------------------*/

  {set FolderLabels pcLabels}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderTabType C-Win 
FUNCTION setFolderTabType RETURNS LOGICAL
  ( piTabType AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the folder tab type to 1 or 2
    Notes: Deprecated, kept for backward compatibility.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dWidth AS DECIMAL NO-UNDO.
  
  IF piTabType NE 1 AND piTabType NE 2 THEN
    RETURN FALSE.   
  
  /** We do NOT convert to old width   
  ELSE DO:
     /* convert to new width property */
     dWidth = (IF piTabType = 1 THEN 110 ELSE 72) / SESSION:PIXELS-PER-COLUMN.
     {set FolderTabWidth dWidth}.
     {set FolderTabType  piTabType}.
     RETURN TRUE.
  END.
  **/
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderTabWidth C-Win 
FUNCTION setFolderTabWidth RETURNS LOGICAL
  ( pdWidth AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Set width to use for folder tab.
    Notes:  set to 0 or ? to use labelwidth.
------------------------------------------------------------------------------*/

  {set FolderTabWidth pdWidth}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPageTarget C-Win 
FUNCTION setPageTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the PageTarget object handle, normally the folder's container.
    Notes:  
------------------------------------------------------------------------------*/

  {set PageTarget pcTarget}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

