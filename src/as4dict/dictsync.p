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

/*-------------------------------------------------------------------------

File: dictsync.p

Description:
   This is the startup program for syncing and verifying AS400 schema 
   from the PROGRESS/400 Data Dictionary. 
   
Author: Donna L. McMann

Date Created: 06/17/96 to run sync and verify process from 
                       PROGRESS/400 Data Dictionary
              09/12/96 Added cursor wait to native sync.
              09/25/97 Added selective sync to options.
              10/07/98 Removed help text and added context help info
                       since formal help is now available.

--------------------------------------------------------------------------*/
{ adecomm/adestds.i }
{ as4dict/dictvar.i shared }
DEFINE VARIABLE sel_sync AS INTEGER INITIAL 1 
  view-as radio-set horizontal radio-buttons "Selective", 1,
                                  "Full", 2.
DEFINE VARIABLE native_flg AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE verify_flg AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE BUTTON btn_Ok          LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_Cancel      LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_help        LABEL "Help"   {&STDPH_OKBTN} AUTO-GO.



SESSION:IMMEDIATE-DISPLAY = TRUE.

FORM
  SKIP ({&VM_WIDG})
  "  Select which options you wish to perform.  " SKIP ({&VM_WIDG})
 space(5) "Synchronize Client Schema Holder:  " view-as text SKIP
   space (10) sel_sync no-label
	 SKIP({&VM_WIDG})
 native_flg VIEW-AS TOGGLE-BOX LABEL "Sync AS/400 Native 4GL Schema Image "
	COLON 6 SKIP({&VM_WIDG})   
 verify_flg VIEW-AS TOGGLE-BOX LABEL "Verify Server Schema to AS/400 Objects" 
	COLON 6 SPACE (6) SKIP({&VM_WIDG})
  btn_ok AT 12 btn_cancel SPACE({&HM_BTN}) btn_help SPACE({&HM_BTN})
  SKIP({&VM_WIDG})
  WITH FRAME sync-client
  SIDE-LABELS NO-ATTR-SPACE CENTERED THREE-D
  VIEW-AS DIALOG-BOX TITLE "  Synchronization Options ".	

/***************************Trigger for Help************************/  
ON CHOOSE OF Btn_Help IN FRAME sync-client DO:
  RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Synch_Options_Dlg_Box}, ?).
  RETURN NO-APPLY.
END.  

FIND FIRST as4dict.p__Db NO-LOCK.
IF SUBSTRING(as4dict.p__Db._Db-misc2[3],1,1) = "Y" THEN DO:
  ASSIGN native_flg = true.
  UPDATE sel_sync native_flg verify_flg btn_OK btn_Cancel btn_help
    WITH FRAME sync-client.
END.    
ELSE
  UPDATE sel_sync verify_flg btn_OK btn_Cancel btn_help
    WITH FRAME sync-client.

DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE : 
  /* This stops an alert-box for part 2 being displayed */   
  ASSIGN user_env[34] = "as4dict".
  IF sel_Sync = 1 THEN DO:
    RUN "as4dict/_selsync.p".
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
  ELSE DO:
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
END.

/* If an error occurs for synching native 4gl client, the message will
   be displayed via _dbamsgs.p.  The errors can be either incorrect
   authority or failure.
*/                                                                                                                                         
IF native_flg THEN DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE: 
   run adecomm/_setcurs.p ("WAIT").
    ASSIGN dba_cmd = "SYNSCHIMG".     
    RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).   
   run adecomm/_setcurs.p ("").
END.

IF verify_flg THEN DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  RUN as4dict/as4_vrfy.p.
END.    

 
RETURN.




