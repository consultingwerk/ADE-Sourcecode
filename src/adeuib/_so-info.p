/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _so-info.p

  Description: Calls the standard SmartObject information dialog in the
               ADM Support code, showing the Supported links, external 
               tables and internal tables for a SmartObject.
               
  Input Parameters:
      p_Urecid - Recid of the Universal Widget Record corresponding to the
                 SmartObject.

  Author: Wm.T.Wood 

  Created: March, 1995       
  
------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_Urecid AS RECID NO-UNDO.

/* Shared variables */
{ adeuib/uniwidg.i }

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* Find the item of interest....If it is not a smartobject then return */
FIND _U WHERE RECID(_U) eq p_Urecid.
FIND _S WHERE RECID(_S) eq _U._x-recid NO-ERROR.
IF NOT AVAILABLE _S THEN RETURN.

/* If the SmartObject is not a real valid object, return after telling
   the user. */
IF NOT _S._valid-object 
THEN MESSAGE "The SmartObject" _U._NAME "cannot supply any information" {&SKP}
            "about itself." SKIP(1)
            "The master file '" + _S._FILE-NAME + "' did not successfully" {&SKP}
            "run.  The UIB cannot query the object until it is a valid" {&SKP}
            "running PROGRESS persistent procedure." 
            VIEW-AS ALERT-BOX INFORMATION TITLE "SmartInfo - " + _U._NAME.
