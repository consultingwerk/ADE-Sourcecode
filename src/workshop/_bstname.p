/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _bstname.p

Description:
    Checks if a name of a wiget is OK (i.e. not used by another widget in the
    window.  If it is, then we convert it to a better name that will work.
    
    This file differs from _ok_name.p in the following ways:
      1) It always returns a good name
      2) It never reports an error
      3) It always gets a unique name. That is, it is unconcerned about
         the case of two variables in different frames with the same data-type
         (which can have the same name).  It always assumes a different variable.

Input Parameters:
   p_test  : The name to start testing.
   p_base  : The base name to use for a new name.
   p_proc-id: The procedure where this is defined

Output Parameters:
   p_best  : the best name - p_best = p_test if the name is valid; otherwise
             it is a new best name.

Author: Wm.T.Wood

Date Created: June 25, 1993   

Modified:
  wood 7/10/95 - Support "_" as seperator between base name and number.  
  wood 2/07/98 - Modified for 2mars to pass in the _P recid, and not the 
                 _h_win (also moved from adeshar to workshop).  Also
                 removed the p_type and p_index parameters

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_test    AS CHAR               NO-UNDO.
DEFINE INPUT  PARAMETER p_base    AS CHAR               NO-UNDO.
DEFINE INPUT  PARAMETER p_proc-id AS INTEGER            NO-UNDO.

DEFINE OUTPUT PARAMETER p_best   AS CHAR                NO-UNDO.

{ workshop/uniwidg.i }          /* Universal widget definition              */
{ workshop/sharvars.i }         /* Standard shared variables                */

DEFINE VARIABLE cBar      AS CHAR    NO-UNDO.
DEFINE VARIABLE ch        AS CHAR    NO-UNDO.
DEFINE VARIABLE i         AS INTEGER NO-UNDO.
DEFINE VARIABLE icnt      AS INTEGER NO-UNDO.
DEFINE VARIABLE lngth     AS INTEGER NO-UNDO.

/* Emergency tests: Check for UNKNOWN test cases or type.  Fix those. */
IF p_test eq ? THEN p_test = "".

/* Is there another widget in this window of any type that has this name? */
/* If there isn't then we have a winner.  Just return it.                 */
FIND FIRST _U WHERE _U._NAME eq p_test
                AND _U._P-recid eq p_proc-id
                AND _U._STATUS ne "DELETED":U
              USE-INDEX _NAME
              NO-ERROR.
IF NOT AVAILABLE _U THEN p_best = p_test.
ELSE DO:
  /* Now we have a problem.  Find a new good variable name. We do this
     by creating names of the form "p_base" + STRING(icnt) and we keep 
     incrementing icnt until we have a good name.  We start icnt at 1. */
  IF p_base NE ? THEN icnt = 1.
  ELSE DO:
    /* For the case of p_base unknown, break p_test into a base and a icnt. */
    ASSIGN p_base = p_test 
           lngth  = LENGTH(p_base,"CHARACTER":u)
           i      = lngth.
    DO WHILE i > 0 
      AND INDEX("0123456789":u,SUBSTRING(p_base,i,1,"CHARACTER":u)) ne 0:
      i = i - 1.
    END.
    /* The i eq 0 should never occur.  That means that p_test is a number by
       itself with no leading characters which should be invalid. */
    IF i = 0 
    THEN ASSIGN p_base = "OBJECT"
                icnt   = 1.
    ELSE ASSIGN ch     = SUBSTRING(p_base,i + 1,-1,"CHARACTER":u)
                icnt   = IF ch eq "" THEN 1 ELSE INTEGER(ch)
                p_base = SUBSTRING(p_base,1,i,"CHARACTER":u).
  END.
  
  /* Now remove any "_" or "-" from the trailing end of p_base.  Use
     either "-" or "_" as the seperation bar between the base name and
     the added number. (That is "b_1" will generate names of the form
     "b_2" etc., while "btn-1" will generate "btn-2". */
  ASSIGN lngth = LENGTH(p_base, "CHARACTER":u)
         ch    = SUBSTRING(p_base, lngth, 1, "CHARACTER":u).
  IF INDEX("_-", ch) ne 0 
  THEN ASSIGN p_base = SUBSTRING(p_base,1,lngth - 1,"CHARACTER":u)
              cBar   = ch. 
  ELSE ASSIGN cBar   = "-":U.
  
  DO WHILE AVAILABLE _U:
    ASSIGN icnt = icnt + 1
           ch = TRIM(STRING(icnt)).
    /* Worry about a really long name exceeding 32 characters */
    IF LENGTH(p_base,"RAW":u) + 1 + LENGTH(ch,"RAW":u) > 32
    THEN p_base = SUBSTRING(p_base,1,31 - LENGTH(ch,"RAW":u),"FIXED":u).
    p_best = p_base + cBar + ch.
    FIND FIRST _U WHERE _U._NAME eq p_best
                    AND _U._P-recid eq p_proc-id
                    AND _U._STATUS ne "DELETED" 
                  USE-INDEX _NAME NO-ERROR.
  END.

END.

/* _bstname.p - end of file */
