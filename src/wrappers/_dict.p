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

File: _dict.p

Description:
   This is the startup program for the dictionary.  It will start up the
   program appropriate for the environment.

Author: Laura Stern

Date Created: 08/21/92

Modified:
  8/8/95 gfs Add warning for running procedures
----------------------------------------------------------------------------*/
&SCOPED-DEFINE SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* Check for persistent procedures which contain database tables */
RUN Chk_PPs.

{ adecomm/adewrap.i
  &TTY     = prodict/_dictc.p
  &MSWIN   = adedict/_dictg.p
  &MOTIF   = adedict/_dictg.p 
  &PRODUCT = "DICT"
  &SETCURS = WAIT }

{ adecomm/_chkpp.i }
