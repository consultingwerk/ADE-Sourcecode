/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _undfram.p

Description: Undelete a FRAME or a BROWSE widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 26 February 1993

----------------------------------------------------------------------------*/
{adecomm/oeideservice.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}         /* Layout temp-table definitions                   */
{adeuib/frameown.i NEW}  /* Frame owner temp table definition                */
{adeuib/sharvars.i}

DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.
DEFINE VARIABLE temp-cur-window AS WIDGET-HANDLE.
DEFINE VARIABLE _HEIGHT-P       AS INTEGER INITIAL ?.
DEFINE VARIABLE _WIDTH-P        AS INTEGER INITIAL ?.
DEFINE VARIABLE _X              AS INTEGER INITIAL ?.
DEFINE VARIABLE _Y              AS INTEGER INITIAL ?.

/* import_mode must be defined for _rdfram.i to compile but not used here   */
DEFINE VARIABLE import_mode     AS CHARACTER                           NO-UNDO.

FIND _U WHERE RECID(_U) = uRecId.
FIND _L WHERE RECID(_L) = _U._lo-recid.
FIND _C WHERE RECID(_C) = _U._x-recid.

ASSIGN temp-cur-window = CURRENT-WINDOW
       CURRENT-WINDOW  = IF _h_win:TYPE = "FRAME":U 
                         THEN _h_win:PARENT ELSE _h_win
      _cur_win_type    = _L._WIN-TYPE.

{adeuib/_rdfram.i}

{adeuib/rstrtrg.i} /* Restore triggers */

CURRENT-WINDOW = temp-cur-window.
