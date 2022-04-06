/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/ora/_ora_lkx.p

Description:
    clean-up by removing temporary db, and deleteing all
    temp-table records
    
Input-Parameters:  
    none
                                                
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    DICTDBG     alias for current link
    s_ldbname      logical name of the link-db (= physical name)
    s_ttb_link  local and distributed DBs
    gate-work   objects in DBs
    
History:
    hutegger    94/10/18    creation
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i }
&UNDEFINE DATASERVER

define variable  s_1st-error     as logical.

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/** / message "_ora_lkx.p" view-as alert-box. / **/

/* we use "z_ora_links instead of s_ldbname because s_ldb-name can be
 * the real db, and we don't want to disconnect this one
 */

if connected("z_ora_links")
 then disconnect value("z_ora_links") /*no-error*/.

for each s_ttb_link:
  delete s_ttb_link.
  end.
for each gate-work:
  delete gate-work.
  end.


find _Db where _Db._db-name = s_ldbname
  no-error.
if available _Db
 then do:
  for each _File OF _Db:
    { prodict/dump/loadkill.i }
    end.
  delete _Db.
  end.


RUN adecomm/_setcurs.p ("").
assign
  SESSION:IMMEDIATE-DISPLAY = no
  s_1st-error               = no.


/*------------------------------------------------------------------*/

