/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
DEFINE VARIABLE vdirname AS CHARACTER FORMAT "X(70)" NO-UNDO.
DEFINE TEMP-TABLE ttfiles NO-UNDO
       FIELD filename AS CHARACTER FORMAT "X(20)"
       FIELD fullname AS CHARACTER FORMAT "X(40)"
       FIELD fileattr AS CHARACTER
       FIELD readdir AS LOGICAL
       FIELD appbuilder AS LOGICAL
       FIELD haslicense AS LOGICAL
       INDEX idx1 readdir.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE STREAM tempio.

/*
RUN readdir("D:\ICF\object").
*/

/*
FOR EACH ttfiles WHERE (NOT filename BEGINS "."
                   AND INDEX(fileattr,"D") > 0)
                   /* OR filename MATCHES "*~~.p" */: 
    DISPLAY RECID(ttfiles).
    DISPLAY ttfiles.
END.

*/

PROCEDURE listfiles:
OUTPUT TO appcompile.log KEEP-MESSAGES.
FOR EACH ttfiles WHERE (filename MATCHES "*~~.p"
                    OR filename MATCHES "*~~.w")
                   AND INDEX(fileattr, "F") > 0:

    PUT UNFORMATTED fullname SKIP.
END.                    
OUTPUT CLOSE.
END.

PROCEDURE getfileinfo:
DEFINE INPUT PARAMETER pfilename AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pfileinfo AS CHARACTER NO-UNDO.

DEFINE VARIABLE wline AS CHARACTER NO-UNDO.

INPUT STREAM tempio FROM VALUE(pfilename).
REPEAT:
  IMPORT STREAM tempio UNFORMATTED wline.
  IF pfileinfo = "" THEN DO:
      IF wline BEGINS "&ANALYZE-SUSPEND" THEN DO:
         pfileinfo = "AppBuilder procedure " + ENTRY(3, wline, ' ').
      END.
      ELSE pfileinfo = "free form procedure".     
  END.
  ELSE DO:
      IF wline BEGINS "* http://www.possenet.org/license.html" THEN DO:
         pfileinfo = pfileinfo + " ,yes, has license".
      END.
  END.
  IF wline BEGINS "&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK" THEN LEAVE.
END.
INPUT STREAM tempio CLOSE.

IF NUM-ENTRIES(pfileinfo) = 1 THEN pfileinfo = pfileinfo + " ,no, does not have license".

END.

PROCEDURE displayfileinfo:
DEFINE INPUT PARAMETER pfilename AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER h AS HANDLE NO-UNDO.

DEFINE VARIABLE wline AS CHARACTER NO-UNDO.
DEFINE VARIABLE winfo AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pfilename).
IMPORT UNFORMATTED wline.

IF wline BEGINS "&ANALYZE-SUSPEND" THEN DO:
   winfo = winfo + "AppBuilder file: " + ENTRY(3, wline, ' ').
END.
ELSE winfo = winfo + "Regular procedure.".
INPUT CLOSE.

h:SCREEN-VALUE = winfo.

END.

PROCEDURE cleantt:
DEFINE INPUT PARAMETER extlist AS CHARACTER NO-UNDO.


  FOR EACH ttfiles WHERE INDEX(fileattr, "D") > 0:
      DELETE ttfiles.
  END.

  FOR EACH ttfiles:
      IF NUM-ENTRIES(filename, ".") < 2 THEN DELETE ttfiles. /* no extension and blank files ... */
      ELSE DO:
         /* MESSAGE filename "-" extlist. */
         IF LOOKUP(ENTRY(2, filename, "."), extlist) = 0 THEN DELETE ttfiles.
      END.
  END.
END.

PROCEDURE readDir:
DEFINE INPUT PARAMETER pdirname AS CHARACTER NO-UNDO.

EMPTY TEMP-TABLE ttfiles.

/* MESSAGE pdirname VIEW-AS ALERT-BOX. */
RUN importDir(pdirname).

DO WHILE CAN-FIND(FIRST ttfiles WHERE readdir):
FOR EACH ttfiles WHERE readdir AND INDEX(ttfiles.fileattr, "D") > 0:
    readdir = NO.
    RUN importDir(fullname).
END.
END.

END PROCEDURE.

PROCEDURE importDir:
DEFINE INPUT PARAMETER pdirname AS CHARACTER NO-UNDO.

INPUT FROM OS-DIR(pdirname).
REPEAT:
  CREATE ttfiles.
  IMPORT filename fullname fileattr.
  readdir = IF filename BEGINS "." THEN NO ELSE YES.
  IF INDEX(ttfiles.fileattr, "D") = 0 THEN readdir = NO.
  ASSIGN ttfiles.appbuilder = ? ttfiles.haslicense = ?.
END.
INPUT CLOSE.
END PROCEDURE.

PROCEDURE insertlicense:
DEFINE INPUT PARAMETER pfilename AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER appbuilder AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER haslicense AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER poutfilename AS CHARACTER NO-UNDO.

DEFINE VARIABLE wline AS CHARACTER NO-UNDO.

OUTPUT TO VALUE(poutfilename).

IF NOT haslicense AND NOT appbuilder THEN RUN addposse.

INPUT FROM VALUE(pfilename).
REPEAT:
  IMPORT UNFORMATTED wline.
  IF wline = "" THEN PUT SKIP(1).
  ELSE PUT UNFORMATTED wline SKIP.
  IF wline BEGINS "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS" THEN DO:
     IF NOT haslicense AND appbuilder THEN RUN addposse.
  END.
END.
INPUT CLOSE.

OUTPUT CLOSE.
END.

PROCEDURE addposse:
DEFINE VARIABLE wline AS CHARACTER NO-UNDO.

INPUT FROM VALUE(SEARCH("af/doc/posse.lic":U)).
REPEAT:
  IMPORT UNFORMATTED wline.
  PUT UNFORMATTED wline SKIP.
END.
INPUT CLOSE.
END PROCEDURE.
