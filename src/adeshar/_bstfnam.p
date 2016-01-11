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
/*----------------------------------------------------------------------------

File: _bstfnam.p

Description: Checks if a name of a Data Object Field is OK (i.e. not already used by another field.  If it is, then we convert it to a better name that will work.
  
NOTE that we only work with SmartData columns!! 

    This file uses the same logic as _bstname.p but differs from it because it checks the SmartData fields vs widgets.
    Note that the check is only made within a SmartData and does not go across widgests.

Input Parameters:
   p_recid : Recid of the _U record (QUERY or BROWSE)
   p_test  : The name to start testing.
   p_base  : The base name to use for a new name.

Output Parameters:
   p_best  : the best name - p_best = p_test if the name is valid; otherwise
             it is a new best name.

Author: SLK
Date Created: Jan 1998   
Copied from _bstname.p

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_recid   AS RECID                NO-UNDO.
DEFINE INPUT  PARAMETER p_test   AS CHAR                NO-UNDO.
DEFINE INPUT  PARAMETER p_seq	 AS INTEGER		NO-UNDO.
DEFINE INPUT  PARAMETER p_base   AS CHAR                NO-UNDO.
DEFINE OUTPUT PARAMETER p_best   AS CHAR                NO-UNDO.

{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/brwscols.i}              /* Universal widget definition              */

DEFINE VARIABLE cBar      AS CHAR    NO-UNDO.
DEFINE VARIABLE ch        AS CHAR    NO-UNDO.
DEFINE VARIABLE i         AS INTEGER NO-UNDO.
DEFINE VARIABLE icnt      AS INTEGER NO-UNDO.
DEFINE VARIABLE lngth     AS INTEGER NO-UNDO.

DEFINE VARIABLE givenOK AS LOGICAL NO-UNDO.
DEFINE VARIABLE isSmartData AS LOGICAL NO-UNDO.

/* Emergency tests: Check for UNKNOWN test cases or type.  Fix those. */
IF p_test eq ? THEN p_test = "".

FIND FIRST _U WHERE _U._TYPE = "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U
                AND RECID(_U) = p_recid 
                AND _U._STATUS ne "DELETED"
	 NO-ERROR.
IF AVAILABLE _U THEN DO:
    FIND FIRST _BC WHERE _BC._x-recid = RECID(_U)
		       AND _BC._DISP-NAME eq p_test 
		       AND _BC._SEQUENCE <> p_seq NO-ERROR.
    IF NOT AVAILABLE _BC THEN givenOK = TRUE.
    ELSE givenOK = FALSE.
END.
ELSE ASSIGN givenOK = TRUE.

IF givenOK THEN ASSIGN p_best = p_test.
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

  DO WHILE AVAILABLE _BC:
    ASSIGN icnt = icnt + 1
           ch = TRIM(STRING(icnt)).
    /* Worry about a really long name exceeding 32 characters */
    IF LENGTH(p_base,"RAW":u) + 1 + LENGTH(ch,"RAW":u) > 32
    THEN p_base = SUBSTRING(p_base,1,31 - LENGTH(ch,"RAW":u),"FIXED":u).
    p_best = p_base + cBar + ch.
      FIND FIRST _BC WHERE _BC._x-recid = RECID(_U)
		       AND _BC._DISP-NAME eq p_best NO-ERROR.
  END.
END.
/* _bstfnam.p - end of file */
