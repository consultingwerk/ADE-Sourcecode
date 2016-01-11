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

File: prodict/gate/nogatwrk.i

Description:
    
    if there is no gate-work available then there are no tables
    selectable for updating or creating a schemaholder, so we leave
            
Text-Parameters:
    &block     label of block to leave if canceled or no obj found  
    &clean-up  expression that holds db-type (external name)  
    &end       "end." if repeat for get-process started in _xxx_get.p
               "" otherwise

    
Included in:
    odb/_odb_get.p
    ora/_ora6get.p
    ora/_ora7get.p
    rdb/_rdb_get.p
    syb/syb_getp.i
    
History:
    hutegger    94/07/29    creation
    
--------------------------------------------------------------------*/        
/*h-*/

find first gate-work no-error. 

if not available gate-work
 then do:   /* there are no tables selectable */

  if SESSION:BATCH-MODE = false
   then message
        "There are no objects in the " edbtyp " database that" skip
        "satisfy the selected criteria."                       skip
        "(Remember: some data sources are case sensitive.)"    skip(1)
        "Reenter preselection criteria?"     
        view-as alert-box information buttons yes-no update l_rep-presel.
   else assign l_rep-presel = FALSE.

  if l_rep-presel = FALSE
   then do:
    assign user_path = "{&clean-up}".
    RUN adecomm/_setcurs.p ("").
    LEAVE {&block}.
    end.
  
  end.      /* there have been triggers effected */

 else assign l_rep-presel = FALSE.

  {&end}  /* for the repeat in the _get.p routines */

find first gate-work no-error. 

if not available gate-work
 then leave.

/*------------------------------------------------------------------*/        
