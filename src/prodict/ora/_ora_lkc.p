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

File: prodict/ora/_ora_lkc.p   THIS ROUTINE GETS CALLED ONCE PER LINK!

Description:
    CONNECTs to s_ldbname and sets alias DICTDBG
    
Input-Parameters:  
   none
                                     
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    DICTDBG     alias gets reset for all selected links
History:
    hutegger    94/10/18    creation
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
&UNDEFINE DATASERVER

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/


SESSION:IMMEDIATE-DISPLAY = yes.
RUN adecomm/_setcurs.p ("WAIT").


if s_level > 0
 then do:  /* only if s_ttb_link is for linked db */

/** / message "_ora_lkc.p: set alias DICTDBG to" s_ldbname
/**/     view-as alert-box.
/ **/
  if not connected(s_ldbname)
   then connect value(s_ldbconct).

  run prodict/ora/_ora_als.p        /* create alias */
    ( INPUT s_ldbname
    ).

  end.     /* only if s_ttb_link is for linked db */

else if LDBNAME("DICTDBG") <> user_dbname
 then do:  /* use normal _db for local-db; set alias only if needed */
  
/** / message "_ora_lkc.p: set alias DICTDBG to" user_dbname
/**/     view-as alert-box.
/ **/
  if not connected(user_dbname)
   then connect value(user_dbname). /* should always be no-op */

  run prodict/ora/_ora_als.p        /* create alias */
    ( INPUT user_dbname
    ).

  end.     /* use normal _db for local-db; set alias only if needed */

/** /
 else message "DICTDBG already set to" user_dbname view-as alert-box.
/ **/
  
/*------------------------------------------------------------------*/
