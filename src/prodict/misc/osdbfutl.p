/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Runs dbf with dbfmode */

/*
Usage: dbf dbfmode nuximode args...
  dbfmode = 1 (produce .d file)
          = 2 (produce .df file (table info))
          = 3 (produce .df file (index info))
  nuximode = 0 .dbf file created by 680x0 (lsb, msb format)
           = 1 .dbf file created by 80x86 (msb, lsb format)
  args... =
    if dbfmode = 1: filename.dbf filename.err >filename.d
               = 2: filename.dbf filename.err >filename.df
               = 3: filename.dbf filename.ndx filename.err >filename.df
*/

DEFINE INPUT PARAMETER dbfmode AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER nuximod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER infiles AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER errfile AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER outfile AS CHARACTER NO-UNDO.

DEFINE VARIABLE tmp     AS CHARACTER.

IF CAN-DO("MSDOS,WIN32",OPSYS)
 THEN DO:
  /* There is a limit to the size of a DOS command issued from MS-WINDOWS.
     So, we generate a batch file to disk, execute it, then clean it up. */
  IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
   THEN DO:
    /* generate a temp file for the batch command */
    RUN "adecomm/_tmpfile.p" (INPUT "qt", INPUT ".bat", OUTPUT tmp).
    OUTPUT TO VALUE(tmp) NO-ECHO.
    PUT UNFORMATTED
      "dbf "
      dbfmode " " 
      nuximod " " 
      infiles " " 
      errfile " " 
      ">" outfile.
    OUTPUT CLOSE.
    DOS SILENT VALUE(tmp).
    OS-DELETE VALUE(tmp).
    END.  /* MS-WINDOWS */
  
   ELSE  /* DOS TTY    */
    DOS SILENT dbf
      VALUE(dbfmode)
      VALUE(nuximod)
      VALUE(infiles)
      VALUE(errfile)
      VALUE(">" + outfile).
  END.  /* CAN-DO("MSDOS,WIN32",OPSYS) */

ELSE IF OPSYS = "OS2"
 THEN OS2 SILENT dbf
    VALUE(dbfmode)
    VALUE(nuximod)
    VALUE(infiles)
    VALUE(errfile)
    VALUE(">" + outfile).

ELSE IF OPSYS = "UNIX"
 THEN UNIX SILENT dbf
    VALUE(dbfmode)
    VALUE(nuximod)
    VALUE(infiles)
    VALUE(errfile)
    VALUE(">" + outfile).

ELSE IF OPSYS = "VMS"
 THEN DO:
  OUTPUT TO VALUE(errfile) NO-ECHO.
  PUT UNFORMATTED "~"The 'dbf' utility is not supported under VMS.~"" SKIP.
  OUTPUT CLOSE.
  END.

ELSE IF OPSYS = "BTOS"
 THEN BTOS SILENT VALUE(SEARCH("Dbf.Run")) DBF
    VALUE(dbfmode)
    VALUE(nuximod)
    VALUE(infiles)
    VALUE(errfile)
    VALUE(">" + outfile).

 ELSE DO:
  OUTPUT TO VALUE(errfile) NO-ECHO.
  PUT UNFORMATTED
    "~"osdbfutl.p: Unknown Operating System - " + OPSYS + "~"" SKIP.
  OUTPUT CLOSE.
  END.

RETURN.
