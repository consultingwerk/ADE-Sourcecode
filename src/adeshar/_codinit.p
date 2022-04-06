/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _codinit.p

Description:
    Initializes the _DEFINITIONS and _MAIN-BLOCK code sections for a UIB
    window.  Also creates place-holder triggers for the DEFAULT enabling and
    disabling procedures.

Input Parameters:
    p_recid    - the RECID(_U) for the window (or dialog-box).

Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: February 10, 1993

----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER     p_recid     AS RECID      NO-UNDO.
 
/* Shared TEMP-TABLE to hold triggers */
{adeuib/triggers.i}

DEFINE VARIABLE code     AS CHAR    NO-UNDO.

/* Create Custom/_DEFINITONS section */
RUN adeshar/_coddflt.p ("_DEFINITIONS":U, p_recid, OUTPUT code).
CREATE _TRG.
ASSIGN _TRG._tSECTION = "_CUSTOM"
       _TRG._wRECID   = p_recid
       _TRG._tEVENT   = "_DEFINITIONS"
       _TRG._tCODE    = code.

/* Default Enabling and Disabling procedures. Do this before we create the
   _MAIN-BLOCK, which might look for these procedure names.  */
CREATE _TRG.
ASSIGN _TRG._tSECTION = "_PROCEDURE"
       _TRG._wRECID   = p_recid
       _TRG._tSPECIAL = "_DEFAULT-ENABLE"
       _TRG._tEVENT   = "enable_UI"
       _TRG._tCODE    = ?.

CREATE _TRG.
ASSIGN _TRG._tSECTION = "_PROCEDURE"
       _TRG._wRECID   = p_recid
       _TRG._tSPECIAL = "_DEFAULT-DISABLE"
       _TRG._tEVENT   = "disable_UI"
       _TRG._tCODE    = ?.

/* Create Custom/_MAIN-BLOCK section */
RUN adeshar/_coddflt.p ("_MAIN-BLOCK":U, p_recid, OUTPUT code).
CREATE _TRG.
ASSIGN _TRG._tSECTION = "_CUSTOM"
       _TRG._wRECID   = p_recid
       _TRG._tEVENT   = "_MAIN-BLOCK"
       _TRG._tCODE    = code.

