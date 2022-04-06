/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* print-it.p

   Auth: J. Hennen ( jh@chdr.leidenuniv.nl)
   Date: 9-nov-1997
   Goal: Strip all UIB comments from a .W file and send the output to a text file

*/   

DEF VAR os-file-name AS C NO-UNDO.
DEF VAR output-name  AS C NO-UNDO.

DEF VAR ok AS L NO-UNDO.

DEFINE TEMP-TABLE code-block NO-UNDO
       FIELD bl-name AS C
       FIELD bl-type AS C
       FIELD bl-code AS C.

DEF VAR last-file AS C NO-UNDO.

DO WHILE TRUE:
SYSTEM-DIALOG GET-FILE os-file-name 
       FILTERS "UIB files" "*.w",
               "Procedure files" "*.p",
               "Include files" "*.i",
               "All files" "*.*"
       USE-FILENAME 
       UPDATE ok TITLE "Select Input Procedure".

IF NOT ok THEN RETURN.
ASSIGN output-name = SUBSTR(os-file-name, 1, R-INDEX(os-file-name,".")) + "txt"
       last-file   = os-file-name.
RUN process-file.
END.

PROCEDURE process-file.

DEF VAR code-line AS C NO-UNDO.

DEF VAR newblock  AS L NO-UNDO.
DEF VAR endblock  AS L NO-UNDO INIT TRUE.
DEF VAR blocktype AS C NO-UNDO.

INPUT FROM VALUE(os-file-name).

DO WHILE TRUE ON ENDKEY UNDO, LEAVE:
   IMPORT UNFORMATTED code-line.

&SCOP checkblock IF LOOKUP("~{&type}", code-line, " ") <> 0~
                 THEN ASSIGN newblock  = TRUE~
                             endblock  = FALSE~
                             blocktype = "~{&code}".

IF LOOKUP("_uib-code-block-end", code-line, " ") <> 0
THEN ASSIGN endblock = TRUE.

&SCOP type _definitions
&SCOP code DEFINITIONS
{&checkblock}

&SCOP type _funtion-forward
&SCOP code FUNCTIONS
{&checkblock}

&SCOP type _control
&SCOP code TRIGGERS
{&checkblock}

&SCOP type _main-block
&SCOP code MAIN BLOCK
{&checkblock}

&SCOP type _procedure
&SCOP code PROCEDURES
{&checkblock}

IF newblock = TRUE AND endblock = FALSE
THEN DO:
     CREATE code-block.
     ASSIGN code-block.bl-type = blocktype
            newblock   = FALSE.
     END.
ELSE 
IF endblock = FALSE
THEN do:
     ASSIGN code-block.bl-code = code-block.bl-code + code-line + chr(13).
     end.

END.

INPUT CLOSE.

OUTPUT TO VALUE(output-name) PAGE-SIZE 66.

&SCOP break-by LOOKUP(code-block.bl-type,"definitions,functions,triggers,main block,procedures")

FOR EACH code-block BREAK BY {&break-by}:

DEF VAR i AS I NO-UNDO.
DEF VAR first-line AS L NO-UNDO.

FORM HEADER os-file-name FORMAT "X(60)"
            PAGE-NUMBER FORMAT "Page: >>>9" TO 98 SKIP
            FILL("-", 100) FORMAT "X(98)" SKIP(1)
     WITH FRAME pt NO-BOX DOWN PAGE-TOP WIDTH 100.
VIEW FRAME pt.

ASSIGN first-line = TRUE.

IF FIRST-OF({&break-by})
THEN DISPLAY code-block.bl-type FORMAT "X(20)" SKIP
     FILL("-", 100) FORMAT "X(98)" SKIP WITH NO-BOX NO-LABELS FRAME A WIDTH 200.

DO WHILE i <= LENGTH(code-block.bl-code) OR i = 0:

   ASSIGN i                  = INDEX(code-block.bl-code, chr(13))
          code-line          = SUBSTR(code-block.bl-code,1,i - 1)
          code-block.bl-code = SUBSTR(code-block.bl-code,i + 1).

   IF first-line AND code-line = "" THEN NEXT. /* skip leadin blank lines */

   DISPLAY code-line FORMAT "X(160)" WITH DOWN WIDTH 180 NO-LABELS.

   IF first-line THEN DOWN 1. /* extra blank line */

   ASSIGN first-line = FALSE.

   DOWN.

END.

DOWN 1.

END.        

OUTPUT CLOSE.

END PROCEDURE.
