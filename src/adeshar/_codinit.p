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

