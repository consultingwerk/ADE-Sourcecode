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

/*------------------------------------------------------------------------ -

File: _as4sync.p

Description:
   This is the startup program for syncing and verifying AS400 schema 
   from the Data Admin or Data Dictionary Tool. 
   
Author: Donna L. McMann

Date Created: 09/22/97
                                                           
--------------------------------------------------------------------------*/
{ adecomm/adestds.i }
{ prodict/user/uservar.i }

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  DEFINE BUTTON    btn_Help LABEL "&Help" {&STDPH_OKBTN}.  
&ENDIF  


DEFINE VARIABLE sel_sync AS INTEGER INITIAL 1 
  view-as radio-set horizontal radio-buttons "Selective", 1,
                                  "Full", 2.
 
DEFINE VARIABLE verify_flg AS LOGICAL INITIAL NO  NO-UNDO.

SESSION:IMMEDIATE-DISPLAY = TRUE.

FORM
  SKIP ({&VM_WIDG})
 "  Select which options you wish to perform.  " SKIP ({&VM_WIDG})
 space(5) "Synchronize Client Schema Holder:  " view-as text SKIP
   space (10) sel_sync no-label
         SKIP({&VM_WIDG})   
 verify_flg VIEW-AS TOGGLE-BOX LABEL "Verify Server Schema to AS/400 Objects" 
        COLON 4 SPACE (6) SKIP({&VM_WIDG})
  btn_ok AT 12 btn_cancel SPACE({&HM_BTN}) btn_help SPACE({&HM_BTN})
  SKIP({&VM_WIDG})
  WITH FRAME sync-client
  SIDE-LABELS NO-ATTR-SPACE CENTERED THREE-D
  VIEW-AS DIALOG-BOX TITLE " Synchronization Options ".        

/***************************Trigger for Help************************/  
/* No formal help available so put message here*/
ON CHOOSE OF Btn_Help IN FRAME sync-client DO:
  MESSAGE "The listed options perform the following actions:"  SKIP (1)
          "Synchronization type " SKIP 
          "        Select which files to synchronize or " SKIP
          "        check all files for synchronization" SKIP (1)
          "Verify the server schema with the physical objects on the AS/400." SKIP (1)
          VIEW-AS ALERT-BOX BUTTONS OK TITLE "Synchronization Options Help ".
   RETURN NO-APPLY.       
END.
FIND _Db WHERE _Db._Db-name = ldbname("DICTDBG").

IF _Db._Db-misc1[8] <> 7 THEN DO:
     MESSAGE "This utility can only be used against a V7 Server."
        VIEW-AS ALERT-BOX ERROR BUTTON OK.
      ASSIGN user_path = "".
 END.

CREATE ALIAS as4dict FOR DATABASE VALUE(_Db._Db-name).    
            
 UPDATE sel_sync verify_flg btn_OK btn_Cancel btn_help
    WITH FRAME sync-client.

IF sel_sync = 2  THEN DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE : 
  /* This stops an alert-box for part 2 being displayed */   
  ASSIGN user_env[34] = "as4dict". 
  RUN "as4dict/as4_sync.p".
  IF RETURN-VALUE = "error" THEN DO:
     MESSAGE "Synchronization terminated." SKIP
             "Backing out information" SKIP
        VIEW-AS ALERT-BOX INFORMATION BUTTON OK.      
        UNDO, RETURN.
  END.     
  ELSE IF RETURN-VALUE <> "insync" THEN 
    MESSAGE "Synchronization" SKIP
        "      Complete     " VIEW-AS ALERT-BOX INFORMATION BUTTON OK.   
  ASSIGN user_env[34] = "".            
END.
                                                                                                                  
else IF sel_sync = 1  THEN DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE: 
   run adecomm/_setcurs.p ("WAIT").    
    RUN as4dict/_selsync.p .   
   run adecomm/_setcurs.p ("").
END.

IF verify_flg THEN DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  RUN as4dict/as4_vrfy.p.
END.    

 
RETURN.


