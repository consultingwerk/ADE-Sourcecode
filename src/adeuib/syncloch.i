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
/* syncloch.i  SYNChronize a LayOut CHange                                       */

/*  When the master layout record is changed, all other layouts must be changed
    in a similar manner, if they had the same original attributes.  Further, if
    this change is undoable, then the corresponding _ACTION record must record
    the RECID's of the _L records (beyond that of the Master Layout _L) that must
    be undone if the user decides to undo the change.  This include file creates a
    comma delimited list of recids of _L's that need to be undone.  This list ends
    in a comma, so only n - 1 entries need to be processed.
    
    
    
    PARAMETERS:
    
    &Master_L    -  This is the name of the buffer containing the _L of the master
                    layout.              
    &FLD1        -  This is the name of a field must be synchronized
    &NEW-VALUE1  -  Variable or expression containing the new value
    
                                                                                 */
                                                                                 
  &IF DEFINED(SYNC-INC) = 0 &THEN
    &SCOPED-DEFINE SYNC-INC yes
    DEFINE BUFFER sync_L        FOR _L.
  &ENDIF
                                                                                 
  IF {&Master_L}._LO-NAME = "Master Layout" THEN DO:
    FOR EACH sync_L WHERE sync_L._u-recid =  {&Master_L}._u-recid AND
                          sync_L._lo-name NE {&Master_L}._lo-name AND
                          sync_L._{&FLD1} =  {&Master_L}._{&FLD1}:
       ASSIGN sync_L._{&FLD1} = {&NEW-VALUE1}.
    END.  /* For each alternative layout */
  END.  /* Only do anything if the master has been changed */
    
