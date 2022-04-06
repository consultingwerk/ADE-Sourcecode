&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: layoutdialog.w

  Description: 

  Run Syntax:
        RUN ry/obj/layoutdialog.w
            (INPUT  pobject_type_code,
             OUTPUT pryc_smartobject_obj, OUTPUT pryc_smartobject_filename, OUTPUT pOKPressed).
    
  Input Parameters:
        pobject_type_code : Object Type object code indicating the type of
                            layout templates to list.
  Output Parameters:
        pryc_smartobject_obj       : Object Obj indicates the id of the selected template layout.
        pryc_smartobject_filename  : Object filename corresponding to the layout selected.
        pOKPressed                 : This logical parameter indicates whether a template was 
                                     selected or not.

  Author: Manoj Khani

  Created: 8/16/2001
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Preprocessor Definitions ---                                         */
&SCOPED-DEFINE List_Delimiter   CHR(3)

/* Local Variable Definitions ---                                       */

DEFINE INPUT  PARAMETER pobject_type_code         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pryc_smartobject_obj      AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pryc_smartobject_filename AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pOKPressed                AS LOGICAL   NO-UNDO INITIAL NO.

DEFINE TEMP-TABLE ttLayoutTemplate NO-UNDO
    FIELD LayoutName        LIKE ryc_smartobject.object_filename
    FIELD LayoutDesc        LIKE ryc_smartobject.object_description   
    FIELD LayoutObject_Obj  LIKE ryc_smartobject.smartobject_obj
    FIELD LayoutImageHandle AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS layout-list Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS layout-list 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14 TOOLTIP "Cancels selection of a template".

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14 TOOLTIP "Help file".

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14 TOOLTIP "Completes the selction of the template".

DEFINE VARIABLE layout-list AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 51 BY 8.57 TOOLTIP "Selection List" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     layout-list AT ROW 2.19 COL 2 NO-LABEL
     Btn_OK AT ROW 2.19 COL 55
     Btn_Cancel AT ROW 3.38 COL 55
     Btn_Help AT ROW 5.29 COL 55
     "Choose a layout" VIEW-AS TEXT
          SIZE 29 BY .71 AT ROW 1.24 COL 2
     SPACE(39.79) SKIP(9.23)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Layout Dialog"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Layout Dialog */
DO:
    /* Find the layout based on what the user selected in our list. */
    FIND ttLayoutTemplate WHERE ttLayoutTemplate.LayoutDesc = layout-list:SCREEN-VALUE NO-ERROR.
    IF NOT AVAILABLE ttLayoutTemplate THEN LEAVE.

    /* We found a valid layout. Now it's ok to say the user pressed OK. */
    ASSIGN pOKPressed = YES.
    
    /* Set the parameter return values. */
    ASSIGN pryc_smartobject_obj      = ttLayoutTemplate.LayoutObject_obj
           pryc_smartobject_filename = ttLayoutTemplate.LayoutName.

/*
    MESSAGE "You have choosen the template:":U   SKIP
            ttLayoutTemplate.LayoutDesc   SKIP
            "with Object-ID:" ttLayoutTemplate.LayoutObject_obj
            VIEW-AS ALERT-BOX INFORMATION.
*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Layout Dialog */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */

  APPLY "END-ERROR":U TO SELF.  


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame /* Cancel */
OR CANCEL OF FRAME {&FRAME-NAME}
DO:
    ASSIGN pOKPressed = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
DO: /* Call Help Function (or a simple message). */
    MESSAGE "Help for File: {&FILE-NAME} ":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* In case layout descriptions have commas, change the delimiter to a
   non-printable character. */
ASSIGN layout-list:DELIMITER = {&List_Delimiter}.

/* Now enable the Layout Dialog interface and wait for the exit condition.*/
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
    RUN createLayoutRecords.
    RUN buildList.
    RUN enable_UI.
    WAIT-FOR GO OF FRAME {&FRAME-NAME} .
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildList Dialog-Frame 
PROCEDURE buildList PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH ttLayoutTemplate:
        layout-list:ADD-LAST(ttLayoutTemplate.LayoutDesc).
    END.                
   
    ASSIGN layout-list = layout-list:ENTRY(1).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createImage Dialog-Frame 
PROCEDURE createImage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createImages Dialog-Frame 
PROCEDURE createImages :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
   
DEFINE VARIABLE hImage      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBaseImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBaseText   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImageFrame AS HANDLE     NO-UNDO.
DEFINE VARIABLE vImageFrame AS HANDLE     NO-UNDO.
DEFINE VARIABLE iMaxImages  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iImageCount AS INTEGER    NO-UNDO.
DEFINE VARIABLE iRowCount       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iImageRow       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iImagesPerRow   AS INTEGER    NO-UNDO.

iMaxImages = 6.
iImagesPerRow = 2.

DO WITH FRAME Image-Frame:

 /*   iRowCount = 2.
    DO iImageCount = 2 TO iMaxImages:

        /*Increasing virtual widht */
        IF (iImageCount = 1) AND (iImageCount = 3) THEN
            vImageFrame:VIRTUAL-WIDTH = 200 NO-ERROR.
   */


    /* Increase the image frame's virtual width and height so it will get scroll bars
       and the user can scroll the list of layout images. */
    
    hImageFrame = FRAME Image-Frame:HANDLE.

/*    hBaseImage = layout-image:HANDLE.
    hBaseText  = image-desc:HANDLE.
    iImageRow  = hBaseImage:ROW.
  */
   /* DEFINE TEMP-TABLE ttLayoutTemplate NO-UNDO
    FIELD LayoutDesc        AS CHAR
    FIELD LayoutDesc        AS CHAR
    FIELD LayoutObjectID    AS INTEGER
    FIELD LayoutImageHandle AS HANDLE.*/

    iRowCount = 3.
    DO iImageCount = 1 TO iMaxImages:

        /* If we are starting the 4th row, increase the virtual frame height. */
        IF (iRowCount = 3) AND (iImageCount = 9) THEN
            hImageFrame:VIRTUAL-HEIGHT = 320 NO-ERROR.
        iImageCount = iImageCount + 1.

        CREATE IMAGE hImage ASSIGN
            FRAME       = FRAME Image-Frame:HANDLE
            HEIGHT      = hBaseImage:HEIGHT
            WIDTH       = hBaseImage:WIDTH
            ROW         = iImageRow
            COLUMN      = hBaseImage:COLUMN + hBaseText:WIDTH + (hBaseText:WIDTH / 2)
            VISIBLE     = YES
            SENSITIVE   = YES 
            SELECTABLE  = YES.

        hImage:LOAD-IMAGE("C:\PROGRESS\WRK\images\findord.jpg":u) NO-ERROR.
        
        /* Make the new image the base image so other images are created to it's left. */
        ASSIGN hBaseImage = hImage.

        /* Are we finished with this row? If so, need a new row value for images. */
        IF (iImageCount = iMaxImages) THEN
        /* Finished the row. Increase the row count. */
        iRowCount = iRowCount + 1.
  
        END.
END.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createLayoutRecords Dialog-Frame 
PROCEDURE createLayoutRecords :
/*------------------------------------------------------------------------------
  Purpose:     Find layout records which are available for this type of object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER lb_ryc_smartobject FOR ryc_smartobject.
    
    /* Find object ID of the type code that was passed in. */
    FIND gsc_object_type NO-LOCK
         WHERE gsc_object_type.object_type_code = pobject_type_code
         NO-ERROR.
    
    IF NOT AVAILABLE gsc_object_type THEN RETURN.

    /* Find all layouts which are available for this type of object. */

    FOR EACH lb_ryc_smartobject NO-LOCK
       WHERE lb_ryc_smartobject.object_type_obj       = gsc_object_type.object_type_obj 
         AND lb_ryc_smartobject.template_smartobject  = YES:

        /* Store valid layout in our temp-table */

        CREATE ttLayoutTemplate.
        ASSIGN ttLayoutTemplate.LayoutDesc       = lb_ryc_smartobject.object_description
               ttLayoutTemplate.LayoutName       = lb_ryc_smartobject.object_filename
               ttLayoutTemplate.LayoutObject_Obj = lb_ryc_smartobject.smartobject_obj.
    END.

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY layout-list 
      WITH FRAME Dialog-Frame.
  ENABLE layout-list Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

