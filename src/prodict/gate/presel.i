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

/*--------------------------------------------------------------------

File: prodict/gate/presel.i

Description:
    
    extracts initial-values for name,owner, type and qualifier out of
    user_env[25], and, if user_env[25] not begins with "AUTO", calls 
    the dialog-box-program for the preselection-criterias.
            
Text-Parameters:
    &block     label of block to leave if canceled or no obj found  
    &frame     name of preselection-frame ("frm_ntoq" or "frm_nto")

    
Included in:
    odb/_odb_get.p
    ora/_ora_lk1.p
    ora/ora_get.i
    syb/syb_getp.i
    
History:
    hutegger    94/07/29    creation
    mcmann      05/21/2002  Added new input-output parameter
    
--------------------------------------------------------------------*/        
/*h-*/

if NUM-ENTRIES(user_env[25]) = 5
 then assign
  s_name  = ENTRY(2,user_env[25])
  s_owner = ENTRY(3,user_env[25])
  s_type  = ENTRY(4,user_env[25])
  s_qual  = ENTRY(5,user_env[25]).
else if user_dbtype <> "ORACLE"
 then assign /* oracle-routine inits these values by itself */
  s_name  = "*"
  s_owner = "*"
  s_type  = "*"
  s_qual  = "*".

assign
  s_vrfy  = (user_env[25] begins "COMPARE"
          or user_env[25] begins "auto-compare").

if NOT user_env[25] begins "AUTO"
 then do:  /* allow user to update preselection-citerias */
   
  RUN prodict/user/_usr_gsl.p
    ( INPUT-OUTPUT s_name,
      INPUT-OUTPUT s_owner,
      INPUT-OUTPUT s_qual,
      INPUT-OUTPUT s_type,
      INPUT-OUTPUT s_vrfy,
      INPUT-OUTPUT s_outf,
      INPUT-OUTPUT s_wildcard,
      INPUT        "{&frame}",
      INPUT        {&link},
      INPUT        {&master}
      
    ).

  IF RETURN-VALUE = "cancel"
   then do:
    &IF "{&block}" <> ""
     &THEN
      assign l_rep-presel = FALSE.
     &ENDIF
    assign user_path = "".
    LEAVE {&block}.
    end.

  end.     /* allow user to update preselection-citerias */


/*------------------------------------------------------------------*/        
