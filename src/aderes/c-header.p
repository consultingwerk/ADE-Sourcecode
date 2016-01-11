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
* c-header.p - generates header/footer for reports
*/

{ aderes/j-define.i }
{ aderes/s-system.i }

DEFINE INPUT  PARAMETER pi_header AS CHARACTER NO-UNDO. /* in header string */
DEFINE INPUT  PARAMETER pi_mode   AS LOGICAL   NO-UNDO. /* to 4gl/for display */
DEFINE OUTPUT PARAMETER po_code   AS CHARACTER NO-UNDO. /* out 4gl code */
DEFINE OUTPUT PARAMETER po_width  AS INTEGER   NO-UNDO. /* width in chars */

DEFINE VARIABLE v_edge    AS INTEGER   NO-UNDO. /* left-edge for index/substr */
DEFINE VARIABLE v_func    AS CHARACTER NO-UNDO. /* 4gl function */
DEFINE VARIABLE v_fmt     AS CHARACTER NO-UNDO. /* format */
DEFINE VARIABLE v_begin   AS INTEGER   NO-UNDO. /* start of token in string */
DEFINE VARIABLE v_left    AS CHARACTER NO-UNDO. /* left-brace character */
DEFINE VARIABLE v_right   AS CHARACTER NO-UNDO. /* right-brace character */
DEFINE VARIABLE v_mdy     AS CHARACTER NO-UNDO. /* get dmy settings */
DEFINE VARIABLE v_scrap   AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE v_table   AS CHARACTER NO-UNDO. /* real table name */
DEFINE VARIABLE del-left  AS INTEGER   NO-UNDO.
DEFINE VARIABLE del-right AS INTEGER   NO-UNDO.
DEFINE VARIABLE v_token   AS INTEGER   NO-UNDO.

DEFINE TEMP-TABLE hdr-text
  FIELD hdr-seq   AS INTEGER    /* sequence */
  FIELD hdr-type  AS CHARACTER  /* "text" or function */
  FIELD hdr-show  AS CHARACTER  /* display format */
  FIELD hdr-gap   AS INTEGER    /* space between tokens */
  INDEX hdr-order IS UNIQUE hdr-seq.

ASSIGN
  po_width = LENGTH(pi_header,"RAW":u)
  po_code  = pi_header.

IF pi_header = "" THEN RETURN.

/* select the delimiters.  we allow { }, < >, ( ) and [ ] */
RUN find_delims (pi_header,OUTPUT v_left,OUTPUT v_right).

/* set up stuff for display only */
IF NOT pi_mode THEN DO:
  v_mdy = SESSION:DATE-FORMAT.

  ASSIGN
    v_mdy    = CAPS(SUBSTITUTE("&1&1/&2&2/&3&3":u,
      SUBSTRING(v_mdy,1,1,"CHARACTER":u),
      SUBSTRING(v_mdy,2,1,"CHARACTER":u),
      SUBSTRING(v_mdy,3,1,"CHARACTER":u)))
    po_code  = REPLACE(po_code,v_left + "DATE":u  + v_right,v_mdy)
    po_code  = REPLACE(po_code,v_left + "TODAY":u + v_right,v_mdy)
    po_code  = REPLACE(po_code,v_left + "TIME":u  + v_right,'HH:MM:SS':u)
    po_width = LENGTH(po_code,"RAW":u).
  RETURN.
END.

/* check for leading blanks */
DO v_begin = 1 TO LENGTH(po_code,"CHARACTER":u):
  IF SUBSTRING(po_code,v_begin,1,"CHARACTER":u) > " " THEN LEAVE.
END.

/* get leading text before any function */
IF po_code BEGINS " ":u THEN DO:
  CREATE hdr-text.
  ASSIGN
    hdr-text.hdr-seq  = 0
    hdr-text.hdr-type = "text":u
    hdr-text.hdr-gap  = v_begin - 1.
END.

/* parse text strings and tokens */
DO WHILE v_begin <= LENGTH(po_code,"CHARACTER":u):
  ASSIGN
    del-left  = INDEX(po_code, v_left, v_begin)
    del-right = INDEX(po_code, v_right, v_begin)
    v_token   = v_token + 1.

  CREATE hdr-text.
  hdr-text.hdr-seq  = v_token.

  /* found function */
  IF del-left = v_begin THEN DO:
    hdr-text.hdr-type = TRIM(SUBSTRING(po_code,del-left,
                               del-right - del-left + 1,"CHARACTER":u),
                               (v_left + v_right)).

    /*
     * The following is a "near the end of release" code change. It is
     * designed to fix a problem with truncating the layout, without
     * affecting too much code. The problem is that the fucntions
     * ({DATE}, {TIME} etc.) are tokens for formats that are usually larger.
     * For example, the format used for date is "99/99/99". The problem is
     * the po_length is based on the token. So make some adjustments to the
     * length with certain formats. This should be reviewed in the future!
     */
    CASE hdr-text.hdr-type:
      WHEN "PAGE":u  THEN
        ASSIGN hdr-text.hdr-show = 'TRIM(STRING(PAGE-NUMBER,">>>>9"))':u.
      WHEN "DATE":u THEN
        ASSIGN hdr-text.hdr-show = 'STRING(TODAY,"99/99/99")':u
               po_width          = po_width + 2.
      WHEN "TODAY":u THEN
        ASSIGN hdr-text.hdr-show = 'STRING(TODAY,"99/99/99")':u
               po_width          = po_width + 1.
      WHEN "COUNT":u THEN
        ASSIGN hdr-text.hdr-show = 'TRIM(STRING(qbf-count,">>>>>>9"))':u.
      WHEN "USER":u  THEN
        ASSIGN hdr-text.hdr-show = 'TRIM(USERID("RESULTSDB"))':u
               po_width          = po_width + 4.
      WHEN "NOW":u   THEN
        ASSIGN hdr-text.hdr-show = 'STRING(TIME,"HH:MM:SS")':u
               po_width          = po_width + 3.
      WHEN "TIME":u  THEN
        ASSIGN hdr-text.hdr-show = 'STRING(qbf-time,"HH:MM:SS")':u
               po_width          = po_width + 2.
    END CASE.
  
    IF hdr-text.hdr-type BEGINS "value":u THEN DO:
      hdr-text.hdr-type = TRIM(REPLACE(hdr-text.hdr-type,"value":u,"")).

      RUN alias_to_tbname (ENTRY(1,hdr-text.hdr-type,";":u),TRUE,
                           OUTPUT v_table).
      RUN adecomm/_y-schem.p (v_table,?,?,OUTPUT v_scrap).

      ASSIGN
        hdr-text.hdr-show = 'STRING('
                          + ENTRY(1,hdr-text.hdr-type,";":u)
                          + ',"'
                          + ENTRY(2,hdr-text.hdr-type,";":u)
                          + '")'
        hdr-text.hdr-type = "value":u
        po_width          = po_width 
                          - LENGTH(hdr-text.hdr-show,"RAW":u) + 2
        .
      ASSIGN 
        po_width          = po_width
                          + {aderes/s-size.i &type=INTEGER(ENTRY(1,v_scrap))
                                             &format=ENTRY(2,v_scrap,CHR(10))}
                            NO-ERROR
        .
    END.

    /* found 'empty' or non-standard function, so display as text after we've
       setup pointer for next token */
    IF hdr-text.hdr-show = "" THEN
      ASSIGN
        hdr-text.hdr-show = hdr-text.hdr-type 
        hdr-text.hdr-type = "text-other":u
        .
  END. /* function */

  /* found text string */
  ELSE DO:
    ASSIGN
      hdr-text.hdr-type = "text":u
      hdr-text.hdr-show = IF del-left <> 0 THEN
          SUBSTRING(po_code,v_begin,del-left - v_begin,"CHARACTER":u)
        ELSE
          SUBSTRING(po_code,v_begin,-1,"CHARACTER":u)
      hdr-text.hdr-gap  = IF del-left <> 0 THEN 
          del-left - v_begin - LENGTH(TRIM(
          SUBSTRING(po_code,v_begin,del-left - v_begin,"CHARACTER":u)),
          "CHARACTER":u)
        ELSE 1.
  
    IF hdr-text.hdr-show = "" THEN
      hdr-text.hdr-gap = IF del-left <> 0 THEN del-left - v_begin ELSE 1.
  END.

  /* setup pointer for next token */
  IF hdr-text.hdr-type = "text":u THEN
    v_begin = IF del-left <> 0 THEN 
                (del-left) ELSE LENGTH(po_code,"CHARACTER":u) + 1.
  ELSE
    v_begin = IF del-right <> 0 THEN 
                (del-right + 1) ELSE LENGTH(po_code,"CHARACTER":u) + 1.
END. /* parse text strings and functions */

/* reassemble 4GL code */
FIND LAST hdr-text.
ASSIGN
  v_token = hdr-text.hdr-seq
  po_code = "".

FOR EACH hdr-text
  BREAK BY hdr-text.hdr-seq:
  IF hdr-text.hdr-seq = 0 AND hdr-text.hdr-gap > 0 THEN DO:
    /* The SPACE function is illegal at this point. Make any extra
     * spaces the hard way.  */
    po_code = "~"" + FILL(" ":u,hdr-text.hdr-gap) + "~"".

    NEXT.
  END.

  IF hdr-text.hdr-show = "" THEN
    hdr-text.hdr-show = "|":u + FILL(CHR(32),hdr-text.hdr-gap) + "|":u.

  po_code = po_code
          + (IF hdr-text.hdr-seq > 0 THEN ' ' ELSE '')
          + (IF hdr-text.hdr-type BEGINS "text"
              AND hdr-text.hdr-show > "" THEN '"' ELSE '')
          + (IF hdr-text.hdr-type BEGINS "text" THEN
              REPLACE(REPLACE(hdr-text.hdr-show, "~"", "~~~""), "|", "")
              ELSE TRIM(hdr-text.hdr-show))
          + (IF hdr-text.hdr-type BEGINS "text"
              AND hdr-text.hdr-show > "" THEN '"' ELSE '').

  IF hdr-text.hdr-seq  > 0 AND hdr-text.hdr-seq <> v_token THEN
    po_code = po_code + (IF LAST(hdr-text.hdr-seq) THEN "" ELSE " +").
END.

RETURN.

/*--------------------------------------------------------------------------*/

/* select the delimiters.  we allow { }, < >, ( ) and [ ] */
/* the default is taken from results.l file: qbf-left & qbf-right */

PROCEDURE find_delims:
  DEFINE INPUT  PARAMETER pi_header AS CHARACTER NO-UNDO. /* header text */
  DEFINE OUTPUT PARAMETER po_left   AS CHARACTER NO-UNDO. /* left delim */
  DEFINE OUTPUT PARAMETER po_right  AS CHARACTER NO-UNDO. /* right delim */

  DEFINE VARIABLE v_loop  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE v_match AS CHARACTER NO-UNDO.

  DO v_loop = 1 TO 8:
    v_match = ENTRY(v_loop,"PAGE,DATE,TODAY,COUNT,USER,NOW,TIME,VALUE*":u).
    IF pi_header MATCHES "*":u + qbf-left + v_match + qbf-right + "*":u THEN
      ASSIGN po_left  = qbf-left po_right = qbf-right.
    ELSE IF pi_header MATCHES "*~{":u + v_match + "~}*":u THEN
      ASSIGN po_left = "~{":u po_right = "~}":u.
    ELSE IF pi_header MATCHES "*<":u + v_match + ">*":u THEN
      ASSIGN po_left = "<":u po_right = ">":u.
    ELSE IF pi_header MATCHES "*(":u + v_match + ")*":u THEN
      ASSIGN po_left = "(":u po_right = ")":u.
    ELSE IF pi_header MATCHES "*[":u + v_match + "]*":u THEN
      ASSIGN po_left = "[":u po_right = "]":u.
  END.
  IF po_left = "" THEN
    ASSIGN
      po_left = qbf-left
      po_right = qbf-right.
END PROCEDURE. /* find_delims */

/*--------------------------------------------------------------------------*/

/* alias_to_tbname */
{ aderes/s-alias.i }

/* c-header.p - end of file */

