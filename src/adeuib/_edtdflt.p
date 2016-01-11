&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r7
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    f_dflt
&Scoped-define FRAME-NAME     f_dflt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_dflt 
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
/*-----------------------------------------------------------------------------

  File: _edtdflt.p

  Description: Ask the user which attributes should use the Progress defaults
      (or dictionary defaults) and which should be explicit.
      
      There is a default list of the form defaults = "Label,Format,Help"
      We only show toggles for values that fields in this list. 
      
      The values we return are ? if there was no change and the new value
      if there was.  Fields NOT in the defaults list are always ?.

  Input Parameters:
      piType = TRUE if "Dictionary" is source for defaults FALSE if PROGRESS
               (this only affects comments).
      piDefaults = list of fields to check (eg. "Label,Format,Help")
      piLabel  = Label source "E" or "D". (Explicit or Default)
      piFormat = Format source "E" or "D".
      piHelp   = Help source "E" or "D".
      
  Output Parameters:
      poLabel  = Label source ?, "E" or "D". (Not Changed, Explicit or Default)
      poFormat = Format source ?, "E" or "D".
      poHelp   = Help source ?, "E" or "D".

  Author: Wm.T.Wood

  Created: 05/5/93

-----------------------------------------------------------------------------*/
/*             This .W file was created with the Progress UIB.               */
/*---------------------------------------------------------------------------*/

/* Parameters Definitions ---                                                */
&GLOBAL-DEFINE WIN95-BTN TRUE

DEFINE INPUT  PARAMETER  piType     AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER  piDefaults AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER  piLabel    AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER  piFormat   AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER  piHelp     AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER  poLabel    AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER  poFormat   AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER  poHelp     AS CHAR    NO-UNDO.

{adecomm/adestds.i}            /* Standard Definitions                       */
{adeuib/uibhlp.i}     	       /* Help pre-processor directives              */

/* Local Variable Definitions ---                  */
DEFINE VAR row-next AS DECIMAL NO-UNDO.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Define a dialog box                                                       */

/* Buttons for the bottom of the screen                                      */
DEFINE BUTTON btn_ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_cancel LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_help   LABEL "&Help":C12  {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
&ENDIF

DEFINE VARIABLE labelTog AS LOGICAL LABEL "Label" NO-UNDO
     VIEW-AS TOGGLE-BOX.

DEFINE VARIABLE formatTog AS LOGICAL LABEL "Format String" NO-UNDO
     VIEW-AS TOGGLE-BOX.

DEFINE VARIABLE helpTog AS LOGICAL LABEL "Help String" NO-UNDO
     VIEW-AS TOGGLE-BOX.

DEFINE VARIABLE comment AS CHAR FORMAT "X(38)" NO-UNDO.

/* Definitions of the frame widgets                                     */
DEFINE FRAME f_dflt
    SKIP({&TFM_WID})
    comment VIEW-AS TEXT AT 3 NO-LABEL
    labelTog AT 7
    FormatTog AT 7
    HelpTog AT 7

    {adecomm/okform.i
     &BOX    = "rect_btns"
     &STATUS = "no"
     &OK     = "btn_ok"
     &CANCEL = "btn_cancel"
     &HELP   = "btn_help"}

    WITH SIDE-LABELS DEFAULT-BUTTON btn_ok TITLE "Defaults" VIEW-AS DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "FRAME f_dflt" 
   &BOX   = "rect_btns"
   &OK    = "btn_ok" 
   &HELP  = "btn_help"}


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_dflt 
/* Standard UIB stuff for dialog boxes - including WINDOW-CLOSE = END-ERROR  */
{adeuib/std_dlg.i &FRAME_CLOSE = f_dflt }  

/* ----------------------------------------------------------- */
/*                     My Favorite Triggers.                   */
/* ----------------------------------------------------------- */
/* Help triggers */
ON CHOOSE OF btn_help IN FRAME f_dflt OR HELP OF FRAME f_dflt
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Defauts_Dlg_Box}, ? ).

ON GO OF FRAME f_dflt DO:
  /* Assign relevant values */
  IF CAN-DO (piDefaults,"Label") THEN DO:
    ASSIGN labelTog.
    poLabel = IF labelTog THEN "D" ELSE "E".
    IF poLabel EQ piLabel THEN poLabel = ?.
  END.
  IF CAN-DO (piDefaults,"Format") THEN DO:
    ASSIGN formatTog.
    poFormat = IF FormatTog THEN "D" ELSE "E".
    IF poFormat EQ piFormat THEN poFormat = ?.
  END.
  IF CAN-DO (piDefaults,"Help") THEN DO:
    ASSIGN HelpTog.
    poHelp = IF HelpTog THEN "D" ELSE "E".
    IF poHelp EQ piHelp THEN poHelp = ?.
  END.
  APPLY "U9":U TO SELF.
END.
/* Do nothing on this exit */
ON WINDOW-CLOSE, END-ERROR OF FRAME f_dflt APPLY "U9":U TO SELF.

/* ----------------------------------------------------------- */
/* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
/* ----------------------------------------------------------- */

/* Initial setup -- make a comment header. */
IF piType 
THEN comment = "Use Data Dictionary Definitions For:".
ELSE comment = "Use PROGRESS Defaults For:".

/* Set all output variables to unknown */
ASSIGN poLabel  = ?
       poFormat = ?
       poHelp   = ?.
/* Reposition and enable the appropriate toggles */
row-next = LabelTog:ROW.
IF CAN-DO (piDefaults,"Label")
THEN ASSIGN labelTog:ROW = row-next
            labelTog:SENSITIVE = yes
            labelTog:SCREEN-VALUE = STRING(piLabel EQ "D")
            row-next = row-next + 1.
ELSE ASSIGN labelTog:HIDDEN = yes.

IF CAN-DO (piDefaults,"Format")
THEN ASSIGN FormatTog:ROW = row-next
            FormatTog:SENSITIVE = yes
            FormatTog:SCREEN-VALUE = STRING(piFormat EQ "D")
            row-next = row-next + 1.
ELSE ASSIGN FormatTog:HIDDEN = yes.

IF CAN-DO (piDefaults,"Help")
THEN ASSIGN HelpTog:ROW = row-next
            HelpTog:SENSITIVE = yes
            HelpTog:SCREEN-VALUE = STRING(piHelp EQ "D")
            row-next = row-next + 1.
ELSE ASSIGN HelpTog:HIDDEN = yes.


/* Now show what we have created so-far and wait for input. */
DISPLAY comment WITH FRAME f_dflt.
ENABLE btn_ok btn_cancel btn_help WITH FRAME f_dflt.

WAIT-FOR "U9":U OF FRAME f_dflt.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE FRAME-NAME 


&UNDEFINE WINDOW-NAME
