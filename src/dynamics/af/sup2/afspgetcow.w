&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

&IF DEFINED(UIB_is_Running) NE 0
&THEN
    DEFINE VARIABLE cpColor  AS CHARACTER NO-UNDO INITIAL "GrayText".
    DEFINE VARIABLE lpResult AS LOGICAL   NO-UNDO.
&ELSE
    DEFINE INPUT-OUTPUT PARAMETER cpColor AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER lpResult AS LOGICAL NO-UNDO.
&ENDIF
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE result AS LOGICAL NO-UNDO.

DEFINE VARIABLE vSelection AS CHARACTER NO-UNDO.
DEFINE VARIABLE ghSourceProc AS HANDLE     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS cb-list sl-colour Btn_OK Btn_Cancel tg-ctn ~
real-0 real-1 real-10 real-11 real-12 real-13 real-14 real-15 real-16 ~
real-17 real-18 real-19 real-2 real-20 real-21 real-22 real-23 real-24 ~
real-25 real-26 real-27 real-28 real-29 real-3 real-30 real-31 real-32 ~
real-33 real-34 real-35 real-36 real-37 real-38 real-39 real-4 real-40 ~
real-41 real-42 real-43 real-44 real-45 real-46 real-47 real-5 real-6 ~
real-7 real-8 real-9 real-colour 
&Scoped-Define DISPLAYED-OBJECTS cb-list sl-colour tg-ctn txt-unknown 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Select" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cb-list AS CHARACTER FORMAT "X(256)":U INITIAL "<Default>" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Default","Black","Blue","Green","Cyan","Red","Magenta","DarkYellow","DarkGrey","LightGrey","LightBlue","LightGreen","LightCyan","LightRed","LightMagenta","Yellow","White" 
     DROP-DOWN-LIST
     SIZE 69 BY 1 NO-UNDO.

DEFINE VARIABLE txt-unknown AS CHARACTER FORMAT "X(256)":U INITIAL "?" 
      VIEW-AS TEXT 
     SIZE 2.2 BY .71 NO-UNDO.

DEFINE RECTANGLE real-0
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "0"
     BGCOLOR 0 FGCOLOR 0 .

DEFINE RECTANGLE real-1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "1"
     BGCOLOR 1 FGCOLOR 1 .

DEFINE RECTANGLE real-10
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "10"
     BGCOLOR 10 .

DEFINE RECTANGLE real-11
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "11"
     BGCOLOR 11 .

DEFINE RECTANGLE real-12
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "12"
     BGCOLOR 12 .

DEFINE RECTANGLE real-13
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "13"
     BGCOLOR 13 .

DEFINE RECTANGLE real-14
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "14"
     BGCOLOR 14 .

DEFINE RECTANGLE real-15
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "15"
     BGCOLOR 15 .

DEFINE RECTANGLE real-16
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "16"
     BGCOLOR 16 FGCOLOR 16 .

DEFINE RECTANGLE real-17
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "17"
     BGCOLOR 17 FGCOLOR 1 .

DEFINE RECTANGLE real-18
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "18"
     BGCOLOR 18 .

DEFINE RECTANGLE real-19
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "19"
     BGCOLOR 19 .

DEFINE RECTANGLE real-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "2"
     BGCOLOR 2 .

DEFINE RECTANGLE real-20
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "20"
     BGCOLOR 20 .

DEFINE RECTANGLE real-21
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "21"
     BGCOLOR 21 .

DEFINE RECTANGLE real-22
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "22"
     BGCOLOR 22 .

DEFINE RECTANGLE real-23
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "23"
     BGCOLOR 23 .

DEFINE RECTANGLE real-24
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "24"
     BGCOLOR 24 .

DEFINE RECTANGLE real-25
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "25"
     BGCOLOR 25 .

DEFINE RECTANGLE real-26
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "26"
     BGCOLOR 26 .

DEFINE RECTANGLE real-27
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "27"
     BGCOLOR 27 .

DEFINE RECTANGLE real-28
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "28"
     BGCOLOR 28 .

DEFINE RECTANGLE real-29
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "29"
     BGCOLOR 29 .

DEFINE RECTANGLE real-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "3"
     BGCOLOR 3 .

DEFINE RECTANGLE real-30
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "30"
     BGCOLOR 30 .

DEFINE RECTANGLE real-31
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "31"
     BGCOLOR 31 .

DEFINE RECTANGLE real-32
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "32"
     BGCOLOR 32 .

DEFINE RECTANGLE real-33
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "33"
     BGCOLOR 33 .

DEFINE RECTANGLE real-34
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "34"
     BGCOLOR 34 .

DEFINE RECTANGLE real-35
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "35"
     BGCOLOR 35 .

DEFINE RECTANGLE real-36
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "36"
     BGCOLOR 36 .

DEFINE RECTANGLE real-37
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "37"
     BGCOLOR 37 .

DEFINE RECTANGLE real-38
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "38"
     BGCOLOR 38 .

DEFINE RECTANGLE real-39
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "39"
     BGCOLOR 39 .

DEFINE RECTANGLE real-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "4"
     BGCOLOR 4 .

DEFINE RECTANGLE real-40
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "40"
     BGCOLOR 40 .

DEFINE RECTANGLE real-41
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "41"
     BGCOLOR 41 .

DEFINE RECTANGLE real-42
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "42"
     BGCOLOR 42 .

DEFINE RECTANGLE real-43
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "43"
     BGCOLOR 43 .

DEFINE RECTANGLE real-44
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "44"
     BGCOLOR 44 .

DEFINE RECTANGLE real-45
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "45"
     BGCOLOR 45 .

DEFINE RECTANGLE real-46
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "46"
     BGCOLOR 46 .

DEFINE RECTANGLE real-47
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "47"
     BGCOLOR 47 .

DEFINE RECTANGLE real-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "5"
     BGCOLOR 5 .

DEFINE RECTANGLE real-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "6"
     BGCOLOR 6 .

DEFINE RECTANGLE real-7
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "7"
     BGCOLOR 7 .

DEFINE RECTANGLE real-8
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "8"
     BGCOLOR 8 .

DEFINE RECTANGLE real-9
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 1 TOOLTIP "9"
     BGCOLOR 9 .

DEFINE RECTANGLE real-colour
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.6 BY 2.29.

DEFINE VARIABLE sl-colour AS INTEGER INITIAL ? 
     VIEW-AS SLIDER MIN-VALUE -1 MAX-VALUE 255 HORIZONTAL 
     TIC-MARKS BOTTOM FREQUENCY 5
     SIZE 60.6 BY 2.38 NO-UNDO.

DEFINE VARIABLE tg-ctn AS LOGICAL INITIAL yes 
     LABEL "Return &Color Table No." 
     VIEW-AS TOGGLE-BOX
     SIZE 25.6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     cb-list AT ROW 1.19 COL 2 NO-LABEL
     sl-colour AT ROW 2.52 COL 11.6 NO-LABEL
     Btn_OK AT ROW 11.52 COL 2
     Btn_Cancel AT ROW 11.52 COL 17.2
     tg-ctn AT ROW 11.81 COL 45.2
     txt-unknown AT ROW 2.43 COL 9.8 COLON-ALIGNED NO-LABEL
     real-0 AT ROW 5.19 COL 2
     real-1 AT ROW 5.19 COL 10.6
     real-10 AT ROW 6.19 COL 19.2
     real-11 AT ROW 6.19 COL 27.8
     real-12 AT ROW 6.19 COL 36.4
     real-13 AT ROW 6.19 COL 45
     real-14 AT ROW 6.19 COL 53.6
     real-15 AT ROW 6.19 COL 62.2
     real-16 AT ROW 7.19 COL 2
     real-17 AT ROW 7.19 COL 10.6
     real-18 AT ROW 7.19 COL 19.2
     real-19 AT ROW 7.19 COL 27.8
     real-2 AT ROW 5.19 COL 19.2
     real-20 AT ROW 7.19 COL 36.4
     real-21 AT ROW 7.19 COL 45
     real-22 AT ROW 7.19 COL 53.6
     real-23 AT ROW 7.19 COL 62.2
     real-24 AT ROW 8.19 COL 2
     real-25 AT ROW 8.19 COL 10.6
     real-26 AT ROW 8.19 COL 19.2
     real-27 AT ROW 8.19 COL 27.8
     real-28 AT ROW 8.19 COL 36.4
     real-29 AT ROW 8.19 COL 45
     real-3 AT ROW 5.19 COL 27.8
     real-30 AT ROW 8.19 COL 53.6
     real-31 AT ROW 8.19 COL 62.2
     real-32 AT ROW 9.19 COL 2
     real-33 AT ROW 9.19 COL 10.6
     real-34 AT ROW 9.19 COL 19.2
     real-35 AT ROW 9.19 COL 27.8
     real-36 AT ROW 9.19 COL 36.4
     real-37 AT ROW 9.19 COL 45
     real-38 AT ROW 9.19 COL 53.6
     real-39 AT ROW 9.19 COL 62.2
     real-4 AT ROW 5.19 COL 36.4
     real-40 AT ROW 10.19 COL 2
     real-41 AT ROW 10.19 COL 10.6
     real-42 AT ROW 10.19 COL 19.2
     real-43 AT ROW 10.19 COL 27.8
     real-44 AT ROW 10.19 COL 36.4
     real-45 AT ROW 10.19 COL 45
     real-46 AT ROW 10.19 COL 53.6
     real-47 AT ROW 10.19 COL 62.2
     real-5 AT ROW 5.19 COL 45
     real-6 AT ROW 5.19 COL 53.6
     real-7 AT ROW 5.19 COL 62.2
     real-8 AT ROW 6.19 COL 2
     real-9 AT ROW 6.19 COL 10.6
     real-colour AT ROW 2.67 COL 2
     SPACE(61.79) SKIP(7.94)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Choose Color"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Compile into: af/sup2
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}
{af/sup2/afspcolour.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
                                                                        */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-list IN FRAME gDialog
   ALIGN-L                                                              */
ASSIGN 
       real-0:MOVABLE IN FRAME gDialog          = TRUE
       real-0:PRIVATE-DATA IN FRAME gDialog     = 
                "0".

ASSIGN 
       real-1:MOVABLE IN FRAME gDialog          = TRUE
       real-1:PRIVATE-DATA IN FRAME gDialog     = 
                "1".

ASSIGN 
       real-10:MOVABLE IN FRAME gDialog          = TRUE
       real-10:PRIVATE-DATA IN FRAME gDialog     = 
                "10".

ASSIGN 
       real-11:MOVABLE IN FRAME gDialog          = TRUE
       real-11:PRIVATE-DATA IN FRAME gDialog     = 
                "11".

ASSIGN 
       real-12:MOVABLE IN FRAME gDialog          = TRUE
       real-12:PRIVATE-DATA IN FRAME gDialog     = 
                "12".

ASSIGN 
       real-13:MOVABLE IN FRAME gDialog          = TRUE.

ASSIGN 
       real-14:MOVABLE IN FRAME gDialog          = TRUE.

ASSIGN 
       real-15:MOVABLE IN FRAME gDialog          = TRUE.

ASSIGN 
       real-16:MOVABLE IN FRAME gDialog          = TRUE
       real-16:PRIVATE-DATA IN FRAME gDialog     = 
                "0".

ASSIGN 
       real-17:MOVABLE IN FRAME gDialog          = TRUE
       real-17:PRIVATE-DATA IN FRAME gDialog     = 
                "1".

ASSIGN 
       real-18:MOVABLE IN FRAME gDialog          = TRUE
       real-18:PRIVATE-DATA IN FRAME gDialog     = 
                "10".

ASSIGN 
       real-19:MOVABLE IN FRAME gDialog          = TRUE
       real-19:PRIVATE-DATA IN FRAME gDialog     = 
                "11".

ASSIGN 
       real-2:MOVABLE IN FRAME gDialog          = TRUE
       real-2:PRIVATE-DATA IN FRAME gDialog     = 
                "2".

ASSIGN 
       real-20:MOVABLE IN FRAME gDialog          = TRUE
       real-20:PRIVATE-DATA IN FRAME gDialog     = 
                "12".

ASSIGN 
       real-21:MOVABLE IN FRAME gDialog          = TRUE.

ASSIGN 
       real-22:MOVABLE IN FRAME gDialog          = TRUE.

ASSIGN 
       real-23:MOVABLE IN FRAME gDialog          = TRUE.

ASSIGN 
       real-24:MOVABLE IN FRAME gDialog          = TRUE
       real-24:PRIVATE-DATA IN FRAME gDialog     = 
                "2".

ASSIGN 
       real-25:MOVABLE IN FRAME gDialog          = TRUE
       real-25:PRIVATE-DATA IN FRAME gDialog     = 
                "3".

ASSIGN 
       real-26:MOVABLE IN FRAME gDialog          = TRUE
       real-26:PRIVATE-DATA IN FRAME gDialog     = 
                "4".

ASSIGN 
       real-27:MOVABLE IN FRAME gDialog          = TRUE
       real-27:PRIVATE-DATA IN FRAME gDialog     = 
                "5".

ASSIGN 
       real-28:MOVABLE IN FRAME gDialog          = TRUE
       real-28:PRIVATE-DATA IN FRAME gDialog     = 
                "6".

ASSIGN 
       real-29:MOVABLE IN FRAME gDialog          = TRUE
       real-29:PRIVATE-DATA IN FRAME gDialog     = 
                "7".

ASSIGN 
       real-3:MOVABLE IN FRAME gDialog          = TRUE
       real-3:PRIVATE-DATA IN FRAME gDialog     = 
                "3".

ASSIGN 
       real-30:MOVABLE IN FRAME gDialog          = TRUE
       real-30:PRIVATE-DATA IN FRAME gDialog     = 
                "8".

ASSIGN 
       real-31:MOVABLE IN FRAME gDialog          = TRUE
       real-31:PRIVATE-DATA IN FRAME gDialog     = 
                "9".

ASSIGN 
       real-32:MOVABLE IN FRAME gDialog          = TRUE
       real-32:PRIVATE-DATA IN FRAME gDialog     = 
                "2".

ASSIGN 
       real-33:MOVABLE IN FRAME gDialog          = TRUE
       real-33:PRIVATE-DATA IN FRAME gDialog     = 
                "3".

ASSIGN 
       real-34:MOVABLE IN FRAME gDialog          = TRUE
       real-34:PRIVATE-DATA IN FRAME gDialog     = 
                "4".

ASSIGN 
       real-35:MOVABLE IN FRAME gDialog          = TRUE
       real-35:PRIVATE-DATA IN FRAME gDialog     = 
                "5".

ASSIGN 
       real-36:MOVABLE IN FRAME gDialog          = TRUE
       real-36:PRIVATE-DATA IN FRAME gDialog     = 
                "6".

ASSIGN 
       real-37:MOVABLE IN FRAME gDialog          = TRUE
       real-37:PRIVATE-DATA IN FRAME gDialog     = 
                "7".

ASSIGN 
       real-38:MOVABLE IN FRAME gDialog          = TRUE
       real-38:PRIVATE-DATA IN FRAME gDialog     = 
                "8".

ASSIGN 
       real-39:MOVABLE IN FRAME gDialog          = TRUE
       real-39:PRIVATE-DATA IN FRAME gDialog     = 
                "9".

ASSIGN 
       real-4:MOVABLE IN FRAME gDialog          = TRUE
       real-4:PRIVATE-DATA IN FRAME gDialog     = 
                "4".

ASSIGN 
       real-40:MOVABLE IN FRAME gDialog          = TRUE
       real-40:PRIVATE-DATA IN FRAME gDialog     = 
                "2".

ASSIGN 
       real-41:MOVABLE IN FRAME gDialog          = TRUE
       real-41:PRIVATE-DATA IN FRAME gDialog     = 
                "3".

ASSIGN 
       real-42:MOVABLE IN FRAME gDialog          = TRUE
       real-42:PRIVATE-DATA IN FRAME gDialog     = 
                "4".

ASSIGN 
       real-43:MOVABLE IN FRAME gDialog          = TRUE
       real-43:PRIVATE-DATA IN FRAME gDialog     = 
                "5".

ASSIGN 
       real-44:MOVABLE IN FRAME gDialog          = TRUE
       real-44:PRIVATE-DATA IN FRAME gDialog     = 
                "6".

ASSIGN 
       real-45:MOVABLE IN FRAME gDialog          = TRUE
       real-45:PRIVATE-DATA IN FRAME gDialog     = 
                "7".

ASSIGN 
       real-46:MOVABLE IN FRAME gDialog          = TRUE
       real-46:PRIVATE-DATA IN FRAME gDialog     = 
                "8".

ASSIGN 
       real-47:MOVABLE IN FRAME gDialog          = TRUE
       real-47:PRIVATE-DATA IN FRAME gDialog     = 
                "9".

ASSIGN 
       real-5:MOVABLE IN FRAME gDialog          = TRUE
       real-5:PRIVATE-DATA IN FRAME gDialog     = 
                "5".

ASSIGN 
       real-6:MOVABLE IN FRAME gDialog          = TRUE
       real-6:PRIVATE-DATA IN FRAME gDialog     = 
                "6".

ASSIGN 
       real-7:MOVABLE IN FRAME gDialog          = TRUE
       real-7:PRIVATE-DATA IN FRAME gDialog     = 
                "7".

ASSIGN 
       real-8:MOVABLE IN FRAME gDialog          = TRUE
       real-8:PRIVATE-DATA IN FRAME gDialog     = 
                "8".

ASSIGN 
       real-9:MOVABLE IN FRAME gDialog          = TRUE
       real-9:PRIVATE-DATA IN FRAME gDialog     = 
                "9".

/* SETTINGS FOR FILL-IN txt-unknown IN FRAME gDialog
   NO-ENABLE                                                            */
ASSIGN 
       txt-unknown:HIDDEN IN FRAME gDialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Choose Color */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
ON CHOOSE OF Btn_Cancel IN FRAME gDialog /* Cancel */
DO:
  ASSIGN vSelection = "*".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* Select */
DO:
    ASSIGN lpResult = TRUE

           cpColor  = IF tg-ctn:CHECKED 
                      THEN
                          (IF sl-colour:SCREEN-VALUE = "-1" THEN "?" ELSE sl-colour:SCREEN-VALUE)
                      ELSE
                          cb-list:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-list gDialog
ON VALUE-CHANGED OF cb-list IN FRAME gDialog
DO:
    ASSIGN sl-colour:SCREEN-VALUE = STRING(cb-list:LOOKUP(SELF:SCREEN-VALUE) - 2).
    APPLY "VALUE-CHANGED" TO sl-colour.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME real-0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL real-0 gDialog
ON MOUSE-SELECT-CLICK OF real-0 IN FRAME gDialog
,real-1,real-2,real-3,real-4,real-5,real-6,real-7,real-8,
real-9,real-10,real-11,real-12,real-13,real-14,real-15,
real-16,real-17,real-18,real-19,real-20,real-21,real-22,real-23,
real-24,real-25,real-26,real-27,real-28,real-29,real-30,
real-31,real-32,real-33,real-34,real-35,real-36,real-37,real-38,
real-39,real-40,real-41,real-42,real-43,real-44,real-45,real-46,real-47

OR "START-MOVE" OF real-0,real-1,real-2,real-3,real-4,real-5,real-6,real-7,real-8,
real-9,real-10,real-11,real-12,real-13,real-14,real-15,
real-16,real-17,real-18,real-19,real-20,real-21,real-22,real-23,
real-24,real-25,real-26,real-27,real-28,real-29,real-30,
real-31,real-32,real-33,real-34,real-35,real-36,real-37,real-38,
real-39,real-40,real-41,real-42,real-43,real-44,real-45,real-46,real-47
DO:
  ASSIGN sl-colour:SCREEN-VALUE = ENTRY(2,SELF:NAME,"-")
         SELF:EDGE-PIXELS = 4 sl-colour.
  IF sl-colour > sl-colour:MAX-VALUE
  THEN
       MESSAGE "Color" sl-colour "is not defined in the Color Table"
            VIEW-AS ALERT-BOX INFORMATION.
  APPLY "VALUE-CHANGED" TO sl-colour.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL real-0 gDialog
ON MOUSE-SELECT-DOWN OF real-0 IN FRAME gDialog
,real-1,real-2,real-3,real-4,real-5,real-6,real-7,real-8,
real-9,real-10,real-11,real-12,real-13,real-14,real-15,
real-16,real-17,real-18,real-19,real-20,real-21,real-22,real-23,
real-24,real-25,real-26,real-27,real-28,real-29,real-30,
real-31,real-32,real-33,real-34,real-35,real-36,real-37,real-38,
real-39,real-40,real-41,real-42,real-43,real-44,real-45,real-46,real-47
DO:
    ASSIGN SELF:EDGE-PIXELS = 8.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sl-colour
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sl-colour gDialog
ON VALUE-CHANGED OF sl-colour IN FRAME gDialog
DO:
  ASSIGN FRAME {&FRAME-NAME} sl-colour 
         real-colour:BGCOLOR = IF sl-colour < 0 THEN ? ELSE sl-colour
         txt-unknown:HIDDEN = sl-colour > -1
         result = cb-list:REPLACE(IF sl-colour < 0 THEN "Default" ELSE "Color " + STRING(sl-colour),cb-list:ENTRY(1))
         cb-list:SCREEN-VALUE = IF sl-colour + 2 <= cb-list:NUM-ITEMS
                                THEN cb-list:ENTRY(sl-colour + 2)
                                ELSE cb-list:ENTRY(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

ASSIGN lpResult     = FALSE
       ghSourceProc = SOURCE-PROCEDURE.

{src/adm2/dialogmn.i}

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
  DISPLAY cb-list sl-colour tg-ctn txt-unknown 
      WITH FRAME gDialog.
  ENABLE cb-list sl-colour Btn_OK Btn_Cancel tg-ctn real-0 real-1 real-10 
         real-11 real-12 real-13 real-14 real-15 real-16 real-17 real-18 
         real-19 real-2 real-20 real-21 real-22 real-23 real-24 real-25 real-26 
         real-27 real-28 real-29 real-3 real-30 real-31 real-32 real-33 real-34 
         real-35 real-36 real-37 real-38 real-39 real-4 real-40 real-41 real-42 
         real-43 real-44 real-45 real-46 real-47 real-5 real-6 real-7 real-8 
         real-9 real-colour 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttribute AS CHARACTER  NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  ASSIGN sl-colour:MAX-VALUE IN FRAME {&FRAME-NAME} = COLOR-TABLE:NUM-ENTRIES.

  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  /* Check whether the source object is the dynamic property hseet */
  IF INDEX(ghSourceProc:FILE-NAME,"ryvobpropw":U) > 0 THEN
  DO:
     cAttribute = DYNAMIC-FUNCTION("getAttribute" IN ghSourceProc) NO-ERROR.
     /* If attribute is for SmartFolder, allow user to return color table or text */
     IF LOOKUP(cAttribute,"SelectorBGColor,SelectorFGColor,TabBGColor,TabFGColor":U) = 0 THEN
       ASSIGN  tg-ctn:CHECKED = TRUE
               tg-ctn:SENSITIVE = FALSE.
     ELSE
        ASSIGN  tg-ctn:CHECKED = FALSE.

  END.
  ELSE
    ASSIGN  tg-ctn:CHECKED = FALSE.


  RUN getColour IN pSuper-hdl(?).

  IF RETURN-VALUE <> ""
  THEN
      ASSIGN cb-list:LIST-ITEMS = cb-list:LIST-ITEMS + "," + RETURN-VALUE.

  IF cpColor = "?":U THEN cpColor = "-1":U.
  ELSE
  IF cpColor = "":U THEN cpColor = "Default":U.

  IF NOT CAN-DO(cb-list:LIST-ITEMS,cpColor)
  THEN DO:
        ASSIGN sl-colour = INTEGER(cpColor) NO-ERROR.

        IF ERROR-STATUS:ERROR
        THEN       
            cb-list:ADD-FIRST(cpColor).
        ELSE DO:
            ASSIGN sl-colour:SCREEN-VALUE = cpColor.

            APPLY "VALUE-CHANGED":U TO sl-colour.

            RETURN.
        END.
  END.

  ASSIGN cb-list:SCREEN-VALUE = cpColor .

  APPLY "VALUE-CHANGED":U TO cb-list.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

