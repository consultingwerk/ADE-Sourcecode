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
/* Created:  D. McMann 06/22/98 PROTOODBC Utiity to migrate a Progress
                                database via ODBC to one of the following
                                foreign database:  Informix On-Line, DB2/6000
                                DB2/NT, DB2/MVS, MS Access, MS SQL Server,
                                Sybase, and Other which will be a catch all
                                for databases which we do not specifically
                                support but that the user wants to try.
                                
  History:  D. McMann 09/03/98  Added assignment of code-page for default
                                and removed <current database> from progress
                                connect parameters. 
                      09/08/98  Removed compatibility for DB2 data bases. 
                      10/21/98  Removed compatibility for ALL data bases.
                      02/08/99  Added check for pro_dbname being same as DICTDB.
                                98-09-14-053   
                      03/03/99  Removed on-line from informix  
                      03/16/99  Made compatible the default  
                      12/02/99  Changed compatible label 
                                19990305027  
                      02/01/00  Added sqlwidth support                                             
                      04/12/00  Added long Progress Database path name
                      09/05/01  Added support for wrong version of SQL Server
                      11/16/01  Added logic to block moving data if running -rx
                      10/08/02  Added logic to create shadow columns.
                    
*/            


{ prodict/user/uservar.i NEW }
{ prodict/odb/odbvar.i NEW }

DEFINE VARIABLE cmd           AS CHARACTER                NO-UNDO.
DEFINE VARIABLE wait          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE create_h      AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE db_exist      AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL NO       NO-UNDO.
DEFINE VARIABLE old-dictdb    AS CHARACTER                NO-UNDO.  
DEFINE VARIABLE output_file   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE tmp_str       AS CHARACTER                NO-UNDO.
DEFINE VARIABLE run_time      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                  NO-UNDO.
DEFINE VARIABLE err-rtn       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE codb_type     AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE VARIABLE redo          AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE redoblk       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE wrg-ver       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE mvdta         AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE odbctypes     AS CHARACTER 
  INITIAL "SQL Server 6,Sybase,DB2/MVS,DB2/6000,DB2/NT,Informix,MS Access,Other,DB2,SQLSERVER,MSAccess,SQLSERVER6.5" NO-UNDO.

DEFINE STREAM   strm.

batch_mode = SESSION:BATCH-MODE.

FORM
  " "   SKIP({&VM_WID}) 
  pro_dbname   FORMAT "x({&PATH_WIDG})"  view-as fill-in size 32 by 1 
    LABEL "Original PROGRESS Database" colon 36 SKIP({&VM_WID}) 
  pro_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
    LABEL "Connect parameters for PROGRESS" colon 36 SKIP({&VM_WID})
  osh_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Name of Schema holder Database" colon 36 SKIP({&VM_WID})
  odb_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "ODBC Data Source Name" colon 36 SKIP({&VM_WID})
 &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   codb_type LABEL "Foreign DBMS TYPE" colon 36 view-as fill-in size 32 by 1
      SKIP ({&VM_WID})  
 &ELSE
   odb_type LABEL "Foreign DBMS Type" colon 36 SKIP ({&VM_WID})       
 &ENDIF  
 
  odb_username FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "ODBC Username" colon 36 SKIP({&VM_WID})
  odb_password FORMAT "x(32)"  BLANK
        view-as fill-in size 32 by 1 
        LABEL "ODBC User's Password" colon 36 SKIP({&VM_WID})
  odb_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
     LABEL "ODBC connect parameters" colon 36 SKIP({&VM_WID})
  odb_codepage FORMAT "x(32)"  view-as fill-in size 32 by 1
     LABEL "Codepage for Schema Image" colon 36 SKIP({&VM_WID})
  odb_collname FORMAT "x(32)"  view-as fill-in size 32 by 1
     LABEL "Collation name" colon 36 SKIP({&VM_WIDG}) SPACE(4)
  pcompatible view-as toggle-box LABEL "Progress 4GL Compatible Objects" 
  shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" SKIP({&VM_WID})
 SPACE(4) loadsql view-as toggle-box label "Load SQL" 
 &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(24)
 &ELSE SPACE(23) &ENDIF
  movedata view-as toggle-box label "Move Data" SKIP({&VM_WID})
             {prodict/user/userbtns.i}
  WITH FRAME x ROW 2 CENTERED SIDE-labels OVERLAY
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF
  TITLE "PROGRESS DB to ODBC Conversion".

FORM
  wait FORMAT "x" LABEL
  "Creating tables - Please wait"
  WITH FRAME table-wait ROW SCREEN-LINES - 2 COLUMN 1 NO-BOX OVERLAY
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF.


/* PROCEDURES */
PROCEDURE cleanup:  
  IF NUM-DBS > 1 THEN DO:   
    IF rmvobj THEN DO:
        DISCONNECT VALUE(osh_dbname).
        RUN prodict/misc/_clproto.p (INPUT osh_dbname, INPUT pro_dbname).
    END.
    ELSE DO:       
      CREATE ALIAS DICTDB FOR DATABASE VALUE(osh_dbname).
      RUN prodict/misc/_del-db.p (INPUT odb_dbname, INPUT osh_dbname, 
                                  INPUT pro_dbname).       
    END.
  END.
END PROCEDURE.

/*   TRIGGERS   */

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
 ON LEAVE of codb_type IN FRAME x DO :
   IF codb_type BEGINS "SQL" THEN codb_type = "Sql Server 6".
   IF LOOKUP(input codb_type, odbctypes) = 0 THEN DO:
     MESSAGE "THE DBMS types that are supported are: " SKIP  
       "  SQL Server 6, Sybase, DB2/MVS, DB2/6000, DB2/NT," SKIP
        " Informix, MS Access, Other" SKIP (1)
        VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
   END.
   IF input codb_type BEGINS "DB2" OR
      input codb_type BEGINS "Informix" OR
      input codb_type BEGINS "MS Acc" OR
      input codb_type BEGINS "MSAcc" OR
      input codb_type BEGINS "Oth"  THEN 
     ASSIGN pcompatible:screen-value in frame x = "no"
            pcompatible = FALSE
            pcompatible:sensitive in frame x = no.
   ELSE
     ASSIGN pcompatible:sensitive in frame x = YES
            pcompatible = TRUE
            pcompatible:screen-value in frame x = "yes".   
   IF codb_type:SCREEN-VALUE BEGINS "Oth" THEN
       ASSIGN shadowcol:SENSITIVE IN FRAME X = NO
              shadowcol:SCREEN-VALUE IN FRAME X = "no".
   ELSE
       ASSIGN shadowcol:SENSITIVE IN FRAME X = YES
              shadowcol:SCREEN-VALUE IN FRAME X = ?.
 END.
&ENDIF  
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
 ON VALUE-CHANGED of odb_type IN FRAME x OR
    LEAVE of odb_type IN FRAME x DO :
   IF odb_type:screen-value BEGINS "DB2" OR
      odb_type:screen-value BEGINS "Informix" OR
      odb_type:screen-value BEGINS "MS Acc" OR
      odb_type:screen-value BEGINS "Oth" THEN
     ASSIGN pcompatible:screen-value in frame x = "no"
            pcompatible = FALSE
            pcompatible:sensitive in frame x = no.
   ELSE
     ASSIGN pcompatible:sensitive in frame x = YES
            pcompatible:screen-value in frame x = "yes"
            pcompatible = TRUE.  
   IF odb_type:SCREEN-VALUE BEGINS "Oth" THEN
       ASSIGN shadowcol:SENSITIVE IN FRAME X = NO
              shadowcol:SCREEN-VALUE = "NO".
   ELSE
       ASSIGN shadowcol:SENSITIVE IN FRAME X = YES
              shadowcol:SCREEN-VALUE = ?.
 END.
&ENDIF  

ON WINDOW-CLOSE of FRAME x
   APPLY "END-ERROR" to FRAME x.
   
ON VALUE-CHANGED of loadsql IN FRAME x DO:
  IF SELF:screen-value = "yes" THEN 
     movedata:sensitive in frame x = YES.
  ELSE DO:
     movedata:screen-value in frame x = "no".
     movedata = false.
     movedata:sensitive in frame x = NO.
  END.   
END.  

&IF "{&WINDOW-SYSTEM}"<> "TTY" &THEN   
/*----- HELP in Progress DB to Oracle Database -----*/
on CHOOSE of btn_Help in frame x
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&PROGRESS_DB_to_ODBC_Dlg_Box},
                             INPUT ?).
&ENDIF

IF LDBNAME ("DICTDB") <> ? THEN
  ASSIGN pro_dbname = LDBNAME ("DICTDB").

IF NOT batch_mode THEN DO:
   {adecomm/okrun.i  
       &FRAME  = "FRAME x" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
   }
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   btn_Help:visible IN FRAME x = yes.
   &ENDIF
END.

main-blk:
DO ON ERROR UNDO main-blk, RETRY main-blk:
  
  IF redo THEN
        RUN cleanup.

  IF wrg-ver THEN DO:
    MESSAGE "The DataServer for ODBC was designed to work with MS SQL Server 6 and " SKIP
            "below.  You have tried to connect to a later version. " SKIP
            "Use the DataServer for MS SQL Server to perform this function. " SKIP(1)       
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.

  ASSIGN pcompatible = YES
         run_time = TIME.

  IF OS-GETENV("PRODBNAME")   <> ? THEN
      pro_dbname   = OS-GETENV("PRODBNAME").
  IF OS-GETENV("PROCONPARMS")   <> ? THEN
        pro_conparms = OS-GETENV("PROCONPARMS").
  IF OS-GETENV("SHDBNAME")    <> ? THEN
      osh_dbname   = OS-GETENV("SHDBNAME").
  IF OS-GETENV("ODBCDBNAME")   <> ? THEN
      odb_dbname   = OS-GETENV("ODBCDBNAME").
  IF OS-GETENV("ODBCTYPE")   <> ? THEN
      odb_type   = OS-GETENV("ODBCTYPE").        
  IF OS-GETENV("ODBCUSERNAME") <> ? THEN
      odb_username = OS-GETENV("ODBCUSERNAME").
  IF OS-GETENV("ODBCPASSWORD") <> ? THEN
      odb_password = OS-GETENV("ODBCPASSWORD").
  IF OS-GETENV("ODBCCONPARMS") <> ? THEN
      odb_conparms = OS-GETENV("ODBCCONPARMS").
  IF OS-GETENV("ODBCCODEPAGE") <> ? THEN
      odb_codepage = OS-GETENV("ODBCODEPAGE").
  ELSE
     ASSIGN odb_codepage = session:cpinternal.
  IF OS-GETENV("ODBCCOLLNAME") <> ? THEN
      odb_collname = OS-GETENV("ODBCCOLLNAME").
  ELSE
     ASSIGN odb_collname = session:CPCOLL.
  IF OS-GETENV("MOVEDATA")    <> ? THEN
      tmp_str      = OS-GETENV("MOVEDATA").
  IF tmp_str BEGINS "Y" THEN movedata = TRUE.

  IF OS-GETENV("COMPATIBLE") <> ? 
  THEN DO:
      tmp_str      = OS-GETENV("COMPATIBLE").
      IF tmp_str BEGINS "Y" then pcompatible = TRUE.
      ELSE pcompatible = FALSE.
   END. 

  IF OS-GETENV("SHADOWCOL") <> ? THEN DO:
    tmp_str      = OS-GETENV("SHADOWCOL").
    IF tmp_str BEGINS "Y" then shadowcol = TRUE.
    ELSE shadowcol = FALSE.
  END. 
  ELSE 
    shadowcol = FALSE.

  IF OS-GETENV("LOADSQL") <> ? THEN DO:
    tmp_str      = OS-GETENV("LOADSQL").
    IF tmp_str BEGINS "Y" then loadsql = TRUE.
    ELSE loadsql = FALSE.
  END. 
  ELSE 
    loadsql = TRUE.
 
  IF PROGRESS EQ "COMPILE-ENCRYPT" THEN
    ASSIGN mvdta = FALSE.
  ELSE
    ASSIGN mvdta = TRUE.

  if   pro_dbname   = ldbname("DICTDB")
   and pro_conparms = ""
   then assign pro_conparms = "<current working database>".

  IF redoblk THEN DO:
      MESSAGE "You have received error messages from the client stating why" SKIP
              "the process was stopped.  Correct the errors and try again." SKIP
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.
  /*
   * if this is not batch mode, allow override of environment variables.
   */
  
  IF NOT batch_mode THEN 
  _updtvar: 
  DO WHILE TRUE:
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      UPDATE pro_dbname
        pro_conparms
        osh_dbname
        odb_dbname
        odb_type 
        odb_username
        odb_password
        odb_conparms
        odb_codepage  
        odb_collname
        pcompatible     
        shadowcol
        loadsql
        movedata WHEN mvdta
        btn_OK btn_Cancel 
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
        &ENDIF
        WITH FRAME x.
    &ELSE 
      UPDATE pro_dbname
        pro_conparms
        osh_dbname
        odb_dbname
        codb_type 
        odb_username
        odb_password
        odb_conparms
        odb_codepage
        odb_collname
        pcompatible
        shadowcol
        loadsql
        movedata
        btn_OK btn_Cancel
        WITH FRAME x.
        
      IF codb_type = ? OR codb_type = "" THEN DO:
        MESSAGE "Foreign DBMS Type is required." SKIP
            VIEW-AS ALERT-BOX.
        NEXT-PROMPT codb_type with frame x.
        NEXT _updtvar.
      END.
      ELSE
        ASSIGN odb_type = codb_type.              
    &ENDIF      

    IF pro_conparms = "<current working database>" THEN
      ASSIGN pro_conparms = "".

    IF LDBNAME ("DICTDB") <> pro_dbname THEN DO:
      ASSIGN old-dictdb = LDBNAME("DICTDB").
      IF NOT CONNECTED(pro_dbname) THEN
        CONNECT VALUE (pro_dbname) VALUE (pro_conparms) -1 NO-ERROR.              
      
      IF ERROR-STATUS:ERROR OR NOT CONNECTED (pro_dbname) THEN DO:
        DO i = 1 TO  ERROR-STATUS:NUM-MESSAGES:
          IF batch_mode THEN
            PUT STREAM logfile UNFORMATTED ERROR-STATUS:GET-MESSAGE(i) skip.
          ELSE
            MESSAGE ERROR-STATUS:GET-MESSAGE(i).
        END.
        IF batch_mode THEN
           PUT STREAM logfile UNFORMATTED "Unable to connect to Progress database"
           skip.
        ELSE DO:
          &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
              MESSAGE "Unable to connect to Progress database".
          &ELSE
             MESSAGE "Unable to connect to Progress database" 
             VIEW-AS ALERT-BOX ERROR.
          &ENDIF
        END.            
        UNDO, RETURN error.
      END.
      ELSE DO:
    
        CREATE ALIAS DICTDB FOR DATABASE VALUE(pro_dbname).
      end.  
    END.
    ELSE
      ASSIGN old-dictdb = LDBNAME("DICTDB").
        
    IF loadsql THEN DO:
      IF Osh_dbname = "" OR osh_dbname = ? THEN DO:
        MESSAGE "Schema holder database Name is required." 
             VIEW-AS ALERT-BOX ERROR.    
        NEXT _updtvar.
      END.

      IF odb_dbname = "" OR odb_dbname = ? THEN DO:
        MESSAGE "ODBC Data Source Name is required."  
            VIEW-AS ALERT-BOX ERROR.  
        NEXT _updtvar.
      END.
    END.      
    LEAVE _updtvar.
  END.
 
  IF osh_dbname <> "" AND osh_dbname <> ? THEN
      output_file = osh_dbname + ".log".
  ELSE
      output_file = "protoodb.log". 
             
  OUTPUT STREAM logfile TO VALUE(output_file) NO-ECHO NO-MAP UNBUFFERED. 
  logfile_open = true. 
  IF pro_dbname = "" OR pro_dbname = ? THEN DO:
    PUT STREAM logfile UNFORMATTED "Progress Database name is required." SKIP.
    ASSIGN err-rtn = TRUE.
  END.
  IF odb_type = "" OR odb_type = ? THEN DO:
     PUT STREAM logfile UNFORMATTED "Foreign DBMS type is required." SKIP.   
     ASSIGN err-rtn = TRUE.
  END.

  IF loadsql THEN DO:
    IF Osh_dbname = "" OR osh_dbname = ? THEN DO:
       PUT STREAM logfile UNFORMATTED  "Schema holder Database Name is required." SKIP.   
       ASSIGN err-rtn = TRUE.        
    END.
    IF odb_dbname = "" OR odb_dbname = ? THEN DO:
       PUT STREAM logfile UNFORMATTED "ODBC data source name is required." SKIP.   
       ASSIGN err-rtn = TRUE.
    END.
  END.      
  IF err-rtn THEN RETURN.
  ASSIGN redo = TRUE.
  RUN prodict/odb/protood1.p.
  IF RETURN-VALUE = "indb" THEN DO:
    ASSIGN redo = FALSE.
    UNDO, RETRY.
  END.
  ELSE IF RETURN-VALUE = "wrg-ver" THEN DO:
    ASSIGN wrg-ver = TRUE.
    UNDO, RETRY.
  END.
  ELSE IF RETURN-VALUE = "undo" THEN DO:
    ASSIGN redoblk = TRUE.
    UNDO, RETRY.
  END.
  /*
   * If this is batch mode, make sure we close the output file we
   * opened above.
  */
  IF logfile_open
    THEN OUTPUT STREAM logfile CLOSE.
 
  IF CONNECTED (osh_dbname) THEN 
     DISCONNECT VALUE (osh_dbname).

  IF pro_dbname <> old-dictdb THEN DO:
    DISCONNECT VALUE(pro_dbname).
    CREATE ALIAS DICTDB FOR DATABASE VALUE(old-dictdb).   
  END.
END.


 
 










