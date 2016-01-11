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

File: _vrferr.p

Description:
   Output to file of errors received during running of as4_vrfy.p.
 
 Created 5/18/95  D. McMann
 
 ------------------------------------------------------------------------------- */
 
 { prodict/user/uservar.i }
 { as4dict/usersho.i }
 
  DEFINE VARIABLE i AS INTEGER NO-UNDO.         
  DEFINE VARIABLE ttl AS CHARACTER FORMAT "x(30)" INITIAL
        "Listing of anomalies found on" NO-UNDO.
  
 FORM HEADER 
        SPACE (5)  ttl  TODAY SKIP (1)
        WITH FRAME hlist CENTERED NO-BOX NO-LABEL.
  
  FORM
    sho_pages[i] SKIP
    WITH FRAME lst CENTERED DOWN STREAM-IO NO-BOX NO-LABEL.
    
 OUTPUT TO VALUE(user_env[8]).            
 VIEW FRAME hlist.           

 DO i = 1 TO sho_limit WITH FRAME lst:   
    DISPLAY sho_pages[i] FORMAT "x(65)".
    DOWN.
  END.           

  OUTPUT CLOSE.   
 
    
         
 
