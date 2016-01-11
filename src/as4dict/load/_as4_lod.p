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
* Contributors:  Created D. McMann 02/06/01                                                    *
*                                                                    *
*********************************************************************/

{as4dict/dictvar.i "new shared"}
{as4dict/menu.i "new shared"}
{as4dict/dump/dumpvar.i "NEW shared" }

DEFINE NEW SHARED VARIABLE s_mod_chg  as character initial "Read Only" NO-UNDO.

DEFINE SHARED VARIABLE df-type AS CHARACTER NO-UNDO.

DEFINE VARIABLE answer    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE pro_type  AS CHARACTER NO-UNDO.
DEFINE VARIABLE gate_type AS CHARACTER NO-UNDO.
DEFINE VARIABLE io_length AS INTEGER   NO-UNDO.
DEFINE VARIABLE io1       AS INTEGER   NO-UNDO.
DEFINE VARIABLE out1      AS CHARACTER NO-UNDO.


ASSIGN user_dbname = PDBNAME("DICTDBG")
       user_env[33] = df-type.

CREATE ALIAS as4dict FOR DATABASE VALUE(user_dbname).

/* User wants to load a regular df file */
IF user_env[33] = "loaddf" THEN DO:                                                      
  ASSIGN pro_type = ?
         gate_type = ?
         io_length = 1.

  ASSIGN dba_cmd = "QRYSRVCAP".
  RUN as4dict/_dbaocmd.p (INPUT "RAW", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_raw = TRUE.
  ELSE
    ASSIGN allow_raw = FALSE. 

  RUN as4dict/_as4_typ.p (INPUT-OUTPUT io1, INPUT-OUTPUT io_length,
                  INPUT-OUTPUT pro_type, INPUT-OUTPUT gate_type,
                  OUTPUT out1).
  _trans:
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    ASSIGN s_CurrDb = user_dbname
           s_ReadOnly = true
           s_mod_chg = "Modify Schema".
         
    MESSAGE  "Loading a definitions file will place an exclusive lock on"  
             "the Progress/400 server schema.  This locks the schema for" 
             "all users until you commit the changes.  It is recommended " 
             "you save your current server schema and DB2/400 database"
             "before doing maintenance."  SKIP (1)
             "Are you sure you want to modify the Progress/400" 
             "server schema in library"  user_dbname SKIP
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE answer. 
  
    IF answer  THEN DO:   
      run adecomm/_setcurs.p ("WAIT").
      ASSIGN dba_cmd = "START".       
      RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).       
        
      IF dba_passed THEN  DO :
        IF dba_return = 1 THEN DO:
          ASSIGN s_mod_chg = "Modify Schema". 
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
            IF dba_return = 1 THEN 
              ASSIGN s_mod_chg = "Modify Schema" .
            run adecomm/_setcurs.p ("").
          END.
          ELSE        
            ASSIGN s_mod_chg = "Read Only".  
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
        END.
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
      END.
      ELSE ASSIGN s_mod_chg = "Read Only".
    END.
    ELSE
      ASSIGN s_mod_chg = "Read Only".

    IF s_mod_chg = "Read Only" THEN RETURN. 
    RUN as4dict/load/_a4loddf.p.
    IF user_env[35] = "error" THEN DO:
      RUN adecomm/_setcurs.p ("WAIT").
      ASSIGN dba_cmd = "ROLLBACK".
      RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
      ASSIGN dba_cmd = "END".
      RUN as4dict/_dbaocmd.p (INPUT "", INPUT '', INPUT '', INPUT 0, INPUT 0).
      RUN adecomm/_setcurs.p ("").
    END.
    ELSE IF user_env[35] = "cancelled" THEN DO:
      ASSIGN dba_cmd = "END".
      RUN as4dict/_dbaocmd.p (INPUT "", INPUT '', INPUT '', INPUT 0, INPUT 0).
      RUN adecomm/_setcurs.p ("").
    END.
    ELSE DO:
      ASSIGN answer = yes.  /* the default */                   
      MESSAGE "You have made changes in the current database" SKIP
              "that are not committed.  Answering YES will"    SKIP  
              "commit your changes, NO will undo them."   SKIP (1)
              "Do you want to commit your changes?" 
              VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
              UPDATE answer.
          
      IF answer = no THEN DO:                  
        RUN adecomm/_setcurs.p ("WAIT").
        ASSIGN dba_cmd = "ROLLBACK"
               user_env[35] = "cancelled".
        RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
        ASSIGN dba_cmd = "END".
        RUN as4dict/_dbaocmd.p (INPUT "", INPUT '', INPUT '', INPUT 0, INPUT 0).
        RUN adecomm/_setcurs.p ("").
        UNDO _trans, LEAVE _trans.           
      END.
      ELSE DO:             
        RUN adecomm/_setcurs.p ("WAIT").
        ASSIGN dba_cmd = "COMMIT".
        RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
        IF NOT dba_passed THEN
            ASSIGN user_env[35] = "error".
        ASSIGN dba_cmd = "END".
        RUN as4dict/_dbaocmd.p (INPUT "", INPUT '', INPUT '', INPUT 0, INPUT 0).   
        RUN adecomm/_setcurs.p ("").
      END.
    END.
  END.
END.
/* user wants to load an AS/400 incremental df which has all the commits in file */
ELSE DO: 
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

  IF allow_enhdba THEN
    RUN as4dict/load/_a4loddf.p.
  ELSE DO:
    ASSIGN user_env[35] = "error".
    RETURN.
  END.
END.

IF user_env[35]<> "cancelled" AND user_env[35]<> "error" THEN  
    RUN prodict/as4/_as4sync.p.
RETURN.

