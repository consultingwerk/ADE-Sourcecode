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
