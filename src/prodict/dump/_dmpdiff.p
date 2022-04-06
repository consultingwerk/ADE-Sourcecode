/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------- 

File: dump/_dmpdiff.p 

Description:
    program to dump data in 'dif' format 

Input Parameters:
    user_env[ 1] = filename to export
    user_env[ 2] = 'where' clause
    user_env[ 3] = 'by' clause
    user_env[ 4] = output file name
    user_env[ 5] = number of fields
    user_env[ 6] = field list, comma delimited
    user_env[ 7] = ?, or filename to save generated code in
    user_env[ 9] = format name for message
    user_env[14] = "y" - disable triggers, "n" - do not disable triggers


History:
    95/07   hutegger    prepend <db>.<table> to field-names in order to
                        make generated program work with multiple-schema-
                        environement
    10/15/03 D. McMann  Add support for datetime and datetime-tz  

----------------------------------------------------------------------*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE NEW SHARED VARIABLE totrecs AS INTEGER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
DEFINE VARIABLE dbfn      AS CHARACTER NO-UNDO.
DEFINE VARIABLE qual      AS CHARACTER NO-UNDO.
DEFINE VARIABLE sort      AS CHARACTER NO-UNDO.
DEFINE VARIABLE scrap     AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmpfile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE hlddt     AS CHARACTER NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 2 NO-UNDO INITIAL [
  /* 1*/ "records were dumped in DIF format to",
  /* 2*/ ""
].

FORM HEADER
   " Exporting.  Press "
   + KBLABEL("STOP")
   + " to terminate export process. " format "x(60)" skip(0.5)
   WITH FRAME exporting CENTERED ROW 5 USE-TEXT.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------*/

/*--------------------------------------------------------------------*/

ASSIGN
  dbfn    = user_env[1]
  qual    = user_env[2]
  sort    = user_env[3]
  totrecs = 0.

/* This thing counts records into 'totrecs' for the 'dif' file header. */
CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(user_dbname) NO-ERROR.
DO ON STOP UNDO, LEAVE:
  RUN "prodict/misc/_rundift.i" dbfn qual.
  END.

IF user_env[7] = ?
 THEN RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
OUTPUT TO VALUE(IF user_env[7] = ?
                 THEN tmpfile
                 ELSE user_env[7]
               ) NO-MAP.
PUT UNFORMATTED
  'DEFINE SHARED VARIABLE totrecs AS INTEGER NO-UNDO.'  SKIP
  'DEFINE VARIABLE ans AS CHARACTER NO-UNDO.'           SKIP
  'DEFINE VARIABLE hlddt AS CHARACTER NO-UNDO. '        SKIP
  'OUTPUT TO "' user_env[4] '" NO-MAP.'                 SKIP.

IF user_env[14] = "y"
 THEN PUT UNFORMATTED
    "DISABLE TRIGGERS FOR DUMP OF DICTDB2." user_env[1] "." SKIP.

PUT UNFORMATTED
  'PUT UNFORMATTED "TABLE" SKIP'                SKIP
  '  "0,1" SKIP'                                SKIP
  '  """" "' user_env[1] '" """" SKIP'          SKIP /*file-name*/
  '  "VECTORS" SKIP'                            SKIP
  '  "0,' user_env[5] '" SKIP'                  SKIP /*count_chosen*/
  '  """""" SKIP'                               SKIP
  '  "TUPLES" SKIP'                             SKIP
  '  "0,' totrecs '" SKIP'                      SKIP
  '  """""" SKIP'                               SKIP
  '  "DATA" SKIP'                               SKIP
  '  "0,0" SKIP'                                SKIP
  '  """""" SKIP.'                              SKIP.

ASSIGN totrecs = 0.
PUT UNFORMATTED
  'FOR EACH DICTDB2.' dbfn                      SKIP
  '  ' qual ' ' sort ':'                        SKIP
  '  PUT UNFORMATTED "-1,0" SKIP "BOT" SKIP.'   SKIP.

FIND DICTDB._File
  WHERE DICTDB._File._Db-recid  = drec_db
  AND   DICTDB._File._File-name = user_env[1]
  AND  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN").

DO i = 1 TO NUM-ENTRIES(user_env[6]): /* count_chosen */

  FIND DICTDB._Field OF DICTDB._File
    WHERE DICTDB._Field._Field-name = ENTRY(i,user_env[6]).
  ASSIGN scrap = "DICTDB2." + DICTDB._File._File-name
               + "."        + DICTDB._Field._Field-name.

  IF CAN-DO("character,date",_Field._Data-type)
   THEN PUT UNFORMATTED
      '  PUT UNFORMATTED "1,0" SKIP """" ' scrap
        ' """" SKIP.'                                           SKIP.
  IF CAN-DO("datetime,datetime-tz",_Field._Data-type)THEN DO:
    PUT UNFORMATTED
      ' ASSIGN hlddt = ISO-DATE(' scrap ').'                    SKIP.
    PUT UNFORMATTED
      '  PUT UNFORMATTED "1,0" SKIP """"  hlddt  """" SKIP.'  SKIP.
  END.
  ELSE IF CAN-DO("integer,recid",_Field._Data-type)
   THEN PUT UNFORMATTED
      '  PUT UNFORMATTED "0," ' scrap
        ' SKIP "V" SKIP.'                                       SKIP.
  ELSE IF DICTDB._Field._Data-type = "decimal"
   THEN PUT UNFORMATTED
      '  RUN to_scientific (INPUT ' scrap ',OUTPUT ans).'       SKIP
      '  PUT UNFORMATTED "0," ans SKIP "V" SKIP.'               SKIP.
  ELSE IF DICTDB._Field._Data-type = "logical"
   THEN PUT UNFORMATTED
      '  ASSIGN ans = (IF ' scrap ' THEN "TRUE" ELSE IF NOT '
        scrap ' THEN "FALSE" ELSE "NA").'
      '  PUT UNFORMATTED "1,0" SKIP ans SKIP.'                  SKIP.
  END.

PUT UNFORMATTED
  '  ASSIGN totrecs = totrecs + 1.'                              SKIP
  '  END.'                                                       SKIP
  'PUT UNFORMATTED "-1,0" SKIP "EOD" SKIP.'                      SKIP
  'OUTPUT CLOSE.'                                                SKIP
  'RETURN.'                                                      SKIP(1)
  'PROCEDURE to_scientific.'                                     SKIP
  '  DEFINE INPUT  PARAMETER numb    AS DECIMAL   NO-UNDO.'      SKIP
  '  DEFINE OUTPUT PARAMETER ans     AS CHARACTER NO-UNDO.'      SKIP
  '  DEFINE        VARIABLE  negsign AS LOGICAL   NO-UNDO.'      SKIP
  '  DEFINE        VARIABLE  expnumb AS INTEGER   NO-UNDO.'      SKIP
  '  DEFINE        VARIABLE  lognumb AS DECIMAL   NO-UNDO.'      SKIP
  '  IF numb = 0'                                                SKIP
  '    THEN ans = "0.0000000000E+01".'                           SKIP
  '    ELSE ASSIGN'                                              SKIP
  '      negsign = numb < 0'                                     SKIP
  '      numb    = ABSOLUTE(numb)'                               SKIP
  '      ans     = STRING(numb,FILL("9",50) + ".9999999999")'    SKIP
  '      lognumb = LOG(numb,10)'                                 SKIP
  '      expnumb = TRUNCATE(lognumb -'                           SKIP
  '                (IF lognumb > 0 THEN 0 ELSE 0.9999999999),0)' SKIP
  '      ans     = SUBSTRING(ans,1,50) + SUBSTRING(ans,52)'      SKIP
  '      ans     = SUBSTRING(ans,50 - expnumb,1) + "."'          SKIP
  '              + SUBSTRING(ans,51 - expnumb)'                  SKIP
  '      ans     = ans + "E" + STRING(expnumb,"+99")'            SKIP
  '      ans     = (IF negsign THEN "-" ELSE "") + ans.'         SKIP
  '  END PROCEDURE.'                                             SKIP.
OUTPUT CLOSE.

IF user_env[7] = ?
 THEN DO:
  SESSION:IMMEDIATE-DISPLAY = yes.
  VIEW FRAME exporting.
  run adecomm/_setcurs.p ("WAIT").
  
  DO ON STOP UNDO, LEAVE:
    RUN VALUE(tmpfile).
    END.

  HIDE FRAME exporting NO-PAUSE.
  SESSION:IMMEDIATE-DISPLAY = no.
  run adecomm/_setcurs.p ("").

  MESSAGE totrecs new_lang[1] user_env[4]
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   OS-DELETE VALUE(tmpfile).
  END.

RETURN.

/*--------------------------------------------------------------------*/
