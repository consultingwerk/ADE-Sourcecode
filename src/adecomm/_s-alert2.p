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
  WHEN "e/YES-NO":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN       
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Error",?,"YES-NO",pio_ans).
    else
    &endif  
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS YES-NO
      UPDATE pio_ans.
  end.    
  WHEN "e/YES-NO-CANCEL":u THEN
  do: 
     &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Error",?,"YES-NO-CANCEL",pio_ans).
    else   
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS YES-NO-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "e/OK":u THEN
  do:
     &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Error",?,"OK",yes).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS OK
      UPDATE pio_ans.
  end.    
  WHEN "e/OK-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN  
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Error",?,"OK-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS OK-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "e/RETRY-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN  
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Error",?,"RETRY-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX error BUTTONS RETRY-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "i/YES-NO":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Information",?,"YES-NO",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS YES-NO
      UPDATE pio_ans.
  end.    
  WHEN "i/YES-NO-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Information",?,"YES-NO-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS YES-NO-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "i/OK":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Information",?,"OK",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS OK
      UPDATE pio_ans.
  end.    
  WHEN "i/OK-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Information",?,"OK-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS OK-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "i/RETRY-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Information",?,"RETRY-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX information BUTTONS RETRY-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "m/YES-NO":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Message",?,"YES-NO",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS YES-NO
      UPDATE pio_ans.
  end.    
  WHEN "m/YES-NO-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Message",?,"YES-NO-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS YES-NO-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "m/OK":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Message",?,"OK",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS OK
      UPDATE pio_ans.
  end.    
  WHEN "m/OK-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Message",?,"OK-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS OK-CANCEL
     UPDATE pio_ans.
  end.   
  WHEN "m/RETRY-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Message",?,"RETRY-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX message BUTTONS RETRY-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "q/YES-NO":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Question",?,"YES-NO",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS YES-NO
      UPDATE pio_ans.
  end.    
  WHEN "q/YES-NO-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Question",?,"YES-NO-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS YES-NO-CANCEL
      UPDATE pio_ans.
  end.   
  WHEN "q/OK":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Question",?,"OK",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS OK
      UPDATE pio_ans.
  end.    
  WHEN "q/OK-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Question",?,"OK-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS OK-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "q/RETRY-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Question",?,"RETRY-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX question BUTTONS RETRY-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "w/YES-NO":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Warning",?,"YES-NO",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS YES-NO
      UPDATE pio_ans.
  end.    
  WHEN "w/YES-NO-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Warning",?,"YES-NO-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS YES-NO-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "w/OK":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Warning",?,"OK",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS OK
      UPDATE pio_ans.
  end.    
  WHEN "w/OK-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Warning",?,"OK-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS OK-CANCEL
      UPDATE pio_ans.
  end.    
  WHEN "w/RETRY-CANCEL":u THEN
  do:
    &if DEFINED(IDE-IS-SUPPORTED) <> 0  &THEN   
    if OEIDE_CanShowMessage() then
       pio_ans = ShowMessageInIDE(v_text,"Warning",?,"RETRY-CANCEL",pio_ans).
    else  
    &endif
    MESSAGE v_text
      VIEW-AS ALERT-BOX warning BUTTONS RETRY-CANCEL
      UPDATE pio_ans.
  end.    
END CASE.

/* proper end-error handling of return value. */
IF NOT pio_ans AND NUM-ENTRIES(pi_butn,"-":u) = 2 THEN
  pio_ans = (IF pi_butn MATCHES "*-CANCEL":u THEN ? ELSE pi_butn <> "YES-NO":u).

RETURN.

/* s-alert.p - end of file */
