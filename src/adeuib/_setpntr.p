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
/*----------------------------------------------------------------------------

File: _setpntr.p 
                                                                         
Description:
   Sets mouse pointer to the currently selected object to draw. We also
   check _P._ALLOW to see if we are allowed to draw this type of object
   in a given procedures objects, if not, the no-draw image is selected.

Parameters:
   p_next_draw   -- name of object to draw
   p_object_draw -- filename of SmartObject to draw

Author: Gerry Seidl

Date Created: 3/3/95
Updated: 02/13/98 SLK Added ADM version check
         01/19/99 JEP Support for bug fix 98-12-28-020 and 99-01-19-017.

----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER p_next_draw   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_object_draw AS CHARACTER NO-UNDO.

{adeuib/pre_proc.i}
{adeuib/uniwidg.i}

DEFINE VARIABLE l            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE no-draw      AS CHARACTER NO-UNDO.
DEFINE VARIABLE fproc        AS CHARACTER NO-UNDO.

/* Handle ADM2 */
DEFINE VARIABLE iconFile AS CHARACTER NO-UNDO. /* icon filename */
{adeuib/vsookver.i}
 
&IF "{&WINDOW-SYSTEM}":U BEGINS "MS-WIN":U &THEN 
  &SCOPED-DEFINE ext .cur
&ELSE &SCOPED-DEFINE ext .xbm
&ENDIF

&IF DEFINED(ADEICONDIR) = 0 &THEN
  {adecomm/icondir.i}
&ENDIF

/* Create a variable that holds the full pathname for the NO-DRAW image. */
no-draw = {&ADEICON-DIR} +  "nodraw":U + "{&ext}":U.

FOR EACH _P,
    EACH _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE 
              AND CAN-DO("Frame,Dialog-Box,Window,Smartobject":U, _U._TYPE)
              AND _U._STATUS ne "DELETED":U :
  /* If _U is a Window, we need to set the nodraw cursor for things you cannot
   * draw in a window widget
   */

  IF _U._TYPE = "WINDOW":U AND
    CAN-DO("BROWSE,BUTTON,COMBO-BOX,DB-FIELDS,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TEXT,TOGGLE-BOX,{&WT-CONTROL}":U,p_next_draw)
  THEN DO:
    l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
  END.

  /* If _U is a SmartObject, we can't draw anything on it at all except 
     other SmartObjects. Handle OCX and the pointer */
  ELSE IF _U._TYPE eq "SmartObject":U THEN DO:
     IF p_next_draw = "{&WT-CONTROL}":U THEN
       l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
     ELSE IF (p_next_draw = ?) AND (p_object_draw eq ?) THEN
       l = _U._HANDLE:LOAD-MOUSE-POINTER("":U). 
     ELSE IF (p_next_draw ne ?) AND (p_object_draw eq ?) THEN           
       l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
  END.

  /* Otherwise, select the proper cursor depending on the object selected
   * and whether or not the procedure (_P._ALLOW) allows it to be drawn there.
   */
  ELSE DO:
    CASE p_next_draw:
      WHEN "BROWSE":U THEN
          IF CAN-DO(_P._Allow,"BROWSE":U) THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "browse":U   + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "BUTTON":U THEN 
          IF CAN-DO(_P._Allow,"BASIC":U) THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "button"   + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "COMBO-BOX"      THEN             
          IF CAN-DO(_P._Allow,"BASIC":U) THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "combbox"  + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "DB-FIELDS"      THEN 
          IF CAN-DO(_P._Allow,"DB-Fields":U) THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "dbfields" + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "EDITOR"         THEN 
          IF CAN-DO(_P._Allow,"BASIC":U) THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "editor"   + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "FILL-IN"        THEN 
          IF CAN-DO(_P._Allow,"BASIC":U) THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "fill_in"  + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "SMARTFOLDER" OR WHEN "SMARTV8FOLDER" THEN 
          IF CAN-DO(_P._Links,"PAGE-TARGET":U) THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "folder"   + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "FRAME"          THEN DO:
          RUN adeuib/_uibinfo.p (INT(RECID(_P)), ?, "FRAMES", OUTPUT fproc).
          CASE _P._max-frame-count:
            WHEN 0 THEN     /* No frames allowed */
              l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
            WHEN 1 THEN     /* Exactly 1 frame allowed */
              IF fproc NE ? AND fproc NE "" THEN
                l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
            OTHERWISE
              l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "frame"    + "{&ext}":U).            
          END CASE.
      END.
      WHEN "IMAGE"          THEN 
          IF CAN-DO(_P._Allow,"BASIC") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "image"    + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "QUERY"          THEN 
          IF CAN-DO(_P._Allow,"QUERY") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "query"    + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "RADIO-SET"      THEN 
          IF CAN-DO(_P._Allow,"BASIC") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "radioset" + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "RECTANGLE"      THEN 
          IF CAN-DO(_P._Allow,"BASIC") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "rectangl" + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "SELECTION-LIST" THEN 
          IF CAN-DO(_P._Allow,"BASIC") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "slctlist" + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "SLIDER"         THEN 
          IF CAN-DO(_P._Allow,"BASIC") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "slider"   + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "TEXT"           THEN 
          IF CAN-DO(_P._Allow,"BASIC") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "text"     + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "TOGGLE-BOX"     THEN 
          IF CAN-DO(_P._Allow,"BASIC") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "toggle"   + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      WHEN "{&WT-CONTROL}"     THEN DO: 
          IF CAN-DO(_P._Allow,"BASIC") THEN 
            l = _U._HANDLE:LOAD-MOUSE-POINTER({&ADEICON-DIR} +  "xcontrol" + "{&ext}":U).
          ELSE
            l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
      END.  WHEN ? THEN l = _U._HANDLE:LOAD-MOUSE-POINTER("").
      OTHERWISE DO:
          /* If p_next_draw is not recognized, it is probably a SmartObject
           * If the procedure allows smart objects, determine if the procedure 
           * and the object to be drawn are of the same version.
           * To determine the procedure version, just look at the _P._adm-version
           * To determine the to-be-drawn version, we need to instantiate
           * the object, check its version, then delete the object (see sookver.i).
           */
          ASSIGN canDraw = FALSE.
          
          /* Call SmartObject version checker code. */
          {adeuib/sookver.i p_object_draw canDraw yes}
          
          IF canDraw THEN DO:
                ASSIGN iconFile = {&ADEICON-DIR}.
                CASE p_next_draw:    
                      WHEN "SMARTDATABROWSER" OR WHEN "SMARTBROWSER" OR WHEN "SMARTV8BROWSER"
                          THEN iconFile = iconFile + "smrtbrws".
                      WHEN "SMARTDATAVIEWER" OR WHEN "SMARTVIEWER" OR WHEN "SMARTV8VIEWER"
                          THEN iconFile = iconFile + "smrtview".
                      WHEN "SMARTDATAOBJECT"  THEN iconFile = iconFile + "smrtdobj".
                      WHEN "SMARTPANEL" OR WHEN "SMARTV8PANEL"
                          THEN iconFile = iconFile + "smrtpnl".
                      WHEN "SMARTCONTAINER"   THEN iconFile = iconFile + "smcntnr".
                      WHEN "SMARTQUERY"       THEN iconFile = iconFile + "smrtqry".
                      WHEN "SMARTDATAFIELD"   THEN iconFile = iconFile + "fill_in".
                      /* so use the general SmartObject cursor. */
                      OTHERWISE                  iconFile = iconFile + "smartobj".
                END CASE. /* next_draw smartObject */
                ASSIGN iconFile = iconFile + "{&ext}":U.
                l = _U._HANDLE:LOAD-MOUSE-POINTER(iconFile) .
          END. /* Can draw */
          ELSE
             l = _U._HANDLE:LOAD-MOUSE-POINTER(no-draw).
        END. /* OTHERWISE case */
    END CASE. /* next_draw object */
  END.
END.
    

