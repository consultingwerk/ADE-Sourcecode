/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
    File        : acprocs.i
    Syntax      : { adecomp/acprocs.i }
    Description : Application Compiler Tool - Internal procedures.

    Author      : J. Palazzo and W. Bare
    Created     : 03/16/93
    
    Last Modified:
        tammys    02/15/1999 Removed code that forces logfile to have .log ext
*/

PROCEDURE UpdateList .

/* This function exists to limit the platform differences in displaying
 * the list.
 */
DEFINE VARIABLE Return_Value AS LOGICAL NO-UNDO.


&IF "{&OPSYS}" = "VMS" &THEN
	&SCOPED-DEFINE ROOT-DIRECTORY "[]"
&ELSE
	&SCOPED-DEFINE ROOT-DIRECTORY "."
&ENDIF

    OPEN QUERY Qry_ListItem FOR EACH ListItem.
    IF AVAILABLE ListItem THEN
    DO:
        REPOSITION Qry_ListItem TO RECID RECID( ListItem ).
        ASSIGN Return_Value = BROWSE b_Compile:SELECT-FOCUSED-ROW() NO-ERROR.
    END.
END.
PROCEDURE GetPropath .
    DEFINE VAR Items_Selected AS CHAR .
    DEFINE VAR Return_Status  AS LOGICAL INIT ? .
    DEFINE VAR Last_File      AS CHAR.
    DEFINE VAR l-dupe         AS LOGICAL.

    DO ON STOP UNDO, LEAVE :
        RUN adecomp/_ppath.p ( INPUT-OUTPUT Items_Selected ,
                               OUTPUT Return_Status ) .
        IF ( Return_Status = ? ) OR ( Items_Selected = ? )
        THEN RETURN.
        DO Counter = 1 TO NUM-ENTRIES( Items_Selected ) :
            Last_File = ENTRY(Counter, Items_Selected).
            RUN CheckDupeItem ( INPUT Last_File , OUTPUT l-dupe ).
            IF l-dupe = TRUE THEN NEXT.
            RUN CreateListItem ( INPUT Last_File,
                                 INPUT s_fspecSaved ) .
        END.

        RUN UpdateList.
        RUN EnableStart ( INPUT YES ).
    END.
    RUN SetDefaults ( INPUT win_Promake ).
END.

PROCEDURE CheckDupeItem .
    DEFINE INPUT  PARAMETER p_File_Spec AS CHAR               NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Duplicate AS LOGICAL INIT FALSE NO-UNDO.
    
    DEFINE BUFFER bListItem FOR ListItem.
    
    DO:
        FIND bListItem WHERE bListItem.File_Spec = p_File_Spec NO-ERROR.
        IF NOT AVAILABLE bListItem THEN RETURN.
        MESSAGE p_File_Spec SKIP
                "Cannot add to compile list." SKIP(1)
                "This file specification is already in the compile" SKIP
                "list and cannot be added again."
                VIEW-AS ALERT-BOX WARNING.
        p_Duplicate = TRUE.
    END.
END PROCEDURE.
    

PROCEDURE AddListItem .
    DEFINE VAR vFile_Spec     AS CHAR.
    DEFINE VAR vProc_Types    AS CHAR.
    DEFINE VAR vReturn_Status AS LOGICAL INIT ?.
    DEFINE VAR l-dupe         AS LOGICAL.
    
    vProc_Types = s_fspecSaved. /* Default */
    REPEAT ON STOP UNDO, LEAVE:
        RUN adecomp/_fspec.p
                    ( INPUT-OUTPUT vFile_Spec , 
                      INPUT-OUTPUT vProc_Types ,
                      OUTPUT vReturn_Status ) .
        IF ( vReturn_Status = ? ) THEN LEAVE.
        RUN CheckDupeItem ( INPUT vFile_Spec , OUTPUT l-dupe ).
        IF l-dupe = FALSE THEN LEAVE.
        ELSE NEXT.
    END.
    RUN SetDefaults ( INPUT win_Promake ).
    IF ( vReturn_Status = ? ) THEN RETURN.
    RUN CreateListItem ( INPUT vFile_Spec , INPUT vProc_Types ).
    RUN UpdateList.
    RUN EnableStart ( INPUT YES ).
END.

PROCEDURE ModifyListItem .
    DEFINE VAR vFile_Spec     AS CHAR.
    DEFINE VAR vProc_Types    AS CHAR.
    DEFINE VAR vReturn_Status AS LOGICAL INIT ?.
    DEFINE VAR l-dupe         AS LOGICAL.
    
    vFile_Spec  = ListItem.File_Spec.
    vProc_Types = ListItem.Proc_Types.

    REPEAT ON STOP UNDO, LEAVE:
        RUN adecomp/_fspec.p
                    ( INPUT-OUTPUT vFile_Spec , 
                      INPUT-OUTPUT vProc_Types ,
                      OUTPUT vReturn_Status ) .
        /* If user pressed Cancel or left the File Spec unchanged,
           then don't check for duplicate entry.
        */
        IF ( vReturn_Status = ? ) OR vFile_Spec = ListItem.File_Spec
            THEN LEAVE.
        RUN CheckDupeItem ( INPUT vFile_Spec , OUTPUT l-dupe ).
        IF l-dupe = FALSE THEN LEAVE.
        ELSE NEXT.
    END.
    RUN SetDefaults ( INPUT win_Promake ).
    IF ( vReturn_Status = ? ) THEN RETURN.
    ASSIGN ListItem.File_Spec  = vFile_Spec
           ListItem.Proc_Types = vProc_Types
    . /* END ASSIGN */

    DISPLAY ListItem WITH BROWSE B_Compile .
    ASSIGN vReturn_Status = BROWSE b_Compile:SELECT-FOCUSED-ROW().
END.
    
PROCEDURE DeleteListItem .
    DEFINE VARIABLE Return_Value AS LOGICAL NO-UNDO.

    IF NOT AVAILABLE ListItem
    THEN DO:
        BELL.
        RETURN.
    END.

    DELETE ListItem.

    RUN UpdateList.    

    IF NOT AVAILABLE ListItem
    THEN DO:
        APPLY "ENTRY" TO btn_Add IN FRAME main.
        RUN EnableStart ( INPUT NO ).
    END.

END.

PROCEDURE EnableStart .
    DEFINE INPUT PARAMETER p_Enabled AS LOGICAL.
    
    DO WITH FRAME main:
      ASSIGN btn_Modify:SENSITIVE         = p_Enabled
             btn_Delete:SENSITIVE         = p_Enabled
             btn_Start_Compile:SENSITIVE  = p_Enabled
             MENU-ITEM _Start:SENSITIVE   IN MENU mnu_Compile = p_Enabled
             MENU-ITEM m_Modify:SENSITIVE IN MENU mnu_Popup = btn_Modify:SENSITIVE
             MENU-ITEM m_Delete:SENSITIVE IN MENU mnu_Popup = btn_Delete:SENSITIVE
             MENU-ITEM m_StartComp:SENSITIVE IN MENU mnu_Popup = btn_Start_Compile:SENSITIVE
      . /* END ASSIGN */
    END.
END .

PROCEDURE CreateListItem .
    DEFINE INPUT PARAMETER p_File_Spec        AS CHAR .
    DEFINE INPUT PARAMETER p_Proc_Types AS CHAR .

    /* No Duplicates allowed */

    FIND FIRST ListItem WHERE ListItem.File_Spec = p_File_Spec NO-ERROR.

    IF NOT AVAILABLE ListItem THEN DO:

      CREATE ListItem .
      ASSIGN ListItem.File_Spec = p_File_Spec
             ListItem.Proc_Types = p_Proc_Types
      . /* END ASSIGN */

    END.
END PROCEDURE.


PROCEDURE InitListItems .
    DEFINE VAR vFile_Spec   AS CHARACTER .
    DEFINE VAR vProc_Types  AS CHARACTER .
    DEFINE VAR Compile_List AS CHARACTER .
    
    IF ( s_fspec = ? )
    THEN DO: 

/****
        Compile_List = PROPATH .

        DO Counter = 1 TO NUM-ENTRIES( Compile_List ) :
            /* For the initial list, skip the $DLC directories. */
            IF ENTRY( Counter , PROPATH ) BEGINS OS-GETENV("DLC")
            THEN NEXT.
            vFile_Spec = ENTRY( Counter , Compile_List ) .
            IF ( vFile_Spec = "" ) /* Current-Dir */
                THEN vFile_Spec = {&ROOT-DIRECTORY} .

	    RUN CreateListItem (vFile_Spec, s_FspecSaved).
        END. /* Counter */
*****/
        RUN CreateListItem({&ROOT-DIRECTORY}, "*.p *.w *.cls").

    END.
    ELSE DO:

        IF LENGTH(s_fspec) = 0 THEN
	    RUN CreateListItem({&ROOT-DIRECTORY}, "*.p *.w *.cls").
        ELSE DO:
            Compile_List = s_fspec.
            /* Compile_List is pairs of File_Spec,Proc_Types, so increment by
             * 2.
             */
            DO Counter = 1 TO NUM-ENTRIES( Compile_List ) BY 2 :
                vFile_Spec = ENTRY( Counter , Compile_List ) .
                IF ( vFile_Spec = "" ) /* Current-Dir */
                    THEN vFile_Spec = {&ROOT-DIRECTORY} .
                        /* When last item in list has no Proc Type, it must
                         * be a File name.  This checks for this and handles
                         *it. 
                         */
                IF Counter = NUM-ENTRIES ( Compile_List )
                    THEN vProc_Types = "".
                ELSE vProc_Types = ENTRY( Counter + 1 , Compile_List ).
                RUN CreateListItem(vFile_Spec, vProc_Types).

            END. /* Counter */
        END. /* ELSE */
    END.
END .


PROCEDURE GetSetUp.ip.

  DEFINE VAR V As CHAR.
  DEFINE VAR Settings_NotRead AS LOGICAL INIT TRUE.
  DEFINE VARIABLE vSpecLoop AS INTEGER INIT 0  NO-UNDO.

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:

  USE "" NO-ERROR.
  RUN adecomm/_setcurs.p ("WAIT").

  DO vSpecLoop = 1 to 99:
    GET-KEY-VALUE SECTION {&CompSect} KEY "FileSpec" + STRING(vSpecLoop,"99") VALUE v.
    IF v = ? THEN LEAVE.
    s_fspec = s_fspec + "," + v.
  END.
  /* Remove leading comma */
  SUBSTR(s_fspec,1,1) = "".

  GET-KEY-VALUE SECTION {&CompSect} KEY "DefFileSpec" VALUE s_fspecSaved.
  GET-KEY-VALUE SECTION {&CompSect} KEY "LogFile" VALUE s_logfile.
  GET-KEY-VALUE SECTION {&CompSect} KEY "ShowStatus" VALUE v.
  s_Show_Status = v = ? OR v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "SaveSettings" VALUE v.
  s_Save_Settings = v = ? OR v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "RemoveOldRs" VALUE v.
  s_rmoldr      = v = ? OR v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "IfNoR" VALUE v.
  s_ifnor       = v NE ? AND v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "SubDirs" VALUE v.
  s_subdirs     = v = ? OR v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "SaveNewRs" VALUE v.
  s_saver       = v = ? OR v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "SaveInto" VALUE s_saveinto.
  GET-KEY-VALUE SECTION {&CompSect} KEY "Xref" VALUE s_xref.
  GET-KEY-VALUE SECTION {&CompSect} KEY "XrefAppend" VALUE v.
  s_xappend     = v NE ? AND v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "ListFile" VALUE s_listing.
  GET-KEY-VALUE SECTION {&CompSect} KEY "ListAppend" VALUE v.
  s_lappend     = v NE ? AND v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "PageLength" VALUE v.
  s_lplen       = IF v = ? THEN {&def_lplen} ELSE INTEGER (v).
  GET-KEY-VALUE SECTION {&CompSect} KEY "PageWidth" VALUE v.
  s_lpwid       = IF v = ? THEN {&def_lpwid} ELSE INTEGER (v).
  GET-KEY-VALUE SECTION {&CompSect} KEY "Languages" VALUE s_languages.
  GET-KEY-VALUE SECTION {&CompSect} KEY "EncryptKey" VALUE s_encrkey.
  GET-KEY-VALUE SECTION {&CompSect} KEY "DebugFile" VALUE s_debuglist.
  GET-KEY-VALUE SECTION {&CompSect} KEY "V6Frame" VALUE s_V6Frame.
  GET-KEY-VALUE SECTION {&CompSect} KEY "StreamIO" VALUE v.
  s_stream_io   = v NE ? AND v BEGINS "Y".
  GET-KEY-VALUE SECTION {&CompSect} KEY "MinRcodeSize" VALUE v.
  s_minsize     = v NE ? AND v BEGINS "Y".
  &IF {&CompileOn91C} &THEN
  GET-KEY-VALUE SECTION {&CompSect} KEY "GenerateMD5" VALUE v.
  s_gen_md5     = v NE ? AND v BEGINS "Y".
  &ENDIF  /* {&CompileOn91C} */

  ASSIGN Settings_NotRead = FALSE.

  END. /* DO ON STOP */

  if (s_fspecSaved = ?) then s_fspecSaved = {&def_fspecSaved} .
  if (s_logfile = ?) /* OR NOT s_logfile MATCHES "*~~.log" */
                        then s_logfile    = {&def_logfile} .
  if (s_saveinto = ?)   then s_saveinto   = {&def_saveinto} .
  if (s_xref = ?)       then s_xref       = {&def_xref} .
  if (s_listing = ?)    then s_listing    = {&def_listing} .
  if (s_languages = ?)  then s_languages  = {&def_languages} .
  if (s_v6frame   = ?)  then s_v6frame    = {&def_v6frame} .
  if (s_stream_io = ?)  then s_stream_io  = {&def_stream_io} .
  if (s_encrkey = ?)    then s_encrkey    = {&def_encrkey} .
  if (s_debuglist = ?)  then s_debuglist  = {&def_debuglist} .
  
  RUN adecomm/_setcurs.p ("").

  /* Report any saving error! */
  IF Settings_NotRead
  THEN MESSAGE "Application Compiler settings were not read."
     VIEW-AS ALERT-BOX ERROR BUTTONS OK.

END.

PROCEDURE PutSetUp.ip.
  DEFINE BUFFER buf_ListItem FOR ListItem.
  DEFINE VAR Settings_NotSaved AS LOGICAL INIT TRUE.
  DEFINE VARIABLE vSpecLoop AS INTEGER INIT 0  NO-UNDO.
  /* DEFINE VAR v AS CHAR. */

  RUN adecomm/_setcurs.p ("WAIT").

  DO ON STOP UNDO , LEAVE ON ERROR UNDO , LEAVE:

    USE "" NO-ERROR.
    
    FOR EACH buf_ListItem vSpecLoop = 1 to 99:
      RUN PutKeyVal.ip ("FileSpec" + STRING(vSpecLoop,"99"),
        buf_ListItem.File_Spec + "," + buf_ListItem.Proc_Types).
    END.
    RUN PutKeyVal.ip ("FileSpec" + STRING(vSpecLoop + 1 ,"99"),?).
  
    RUN PutKeyVal.ip ("DefFileSpec",s_fspecSaved).
    RUN PutKeyVal.ip ("LogFile",s_logfile).
    RUN PutKeyVal.ip ("ShowStatus",STRING (s_Show_Status)).
    RUN PutKeyVal.ip ("SaveSettings",STRING (s_Save_Settings)).
    RUN PutKeyVal.ip ("RemoveOldRs",STRING (s_rmoldr)).
    RUN PutKeyVal.ip ("IfNoR",STRING (s_ifnor)).
    RUN PutKeyVal.ip ("SubDirs",STRING (s_subdirs)).
    RUN PutKeyVal.ip ("SaveNewRs",STRING (s_saver)).
    RUN PutKeyVal.ip ("SaveInto",s_saveinto).
    RUN PutKeyVal.ip ("Xref",s_xref).
    RUN PutKeyVal.ip ("XrefAppend",STRING (s_xappend)).
    RUN PutKeyVal.ip ("ListFile",s_listing).
    RUN PutKeyVal.ip ("ListAppend",STRING (s_lappend)).
    RUN PutKeyVal.ip ("PageLength",STRING(s_lplen)).
    RUN PutKeyVal.ip ("PageWidth",STRING(s_lpwid)).
    RUN PutKeyVal.ip ("Languages",s_languages).
    RUN PutKeyVal.ip ("V6Frame", STRING(s_V6Frame) ).
    RUN PutKeyVal.ip ("StreamIO", STRING(s_stream_io) ).
    RUN PutKeyVal.ip ("EncryptKey",s_encrkey).
    RUN PutKeyVal.ip ("MinRcodeSize",STRING (s_minsize)).
    RUN PutKeyVal.ip ("DebugFile",s_debuglist).
    &IF {&CompileOn91C} &THEN
    RUN PutKeyVal.ip ("GenerateMD5",STRING (s_gen_md5)).
    &ENDIF  /* {&CompileOn91C} */
    
    ASSIGN Settings_NotSaved = FALSE.

  END. /* DO ON STOP */
  
  RUN adecomm/_setcurs.p ("").

  /* Report any saving error! */
IF Settings_NotSaved
THEN RUN adeshar/_puterr.p (INPUT "Application Compiler" ,
                            INPUT win_Promake ).

END.


PROCEDURE DlgOptions .

  
  DEFINE BUTTON b_OK   LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO .
  DEFINE BUTTON b_Cancel LABEL "Cancel" 
    {&STDPH_OKBTN} AUTO-ENDKEY .
  DEFINE BUTTON b_Reset LABEL "&Defaults" 
    {&STDPH_OKBTN} .
  DEFINE BUTTON b_HELP LABEL "&Help" 
    {&STDPH_OKBTN} .

  /* Dialog Button Box */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE DLG_Btn_Box    {&STDPH_OKBOX}.
  &ENDIF

  /* Dialog Box */    
    

  FORM
    SKIP( {&TFM_WID} )
    s_fspecSaved COLON 23 {&STDPH_FILL} SKIP( {&VM_WID} )
    s_logfile    COLON 23 {&STDPH_FILL} SKIP( {&VM_WID} )
    s_saveinto   COLON 23 {&STDPH_FILL} SKIP( {&VM_WID} )
    s_languages  COLON 23 {&STDPH_FILL} SKIP( {&VM_WID} ) 
    s_V6Frame    COLON 23 {&STDPH_FILL}
                 &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                 /* Workaround for Character bug 94-07-28-050 */
                 VIEW-AS FILL-IN SIZE 20 BY 1
                 &ENDIF
                 SKIP( {&VM_WID} ) 
    s_stream_io  COLON 23 {&STDPH_FILL} SKIP( {&VM_WIDG}) 
    s_listing    COLON 23 {&STDPH_FILL} s_lappend   SKIP( {&VM_WID} )
    s_lpwid      AT 25    {&STDPH_FILL} s_lplen {&STDPH_FILL} SKIP( {&VM_WIDG})
    s_xref       COLON 23 {&STDPH_FILL} s_xappend             SKIP( {&VM_WID} )
    s_debuglist  COLON 23 {&STDPH_FILL} SKIP( {&VM_WID} )
    s_encrkey    COLON 23 {&STDPH_FILL} SKIP( {&VM_WID} )
    s_minsize    COLON 23 {&STDPH_FILL} &IF {&CompileOn91C} &THEN SKIP( {&VM_WID} )
    s_gen_md5    COLON 23 {&STDPH_FILL}
    &ENDIF  /* {&CompileOn91C} */    
    { adecomm/okform.i
        &BOX    ="DLG_Btn_Box"
        &OK     ="b_OK"
        &CANCEL ="b_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) b_Reset"
        &HELP   ="b_Help" 
    }
    WITH FRAME Options TITLE "Compiler Options" SIDE-LABELS 
         VIEW-AS dialog-box
                 DEFAULT-BUTTON b_OK
                 CANCEL-BUTTON  b_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME Options"
        &BOX    = "DLG_Btn_Box"
        &OK     = "b_OK"
        &CANCEL = "b_Cancel"
        &OTHER  = "b_Reset"
        &HELP   = "b_Help"
    }
  
  ON HELP OF FRAME Options ANYWHERE
  DO:
    DO ON STOP UNDO, LEAVE:
      RUN adecomm/_adehelp.p
          ( INPUT "comp" ,
            INPUT "CONTEXT" , 
            INPUT {&Options_Dialog_Box} , INPUT ? ).
    END.    
  END.

  ON CHOOSE OF b_Help IN FRAME Options
  DO:
    DO ON STOP UNDO, LEAVE:
      RUN adecomm/_adehelp.p
          ( INPUT "comp" ,
            INPUT "CONTEXT" , 
            INPUT {&Options_Dialog_Box} , INPUT ? ).
    END.    
  END.

  ON WINDOW-CLOSE OF FRAME Options
  DO:
    APPLY "END-ERROR" TO FRAME Options.
    RETURN NO-APPLY.
  END.
  
  /* The default button redisplays the original "factory" settings of the
     dialog options. */
  ON choose OF b_reset IN FRAME options
  DO:
        
    ASSIGN
      s_fspecSaved:SCREEN-VALUE = {&def_fspecSaved}
      s_logfile:SCREEN-VALUE    = {&def_logfile}
      s_saveinto:SCREEN-VALUE   = {&def_saveinto}
      s_languages:SCREEN-VALUE  = {&def_languages}
      s_V6Frame:SCREEN-VALUE    = string( {&def_v6frame} )
      s_stream_io:SCREEN-VALUE  = string( {&def_stream_io} )
      s_listing:SCREEN-VALUE    = {&def_listing}
      s_lappend:SCREEN-VALUE    = string( {&def_lappend} )
      s_lpwid:SCREEN-VALUE      = string( {&def_lpwid} )
      s_lplen:SCREEN-VALUE      = string( {&def_lplen} )
      s_xref:SCREEN-VALUE       = {&def_xref}
      s_xappend:SCREEN-VALUE    = string( {&def_xappend} )
      s_debuglist:SCREEN-VALUE  = {&def_debuglist}
      s_encrkey:SCREEN-VALUE    = {&def_encrkey}
      s_minsize:SCREEN-VALUE    = string( {&def_minsize} )
      &IF {&CompileOn91C} &THEN
      s_gen_md5:SCREEN-VALUE    = STRING( {&def_gen_md5} )
      &ENDIF  /* {&CompileOn91C} */
      .  
  END.

  DO ON stop undo, leave on endkey undo, leave on error undo, leave:
                     
    &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    /* Workaround for Character bug 94-07-28-050 */
    DISPLAY s_V6Frame WITH FRAME options.
    &ENDIF

    UPDATE
      s_fspecSaved
      s_logfile
      s_saveinto
      s_languages
      s_V6Frame     WHEN ( SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" )
      s_stream_io
      s_listing
      s_lappend
      s_lpwid
      s_lplen
      s_xref
      s_xappend
      s_debuglist
      s_encrkey
      s_minsize
      &IF {&CompileOn91C} &THEN
      s_gen_md5
      &ENDIF  /* {&CompileOn91C} */
      
      b_ok b_cancel b_reset b_help {&WHEN_HELP}
      WITH FRAME options.
      
    ASSIGN
      s_logfile   = TRIM(s_logfile)
      s_saveinto  = TRIM(s_saveinto)
      s_listing   = TRIM(s_listing)
      s_xref      = TRIM(s_xref)
      s_debuglist = TRIM(s_debuglist)
      .
    
    IF s_minsize = ? THEN
        s_minsize = {&def_minsize}.

    &IF {&CompileOn91C} &THEN
    IF s_gen_md5 = ? THEN
        s_gen_md5 = {&def_gen_md5}.
    &ENDIF  /* {&CompileOn91C} */
  end. /* do */ 
  
  RUN SetDefaults ( INPUT win_Promake ).
END. /* PROCEDURE */


PROCEDURE StartCompile.

  DEFINE BUFFER buf_ListItem FOR ListItem.
  DEFINE VAR    Counter AS INTEGER.
  DEFINE VAR    v_EndMessage AS CHAR NO-UNDO.
  DEFINE VAR    v_RelPath    AS CHAR NO-UNDO.
  DEFINE VAR    v_SavedPP    AS CHAR NO-UNDO.

  DEFINE VAR    v_CurEntry   AS CHAR NO-UNDO.
  DEFINE VAR    v_TmpProPath AS CHAR NO-UNDO.

  ON HELP OF FRAME EditorDisplay ANYWHERE
  DO:
    DO ON STOP UNDO, LEAVE:
      RUN adecomm/_adehelp.p
          ( INPUT "comp" ,
            INPUT "CONTEXT" , 
            INPUT {&Results_Dialog_Box} , INPUT ? ).
    END.    
  END.

  ON CHOOSE OF b_CompileHelp IN FRAME EditorDisplay
  DO:
    DO ON STOP UNDO, LEAVE:
      RUN adecomm/_adehelp.p
          ( INPUT "comp" ,
            INPUT "CONTEXT" , 
            INPUT {&Results_Dialog_Box} , INPUT ? ).
    END.    
  END.

  ASSIGN
    INPUT FRAME main s_subdirs
    INPUT FRAME main s_ifnor
    INPUT FRAME main s_saver
    INPUT FRAME main s_rmoldr
  . /* END ASSIGN */


  _COMPILE-BLOCK:
  DO ON STOP UNDO, LEAVE:

  STATUS INPUT "Compiling Procedure List..." IN WINDOW win_Promake.
  
  if s_listing > "" AND not s_lappend then
  do on stop  undo, retry
     on error undo, retry:
    if not retry then output to VALUE(s_listing) {&NO-MAP}.
    output close.
    if retry
    then do:
       run AlertError( input 1 /* p_Msg_Num */ , 
                       input {&COMP_NAME} ,
                       input s_listing ,
                       input win_Promake ) .
       leave _COMPILE-BLOCK.
    end.
  end.

  if s_xref > "" AND not s_xappend then
  do on stop  undo, retry
     on error undo, retry:
    if not retry then output to VALUE(s_xref) {&NO-MAP}.
    output close.
    if retry
    then do:
       run AlertError( input 1 /* p_Msg_Num */ , 
                       input {&COMP_NAME} ,
                       input s_xref ,
                       input win_Promake ) .
       leave _COMPILE-BLOCK.
    end.
  end.

  /* trunc the log file */
  if s_logfile > "" then
  do on stop  undo, retry
     on error undo, retry:
    if not retry then output to VALUE(s_logfile) {&NO-MAP}.
    output close.
    if retry
    then do:
       run AlertError( input 1 /* p_Msg_Num */ , 
                       input {&COMP_NAME} ,
                       input s_logfile ,
                       input win_Promake ) .
       leave _COMPILE-BLOCK.
    end.
  end.

  ASSIGN
    s_CompCount = 0
    v_editorOut:READ-ONLY in frame EditorDisplay = yes
    v_editorOut:SENSITIVE in frame EditorDisplay = no
    v_editorOut:screen-value in frame EditorDisplay = "".

  IF ( s_Show_Status = YES )
  THEN DO:
      enable v_EditorOut b_CompileCancel b_CompileHelp {&WHEN_HELP}
          with frame EditorDisplay.
      VIEW FRAME EditorDisplay.
      APPLY "ENTRY" TO b_CompileCancel IN FRAME EditorDisplay.
  END.

/* Per the note above, you'd have to remove the reference to the buffer
   buf_ListItem and pass a comma-delimited list of File Spec and File types
   to make this an external .p compiler. 
*/
  IF ( s_Show_Status = NO )
      THEN RUN adecomm/_setcurs.p ("WAIT").
  FOR EACH buf_ListItem: 
    ASSIGN
      v_RelPath = ""
      s_ProPathDir = ""
      v_TmpProPath = PROPATH
      FILE-INFO:FILENAME = buf_ListItem.File_Spec.

    /* Is it a Directory? */
    IF INDEX( FILE-INFO:FILE-TYPE , "D" ) > 0
    THEN DO:

      /*
      ** NOTE: Please do not change this code without reading
      ** the comments at the top of _procomp.p.
      */

      /* Get the longest PROPATH entry that matches this dir */
      DO t_int = 1 to num-entries(vQualifiedProPath):
        v_CurEntry = ENTRY(t_Int,vQualifiedProPath).
        IF FILE-INFO:FULL-PATHNAME BEGINS v_CurEntry
          AND LENGTH(v_CurEntry) > LENGTH(s_ProPathDir) THEN
          ASSIGN
          v_RelPath = SUBSTR(FILE-INFO:FULL-PATHNAME,LENGTH(v_CurEntry) + 2)
          s_ProPathDir = v_CurEntry
          /* Make new propath with this entry first */
          v_TmpProPath = vQualifiedProPath
          ENTRY(t_int,v_TmpProPath) = ""
          v_TmpProPath = s_ProPathDir + "," + TRIM(REPLACE(v_TmpProPath,",,",","),",").
      END.

      /* If nothing found in propath, it is an absolute name */
      IF v_RelPath = "" AND s_ProPathDir = "" THEN
        ASSIGN
        v_RelPath = buf_ListItem.File_Spec
        s_PropathDir = "".
            
      ASSIGN
        v_SavedPP = PROPATH
        PROPATH = v_TmpProPath.
            
      /*----------------------------------------------------------- 
         If more than one filter/extension wildcard given, pass
         each individually. Wildcard entries are separated by 
         spaces. 
      -----------------------------------------------------------*/
      DO Counter = 1 TO NUM-ENTRIES( buf_ListItem.Proc_Types , " " )
          ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE
          ON STOP  UNDO, LEAVE ON QUIT, LEAVE:
        s_fspec = ENTRY ( Counter , buf_ListItem.Proc_Types , " " ).
        /* add the rel path to the fspec */
        IF v_RelPath > "" THEN
        RUN adecomm/_osfmush.p (v_RelPath, s_fspec, output s_fspec).
        RUN adecomp/_compile.p.
      END.
      PROPATH = v_SavedPP.
      NEXT.
    END.
    /* Is it a single OS File or even anything else? */
    ELSE /* FILE-INFO:FILE-TYPE = "F" or something else. */
    DO  ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE
        ON STOP  UNDO, LEAVE ON QUIT, LEAVE:
      s_fspec = buf_ListItem.File_Spec.
      /*---------------------------------------------------------- 
         Relative to PROPATH, or full path required. So blank out
         the Propath dir - its already part of .File_Spec. 
      ---------------------------------------------------------- */
      s_PropathDir = "".
      RUN adecomp/_compile.p.
      NEXT.
    END.
  END. /* FOR EACH */
  RUN adecomm/_setcurs.p ("").

  IF s_CompCount = 0 THEN
    v_EndMessage = CHR(10) + IF (s_saver AND s_ifnor)
                             THEN "No files were compiled."
                             ELSE "No files were found.".
  ELSE /* was the compile canceled */
  IF s_CompCount = -1 THEN
    v_EndMessage = CHR(10) + "Compilation cancelled by user.".

  IF ( s_Show_Status = NO )
  THEN DO:
      enable v_EditorOut b_CompileCancel b_CompileHelp {&WHEN_HELP}
          with frame EditorDisplay.
      VIEW FRAME EditorDisplay.
  END.

  /* Finished message is displayed only if compilation was not cancelled. */
  ASSIGN
    v_EndMessage = v_EndMessage + CHR(10) + "Compilation Finished."
                   when s_CompCount <> -1
    t_log = v_EditorOut:INSERT-STRING(v_EndMessage) in frame EditorDisplay.
    b_CompileCancel:sensitive in frame EditorDisplay = no.

  STATUS INPUT "Compilation complete." IN WINDOW win_Promake.

  do on stop undo, leave on error undo, leave on endkey undo, leave:
    UPDATE b_ViewOK GO-ON( WINDOW-CLOSE ) WITH FRAME EditorDisplay.
  end.

  END. /* DO ON STOP */

  hide frame EditorDisplay NO-PAUSE.
  APPLY "ENTRY" TO btn_Start_Compile IN FRAME main.
  RUN SetDefaults ( INPUT win_Promake ).
   
END PROCEDURE.

PROCEDURE AlertError.
/*----------------------------------------------------------------------------
  Purpose     : Display Alert-box messages for Application Compiler messages.

  Syntax      :
                  RUN AlertError( INPUT p_Msg_Num , 
                                  INPUT p_Title   ,
                                  INPUT p_File    ,
                                  INPUT p_Window ) .

  Description :

  Author      : J. Palazzo
----------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Msg_Num AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER p_Title   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_File    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_Window  AS WIDGET    NO-UNDO.
  
  CASE p_Msg_Num :
  
    WHEN 1          /* Cannot open a file for output. */
      THEN MESSAGE
            p_File SKIP
            "Cannot open file for output. Compilation cancelled." SKIP(1)
            "Please verify that the path and filename specified" skip
            "are valid and that the file is not read-only."
            VIEW-AS ALERT-BOX ERROR IN WINDOW p_Window.
  END CASE.
  
END PROCEDURE.


PROCEDURE _RunProc.
/*----------------------------------------------------------------------------
  Purpose     : Runs an external .p from Compiler Tool.  Ensures tool is
                properly disabled/enabled.

  Syntax      :
                  RUN _RunProc( INPUT  p_Program_Name ) .

  Description :

  Author      : J. Palazzo
----------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Program_Name  AS CHARACTER NO-UNDO.

       REPEAT ON STOP UNDO, RETRY:
           IF NOT RETRY
           THEN DO:
               &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
               RUN disable_widgets.
               &ENDIF
               RUN VALUE( p_Program_Name ).
           END.
           &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
           RUN enable_widgets.
           &ENDIF
           LEAVE.
       END.

END PROCEDURE.


PROCEDURE disable_widgets .
  /*--------------------------------------------------------------------------
    Purpose:     Routine called from Tools Menu to disable compiler
                 before running ADE Tool.
    
    Run Syntax:  RUN disable_widgets .
    Parameters:  None.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  /* Unset global active ade tool procedure handle. */
  ASSIGN h_ade_tool = ?.
  RUN EnableTool ( INPUT win_Promake , INPUT FALSE /* p_Enabled */ ).
    
END.


PROCEDURE enable_widgets.
  /*--------------------------------------------------------------------------
    Purpose:     Routine called from Tools Menu to enable compiler
                 after running ADE Tool.
    
    Run Syntax:  RUN disable_widgets .
    Parameters:  None.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  /* Set global active ade tool procedure handle to this tool. */
  ASSIGN h_ade_tool = THIS-PROCEDURE.
  RUN EnableTool ( INPUT win_Promake , INPUT TRUE /* p_Enabled */ ).
    
END.


PROCEDURE EnableTool .
  /*--------------------------------------------------------------------------
    Purpose:	    Enables/Disables a Compiler Window and its
                    menubar and frame.
    Run Syntax:     RUN EnableTool ( INPUT p_Window, INPUT p_Enabled ).
    Parameters:
    Description:
		    1. Enables/Disables window menubar.
                    2. Freezes/UnFreezes Edit Window W x H.
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Enabled AS LOGICAL	    NO-UNDO.

  DEFINE VARIABLE hMenubar	   AS WIDGET-HANDLE NO-UNDO.
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  IF ( SESSION:WINDOW-SYSTEM = "TTY" ) 
  THEN DO:

      CASE p_Enabled:
          WHEN TRUE
          THEN DO:
              HIDE ALL NO-PAUSE.
              ASSIGN p_Window:MENUBAR = MENU mnu_Promake:HANDLE.
              VIEW FRAME main.
              RUN SetDefaults ( INPUT p_Window ) .
              APPLY "ENTRY" TO B_Compile IN FRAME main.
          END.

          WHEN FALSE
          THEN DO:
              HIDE ALL NO-PAUSE.
              STATUS INPUT.
              ASSIGN p_Window:MENUBAR = ?.
          END.
      END CASE.

      RETURN.
  END.
&ENDIF

DO WITH FRAME main:

  ASSIGN
      hMenubar	                = p_Window:MENUBAR
      hMenubar:SENSITIVE        = p_Enabled
      FRAME main:SENSITIVE      = p_Enabled
  . /* END ASSIGN */

  IF ( p_Enabled = TRUE )
  THEN DO: /* UnFreeze W x H */   
      ASSIGN
        p_Window:MAX-WIDTH        = p_Window:FULL-WIDTH
        p_Window:MAX-HEIGHT       = p_Window:FULL-HEIGHT
        p_Window:MIN-WIDTH        = 1
        p_Window:MIN-HEIGHT       = 1
      . /* END ASSIGN */

      /* Sensitize buttons. */
      ASSIGN
        btn_Propath:SENSITIVE     = p_Enabled
        btn_Add:SENSITIVE         = p_Enabled
        btn_Modify:SENSITIVE      = IF btn_Modify:PRIVATE-DATA = "TRUE"
                                    THEN TRUE ELSE FALSE
        btn_Delete:SENSITIVE      = IF btn_Delete:PRIVATE-DATA = "TRUE"
                                    THEN TRUE ELSE FALSE
        btn_Start_Compile:SENSITIVE = IF btn_Start_Compile:PRIVATE-DATA = "TRUE"
                                      THEN TRUE ELSE FALSE
        .
  END.
  ELSE DO: /* Freeze W x H */
      ASSIGN
        p_Window:MAX-WIDTH        = p_Window:WIDTH
        p_Window:MAX-HEIGHT       = p_Window:HEIGHT
        p_Window:MIN-WIDTH        = p_Window:WIDTH
        p_Window:MIN-HEIGHT       = p_Window:HEIGHT
      . /* END ASSIGN */

      /* De-sensitize buttons. For some, we store off the button sensitive
         state in PRIVATE-DATA so we can restore it when the tool is enabled
         again.
      */
      ASSIGN
        btn_Propath:SENSITIVE     = FALSE
        btn_Add:SENSITIVE         = FALSE
        btn_Modify:PRIVATE-DATA   = IF btn_Modify:SENSITIVE = TRUE
                                    THEN "TRUE" ELSE "FALSE"
        btn_Modify:SENSITIVE      = FALSE
        btn_Delete:PRIVATE-DATA   = IF btn_Delete:SENSITIVE = TRUE
                                    THEN "TRUE" ELSE "FALSE"
        btn_Delete:SENSITIVE      = FALSE
        btn_Start_Compile:PRIVATE-DATA =
                                    IF btn_Start_Compile:SENSITIVE = TRUE
                                    THEN "TRUE" ELSE "FALSE"
        btn_Start_Compile:SENSITIVE = FALSE
        .

  END.

END.
  
END PROCEDURE.	/* EnableTool. */


PROCEDURE SetDefaults.
  /*--------------------------------------------------------------------------
    Purpose:        Sets the appropriate defaults for the Compile Tool's
                    display.
    Run Syntax:     RUN SetDefaults ( INPUT p_Window ).
    Parameters:
    Description:
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Window  AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE Msg AS CHARACTER NO-UNDO.

    IF SESSION:WINDOW-SYSTEM = "TTY" THEN
    DO:
      ASSIGN Msg = " " + KBLABEL("GO") + "=COMPILE  "
                   + KBLABEL("ENTER-MENUBAR") + "=MENUS  "
                   + KBLABEL("DEFAULT-POP-UP") + "=POPUP" .
      IF ( LENGTH( Msg ) > 63 ) THEN
        ASSIGN Msg = REPLACE( Msg , "  " , " " ).
      STATUS INPUT Msg IN WINDOW p_Window.
    END.
    ELSE
      STATUS INPUT "Press " + KBLABEL("GO") + " to start compile."
             IN WINDOW p_Window.

    ASSIGN SESSION:SYSTEM-ALERT-BOX = YES.
    PAUSE 0 BEFORE-HIDE IN WINDOW p_Window.

END PROCEDURE.

PROCEDURE PutKeyVal.ip.
  DEFINE INPUT PARAMETER p_Key     AS CHAR NO-UNDO .
  DEFINE INPUT PARAMETER p_Value   AS CHAR NO-UNDO .

  DEFINE VARIABLE Key_Value AS CHAR NO-UNDO.
    
  /* proc-main */
  DO ON STOP  UNDO, RETURN ERROR
    ON ERROR UNDO, RETURN ERROR :

    /* Only put this value out if it needs changing */
    GET-KEY-VALUE SECTION {&CompSect} KEY p_Key VALUE Key_Value.
    IF  Key_Value <> p_Value
    THEN DO:
      PUT-KEY-VALUE SECTION {&CompSect} KEY p_Key VALUE p_Value NO-ERROR.
      IF ERROR-STATUS:ERROR THEN STOP.
    END.
  END.
    
END PROCEDURE.	/* KeyVals */


