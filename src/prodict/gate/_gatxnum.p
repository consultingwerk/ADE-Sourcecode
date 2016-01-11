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

/*--------------------------------------------------------------------

File: prodict/gate/_gatxnum.p

Description:
    Some DataServers don't supply a index-number, so we have to 
    generate one.
    
Input-Parameters:
    p_file-recid    RECID of file the indes gets defined for
    
Output-Parameters:
    p_index-num     Index-number to be used
    
    
History:
    hutegger    94/07/01    creation
    
--------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_file_recid AS RECID NO-UNDO.
DEFINE OUTPUT PARAMETER p_index-num  AS INTEGER NO-UNDO.

/*------------------------------------------------------------------*/

ASSIGN p_index-num = 0.

FOR EACH DICTDB._Index 
  WHERE DICTDB._Index._File-recid = p_file_recid 
  NO-LOCK:
  IF DICTDB._Index._idx-num <> ? 
    AND DICTDB._Index._idx-num > p_index-num 
    THEN ASSIGN p_index-num = DICTDB._Index._idx-num.
  END.

ASSIGN p_index-num = p_index-num + 1.

RETURN.


/*------------------------------------------------------------------*/
