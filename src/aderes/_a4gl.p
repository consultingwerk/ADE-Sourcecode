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
/*
* _a4gl.p
*
*    This procedure wraps the write-the-current-query function
*    of RESULTS for the VAR programmer using sffire("Write4GL").
*
*    The problem is that it doesn't make sense to generate source
*    for those views because they contain widgets. Trying to "run" those 
*    views inside of an OUTPUT statement will cause a hang.
*
*    Let the VAR know that there is a problem.
*/

{ aderes/s-system.i }
{ aderes/_fdefs.i }

DEFINE INPUT PARAMETER filename AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER usage    AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-l AS LOGICAL NO-UNDO.

IF qbf-module = "b":u OR qbf-module = "f":u THEN DO:
  DEFINE STREAM fStream.

  MESSAGE "This feature does not work with Form or Browse View."
    VIEW-AS ALERT-BOX.

  problemo:
  DO ON ERROR UNDO problemo, RETRY problemo:
    IF RETRY THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
        SUBSTITUTE("There is a problem writing &1.  The file will not be created.",filename)).

      RETURN.
    END.

    /*
    * Create an empty file, so that any RUN based on the filename
    * will at least not be fatal, or cause RESULTS to hang.
    */
    OUTPUT STREAM fStream TO VALUE(filename) NO-ECHO.
    PUT STREAM fStream UNFORMATTED ' '.
    OUTPUT STREAM fStream CLOSE.

    RETURN.
  END. /* problemo */
END.
RUN aderes/s-write.p (filename, usage).

/* _a4gl.p - end of file */

