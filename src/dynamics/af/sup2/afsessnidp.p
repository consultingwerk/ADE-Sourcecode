/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afsessnidp.p

  Description:  Session Id Procedure

  Purpose:      To allocate a unique session id using the sequence
                seq_session_id.
                This is used when running client side with no Appserver
                connection to replace the server-connection-id.

  Parameters:   output session id

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   30/05/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pcSessionId AS CHARACTER NO-UNDO.

IF CONNECTED("RVDB") THEN
  RUN rv/app/rvsessnidp.p (OUTPUT pcSessionId).
ELSE
  RUN ry/app/rysessnidp.p (OUTPUT pcSessionId).
