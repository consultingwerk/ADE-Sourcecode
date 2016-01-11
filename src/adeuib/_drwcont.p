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

File: _drwcont.p

Description:
    Draw an OCX Control Frame widget in h_frame.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author:  Wm.T.Wood

Date Created: 1995 

Modified History
    03/26/97 jep Removed code that set _L._BGCOLOR = 7. Was there in case
                 control could not be created, user would see "hole". But
                 bug 97-01-30-058 requires the color to be ?, so its the
                 same as the parent. Also, the UIB does not create a frame
                 if the control cannot be realized at design-time.
----------------------------------------------------------------------------*/
 
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

/* Define the minimum size of a widget. If the user clicks smaller than this
   then use the default size.  */
&Scoped-define min-height-chars 0.2
&Scoped-define min-cols 0.4

DEFINE VAR cur-lo       AS CHARACTER NO-UNDO.
DEFINE VAR nameBase     AS CHARACTER NO-UNDO.
DEFINE VAR name         AS CHARACTER NO-UNDO.
DEFINE VAR s            AS INTEGER   NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.

/* Get the RECID of the parent frame */
FIND parent_U WHERE parent_U._HANDLE = _h_frame.
FIND parent_L WHERE RECID(parent_L)  = parent_U._lo-recid.

/* Create a Universal Widget Record and populate it as much as possible. */

CREATE _U.
CREATE _L.
CREATE _F.

/* The OCX control is passed in as follows:
        _custom_draw == name of the control (store as SUBTYPE and use in _U._OCX-DRAW)
        _object_draw == Class ID of the OCX file. */

assign name = "CtrlFrame":U. /* Base name of the control-frame */
.
RUN adeshar/_bstname.p (INPUT  name, name, ?, ?,  parent_U._WINDOW-HANDLE, 
                        OUTPUT name).
       
ASSIGN /* VBX Control-specific settings */
       _U._NAME        = name
       _U._TYPE        = "{&WT-CONTROL}":U 
       _U._SUBTYPE     = _custom_draw  
       /* For a VBX, store the file-name in IMAGE-FILE */
       _F._IMAGE-FILE  = _object_draw
       _U._OCX-NAME    = _custom_draw  
       _U._LABEL       = _custom_draw  
       _U._SENSITIVE   = YES
       _U._ENABLE      = no
       _U._DISPLAY     = no
       /* Standard Settings for Universal and Field records */
       { adeuib/std_uf.i &SECTION = "DRAW-SETUP" }
       . 

/* Assign width and height based on area drawn by user. */
ASSIGN _L._HEIGHT = (_second_corner_y - _frmy + 1) / SESSION:PIXELS-PER-ROW /
                        _cur_row_mult
       _L._WIDTH = (_second_corner_x - _frmx + 1) / SESSION:PIXELS-PER-COL /
                        _cur_col_mult .
IF (_L._WIDTH < {&min-cols}) AND (_L._HEIGHT < {&min-height-chars})
THEN ASSIGN _L._WIDTH  = ?  /* Use default */
            _L._HEIGHT = ?. /* Use default */

/* Create the control frame based on the Universal widget record. */
RUN adeuib/_undcont.p (RECID(_U)).

/*
 * If there is a problem then clean up
 */
 
IF _F._SPECIAL-DATA <> ? THEN DO:

    run adeuib/_delet_u.p(RECID(_U), yes).
    return.

END.
/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}
  
