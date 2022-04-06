&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------
    Library     : afpropdlg.i

    Purpose     : Property Dialog Include

    Syntax      : af/sup2/afpropdlg.i
                  copied from SmartPak3 src/adm2/support/PropDlg.i

    Description : Common routines for Property Dialogs

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE PRODUCT_NAME SmartPak
&GLOBAL-DEFINE PRODUCT_AUTHOR M.J. Carroll   (michaelcarroll@freeuk.com)
&GLOBAL-DEFINE PRODUCT_VERSION 3.05
&GLOBAL-DEFINE PRODUCT_ID {&PRODUCT_NAME} {&PRODUCT_VERSION}

&IF "{&ADM-VERSION}" = "ADM2.0"
&THEN
    &SCOPED-DEFINE FNDFILE-FILTER *.bmp|*.ico|*.*
&ELSE
    &SCOPED-DEFINE FNDFILE-FILTER Bitmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico
&ENDIF

&GLOBAL-DEFINE TEST-BITMAP "adeicon/showcursor.bmp"

DEFINE TEMP-TABLE wProperty NO-UNDO
    FIELD wIndex  AS INTEGER
    FIELD wHandle AS HANDLE
    FIELD wValue  AS CHARACTER
    INDEX wIndex IS PRIMARY wIndex.

DEFINE VARIABLE vVerify AS LOGICAL NO-UNDO.

DEFINE VARIABLE FrameChanged AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-ENUMERATE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ENUMERATE Method-Library 
FUNCTION ENUMERATE RETURNS LOGICAL
  ( hWidget AS HANDLE, iIndex AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FOLDER-OF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FOLDER-OF Method-Library 
FUNCTION FOLDER-OF RETURNS CHARACTER
  ( INPUT ip-filename AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{af/sup2/afspcolour.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-AboutBox) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AboutBox Method-Library 
PROCEDURE AboutBox :
/*------------------------------------------------------------------------------
  Purpose:     Display the About Box
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUTTON Btn_Image 
     IMAGE-UP FILE "ry/img/smartpak":U
     IMAGE-DOWN FILE "ry/img/smartpak":U
     IMAGE-INSENSITIVE FILE "ry/img/smartpak":U NO-FOCUS
     SIZE 6.4 BY 1.52.

DEFINE BUTTON Btn_Close AUTO-GO 
     LABEL "&Close" 
     SIZE 15 BY 1.14.

DEFINE RECTANGLE RECT-BORDER
     EDGE-PIXELS 37 NO-FILL 
     SIZE 7.2 BY 1.71.

DEFINE FRAME AboutBox
     Btn_Image AT ROW 2.14 COL 3.8
     Btn_Close AT ROW 4.76 COL 26.2
     "{&PRODUCT_NAME} v{&PRODUCT_VERSION} for Progress Version 9.x":U
     VIEW-AS TEXT AT ROW 2 COL 12.6 FGCOLOR 1 FONT 6
     RECT-BORDER AT ROW 2.05 COL 3.4
     "by {&PRODUCT_AUTHOR}.":U
     VIEW-AS TEXT SIZE 52 BY 1.05 AT ROW 3 COL 12.6
     SPACE(1.79) SKIP(2.13)
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
     SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
     TITLE "About" DEFAULT-BUTTON Btn_Close.

&IF "{&FRAME-NAME}" <> ""
&THEN
    ASSIGN FRAME AboutBox:PARENT = FRAME {&FRAME-NAME}:PARENT NO-ERROR.
&ENDIF

ON "WINDOW-CLOSE":U OF FRAME AboutBox APPLY "END-ERROR":U TO SELF.

DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE WITH FRAME AboutBox:
    VIEW FRAME AboutBox.
    ENABLE Btn_Close WITH FRAME AboutBox.
    WAIT-FOR GO OF FRAME AboutBox FOCUS Btn_Close IN FRAME AboutBox.
END.

HIDE FRAME AboutBox.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formAssign) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formAssign Method-Library 
PROCEDURE formAssign :
/*------------------------------------------------------------------------------
  Purpose:     Assign Property details from screen
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT FrameChanged THEN RETURN.

ASSIGN wh = FRAME FRAME-B:HANDLE
       wh = wh:FIRST-CHILD    /* Field Group */ 
       wh = wh:FIRST-CHILD.   /* First Field */

DO WHILE VALID-HANDLE(wh):

    IF CAN-QUERY(wh,"SCREEN-VALUE":U) 
    THEN DO:

        FIND FIRST wProperty
            WHERE wProperty.wIndex  = fiIndex
              AND wProperty.wHandle = wh
            NO-ERROR.

        IF AVAILABLE wProperty THEN
        CASE wh:TYPE:

            WHEN "TOGGLE-BOX":U 
            THEN 
                ASSIGN wProperty.wValue = STRING(wh:CHECKED).

            WHEN "COMBO-BOX":U OR WHEN "SELECTION-LIST":U
            THEN 
                IF LOOKUP(wh:NAME,"{&LIST-ITEMS}"," ") > 0 
                THEN
                    ASSIGN wProperty.wValue = IF wh:LIST-ITEMS = ? THEN "" ELSE wh:LIST-ITEMS.
                ELSE
                    ASSIGN wProperty.wValue = IF wh:SCREEN-VALUE = ? THEN "" ELSE wh:SCREEN-VALUE.

            OTHERWISE    
                ASSIGN wProperty.wValue = IF wh:SCREEN-VALUE = ? THEN "" ELSE wh:SCREEN-VALUE.

        END CASE.
    END.

    ASSIGN wh = wh:NEXT-SIBLING.
END.

ASSIGN FrameChanged = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formDelete Method-Library 
PROCEDURE formDelete :
/*------------------------------------------------------------------------------
  Purpose:     Delete the current Property record
  Parameters:  <none>
  Notes:       There must always be at least one Property record, so if the
               last one is deleted, it is recreated with defaults.
------------------------------------------------------------------------------*/

ASSIGN FRAME FRAME-B fiIndex
       Btn_Apply:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
       FrameChanged = TRUE.

IF iCount > 1
THEN DO:
    FOR EACH wProperty
        WHERE wProperty.wIndex = fiIndex:

        DELETE wProperty.
    END.

    ASSIGN iCount = iCount - 1 fiIndex = MINIMUM(fiIndex,iCount).

    FOR EACH wProperty
        WHERE wProperty.wIndex > fiIndex
        BY wProperty.wIndex:

        ASSIGN wProperty.wIndex = wProperty.wIndex - 1.
    END.

    RUN FormDisplay IN THIS-PROCEDURE.
END.
ELSE DO:
    CLEAR FRAME FRAME-B.

    ASSIGN iCount = 1 fiIndex = 1.

    DISPLAY fiIndex {&INITIAL} {&EXTRA-INITIAL} WITH FRAME FRAME-B.

    FOR EACH wProperty:

        ASSIGN wProperty.wIndex = 1.

        IF LOOKUP(wProperty.wHandle:NAME,"{&INDEX}"," ") > 0 
        THEN
            ASSIGN wProperty.wHandle:SCREEN-VALUE = SUBSTITUTE(wProperty.wHandle:PRIVATE-DATA,"&" + STRING(fiIndex)).
        ELSE    
        IF LOOKUP(wProperty.wHandle:NAME,"{&LIST-ITEMS}"," ") > 0
        THEN
            ASSIGN wProperty.wHandle:LIST-ITEMS = wProperty.wHandle:PRIVATE-DATA
                   wProperty.wHandle:SCREEN-VALUE = ENTRY(1,wProperty.wHandle:LIST-ITEMS).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formDisplay) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formDisplay Method-Library 
PROCEDURE formDisplay :
/*------------------------------------------------------------------------------
  Purpose:     Display property details
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISPLAY fiIndex WITH FRAME FRAME-B.

FOR EACH wProperty
    WHERE wProperty.wIndex = fiIndex:

    CASE wProperty.wHandle:TYPE:

        WHEN "COMBO-BOX" OR WHEN "SELECTION-LIST"
        THEN
            IF LOOKUP(wProperty.wHandle:NAME,"{&LIST-ITEMS}"," ") > 0
            THEN
                ASSIGN wProperty.wHandle:LIST-ITEMS   = wProperty.wValue
                       wProperty.wHandle:SCREEN-VALUE = ENTRY(1,wProperty.wValue).
            ELSE
                ASSIGN wProperty.wHandle:SCREEN-VALUE = wProperty.wValue.

        WHEN "TOGGLE-BOX"
        THEN
            ASSIGN wProperty.wHandle:CHECKED = wProperty.wValue = "YES".

        OTHERWISE
            ASSIGN wProperty.wHandle:SCREEN-VALUE = wProperty.wValue.

    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formFirst Method-Library 
PROCEDURE formFirst :
/*------------------------------------------------------------------------------
  Purpose:     Get the first Property record in sequence
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN FRAME FRAME-B fiIndex.

RUN formAssign IN THIS-PROCEDURE.

ASSIGN fiIndex = 1.

RUN formDisplay IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formInsert) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formInsert Method-Library 
PROCEDURE formInsert :
/*------------------------------------------------------------------------------
  Purpose:     Insert a new Property record after the current position
  Parameters:  <none>
  Notes:       The default values are placed on-screen using the INITIAL list
               preprocessor which should be checked for each property that has 
               an initial value.
------------------------------------------------------------------------------*/
DEFINE BUFFER lProperty FOR wProperty.

ASSIGN FRAME FRAME-B fiIndex
       Btn_Apply:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
       FrameChanged = TRUE.

IF iCount >= fiIndex:NUM-ITEMS
THEN DO:
    MESSAGE "The" fiTitle "is currently limited to" iCount "{&OTYPE}." SKIP(1)
            "If you really need to have more than" iCount "{&OTYPE}, then"
            "please edit the" fiTitle "object" SKIP "and increase the value of the"
            "ARRAY-SIZE preprocessor definition. Then recompile the" SKIP fiTitle 
            "and reinstantiate within AppBuilder." SKIP(1)
            "Don't forget to distribute the modified version with your application."
        VIEW-AS ALERT-BOX INFORMATION TITLE "{&PRODUCT_ID}".
    RETURN.
END.

RUN formAssign IN THIS-PROCEDURE.

FOR EACH wProperty
    WHERE wProperty.wIndex > fiIndex
    BY wProperty.wIndex DESCENDING:

    ASSIGN wProperty.wIndex = wProperty.wIndex + 1.
END.

ASSIGN fiIndex = fiIndex + 1 iCount = iCount + 1.

CLEAR FRAME FRAME-B.

DISPLAY fiIndex {&INITIAL} {&EXTRA-INITIAL} WITH FRAME FRAME-B.

FOR EACH wProperty
    WHERE wProperty.wIndex = 1:

    CREATE lProperty.

    ASSIGN lProperty.wIndex  = fiIndex
           lProperty.wHandle = wProperty.wHandle.

    IF LOOKUP(lProperty.wHandle:NAME,"{&INDEX}"," ") > 0 
    THEN
        ASSIGN lProperty.wHandle:SCREEN-VALUE = SUBSTITUTE(lProperty.wHandle:PRIVATE-DATA,"&" + STRING(fiIndex)).
    ELSE    
    IF LOOKUP(lProperty.wHandle:NAME,"{&LIST-ITEMS}"," ") > 0
    THEN
        ASSIGN lProperty.wHandle:LIST-ITEMS = lProperty.wHandle:PRIVATE-DATA
               lProperty.wHandle:SCREEN-VALUE = ENTRY(1,lProperty.wHandle:LIST-ITEMS).
END.

ASSIGN wh = WIDGET-HANDLE(FRAME FRAME-B:PRIVATE-DATA)
       FrameChanged = TRUE.

IF VALID-HANDLE(wh) THEN APPLY "ENTRY" TO wh.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formLast Method-Library 
PROCEDURE formLast :
/*------------------------------------------------------------------------------
  Purpose:     Get the last Property record in sequence
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN FRAME FRAME-B fiIndex.

RUN formAssign IN THIS-PROCEDURE.

ASSIGN fiIndex = MAX(1,iCount).

RUN formDisplay IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formLeft) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formLeft Method-Library 
PROCEDURE formLeft :
/*------------------------------------------------------------------------------
  Purpose:     Move the current Property record down in sequence
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER lProperty FOR wProperty.

ASSIGN FRAME FRAME-B fiIndex.

IF fiIndex < 2 THEN RETURN.

RUN formAssign.

ASSIGN Btn_Apply:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE FrameChanged = TRUE.

FOR EACH wProperty
    WHERE wProperty.wIndex  = fiIndex:
    ASSIGN wProperty.wIndex = -99.
END.

FOR EACH wProperty
    WHERE wProperty.wIndex  = fiIndex - 1:
    ASSIGN wProperty.wIndex = fiIndex.
END.

FOR EACH wProperty
    WHERE wProperty.wIndex  = -99:
    ASSIGN wProperty.wIndex = fiIndex - 1.
END.

ASSIGN fiIndex = fiIndex - 1.

RUN formDisplay IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formNext Method-Library 
PROCEDURE formNext :
/*------------------------------------------------------------------------------
  Purpose:     Get the next Property record in sequence
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN FRAME FRAME-B fiIndex.

RUN formAssign IN THIS-PROCEDURE.

ASSIGN fiIndex = MAX(1,MIN(fiIndex + 1,iCount)).

RUN formDisplay IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formPrevious) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formPrevious Method-Library 
PROCEDURE formPrevious :
/*------------------------------------------------------------------------------
  Purpose:     Get the previous Property record in sequence
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN FRAME FRAME-B fiIndex.

RUN formAssign IN THIS-PROCEDURE.

ASSIGN fiIndex = MAX(1,fiIndex - 1).

RUN formDisplay IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formRight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formRight Method-Library 
PROCEDURE formRight :
/*------------------------------------------------------------------------------
  Purpose:     Move the current Property record up in sequence
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER lProperty FOR wProperty.

ASSIGN FRAME FRAME-B fiIndex.

IF fiIndex >= iCount THEN RETURN.

RUN formAssign.

ASSIGN Btn_Apply:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE FrameChanged = TRUE.

FOR EACH wProperty
    WHERE wProperty.wIndex  = fiIndex:
    ASSIGN wProperty.wIndex = -99.
END.

FOR EACH wProperty
    WHERE wProperty.wIndex  = fiIndex + 1:
    ASSIGN wProperty.wIndex = fiIndex.
END.

FOR EACH wProperty
    WHERE wProperty.wIndex  = -99:
    ASSIGN wProperty.wIndex = fiIndex + 1.
END.

ASSIGN fiIndex = fiIndex + 1.

RUN formDisplay IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getArrayProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getArrayProperties Method-Library 
PROCEDURE getArrayProperties :
/*------------------------------------------------------------------------------
  Purpose:     Extract the Arrayed properties for Frame B
  Parameters:  <none>
  Notes:       Zips around the the frame to find all the fields, and extract the
               property value using the property name stored in the HELP attribute.
               The only reason it's done backwards (LAST-CHILD/PREV-SIBLING) is so
               that the first field in the frame has initial focus. As these are 
               property arrays, they are further processed by placing each one in 
               its own work-table record. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cPropertyName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropertyValue AS CHARACTER NO-UNDO.

ASSIGN cPropertyValue = STRING(DYNAMIC-FUNCTION("get{&PRIMARY-PROPERTY}" IN ip-caller)).

IF cPropertyValue = "":U OR cPropertyValue = ? THEN
    DYNAMIC-FUNCTION('disablePagesInFolder':U, INPUT "2":U).

ASSIGN iCount = NUM-ENTRIES(cPropertyValue,"{&DELIMITER}")
       wh = FRAME FRAME-B:HANDLE
       wh = wh:FIRST-CHILD    /* Field Group */ 
       wh = wh:LAST-CHILD.    /* Last Field  */

DO WHILE VALID-HANDLE(wh):

    IF CAN-SET(wh,"SCREEN-VALUE") AND wh:HELP <> ?
    THEN DO:

        ASSIGN cPropertyName  = wh:HELP
               cPropertyValue = STRING(DYNAMIC-FUNCTION("get" + cPropertyName IN ip-caller))
               wh:SENSITIVE = TRUE.

        DO fiIndex = 1 TO iCount:

            CREATE wProperty.

            ASSIGN wProperty.wIndex    = fiIndex
                   wProperty.wHandle   = wh
                   FRAME FRAME-B:PRIVATE-DATA = STRING(wh)
                   wProperty.wValue    = ENTRY(fiIndex,cPropertyValue,"{&DELIMITER}")
                   NO-ERROR.
        END.
    END.

    ASSIGN wh = wh:PREV-SIBLING.
END.

ENUMERATE(fiIndex:HANDLE,DYNAMIC-FUNCTION("getLimits" IN ip-caller)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBasicProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBasicProperties Method-Library 
PROCEDURE getBasicProperties :
/*------------------------------------------------------------------------------
  Purpose:     Extract the basic Properties for Frame A
  Parameters:  <none>
  Notes:       Zips around the the frame to find all the fields, and extract the
               property value using the property name stored in the HELP attribute.
               The only reason it's done backwards (LAST-CHILD/PREV-SIBLING) is so
               that the first field in the frame has initial focus.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cPropertyName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropertyValue AS CHARACTER NO-UNDO.

ASSIGN wh = FRAME FRAME-A:HANDLE
       wh = wh:FIRST-CHILD    /* Field Group */ 
       wh = wh:LAST-CHILD.    /* Last Field  */

DO WHILE VALID-HANDLE(wh):

    IF CAN-SET(wh,"SCREEN-VALUE") AND wh:HELP <> ?
    THEN
        ASSIGN cPropertyName   = wh:HELP
               cPropertyValue  = STRING(DYNAMIC-FUNCTION("get" + cPropertyName IN ip-caller))
               wh:SCREEN-VALUE = cPropertyValue
               wh:SENSITIVE    = TRUE
               FRAME FRAME-A:PRIVATE-DATA = STRING(wh)
               NO-ERROR.

    ASSIGN wh = wh:PREV-SIBLING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorDialog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getColorDialog Method-Library 
PROCEDURE getColorDialog :
/*------------------------------------------------------------------------------
  Purpose:     Calls the standard dialog
  Parameters:  <none>
  Notes:       Although the dialog presents both foreground and background 
               colors for selection, only one can be chosen here.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cColor AS CHARACTER NO-UNDO.

DEFINE VARIABLE lResult AS LOGICAL NO-UNDO.

ASSIGN cColor = wh:SCREEN-VALUE.

RUN af/sup2/afspgetcow.w(INPUT-OUTPUT cColor,OUTPUT lResult).

IF NOT lResult THEN RETURN.

ASSIGN wh:SCREEN-VALUE = cColor.

APPLY "VALUE-CHANGED" TO wh.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFontDialog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFontDialog Method-Library 
PROCEDURE getFontDialog :
/*------------------------------------------------------------------------------
  Purpose:     Display the standard Font selector
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iFont AS INTEGER NO-UNDO.

ASSIGN ifont = INTEGER(wh:SCREEN-VALUE) NO-ERROR.

RUN adecomm/_chsfont.p 
    ("Choose " + REPLACE(wh:LABEL,"&",""), ?,
    INPUT-OUTPUT ifont,
    OUTPUT vResult).

IF NOT vResult THEN RETURN.

ASSIGN wh:SCREEN-VALUE = STRING(iFont).

APPLY "VALUE-CHANGED" TO wh.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImageDialog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getImageDialog Method-Library 
PROCEDURE getImageDialog :
/*------------------------------------------------------------------------------
  Purpose:     Prompt for an image file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pDirList          AS CHARACTER NO-UNDO INITIAL "adeicon,.".
  DEFINE VARIABLE pFileName         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pAbsoluteFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pOk               AS LOGICAL   NO-UNDO.

  ASSIGN pFileName = wh:SCREEN-VALUE.

  RUN adecomm/_fndfile.p ("Choose Image File","IMAGE","{&FNDFILE-FILTER}",
            INPUT-OUTPUT pDirList, INPUT-OUTPUT pFileName,
            OUTPUT pAbsoluteFileName,OUTPUT pOk).

  IF NOT pOk THEN RETURN.

  ASSIGN wh:SCREEN-VALUE = FOLDER-OF(pFilename).

  APPLY "VALUE-CHANGED" TO wh.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-listAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE listAdd Method-Library 
PROCEDURE listAdd :
/*------------------------------------------------------------------------------
  Purpose:     Add or Modify a value in a Combo-Box or Selection-List
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN wh = FOCUS FrameChanged = TRUE.

IF LOOKUP(wh:NAME,"{&LIST-ITEMS}"," ") = 0
THEN DO:
    BELL.
    RETURN.
END.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Replace
     LABEL "&Replace" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cListItem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE FRAME fListItem
     cListItem AT ROW 2.14 COL 2.8 NO-LABEL
     Btn_OK AT ROW 3.48 COL 3
     Btn_Replace AT ROW 3.48 COL 19
     Btn_Cancel AT ROW 3.48 COL 35
     "Please enter the new list item value:" VIEW-AS TEXT
     SIZE 50 BY .76 AT ROW 1.29 COL 2.8
     SPACE(11.59) SKIP(2.75)
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "New List Item"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


DO ON ERROR UNDO, LEAVE
   ON ENDKEY UNDO, LEAVE
   WITH FRAME fListItem:

   ON "CHOOSE" OF btn_Replace
   DO:
        ASSIGN vResult = TRUE.
        APPLY "GO" TO FRAME fListItem.
   END.

   ON "WINDOW-CLOSE" OF FRAME fListItem
   DO:
        APPLY "END-ERROR" TO SELF.
   END.

   ON "VALUE-CHANGED" OF cListItem
   DO:
       ASSIGN Btn_OK:SENSITIVE = wh:LIST-ITEMS = ?
                                 OR (NOT CAN-DO(wh:LIST-ITEMS,SELF:SCREEN-VALUE) 
                                 AND SELF:SCREEN-VALUE <> "" 
                                 AND SELF:SCREEN-VALUE <> ?)
              Btn_Replace:SENSITIVE = wh:LIST-ITEMS <> ? AND Btn_OK:SENSITIVE.  
   END.

   ENABLE cListItem Btn_Cancel.

   VIEW.

   ASSIGN vResult = FALSE
          cListItem:SCREEN-VALUE = IF wh:LIST-ITEMS <> ? 
                                   THEN wh:SCREEN-VALUE
                                   ELSE "".

   WAIT-FOR "GO" OF FRAME fListItem FOCUS cListItem.

   ASSIGN cListItem.

   IF vResult 
   THEN
        wh:REPLACE(wh:SCREEN-VALUE,cListItem).
   ELSE
        wh:ADD-FIRST(cListItem).

   ASSIGN wh:SCREEN-VALUE = cListItem.

   APPLY "VALUE-CHANGED" TO wh.
END.

HIDE FRAME fListItem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-listRemove) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE listRemove Method-Library 
PROCEDURE listRemove :
/*------------------------------------------------------------------------------
  Purpose:     Deletes an entry in a Combo-Box or Selection-List
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN wh = FOCUS vResult = FALSE FrameChanged = TRUE.

IF LOOKUP(wh:NAME,"{&LIST-ITEMS}"," ") = 0
THEN DO:
    BELL.
    RETURN.
END.

MESSAGE "Delete List Item" wh:SCREEN-VALUE "from the '" 
      + REPLACE(wh:LABEL,"&","") + "' list?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "{&PRODUCT_ID}"
    UPDATE vResult.

IF vResult 
THEN DO:
    ASSIGN vResult = wh:DELETE(wh:SCREEN-VALUE)
           wh:SCREEN-VALUE = wh:ENTRY(1)
           NO-ERROR.

    APPLY "VALUE-CHANGED":U TO wh.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setArrayProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setArrayProperties Method-Library 
PROCEDURE setArrayProperties :
/*------------------------------------------------------------------------------
  Purpose:     Extract the basic Properties for Frame A
  Parameters:  <none>
  Notes:       All property array are of data-type CHARACTER
------------------------------------------------------------------------------*/
DEFINE VARIABLE cPropertyName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropertyValue AS CHARACTER NO-UNDO.

ASSIGN wh = FRAME FRAME-B:HANDLE
       wh = wh:FIRST-CHILD    /* Field Group */ 
       wh = wh:FIRST-CHILD.   /* First Field */

DO WHILE VALID-HANDLE(wh):

    IF CAN-SET(wh,"SCREEN-VALUE") AND wh:HELP <> ?
    THEN DO:

        FOR EACH wProperty
            WHERE wProperty.wHandle = wh
            BY wProperty.wIndex:

            ASSIGN cPropertyName = wProperty.wHandle:HELP.

            IF LOOKUP(wh:NAME,"{&COLOR-LIST}"," ") > 0 AND wProperty.wValue = ""
            THEN
                ASSIGN wProperty.wValue = "Default".

            IF wProperty.wIndex = 1
            THEN
                ASSIGN cPropertyValue = wProperty.wValue.
            ELSE
                ASSIGN cPropertyValue = cPropertyValue + "{&DELIMITER}" + wProperty.wValue.
        END.

        /* HCK (2002/10/29) - Fix for issue 7330. When there is no function name (cPropertyName = ""),
                              there is no need to try and execute a set function */
        IF cPropertyName <> "":U THEN
        DO:
          IF cPropertyName <> "{&PRIMARY-PROPERTY}"
          AND cPropertyValue = FILL("{&DELIMITER}",iCount - 1)
          THEN
              ASSIGN cPropertyValue = "".

          ASSIGN vResult = DYNAMIC-FUNCTION("set" + cPropertyName IN ip-caller, cPropertyValue).

          IF NOT vResult 
          THEN
              MESSAGE "Unable to set value for Array Property" cPropertyName
                  VIEW-AS ALERT-BOX WARNING TITLE "{&PRODUCT_ID}".
        END.
    END.

    ASSIGN wh = wh:NEXT-SIBLING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBasicProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBasicProperties Method-Library 
PROCEDURE setBasicProperties :
/*------------------------------------------------------------------------------
  Purpose:     Save the basic Properties into the SmartObject
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cPropertyName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropertyValue AS CHARACTER NO-UNDO.

ASSIGN wh = FRAME FRAME-A:HANDLE
       wh = wh:FIRST-CHILD    /* Field Group */ 
       wh = wh:FIRST-CHILD.   /* First Field */

DO WHILE VALID-HANDLE(wh):

    IF CAN-SET(wh,"SCREEN-VALUE") AND wh:HELP <> ?
    THEN DO:
        ASSIGN cPropertyName  = wh:HELP
               cPropertyValue = wh:SCREEN-VALUE.

        IF LOOKUP(wh:NAME,"{&COLOR-LIST}"," ") > 0 AND cPropertyValue = ""
        THEN
            ASSIGN cPropertyValue = "Default".

        CASE wh:DATA-TYPE:

            WHEN "LOGICAL" 
            THEN DO:
                ASSIGN vResult = DYNAMIC-FUNCTION("set" + cPropertyName IN ip-caller, CAN-DO("Yes",cPropertyValue)).

                IF vVerify
                THEN DO:
                    IF DYNAMIC-FUNCTION("get" + cPropertyName IN ip-caller) <> cPropertyValue
                    THEN
                        MESSAGE "Verification error for Basic Property" cPropertyName
                            VIEW-AS ALERT-BOX WARNING TITLE "{&PRODUCT_ID}".
                END.
            END.

            WHEN "INTEGER" 
            THEN DO:
                ASSIGN vResult = DYNAMIC-FUNCTION("set" + cPropertyName IN ip-caller, INTEGER(cPropertyValue)).

                IF vVerify
                THEN DO:
                    IF DYNAMIC-FUNCTION("get" + cPropertyName IN ip-caller) <> INTEGER(cPropertyValue)
                    THEN
                        MESSAGE "Verification error for Basic Property" cPropertyName
                            VIEW-AS ALERT-BOX WARNING TITLE "{&PRODUCT_ID}".
                END.
            END.

            OTHERWISE DO:
                ASSIGN vResult = DYNAMIC-FUNCTION("set" + cPropertyName IN ip-caller, cPropertyValue).

                IF vVerify
                THEN DO:
                    IF DYNAMIC-FUNCTION("get" + cPropertyName IN ip-caller) <> cPropertyValue
                    THEN
                        MESSAGE "Verification error for Basic Property" cPropertyName
                            VIEW-AS ALERT-BOX WARNING TITLE "{&PRODUCT_ID}".
                END.
            END.

        END CASE.

        IF NOT vResult THEN
            MESSAGE "Unable to set value for Basic Property" cPropertyName
                VIEW-AS ALERT-BOX WARNING TITLE "{&PRODUCT_ID}".
    END.

    ASSIGN wh = wh:NEXT-SIBLING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-ENUMERATE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ENUMERATE Method-Library 
FUNCTION ENUMERATE RETURNS LOGICAL
  ( hWidget AS HANDLE, iIndex AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

hWidget:SCREEN-VALUE = ?.
hWidget:LIST-ITEMS   = ?.

DO iCount = 1 TO iIndex:
    hWidget:ADD-LAST(STRING(iCount,">>9")).
END.

RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FOLDER-OF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FOLDER-OF Method-Library 
FUNCTION FOLDER-OF RETURNS CHARACTER
  ( INPUT ip-filename AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose: Return the short pathname for a file
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE vFrom  AS INTEGER NO-UNDO.
  DEFINE VARIABLE vto    AS INTEGER NO-UNDO.
  DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

  DEFINE VARIABLE vShort AS CHARACTER NO-UNDO.
  DEFINE VARIABLE vFname AS CHARACTER NO-UNDO.

  ASSIGN ip-filename = REPLACE(ip-filename,"~\","/")
         iCount = NUM-ENTRIES(ip-filename,"/")
         vFname = ENTRY(iCount,ip-filename,"/").

  DO vFrom = iCount TO 1 BY -1:

      ASSIGN vShort = "".

      DO vTo = vFrom TO iCount - 1:
          ASSIGN vShort = vShort + ENTRY(vTo,ip-filename,"/") + "/".
      END.

      ASSIGN vShort = vShort + vFname.

      IF SEARCH(vShort) <> ? THEN RETURN vShort.
  END.

  RETURN ip-filename. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

