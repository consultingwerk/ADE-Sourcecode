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

File: _as4dict.p

Description:
   This is the startup program for the AS400 dictionary.
   Adapted from _dict.p.  It will create the initial alias
   for the working AS400 database.
   
Author: Donna L. McMann

Date Created: 12/27/94
    Modified: 09/26/96 D. McMann changed to remove all references to any
                       schema files.  DO NOT REFERENCE ANY SCHEMA INFO
                       because the Progress/400 Data Dictionary will not
                       reset the schema cache if any reference is open.
              05/14/98 D. McMann removed V7 from the connect message 
              06/05/98 D. McMann Added check for _dbtype.         

----------------------------------------------------------------------------*/                       
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE NEW SHARED VARIABLE assgndb AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE savcurwin AS WIDGET-HANDLE. 
DEFINE VARIABLE savestate AS integer NO-UNDO.

 Define  shared menu mnu_Admin_Tool
   MENUBAR  .                   
 
  IF user_dbtype <> "AS400" THEN DO:
      MESSAGE "You tried to perform some AS/400 operation on a" 
               user_dbtype "database" skip
      VIEW-AS ALERT-BOX BUTTONS OK.
   RETURN.
 end.   

 
 run as4dict/setalias.p.     /* create alias */

IF assgndb THEN DO:   
   /* Inactive menu bar so user can't close dictionary and work here */      
    menu mnu_Admin_Tool:sensitive = no.   
     ASSIGN savcurwin = CURRENT-WINDOW
                      savestate = CURRENT-WINDOW:WINDOW-STATE.
                      
    run as4dict/_dictg.p.       
    
    ASSIGN CURRENT-WINDOW = savcurwin
                     CURRENT-WINDOW:WINDOW-STATE = savestate.    
   
   /* Now reactive menubar */
    menu mnu_Admin_Tool:sensitive = yes .
    run adecomm/_setcurs.p ("").                                   
    
  run as4dict/setalias.p.   /* delete alias and reset admin win db */
END.
ELSE DO:
  MESSAGE "A DB2/400 Database must be connected in order to do maintenance"
     VIEW-AS ALERT-BOX ERROR BUTTON OK.
  RETURN.
END.  


