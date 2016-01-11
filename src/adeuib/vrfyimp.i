/*********************************************************************
* Copyright (C) 2005,2012 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Check if the file is not a UIB file.
 *
 * Updated: 1-15-98 adams  Added support for remote WebSpeed files
 * Updated: 6-02-98 adams  Added remote analyze logic.
 * Updated: 5-07-99 tsm    Added support for MRU Filelist
 * Update:  6-24-99 tsm    When remote file being opened from MRU File list, use broker url
 *                         to analyze the file rather than the current broker url
 * 
 *
 * I've modified the behavior of the following code block because it was
 * possible to open an xcoded file in the UIB. The block will not allow the
 * Opening or Importing of a file which is xcoded (First char ASC 17) - (gfs)
 *
 * NOTE: This .i is included in _dynsckr.p, _qssuckr.p.
 */
 
DEF VARIABLE SwitchEnvironment AS LOGICAL NO-UNDO. /* if integrated environment, this variable will be no always. */
 
IF AbortImport NE yes THEN DO:
       
  INPUT STREAM _P_QS FROM VALUE(IF web_file THEN web_temp_file ELSE dot-w-file) {&NO-MAP}.
  READ-UIBLINE:
  DO ON ENDKEY UNDO READ-UIBLINE, LEAVE READ-UIBLINE:
    IMPORT STREAM _P_QS _inp_line NO-ERROR.
  END.
  INPUT STREAM _P_QS CLOSE.
  /* Position 5 should contain ADM version, which is ADM2 only, since no other
     templates prior to V9/ADM2 contained the ADM verision in the template header.
     - jpalazzo 3/3/98 */
  adm_version = _inp_line[5].
  
  RUN adecomm/_osfext.p ((IF web_file THEN web_temp_file ELSE dot-w-file), 
                         OUTPUT file_ext ).

  /* If doesn't contain correct procedure header, or it is a .cls file */
  IF NOT (_inp_line[1] = "&ANALYZE-SUSPEND":U AND 
    (_inp_line[3] BEGINS "UIB_v":U OR _inp_line[3] BEGINS "WDT_v":U OR
     _inp_line[3] BEGINS "AB_v":U)) OR File_Ext = ".cls" THEN
  DO ON STOP UNDO, LEAVE:
    /* if not Visual just abort without opening file in another tool */
    IF notVisual THEN 
      ASSIGN AbortImport = YES
             err_msgs = "File is not in {&UIB_NAME} file format.":U.
    ELSE DO:
      /* If the file's extension is .w, call advisor and give user some
         open options. Otherwise, open the file in a Procedure Window,
         no questions asked.
      */
      IF file_ext = ".w":U THEN DO:
        /* Reset the cursor for user input.*/
        RUN adecomm/_setcurs.p ("").
        /* Initialize the choice */
        adv_choice = "_PWIN":U.
      
        IF ASC(SUBSTRING(_inp_line[1],1,1)) = 17 THEN 
          /* likely to be an xcoded file - will not get the option to
           * "load-it-anyway" (gfs)
           */
          RUN adeuib/_advisor.w (
            INPUT  dot-w-file + CHR(10) + CHR(10)
                   + "This file is not in {&UIB_NAME} file format. "
                   + "What do you want the {&UIB_NAME} to do?" ,
            INPUT
  "&Edit. Edit the file in a Procedure Window.,_PWIN,
  &Cancel. Do not open the file.,_CANCEL" ,
            INPUT FALSE,
            INPUT "AB":U,
            INPUT 0,
            INPUT-OUTPUT adv_choice ,
            OUTPUT adv_never ).
        ELSE
          RUN adeuib/_advisor.w (
            INPUT  dot-w-file + CHR(10) + CHR(10)
                   + "This file is not in {&UIB_NAME} file format. "
                   + "What do you want the {&UIB_NAME} to do?" ,
            INPUT
  "&Open. Try to open the file anyway as an {&UIB_NAME} file.,_OPEN,
  &Edit. Edit the file in a Procedure Window.,_PWIN,
  &Cancel. Do not open the file.,_CANCEL" ,
            INPUT FALSE,
            INPUT "AB":U,
            INPUT 0,
            INPUT-OUTPUT adv_choice ,
            OUTPUT adv_never ).
      END. /* if .w */
      ELSE IF CAN-DO(".xmc,.xml,.xmp,.xsd":U, file_ext) THEN
        ASSIGN adv_choice = "_XML":U.
      ELSE ASSIGN adv_choice = "_PWIN":U.
      
      CASE adv_choice:
        WHEN "_PWIN":U THEN DO:
            ASSIGN AbortImport = Yes.
    	    DEFINE VARIABLE lOpenInOEIDE AS LOGICAL NO-UNDO.
    	    
    	    IF OEIDEIsRunning THEN 
    	    DO:
    	        DEFINE VARIABLE cFileName    AS CHARACTER NO-UNDO.
    	        DEFINE VARIABLE cProjectName AS CHARACTER NO-UNDO.
    	        
                /* If the file import_mode is UNTITLED then open the file in OEIDE. */
                IF import_mode = "UNTITLED":U OR
                   import_mode = "WINDOW UNTITLED":U THEN
                    lOpenInOEIDE = TRUE.
                ELSE
                DO:
                    /* Open the file in OEIDE only if it is a project file. */
                    FILE-INFO:FILE-NAME = dot-w-file.
    		      
                    /* Ensure pFileName is a full path */
                    IF FILE-INFO:FULL-PATHNAME <> ? THEN
                        cFileName = FILE-INFO:FULL-PATHNAME.
                    RUN getActiveProjectOfFile IN hOEIDEService (cFileName, OUTPUT cProjectName).
                    
                    /* File is a project file */
                    IF cProjectName > "" THEN
                        lOpenInOEIDE = TRUE.
                END.
            END.
        	  
            IF lOpenInOEIDE THEN
            DO:
              /* Open File in OEIDE Editor */
               openDesignEditor(getProjectName(), dot-w-file).
            END.            
            ELSE
              RUN adecomm/_pwmain.p (INPUT "_ab.p":U  /* PW Parent ID */,
                                 INPUT (dot-w-file + /* Files to open */
                                       (IF NOT web_file THEN "" ELSE CHR(3) + 
                                          web_temp_file + CHR(3) + _BrokerURL +
                                        CHR(3) + cRelPathWeb)),
                                 INPUT IF import_mode = "WINDOW UNTITLED":U
                                       THEN "UNTITLED":U 
                                       ELSE ""   /* PW Command      */).
          /* Update MRU FileList */
          IF _mru_filelist AND import_mode NE "WINDOW UNTITLED":U THEN
            RUN adeshar/_mrulist.p (INPUT (IF web_file THEN open_file ELSE dot-w-file),
                                    INPUT IF web_file THEN _BrokerURL ELSE "").
        END.
        WHEN "_XML":U THEN DO:
          ASSIGN AbortImport = Yes.
        
          RUN adexml/_xmlview.w PERSISTENT SET h_xml.
          RUN initializeObject IN h_xml.
          RUN openFile IN h_xml (dot-w-file + (IF NOT web_file THEN "" ELSE CHR(3) + 
                                 web_temp_file + CHR(3) + _BrokerURL)).
        
          /* Update MRU FileList */
          IF _mru_filelist AND import_mode NE "WINDOW UNTITLED":U THEN
            RUN adeshar/_mrulist.p (dot-w-file, IF web_file THEN _BrokerURL ELSE "").
        END.
        WHEN "_CANCEL":U THEN
          ASSIGN AbortImport = Yes.
      END CASE.  /* Case on adv_choice */
    END.  /* else do - visual */
  END.  /* IF NOT ("&ANALYZE-SUSPEND":U AND BEGINS "UIB_v", "WDT_v" or "AB_v") */
END.  /* If AbortImport NE Yes */

IF AbortImport NE yes THEN DO:
  /* Check to see if correct databases are connected                           */
  INPUT STREAM _P_QS FROM VALUE(IF web_file THEN web_temp_file ELSE dot-w-file) {&NO-MAP}.
  DB-LOOP:
  DO ON ENDKEY UNDO DB-LOOP, LEAVE DB-LOOP:
    IMPORT STREAM _P_QS _inp_line. /* line 1 */
    DO WHILE TRIM(_inp_line[1]) NE "&ANALYZE-RESUME":U: /* gfs: want to skip past Description */
      IMPORT STREAM _P_QS _inp_line.
    END.
    IMPORT STREAM _P_QS _inp_line.
    /* Now on the third line - see if it begins "/* Connected Databases */"       */
    IF _inp_line[1] = "/*":U AND
       _inp_line[2] = "Connected" AND
       _inp_line[3] = "Databases" THEN RUN connect_dbs.
  END. /* DB-LOOP */
  INPUT STREAM _P_QS CLOSE.
END.

IF AbortImport NE yes THEN DO:
  
  /* This might take a while.*/
  RUN adecomm/_setcurs.p ("WAIT":U).
  err_msgs = "".
  
  IF web_File THEN
    RUN analyze_webproc (OUTPUT err_msgs).
  
  ELSE
  DO:   
    ANALYZE VALUE(IF web_file THEN web_temp_file ELSE dot-w-file) 
            VALUE(temp_file)
            OUTPUT VALUE(temp_file + "2":U) NO-ERROR.
  
    /* Was there an analyzer error -- COMPILER:ERROR will be set! */
    IF COMPILER:ERROR THEN DO:
    
     /* Get all the error messages */
      DO i = 1 to ERROR-STATUS:NUM-MESSAGES:
        err_msgs = err_msgs + CHR(10) + ERROR-STATUS:GET-MESSAGE(i).
      END.
      /* Reset the cursor for user input.*/
    END.
  END.
  
  IF err_msgs <> "":U THEN 
  DO:  
    RUN adecomm/_setcurs.p ("").
    MESSAGE (IF import_mode EQ "IMPORT":U 
             THEN "The contents of this file cannot be" 
             ELSE "This file cannot be")
            "analyzed" 
            (IF web_file THEN "remotely" else "")
            "by the {&UIB_NAME}"
            + (IF web_file THEN ' on ' + _brokerURL ELSE '':U)
            + ".":U
             SKIP 
            "Please check these problems in your file or environment:" 
             SKIP err_msgs 
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    AbortImport = yes.
  END. /* Bad file */
END.

IF AbortImport NE yes THEN DO:
  INPUT STREAM _P_QS FROM VALUE(temp_file) {&NO-MAP}.

  READ-LINE1:
  DO ON ENDKEY UNDO READ-LINE1, LEAVE READ-LINE1: 
    _inp_line = "":U.
    IMPORT STREAM _P_QS _inp_line NO-ERROR.
  END.
  ASSIGN FileHeader = _inp_line[1].
  /* .p and .i files don't care about GUI or TTY. We also don't case about
     the type when we are importing. */   
  IF import_mode ne "IMPORT":U AND _inp_line[3] ne "":U THEN DO:
    /* This is one place we need the shared variable _cur_win_type because     */
    /* we don't have an _L record to store the value and _rdwind and _rdfram   */
    /* need to know what we are dealing with.                                  */  
    /* Reset the associated multipliers if the _cur_win_type changes.          */
    IF _cur_win_type ne (CAN-DO("TTY,CHARACTER":U, _inp_line[3]) eq NO)
    THEN ASSIGN _cur_win_type = CAN-DO("TTY,CHARACTER":U, _inp_line[3]) eq NO
                _cur_col_mult = IF _cur_win_type THEN 1 ELSE _tty_col_mult
                _cur_row_mult = IF _cur_win_type THEN 1 ELSE _tty_row_mult
                .

    /* We now know the win-type of this window we are about to open.  If there
       are any other windows open, it better be the same as them otherwise the
       user needs to close them before this load                                */
    FIND _LAYOUT WHERE _LAYOUT._LO-NAME = "Master Layout":U.
    IF _LAYOUT._GUI-BASED NE _cur_win_type THEN DO:
      /* Previously opened .w had different type */
      DEFINE VARIABLE close-them AS LOGICAL NO-UNDO.
      IF OEIDEIsRunning THEN
         SwitchEnvironment = NO.
      ELSE 
      DO:   
            IF CAN-FIND(FIRST _U WHERE CAN-DO("WINDOW,DIALOG-BOX":U,_U._TYPE)
                                 AND CAN-FIND (_P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE
                                                AND _P._FILE-TYPE eq "w":U))
            THEN  SwitchEnvironment = YES.
            ELSE SwitchEnvironment = NO.
      END.
                                                
      IF SwitchEnvironment THEN 
      DO:
        MESSAGE "Existing windows have"
                (IF _LAYOUT._GUI-BASED THEN "GUI" ELSE "CHARACTER") 
                "based layouts." SKIP
                "These windows must be closed, before opening a window that is"
                (IF _cur_win_type THEN "GUI" ELSE "CHARACTER") "based."
                VIEW-AS ALERT-BOX INFORMATION.
        ASSIGN _cur_win_type = NOT _cur_win_type  /* Set it back */
               AbortImport = yes.
      END.  /* If windows exist of the wrong type */
      ELSE _LAYOUT._GUI-BASED = _cur_win_type.
    END.  /* If master layout is set in the wrong way */
  END. /* IF _inp_line[3]... */
  
  IF FileHeader = "_VERSION-NUMBER":U OR FileHeader = "_EXPORT-NUMBER":U THEN DO:
    IF import_mode eq "IMPORT":U THEN DO:
      IF FileHeader = "_VERSION-NUMBER" THEN DO:
        /* Reset the cursor for user input.*/
        RUN adecomm/_setcurs.p ("").
        MESSAGE "The " + dot-w-file + " file contains a" {&SKP}
                "Window or Dialog-box definition.  It cannot be inserted." {&SKP}
                "Do you want to OPEN this file instead?"
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE pressed-ok.
        IF pressed-ok THEN ASSIGN import_mode = "WINDOW":U
                                  _save_file  = dot-w-file.
        ELSE ASSIGN AbortImport = TRUE.
      END. /* opened a .w file */
    END. /* IMPORT */
    ELSE DO: /* mode is open WINDOW or WINDOW UNTITLED */
      IF FileHeader = "_EXPORT-NUMBER":U THEN DO:
        /* Reset the cursor for user input.*/
        RUN adecomm/_setcurs.p ("").
        MESSAGE "The" dot-w-file "file contains {&UIB_NAME} export format." {&SKP}
          "Do you want to INSERT this file?"
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE pressed-ok.
        IF pressed-ok THEN import_mode = "IMPORT":U.
        ELSE ASSIGN AbortImport = TRUE.
      END.  /* opened an UIB export file */
    END. /* mode begins "WINDOW..." */
    
    /* In 7.2A - 7.2D, (UIB_v7r9) we read widgets with a default of
       DISPLAY = no.  In 7.3A (UIB_v7r10) we default the value as being YES.
       So, we can convert a UIB_v7r9 to UIB_v7r10 simply by setting a 
       default_DISPLAY flag.
     */
    file_version = _inp_line[2].  /* Save the file version */
    IF file_version eq "UIB_v7r9":U THEN _inp_line[2] = "UIB_v7r10":U.
                    
    /* In all cases check for version compatability (note, check the modified
       _inp_line[2] and not the original file_version.) */
    IF NOT AbortImport AND _inp_line[2] NE _UIB_VERSION THEN DO:   
      /* Reset the cursor for user input.*/
      RUN adecomm/_setcurs.p ("").  
      AbortImport = TRUE.
          
      CASE ENTRY(1, _inp_line[2], "r":U):
        WHEN "UIB_v7":U THEN DO:
         /* We can load all UIB_v7 revisions... Note that revision 11 was 
            the first one that had query JoinCode's that don't need to be 
            adjusted. */
          AbortImport = FALSE.
          IF INTEGER(ENTRY(2,_inp_line[2],"r":U)) < 11
          THEN ASSIGN adj_joincode  = TRUE.    
        END. 
        WHEN "UIB_v8":U THEN DO: 
          /* Check the revision number. Load any revision number that is
             smaller.  */
          IF INTEGER(ENTRY(2,_inp_line[2],"r":U)) <=
             INTEGER(ENTRY(2,_UIB_VERSION,"r":U)) THEN AbortImport = FALSE.
        END.
        WHEN "UIB_v9":U OR WHEN "AB_v9" THEN DO: 
          /* Check the revision number. Load any revision number that is
             smaller.  */
          IF INTEGER(ENTRY(2,_inp_line[2],"r":U)) <=
             INTEGER(ENTRY(2,_UIB_VERSION,"r":U)) THEN AbortImport = FALSE.
        END.
        WHEN "UIB_v10":U OR WHEN "AB_v10" THEN DO:
          /* Check the revision number. Load any revision number that is
              smaller.  */
          IF INTEGER(ENTRY(2,_inp_line[2],"r":U)) <=
             INTEGER(ENTRY(2,_UIB_VERSION,"r":U)) THEN AbortImport = FALSE.
        END.     
        WHEN "WDT_v1":U THEN
          /* We can load all WebSpeed V1 revisions */
          AbortImport = FALSE.
        WHEN "WDT_v2":U THEN DO:
          /* Check the revision number. Load any revision number that is
             smaller.  */
          IF INTEGER(ENTRY(2, _inp_line[2], "r":U)) <=
             INTEGER(ENTRY(2, _UIB_VERSION, "r":U)) THEN AbortImport = FALSE.
             
          /* Procedure type, and template info, will be stored here on 
             first line, e.g.
             &ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Include Template */
          CREATE _P.
          IF _inp_line[4] ne "":U THEN
            _P._type = (IF _inp_line[4] BEGINS "Web":U THEN "WebObject":U
                        ELSE _inp_line[4]).
          IF _inp_line[5] eq "Template":U THEN
            _P._template = yes.
          _P._file-version = file_version.
        END.
        OTHERWISE AbortImport = TRUE. /* Don't load anything else. */
      END CASE.
      /* Ask the user if they really want to abort the import. */
      IF AbortImport THEN
        MESSAGE dot-w-file + " version is " + file_version + "." {&SKP}
          "It may be incompatible with the current version " + _UIB_VERSION + "."
          {&SKP} "Would you like to continue?"
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE pressed-ok.
      IF pressed-ok THEN ASSIGN AbortImport = FALSE.
    END. /* Version Mismatch */
  END. /* opened a UIB generated file */
END.  /* IF NOT AbortImport */

PROCEDURE analyze_webproc:  
  DEFINE OUTPUT PARAMETER pErrMsg AS CHAR NO-UNDO.
  
  DEFINE VARIABLE QS2file         AS CHAR NO-UNDO.
  DEFINE VARIABLE tempFile2       AS CHAR NO-UNDO.
  DEFINE VARIABLE Errormark       AS CHAR NO-UNDO.
              
  /* If file being opened from MRU File List, need to use MRU broker url to open the
     file rather than the current broker URL - they may not be the same */            
  RUN adeweb/_webcom.w
           (?,
            IF _mru_broker_url NE "" THEN _mru_broker_url ELSE _brokerURL,
            dot-w-file,
            'analyze':U,
            OUTPUT QS2File,
            INPUT-OUTPUT temp_file).
  
  IF RETURN-VALUE <> "" THEN 
  DO:
    ASSIGN 
      ErrorMark = ENTRY(1,RETURN-VALUE," ":U)
              
      pErrMsg   = SUBSTR(RETURN-VALUE,INDEX(RETURN-VALUE,ErrorMark) 
                         + LENGTH(ErrorMark,"CHARACTER":U) + 1).
  END. /* return-value <> '' */
  ELSE IF QS2File <> ? THEN
  DO:
    ASSIGN TempFile2 = temp_file + "2":U.        
    RUN adeweb/_webcom.w
            (?,
             _brokerURL,
             QS2File,
             'open,delete':U,
             OUTPUT QS2File,
             INPUT-OUTPUT TempFile2).             
  END. /* else if qs2file <> ? */ 
             
END PROCEDURE. /* analyze_webproc */ 
  
/* Connect to databases */
PROCEDURE connect_dbs:
  DEFINE VARIABLE choice   AS CHAR           NO-UNDO.
  DEFINE VARIABLE choice2  AS CHAR           NO-UNDO.
  DEFINE VARIABLE ldummy   AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE Db_Pname AS CHAR INITIAL ? NO-UNDO.
  DEFINE VARIABLE Db_Lname AS CHAR INITIAL ? NO-UNDO.
  DEFINE VARIABLE Db_Type  AS CHAR INITIAL ? NO-UNDO.
  
  /* Define help */
  { adeuib/uibhlp.i } /* Help Preprocessor definitions. */
  
  /* Reset the cursor for user input.*/
  RUN adecomm/_setcurs.p ("").

  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line.
  DO WHILE _inp_line[1] NE "*/":
    IF NOT CONNECTED(_inp_line[1]) and not ideSynchSilent THEN
    DO ON STOP UNDO, RETRY:
      IF RETRY THEN DO:
        ASSIGN AbortImport = YES.
        LEAVE.
      END.
      IF notVisual THEN DO:
        ASSIGN AbortImport = YES
               err_msgs = "Not connected to database " + _inp_line[1] + ".":U.
        LEAVE.
      END.
     
      /* if running from ide and we have need a connection and already have a connection then a restart is required \
         (if num-dbs = 0 ide connection will be handled as _connect in next case since it does not requre a restart ) */
      if OEIDE_CanShowMessage() and num-dbs > 0 then
      do:
          choice = "_IDECONNECT":U.  
          RUN adeuib/_advisor.w (
           "The database '" + _inp_line[1] + "' was used by " +
                dot-w-file + " when it was last opened." + CHR(10) +
                CHR(10) + "Would you like to reconnect to this database?",
"&Define the connection in the workbench and restart.,_IDECONNECT," 
+ "&Connect now and define the connection later.,_CONNECT,"
+ "&Open. Try to open the file without connecting.,_LOAD,"
+ "&Cancel. Do not open the file.,_CANCEL" ,
          FALSE,
          "{&UIB_SHORT_NAME}",
          {&Advisor_DB_Connect_on_Open},
          INPUT-OUTPUT choice,
          OUTPUT ldummy ).
      end.
      else  do:
         choice = "_CONNECT":U.     
        RUN adeuib/_advisor.w (
          INPUT "The database '" + _inp_line[1] + "' was used by " +
                dot-w-file + " when it was last opened." + CHR(10) +
                CHR(10) + "Would you like to reconnect to this database?",
          INPUT
"Co&nnect. Connect to '" + _inp_line[1] + "' now.,_CONNECT,
&Open. Try to open the file without connecting.,_LOAD,
&Cancel. Do not open the file.,_CANCEL" ,
          INPUT FALSE,
          INPUT "{&UIB_SHORT_NAME}",
          INPUT {&Advisor_DB_Connect_on_Open},
          INPUT-OUTPUT choice,
          OUTPUT ldummy ).
      end.
      CASE choice:
        WHEN "_CONNECT":U THEN DO:
          ASSIGN Db_Pname = _inp_line[1]
                 Db_Lname = ?
                 Db_Type  = _inp_line[2].
          IF Db_Type = "" OR Db_Type = ? THEN Db_type = "PROGRESS".
          RUN adecomm/_dbconn.p
             (INPUT-OUTPUT  Db_Pname,
              INPUT-OUTPUT  Db_Lname,
              INPUT-OUTPUT  Db_Type).
          ASSIGN AbortImport = (Db_Pname = ?) AND (Db_Lname = ?).
        END. /* _CONNECT */   
        WHEN "_IDECONNECT":U THEN DO:
          ASSIGN Db_Pname = _inp_line[1]
                 Db_Lname = ?
                 Db_Type  = _inp_line[2].
          IF Db_Type = "" OR Db_Type = ? THEN Db_type = "PROGRESS".
          RUN adecomm/_dbconnide.p
             (INPUT-OUTPUT  Db_Pname,
              INPUT-OUTPUT  Db_Lname,
              INPUT-OUTPUT  Db_Type).
          ASSIGN AbortImport = (Db_Pname = ?) AND (Db_Lname = ?).
        END. /* _CONNECT */   
        WHEN "_LOAD":U THEN DO:
          ASSIGN choice2 = "_CANCEL":U.
          RUN adeuib/_advisor.w (
              INPUT "You have choosen to attempt to load " + dot-w-file +
                    " despite not having the correct database(s) connected." +
                    " This will probably cause " + dot-w-file + " to be corrupted." +
                    " However, there may be cases when no harm will be done." +
                    CHR(10) + CHR(10) +
                    "You should not save this file on top of " + dot-w-file +
                    " unless you are certain that no corruption has occurred." +
                    CHR(10) + CHR(10) +
                    "Would you like to continue loading?",
              INPUT
"Co&ntinue.  Continue loading.,_CONTINUE,
&Cancel. Do not load.,_CANCEL",
              INPUT FALSE,          
              INPUT "{&UIB_SHORT_NAME}",
              INPUT {&Advisor_DB_Connect_on_Open},
              INPUT-OUTPUT choice2,
              OUTPUT ldummy ).
          AbortImport = choice2 EQ "_CANCEL".        
        END. /* _LOAD */   
        WHEN "_CANCEL":U THEN AbortImport = YES.
      END CASE.
    END.  /* If not connected */
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.
  END.  /* while not  end of comment */
END PROCEDURE.  /* connect to databases */

/* vrfyimp.i - end of file */


