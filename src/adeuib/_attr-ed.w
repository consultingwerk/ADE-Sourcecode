&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports2000       PROGRESS
*/
&Scoped-define WINDOW-NAME properties_window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS properties_window 
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

  File: _attr-ed.w

  Description: Applies a group of attributes to all the selected objects.
               First it shows the current values.  It does this with a 
               floating window that is run persistent.
  
  Entry Points:
      <startup> - creates the window and shows the attributes for the 
                  currently selected widgets.                  
      show-attributes - run this to update the display when the selected
                  widget changes.
      move-to-top - pops the window to the top (and forces it visible).
                                          
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Wm. T. Wood
  Created: 10/01/94 -  9:32 am
  Updated:  7/19/95 wood  Change name to 'Group Properties'
                          Remove VBX logic      
            3/26/98 adams Updated for Skywalker 9.0a
                          Change name to "Properties Window"
            7/11/98 hd    Added user fields
            9/19/98 hd    Format and Data-Type 
            8/20/99 adams Added support for LIST-ITEM-PAIRS
            6/15/00 hd    hd    Resizable (As recreational work) 
                                            
  Note: There is currently NO logic to handle editing of both DATA-TYPE and TYPE.  
        WebObjects can ONLY edit DATA-TYPE and other Objects can only edit TYPE.
     Resize :
         DESIGN-TIME  
         - The resizeObject does not size the browse column the first time 
           Make sure the width of the last browse column in DISPLAY is adjusted 
           if the design-time width of the window is changed.
           (or make it 100% dynamic)
         - Ensure that the Browse and Window has the 'same' size. 
         MIN-<size>  
         - xdMin* variables below, used in modify-Layout.   
         MAX-<size>
         - xdMax* variables below, used in adjustSize() and modify-layout.
           INCREASE maxHeight if new tt added!
         - MAX-HEIGHT automatically adjusted to fit number of rows when 
           Window-state =maximized.                  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Do NOT create an unnamed widget pool.  This routine will RECREATE
   objects.  We do not want any widgets to be "parented" to this procedure.
   (Otherwise, those widgets will be destroyed when this procedure exits,
   and we will have _U records with invalid _U._HANDLE's. ) */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE custom-lists AS CHAR    NO-UNDO.
DEFINE VARIABLE ldummy       AS LOGICAL NO-UNDO.
DEFINE VARIABLE lListItems   AS LOGICAL NO-UNDO.
DEFINE VARIABLE s            AS INTEGER NO-UNDO.
DEFINE VARIABLE r_current    AS RECID   NO-UNDO.
DEFINE VARIABLE valid-types  AS CHAR    NO-UNDO.
DEFINE VARIABLE valid-dtypes AS CHAR    NO-UNDO 
  INITIAL "Character,Date,Decimal,Integer,Logical":U.
DEFINE VARIABLE web_object   AS LOGICAL NO-UNDO.

DEFINE VARIABLE giNumResults    AS INT  NO-UNDO.

/*** MIN MAX Constants ***/ 
/* MaxHeight currently 1 more than max possible tt visible */
DEFINE VARIABLE xdMaxHeight     AS DEC  NO-UNDO INIT 22. 
/* MaxWidth, somewhat random; not to wide, not to small (?) */
DEFINE VARIABLE xdMaxWidth      AS DEC  NO-UNDO INIT 85. 
/* MinHeight, minimum 2 browse rows */
DEFINE VARIABLE xdMinHeight     AS DEC  NO-UNDO INIT 3.
/* MiunWidth, show some data in last col */
DEFINE VARIABLE xdMinWidth      AS DEC  NO-UNDO INIT 28.


/* Shared UIB Definitions ---                                           */
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/layout.i}               /* Definitions of the layout records        */
{adeuib/property.i}             /* Temp-Table containing attribute info     */
{adeuib/sharvars.i}             /* Shared Variable Definitions records.     */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */
{adeweb/htmwidg.i}              /* HTML Definitions for WEB support         */

/* Buffer Definitions */
DEFINE BUFFER first_U  FOR _U.
DEFINE BUFFER first_L  FOR _L.
DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER x_P      FOR _P.
DEFINE BUFFER ip_F     FOR _F.

/* Define a Temp-Table on all the attributes that we will allow the
   user to change here */
DEFINE TEMP-TABLE tt NO-UNDO
    FIELD attr-name  AS CHAR FORMAT "X(16)"
    FIELD attr-label AS CHAR FORMAT "X(16)"
    FIELD attr-value AS CHAR FORMAT "X(256)" /* width is in DISPLAY */
    FIELD indx-name  AS CHAR FORMAT "X(32)" /* WEB: */
    FIELD type       AS CHAR FORMAT "X(10)"
    FIELD in-use     AS LOGICAL 
    FIELD expanded   AS CHAR
    FIELD hidden     AS LOGICAL INITIAL no
  INDEX indx-name IS PRIMARY indx-name
  INDEX attr-name            attr-name.

/* Function prototypes */
FUNCTION validate-format RETURNS LOGICAL
  (INPUT pformat AS CHARACTER, 
   INPUT pdataType AS CHARACTER) IN _h_func_lib.

/* Function prototypes */
FUNCTION change-data-type RETURNS LOGICAL
  (INPUT p_UHandle    AS HANDLE, 
   INPUT pNewDataType AS CHARACTER) IN _h_func_lib.

FUNCTION compile-userfields RETURNS CHARACTER
  (INPUT p_U_PRecid AS RECID) IN _h_func_lib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f
&Scoped-define BROWSE-NAME brws-attr

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt

/* Definitions for BROWSE brws-attr                                     */
&Scoped-define FIELDS-IN-QUERY-brws-attr tt.expanded NO-LABEL tt.attr-label tt.attr-value   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brws-attr   
&Scoped-define SELF-NAME brws-attr
&Scoped-define OPEN-QUERY-brws-attr OPEN QUERY brws-attr FOR EACH tt WHERE tt.in-use AND NOT tt.hidden. adjustSize().
&Scoped-define TABLES-IN-QUERY-brws-attr tt
&Scoped-define FIRST-TABLE-IN-QUERY-brws-attr tt


/* Definitions for FRAME f                                              */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b_reject b_accept cb-options brws-attr 
&Scoped-Define DISPLAYED-OBJECTS cb-options 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-6 b_accept 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD adjustSize properties_window 
FUNCTION adjustSize RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD init-tt-initial-value properties_window 
FUNCTION init-tt-initial-value RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD windowHeightFromDown properties_window 
FUNCTION windowHeightFromDown RETURNS DECIMAL
  ( piRows AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR properties_window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_accept 
     IMAGE-UP FILE "adeicon/check":U
     LABEL "v" 
     SIZE 4 BY 1 TOOLTIP "Accept"
     BGCOLOR 8 .

DEFINE BUTTON b_more 
     LABEL "..." 
     SIZE 4 BY 1.1.

DEFINE BUTTON b_reject 
     IMAGE-UP FILE "adeicon/cross":U
     LABEL "X" 
     SIZE 4 BY 1 TOOLTIP "Reject"
     BGCOLOR 8 .

DEFINE VARIABLE cb-options AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Yes","No" 
     DROP-DOWN-LIST
     SIZE 29.8 BY 1 NO-UNDO.

DEFINE VARIABLE fi-char AS CHARACTER FORMAT "x(256)":U INITIAL "0" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE fi-decimal AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 24.8 BY 1 NO-UNDO.

DEFINE VARIABLE fi-integer AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 24.8 BY .95 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brws-attr FOR 
      tt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brws-attr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brws-attr properties_window _FREEFORM
  QUERY brws-attr NO-LOCK DISPLAY
      tt.expanded    FORMAT "X(1)" NO-LABEL
      tt.attr-label
      tt.attr-value  WIDTH 19
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 42.4 BY 9
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f
     b_reject AT ROW 1 COL 1
     b_accept AT ROW 1 COL 5
     fi-char AT ROW 1 COL 7.2 COLON-ALIGNED NO-LABEL
     fi-decimal AT ROW 1 COL 7.2 COLON-ALIGNED NO-LABEL
     cb-options AT ROW 1 COL 7.2 COLON-ALIGNED NO-LABEL
     fi-integer AT ROW 1 COL 9.2 NO-LABEL
     b_more AT ROW 1 COL 39
     brws-attr AT ROW 2 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY NO-HELP 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW properties_window ASSIGN
         HIDDEN             = YES
         TITLE              = "Properties Window"
         HEIGHT             = 10
         WIDTH              = 42.4
         MAX-HEIGHT         = 34.33
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 34.33
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT properties_window:LOAD-ICON("adeicon/uib%":U) THEN
    MESSAGE "Unable to load icon: adeicon/uib%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW properties_window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f
   Size-to-Fit                                                          */
/* BROWSE-TAB brws-attr b_more f */
ASSIGN 
       FRAME f:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON b_accept IN FRAME f
   6                                                                    */
/* SETTINGS FOR BUTTON b_more IN FRAME f
   NO-ENABLE                                                            */
ASSIGN 
       b_more:HIDDEN IN FRAME f           = TRUE.

ASSIGN 
       b_reject:HIDDEN IN FRAME f           = TRUE.

/* SETTINGS FOR FILL-IN fi-char IN FRAME f
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-char:HIDDEN IN FRAME f           = TRUE.

/* SETTINGS FOR FILL-IN fi-decimal IN FRAME f
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-decimal:HIDDEN IN FRAME f           = TRUE.

/* SETTINGS FOR FILL-IN fi-integer IN FRAME f
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fi-integer:HIDDEN IN FRAME f           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(properties_window)
THEN properties_window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brws-attr
/* Query rebuild information for BROWSE brws-attr
     _START_FREEFORM
OPEN QUERY brws-attr FOR EACH tt WHERE tt.in-use AND NOT tt.hidden.
adjustSize().
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE brws-attr */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME properties_window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL properties_window properties_window
ON END-ERROR OF properties_window /* Properties Window */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* "Eat" the standard END- events. */   
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL properties_window properties_window
ON HELP OF properties_window /* Properties Window */
ANYWHERE DO:
  RUN adecomm/_adehelp.p ( "ab", "CONTEXT", {&Attributes_Window} , ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL properties_window properties_window
ON WINDOW-CLOSE OF properties_window /* Properties Window */
DO:
  /* Close up this when the user closes */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL properties_window properties_window
ON WINDOW-MAXIMIZED OF properties_window /* Properties Window */
DO:
  adjustSize(). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL properties_window properties_window
ON WINDOW-RESIZED OF properties_window /* Properties Window */
DO:
  RUN resizeObject(SELF:HEIGHT, SELF:WIDTH).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL properties_window properties_window
ON WINDOW-RESTORED OF properties_window /* Properties Window */
DO:
  adjustSize(). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brws-attr
&Scoped-define SELF-NAME brws-attr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brws-attr properties_window
ON DEFAULT-ACTION OF brws-attr IN FRAME f
DO: /* When the value of the query changes, then change the type of 
       display */
       
  DEFINE VARIABLE lOK           AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lListItems    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lNewAttribute AS LOGICAL NO-UNDO.

  CASE tt.type:
    WHEN "L" THEN DO: /* Logical */ 
      /* the check for hidden was done for "userfields", but its a general rule */
      IF cb-options:HIDDEN = FALSE THEN
      DO:
        IF tt.attr-value eq "yes" THEN tt.attr-value = "no".
        ELSE tt.attr-value = "yes".  /* If it was NO, or Unknown */
        DISPLAY tt.attr-value WITH BROWSE brws-attr.
        lNewAttribute = YES.
      END.  
    END.
    WHEN "D" THEN DO: /* Decimal */ 
      APPLY "ENTRY" TO fi-decimal IN FRAME f.
      fi-decimal:AUTO-ZAP = TRUE.
    END.
    WHEN "I" THEN DO: /* Integer */ 
      APPLY "ENTRY" TO fi-integer IN FRAME f.
      fi-integer:AUTO-ZAP = TRUE.
    END.
    WHEN "C" THEN DO: /* Character */ 
      APPLY "ENTRY" TO fi-char IN FRAME f.
      fi-char:AUTO-ZAP = TRUE.
    END.
    WHEN "FONT" OR WHEN "COLOR" THEN DO:
      RUN popup-action (OUTPUT lOK) .
      IF lOK THEN DO:
        tt.attr-value = STRING(fi-integer).
        DISPLAY tt.attr-value WITH BROWSE brws-attr.
        lNewAttribute = YES.
      END.
    END.      
    WHEN "PROPERTIES" THEN DO:
      RUN popup-action (OUTPUT lOK) .
      IF lOK THEN  
      DO:
        IF tt.attr-label <> "QUERY" THEN
          FIND _F WHERE RECID(_F) eq first_U._x-recid.

        ASSIGN
          lListItems  = (_F._LIST-ITEMS NE ? AND _F._LIST-ITEMS NE "") OR
                        (_F._LIST-ITEM-PAIRS EQ ? OR _F._LIST-ITEM-PAIRS EQ "")
          tt.attr-label = (IF lListItems THEN "List-Items" ELSE "List-Item-Pairs").

        CASE tt.attr-label:
          WHEN "Format":U THEN
            ASSIGN lNewAttribute = (tt.attr-value <> _F._FORMAT)
                   tt.attr-value = _F._FORMAT.
          WHEN "List-Items":U THEN
            ASSIGN lNewAttribute = (tt.attr-value <> REPLACE(_F._LIST-ITEMS, CHR(10), ","))
                   tt.attr-value = REPLACE(_F._LIST-ITEMS, CHR(10), ",").
          WHEN "List-Item-Pairs":U THEN
            ASSIGN lNewAttribute = (tt.attr-value <> REPLACE(_F._LIST-ITEM-PAIRS, CHR(10), ","))
                   tt.attr-value = REPLACE(_F._LIST-ITEM-PAIRS, CHR(10), ",").
          WHEN "Radio-Buttons" THEN
            ASSIGN lNewAttribute = (tt.attr-value <> REPLACE(_F._LIST-ITEMS, CHR(10), ""))
                   tt.attr-value = REPLACE(_F._LIST-ITEMS, CHR(10), "").
          WHEN "Query" THEN
            ASSIGN lNewAttribute = No
                   tt.attr-value = "".
        END CASE.
        DISPLAY tt.attr-label tt.attr-value WITH BROWSE brws-attr.
      END.
    END.      
    WHEN "GROUP" THEN RUN expand-group IN THIS-PROCEDURE.
    OTHERWISE RETURN. /* this type has no default action */
  END CASE.  
  
  /* If we changed the value of the attribute on the default action, then
     apply the change to the selected _U records and redisplay. */
  IF lNewAttribute THEN DO:
    RUN apply-attribute (RECID(tt)).
    /* Redisplay the current attribute */
    RUN display-value.
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brws-attr properties_window
ON VALUE-CHANGED OF brws-attr IN FRAME f
DO:
  RUN display-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_accept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_accept properties_window
ON CHOOSE OF b_accept IN FRAME f /* v */
OR RETURN OF cb-options, fi-char, fi-decimal, fi-integer
DO:     
  DEFINE VAR l-OK AS LOGICAL NO-UNDO.
  DEFINE VAR new-value AS CHARACTER NO-UNDO.
  
  /* Make sure we have a valid temp-table record */
  FIND tt WHERE RECID(tt) eq r_current NO-ERROR.
  IF NOT AVAILABLE tt THEN RETURN.
  
  /* Copy the value from the current fill-in to the tt record */
  CASE tt.type:
    WHEN "L"    OR
    WHEN "TYPE" OR
    WHEN "DATA-TYPE" THEN      
      new-value = IF NOT cb-options:HIDDEN THEN cb-options:SCREEN-VALUE
                  ELSE tt.attr-value. 
    WHEN "D" THEN  /* Decimal */ 
      new-value = IF NOT fi-decimal:HIDDEN THEN fi-decimal:SCREEN-VALUE
                  ELSE tt.attr-value.
    WHEN "C" THEN  /* Character */ 
      new-value = IF NOT fi-char:HIDDEN THEN fi-char:SCREEN-VALUE
                  ELSE tt.attr-value.
    WHEN "I"     OR /* Integer */ 
    WHEN "FONT"  OR 
    WHEN "COLOR" THEN   
      new-value = IF NOT fi-integer:HIDDEN THEN fi-integer:SCREEN-VALUE
                  ELSE tt.attr-value.
  END CASE.    
  /* Has the value changed?  If so, then assign the new value and apply it to
     the selected widgets. Also display the new value. */
  IF new-value ne tt.attr-value THEN DO: 
    tt.attr-value = new-value.
    /* Actually copy the value to the selected _U records. */
    RUN apply-attribute (RECID(tt)).
    /* Redisplay the current attribute.  Note: for geometry attributes, we
       need to do more than just display -- we need to compute the values. */
    
    IF tt.attr-name BEGINS "Geometry.":U THEN RUN show-geometry.
    ELSE DO:
      DISPLAY tt.attr-value WITH BROWSE brws-attr.
      /* Show the value in the fill-in at top of window. */
      RUN display-value.
      /* userfield has error handling in apply-attribute so skip the error 
         message here */                   
      IF tt.attr-name = "UserField" THEN RETURN. 
    END.    
    
    /* Was there a problem setting the value? Check the value against
       the current display. */
    CASE tt.type:
      /* Combo box */
      WHEN "L"    OR  
      WHEN "TYPE" OR 
      WHEN "DATA-TYPE" THEN  
        l-OK = (new-value eq cb-options:SCREEN-VALUE).
      WHEN "D" THEN DO: /* Decimal */ 
        l-OK = (new-value eq fi-decimal:SCREEN-VALUE).
        /* If there was a problem, then check if the value was "close".
           We don't want to give errors about pixel-roundoff.  Check for
           a 0.5 PPU difference on Geometry values. */
        IF NOT l-OK and tt.attr-name BEGINS "Geometry":U THEN DO:
          ASSIGN fi-decimal.
          IF ABS( fi-decimal - DECIMAL(new-value)) < 0.5 THEN l-OK = yes.
        END.
      END.      
      /* Integer, Font or Color */  
      WHEN "I"    OR
      WHEN "FONT" OR 
      WHEN "COLOR" THEN       
        l-OK = (new-value eq fi-integer:SCREEN-VALUE).
      WHEN "C" THEN  /* Character */ 
        l-OK = (new-value eq  fi-char:SCREEN-VALUE).
    END CASE.       
    IF NOT l-OK THEN DO:
      MESSAGE tt.attr-name SKIP(1)
              "The new value could not be applied to " +
              (IF CAN-FIND (FIRST _U WHERE _U._SELECTEDib 
                                       AND _U._HANDLE ne first_U._HANDLE)
               THEN "one or more selected object." 
               ELSE first_U._NAME + ".":U)
             VIEW-AS ALERT-BOX WARNING IN WINDOW {&WINDOW-NAME}.
    END.   
    
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_more
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_more properties_window
ON CHOOSE OF b_more IN FRAME f /* ... */
DO:
  DEFINE VARIABLE lOK AS LOGICAL NO-UNDO.

  /* Do the default action */
  RUN popup-action (OUTPUT lOK).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_reject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_reject properties_window
ON CHOOSE OF b_reject IN FRAME f /* X */
DO:        
  /* Redisplay the current attribute. */
  RUN display-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK properties_window 


/* ***************************  Main Block  *************************** */

/* UIB Group Triggers (simulate Main Menu Accelerators) */
/* If we ever enable the browse here for editing, these could cause
   problems and may have to be removed. -jep 12/11/98 */
{adeuib/grptrig.i &of-widget-list="OF brws-attr"}

/* BUG: the UIB is losing this value on a save. So explicitly set it. */
brws-attr:NUM-LOCKED-COLUMNS = 2.

/* Parent the window to the UIB's main window (and position it accordingly). */
IF VALID-HANDLE(_h_menu_win) THEN DO:
  {&WINDOW-NAME}:PARENT = _h_menu_win.
  IF (_h_menu_win:X + _h_menu_win:WIDTH-P + {&WINDOW-NAME}:WIDTH-P + 10 ) < 
     SESSION:WIDTH-P 
  THEN ASSIGN /* Attribute window can fit beside the UIB Main window */
            {&WINDOW-NAME}:X = (_h_menu_win:X + _h_menu_win:WIDTH-P + 10)
            {&WINDOW-NAME}:Y = _h_menu_win:Y 
            .
  ELSE ASSIGN /* Attribute window below the UIB Main window.  Allow 2
                 rows (about) is the height of the Menu bar and title of
                 the UIB Main Window. */
            {&WINDOW-NAME}:X = SESSION:WIDTH-P - {&WINDOW-NAME}:WIDTH-P - 10
            {&WINDOW-NAME}:Y = _h_menu_win:Y + _h_menu_win:HEIGHT-P + 
                               &IF "{&WINDOW-SYSTEM}" eq "OSF/Motif" &THEN 80
                               &ELSE SESSION:PIXELS-PER-ROW * 2 &ENDIF
            .
END.
                      
/* Do not set CURRENT-WINDOW: this should not parent dialog-boxes and frames. */
THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE
  RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
  
/* Create the Temp-table of attributes */
RUN create-tt.

/* Size the Window and Widgets based on the system fonts and widget sizes */
RUN Modify-Layout.
      
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI. 
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* Define standard Procedure that indicates that this is a
   persistent procedure the ADE should not get rid of. */
{ adecomm/_adetool.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE apply-attribute properties_window 
PROCEDURE apply-attribute :
/* -----------------------------------------------------------------
  Purpose:     For the given attribute in the property sheet, apply
               the current values to all the selected objects. 
  Parameters:  p_ttRecid - the recid of the "current" attribute.
  Notes:       
 -------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_ttRecid AS RECID NO-UNDO.
  DEFINE VARIABLE indx  AS INTEGER NO-UNDO.
  DEFINE VARIABLE categ AS CHAR    NO-UNDO.
 
  DEFINE BUFFER ipTT FOR tt.
  
  FIND ipTT WHERE RECID(ipTT) eq p_ttRecid.
  categ = ENTRY(1, ipTT.attr-name, ".":U).
  IF categ eq "Geometry":U THEN DO:
    /* Handle geometry seperately. */
    RUN apply-geometry (ENTRY(2, ipTT.attr-name, "."), 
                        IF ipTT.TYPE eq "I":U
                        THEN INTEGER(ipTT.attr-value)
                        ELSE DECIMAL(ipTT.attr-value)) .
    /* NOTE: apply-geometry sets the window-saved flag. */    
  END.                                 /* WEB: */
  ELSE IF CAN-DO ("DATA-TYPE,LABEL,INITIAL-VALUE,NAME,TYPE,USERFIELD":U, ipTT.attr-name)  THEN DO:
    /* These attributes apply only to a single widget. */
    IF AVAILABLE first_U THEN DO:
      FIND _U WHERE RECID(_U) eq RECID(first_U).

      CASE ipTT.attr-name:
        WHEN "LABEL":U THEN         RUN change_label (ipTT.attr-value).
        WHEN "NAME":U THEN          RUN change_name (ipTT.attr-value).
        WHEN "TYPE":U THEN          RUN metamorph (ipTT.attr-value).
        /* WEB: */
        WHEN "DATA-TYPE":U THEN     RUN change_datatype (ipTT.attr-value).       
        WHEN "INITIAL-VALUE":U THEN RUN change_initval (ipTT.attr-value).
        WHEN "USERFIELD":U THEN     RUN change_userfield (ipTT.attr-value).
      END CASE.    
      /* Note that the window changed */
      RUN adeuib/_winsave.p (_h_win, FALSE).    
    END. /* IF AVAIL first_U... */
  END. /* ELSE IF ...only one selected ... */

  ELSE IF categ ne "GROUP":U THEN DO:  
    /* Loop through all the selected widgets. (Note that first_U can be
       a dialog-box or window, which won't be "selected"). */
    FOR EACH _U WHERE (_U._SELECTEDib OR _U._HANDLE eq first_U._HANDLE):
      CASE categ:
        WHEN "Custom Lists":U THEN DO:
          /* The list is "Custom Lists.List-1" -- get the index */
          indx = INTEGER(ENTRY(2,ipTT.attr-name, "-")).
          _U._User-List[indx] = (ipTT.attr-value eq "yes").
        END.
        WHEN "FORMAT" THEN DO:
          FIND _F WHERE RECID(_F) eq _U._x-recid.                     
          If validate-format(ipTT.attr-value,_F._DATA-TYPE) THEN
            ASSIGN _F._FORMAT = ipTT.attr-value. 
        END.
        WHEN "DISPLAY":U THEN _U._DISPLAY = (ipTT.attr-value eq "yes":U).
        WHEN "ENABLE":U  THEN _U._ENABLE  = (ipTT.attr-value eq "yes":U).
        WHEN "HIDDEN":U  THEN _U._HIDDEN  = (ipTT.attr-value eq "yes":U).
        WHEN "FONT" THEN DO:
          /* Make sure the font is valid. */
          fi-integer = IF ipTT.attr-value eq ? THEN ? ELSE INTEGER(ipTT.attr-value).
          IF fi-integer ne ? AND 
             (fi-integer < 0 OR fi-integer > FONT-TABLE:NUM-ENTRIES)
          THEN MESSAGE "Invalid Font: " STRING(fi-integer) SKIP (1)
                       "Font number must be between 0 and " 
                       STRING(FONT-TABLE:NUM-ENTRIES) + "."
                       VIEW-AS ALERT-BOX ERROR.
          ELSE DO:
            FIND _L WHERE RECID(_L) eq _U._lo-recid.   
            /* We simulate BROWSE's using a fixed font. Otherwise, copy the font
               to the widget itself. */
            IF _U._TYPE eq "BROWSE":U 
            THEN ASSIGN _L._FONT        = fi-integer.
            ELSE ASSIGN _U._HANDLE:FONT = fi-integer 
                        _L._FONT        = _U._HANDLE:FONT.
          END.
        END.
        WHEN "NATIVE":U  THEN DO:
          FIND _F WHERE RECID(_F) eq _U._x-recid.
          _F._NATIVE = (ipTT.attr-value eq "yes").
        END.
        WHEN "PRIVATE-DATA" THEN _U._PRIVATE-DATA = ipTT.attr-value.
        WHEN "SORT":U  THEN DO:
          FIND _F WHERE RECID(_F) eq _U._x-recid.
          ASSIGN _F._SORT = (ipTT.attr-value eq "yes").
        END.
        WHEN "MULTIPLE":U THEN DO:
          FIND _F WHERE RECID(_F) eq _U._x-recid.
          ASSIGN _F._MULTIPLE = (ipTT.attr-value eq "yes").
        END.
      END CASE.
    END. /* for each...selected... */   
      
    /* Note that the window changed */
    RUN adeuib/_winsave.p (_h_win, FALSE).

  END. /* ELSE IF...ne GROUP...*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE apply-geometry properties_window 
PROCEDURE apply-geometry :
/*------------------------------------------------------------------------------
  Purpose: Adjust ROW,COL,HEIGHT and WIDTH of the current _U & _L records.
  Parameters: pAttr = Attribute (eg. ROW)
              pVal  = Value (eg. 1.0)
  Notes: Dialog-box and SmartObjects are handled with special case.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pAttr AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER pVal  AS DECIMAL NO-UNDO.
  
  DEFINE VAR dHorz AS DECIMAL NO-UNDO.
  DEFINE VAR dVert AS DECIMAL NO-UNDO.
  DEFINE VAR l_Changed AS LOGICAL NO-UNDO.
  DEFINE VAR hWindow AS WIDGET NO-UNDO.
  
  /* Loop through all the selected widgets. */
  /* Loop through all the selected widgets. (Note that first_U can be
     a dialog-box or window, which won't be "selected"). */
  FOR EACH _U WHERE (_U._SELECTEDib OR _U._HANDLE eq first_U._HANDLE),
      EACH _L WHERE RECID(_L) eq _U._lo-recid:
    /* Handle geometry based on TYPE of the object. */
    CASE _U._TYPE:
      WHEN "DIALOG-BOX":U THEN DO:
        /* Dialog-boxes are not moved at design time.  Also, size the "hidden"
           window just like the frame. */
        hWindow = _U._HANDLE:PARENT.
        CASE pAttr:
          WHEN "ROW":U THEN 
            ASSIGN _L._ROW = pVal.
          WHEN "COLUMN":U THEN
            ASSIGN _L._COL = pVal.
          WHEN "HEIGHT":U THEN 
            ASSIGN _U._HANDLE:HEIGHT = pVal * _L._ROW-MULT 
                   hWindow:HEIGHT    = _U._HANDLE:HEIGHT
                   _L._HEIGHT        = _U._HANDLE:HEIGHT / _L._ROW-MULT
                 NO-ERROR.
          WHEN "WIDTH":U THEN 
            ASSIGN _U._HANDLE:WIDTH = pVal * _L._COL-MULT
                   hWindow:WIDTH    = _U._HANDLE:WIDTH
                   _L._WIDTH        = _U._HANDLE:WIDTH / _L._COL-MULT 
                 NO-ERROR.
        END CASE. /* pAttr */
      END.
      OTHERWISE DO:
        /* Use SET-POSITION and SET-SIZE for SmartObjects that support it.
           Otherwise just copy to the widgets directly. */
        IF _U._TYPE ne "SmartObject":U THEN l_changed = NO.
        ELSE DO:
          /* Does the object support SET-POSITION and SET-SIZE? */
          FIND _S WHERE RECID(_S) eq _U._x-recid.
          IF CAN-DO ("ROW,COLUMN":U, pAttr) THEN DO:
            /* Let the code below handle the moving of the widget unless it
               has its own visualization. */
           IF NOT _S._visual THEN l_changed = NO.
           ELSE DO:   
              /* Change Position. Note that set-position takes two attributes
                 so we need to just read the other value from the object itself. 
                 (So only the value we want to change will change.) */
              IF pAttr = "Row":U
              THEN ASSIGN dVert = 1.0 + ((pVal - 1.0) * _L._ROW-MULT) 
                          dHorz = _U._HANDLE:COLUMN.
              ELSE ASSIGN dVert = _U._HANDLE:ROW.
                          dHorz = 1.0 + ((pVal - 1.0) * _L._COL-MULT).
              FIND x_P WHERE x_P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
              IF _P._adm-version < "ADM2" THEN
                RUN set-position IN _S._HANDLE (dVert, dHorz) NO-ERROR.
              ELSE
                RUN repositionObject IN _S._HANDLE (dVert, dHorz) NO-ERROR.
            END. /* IF...visual... */
          END. /* IF..ROW,COLUMN... */
          ELSE DO:
            /* Change Size.  Again, we set one value new, but use the
               object itself to find out the other value. We use a common
               routine "setsize" that calls "set-size" in visual objects,
               and that automatically resizes our visualization. */
            IF pAttr = "Height":U
            THEN RUN adeuib/_setsize.p (RECID(_U), pVal * _L._ROW-MULT, ?).
            ELSE RUN adeuib/_setsize.p (RECID(_U), ? , pVal * _L._COL-MULT).
            l_changed = YES.
          END. /* IF not...ROW,COL... */
        END. /* IF...SmartObject... */
        
        /* If we haven't changed the value already, then just copy 
           the value to the widget.  */
        IF NOT l_Changed THEN DO:
        
         /* In Dialog-boxes and Frames that are not SCROLLABLE, compute
            the minimum size allowed. */
         IF CAN-DO ("DIALOG-BOX,FRAME":U, _U._TYPE) AND 
            CAN-DO ("HEIGHT,WIDTH":U, pAttr)
         THEN DO:
           FIND _C WHERE RECID(_C) eq _U._x-recid.
           IF NOT _C._SCROLLABLE THEN DO:
             RUN adeuib/_minsize (RECID(_U), ?, OUTPUT dVert, OUTPUT dHorz).
             IF pAttr eq "HEIGHT":U AND pVal < dVert THEN pVal = dVert.
             ELSE IF pAttr eq "WIDTH":U AND pVal < dHorz THEN pVal = dHorz.
           END.
           /* In a SIZE-TO-PARENT frame, resize the parent window. We do this 
              first because that will guarantee the VIRTUAL-SIZE of the window 
              will be able to accomodate a growing frame. */
           IF _U._TYPE eq "FRAME":U AND _U._size-to-parent THEN
           RUN resize-window (pAttr, pVal).         
         END.
         
         CASE pAttr:
            WHEN "ROW":U THEN 
              ASSIGN _U._HANDLE:ROW = 1.0 + ((pVal - 1.0) * _L._ROW-MULT) 
                   NO-ERROR.
            WHEN "COLUMN":U THEN
              ASSIGN _U._HANDLE:COLUMN = 1.0 + ((pVal - 1.0) * _L._COL-MULT) 
                   NO-ERROR.
            WHEN "HEIGHT":U THEN 
              ASSIGN _U._HANDLE:HEIGHT = pVal * _L._ROW-MULT 
                   NO-ERROR.
            WHEN "WIDTH":U THEN 
              ASSIGN _U._HANDLE:WIDTH = pVal * _L._COL-MULT
                   NO-ERROR.
          END CASE. /* pAttr */
        END. /* IF NOT l_Changed... */
        
        /* Now copy the values back to the _L record.
           This will handle any errors where the value could not be set. */
        CASE pAttr:
          WHEN "ROW":U THEN
            _L._ROW = 1.0 + ((_U._HANDLE:ROW - 1.0) / _L._ROW-MULT).
          WHEN "COLUMN":U THEN
            _L._COL = 1.0 + ((_U._HANDLE:COLUMN - 1.0) / _L._COL-MULT).
          WHEN "HEIGHT":U THEN 
            _L._HEIGHT = _U._HANDLE:HEIGHT / _L._ROW-MULT.
          WHEN "WIDTH":U THEN 
            _L._WIDTH = _U._HANDLE:WIDTH / _L._COL-MULT .
        END CASE. /* pAttr */
        
        /* Reset labels, if necessary. */
        IF CAN-DO ("COMBO-BOX,FILL-IN,EDITOR,SELECTION-LIST", _U._TYPE)
           AND pAttr ne "WIDTH" AND _U._l-recid NE ? THEN
          RUN adeuib/_showlbl.p (_U._HANDLE).
            
      END.
    END CASE. /*... _U._TYPE: */
  END. /* FOR EACH _U... */
      
  /* Note that the window changed */
  RUN adeuib/_winsave.p (_h_win, FALSE).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_datatype properties_window 
PROCEDURE change_datatype :
/*------------------------------------------------------------------------------
  Purpose:     Change datatype of the current widget.   
  Parameters:  pAttrValue - the new data-type
  Notes:       _U of the widget must be available.
               Change of data-type requires change to format, initial-value 
               and list-items.        
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pAttrValue AS CHAR NO-UNDO.
  
  IF change-data-type(_U._HANDLE,pAttrValue) THEN
  DO:
    FIND _F WHERE RECID(_F) eq _U._x-recid.                             
             
    FIND TT WHERE TT.attr-name = "INITIAL-VALUE":U NO-ERROR.
    IF AVAIL TT THEN init-tt-initial-value().
            
    FIND TT WHERE TT.attr-name = "FORMAT":U NO-ERROR.
    IF AVAIL TT THEN TT.attr-value = _F._FORMAT.
             
    IF CAN-DO("RADIO-SET,SELECTION-LIST",_U._TYPE) THEN
    DO:
      FIND TT WHERE TT.attr-name = "PROPERTIES":U NO-ERROR.
      IF AVAIL TT THEN tt.attr-value = REPLACE(_F._LIST-ITEMS, CHR(10), ",":U).           
    END.
                        
    {&BROWSE-NAME}:REFRESH() IN FRAME {&FRAME-NAME}.
    /* This makes the available TT to be the currently selected again*/
    GET CURRENT {&BROWSE-NAME}.                    
    
    RUN adeuib/_recreat.p (RECID(_U)).
    
    /* Redisplay the current widget */
    RUN display_current IN _h_UIB.

  END.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_initval properties_window 
PROCEDURE change_initval :
/*------------------------------------------------------------------------------
  Purpose:     Change the initial value of the current widget.  
  Parameters:  new-value - the new value to change to.
  Notes:       Part of Mars WEB-JEP changes.
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER new-value AS CHAR NO-UNDO.

  FIND _F WHERE RECID(_F) eq _U._x-recid NO-ERROR.
  IF NOT AVAILABLE _F THEN RETURN.
  ASSIGN _F._INITIAL-DATA = new-value.

  RUN adeuib/_recreat.p (RECID(_U)).
  
  /* Redisplay the current widget */
  RUN display_current IN _h_UIB.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_label properties_window 
PROCEDURE change_label :
/*------------------------------------------------------------------------------
  Purpose:     Change the label of the current widget.  
  Parameters:  new-lbl - the new label to change _U to.
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER new-lbl AS CHAR NO-UNDO.
  
  DEFINE VARIABLE text-sa AS CHAR NO-UNDO.
  
  /* Make sure the widget REALLY allows the label to change. */
  IF CAN-SET(_U._HANDLE, "LABEL") THEN DO:  
    /* Get the parent. */
    FIND parent_U WHERE RECID(parent_U) = _U._PARENT-RECID.
    FIND _C WHERE RECID(_C) eq parent_U._x-recid.
  
    IF new-lbl EQ "?" OR new-lbl EQ ? THEN DO:      
      /* Label is "unknown", so use "D"efault -- note: for DB fields, we
         need to refetch the Default label. We only bother with this change
         if the old value was not "D"efault. */
      IF _U._LABEL-SOURCE ne "D" THEN DO:
        FIND ip_F WHERE RECID(_F) = _U._x-recid NO-ERROR.
        IF _U._DBNAME ne ? THEN
          RUN adeuib/_fldlbl.p (
             _U._DBNAME,
             _U._TABLE,
             IF _F._DISPOSITION = "LIKE":U THEN _F._LIKE-FIELD ELSE _U._NAME,
             _C._SIDE-LABELS, 
             OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).   
        _U._LABEL-SOURCE = "D".
      END.                                    
    END.
    ELSE ASSIGN _U._LABEL = new-lbl
                _U._LABEL-SOURCE = "E".
    /* Now change the label */
    CASE _U._TYPE:
      WHEN "BUTTON":U OR WHEN "TOGGLE-BOX":U THEN DO:
        RUN adeuib/_sim_lbl.p (_U._HANDLE). /* i.e. buttons and toggles */
      END.
      /* Menus and Sub-menus have a label, but no _F record. */
      WHEN "MENU-ITEM":U OR WHEN "SUB-MENU":U THEN DO:
       /* Now change the label */
       RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, no, OUTPUT text-sa).
        _U._HANDLE:LABEL = text-sa.
      END.
      OTHERWISE DO:
        /* Get the objects layout and parent records */
        FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
        FIND _F WHERE RECID(_F) eq _U._x-recid.
        FIND _L WHERE RECID(_L) eq _U._lo-recid.
        _L._NO-LABELS = (TRIM(_U._LABEL) EQ ""). /* Set no-label */
        IF NOT _C._SIDE-LABELS AND NOT parent_L._NO-LABELS AND _L._NO-LABELS
        THEN RUN adeuib/_chkpos.p (INPUT _U._HANDLE).
        RUN adeuib/_showlbl.p (_U._HANDLE).
      END.
    END CASE.
  END.

  /* Redisplay the current widget */
  RUN display_current IN _h_UIB.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_name properties_window 
PROCEDURE change_name :
/*------------------------------------------------------------------------------
  Purpose:     Change the name of the current widget.  
  Parameters:  new-name - the new type to change _U to.
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER new-name AS CHAR NO-UNDO.

  DEFINE VARIABLE valid_name AS LOGICAL NO-UNDO.
  
  RUN adeuib/_ok_name.p (new-name, RECID(_U), OUTPUT valid_name).
  IF valid_name THEN DO:
    _U._NAME = new-name.
    
    IF _U._TYPE = "{&WT-CONTROL}" THEN _U._HANDLE:NAME = _U._NAME.

    /* Redisplay the current widget */
    RUN display_current IN _h_UIB.

    /* SEW call to update widget name in SEW. */
    RUN call_sew IN _h_UIB ( INPUT "SE_PROPS" ).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_userfield properties_window 
PROCEDURE change_userfield :
/*------------------------------------------------------------------------------
  Purpose: Check if a userfield is properly defined in the Procedure Settings     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pAttrValue AS CHAR NO-UNDO.
  DEFINE VARIABLE        cMsg       AS CHAR NO-UNDO.
  IF TT.attr-value = "YES" THEN
  DO:
    ASSIGN 
      _U._DEFINED-BY = "User":U 
      cMsg           = compile-userfields(RECID(_U)) .
    IF cMsg <> "" THEN
    DO:              
      /* don't show error 232 */
      cMsg = (IF R-INDEX(cMsg,"(232)":U) = LENGTH(cMSg) - 4 
              THEN "" 
              ELSE cmsg + CHR(10) + CHR(10))   
            + _U._NAME  
            + " is not properly defined in the Procedure Settings." + CHR(10)
            + "This must be done before the field can become a User Field."
            + CHR(10)
            + "The change could not be applied." 
            + CHR(10).
      MESSAGE 
      cMsg      
      VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN  
        TT.attr-value = "no":U.
        _U._DEFINED-BY = "Tool":U.
      DISPLAY tt.attr-value WITH BROWSE {&BROWSE-NAME}.     
    END. 
  END.  
  ELSE ASSIGN _U._DEFINED-BY = "Tool":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-tt properties_window 
PROCEDURE create-tt :
/* -----------------------------------------------------------
  Purpose:     Create the records in the temp-table for each
               of the attributes that we want to deal with.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR i  AS INTEGER NO-UNDO.
  DEFINE VAR ch AS CHAR    NO-UNDO.
  
  /* Create tt records where NAME will equal LABEL. */
  CREATE tt.
  ASSIGN tt.attr-name = "Type"
         tt.type = "TYPE"
         .
  
  CREATE tt.
  ASSIGN tt.attr-name = "Label"
         tt.type = "C"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Native"
         tt.type = "L"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Display"
         tt.type = "L"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Format"
         tt.type = "C"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Enable"
         tt.type = "L"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Hidden"
         tt.type = "L"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Font"
         tt.type = "FONT"
         .
  /* WEB: */
  CREATE tt.
  ASSIGN tt.attr-name  = "Data-Type"
         tt.attr-label = "Define As"
         tt.type = "DATA-TYPE"
         . 

  CREATE tt.
  ASSIGN tt.attr-name = "Properties"
         tt.attr-label = "Property Sheet"
         tt.type = "PROPERTIES"
         .
 
  CREATE tt.
  ASSIGN tt.attr-name  = "HTML"
         tt.attr-label = "HTML Name"
         tt.type = "C"
         .

  CREATE tt.
  ASSIGN tt.attr-name  = "HTML-Tag"
         tt.attr-label = "HTML Tag"
         tt.type = "C"
         .

  CREATE tt.
  ASSIGN tt.attr-name  = "HTML-type"
         tt.attr-label = "HTML Type"
         tt.type = "C"
         .

  CREATE tt.
  ASSIGN tt.attr-name  = "UserField"
         tt.attr-label = "User Field"
         tt.type = "L"
         .
  
  CREATE tt.
  ASSIGN tt.attr-name = "Private-Data"
         tt.type = "C"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Initial-Value"
         tt.attr-label = "Initial Value"
         tt.type = "C"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Sort"
         tt.type = "L"
         .
  CREATE tt.
  ASSIGN tt.attr-name = "Multiple"
         tt.type = "L"
         .
  /* WEB: */

  CREATE tt.  
  ASSIGN tt.attr-name = "Geometry"
         tt.type = "GROUP"
         tt.expanded = "+"
         .
  
  /* Create Custom Lists as a expandable list */
  CREATE tt.  
  ASSIGN tt.attr-name = "Custom Lists"
         tt.type = "GROUP"
         tt.expanded = "+"
         .
         
  /* Create tt records where NAME will not equal LABEL. */  
  CREATE tt.
  ASSIGN tt.attr-name = "Name"
         tt.attr-label = "Object"
         tt.type = "C"
         .

  /* Initialize the list names to the default value */
  custom-lists = "List-1,List-2,List-3,List-4,List-5,List-6".
  DO i = 1 TO 6:
    CREATE tt.
    ASSIGN ch = ENTRY(i,custom-lists)
           tt.attr-name = "Custom Lists." + ch
           tt.attr-label = "  " + ch /* Indent the label */ 
           tt.type = "L"
           tt.hidden = yes
           .
  END.
  
  /* Initialize the 4 main Geometry items. */
  DO i = 1 TO 4:
    CREATE tt.
    ASSIGN tt.attr-name = "Geometry." + ENTRY(i, "Row,Column,Height,Width")
           tt.attr-label = "  " + ENTRY(i, "Top,Left,Height,Width")  /* Indent the label */ 
           tt.type = "D"
           tt.hidden = yes
           .
  END.
  
  /* If label was not set, then just use the attribute name */
  FOR EACH tt WHERE tt.attr-label = "":
    tt.attr-label = tt.attr-name.
  END.
    
  /* WEB: The name used for the primary index defaults to the attribute name
     itself.  */
  FOR EACH tt WHERE tt.indx-name eq "":
    tt.indx-name = tt.attr-name.
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI properties_window  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(properties_window)
  THEN DELETE WIDGET properties_window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display-value properties_window 
PROCEDURE display-value :
/* -----------------------------------------------------------
  Purpose: display the current value in the header   
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DO WITH FRAME f:
    IF NOT AVAILABLE tt THEN DO:  /* Clear out the top of the window */
      ASSIGN cb-options:HIDDEN       = TRUE
             fi-integer:HIDDEN       = TRUE
             fi-decimal:HIDDEN       = TRUE
             b_more:HIDDEN           = TRUE
             /* Show the empty character field */
             fi-char:SCREEN-VALUE    = ""
             fi-char:HIDDEN          = FALSE             
             .
    END.
    ELSE DO:
      r_current = RECID(tt).
      
      CASE tt.attr-name:
         /* If the following attr-name are NOT editable we must RETURN */
         
        WHEN "LABEL":U OR 
        WHEN "FORMAT":U OR 
        WHEN "DATA-TYPE":U OR
        WHEN "NAME":U  OR 
        WHEN "USERFIELD":U OR
        WHEN "HTML":U OR 
        WHEN "HTML-TYPE":U OR 
        WHEN "HTML-TAG":U THEN DO: /* Properties user can't change */
          ASSIGN cb-options:HIDDEN       = TRUE
                 fi-integer:HIDDEN       = TRUE
                 fi-decimal:HIDDEN       = TRUE
                 fi-char:HIDDEN          = TRUE
                 b_more:HIDDEN           = TRUE
                 .
          /*html* is always read-only. 
           Label,Name,format and userfield is read-only if mapped to db */
          IF tt.attr-name BEGINS "HTML":U 
          OR first_U._TABLE <> ? THEN 
            RETURN.
          /* User field data-type is maintained by user (and abfunc.w) */
          IF tt.attr-name = "DATA-TYPE":U 
          AND first_U._DEFINED-BY = "USER":U THEN 
            RETURN.
        END.
      END CASE.
          
      CASE tt.type:
        WHEN "GROUP":U THEN DO: /* Group */ 
          ASSIGN cb-options:HIDDEN       = TRUE
                 fi-integer:HIDDEN       = TRUE
                 fi-decimal:HIDDEN       = TRUE
                 fi-char:HIDDEN          = TRUE
                 b_more:HIDDEN           = TRUE
                 .
        END.
        WHEN "L":U THEN DO: /* Logical */ 
          ASSIGN cb-options:SCREEN-VALUE = ?
                 cb-options:LIST-ITEMS   = "yes,no":U
                 cb-options:SCREEN-VALUE = tt.attr-value
                 cb-options:HIDDEN       = FALSE
                 fi-integer:HIDDEN       = TRUE
                 fi-decimal:HIDDEN       = TRUE
                 fi-char:HIDDEN          = TRUE
                 b_more:HIDDEN           = TRUE
                 /* Inner-lines not supported on Motif */
                 &IF "{&WINDOW-SYSTEM}":U ne "OSF/Motif":U &THEN
                 cb-options:INNER-LINES  = 2
                 &ENDIF
                 .
        END.
        WHEN "D":U THEN DO: /* Decimal */ 
          ASSIGN cb-options:HIDDEN = TRUE
                 fi-integer:HIDDEN = TRUE
                 fi-decimal:HIDDEN = FALSE
                 fi-char:HIDDEN    = TRUE
                 b_more:HIDDEN     = TRUE
                 .
          fi-decimal:SCREEN-VALUE = ENTRY(1, tt.attr-value, " ":U).
        END.
        WHEN "C":U THEN DO: /* Character */ 
          ASSIGN cb-options:HIDDEN = TRUE
                 fi-integer:HIDDEN = TRUE
                 fi-decimal:HIDDEN = TRUE
                 fi-char:HIDDEN    = FALSE
                 b_more:HIDDEN     = TRUE
                 .
          fi-char:SCREEN-VALUE = tt.attr-value.
        END.
        WHEN "I":U THEN DO: /* Integer */ 
          ASSIGN cb-options:HIDDEN = TRUE
                 fi-integer:HIDDEN = FALSE
                 fi-decimal:HIDDEN = TRUE
                 fi-char:HIDDEN    = TRUE
                 b_more:HIDDEN     = TRUE
                 .
          fi-integer:SCREEN-VALUE = ENTRY(1, tt.attr-value, " ":U).
        END.
        WHEN "FONT":U OR WHEN "COLOR":U THEN DO: /* Font or Color */ 
          ASSIGN cb-options:HIDDEN = TRUE
                 fi-integer:HIDDEN = FALSE
                 fi-decimal:HIDDEN = TRUE
                 fi-char:HIDDEN    = TRUE
                 b_more:HIDDEN     = FALSE
                 .
          /* The value of the attribute may be blank if there are multiple
             selected widgets. Use ? instead. */
          fi-integer:SCREEN-VALUE = IF tt.attr-value eq "":U THEN ?
                                    ELSE tt.attr-value.
        END.
        WHEN "PROPERTIES":U THEN DO: /* Properties Sheet */
          ASSIGN cb-options:HIDDEN = TRUE
                 fi-integer:HIDDEN = TRUE
                 fi-decimal:HIDDEN = TRUE
                 fi-char:HIDDEN    = TRUE
                 b_more:HIDDEN     = FALSE
                 .
        END.
        WHEN "TYPE":U    OR
        WHEN "DATA-TYPE" THEN 
        DO: 
          ASSIGN cb-options:SCREEN-VALUE = ?
                 cb-options:LIST-ITEMS   = IF tt.type = "TYPE" THEN valid-types
                                           ELSE                     valid-dtypes 
                 cb-options:SCREEN-VALUE = tt.attr-value
                 cb-options:HIDDEN       = FALSE
                 fi-integer:HIDDEN       = TRUE
                 fi-decimal:HIDDEN       = TRUE
                 fi-char:HIDDEN          = TRUE
                 b_more:HIDDEN           = TRUE
                 /* Inner-lines not supported on Motif */
                 &IF "{&WINDOW-SYSTEM}":U ne "OSF/Motif":U &THEN
                 cb-options:INNER-LINES  = NUM-ENTRIES(cb-options:LIST-ITEMS)
                 &ENDIF
                  .
        END.
      END CASE.
    END. /* IF NOT AVAILABLE tt...ELSE DO... */
  END. /* DO WITH FRAME f */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI properties_window  _DEFAULT-ENABLE
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
  DISPLAY cb-options 
      WITH FRAME f IN WINDOW properties_window.
  ENABLE b_reject b_accept cb-options brws-attr 
      WITH FRAME f IN WINDOW properties_window.
  {&OPEN-BROWSERS-IN-QUERY-f}
  VIEW properties_window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expand-group properties_window 
PROCEDURE expand-group :
/* -----------------------------------------------------------
  Purpose: expands or collapses a section -- If it is "+" then
           expand it (and set it to "-")  
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE BUFFER iptt FOR tt.
  tt.expanded = (IF tt.expanded eq "-" THEN "+" ELSE "-").
  FOR EACH iptt WHERE iptt.attr-name BEGINS tt.attr-name + ".":
    iptt.hidden = (tt.expanded eq "+").
  END.
  /* If we just expanded Geometry, then find the current values. */
  IF tt.attr-name eq "Geometry":U AND tt.expanded eq "-":U
  THEN RUN find-geometry-values.
  
  /* Now reopen the query (in a visible window).  Set the browse so that it
     repositions to the same record in the same row. */ 
  DO WITH FRAME {&FRAME-NAME}:
    ldummy = {&BROWSE-NAME}:SET-REPOSITIONED-ROW 
                  (MAX(1, {&BROWSE-NAME}:FOCUSED-ROW), "CONDITIONAL").
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  REPOSITION {&BROWSE-NAME} TO RECID r_current.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-geometry-values properties_window 
PROCEDURE find-geometry-values :
/* -----------------------------------------------------------
  Purpose: For the Geometry attributes (eg. Row, Width), this
           routine populates the current data.    
  Parameters:  <none>
  Notes: This assumes a value of first_U and first_L (which
         usually maps to _h_cur_widg).    
-------------------------------------------------------------*/
  define variable ch          as char    no-undo.
  define variable dVal        as decimal no-undo.
  define variable only-one    as logical no-undo.
  define variable l_movable   as logical no-undo.
  define variable l_resizable as logical no-undo.
  define variable l_gui       as logical no-undo.
  
  define query Q for _U, _L.
  
  /* Is there only one object selected, and are all the objects
     resizable? */
  only-one = NOT CAN-FIND(FIRST _U WHERE _U._SELECTEDib 
                                     AND RECID(_U) ne RECID(first_U)).
  /* One object can be a window or dialog-box or size-to-parent (which are 
     resizable in the UIB even thought the true widget we use is NOT resizable.)
     If multiple objects, just see if any of them are not RESIZABLE.
     NOTE: the only object that is not movable is a size-to-parent object. */
  IF only-one 
  THEN ASSIGN l_resizable = CAN-DO ("DIALOG-BOX,WINDOW":U, first_U._TYPE)
                            OR first_U._HANDLE:RESIZABLE
                            OR first_U._size-to-parent
              l_movable   = NOT first_U._size-to-parent
              .
  ELSE DO:
    ASSIGN l_movable = NOT CAN-FIND (FIRST _U WHERE _U._SELECTEDib 
                                                AND _U._size-to-parent)
           l_resizable = yes
           .
    OBJECT-SEARCH:
    FOR EACH _U WHERE _U._SELECTEDib:
      IF _U._HANDLE:RESIZABLE eq NO AND _U._size-to-parent eq NO THEN DO:
        l_resizable = NO.
        LEAVE OBJECT-SEARCH.
      END.
    END. /* OBJECT-SEARCH: FOR ... */
  END.
 
  /* Is this a TTY window. */
  l_gui = FIRST_L._WIN-TYPE.
  
  /* Look at all the Geometry attributes. */
  FOR EACH tt WHERE tt.attr-name BEGINS "Geometry.":U: 
    /* Show as integers in TTY Layout. */
    tt.type = IF l_gui THEN "D":U ELSE "I":U.
      
    /* Strip off the group name on some attributes. */
    ch = ENTRY(2, tt.attr-name, ".":U).
    /* Set in-use based on attribute. */
    IF CAN-DO("Row,Column":U, ch) THEN tt.in-use = l_movable.
    ELSE tt.in-use = l_resizable.
    IF tt.in-use THEN DO:
      IF only-one 
      THEN ASSIGN dVal = IF ch eq "Row" THEN first_L._ROW 
                         ELSE IF ch eq "Column" THEN first_L._COL  
                         ELSE IF ch eq "Width" THEN first_L._WIDTH  
                         ELSE IF ch eq "Height" THEN first_L._HEIGHT 
                         ELSE 1 
                  tt.attr-value = STRING(IF l_gui THEN dVal ELSE ROUND(dVal, 0)) .
      ELSE DO:
        CASE ch:
          WHEN "Row":U THEN DO:
            OPEN QUERY Q FOR EACH _U WHERE _U._SELECTEDib ,  
                             EACH _L WHERE RECID(_L) eq _U._lo-recid
                               BY _L._ROW.
            GET FIRST Q.
            tt.attr-value = STRING(IF l_gui THEN _L._ROW ELSE ROUND(_L._ROW, 0)).
            GET LAST Q.
            ch = STRING(IF l_gui THEN _L._ROW ELSE ROUND(_L._ROW, 0)).
            IF tt.attr-value ne ch 
            THEN tt.attr-value = tt.attr-value + "  -  ":U + ch.
            CLOSE QUERY Q.
          END. /* WHEN "Row" */
          WHEN "Column":U THEN DO:
            OPEN QUERY Q FOR EACH _U WHERE _U._SELECTEDib ,  
                             EACH _L WHERE RECID(_L) eq _U._lo-recid
                               BY _L._COL.
            GET FIRST Q.
            tt.attr-value = STRING(IF l_gui THEN _L._COL ELSE ROUND(_L._COL, 0)).
            GET LAST Q.
            ch = STRING(IF l_gui THEN _L._COL ELSE ROUND(_L._COL, 0)).
            IF tt.attr-value ne ch 
            THEN tt.attr-value = tt.attr-value + "  -  ":U + ch.
            CLOSE QUERY Q.
          END. /* WHEN "Column" */
          WHEN "WIDTH":U THEN DO:
            OPEN QUERY Q FOR EACH _U WHERE _U._SELECTEDib ,  
                             EACH _L WHERE RECID(_L) eq _U._lo-recid
                               BY _L._WIDTH.
            GET FIRST Q.
            tt.attr-value = STRING(IF l_gui THEN _L._WIDTH ELSE ROUND(_L._WIDTH, 0)).
            GET LAST Q.
            ch = STRING(IF l_gui THEN _L._WIDTH ELSE ROUND(_L._WIDTH, 0)).
            IF tt.attr-value ne ch 
            THEN tt.attr-value = tt.attr-value + "  -  ":U + STRING(_L._WIDTH).
            CLOSE QUERY Q.
          END. /* WHEN "Width" */
          WHEN "HEIGHT":U THEN DO:
            OPEN QUERY Q FOR EACH _U WHERE _U._SELECTEDib ,  
                             EACH _L WHERE RECID(_L) eq _U._lo-recid
                               BY _L._HEIGHT.
            GET FIRST Q.
            tt.attr-value = STRING(IF l_gui THEN _L._HEIGHT ELSE ROUND(_L._HEIGHT, 0)).
            GET LAST Q.
            ch = STRING(IF l_gui THEN _L._HEIGHT ELSE ROUND(_L._HEIGHT, 0)).
            IF tt.attr-value ne ch 
            THEN tt.attr-value = tt.attr-value + "  -  ":U + STRING(_L._HEIGHT).
            CLOSE QUERY Q.
          END. /* WHEN "Height" */
        END CASE.
      END.
    END. /* IF tt.in-use... */ 
  END. /* FOR EACH tt WHERE..."Geometry"... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE metamorph properties_window 
PROCEDURE metamorph :
/* -----------------------------------------------------------
  Purpose: Change the First_U widget to a new type. That is
           metamorphize it into a new widget type.    
  Parameters: new-type - the new type to change _U to.
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER new-type AS CHAR NO-UNDO.
  
  DEFINE BUFFER lbl_U FOR _U.
  DEFINE BUFFER lbl_F FOR _F.
   
  FIND _F WHERE RECID(_F) eq _U._x-recid.
  
  /* Change the type of the _U and recreate. */
  _U._TYPE = new-type.
  
  /* Clear _U._SUBTYPE if _U._TYPE was changed from combo-box to something 
     else. */
  IF _U._TYPE NE "COMBO-BOX" AND _U._SUBTYPE = "DROP-DOWN-LIST" THEN
    _U._SUBTYPE = ?.
    
  /* Special Cases: */
  CASE _U._TYPE:
    WHEN "RADIO-SET":U THEN DO:
      /* Radio-Buttons are stored in the SCREEN-VALUE.  Set the Radio-Buttons 
         based on the DATA-TYPE of the variable */
      IF _F._SCREEN-VALUE eq "":U THEN DO:
        CASE _F._DATA-TYPE:
          WHEN "CHARACTER":U THEN _F._SCREEN-VALUE = "~"Item 1~",~"1~"".
          WHEN "LOGICAL":U   THEN _F._SCREEN-VALUE = "~"Yes~", yes, ~"No~", no".
          OTHERWISE               _F._SCREEN-VALUE = "~"Item 1~",1".
        END CASE.
      END.
    END.
    WHEN "FILL-IN":U OR WHEN "COMBO-BOX":U THEN DO:
      /* Make sure there is a label record */
      IF _U._l-recid eq ? THEN DO:
        CREATE lbl_U.
        CREATE lbl_F.
        ASSIGN _U._l-recid = RECID(lbl_U)
               lbl_U._x-recid   = RECID(lbl_F)
               lbl_F._FRAME     = _F._FRAME
               lbl_U._NAME      = "_LBL-" + _U._NAME
               lbl_U._PARENT    = _U._PARENT
               lbl_U._SUBTYPE   = "LABEL":U
               lbl_U._TYPE      = "TEXT":U
               lbl_U._WIN-TYPE  = _U._WIN-TYPE
              .
      END.
      /* Make sure format and label are valid */
      IF _U._LABEL  eq ? THEN _U._LABEL  = _U._NAME.
      IF _F._FORMAT eq ? THEN DO:
        CASE _F._DATA-TYPE:
          WHEN "DECIMAL":U THEN _F._FORMAT = "->,>>>,>>9.99".
          WHEN "LOGICAL":U THEN _F._FORMAT = "yes/no".
          WHEN "INTEGER":U THEN _F._FORMAT = "-9999999".
          OTHERWISE _F._FORMAT = "X(256)".
        END CASE.
      END.
      
      /* Make sure _U._SUBTYPE is not unknown for combo-boxes. */
      IF _U._TYPE = "COMBO-BOX":U THEN
        _U._SUBTYPE = "DROP-DOWN-LIST".
    END.  
    WHEN "TEXT":U THEN DO:       
      /* If there is NO initial data, then use a label if available, or the name.
         (Note that all TEXT widgets must be character fields). */
      IF _F._INITIAL-DATA eq "":U 
      THEN _F._INITIAL-DATA = (IF _U._LABEL ne "" THEN _U._LABEL ELSE _U._NAME).
    END.   
  END CASE.
 
  /* Rebuild the object. */
  RUN adeuib/_recreat.p (RECID(_U)).

  /* Make sure the recreated widget is selected. */
  ASSIGN  _U._HANDLE:SELECTED = yes
          _U._SELECTEDib      = yes 
          .

  /* Widgets with labels are the only ones that can be colon-aligned */
  IF _U._l-recid ne ? AND _U._ALIGN = "C":U 
  THEN _U._ALIGN = "L":U.

  /* Redisplay the current widget (which will call back into this procedure).
     This must be the LAST line in this routine. */
  RUN display_current IN _h_UIB.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Modify-Layout properties_window 
PROCEDURE Modify-Layout :
/*------------------------------------------------------------------------------
  Purpose:     Look at the current font and widget sizes.  Change the layout
               so the window "fits" correctly.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR right-edge AS INTEGER NO-UNDO.
  
  /* Made everything in the top of the frame the height of the combo-box. */
  DO WITH FRAME f:
    /* Base the height of the widgets on the combo-box (which is
       resized based on its font by PROGRESS) */
    ASSIGN
      FRAME f:SCROLLABLE      = YES
      b_more:HEIGHT-P         = cb-options:HEIGHT-P
      fi-char:HEIGHT-P        = cb-options:HEIGHT-P
      fi-decimal:HEIGHT-P     = cb-options:HEIGHT-P
      fi-integer:HEIGHT-P     = cb-options:HEIGHT-P
      b_ACCEPT:HEIGHT-P       = cb-options:HEIGHT-P
      b_REJECT:HEIGHT-P       = cb-options:HEIGHT-P
      brws-attr:Y             = cb-options:HEIGHT-P                                                                 
     {&WINDOW-NAME}:MIN-WIDTH  = xdMinWidth 
     {&WINDOW-NAME}:MIN-HEIGHT = xdMinHeight 
     {&WINDOW-NAME}:MAX-HEIGHT = xdMaxHeight /* also set in adjustSize()*/   
      FRAME f:SCROLLABLE       = NO.
  
    RUN resizeObject({&WINDOW-NAME}:HEIGHT, {&WINDOW-NAME}:WIDTH ).
   
    ASSIGN b_more:SENSITIVE     = YES
           cb-options:SENSITIVE = YES
           fi-char:SENSITIVE    = YES
           fi-decimal:SENSITIVE = YES
           fi-integer:SENSITIVE = YES
           brws-attr:SENSITIVE  = YES.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE move-to-top properties_window 
PROCEDURE move-to-top :
/* -----------------------------------------------------------
  Purpose: Makes the window visible and moves it to the top.
           If it is iconized, then restore it.    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  IF {&WINDOW-NAME}:WINDOW-STATE = WINDOW-MINIMIZED
  THEN {&WINDOW-NAME}:WINDOW-STATE = WINDOW-NORMAL.
  /* Move the window to the top, and view-it. */
  IF {&WINDOW-NAME}:MOVE-TO-TOP() AND NOT {&WINDOW-NAME}:VISIBLE
  THEN {&WINDOW-NAME}:VISIBLE = yes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE popup-action properties_window 
PROCEDURE popup-action :
/* ------------------------------------------------------------------
  Purpose:    Execute a default popup-action for an attribute.  This
              is called when the "..." button is pressed, or
              a row is clicked. 
  Parameters: pOK - return YES if the value was changed.
  Notes:       
---------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pOK AS LOGICAL NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* Make sure we have a valid temp-table record */
    FIND tt WHERE RECID(tt) eq r_current NO-ERROR.
    IF NOT AVAILABLE tt THEN RETURN.
  
    CASE tt.type:
      WHEN "FONT" THEN DO:
        ASSIGN fi-integer.
        RUN adecomm/_chsfont.p (INPUT "Choose Font", 
                                INPUT ?, 
                                INPUT-OUTPUT fi-integer,
                                OUTPUT pOK).
        DISPLAY fi-integer WITH FRAME {&FRAME-NAME}.
      END.
      WHEN "PROPERTIES" THEN DO:
        RUN adeuib/_proprty.p (INPUT first_U._HANDLE).
        ASSIGN pOK = TRUE.
      END.
      OTHERWISE DO:
        pOK = NO. /* this type has no default action, so there was no change. */
      END.
    END CASE.
  END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resize-window properties_window 
PROCEDURE resize-window :
/*------------------------------------------------------------------------------
  Purpose:   Resize the window that is the parent of a SIZE-TO-PARENT frame.  
  Parameters:  pAttr - attribute we are resizing for.
               pVal  - the new value to set
  Notes: Assumes a valid _U and _L record for a Size-to-Parent frame.       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pAttr AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER pVal  AS DECIMAL NO-UNDO.
  
  DEFINE BUFFER p_U FOR _U.
  DEFINE BUFFER p_L FOR _L.
  
  /* Reset containing window, if necessary. */
  FIND p_U WHERE RECID(p_U) eq _U._parent-recid.
  FIND p_L WHERE RECID(p_L) eq p_U._lo-recid.
  CASE pAttr:
    WHEN "WIDTH":U  THEN 
      ASSIGN p_U._HANDLE:WIDTH  = pVal * p_L._ROW-MULT
             p_L._WIDTH         = p_U._HANDLE:WIDTH / p_L._ROW-MULT.
    WHEN "HEIGHT":U THEN 
      ASSIGN p_U._HANDLE:HEIGHT = pVal * p_L._COL-MULT
             p_L._HEIGHT        = _U._HANDLE:HEIGHT / p_L._COL-MULT.
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject properties_window 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Rrsize the object 
  Parameters:  Height - 
               Width  -
  Notes:       Called from WINDOW-RESIZED trigger
                      from adjustHeight if the window is maximized.
                      from Modify-Layout (initialization)   
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pdHeight AS DEC    NO-UNDO.
DEFINE INPUT PARAMETER pdWidth  AS DEC    NO-UNDO.
 
DEFINE VARIABLE right-edge      AS DEC  NO-UNDO.
DEFINE VARIABLE browse-shrinked AS DEC  NO-UNDO.
DEFINE VARIABLE i               AS INT  NO-UNDO.
DEFINE VARIABLE iRow            AS INT  NO-UNDO.

 DO WITH FRAME f:
  /* Base the height of the widgets on the combo-box (which is
     resized based on its font by PROGRESS) */
  ASSIGN
    {&WINDOW-NAME}:WIDTH      = pdWidth 
    {&WINDOW-NAME}:HEIGHT     = pdHeight
    FRAME f:WIDTH             = {&WINDOW-NAME}:WIDTH
    FRAME f:HEIGHT            = {&WINDOW-NAME}:HEIGHT
    brws-attr:HEIGHT          = {&WINDOW-NAME}:HEIGHT - (brws-attr:ROW - 1) 
  
  /* Use no-error because this give error when 2 down because the browser 
     tries to grow a horizontal scollbar, which does not fit. 
     (down = 0 indicates first time)  */    
    tt.attr-value:WIDTH IN BROWSE brws-attr 
                         = {&WINDOW-NAME}:WIDTH - 2
                           - (tt.attr-value:COL IN BROWSE brws-attr)
                               WHEN brws-attr:DOWN <> 0  
  NO-ERROR.
    
  brws-attr:WIDTH           = {&WINDOW-NAME}:WIDTH.
    
           /* we resize attr-value again in case the previous resize failed */
  ASSIGN
     tt.attr-value:WIDTH IN BROWSE brws-attr 
                         = {&WINDOW-NAME}:WIDTH - 2
                           - (tt.attr-value:COL IN BROWSE brws-attr)
                               WHEN brws-attr:DOWN <> 0 
    browse-shrinked           = brws-attr:HEIGHT 
    /* Down is INT so this statement adjusts the browse to have no half lines */ 
    brws-attr:DOWN            = MAX(2,brws-attr:DOWN) 
    browse-shrinked           = browse-shrinked - brws-attr:HEIGHT 
    FRAME f:HEIGHT            = {&WINDOW-NAME}:HEIGHT - browse-shrinked
    {&WINDOW-NAME}:HEIGHT     = {&WINDOW-NAME}:HEIGHT - browse-shrinked 
  NO-ERROR. 
   
  /* When resized to a size big enough to show all rows the browse 
     scrollbars disappear even if all rows are not in the viewport. 
     NOTE: It makes sense to show all rows even without the scrollbar problem */
  IF giNumResults > 0 AND giNumResults <= brws-attr:DOWN THEN
  DO:    
    /*  current-result-row was not always the selected (?)  */ 
    brws-attr:FETCH-SELECTED-ROW(1).  
    iRow = QUERY brws-attr:CURRENT-RESULT-ROW.
    APPLY 'page-up':U TO brws-attr.    
    REPOSITION brws-attr TO ROW iRow NO-ERROR.
  END.

  ASSIGN  
   /* Correct the right edge of the widgets based on the browse size */
     right-edge              = brws-attr:COL + brws-attr:WIDTH
     b_more:COL            = right-edge  - b_more:WIDTH 
     cb-options:WIDTH      = right-edge  - cb-options:COL
     fi-char:WIDTH         = right-edge  - fi-char:COL
     fi-decimal:WIDTH      = right-edge  - fi-decimal:COL
     fi-integer:WIDTH      = right-edge  - fi-integer:COL.
 END. /* do with frame */ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-attributes properties_window 
PROCEDURE show-attributes :
/* -----------------------------------------------------------
  Purpose: For each attribute, determine its value and display
           it.    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  define variable i           as integer no-undo.
  define variable only-one    as logical no-undo.
  define variable l_master    as logical no-undo.
  define variable MenuSelect  as logical no-undo.
  define variable SmartSelect as logical no-undo.
  define variable first-recid as recid   no-undo.
  define buffer ipTT FOR tt.

/* Debugging code to see where this is called from. */
/*
 *    define variable ch          as char    no-undo. 
 *    i = 1.
 *   repeat while program-name(i) ne ?:
 *     ch = ch + chr(10) + PROGRAM-NAME(i).
 *     i = i + 1.
 *   end.
 *   MESSAGE "show-attributes" ch skip STRING(_h_cur_widg) . */
/* Don't show anything if nothing is selected.  Also, don't show anything
     if SmartObjects are selected.  Note that some "current" widgets cannot
     be selected.  These are Windows, or Dialog-boxes.  NOTE we exclude
     Design-Windows here.  */
  FIND FIRST first_U WHERE first_U._HANDLE eq _h_cur_widg 
                       AND first_U._STATUS ne "DELETED":U
                       AND NOT (first_U._TYPE eq "WINDOW":U AND 
                                first_U._SUBTYPE eq "Design-Window":U)
            NO-ERROR.
  /* If there is no current widget, that is not a Design window, then find
     the first selected widget. */
  IF NOT AVAILABLE first_U
  THEN FIND FIRST first_U WHERE first_U._SELECTEDib NO-ERROR.
  IF NOT AVAILABLE first_U OR _next_draw NE ? THEN 
  DO:
    ASSIGN FRAME {&FRAME-NAME}:HIDDEN = YES.
  END.   
  ELSE DO WITH FRAME {&FRAME-NAME}:
    /* If there only one object selected, */
    first-recid = RECID(first_U).
    /* Not all objects (i.e. menus) have Layout records. */
    FIND first_L WHERE RECID(first_L) eq first_U._lo-recid NO-ERROR.
    only-one = NOT CAN-FIND(FIRST _U WHERE _U._SELECTEDib AND RECID(_U) ne first-recid).
    
    /* Are we in the master layout. */
    ASSIGN l_master = first_U._LAYOUT-NAME eq "{&Master-Layout}":U.
    
    /* Change the names of the lists, if necessary. */
    FIND _P WHERE _P._WINDOW-HANDLE eq first_U._WINDOW-HANDLE.
    IF _P._lists ne custom-lists THEN RUN update-user-lists.
    ASSIGN web_object = (_P._TYPE BEGINS "WEB":U).
    
    /* Are there any SmartObjects selected, or any menus selected.  NOTE that
       Menus are not really selectable.  They can only be chosen if they are
       the ONLY selection. */
    ASSIGN SmartSelect = CAN-FIND(FIRST _U WHERE _U._SELECTEDib
                                             AND _U._TYPE eq "SmartObject":U) 
           MenuSelect = only-one AND CAN-DO("MENU,MENU-ITEM,SUB-MENU":U, first_U._TYPE).
    
    /* For each attribute, see if we should display it.  If yes
       then get the current value. Don't do anything with the Groups. */
    FOR EACH tt:      
      /* Every object except Menus have geometry.  
         Other Group Attributes are not supported by SmartObjects or Menus. */
      IF tt.type eq "GROUP" THEN DO:
        IF tt.attr-name eq "Geometry":U THEN DO:
          /* WEB: Don't bother showing geometry for HTML objects. */
          ASSIGN tt.in-use = (MenuSelect eq NO) AND (NOT web_object).        
        END.
        ELSE tt.in-use = (SmartSelect eq NO) AND (MenuSelect eq NO).
      END.
      
      ELSE IF tt.attr-name BEGINS "Custom Lists.":U THEN DO: 
        /* Check special cases LIST-1...LIST-n, which everything uses.*/
        i = INTEGER (ENTRY(2,tt.attr-name, "-")).
        tt.in-use = (SmartSelect eq NO) AND (MenuSelect eq NO) AND l_master.
        IF only-one OR NOT CAN-FIND 
            (FIRST _U WHERE _U._SELECTEDib AND _U._User-List[i] NE first_U._User-List[i])
        THEN tt.attr-value = STRING(first_U._User-List[i]).
        ELSE tt.attr-value = "".                               
      END.
      
      ELSE IF tt.attr-name eq "TYPE":U THEN DO:
        /* We only support TYPE if a single selected item (and never on those
           that aren't field-level widgets [i.e. no _F extenstion]).*/
        /* &MESSAGE [_attr-ed.w] Don't support Radio-Set Type (yet). */
        /* WEB: Support Type property only if not an HTML object. */
        FIND _HTM WHERE _HTM._U-RECID = RECID(first_U) NO-ERROR.
        FIND _F WHERE RECID(_F) eq first_U._x-recid NO-ERROR.
        IF NOT AVAILABLE _F OR AVAILABLE _HTM THEN tt.in-use = NO.
        ELSE DO:
          ASSIGN valid-types = "Combo-Box,Fill-in" +
                               (IF _F._DATA-TYPE eq "CHARACTER":U
                                THEN ",Editor,Selection-List,Text":U ELSE "":U) +
                               (IF _F._DATA-TYPE eq "INTEGER":U
                                THEN ",Slider":U ELSE "":U) +
                               (IF _F._DATA-TYPE eq "LOGICAL":U
                                THEN ",Toggle-Box" ELSE "":U) 
                 tt.in-use    = only-one AND CAN-DO(valid-types, first_U._TYPE)
                 tt.attr-value = first_U._TYPE
                 .
        END. /* IF..._F... */
      END. /* IF..."TYPE"... */
      ELSE IF tt.attr-name eq "NAME" THEN DO:
        ASSIGN tt.in-use     = only-one
               tt.attr-value = first_U._NAME.
        /* Show when a database field. */
        ASSIGN tt.attr-value = IF (first_U._TABLE <> ?)
                               THEN (tt.attr-value + " (":u + first_U._TABLE + ")":u)
                               ELSE tt.attr-value.
      END. /* IF..."NAME"... */
      ELSE IF tt.attr-name = "Format":u THEN
      DO:
        
        FIND _prop WHERE _prop._name eq tt.attr-name.
        tt.in-use = CAN-DO(_prop._WIDGETS, first_U._TYPE).
        
        IF tt.in-use THEN
        DO:         
          FIND _F WHERE RECID(_F) eq first_U._x-recid NO-ERROR.
          IF AVAIL _F THEN
          DO:
            ASSIGN tt.attr-value = _F._FORMAT
                   tt.in-use     = YES.              
            /* Only allow format change if all selected objects have same data-type*/
            FOR EACH _U WHERE _U._SELECTEDib:
              FIND _F WHERE RECID(_F) eq _U._x-recid NO-ERROR.
              IF NOT AVAIL _F OR _F._FORMAT ne tt.attr-value THEN DO:
                ASSIGN
                  tt.attr-value = ""
                  tt.in-use     = NO.
                LEAVE.
              END.
            END. /* for each _u */       
          END. /* if avail _f */ 
          ELSE tt.in-use = NO.
        END. /* if tt-in-use */   
      END. /* IF ..FORMAT */     
      ELSE IF tt.attr-name = "DATA-TYPE":u THEN
      DO:
        tt.in-use = only-one.
        IF tt.in-use THEN
        DO:
          FIND _prop WHERE _prop._name eq tt.attr-name no-error.
          tt.in-use = CAN-DO(_prop._WIDGETS, first_U._TYPE).
          
          IF tt.in-use THEN
          DO:
            FIND _F WHERE RECID(_F) eq first_U._x-recid NO-ERROR.
       
            IF AVAIL _F THEN
              tt.attr-value = _F._DATA-TYPE.
            ELSE 
              tt.in-use = NO.
          END.
        END.                            
      END. /* IF ..data-type */     
      
      ELSE IF tt.attr-name eq "USERFIELD" THEN DO:
        FIND _HTM WHERE _HTM._U-RECID = RECID(first_U) NO-ERROR.
          
        ASSIGN tt.in-use     = AVAIL _HTM.
        IF tt.in-use THEN 
          ASSIGN tt.attr-value = STRING(first_U._DEFINED-BY = "USER").
      END. /* IF..."NAME"... */
      /* WEB */
      ELSE IF tt.attr-name BEGINS "HTML" THEN DO:
        FIND _HTM WHERE _HTM._U-RECID = RECID(first_U) NO-ERROR.
          
        ASSIGN tt.in-use     = AVAIL _HTM.
        IF tt.in-use THEN        
        DO: 
          CASE tt.attr-name:
            WHEN "HTML":U THEN            
              ASSIGN tt.attr-value = _HTM._htm-name.
            WHEN "HTML-TAG" THEN
              ASSIGN tt.attr-value = IF _HTM._HTM-TAG = ?
                                     THEN "":U 
                                     ELSE _HTM._htm-tag.
            WHEN "HTML-TAG" THEN         
              ASSIGN tt.attr-value = IF _HTM._HTM-TYPE = ?
                                     THEN "":U 
                                     ELSE _HTM._htm-TYPE.
          END.
        END.
      END. /* IF ...BEGINS "HTML"... */
      /* Implemented for WEB, but all objects from 9.1B */  
      ELSE IF tt.attr-name eq "PRIVATE-DATA" THEN 
      DO:
        FIND _prop WHERE _prop._name eq tt.attr-name.
        ASSIGN tt.in-use     = only-one AND CAN-DO(_prop._WIDGETS, first_U._TYPE)
               tt.attr-value = first_U._PRIVATE-DATA WHEN tt.in-use.
      END. /* IF..."NAME"... */

      ELSE IF tt.attr-name eq "INITIAL-VALUE" THEN 
      DO:
        FIND _prop WHERE _prop._name eq tt.attr-name.
        ASSIGN tt.in-use     = only-one AND CAN-DO(_prop._WIDGETS, first_U._TYPE)
                               AND (first_U._TABLE = ?).
        IF tt.in-use THEN
        DO:
          FIND _F WHERE RECID(_F) eq first_U._x-recid NO-ERROR.
          IF AVAILABLE _F THEN
          DO:
            init-tt-initial-value().            
          END.
        END. /* IF...in-use... */
      END. /* IF..."NAME"... */

      /* WEB: */
      ELSE IF tt.attr-name EQ "PROPERTIES":U AND web_object THEN 
      DO:
        tt.in-use = only-one AND CAN-DO("RADIO-SET,SELECTION-LIST,QUERY", first_U._TYPE).
        IF tt.in-use THEN DO:
          IF first_U._TYPE <> "QUERY" THEN
            FIND _F WHERE RECID(_F) eq first_U._x-recid.
          CASE first_U._TYPE:
            /** beta 2 
            WHEN "FILL-IN":u THEN
              ASSIGN tt.attr-label = 'Format':U
                     tt.attr-value = _F._FORMAT
                     tt.in-use     = (first_U._DBNAME = ?).
            **/
            WHEN "SELECTION-LIST":u THEN DO:
              ASSIGN lListItems    = (_F._LIST-ITEMS NE ? AND _F._LIST-ITEMS NE "") OR
                                     (_F._LIST-ITEM-PAIRS EQ ? OR _F._LIST-ITEM-PAIRS EQ "")
                     tt.attr-label = IF lListItems THEN 'List-Items':U
                                     ELSE 'List-Item-Pairs':U
                     tt.attr-value = IF lListItems THEN 
                                       REPLACE(_F._LIST-ITEMS, CHR(10), ",")
                                     ELSE
                                       REPLACE(_F._LIST-ITEM-PAIRS, CHR(10), ",").
            END.
            WHEN "RADIO-SET":u THEN
              ASSIGN tt.attr-label = 'Radio-Buttons':U
                     tt.attr-value = REPLACE(_F._LIST-ITEMS, CHR(10), "").
            WHEN "QUERY":u THEN
              ASSIGN tt.attr-label = 'Query':U
                     tt.attr-value = "".
           END CASE.   
           /* Reset the index name to the label. */
           tt.indx-name = tt.attr-label.                                
        END. /* IF...in-use... */   
      END. /* IF..."NAME"... */
      
      ELSE IF tt.attr-name eq "LABEL":U THEN 
      DO:
        /* We only show these if there is only one selectd widget, and if
           the "only one" has a "LABEL" (not a "TITLE"). */
        FIND _HTM WHERE _HTM._U-RECID = RECID(first_U) NO-ERROR.
                       
        tt.in-use = NOT AVAIL _HTM AND only-one AND l_master AND
                    NOT CAN-DO("BROWSE,DIALOG-BOX,FRAME,WINDOW,MENU", first_U._TYPE).
        IF tt.in-use THEN DO:
          /* Is this property valid for the first object? */ 
          FIND _prop WHERE _prop._name eq tt.attr-name.
          tt.in-use = CAN-DO (_prop._WIDGETS + ",MENU-ITEM,SUB-MENU":U, first_U._TYPE).
      
          /* Show ? when the Default label is set. */
          IF tt.in-use THEN tt.attr-value = (IF first_U._LABEL-SOURCE EQ "D" 
                                             THEN "?" ELSE first_U._LABEL).
        END.
      END. /* IF...NAME, LABEL ... */
      
      ELSE DO:
         /* Is this property valid for ALL selected widgets?  Note, we don't
           need to check for _h_cur_widg here because it is first_U. */
        FIND _prop WHERE _prop._name eq tt.attr-name NO-ERROR.
        
        tt.in-use = IF web_object THEN 
                      AVAILABLE _prop                       
                      AND CAN-DO (_prop._WIDGETS, first_U._TYPE)                     
                      AND CAN-DO("display,enable,sort,multiple",tt.attr-name)
                    ELSE
                     (AVAILABLE _prop 
                      AND l_master
                      AND CAN-DO (_prop._WIDGETS, first_U._TYPE) 
                      AND NOT CAN-FIND (FIRST _U WHERE _U._SELECTEDib
                                        AND NOT CAN-DO(_prop._WIDGETS,_U._TYPE))
                      /* Don't edit Multiple for BROWWSE (only for WEB selection-lists) */
                      AND NOT (    first_U._TYPE = "BROWSE" 
                               AND tt.attr-name  = "Multiple" )).    
                     
        IF tt.in-use THEN DO:
          CASE tt.attr-name:
            WHEN "Display" THEN DO:
              IF only-one OR NOT CAN-FIND (FIRST _U WHERE _U._SELECTEDib
                                             AND _U._DISPLAY NE first_U._DISPLAY)
              THEN tt.attr-value = STRING(first_U._DISPLAY).
              ELSE tt.attr-value = "".                               
            END.
            WHEN "Enable" THEN DO:
              IF only-one OR NOT CAN-FIND (FIRST _U WHERE _U._SELECTEDib              
                                             AND _U._ENABLE NE first_U._ENABLE)
              THEN tt.attr-value = STRING(first_U._ENABLE).
              ELSE tt.attr-value = "".                               
            END.
            WHEN "Font" THEN DO:
              IF only-one OR NOT CAN-FIND (FIRST _U WHERE _U._SELECTEDib
                                             AND _L._FONT NE first_L._FONT)
              THEN tt.attr-value = STRING(first_L._FONT).
              ELSE tt.attr-value = "".                               
            END.
            WHEN "Hidden" THEN DO:
              IF only-one OR NOT CAN-FIND (FIRST _U WHERE _U._SELECTEDib
                                             AND _U._HIDDEN NE first_U._HIDDEN)
              THEN tt.attr-value = STRING(first_U._HIDDEN).
              ELSE tt.attr-value = "".                               
            END.
            WHEN "Native" THEN DO:
              FIND _F WHERE RECID(_F) eq first_U._x-recid.
              tt.attr-value = STRING(_F._NATIVE).
              OTHER-BLOCK:
              FOR EACH _U WHERE _U._SELECTEDib,
                  EACH _F WHERE RECID(_F) eq _U._x-recid.
                IF STRING(_F._NATIVE) ne tt.attr-value THEN DO:
                  tt.attr-value = "".
                  LEAVE OTHER-BLOCK.
                END.
              END.                               
            END.
            WHEN "Sort" THEN DO:
              FIND _F WHERE RECID(_F) eq first_U._x-recid.
              tt.attr-value = STRING(_F._SORT).
              OTHER-BLOCK:
              FOR EACH _U WHERE _U._SELECTEDib,
                  EACH _F WHERE RECID(_F) eq _U._x-recid.
                IF STRING(_F._SORT) ne tt.attr-value THEN DO:
                  tt.attr-value = "".
                  LEAVE OTHER-BLOCK.
                END.
              END.                               
            END.
            WHEN "Multiple" THEN DO:
              FIND _F WHERE RECID(_F) eq first_U._x-recid.
              tt.attr-value = STRING(_F._MULTIPLE).
              OTHER-BLOCK:
              FOR EACH _U WHERE _U._SELECTEDib,
                  EACH _F WHERE RECID(_F) eq _U._x-recid.
                IF STRING(_F._MULTIPLE) ne tt.attr-value THEN DO:
                  tt.attr-value = "".
                  LEAVE OTHER-BLOCK.
                END.
              END.                               
            END.
          END CASE.
        END. /* IF tt.in-use ... */
      END. /* IF not a LIST-n ... */
    END. /* For each tt...*/
    /* If "Geometry" is expanded, then compute the current values for these. */
    FIND tt WHERE tt.attr-name eq "Geometry":U.
    
    IF tt.in-use AND tt.expanded eq "-":U THEN RUN find-geometry-values.

    /* Is anything in use? */
    IF NOT CAN-FIND (FIRST tt WHERE tt.in-use) THEN FRAME {&FRAME-NAME}:HIDDEN = YES.
    ELSE DO: 
      /* Now open the query (in a visible window).  Set the browse so that it
         repositions to the current row.  */ 
      ldummy = {&BROWSE-NAME}:SET-REPOSITIONED-ROW 
                    (MAX(1, {&BROWSE-NAME}:FOCUSED-ROW), "CONDITIONAL").
    
      /* Open the query, and change the display at the top of the window. */
      {&OPEN-QUERY-{&BROWSE-NAME}}    
      
      /* Reposition to the current attribute. */
      FIND ipTT WHERE RECID(ipTT) eq r_current NO-ERROR.
      IF AVAILABLE ipTT AND ipTT.in-use AND NOT ipTT.hidden THEN DO:
        REPOSITION {&BROWSE-NAME} TO RECID r_current.
      END.
      /* Show the value at this row. */
      RUN display-value.
      
      /* Make sure the window is visible. */
      IF FRAME {&FRAME-NAME}:HIDDEN THEN FRAME {&FRAME-NAME}:HIDDEN = NO.
    END. /* IF anything in use ELSE DO:... */
    
  END. /* IF AVAILABLE first_U THEN DO WITH... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-geometry properties_window 
PROCEDURE show-geometry :
/* -----------------------------------------------------------
  Purpose: Update the current values of the Geometry only.
           This would be called on an end-resize or end-move
           from the UIB Main routine.    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  /* If the window is not visible, or if "Geometry" is not expanded, 
     then do nothing. */
  IF NOT FRAME {&FRAME-NAME}:HIDDEN THEN DO:
    FIND tt WHERE tt.attr-name eq "Geometry":U.
    IF tt.in-use AND tt.expanded eq "-":U AND tt.in-use 
    THEN DO WITH FRAME {&FRAME-NAME}:
      RUN find-geometry-values.
  
      /* Now open the query (in a visible window).  Set the browse so that it
         repositions to the current row.  */ 
      ldummy = {&BROWSE-NAME}:SET-REPOSITIONED-ROW 
                    (MAX(1, {&BROWSE-NAME}:FOCUSED-ROW), "CONDITIONAL").
    
      /* Open the query, and change the display at the top of the window. */
      {&OPEN-QUERY-{&BROWSE-NAME}}    
      /* Reposition to the current attribute. */
      REPOSITION {&BROWSE-NAME} TO RECID r_current NO-ERROR.
      /* Show the value at this row. */
      RUN display-value.
    END. /* IF tt.expanded and tt.in-use. */
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-user-lists properties_window 
PROCEDURE update-user-lists :
/*------------------------------------------------------------------------------
  Purpose:     Change the names of the lists to the names used in the current
               procedure.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define variable ch as char no-undo.
  define variable i as integer no-undo.
  
  /* Get the names of the lists, and store them in the temp-table */
  custom-lists = _P._lists.
  
  DO i = 1 TO 6:
    ch = "Custom Lists.List-" + SUBSTRING("123456",i,1,"CHARACTER").
    FIND tt WHERE tt.attr-name = ch.
    tt.attr-label = " " + ENTRY(i, custom-lists).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION adjustSize properties_window 
FUNCTION adjustSize RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Adjust Maximum Height and call resizeObject to adjust all objects
           if maximized.   
    Notes: Called from WINDOW-RESIZED and OPEN_QUERY trigger. 
           (This means that it's called directly from show-attributes) 
           There is some flashing/bouncing involved when this is called
           from window-maximized since the MAX-sizes are adjusted down after 
           the actual window event has happened.   
------------------------------------------------------------------------------*/
 /* Do a get last to ensure that num-results is correct */
 IF QUERY brws-attr:IS-OPEN THEN
 DO:
   QUERY brws-attr:GET-LAST.
   QUERY brws-attr:GET-FIRST. /* in case there's no reposition */
   giNumResults = QUERY brws-attr:NUM-RESULTS.
 END.

 DO WITH FRAME {&FRAME-NAME}:
   /* Set height to fit exactly when winow is Maximized  */ 
   IF {&WINDOW-NAME}:WINDOW-STATE = WINDOW-MAXIMIZED THEN
   DO:
     ASSIGN  
       {&WINDOW-NAME}:MAX-HEIGHT-P = 
            IF giNumResults <> 0 
            THEN brws-attr:Y 
                 + (giNumResults * ((brws-attr:ROW-HEIGHT-P + 4))) + 2
            ELSE {&WINDOW-NAME}:MAX-HEIGHT-P              
       {&WINDOW-NAME}:HEIGHT-P  = {&WINDOW-NAME}:MAX-HEIGHT-P.         
     RUN resizeObject({&WINDOW-NAME}:HEIGHT,{&WINDOW-NAME}:WIDTH). 
   END. /* maximized */
   ELSE
     {&WINDOW-NAME}:MAX-HEIGHT = xdMaxHeight.    
  
   {&WINDOW-NAME}:MAX-WIDTH  = xdMaxWidth.

 END.
 
 RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION init-tt-initial-value properties_window 
FUNCTION init-tt-initial-value RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Initialize the tt used for initial-value.  
           This is a function because it is used in show-attributes and
           whenever a data-type is changed 
    Notes: The tt and _F must be available.          
------------------------------------------------------------------------------*/
   ASSIGN tt.attr-value = _F._INITIAL-DATA
          tt.type       = 
                /* Set the type of the field based on the data-type.  */
                       IF _F._DATA-TYPE BEGINS "I"  THEN "I":U
                  ELSE IF _F._DATA-TYPE BEGINS "DE" THEN "D":U
                  ELSE IF _F._DATA-TYPE BEGINS "DA" THEN "C":U
                  ELSE IF _F._DATA-TYPE BEGINS "C"  THEN "C":U
                  ELSE IF _F._DATA-TYPE BEGINS "L"  THEN "L":U
                  ELSE "C".
       
  RETURN TRUE.   
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION windowHeightFromDown properties_window 
FUNCTION windowHeightFromDown RETURNS DECIMAL
  ( piRows AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  Calculate the window height from the number of rows to show
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

