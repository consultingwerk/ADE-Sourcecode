/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

