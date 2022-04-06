/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* this was copied from prodict/user/uservar.i */
&GLOBAL-DEFINE PRO_DISPLAY_NAME OpenEdge

/* This routine runs quoter on <infile>, producing <outfile>.*/

/* NOTE: quotes are not available as delimiters!!! (Some     */
/*  OS have problems with passing them on <hutegger 94/06>   */
/* Added check to see if quoter.exe can be found 20000523043 */
/* Added variable to hold full path name of quoter 20010404009 */

DEFINE INPUT PARAMETER infile  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER delim   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER colum   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER outfile AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp            AS CHARACTER NO-UNDO.
DEFINE VARIABLE qpath          AS CHARACTER NO-UNDO.

IF delim = '"'
  THEN DO:
    MESSAGE "Quotes are not allowed as delimiter."
            VIEW-AS ALERT-BOX ERROR.
    RETURN /*ERROR*/.        
    END.

IF delim = ?          THEN delim = "".
ELSE                       delim = "-d ~"" + delim + "~" ".

IF colum = ?          THEN colum = "".
ELSE                       colum = "-c ~"" + colum + "~" ".

IF CAN-DO("MSDOS,WIN32",OPSYS) THEN DO: 
  IF SEARCH("quoter.exe") = ? THEN DO:
    MESSAGE "Unable to find the quoter utility.  Make sure that" SKIP
            "{&PRO_DISPLAY_NAME}' bin directory is in your PATH." SKIP
    VIEW-AS ALERT-BOX ERROR.
    RETURN "error".
  END.
  ELSE
    ASSIGN qpath = SEARCH("quoter.exe").
END.
ELSE  IF OPSYS = "UNIX" THEN DO: 
  IF SEARCH("quoter") = ? THEN DO:
    MESSAGE "Unable to find the quoter utility.  Make sure that" SKIP
            "{&PRO_DISPLAY_NAME}' bin directory is in your PATH." SKIP
    VIEW-AS ALERT-BOX ERROR.
    RETURN "error".
  END.
  ELSE
  ASSIGN qpath = SEARCH("quoter").
END.

IF CAN-DO("MSDOS,WIN32",OPSYS) THEN DO:
  /* There is a limit to the size of a DOS command issued from MS-WINDOWS.
     So, we generate a batch file to disk, execute it, then clean it up. */

  IF "{&WINDOW-SYSTEM}" begins "MS-WIN" THEN DO:
    /* generate a temp file for the batch command */
    RUN "adecomm/_tmpfile.p" (INPUT "qt", INPUT ".bat", OUTPUT tmp).
    OUTPUT TO VALUE(tmp) NO-ECHO.
    PUT UNFORMATTED
      "~"" qpath "~" " /* quotes around paths, to avoid embedded spaces */
      delim  " " 
      colum  " " 
      "~"" infile "~" " 
      "> ~"" outfile "~"".
    OUTPUT CLOSE.
    DOS SILENT VALUE(tmp).
    OS-DELETE VALUE(tmp).
  END.  /* MS-WINDOWS */
  
  ELSE  /* DOS TTY    */
    DOS SILENT VALUE(qpath)
      VALUE(delim)
      VALUE(colum)
      VALUE(infile)
      VALUE(">" + outfile).
END.  /* CAN-DO("MSDOS,WIN32",OPSYS) */

ELSE IF OPSYS = "UNIX" THEN DO: 
  UNIX SILENT VALUE(qpath)
    VALUE(delim)
    VALUE(colum)
    VALUE(infile)
    VALUE(">" + outfile).
END.
ELSE MESSAGE "osquoter.p: Unknown Operating System -" OPSYS.

RETURN.
