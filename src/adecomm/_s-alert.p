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
/* s-alert.p - alert box routine */

/*
Input text comes in 'pi_text' parameter, and may be any length.
This program splits it up into 45-character chunks, breaking at
spaces.  Embedded '^' marks get translated into line-feeds (like
in column-labels).

pi_type the the type of alert box to use.
  pi_type = "e*" -> error
  pi_type = "i*" -> information
  pi_type = "m*" -> message
  pi_type = "q*" -> question
  pi_type = "w*" -> warning

pi_butn is the type of button(s) to use.
pio_ans is the initial value and also the result.
  pi_butn = "yes-no"        -> pio_ans = TRUE/FALSE
  pi_butn = "yes-no-cancel" -> pio_ans = TRUE/FALSE/?
  pi_butn = "ok"            -> pio_ans = TRUE
  pi_butn = "ok-cancel"     -> pio_ans = TRUE/?
  pi_butn = "retry-cancel"  -> pio_ans = TRUE/?

End-error handling:
  If there is a "cancel" button, then the result will be as if the user
  pressed the "cancel" button.  If there is no "cancel" button but
  there is a "no" button, then the result will be as if the user
  pressed the "no" button.  If there is only the "ok" button, then the
  result will be as if the user selected the "ok" button.
*/

DEFINE INPUT-OUTPUT PARAMETER pio_ans AS LOGICAL   NO-UNDO. /* value */
DEFINE INPUT        PARAMETER pi_type AS CHARACTER NO-UNDO. /* alert type */
DEFINE INPUT        PARAMETER pi_butn AS CHARACTER NO-UNDO. /* buttons */
DEFINE INPUT        PARAMETER pi_text AS CHARACTER NO-UNDO. /* text */

DEFINE VARIABLE v_text AS CHARACTER NO-UNDO. /* word-wrapped text */

/*****************************************************************/
/************ New parser written by Alex *************************/
&SCOPED-DEFINE dh-limit 16
&SCOPED-DEFINE dw-limit 45

DEF VAR cChunk AS CHAR EXTENT {&dh-limit} NO-UNDO.
DEF VAR I      AS INT                     NO-UNDO.  
DEF VAR K      AS INT                     NO-UNDO.  
DEF VAR lOK    AS LOG                     NO-UNDO.  
DEF VAR lOver  AS LOG INIT NO             NO-UNDO.  
DEF VAR cTemp  AS CHAR                    NO-UNDO.  

/*****************************************************************/
/* this proc shifts text chunks up to make space for a new chunk */
PROCEDURE shift:
DEF INPUT PARAM iStart AS INT NO-UNDO.
DEF VAR J              AS INT NO-UNDO.

IF iStart > {&dh-limit} - 1 OR iStart < 2 THEN RETURN.
IF cChunk[{&dh-limit}] <> "" THEN lOver = YES.

REPEAT J = {&dh-limit} TO iStart + 1 BY -1: ASSIGN cChunk[J] = cChunk[J - 1]. END.

cChunk[iStart] = "".
END PROCEDURE.
/*****************************************************************/

Zakorjuchka:
REPEAT I = 1 TO {&dh-limit}:
IF INDEX(pi_text,"^":u) > 0 THEN 
  ASSIGN cChunk[I] = SUBSTRING(pi_text, 1, INDEX(pi_text,"^":u) - 1)
         pi_text   = SUBSTRING(pi_text, INDEX(pi_text,"^":u) + 1).
ELSE
  DO:
  ASSIGN cChunk[I] = pi_text. LEAVE Zakorjuchka.
  END.
END.

ASSIGN lOK = NO.
DO WHILE NOT lOK:
ASSIGN lOK = YES.
 REPEAT I = {&dh-limit} TO 1 BY -1: 
 IF LENGTH(cChunk[I]) < {&dw-limit} + 1 THEN NEXT.                       
 RUN shift(INPUT I + 1).                                       
 ASSIGN K = R-INDEX(cChunk[I], " ", {&dw-limit} + 1) lOK = NO.                   

 IF K = 0 THEN                                             
   ASSIGN cTemp         = SUBSTRING(cChunk[I], {&dw-limit} + 1)
          cChunk[I]     = SUBSTRING(cChunk[I], 1, {&dw-limit})      
          cChunk[I + 1] = cTemp.        
 ELSE                                                      
   ASSIGN cTemp         = SUBSTRING(cChunk[I], K + 1)
          cChunk[I]     = SUBSTRING(cChunk[I], 1, K - 1)   
          cChunk[I + 1] = cTemp.     
 END. /* repeat */
END. /* do while */

DO I = 1 TO {&dh-limit}: ASSIGN v_text = v_text + cChunk[I] + CHR(10). END.
ASSIGN v_text = TRIM(v_text, CHR(10)) + CHR(10) + IF lOver THEN "..." ELSE "".
/*****************************************************************/
/********************** End new parser ***************************/

/*****************************************************************/
/******************* Screen messaging part ***********************/
CASE SUBSTRING(pi_type,1,1,"CHARACTER":u) + "/":u + pi_butn:
  WHEN "e/yes-no":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS yes-no
      UPDATE pio_ans.
  WHEN "e/yes-no-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS yes-no-cancel
      UPDATE pio_ans.
  WHEN "e/ok":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS ok
      UPDATE pio_ans.
  WHEN "e/ok-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS ok-cancel
      UPDATE pio_ans.
  WHEN "e/retry-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS retry-cancel
      UPDATE pio_ans.
  WHEN "i/yes-no":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS yes-no
      UPDATE pio_ans.
  WHEN "i/yes-no-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS yes-no-cancel
      UPDATE pio_ans.
  WHEN "i/ok":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS ok
      UPDATE pio_ans.
  WHEN "i/ok-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS ok-cancel
      UPDATE pio_ans.
  WHEN "i/retry-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS retry-cancel
      UPDATE pio_ans.
  WHEN "m/yes-no":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS yes-no
      UPDATE pio_ans.
  WHEN "m/yes-no-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS yes-no-cancel
      UPDATE pio_ans.
  WHEN "m/ok":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS ok
      UPDATE pio_ans.
  WHEN "m/ok-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS ok-cancel
      UPDATE pio_ans.
  WHEN "m/retry-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS retry-cancel
      UPDATE pio_ans.
  WHEN "q/yes-no":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS yes-no
      UPDATE pio_ans.
  WHEN "q/yes-no-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS yes-no-cancel
      UPDATE pio_ans.
  WHEN "q/ok":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS ok
      UPDATE pio_ans.
  WHEN "q/ok-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS ok-cancel
      UPDATE pio_ans.
  WHEN "q/retry-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS retry-cancel
      UPDATE pio_ans.
  WHEN "w/yes-no":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS yes-no
      UPDATE pio_ans.
  WHEN "w/yes-no-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS yes-no-cancel
      UPDATE pio_ans.
  WHEN "w/ok":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS ok
      UPDATE pio_ans.
  WHEN "w/ok-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS ok-cancel
      UPDATE pio_ans.
  WHEN "w/retry-cancel":u THEN
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS retry-cancel
      UPDATE pio_ans.
END CASE.

/* proper end-error handling of return value. */
IF NOT pio_ans AND NUM-ENTRIES(pi_butn,"-":u) = 2 THEN
  pio_ans = (IF pi_butn MATCHES "*-cancel":u THEN ? ELSE pi_butn <> "yes-no":u).

RETURN.

/* s-alert.p - end of file */
