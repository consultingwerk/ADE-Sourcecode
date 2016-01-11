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

  File: s-menu.i - shared frame and other shared variable definitions

  Description: 

  Input Parameters:

  Output Parameters:      <none>

  Author: Greg O'Connor

  Created: 08/15/93 - 12:17 pm

-----------------------------------------------------------------------------*/

DEFINE {1} SHARED VARIABLE cModule  AS CHARACTER NO-UNDO INIT "b,r,f,l,e".
DEFINE {1} SHARED VARIABLE _menuBar AS HANDLE    NO-UNDO.
DEFINE {1} SHARED VARIABLE lExit    AS LOGICAL   NO-UNDO. /* special event */
DEFINE {1} SHARED VARIABLE fDesign  AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE lbl-text AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE hdr-text AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE crit-box AS CHARACTER NO-UNDO.

DEFINE {1} SHARED FRAME fLayout.
DEFINE {1} SHARED FRAME fToolbar.
DEFINE {1} SHARED FRAME fHeader.
DEFINE {1} SHARED FRAME fLabel.

DEFINE RECTANGLE bcg-rect1 SIZE-PIXELS 2 BY 2 EDGE-PIXELS 1. 

FORM /* report and export design layout */
  fDesign VIEW-AS EDITOR SIZE 60 BY 12 NO-WORD-WRAP
  WITH FRAME fLayout COLUMN 1 NO-LABELS NO-ATTR-SPACE 
  SCROLLABLE OVERLAY NO-BOX.

/* The frame box is too thick so we'll use a rectangle for border instead */
FORM /* toolbar */
  bcg-rect1 SKIP 
  crit-box LABEL "Criteria" AT 2
    VIEW-AS COMBO-BOX SIZE 30 BY 1 INNER-LINES 8
  WITH FRAME fToolbar 
  NO-ATTR-SPACE SIDE-LABELS NO-BOX OVERLAY ROW 1 COLUMN 1.

FORM /* labels configuration header */
  hdr-text AT 1
    VIEW-AS EDITOR INNER-CHARS 70 INNER-LINES 3
  WITH FRAME fHeader 
  NO-LABELS NO-ATTR-SPACE OVERLAY.

FORM /* labels FRAME with rectangle */ 
  lbl-text AT 1
    VIEW-AS EDITOR INNER-CHARS 55 INNER-LINES 4
    SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
  WITH FRAME fLabel 
  NO-LABELS NO-ATTR-SPACE OVERLAY.

/* s-menu.i - end of file */

