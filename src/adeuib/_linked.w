&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_linked
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_linked 
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

  File: _linked.w

  Description: ADM link editor for the UIB 

  Input Parameters:
      p_window-handle - from _P

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 01/25/95 - 11:16 am
  Modified: 03/98 SLK Added queryObject

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/uniwidg.i} /* universal widget defs */
{adeuib/links.i}   /* ADM links temp-table def */
{adeuib/uibhlp.i}  /* UIB Help File Defs */
{adeuib/_chkrlnk.i}  /* shared include routines to chekc link between objects */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER precid AS RECID. /* recid of _P record */
DEFINE INPUT PARAMETER urecid AS RECID. /* recid of _U record */


/* Local Variable Definitions ---                                       */  
DEFINE BUFFER x_P FOR _P.
DEFINE BUFFER xx_U FOR _U.

DEFINE NEW SHARED TEMP-TABLE so
  FIELD name        AS CHARACTER
  FIELD type        AS CHARACTER
  FIELD links       AS CHARACTER
  FIELD _U-recid    AS RECID
  FIELD _S-handle   AS HANDLE
  FIELD queryObject AS LOGICAL INITIAL NO
  FIELD active      AS LOGICAL INITIAL YES.

DEFINE NEW SHARED TEMP-TABLE nadmlinks
  FIELD _admlinks-recid AS RECID
  FIELD _active         AS LOGICAL INITIAL yes /* Set to no if source or target _U is "DELETED" */
  FIELD _source-name    AS CHARACTER FORMAT "X(28)" COLUMN-LABEL "Source"
  FIELD _target-name    AS CHARACTER FORMAT "X(28)" COLUMN-LABEL "Target"
  INDEX _admlinks-recid AS PRIMARY _admlinks-recid.
  
DEFINE NEW SHARED VARIABLE litem AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE l                AS LOGICAL           NO-UNDO.
DEFINE VARIABLE curobj           AS CHARACTER         NO-UNDO.
DEFINE VARIABLE curobjsv         AS CHARACTER         NO-UNDO.

DEFINE BUFFER x_nadmlinks FOR nadmlinks.
/* Variables used for adm version */
{adeuib/vsookver.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d_linked
&Scoped-define BROWSE-NAME br_links

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES _admlinks nadmlinks

/* Definitions for BROWSE br_links                                      */
&Scoped-define FIELDS-IN-QUERY-br_links nadmlinks._source-name _admlinks._link-type nadmlinks._target-name   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_links   
&Scoped-define SELF-NAME br_links
&Scoped-define OPEN-QUERY-br_links OPEN QUERY br_links FOR EACH _admlinks, ~
           EACH nadmlinks WHERE RECID(_admlinks) = nadmlinks._admlinks-recid     SHARE-LOCK BY nadmlinks._source-name.
&Scoped-define TABLES-IN-QUERY-br_links _admlinks nadmlinks
&Scoped-define FIRST-TABLE-IN-QUERY-br_links _admlinks
&Scoped-define SECOND-TABLE-IN-QUERY-br_links nadmlinks


/* Definitions for DIALOG-BOX d_linked                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-4 RECT-6 RECT-5 b_Close br_links ~
b_Add b_Modify b_Remove b_Help cb_Source cb_LinkType cb_target b_ckLinks ~
rs_show rs_sort 
&Scoped-Define DISPLAYED-OBJECTS cb_Source cb_LinkType cb_target rs_show ~
rs_sort cb_tofrom 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Add 
     LABEL "&Add..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_ckLinks 
     LABEL "Ch&eck Links..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Close AUTO-GO 
     LABEL "&Close" 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Modify 
     LABEL "&Modify..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Remove 
     LABEL "&Remove" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cb_LinkType AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE cb_Source AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 27.6 BY 1 NO-UNDO.

DEFINE VARIABLE cb_target AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 28.6 BY 1 NO-UNDO.

DEFINE VARIABLE cb_tofrom AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE rs_show AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "All Lin&ks", 1,
"To/&From", 2
     SIZE 13 BY 2.38
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE rs_sort AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "&Source", 1,
"&Link", 2,
"&Target", 3
     SIZE 32 BY 1.1
     BGCOLOR 8  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 2.86.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 1.86.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 2.86.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 8.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_links FOR 
      _admlinks, 
      nadmlinks SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_links
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_links d_linked _FREEFORM
  QUERY br_links NO-LOCK DISPLAY
      nadmlinks._source-name
      _admlinks._link-type
      nadmlinks._target-name
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 73 BY 7.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_linked
     b_Close AT ROW 1.29 COL 78
     br_links AT ROW 1.67 COL 3
     b_Add AT ROW 3.14 COL 78
     b_Modify AT ROW 4.48 COL 78
     b_Remove AT ROW 5.81 COL 78
     b_Help AT ROW 7.14 COL 78
     cb_Source AT ROW 10.43 COL 1 COLON-ALIGNED NO-LABEL
     cb_LinkType AT ROW 10.43 COL 29.6 COLON-ALIGNED NO-LABEL
     cb_target AT ROW 10.43 COL 45.6 COLON-ALIGNED NO-LABEL
     b_ckLinks AT ROW 12.29 COL 78
     rs_show AT ROW 12.52 COL 4 NO-LABEL
     rs_sort AT ROW 13.24 COL 44 NO-LABEL
     cb_tofrom AT ROW 13.81 COL 15 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.29 COL 2
     " Sort Order" VIEW-AS TEXT
          SIZE 11 BY .67 AT ROW 11.95 COL 44
     " Show" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 12 COL 3
     RECT-4 AT ROW 12.29 COL 2
     RECT-6 AT ROW 12.29 COL 43
     RECT-5 AT ROW 9.86 COL 2
     " Filters" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 9.67 COL 3
     " Links" VIEW-AS TEXT
          SIZE 6 BY .67 AT ROW 1 COL 3
     SPACE(85.13) SKIP(13.59)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartLinks"
         DEFAULT-BUTTON b_Close.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d_linked
                                                                        */
/* BROWSE-TAB br_links b_Close d_linked */
ASSIGN 
       FRAME d_linked:SCROLLABLE       = FALSE.

ASSIGN 
       b_ckLinks:HIDDEN IN FRAME d_linked           = TRUE.

/* SETTINGS FOR COMBO-BOX cb_tofrom IN FRAME d_linked
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_links
/* Query rebuild information for BROWSE br_links
     _START_FREEFORM
OPEN QUERY br_links FOR EACH _admlinks,
    EACH nadmlinks WHERE RECID(_admlinks) = nadmlinks._admlinks-recid
    SHARE-LOCK BY nadmlinks._source-name.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE br_links */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_linked
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_linked d_linked
ON HELP OF FRAME d_linked /* SmartLinks */
OR CHOOSE OF b_Help 
DO:
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&SmartLinks_Dlg_Box}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_linked d_linked
ON WINDOW-CLOSE OF FRAME d_linked /* SmartLinks */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_links
&Scoped-define SELF-NAME br_links
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_links d_linked
ON VALUE-CHANGED OF br_links IN FRAME d_linked
DO:
  /* Sensitize the Modify and Remove buttons, as appropriate. */ 
  IF b_Modify:SENSITIVE NE AVAILABLE _admlinks THEN 
  ASSIGN 
     b_Modify:SENSITIVE  = AVAILABLE _admlinks
     b_CkLinks:SENSITIVE = AVAILABLE _admlinks AND admVersion >= "ADM2":U
     b_Remove:SENSITIVE  = b_Modify:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Add d_linked
ON CHOOSE OF b_Add IN FRAME d_linked /* Add... */
DO:
  DEFINE VAR lOK AS LOGICAL NO-UNDO.
  
  /* Add a new link. */
  RUN adeuib/_linkadd.w (precid, ?, OUTPUT lOK). 
  IF lOK THEN DO:
    /* refresh the browser */
    RUN Reopen_Query.    
    /* Add any new custom links to list */
    RUN Check_CustomLinks. 
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_ckLinks
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_ckLinks d_linked
ON CHOOSE OF b_ckLinks IN FRAME d_linked /* Check Links... */
DO:
  DEFINE VAR lOK AS LOGICAL NO-UNDO.
  /* Check the links. */
  RUN CkLinks.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Modify
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Modify d_linked
ON CHOOSE OF b_Modify IN FRAME d_linked /* Modify... */
DO:
  DEFINE VAR lOK AS LOGICAL NO-UNDO.
  
  /* Modify the currently selected link. (NOTE there should be no way to
     get in here without some object selected.) */  
  IF br_links:NUM-SELECTED-ROWS = 1 THEN DO:
    IF NOT AVAILABLE (_admlinks) THEN l = br_links:FETCH-SELECTED-ROW(1).
    RUN adeuib/_linkadd.w (precid, RECID(_admlinks), OUTPUT lOK). 
    IF lOK THEN DO:
      /* Refresh the browser */
      DISPLAY {&FIELDS-IN-QUERY-{&BROWSE-NAME}} WITH BROWSE {&BROWSE-NAME}.    
      /* Add any new custom links to list */
      RUN Check_CustomLinks. 
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Remove d_linked
ON CHOOSE OF b_Remove IN FRAME d_linked /* Remove */
DO:
  DEFINE VARIABLE lt AS CHARACTER NO-UNDO.
  
  IF br_links:NUM-SELECTED-ROWS = 1 THEN DO:
    IF NOT AVAILABLE (_admlinks) THEN
        l = br_links:FETCH-SELECTED-ROW(1).
    ASSIGN lt = _admlinks._link-type.
    DELETE _admlinks.
    DELETE nadmlinks.
    /* If this was the last link of it's type, then delete it from the list */
    IF NOT CAN-FIND (FIRST _admlinks WHERE _admlinks._link-type = lt) THEN
        l = cb_linktype:delete(lt).
    RUN Reopen_Query.
    RUN adeuib/_winsave.p (x_P._WINDOW-HANDLE, FALSE). /* force save on window */             
  END.
  ELSE MESSAGE "You must first select a link." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb_Source
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb_Source d_linked
ON VALUE-CHANGED OF cb_Source IN FRAME d_linked
OR VALUE-CHANGED OF cb_linktype IN FRAME d_linked
OR VALUE-CHANGED OF cb_target   IN FRAME d_linked
OR VALUE-CHANGED OF rs_sort     IN FRAME d_linked
DO:
  RUN Reopen_Query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb_tofrom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb_tofrom d_linked
ON VALUE-CHANGED OF cb_tofrom IN FRAME d_linked
DO:
  RUN ReOpen_Query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs_show
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs_show d_linked
ON VALUE-CHANGED OF rs_show IN FRAME d_linked
DO:
  IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN cb_source:SENSITIVE = YES
           cb_target:SENSITIVE = YES
           cb_source:SCREEN-VALUE = "[ALL]"
           cb_target:SCREEN-VALUE = "[ALL]".
  RUN ReOpen_Query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_linked 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Find the current procedure we are working with. */
FIND x_P WHERE RECID(x_P) = precid.
ASSIGN admVersion = IF x_P._adm-version LT "ADM2":U THEN
                       "ADM1":U
                    ELSE x_P._adm-version.

FIND xx_U WHERE RECID(xx_U) = urecid.
IF AVAILABLE xx_U THEN DO:
  IF xx_U._TYPE = "SmartObject" THEN
    ASSIGN cb_tofrom  = xx_U._NAME. /* Show to/from this object */
  ELSE ASSIGN cb_tofrom  = "THIS-PROCEDURE":U.
  ASSIGN rs_show = 1. /* Show All Links */
END.

/* Adjust width for worst case */
IF SESSION:WIDTH-PIXELS / SESSION:PIXELS-PER-COL < 94 THEN
  ASSIGN b_Add:WIDTH IN FRAME {&FRAME-NAME}    = 10
         b_Close:WIDTH IN FRAME {&FRAME-NAME}  = 10
         b_Help:WIDTH IN FRAME {&FRAME-NAME}   = 10
         b_Modify:WIDTH IN FRAME {&FRAME-NAME} = 10
         b_ckLinks:WIDTH IN FRAME {&FRAME-NAME} = 10
         b_Remove:WIDTH IN FRAME {&FRAME-NAME} = 10
         FRAME {&FRAME-NAME}:WIDTH             = 88.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN Find_SOs.
  IF RETURN-VALUE = "NONE" THEN RETURN.
  RUN enable_UI.
  RUN Reopen_Query.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* There seems to be a bug where ACTIVE-WINDOW gets reset. (It becomes the
   UIB Main Window.  To test, just call up this dialog from the popup menu
   on a SmartObject.  When you hit CLOSE, see if the UIB main window is active,
   or the Design Window is ACTIVE. */
APPLY "ENTRY" TO ACTIVE-WINDOW.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check_CustomLinks d_linked 
PROCEDURE Check_CustomLinks :
/* --------------------------------------------------------------------
  Purpose:     Look for Custom link types and add them to the list
  Parameters:  <none>
  Notes:       
   -------------------------------------------------------------------- */
  DEFINE VARIABLE pos AS INTEGER NO-UNDO.
  DEFINE VARIABLE oldlt AS CHAR NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF cb_linktype:SCREEN-VALUE NE ? AND cb_linktype:SCREEN-VALUE <> "" THEN
      oldlt = cb_linktype:SCREEN-VALUE.

    ASSIGN cb_linktype:LIST-ITEMS = 
       IF admVersion LT "ADM2":U THEN "[ALL],Navigation,Page,Record,State,TableIO"
       ELSE                           "[ALL],Navigation,Page,Record,TableIO".  

    /* Insert any custom linktypes into the list */
    FOR EACH _admlinks WHERE _P-recid = precid:
      pos = cb_linktype:LOOKUP(_admlinks._link-type).
      IF pos = 0 THEN l = cb_linktype:ADD-LAST(_admlinks._link-type).
    END.
    IF oldlt <> "" THEN DO:
      pos = cb_linktype:LOOKUP(oldlt).
      IF pos = 0 THEN cb_linktype:SCREEN-VALUE = "[ALL]".
      ELSE cb_linktype:SCREEN-VALUE = oldlt.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CkLinks d_linked 
PROCEDURE CkLinks :
/* --------------------------------------------------------------------
  Purpose:     Check the links
  Parameters:  <none>
  Notes:       
   -------------------------------------------------------------------- */
  DEFINE VARIABLE cErrorMsg         AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cTemp             AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cTemp2            AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE link-possible     AS LOGICAL                   NO-UNDO.
  DEFINE VARIABLE lError            AS LOGICAL                   NO-UNDO.

  DEFINE VARIABLE h_source          AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE h_target          AS HANDLE                    NO-UNDO.

  FOR EACH x_nadmlinks WHERE x_nadmlinks._active:
     FIND FIRST _admlinks WHERE RECID(_admlinks) = x_nadmlinks._admlinks-recid
     NO-ERROR.
     IF AVAILABLE _admlinks THEN
     DO:
         ASSIGN link-possible = YES.
         FIND FIRST so WHERE so._U-recid = INTEGER(_admlinks._link-source) NO-ERROR.
         IF AVAILABLE so THEN h_source = so._S-handle.
         FIND FIRST so WHERE so._U-recid = INTEGER(_admlinks._link-dest) NO-ERROR.
         IF AVAILABLE so THEN h_target = so._S-handle.
         RUN ok-sig-match (INPUT h_source,
                           INPUT h_target,
                           INPUT _admlinks._link-type,
                           INPUT NO,
                           OUTPUT link-possible,
                           OUTPUT cErrorMsg).
         IF NOT link-possible THEN
         ASSIGN 
            cTemp2 = "   ":U + x_nadmlinks._source-name + " -> " 
                  + _admlinks._link-type
                  + " -> "  + x_nadmlinks._target-name
            cTemp = cTemp + cTemp2 + " (" + cErrorMsg + ") " + CHR(10)
            lError = YES.
         ELSE
         DO:
            RUN ok-link (INPUT h_source,
                           INPUT h_target,
                           INPUT _admlinks._link-type,
                           INPUT NO,
                           OUTPUT link-possible,
                           OUTPUT cErrorMsg).
            IF NOT link-possible THEN
            ASSIGN 
            cTemp2 = "   ":U + x_nadmlinks._source-name + " -> " 
                  + _admlinks._link-type
                  + " -> "  + x_nadmlinks._target-name
            cTemp = cTemp + cTemp2 + " (" + cErrorMsg + ") " + CHR(10)
            lError = YES.
         END.

     END. /* found the _admlink */
  END. /* EACH x_nadmlinks */
  IF lError THEN 
      ASSIGN cTemp = 
         "The following links are invalid:" + CHR(10)
         + CHR(10) + cTemp.
  ELSE
      ASSIGN cTemp = 
         "All links are valid.".
  RUN adeuib/_advisor.w (
            /* Text        */ INPUT cTemp,
            /* Options     */ INPUT "",
            /* Toggle Box  */ INPUT FALSE,
            /* Help Tool   */ INPUT "ab":U,
            /* Context     */ INPUT {&Advisor_Link_Conflict},
            /* Choice      */ INPUT-OUTPUT cTemp,
            /* Never Again */ OUTPUT lError). 
END PROCEDURE. /* ckLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_linked _DEFAULT-DISABLE
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
  HIDE FRAME d_linked.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_linked _DEFAULT-ENABLE
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
  DISPLAY cb_Source cb_LinkType cb_target rs_show rs_sort cb_tofrom 
      WITH FRAME d_linked.
  ENABLE RECT-7 RECT-4 RECT-6 RECT-5 b_Close br_links b_Add b_Modify b_Remove 
         b_Help cb_Source cb_LinkType cb_target b_ckLinks rs_show rs_sort 
      WITH FRAME d_linked.
  {&OPEN-BROWSERS-IN-QUERY-d_linked}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Find_SOs d_linked 
PROCEDURE Find_SOs :
/* -----------------------------------------------------------
  Purpose:     Find SOs and their supported links
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER x_S FOR _S.
        
  DEFINE VARIABLE citem AS CHARACTER NO-UNDO. /* line item for combo-box */
  
  /* Find all smartobjects for this window and find out
   * what their links are
   */
  FOR EACH x_U WHERE x_U._TYPE          = "smartobject"      AND
                     x_U._WINDOW-HANDLE = x_P._WINDOW-HANDLE:
      FIND x_S WHERE RECID(x_S) = x_U._x-recid NO-ERROR.

      IF AVAILABLE x_S THEN DO:
          FIND so WHERE so.name = x_U._NAME NO-ERROR.
          IF NOT AVAILABLE so THEN DO:
              CREATE so.
              ASSIGN so.name     = x_U._NAME
                     so.type     = x_U._SUBTYPE
                     so._U-recid = RECID(x_U)
                     so._S-handle = x_S._HANDLE.
              IF admVersion LT "ADM2":U THEN DO:
                 RUN get-attribute IN x_S._HANDLE ('Supported-Links':U).
                 so.links = RETURN-VALUE.
              END. /* ADM1 */
              ELSE DO:
                ASSIGN
                 so.links = DYNAMIC-FUNCTION("getSupportedLinks":U IN x_S._HANDLE)
                 so.queryObject = DYNAMIC-FUNCTION("getQueryObject":U IN x_S._HANDLE) NO-ERROR.
              END. /* > ADM1 */

              IF x_U._STATUS = "DELETED" THEN so.active = NO.
          END.
      END.
  END. 
  /* Add additional objects that always exist */
  DO:
    CREATE so.
    ASSIGN so.name = "THIS-PROCEDURE":U
           so.type = "SmartContainer":U
           so.links = x_P._LINKS
           so._U-recid = precid
           so._S-handle = ?.
  END.    
  /* Check to see if there are any objects to link */
  IF NOT CAN-FIND(FIRST so) AND NOT CAN-FIND(FIRST _admlinks) THEN DO:
    MESSAGE "There are no SmartObjects available to link." VIEW-AS ALERT-BOX
        INFORMATION BUTTONS OK.
    RETURN "NONE".
  END.
  /* Setup nadmlinks */
  FOR EACH _admlinks WHERE _P-recid = precid:
    CREATE nadmlinks.
    ASSIGN nadmlinks._active = YES. 
    /* Find name of source */
    FIND so WHERE so._U-recid = INTEGER(_admlinks._link-source) NO-ERROR.
    IF NOT AVAILABLE (so) THEN DO: /* No 'so' rec, try x_U */
      FIND x_U WHERE RECID(x_U) = INTEGER(_admlinks._link-source) NO-ERROR.
      IF AVAILABLE x_U THEN DO:
        ASSIGN nadmlinks._source-name = x_U._NAME.
        /* If the object is not active, then just deactivate it */
        IF x_U._STATUS eq "DELETED" THEN nadmlinks._active = NO.
      END.
      ELSE DO: /* No 'so' or _U, try _P */
        FIND x_P WHERE RECID(x_P) = INTEGER(_admlinks._link-source) NO-ERROR.
        IF AVAILABLE x_P THEN ASSIGN nadmlinks._source-name = "THIS-PROCEDURE":U.
      END.
    END.
    ELSE
      ASSIGN nadmlinks._source-name = so.name
             nadmlinks._active      = so.active.
    /* Find name of target */
    FIND so WHERE so._U-recid = INTEGER(_admlinks._link-dest) NO-ERROR.
    IF NOT AVAILABLE (so) THEN DO:
      FIND x_U WHERE RECID(x_U) = INTEGER(_admlinks._link-dest) NO-ERROR.
      IF AVAILABLE x_U THEN DO:
        ASSIGN nadmlinks._target-name = x_U._NAME.
        /* If the object is not active, then just deactivate it */
        IF x_U._STATUS eq "DELETED" THEN nadmlinks._active = NO.
      END.
      ELSE DO:
        FIND x_P WHERE RECID(x_P) = INTEGER(_admlinks._link-dest) NO-ERROR.
        IF AVAILABLE x_P THEN ASSIGN nadmlinks._source-name = "THIS-PROCEDURE":U.
      END.
    END.
    ELSE
      ASSIGN nadmlinks._target-name = so.name
             /* _active may have been set to NO for source, if so, don't change it */
             nadmlinks._active      = (IF nadmlinks._active = YES THEN so.active ELSE NO).
    ASSIGN nadmlinks._admlinks-recid = RECID(_admlinks).
  END.
  
  /* get length of longest name */
  FOR EACH so:
    IF LENGTH(so.name) > litem THEN litem = LENGTH(so.name).
  END.
  
  /* Insert objects into the combos */
  FOR EACH so:   
    citem = so.name. 
    ASSIGN l = cb_source:ADD-LAST(citem)   IN FRAME {&FRAME-NAME}
           l = cb_target:ADD-LAST(citem)   IN FRAME {&FRAME-NAME}
           l = cb_tofrom:ADD-LAST(so.name) IN FRAME {&FRAME-NAME}.
  END.
  RUN Check_CustomLinks.
  /* Set up defaults and open the query */
  ASSIGN l = cb_source:ADD-FIRST("[ALL]")
         l = cb_target:ADD-FIRST("[ALL]")
         cb_source:SCREEN-VALUE   = "[ALL]"
         cb_target:SCREEN-VALUE   = "[ALL]"
         cb_linktype:SCREEN-VALUE = "[ALL]"
         rs_sort:SCREEN-VALUE     = "1".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reopen_Query d_linked 
PROCEDURE Reopen_Query :
/* -----------------------------------------------------------
  Purpose:     Reopen the query
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cb_tofromsv AS CHARACTER NO-UNDO.
   
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cb_source      = TRIM(SUBSTRING(cb_source:SCREEN-VALUE,1,litem))
           cb_linktype    = cb_linktype:SCREEN-VALUE
           cb_target      = TRIM(SUBSTRING(cb_target:SCREEN-VALUE,1,litem))
           cb_tofrom      = cb_tofrom:SCREEN-VALUE
           rs_sort        = INT(rs_sort:SCREEN-VALUE)
           rs_show        = INT(rs_show:SCREEN-VALUE)
           .
    IF rs_show = 1 THEN DO: /* ALL LINKS */ 
      ASSIGN cb_tofrom:SENSITIVE = no.         
      CASE rs_sort:
        WHEN 1 THEN
          OPEN QUERY br_links FOR EACH _admlinks
                                    WHERE (IF cb_linktype NE "[ALL]" THEN _link-type   EQ cb_linktype    ELSE TRUE) AND 
                                          _admlinks._P-recid = precid, 
                                  EACH nadmlinks 
                                    WHERE nadmlinks._active                                                         AND
                                          RECID(_admlinks) = nadmlinks._admlinks-recid                              AND
                                          (IF cb_source  NE "[ALL]" THEN _source-name EQ cb_source      ELSE TRUE)  AND
                                          (IF cb_target  NE "[ALL]" THEN _target-name EQ cb_target      ELSE TRUE)
                              BY nadmlinks._source-name.
        WHEN 2 THEN
          OPEN QUERY br_links FOR EACH _admlinks
                                    WHERE (IF cb_linktype NE "[ALL]" THEN _link-type   EQ cb_linktype    ELSE TRUE) AND 
                                          _admlinks._P-recid = precid, 
                                  EACH nadmlinks 
                                    WHERE nadmlinks._active                                                         AND
                                          RECID(_admlinks) = nadmlinks._admlinks-recid                              AND
                                          (IF cb_source  NE "[ALL]" THEN _source-name EQ cb_source      ELSE TRUE)  AND
                                          (IF cb_target  NE "[ALL]" THEN _target-name EQ cb_target      ELSE TRUE)
                              BY _admlinks._link-type.
        WHEN 3 THEN
          OPEN QUERY br_links FOR EACH _admlinks
                                    WHERE (IF cb_linktype NE "[ALL]" THEN _link-type   EQ cb_linktype    ELSE TRUE) AND 
                                          _admlinks._P-recid = precid, 
                                  EACH nadmlinks 
                                    WHERE nadmlinks._active                                                         AND
                                          RECID(_admlinks) = nadmlinks._admlinks-recid                              AND
                                          (IF cb_source  NE "[ALL]" THEN _source-name EQ cb_source      ELSE TRUE)  AND
                                          (IF cb_target  NE "[ALL]" THEN _target-name EQ cb_target      ELSE TRUE)
                              BY nadmlinks._target-name.
      END CASE.
    END.
    ELSE DO: /* show links for only one object */
      /* Find it in the list */
      DO i = 1 TO NUM-ENTRIES(cb_source:LIST-ITEMS):
        IF ENTRY(i,cb_source:LIST-ITEMS) BEGINS cb_tofrom AND 
           ENTRY(i,cb_source:LIST-ITEMS) NE "" THEN DO:
             cb_tofromsv = ENTRY(i,cb_source:LIST-ITEMS).
             LEAVE.
        END.
      END.
      ASSIGN cb_tofrom:SENSITIVE = YES
             cb_source = cb_tofrom
             cb_source:SCREEN-VALUE = cb_tofromsv
             cb_target = cb_tofrom
             cb_target:SCREEN-VALUE = cb_tofromsv
             cb_source:SENSITIVE = NO
             cb_target:SENSITIVE = NO
             .
             
      CASE rs_sort:
        WHEN 1 THEN
          OPEN QUERY br_links FOR EACH _admlinks
                                  WHERE (IF cb_linktype NE "[ALL]" THEN _link-type   EQ cb_linktype    ELSE TRUE)   AND 
                                          _admlinks._P-recid = precid, 
                                EACH nadmlinks 
                                  WHERE nadmlinks._active                                                           AND
                                          RECID(_admlinks) = nadmlinks._admlinks-recid                              AND
                                          (_source-name EQ cb_source                                                 OR
                                          _target-name EQ cb_target) 
                             BY nadmlinks._source-name.          
        WHEN 2 THEN
          OPEN QUERY br_links FOR EACH _admlinks
                                    WHERE (IF cb_linktype NE "[ALL]" THEN _link-type   EQ cb_linktype    ELSE TRUE)   AND 
                                            _admlinks._P-recid = precid, 
                                  EACH nadmlinks 
                                    WHERE nadmlinks._active                                                           AND
                                            RECID(_admlinks) = nadmlinks._admlinks-recid                              AND
                                            (_source-name EQ cb_source                                                 OR
                                            _target-name EQ cb_target) 
                               BY _admlinks._link-type.          
        WHEN 3 THEN
          OPEN QUERY br_links FOR EACH _admlinks
                                    WHERE (IF cb_linktype NE "[ALL]" THEN _link-type   EQ cb_linktype    ELSE TRUE)   AND 
                                            _admlinks._P-recid = precid, 
                                  EACH nadmlinks 
                                    WHERE nadmlinks._active                                                           AND
                                            RECID(_admlinks) = nadmlinks._admlinks-recid                              AND
                                            (_source-name EQ cb_source                                                 OR
                                            _target-name EQ cb_target) 
                               BY nadmlinks._target-name. 
      END CASE.         
    END. 
  END.
  
  /* Get the first record, if available, and desensitize relevant buttons*/
  IF br_links:NUM-SELECTED-ROWS = 1 THEN l = br_links:FETCH-SELECTED-ROW (1).
  IF b_Modify:SENSITIVE ne AVAILABLE _admlinks THEN 
  DO:
     ASSIGN 
        b_Modify:SENSITIVE = AVAILABLE _admlinks
        b_Remove:SENSITIVE = b_Modify:SENSITIVE.
     IF admVersion >= "ADM2":U THEN
        ASSIGN b_ckLinks:SENSITIVE = AVAILABLE _admlinks.
     ELSE 
        ASSIGN b_ckLinks:HIDDEN = TRUE.
  END. /* modify sensitive but no available record */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
