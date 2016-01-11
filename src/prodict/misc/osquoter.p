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
            "Progress' bin directory is in your PATH." SKIP
    VIEW-AS ALERT-BOX ERROR.
    RETURN "error".
  END.
  ELSE
    ASSIGN qpath = SEARCH("quoter.exe").
END.
ELSE  IF OPSYS = "UNIX" THEN DO: 
  IF SEARCH("quoter") = ? THEN DO:
    MESSAGE "Unable to find the quoter utility.  Make sure that" SKIP
            "Progress' bin directory is in your PATH." SKIP
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
      qpath " "
      delim  " " 
      colum  " " 
      infile " " 
      ">" outfile.
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
