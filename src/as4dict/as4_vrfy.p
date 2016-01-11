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

/* File: as4_vrfy.p

Description:
      This program verifys AS/400 data dictionary  against the physical
      object in the DB2/400 database.

History:
      D. McMann    05/01/95   Created. 
      D. McMann    06/19/96   Changed to display _Db-addr instead of 
                              _Db-name and made overlay frame to run 
                              in PROGRESS/400 Data Dictionary.
      D. McMann    06/25/97   Added check for user index for word index support.                        
                              
*/


/*===========================  Main Line Code  ===========================*/

DEFINE VARIABLE verfy       AS CHARACTER               NO-UNDO.   
DEFINE VARIABLE dba_return  AS INTEGER                 NO-UNDO.
DEFINE VARIABLE dba_cmd     AS CHARACTER               NO-UNDO.   
DEFINE VARIABLE file_type   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE didstop     AS LOGICAL.     /* Don't do no-undo */            
DEFINE VARIABLE ronote      AS CHARACTER               NO-UNDO.
DEFINE VARIABLE dspname      AS CHARACTER               NO-UNDO.

DEFINE VARIABLE err_msg AS CHARACTER EXTENT 6 NO-UNDO INITIAL [
/* return code 2 -1 */ "Object not found",
/* return code 3 -2*/  "Library not found",
/* return code 5 -3*/  "Invalid authority could not check",
/* return code 11-4*/ "Wrong File Format",   /* This if for files */
/* return code 11-5*/  "Mismatched change date",    /* This is for indexes */
/* anyother      -6*/ "Unknown error code "
].

FORM
  dspname LABEL "Database" COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__File._AS4-File  LABEL "Table"    COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__Index._AS4-File LABEL "Index"    COLON 11 FORMAT "x(32)":u SKIP
  HEADER 
    " Verifying Definitions.  Press " +
    KBLABEL("STOP") + " to terminate process." format "x(70)" 
  WITH OVERLAY FRAME working THREE-D
  ROW 4 CENTERED USE-TEXT SIDE-LABELS VIEW-AS DIALOG-BOX.          

{ as4dict/usersho.i NEW } 
{ prodict/user/uservar.i  }  
SESSION:IMMEDIATE-DISPLAY = TRUE.        

FIND _db where _db._db-name = LDBNAME("as4dict").       
IF _Db._Db-addr = ? OR _Db._Db-addr = "" THEN
    ASSIGN dspname = _Db._Db-name.
ELSE
    ASSIGN dspname = _Db._Db-addr.    
 
COLOR DISPLAY MESSAGES
    dspname as4dict.p__File._AS4-File  as4dict.p__Index._AS4-File 
    WITH FRAME working.    
    
  DISPLAY dspname with frame working.   
  sho_limit = 0.       
 
 ASSIGN didstop = TRUE.
  
 _vloop:
DO TRANSACTION ON ERROR UNDO, LEAVE _vloop
                         ON ENDKEY UNDO, LEAVE _vloop ON STOP UNDO, LEAVE _vloop:                          
     ASSIGN didstop = FALSE.
     
  /*------------------------ _File processing ------------------------------*/
  /* File Loop for each table in the database.  */
   
  _vfyfil:
  FOR EACH as4dict.p__file NO-LOCK:            
    IF as4dict.p__File._File-name = "qcmd" THEN NEXT.

    ASSIGN  verfy = "Verifying " + as4dict.p__File._AS4-File.
    Display verfy @ as4dict.p__file._AS4-File 
                                with frame working.            
                                                              
     IF as4dict.p__File._For-flag > 0 THEN  DO:
        if as4dict.p__file._For-flag = 1 then ronote         = "Limited logical virtual table, can't verify".
       else if as4dict.p__file._For-flag = 2 then ronote = "Multi record virtual table, can't verify".
       else if as4dict.p__file._For-flag = 3 then ronote = "Joined logical virtual table, can't verify".
       else if as4dict.p__file._For-flag = 4 then ronote = "Program desc virtual table, can't verify".
       else if as4dict.p__file._For-flag = 5 then ronote = "Multi rec pgm desc virtual, can't verify" . 
       else ronote = "virtual file/table, can't verify".           
        
       ASSIGN sho_limit = sho_limit + 1
                        sho_pages[sho_limit] = STRING(as4dict.p__File._For-name,"x(22)")  +
                            ronote.
      NEXT _vfyfil.
    END.

   ASSIGN file_type = "PF,".   
             
    CREATE as4dict.qcmd.
    ASSIGN as4dict.qcmd.cmd = "** DBA CHKF "  + file_type
                              + as4dict.p__File._AS4-File + "," + as4dict.p__File._AS4-Library.                            
    ASSIGN dba_return = RECID(as4dict.qcmd).     
    
    IF dba_return <> 1 THEN DO:
        ASSIGN sho_limit = sho_limit + 1.

        IF dba_return = 2 THEN
                ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__File._For-name,"x(22)")
                                       + err_msg[1].
         ELSE  IF dba_return = 3 THEN 
                ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__File._For-name,"x(22)")
                                       + err_msg[2].          
          ELSE  IF dba_return = 5 THEN 
                ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__File._For-name,"x(22)")
                                       + err_msg[3].   
         ELSE  IF dba_return = 11 THEN 
                ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__File._For-name,"x(22)")
                                       + err_msg[4].       
         ELSE 
                ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__File._For-name,"x(22)")
                                       + err_msg[6] + " " + string(dba_return).       
    END.
    	            
    FOR EACH as4dict.p__index WHERE as4dict.p__index._file-number = as4dict.p__file._file-number NO-LOCK:
        ASSIGN  verfy = "Verifying " + as4dict.p__Index._AS4-file.
        IF as4dict.p__Index._Idx-num = as4dict.p__File._Fil-Misc1[7] THEN NEXT.    
        ELSE DO:
            Display verfy @ as4dict.p__Index._AS4-File 
                                with frame working.
            IF as4dict.p__index._Wordidx = 0 THEN DO:
              CREATE as4dict.qcmd.
              ASSIGN as4dict.qcmd.cmd = "** DBA CHKF LF," 
                       + as4dict.p__Index._AS4-File + "," 
                       + as4dict.p__Index._AS4-Library.                            
              ASSIGN dba_return = RECID(as4dict.qcmd). 
            END.
            ELSE DO:            
              CREATE as4dict.qcmd.
              ASSIGN as4dict.qcmd.cmd = "** CMD CHKOBJ " 
                              + as4dict.p__Index._AS4-File + "," 
                              + as4dict.p__Index._AS4-Library + ","
                              + "*USRIDX".                            
              ASSIGN dba_return = RECID(as4dict.qcmd). 
            END.
              
            IF dba_return <> 1 THEN DO:
                ASSIGN sho_limit = sho_limit + 1.

                IF dba_return = 2 THEN
                    ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__Index._For-name,"x(22)")
                                       + err_msg[1].
                ELSE  IF dba_return = 3 THEN 
                    ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__Index._For-name,"x(22)")
                                       + err_msg[2].          
                ELSE  IF dba_return = 5 THEN 
                    ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__Index._For-name,"x(22)")
                                       + err_msg[3].   
                ELSE  IF dba_return = 11 THEN 
                    ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__Index._For-name,"x(22)")
                                       + err_msg[5].       
                ELSE
                    ASSIGN sho_pages[sho_limit] = STRING(as4dict.p__Index._For-name,"x(22)")
                                       + err_msg[6] + string(dba_return) + " index".              
             END.                          
        END.                     
    END.
END.     
END.

IF didstop THEN DO:
  HIDE FRAME working NO-PAUSE.
  MESSAGE "Verification stopped." VIEW-AS ALERT-BOX INFORMATION BUTTON OK.  
  RETURN.     
END.  
IF sho_limit > 0 THEN DO: 
   HIDE FRAME working NO-PAUSE.    
    ASSIGN user_env[5] = ""
           user_env[6] = "The following anomalies were found"
           user_env[7] = "check error file " + dspname + ".e"
           user_env[8] = dspname + ".e"
           sho_title = "Listing Anomalies".
      RUN as4dict/_vrferr.p.
      RUN as4dict/_usrshow.p (INPUT 0).  
END.        
ELSE  DO:           
    HIDE FRAME working NO-PAUSE.    
   MESSAGE "Verify complete, no anomalies found"
       VIEW-AS ALERT-BOX INFORMATION BUTTON OK.     
END.       

RETURN.

