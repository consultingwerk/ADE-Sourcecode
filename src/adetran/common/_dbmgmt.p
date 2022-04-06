/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_dbmgmt.p
Author:       R. Ryan/
Created:      1/95
Updated:      9/95
Purpose:      Performs various db management activities outside the 
              scope of the calling procedure.
Background:   The first parameter, pAction, identifies what the mode
              for this procedure will be:
                 
                CREATE       Creates a new progress DB
                CONNECT      Connects to a Progress DB
                DISCONNECT   Disconnect the Progress DB

                DELETE       Deletes a progress DB
                BACKUP       Backs up a progress DB
                RESTORE      Restores a progress DB
                BACKUPVERIFY Verifies backup of a progress DB
                
Calls:        common/_alias.p (connects to the project database and sets the alias)
              common/_dbmgmt.p (actions on the database)
              common/_k-alias.p (connects to the kit database and sets the alias)
Parameters:   pAction (input/char) described above
              pToDB (input/char)   name of the db to create or connect to
              pAlias (input/char)   name of the db alias 
              pFromDB (input/char) name of the db to copy from
              pReplace (input/log) flag for replace a db if it exists
              pError (output/log)  was the operation successful?

Notes: There is no DELETE, BACKUP, RESTORE or BACKUPVERIFY in the PROGRESS 4GL, 
    we are simulating via OS commands.
    Also note that we never use the CONNECT because if we do the transaction 
                
*/

&IF LOOKUP("{&OPSYS}","MSDOS,WIN32":U) > 0 &THEN
   &SCOPED-DEFINE SLASH ~~~\
&ELSE
   &SCOPED-DEFINE SLASH /
&ENDIF


DEFINE INPUT   PARAMETER pAction      AS CHARACTER                  NO-UNDO.
DEFINE INPUT   PARAMETER pToDB        AS CHARACTER                  NO-UNDO.
DEFINE INPUT   PARAMETER pAlias       AS CHARACTER                  NO-UNDO.
DEFINE INPUT   PARAMETER pFromDB      AS CHARACTER                  NO-UNDO.
DEFINE INPUT   PARAMETER pReplace     AS LOGICAL                    NO-UNDO.
DEFINE OUTPUT  PARAMETER pError       AS LOGICAL                    NO-UNDO.   

DEFINE VARIABLE i                     AS INTEGER                    NO-UNDO.
DEFINE VARIABLE MessageList           AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cFiles                AS CHARACTER                  NO-UNDO.

DEFINE VARIABLE lStatus               AS LOGICAL                    NO-UNDO.

/* Variables added for BACKUP/RESTORE */
DEFINE VARIABLE doIt                  AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE lError                AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE fExt                  AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cDLCDir               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cSetDLC               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cFullPath             AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cKitFileBase          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cKitFileExt           AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cStatusFileContent    AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE lAction               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE tmpFile               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE tmpStr                AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE statFile              AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE batFile               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE yesFile               AS CHARACTER                  NO-UNDO.

DEFINE VARIABLE origConnStat          AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE cBkupExt              AS CHARACTER INITIAL ".bku":U NO-UNDO.

DEFINE VARIABLE cBasename             AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cBaseMinusExt         AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cPrefix               AS CHARACTER                  NO-UNDO.


DEFINE VARIABLE cBackup        AS CHARACTER INITIAL "BACKUP":U       NO-UNDO. 
DEFINE VARIABLE cBackupVerify  AS CHARACTER INITIAL "BACKUPVERIFY":U NO-UNDO. 
DEFINE VARIABLE cRestore       AS CHARACTER INITIAL "RESTORE":U      NO-UNDO. 

DEFINE VARIABLE cSearchString  AS CHARACTER EXTENT 99 NO-UNDO. 
DEFINE VARIABLE cErrorNumber   AS CHARACTER EXTENT 99 NO-UNDO. 
DEFINE VARIABLE cErrorString   AS CHARACTER           NO-UNDO. 

DEFINE STREAM sInStream.
DEFINE STREAM batStream.

main-block:
do 
  on error   undo main-block, leave main-block
  on end-key undo main-block, leave main-block
  on stop    undo main-block, leave main-block: 


  case pAction:   
    when "DISCONNECT" then do:
      /* message "Disconnecting" pFromDB view-as alert-box. */
      disconnect value(pFromDB) no-error.  
      delete alias value(pAlias).
    end.
  
    when "CONNECT" then do: 
      /* message "Connecting" pAlias "." view-as alert-box. */ 
      connect -db value(pFromDB) -ld value(pAlias) -1 no-error.          
    end. 
  
    when "CREATE" then do:                       
      /* message "Creating" pToDB "from" pFromDB "database" view-as alert-box. */ 
      if pReplace then
        create database pToDB from pFromDB replace no-error.
      else
        create database pToDB from pFromDB no-error. 
    end.

    WHEN "DELETE":U THEN
    DO:
       FILE-INFO:FILE-NAME = pToDB.
       IF FILE-INFO:FULL-PATHNAME = ? THEN 
          RUN adetran/common/_dbfiles.p
          (INPUT pToDB,
           OUTPUT cFiles).
       ELSE
          RUN adetran/common/_dbfiles.p
          (INPUT FILE-INFO:FULL-PATHNAME,
           OUTPUT cFiles).

       DO i = 1 TO NUM-ENTRIES(cFiles,CHR(3)):
         FILE-INFO:FILE-NAME = ENTRY(i,cFiles,CHR(3)).
         IF FILE-INFO:FULL-PATHNAME <> ? THEN
           OS-DELETE VALUE(FILE-INFO:FULL-PATHNAME).
       END. /* remove each file */
    END. /* DELETE */

    WHEN cBackup THEN
    DO:
       /* disconnect the database if necessary
        * _dbutil probkup <dbname> <device-name> 
        * _dbutil prorest <dbname> <device-name> -vf
        * we do not directly use probkup.bat or prorest.bat since
        * redirection doesn't work into,out off .bat files
        * reconnect to database if originally connected
        */ 
      RUN discOSCommand.

      IF NOT pError THEN
      DO:
         /* Verify the the backup worked */
         RUN adetran/common/_dbmgmt.p 
                   (INPUT cBackupVerify, 
                    INPUT pToDB,
                    INPUT pAlias,
                    INPUT ?,
                    INPUT ?,
                    OUTPUT lError).
         IF NOT lError AND (NOT CONNECTED(pAlias)) AND origConnStat THEN 
         DO:
            IF pAlias = "xlatedb":U THEN
               RUN adetran/common/_alias.p (OUTPUT lError).
            ELSE
               RUN adetran/common/_k-alias.p (OUTPUT lError).
         END. /* no error and not connected. Reconnect */
      END. /* no error */
    END. /* BACKUP */

    WHEN cBackupVerify THEN
    DO:
       /* _dbutil prorest <dbname> <device-name> -vf
        */ 
      RUN discOSCommand.

      IF NOT lError AND (NOT CONNECTED(pAlias)) AND origConnStat THEN 
      DO:
         /* Reconnect */
         IF pAlias = "xlatedb":U THEN
            RUN adetran/common/_alias.p (OUTPUT lError).
         ELSE
            RUN adetran/common/_k-alias.p (OUTPUT lError).
      END. /* not error and previously connected */
    END. /* BACKUPVERIF */

    WHEN cRestore THEN
    DO:
       /* Restore      _dbutil prorest <dbname> <device-name> */
      RUN discOSCommand.
      IF SEARCH(pToDB) <> ? OR
         SEARCH(pToDB + ".db":U) <> ? THEN
      DO:
         IF SEARCH(tmpFile) <> ? THEN OS-DELETE VALUE(tmpFile).
      END.
      ELSE ASSIGN pError = YES.
    END. /* RESTORE */

  end case. 
end.  

if error-status:error AND INDEX("DISCONNECT,CONNECT,CREATE":U,pAction) <> 0 THEN
DO:
  do i = 1 to error-status:num-messages:
    MessageList = MessageList + chr(10) + error-status:get-message(i).
    
    IF error-status:get-message(i) MATCHES "*Error Creat*":U THEN
      MEssageList = MessageList + chr(10) +
                  "Check to make sure that the directory structure is correct.":U.
  end.
  message MessageList view-as alert-box error title "Database Error".
  pError = true. 
end.
ELSE IF cErrorString <> "":U THEN
DO:
  MESSAGE cErrorString VIEW-AS ALERT-BOX ERROR TITLE "Database Error".
  ASSIGN pError = TRUE. 
END.


/* Internal procedures */
PROCEDURE discOSCommand:
   /* disconnect the database if necessary
    * _dbutil probkup <dbname> <device-name> 
    * _dbutil prorest <dbname> <device-name> -vf
    * _dbutil prorest <dbname> <device-name>
    */ 

      GET-KEY-VALUE SECTION "StartUp" KEY "DLC" VALUE cDLCDir.

      ASSIGN cErrorNumber[1] = "(263)":U   /* single-user mode */
             cErrorNumber[2] = "Out of environment space" /* Out of environment space */
             FILE-INFO:FILE-NAME = pToDB
             tmpStr = IF FILE-INFO:FULL-PATHNAME = ? THEN pToDB
                      ELSE FILE-INFO:FULL-PATHNAME.

      IF cDLCDir = "" OR cDLCDir = ? THEN
         cDLCDir = OS-GETENV("DLC":U).

      IF cDLCDir <> "" AND cDLCDir <> ? THEN
         cSetDLC = "set DLC=" + cDLCDir.

      RUN adecomm/_osfext.p (INPUT pToDB,
                             OUTPUT fExt).
      RUN adecomm/_osprefx.p (INPUT pToDB,
                              OUTPUT cPrefix,
                              OUTPUT cBasename).
      RUN adecomm/_tmpfile.p (INPUT "bku":U,
                              INPUT ".bat",
                              OUTPUT batFile).
      RUN adecomm/_tmpfile.p (INPUT "bku":U,
                              INPUT ".sta",
                              OUTPUT statFile).
      RUN adecomm/_tmpfile.p (INPUT "yes":U,
                              INPUT ".dat",
                              OUTPUT yesFile).
      ASSIGN cBaseMinusExt = 
        SUBSTRING(cBaseName,1,LENGTH(cBasename) - LENGTH(fExt)).

      RUN adecomm/_osprefx.p (INPUT tmpStr,
                              OUTPUT cFullPath,
                              OUTPUT tmpStr).
      RUN adecomm/_osfext.p (INPUT tmpStr,
                             OUTPUT cKitFileExt).
      ASSIGN 
            cKitFileBase = SUBSTRING(tmpStr,1,LENGTH(tmpStr) - LENGTH(cKitFileExt)).

      /* Checks */
      CASE pAction:
         WHEN cBackup THEN
         DO: /* <dbname>.db must exist */
            IF SEARCH(cFullPath +  cKitFileBase + cKitFileExt) = ?
            THEN pError = YES.
         END.
         WHEN cBackupVerify THEN
         DO: /* <dbname>.db and <dbname>.bku must exist */
            IF SEARCH(cFullPath +  cKitFileBase + cKitFileExt) = ? 
               OR SEARCH(cFullPath + cKitFileBase + cBkUpExt) = ? 
            THEN pError = YES.
         END. /* backupVerify */
         WHEN cRestore THEN
         DO: /* <dbname>.bku must exist */
            IF SEARCH(cFullPath + cKitFileBase + cBkUpExt) = ? 
            THEN pError = YES.
         END. /* restore */
      END CASE.
      IF pError THEN RETURN.

      IF SEARCH(statFile) <> ? THEN OS-DELETE VALUE(statFile).
      IF SEARCH(batFile) <> ? THEN OS-DELETE VALUE(batFile).
      IF SEARCH(yesFile) <> ? THEN OS-DELETE VALUE(yesFile).
      IF CONNECTED(pAlias) THEN 
      DO:
           ASSIGN origConnStat = TRUE.
           RUN adetran/common/_dbmgmt.p 

             (INPUT "DISCONNECT":U, 
              INPUT cBaseMinusExt,
              INPUT pAlias,
              INPUT cBaseMinusExt,
              INPUT ?,
              OUTPUT lError).
      END. /* CONNECTED DB */

      IF NOT CONNECTED(pAlias) THEN 
      DO:

         CASE pAction:
            WHEN cBackup THEN
               /* A successful backup returns info such as:
                *         171 active blocks out of 189 blocks in sonia will be dumped. (6686)
                *         0 bi blocks will be dumped. (6688)
                *         Backup requires 205 blocks (839680 bytes) of media. (6689)
                *         Restore would require 205 blocks (1 Mb) of media. (6699)
                *         Backed up 171 blocks in 00:00:00
                *         Wrote a total of 6 backup blocks using 1 megabytes of media. (5431)
                *         
                *         Backup complete. (3740)
                */
                ASSIGN lAction = '"' + cDLCDir + "{&SLASH}" 
                              + "bin" + "{&SLASH}" 
                              + "_dbutil.exe":U + '" '
                              + " probkup ":U
                              + cFullPath + cKitFileBase + " ":U 
                              + cFullPath + cKitFileBase + cBkUpExt
                              + " >> ":U + statFile
                      cSearchString[1] = "(3740)":U.
            WHEN cBackupVerify THEN
               /* A successful restore verify returns info such as:
                *        This is a full backup of D:\9\ade\sonia.db. (6759)
                *        This backup was taken Thu Aug 20 14:09:12 1998. (6760)
                *        It will require a minimum of 189 blocks to restore. (6763)
                *        Full verify pass started. (3752)
                *        Read 171 blocks in 00:00:00
                *        Full verify successful. (3758)
                */
                ASSIGN lAction = '"' + cDLCDir + "{&SLASH}" 
                              + "bin" + "{&SLASH}" 
                              + "_dbutil.exe":U + '" '
                              + " prorest ":U
                              + cFullPath + cKitFileBase + " ":U 
                              + cFullPath + cKitFileBase + cBkUpExt
                              + " -vf >> ":U + statFile
                      cSearchString[1] = "(3758)":U.
            WHEN cRestore THEN
                /* A successful restore verify returns info such as:
                 *        This is a full backup of D:\temp\sonia.db. (6759)
                 *        This backup was taken Thu Aug 20 14:37:13 1998. (6760)
                 *        It will require a minimum of 189 blocks to restore. (6763)
                 *        Read 171 blocks in 00:00:01
                 */
                 ASSIGN lAction = '"' + cDLCDir + "{&SLASH}" 
                              + "bin" + "{&SLASH}" 
                              + "_dbutil.exe":U + '" ' + " prorest "
                              + cFullPath + cKitFileBase + " ":U 
                              + cFullPath + cKitFileBase + cBkUpExt
                              + " < " + yesFile
                              + " >> ":U + statFile
                        cSearchString[1] = "Read ":U
                        cSearchString[2] = "block":U.
         END CASE.

         ASSIGN
            tmpFile     = cFullPath + "b":U + cKitFileBase + cBkupExt
            cErrorString = "":U.
         IF lAction <> ? AND lAction <> "":U THEN 
         DO:
            OUTPUT STREAM batStream TO VALUE(yesFile).
            PUT STREAM batStream UNFORMATTED "y".
            OUTPUT STREAM batStream CLOSE.
            OUTPUT STREAM batStream TO VALUE(batFile).
            PUT STREAM batStream UNFORMATTED
               cSetDLC
               CHR(10) 
               lAction.
            OUTPUT STREAM batStream CLOSE.

            OS-COMMAND SILENT VALUE(batFile).
            IF SEARCH(batFile) <> ? THEN OS-DELETE VALUE(batFile).
            IF SEARCH(yesFile) <> ? THEN OS-DELETE VALUE(yesFile).

            ASSIGN lError = YES.
            INPUT STREAM sInStream FROM VALUE(statFile) NO-ECHO.


            WHILELOOP:
            DO WHILE TRUE:
               IMPORT STREAM sInStream UNFORMATTED cStatusFileContent.

               DOLOOP:
               DO i = 1 TO 99:
                  IF     cSearchString[i] = "":U 
                     AND cErrorNumber[i] = "":U THEN LEAVE DOLOOP.

                  IF INDEX(cStatusFileContent,cErrorNumber[i]) <> 0 THEN
                  DO:
                     ASSIGN lError = YES.
                            cErrorString = cStatusFileContent.
                     LEAVE WHILELOOP.
                  END. /* found Error */

                  IF INDEX(cStatusFileContent,cSearchString[i]) <> 0 THEN
                  DO:
                     ASSIGN lError = NO.
                     LEAVE WHILELOOP.
                  END. /* found success */
                  ELSE 
                  DO:
                     ASSIGN lError = YES.
                     LEAVE DOLOOP.
                  END. /* found Success */
               END. /* DOLOOP 1-99 */ 
            END. /* WHILELOOP  */

            INPUT STREAM sInStream CLOSE.
            IF SEARCH(statFile) <> ? THEN OS-DELETE VALUE(statFile).
            IF lError THEN
            DO:
               ASSIGN pError = lError.
               RETURN.
            END.  /* error with backup */
         END. /* Valid OS-COMMAND */
         ELSE ASSIGN pError = YES.
      END. /* not connected */
END PROCEDURE /* discOSComamnd */
