&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: afmessaged.w

  Description: Generic message display

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{af/sup2/afglobals.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER  pcMessageType        AS CHARACTER. /* Message Type (MES, INF, WAR, ERR, HAL,QUE                            */
DEFINE INPUT PARAMETER  pcMessageSummaryList AS CHARACTER. /* CHR(3) delimited list of formatted summary message text (translated) */
DEFINE INPUT PARAMETER  pcMessageDetailList  AS CHARACTER. /* CHR(3) delimited list of formatted full message text (translated)    */
DEFINE INPUT PARAMETER  pcButtonLabelList    AS CHARACTER. /* Comma delimited list of button labels (translated)                   */
DEFINE INPUT PARAMETER  pcDialogTitle        AS CHARACTER. /* Message title (translated)                                           */
DEFINE INPUT PARAMETER  piDefaultButton      AS INTEGER.   /* Integer value of entry number in button list of default button       */
DEFINE INPUT PARAMETER  piCancelButton       AS INTEGER.   /* Integer value of entry number in button list of escape button        */
DEFINE INPUT PARAMETER  pcAnswerDatatype     AS CHARACTER. /* Optional question data type                                          */
DEFINE INPUT PARAMETER  pcAnswerFormat       AS CHARACTER. /* Optional question format mask                                        */
DEFINE INPUT PARAMETER  pcDefaultAnswer      AS CHARACTER. /* Optional  string value for default answer to question                */
DEFINE INPUT PARAMETER  phContainer          AS HANDLE.    /* Optional  container handle                */
DEFINE OUTPUT PARAMETER piPressedButton      AS INTEGER.   /* Integer value of entry number in button list of button pressed.      */
DEFINE OUTPUT PARAMETER pcActualAnswer       AS CHARACTER. /* String value of answer to question if applicable.                    */

IF pcMessageType = "ABO":U THEN
  pcMessageDetailList = "":U.

/* MESSAGE "pcMessageType=" pcMessageType SKIP                  */
/*         "pcButtonLabelList=" pcButtonLabelList SKIP          */
/*         "pcDialogTitle=" pcDialogTitle SKIP                  */
/*         "piDefaultButton=" piDefaultButton SKIP              */
/*         "piCancelButton=" piCancelButton SKIP                */
/*         "pcAnswerDatatype=" pcAnswerDatatype SKIP            */
/*         "pcAnswerFormat=" pcAnswerFormat SKIP(1)             */
/*         "pcMessageSummaryList=" pcMessageSummaryList SKIP(1) */
/*         "pcMessageDetailList=" pcMessageDetailList SKIP.     */



/* Local Variable Definitions ---                                       */


/* variables used to cache the dimensions of a window before it is maximized */

DEFINE VARIABLE gdPreviousWidth     AS DECIMAL  NO-UNDO.
DEFINE VARIABLE gdPreviousHeight    AS DECIMAL  NO-UNDO.
DEFINE VARIABLE gdPreviousRow       AS DECIMAL  NO-UNDO.
DEFINE VARIABLE gdPreviousColumn    AS DECIMAL  NO-UNDO.

DEFINE VARIABLE glQuestion          AS LOGICAL  NO-UNDO. /* set TRUE if this is a Question */
DEFINE VARIABLE glInformation       AS LOGICAL  NO-UNDO. /* set TRUE if this is a Information */
DEFINE VARIABLE glAbout             AS LOGICAL  NO-UNDO. /* set TRUE if this is a About window */
DEFINE VARIABLE ghFillIn            AS HANDLE   NO-UNDO. /* handle to the fillin for entering a Response */
DEFINE VARIABLE ghLabel             AS HANDLE   NO-UNDO. /* handle to the Label of a Response */
DEFINE VARIABLE ghFocusButton       AS HANDLE   NO-UNDO. /* handle to the widget which will be granted focus */

DEFINE VARIABLE lFullScreen         AS LOGICAL  NO-UNDO.


DEFINE VARIABLE ghSourceProcedure AS HANDLE NO-UNDO. /* used to get details from the calling procedure */

/* I know this is the definitions section, but I need to execute this statement without 
   any chance of a RUN statement being executed first! */

ghSourceProcedure = SOURCE-PROCEDURE.

DEFINE TEMP-TABLE ttHandle          NO-UNDO
    FIELD lLocalSession     AS LOGICAL
    FIELD cHandle           AS CHARACTER
    FIELD hHandle           AS HANDLE
    FIELD cFieldList        AS CHARACTER
    INDEX pudx IS UNIQUE PRIMARY
        lLocalSession
        cHandle
    .

DEFINE TEMP-TABLE ttField       NO-UNDO
    FIELD tFieldHandle      AS HANDLE
    FIELD tFieldLabel       AS CHARACTER
    .

DEFINE VARIABLE ghCacheBufferHandle AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS edSystemInformation edAppserver ~
edMessageSummary edMessageDetail imAlert 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addHandle gDialog 
FUNCTION addHandle RETURNS LOGICAL
    ( INPUT phHandle        AS HANDLE,
      INPUT pcFieldList     AS CHARACTER,
      INPUT plLocalSession  AS LOGICAL      )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addToVariable gDialog 
FUNCTION addToVariable RETURNS CHARACTER
  (pcCurrentText  AS CHARACTER,
   pcText         AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD DisplayConfigInfo gDialog 
FUNCTION DisplayConfigInfo RETURNS LOGICAL
    ( INPUT plLocalSession      AS LOGICAL,
      INPUT phDisplayWidget     AS HANDLE       )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD notNull gDialog 
FUNCTION notNull RETURNS CHARACTER
  ( cValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD whackTempTables gDialog 
FUNCTION whackTempTables RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_afspfoldrw AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btFullScreen 
     IMAGE-UP FILE "ry/img/afsingwind.gif":U NO-FOCUS
     LABEL "FS" 
     SIZE 5.2 BY 1.14 TOOLTIP "Full Screen Size"
     BGCOLOR 8 .

DEFINE BUTTON btMail 
     IMAGE-UP FILE "ry/img/afmail.gif":U NO-FOCUS
     LABEL "" 
     SIZE 5.2 BY 1.14 TOOLTIP "E-Mail Technical Support"
     BGCOLOR 8 .

DEFINE BUTTON btStack 
     IMAGE-UP FILE "ry/img/affindu.gif":U NO-FOCUS
     LABEL "STK" 
     SIZE 5.2 BY 1.14 TOOLTIP "View Stack Trace"
     BGCOLOR 8 .

DEFINE VARIABLE edAppserver AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL LARGE NO-BOX
     SIZE 61 BY 5.52
     BGCOLOR 16 FONT 0 NO-UNDO.

DEFINE VARIABLE edMessageDetail AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE NO-BOX
     SIZE 61 BY 5.52
     BGCOLOR 16 FONT 0 NO-UNDO.

DEFINE VARIABLE edMessageSummary AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE NO-BOX
     SIZE 61 BY 5.52
     BGCOLOR 16 FONT 0 NO-UNDO.

DEFINE VARIABLE edSystemInformation AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL LARGE NO-BOX
     SIZE 61 BY 5.52
     BGCOLOR 16 FONT 0 NO-UNDO.

DEFINE IMAGE imAlert CONVERT-3D-COLORS
     SIZE 8 BY 2.14.

DEFINE BUTTON btCancel 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btDefault DEFAULT 
     LABEL "Default" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     btFullScreen AT ROW 6.57 COL 3.2
     edSystemInformation AT ROW 2.43 COL 12.6 NO-LABEL
     edAppserver AT ROW 2.43 COL 12.6 NO-LABEL
     edMessageSummary AT ROW 2.43 COL 12.6 NO-LABEL
     edMessageDetail AT ROW 2.43 COL 12.6 NO-LABEL
     btMail AT ROW 4.1 COL 3.2
     btStack AT ROW 5.33 COL 3.2
     imAlert AT ROW 1.48 COL 1.8
     SPACE(91.59) SKIP(6.70)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert SmartDialog title>".

DEFINE FRAME frButtons
     btDefault AT ROW 1 COL 1
     btCancel AT ROW 1 COL 19
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 15 ROW 8.62
         SIZE 78 BY 1.71
         DEFAULT-BUTTON btDefault CANCEL-BUTTON btCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Compile into: af/cod2
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME frButtons:FRAME = FRAME gDialog:HANDLE.

/* SETTINGS FOR FRAME frButtons
   Custom                                                               */
/* SETTINGS FOR BUTTON btCancel IN FRAME frButtons
   NO-ENABLE                                                            */
ASSIGN 
       btCancel:HIDDEN IN FRAME frButtons           = TRUE.

ASSIGN 
       btDefault:HIDDEN IN FRAME frButtons           = TRUE.

/* SETTINGS FOR DIALOG-BOX gDialog
                                                                        */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btFullScreen IN FRAME gDialog
   NO-ENABLE                                                            */
ASSIGN 
       btFullScreen:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR BUTTON btMail IN FRAME gDialog
   NO-ENABLE                                                            */
ASSIGN 
       btMail:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR BUTTON btStack IN FRAME gDialog
   NO-ENABLE                                                            */
ASSIGN 
       btStack:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR EDITOR edAppserver IN FRAME gDialog
   NO-DISPLAY                                                           */
ASSIGN 
       edAppserver:HIDDEN IN FRAME gDialog           = TRUE
       edAppserver:READ-ONLY IN FRAME gDialog        = TRUE.

/* SETTINGS FOR EDITOR edMessageDetail IN FRAME gDialog
   NO-DISPLAY                                                           */
ASSIGN 
       edMessageDetail:HIDDEN IN FRAME gDialog           = TRUE
       edMessageDetail:READ-ONLY IN FRAME gDialog        = TRUE.

/* SETTINGS FOR EDITOR edMessageSummary IN FRAME gDialog
   NO-DISPLAY                                                           */
ASSIGN 
       edMessageSummary:READ-ONLY IN FRAME gDialog        = TRUE.

/* SETTINGS FOR EDITOR edSystemInformation IN FRAME gDialog
   NO-DISPLAY                                                           */
ASSIGN 
       edSystemInformation:HIDDEN IN FRAME gDialog           = TRUE
       edSystemInformation:READ-ONLY IN FRAME gDialog        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frButtons
/* Query rebuild information for FRAME frButtons
     _Query            is NOT OPENED
*/  /* FRAME frButtons */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON MOUSE-SELECT-DBLCLICK OF FRAME gDialog /* <insert SmartDialog title> */
DO:
  APPLY "choose":U TO btfullscreen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frButtons
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel gDialog
ON CHOOSE OF btCancel IN FRAME frButtons /* Cancel */
DO:
    RUN buttonAction(INPUT piCancelButton).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDefault
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDefault gDialog
ON CHOOSE OF btDefault IN FRAME frButtons /* Default */
DO:
    RUN buttonAction(INPUT piDefaultButton).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME gDialog
&Scoped-define SELF-NAME btFullScreen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFullScreen gDialog
ON CHOOSE OF btFullScreen IN FRAME gDialog /* FS */
DO:

    DEFINE VARIABLE hParentWindow AS HANDLE NO-UNDO.
    DEFINE VARIABLE dParentWIndowColumn AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dParentWIndowRow AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dRow AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dCol AS DECIMAL NO-UNDO.

    lFullScreen = NOT lFullScreen.

    IF lFullScreen THEN 
    DO:    
        ASSIGN
            hParentWindow       = FRAME {&FRAME-NAME}:PARENT
            dParentWIndowColumn = hParentWindow:COLUMN
            dParentWIndowRow    = hParentWindow:ROW
            gdPreviousWidth     = FRAME {&FRAME-NAME}:WIDTH
            gdPreviousHeight    = FRAME {&FRAME-NAME}:HEIGHT
            gdPreviousColumn    = FRAME {&FRAME-NAME}:COLUMN
            gdPreviousRow       = FRAME {&FRAME-NAME}:ROW
            .            
        ASSIGN
            FRAME {&FRAME-NAME}:WIDTH  = SESSION:WIDTH 
            FRAME {&FRAME-NAME}:HEIGHT = SESSION:HEIGHT
            dRow = MAXIMUM(1,(SESSION:HEIGHT - FRAME {&FRAME-NAME}:HEIGHT) / 2)
                                         - hParentWindow:ROW - 1
            dCol = MAXIMUM(1,(SESSION:WIDTH - FRAME {&FRAME-NAME}:WIDTH) / 2)
                                         - hParentWindow:COLUMN - 1
            .                                         

        /* If the row or column wound up being between 0 and 1 after the 
           calculation, change it, because otherwise Progress will complain. */
        IF dRow GE 0 AND dRow < 1 THEN dRow = 1.
        IF dCol GE 0 AND dCol < 1 THEN dCol = 1.

        ASSIGN            
            FRAME {&FRAME-NAME}:ROW    = dRow
            FRAME {&FRAME-NAME}:COLUMN = dCol
            .                                                                                  

/*             FRAME {&FRAME-NAME}:COLUMN   = -1 * dParentWIndowColumn */
/*             FRAME {&FRAME-NAME}:ROW   = -1 * dParentWIndowRow       */

        RUN reorganize (SESSION:WIDTH, SESSION:HEIGHT, NO).
    END.
    ELSE DO:
        RUN reorganize (gdPreviousWidth, gdPreviousHeight, YES).            
        ASSIGN
            FRAME {&FRAME-NAME}:WIDTH    = gdPreviousWidth
            FRAME {&FRAME-NAME}:HEIGHT   = gdPreviousHeight
            FRAME {&FRAME-NAME}:COLUMN   = gdPreviousColumn
            FRAME {&FRAME-NAME}:ROW      = gdPreviousRow
            .
    END.

    IF lFullScreen 
        THEN SELF:TOOLTIP = "Normal Screen Size". 
        ELSE SELF:TOOLTIP = "Full Screen Size".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMail gDialog
ON CHOOSE OF btMail IN FRAME gDialog
DO:
    DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFailureReason AS CHARACTER NO-UNDO.

    cMessage = "~n~n**********  MESSAGE SUMMARY   **********~n~n" + edMessageSummary:SCREEN-VALUE + 
               (IF pcMessageDetailList <> "":U THEN ("~n~n**********   MESSAGE DETAIL   **********~n~n" + edMessageDetail:SCREEN-VALUE) ELSE "":U) +
               "~n~n********** SYSTEM INFORMATION **********~n~n" + edSystemInformation:SCREEN-VALUE +
               "~n~n********** APPSERVER INFORMATION **********~n~n" + edAppserver:SCREEN-VALUE
               .

    RUN notifyUser IN gshSessionManager (
        INPUT   0,                              /* pdUserObj      */
        INPUT   "",                             /* pcUserName     */
        INPUT   "EMAIL",                        /* pcAction       */
        INPUT   "Technical Support",            /* pcSubject      */
        INPUT   cMessage,                       /* pcMessage      */
        OUTPUT  cFailureReason                  /* pcFailedReason */
        ).

    IF cFailureReason <> "" THEN MESSAGE 
        cFailureReason VIEW-AS ALERT-BOX ERROR TITLE "Could not compose Email".

/*     DEFINE VARIABLE lv_failure_reason   AS CHARACTER NO-UNDO.                                                                                           */
/*     DEFINE VARIABLE lv_message          AS CHARACTER NO-UNDO.                                                                                           */
/*     ASSIGN lv_message = edt-more:SCREEN-VALUE + CHR(10) + CHR(10) + lv_current_user_name + " ":U + STRING(TODAY) + " @ ":U + STRING(TIME,"HH:MM:SS":U). */
/*                                                                                                                                                         */
/*     RUN mip-send-email IN gh_local_app_plip                                                                                                             */
/*                       ( INPUT "":U,                 /* Email profile to use  */                                                                         */
/*                         INPUT "{&support_email}":U, /* Comma list of Email addresses for to: box */                                                     */
/*                         INPUT "":U,                 /* Comma list of Email addresses to cc */                                                           */
/*                         INPUT "Technical Support",  /* Subject of message */                                                                            */
/*                         INPUT lv_message,           /* Message text */                                                                                  */
/*                         INPUT "":U,                 /* Comma list of attachment filenames */                                                            */
/*                         INPUT "":U,                 /* Comma list of attachment filenames with full path */                                             */
/*                         INPUT YES,                  /* YES = display dialog for modification before send */                                             */
/*                         INPUT 0,                    /* Importance 0 = low, 1 = medium, 2 = high */                                                      */
/*                         INPUT NO,                   /* YES = return a read receipt */                                                                   */
/*                         INPUT NO,                   /* YES = return a delivery receipt */                                                               */
/*                         INPUT "":U,                 /* Not used yet but could be used for additional settings */                                        */
/*                         OUTPUT lv_failure_reason    /* If failed - the reason why, blank = it worked */                                                 */
/*                       ).                                                                                                                                */
/*     IF lv_failure_reason <> "":U THEN                                                                                                                   */
/*       MESSAGE lv_failure_reason.                                                                                                                        */
/*                                                                                                                                                         */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btStack
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btStack gDialog
ON CHOOSE OF btStack IN FRAME gDialog /* STK */
DO:

    MESSAGE "Press HELP for stack trace":U
        VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

ON CTRL-PAGE-UP OF FRAME {&FRAME-NAME} ANYWHERE DO:
  PUBLISH "selectPrevTab":U.
END.

ON CTRL-PAGE-DOWN OF FRAME {&FRAME-NAME} ANYWHERE DO:
  PUBLISH "selectNextTab":U.
END.


{src/adm2/dialogmn.i  &FOCUS-Phrase = "FOCUS btDefault"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'af/sup2/afspfoldrw.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'FolderLabels':U + 'Message &Summary|Message &Detail|System &Information|&Appserver Information' + 'TabFGcolor':U + 'Default|Default|Default|Default' + 'TabBGcolor':U + 'Default|Default|Default|Default' + 'TabINColor':U + 'GrayText|GrayText|GrayText|GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + 'Alt-S|Alt-D|Alt-I|Alt-A' + 'Tooltip':U + '' + 'TabHidden':U + 'no|no|no|no' + 'EnableStates':U + 'All|All|All|All' + 'DisableStates':U + 'All|All|All|All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '20' + 'FolderMenu':U + '' + 'TabsPerRow':U + '8' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Proportional' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'TabVisualization':U + 'TABS' + 'PopupSelectionEnabled':U + 'yes' + 'HideOnInityesDisableOnInitnoObjectLayout':U ,
             OUTPUT h_afspfoldrw ).
       RUN repositionObject IN h_afspfoldrw ( 1.24 , 10.80 ) NO-ERROR.
       RUN resizeObject IN h_afspfoldrw ( 4.00 , 82.60 ) NO-ERROR.

       /* Links to SmartFolder h_afspfoldrw. */
       RUN addLink ( h_afspfoldrw , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ASInfo gDialog 
PROCEDURE ASInfo :
/*------------------------------------------------------------------------------
  Purpose:     Event procedure for the asnych call we made
  Parameters:  
  Notes:       If receives, assigns and displays the data received.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER lRemote         AS LOGICAL INITIAL NO NO-UNDO.
  DEFINE INPUT PARAMETER cConnid         AS CHARACTER  NO-UNDO. /* SESSION:SERVER-CONNECTION-ID */
  DEFINE INPUT PARAMETER cOpmode         AS CHARACTER  NO-UNDO. /* SESSION:SERVER-OPERATING-MODE */
  DEFINE INPUT PARAMETER lConnreq        AS LOGICAL    NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND-REQUEST */
  DEFINE INPUT PARAMETER lConnbnd        AS LOGICAL    NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND */
  DEFINE INPUT PARAMETER cConnctxt       AS CHARACTER  NO-UNDO. /* SESSION:SERVER-CONNECTION-CONTEXT */
  DEFINE INPUT PARAMETER cASppath        AS CHARACTER  NO-UNDO. /* PROPATH */
  DEFINE INPUT PARAMETER cConndbs        AS CHARACTER  NO-UNDO. /* List of Databases */
  DEFINE INPUT PARAMETER cConnpps        AS CHARACTER  NO-UNDO. /* List of Running Persistent Procedures */
  DEFINE INPUT PARAMETER pcCustomisationTypes       AS CHARACTER    NO-UNDO.    /* from CustomizatinManager */
  DEFINE INPUT PARAMETER pcCustomisationReferences  AS CHARACTER    NO-UNDO.    /* from CustomizatinManager */
  DEFINE INPUT PARAMETER pcCustomisationResultCodes AS CHARACTER    NO-UNDO.    /* from CustomizatinManager */
  DEFINE INPUT PARAMETER TABLE-HANDLE phTTParam.                /* } Temp-tables describing */
  DEFINE INPUT PARAMETER TABLE-HANDLE phTTManager.              /* } the configuration and connection */
  DEFINE INPUT PARAMETER TABLE-HANDLE phTTServiceType.          /* } manager details. */
  DEFINE INPUT PARAMETER TABLE-HANDLE phTTService.              /* } */

  DEFINE VARIABLE iLoop                     AS INTEGER              NO-UNDO.
  DEFINE VARIABLE cAppserverInfo            AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cCustomisationInformation AS CHARACTER            NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    cAppserverInfo = "~n" + 
      "Partition:                  " + notNull("Astra":U)        + "~n" +
      "Connected:                  " + notNull(STRING(lRemote))  + "~n" +
      "Connection Id:              " + notNull(cConnid)          + "~n" +
      "Operating Mode:             " + notNull(cOpmode)          + "~n" +
      "Connection Bound Req.:      " + notNull(STRING(lConnreq)) + "~n" +
      "Connection Bound:           " + notNull(STRING(lConnbnd)) + "~n" +
      "Connection Context:         " + notNull(cConnctxt)        + "~n"
      .

    DO iLoop = 1 TO NUM-ENTRIES(cConndbs):
        cAppserverInfo = addToVariable(cAppserverInfo, "~n" + "Database: " + ENTRY(iLoop,cConndbs)).
    END.         

    cAppserverInfo = addToVariable(cAppserverInfo, "~n~nPropath: ").
    DO iLoop = 1 TO NUM-ENTRIES(cASppath):
       cAppserverInfo = addToVariable(cAppserverInfo, ENTRY(iLoop,cASppath) + "~n         ").
    END.

    cAppserverInfo = addToVariable(cAppserverInfo, "~nPersistent Procedures: ").
    DO iLoop = 1 TO NUM-ENTRIES(cConnpps):
       cAppserverInfo = addToVariable(cAppserverInfo, ENTRY(iLoop,cConnpps) + "~n                       ").
    END.

    edAppserver:SCREEN-VALUE = cAppserverInfo.

    /* Display the Config and Connection Manager information. */
    DYNAMIC-FUNCTION("addHandle", INPUT phTTParam,       INPUT "*":U,                                  INPUT NO).
    DYNAMIC-FUNCTION("addHandle", INPUT phTTManager,     INPUT "cManagerName,cFileName,cHandleName":U, INPUT NO).
    DYNAMIC-FUNCTION("addHandle", INPUT phTTServiceType, INPUT "cServiceType,cSTProcName":U,           INPUT NO).
    DYNAMIC-FUNCTION("addHandle", INPUT phTTService,     INPUT "*":U,                                  INPUT NO).

    DYNAMIC-FUNCTION("DisplayConfigInfo", INPUT NO, INPUT edAppserver:HANDLE).

    /** Display relevant customisation information.
     *  ----------------------------------------------------------------------- **/
    ASSIGN cCustomisationInformation = "":U.

    /* Display this information after the existing information. */
    cAppserverInfo = edAppserver:SCREEN-VALUE.

    cAppserverInfo = addToVariable(cAppserverInfo, "~n~n":U).
    cAppserverInfo = addToVariable(cAppserverInfo, "Customisation Information" + "~n":U + FILL("=":U, 50) + "~n":U).

    /* Customisation Types */
    ASSIGN cCustomisationInformation =  "Session Customisation Types:" + "~n":U + pcCustomisationTypes + "~n~n":U
           cAppserverInfo            = addToVariable(cAppserverInfo, cCustomisationInformation)
           .
    /* The References these resolve to. */
    ASSIGN cCustomisationInformation =  "Session Customisation Type References:" + "~n":U + pcCustomisationReferences + "~n~n":U
           cAppserverInfo            = addToVariable(cAppserverInfo, cCustomisationInformation)
           .
    /* The result codes these resolve to. */
    ASSIGN cCustomisationInformation =  "Session Customisation Result Codes:" + "~n":U + pcCustomisationResultCodes + "~n~n":U
           cAppserverInfo            = addToVariable(cAppserverInfo, cCustomisationInformation)
           .
    /* Go back to the top of the editor. */
    ASSIGN edAppServer:SCREEN-VALUE  = cAppserverInfo
           edAppserver:CURSOR-OFFSET = 1.

  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buttonAction gDialog 
PROCEDURE buttonAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piButton AS INTEGER.    
    ASSIGN piPressedButton = piButton.

    IF VALID-HANDLE (ghFillIn) THEN ASSIGN pcActualAnswer = ghFillIn:SCREEN-VALUE.
    APPLY "GO" TO FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject gDialog 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /* Clean up after ourselves. */
    whackTempTables().

    RUN SUPER.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME frButtons.
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  ENABLE edSystemInformation edAppserver edMessageSummary edMessageDetail 
         imAlert 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
  ENABLE btDefault 
      WITH FRAME frButtons.
  {&OPEN-BROWSERS-IN-QUERY-frButtons}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAppserverInfo gDialog 
PROCEDURE getAppserverInfo :
/*------------------------------------------------------------------------------
  Purpose:     Get Astra Appserver Information
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lRemote             AS LOGICAL  INITIAL NO      NO-UNDO.
    DEFINE VARIABLE cConnid             AS CHARACTER                NO-UNDO. /* SESSION:SERVER-CONNECTION-ID */
    DEFINE VARIABLE cOpmode             AS CHARACTER                NO-UNDO. /* SESSION:SERVER-OPERATING-MODE */
    DEFINE VARIABLE lConnreq            AS LOGICAL                  NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND-REQUEST */
    DEFINE VARIABLE lConnbnd            AS LOGICAL                  NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND */
    DEFINE VARIABLE cConnctxt           AS CHARACTER                NO-UNDO. /* SESSION:SERVER-CONNECTION-CONTEXT */
    DEFINE VARIABLE cASppath            AS CHARACTER                NO-UNDO. /* PROPATH */
    DEFINE VARIABLE cConndbs            AS CHARACTER                NO-UNDO. /* List of Databases */
    DEFINE VARIABLE cConnpps            AS CHARACTER                NO-UNDO. /* List of Running Persistent Procedures */
    DEFINE VARIABLE iLoop               AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cAppserverInfo      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hAsynch             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hHandle1            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hHandle2            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hHandle3            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hHandle4            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cCustomisationInfo  AS CHARACTER                NO-UNDO     EXTENT 3.

    IF VALID-HANDLE(gshAstraAppserver) AND CAN-QUERY(gshAstraAppserver, "connected":U) AND gshAstraAppserver:CONNECTED() THEN
    DO:
        /* First, check if this message information has been cached in the session manager */
        ASSIGN ghCacheBufferHandle = ?.

        IF VALID-HANDLE(gshSessionManager)
        AND LOOKUP("getMessageCacheHandle":U, gshSessionManager:INTERNAL-ENTRIES) <> 0 THEN
            RUN getMessageCacheHandle IN gshSessionManager (OUTPUT ghCacheBufferHandle).

        IF VALID-HANDLE(ghCacheBufferHandle) 
        THEN DO:
            ASSIGN hHandle1 = ghCacheBufferHandle:BUFFER-FIELD("hTableHandle1"):BUFFER-VALUE
                   hHandle2 = ghCacheBufferHandle:BUFFER-FIELD("hTableHandle2"):BUFFER-VALUE
                   hHandle3 = ghCacheBufferHandle:BUFFER-FIELD("hTableHandle3"):BUFFER-VALUE
                   hHandle4 = ghCacheBufferHandle:BUFFER-FIELD("hTableHandle4"):BUFFER-VALUE.

            RUN ASInfo IN THIS-PROCEDURE
                 (INPUT (ghCacheBufferHandle:BUFFER-FIELD("lRemote"):BUFFER-VALUE = "YES":U),
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cConnid"):BUFFER-VALUE,
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cOpmode"):BUFFER-VALUE,
                  INPUT (ghCacheBufferHandle:BUFFER-FIELD("lConnreg"):BUFFER-VALUE = "YES":U),
                  INPUT (ghCacheBufferHandle:BUFFER-FIELD("lConnbnd"):BUFFER-VALUE = "YES":U),
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cConntxt"):BUFFER-VALUE,
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cAsppath"):BUFFER-VALUE,
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cConndbs"):BUFFER-VALUE,
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cConnpps"):BUFFER-VALUE,
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cCustInfo1"):BUFFER-VALUE, /* Customisation types        */
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cCustInfo2"):BUFFER-VALUE, /* Customisation references   */
                  INPUT ghCacheBufferHandle:BUFFER-FIELD("cCustInfo3"):BUFFER-VALUE, /* Customisation Result Codes */
                  INPUT TABLE-HANDLE hHandle1,                                       /* TTParam                    */
                  INPUT TABLE-HANDLE hHandle2,                                       /* TTManager                  */
                  INPUT TABLE-HANDLE hHandle3,                                       /* TTServiceType              */
                  INPUT TABLE-HANDLE hHandle4                                        /* TTService                  */
                 ).
        END.
        ELSE DO:
            /* Not cached, retrieve the info from the Appserver */
            RUN af/app/afapppingp.p ON gshAstraAppserver
                ASYNCHRONOUS SET hAsynch
                EVENT-PROCEDURE "ASInfo":U
                ( OUTPUT lRemote,
                  OUTPUT cConnid,
                  OUTPUT cOpmode,
                  OUTPUT lConnreq,
                  OUTPUT lConnbnd,
                  OUTPUT cConnctxt,
                  OUTPUT cASppath,
                  OUTPUT cConndbs,
                  OUTPUT cConnpps,
                  OUTPUT cCustomisationInfo[1],
                  OUTPUT cCustomisationInfo[2],
                  OUTPUT cCustomisationInfo[3],
                  OUTPUT TABLE-HANDLE hHandle1,
                  OUTPUT TABLE-HANDLE hHandle2,
                  OUTPUT TABLE-HANDLE hHandle3,
                  OUTPUT TABLE-HANDLE hHandle4   ) NO-ERROR.
            WAIT-FOR PROCEDURE-COMPLETE OF hAsynch.
        END.
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHandles gDialog 
PROCEDURE getHandles :
/*------------------------------------------------------------------------------
  Purpose:     Gets the handles to the temp-tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
  DEFINE VARIABLE hHandle1 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle2 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle3 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle4 AS HANDLE     NO-UNDO.

  whackTempTables().

  IF lRemote THEN
  DO:
    RUN af/app/afcfminfop.p ON SERVER gshAstraAppServer 
      (OUTPUT TABLE-HANDLE hHandle1, 
       OUTPUT TABLE-HANDLE hHandle2, 
       OUTPUT TABLE-HANDLE hHandle3, 
       OUTPUT TABLE-HANDLE hHandle4).
  END.
  ELSE
  DO:
    RUN obtainCFMTables IN THIS-PROCEDURE (OUTPUT hHandle1, OUTPUT hHandle2).
    RUN obtainConnectionTables IN THIS-PROCEDURE (OUTPUT hHandle3, OUTPUT hHandle4).
  END.

  addHandle(hHandle1, "*").
  addHandle(hHandle2, "cManagerName,cFileName,cHandleName").
  addHandle(hHandle3, "cServiceType,cSTProcName").
  addHandle(hHandle4, "*").

  RUN loadCombo.
*/  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPatchLevel gDialog 
PROCEDURE getPatchLevel :
/*------------------------------------------------------------------------------
  Purpose:     Reads the Version file to see if there is a patch level
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER patchLevel AS CHARACTER NO-UNDO.

  DEFINE VARIABLE i        AS INTEGER             NO-UNDO.
  DEFINE VARIABLE dlcValue AS CHARACTER           NO-UNDO. /* DLC */
  DEFINE VARIABLE inp      AS CHARACTER           NO-UNDO. /* hold 1st line of version file */

  IF OPSYS = "Win32":U THEN /* Get DLC from Registry */
    GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE dlcValue.

  IF (dlcValue = "" OR dlcValue = ?) THEN DO:
    ASSIGN dlcValue = OS-GETENV("DLC":U). /* Get DLC from environment */
      IF (dlcValue = "" OR dlcValue = ?) THEN DO: /* Still nothing? */
        ASSIGN patchLevel = "".
        RETURN.
      END.
  END.
  FILE-INFO:FILE-NAME = dlcValue + "/version":U.
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO: /* Read the version file */
    INPUT FROM VALUE(FILE-INFO:FULL-PATHNAME).
      IMPORT UNFORMATTED inp. /* Get the first line */
    INPUT CLOSE.
    /* 
     * There are three types of version files (e.g.)
     *   PROGRESS version 9.1A as of Fri Apr 20 1999
     *   PROGRESS PATCH version 9.1A01 as of Fri Apr 20 1999
     *   PROGRESS UNOFFICIAL PATCH version 9.1A01 as of Fri Apr 20 1999
     */
    IF INDEX(inp,"PATCH":U) NE 0 THEN DO:
      /* If it's a patch, then we want the number */
      LEVEL:
      DO i = 2 TO NUM-ENTRIES(inp," ":U):
        IF ENTRY(i,inp," ") BEGINS PROVERSION THEN DO:
          ASSIGN patchLevel = REPLACE(ENTRY(i,inp," "),PROVERSION,"").
          LEAVE LEVEL.
        END.
      END.
    END.
  END.         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSystemInfo gDialog 
PROCEDURE getSystemInfo :
/*------------------------------------------------------------------------------
  Purpose:     Get information about the calling procedure and place into
               variables which are available to this entire program
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hParentWindow      AS HANDLE NO-UNDO.
    DEFINE VARIABLE hParentProcedure   AS HANDLE NO-UNDO.
    DEFINE VARIABLE cParentWindowTitle AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSystemInformation AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectInformation AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iLoop              AS INTEGER NO-UNDO.
    DEFINE VARIABLE cPatchLevel        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSite              AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDBList            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDBVersions        AS CHARACTER NO-UNDO.

    DEFINE VARIABLE hContainerTarget   AS HANDLE NO-UNDO.
    DEFINE VARIABLE cLinkHandles       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLogicalObject     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPhysicalObject    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLogicalVersion    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPhysicalVersion   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRunAttribute      AS CHARACTER NO-UNDO.

    DEFINE VARIABLE hHandle            AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cPP                AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cCustomisationInformation       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hCustomizationManager           AS HANDLE       NO-UNDO.

    DEFINE VARIABLE hTTParam            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hTTManager          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hTTServiceType      AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hTTService          AS HANDLE                   NO-UNDO.

    RUN GetPatchLevel(OUTPUT cPatchLevel). /* Read patch level from version file */

    /* Generate a list of running persistent procedures */
    hHandle = SESSION:FIRST-PROCEDURE.
    DO WHILE hHandle <> ?:
      IF hHandle:PERSISTENT THEN
        cPP = addToVariable(cPP, (IF cPP NE "" THEN ",":U ELSE "") + hHandle:FILE-NAME).

      hHandle = hHandle:NEXT-SIBLING.
    END.

    hParentWindow = FRAME {&FRAME-NAME}:PARENT.
    hParentProcedure = ghSourceProcedure.

    DEFINE VARIABLE cResources1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cResources2 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cProperties AS CHARACTER NO-UNDO.

    cProperties = DYNAMIC-FUNCTION("getPropertyList" IN gshSessionManager, "currentUserLogin,currentUserName,CurrentOrganisationName,CurrentProcessDate,dateFormat,currentLanguageName", NO).

    /* Get container and container-target versions if possible */
    ASSIGN cObjectInformation = "":U.
    IF VALID-HANDLE(phContainer) THEN
    DO:
      ASSIGN cPhysicalObject = phContainer:FILE-NAME.
      ASSIGN cPhysicalVersion = DYNAMIC-FUNCTION('getPhysicalVersion' IN phContainer) NO-ERROR.
      ASSIGN cLogicalObject = DYNAMIC-FUNCTION('getLogicalObjectName' IN phContainer) NO-ERROR.
      ASSIGN cLogicalVersion = DYNAMIC-FUNCTION('getLogicalVersion' IN phContainer) NO-ERROR.
      ASSIGN cRunAttribute = DYNAMIC-FUNCTION('getRunAttribute' IN phContainer) NO-ERROR.

      ASSIGN
        cObjectInformation = "Container Physical File    = ":U + notNull(cPhysicalObject) + "~n" +
                             "Container Physical Version = ":U + notNull(cPhysicalVersion) + "~n"
        . 
      IF cLogicalObject <> "":U THEN
        ASSIGN
          cObjectInformation = cObjectInformation +
                             "Container Logical File     = ":U + notNull(cLogicalObject) + "~n" +
                             "Container Logical Version  = ":U + notNull(cLogicalVersion) + "~n"
          . 
      ASSIGN
          cObjectInformation = cObjectInformation +
                             "Container Run Attribute    = ":U + notNull(cRunAttribute) + "~n"
          . 
      cLinkHandles = DYNAMIC-FUNCTION('linkHandles' IN phContainer, INPUT "container-target") NO-ERROR.
      target-loop:
      DO iLoop = 1 TO NUM-ENTRIES(cLinkHandles):
        hContainerTarget = WIDGET-HANDLE(ENTRY(iLoop,clinkHandles)).
        IF NOT VALID-HANDLE(hContainerTarget) THEN NEXT target-loop.

        ASSIGN
          cPhysicalObject = "":U
          cPhysicalVersion = "":U
          cLogicalObject = "":U
          cLogicalVersion = "":U
          .          
        ASSIGN cPhysicalObject = hContainerTarget:FILE-NAME.
        ASSIGN cPhysicalVersion = DYNAMIC-FUNCTION('getPhysicalVersion' IN hContainerTarget) NO-ERROR.
        ASSIGN cLogicalObject = DYNAMIC-FUNCTION('getLogicalObjectName' IN hContainerTarget) NO-ERROR.
        ASSIGN cLogicalVersion = DYNAMIC-FUNCTION('getLogicalVersion' IN hContainerTarget) NO-ERROR.

        ASSIGN
          cObjectInformation = cObjectInformation +
                               "Object Physical File       = ":U + notNull(cPhysicalObject) + "~n" +
                               "Object Physical Version    = ":U + notNull(cPhysicalVersion) + "~n"
          . 
        IF cLogicalObject <> "":U THEN
          ASSIGN
            cObjectInformation = cObjectInformation +
                               "Object Logical File        = ":U + notNull(cLogicalObject) + "~n" +
                               "Object Logical Version     = ":U + notNull(cLogicalVersion) + "~n"
            . 
      END.
    END.

    IF VALID-HANDLE(ghCacheBufferHandle) THEN /* would have been set in getAppserverInfo if we're running Appserver */
        ASSIGN cSite = ghCacheBufferHandle:BUFFER-FIELD("cSite":U):BUFFER-VALUE.
    ELSE
        RUN getSiteNumber IN gshGenManager (OUTPUT cSite).                                                    

    RUN af/sup/afwindsysp.p ( 
        OUTPUT cResources1,
        OUTPUT cResources2).

    cSystemInformation = "~n" + 

        "Window Title:               " + notNull(hParentWindow:TITLE)            + "~n" +
        "Site Number:                " + notNull(cSite)                          + "~n" +
        "User Login:                 " + notNull(ENTRY(1,cProperties,CHR(3)))    + "~n" +
        "User Name:                  " + notNull(ENTRY(2,cProperties,CHR(3)))    + "~n" + 
        "Organisation:               " + notNull(ENTRY(3,cProperties,CHR(3)))    + "~n" + 
        "Language:                   " + notNull(ENTRY(6,cProperties,CHR(3)))    + "~n" +     
        "Current Date/Time:          " + STRING(TODAY,"99/99/9999") + " at " + STRING(TIME,"HH:MM:SS") + "~n" + 
        "Process Date:               " + notNull(ENTRY(4,cProperties,CHR(3)))    + "~n" +                                                                  
        "Date Format:                " + notNull(ENTRY(5,cProperties,CHR(3)))    + "~n" +  
        "System Name:                " + notNull(?)                              + "~n" +
        "System Version:             " + notNull(?)                              + "~n" + 
        "Progress Version:           " + notNull(PROVERSION) + notNull(cPatchLevel) + "~n" + 
        "Progress License:           " + notNull(PROGRESS)                       + "~n" + 
        "Time Source:                " + notNull(SESSION:TIME-SOURCE)            + "~n" + 
        "Session Parameter:          " + notNull(SESSION:PARAMETER)              + "~n" +
        "Session DMY:                " + notNull(SESSION:DATE-FORMAT)            + "~n" +
        "Session Numeric Format:     " + notNull(SESSION:NUMERIC-FORMAT)         + "~n" +
        "Session Decimal Point:      " + notNull(SESSION:NUMERIC-DECIMAL-POINT)  + "~n" +
        "Session Numeric Separator:  " + notNull(SESSION:NUMERIC-SEPARATOR)      + "~n" +
        "Session Remote:             " + STRING(SESSION:REMOTE)                  + "~n" +   
        "Computer:                   " + notNull(cResources1)                    + "~n" +
        "Resources:                  " + notNull(cResources2)                    + "~n" +
        "Run From:                   " + "Procedure '" + notNull(ENTRY(1,PROGRAM-NAME(4)," ")) + "' in program " + notNull(ENTRY(2,PROGRAM-NAME(4)," ")) + "~n"
        .

    IF cObjectInformation <> "":U THEN
      ASSIGN
          cSystemInformation = addToVariable(cSystemInformation, "~n" + cObjectInformation).

    ASSIGN cDBList = "":U.
    DO iLoop = 1 TO NUM-DBS:
        ASSIGN cDBList = cDBList + (IF cDBList <> "":U THEN ",":U ELSE "":U) + LDBNAME(iLoop).
    END.

    IF cDBList <> "":U 
    THEN DO:
        IF VALID-HANDLE(ghCacheBufferHandle) THEN /* would have been set in getAppserverInfo if we're running Appserver */
            ASSIGN cDBVersions = ghCacheBufferHandle:BUFFER-FIELD("cDBVersions":U):BUFFER-VALUE.
        ELSE
            RUN getDBVersion IN gshGenManager (INPUT cDBList, OUTPUT cDBVersions).
    END.

    DO iLoop = 1 TO NUM-DBS:
        cSystemInformation = addToVariable(cSystemInformation, "~n" + "Database:       " + LDBNAME(iLoop)
                                                             + "~n" + "Delta Version:  " + ENTRY(iLoop, cDBVersions)
                                                             + "~n" + "Version:        " + DBVERSION(iLoop)
                                                             + "~n" + "Connect:        " + DBPARAM(iLoop) + "~n").
    END.         

    cSystemInformation = addToVariable(cSystemInformation, "~nPropath: ").
    DO iLoop = 1 TO NUM-ENTRIES(PROPATH):
       cSystemInformation = addToVariable(cSystemInformation, ENTRY(iLoop,PROPATH) + "~n         ").
    END.

    cSystemInformation = addToVariable(cSystemInformation, "~nPersistent Procedures: ").
    DO iLoop = 1 TO NUM-ENTRIES(cPP):
       cSystemInformation = addToVariable(cSystemInformation, ENTRY(iLoop,cPP) + "~n                       ").
    END.

    edSystemInformation:SCREEN-VALUE = cSystemInformation.

    /* Add data from the CONFIG manager */
    RUN obtainCFMTables        IN THIS-PROCEDURE (OUTPUT hTTParam, OUTPUT hTTManager).
    RUN obtainConnectionTables IN THIS-PROCEDURE (OUTPUT hTTServiceType, OUTPUT hTTService).

    DYNAMIC-FUNCTION("addHandle", INPUT hTTParam,       INPUT "*":U,                                  INPUT YES).
    DYNAMIC-FUNCTION("addHandle", INPUT hTTManager,     INPUT "cManagerName,cFileName,cHandleName":U, INPUT YES).
    DYNAMIC-FUNCTION("addHandle", INPUT hTTServiceType, INPUT "cServiceType,cSTProcName":U,           INPUT YES).
    DYNAMIC-FUNCTION("addHandle", INPUT hTTService,     INPUT "*":U,                                  INPUT YES).

    DYNAMIC-FUNCTION("DisplayConfigInfo", INPUT YES, INPUT edSystemInformation:HANDLE).

    /** Display relevant customisation information.
     *  ----------------------------------------------------------------------- **/
    ASSIGN cCustomisationInformation = "":U
           hCustomizationManager     = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, "CustomizationManager":U)
           NO-ERROR.
    IF VALID-HANDLE(hCustomizationManager) THEN
    DO:
        /* Display this information after the existing information. */
        cSystemInformation = edSystemInformation:SCREEN-VALUE.
        
        cSystemInformation = addToVariable(cSystemInformation, "~n~n":U).
        cSystemInformation = addToVariable(cSystemInformation, "Customisation Information" + "~n":U + FILL("=":U, 50) + "~n":U).

        /* Customisation Types */
        ASSIGN cCustomisationInformation  =  "Session Customisation Types:" + "~n":U
               cCustomisationInformation  = cCustomisationInformation + DYNAMIC-FUNCTION("getCustomisationTypesPrioritised":U IN hCustomizationManager) + "~n~n":U
               cSystemInformation         = addToVariable(cSystemInformation, cCustomisationInformation)
               .
        /* The References these resolve to. */
        ASSIGN cCustomisationInformation  =  "Session Customisation Type References:" + "~n":U
               cCustomisationInformation  = cCustomisationInformation + DYNAMIC-FUNCTION("getSessionCustomisationReferences":U IN hCustomizationManager) + "~n~n":U
               cSystemInformation         = addToVariable(cSystemInformation, cCustomisationInformation)
               .
        /* The result codes these resolve to. */
        ASSIGN cCustomisationInformation  =  "Session Customisation Result Codes:" + "~n":U
               cCustomisationInformation  = cCustomisationInformation + DYNAMIC-FUNCTION("getSessionResultCodes":U IN hCustomizationManager) + "~n~n":U
               cSystemInformation         = addToVariable(cSystemInformation, cCustomisationInformation)
               .
    END.    /* valid customisation manager */

    /* Go back to the top of the editor. */
    ASSIGN edSystemInformation:SCREEN-VALUE  = cSystemInformation
           edSystemInformation:CURSOR-OFFSET = 1.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}: END.

  DEFINE VARIABLE cDefaultTitle   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dMinHeight      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMinWidth       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE idx             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hPreviousButton AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWidget         AS HANDLE     NO-UNDO.

  /* message dialog does not require security - so set object secured to true
     to avoid appserver hits to check for security on it
  */
  {set ObjectSecured TRUE} NO-ERROR.

  /* load the alert image */
  ASSIGN
      piDefaultButton = IF piDefaultButton <> 0 THEN piDefaultButton ELSE 1 /* set the default return used if the user presses X in the dialog */
      piPressedButton = IF piCancelButton  <> 0 THEN piCancelButton  ELSE piDefaultButton
      glQuestion      = (pcMessageType = "QUE")
      glInformation   = (pcMessageType = "INF")
      glAbout         = (pcMessageType = "ABO").

  CASE pcMessageType:
      WHEN "ABO" THEN DO: imAlert:LOAD-IMAGE("adeicon/icfdev.ico").    cDefaultTitle = "About Application". END.
      WHEN "MES" THEN DO: imAlert:LOAD-IMAGE("ry/img/afinfo.gif").     cDefaultTitle = "Message".           END.
      WHEN "INF" THEN DO: imAlert:LOAD-IMAGE("ry/img/afinfo.gif").     cDefaultTitle = "Information".       END.
      WHEN "WAR" THEN DO: imAlert:LOAD-IMAGE("ry/img/afwarning.gif").  cDefaultTitle = "Warning".           END.
      WHEN "ERR" THEN DO: imAlert:LOAD-IMAGE("ry/img/afinfo.gif").     cDefaultTitle = "Error".             END.
      WHEN "HAL" THEN DO: imAlert:LOAD-IMAGE("ry/img/aferror.gif").    cDefaultTitle = "Error".             END.
      WHEN "QUE" THEN DO: imAlert:LOAD-IMAGE("ry/img/afquestion.gif"). cDefaultTitle = "Question".          END.
  END CASE.

  /* set the title */
  IF pcDialogTitle <> "" AND pcDialogTitle <> ? THEN
    FRAME {&FRAME-NAME}:TITLE = pcDialogTitle.
  ELSE
    FRAME {&FRAME-NAME}:TITLE = cDefaultTitle.

  /* do we need a fillin field? */

  IF pcMessageType = "QUE" AND pcAnswerDataType <> "" THEN
  DO:
    IF LOOKUP(pcAnswerDataType,"LOGICAL,CHARACTER,INTEGER,DECIMAL,DATE") = 0 THEN
      pcAnswerDataType = "CHARACTER".

    CREATE TEXT ghLabel
    ASSIGN FRAME        = FRAME {&FRAME-NAME}:HANDLE
           HIDDEN       = FALSE
           WIDTH        = FONT-TABLE:GET-TEXT-WIDTH("Response:")
           FORMAT       = "x(25)"
           SCREEN-VALUE = "Response:"
           COL          = 13
           ROW          = 1 + 0.07.

    CREATE FILL-IN ghFillIn
    ASSIGN FRAME             = FRAME {&FRAME-NAME}:HANDLE
           HEIGHT            = 1
           ROW               = 1 + 0.07
           SIDE-LABEL-HANDLE = ghLabel
           COL               = 13 + FONT-TABLE:GET-TEXT-WIDTH("Response: ")
           WIDTH             = edMessageSummary:WIDTH - ghLabel:COL + 1
           HIDDEN            = FALSE
           SENSITIVE         = TRUE
           DATA-TYPE         = pcAnswerDataType.

    IF pcAnswerFormat <> "" THEN
      ghFillIn:FORMAT = pcAnswerFormat.

    ghFillIn:SCREEN-VALUE = pcDefaultAnswer.
  END.

  /* build up the buttons in the button frame */
  DO idx = 1 TO NUM-ENTRIES(pcButtonLabelList):    
    IF idx = piDefaultButton THEN
      hWidget = btDefault:HANDLE IN FRAME frButtons.
    ELSE
      IF idx = piCancelButton THEN
        hWidget = btCancel:HANDLE IN FRAME frButtons.
      ELSE
      DO: 
        CREATE BUTTON hWidget
        ASSIGN FRAME = FRAME frButtons:HANDLE                    
        TRIGGERS:
          ON CHOOSE PERSISTENT RUN buttonAction(idx).
        END TRIGGERS.
      END.

    ASSIGN
        hWidget:LABEL     = ENTRY(idx, pcButtonLabelList)
        hWidget:WIDTH     = 15
        hWidget:HEIGHT    = 1.14
        hWidget:ROW       = 1
        hWidget:COL       = (idx - 1) * 16 + 1
        hWidget:HIDDEN    = FALSE
        hWidget:SENSITIVE = TRUE.

/*             IF idx = piDefaultButton THEN ASSIGN FRAME {&FRAME-NAME}:DEFAULT-BUTTON = hWidget. */

        dMinWidth = MAX(dMinWidth, hWidget:COLUMN + hWidget:WIDTH - 1).
        dMinHeight = MAX(dMinHeight, hWidget:HEIGHT). 
    
    IF (idx = 1 AND piDefaultButton = 0) OR (idx = piDefaultButton) THEN
      ghFocusButton = hWidget.

    IF VALID-HANDLE(hPreviousButton) THEN
      hWidget:MOVE-AFTER-TAB-ITEM(hPreviousButton).

    hPreviousButton = hWidget.           
  END.

  ASSIGN
      FRAME frButtons:VIRTUAL-HEIGHT = dMinHeight
      FRAME frButtons:VIRTUAL-WIDTH  = dMinWidth
      FRAME frButtons:HEIGHT         = dMinHeight
      FRAME frButtons:WIDTH          = dMinWidth
      edMessageSummary:SCREEN-VALUE  = "~n" + REPLACE(pcMessageSummaryList, CHR(3), "~n~n")
      edMessageDetail:SCREEN-VALUE   = "~n" + REPLACE(pcMessageDetailList,  CHR(3), "~n~n").    

  IF NOT glQuestion AND NOT glInformation THEN
  DO:
    RUN getAppserverInfo.
    RUN getSystemInfo.
  END.

  {set HideOnInit YES}.

  RUN postCreateObjects.

  IF glQuestion OR glInformation THEN
    DYNAMIC-FUNCTION("setUserProperty":U IN h_afspfoldrw, "DoNotShow":U, "yes":U).
  
  RUN initializeObject IN h_afspfoldrw.

  /* Question */

  IF glQuestion OR glInformation THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        btMail:HIDDEN               = TRUE
        btStack:HIDDEN              = TRUE
        edMessageDetail:HIDDEN      = TRUE
        edSystemInformation:HIDDEN  = TRUE        
        edAppserver:HIDDEN          = TRUE        
        btFullScreen:HIDDEN         = TRUE
        edMessageSummary:FONT       = ?
        btStack:ROW                 = btMail:ROW
        btFullScreen:ROW            = btMail:ROW.

    edMessageSummary:MOVE-TO-EOF().
    
    ASSIGN
        edMessageSummary:HEIGHT     = MIN(edMessageSummary:HEIGHT, edMessageSummary:CURSOR-LINE * FONT-TABLE:GET-TEXT-HEIGHT(edMessageSummary:FONT))
        edMessageDetail:HEIGHT      = edMessageSummary:HEIGHT
        edSystemInformation:HEIGHT  = edMessageSummary:HEIGHT
        edAppserver:HEIGHT          = edMessageSummary:HEIGHT.

    RUN reorganize (INPUT FRAME {&FRAME-NAME}:WIDTH,
                    INPUT MAX(edMessageSummary:HEIGHT + 4,
                    INPUT btFullScreen:ROW + (IF VALID-HANDLE(ghFillIn) THEN ghFillIn:HEIGHT + 0.24 ELSE 0) + 1.14 + 0.24 + 0.16), YES).
  END.
  ELSE
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        btMail:HIDDEN           = FALSE
        btStack:HIDDEN          = FALSE
        btFullScreen:HIDDEN     = FALSE
        btMail:SENSITIVE        = TRUE
        btStack:SENSITIVE       = TRUE
        btFullScreen:SENSITIVE  = TRUE.

    edMessageSummary:MOVE-TO-EOF().

    RUN reorganize (INPUT FRAME {&FRAME-NAME}:WIDTH,
                    INPUT MAX(edMessageSummary:HEIGHT + 4,
                    INPUT btFullScreen:ROW + btStack:HEIGHT + 0.24 + 0.16), YES).
  END.

  IF NOT glQuestion THEN
    RUN selectPage(1).

  RUN SUPER.

  IF NOT (glQuestion OR glInformation) THEN
    RUN viewObject IN h_afspfoldrw.
  ELSE
    RUN hideObject IN h_afspfoldrw.

  IF NOT glQuestion AND NOT glInformation THEN
    btStack:HIDDEN = NOT SESSION:DEBUG-ALERT.

  IF glabout THEN
    RUN disableFolderPage IN h_afspfoldrw (2).

  VIEW FRAME {&FRAME-NAME}.

  IF VALID-HANDLE(ghFillIn) THEN
    APPLY "ENTRY":U TO ghFillIn.
  ELSE
    IF btDefault:SENSITIVE THEN
      APPLY "ENTRY":U TO btDefault.
  
  /* Move the cursor to the first line, so the message displays from top to bottom... */
  ASSIGN edMessageSummary:CURSOR-OFFSET = 1
         edMessageDetail:CURSOR-OFFSET  = 1
         NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects gDialog 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.

  /* First, check if this message information has been cached in the session manager */
  ASSIGN ghCacheBufferHandle = ?.

  IF VALID-HANDLE(gshSessionManager)
  AND LOOKUP("getMessageCacheHandle":U, gshSessionManager:INTERNAL-ENTRIES) <> 0 
  THEN DO:
      RUN getMessageCacheHandle IN gshSessionManager (OUTPUT ghCacheBufferHandle).
      IF VALID-HANDLE(ghCacheBufferHandle) THEN
          ghCacheBufferHandle:FIND-FIRST() NO-ERROR.
  END.

  IF VALID-HANDLE(ghCacheBufferHandle)
  AND ghCacheBufferHandle:AVAILABLE
  THEN DO:
      {fnarg setPopupSelectionEnabled "ghCacheBufferHandle:BUFFER-FIELD('lPopupSelectionEnabled'):BUFFER-VALUE" h_afspfoldrw}.
      {fnarg setTabVisualization      "ghCacheBufferHandle:BUFFER-FIELD('cTabVisualization'):BUFFER-VALUE"      h_afspfoldrw}.
      {fnarg setTabPosition           "ghCacheBufferHandle:BUFFER-FIELD('cTabPosition'):BUFFER-VALUE"           h_afspfoldrw}.
  END.
  ELSE DO:
      /* Fetch the repository class*/
      hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, "SmartFolder":U).

      IF VALID-HANDLE(hClassBuffer) THEN
        hAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   

      IF VALID-HANDLE(hAttributeBuffer) THEN
      DO:
        hAttributeBuffer:BUFFER-CREATE().

        {fnarg setPopupSelectionEnabled "hAttributeBuffer:BUFFER-FIELD('PopupSelectionEnabled'):BUFFER-VALUE" h_afspfoldrw}.
        {fnarg setTabVisualization      "hAttributeBuffer:BUFFER-FIELD('TabVisualization'):BUFFER-VALUE"      h_afspfoldrw}.
        {fnarg setTabPosition           "hAttributeBuffer:BUFFER-FIELD('TabPosition'):BUFFER-VALUE"           h_afspfoldrw}.

        hAttributeBuffer:BUFFER-DELETE().
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reorganize gDialog 
PROCEDURE reorganize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER dNewWidth  AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER dNewHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER plCentre   AS LOGICAL NO-UNDO.

  DEFINE VARIABLE dButtonFrameColumn  AS DECIMAL  NO-UNDO.                            
  DEFINE VARIABLE dButtonFrameRow     AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dEditorHeight       AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dEditorWidth        AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dFolderHeight       AS DECIMAL  NO-UNDO.    
  DEFINE VARIABLE dFolderWidth        AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dFolderRow          AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dFolderCol          AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dRow                AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dCol                AS DECIMAL  NO-UNDO.

  ASSIGN
      FRAME {&FRAME-NAME}:SCROLLABLE = FALSE
      FRAME {&FRAME-NAME}:HEIGHT     = MAX(dNewHeight, FRAME {&FRAME-NAME}:HEIGHT)
      FRAME {&FRAME-NAME}:WIDTH      = MAX(dNewWidth,  FRAME {&FRAME-NAME}:WIDTH).
  
  DO WITH FRAME {&FRAME-NAME}: END.

  ASSIGN
      dButtonFrameColumn     = dNewWidth - FRAME frButtons:WIDTH - 1
      dButtonFrameRow        = dNewHeight - FRAME frButtons:HEIGHT - 0.24 - 0.26 - 0.2 /* added extra 0.2 to fix XP errors */

      FRAME frButtons:COLUMN = (IF dButtonFrameColumn >= 1 THEN dButtonFrameColumn ELSE 1) - 1.00
      FRAME frButtons:ROW    = (IF dButtonFrameRow    >= 1 THEN dButtonFrameRow    ELSE 1).

  IF glQuestion OR glInformation THEN
  DO:
    ASSIGN    
        edSystemInformation:ROW    = 1.24
        edMessageSummary:ROW       = edSystemInformation:ROW
        edMessageDetail:ROW        = edSystemInformation:ROW
        edAppserver:ROW            = edSystemInformation:ROW

        edMessageSummary:WIDTH = dNewWidth - edMessageSummary:COL - 1.

    IF VALID-HANDLE(ghFillIn) THEN
      ASSIGN
          dRow           = dButtonFrameRow - ghFillIn:HEIGHT - 0.24
          ghFillIn:ROW   = (IF dRow >= 1 THEN dRow ELSE 1)
          ghFillIn:WIDTH = edMessageSummary:WIDTH - ghLabel:COL + 1
          dRow           = ghFillIn:ROW + 0.12
          ghLabel:ROW    = (IF dRow >= 1 THEN dRow ELSE 1).

    dNewHeight = IF dNewHeight <= 5.5 THEN 5.5 ELSE dNewHeight. /* This should be the minumum height of the window */
  END.
  ELSE
  DO:
    ASSIGN  
        dFolderWidth  = dNewWidth - 11 - 1
        dFolderHeight = FRAME frButtons:ROW - 1.24 - 0.24.

    RUN resizeObject IN h_afspfoldrw (INPUT dFolderHeight,
                                      INPUT dFolderWidth).

    RUN getClientRectangle IN h_afspfoldrw (OUTPUT dFolderCol,
                                            OUTPUT dFolderRow,
                                            OUTPUT dEditorWidth,
                                            OUTPUT dEditorHeight).

    ASSIGN  
        dEditorHeight              = dEditorHeight - 0.40
        dEditorWidth               = dEditorWidth  - 1.00

        edSystemInformation:ROW    = dFolderRow + 0.12
        edMessageSummary:ROW       = edSystemInformation:ROW
        edMessageDetail:ROW        = edSystemInformation:ROW
        edAppserver:ROW            = edSystemInformation:ROW

        edSystemInformation:HEIGHT = dEditorHeight
        edMessageSummary:HEIGHT    = dEditorHeight
        edMessageDetail:HEIGHT     = dEditorHeight
        edAppserver:HEIGHT         = dEditorHeight

        edSystemInformation:WIDTH  = dEditorWidth
        edMessageSummary:WIDTH     = dEditorWidth
        edMessageDetail:WIDTH      = dEditorWidth
        edAppserver:WIDTH          = dEditorWidth

        dNewHeight                 = IF dNewHeight <= 8.25 THEN 8.25 ELSE dNewHeight. /* This should be the minumum height of the window */
  END.

  ASSIGN
      FRAME {&FRAME-NAME}:HEIGHT = dNewHeight
      FRAME {&FRAME-NAME}:WIDTH  = dNewWidth.

  IF glabout THEN
    RUN disableFolderPage IN h_afspfoldrw (2).

  IF NOT plCentre THEN RETURN.

  /* Centre the frame */
  DEFINE VARIABLE hParent AS HANDLE NO-UNDO.

  hParent = FRAME {&FRAME-NAME}:PARENT.

  ASSIGN
      dRow = MAXIMUM(1,(SESSION:HEIGHT - FRAME {&FRAME-NAME}:HEIGHT) / 2) - hParent:ROW
      dCol = MAXIMUM(1,(SESSION:WIDTH  - FRAME {&FRAME-NAME}:WIDTH)  / 2) - hParent:COLUMN.

  /* If the row or column wound up being between 0 and 1 after the 
     calculation, change it, because otherwise Progress will complain. */
  IF dRow >=  0 AND dRow < 1 THEN dRow =  1.
  IF dCol >=  0 AND dCol < 1 THEN dCol =  1.
  IF dRow >= -1 AND dRow < 0 THEN dRow = -1.
  IF dCol >= -1 AND dCol < 0 THEN dCol = -1.

  ASSIGN        
      FRAME {&FRAME-NAME}:ROW    = dRow
      FRAME {&FRAME-NAME}:COLUMN = dCol.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator gDialog 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "af\sup2\afspfoldrw.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage gDialog 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNumber AS INTEGER.

  RUN SUPER(piPageNumber).

  /* giPageNumber = piPageNumber. */
  DO WITH FRAME {&FRAME-NAME}: END.

  edMessageDetail:HIDDEN      = (piPageNumber <> 2).
  edMessageSummary:HIDDEN     = (piPageNumber <> 1).
  edSystemInformation:HIDDEN  = (piPageNumber <> 3).
  edAppserver:HIDDEN          = (piPageNumber <> 4).

  IF NOT edMessageDetail:HIDDEN THEN edMessageDetail:MOVE-TO-TOP().
  IF NOT edMessageSummary:HIDDEN THEN edMessageSummary:MOVE-TO-TOP().
  IF NOT edSystemInformation:HIDDEN THEN edSystemInformation:MOVE-TO-TOP().
  IF NOT edAppserver:HIDDEN THEN edSystemInformation:MOVE-TO-TOP().
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addHandle gDialog 
FUNCTION addHandle RETURNS LOGICAL
    ( INPUT phHandle        AS HANDLE,
      INPUT pcFieldList     AS CHARACTER,
      INPUT plLocalSession  AS LOGICAL      ) :
/*------------------------------------------------------------------------------
  Purpose:  Adds a handle to the temp-table. 
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE BUFFER ttHandle      FOR ttHandle.

    DO TRANSACTION:
        CREATE ttHandle.
        ASSIGN ttHandle.cHandle       = phHandle:NAME
               ttHandle.hHandle       = phHandle
               ttHandle.cFieldList    = pcFieldList
               ttHandle.lLocalSession = plLocalSession
               .
    END.    /* transaction */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addToVariable gDialog 
FUNCTION addToVariable RETURNS CHARACTER
  (pcCurrentText  AS CHARACTER,
   pcText         AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function will add text to a variable and ensure that it does not
            blow the character variable limit. Strangely, I thought we should be
            able to get away with 32000 characters but I had to trim it down to
            28000 characters else we ended up with errors.
    Notes:  
------------------------------------------------------------------------------*/
                                              /* ---- This is the number of characters we can add ----- */
  RETURN pcCurrentText + SUBSTRING(pcText, 1, MAX(0, MIN((17500 - LENGTH(pcCurrentText)), LENGTH(pcText)))).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION DisplayConfigInfo gDialog 
FUNCTION DisplayConfigInfo RETURNS LOGICAL
    ( INPUT plLocalSession      AS LOGICAL,
      INPUT phDisplayWidget     AS HANDLE       ) :
/*------------------------------------------------------------------------------
  Purpose:  This function displays information from the Config and Connection Managers.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cWidgetValue        AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE hQuery              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hBuffer             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hField              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE iCount              AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cDisplayValue       AS CHARACTER                    NO-UNDO.

    DEFINE BUFFER ttHandle          FOR ttHandle.

    /* Display this information after the existing information. */
    cWidgetValue = phDisplayWidget:SCREEN-VALUE.
    
    cWidgetValue = addToVariable(cWidgetValue, "~n~n":U).
    cWidgetValue = addToVariable(cWidgetValue, "Session Configuration Information" + "~n":U + FILL("=":U, 50) + "~n":U).

    FOR EACH ttHandle WHERE
             ttHandle.lLocalSession = plLocalSession
             NO-LOCK:
        EMPTY TEMP-TABLE ttField.
        
        CREATE BUFFER hBuffer FOR TABLE ttHandle.hHandle:DEFAULT-BUFFER-HANDLE.

        CASE hbuffer:NAME:
            WHEN "ttParam":U       THEN cWidgetValue = addToVariable(cWidgetValue, "Session Parameters and Properties" + "~n":U + FILL("-":U, 50) + "~n":U).
            WHEN "ttManager":U     THEN cWidgetValue = addToVariable(cWidgetValue, "Managers started via the Configuration File Manager" + "~n":U + FILL("-":U, 50) + "~n":U).
            WHEN "ttService":U     THEN cWidgetValue = addToVariable(cWidgetValue, "Services Registered with the Connection Manager" + "~n":U + FILL("-":U, 50) + "~n":U).
            WHEN "ttServiceType":U THEN cWidgetValue = addToVariable(cWidgetValue, "Service Types" + "~n":U + FILL("-":U, 50) + "~n":U).
        END CASE.   /* hbuffer:name */

        DO iCount = 1 TO hBuffer:NUM-FIELDS:
            ASSIGN hField = hBuffer:BUFFER-FIELD(iCount).
            IF CAN-DO(ttHandle.cFieldList, hField:NAME) THEN
            DO:
                CREATE ttField.
                ASSIGN ttField.tFieldHandle = hField
                       ttField.tFieldLabel  = hField:LABEL
                       .
            END.    /* CAN-DO field */
        END.    /* iCount */

        CREATE QUERY hQuery.
        hQuery:ADD-BUFFER(hBuffer).
        hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME).

        hQuery:QUERY-OPEN().
        hQuery:GET-FIRST(NO-LOCK).
        
        DO WHILE hBuffer:AVAILABLE:
            FOR EACH ttField:
                ASSIGN cDisplayValue = TRIM(notNull(ttField.tFieldHandle:BUFFER-VALUE)).

                cWidgetValue = addToVariable(cWidgetValue, STRING(ttField.tFieldLabel + ":":U, "x(28)":U)).
                cWidgetValue = addToVariable(cWidgetValue, STRING(cDisplayValue, "x(70)":U) + "~n":U).
            END.    /* each field */
            /* Skip a line after each record. */
            cWidgetValue = addToVariable(cWidgetValue, "~n":U).
            
            hQuery:GET-NEXT(NO-LOCK).
        END.    /* avail buffer */

        hQuery:QUERY-CLOSE().

        DELETE OBJECT hQuery NO-ERROR.
        ASSIGN hQuery = ?.

        DELETE OBJECT hBuffer NO-ERROR.
        ASSIGN hBuffer = ?.
    END.    /* each ttHandle. */

    /* Go back to the top of the editor. */
    ASSIGN phDisplayWidget:SCREEN-VALUE  = cWidgetValue
           phDisplayWidget:CURSOR-OFFSET = 1.

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION notNull gDialog 
FUNCTION notNull RETURNS CHARACTER
  ( cValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN (IF cValue = ? THEN "?" ELSE cValue).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION whackTempTables gDialog 
FUNCTION whackTempTables RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hTT             AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE cList           AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cHandle         AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE hBuffer         AS HANDLE                           NO-UNDO.
    
    DEFINE BUFFER bttHandle FOR ttHandle.
    
    /* Build up a list of the temp-tables in the session widget pool as these
     will have come across from the AppServer */
    ASSIGN hBuffer = SESSION:FIRST-BUFFER.

    /* Walk through the list of buffers that belong to Dynamic Temp Tables*/
    do-ltt:
    DO WHILE VALID-HANDLE(hBuffer) AND VALID-HANDLE(hBuffer:TABLE-HANDLE):
        /* Convert the handle to a string */
        cHandle = STRING(hBuffer:TABLE-HANDLE).

        /* If the handle is not in cList, add it */
        IF NOT CAN-DO(cList,cHandle) THEN
            ASSIGN cList = cList + (IF cList = "" THEN "" ELSE ",") + cHandle.

        /* Go on to the next Buffer */
        ASSIGN hBuffer = hBuffer:NEXT-SIBLING.
    END.
    
    /* Now we have a list of all the dynamic temp-tables */
    
    /* Go through the table that contains the handles to the tables and if 
     the temp-table handle is in the list of temp-tables we created above,
     whack the whole temp-table, otherwise we have a memory leak */
    FOR EACH bttHandle:
        ASSIGN hTT = bttHandle.hHandle.
        IF VALID-HANDLE(hTT)         AND
           CAN-DO(cList,STRING(hTT)) THEN
            DELETE OBJECT hTT.

        DELETE bttHandle. /* Delete the record from the bttHandle table */
    END.

    RETURN TRUE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

