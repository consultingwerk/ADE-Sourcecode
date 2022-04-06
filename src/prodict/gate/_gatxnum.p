/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
