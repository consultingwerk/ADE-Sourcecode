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
   Procedure _a4dmpin.p Entry point for the incremental dump in the PROGRESS/400
                        Data Dictionary.  Called from menutrig.i when the user
                        selects Create Incrementad .DF file in the Admin menu.
                        
   Created:  D. McMann  06/05/97
   
*/                        
   

{ as4dict/dictvar.i SHARED }
{ as4dict/dump/dumpvar.i "NEW SHARED" }
{ as4dict/brwvar.i SHARED }
{ as4dict/dump/userpik.i NEW }

DEFINE NEW SHARED FRAME working.
{ as4dict/dump/as4dmpdf.f &FRAME = "working" }

DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE j AS INTEGER.

ASSIGN cache_db# = 0
       j = 1.

/* Setup shared variables for proceeding procedures */
DO i = 1 TO NUM-DBS:
  IF DBTYPE(i) = "AS400" THEN  
     ASSIGN cache_db# = j
            cache_db_t[j] = dbtype(i)    
            cache_db_l[j] = pdbname(i)
            j = j + 1.    
END.  

ASSIGN user_dbtype = "AS400".
PAUSE 0 BEFORE-HIDE.
     
RUN as4dict/dump/_usrincr.p.

RETURN.
