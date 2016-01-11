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
/* --------------------------------------------------------------------

File: prodict/ora/_ora_vts.p

Description:
    This procedure verifys the tablespace names entered during protoora for
    where to place the files and indexes.
    
Input:
    none
    
Output:
    none
    
History:
     created 03/16/98 D. McMann
     
*/

{ prodict/ora/oravar.i }
{ prodict/user/uservar.i }

DEFINE SHARED VARIABLE l_closelog  AS logical   NO-UNDO.

IF user_env[34] <> ? and user_env[34] <> "" THEN DO:
   FIND DICTDBG.oracle_tablespace where DICTDBG.oracle_tablespace.name = user_env[34]
                                    and DICTDBG.oracle_tablespace.online$ = 1
                                    NO-LOCK NO-ERROR.
   /* If available then check to see if userid is owner if not check for security */   
   IF AVAILABLE DICTDBG.oracle_tablespace THEN DO:
     
         /* here is where code checks to see if user can use tablespace */
       
   END.
   ELSE DO:
  
     IF not logfile_open THEN DO:
        output stream logfile to value(user_env[2] + ".log") 
               unbuffered no-map no-echo append. 
        assign l_closelog   = true
               logfile_open = true. 
      END.

      PUT STREAM logfile UNFORMATTED 
           " " skip 
           "-- ++ " skip
           "   Tablespace " user_env[34] " could not be found." skip
           "   Load of SQL not performed." SKIP
           "-- -- " skip(2).
      ASSIGN movedata = false.
      RETURN "1".
   END.
END.

IF user_env[35] <> ? and user_env[35] <> "" THEN DO:
   FIND DICTDBG.oracle_tablespace where DICTDBG.oracle_tablespace.name = user_env[35]
                                    and DICTDBG.oracle_tablespace.online$ = 1
                                    NO-LOCK NO-ERROR.
   /* If available then check to see if userid is owner if not check for security */   
   IF AVAILABLE DICTDBG.oracle_tablespace THEN DO:
     
         /* here is where code checks to see if user can use tablespace */
      
   END.
   ELSE DO:
     IF not logfile_open THEN DO:
        output stream logfile to value(user_env[2] + ".log") 
               unbuffered no-map no-echo append. 
        assign l_closelog   = true
               logfile_open = true. 
      END.

      PUT STREAM logfile UNFORMATTED 
           " " skip 
           "-- ++ " skip
           "-- Tablespace " user_env[35] " could not be found." skip
           "-- Load of SQL not performed." SKIP
           "-- -- " skip(2).
      ASSIGN movedata = false.     
      RETURN "1".
   END.
END.                                             
