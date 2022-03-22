/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _admin.p

Description:
   This is the startup program for the admin functions (formerly part of 
   the dictionary).

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
  &MSWIN   = prodict/_dictc.p
  &MOTIF   = prodict/_dictc.p 
  &PRODUCT = "ADMIN"
  &SETCURS = WAIT }

{ adecomm/_chkpp.i }
