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
 File:_chgdbmd.p

Description:
    This procedure changes the mode the user is in depending on whether
    the read only indicator is on or off.  The s_DictDirty indicator is set if any
    updates have been made.  This indicator is checked to know if the commit
    action must be taken.
    
History:
     Created  03/23/95  D. McMann  
     Modified 03/25/96  D. McMann Changed QUESTION to WARNING in messages
              06/25/97  D. McMann Added allow_word_index for word index support
              08/14/97  D. McMann Added check for having more than word indexes
                        97-08-14-22   
              09/09/99  D. McMann cleared status line when going into modify.
              02/07/00  D. McMann Added chgpf check
              10/25/00  D. McMann Added allow_raw and allow_ench
              02/06/01  D. McMann Added check for changing mode in Data Admin
*/                                       
                                

{ as4dict/dictvar.i  shared }
{ as4dict/brwvar.i  shared }
 { as4dict/menu.i shared }



SESSION:IMMEDIATE-DISPLAY = TRUE.

DEFINE VARIABLE answer AS LOGICAL INITIAL FALSE NO-UNDO.     
DEFINE VARIABLE dbhold  AS CHARACTER NO-UNDO.


/*===========================Internal Procedures=========================*/

/*----------------------------------------------------------------
   See if the user made any changes in a property window 
   that he hasn't saved.  This (_changed.p) will ask if he wants 
   to save and do the save if he says yes. 

   Returns: "error" if an error occurs when the user tries to 
	    save, otherwise, "".
---------------------------------------------------------------*/
Procedure Check_For_Changes:

   Define var err as logical NO-UNDO.

   err = no.
   if s_win_Tbl <> ? then
      run as4dict/_changed.p (INPUT {&OBJ_TBL}, yes, OUTPUT err).
   if NOT err AND s_win_Seq <> ? then
      run as4dict/_changed.p (INPUT {&OBJ_SEQ}, yes, OUTPUT err).
   
   if NOT err AND s_win_Fld <> ? then
      run as4dict/_changed.p (INPUT {&OBJ_FLD}, yes, OUTPUT err).
   if NOT err AND s_win_Idx <> ? then
      run as4dict/_changed.p (INPUT {&OBJ_IDX}, yes, OUTPUT err).

   if err then 
      return "error".
   else
      return "".
End.
/*===========================  Main Line Code  ===========================*/   
/* This variable is set when entering the dictionary and if the user was in the middle
     of a transaction, we don't want them to do any maintenance */

IF s_InTran_ReadOnly THEN  DO:
  MESSAGE  "Since your are either in the middle of a transaction or the version"  
            "of PROGRESS only allows the Progress/400 dictionary to be in"  
            "read-only mode, you can not performance any maintenance."    
     VIEW-AS ALERT-BOX INFORMATION buttons OK.         
  ASSIGN s_mod_chg = "Read Only" 
         s_mod_chg:screen-value in frame browse = "Read Only"
         allow_word_idx = FALSE.    
  apply "back-tab" to s_mod_chg in frame browse.
END.             
ELSE IF s_ReadOnly   THEN DO:      
  ASSIGN dbhold = s_CurrDb + "?".
  IF user_env[33] <> "as4inc" AND user_env[33] <> "loaddf" THEN
    MESSAGE  "Selecting modify schema will place an exclusive lock on"  
             "the Progress/400 server schema.  This locks the schema for" 
             "all users until you commit the changes.  It is recommended " 
             "you save your current server schema and DB2/400 database"
             "before doing maintenance."  SKIP (1)
             "Are you sure you want to modify the Progress/400" 
             "server schema in library"  dbhold SKIP
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE answer. 
  ELSE
    MESSAGE  "Loading a definitions file will place an exclusive lock on"  
             "the Progress/400 server schema.  This locks the schema for" 
             "all users until you commit the changes.  It is recommended " 
             "you save your current server schema and DB2/400 database"
             "before doing maintenance."  SKIP (1)
             "Are you sure you want to modify the Progress/400" 
             "server schema in library"  dbhold SKIP
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE answer. 
  
  IF answer  THEN DO:   
    run adecomm/_setcurs.p ("WAIT").
    ASSIGN dba_cmd = "START".       
    RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).       
        
    IF dba_passed THEN  DO :
      IF dba_return = 1 THEN DO:
        ASSIGN s_ReadOnly = FALSE
               s_mod_chg = "Modify Schema"
               s_Browse_Stat = "". 
        IF user_env[33] <> "as4inc" AND user_env[33] <> "loaddf" THEN
          DISPLAY  s_Browse_Stat WITH frame BROWSE .        
         
        /* Check for server capabilities for word indexes, replications triggers 
           raw data type support, enhanced load capability and stored procedures */
        ASSIGN dba_cmd = "QRYSRVCAP".
        RUN as4dict/_dbaocmd.p (INPUT "ALWRPLTRG", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_rep_trig = TRUE.
        ELSE
          ASSIGN allow_rep_trig = FALSE.          
 
        ASSIGN dba_cmd = "QRYSRVCAP".
        RUN as4dict/_dbaocmd.p (INPUT "ALWSTPROC", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_st_proc = TRUE.
        ELSE
          ASSIGN allow_st_proc = FALSE.                     

        ASSIGN dba_cmd = "QRYSRVCAP".
        RUN as4dict/_dbaocmd.p (INPUT "WRDIDX", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_word_idx = TRUE.
        ELSE
          ASSIGN allow_word_idx = FALSE. 

        ASSIGN dba_cmd = "QRYSRVCAP".
        RUN as4dict/_dbaocmd.p (INPUT "CHGPF", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_chgpf = TRUE.
        ELSE
          ASSIGN allow_chgpf = FALSE. 

        ASSIGN dba_cmd = "QRYSRVCAP".
        RUN as4dict/_dbaocmd.p (INPUT "RAW", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_raw = TRUE.
        ELSE
          ASSIGN allow_raw = FALSE. 

        ASSIGN dba_cmd = "QRYSRVCAP".
          RUN as4dict/_dbaocmd.p (INPUT "ENHDBA", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_enhdba = TRUE.
        ELSE
          ASSIGN allow_enhdba = FALSE. 

        RUN as4dict/_brwgray.p  (INPUT false).
      END.    
      ELSE IF dba_return = 9 THEN DO:             
        ASSIGN answer = TRUE.
        MESSAGE "You have opened DB2/400 Database files."
                 "Before being allowed to modify the server"
                 "schema, they must be closed."  SKIP (1)
                 "Do you want to close them now?"  
                VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE answer.  
                  
        IF answer THEN DO:              
          run adecomm/_setcurs.p ("WAIT").
          ASSIGN dba_cmd = "CLOSEALL".       
          RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT s_CurrDb, INPUT 0, INPUT 0).   
          ASSIGN dba_cmd = "START".       
          RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).       
          IF dba_return = 1 THEN DO:
            ASSIGN s_ReadOnly = FALSE
                   s_mod_chg = "Modify Schema" .
  
            ASSIGN dba_cmd = "QRYSRVCAP".
            RUN as4dict/_dbaocmd.p (INPUT "WRDIDX", INPUT "", INPUT "", INPUT 0, INPUT 0).      
            IF dba_return = 1 THEN
              ASSIGN allow_word_idx = TRUE.
            ELSE
              ASSIGN allow_word_idx = FALSE.
                                                                            
            RUN as4dict/_brwgray.p  (INPUT false).
          END. 
          ELSE DO:        
            ASSIGN s_mod_chg = "Read Only" 
                   s_mod_chg:screen-value in frame browse = "Read Only".    
            IF user_env[33] <> "as4inc" AND user_env[33] <> "loaddf" THEN
              apply "back-tab" to s_mod_chg in frame browse.
          END.    
          run adecomm/_setcurs.p ("").
        END.
        ELSE DO:        
          ASSIGN s_mod_chg = "Read Only" 
                 s_mod_chg:screen-value in frame browse = "Read Only".    
          IF user_env[33] <> "as4inc" AND user_env[33] <> "loaddf" THEN
            apply "back-tab" to s_mod_chg in frame browse.
        END.   
      END.                                                                                             
      ELSE DO:           
        MESSAGE "An error must have occurred during your last DBA session."
                 "You are currently in DBA mode which means that any changes"
                 "entered since your last commit have been lost and must be"
                 "re-entered. " SKIP (1)
                 VIEW-AS ALERT-BOX INFORMATION BUTTON OK.    
		  
        run adecomm/_setcurs.p ("WAIT").           
   
        ASSIGN dba_cmd = "ROLLBACK".      
        RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).    
             
        ASSIGN dba_cmd = "END".      
        RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).    
           
        ASSIGN dba_cmd = "START".
        RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
 
        ASSIGN s_ReadOnly =  FALSE
               s_mod_chg = "Modify Schema" .                 
       
         /* Check for server capabilities for word indexes, replications triggers and stored procedures */
        ASSIGN dba_cmd = "QRYSRVCAP".
        RUN as4dict/_dbaocmd.p (INPUT "ALWRPLTRG", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_rep_trig = TRUE.
        ELSE
          ASSIGN allow_rep_trig = FALSE.          
 
        ASSIGN dba_cmd = "QRYSRVCAP".
        RUN as4dict/_dbaocmd.p (INPUT "ALWSTPROC", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_st_proc = TRUE.
        ELSE
          ASSIGN allow_st_proc = FALSE.                     

        ASSIGN dba_cmd = "QRYSRVCAP".
        RUN as4dict/_dbaocmd.p (INPUT "WRDIDX", INPUT "", INPUT "", INPUT 0, INPUT 0).      
        IF dba_return = 1 THEN
          ASSIGN allow_word_idx = TRUE.
        ELSE
          ASSIGN allow_word_idx = FALSE.
        IF user_env[33] <> "as4inc" AND user_env[33] <> "loaddf" THEN                           
          RUN as4dict/_brwgray.p  (INPUT false).         
      END.                                   
    END.              
    ELSE DO:        
      ASSIGN s_mod_chg = "Read Only" 
             s_mod_chg:screen-value in frame browse = "Read Only".    
      IF user_env[33] <> "as4inc" AND user_env[33] <> "loaddf" THEN
        apply "back-tab" to s_mod_chg in frame browse.
    END.    
    run adecomm/_setcurs.p ("").                                                                            
  END.            
  else do:
    ASSIGN s_mod_chg = "Read Only" 
           s_mod_chg:screen-value in frame browse = "Read Only".  
    IF user_env[33] <> "as4inc" AND user_env[33] <> "loaddf" THEN
      apply "back-tab" to s_mod_chg in frame browse.                           
  end.
END.
ELSE DO:           
   /* Check to see if user has made any changes in open property windows
      that he hasn't saved.  If there are, and he saves now, and an error
      occurs, don't continue.  
   */
  run Check_For_Changes.
  if RETURN-VALUE = "error" then  return.  

  IF s_dictDirty THEN DO:                           
    current-window = s_win_Browse.
    message  "You have uncommited transactions that must be commited"
             "before returning to read only mode.   Commiting may potentially"
             "take a long time.  Are you sure you want to change to read only?" SKIP
 	        view-as ALERT-BOX WARNING  buttons YES-NO  update answer
 	        in window s_win_Browse.

    IF answer THEN DO:            
        RUN as4dict/_chkfld.p.
        if user_env[34] = "N" THEN DO:          
          ASSIGN s_ReadOnly = FALSE
                 s_Mod_chg = "Modify Schema".        
                 s_mod_chg:screen-value in frame browse = "Modify Schema".  
          apply "back-tab" to s_mod_chg in frame browse.                                                                       
          RETURN.    
        end.                                                                               
                                         
      /* If focus is in Db list, we want it to remain there instead
	 of defaulting to fill-in.  So remember if list has the focus.
	 focus should never be ? here (I don't think) but the
	 GUI focus model is a bit wierd so sometimes it is.  
      */
      if focus <> ? then
	   s_Dblst_Focus = (if s_lst_Dbs:handle in frame browse = 
			  focus:handle then yes else no).

      s_Trans = {&TRANS_COMMIT}.   
            
      /* apply u2 will cause the commit to be issued in procedure _dcttran.p 
         then we will return here and the dba end will be done */
            
      apply "U2" to frame browse.    
      ASSIGN s_ReadOnly = TRUE
             s_mod_chg = "Read Only"
             allow_word_idx = FALSE .
      RUN as4dict/_brwgray.p (INPUT false).
    END.     
    ELSE                    
      ASSIGN s_mod_chg = "Modify Schema" 
             s_mod_chg:screen-value in frame browse = "Modify Schema".      
      apply "back-tab" to s_mod_chg in frame browse.                       
    END.      
    ELSE DO:                   
      run adecomm/_setcurs.p ("WAIT").
      ASSIGN dba_cmd = "END".      
      RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
      IF dba_passed THEN DO:          
        run as4dict/_delwins.p (INPUT yes).
        ASSIGN s_ReadOnly = TRUE      
               s_mod_chg = "Read Only".              
        RUN as4dict/_brwgray.p (INPUT false).
      END.    
      run adecomm/_setcurs.p ("").
    END.      
END.
 
