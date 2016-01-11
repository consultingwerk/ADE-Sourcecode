/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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

  File: _protool.p

  Description: This persistent procedure sets up the Feature Definitions
               for the Pro*Tools application.
               
               It runs adecomm/_palette.p to create the palette and define
               its features.
               
               Features for the palette are stored in the file pointed to
               by FunctionDefs in the PROGRESS startup file (INI/.Xdefaults).
               
  Input Parameters:
       <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: Sept 8, 1994 
  
  Modified by: TAJ on 01/22/02 Don't show webclient applet if executable not installed.
               JEP on 08/19/01 ICF support. Changed AB License call.
               GFS on 04/08/98 Changed default .dat file for Webspeed
               GFS on 01/27/95 Added applet order
------------------------------------------------------------------------*/
{ protools/_protool.i NEW } /* shared temp-table */    
{ protools/ptlshlp.i }      /* help definitions  */
{ adecomm/_adetool.i }

DEFINE VARIABLE hPalette       AS HANDLE  NO-UNDO.
DEFINE VARIABLE hdl            AS WIDGET  NO-UNDO.
DEFINE VARIABLE pitems         AS CHAR    NO-UNDO. /* palette items */
DEFINE VARIABLE ptdat          AS CHAR    NO-UNDO. /* loc of dat file */
DEFINE VARIABLE s_pxpy         AS CHAR    NO-UNDO. /* x,y Loc from INI */
DEFINE VARIABLE px             AS INTEGER NO-UNDO. /* x co-ordinate */
DEFINE VARIABLE py             AS INTEGER NO-UNDO. /* y co=ordinate */
DEFINE VARIABLE citems-per-row AS CHAR    NO-UNDO. /* i-p-r from INI */
DEFINE VARIABLE items-per-row  AS INTEGER NO-UNDO.
DEFINE VARIABLE lbl-or-btn     AS CHAR    NO-UNDO. /* setting in INI */
DEFINE VARIABLE ptlabels       AS LOGICAL NO-UNDO. /* labels ? */
DEFINE VARIABLE ABLic          AS INTEGER NO-UNDO. /* AB license        */
DEFINE VARIABLE ABTools        AS CHAR    NO-UNDO. /* AB Tools  jep-icf */

/* Prevent this procedure from being called twice (by checking FILE-NAME) */
IF THIS-PROCEDURE:PERSISTENT THEN DO:
  /* See if a copy already exists. */
  hdl = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hdl): 
    IF hdl:FILE-NAME eq "adecomm/_palette.w"
    THEN DO:
      hPalette = hdl:CURRENT-WINDOW.
      IF hPalette:WINDOW-STATE = 2 THEN hPalette:WINDOW-STATE = 3.
      IF hPalette:MOVE-TO-TOP() THEN.
      DELETE PROCEDURE THIS-PROCEDURE.
      RETURN.
    END.
    hdl = hdl:NEXT-SIBLING.
  END.
END. 

GET-KEY-VALUE SECTION "ProTools" KEY "FunctionDefs" VALUE ptdat.
IF SEARCH(ptdat) = ? OR ptdat = "" THEN DO:
    /* Check license. If Webspeed-only, change .dat file */
    RUN adeshar/_ablic.p (INPUT NO /* Show Msgs */, OUTPUT ABLic, OUTPUT ABTools). /* jep-icf */
    IF ABLic NE 2 THEN
      ASSIGN ptdat = SEARCH("protools/protools.dat").
    ELSE 
      ASSIGN ptdat = SEARCH("protools/wprotool.dat"). /* Webspeed */
    IF ptdat = ? THEN DO:
        MESSAGE "PROTOOLS.DAT was not found!" VIEW-AS ALERT-BOX ERROR.
        RUN Destroy.
        RETURN.
    END. 
END.

RUN adecomm/_setcurs.p ("WAIT":U).

INPUT FROM VALUE(ptdat).
REPEAT TRANSACTION ON ERROR UNDO, LEAVE:
    CREATE pt-function.
    IMPORT pt-function.
END.
INPUT CLOSE.

/* IZ 1901: Don't show the WebClient Assembler 
 * applet if its executable is not installed. 
 */
IF SEARCH("prowcappmgr.exe") = ? THEN
DO:
    FIND pt-function WHERE pt-function.pcFile
                           = "protools/_prowcapped.p":u NO-ERROR.
    IF AVAIL pt-function THEN pt-function.pdisplay = no.
END.

FOR EACH pt-function WHERE pt-function.pdisplay = yes BY pt-function.order:
    ASSIGN pitems = pitems + CHR(10).
    IF pt-function.perrun THEN
        ASSIGN pitems = pitems + "PERSISTENT,".
    ELSE ASSIGN pitems = pitems + "RUN,".
    ASSIGN pitems = pitems + pcFile + "," + pcImage + "," + pcFname + ", ," + 
                        "no," + STRING(pt-function.order).
END.       
ASSIGN pitems = substring(pitems,2).

FOR EACH pt-function WHERE pcFname = "":
    DELETE pt-function.
END.

/* Create the palette, and then set up the palette.  If there is an error
   in any of the setup, then delete the palette and this procedure */
RUN adecomm/_palette.w PERSISTENT SET hPalette.
SETUP-BLOCK:
DO ON ERROR UNDO SETUP-BLOCK, RETRY SETUP-BLOCK:
  /* If there is a RETRY, then there was an error setting up the palette.
     In this case, just delete the palette and THIS-PROCEDURE. */
  IF RETRY THEN DO:
     RUN destroy IN hPalette NO-ERROR.
     RUN destroy IN THIS-PROCEDURE.
     RUN adecomm/_setcurs.p ("":U).
     RETURN.
  END.
  ELSE DO:
    /* Setup the Palette */
   
    RUN Add-Menu-Item   IN hPalette 
      (INPUT "&Customize...", INPUT "ALT-ENTER", INPUT "Customize", INPUT "HANDLE", INPUT THIS-PROCEDURE).
    RUN Add-Menu-Item   IN hPalette 
      (INPUT "&About PRO*Tools", INPUT "", INPUT "About", INPUT "HANDLE", INPUT THIS-PROCEDURE).
    RUN set-items       IN hPalette (INPUT pitems).

    GET-KEY-VALUE SECTION "ProTools" KEY "Visualization" VALUE lbl-or-btn.
    IF lbl-or-btn = "labels" 
    THEN ptlabels = yes.
    ELSE ptlabels = no.

    RUN set-button-size IN hPalette (INPUT 24).
    RUN set-label-font  IN hPalette (INPUT 4).
    RUN set-menu        IN hPalette (INPUT no).
    RUN set-parent      IN hPalette (INPUT this-procedure).
    RUN set-title       IN hPalette (INPUT "PRO*Tools").
    &IF "{&WINDOW-SYSTEM}" EQ "OSF/Motif" &THEN
      RUN set-window-icon IN hPalette (INPUT "adeicon/protools.xpm").
    &ELSE
      RUN set-window-icon IN hPalette (INPUT "adeicon/protools.ico").
    &ENDIF
    RUN add-f1-help     IN hPalette (INPUT "pthelp", INPUT this-procedure).

    GET-KEY-VALUE SECTION "ProTools" KEY "PaletteLoc" VALUE s_pxpy.
    ASSIGN px = INT(ENTRY(1,s_pxpy))
       py = INT(ENTRY(2,s_pxpy)).
    GET-KEY-VALUE SECTION "ProTools" KEY "ItemsPerRow" VALUE citems-per-row.
    ASSIGN items-per-row = INT(citems-per-row).
    IF items-per-row = 0 THEN items-per-row = 5.
    RUN Realize         IN hPalette (INPUT px, INPUT py, INPUT items-per-row).
  END. /* IF not RETRY... */
END. /* SETUP-BLOCK */
                                
/* Close this procedure */
ON CLOSE OF THIS-PROCEDURE DO:
    RUN destroy.
END.                                    

RUN adecomm/_setcurs.p ("":U).

IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    
PROCEDURE destroy:
   /* Free up the Persistent Procedure */
   IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
   IF VALID-HANDLE(hPalette) THEN DELETE PROCEDURE hPalette.
   RUN adecomm/_setcurs.p ("":U).
END.

PROCEDURE Customize:
    RUN protools/_custmiz.w (INPUT hPalette, INPUT-OUTPUT ptdat).
END.

PROCEDURE About:
    RUN adecomm/_about.p (INPUT "PRO*Tools", INPUT "adeicon/protools").
END.

PROCEDURE pthelp:
    RUN adecomm/_adehelp.p ( "ptls", "TOPICS", {&Main_Contents}, ? ).
END.

