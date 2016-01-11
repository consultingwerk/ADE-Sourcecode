/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-alert2.p - alert box routine */

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

 NOTE/WARNING: 
       The input-output is not following ABL MESSAGE statement standard  
       CANCEL is returned as ? also when there are only 2 buttons 
              
pi_butn is the type of button(s) to use.
pio_ans is the initial value and also the result.
  pi_butn = "YES-NO"        -> pio_ans = TRUE/FALSE
  pi_butn = "YES-NO-CANCEL" -> pio_ans = TRUE/FALSE/?
  pi_butn = "OK"            -> pio_ans = TRUE
  pi_butn = "OK-CANCEL"     -> pio_ans = TRUE/?
  pi_butn = "RETRY-CANCEL"  -> pio_ans = TRUE/?

End-error handling:
  If there is a "CANCEL" button, then the result will be as if the user
  pressed the "CANCEL" button.  If there is NO "CANCEL" button but
  there is a "NO" button, then the result will be as if the user
  pressed the "NO" button.  If there is only the "OK" button, then the
  result will be as if the user selected the "OK" button.
---  
      
 
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

if pi_type matches "e*":U then
    pi_type = "ERROR":U.
else if pi_type matches "i*":U then
   pi_type = "INFORMATION":U.
else if pi_type matches "m*":U then
   pi_Type = "MESSAGE":U.
else if pi_type matches "q*":U then
   pi_Type = "QUESTION".
else if pi_type matches "w*":U then
   pi_Type = "WARNING".
else pi_Type = "MESSAGE".
     
&if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN       
    if OEIDE_CanShowMessage() then
    do:                           
        pio_ans = ShowMessageInIDE(v_text,pi_Type,?,pi_butn,pio_ans).
    end.
    else do:     
&endif

        run adecomm/_showmessage.p(v_text,pi_type,?,pi_butn,?,input-output pio_ans). 

&if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN       
    end. /* else */
&endif
 
/* proper end-error handling of return value. */
IF NOT pio_ans AND NUM-ENTRIES(pi_butn,"-":u) = 2 THEN
  pio_ans = (IF pi_butn MATCHES "*-CANCEL":u THEN ? ELSE pi_butn <> "YES-NO":u).

RETURN.

/* s-alert.p - end of file */
