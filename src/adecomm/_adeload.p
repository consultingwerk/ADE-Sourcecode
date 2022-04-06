/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _adeload.p

Description:
         Reads the default values for the standard colors and fonts to be used by all
         ADE applications.  Those colors are found in adestds.i.
         Also sets the Windows ALT-TAB icon. (jep - 10/29/98)
         
Author: Wm.T.Wood + Ravi-Chandar Ramalingam

Date Created: January 14, 1993
Modified    : 10/29/98 jep - Added SESSION:LOAD-ICON code for ALT-TAB icon.
----------------------------------------------------------------------------*/


{ adecomm/adestds.i }
&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

  DEFINE VAR color-count   AS INTEGER        NO-UNDO.
  DEFINE VAR v       AS CHAR           NO-UNDO.
  
  /* MESSAGE "Defining Fonts and Colors!"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

 initialized_adestds = yes.

 /* Set the ALT-TAB icon for the session. */
 SESSION:LOAD-ICON({&ADEICON-DIR} + "progress.ico":U) NO-ERROR.

 /* Set the ADE default fonts - we are using 3 fonts (FONT 0 to 2) for sure. */
 /* We also recommend that the first 8 fonts exist (see PROGRESS.INI file    */
 /* for further documentation.                                               */

 /* Set up the fonts for the ADE environment                 */
 IF FONT-TABLE:NUM-ENTRIES < 8 THEN FONT-TABLE:NUM-ENTRIES = 8.

 /* Get each ADE font from the INI file and make sure it is valid. */
 GET-KEY-VALUE SECTION "ProADE" KEY "FixedFont" VALUE v.
 CASE v:
        WHEN "DEFAULT" THEN  fixed_font = ?.
        WHEN ?         THEN fixed_font = 0.
        OTHERWISE DO:
          ASSIGN fixed_font = INTEGER(v) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN fixed_font = 0.
        END.
  END CASE.  

 GET-KEY-VALUE SECTION "ProADE" KEY "StandardFont" VALUE v.
 CASE v:
        WHEN "DEFAULT" THEN std_font = ?.
        WHEN ?          THEN std_font = 1.
        OTHERWISE DO:
          ASSIGN std_font = INTEGER(v) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN std_font = 1.
        END.
  END CASE.  

    GET-KEY-VALUE SECTION "ProADE" KEY "Editor4GLFont" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN editor_font = ?.
        WHEN ?         THEN editor_font = 2.
        OTHERWISE DO:
            ASSIGN editor_font = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN editor_font = 2.
        END.
     END CASE.  

    GET-KEY-VALUE SECTION "ProADE" KEY "EditorTabStop" VALUE v.
    CASE v:
        WHEN ?         THEN editor_tab = 4.
        OTHERWISE DO:
            ASSIGN editor_tab = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN editor_tab = 4.
        END.
     END CASE.  

    /* Set up the colors for the ADE environment                 */
    IF COLOR-TABLE:NUM-ENTRIES < 16 THEN COLOR-TABLE:NUM-ENTRIES = 16.

    /* Get each ADE color from the INI file and make sure it is valid. */

    GET-KEY-VALUE SECTION "ProADE" KEY "DividerFgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_div_fgcolor = ?.
        WHEN ?         THEN std_div_fgcolor = 15.
        OTHERWISE DO:
            ASSIGN std_div_fgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_div_fgcolor = 15.
        END.
    END CASE.
    GET-KEY-VALUE SECTION "ProADE" KEY "DividerBgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_div_bgcolor = ?.
        WHEN ?         THEN std_div_bgcolor = 1.
        OTHERWISE DO:
            ASSIGN std_div_bgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_div_bgcolor = 1.
        END.
    END CASE.  

    GET-KEY-VALUE SECTION "ProADE" KEY "OKBoxFgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_okbox_fgcolor = ?.
        WHEN ?         THEN std_okbox_fgcolor = 1.
        OTHERWISE DO:
            ASSIGN std_okbox_fgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_okbox_fgcolor = 1.
        END.
    END CASE.
    GET-KEY-VALUE SECTION "ProADE" KEY "OKBoxBgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_okbox_bgcolor = ?.
        WHEN ?         THEN std_okbox_bgcolor = 8.
        OTHERWISE DO:
            ASSIGN std_okbox_bgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_okbox_bgcolor = 8.
        END.
    END CASE.  

    GET-KEY-VALUE SECTION "ProADE" KEY "FillinFgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_fillin_fgcolor = ?.
        WHEN ?         THEN std_fillin_fgcolor = 0.
        OTHERWISE DO:
            ASSIGN std_fillin_fgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_fillin_fgcolor = 0.
        END.
    END CASE.
    GET-KEY-VALUE SECTION "ProADE" KEY "FillinBgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_fillin_bgcolor = ?.
        WHEN ?         THEN std_fillin_bgcolor = 8.
        OTHERWISE DO:
            ASSIGN std_fillin_bgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_fillin_bgcolor = 8.
        END.
    END CASE.

    GET-KEY-VALUE SECTION "ProADE" KEY "Editor4GLFgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_ed4gl_fgcolor = ?.
        WHEN ?         THEN std_ed4gl_fgcolor = ?.
        OTHERWISE DO:
            ASSIGN std_ed4gl_fgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_ed4gl_fgcolor = ?.
        END.
    END CASE.
    GET-KEY-VALUE SECTION "ProADE" KEY "Editor4GLBgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_ed4gl_bgcolor = ?.
        WHEN ?         THEN std_ed4gl_bgcolor = ?.
        OTHERWISE DO:
            ASSIGN std_ed4gl_bgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_ed4gl_bgcolor = ?.
        END.
    END CASE.

    GET-KEY-VALUE SECTION "ProADE" KEY "Editor4GLSmallFgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_ed4gl_small_fgcolor = ?.
        WHEN ?         THEN std_ed4gl_small_fgcolor = 0.
        OTHERWISE DO:
            ASSIGN std_ed4gl_small_fgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_ed4gl_small_fgcolor = 0.
        END.
    END CASE.
    GET-KEY-VALUE SECTION "ProADE" KEY "Editor4GLSmallBgColor" VALUE v.
    CASE v:
        WHEN "DEFAULT" THEN std_ed4gl_small_bgcolor = ?.
        WHEN ?         THEN std_ed4gl_small_bgcolor = 8.
        OTHERWISE DO:
            ASSIGN std_ed4gl_small_bgcolor = INTEGER(v) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN std_ed4gl_small_bgcolor = 8.
        END.
    END CASE.



