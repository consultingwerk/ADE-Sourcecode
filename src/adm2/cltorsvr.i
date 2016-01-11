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
/*------------------------------------------------------------------------
    File        : adm2/cltorsvr.i
    Purpose     : This include file is used many times in data.p to send
                  a request (in the form of a function) to the
                  appServer if the ASDivision is "Client" or to send the
                  request up the Super Procedure stack or just execute
                  the code for the function if we are local.

    Syntax      : {src/adm2/cltorsvr.i FnctName RetType "param(s)" Super}
                     Where FnctName is the name of the Function to call
                           ReType is the return type of the function
                                  (either Log, Char, Int, Dec, Dat, or Row)
                                  (actually either "Log" or anything else)
                           param() is an argument list to the function.
                           Super is an optional argument (normally omitted)
                             which if specified and NO will just fall out
                             of the include file to execute that code in
                             the function locally instead of doing SUPER().

    Modified    : December 27, 1999
  ----------------------------------------------------------------------*/

  DEFINE VARIABLE hAppServer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision AS CHARACTER NO-UNDO.

  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
  DO: /* If we're just the client then tell the AppServer to adjust the
         where clause. */
    {get ASHandle hAppServer}.
    IF VALID-HANDLE(hAppServer) AND hAppServer NE TARGET-PROCEDURE THEN 
    DO:
      &IF "{3}":U NE "":U &THEN
        RETURN ( DYNAMIC-FUNCTION("{1}":U IN hAppServer, {3} )) .
      &ELSE
        RETURN ( DYNAMIC-FUNCTION("{1}":U IN hAppServer)) .
      &ENDIF
       /* unbind if this call did the bind (getASHandle) */
      RUN unbindServer IN TARGET-PROCEDURE (?). 
    END. /* If we have a valid hAppServer handle */
    ELSE RETURN &IF "{2}":U = "Log":U &THEN FALSE &ELSE ? &ENDIF.
  END.    /* END DO IF Client */
  &IF "{4}":U NE "No":U &THEN
  ELSE RETURN SUPER({3}). /* Get query.p's version of this function. */
  &ENDIF
