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

File: _ins_cd.p

Description:
   This routine inserts a _code section into the Workshop's internal memory.
   This is more than just creating the _code record.  Because _code is stored
   in a double-link list, we must make sure the list stays consistent.
   
Notes:
   This routine does not actually add the code text. That must be done seperately.
   It only creates the _code record.

Input Parameters:
   p_prev-id -  Recid of _code block that precedes this new one. (or ? if this
                is to be the first code section.
   p_p-recid -  Recid of the associated procedure file (if ? then this will be taken
                from the previous code block. 
   p_l-recid -  Recid of the associated object (if ? then this will be set to p_p-recid).
   p_section - Section for the code (e.g. "_PROCEDURE", "_WORKSHOP")
   p_special - Special handler for the section (eg. _WEB-ASSOCIATE, mydir/mycde.p) 
               This can be "" if there is no special handler.
   p_name    - Name of the section

Output Parameters:
   p_code-id - Recid of the newly created code block (or ? if the insertion failed)
       
Author: Wm. T. Wood 
Date Created: Feb. 8, 1997

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_prev-id AS RECID           NO-UNDO.
DEFINE INPUT  PARAMETER p_p-recid AS RECID           NO-UNDO.
DEFINE INPUT  PARAMETER p_l-recid AS RECID           NO-UNDO.
DEFINE INPUT  PARAMETER p_section AS CHAR            NO-UNDO.
DEFINE INPUT  PARAMETER p_special AS CHAR            NO-UNDO.
DEFINE INPUT  PARAMETER p_name    AS CHAR            NO-UNDO.
DEFINE OUTPUT PARAMETER p_code-id AS RECID INITIAL ? NO-UNDO.

/* Include files  ---                                             */
{ workshop/code.i }        /* Code Section TEMP-TABLE definition  */

/* Definitions ---                                                */
DEFINE VARIABLE cd-recid AS RECID NO-UNDO.

DEFINE BUFFER next_code FOR _code.
DEFINE BUFFER prev_code FOR _code.

/* Find the previous record, if available. */ 
IF p_prev-id ne ? THEN FIND prev_code WHERE RECID(prev_code) eq p_prev-id.

/* Check the values of the various input parameters. NOTE that it is a
   fatal error if both p_prev-id and p_p-recid and unknown. */
IF p_p-recid eq ? THEN p_p-recid = prev_code._P-recid.
IF p_l-recid eq ? THEN p_l-recid = p_p-recid. 
IF p_special eq ? THEN p_special = "":U.

/* Get the next record (which is the first record, if there is no previous one) */
IF NOT AVAILABLE prev_code
THEN DO:    
  /* Insert before the first code record. */
  RUN workshop/_find_cd.p (INTEGER(p_p-recid), "FIRST":U, "":U, OUTPUT cd-recid). 
  IF cd-recid ne ? THEN FIND next_code WHERE RECID(next_code) eq cd-recid.
END.
ELSE DO: 
  /* Insert before the previous record's "next" id. If the previous record
     was the last one, then there will be no next record. */   
  IF prev_code._next-id ne ?
  THEN FIND next_code WHERE RECID(next_code) eq prev_code._next-id NO-ERROR. 
END.

/* Now create the new record. */
CREATE _code.
ASSIGN     
  /* Set the various links. */
  _code._p-recid = p_p-recid
  _code._l-recid = p_l-recid
  /* Assign the other fields. */        
  _code._section = p_section
  _code._name    = p_name
  _code._special = p_special
  .

/* Link previous and next records. */
IF AVAILABLE prev_code
THEN ASSIGN prev_code._next-id = RECID(_code)
            _code._prev-id     = RECID(prev_code) .
IF AVAILABLE next_code
THEN ASSIGN next_code._prev-id = RECID(_code)
            _code._next-id     = RECID(next_code) .
            
/* Return the new code recid. */
p_code-id = RECID(_code).  
