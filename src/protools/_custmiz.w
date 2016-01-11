&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    d_pt-func
&Scoped-define FRAME-NAME     d_pt-func
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_pt-func 
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

  File: protools/_custmiz.w

  Description: PRO*Tools Customization dialog

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 09/01/94 - 12:56 pm
  
  Last Modified on 10/26/94 by GFS

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
{ protools/_protool.i } /* shared temp-table def */
{ protools/ptlshlp.i }  /* Help file definitions */
{ adecomm/_adetool.i }

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hPalette AS HANDLE.   /* PROC HANDLE of Palette */
DEFINE INPUT-OUTPUT PARAMETER ptdat AS CHAR. /* data file loaded from */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE iname     AS CHAR NO-UNDO. /* FULL IMAGE NAME */
DEFINE NEW SHARED VARIABLE pname     AS CHAR NO-UNDO. /* FULL PROC NAME */
DEFINE NEW SHARED VARIABLE rcode     AS LOG  NO-UNDO. /* RETURN CODE */
DEFINE NEW SHARED VARIABLE dlist-i   AS CHAR NO-UNDO. /* dirs for images */
DEFINE NEW SHARED VARIABLE dlist-p   AS CHAR NO-UNDO. /* dirs for procs */
DEFINE NEW SHARED VARIABLE ifilename AS CHAR NO-UNDO.
DEFINE NEW SHARED VARIABLE pfilename AS CHAR NO-UNDO.
DEFINE NEW SHARED VARIABLE modrecid  AS RECID NO-UNDO.

DEFINE VARIABLE modrcode AS LOGICAL NO-UNDO. /* upd/add return code */
DEFINE VARIABLE h        AS HANDLE  NO-UNDO.
DEFINE VARIABLE l        AS LOGICAL NO-UNDO.
DEFINE VARIABLE changed  AS LOGICAL NO-UNDO INITIAL no.

/* Tells okbar.i to size buttons to win-95. */
&GLOBAL-DEFINE WIN95-BTN YES

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  d_pt-func
&Scoped-define BROWSE-NAME brFunc

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE brFunc                                        */
&Scoped-define FIELDS-IN-QUERY-brFunc pt-function.pdisplay ~
pt-function.pcFname 
&Scoped-define OPEN-QUERY-brFunc OPEN QUERY brFunc FOR EACH pt-function SHARE-LOCK ~
    BY pt-function.order.

/* Definitions for DIALOG-BOX d_pt-func                                 */
&Scoped-define FIELDS-IN-QUERY-d_pt-func 
&Scoped-define ENABLED-FIELDS-IN-QUERY-d_pt-func 
&Scoped-define OPEN-BROWSERS-IN-QUERY-d_pt-func ~
    ~{&OPEN-QUERY-brFunc}

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Add 
     LABEL "&Add...":L 
     SIZE 10.2 BY 1.

DEFINE BUTTON b_down 
     IMAGE-UP FILE "adeicon/next"
     LABEL "~\/" 
     SIZE 10.2 BY 1.5.

DEFINE BUTTON b_Files2 
     LABEL "&Files...":L 
     SIZE 10 BY 1.

DEFINE BUTTON b_Remove 
     LABEL "&Remove":L 
     SIZE 10.2 BY 1.

DEFINE BUTTON b_up 
     IMAGE-UP FILE "adeicon/prev"
     LABEL "/~\" 
     SIZE 10.2 BY 1.5.

DEFINE BUTTON b_Update 
     LABEL "&Update...":L 
     SIZE 10.2 BY 1.

DEFINE VARIABLE b_Image_Label AS CHARACTER FORMAT "X(256)":U INITIAL "Image:" 
      VIEW-AS TEXT 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE dfilename AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Startup file" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1 NO-UNDO.

DEFINE IMAGE f_Image
     SIZE-PIXELS 32 BY 32
     BGCOLOR 8 .

DEFINE RECTANGLE r_Attributes
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 7.77
     BGCOLOR 8 .

DEFINE RECTANGLE r_Functions
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44 BY 7.77
     BGCOLOR 8 .

DEFINE RECTANGLE r_Options
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 3.77
     BGCOLOR 8 .

DEFINE VARIABLE t_pdisplay AS LOGICAL INITIAL no 
     LABEL "Display On Palette":L 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .85 NO-UNDO.

DEFINE VARIABLE t_perrun AS LOGICAL INITIAL no 
     LABEL "Run Persistent":L 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .85 NO-UNDO.

DEFINE VARIABLE t_Save_Loc AS LOGICAL INITIAL no 
     LABEL "Save &Current Palette Position and Orientation":L 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .85 NO-UNDO.


/* Query definitions                                                    */
DEFINE QUERY brFunc FOR pt-function SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE brFunc QUERY brFunc SHARE-LOCK NO-WAIT DISPLAY 
      pt-function.pdisplay FORMAT "  / *"
      pt-function.pcFname
    WITH NO-LABELS SIZE 30 BY 6.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_pt-func
     brFunc AT ROW 2.3 COL 3
     b_Add AT ROW 2.3 COL 34
     pt-function.pcFname AT ROW 2.5 COL 54 COLON-ALIGNED
          LABEL "Label"
          VIEW-AS FILL-IN 
          SIZE 33 BY 1.08
          BGCOLOR 15 FGCOLOR 0 
     b_Remove AT ROW 3.5 COL 34
     pt-function.pcFile AT ROW 4 COL 54 COLON-ALIGNED
          LABEL "Program" FORMAT "x(65)"
          VIEW-AS FILL-IN 
          SIZE 33 BY 1.08
          BGCOLOR 15 FGCOLOR 0 
     b_Update AT ROW 4.7 COL 34
     t_perrun AT ROW 6 COL 66
     b_Image_Label AT ROW 6.5 COL 47 COLON-ALIGNED NO-LABEL
     t_pdisplay AT ROW 7 COL 66
     b_up AT ROW 6 COL 34 NO-LABEL
     b_down AT ROW 7.6 COL 34 NO-LABEL
     t_Save_Loc AT ROW 10.5 COL 25
     dfilename AT ROW 11.77 COL 19 COLON-ALIGNED 
     b_Files2 AT ROW 11.77 COL 74
     "(Applets will be saved to this file)" VIEW-AS TEXT
          SIZE 40 BY .65 AT ROW 12.9 COL 21
     " Applets " VIEW-AS TEXT
          SIZE 9 BY .65 AT ROW 1.5 COL 3
     " Attributes" VIEW-AS TEXT
          SIZE 11 BY .65 AT ROW 1.5 COL 47
     r_Attributes AT ROW 1.81 COL 2
     r_Functions AT ROW 1.81 COL 46
     f_Image AT ROW 6.27 COL 56
     " Startup Options" VIEW-AS TEXT
          SIZE 16 BY .65 AT ROW 9.77 COL 3
     r_Options AT ROW 10 COL 2
     SPACE(0.93) SKIP(0.38)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "PRO*Tools Customization":L.

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME d_pt-func:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN b_Image_Label IN FRAME d_pt-func
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pt-function.pcFile IN FRAME d_pt-func
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN pt-function.pcFname IN FRAME d_pt-func
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX t_pdisplay IN FRAME d_pt-func
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX t_perrun IN FRAME d_pt-func
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brFunc
/* Query rebuild information for BROWSE brFunc
     _TblList          = "pt-function"
     _Options          = "SHARE-LOCK"
     _OrdList          = "pt-function.order|yes"
     _FldNameList[1]   = pt-function.pdisplay
     _FldFormatList[1] = "  / *"
     _FldNameList[2]   = pt-function.pcFname
     _Query            is OPENED
*/  /* BROWSE brFunc */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_pt-func
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_pt-func d_pt-func
ON GO OF FRAME d_pt-func /* PRO*Tools Customization */
DO:
  DEFINE VARIABLE choice        AS LOGICAL NO-UNDO INITIAL yes. /* Misc LOG */
  DEFINE VARIABLE px            AS INTEGER NO-UNDO. /* x Loc of Palette */
  DEFINE VARIABLE py            AS INTEGER NO-UNDO. /* y Loc of Palette */
  DEFINE VARIABLE items-per-row AS INTEGER NO-UNDO.
  DEFINE VARIABLE lbl-or-btn    AS CHAR    NO-UNDO. /* lbl or btn */
  DEFINE VARIABLE o             AS INTEGER NO-UNDO INITIAL 10. /* used to renumber */
  DEFINE VARIABLE v             AS CHAR    NO-UNDO.

  IF changed OR dfilename:SCREEN-VALUE NE ptdat THEN DO:
    ASSIGN dfilename = dfilename:SCREEN-VALUE.
    FILE-INFO:FILE-NAME = dfilename.
    IF INDEX(FILE-INFO:FILE-TYPE, "W") = 0 THEN DO:
        MESSAGE "You do not have permission to write to this file."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        APPLY "ENTRY" TO dfilename IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
    IF FILE-INFO:FULL-PATHNAME <> ? THEN DO:
      ASSIGN choice = NO.
      MESSAGE "Do you want to overwrite" skip
              dfilename "?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE choice.
      IF choice THEN dfilename = FILE-INFO:FULL-PATHNAME.
    END.
  
    IF choice THEN DO:
      IF dfilename <> ? AND dfilename <> "" THEN 
      DO ON ERROR UNDO, RETRY:  
        IF RETRY THEN DO:
          MESSAGE "An error has occured writing to " dfilename skip
                  "The file cannot be saved until the problem is corrected."
            VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
        END.
        /* Save applets */
          OUTPUT TO value(dfilename).
              REPEAT PRESELECT EACH pt-function BY pt-function.order:
                  FIND NEXT pt-function.
                  ASSIGN pt-function.order = o       /* renumber */
                         o                 = o + 10.
                  EXPORT pt-function.
              END.
          OUTPUT CLOSE.
          ASSIGN ptdat = dfilename.
      END.
      ELSE DO:
          MESSAGE "You must specify a Startup File!" VIEW-AS
              ALERT-BOX ERROR BUTTONS OK.
          APPLY "ENTRY" TO dfilename IN FRAME {&FRAME-NAME}.
          RETURN NO-APPLY.
      END.
    END.
  END. /* IF changed */
  
  /* SAVE Startup File Options */
/*
  PUT-KEY-VALUE SECTION "ProTools" 
                KEY     "ExecuteOnAdeStartup" 
                VALUE   STRING(t_Startup:CHECKED, "yes/no") NO-ERROR.
                
  PUT-KEY-VALUE SECTION "ProTools" 
                KEY     "AddFunctionsToAdeMenuBar" 
                VALUE   STRING(t_Add_To_Menu:CHECKED, "yes/no") NO-ERROR.  
*/                
  PUT-KEY-VALUE SECTION "ProTools" 
                KEY     "FunctionDefs" 
                VALUE   ptdat NO-ERROR.                            
  IF ERROR-STATUS:ERROR THEN RUN INI_Error (INPUT "FunctionDefs").
  ELSE DO:
    GET-KEY-VALUE SECTION "ProTools" 
                  KEY     "FunctionDefs" 
                  VALUE   v .                            
    IF v NE ptdat THEN RUN INI_Error (INPUT "FunctionDefs").
  END.
     
  IF t_Save_Loc:CHECKED THEN DO:
        RUN Get-Location IN hPalette (OUTPUT px, OUTPUT py). 
        PUT-KEY-VALUE SECTION "ProTools" 
                    KEY     "PaletteLoc" 
                    VALUE   STRING(px) + "," + STRING(py) NO-ERROR. 
        IF ERROR-STATUS:ERROR THEN RUN INI_Error (INPUT "PaletteLoc").
        ELSE DO:
          GET-KEY-VALUE SECTION "ProTools" 
                      KEY     "PaletteLoc" 
                      VALUE   v .                            
          IF v NE STRING(px) + "," + STRING(py) THEN RUN INI_Error (INPUT "FunctionDefs").
        END.

        RUN Get-Items-Per-Row IN hPalette (OUTPUT items-per-row).
        PUT-KEY-VALUE SECTION "ProTools" 
                    KEY     "ItemsPerRow" 
                    VALUE   STRING(items-per-row) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN RUN INI_Error (INPUT "ItemsPerRow").
        ELSE DO:
          GET-KEY-VALUE SECTION "ProTools" 
                      KEY     "ItemsPerRow" 
                      VALUE   v .                            
          IF v NE STRING(items-per-row) THEN RUN INI_Error (INPUT "FunctionDefs").
        END.     
  END.                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brFunc
&Scoped-define SELF-NAME brFunc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFunc d_pt-func
ON VALUE-CHANGED OF brFunc IN FRAME d_pt-func
DO:
  RUN Display_Fields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Add d_pt-func
ON CHOOSE OF b_Add IN FRAME d_pt-func /* Add */
DO:
    RUN protools/_custmi2.w (INPUT "Add",
                             OUTPUT modrcode).
    IF modrcode THEN DO: /* new one added */
        ASSIGN changed = yes.
        {&OPEN-QUERY-brFunc}
        l = h:SET-REPOSITIONED-ROW (MAX(1,h:FOCUSED-ROW), "CONDITIONAL").
        REPOSITION brFunc TO RECID(modrecid).
        FIND pt-function WHERE RECID(pt-function) = modrecid.
        RUN Display_Fields.
        IF pt-function.pdisplay THEN
            RUN Add-Function IN hPalette (INPUT pt-function.pcFile,
                                          INPUT pt-function.pcImage, 
                                          INPUT pt-function.pcFname,
                                          INPUT pt-function.perrun,
                                          INPUT pt-function.order).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_down d_pt-func
ON CHOOSE OF b_down IN FRAME d_pt-func /* \/ */
DO:
  DEFINE BUFFER   tbuf FOR pt-function.
  DEFINE VARIABLE trecid AS RECID   NO-UNDO.
  DEFINE VARIABLE oswap  AS INTEGER NO-UNDO.
  
  ASSIGN trecid = RECID(pt-function).
  ASSIGN changed = yes.
  GET NEXT brFunc.
  IF AVAILABLE(pt-function) THEN DO:
      FIND tbuf WHERE RECID(tbuf) = trecid.
      ASSIGN oswap             = tbuf.order
             tbuf.order        = pt-function.order
             pt-function.order = oswap.
      RUN Swap_Order IN hPalette (INPUT pt-function.pcFname,
                                  INPUT tbuf.pcFname).
      {&OPEN-QUERY-brFunc}
      l = h:SET-REPOSITIONED-ROW (MAX(1,h:FOCUSED-ROW), "CONDITIONAL").
      REPOSITION brFunc TO RECID(trecid).
  END.
  ELSE DO:
      MESSAGE "This is already the last applet in the order"
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.  
      GET LAST brFunc.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Files2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Files2 d_pt-func
ON CHOOSE OF b_Files2 IN FRAME d_pt-func /* Files... */
DO:
    SYSTEM-DIALOG GET-FILE ptdat
    FILTERS "PRO*Tools defs (*.dat)" "*.dat",
            "All files (*.*)" "*.*"
    DEFAULT-EXTENSION ".dat"
    USE-FILENAME
    CREATE-TEST-FILE
    SAVE-AS
    UPDATE rcode.
    IF rcode AND ptdat NE dfilename:SCREEN-VALUE THEN
      ASSIGN changed                = yes
             dfilename:SCREEN-VALUE = ptdat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Remove d_pt-func
ON CHOOSE OF b_Remove IN FRAME d_pt-func /* Remove */
DO:
  DEF VAR choice AS LOG.
  DEF VAR fname  AS CHAR.
  DEF VAR onpal  AS LOG INITIAL yes.
  DEFINE BUFFER tfunc FOR pt-function.
  
  IF AVAILABLE (pt-function) THEN DO:
      MESSAGE "Are you sure you want to remove" skip
              "applet: " + pcFname + "?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE choice.
      IF CHOICE THEN DO:
          ASSIGN fname   = pcFname
                 onpal   = pt-function.pdisplay
                 changed = yes.
          FIND tfunc WHERE RECID(tfunc) = RECID(pt-FUNCTION).
          FIND PREV tfunc USE-INDEX order NO-ERROR.
          IF AVAILABLE pt-FUNCTION THEN 
          l = h:SET-REPOSITIONED-ROW (MAX(1,h:FOCUSED-ROW), "CONDITIONAL").
          DELETE pt-FUNCTION.
          {&OPEN-QUERY-brFunc}
          IF RECID(tfunc) NE ? THEN REPOSITION brFunc TO RECID(RECID(tfunc)).
          ELSE rcode = brFunc:SELECT-ROW(1).
          RUN Display_Fields.
          IF onpal THEN 
            RUN Delete-Function IN hPalette (INPUT Fname).
      END.
  END.
  ELSE MESSAGE "Please select a applet to remove" 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_up d_pt-func
ON CHOOSE OF b_up IN FRAME d_pt-func /* /\ */
DO:
  DEFINE BUFFER   tbuf FOR pt-function.
  DEFINE VARIABLE trecid AS RECID   NO-UNDO.
  DEFINE VARIABLE oswap  AS INTEGER NO-UNDO.
  
  ASSIGN trecid  = RECID(pt-function)
         changed = yes.
  GET PREV brFunc.
  IF AVAILABLE(pt-function) THEN DO:
      FIND tbuf WHERE RECID(tbuf) = trecid.
      ASSIGN oswap             = tbuf.order
             tbuf.order        = pt-function.order
             pt-function.order = oswap.
      RUN Swap_Order IN hPalette (INPUT pt-function.pcFname,
                                  INPUT tbuf.pcFname).
      {&OPEN-QUERY-brFunc}
      l = h:SET-REPOSITIONED-ROW (MAX(1,h:FOCUSED-ROW), "CONDITIONAL").
      REPOSITION brFunc TO RECID(trecid).
  END.
  ELSE DO:
      MESSAGE "This is already the first applet in the order"
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      GET FIRST brFunc.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Update d_pt-func
ON CHOOSE OF b_Update IN FRAME d_pt-func /* Update */
DO:
  DEFINE VARIABLE wasdisp AS LOG NO-UNDO. /* was it displayed before upd? */
  DEFINE VARIABLE oldname AS CHARACTER NO-UNDO. /* original name of function */
  
  IF AVAILABLE (pt-function) THEN DO:
    ASSIGN modrecid = RECID(pt-function)
           wasdisp  = pt-function.pdisplay
           oldname  = pt-function.pcFname.
    RUN protools/_custmi2.w (INPUT "Update",
                             OUTPUT modrcode).
    IF modrcode = NO THEN RETURN.
    ASSIGN changed = yes.
    {&OPEN-QUERY-brFunc}
    l = h:SET-REPOSITIONED-ROW (MAX(1,h:FOCUSED-ROW), "CONDITIONAL").
    REPOSITION brFunc TO RECID(modrecid).
    RUN Display_Fields.
  END.                         
  ELSE DO:
      MESSAGE "There is no applet to update." VIEW-AS ALERT-BOX
          ERROR BUTTONS ok.
      RETURN NO-APPLY.
  END. 
  IF wasdisp AND NOT pt-function.pdisplay THEN
      RUN Delete-Function IN hPalette (INPUT pt-function.pcFname).  
  ELSE IF NOT wasdisp AND pt-function.pdisplay THEN
      RUN Add-Function IN hPalette (INPUT pt-function.pcFile,
                                    INPUT pt-function.pcImage, 
                                    INPUT pt-function.pcFname,
                                    INPUT pt-function.perrun,
                                    INPUT pt-function.order). 
  ELSE IF pt-function.pdisplay THEN 
       RUN Update-Function IN hPalette (INPUT pt-function.pcFile,
                                        INPUT pt-function.pcImage, 
                                        INPUT pt-function.pcFname,
                                        INPUT pt-function.perrun,
                                        INPUT oldname). 

  /* Show "*" in the browse (if this isn't displayed) */
/*  DISPLAY t_pdisplay:CHECKED @ pt-function.pdisplay WITH BROWSE {&BROWSE-NAME}.                                      
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_pt-func 


/* ***************************  Main Block  *************************** */
{ adecomm/commeng.i }
{ adecomm/okbar.i &TOOL = "ptls"
                 &CONTEXT = {&Protools_Customize_Dlg_Box} }

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

RUN Read-INI.
&IF "{&WINDOW-SYSTEM}" EQ "OSF/Motif" &THEN
    ASSIGN b_Image_Label = "Image:".
&ENDIF
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  ASSIGN dfilename:SCREEN-VALUE = ptdat
         rcode                  = brFunc:SELECT-ROW(1)
         h                      = brFunc:HANDLE.
  APPLY "VALUE-CHANGED" TO brFunc.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.
IF LAST-EVENT:FUNCTION = "GO" AND changed THEN RUN Redraw IN hPalette.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_pt-func _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME d_pt-func.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Display_Fields d_pt-func 
PROCEDURE Display_Fields :
/* -----------------------------------------------------------
  Purpose:     display attributes of applet
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
      ASSIGN t_Perrun   = pt-function.perrun
             iFileName  = pt-function.pcImage
             pFileName  = pt-function.pcFname
             t_pdisplay = pt-function.pdisplay.
      DISPLAY pt-function.pcFname 
              pt-function.pcFile 
              t_Perrun
              t_pdisplay
              WITH FRAME {&FRAME-NAME}.
      rcode = f_Image:LOAD-IMAGE(?). /* clear */
      rcode = f_Image:LOAD-IMAGE(iFileName,0,0,f_Image:WIDTH-P,f_Image:HEIGHT-P).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_pt-func _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DISPLAY t_perrun b_Image_Label t_pdisplay t_Save_Loc dfilename 
      WITH FRAME d_pt-func.
  IF AVAILABLE pt-function THEN 
    DISPLAY pt-function.pcFname pt-function.pcFile 
      WITH FRAME d_pt-func.
  ENABLE r_Attributes r_Functions brFunc b_Add b_Remove b_Update f_Image b_up 
         b_down r_Options t_Save_Loc dfilename b_Files2 
      WITH FRAME d_pt-func.
  {&OPEN-BROWSERS-IN-QUERY-d_pt-func}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE INI_Error d_pt-func 
PROCEDURE INI_Error :
/* -----------------------------------------------------------
  Purpose:     Error writing to startup file
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER msg AS CHAR NO-UNDO.
  
  MESSAGE "ERROR writing parameter: " msg "to startup file!" skip
          "You may not have permission to write to this file." skip
          "If you attempting personal changes, you should run" skip
          "from your own copy of protools.dat and startup file."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Read-INI d_pt-func 
PROCEDURE Read-INI :
/* -----------------------------------------------------------
  Purpose:     Read startup options
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE get-log AS CHAR NO-UNDO.
/*  
  GET-KEY-VALUE SECTION "ProTools" 
                KEY "ExecuteOnAdeStartup" 
                VALUE get-log.
  IF get-log = "yes" THEN t_Startup = yes.
  ELSE t_Startup = no.
                
  GET-KEY-VALUE SECTION "ProTools" 
                KEY "AddFunctionsToAdeMenuBar" 
                VALUE get-log.  
  IF get-log = "yes" THEN t_Add_To_Menu = yes.
  ELSE t_Add_To_Menu = no.
*/  
  GET-KEY-VALUE SECTION "ProTools" 
                KEY "PaletteLoc" 
                VALUE get-log.  
  IF get-log <> "" THEN t_Save_Loc = yes.
  ELSE t_Save_Loc = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
