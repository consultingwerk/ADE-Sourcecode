/***************************************************************************
* Copyright (C) 2005-2009,2014,2016,2020 by Progress Software Corporation. *
* All rights reserved.  Prior versions of this work may contain            *
* portions contributed by participants of Possenet.                        *
*                                                                          *
****************************************************************************/

/*

File:   prodict/user/_usrload 

Describtion:
    user interface and defaults setup for loading

Input:
  user_env[1] = "ALL" or comma-separated list of files
                or it may be in user_longchar, if list was too big.
  user_env[4] = if user_env[9] = "h"
                    then "error", "error_objattrs" or ""  to signal the needed message
                    else insignificant
  user_env[9] = type of load (e.g. .df or .d)
                "d" = load file definitions
                "f" = load data file contents
                "h" = hide message, puts up completed message and returns
                "k" = load sequence values
                "u" = load user file contents
                "v" = load view file contents
                "4" = AS/400 definitions
                "4t" = AS/400 trigger definitions
                "s" = load sequence def's
                "t" = load audit policies as text
                "x" = load audit policies as xml
                "y" = load audit data
                "e" = load application audit events
                "z" = load security authentication records
                "m" = load security permissions
                "i" = load Database Identification Properties
                "o" = load Database Options
				"p" = load CDC Policies
                
Output:
  user_env[1] = same as IN
  user_env[2] = physical file or directry name for some input
  user_env[4] = "y" or "n" - stop on first error (if class = "d","4" or "s")
              = error% (if class = "f")
  user_env[5] = comma separated list of table numbers for which triggers
                should be disabled when the load is done.
                (only used for load data file contents, "f").
  user_env[8] = dbname (if class = "d" or "4" or "s")
  user_env[10]= user specified code page
  user_env[15]= user wants to commit even if errors are found.

History:
    D. McMann   08/12/03 Add GET-DIR functionality
    D. McMann   02/04/03 Added support for LOB directories
    D. McMann   04/23/02 Added option for on-line schema changes
    D. McMann   01/03/13 Added option to commit even if error present.
    D. McMann   00/06/08 Added check for non table records on load of data
    D. McMann   00/04/12 Added support for long path names
    D. McMann   98/07/09 Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                         to _File FINDS
    D. McMann   98/06/25 Added check for trailer to begine either cpstream or codepage for
                         backwards compatibility with new .df trailer.
    laurief     98/06/09 Added code to utilize user_env[6] as a flag to turn
                         errors to screen on/off.
    tomn        96/04   Moved instances of okrun.i outside of DO blocks at
                        end of Main section (update statements); Undoing of
                        block would cause frame width to increase each time
                        
    tomn        96/04   Removed extraneous ENDKEY/END-ERROR traps (using
                        LAST-EVENT:FUNCTION statement) after UPDATE statements
                        at end of Main section (already handled by enclosing
                        DO block)

    hutegger    95/05   changed "h" behaviour to message "Load aborted"
                        in case an error occured
    kmcintos 04/04/05   Added frames and additional logic for auditing
                        support
    kmcintos 06/07/05   Added context sensitive help for auditing options
    kmcintos 08/18/05   Added user_commit toggle to audit policy load
                        dialog 20050629-018.
    kmcintos 08/31/05   Added special case for audit policies as text
                        20050629-018.
    kmcintos 01/04/06   Reset user_env[2] when read-only db or some other
                        fatal error having to do with permission checking
                        20051031-030.
    fernando 03/14/06   Handle case with too many tables selected - bug 20050930-006.
    fernando 06/20/07   Support for large files
    fernando 12/13/07   Handle long list of "some" selected tables    
    fernando 07/20/08   support for encryption
    rkamboj  08/16/11   Added new terminology for security items and windows.
    tmasood  08/25/20   Added field for missing codepage in the files. 
*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE answer        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE canned        AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE base          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE class         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE comma         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE err           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ivar          AS INT        NO-UNDO.
DEFINE VARIABLE err%          AS INT        NO-UNDO.
DEFINE VARIABLE io-file       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE io-frame      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE io-title      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE is-all        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-one        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-some       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE stop_flg      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE commit_flg    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE no-schema-lock AS LOGICAL   NO-UNDO.
DEFINE VARIABLE msg-num       AS INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE noload        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE prefix        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE trash         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dis_trig      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE codepage      AS CHARACTER  NO-UNDO FORMAT "X(20)".
DEFINE VARIABLE lvar          AS CHAR EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#         AS INT            NO-UNDO.  
DEFINE VARIABLE cr            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE inclob        AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE s_res         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE do-screen     AS LOGICAL   NO-UNDO INIT FALSE.
DEFINE VARIABLE err-to-file   AS LOGICAL   NO-UNDO INIT FALSE.
DEFINE VARIABLE err-to-screen AS LOGICAL   NO-UNDO INIT TRUE.
DEFINE VARIABLE oldsession    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodePage     AS CHARACTER NO-UNDO.

DEFINE VARIABLE base_lchar AS LONGCHAR NO-UNDO.
DEFINE VARIABLE numCount   AS INTEGER  NO-UNDO.
DEFINE VARIABLE cItem      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE isCpUndefined AS LOGICAL NO-UNDO.
define variable isSuperTenant as logical no-undo.
define variable isAllMultiTenant as logical no-undo. 
define variable isAnyMultiTenant as logical no-undo.
define variable lLobsub as logical no-undo.
define variable gLobFolderName as character no-undo init "lobs".
define variable gFileName      as character no-undo.
define variable gUseDefaultOut   as character no-undo init "<default>".
define variable UseDefaultDirs as logical no-undo  
    label "Use default location" .
    
define variable RootDirectory as character no-undo.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DEFINE VARIABLE warntxt  AS CHARACTER  NO-UNDO VIEW-AS EDITOR NO-BOX 
   INNER-CHARS 69 INNER-LINES 8.

/* To support fill-in label mnemonic (Nordhougen 07/26/95) */
  DEFINE VARIABLE idir_lbl AS CHARACTER  NO-UNDO FORMAT "X(55)"
    INIT "&Input Directory (blank = current directory):". 
  
  DEFINE VARIABLE tenant_lbl AS CHARACTER  NO-UNDO FORMAT "X(35)"
    INIT "&Effective Tenant:". 
  
  DEFINE VARIABLE idirmt_lbl AS CHARACTER  NO-UNDO FORMAT "X(65)"
    INIT "&Tenant Input Directory (blank = current directory):". 

  DEFINE VARIABLE ldir_lbl AS CHARACTER  NO-UNDO FORMAT "X(55)"
    INIT "Lob Directory (blank = current directory):". 
  
  DEFINE VARIABLE ldirmt_lbl AS CHARACTER  NO-UNDO FORMAT "X(65)"
    INIT "Te&nant LOB Directory (relative to Effective Tenant Directory):". 

  DEFINE BUTTON btn_dir
    SIZE 11 by 1.

  DEFINE BUTTON btn_dir2
    SIZE 11 by 1 .

  DEFINE BUTTON btn_dirMT
    SIZE 11 by 1 .

  DEFINE BUTTON btn_dirMTLOB
    SIZE 11 by 1 .
  
  DEFINE BUTTON btn_dirroot
    SIZE 11 by 1 .
 
&ENDIF

DEFINE BUTTON btn_tenant
  SIZE 18 by 1 .
         
{prodict/misc/filesbtn.i}

/* standard form */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
              AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
              LABEL "&Input File"
  btn_File SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-input
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

/* standard form */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 
              VIEW-AS FILL-IN SIZE 40 BY 1
              LABEL "&Input Directory"
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    btn_dir LABEL "Dir..." 
  &ENDIF
  "(If different from current directory)" VIEW-AS TEXT 
      AT &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 19 &ELSE 17 &ENDIF
  {prodict/user/userbtns.i}
  WITH FRAME read-input-dir
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} 
              FORMAT "x({&PATH_WIDG})" AT 2
              VIEW-AS FILL-IN 
                      SIZE 40 BY 1
              LABEL "&Input Directory"
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    btn_dir LABEL "Dir..."
  &ENDIF
  "(If different from current directory)" VIEW-AS TEXT
                                          AT 
                                           &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                                             19 &ELSE 17 &ENDIF
  user_commit VIEW-AS TOGGLE-BOX
              LABEL "&Refresh DB Policy Cache" AT 2
              
  {prodict/user/userbtns.i}
  
  WITH FRAME read-dir-text
             SIDE-LABELS NO-ATTR-SPACE CENTERED
             DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
             VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

/* standard form */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 
              VIEW-AS FILL-IN SIZE 40 BY 1
              LABEL "&Input Directory"
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    btn_dir LABEL "Dir..." 
  &ENDIF
  "(If different from current directory)" VIEW-AS TEXT 
     AT &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
          19 &ELSE 17 &ENDIF SKIP({&VM_WIDG})
  {&DFILE-SPEECH}
  err% {&STDPH_FILL} FORMAT ">>9" LABEL "&Acceptable Error Percentage" AT 2                   
     VALIDATE(err% >= 0 AND err% <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL " Display Errors to &Screen"
  AT 2  SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-dir-nobl
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN
  &GLOBAL-DEFINE LINEUP 12
  &GLOBAL-DEFINE FILLCH 67
&ELSEIF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
  &GLOBAL-DEFINE LINEUP 12
  &GLOBAL-DEFINE FILLCH 69
&ELSE
  &GLOBAL-DEFINE LINEUP 15
&ENDIF

/* form for .df file input */
/* Note that spaces were added to some of the string literals so that
   the strings would not be cut off under Korean Windows 95 */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "&Input File" COLON {&LINEUP}
  btn_File  SKIP ({&VM_WIDG}) 
    stop_flg VIEW-AS TOGGLE-BOX LABEL "Stop If Errors Found"
     COLON 3
    commit_flg VIEW-AS TOGGLE-BOX LABEL "Commit Even with Errors" COLON 38
     SKIP({&VM_WID})
    err-to-file VIEW-AS TOGGLE-BOX LABEL "Output Errors to File"
   COLON 3  
    err-to-screen VIEW-AS TOGGLE-BOX LABEL "Output Errors to Screen"
       COLON 38  
  
    SKIP({&VM_WID}) 
    no-schema-lock VIEW-AS TOGGLE-BOX LABEL "Add new objects on-line"
        COLON 3 SKIP({&VM_WIDG})
  
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  warntxt AT 2 NO-LABEL SKIP ({&VM_WIDG})
  &ELSE
    "WARNING: " AT 2 VIEW-AS TEXT skip
    "  If .df file is an incremental .df it may contain DROP statements which" 
       AT 2 VIEW-AS TEXT SKIP
    "  will cause data to be deleted."  
       AT 2 VIEW-AS TEXT SKIP (1)    
    "  If you select that you are only adding new objects on-line and you try" 
       AT 2 VIEW-AS TEXT SKIP
    "  to modify existing objects all changes could be rolled back. "  
       AT 2 VIEW-AS TEXT SKIP (1)
    "  If you select to commit with errors, your database could be corrupted." 
       AT 2 VIEW-AS TEXT SKIP     
  &ENDIF
  {prodict/user/userbtns.i}
  WITH FRAME read-df KEEP-TAB-ORDER
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

ASSIGN cr = CHR(10).

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ASSIGN warntxt:SCREEN-VALUE =
   "WARNING:" + cr + "  If the input file is an incremental .df it may contain DROP statements" 
   + cr + "  which will cause data to be deleted." + cr + cr +
   "  If you select to add new objects on-line and you try to modify existing" + cr +
   "  objects, all changes could be rolled back." + cr + cr +
   "  If you select to commit with errors, your database could be corrupted." .
 
  ASSIGN warntxt:READ-ONLY = yes.   
&ENDIF

/* form for .d file input */
&GLOBAL-DEFINE DFILE-SPEECH   "Specify an acceptable error percentage.  When this limit is reached,      " AT 2 VIEW-AS TEXT SKIP  "loading will stop.  Enter 0 if any error should stop the load; enter      " AT 2 VIEW-AS TEXT SKIP  "100 if the load should not stop for any error.          "                                       AT 2     VIEW-AS TEXT SKIP ({&VM_WIDG})
&GLOBAL-DEFINE CP-SPEECH  "Files missing code page in the trailer section will use code page:" AT 2 VIEW-AS TEXT SKIP ({&VM_WIDG})

FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 3 VIEW-AS FILL-IN SIZE 45 BY 1
         LABEL " &Input File" btn_File  SKIP ({&VM_WIDG})
    "  Include LOB:" VIEW-AS TEXT  inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WIDG})
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" LABEL "  LOB Directory"
    VIEW-AS FILL-IN SIZE 45 BY 1 SKIP ({&VM_WIDG})
  &ELSE 
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 6 VIEW-AS FILL-IN SIZE 45 BY 1
         LABEL "&Input File" btn_File  SKIP ({&VM_WIDG})
    "  Include LOB:" VIEW-AS TEXT  inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WID})
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE 45 BY 1
         LABEL " &LOB Directory" btn_dir LABEL "Dir..." SKIP ({&VM_WIDG})
   &ENDIF
  {&DFILE-SPEECH}
  err% {&STDPH_FILL} FORMAT ">>9" LABEL "&Acceptable Error Percentage" AT 2                   
     VALIDATE(err% >= 0 AND err% <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL " Display Errors to &Screen"
  AT 2  SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-d-file
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
    user_env[32]   {&STDPH_FILL} FORMAT "x(32)"     
                   colon 22 VIEW-AS FILL-IN size 33 by 1 /* size to align button..*/        
                   LABEL "Effective Tenant"  
    btn_Tenant     LABEL "Select Tenant..." SKIP ({&VM_WID})
    "Use Default Location:" VIEW-AS TEXT AT 2 
    UseDefaultDirs view-as toggle-box label " (Tenant data in subdirectory named after tenant)"
    RootDirectory {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"
                    colon 22 label "Root Directory"     
                    VIEW-AS FILL-IN SIZE 41 BY 1 
    user_env[2]    {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" colon 22 
                    VIEW-AS FILL-IN SIZE 41 BY 1
         LABEL "&Input File" btn_File 
    "Include LOB:" VIEW-AS TEXT AT 11 
    inclob LABEL  ""  colon 22    view-as toggle-box 
         
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" colon 22 LABEL "LOB Directory"
    VIEW-AS FILL-IN SIZE 28 BY 1 
    "(relative to Effective"            COLON 51 
    "Tenant Directory)" COLON 51 SKIP ({&VM_WIDG})    
  &ELSE 
    user_env[32]    {&STDPH_FILL} FORMAT "x(32)" colon 17 VIEW-AS FILL-IN SIZE 39 BY 1
                    LABEL "&Effective Tenant" 
    btn_Tenant      LABEL "Select Tenant..." SKIP ({&VM_WIDG})
    UseDefaultDirs  view-as toggle-box colon 17 label "Use Default Location (Tenant data in subdirectory)"
   
    RootDirectory   {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"
                    colon 17 label "Root Directory"     
                    VIEW-AS FILL-IN SIZE 45 BY 1 
    btn_DirRoot     LABEL "Dir..." SKIP ({&VM_WID})
    
    user_env[2]     {&STDPH_FILL} 
                    FORMAT "x({&PATH_WIDG})" colon 17 VIEW-AS FILL-IN SIZE 45 BY 1
                    LABEL "&Input File" 
    btn_File        SKIP ({&VM_WIDG})
    inclob          colon 17 LABEL "Include LOB" view-as toggle-box SKIP ({&VM_WID})
    "(LOB Directory is relative to Effective Tenant Directory)"         VIEW-AS TEXT AT 4    
    user_env[30]    {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" colon 17 VIEW-AS FILL-IN SIZE 45 BY 1
                    LABEL " &LOB Directory" 
    btn_dir         LABEL "Dir..." SKIP ({&VM_WIDG})
   
   &ENDIF
  {&DFILE-SPEECH}
  err% {&STDPH_FILL} FORMAT ">>9" LABEL "&Acceptable Error Percentage" AT 2                   
     VALIDATE(err% >= 0 AND err% <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL " Display Errors to &Screen"
  AT 2  SKIP({&VM_WID})
  {prodict/user/userbtns.i}
  WITH FRAME read-d-file-mt
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
    user_env[32]   {&STDPH_FILL} FORMAT "x(32)"     
                   colon 22 VIEW-AS FILL-IN size 33 by 1 /* size to align button..*/        
                   LABEL "Effective Tenant"  
    btn_Tenant     LABEL "Select Tenant..." SKIP ({&VM_WIDG})
    "Use Default Location:" VIEW-AS TEXT AT 2 
    UseDefaultDirs view-as toggle-box label " (Tenant data in subdirectory named after tenant)"
    RootDirectory {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"
                    colon 22 label "Root Directory"     
                    VIEW-AS FILL-IN SIZE 41 BY 1 
    user_env[2]    {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" colon 22 
                    VIEW-AS FILL-IN SIZE 41 BY 1
                   LABEL "&Input File" btn_File  SKIP ({&VM_WIDG})
   &ELSE 
    user_env[32]    {&STDPH_FILL} FORMAT "x(32)" colon 17 VIEW-AS FILL-IN SIZE 39 BY 1
                    LABEL "&Effective Tenant" 
    btn_Tenant      LABEL "Select Tenant..." SKIP ({&VM_WIDG})
    UseDefaultDirs  view-as toggle-box colon 17 label "Use Default Location (Tenant data in subdirectory)"
   
    RootDirectory   {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"
                    colon 17 label "Root Directory"     
                    VIEW-AS FILL-IN SIZE 45 BY 1 
    btn_DirRoot     LABEL "Dir..." SKIP ({&VM_WID})
    
    user_env[2]     {&STDPH_FILL} 
                    FORMAT "x({&PATH_WIDG})" colon 17 VIEW-AS FILL-IN SIZE 45 BY 1
                    LABEL "&Input File" 
    btn_File        SKIP ({&VM_WIDG})
  
  &ENDIF
  
  {prodict/user/userbtns.i}
  WITH FRAME read-d-seq-mt
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 3 VIEW-AS FILL-IN SIZE 45 BY 1
         LABEL " &Input File" btn_File  SKIP ({&VM_WIDG})
  &ELSE 
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 6 VIEW-AS FILL-IN SIZE 45 BY 1
         LABEL "&Input File" btn_File  SKIP ({&VM_WIDG})
   &ENDIF
  {&DFILE-SPEECH}
  err% {&STDPH_FILL} FORMAT ">>9" LABEL "&Acceptable Error Percentage" AT 2                   
     VALIDATE(err% >= 0 AND err% <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL " Display Errors to &Screen"
  AT 2  SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-d-file-nobl
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".
  
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
              AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
              LABEL "&Input File"
  btn_File SKIP ({&VM_WIDG})
  {&DFILE-SPEECH}
  err% {&STDPH_FILL} FORMAT ">>9" LABEL "&Acceptable Error Percentage" AT 2                   
     VALIDATE(err% >= 0 AND err% <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-input-cdc
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
    user_env[2] {&STDPH_FILL} 
                FORMAT "x({&PATH_WIDG})" AT 3
                VIEW-AS FILL-IN SIZE 45 BY 1
                LABEL " &Input File" 
    btn_File                                                  SKIP({&VM_WIDG})
    user_overwrite VIEW-AS TOGGLE-BOX 
                   LABEL "&Overwrite Duplicate Policies" AT 6 SKIP({&VM_WIDG})
    user_commit    VIEW-AS TOGGLE-BOX
                   LABEL "&Refresh DB Policy Cache"      AT 6
  &ELSE 
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                AT 4 VIEW-AS FILL-IN SIZE 45 BY 1
                LABEL "&Input File" 
    btn_File                                                  SKIP({&VM_WIDG})
    user_overwrite VIEW-AS TOGGLE-BOX 
                   LABEL "&Overwrite Duplicate Policies" AT 4
    user_commit    VIEW-AS TOGGLE-BOX
                   LABEL "&Refresh DB Policy Cache"      
  &ENDIF
  {prodict/user/userbtns.i}
  WITH FRAME read-xml-file
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    idir_lbl NO-LABEL VIEW-AS TEXT AT 2
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
          SIZE 45 BY 1 NO-LABEL  btn_dir LABEL "Data Dir.." SKIP ({&VM_WIDG})
     "Include LOB" VIEW-AS TEXT AT 2 inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WID})
    ldir_lbl NO-LABEL VIEW-AS TEXT AT 2
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
      SIZE 45 BY 1 NO-LABEL btn_dir2 LABEL "Lob Dir..." SKIP ({&VM_WIDG})
    btn_dir2 LABEL "Lob Dir..." SKIP ({&VM_WIDG})
    {&CP-SPEECH}
    cCodePage {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
         SIZE 40 BY 1 NO-LABEL SKIP ({&VM_WIDG})
  &ELSE
     user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 45 BY 1
                LABEL "Input Directory"  SKIP 
    "(Leave blank for current directory)" VIEW-AS TEXT AT 19  SKIP({&VM_WIDG})   
    "    Include LOB:" VIEW-AS TEXT AT 2 inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WID})
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
      SIZE 45 BY 1 LABEL "  LOB Directory"  SKIP 
     "(Leave blank for current directory)" VIEW-AS TEXT AT 19 SKIP({&VM_WIDG})
    {&CP-SPEECH}
    cCodePage {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
         SIZE 40 BY 1 NO-LABEL SKIP ({&VM_WIDG})
  &ENDIF  
  {&DFILE-SPEECH}
  err% {&STDPH_FILL} FORMAT ">>9" AT 2 LABEL "&Acceptable Error Percentage"                     
     VALIDATE(err% >= 0 AND err% <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL "Output Errors to &Screen"
      AT 2 SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-d-dir
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".  

FORM 
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    SKIP({&TFM_WID})
    tenant_lbl NO-LABEL VIEW-AS TEXT AT 2
    user_env[32] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" at 2 
                    VIEW-AS FILL-IN SIZE 48 BY 1 NO-LABEL
    btn_Tenant LABEL "Select Tenant..." SKIP ({&VM_WIDG})
    UseDefaultDirs  view-as toggle-box  at 2 label "Use Default Location (Tenant and LOB data in subdirectory)"
      
    idir_lbl NO-LABEL VIEW-AS TEXT AT 2
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
                              SIZE 55 BY 1 NO-LABEL  
    btn_dir LABEL "Data Dir.." SKIP ({&VM_WIDG})
    
    idirmt_lbl NO-LABEL VIEW-AS TEXT AT 2
    user_env[33] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
                               SIZE 55 BY 1 NO-LABEL 
    btn_dirmt LABEL "Data Dir..." SKIP ({&VM_WIDG})
 
    inclob LABEL "Include LOB" at 2 view-as toggle-box SKIP ({&VM_WID})
    
    ldir_lbl NO-LABEL VIEW-AS TEXT AT 2
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
                               SIZE 55 BY 1 NO-LABEL 
    
    btn_dir2 LABEL "Lob Dir..." SKIP ({&VM_WIDG})
    ldirmt_lbl NO-LABEL VIEW-AS TEXT AT 2

    user_env[34] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
                               SIZE 55 BY 1 NO-LABEL 
    btn_dirmtlob LABEL "Lob Dir..." SKIP ({&VM_WIDG})
 
 
  &ELSE
    SKIP({&VM_WIDG})   
    user_env[32] {&STDPH_FILL} FORMAT "x(32)" colon 22 
                 VIEW-AS FILL-IN SIZE 32 BY 1 LABEL "Effective Tenant"
    btn_Tenant LABEL "Select Tenant..." skip({&VM_WID})
    "Use Default Location:"           VIEW-AS TEXT AT 2
    UseDefaultDirs        colon 22 
                          view-as toggle-box label " (Tenant data and lobs in subdirectories)"
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" colon 22
                help "Leave blank for current directory"
                VIEW-AS FILL-IN SIZE 51 BY 1 LABEL "Shared Directory"  SKIP 
    user_env[33] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" colon 22
                help "Leave blank for current directory"
                VIEW-AS FILL-IN SIZE 51 BY 1 LABEL "Tenant Directory" 
    
    "Include LOB:" VIEW-AS TEXT AT 11 inclob LABEL "" view-as toggle-box 
    
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" colon 22 
                 VIEW-AS FILL-IN SIZE 28 BY 1 LABEL "LOB Directory" 
     
    user_env[34] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" colon 22 
                 VIEW-AS FILL-IN SIZE 28 BY 1  LABEL "Tenant LOB Directory" 
    "(relative to Effective"            COLON 51 
    "Tenant Directory)" COLON 51 
    
  &ENDIF  
   {&DFILE-SPEECH}
  err% {&STDPH_FILL} FORMAT ">>9" AT 2 LABEL "&Acceptable Error Percentage"
     help "0 = Any error stops the load, 100 = Do not stop for any error."                     
     VALIDATE(err% >= 0 AND err% <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL "Output Errors to &Screen"
      AT 2 
  
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      SKIP({&VM_WIDG})
  &ENDIF
  
  {prodict/user/userbtns.i}
  WITH FRAME read-d-dir-mt
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".  


FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    idir_lbl NO-LABEL VIEW-AS TEXT AT 2
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
          SIZE 45 BY 1 NO-LABEL  btn_dir LABEL "Dir.." SKIP ({&VM_WIDG})
  &ELSE
     user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 45 BY 1
                LABEL "Input Directory"  SKIP 
    "(Leave blank for current directory)" VIEW-AS TEXT AT 19  SKIP({&VM_WIDG})   
    "    Include LOB:" VIEW-AS TEXT AT 2 inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WID})
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
      SIZE 45 BY 1 LABEL "  LOB Directory"  SKIP 
     "(Leave blank for current directory)" VIEW-AS TEXT AT 19 SKIP({&VM_WIDG})
  &ENDIF  
  {&DFILE-SPEECH}
  err% {&STDPH_FILL} FORMAT ">>9" AT 2 LABEL "&Acceptable Error Percentage"                     
     VALIDATE(err% >= 0 AND err% <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL "Output Errors to &Screen"
      AT 2 SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-dir
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".  

/* For MSW, associate text widget with fill-in to enable mnemonic (Nordhougen 07/26/95) */
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  /* fixed to use right frame and labels shows &
  ASSIGN user_env[2]:SIDE-LABEL-HANDLE IN FRAME read-d-dir = idir_lbl:HANDLE IN FRAME read-d-dir
         user_env[2]:LABEL IN FRAME read-d-dir = idir_lbl
         user_env[30]:SIDE-LABEL-HANDLE IN FRAME read-d-dir = ldir_lbl:HANDLE IN FRAME read-d-dir
         user_env[30]:LABEL IN FRAME read-d-dir = ldir_lbl.

  ASSIGN user_env[2]:SIDE-LABEL-HANDLE IN FRAME read-d-dir-mt = idir_lbl:HANDLE IN FRAME read-d-dir-mt 
         user_env[2]:LABEL IN FRAME read-d-dir-mt = idir_lbl
         user_env[30]:SIDE-LABEL-HANDLE IN FRAME read-d-dir-mt  = ldir_lbl:HANDLE IN FRAME read-d-dir-mt  
         user_env[30]:LABEL IN FRAME read-d-dir-mt = ldir_lbl 
         user_env[32]:SIDE-LABEL-HANDLE IN FRAME read-d-dir-mt  = tenant_lbl:HANDLE IN FRAME read-d-dir-mt  
         user_env[32]:LABEL IN FRAME read-d-dir-mt = tenant_lbl 
         user_env[33]:SIDE-LABEL-HANDLE IN FRAME read-d-dir-mt  = idirmt_lbl:HANDLE IN FRAME read-d-dir-mt  
         user_env[33]:LABEL IN FRAME read-d-dir-mt = idirmt_lbl 
         user_env[34]:SIDE-LABEL-HANDLE IN FRAME read-d-dir-mt  = ldirmt_lbl:HANDLE IN FRAME read-d-dir-mt  
         user_env[34]:LABEL IN FRAME read-d-dir-mt = ldirmt_lbl.
   */

&ENDIF

FORM
  "Please enter a Code Page to use for this load." AT 2 SKIP
  codepage {&STDPH_FILL} LABEL "&Code Page" AT 2
  {prodict/user/userbtns.i}
  WITH FRAME get-cp SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Code Page ".

/*=============================== Functions =================================*/ 
function getTenantName returns char(pctenant as char):
    define variable lok     as logical no-undo.
    define variable hbuffer as handle no-undo. 
    define variable cValue   as character no-undo.
    
    CREATE BUFFER hbuffer FOR TABLE "DICTDB._tenant".
    lok = hbuffer:find-unique ("where _tenant._Tenant-name = " + quoter(pcTenant)) no-error.
    if lok then 
        cValue = hBuffer::_tenant-name.
    
    delete object hbuffer.    
    return cValue.
end function. 

function setEffectiveTenant returns logical(pctenant as char):
    set-effective-tenant(pcTenant,"DICTDB").
    return true.
    catch e as Progress.Lang.Error :
        message e:GetMessage(1)
        view-as alert-box error.    
        return false.
    end catch.
end function. 

/*
function appendFolderName returns char (ppath as char, pfolder as char):
    define variable iback    as integer no-undo.
    define variable iforward as integer no-undo.
    define variable ilength  as integer no-undo.
    define variable cSlash   as character no-undo init "/".
    define variable cBackSlash   as character no-undo init "~\".
    if pPath = "" then 
        return pfolder.
    iback = r-index(pPath,cBackSlash).
    iforward = r-index(pPath,cSlash).
    if iback = 0 and iforward = 0 then
        return pPath + cSlash + pfolder. 
    ilength = length(pPath).
    if iback = ilength or iforward = ilength then 
        return pPath + pfolder.
    if iForward > 0 then  
        return pPath + cSlash + pfolder.
    if iBack > 0 then    
        return pPath + cBackSlash + pfolder.
    
end.
*/

function addPath return character
                   (pFullPath as char,
                    oldPath as char,
                    newPath as char):
    
    define variable iback        as integer no-undo.
    define variable iforward     as integer no-undo.
    define variable inewback     as integer no-undo.
    define variable inewforward  as integer no-undo.
    define variable iloop        as integer no-undo.
    define variable cSlash       as character no-undo init "/".
    define variable cBackSlash   as character no-undo init "~\".
    define variable cUseSlash    as character no-undo.
    define variable cEntry       as character no-undo.
    define variable cFullPath     as character no-undo. 
    
    
    if length(pfullpath) > 3 and (oldPath = "" or newpath = "") then
    do:
       if substr(pFullPath,1,3) matches ".:" + cSlash + "*" then
           return pFullPath. 
       if substr(pFullPath,1,3) matches ".:" + cBackSlash + "*" then
           return pFullPath. 
    end.
       
    
    cFullPath = pFullPath.   
    /* new slash supersedes old */
    iNewBack = r-index(newPath,cBackSlash).
    iNewForward = r-index(newPath,cSlash).
    iback = r-index(cFullPath,cBackSlash).
    iforward = r-index(cFullPath,cSlash).
    if iNewForward > 0 and iNewForward > iNewBack then
    do:
        if iback > 0 then
            assign
                oldPath = replace(oldPath,cBackSlash,cSlash)
                cFullPath = replace(cFullPath,cBackSlash,cSlash).
        if iNewBack > 0 then
            newPath = replace(newPath,cBackSlash,cSlash).
        cUseSlash = cSlash.
    end.    
    else if iNewBack > 0 then
    do:
        if iForward > 0 then
            assign
                oldPath = replace(oldPath,cSlash,cBackSlash)
                cFullPath = replace(cFullPath,cSlash,cBackSlash).
        if iNewForward > 0 then
            newPath = replace(newPath,cSlash,cBackSlash).
        
        cUseSlash = cBackSlash.
    end.    
    else if iBack > iforward then
    do:
        cUseSlash = cBackSlash.
        if iForward > 0 then 
            assign
                oldPath = replace(oldPath,cSlash,cBackSlash)
                cFullPath = replace(cFullPath,cSlash,cBackSlash).
    end.
    else do:   
        cUseSlash = cSlash.   
        if iback > 0 then
            assign
                oldPath = replace(oldPath,cBackSlash,cSlash)
                cFullPath = replace(cFullPath,cBackSlash,cSlash).
    end.
    
    /* return cfullpath only if replace is done */  
    if oldPath = "" then
    do:
       if newPath = "" then 
           return pFullPath.   
       cFullPath = right-trim(newPath,cUseSlash) 
             + (if cFullPath begins cUseSlash then "" else cUseSlash) 
             + cFullPath.
       return cfullPath.
/*       return left-trim(cFullPath,cUseSlash).*/
    end.
    else if newPath = "" then
    do:
       if cFullPath <> oldpath then
           cFullPath = substr(cFullPath,length(oldpath) + 1).
       else
           cFullPath = "".
       return left-trim(cFullPath,cUseSlash).
    end.
    else do:
       /*** keep max 1 slash  in the returned fullpath */    
       /* trim just in case of many slashes at end of old since 
          they will not have been added */   
       oldPath =  right-trim(oldPath,cUseSlash) + cUseSlash.
       if cFullPath begins oldPath then
       do:
           cFullPath = substr(cFullPath,length(oldpath)).
           if not cFullPath begins cUseSlash then
              cFullPath = cUseSlash + cFullPath.
           newPath = right-trim(newpath,cUseSlash).
           cFullPath = newpath + cFullPath.
           return cfullPath.
 
       end.
    end.    
    
    /* return input if nothing returned above */ 
    return pFullPath.
        
end function. 


function validDirectory returns logical ( cValue as char):
  
    IF cValue <> "" THEN 
    DO:
        if not (cValue begins "/" or cvalue begins "~\" or index(cValue,":") <> 0) then
            cValue = "./" + cValue.  
        
        ASSIGN FILE-INFO:FILE-NAME = cValue. 
        return SUBSTRING(FILE-INFO:FILE-TYPE,1,1) = "D".
    END.
        
    return true.
 
end function. /* validateDirectory */


function validateDirectory returns logical ( cValue as char):
   
    IF cValue <> "" THEN 
    DO:
        ASSIGN FILE-INFO:FILE-NAME = cValue. 
        IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
            MESSAGE "Directory " + cValue + " does not exist" SKIP(1)
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    /*
            MESSAGE FILE-INFO:FILE-NAME "is not a directory or can not be found" 
            VIEW-AS ALERT-BOX ERROR.
      */
        return false.
    END.
    return true.
  END.
end function. /* validateDirectory */

function validateLoadLobDirectory returns logical ( cValue as char):
   
    IF cValue <> "" THEN 
    DO:
        IF NOT (cValue begins "/" or cValue begins "~\" or INDEX(cValue,":") <> 0) THEN
        DO:
            IF SUBSTRING(user_env[2],1,R-Index(user_env[2],"/") - 1) = user_env[2] THEN
                cValue = "./" + cValue.
            ELSE
                cValue = SUBSTRING(user_env[2],1,R-Index(user_env[2],"/") - 1) + "/" + cValue.
         END.
            
        ASSIGN FILE-INFO:FILE-NAME = cValue. 
        IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
            MESSAGE "Directory " + user_env[30] + " does not exist" SKIP(1)
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
        return false.
    END.
    return true.
  END.
end function. /* validateLoadLobDirectory */

function validateLoadTenantLobDirectory returns logical ( cValue as char):
   
    IF cValue <> "" THEN 
    DO:
        IF NOT (cValue begins "/" or cValue begins "~\" or INDEX(cValue,":") <> 0) THEN
        DO:
            IF user_env[33] = "" THEN
                cValue = "./" + cValue.
             ELSE
                cValue = user_env[33] + "/" + cValue.
        END.
            
        ASSIGN FILE-INFO:FILE-NAME = cValue. 
        IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
            MESSAGE "Directory " + user_env[34] + " does not exist" SKIP(1)
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   
        return false.
    END.
    return true.
  END.
end function. /* validateLoadTenantLobDirectory */

/* refresh variables depending in tenant (use_env[32]) and Rootdirectory
   Call whenever one of them has changed  (used by write-dump-dir-file) 
   (Could also be used to refresh if gFileName and gLobFolderName changes)
   */
function refreshDirDefaults return logical():
     define variable cSlash     as character no-undo init "/".     
     define variable cBackSlash as character no-undo init "~\".     
     define variable iBack      as integer no-undo.
     define variable iForward   as integer no-undo.
     define variable cUseSlash  as character no-undo.     
     define variable cDir       as character no-undo.
     if UseDefaultDirs then
     do:
         iback = r-index(user_env[2],cBackSlash).
         iforward = r-index(user_env[2],cSlash).
         if iback > iforward then 
             cUseSlash = cBackSlash.
         else
             cUseSlash  = cSlash.
             
         if user_env[2] <> "" then
         do:
             cdir = user_env[2] + cUseSlash. 
         end.
         assign   
             user_env[33] = cdir + user_env[32]  
             user_env[30] = cdir + gLobFolderName
             user_env[34] = cdir + gLobFolderName.
         return true. 
     end. 
     return false.    
end function.  


/* refresh variables depending in tenant (use_env[32]) and Rootdirectory
   Call whenever one of them has changed  (used by write-dump-dir-file) 
   (Could also be used to refresh if gFileName and gLobFolderName changes)
   */
function refreshFileDefaults return logical():
     define variable cSlash     as character no-undo init "/".     
     define variable cBackSlash as character no-undo init "~\".     
     define variable iBack      as integer no-undo.
     define variable iForward   as integer no-undo.
     define variable cUseSlash  as character no-undo.     
     define variable cDir       as character no-undo.
     if UseDefaultDirs then
     do:
         iback = r-index(RootDirectory,cBackSlash).
         iforward = r-index(RootDirectory,cSlash).
         if iback > iforward then 
             cUseSlash = cBackSlash.
         else
             cUseSlash  = cSlash.
             
         if RootDirectory <> "" then
         do:
             cdir = RootDirectory + cUseSlash. 
         end.
         assign   
             user_env[2] =  cdir + user_env[32] + cUseSlash + gFileName
             user_env[30] = cdir + gLobFolderName.
         return true. 
     end. 
     return false.    
end function.  

/* refresh variables depending in tenant (use_env[32]) and Rootdirectory
   Call whenever one of them has changed  (used by read-d-seq-mt) 
   (Could also be used to refresh if gFileName and gLobFolderName changes)
   */
function refreshSeqDefaults return logical():
     define variable cSlash     as character no-undo init "/".     
     define variable cBackSlash as character no-undo init "~\".     
     define variable iBack      as integer no-undo.
     define variable iForward   as integer no-undo.
     define variable cUseSlash  as character no-undo.     
     define variable cDir       as character no-undo.
     if UseDefaultDirs then
     do:
         iback = r-index(RootDirectory,cBackSlash).
         iforward = r-index(RootDirectory,cSlash).
         if iback > iforward then 
             cUseSlash = cBackSlash.
         else
             cUseSlash  = cSlash.
             
         if RootDirectory <> "" then
         do:
             cdir = RootDirectory + cUseSlash. 
         end.
         assign   
             user_env[2] =  cdir + user_env[32] + cUseSlash + gFileName.
         return true. 
     end. 
     return false.    
end function.



function refreshDirMT returns logical ():  
     if refreshDirDefaults() then 
     do: 
         user_env[33]:screen-value in frame read-d-dir-mt = user_env[33].
         if inclob:checked in frame read-d-dir-mt then
            assign
                user_env[30]:screen-value in frame read-d-dir-mt = user_env[30]
                user_env[34]:screen-value in frame read-d-dir-mt = user_env[34].
     
     end.           
end.      

function refreshSeqMT returns logical ():  
     if refreshSeqDefaults() then 
     do: 
         user_env[2]:screen-value in frame read-d-seq-mt = user_env[2].
     end.           
end.   
 
function refreshFileMT returns logical ():  
     if refreshFileDefaults() then 
     do: 
         user_env[2]:screen-value in frame read-d-file-mt = user_env[2].
         if inclob:checked   in frame read-d-file-mt then
             user_env[30]:screen-value in frame read-d-file-mt = user_env[30].
     end.           
end.      


function refreshDirInDirUI returns logical ():      
     if validDirectory(user_env[2]:screen-value in frame read-d-dir-mt) then
     do: 
         user_env[2] = right-trim(user_env[2]:screen-value in frame read-d-dir-mt,"/~\.").        
         refreshDirMT().  
         return true.
     end.
     return false.    
end function.  

function refreshDirInFileUI returns logical ():    
      
     if validDirectory(RootDirectory:screen-value in frame read-d-file-mt) then
     do: 
         RootDirectory = right-trim(RootDirectory:screen-value in frame read-d-file-mt,"/~\.").        
         refreshFileMT().  
         return true.
     end.
     return false.    
end function.  

/* 
function replaceFolderName returns char (ppath as char, pfolder as char,pnewFolder as char):
    define variable iback        as integer no-undo.
    define variable iforward     as integer no-undo.
    define variable iloop        as integer no-undo.
    define variable cSlash       as character no-undo init "/".
    define variable cBackSlash   as character no-undo init "~\".
    define variable cEntry       as character no-undo.
    
    if pPath = "" then 
        return pnewfolder.
    iback = r-index(pPath,cBackSlash).
    iforward = r-index(pPath,cSlash).
    if iBack > iforward then
       cSlash = cBackSlash.
       
    iloop = max(iback,iforward).
    do iloop = num-entries(ppath,cslash) to 1 by -1:
        cEntry = entry(iLoop,ppath,cslash).
        if centry = pfolder then
        do:
           entry(iLoop,ppath,cslash) = pnewfolder.   
           leave. /* only replace one*/
        end.
    end.    
    return ppath. 
end.
*/


function refreshDirMTState returns logical ():    
   
    assign 
        UseDefaultDirs =  UseDefaultDirs:checked in frame read-d-dir-mt
        inclob            =  inclob:checked in frame read-d-dir-mt
        user_env[2]:sensitive in frame read-d-dir-mt = UseDefaultDirs or (isAllMultitenant = false)
  
        user_env[2]:screen-value in frame read-d-dir-mt = if user_env[2]:sensitive in frame read-d-dir-mt
                                                          then user_env[2]
                                                          else ""
        user_env[33]:sensitive  in frame read-d-dir-mt = not UseDefaultDirs
        
        user_env[30]:screen-value in frame read-d-dir-mt = if inclob then user_env[30] else ""
        user_env[30]:sensitive in frame read-d-dir-mt = UseDefaultDirs = false and inclob
        user_env[34]:screen-value in frame read-d-dir-mt = if inclob then user_env[34] else ""
        user_env[34]:sensitive in frame read-d-dir-mt = UseDefaultDirs = false and inclob
       
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
         btn_dir:sensitive  in frame read-d-dir-mt = 
                    user_env[2]:sensitive  in frame read-d-dir-mt
         btn_dirMt:sensitive  in frame read-d-dir-mt = 
                    user_env[33]:sensitive  in frame read-d-dir-mt
         btn_dir2:sensitive  in frame read-d-dir-mt = 
                    user_env[30]:sensitive  in frame read-d-dir-mt
         btn_dirmtLob:sensitive  in frame read-d-dir-mt = 
                    user_env[34]:sensitive  in frame read-d-dir-mt
   
     &ENDIF 
     
       .
end.   

function refreshFileMTState returns logical ():    
     
    assign 
        UseDefaultDirs =  UseDefaultDirs:checked in frame read-d-file-mt
        inclob            =  inclob:checked in frame read-d-file-mt
        RootDirectory:sensitive in frame read-d-file-mt = UseDefaultDirs
        RootDirectory:screen-value in frame read-d-file-mt = if UseDefaultDirs then RootDirectory
                                                                 else ""
        user_env[2]:sensitive  in frame read-d-file-mt = not UseDefaultDirs
        user_env[30]:screen-value in frame read-d-file-mt = if inclob then user_env[30] else ""
        user_env[30]:sensitive in frame read-d-file-mt = UseDefaultDirs = false and inclob
        btn_file:sensitive  in frame read-d-file-mt = 
                    user_env[2]:sensitive  in frame read-d-file-mt
         
       
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
         btn_dirRoot:sensitive  in frame read-d-file-mt = 
                    RootDirectory:sensitive  in frame read-d-file-mt
         btn_dir:sensitive  in frame read-d-file-mt = 
                    user_env[30]:sensitive  in frame read-d-file-mt
   
     &ENDIF      
       .
end.     


function refreshSeqMTState returns logical ():    
    assign 
        UseDefaultDirs =  UseDefaultDirs:checked in frame read-d-seq-mt
        RootDirectory:sensitive in frame read-d-seq-mt = UseDefaultDirs
        RootDirectory:screen-value in frame read-d-seq-mt = if UseDefaultDirs then RootDirectory
                                                            else ""
        user_env[2]:sensitive  in frame read-d-seq-mt = not UseDefaultDirs
        btn_file:sensitive  in frame read-d-seq-mt = 
                    user_env[2]:sensitive  in frame read-d-seq-mt
       
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
         btn_dirRoot:sensitive  in frame read-d-seq-mt = 
                    RootDirectory:sensitive  in frame read-d-seq-mt
     &ENDIF 
       .
end.     

    
function refreshTenantInDirUI returns logical ():    
     define variable newTenantName as character no-undo.
     newTenantName = getTenantName(user_env[32]:screen-value in frame read-d-dir-mt). 
     if newTenantName > "" then
     do: 
         user_env[32] = newTenantName.
         refreshDirMT().  
         return true.
     end.
     return false.    
end function. 

function refreshTenantInFileUI returns logical ():    
     define variable newTenantName as character no-undo.
     newTenantName = getTenantName(user_env[32]:screen-value in frame read-d-file-mt). 
     if newTenantName > "" then
     do: 
         user_env[32] = newTenantName.
         refreshFileMT().  
         return true.
     end.
     return false.    
end function.     

function refreshTenantInSeqUI returns logical ():    
     define variable newTenantName as character no-undo.
     newTenantName = getTenantName(user_env[32]:screen-value in frame read-d-seq-mt). 
     if newTenantName > "" then
     do: 
         user_env[32] = newTenantName.
         refreshSeqMT().  
         return true.
     end.
     return false.    
end function.   

function selectTenant return logical (hTenant as handle):
    define variable tenantdlg as prodict.pro._tenant-sel-presenter no-undo.
    
    tenantdlg = new prodict.pro._tenant-sel-presenter ().
    
    do:
           &IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN
        if  hTenant:frame:row < 0 then  /* this does not really work with large negative */                  
           tenantdlg:Row = (hTenant:row + hTenant:height) + 0.5.
        else 
           tenantdlg:Row = hTenant:row + hTenant:height +  hTenant:frame:row + 0.5.
        tenantdlg:Col = hTenant:col + hTenant:frame:col .
  
           &ELSE
        tenantdlg:Row = hTenant:row + hTenant:height +  hTenant:frame:row.
      
           &ENDIF
    end.
    tenantdlg:Title = "Select Tenant".
    tenantdlg:QueryString = "for each ttTenant where ttTenant.type <> 'super'".
/*    glInSelect = true. /* stop end-error anywhere trigger */*/
  
   
    if tenantdlg:Wait() then do   :
                 
        hTenant:screen-value = tenantdlg:ColumnValue("ttTenant.name").
        apply "value-changed" TO hTenant.
    end. 
   
/*    glInSelect = false.*/
end.  

function trimScreenValue returns logical (h as handle):
     h:SCREEN-VALUE = TRIM(h:SCREEN-VALUE).
end function.

function validateTenantName returns logical(ctenant as char):
    define variable lok as logical no-undo.
    if cTenant = "" then
    do:
        MESSAGE "Please specify which Tenant to dump data for."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        return false. 
    end.
    if getTenantName(cTenant) = "" then 
    do:
        MESSAGE "There is no Tenant with name " +  ctenant + " in the database."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        return false.
    end.
    return true.
end function. 

function refreshLobField returns logical (lEnabled as log,hfield as handle):
    assign 
       hField:sensitive = lEnabled.
       
    if not lEnabled then
       assign
           user_env[30] = hField:screen-value
           hField:screen-value = "". 
    else 
        hField:screen-value = user_env[30].

end.

function refreshTenantLobField returns logical (lEnabled as log,hfield as handle):
    assign 
       hField:sensitive = lEnabled.
    if not lEnabled then
       assign
           user_env[34] = hField:screen-value
           hField:screen-value = "". 
    else 
        hField:screen-value = user_env[34].
end.


/*=============================Triggers===============================*/

DEFINE VAR msg AS CHAR NO-UNDO INITIAL
   "Can not find a file of this name.  Try again.".

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame read-input or CHOOSE of btn_Help in frame read-input
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Load_Stuff_Dlg_Box},
                             INPUT ?).

on HELP of frame read-df or CHOOSE of btn_Help in frame read-df
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Load_Data_Definitions_Dlg_Box},
                             INPUT ?).

ON HELP OF FRAME read-d-seq-mt OR 
   CHOOSE OF btn_Help IN FRAME read-d-seq-mt
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Load_Data_Contents_Dlg_Box},
                             INPUT ? ).

ON HELP OF FRAME read-d-file OR 
   CHOOSE OF btn_Help IN FRAME read-d-file
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Load_Data_Contents_Dlg_Box},
                             INPUT ? ).

ON HELP   OF FRAME read-d-file-nobl OR 
   CHOOSE OF btn_Help IN FRAME read-d-file-nobl DO:
  DEFINE VARIABLE iContextId AS INTEGER     NO-UNDO.

  CASE user_env[9]:
    WHEN "o" THEN
      iContextId = {&Load_Database_Options_Dialog_Box}.
    WHEN "i" THEN
      iContextId = {&Load_Database_Identification_Properties_Dialog_Box}.
    WHEN "e" THEN
      iContextId = {&Load_Application_Audit_Events_Dialog_Box}.
  END CASE.
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT iContextId,
                             INPUT ? ).
END.

on HELP of frame read-input-cdc or CHOOSE of btn_Help in frame read-input-cdc
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Load_Stuff_Dlg_Box},
                             INPUT ?).

ON HELP OF FRAME read-xml-file OR 
   CHOOSE OF btn_Help IN FRAME read-xml-file
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT",
                             /* Temporary until context help is developed */
                             INPUT {&Load_Data_Contents_Dlg_Box},
                             INPUT ? ).

ON HELP OF FRAME read-input-dir OR 
   CHOOSE OF btn_Help IN FRAME read-input-dir
  RUN "adecomm/_adehelp.p" ( INPUT "admn",
                             INPUT "CONTEXT",
                             INPUT {&Load_Data_Contents_Dlg_Box},
                             INPUT ? ).

ON HELP OF FRAME read-dir-text OR
   CHOOSE OF btn_Help IN FRAME read-dir-text
  RUN "adecomm/_adehelp.p" ( INPUT "admn",
                             INPUT "CONTEXT",
                             INPUT {&Load_Data_Contents_Dlg_Box},
                             INPUT ? ).
                             
ON HELP OF FRAME read-dir-nobl
   OR CHOOSE OF btn_Help IN FRAME read-dir-nobl
  RUN "adecomm/_adehelp.p" ( INPUT "admn",
                             INPUT "CONTEXT",
                             /* Temporary until context help is developed */
                             INPUT {&Load_Data_Contents_Dlg_Box},
                             INPUT ? ).

on HELP of frame read-d-dir
   or CHOOSE of btn_Help in frame read-d-dir
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Load_Data_Contents_Some_Dlg_Box},
                             INPUT ?).
                             
on HELP of frame get-cp or CHOOSE of btn_Help in frame get-cp
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT",
                             INPUT {&Code_Page_Dlg_Box},
                              INPUT ?).

&ENDIF

/*----- ON GO or OK -----*/
ON GO OF FRAME read-df
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-df) = ? THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-df.
    RETURN NO-APPLY.
  END.
  IF io-file THEN 
    user_env[2]:SCREEN-VALUE = SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-df).
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-df.
  run verify-cp.
END.

ON GO OF FRAME read-d-file
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-d-file) = ? 
  THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-d-file.
    RETURN NO-APPLY.
  END.
  
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-d-file
         user_env[30] = user_env[30]:SCREEN-VALUE IN FRAME read-d-file.

  IF inclob:SCREEN-VALUE IN FRAME read-d-file = "no" THEN
      ASSIGN user_env[31] = " NO-LOBS".
  ELSE
      ASSIGN user_env[31] = "".
             
  run verify-cp.
END.

ON GO OF FRAME read-d-file-mt
DO:  
    do with frame  read-d-file-mt:
        trimScreenValue(user_env[30]:handle IN FRAME read-d-file-mt).
        if not validateTenantName(user_env[32]:screen-value IN FRAME read-d-file-mt) then
        do:
            APPLY "ENTRY" TO user_env[32] IN FRAME read-d-file-mt.
            return no-apply.
        end.  
        
        /* Validate this when use defaults. It is not directly used 
           but it is prepended to other directories when valid 
          (invalid values are not prepended, and the user might have 
           thought it was, so we need to tell them that the root is wrong)  */
        if UseDefaultdirs
        and not validateDirectory(RootDirectory:screen-value in frame read-d-file-mt) then 
        do:
            apply "entry" to RootDirectory IN FRAME read-d-file-mt.
            
            return no-apply.
        end.    
    
        IF SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-d-file-mt) = ?  THEN 
        DO:
            MESSAGE "File" user_env[2] "does not exist" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            if user_env[2]:sensitive in FRAME read-d-file-mt then
                APPLY "ENTRY" TO user_env[2] IN FRAME read-d-file-mt.
            else
                APPLY "ENTRY" TO UseDefaultDirs IN FRAME read-d-file-mt.
            
            RETURN NO-APPLY.
        END.
        /* PSC00306654- moved above to get updated values for user_env before calling validatedirectory() */
        ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-d-file-mt
               user_env[30] = user_env[30]:SCREEN-VALUE IN FRAME read-d-file-mt 
               user_env[32] = user_env[32]:SCREEN-VALUE IN FRAME read-d-file-mt.
      
        IF inclob:SCREEN-VALUE IN FRAME read-d-file-mt = "yes" 
        and not validateLoadLobDirectory(user_env[30]:screen-value IN FRAME read-d-file-mt) then 
        do:
            if user_env[30]:sensitive in FRAME read-d-file-mt then
                apply "entry" to user_env[30] IN FRAME read-d-file-mt.
            else
                APPLY "ENTRY" TO UseDefaultDirs IN FRAME read-d-file-mt.
            return no-apply.
        end.      
                
        if not setEffectiveTenant(user_env[32]) then
        do:
            apply "entry" to user_env[32].
            return no-apply.    
        end.
        
        IF inclob:SCREEN-VALUE IN FRAME read-d-file-mt = "no" THEN
            ASSIGN user_env[31] = " NO-LOBS".
        ELSE
            ASSIGN user_env[31] = "".
                 .
        run verify-cp.
    end.
    
END.


ON GO OF FRAME read-d-seq-mt
DO:  
    if not validateTenantName(user_env[32]:screen-value IN FRAME read-d-seq-mt) then
    do:
        APPLY "ENTRY" TO user_env[32] IN FRAME read-d-seq-mt.
        return no-apply.
    end.  
    
    /* Validate this when use defaults. It is not directly used 
       but it is prepended to other directories when valid 
      (invalid values are not prepended, and the user might have 
       thought it was, so we need to tell them that the root is wrong)  */
    if UseDefaultdirs
    and not validateDirectory(RootDirectory:screen-value in frame read-d-seq-mt) then 
    do:
        apply "entry" to RootDirectory IN FRAME read-d-seq-mt.        
        return no-apply.
    end.    

    IF SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-d-seq-mt) = ?  THEN 
    DO:
        MESSAGE "File" user_env[2] "does not exist" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        if user_env[2]:sensitive in FRAME read-d-seq-mt then
            APPLY "ENTRY" TO user_env[2] IN FRAME read-d-seq-mt.
        else
            APPLY "ENTRY" TO UseDefaultDirs IN FRAME read-d-seq-mt.
        
        RETURN NO-APPLY.
    END.
    assign user_env[32].
    if not setEffectiveTenant(user_env[32]) then
    do:
        apply "entry" to user_env[32].
        return no-apply.    
    end.
    run verify-cp.
 
END.


ON GO OF FRAME read-d-file-nobl
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-d-file-nobl) = ? 
  THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-d-file-nobl.
    RETURN NO-APPLY.
  END.
  user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-d-file-nobl.

  run verify-cp.
END.

ON GO OF FRAME read-input-cdc
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-input-cdc) = ? THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-input-cdc.
    RETURN NO-APPLY.
  END.
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-input-cdc.
     
  IF NOT user_env[2] MATCHES "*~~.cd" THEN
  DO:
	 MESSAGE "You must Provide a valid .cd file!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     APPLY "ENTRY" TO user_env[2].
     RETURN NO-APPLY.
  END. 
  
  run verify-cp.
END.

ON GO OF FRAME read-xml-file
DO:
  IF SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-xml-file) = ? 
  THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-xml-file.
    RETURN NO-APPLY.
  END.
  user_env[2]  = user_env[2]:SCREEN-VALUE IN FRAME read-xml-file.
END.

ON GO OF FRAME read-input-dir DO:
  DEFINE VARIABLE cDir AS CHARACTER   NO-UNDO.

  cDir = (IF user_env[2]:SCREEN-VALUE IN FRAME read-input-dir = "" THEN
            "./" ELSE user_env[2]:SCREEN-VALUE IN FRAME read-input-dir).
  FILE-INFO:FILE-NAME = cDir.
  IF FILE-INFO:FILE-NAME = ? OR
     INDEX(FILE-INFO:FILE-TYPE,"D") = 0 THEN DO:
    MESSAGE cDir "is not a directory or cannot be found!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
END.

ON GO OF FRAME read-dir-text DO:
  DEFINE VARIABLE cDir AS CHARACTER   NO-UNDO.
  
  cDir = (IF user_env[2]:SCREEN-VALUE IN FRAME read-dir-text = "" THEN
            "./" ELSE user_env[2]:SCREEN-VALUE IN FRAME read-dir-text).
  FILE-INFO:FILE-NAME = cDir.
  IF FILE-INFO:FILE-NAME = ? OR
     INDEX(FILE-INFO:FILE-TYPE,"D") = 0 THEN DO:
    MESSAGE cDir "is not a directory or cannot be found!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
END.

ON GO OF FRAME read-dir-nobl DO:
  DEFINE VARIABLE cDir AS CHARACTER   NO-UNDO.

  cDir = (IF user_env[2]:SCREEN-VALUE IN FRAME read-dir-nobl = "" THEN
            "./" ELSE user_env[2]:SCREEN-VALUE IN FRAME read-dir-nobl).
  FILE-INFO:FILE-NAME = cDir.
  IF FILE-INFO:FILE-NAME = ? OR
     INDEX(FILE-INFO:FILE-TYPE,"D") = 0 THEN DO:
    MESSAGE cDir "is not a directory or cannot be found!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
END.

ON GO OF FRAME read-d-dir
DO:
   
  IF inclob:SCREEN-VALUE IN FRAME read-d-dir = "no" THEN
      ASSIGN user_env[31] = " NO-LOBS".            
  ELSE
      ASSIGN user_env[31] = "".

  IF cCodePage:SCREEN-VALUE IN FRAME read-d-dir <> "" THEN
      ASSIGN user_env[10] = cCodePage:SCREEN-VALUE.            
END.

ON GO OF FRAME read-d-dir-mt
DO:   
    /* keep standard behavior (not done one value-changed in this frame though) */
    trimScreenValue(user_env[2]:handle in frame read-d-dir-mt).
    trimScreenValue(user_env[30]:handle in frame read-d-dir-mt).
    trimScreenValue(user_env[33]:handle in frame read-d-dir-mt).
    trimScreenValue(user_env[34]:handle in frame read-d-dir-mt).
    
    do with frame read-d-dir-mt:
        if not validateTenantName(user_env[32]:screen-value in frame read-d-dir-mt) then
        do:
            apply "entry" TO user_env[32] IN FRAME read-d-file-mt.
            return no-apply.
        end.  
        
        /* Validate this also if isAllMultiTenant when use defaults. Even if it is not directly in 
           use it is the first part of the other directories  */
        if (not isAllMultiTenant or UseDefaultdirs)
        and not validateDirectory(user_env[2]:screen-value in frame read-d-dir-mt) then 
        do:
            if user_env[2]:sensitive then       
                 apply "entry" to user_env[2] IN FRAME read-d-file-mt.
            else
                 apply "entry" to UseDefaultDirs IN FRAME read-d-file-mt.
                 
            return no-apply.
        end.    
       
        if not validateDirectory(user_env[33]:screen-value in frame read-d-dir-mt) then 
        do:
            apply "entry" to user_env[33] in frame read-d-dir-mt.
            return no-apply.
        end.    
         
        IF inclob:SCREEN-VALUE in frame read-d-dir-mt = "yes" 
        and not isAllMultiTenant 
        and not validateDirectory(user_env[30]:screen-value in frame read-d-dir-mt) then 
        do:
           apply "entry" to user_env[30] in frame read-d-dir-mt.
           return no-apply.
        end.    
        
        IF inclob:SCREEN-VALUE in frame read-d-dir-mt = "yes" 
        and not validateLoadTenantLobDirectory(user_env[34]:screen-value in frame read-d-dir-mt) then 
        do:
            apply "entry" to user_env[34] in frame read-d-dir-mt. 
            return no-apply.
        end.    
        
        assign user_env[32].
        if not setEffectiveTenant(user_env[32]) then
        do:
            apply "entry" to user_env[32].
            return no-apply.    
        end.
        
        IF inclob:SCREEN-VALUE IN FRAME read-d-dir-mt = "no" THEN
            ASSIGN user_env[31] = " NO-LOBS".            
        ELSE
            ASSIGN user_env[31] = "".
        
    end.                
END.

ON GO OF FRAME read-input
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-input) = ? THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-input.
    RETURN NO-APPLY.
  END.
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-input.
  run verify-cp.
END.

ON CHOOSE OF btn_Cancel IN FRAME read-xml-file
  APPLY "WINDOW-CLOSE" TO FRAME read-xml-file.

IF user_env[9] = "y" THEN DO:
  ON CHOOSE OF btn_Cancel IN FRAME read-input-dir
    APPLY "WINDOW-CLOSE" TO FRAME read-input-dir.
END.


IF user_env[9] = "t" THEN DO:
  ON CHOOSE OF btn_Cancel IN FRAME read-dir-text
    APPLY "WINDOW-CLOSE" TO FRAME read-dir-text.
END.
      
IF user_env[9] = "p" THEN DO:
  ON CHOOSE OF btn_Cancel IN FRAME read-input-cdc
    APPLY "WINDOW-CLOSE" TO FRAME read-input-cdc.
END.
	  
	  
/*----- ON WINDOW-CLOSE -----*/
on WINDOW-CLOSE of frame read-input
   apply "END-ERROR" to frame read-input.
ON WINDOW-CLOSE OF FRAME read-input-dir
   APPLY "END-ERROR" TO FRAME read-input-dir.
ON WINDOW-CLOSE OF FRAME read-d-seq-mt
   APPLY "END-ERROR" TO FRAME read-d-seq-mt.
ON WINDOW-CLOSE OF FRAME read-dir-text
   APPLY "END-ERROR" TO FRAME read-dir-text.
ON END-ERROR OF FRAME read-input-dir
  user_env[2] = ?.
ON END-ERROR OF FRAME read-d-seq-mt
  user_env[2] = ?.
ON END-ERROR OF FRAME read-dir-text
  user_env[2] = ?.
ON WINDOW-CLOSE OF FRAME read-dir-nobl
   APPLY "END-ERROR" TO FRAME read-dir-nobl.
on WINDOW-CLOSE of frame read-df
   apply "END-ERROR" to frame read-df.
on WINDOW-CLOSE of frame read-d-file
   apply "END-ERROR" to frame read-d-file.
on WINDOW-CLOSE of frame read-d-file-mt
   apply "END-ERROR" to frame read-d-file-mt.

on WINDOW-CLOSE of frame read-d-file-nobl
   apply "END-ERROR" to frame read-d-file-nobl.
on WINDOW-CLOSE of frame read-input-cdc
   apply "END-ERROR" to frame read-input-cdc.
on WINDOW-CLOSE of frame read-xml-file
   apply "END-ERROR" to frame read-xml-file.
on END-ERROR of frame read-xml-file
  user_env[2] = ?.
on WINDOW-CLOSE of frame read-d-dir
   apply "END-ERROR" to frame read-d-dir.
on WINDOW-CLOSE of frame read-d-dir-mt
   apply "END-ERROR" to frame read-d-dir-mt.
on END-ERROR of frame read-input-cdc
  user_env[2] = ?.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[2] in frame read-input
   user_env[2]:screen-value in frame read-input = 
        TRIM(user_env[2]:screen-value in frame read-input).
ON LEAVE OF user_env[2] IN FRAME read-input-dir
   user_env[2]:SCREEN-VALUE IN FRAME read-input-dir = 
        TRIM(user_env[2]:SCREEN-VALUE IN FRAME read-input-dir).
ON LEAVE OF user_env[2] IN FRAME read-dir-text
   user_env[2]:SCREEN-VALUE IN FRAME read-dir-text =
        TRIM(user_env[2]:SCREEN-VALUE IN FRAME read-dir-text).
ON LEAVE OF user_env[2] IN FRAME read-dir-nobl
   user_env[2]:SCREEN-VALUE IN FRAME read-dir-nobl = 
        TRIM(user_env[2]:SCREEN-VALUE IN FRAME read-dir-nobl).
ON LEAVE OF user_env[2] in frame read-df
   user_env[2]:screen-value in frame read-df = 
        TRIM(user_env[2]:screen-value in frame read-df).
ON LEAVE OF user_env[2] in frame read-d-file
   user_env[2]:screen-value in frame read-d-file = 
        TRIM(user_env[2]:screen-value in frame read-d-file).
ON LEAVE OF user_env[2] in frame read-d-file-nobl
   user_env[2]:screen-value in frame read-d-file-nobl = 
        TRIM(user_env[2]:screen-value in frame read-d-file-nobl).
ON LEAVE OF user_env[2] in frame read-input-cdc
   user_env[2]:screen-value in frame read-input-cdc = 
        TRIM(user_env[2]:screen-value in frame read-input-cdc).
ON LEAVE OF user_env[2] in frame read-xml-file
   user_env[2]:screen-value in frame read-xml-file = 
        TRIM(user_env[2]:screen-value in frame read-xml-file).

ON LEAVE OF user_env[2] in frame read-d-dir DO:
  user_env[2]:screen-value in frame read-d-dir = 
        TRIM(user_env[2]:screen-value in frame read-d-dir).
  IF user_env[2]:screen-value in frame read-d-dir <> ""  THEN DO:
     ASSIGN FILE-INFO:FILE-NAME = user_env[2]:screen-value in frame read-d-dir .
     IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
       MESSAGE FILE-INFO:FILE-NAME "is not a directory or can not be found" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
     END.
  END.
END.

ON LEAVE OF user_env[30] in frame read-d-file DO:
   user_env[30]:screen-value in frame read-d-file = 
        TRIM(user_env[30]:screen-value in frame read-d-file).
   IF user_env[30]:screen-value in frame read-d-file <> ""  THEN DO:
     ASSIGN FILE-INFO:FILE-NAME = user_env[30]:screen-value in frame read-d-file .
     IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
       MESSAGE FILE-INFO:FILE-NAME "is not a directory or can not be found" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
     END.
  END.
END.

ON LEAVE OF user_env[30] in frame read-d-dir DO:
  user_env[30]:screen-value in frame read-d-dir = 
        TRIM(user_env[30]:screen-value in frame read-d-dir).
   IF user_env[30]:screen-value in frame read-d-dir <> ""  THEN DO:
     ASSIGN FILE-INFO:FILE-NAME = user_env[30]:screen-value in frame read-d-dir .
     IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
       MESSAGE FILE-INFO:FILE-NAME "is not a directory or can not be found" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
     END.
  END.
END.

/*-----On value change of flags --*/
ON VALUE-CHANGED OF stop_flg IN FRAME read-df DO:
  IF SELF:screen-value = "yes" THEN DISABLE commit_flg WITH FRAME read-df.
  ELSE DO: 
      IF no-schema-lock:SCREEN-VALUE IN FRAME read-df = "no" THEN
        ENABLE commit_flg WITH FRAME read-df.   
  END.
  RETURN.
END.
ON VALUE-CHANGED OF commit_flg IN FRAME read-df DO:
  IF SELF:screen-value = "yes" THEN 
      DISABLE stop_flg no-schema-lock WITH FRAME read-df.
  ELSE 
      ENABLE stop_flg no-schema-lock WITH FRAME read-df.
  RETURN.
END.

ON VALUE-CHANGED OF no-schema-lock IN FRAME read-df DO:
  IF SELF:screen-value = "yes" THEN DISABLE commit_flg WITH FRAME read-df.      
  ELSE DO:
    IF stop_flg:SCREEN-VALUE IN FRAME read-df = "no" THEN
      ENABLE commit_flg WITH FRAME read-df.      
  END.
  RETURN.
END.

ON VALUE-CHANGED OF user_env[2] IN FRAME read-d-dir-mt
do:
    refreshDirInDirUI().
end.   

ON VALUE-CHANGED OF user_env[30] in frame read-d-file-mt do: 
    assign frame read-d-file-mt user_env[30].         
end.

ON VALUE-CHANGED OF user_env[30] in frame read-d-dir-mt do: 
    assign frame read-d-dir-mt user_env[30].    
end.

ON VALUE-CHANGED OF user_env[32] in frame read-d-dir-mt do: 
    refreshTenantInDirUI ().
end.

ON VALUE-CHANGED OF user_env[32] in frame read-d-file-mt do: 
    refreshTenantInfileUI ().
end.

ON VALUE-CHANGED OF user_env[32] in frame read-d-seq-mt do: 
    refreshTenantInSeqUI ().
end.

ON VALUE-CHANGED OF user_env[33] in frame read-d-dir-mt do: 
    assign frame read-d-dir-mt user_env[33].        
end.

ON VALUE-CHANGED OF user_env[34] in frame read-d-dir-mt do: 
    assign frame read-d-dir-mt user_env[34].        
end.


ON VALUE-CHANGED OF inclob IN FRAME read-d-file 
DO:
    refreshLobField(SELF:screen-value IN FRAME read-d-file = "yes",user_env[30]:handle IN FRAME read-d-file ).
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
        btn_dir:sensitive in frame read-d-file = SELF:screen-value IN FRAME read-d-file = "yes".
    &ENDIF
END.

ON VALUE-CHANGED OF inclob IN FRAME read-d-file-mt 
DO:
    refreshFileMTState().
END.

ON VALUE-CHANGED OF inclob IN FRAME read-d-dir 
DO:
    refreshLobField(SELF:screen-value = "yes",user_env[30]:handle IN FRAME read-d-dir  ).
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
        btn_dir2:sensitive in frame read-d-dir = SELF:screen-value IN FRAME read-d-dir = "yes".
    &ENDIF
END.

ON VALUE-CHANGED OF inclob IN FRAME read-d-dir-mt
DO:
     refreshDirMTState().
END.

ON VALUE-CHANGED OF UseDefaultDirs IN FRAME read-d-dir-mt
do:
    assign frame read-d-dir-mt UseDefaultDirs.
    if UseDefaultDirs then
        refreshDirMT(). 
    
    refreshDirMtState().
end.


ON VALUE-CHANGED OF UseDefaultDirs IN FRAME read-d-file-mt
do:
    assign FRAME read-d-file-mt UseDefaultDirs.
    if UseDefaultDirs then
        refreshFileMT(). 
    
    refreshFileMtState().
end.

ON VALUE-CHANGED OF UseDefaultDirs IN FRAME read-d-seq-mt
do:
    assign frame read-d-seq-mt UseDefaultDirs.
    if UseDefaultDirs then
        refreshSeqMT(). 
    
    refreshSeqMtState().
end.


ON VALUE-CHANGED OF RootDirectory IN FRAME read-d-file-mt
do:
    refreshDirInFileUI(). 
    
end.


/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame read-input DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-input /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-df DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-df /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-d-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-d-file /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-d-file-mt DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-d-file-mt /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-d-seq-mt DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-d-seq-mt /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-d-file-nobl DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-d-file-nobl /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-input-cdc DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-input-cdc /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-xml-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-xml-file /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
        
END.
ON CHOOSE OF btn_Tenant IN FRAME read-d-file-mt
DO:
    selectTenant(user_env[32]:handle IN FRAME read-d-file-mt).      
END.
ON CHOOSE OF btn_Tenant IN FRAME read-d-dir-mt
DO:
    selectTenant(user_env[32]:handle IN FRAME read-d-dir-mt).
END.
ON CHOOSE OF btn_Tenant IN FRAME read-d-seq-mt
DO:
    selectTenant(user_env[32]:handle IN FRAME read-d-seq-mt).
END.


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
  ON CHOOSE OF btn_dir in frame read-d-file DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[30]:handle in frame read-d-file /*Fillin*/,
        INPUT "Find Lob Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.
  ON CHOOSE OF btn_dir in frame read-d-file-mt DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[30]:handle in frame read-d-file-mt /*Fillin*/,
        INPUT "Find Lob Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
    apply "value-changed" to user_env[30] in frame read-d-file-mt.    
  END.
  
  ON CHOOSE OF btn_dir in frame read-input-dir DO:
    RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[2]:handle in frame read-input-dir /*Fillin*/,
        INPUT "Choose Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.
  ON CHOOSE OF btn_dir in frame read-dir-text DO:
    RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[2]:handle in frame read-dir-text /*Fillin*/,
        INPUT "Choose Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.
  ON CHOOSE OF btn_dir in frame read-dir-nobl DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[2]:handle in frame read-dir-nobl /*Fillin*/,
        INPUT "Choose Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.
  ON CHOOSE OF btn_dir in frame read-d-dir DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[2]:handle in frame read-d-dir /*Fillin*/,
        INPUT "Find File Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.
  ON CHOOSE OF btn_dir in frame read-d-dir-mt DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[2]:handle in frame read-d-dir-mt /*Fillin*/,
        INPUT "Find File Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
   apply "value-changed" to user_env[2] in frame read-d-dir-mt.    
  END.
  
  ON CHOOSE OF btn_dir2 in frame read-d-dir DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[30]:handle in frame read-d-dir /*Fillin*/,
        INPUT "Find Lob Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.
  ON CHOOSE OF btn_dir2 in frame read-d-dir-mt DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[30]:handle in frame read-d-dir-mt /*Fillin*/,
        INPUT "Find Lob Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
    apply "value-changed" to user_env[30] in frame read-d-dir-mt.    
  END.
  ON CHOOSE OF btn_dirmt in frame read-d-dir-mt DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[33]:handle in frame read-d-dir-mt /*Fillin*/,
        INPUT "Find File Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
    apply "value-changed" to user_env[33] in frame read-d-dir-mt.    
   
  END.
  ON CHOOSE OF btn_dirmtlob in frame read-d-dir-mt DO:
    RUN "prodict/misc/_dirbtn.p"
        (INPUT user_env[34]:handle in frame read-d-dir-mt /*Fillin*/,
         INPUT "Find File Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
    apply "value-changed" to user_env[34] in frame read-d-dir-mt.    
    
  END.
  
  ON CHOOSE OF btn_dirRoot in frame read-d-file-mt DO:
    RUN "prodict/misc/_dirbtn.p"
        (INPUT RootDirectory:handle in frame read-d-file-mt /*Fillin*/,
         INPUT "Find File Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
    apply "value-changed" to RootDirectory in frame read-d-file-mt.    
    
  END.
  ON CHOOSE OF btn_dirRoot in frame read-d-seq-mt DO:
    RUN "prodict/misc/_dirbtn.p"
        (INPUT RootDirectory:handle in frame read-d-seq-mt /*Fillin*/,
         INPUT "Find File Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
    apply "value-changed" to RootDirectory in frame read-d-seq-mt.    
    
  END.

  
&ENDIF
/*=======================Internal Procedures==========================*/

PROCEDURE verify-cp:
  /* Is there a defined codepage? Try to read it in the trailer, if
   * not, ask for it
   */
  ASSIGN codepage = "".
  RUN read-cp. /* read the code page in the file */
  IF codepage = "" OR codepage = ? OR codepage = "(no conversion)" THEN
  DO:
     MESSAGE "There is no Code Page defined in this input file." view-as
        ALERT-BOX ERROR BUTTONS OK.
     RUN get-cp. /* prompt for it */
  END.
  ELSE user_env[10] = codepage.
END PROCEDURE.

PROCEDURE read-cp.
  /* Read trailer of file and find codepage */
  /* (partially stolen from lodtrail.i)     */
  
  DEFINE VARIABLE tempi AS DECIMAL          NO-UNDO.
  DEFINE VARIABLE j     AS INTEGER          NO-UNDO.
  DEFINE VARIABLE iPos  AS INT64            NO-UNDO.

  INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  iPos = SEEK(INPUT) - 11.
  SEEK INPUT TO iPos. /* position to possible beginning of last line */

  /* Now we need to deal with a large offset, which is a variable size
     value in the trailer, for large values.
     Now go back one character at a time until we find a new line or we have
     gone back too far.
     For the non-large offset format, the previous char will be a
     newline character, so we will  detect that right away and read the
     value as usual. Unless the file has CRLF (Windows), in which case
     we will go back 1 character to read the value properly - to
     account for the extra byte.
     For larger values, we will read as many digits as needed.
     The loop below could stop after 10 digits, but I am letting it go
     up to 50 to try to catch a bad value.
  */
  DO WHILE LASTKEY <> 13 AND j <= 50:
     ASSIGN j = j + 1
            iPos = iPos - 1.
     SEEK INPUT TO iPos.
     READKEY PAUSE 0.
  END.

  /* now we can start reading it */
  READKEY PAUSE 0.
  ASSIGN
    lvar# = 0
    lvar  = ""
    iPos  = 0.

  DO WHILE LASTKEY <> 13 AND iPos <> ?: /* get byte count (last line) */

      IF LASTKEY > 47 AND LASTKEY < 58 THEN DO:
          /* check if can fit the value into an int64 type. We need
             to manipulate it with a decimal so that we don't get fooled
             by a value that overflows. This is so that we catch a
             bad offset in the file.
           */
          ASSIGN tempi = iPos /* first move it to a decimal */
                 tempi = tempi * 10 + LASTKEY - 48. /* get new value */
          iPos = INT64(tempi) NO-ERROR. /* see if it fits into an int64 */
          
          /* check if the value overflows becoming negative or an error happened. 
             If so, something is wrong (too many digits or invalid values),
             so forget this.
          */
          IF  iPos < 0 OR
              ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
              ASSIGN iPos = 0.
              LEAVE. /* we are done with this */
          END.

      END.
      ELSE 
          ASSIGN iPos = ?. /* bad character */

    READKEY PAUSE 0.
  END.

  IF iPos > 0 then run get_psc (INPUT iPos). /* get it */
  ELSE RUN find_psc. /* look for it */
  INPUT CLOSE.
  DO iPos = 1 TO lvar#:
    IF lvar[iPos] BEGINS "cpstream=" OR lvar[iPos] BEGINS "codepage" THEN
       codepage = TRIM(SUBSTRING(lvar[iPos],10,-1,"character":U)).
  END.
END PROCEDURE.

PROCEDURE get-cp.
   /* Prompt for codepage */
   DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE WITH FRAME get-cp:
       ASSIGN codepage = SESSION:STREAM.
       UPDATE codepage btn_OK btn_Cancel {&HLP_BTN_NAME}.
       ASSIGN user_env[10] = codepage.
   END.
END PROCEDURE.

PROCEDURE get_psc:
  DEFINE INPUT PARAMETER piPos AS INT64 NO-UNDO.

  /* using the byte count, we scoot right down there and look for
   * the beginning of the trailer ("PSC"). If we don't find it, we
   * will go and look for it.
   */

  DEFINE VARIABLE rc AS LOGICAL INITIAL no.
  _psc:
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SEEK INPUT TO piPos. /* skip to beginning of "PSC" in file */
    READKEY PAUSE 0. IF LASTKEY <> ASC("P") THEN LEAVE _psc. /* not there!*/
    READKEY PAUSE 0. IF LASTKEY <> ASC("S") THEN LEAVE _psc.
    READKEY PAUSE 0. IF LASTKEY <> ASC("C") THEN LEAVE _psc.
    ASSIGN rc = yes. /* found it! */
    RUN read_bits (INPUT piPos). /* read trailer bits */
  END.
  IF NOT rc THEN RUN find_psc. /* look for it */
END PROCEDURE.

PROCEDURE find_psc:
  /* If the bytecount at the end of the file is wrong, we will jump
   * back the maximum number of bytes in a trailer and start looking
   * from there. If we still don't find it then tough luck.
   * NOTE: Variable p holds the number of bytes to roll back. AS of
   * 7/21/94, the max size of a trailer (.d) is 204 bytes, if you add
   * anything to this trailer, you must change this number to reflect
   * the number of bytes you added. I'll use 256 to add a little padding. (gfs)
   */
  DEFINE VARIABLE p AS INT64    INITIAL 256. /* really 204, added extra just in case */
  DEFINE VARIABLE l AS INT64.                /* LAST char position */
  
  SEEK INPUT TO END.
  ASSIGN l = SEEK(INPUT). /* EOF */
  SEEK INPUT TO SEEK(INPUT) - MINIMUM(p,l). /* take p, or size of file */
  IF SEEK(INPUT) = ? THEN RETURN.
  _scan:
  REPEAT ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    READKEY PAUSE 0.
    p = SEEK(INPUT). /* save off where we are looking */
    IF LASTKEY = ASC("P") THEN DO:
       READKEY PAUSE 0.
       IF LASTKEY <> ASC("S") THEN NEXT.
       ELSE DO: /* found "PS" */
         READKEY PAUSE 0.
         IF LASTKEY <> ASC("C") THEN NEXT.
         ELSE DO: /* found "PSC"! */
           RUN read_bits (INPUT p - 1).
           LEAVE.
         END. /* IF "C" */
       END. /* IF "S" */    
    END. /* IF "P" */
    ELSE IF p >= l THEN LEAVE _scan. /* at EOF, so give up */
  END. /* repeat */
END.

PROCEDURE read_bits:
  /* reads trailer given a starting position 
   */ 
  DEFINE INPUT PARAMETER pi as INT64  . /* "SEEK TO" location */
    
  SEEK INPUT TO pi.
  REPEAT:
    IMPORT lvar[lvar# + 1].
    lvar# = lvar# + 1.
  END.
END PROCEDURE. 

 
/*==========================Mainline code=============================*/
{adecomm/okrun.i
  &FRAME = "FRAME get-cp"
  &BOX   = "rect_Btns"
  &OK    = "btn_OK"
  {&CAN_BTN}
  {&HLP_BTN}
  }

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

if int(dbversion("dictdb")) > 10 then
do:
   isSuperTenant = can-find(first dictdb._tenant) and  tenant-id("dictdb") < 0.
end.

ASSIGN
  class    = SUBSTRING(user_env[9],1,-1,"character")
  io-file  = TRUE
  io-frame = ""
    prefix   = "".
             /*(IF OPSYS = "UNIX" THEN "./"
               ELSE IF CAN-DO("MSDOS,OS2",OPSYS) THEN ".~\"
               ELSE "")*/

/* if user_env[1] is "" for class "f", then list is in user_longchar 
   because it was too big to fi into user_env[1].
*/
IF user_env[1] = "" AND class = "f" THEN
   ASSIGN is-some  = (user_longchar MATCHES "*,*").
ELSE
   ASSIGN is-some  = (user_env[1] MATCHES "*,*").

ASSIGN
  is-all   = (user_env[1] = "ALL")
  is-one   = NOT is-all AND NOT is-some.

IF dict_rog THEN msg-num = 3. /* look but don't touch */

/*-------------------------------------------------*/ /* Hide message */
IF class = "h" THEN DO:
  /* Fernando: gives the user time to see the error message that the 
     client issued instead of flashing the messages */
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
     HIDE MESSAGE NO-PAUSE.
  &ENDIF
  
  ASSIGN SESSION:SCHEMA-CHANGE = user_env[35].
 
   /* Fernando: 20020129-017 Also, if there was an error that backed out the changes, 
   do not display the message */
  IF user_env[4] = "error" THEN
     MESSAGE "Load aborted." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE IF user_env[4] = "error_objattrs" THEN
      MESSAGE "Load of policies and/or object attributes failed." 
         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE
      MESSAGE "Load completed." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     
   RETURN.
END.
/*----------------------------------------*/ /* LOAD FILE DEFINITIONS */
IF class = "d" OR class begins "4" or class = "s" THEN DO:

  IF msg-num = 0 THEN DO FOR DICTDB._File iVar = 1 TO 4:
    FIND DICTDB._File
      WHERE DICTDB._File._File-name = ENTRY(iVar,"_Db,_File,_Field,_Index")
        AND DICTDB._File._Owner = "PUB".
    IF   NOT CAN-DO(_Can-read,  USERID("DICTDB"))
      OR NOT CAN-DO(_Can-write, USERID("DICTDB"))
      OR NOT CAN-DO(_Can-delete,USERID("DICTDB"))
      OR NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN msg-num = 4.    
  END.
  ASSIGN
    base        = PDBNAME(user_dbname)
    user_env[2] = (IF class = "s" THEN "_seqdefs.df"
                  ELSE IF class = "4t" THEN "_trgdefs.df"
                  ELSE
                  ((IF base = "" OR base = ? THEN user_dbname ELSE base) 
                                                                 + ".df"))
    io-frame    = "df"
    io-title    = (IF class = "s" THEN "Load Sequence Definitions"
                   ELSE IF class = "4" THEN "Load AS/400 Definitions File"
                   ELSE IF class = "4t" THEN "Load Database Triggers"
                   ELSE "Load Data Definitions")
    user_env[4] = "n"          /* stop on first error - used by _lodsddl.p */
    user_env[8] = user_dbname  /* dbname to load into - used by _lodsddl.p */
    class = "d". /* if class was 's', reassign to run as class 'd' after 
                    input file name default (user_env[2]) */
    
END.

/*--------------------------------------*/ /* LOAD DATA FILE CONTENTS */
ELSE IF class = "f" THEN DO FOR DICTDB._File:

  /* read-only status is relevant only for PROGRESS-db's */
  /* schemaholders can be in read-only mode and still    */
  /* allow data to be loaded!                            */
  IF dict_rog 
    AND msg-num = 3
    AND user_dbtype <> "PROGRESS"
    THEN ASSIGN msg-num = 0. 

  noload = "u".
  { prodict/dictgate.i &action=undumpload
    &dbtype=user_dbtype &dbrec=drec_db &output=noload
  }

  FIND DICTDB._File  WHERE DICTDB._FIle._File-name = "_File"
                       AND DICTDB._File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 4.
  RELEASE DICTDB._File.
  IF NOT is-all AND NOT is-some THEN
  DO:
    FIND DICTDB._File WHERE _Db-recid = drec_db AND _File-name = user_env[1]
                        AND (_Owner = "PUB" OR _Owner = "_FOREIGN").
    
  END.
  
  /* using base_lchar to make code below simplier */
  IF NOT isCpUndefined AND (is-one OR is-some) THEN DO:
     /* if user_env[1] is "", then value is in user_longchar */
     IF user_env[1] NE "" THEN
         base_lchar = user_env[1].
     ELSE
         base_lchar = user_longchar.
  END.
  ELSE
     base = (IF is-one OR is-some THEN user_env[1] ELSE "").


  ASSIGN
    user_env[2] = prefix + (IF is-all OR is-some THEN "" ELSE
                  (IF DICTDB._File._Dump-name = ?
                  THEN DICTDB._File._File-name ELSE DICTDB._File._Dump-name)
                + ".d")
    user_env[4] = "0"
    io-file     = NOT is-all AND NOT is-some /* read from file/dir */
    io-frame    = "d"
    io-title    = "Load Data Contents for"
                + " " + (IF is-all THEN "All Tables" /*allfiles*/
                  ELSE  IF is-some THEN "Some Tables" /*somefiles*/
                  ELSE "Table ~"" + user_env[1] + "~"")
    user_env[1] = ""
    user_longchar = (IF isCpUndefined THEN user_longchar ELSE "")
    comma       = ""
    iVar           = 1
    cCodePage    = SESSION:STREAM.

  /* If user had selected ALL, fill base array with list of files.  
     Otherwise, it is already set to file list.
  */
  IF is-all THEN FOR EACH DICTDB._File
    WHERE DICTDB._File._File-number > 0
      AND DICTDB._File._Db-recid = drec_db
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
      AND NOT DICTDB._File._Hidden
      AND DICTDB._File._Tbl-Type <> "V"
      AND CAN-DO(DICTDB._File._Can-create,USERID(user_dbname))
      AND (noload = "" OR NOT CAN-DO(noload,DICTDB._File._For-type))
    BY DICTDB._File._File-name:
    IF DICTDB._File._Owner = "_FOREIGN" AND DICTDB._File._For-Type <> "TABLE" THEN
        NEXT.

    IF isCpUndefined THEN
       base = base + (IF base = "" THEN "" ELSE ",") + DICTDB._File._File-name.
   ELSE
       base_lchar = base_lchar + (IF base_lchar = "" THEN "" ELSE ",") + DICTDB._File._File-name.
  END.

  /* Run through the file list and cull out the ones that the user
     is not allowed to dump for some reason.
  */
  user_env[5] = "".

  ASSIGN numCount = (IF isCpUndefined THEN NUM-ENTRIES(base)
                     ELSE NUM-ENTRIES(base_lchar)).
         isAllMultiTenant = ?.

  DO iVar = 1 TO numCount:
    err = ?.
    dis_trig = "y".
    cItem = ENTRY(iVar,(IF isCpUndefined THEN base ELSE base_lchar)).
    FIND DICTDB._File
      WHERE _Db-recid = drec_db AND _File-name = cItem
        AND (_Owner = "PUB" OR _Owner = "_FOREIGN").   
    IF DICTDB._File._Owner = "_FOREIGN" AND DICTDB._File._For-type <> "TABLE" THEN DO:
      MESSAGE 'The file "' DICTDB._File._File-name  '" does not have a foreign' SKIP
              'type of "TABLE". It is therefore being skipped' SKIP
              VIEW-AS ALERT-BOX WARNING.
      NEXT.
    END.
    IF NOT CAN-DO(DICTDB._File._Can-create,USERID(user_dbname)) THEN
      err = DICTDB._File._File-name
        + " will not be loaded due to insufficient privileges.".
    ELSE
    IF noload <> "" AND CAN-DO(noload,DICTDB._File._For-type) THEN
      err = "".
        /*SUBSTITUTE("&1 is a &2 &3 and cannot be dumped.",
          DICTDB._File._File-name,user_dbtype,DICTDB._File._For-type).*/
    ELSE DO:
      
      
      {prodict/dump/ltrigchk.i &OK = answer}
      IF NOT answer THEN DO:
         MESSAGE "You do not have privileges to load table" DICTDB._File._File-name 
                 SKIP
                 "with triggers disabled.  Do you want to load this table" SKIP
                 "anyway even though the triggers will fire?"
                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE answer.
         IF answer = no THEN
            err = "".  /* don't do this table but no more messages */
         ELSE IF answer = yes THEN DO:
            err = ?.   /* include this table in load */
            dis_trig = "n".
         END.
         ELSE DO:    /* cancel the load operation */
            user_path = "".
            RETURN.
         END.
      END.
    END.

    IF err = ? THEN DO:
      IF isCpUndefined THEN
         user_env[1] = user_env[1] + comma + DICTDB._File._File-name.
      ELSE
         user_longchar = user_longchar + comma + DICTDB._File._File-name.

      /* now we will only put the table number of tables that we will not
         disable triggers for, which is the exception (to most cases).
      */
      IF dis_trig = "n" THEN DO:
         IF user_env[5] = "" THEN
            user_env[5] = STRING(_File._File-number).
         ELSE
             user_env[5] = user_env[5] + "," + STRING(_File._File-number).
      END.

      ASSIGN  comma       = ",".
    END.
    ELSE IF err <> "" THEN DO:
      MESSAGE err SKIP "Do you want to continue?"
         VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO UPDATE answer.
      IF answer = FALSE THEN DO:
        user_path = "".
        RETURN.
      END.
    END.
    
    if isSuperTenant then 
    do:         
        if isAnyMultiTenant = false then 
            isAnyMultiTenant = _file._file-attributes[1].
       
        if isAllMultiTenant = ? or isAllMultiTenant then
           isAllMultiTenant = _file._file-attributes[1].   
    end.
  END. /* do ivar = 1 to num  */
   
  /* subsequent removal of files changed from many to one, so reset ui stuff */
  IF (is-some OR is-all) AND
      NUM-ENTRIES((IF isCpUndefined THEN user_env[1] ELSE user_longchar)) = 1 THEN DO:

    IF NOT isCpUndefined THEN
       ASSIGN user_env[1] = user_longchar
              user_longchar ="".

    FIND DICTDB._File
      WHERE DICTDB._File._Db-recid = drec_db
        AND DICTDB._File._File-name = user_env[1]
        AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN").
    
    ASSIGN
      is-some     = FALSE
      is-all      = FALSE
      is-one      = TRUE
      user_env[2] = prefix + (IF DICTDB._File._Dump-name = ?
                    THEN DICTDB._File._File-name ELSE DICTDB._File._Dump-name)
                  + ".d"
      io-file     = TRUE
      io-title    = "Load Data Contents for Table ~"" + user_env[1] + "~""
      base        = user_env[1].
  END.
  ELSE DO: 
      IF NOT isCpUndefined THEN DO:
          /* see if we can put user_longchar into user_env[1] */
          ASSIGN user_env[1] = user_longchar NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN
             ASSIGN user_longchar = "".
          ELSE
             ASSIGN user_env[1] = "".
      END.
  END.

END.

/*-----------------------------------------------*/ /* LOAD SEQ VALS */
ELSE IF class = "k" THEN DO FOR DICTDB._File:
  FIND DICTDB._File "_Sequence".
  IF NOT CAN-DO(_Can-write,USERID("DICTDB")) THEN msg-num = 4.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_seqvals.d"
    io-title    = "Load Sequence Current Values".
END.

/*--------------------------------------*/ /* LOAD USER FILE CONTENTS */
ELSE IF class = "u" THEN DO FOR DICTDB._File:
  FIND DICTDB._File "_User".
  IF NOT CAN-DO(_Can-write, USERID("DICTDB"))
    OR NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN msg-num = 4.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_user.d"
    io-title    = "Load User Table Contents".
END.

/*--------------------------------------*/ /* LOAD VIEW FILE CONTENTS */
ELSE IF class = "v" THEN DO FOR DICTDB._File:
  FIND DICTDB._File "_View".
  IF NOT CAN-DO(_Can-write, USERID("DICTDB"))
    OR NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN msg-num = 4.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 2.
  ASSIGN
    user_env[2] = prefix + "_view.d"
    io-title    = "Load SQL Views".
END.

IF msg-num > 0 THEN DO:
  MESSAGE (
    IF msg-num = 1 THEN
      "Cannot load User information for non-{&PRO_DISPLAY_NAME} database."
    ELSE IF msg-num = 2 THEN
      "Cannot load View information for non-{&PRO_DISPLAY_NAME} database."
    ELSE IF msg-num = 3 THEN
      "The dictionary is in read-only mode - alterations not allowed."
    ELSE
      "You do not have permission to use this option.")
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  IF CAN-DO("t,x,y",class) THEN
    user_env[2] = ?.
  RETURN.
END.

PAUSE 0.

/* if filename contains the .db, then remove it */
IF INDEX(user_env[2],".db") > 0 THEN
        SUBSTRING(user_env[2],INDEX(user_env[2],".db"),3,"RAW") = "".

IF io-frame = "df" THEN DO:
  /* Adjust the graphical rectangle and the ok and cancel buttons */
  {adecomm/okrun.i  
   &FRAME  = "FRAME read-df" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
  }


  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-df:
     ENABLE stop_flg commit_flg err-to-file err-to-screen no-schema-lock 
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN warntxt &ENDIF 
         WITH FRAME read-df.

     ASSIGN stop_flg = user_env[4] BEGINS "y".
    
    UPDATE user_env[2] btn_File stop_flg commit_flg err-to-file err-to-screen 
           no-schema-lock btn_OK btn_Cancel {&HLP_BTN_NAME}.

    ASSIGN user_env[15] = STRING(commit_flg)
           user_env[4] = STRING(stop_flg).
    IF no-schema-lock THEN
      ASSIGN user_path = "_lodv5df,*C,_lodsddl,9=h,_usrload"
             oldsession = SESSION:SCHEMA-CHANGE
             SESSION:SCHEMA-CHANGE = "NEW OBJECTS"
              user_env[35] = oldsession.
    ELSE
      ASSIGN user_path = "*T,_lodv5df,*C,_lodsddl,9=h,_usrload"
             user_env[35] = "".
    
    { prodict/dictnext.i trash }
    canned = FALSE.
        user_env[6] = 
         IF (err-to-file AND NOT err-to-screen) THEN "f" 
         ELSE IF (err-to-file AND err-to-screen) THEN "b" 
         ELSE IF (NOT err-to-file AND err-to-screen) THEN "s"
         ELSE "f".
    
  END.
END.

ELSE IF io-frame = "d" THEN DO:
  
  IF NOT io-file THEN 
  DO:
    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
        if isAnyMultitenant then
        do with frame read-d-dir-mt:
            {adecomm/okrun.i  
              &FRAME  = "FRAME read-d-dir-mt" 
              &BOX    = "rect_Btns"
              &OK     = "btn_OK" 
              {&CAN_BTN}
              {&HLP_BTN}
              }
            
            assign 
                UseDefaultDirs = true
                user_env[32]   = get-effective-tenant-name("dictdb")
                err%           = INTEGER(user_env[4]).
            
            refreshDirDefaults().  
            
            display 
                user_env[32] 
                UseDefaultDirs
                user_env[2] 
                user_env[33] 
                inclob
                user_env[30]
                user_env[34] 
                err% 
                .
           
            /* 
            if isAllMultiTenant then 
            do:
                user_env[2] = "".
                user_env[30] = "".
                user_env[2]:hidden in frame read-d-dir-mt = true.
                user_env[30]:hidden in frame read-d-dir-mt = true.
            end.      
              */
                              
            &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
            
            if not isAllMultiTenant then
            do:
                entry(1,idir_lbl," ") = "Shared".
                display idir_lbl ldir_lbl.
            end.
             
            display tenant_lbl idirmt_lbl ldirmt_lbl.
            
            enable user_env[32] 
                   btn_Tenant
                   UseDefaultDirs
                   user_env[2]  
                   btn_dir  
                   user_env[33] 
                   btn_dirmt 
                   inclob 
                   user_env[30]  
                   btn_dir2 
                   user_env[34] 
                   btn_dirmtlob 
                   err% 
                   do-screen 
                   btn_OK 
                   btn_Cancel  
                   {&HLP_BTN_NAME}.
            &ELSE
            
            if isAllMultiTenant then 
            do:           
                user_env[30]:row in frame read-d-dir-mt = user_env[34]:row in frame read-d-dir-mt.
                user_env[30]:side-label-handle:hidden in frame read-d-dir-mt = yes.
            end.
               
            enable 
                   user_env[32]
                   btn_Tenant
                   UseDefaultDirs
                   user_env[2]  
                   user_env[33]
                   inclob 
                   user_env[30] WHEN NOT isAllMultiTenant
                   user_env[34]
                   err%
                   do-screen 
                   btn_OK 
                   btn_Cancel  
                   {&HLP_BTN_NAME}.
            
            &ENDIF         
                        
            refreshDirMTState().
            wait-for "go" of frame read-d-dir-mt.
          
           /* danger danger: this must be qualified to use the frame of the 
              do block (it is possible that the frame qual only is needed on the first field) */ 
            
            ASSIGN 
                   frame read-d-dir-mt user_env[32]
                   frame read-d-dir-mt UseDefaultDirs
                   frame read-d-dir-mt user_env[2]  
                   frame read-d-dir-mt user_env[33]
                   frame read-d-dir-mt inclob 
                   frame read-d-dir-mt user_env[30]  
                   frame read-d-dir-mt user_env[34]
                   frame read-d-dir-mt err%
                   frame read-d-dir-mt do-screen 
                   user_env[6] = (IF do-screen THEN "s" ELSE "f")
                   user_env[4] = STRING(err%).
            
            RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).
            RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[30]).
            if UseDefaultDirs then
            do:
                 user_env[33] = gUseDefaultOut.
                 user_env[40] = gLobfolderName.
            end.
            else
            do:
                 user_env[40] = "".     
                 RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[33]).
            end.
            RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[34]).
            
            DISPLAY user_env[2] user_env[30] user_env[33] user_env[34].
           { prodict/dictnext.i trash }
            canned = FALSE.
        end. /* if isAnyMultiTenant */
        else do with frame read-d-dir:    
              {adecomm/okrun.i  
                 &FRAME  = "FRAME read-d-dir" 
                 &BOX    = "rect_Btns"
                 &OK     = "btn_OK" 
                 {&CAN_BTN}
                 {&HLP_BTN}
                }
         
            &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
            
            display idir_lbl ldir_lbl.
            ENABLE user_env[2] 
                   btn_dir 
                   inclob 
                   user_env[30] 
                   btn_dir2
                   cCodePage 
                   err% 
                   do-screen 
                   btn_OK 
                   btn_Cancel.
            ASSIGN err% = INTEGER(user_env[4]).
    
            UPDATE user_env[2] 
                   btn_dir 
                   inclob 
                   user_env[30] 
                   btn_dir2
                   cCodePage     
                   err% 
                   do-screen 
                   btn_OK 
                   btn_Cancel  
                   {&HLP_BTN_NAME}.
            &ELSE
            
            ENABLE user_env[2] inclob user_env[30] cCodePage err% do-screen btn_OK btn_Cancel.
            ASSIGN err% = INTEGER(user_env[4]).
    
            UPDATE user_env[2] 
                   inclob 
                   user_env[30]
                   cCodePage 
                   err%
                   do-screen 
                   btn_OK 
                   btn_Cancel  
                   {&HLP_BTN_NAME}.
            &ENDIF
            
            ASSIGN user_env[6] = (IF do-screen THEN "s" ELSE "f").
    
            RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).
            RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[30]).
            
            DISPLAY user_env[2] user_env[30].
            user_env[4] = STRING(err%).
    
            { prodict/dictnext.i trash }
            canned = FALSE.
     
        end. /* not isAnyMultitenant */
    END. /* do on error */
  END. /* not io-file */
  ELSE DO:
    
    if isAnyMultitenant then
    do WITH FRAME read-d-file-mt:
         {adecomm/okrun.i  
         &FRAME  = "FRAME read-d-file-mt" 
         &BOX    = "rect_Btns"
         &OK     = "btn_OK" 
         {&CAN_BTN}
         {&HLP_BTN}
        }
        
        assign 
            UseDefaultDirs = true
            user_env[32]  = get-effective-tenant-name("dictdb")
            err% = INTEGER(user_env[4])
            gFileName = user_env[2].
              
        refreshFileDefaults(). 
        
        display user_env[32] 
                UseDefaultDirs
                user_env[2] 
                user_env[30] 
                err%
                inclob.
              
        DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
          &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
            ENABLE user_env[32]
                   btn_tenant 
                   UseDefaultDirs 
                   RootDirectory
                   user_env[2] 
                   btn_File 
                   inclob 
                   user_env[30] 
                   btn_dir 
                   err% 
                   do-screen 
                   btn_OK 
                   btn_Cancel  
                   {&HLP_BTN_NAME}.
    
            &ELSE
             
            ENABLE user_env[32]  
                   btn_Tenant
                   UseDefaultDirs 
                   RootDirectory
                   user_env[2]  
                   btn_File 
                   inclob 
                   user_env[30] 
                   err% 
                   do-screen 
                   btn_OK 
                   btn_Cancel  
                   {&HLP_BTN_NAME}.
    
           &ENDIF
           
           refreshFileMTState().
            
           wait-for "go" of frame read-d-file-mt.
           /* danger danger: this must be qualified to use the frame of the 
              do block (it is possible that the frame qual only is needed on the first field) */ 
           ASSIGN  frame read-d-file-mt do-screen 
                   frame read-d-file-mt user_env[32]
                   frame read-d-file-mt user_env[2]                   
                   frame read-d-file-mt user_env[30]
                   frame read-d-file-mt err% 
                   user_env[4] = STRING(err%) 
                   user_env[6] = (IF do-screen THEN "s" ELSE "f").
            /* commented below code since it is a regression-PSC00250409 */
           /* if UseDefaultDirs then
           do:
               user_env[33] = gUseDefaultOut.
               user_env[40] = gLobfolderName.
           end.
           else 
              user_env[40] = "". */
           { prodict/dictnext.i trash }
          canned = FALSE.
    
       END.
    end. /* if multitenant */
    else do:
        {adecomm/okrun.i  
         &FRAME  = "FRAME read-d-file" 
         &BOX    = "rect_Btns"
         &OK     = "btn_OK" 
         {&CAN_BTN}
         {&HLP_BTN}
        }
    
        DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-d-file:
          &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
            ENABLE user_env[2]  btn_File inclob user_env[30] btn_dir err% do-screen btn_OK btn_Cancel.
            ASSIGN err% = INTEGER(user_env[4]).
    
            UPDATE user_env[2] 
                   btn_File 
                   inclob 
                   user_env[30] 
                   btn_dir 
                   err% 
                   do-screen 
                   btn_OK 
                   btn_Cancel  
                   {&HLP_BTN_NAME}.
    
              &ELSE
           ENABLE user_env[2]  
                  btn_File 
                  inclob 
                  user_env[30] 
                  err% 
                  do-screen 
                  btn_OK 
                  btn_Cancel.
            ASSIGN err% = INTEGER(user_env[4]).
    
            UPDATE user_env[2]  
                   btn_File 
                   inclob 
                   user_env[30] 
                   err% 
                   do-screen 
                   btn_OK 
                   btn_Cancel  
                   {&HLP_BTN_NAME}.
          &ENDIF
          
            DISPLAY user_env[2].
            ASSIGN user_env[4] = STRING(err%)
                   user_env[6] = (IF do-screen THEN "s" ELSE "f").
    
            { prodict/dictnext.i trash }
            canned = FALSE.
       END.
    end. /* if multitenant */
  END. /* else (io-file) */    
END. /* ELSE IF io-frame = "d" */

ELSE DO:
  IF class = "t" THEN DO:
    {adecomm/okrun.i
      &FRAME  = "FRAME read-dir-text"
      &BOX    = "rect_Btns"
      &OK     = "btn_OK"
      {&CAN_BTN}
      {&HLP_BTN}
    }
    DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE WITH FRAME read-dir-text:
      io-title = "Load Audit Policies - Text".
                        
      UPDATE user_env[2]
             &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
               btn_dir
             &ENDIF
             user_commit
             btn_OK
             btn_Cancel
             {&HLP_BTN_NAME}.
    
      RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).
      {prodict/dictnext.i trash}
      canned = FALSE.
    END.
  END.
    ELSE IF class = "p" THEN DO:
     {adecomm/okrun.i  
      &FRAME  = "FRAME read-input-cdc" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
    }
    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-input-cdc:

      io-title = "Load Change Data Capture Policies".
     
      UPDATE user_env[2]
             btn_File 
			 err% 
	         btn_OK 
	         btn_Cancel 
	         {&HLP_BTN_NAME}. 
			 			      
      ASSIGN user_env[4] = STRING(err%). 	

      { prodict/dictnext.i trash }
      canned = FALSE.     
    END.
  END.          
  ELSE IF class = "x" THEN DO:
    {adecomm/okrun.i  
      &FRAME  = "FRAME read-xml-file" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
    }
    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-xml-file:

      io-title = "Load Audit Policies - XML".

      UPDATE user_env[2] 
             btn_File 
             user_overwrite 
             user_commit
             btn_OK 
             btn_Cancel 
             {&HLP_BTN_NAME}.

      { prodict/dictnext.i trash }
      canned = FALSE.
    END.
  END.
  ELSE IF CAN-DO("i,o,e",class) THEN DO:
    {adecomm/okrun.i  
      &FRAME  = "FRAME read-d-file-nobl" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
    }
    DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE WITH FRAME read-d-file-nobl:
      CASE class:
        WHEN "i" THEN
          io-title = "Load Database Identification Properties".
        WHEN "o" THEN
          io-title = "Load Database Options".
        WHEN "e" THEN
          io-title = "Load Application Audit Events".
      END CASE.
      
      UPDATE user_env[2]
             btn_file
             err% 
             do-screen
             btn_OK
             btn_Cancel
             {&HLP_BTN_NAME}.
             
      ASSIGN user_env[4] = STRING(err%).  /* PSC00267783 - load Application Audit Events fails with 100% Acceptable Error Percentage */
      
      /* the ostodir call is not required for these 3 load operations which require file-name as input. */
      /*RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).*/

      {prodict/dictnext.i trash}
      canned = FALSE.
    END.
  END.
  ELSE IF CAN-DO("z,m,y",class) THEN DO:
    {adecomm/okrun.i  
      &FRAME  = "FRAME read-input-dir" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
    }
    DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE WITH FRAME read-input-dir:
      CASE class:
        WHEN "z" THEN
          io-title = "Load Security Domains" /* Security Authentication Records" */ .        
        WHEN "m" THEN
          io-title = "Load Security Permissions".
        WHEN "y" THEN
          io-title = "Load Audit Data".
      END CASE.

      UPDATE user_env[2]
             &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
               btn_dir 
             &ENDIF
             btn_OK
             btn_Cancel
             {&HLP_BTN_NAME}.
 
      RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).
      {prodict/dictnext.i trash}
      canned = FALSE.
    END.
  END.
  else if class = "k" and isSuperTenant then
  DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE WITH FRAME read-d-seq-mt:
    
      {adecomm/okrun.i  
        &FRAME  = "FRAME read-d-seq-mt" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
       }
      assign 
          UseDefaultDirs = true
          user_env[32]  = get-effective-tenant-name("dictdb")
          gFileName = user_env[2].
              
      refreshSeqDefaults().  
      display 
          user_env[32]
          UseDefaultDirs
          user_env[2]. 
      
      enable user_env[32]
             btn_Tenant
             UseDefaultDirs
             RootDirectory
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
             btn_DirRoot 
           &ENDIF 
             user_env[2] 
             btn_File      
             btn_OK 
             btn_Cancel
             {&HLP_BTN_NAME}.
          
      refreshSeqMTState().
      wait-for "go" of frame read-d-seq-mt.
      /* danger danger: this must be qualified to use the frame of the do block 
        (it is possible that the frame qual only is needed on the first field) */     
      assign 
          frame read-d-seq-mt user_env[32]
          frame read-d-seq-mt user_env[2].        
      
      { prodict/dictnext.i trash }
      canned = FALSE.
     
  end.
  ELSE DO:
    {adecomm/okrun.i  
      &FRAME  = "FRAME read-input" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
    }

    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-input:

      UPDATE user_env[2] btn_File btn_OK btn_Cancel {&HLP_BTN_NAME}.

      { prodict/dictnext.i trash }
      canned = FALSE.
    END.
  END.
END.
 
HIDE FRAME read-input NO-PAUSE.
HIDE FRAME read-df    NO-PAUSE.
HIDE FRAME read-d-file NO-PAUSE.
HIDE FRAME read-d-file-nobl NO-PAUSE.
HIDE FRAME read-input-cdc  NO-PAUSE.
HIDE FRAME read-xml-file NO-PAUSE.
HIDE FRAME read-d-dir NO-PAUSE.
HIDE FRAME read-input-dir NO-PAUSE.
HIDE FRAME read-dir-text NO-PAUSE.
HIDE FRAME read-dir-nobl NO-PAUSE.
HIDE FRAME get-cp NO-PAUSE.
 
IF canned THEN DO:
  user_path = "".
  IF no-schema-lock THEN
      ASSIGN SESSION:SCHEMA-CHANGE = oldsession.
END.
RETURN.

 

