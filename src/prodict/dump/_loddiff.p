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

/* loaddiff */

/*----------------------------  DEFINES  ---------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* fields for dif interpretation */
DEFINE VARIABLE holdline  AS CHARACTER FORMAT "x(80)" NO-UNDO.
DEFINE VARIABLE holdline2 AS CHARACTER FORMAT "x(80)" NO-UNDO.
DEFINE VARIABLE numfields AS INTEGER   INITIAL      0 NO-UNDO.
DEFINE VARIABLE numvalue  AS DECIMAL   DECIMALS    10 NO-UNDO.
DEFINE VARIABLE reccount  AS INTEGER   INITIAL      0 NO-UNDO.

/* fields for dif load */
DEFINE NEW SHARED STREAM   loaderr.
DEFINE NEW SHARED VARIABLE recs   AS INTEGER INITIAL 0. /*UNDO*/
DEFINE NEW SHARED VARIABLE errs   AS INTEGER           NO-UNDO.
DEFINE NEW SHARED VARIABLE xpos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE NEW SHARED VARIABLE ypos   AS INTEGER INITIAL ? NO-UNDO.

DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
DEFINE VARIABLE reason    AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmpfile_i AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmpfile_o AS CHARACTER NO-UNDO.
DEFINE STREAM a.
DEFINE STREAM b.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 7 NO-UNDO INITIAL [
  /*  1*/ "File Not In Standard DIF Format",
  /*  2*/ "records in DIF format loaded into",
  /*  3*/ "There was one error encountered during the translation.",
  /*  4*/ "It is listed in the error file",
  /*5,6*/ "There were", "errors encountered during the translation.",
  /*  7*/ "They are listed in the error file"
].

DEFINE VARIABLE err_lang AS CHARACTER EXTENT 14 NO-UNDO INITIAL [
  /* 1*/ "First record is not TABLE",
  /* 2*/ "Second record is not 0,1",
  /* 3*/ "4th record is not VECTORS",
  /* 4*/ "5th record doesn't start with 0,",
  /* 5*/ "7th record is not TUPLES",
  /* 6*/ "8th record doesn't start with 0,",
  /* 7*/ "Incorrect DATA-header, 0,0 is missing",
  /* 8*/ "First DATA-record is not -1,0",
  /* 9*/ "Second DATA-record is not BOT (Beginning Of Tuple)",
  /*10*/ "A type-indicator of a data-value is -1 (reserved for BOT,EOD)",
  /*11*/ "String-value for numeric data is not V NA ERROR TRUE or FALSE",
  /*12*/ "Wrong combination of type indicator and value",
  /*13*/ "Second last record is not -1,0",
  /*14*/ "Last record is not EOD"
].

FORM HEADER
   " Importing.  Press " +
   KBLABEL("STOP") + " to terminate import process. " format "x(60)" skip (0.5)
   WITH FRAME importing CENTERED ROW 5 USE-TEXT.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

PROCEDURE un_scientific. /* convert scientific notation to PROGRESS decimal */

  DEFINE INPUT  PARAMETER holdline AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER numvalue AS DECIMAL   NO-UNDO.

  DEFINE VARIABLE decpart AS CHARACTER NO-UNDO. /* will hold decimal portion */
  DEFINE VARIABLE epos    AS INTEGER   NO-UNDO. /* the POS of 'E' in holdline */
  DEFINE VARIABLE exppart AS INTEGER   NO-UNDO. /* exponent part of number */
  DEFINE VARIABLE negsign AS LOGICAL   NO-UNDO.

  ASSIGN
    negsign  = SUBSTRING(holdline,1,1,"character") = "-"
    holdline = SUBSTRING(holdline,IF negsign THEN 2 ELSE 1,-1,"character")
    epos     = INDEX(holdline,"E").

  IF epos = 0 THEN
    decpart = holdline.
  ELSE DO:
    ASSIGN
      decpart = SUBSTRING(holdline,1,epos - 1,"character")
      exppart = INTEGER(SUBSTRING(holdline,epos + 1,-1,"character")).
    IF exppart < -10 THEN DO: /* Exponent too small for decimal datatype */
      numvalue = 0.
      RETURN.
    END.
    IF exppart > 49 THEN DO: /* Exponent too large for decimal datatype */
      numvalue = ?.
      RETURN.
    END.
    ASSIGN
      decpart = FILL("0",10) + SUBSTRING(decpart,1,1,"character") +
                SUBSTRING(decpart,3,-1,"character") + FILL("0",50)
      decpart = SUBSTRING(decpart,1,11 + exppart,"character") + "."
              + SUBSTRING(decpart,12 + exppart,-1,"character").
  END.
  numvalue = DECIMAL(decpart).
  IF negsign THEN numvalue = - numvalue.

END PROCEDURE.

/*---------------------------  MAIN-CODE  --------------------------*/

/* user_env[4]=filename.dif */
RUN "adecomm/_tmpfile.p" (INPUT "i", INPUT ".adm", OUTPUT tmpfile_i).
RUN "adecomm/_tmpfile.p" (INPUT "o", INPUT ".adm", OUTPUT tmpfile_o).
RUN "prodict/misc/osquoter.p" (user_env[4],?,?,tmpfile_i).
reason = "".

run adecomm/_setcurs.p ("WAIT").

_outer:
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE: /* start reading the data */
/* check for required entries */

  INPUT  STREAM b FROM VALUE(tmpfile_i) NO-ECHO NO-MAP.
  OUTPUT STREAM a TO VALUE(tmpfile_o) NO-ECHO NO-MAP.

  IMPORT STREAM b holdline.
  IF holdline <> "TABLE" THEN DO:
    reason = err_lang[1]. /* First record is not TABLE */
    LEAVE _outer.
  END.

  IMPORT STREAM b holdline.
  IF holdline <> "0,1" THEN DO:
    reason = err_lang[2]. /* Second record is not 0,1 */
    LEAVE _outer.
  END.

  IMPORT STREAM b ^.  /* read comment-record */
  IMPORT STREAM b holdline.
  IF holdline <> "VECTORS" THEN DO:
    reason = err_lang[3]. /* 4th record is not VECTORS */
    LEAVE _outer.
  END.

  IMPORT STREAM b holdline.
  IF NOT holdline BEGINS "0," THEN DO:
    reason = err_lang[4]. /* 5th record doesn't start with 0, */
    LEAVE _outer.
  END.
  numfields = INTEGER(SUBSTRING(holdline,3,78,"character")). /* read num of fields */

  IMPORT STREAM b holdline. /* get rid of blank comment line */
  IMPORT STREAM b holdline.
  IF holdline <> "TUPLES" THEN DO:
    reason = err_lang[5]. /* 7th record is not TUPLES */
    LEAVE _outer.
  END.

  IMPORT STREAM b holdline.
  IF NOT holdline BEGINS "0," THEN DO:
    reason = err_lang[6]. /* 8th record doesn't start with 0, */
    LEAVE _outer.
  END.
  reccount = INTEGER(SUBSTRING(holdline,3,78,"character")). /* read number of records */

  IMPORT STREAM b holdline. /* get rid of blank comment line */
  DO WHILE TRUE:
    IMPORT STREAM b holdline.
    IF holdline <> "DATA" THEN DO: /* if any of the optional header items */
      IMPORT STREAM b ^.
      IMPORT STREAM b ^. /* getting rid of the next two comment lines */
    END. /* if */
    ELSE
      LEAVE. /* time to read the data */
  END. /* do while true */

  IMPORT STREAM b holdline.
  IF holdline <> "0,0" THEN DO:
    reason = err_lang[7]. /* Incorrect DATA-header, 0,0 is missing */
    LEAVE _outer.
  END.

  IMPORT STREAM b holdline. /* get rid of the "" line */

  /* read the data and then subsequently write it out. */
  DO WHILE recs < reccount:
    IMPORT STREAM b holdline.
    IF holdline <> "-1,0"  THEN DO:
      reason = err_lang[8]. /* First DATA-record is not -1,0 */
      LEAVE _outer.
    END.

    recs = recs + 1. /* increase record counter */
    IMPORT STREAM b holdline.
    IF holdline <> "BOT" THEN DO:
      reason = err_lang[9]. /* Second DATA-record is not BOT */
      LEAVE _outer.
    END.

    PAUSE 0 BEFORE-HIDE.
    DO i = 1 TO numfields:
      IMPORT STREAM b holdline.
      IF holdline BEGINS "-1" THEN DO:
        reason = err_lang[10]. /* A type-indicator of a data-value is -1 */
        LEAVE _outer.
      END.

      IF holdline BEGINS "0," THEN DO:
        holdline = SUBSTRING(holdline,3,78,"character").
        IMPORT STREAM b holdline2.
        IF holdline2 = "V" THEN DO:           /* Value */
          /* function to convert scientific notation to PROGRESS decimal */
          RUN un_scientific (INPUT holdline,OUTPUT numvalue).
          PUT STREAM a UNFORMATTED numvalue " ".
        END. /* if "v" */
        ELSE IF holdline2 = "NA"    THEN PUT STREAM a UNFORMATTED ?.
        ELSE IF holdline2 = "ERROR" THEN PUT STREAM a UNFORMATTED 0.
        ELSE IF holdline2 = "TRUE"  THEN PUT STREAM a UNFORMATTED "yes".
        ELSE IF holdline2 = "FALSE" THEN PUT STREAM a UNFORMATTED "no".
        ELSE DO:
          reason = err_lang[11]. /* Value isn't V NA ERROR TRUE FALSE */
          LEAVE _outer.
        END.
      END. /* if case "0" */
      ELSE IF holdline = "1,0" THEN DO:
        IMPORT STREAM b holdline.
        IF holdline = "~"~"" THEN PUT STREAM a UNFORMATTED "- ".
        ELSE PUT STREAM a UNFORMATTED holdline SPACE.
      END. /* if case "1" */
      ELSE DO:
        reason = err_lang[12]. /* Wrong combo of type indicator and value */
        LEAVE _outer.
      END.
    END. /* do numfields */
    PUT STREAM a UNFORMATTED SKIP.
  END. /* do while recs */

  IF reason = "" THEN DO:
    IMPORT STREAM b holdline.
    IF holdline <> "-1,0" THEN DO:
      reason = err_lang[13]. /* Second last record is not -1,0 */
      LEAVE _outer.
    END.
    IMPORT STREAM b holdline.
    IF holdline <> "EOD" THEN DO:
      reason = err_lang[14]. /* Last record is not EOD */
      LEAVE _outer.
    END.
  END.
END.  /* end outer */


INPUT  STREAM b CLOSE.
OUTPUT STREAM a CLOSE.

IF reason <> "" THEN DO:
  run adecomm/_setcurs.p ("").
  MESSAGE new_lang[1] SKIP /* File Not In Standard DIF Format */
      	  reason  
      	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.
ELSE DO:
  /* create and run import program */

  /* user_env[1]=filename, 
     user_env[6]=fieldnames, 
     user_env[10]=disable trigger flag
  */
  OUTPUT STREAM loaderr TO VALUE(user_env[1] + ".e") NO-ECHO.
  INPUT FROM VALUE(tmpfile_o) NO-ECHO NO-MAP.
  CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(user_dbname) NO-ERROR.

  SESSION:IMMEDIATE-DISPLAY = yes.
  VIEW FRAME importing.
  recs = 0. 
  DO ON STOP UNDO, LEAVE:
    RUN "prodict/misc/_runload.i" (INPUT user_env[10])
        VALUE(user_env[1]) 100 100 user_env[6] 0.
  END.
  HIDE FRAME importing NO-PAUSE.
  SESSION:IMMEDIATE-DISPLAY = no.
  INPUT CLOSE.
  OUTPUT STREAM loaderr CLOSE.
  run adecomm/_setcurs.p ("").

  IF errs = 0 THEN DO:
    MESSAGE recs new_lang[2] user_env[1] /* records loaded */
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    OS-DELETE VALUE(user_env[1] + ".e").  /* delete temporary external files */
  END.
  ELSE 
    MESSAGE recs new_lang[2] user_env[1] SKIP
      	    new_lang[IF errs = 1 THEN 3 ELSE 5] 
      	    (IF errs = 1 THEN "" ELSE STRING(errs) + " " + new_lang[6]) SKIP
      	    "***" new_lang[IF errs = 1 THEN 4 ELSE 7] user_env[1] + ".e"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

OS-DELETE VALUE(tmpfile_i) VALUE(tmpfile_o).
RETURN.

/*------------------------------------------------------------------*/
