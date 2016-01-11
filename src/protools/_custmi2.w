&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r10 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    d_custom
&Scoped-define FRAME-NAME     d_custom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_custom 
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

  File: _custmi2.w

  Description: Add/Update PRO*Tools applets 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 10/06/94 - 10:42 am
  
  Last Modified on 01/27/94 by GFS - Added order support.
                   10/26/94 BY GFS
                   05/27/99 by tsm - Changed filters parameter in call to 
                                    _fndfile.p because it now needs list-item 
                                    pairs rather than list-items to support new 
                                    image formats
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
{ protools/_protool.i } /* shared temp-table definitions */
{ protools/ptlshlp.i }  /* help contents definitions */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER mode         AS CHAR    NO-UNDO. /*"Add" or "Update" */
DEFINE OUTPUT PARAMETER modrcode    AS LOGICAL NO-UNDO. /* add/upd return code */

/* Shared Variable Definitions ---                                       */
DEFINE SHARED VARIABLE iname     AS CHAR  NO-UNDO. /* FULL IMAGE NAME    */
DEFINE SHARED VARIABLE pname     AS CHAR  NO-UNDO. /* FULL PROC NAME     */
DEFINE SHARED VARIABLE dlist-i   AS CHAR  NO-UNDO. /* dirs for images    */
DEFINE SHARED VARIABLE dlist-p   AS CHAR  NO-UNDO. /* dirs for procs     */
DEFINE SHARED VARIABLE ifilename AS CHAR  NO-UNDO.
DEFINE SHARED VARIABLE pfilename AS CHAR  NO-UNDO.
DEFINE SHARED VARIABLE modrecid  AS RECID NO-UNDO.

/* Local Variable Definitions ---                                        */
DEFINE VARIABLE rcode            AS LOG   NO-UNDO. /* generic RETURN CODE */
DEFINE VARIABLE hcontext         AS INT   NO-UNDO. /* help context no.   */

/* Tells okbar.i to size buttons to win-95. */
&GLOBAL-DEFINE WIN95-BTN YES

DEFINE NEW SHARED BUFFER tfunct FOR pt-function.
DEFINE NEW SHARED BUFFER temp   FOR pt-function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  d_custom

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for DIALOG-BOX d_custom                                  */
&Scoped-define FIELDS-IN-QUERY-d_custom 
&Scoped-define ENABLED-FIELDS-IN-QUERY-d_custom 
&Scoped-define OPEN-QUERY-d_custom OPEN QUERY d_custom FOR EACH pt-function SHARE-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-d_custom pt-function
&Scoped-define TABLES-IN-QUERY-d_custom pt-function 

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Files 
     LABEL "&Files...":L 
     SIZE 14 BY 1.14.

DEFINE BUTTON b_Image 
     LABEL "":L 
     SIZE-PIXELS 38 BY 38.

DEFINE VARIABLE b_Image_Label AS CHARACTER FORMAT "X(256)":U INITIAL "&Image:" 
      VIEW-AS TEXT 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE fFile AS CHARACTER FORMAT "x(65)" 
     LABEL "&Program" 
     VIEW-AS FILL-IN 
     SIZE 29 BY 1.08.

DEFINE VARIABLE fName AS CHARACTER FORMAT "x(30)" 
     LABEL "&Label" 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1.08.

DEFINE RECTANGLE r_Attributes
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55 BY 6.27
     BGCOLOR 8 .

DEFINE VARIABLE t_pdisplay AS LOGICAL INITIAL no 
     LABEL "&Display on palette":L 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .85 NO-UNDO.

DEFINE VARIABLE t_perrun AS LOGICAL INITIAL no 
     LABEL "&Run Persistent":L 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .85 NO-UNDO.


/* Query definitions                                                    */
DEFINE QUERY d_custom FOR pt-function SCROLLING.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_custom
     fName AT ROW 2.27 COL 10 COLON-ALIGNED
     fFile AT ROW 3.77 COL 10 COLON-ALIGNED
     b_Files AT ROW 3.77 COL 42
     b_Image AT ROW 5.5 COL 12
     t_perrun AT ROW 5.5 COL 22
     b_Image_Label AT ROW 5.77 COL 3 COLON-ALIGNED NO-LABEL
     t_pdisplay AT ROW 6.5 COL 22
     " Attributes" VIEW-AS TEXT
          SIZE 11 BY .65 AT ROW 1.27 COL 3
     r_Attributes AT ROW 1.5 COL 2
     SPACE(0.64) SKIP(0.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Add PRO*Tools Applet":L.

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d_custom
  VISIBLE,L                                                             */
ASSIGN 
       FRAME d_custom:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN b_Image_Label IN FRAME d_custom
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME



/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d_custom
/* Query rebuild information for DIALOG-BOX d_custom
     _TblList          = "pt-function"
     _Options          = "SHARE-LOCK"
     _OrdList          = ""
     _Query            is OPENED
*/  /* DIALOG-BOX d_custom */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_custom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_custom d_custom
ON ENDKEY OF FRAME d_custom /* Add PRO*Tools Applet */
OR END-ERROR OF FRAME {&FRAME-NAME}
DO:
  ASSIGN modrcode = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_custom d_custom
ON GO OF FRAME d_custom /* Add PRO*Tools Applet */
DO:              
  
  /* Check for valid input */
  IF fName:SCREEN-VALUE = "" THEN DO:
    MESSAGE "Enter a name for this applet." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO fName.
    RETURN NO-APPLY.
  END.
  IF fFile:SCREEN-VALUE = "" THEN DO:
    MESSAGE "Enter a program for this applet." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO fFile.
    RETURN NO-APPLY.
  END.
  /* Disallow duplicate names */
  FIND temp WHERE temp.pcFname = fname:SCREEN-VALUE NO-ERROR.
  IF (AVAILABLE temp AND mode = "Add") OR
     (AVAILABLE temp AND mode = "Update" AND temp.pcfname <> tfunct.pcfname) THEN 
  DO:
    MESSAGE "An applet with this label already exists." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO fName.
    RETURN NO-APPLY.
  END.
  /* Check for valid procedure name */
  FILE-INFO:FILE-NAME = fFile:SCREEN-VALUE.
  IF FILE-INFO:PATHNAME EQ ? THEN 
  CHK:
  DO: /* can't find what the user entered, if .p or .w, try to find a .r */
    IF LOOKUP(SUBSTRING(fFile:SCREEN-VALUE,LENGTH(fFile:SCREEN-VALUE) - 1,2,"CHARACTER":U), ".w,.p") > 0 THEN DO:
      FILE-INFO:FILE-NAME = SUBSTRING(fFile:SCREEN-VALUE,1,LENGTH(fFile:SCREEN-VALUE) - 1,"CHARACTER":U) + "r".
      IF FILE-INFO:PATHNAME NE ? THEN LEAVE CHK.
    END.
    MESSAGE fFile:SCREEN-VALUE "was not found!" skip 
      "Please check your PROGRESS Propath or enter a fully-qualified name for the procedure."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO fFile.
    RETURN NO-APPLY.
  END.
  
  /* If 'ADD', add to temp-table */
  IF mode = "Add" THEN DO:
      FIND LAST temp USE-INDEX order.
      CREATE tfunct.
      ASSIGN tfunct.order = temp.order + 10. 
  END.   
  ASSIGN tfunct.pcFname   = fName:SCREEN-VALUE
         tfunct.pcFile    = fFile:SCREEN-VALUE
         tfunct.pcImage   = iFileName
         tfunct.perrun    = t_perrun:CHECKED
         tfunct.pdisplay  = t_pdisplay:CHECKED.


  ASSIGN  modrecid    = RECID(tfunct)
          modrcode    = yes.      
  RELEASE tfunct.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Files
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Files d_custom
ON CHOOSE OF b_Files IN FRAME d_custom /* Files... */
DO:
    IF dlist-p = "" THEN dlist-p = ".".
    ASSIGN pFilename = fName:SCREEN-VALUE.
    RUN adecomm/_fndfile.p (INPUT "Procedure to Run",
                          INPUT "TEXT", 
                          INPUT "Procedures & Windows (*.p,*.w)|*.p,*.w|All Files|*.*",
                          INPUT-OUTPUT dlist-p,
                          INPUT-OUTPUT pFileName,
                          OUTPUT pname,
                          OUTPUT rcode).  
    IF rcode THEN
      fFile:SCREEN-VALUE = pname.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Image
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Image d_custom
ON CHOOSE OF b_Image IN FRAME d_custom
DO:
  DEFINE VARIABLE image-formats AS CHARACTER NO-UNDO.
  
  image-formats = "All Picture Files|*.bmp,*.dib,*.ico,*.gif,*.jpg,*.cal,*.cut,*.dcx,*.eps,*.ica,*.iff,*.img," +
    "*.lv,*.mac,*.msp,*.pcd,*.pct,*.pcx,*.psd,*.ras,*.im,*.im1,*.im8,*.tga,*.tif,*.xbm,*.bm,*.xpm,*.wmf,*.wpg" +
    "|Bitmaps (*.bmp,*.dib)|*.bmp,*.dib|Icons (*.ico)|*.ico|GIF (*.gif)|*.gif|JPEG (*.jpg)|*.jpg" +
    "|CALS (*.cal)|*.cal|Halo CUT (*.cut)|*.cut|Intel FAX (*.dcx)|*.dcx|EPS (*.eps)|*.eps|IOCA (*.ica)|*.ica" +
    "|Amiga IFF (*.iff)|*.iff|GEM IMG (*.img)|*.img|LaserView (*.lv)|*.lv|MacPaint (*.mac)|*.mac" +
    "|Microsoft Paint (*.msp)|*.msp|Photo CD (*.pcd)|*.pcd|PICT (*.pct)|*.pct|PC Paintbrush (*.pcx)|*.pcx" +
    "|Adobe Photoshop (*.psd)|*.psd|Sun Raster (*.ras,*.im,*.im1,*.im8)|*.ras,*.im,*.im1,*.im8|TARGA (*.tga)|*.tga" +
    "|TIFF (*.tif)|*.tif|Pixmap (*.xpm)|*.xpm|Metafiles (*.wmf)|*.wmf|WordPerfect graphics (*.wpg)|*.wpg|" +
    "Xbitmap (*.xbm,*.bm)|*.xbm,*.bm|All Files|*.*":U.

  IF dlist-i = "" THEN dlist-i = ".".
  RUN adecomm/_fndfile.p (INPUT "Image",
                          INPUT "IMAGE", 
                          &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                            INPUT image-formats,
                          &ELSE 
                            INPUT "*.xpm,*.xbm|*.*",
                          &ENDIF
                          INPUT-OUTPUT dlist-i,
                          INPUT-OUTPUT iFileName,
                          OUTPUT iname,
                          OUTPUT rcode).  
  IF rcode THEN
      rcode = self:Load-Image(iname).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_custom 


/* ***************************  Main Block  *************************** */
{ adecomm/commeng.i }

/* Which help file to use? */
IF mode = "Add" THEN hcontext = {&Add_Applet_DB}.
ELSE hcontext = {&Update_Applet_DB}.

{ adecomm/okbar.i &TOOL = "ptls"
                 &CONTEXT = hcontext }

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
IF mode = "Update" THEN DO:
    ASSIGN FRAME {&FRAME-NAME}:TITLE = "Update PRO*Tools Applet".
    FIND tfunct WHERE RECID(tfunct) = modrecid NO-ERROR.
    IF NOT AVAILABLE tfunct THEN DO:
        MESSAGE "Record not available".
        RETURN.
    END.
    RUN Display_Fields.
END.
ELSE ASSIGN iname = ""
            pname = ""
            ifilename = ""
            pfilename = ""
            t_pdisplay = yes
            t_perrun = yes.
            
IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN
    ASSIGN b_Image_Label = "Image:".

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_custom _DEFAULT-DISABLE
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
  HIDE FRAME d_custom.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Display_Fields d_custom 
PROCEDURE Display_Fields :
/* -----------------------------------------------------------
  Purpose:     displays fields on the frame
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
      ASSIGN t_Perrun   = tfunct.perrun
             iFileName  = tfunct.pcImage
             t_pdisplay = tfunct.pdisplay
             fName      = tfunct.pcFname
             fFile      = tfunct.pcFile.
      DISPLAY fName 
              fFile 
              t_Perrun
              t_pdisplay
              WITH FRAME {&FRAME-NAME}.
      rcode = b_Image:LOAD-IMAGE(pcImage).
      ASSIGN iFileName = pcImage
             pFileName = pcFname.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_custom _DEFAULT-ENABLE
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

  {&OPEN-QUERY-d_custom}
  GET FIRST d_custom.
  DISPLAY fName fFile t_perrun b_Image_Label t_pdisplay 
      WITH FRAME d_custom.
  ENABLE r_Attributes fName fFile b_Files b_Image t_perrun t_pdisplay 
      WITH FRAME d_custom.
  {&OPEN-BROWSERS-IN-QUERY-d_custom}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME 
&UNDEFINE WINDOW-NAME
