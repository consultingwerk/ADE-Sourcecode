/*********************************************************************
* Copyright (C) 2007,2011 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* userdump - user interface and defaults setup for dumping */

/*
IN:
  user_env[1] = "ALL" or comma-separated list of files 
                or it may be in user_longchar, if list was too big.

  user_env[9] = type of dump (e.g. .df or .d or bulk-load file)
                "4"   = dump file definitions with AS/400 stuff
                "5"   = dump file definitions in V5 format
                "a"   = dump auto-connect records
                "c"   = dump collation tables
                "b"   = make bulkload description file
                "d"   = dump definitions
                "f"   = dump data file contents
                "s"   = dump sequence definitions
                "k"   = dump sequence values
                "u"   = dump user file contents
                "v"   = dump view file contents
                "x"   = dump audit policy records as XML
                "t"   = dump audit policy records as Text
                "e"   = dump application audit event records
                "y"   = dump audit data
                "i"   = dump database identification properties
                "o"   = dump database options
                "h"   = dump security authentication records
                "m"   = dump security permissions
            
OUT:
  user_env[1] = same as IN
  user_env[2] = physical file or directory name for some output
  user_env[3] = "MAP <name>" or "NO-MAP" OR ""
  user_env[4] = comma separated list of table numbers for which triggers 
                should be disabled.
                (only used for dump data file contents, "f").
  user_env[5] = "<source-code-page>,<target-code-page>" or "UNDEFINED"
                (only for .df- and .d-files!)  /*hutegger*/
  user_env[9] = same as IN
  user_env[26] = "y" or "n" to dump Field._Field-rpos or not.
  user_env[30] = lob dir
  user_env[31] = "" or " NO-LOBS" 
  user_env[32] = tenant  
  user_env[33] = tenant dir
  user_env[34] = tenant lob dir
  
  
history:
    mcmann      08/12/03    Add GET-DIR functionality
    mcmann      00/04/13    Added support for long path names
    Mario B     99/03/15    Added user_env[26] for conditional dump of 
                            _Field._Field-rpos
    mcmann      98/07/13    Added _Owner to _File finds
    gfs         95/05/31    allow dumping of hidden files if flag set
    gfs         94/11/04    add check for _File._Can-dump
    gfs         94/11/01    changed code-page to code page
    gfs         94/07/30    fixed dialogs
    gfs         94/06/23    changed default value logic for codepage
    hutegger    94/02/22    code-page support
    hutegger    94/05/04    change default-value for mapping to "NO-MAP"
    mcmann      03/02/04    Added LOB Directory
    mcmann      03/06/13    Removed lob directory from dump of df file
    mcmann      03/10/17    Add NO-LOCK statement to _Db find in support 
                            of on-line schema add
    kmcintos    04/04/05    Added frames and additional logic for auditing
                            support
    kmcintos    06/07/05    Added context help ids for auditing options.
    kmcintos    07/27/05    Removed reference to unused longchar variable.
    fernando    03/14/06    Handle case with too many tables selected - bug 20050930-006.
    fernando    08/10/07    Enhancing label of dmp-rpos - OE00154917
    fernando    12/13/07    Handle long list of "some" selected tables
    rkamboj     08/16/11   Added new terminology for security items and windows.
    rkamboj 	11/11/2011 Fixed issue of dump data for Lob field. bug OE00214956.
*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/fhidden.i}

IF CAN-DO("y,t,x",user_env[9]) AND
   user_env[1] = ? THEN DO:
  user_path = "".
  RETURN.
END.

DEFINE VARIABLE answer   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE canned   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE base     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE class    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE comma    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dump-as  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE err      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i        AS INTEGER    NO-UNDO.
DEFINE VARIABLE io-file  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE io-mapc  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE io-mapl  AS INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE io-title AS CHARACTER  NO-UNDO.
DEFINE VARIABLE is-all   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-one   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-some  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE msg-num  AS INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE nodump   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE prefix   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE trash    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dis_trig AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dmp-rpos AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE inclob   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE s_res    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE base_lchar AS LONGCHAR NO-UNDO.
DEFINE VARIABLE numCount   AS INTEGER  NO-UNDO.
DEFINE VARIABLE cItem      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE isCpUndefined AS LOGICAL NO-UNDO.

define variable UseDefaultDirs as logical no-undo.
define variable RootDirectory as character no-undo.

define variable labelDirShared as character no-undo 
        init "Shared Directory (blank = current directory):":t55. 

define variable labelDirRoot as character no-undo 
        init "Root Directory (blank = current directory):":t55. 

define variable isSuperTenant as logical no-undo.
/* used for file and sequence dump */
define variable isAllMultiTenant as logical no-undo. 
define variable isAnyMultiTenant as logical no-undo.

define variable gLobFolderName as character no-undo init "lobs".
define variable gGroupFolderName as character no-undo init "groups".
define variable gUseDefaultOut   as character no-undo init "<default>".
define variable gFileName      as character no-undo.
define variable labelDir as character no-undo.

{prodict/misc/filesbtn.i}

DEFINE BUTTON btn_dir
  SIZE 11 by 1.
  
DEFINE BUTTON btn_dir2
  SIZE 11 by 1 .

DEFINE BUTTON btn_dirRoot
  SIZE 11 by 1 .

DEFINE BUTTON btn_dirMT
  SIZE 11 by 1 .

DEFINE BUTTON btn_dirMTLOB
  SIZE 11 by 1 .

DEFINE BUTTON btn_tenant
  SIZE 18 by 1 .
define variable radioTenantDir as char view-as radio-set  
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
            horizontal
            radio-buttons "Subdirectory","tenant","Input directory","Shared","Other","Other"
            label "Tenant Directory".
         
         &ELSE
             vertical  
             radio-buttons "Subdirectoy","tenant","Input directory","Shared","Other","Other"
             label "Tenant Directory".
         &ENDIF    

define variable radioLobDir as char view-as radio-set  
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
            horizontal
            radio-buttons "Subdirectory","tenant","Input directory","Shared","Other","Other"
            label "LOB Directory".
         
         &ELSE
             vertical  
             radio-buttons "Subdirectoy","tenant","Input directory","Shared","Other","Other"
             label "Tenant Directory".
         &ENDIF    


define variable radioTenantLobDir as char view-as radio-set  
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
            horizontal
            radio-buttons "Subdirectory","L","Lob directory","T","Other","O"
            label "Tenant Lob Directory".
         
         &ELSE
             vertical  
             radio-buttons "Subdirectoy","tenant","Lob directory","Shared","Other","Other"
             label "Tenant Lob Directory".
         &ENDIF    


&IF "{&OPSYS}" <> "MSDOS" and "{&OPSYS}" <> "WIN32" &THEN
    &SCOPED-DEFINE SLASH /
&ELSE 
    &SCOPED-DEFINE SLASH ~~~\
&ENDIF

FORM SKIP({&TFM_WID})
     user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                 COLON 12 VIEW-AS FILL-IN SIZE 40 BY 1
                 LABEL "Output File"
     btn_File    SKIP ({&VM_WIDG})
     user_env[5] {&STDPH_FILL} FORMAT "x(80)" 
                 COLON 12 VIEW-AS FILL-IN SIZE 40 BY 1
                 LABEL "Code Page"
              
     {prodict/user/userbtns.i}
  
  WITH FRAME write-def-file
       SIDE-LABELS ATTR-SPACE CENTERED 
       DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
       VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
     user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                 COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
                 LABEL "Output File"
     btn_File    SKIP ({&VM_WIDG})
     user_env[5] {&STDPH_FILL} FORMAT "x(80)" 
                 COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
                 LABEL "Code Page" SKIP ({&VM_WIDG})
     dmp-rpos    VIEW-AS TOGGLE-BOX COLON 15 
                 LABEL "Include &POSITION for .r / Binary Load Compatibility"
                 
     {prodict/user/userbtns.i}

  WITH FRAME write-output-file
       SIDE-LABELS ATTR-SPACE CENTERED 
       DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
       VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
     user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                 COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
                 LABEL "Output File"
     btn_File                                     
     
     {prodict/user/userbtns.i}
     
  WITH FRAME write-output-file-nocp
       SIDE-LABELS ATTR-SPACE CENTERED 
       DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
       VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
     user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                 COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
                 LABEL "Output File"  btn_File  SKIP({&VM_WIDG})
     &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
       "  Include LOB:" VIEW-AS TEXT AT 2  
       inclob LABEL "yes/no" view-as toggle-box SKIP({&VM_WIDG}) 
       "LOB Directory:" VIEW-AS TEXT AT 2  
       user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                    NO-LABEL VIEW-AS FILL-IN 
                    SIZE 40 BY 1 SKIP({&VM_WIDG})
     &ELSE
       "  Include LOB:" VIEW-AS TEXT AT 2  
       inclob LABEL "yes/no" view-as toggle-box SKIP({&VM_WIDG}) 
       user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                    COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1 
                    LABEL "Lob Directory" 
       btn_dir LABEL "Dir..."  SKIP ({&VM_WIDG})
     &ENDIF
     user_env[5] {&STDPH_FILL} FORMAT "x(80)" 
                 COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Code Page" SKIP ({&VM_WIDG})

     {prodict/user/userbtns.i}
  
  WITH FRAME write-boutput-file
       SIDE-LABELS ATTR-SPACE CENTERED 
       DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
       VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
 
  &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN  
    &GLOBAL-DEFINE RADBTNVOFF 1.2
    &GLOBAL-DEFINE RADBTNHOFF 13
    &GLOBAL-DEFINE FILLCH 55
  &ELSE
    &GLOBAL-DEFINE RADBTNVOFF 0.9
    &GLOBAL-DEFINE RADBTNHOFF 12
    &GLOBAL-DEFINE FILLCH 47
  &ENDIF

  

  FORM SKIP({&TFM_WID})
       "Output File:":t20       VIEW-AS TEXT AT 2
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
       btn_File                 SKIP({&VM_WIDG})
       "  Include LOB:"         VIEW-AS TEXT AT 2  
       inclob                   LABEL "yes/no" 
                                view-as toggle-box SKIP({&VM_WID}) 
       "LOB Directory:"         VIEW-AS TEXT AT 2 
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1 
       btn_dir                  LABEL "Dir..." SKIP ({&VM_WIDG})
       "Character Mapping:":t26 VIEW-AS TEXT AT 2
       io-mapl                  VIEW-AS RADIO-SET
                                RADIO-BUTTONS "NO-MAP", 1, "Map", 2 AT 2 
                                SKIP({&VM_WIDG})
       "Code Page:":t18         VIEW-AS TEXT AT 2
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
                                
       {prodict/user/userbtns.i}
       
       io-mapc                  {&STDPH_FILL} FORMAT "X(20)"
                                AT ROW-OF io-mapl    + {&RADBTNVOFF} 
                                   COLUMN-OF io-mapl + {&RADBTNHOFF}
    WITH FRAME write-dump-file
         NO-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
       "Effective Tenant:":t20            VIEW-AS TEXT AT 2
       user_env[32]             {&STDPH_FILL} FORMAT "x(32)" 
                                AT 2 VIEW-AS FILL-IN                                
                                SIZE 40 BY 1
       btn_tenant               LABEL "Select Tenant..." SKIP({&VM_WIDG})
       UseDefaultDirs            at 2 label "Use Default Location (create subdirectories if necessary)"  
         view-as toggle-box SKIP({&VM_WID})                                     
       "Root directory (blank = current directory):":t50       VIEW-AS TEXT AT 2
       RootDirectory            {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN SIZE 47 BY 1
       btn_dirroot              LABEL "Dir..." SKIP ({&VM_WIDG})
       "Output File:":t20       VIEW-AS TEXT AT 2
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN SIZE 47 BY 1
       btn_File                 SKIP({&VM_WIDG})
       inclob                   AT 2 LABEL "Include LOB" 
                                view-as toggle-box SKIP({&VM_WID}) 
       "LOB Directory (relative to Effective Tenant Directory):"         VIEW-AS TEXT AT 2 
 
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN SIZE 47 BY 1 
       btn_dir                  LABEL "Dir..." SKIP ({&VM_WIDG})
       "Character Mapping:":t26 VIEW-AS TEXT AT 2
       io-mapl                  VIEW-AS RADIO-SET
                                RADIO-BUTTONS "NO-MAP", 1, "Map", 2 AT 2 
                                SKIP({&VM_WIDG})
       "Code Page:":t18         VIEW-AS TEXT AT 2
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                AT 2 VIEW-AS FILL-IN SIZE 47 BY 1
                                
       {prodict/user/userbtns.i}
       
       io-mapc                  {&STDPH_FILL} FORMAT "X(20)"
                                AT ROW-OF io-mapl    + {&RADBTNVOFF} 
                                   COLUMN-OF io-mapl + {&RADBTNHOFF}
    WITH FRAME write-dump-file-mt
         NO-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".
 
  FORM SKIP({&TFM_WID})
       user_env[33]  colon 17   NO-LABEL  
                VIEW-AS RADIO-SET /*size 50 by 1*/ HORIZONTAL RADIO-BUTTONS  
                 "Multi-Tenant Only", "Tenant", 
                 "Shared Only","Shared",
                 "All","All"  SKIP({&VM_WID}) 
       user_env[32]     {&STDPH_FILL} LABEL "Effective Tenant" FORMAT "x(32)" 
                         colon 17 VIEW-AS FILL-IN                                
                         SIZE 40 BY 1
       btn_tenant        LABEL "Select Tenant..." SKIP({&VM_WIDG})
       UseDefaultDirs    label "Use Default Location (create subdirectory if necessary)"  
                         view-as toggle-box colon 17 SKIP({&VM_WID})                                     
       RootDirectory     {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                         colon 17 label "Root Directory"
                         VIEW-AS FILL-IN SIZE 47 BY 1
       
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
       
       btn_dirroot       LABEL "Dir..." 
      
       &ENDIF
        
       SKIP ({&VM_WIDG})
       
       user_env[2]       {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                         COLON 17 VIEW-AS FILL-IN SIZE 47 BY 1
                         LABEL "Output File"
       btn_File          SKIP ({&VM_WIDG})
       user_env[5]       {&STDPH_FILL} FORMAT "x(80)" 
                         COLON 17 VIEW-AS FILL-IN SIZE 40 BY 1
                         LABEL "Code Page"
              
     {prodict/user/userbtns.i}
  WITH FRAME write-dump-seq-mt
       SIDE-LABELS ATTR-SPACE CENTERED 
       DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
       VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  
  
  FORM SKIP({&TFM_WID})
       "Output File:":t20       VIEW-AS TEXT AT 2
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
       btn_File                 SKIP({&VM_WIDG})
       "Character Mapping:":t26 VIEW-AS TEXT AT 2
       io-mapl                  VIEW-AS RADIO-SET
                                RADIO-BUTTONS "NO-MAP", 1, "Map", 2 AT 2    
                                SKIP({&VM_WIDG})
       "Code Page:":t18         VIEW-AS TEXT AT 2
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
                                
       {prodict/user/userbtns.i}
  
       io-mapc                  {&STDPH_FILL} FORMAT "X(20)"
                                AT ROW-OF io-mapl    + {&RADBTNVOFF} 
                                   COLUMN-OF io-mapl + {&RADBTNHOFF}
      WITH FRAME write-dump-file-nobl
           NO-LABELS NO-ATTR-SPACE CENTERED 
           DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
           VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
       "Output Directory (blank = current directory):":t63 
                                VIEW-AS TEXT AT 2
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1   
       btn_dir2                 LABEL "Dir..." SKIP({&VM_WIDG})
       "  Include LOB:"         VIEW-AS TEXT AT 2 inclob 
                                LABEL "yes/no" 
                                view-as toggle-box SKIP({&VM_WIDG})
       "LOB Directory (blank = current directory)" VIEW-AS TEXT AT 2
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1  
       btn_dir                  LABEL "Dir..."  SKIP({&VM_WIDG})
       "Character Mapping:":t26 VIEW-AS TEXT AT 2
       io-mapl                  VIEW-AS RADIO-SET
                                RADIO-BUTTONS "NO-MAP", 1, "Map", 2 
                                AT 2 SKIP({&VM_WIDG})
       "Code Page:":t18         VIEW-AS TEXT AT 2
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
                                
       {prodict/user/userbtns.i}
    
       io-mapc                  {&STDPH_FILL} FORMAT "X(20)"
                                AT ROW-OF io-mapl    + {&RADBTNVOFF} 
                                   COLUMN-OF io-mapl + {&RADBTNHOFF}
    WITH FRAME write-dump-dir
         NO-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
       "Effective Tenant:":t20            VIEW-AS TEXT AT 2
       user_env[32]             {&STDPH_FILL} FORMAT "x(32)" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE 40 BY 1   
       btn_tenant               LABEL "Select Tenant..." SKIP({&VM_WIDG})
       UseDefaultDirs        at 2 label "Use Default Location (create subdirectories if necessary)"  
         view-as toggle-box SKIP({&VM_WID})                                     
       
        labelDir  view-as text format "x(54)"   
                                 AT 2
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1   
       btn_dir2                 LABEL "Dir..." SKIP({&VM_WIDG})
       "Tenant Directory (blank = current directory):":t53 
                                VIEW-AS TEXT AT 2
       user_env[33]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1   
       btn_dirMT                LABEL "Dir..." SKIP({&VM_WIDG})
       
       inclob                   AT 2 LABEL "Include LOB" 
                                view-as toggle-box SKIP({&VM_WIDG})
       "Shared LOB Directory (blank = current directory):":t53 VIEW-AS TEXT AT 2
                                 
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1  
       btn_dir                  LABEL "Dir..."  SKIP({&VM_WIDG})
       
       "Tenant LOB Directory (relative to Effective Tenant Directory):" VIEW-AS TEXT AT 2
       "(blank = current directory) ":t53 VIEW-AS TEXT AT 2

       user_env[34]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1   
       btn_dirMTLOB                LABEL "Dir..." SKIP({&VM_WIDG})
      
       "Character Mapping:":t26 VIEW-AS TEXT AT 2
       io-mapl                  VIEW-AS RADIO-SET
                                RADIO-BUTTONS "NO-MAP", 1, "Map", 2 
                                AT 2 SKIP({&VM_WIDG})
       "Code Page:":t18         VIEW-AS TEXT AT 2
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
                                
       {prodict/user/userbtns.i}
    
       io-mapc                  {&STDPH_FILL} FORMAT "X(20)"
                                AT ROW-OF io-mapl    + {&RADBTNVOFF} 
                                   COLUMN-OF io-mapl + {&RADBTNHOFF}
    WITH FRAME write-dump-dir-mt
         NO-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".


  FORM SKIP({&TFM_WID})
       "Output Directory (blank = current directory):":t63 
                                VIEW-AS TEXT AT 2
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1   
       btn_dir2                 LABEL "Dir..." SKIP({&VM_WIDG})
       "  Include LOB:"         VIEW-AS TEXT AT 2 
       inclob                   LABEL "yes/no" 
                                view-as toggle-box SKIP
       "LOB Directory (blank = current directory):" VIEW-AS TEXT AT 2
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1  
       btn_dir                  LABEL "Dir..." SKIP({&VM_WIDG})
       
      "Code Page:":t18          VIEW-AS TEXT AT 2
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
                                SKIP({&VM_WID})
       
       {prodict/user/userbtns.i}
       
    WITH FRAME write-audit-data
         NO-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

    FORM SKIP({&TFM_WID})
         "Output Directory (if different from current directory):":t63 
                                  VIEW-AS TEXT AT 2
         user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                  AT 2 VIEW-AS FILL-IN 
                                  SIZE {&FILLCH} BY 1   
         btn_dir2                 LABEL "Dir..." SKIP({&VM_WIDG})
         "Character Mapping:":t26 VIEW-AS TEXT AT 2
         io-mapl                  VIEW-AS RADIO-SET
                                  RADIO-BUTTONS "NO-MAP", 1, "Map", 2 
                                  AT 2 SKIP({&VM_WIDG})
         "Code Page:":t18         VIEW-AS TEXT AT 2
         user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                  AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
                                  
         {prodict/user/userbtns.i}
    
         io-mapc                  {&STDPH_FILL} FORMAT "X(20)"
                                  AT ROW-OF io-mapl    + {&RADBTNVOFF} 
                                     COLUMN-OF io-mapl + {&RADBTNHOFF}
    WITH FRAME write-dump-dir-nobl
         NO-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
       "Output Directory (if different from current directory):":t63 
                                VIEW-AS TEXT AT 2
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE {&FILLCH} BY 1   
       btn_dir2                 LABEL "Dir..." SKIP({&VM_WIDG})
       "Code Page:":t18         VIEW-AS TEXT AT 2
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
                                
       {prodict/user/userbtns.i}
       
    WITH FRAME write-dump-dir-cdpg
         NO-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

&ELSE       /* tty */
  FORM SKIP({&TFM_WID})
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Output File"  
       btn_File                 SKIP({&VM_WIDG})
       "Include LOB:"           VIEW-AS TEXT AT 4 
       inclob                   LABEL "yes/no" 
                                view-as toggle-box SKIP({&VM_WID})
       "LOB Directory:"         VIEW-AS TEXT at 2 
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  
                                VIEW-AS FILL-IN SIZE 40 BY 1 SKIP({&VM_WIDG})
       io-mapc                  {&STDPH_FILL} LABEL "Character Mapping"
                                FORMAT "x(20)" COLON 19
       "(Blank = Default Map; use"       COLON 41
       "~"NO-MAP~" to turn off mapping)" COLON 41 SKIP ({&VM_WIDG})
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Code Page" SKIP({&VM_WIDG})
                                
       {prodict/user/userbtns.i}
   
    WITH FRAME write-dump-file
         NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
       user_env[32]             {&STDPH_FILL} FORMAT "x(32)"     
                                colon 22 VIEW-AS FILL-IN size 33 by 1  /* size to align button..*/         
                                LABEL "Effective Tenant"  
       btn_Tenant               LABEL "Select Tenant..." SKIP({&VM_WID})
       "Use Default Location:"           VIEW-AS TEXT AT 2
       UseDefaultDirs           colon 22 view-as toggle-box 
                                label " (Create subdirectories if necessary)"
       RootDirectory            {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"
                                colon 22 label "Root Directory"     
                                VIEW-AS FILL-IN SIZE 41 BY 1 
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                COLON 22 VIEW-AS FILL-IN SIZE 41 BY 1
                                LABEL "Output File"  
       btn_File                 SKIP({&VM_WIDG})
       "Include LOB:"           VIEW-AS TEXT AT 11 
       inclob                   LABEL " " 
                                view-as toggle-box 
       
       "LOB Directory:"         VIEW-AS TEXT at  9
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  
                                VIEW-AS FILL-IN SIZE 28 BY 1 
       "(relative to Effective" COLON 51
       "Tenant Directory)"      COLON 51 
       io-mapc                  {&STDPH_FILL} LABEL "Character Mapping"
                                FORMAT "x(20)" COLON 22
       "(Blank = Default Map; use"       COLON 43
       "~"NO-MAP~" to turn off mapping)" COLON 43 SKIP ({&VM_WIDG})
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                COLON 22 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Code Page" SKIP({&VM_WIDG})
                                
       {prodict/user/userbtns.i}
   
    WITH FRAME write-dump-file-mt
         NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".
  
  FORM SKIP({&TFM_WID})
       user_env[33]  colon 22   NO-LABEL  
                VIEW-AS RADIO-SET /*size 50 by 1*/ HORIZONTAL RADIO-BUTTONS  
                 "Multi-Tenant Only", "Tenant", 
                 "Shared Only","Shared",
                 "All","All"  SKIP({&VM_WID}) 
       user_env[32]             {&STDPH_FILL} FORMAT "x(32)"     
                                colon 22 VIEW-AS FILL-IN size 33 by 1  /* size to align button..*/         
                                LABEL "Effective Tenant"  
       btn_Tenant               LABEL "Select Tenant..." SKIP({&VM_WIDG})
       "Use Default Location:"           VIEW-AS TEXT AT 2
       UseDefaultDirs           colon 22 view-as toggle-box label " (Create tenant subdirectory if necessary)"
       RootDirectory            {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"
                                colon 22 label "Root Directory"     
                                VIEW-AS FILL-IN SIZE 41 BY 1 
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                COLON 22 VIEW-AS FILL-IN SIZE 41 BY 1
                                LABEL "Output File"  
       btn_File                 SKIP({&VM_WIDG})
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                COLON 22 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Code Page" SKIP({&VM_WIDG})
       {prodict/user/userbtns.i}
  WITH FRAME write-dump-seq-mt
       NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
       DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
       VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".
  
  FORM SKIP({&TFM_WID})
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Output File"  
       btn_File                 SKIP({&VM_WIDG})
       io-mapc                  {&STDPH_FILL} LABEL "Character Mapping"
                                FORMAT "x(20)" COLON 19
       "(Blank = Default Map; use"       COLON 41
       "~"NO-MAP~" to turn off mapping)" COLON 41 SKIP({&VM_WIDG})
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Code Page" SKIP({&VM_WIDG})
                                
       {prodict/user/userbtns.i}
    
    WITH FRAME write-dump-file-nobl
         NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

   FORM  
      SKIP({&VM_WIDG})
       user_env[32]             {&STDPH_FILL} FORMAT "x(32)"     
                                colon 22 VIEW-AS FILL-IN         
                                LABEL "Effective Tenant"  
       btn_Tenant               LABEL "Select Tenant..." SKIP({&VM_WIDG})
       "Use Default Location:"           VIEW-AS TEXT AT 2
       UseDefaultDirs        colon 22 view-as toggle-box label " (Create subdirectories if necessary)"
    
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                colon 22 VIEW-AS FILL-IN SIZE 51 BY 1
                                LABEL "Shared Directory" SKIP SKIP({&VM_WID}) 
      
       user_env[33]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                colon 22 VIEW-AS FILL-IN SIZE 51 BY 1
                                LABEL "Tenant Directory" SKIP({&VM_WIDG})
       "Include LOB:"           VIEW-AS TEXT AT 11
       inclob                   colon 22 LABEL " (X = yes)" view-as toggle-box 
                                     
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  
                                colon 22 VIEW-AS FILL-IN SIZE 28 BY 1  
                                LABEL "Shared LOB Directory" SKIP
       user_env[34]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  
                                colon 22  VIEW-AS FILL-IN SIZE 28 BY 1        
                                LABEL "Tenant LOB Directory" 
       "(relative to Effective"  COLON 51
       "Tenant Directory)"       COLON 51 SKIP({&VM_WIDG})
       io-mapc                  {&STDPH_FILL} LABEL "Character Mapping"
                                FORMAT "x(20)" COLON 22
       "(Blank = Default Map; use"       COLON 44
       "~"NO-MAP~" to turn off mapping)" COLON 44 SKIP({&VM_WIDG})
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                COLON 22 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Code Page"
                                
       {prodict/user/userbtns.i}
       
    WITH FRAME write-dump-dir-mt
         NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".


FORM SKIP({&TFM_WID})
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                COLON 17 VIEW-AS FILL-IN SIZE 50 BY 1
                                LABEL "Output Directory" SKIP({&VM_WID})
       "(Blank = Current Directory)" VIEW-AS TEXT COLON 19 SKIP({&VM_WIDG})
       
       
       "Include LOB:"           VIEW-AS TEXT AT 6 
       inclob                   LABEL "yes/no" view-as toggle-box 
                                SKIP({&VM_WID})     
       "LOB Directory:"         VIEW-AS TEXT AT 4
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  
                                VIEW-AS FILL-IN SIZE 40 BY 1 SKIP({&VM_WID})
       "(Blank = Current Directory)" VIEW-AS TEXT COLON 19 SKIP({&VM_WIDG})
       io-mapc                  {&STDPH_FILL} LABEL "Character Mapping"
                                FORMAT "x(20)" COLON 19
       "(Blank = Default Map; use"       COLON 41
       "~"NO-MAP~" to turn off mapping)" COLON 41 SKIP({&VM_WIDG})
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Code Page"
                                
       {prodict/user/userbtns.i}
       
    WITH FRAME write-dump-dir
         NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".



  FORM SKIP({&TFM_WID})
       "Output Directory (if different from current directory):":t63 
                                VIEW-AS TEXT AT 2
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE 50 BY 1 SKIP({&VM_WIDG})
       "  Include LOB:"         VIEW-AS TEXT AT 2 
       inclob                   LABEL "yes/no" view-as toggle-box 
                                SKIP({&VM_WID})
       "LOB Directory: (Blank = Current Directory)" VIEW-AS TEXT AT 2
       user_env[30]             {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                AT 2 VIEW-AS FILL-IN 
                                SIZE 50 BY 1 SKIP({&VM_WIDG})
                                
       "Code Page:":t18         VIEW-AS TEXT AT 2
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
                                SKIP({&VM_WID})

       {prodict/user/userbtns.i}
       
    WITH FRAME write-audit-data
         NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                COLON 17 VIEW-AS FILL-IN SIZE 50 BY 1
                                LABEL "Output Directory"  SKIP({&VM_WID})
       "(Blank = Current Directory)" VIEW-AS TEXT COLON 19 SKIP ({&VM_WIDG})
       io-mapc                  {&STDPH_FILL} LABEL "Character Mapping"
                                FORMAT "x(20)" COLON 19
       "(Blank = Default Map; use"       COLON 41
       "~"NO-MAP~" to turn off mapping)" COLON 41 SKIP({&VM_WIDG})
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Code Page"
    
       {prodict/user/userbtns.i}
    
    WITH FRAME write-dump-dir-nobl
         NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
       user_env[2]              {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
                                COLON 17 VIEW-AS FILL-IN SIZE 50 BY 1
                                LABEL "Output Directory"  SKIP({&VM_WID})
       "(Blank = Current Directory)" VIEW-AS TEXT COLON 19 SKIP ({&VM_WIDG})
       user_env[5]              {&STDPH_FILL} FORMAT "x(80)" 
                                COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
                                LABEL "Code Page"
    
       {prodict/user/userbtns.i}
    
    WITH FRAME write-dump-dir-cdpg
         NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
         VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

&ENDIF

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

function refreshMapping returns logical (hMap as handle,hField as handle):
    
   IF hMap:SCREEN-VALUE = "1" THEN DO:
        hField:SENSITIVE = FALSE.
        hField:SCREEN-VALUE = "".
   END.
   ELSE DO:
        io-mapc = "".
        hField:SENSITIVE = TRUE.
        hField:MOVE-AFTER-TAB-ITEM(hMap).
   END.
end.
 
function refreshDir return logical
                   (newDir as char):
    
     assign   
         user_env[33] = newdir + "{&SLASH}" + user_env[32]
         user_env[30] = newdir + "{&SLASH}" + gLobFolderName
         user_env[34] = newdir + "{&SLASH}" + user_env[32] + "{&SLASH}" + gLobFolderName
         user_env[2]  = newDir.
        
     return true.    
end function. 

/* refresh variables depending in tenant (use_env[32]) and Rootdirectory
   Call whenever one of them has changed  (used by write-dump-seq-mt) 
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
     else if user_env[33] <> "Tenant" then
     do:
         user_env[2] = gFileName.
         return true.
     end.
     return false.    
end function.

/* refresh variables depending in tenant (use_env[32]) and Rootdirectory
   Call whenever one of them has changed  (used by write-dump-file-mt) 
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
 
function refreshDirMTState returns logical ():    
   
    assign 
        UseDefaultDirs =  UseDefaultDirs:checked in frame write-dump-dir-mt
        inclob            =  inclob:checked in frame write-dump-dir-mt
        user_env[2]:sensitive in frame write-dump-dir-mt = UseDefaultDirs or (isAllMultitenant = false)
  
        user_env[2]:screen-value in frame write-dump-dir-mt = if user_env[2]:sensitive then user_env[2]
                                                                 else ""
        user_env[33]:sensitive  in frame write-dump-dir-mt = not UseDefaultDirs
        
        user_env[30]:screen-value in frame write-dump-dir-mt = if inclob then user_env[30] else ""
        user_env[30]:sensitive in frame write-dump-dir-mt = UseDefaultDirs = false and inclob
        user_env[34]:screen-value in frame write-dump-dir-mt = if inclob then user_env[34] else ""
        user_env[34]:sensitive in frame write-dump-dir-mt = UseDefaultDirs = false and inclob
       
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
         btn_dir2:sensitive  in frame write-dump-dir-mt = 
                    user_env[2]:sensitive  in frame write-dump-dir-mt
         btn_dirMt:sensitive  in frame write-dump-dir-mt = 
                    user_env[33]:sensitive  in frame write-dump-dir-mt
         btn_dir:sensitive  in frame write-dump-dir-mt = 
                    user_env[30]:sensitive  in frame write-dump-dir-mt
         btn_dirmtLob:sensitive  in frame write-dump-dir-mt = 
                    user_env[34]:sensitive  in frame write-dump-dir-mt
   
     &ENDIF 
     
       .
end.     


function refreshSeqMTState returns logical ():    
    assign 
        UseDefaultDirs =  UseDefaultDirs:checked in frame write-dump-seq-mt
        RootDirectory:sensitive in frame write-dump-seq-mt = UseDefaultDirs
        RootDirectory:screen-value in frame write-dump-seq-mt = if UseDefaultDirs then RootDirectory
                                                                 else ""
        user_env[2]:sensitive  in frame write-dump-seq-mt = not UseDefaultDirs
        btn_file:sensitive  in frame write-dump-seq-mt = 
                    user_env[2]:sensitive  in frame write-dump-seq-mt
       
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
         btn_dirRoot:sensitive  in frame write-dump-seq-mt = 
                    RootDirectory:sensitive  in frame write-dump-seq-mt
     &ENDIF 
       .
end.     

function refreshFileMTState returns logical ():    
     
    assign 
        UseDefaultDirs =  UseDefaultDirs:checked in frame write-dump-file-mt
        inclob            =  inclob:checked in frame write-dump-file-mt
        RootDirectory:sensitive in frame write-dump-file-mt = UseDefaultDirs
        RootDirectory:screen-value in frame write-dump-file-mt = if UseDefaultDirs then RootDirectory
                                                                 else ""
        user_env[2]:sensitive  in frame write-dump-file-mt = not UseDefaultDirs
        user_env[30]:screen-value in frame write-dump-file-mt = if inclob then user_env[30] else ""
        user_env[30]:sensitive in frame write-dump-file-mt = UseDefaultDirs = false and inclob
        btn_file:sensitive  in frame write-dump-file-mt = 
                    user_env[2]:sensitive  in frame write-dump-file-mt
       
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
         btn_dirRoot:sensitive  in frame write-dump-file-mt = 
                    RootDirectory:sensitive  in frame write-dump-file-mt
         btn_dir:sensitive  in frame write-dump-file-mt = 
                    user_env[30]:sensitive  in frame write-dump-file-mt
   
     &ENDIF 
     
       .
end.     

function refreshDirMT returns logical ():  
     if refreshDirDefaults() then 
     do: 
         user_env[33]:screen-value in frame write-dump-DIR-mt = user_env[33].
         if inclob:checked in frame write-dump-DIR-mt then
            assign
                user_env[30]:screen-value in frame write-dump-DIR-mt = user_env[30]
                user_env[34]:screen-value in frame write-dump-DIR-mt = user_env[34].
     
     end.           
end.      

function refreshSeqMT returns logical ():  
     if refreshSeqDefaults() then 
     do: 
         user_env[2]:screen-value in frame write-dump-seq-mt = user_env[2].
     end.           
end.      

function refreshFileMT returns logical ():  
     if refreshFileDefaults() then 
     do: 
         user_env[2]:screen-value in frame write-dump-file-mt = user_env[2].
         if inclob:checked   in frame write-dump-file-mt then
             user_env[30]:screen-value in frame write-dump-file-mt = user_env[30].
     end.           
end.      

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

function validLobDirectory returns logical ( cValue as char):
  
    IF cValue <> "" THEN 
    DO:
        if not (cValue begins "/" or cvalue begins "~\" or index(cValue,":") <> 0) then
        DO:
            if SUBSTRING(user_env[2],1,R-INDEX(user_env[2], "/") - 1) = user_env[2] then
                cValue = "./" + cValue.
            else
                cValue = SUBSTRING(user_env[2],1,R-INDEX(user_env[2], "/") - 1) + "/" + cValue.  
        END.
        ASSIGN FILE-INFO:FILE-NAME = cValue. 
        return SUBSTRING(FILE-INFO:FILE-TYPE,1,1) = "D".
    END.    
    
    return true.
 
end function. /* validateLobDirectory */

function validTenantLobDirectory returns logical ( cValue as char):
  
    IF cValue <> "" THEN 
    DO:
        if not (cValue begins "/" or cvalue begins "~\" or index(cValue,":") <> 0) then
        DO:
            if user_env[33] = "" then
                cValue = "./" + cValue.
            else 
                cValue = user_env[33] + "/" + cValue.  
        END.
        ASSIGN FILE-INFO:FILE-NAME = cValue. 
        return SUBSTRING(FILE-INFO:FILE-TYPE,1,1) = "D".
    END.
    
    return true.
 
end function. /* validateTenantLobDirectory */

function createDirectoryIf returns logical ( cdirname as char):

    define variable iStat as integer no-undo.
    define variable lslash as character no-undo.
	/* rootpath to create at correct place */
	if index(cdirname,"/") <> 0 then lslash = "/".
       else lslash = "~\". 
    if index(cdirname,lslash) = 0 
      and RootDirectory:screen-value in frame write-dump-file-mt <> "" 
      and isSuperTenant then
          assign cdirname = RootDirectory:screen-value in frame write-dump-file-mt 
                            + lslash + cdirname.
    						
    if not validdirectory(cdirname) then
    do:
	    OS-CREATE-DIR VALUE(cdirname). 
        iStat = OS-ERROR. 
        
        if iStat <> 0 then
           MESSAGE "Cannot create directory " + cdirname + ". System error:" iStat
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        return istat = 0.
    end.
    return true.
end function. /* validateDirectory */

function refreshDirInSeqUI returns logical ():    
      
     if validDirectory(RootDirectory:screen-value in frame write-dump-seq-mt) then
     do: 
         RootDirectory = right-trim(RootDirectory:screen-value in frame write-dump-seq-mt,"/~\.").
         
         refreshSeqMT().  
         return true.
     end.
     return false.    
end function. 

function refreshDirInFileUI returns logical ():    
      
     if validDirectory(RootDirectory:screen-value in frame write-dump-file-mt) then
     do: 
         RootDirectory = right-trim(RootDirectory:screen-value in frame write-dump-file-mt,"/~\.").
         
         refreshFileMT().  
         return true.
     end.
     return false.    
end function.  

function refreshDirInDirUI returns logical ():      
     if validDirectory(user_env[2]:screen-value in frame write-dump-dir-mt) then
     do: 
         user_env[2] = right-trim(user_env[2]:screen-value in frame write-dump-dir-mt,"/~\.").        
         refreshDirMT().  
         return true.
     end.
     return false.    
end function.  

function refreshTenantInDirUI returns logical ():    
     define variable newTenantName as character no-undo.
     newTenantName = getTenantName(user_env[32]:screen-value in frame write-dump-dir-mt). 
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
     newTenantName = getTenantName(user_env[32]:screen-value in frame write-dump-file-mt). 
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
     newTenantName = getTenantName(user_env[32]:screen-value in frame write-dump-seq-mt). 
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
    tenantdlg = new  prodict.pro._tenant-sel-presenter ().
    do with frame write-dump-dir-mt:
           &IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN
        /* adjust the browse aligned and under field (at least try...) */   
        if  hTenant:frame:row < 0 then  /* this does not really work with large negative */                  
            tenantdlg:Row = (hTenant:row + hTenant:height) + 0.5.
        else 
            tenantdlg:Row = hTenant:row + hTenant:height +  hTenant:frame:row + 0.5.
        tenantdlg:Col = hTenant:col + hTenant:frame:col .
           &ELSE
        
        tenantdlg:Row = hTenant:row + hTenant:height +  hTenant:frame:row.
       
           &ENDIF
    end.
    tenantdlg:QueryString = "for each ttTenant where ttTenant.type <> 'super'".
    tenantdlg:Title = "Select Tenant".
  
/*    glInSelect = true. /* stop end-error anywhere trigger */*/ 
    if tenantdlg:Wait() then
    do: 
        hTenant:screen-value = tenantdlg:ColumnValue("ttTenant.name").
        apply "value-changed" to hTenant.
    end.
/*    glInSelect = false.*/
 
end.  

function validateFile returns logical ( cfile as char):
   
    IF cfile <> "" THEN 
    DO:
        /* check file name entered */
        FILE-INFO:FILE-NAME = cfile.
        IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 
        OR SUBSTRING(cfile,LENGTH(cfile),1,"CHARACTER":U) = "{&SLASH}" THEN 
        DO:
            MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
            RETURN false.
        END.
    END.
    
    return true.
end function. /* validatefile */



function validateDirectory returns logical ( cValue as char):
   
    IF cValue <> "" THEN 
    DO:
        if not validDirectory(cValue) then
        DO:
            MESSAGE "Directory " + cValue + " does not exist!" SKIP(1)
            "Please enter a valid directory name."
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

function validateLobDirectory returns logical ( cValue as char):
      
    IF cValue <> "" THEN 
    DO:
        if not validLobDirectory(cValue) then
        DO:
            MESSAGE "Directory " + cValue + " does not exist!" SKIP(1)
            "Please enter a valid directory name."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   
            return false.
        END.
      return true.
    END.
end function. /* validateLobDirectory */

function validateTenantLobDirectory returns logical ( cValue as char):
   
    IF cValue <> "" THEN 
    DO:
        if not validTenantLobDirectory(cValue) then
        DO:
            MESSAGE "Directory " + cValue + " does not exist!" SKIP(1)
            "Please enter a valid directory name."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   
            return false.
        END.
      return true.
    END.
end function. /* validateTenantLobDirectory */

function validateFileExists returns logical ( cFile as char): 
    define variable prefix    as character no-undo.
    define variable basename  as character no-undo.
    
    RUN prodict/misc/osprefix.p
      ( INPUT  cfile,
        OUTPUT prefix,
        OUTPUT basename
        ).
    
    if basename = cfile then 
        assign cfile = "./" + cfile.
  
    IF io-file AND (SEARCH(cfile) <> ?) THEN 
    DO:
       answer = FALSE.
       MESSAGE "A file already exists with the name:" SKIP cfile SKIP(1) "Overwrite?"
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
       IF NOT answer THEN 
       DO:
          return false. 
       END.
    end.
    return true.   
end function.  

function validateDirectoryExists returns logical ( cValue as char, cname as char): 
  DEFINE VAR dir   AS CHAR    NO-UNDO.
  DEFINE VAR exist AS LOGICAL NO-UNDO.
  DEFINE VAR fil   AS CHAR    NO-UNDO.
  DEFINE VAR i     AS INTEGER NO-UNDO.

  assign
    dir     = cValue
    exist   = false.
  
  if dir = "" then assign dir = "./".
  
  DO i = 1 to NUM-ENTRIES(user_env[1]) WHILE NOT exist:
    ASSIGN fil = dir + ENTRY(i,user_env[1]) + ".d".
    IF (SEARCH(fil) <> ?) THEN ASSIGN exist = true.
  END.
    
  IF exist THEN DO:
    answer = FALSE.
    MESSAGE "One or more of the files already exist in the " + cname + "." SKIP 
            "Overwrite them?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      return false.
    END.
  END.
  return true.
end.

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

function saveDefaultLOB returns logical(useLob as log,lobdirname as char):
     IF useLob = false THEN
         ASSIGN user_env[31] = " NO-LOBS"
                user_env[40] = "".
     ELSE
         ASSIGN user_env[31] = ""
                user_env[40] = lobdirname.
     
end function. 

function saveLOB returns logical(useLob as log,lobdir as char):
     IF useLob = false THEN
         ASSIGN user_env[31] = " NO-LOBS"
                user_env[30] = "".
      ELSE
         ASSIGN user_env[31] = ""
                user_env[30] = lobdir.
end function. 

function saveLOBMT returns logical(useLob as log,lobdir as char,lobdirMT as char):
    saveLOB(useLOB,lobDir).
    IF useLob = false THEN
        user_env[34] = "".
    else
        user_env[34] = lobdirMT.    
end function.    


function trimScreenValue returns logical (h as handle):
     h:SCREEN-VALUE = TRIM(h:SCREEN-VALUE).
end function.     

function validateDirScreenValue returns logical (h as handle):
     trimScreenValue(h).
     return validateDirectory(h:SCREEN-VALUE).
end function.     

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


 

 


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
ON HELP OF FRAME write-output-file OR 
   CHOOSE OF btn_Help IN FRAME write-output-file
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Dump_Data_Contents_Dlg_Box},
                             INPUT ? ).

on HELP of frame write-boutput-file
   or CHOOSE of btn_Help in frame write-boutput-file
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Make_Bulk_Load_Dlg_Box},
                             INPUT ?).

on HELP of frame write-def-file 
   or CHOOSE of btn_Help in frame write-def-file
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Dump_Stuff_Dlg_Box},
                             INPUT ?).

on HELP of frame write-dump-file 
   or CHOOSE of btn_Help in frame write-dump-file
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                              INPUT {&Dump_Data_Contents_Dlg_Box},
                              INPUT ?).

ON HELP OF FRAME write-dump-file-nobl OR
   CHOOSE OF btn_Help IN FRAME write-dump-file-nobl
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Dump_Data_Contents_Dlg_Box},
                             INPUT ? ).

on HELP of frame write-dump-dir
   or CHOOSE of btn_Help in frame write-dump-dir
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Dump_Data_Contents_Some_Dlg_Box},
                             INPUT ?).

on HELP of frame write-dump-dir-mt
   or CHOOSE of btn_Help in frame write-dump-dir-mt
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Dump_Data_Contents_Some_Dlg_Box},
                             INPUT ?).

ON HELP OF FRAME write-audit-data OR 
   CHOOSE OF btn_Help IN FRAME write-audit-data
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             /* Temporary stub till help file is written */
                             INPUT {&Dump_Data_Contents_Dlg_Box},
                             INPUT ?).

ON HELP OF FRAME write-dump-dir-nobl OR 
   CHOOSE OF btn_Help IN FRAME write-dump-dir-nobl
  RUN "adecomm/_adehelp.p" ( INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Dump_Data_Contents_Dlg_Box},
                             INPUT ? ).

ON HELP OF FRAME write-output-file-nocp OR 
   CHOOSE OF btn_Help IN FRAME write-output-file-nocp
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Dump_Database_Options_Dialog_Box},
                             INPUT ? ).
            
ON HELP OF FRAME write-dump-dir-cdpg OR 
   CHOOSE OF btn_Help IN FRAME write-dump-dir-cdpg
  RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Dump_Data_Contents_Dlg_Box},
                             INPUT ? ).
ON HELP OF FRAME write-dump-file-mt OR 
   CHOOSE OF btn_Help IN FRAME write-dump-file-mt
   RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Dump_Data_Contents_for_Some_Tables_Multi_tenant_enabled_Dialog_Box},
                             INPUT ? ). 

ON CHOOSE OF btn_dir in frame write-dump-file
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[30]:handle in frame write-dump-file /*Fillin*/,
         INPUT "Find Lob Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).

ON CHOOSE OF btn_dir in frame write-dump-file-mt
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[30]:handle in frame write-dump-file-mt /*Fillin*/,
         INPUT "Find Lob Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
  
ON CHOOSE OF btn_dirMT in frame write-dump-dir-mt   
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[33]:handle in frame write-dump-dir-mt /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).

ON CHOOSE OF btn_dirMTLOB in frame write-dump-dir-mt   
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[34]:handle in frame write-dump-dir-mt /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).

ON CHOOSE OF btn_dir2 in frame write-dump-dir
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[2]:handle in frame write-dump-dir /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).

ON CHOOSE OF btn_dir2 in frame write-dump-dir-mt
do:
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[2]:handle in frame write-dump-dir-mt /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
  apply "value-changed" to user_env[2]  in frame write-dump-dir-mt. 
end.
  
ON CHOOSE OF btn_dir2 in frame write-audit-data
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[2]:handle in frame write-audit-data /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
  
ON CHOOSE OF btn_dir2 in frame write-dump-dir-nobl
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[2]:handle in frame write-dump-dir-nobl /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).

ON CHOOSE OF btn_dir2 in frame write-dump-dir-cdpg
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[2]:handle in frame write-dump-dir-cdpg /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).

ON CHOOSE OF btn_dir in frame write-dump-dir-mt
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[30]:handle in frame write-dump-dir-mt /*Fillin*/,
         INPUT "Find Lob Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).  

ON CHOOSE OF btn_dir in frame write-dump-dir
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[30]:handle in frame write-dump-dir /*Fillin*/,
         INPUT "Find Lob Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
 
ON CHOOSE OF btn_dir in frame write-audit-data
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[30]:handle in frame write-audit-data /*Fillin*/,
         INPUT "Find Lob Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).

ON CHOOSE OF btn_dir in frame write-boutput-file
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT user_env[30]:handle in frame write-boutput-file /*Fillin*/,
         INPUT "Find Lob Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).

ON CHOOSE OF btn_dirRoot in frame write-dump-file-mt 
do:  
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT RootDirectory:handle in frame write-dump-file-mt /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
  apply "value-changed" to RootDirectory in frame write-dump-file-mt. 
end.


ON CHOOSE OF btn_dirRoot in frame write-dump-seq-mt 
do:  
  RUN "prodict/misc/_dirbtn.p"
       ( INPUT RootDirectory:handle in frame write-dump-seq-mt /*Fillin*/,
         INPUT "Choose Dump Directory"  /*Title*/,
         INPUT ""                 /*Filter*/).
  apply "value-changed" to RootDirectory in frame write-dump-seq-mt. 
end.

&ENDIF /* IF NOT TTY */


/*----- ON GO or OK -----*/
ON GO OF FRAME write-output-file
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  fil = user_env[2]:SCREEN-VALUE IN FRAME write-output-file.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
    SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.
    
  RUN prodict/misc/osprefix.p
    ( INPUT  fil,
      OUTPUT prefix,
      OUTPUT basename
      ).
  if basename = fil then assign fil = "./" + fil.
  
  IF /*io-file AND*/ (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-output-file.
      RETURN NO-APPLY.
    END. 
  END.

  /* Assign value of toggle to user_env[26] for dump of _Field._Field-rpos */
  ASSIGN dmp-rpos.
  user_env[26] = (IF NOT dmp-rpos THEN "n" ELSE "y").
END. /* ON "GO" OF write-output-file */

/*----- ON GO or OK -----*/
ON GO OF FRAME write-output-file-nocp
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  fil = user_env[2]:SCREEN-VALUE IN FRAME write-output-file-nocp.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
    SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.
    
  RUN prodict/misc/osprefix.p
    ( INPUT  fil,
      OUTPUT prefix,
      OUTPUT basename
      ).
  if basename = fil then assign fil = "./" + fil.
  
  IF /*io-file AND*/ (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-output-file-nocp.
      RETURN NO-APPLY.
    END. 
  END.

END. /* ON "GO" OF write-output-file-nocp */

ON GO OF FRAME write-boutput-file
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  fil = user_env[2]:SCREEN-VALUE IN FRAME write-boutput-file.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
    SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.
    
  RUN prodict/misc/osprefix.p
    ( INPUT  fil,
      OUTPUT prefix,
      OUTPUT basename
      ).
  if basename = fil then assign fil = "./" + fil.
  
  IF /*io-file AND*/ (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-boutput-file.
      RETURN NO-APPLY.
    END. 
  END.
  user_env[26] =  "n" .
END. /* ON "GO" OF write-boutput-file */


ON GO OF FRAME write-def-file
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  fil = user_env[2]:SCREEN-VALUE IN FRAME write-def-file.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
    SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.

  RUN prodict/misc/osprefix.p
    ( INPUT  fil,
      OUTPUT prefix,
      OUTPUT basename
      ).
  if basename = fil then assign fil = "./" + fil.
  
  IF /*io-file AND*/ (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-def-file.
      RETURN NO-APPLY.
    END.
  END.
END. /* ON "GO" OF write-def-file */

ON GO OF FRAME write-dump-file
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  do with frame write-dump-file:
    
    io-mapc = io-mapc:SCREEN-VALUE. /*To cover GUI case where not in UPDATE*/
  
    if not validateFile(user_env[2]:SCREEN-VALUE) then
    do:
        APPLY "ENTRY" TO user_env[2].
        RETURN NO-APPLY.
    END.
    
    if not validateFileExists(user_env[2]:SCREEN-VALUE) then
    do:
        APPLY "ENTRY" TO user_env[2].
        RETURN NO-APPLY.
    END.
    saveLob(inclob:checked in frame write-dump-file,user_env[30]:screen-value in frame write-dump-file).
  end.
END. /* ON "GO" OF write-dump-file */

ON GO OF FRAME write-dump-file-mt
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  do with frame write-dump-file-mt:
    
    io-mapc = io-mapc:SCREEN-VALUE. /*To cover GUI case where not in UPDATE*/
    
    if not validateTenantName(user_env[32]:screen-value) then
    do:
        apply "entry" to user_env[32].
        return no-apply. 
    end. 
    
    /* Validate this when use defaults. It is not directly used 
       but it is prepended to other directories when valid 
      (invalid values are not prepended, and the user might have 
       thought it was, so we need to tell them that the root is wrong)  */
    if UseDefaultdirs
    and not validateDirectory(RootDirectory:screen-value in frame write-dump-file-mt) then 
    do:
        apply "entry" to RootDirectory IN FRAME write-dump-file-mt.
        
        return no-apply.
    end.    

    if not UseDefaultDirs then
    do:
        if not validateFile(user_env[2]:SCREEN-VALUE) then
        do:
            if user_env[2]:sensitive then
                apply "ENTRY" to user_env[2].
            else
                apply "ENTRY" to UseDefaultDirs.
            
            return no-apply.
        end. 
        
        if not validateLobDirectory(user_env[30]:screen-value) then 
        do:
            if user_env[30]:sensitive then
                apply "ENTRY" to user_env[30].
            else
                apply "ENTRY" to UseDefaultDirs.
        
            return no-apply. 
        end. 
    end. /* not usedefaultdirs */
    
    if not validateFileExists(user_env[2]:SCREEN-VALUE) then
    do:
        if user_env[2]:sensitive then
            apply "ENTRY" to user_env[2].
        else
            apply "ENTRY" to UseDefaultDirs.
    
        return no-apply.     
    end.
    
    if UseDefaultDirs then 
    do:
        if not createDirectoryIf(user_env[32]:screen-value) then 
        do:
           apply "entry" to UseDefaultDirs.
           return no-apply.     
        end.
        if not createDirectoryIf(user_env[30]:screen-value) then 
        do:
           apply "entry" to UseDefaultDirs.
           return no-apply.     
        end.
    end.    
    assign user_env[32].
    
    if not setEffectiveTenant(user_env[32]) then
    do:
        apply "entry" to user_env[32].
        return no-apply.    
    end.
    if UseDefaultDirs then
    do:
        saveDefaultLob(inclob:checked in frame write-dump-file-mt,gLobFolderName).
    end.
    else  
        saveLob(inclob:checked in frame write-dump-file-mt,user_env[30]:screen-value in frame write-dump-file-mt).
  end.
END. /* ON "GO" OF write-dump-file-mt */


ON GO OF FRAME write-dump-seq-mt
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  do with frame write-dump-seq-mt:
    assign 
        frame write-dump-seq-mt user_env[33].
    
    if user_env[33] <> "SHARED" then
    do:  
        if not validateTenantName(user_env[32]:screen-value) then
        do:
            apply "entry" to user_env[32].
            return no-apply. 
        end. 
    end.
    
    /* Validate this when use defaults. It is not directly used 
       but it is prepended to other directories when valid 
      (invalid values are not prepended, and the user might have 
       thought it was, so we need to tell them that the root is wrong)  */
    if UseDefaultdirs
    and not validateDirectory(RootDirectory:screen-value) then 
    do:
        apply "entry" to RootDirectory.
        
        return no-apply.
    end.    

    if not UseDefaultDirs then
    do:
        if not validateFile(user_env[2]:SCREEN-VALUE IN FRAME write-dump-seq-mt) then
        do:
            if user_env[2]:sensitive IN FRAME write-dump-seq-mt then
                apply "ENTRY" to user_env[2] IN FRAME write-dump-seq-mt.
            else
                apply "ENTRY" to UseDefaultDirs IN FRAME write-dump-seq-mt.
            
            return no-apply.
        end.        
    end. /* not usedefaultdirs */
    
    if not validateFileExists(user_env[2]:SCREEN-VALUE) then
    do:
        if user_env[2]:sensitive then
            apply "ENTRY" to user_env[2].
        else
            apply "ENTRY" to UseDefaultDirs.
    
        return no-apply.     
    end.
    
    if UseDefaultDirs then 
    do:
        if not createDirectoryIf(user_env[32]:screen-value) then 
        do:
           apply "entry" to UseDefaultDirs.
           return no-apply.     
        end.
    end.

    assign 
        frame write-dump-seq-mt user_env[32].
    if user_env[33] <> "SHARED" then
    do:  
        if not setEffectiveTenant(user_env[32]) then
        do:
            apply "entry" to user_env[32].
            return no-apply.    
        end.
    end.
  end.
END. /* ON "GO" OF write-dump-seq-mt */



ON GO OF FRAME write-dump-file-nobl DO:
  DEFINE VAR basename AS CHARACTER NO-UNDO.
  DEFINE VAR fil      AS CHARACTER NO-UNDO.
  DEFINE VAR prefix   AS CHARACTER NO-UNDO.

  io-mapc = io-mapc:SCREEN-VALUE. /*To cover GUI case where not in UPDATE*/
  fil = user_env[2]:SCREEN-VALUE IN FRAME write-dump-file-nobl.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
     SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.

  RUN prodict/misc/osprefix.p ( INPUT  fil,
                                OUTPUT prefix,
                                OUTPUT basename ).
  IF basename = fil THEN 
    ASSIGN fil = "./" + fil.
  
  IF io-file AND (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-dump-file-nobl.
      RETURN NO-APPLY.
    END.
  END.

END. /* ON "GO" OF write-dump-file */

ON GO OF FRAME write-dump-dir
DO:    
  do with frame write-dump-dir: 
      io-mapc = io-mapc:SCREEN-VALUE. /*To cover GUI case where not in UPDATE*/
  
      if not validateDirectory(user_env[2]:screen-value) then 
      do:
         apply "entry" to user_env[2].
         return no-apply. 
      end. 
        
      if not validateDirectory(user_env[30]:screen-value) then 
      do:
         apply "entry" to user_env[30].
         return no-apply. 
      end. 
      
      /* the validations below ask questions and should be after regular errors */
      
      if not validateDirectoryExists(user_env[2]:screen-value,"output directory") then
      do:
         apply "entry" to user_env[2].
         return no-apply. 
      end. 
      
      if not validateDirectoryExists(user_env[30]:screen-value,"LOB directory") then
      do:
         apply "entry" to user_env[30].
         return no-apply. 
      end. 
      
      saveLob(inclob:checked,user_env[30]:screen-value).
    end.
END. /* ON "GO" OF write-dump-dir */

on go of frame write-dump-dir-mt
do:
    do with frame write-dump-dir-mt:    
      io-mapc = io-mapc:SCREEN-VALUE. /*To cover GUI case where not in UPDATE*/  
      
      if not validateTenantName(user_env[32]:screen-value) then
      do:
          apply "entry" to user_env[32].
          return no-apply. 
      end. 
      if not validateDirectory(user_env[2]:screen-value) then 
      do:
          apply "entry" to user_env[2].
          return no-apply. 
      end. 
      
      if UseDefaultDirs then 
      do:
          if not createDirectoryIf(user_env[33]:screen-value) then 
          do:
              apply "entry" to UseDefaultDirs.
              return no-apply.     
          end.
          if not createDirectoryIf(user_env[30]:screen-value) then 
          do:
              apply "entry" to UseDefaultDirs.
              return no-apply.     
          end.
          if not createDirectoryIf(user_env[34]:screen-value) then 
          do:
              apply "entry" to UseDefaultDirs.
              return no-apply.     
          end.
          
      end.    
      else do:          
          if not validateDirectory(user_env[33]:screen-value) then 
          do:
              apply "entry" to user_env[33].
              return no-apply. 
          end. 
          
          if not validateDirectory(user_env[30]:screen-value) then 
          do:
              apply "entry" to user_env[30].
              return no-apply. 
          end. 
          
          if not validateTenantLobDirectory(user_env[34]:screen-value) then 
          do:
              apply "entry" to user_env[34].
              return no-apply. 
          end. 
      end.
      
      /* the validations below ask questions and should be after regular errors */
      if not validateDirectoryExists(user_env[2]:screen-value,"output directory") then
      do:
          apply "entry" to user_env[2].
          return no-apply. 
      end. 
      
      if not validateDirectoryExists(user_env[33]:screen-value,"tenant directory") then
      do:
          apply "entry" to user_env[33].
          return no-apply. 
      end. 
      
      if not validateDirectoryExists(user_env[30]:screen-value,"LOB directory") then
      do:
          apply "entry" to user_env[30].
          return no-apply. 
      end. 
      
      if not validateDirectoryExists(user_env[34]:screen-value,"tenant LOB directory") then
      do:
          apply "entry" to user_env[34].
          return no-apply. 
      end. 
      assign user_env[32].
    
      if not setEffectiveTenant(user_env[32]) then
      do:
         apply "entry" to user_env[32].
         return no-apply.    
      end.
      if UseDefaultDirs then
      do:
          user_env[37] = gGroupFolderName.
          saveDefaultLob(inclob:checked in frame write-dump-dir-mt,gLobFolderName).
      end.
      else  
          saveLobMt(inclob:checked in frame write-dump-dir-mt,user_env[30],user_env[34]).
    end.
end. /* ON "GO" OF write-dump-dir-mt */

ON GO OF FRAME write-audit-data
DO:
  DEFINE VARIABLE cDir    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lExist  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cFile   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iFile   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSlash  AS CHARACTER   NO-UNDO.

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    cSlash = "/".
  &ELSE 
    cSlash = "~\".
  &ENDIF

  cDir = user_env[2]:SCREEN-VALUE IN FRAME write-audit-data.

  IF cDir = "" THEN cDir = ".".
  FILE-INFO:FILE-NAME = cDir.
  lExist = (FILE-INFO:FULL-PATHNAME NE ?).
  IF NOT lExist THEN DO:
    MESSAGE "Directory " + cDir + " does not exist!" SKIP(1)
            "Please enter a valid directory name."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME write-audit-data.
    RETURN NO-APPLY.
  END.

  lExist = FALSE.
  DO i = 1 TO NUM-ENTRIES(user_env[1])
      WHILE NOT lExist:
    FILE-INFO:FILE-NAME = TRIM(cDir,cSlash) + cSlash + 
        ENTRY(i,user_env[1]) + ".ad".
    lExist = (FILE-INFO:FULL-PATHNAME NE ?).
  END.

  IF lExist THEN DO:
    answer = FALSE.
    MESSAGE "One or more of the files already exist in this directory." SKIP 
            "Overwrite them?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-audit-data.
      RETURN NO-APPLY.
    END.
  END.

   IF inclob:SCREEN-VALUE IN FRAME write-audit-data = "no" THEN
      ASSIGN user_env[31] = " NO-LOBS"
             user_env[30] = "".
  ELSE
      ASSIGN user_env[31] = ""
             user_env[30] = user_env[30]:SCREEN-VALUE IN FRAME write-audit-data.
END. /* ON "GO" OF write-audit-data */

ON GO OF FRAME write-dump-dir-nobl
DO:
  DEFINE VARIABLE cDir    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lExist  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cFile   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iFile   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSlash  AS CHARACTER   NO-UNDO.

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    cSlash = "/".
  &ELSE 
    cSlash = "~\".
  &ENDIF

  cDir = user_env[2]:SCREEN-VALUE IN FRAME write-audit-data.

  IF cDir = "" THEN cDir = ".".
  FILE-INFO:FILE-NAME = cDir.
  lExist = (FILE-INFO:FULL-PATHNAME NE ?).
  IF NOT lExist THEN DO:
    MESSAGE "Directory " + cDir + " does not exist!" SKIP(1)
            "Please enter a valid directory name."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME write-audit-data.
    RETURN NO-APPLY.
  END.

  lExist = FALSE.
  DO i = 1 TO NUM-ENTRIES(user_env[1])
      WHILE NOT lExist:
    FILE-INFO:FILE-NAME = TRIM(cDir,cSlash) + cSlash + 
        ENTRY(i,user_env[1]) + ".d".
    lExist = (FILE-INFO:FULL-PATHNAME NE ?).
  END.

  IF lExist THEN DO:
    answer = FALSE.
    MESSAGE "One or more of the files already exist in this directory." SKIP 
            "Overwrite them?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-audit-data.
      RETURN NO-APPLY.
    END.
  END.

  io-mapc = io-mapc:SCREEN-VALUE. /*To cover GUI case where not in UPDATE*/
END. /* ON "GO" OF write-dump-dir-nobl */

ON GO OF FRAME write-dump-dir-cdpg
DO:
  DEFINE VARIABLE cDir    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lExist  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cFile   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iFile   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSlash  AS CHARACTER   NO-UNDO.

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    cSlash = "/".
  &ELSE 
    cSlash = "~\".
  &ENDIF

  cDir = user_env[2]:SCREEN-VALUE IN FRAME write-dump-dir-cdpg.

  IF cDir = "" THEN cDir = ".".
  FILE-INFO:FILE-NAME = cDir.
  lExist = (FILE-INFO:FULL-PATHNAME NE ?).
  IF NOT lExist THEN DO:
    MESSAGE "Directory " + cDir + " does not exist!" SKIP(1)
            "Please enter a valid directory name."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME write-dump-dir-cdpg.
    RETURN NO-APPLY.
  END.

  lExist = FALSE.
  DO i = 1 TO NUM-ENTRIES(user_env[1])
      WHILE NOT lExist:
    FILE-INFO:FILE-NAME = TRIM(cDir,cSlash) + cSlash + 
        ENTRY(i,user_env[1]) + ".d".
    lExist = (FILE-INFO:FULL-PATHNAME NE ?).
  END.

  IF lExist THEN DO:
    answer = FALSE.
    MESSAGE "One or more of the files already exist in this directory." SKIP 
            "Overwrite them?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-dump-dir-cdpg.
      RETURN NO-APPLY.
    END.
  END.
END. /* ON "GO" OF write-dump-dir-cdpg */

IF user_env[9] = "x" THEN DO:
  ON CHOOSE OF btn_Cancel IN FRAME write-output-file
    APPLY "WINDOW-CLOSE" TO FRAME write-output-file.
END.

IF user_env[9] = "t" THEN DO:
  ON CHOOSE OF btn_Cancel IN FRAME write-dump-dir-cdpg
    APPLY "WINDOW-CLOSE" TO FRAME write-dump-dir-cdpg.
END.

/*----- ON WINDOW-CLOSE -----*/
on WINDOW-CLOSE of frame write-output-file
   apply "END-ERROR" to frame write-output-file.
   
on END-ERROR of frame write-output-file
   assign user_env[1] = ?
          user_longchar = (IF isCpUndefined THEN user_longchar ELSE ?).


on WINDOW-CLOSE of frame write-output-file-nocp
   apply "END-ERROR" to frame write-output-file-nocp.
on END-ERROR of frame write-output-file-nocp
   ASSIGN user_env[1] = ?
          user_longchar = (IF isCpUndefined THEN user_longchar ELSE ?).

on WINDOW-CLOSE of frame write-boutput-file
   apply "END-ERROR" to frame write-boutput-file.
on WINDOW-CLOSE of frame write-dump-file
   apply "END-ERROR" to frame write-dump-file.
on WINDOW-CLOSE of frame write-dump-file-mt
   apply "END-ERROR" to frame write-dump-file-mt.
on WINDOW-CLOSE of frame write-dump-seq-mt
   apply "END-ERROR" to frame write-dump-seq-mt.
ON WINDOW-CLOSE OF FRAME write-dump-file-nobl
   APPLY "END-ERROR" TO FRAME write-dump-file-nobl.
on WINDOW-CLOSE of frame write-dump-dir
   apply "END-ERROR" to frame write-dump-dir.
on WINDOW-CLOSE of frame write-dump-dir-mt
   apply "END-ERROR" to frame write-dump-dir.
on WINDOW-CLOSE of frame write-audit-data
   apply "END-ERROR" to frame write-audit-data.
ON END-ERROR OF FRAME write-audit-data
   user_env[1] = ?.
ON CHOOSE OF btn_cancel IN FRAME write-audit-data
   user_env[1] = ?.
on WINDOW-CLOSE of frame write-dump-dir-nobl
   apply "END-ERROR" to frame write-dump-dir-nobl.
on WINDOW-CLOSE of frame write-dump-dir-cdpg
   apply "END-ERROR" to frame write-dump-dir-cdpg.
ON END-ERROR OF FRAME write-dump-dir-cdpg
   ASSIGN user_env[1] = ?
          user_longchar = (IF isCpUndefined THEN user_longchar ELSE ?).

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[2] IN FRAME write-output-file
do:   
   do with frame write-output-file:      
      trimScreenValue(user_env[2]:handle). 
   end.
end.

ON LEAVE OF user_env[2] in frame write-output-file-nocp
do:   
   do with frame write-output-file-nocp:      
      trimScreenValue(user_env[2]:handle). 
   end.
end.

ON LEAVE OF user_env[2] in frame write-boutput-file
do:   
   do with frame write-boutput-file:      
      trimScreenValue(user_env[2]:handle). 
   end.
end.

ON LEAVE OF user_env[2] in frame write-dump-file
do:   
   do with frame write-dump-file:      
      trimScreenValue(user_env[2]:handle). 
   end.
end.

ON LEAVE OF user_env[2] IN FRAME write-dump-file-nobl
do:   
   do with frame write-dump-file-nobl:      
      trimScreenValue(user_env[2]:handle). 
   end.
end.

ON LEAVE OF user_env[2] in frame write-dump-dir DO:
    do with frame write-dump-dir:      
        if not validateDirScreenValue(user_env[2]:handle) then
            RETURN NO-APPLY.
    end.
END.


ON LEAVE OF user_env[2] IN FRAME write-audit-data DO:
    do with frame write-audit-data:      
        if not validateDirScreenValue(user_env[2]:handle) then
            RETURN NO-APPLY.
    end.
END.

ON LEAVE OF user_env[2] IN FRAME write-dump-dir-nobl DO:
    do with frame write-dump-dir-nobl:      
        if not validateDirScreenValue(user_env[2]:handle) then
            RETURN NO-APPLY.
    end.
END. /* ON "LEAVE" OF user_env[2] IN write-dump-dir-nobl */

ON LEAVE OF user_env[2] in frame write-dump-dir-cdpg DO:
    do with frame write-dump-dir-cdpg:      
        if not validateDirScreenValue(user_env[2]:handle) then
            RETURN NO-APPLY.
    end.
END. /* ON "LEAVE" OF user_env[2] IN write-dump-dir-cdpg */

ON LEAVE OF user_env[30] in frame write-dump-file DO:
    do with frame write-dump-file:      
        if not validateDirScreenValue(user_env[30]:handle) then
            RETURN NO-APPLY.
    end.
END. /* ON "LEAVE" OF user_env[30] IN write-dump-file */

ON LEAVE OF user_env[30] in frame write-dump-dir DO:
    do with frame write-dump-dir:      
        if not validateDirScreenValue(user_env[30]:handle) then
            RETURN NO-APPLY.
    end.
END. /* ON "LEAVE" OF user_env[30] IN write-dump-dir */

ON LEAVE OF user_env[30] IN FRAME write-audit-data DO:
    do with frame write-audit-data:      
        if not validateDirScreenValue(user_env[30]:handle) then
            RETURN NO-APPLY.
    end.
END. /* ON "LEAVE" OF user_env[30] IN write-audit-data */

ON VALUE-CHANGED OF inclob IN FRAME write-boutput-file DO:
  IF inclob:SCREEN-VALUE IN FRAME write-boutput-file = "no" THEN
    ASSIGN user_env[30]:SENSITIVE IN FRAME write-boutput-file = FALSE
           user_env[30]:SCREEN-VALUE IN FRAME write-boutput-file = ""
           user_env[30] = "".
  ELSE
    user_env[30]:SENSITIVE IN FRAME write-boutput-file = TRUE.
END. /* ON "VALUE-CHANGED" OF inclob IN write-boutput-file */


ON VALUE-CHANGED OF inclob IN FRAME write-dump-file 
DO:
    IF SELF:screen-value = "yes" THEN
      ASSIGN user_env[30]:sensitive in frame write-dump-file = YES
             s_res = user_env[30]:MOVE-AFTER-TAB-ITEM(inclob:HANDLE).
    ELSE
     ASSIGN user_env[30]:SENSITIVE IN FRAME write-dump-file = NO.            

   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
     IF SELF:screen-value = "yes" THEN
       ASSIGN btn_dir:SENSITIVE IN FRAME write-dump-file = YES
              s_res = btn_dir:MOVE-AFTER-TAB-ITEM(user_env[30]:HANDLE).
     ELSE 
       ASSIGN btn_dir:SENSITIVE IN FRAME write-dump-file = NO.
   &ENDIF
END. /* ON "VALUE-CHANGED" OF inclob IN write-dump-file */

ON VALUE-CHANGED OF inclob IN FRAME write-dump-file-mt 
DO:
    refreshFileMTState().
END. /* ON "VALUE-CHANGED" OF inclob IN write-dump-file */

ON VALUE-CHANGED OF inclob IN FRAME write-dump-dir-mt 
DO:
    refreshDirMTState().
END. /* ON "VALUE-CHANGED" OF inclob IN write-dump-file */


ON VALUE-CHANGED OF inclob IN FRAME write-dump-dir 
DO:
    IF SELF:screen-value = "yes" THEN
      ASSIGN user_env[30]:sensitive in frame write-dump-dir = YES
             s_res = user_env[30]:MOVE-AFTER-TAB-ITEM(inclob:HANDLE).           
    ELSE 
     ASSIGN user_env[30]:SENSITIVE IN FRAME write-dump-dir = NO.
            
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
     IF SELF:screen-value = "yes" THEN
       ASSIGN btn_dir:SENSITIVE IN FRAME write-dump-dir = YES
              s_res = btn_dir:MOVE-AFTER-TAB-ITEM(user_env[30]:HANDLE).
     ELSE
       ASSIGN btn_dir:SENSITIVE IN FRAME write-dump-dir = NO.
   &ENDIF
END. /* ON "VALUE-CHANGED" OF inclob IN write-dump-dir */

ON VALUE-CHANGED OF inclob IN FRAME write-audit-data 
DO:
    IF SELF:SCREEN-VALUE = "yes" THEN
      ASSIGN user_env[30]:SENSITIVE IN FRAME write-audit-data = YES
             s_res = user_env[30]:MOVE-AFTER-TAB-ITEM(inclob:HANDLE).           
    ELSE 
     ASSIGN user_env[30]:SENSITIVE IN FRAME write-audit-data = NO.
            
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
     IF SELF:SCREEN-VALUE = "yes" THEN
       ASSIGN btn_dir:SENSITIVE IN FRAME write-audit-data = YES
              s_res = btn_dir:MOVE-AFTER-TAB-ITEM(user_env[30]:HANDLE).
     ELSE
       ASSIGN btn_dir:SENSITIVE IN FRAME write-audit-data = NO.
   &ENDIF
END. /* ON "VALUE-CHANGED" OF inclob IN write-audit-data */

ON VALUE-CHANGED OF user_env[2] IN FRAME write-dump-dir-mt
do:
    refreshDirInDirUI().   
end.    

ON VALUE-CHANGED OF user_env[2] IN FRAME write-dump-file-mt
do:
    assign frame write-dump-file-mt user_env[2].
end.    

ON VALUE-CHANGED OF user_env[32] IN FRAME write-dump-file-mt
do:
    refreshTenantInFileUI().
end. 

ON VALUE-CHANGED OF user_env[32] IN FRAME write-dump-dir-mt
do:
    refreshTenantInDirUI().
end. 

ON VALUE-CHANGED OF user_env[32] IN FRAME write-dump-seq-mt
do:
    refreshTenantInSeqUI().
end. 


ON VALUE-CHANGED OF user_env[30] IN FRAME write-dump-file-mt
do:
    assign frame write-dump-file-mt user_env[30].
end. 

ON VALUE-CHANGED OF user_env[30] IN FRAME write-dump-dir-mt
do:
    assign frame write-dump-dir-mt user_env[30].
end.
 
ON VALUE-CHANGED OF user_env[33] IN FRAME write-dump-dir-mt
do:
    assign frame write-dump-dir-mt user_env[33].
end. 

ON VALUE-CHANGED OF user_env[33] IN FRAME write-dump-seq-mt
do:
    assign frame write-dump-seq-mt user_env[33].
    case user_env[33]:
        
        when "Tenant" then 
        do:
            UseDefaultDirs:sensitive in frame write-dump-seq-mt = true. 
            UseDefaultDirs:checked in frame write-dump-seq-mt = true.
            user_env[32]:sensitive in frame write-dump-seq-mt = true.
            user_env[32]:screen-value in frame write-dump-seq-mt = user_env[32].
        end.
        when "Shared" then 
        do:
            UseDefaultDirs:sensitive in frame write-dump-seq-mt = false. 
            UseDefaultDirs:checked in frame write-dump-seq-mt = false.            
            user_env[32]:sensitive in frame write-dump-seq-mt = false.
            user_env[32]:screen-value in frame write-dump-seq-mt = "".
        end.
        otherwise /*when "All" then */
        do:
            UseDefaultDirs:sensitive in frame write-dump-seq-mt = true. 
            UseDefaultDirs:checked in frame write-dump-seq-mt = false.
            user_env[32]:sensitive in frame write-dump-seq-mt = true.
            user_env[32]:screen-value in frame write-dump-seq-mt = user_env[32].
            
        end.
    end.
    btn_Tenant:sensitive in frame write-dump-seq-mt = 
          user_env[32]:sensitive in frame write-dump-seq-mt.
    if UseDefaultDirs:checked <> UseDefaultDirs then
         apply "value-changed" to UseDefaultDirs in frame write-dump-seq-mt.
 

end. 

ON VALUE-CHANGED OF user_env[34] IN FRAME write-dump-dir-mt
do:
    assign frame write-dump-dir-mt user_env[34].
end. 

ON VALUE-CHANGED OF RootDirectory IN FRAME write-dump-file-mt
do:
    refreshDirInFileUI(). 
end.

ON VALUE-CHANGED OF RootDirectory IN FRAME write-dump-seq-mt
do:
    refreshDirInSeqUI(). 
end.

    
ON VALUE-CHANGED OF UseDefaultDirs IN FRAME write-dump-file-mt
do:
    assign FRAME write-dump-file-mt UseDefaultDirs.
    if UseDefaultDirs then
        refreshFileMT(). 
    
    refreshFileMtState().
end.

ON VALUE-CHANGED OF UseDefaultDirs IN FRAME write-dump-seq-mt
do:
    assign FRAME write-dump-seq-mt UseDefaultDirs.
/*    if UseDefaultDirs then*/
        refreshSeqMT(). 
    
    refreshSeqMtState().
end.

ON VALUE-CHANGED OF UseDefaultDirs IN FRAME write-dump-dir-mt
do:
    assign FRAME write-dump-dir-mt UseDefaultDirs.
    if UseDefaultDirs then
        refreshDirMT(). 
    
    refreshDirMtState().
end.


/* code-page-stuff    <hutegger> 94/02 */
  
{prodict/user/usrdump1.i
  &frame    = "write-dump-dir"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */

{prodict/user/usrdump1.i
  &frame    = "write-dump-dir-mt"
  &variable = "user_env[5]"
}  /* checks if user_env[5] contains convertable code-page */
  
{prodict/user/usrdump1.i
  &frame    = "write-dump-dir-nobl"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */

{prodict/user/usrdump1.i
  &frame    = "write-dump-file"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */

{prodict/user/usrdump1.i
  &frame    = "write-dump-file-mt"
  &variable = "user_env[5]"
 }  /* checks if user_env[5] contains convertable code-page */
 
{prodict/user/usrdump1.i
      &frame    = "write-dump-file-nobl"
      &variable = "user_env[5]"
      }  /* checks if user_env[5] contains convertable code-page */

{prodict/user/usrdump1.i
  &frame    = "write-output-file"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */
  
 {prodict/user/usrdump1.i
  &frame    = "write-boutput-file"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */ 
  
ON CHOOSE OF btn_Tenant IN FRAME write-dump-dir-mt
DO:
    do with frame write-dump-dir-mt:
       selectTenant(user_env[32]:handle).
    end.
END.

ON CHOOSE OF btn_Tenant IN FRAME write-dump-file-mt
DO:
    do with frame write-dump-file-mt:
       selectTenant(user_env[32]:handle).
    end.
END.

ON CHOOSE OF btn_Tenant IN FRAME write-dump-seq-mt
DO:
    do with frame write-dump-seq-mt:
       selectTenant(user_env[32]:handle).
    end.
END.  

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame write-output-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-output-file /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame write-output-file-nocp DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-output-file-nocp /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame write-boutput-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-boutput-file /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.

ON CHOOSE OF btn_File in frame write-dump-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-dump-file /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.

ON CHOOSE OF btn_File in frame write-dump-file-mt DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-dump-file-mt /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.

ON CHOOSE OF btn_File in frame write-dump-seq-mt DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-dump-seq-mt /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.


ON CHOOSE OF btn_File IN FRAME write-dump-file-nobl DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:HANDLE IN FRAME write-dump-file-nobl /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT NO                 /*Must exist*/).
END.

ON CHOOSE OF btn_File in frame write-def-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-def-file /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.
 
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  

ON VALUE-CHANGED OF io-mapl IN FRAME write-dump-file DO:
   refreshMapping(io-mapl:handle in frame write-dump-file,
                  io-mapc:handle in frame write-dump-file).
END. /* ON "VALUE-CHANGED" OF io-mapl IN write-dump-file */

ON VALUE-CHANGED OF io-mapl IN FRAME write-dump-file-mt DO:
   refreshMapping(io-mapl:handle in frame write-dump-file-mt,
                  io-mapc:handle in frame write-dump-file-mt).
END. /* ON "VALUE-CHANGED" OF io-mapl IN write-dump-file-mt */


ON VALUE-CHANGED OF io-mapl IN FRAME write-dump-file-nobl DO:
   refreshMapping(io-mapl:handle in frame write-dump-file-nobl,
                  io-mapc:handle in frame write-dump-file-nobl).
END. /* ON "VALUE-CHANGED" OF io-mapl IN write-dump-file-nobl */

ON VALUE-CHANGED OF io-mapl IN FRAME write-dump-dir DO:
    refreshMapping(io-mapl:handle in frame write-dump-dir,
                  io-mapc:handle in frame write-dump-dir).
END. /* ON "VALUE-CHANGED" OF io-mapl IN write-dump-dir */

ON VALUE-CHANGED OF io-mapl IN FRAME write-dump-dir-mt DO:
    refreshMapping(io-mapl:handle in frame write-dump-dir-mt,
                  io-mapc:handle in frame write-dump-dir-mt).
END. /* ON "VALUE-CHANGED" OF io-mapl IN write-dump-dir-mt */


ON VALUE-CHANGED OF io-mapl IN FRAME write-dump-dir-nobl DO:
    refreshMapping(io-mapl:handle in frame write-dump-dir-nobl,
                  io-mapc:handle in frame write-dump-dir-nobl).
END. /* ON "VALUE-CHANGED" OF io-mapl IN write-dump-dir-nobl */

&ENDIF
/*============================Mainline code===============================*/

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

ASSIGN
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
  io-mapc  = "NO-MAP"
&ENDIF
  class    = SUBSTRING(user_env[9],1,1)
  io-file  = TRUE
  prefix   = ""
  dmp-rpos:HIDDEN IN FRAME write-output-file = 
  (IF class = "d" THEN FALSE ELSE TRUE).


/* for "some" operations, if user_env[1] is empty, then we got a bug
   list in user_longchar 
*/
IF user_env[1] = "" AND (class = "f" OR class = "d" OR class = "b") THEN
   ASSIGN is-some  = (user_longchar MATCHES "*,*").
ELSE
   ASSIGN is-some  = (user_env[1] MATCHES "*,*").
 
ASSIGN
      is-all   = (user_env[1] = "ALL")
      is-one   = NOT is-all AND NOT is-some 
      user_env[37] = ""  
      user_env[40] = ""  
      .

if int(dbversion("dictdb")) > 10 then
do:
   isSuperTenant = can-find(first dictdb._tenant) and  tenant-id("dictdb") < 0.
   
end.

/* Set default value for codepage gfs:94-04-28-043 */
IF user_env[5] = "" OR user_env[5] = ? THEN DO:
  IF SESSION:CHARSET = "UNDEFINED" THEN 
  DO:
    FIND FIRST _db NO-LOCK.
    ASSIGN user_env[5]  = _db._db-xl-name. /* db codepage */
  END.
  ELSE IF SESSION:STREAM  = "UNDEFINED" THEN
    ASSIGN user_env[5]  = SESSION:CHARSET.
  ELSE ASSIGN user_env[5] = SESSION:STREAM.
  ASSIGN user_env[5]:SENSITIVE = true.
END.

IF user_env[1] <> "" AND 
   NOT is-all  AND 
   NOT is-some AND
   NOT CAN-DO("y,t,x",user_env[9]) THEN DO FOR _File:
  FIND _File WHERE _Db-recid = drec_db AND _File-name = user_env[1]
               AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
  dump-as = (IF _File._Dump-name = ?
            THEN SUBSTRING(_File._File-name,1,8)
            ELSE _File._Dump-name).
END.
 

/*----------------------------------------------*/ /* DUMP FILE DEFINITIONS */
IF class = "d" OR class = "4" THEN DO FOR _File:
  FIND _File WHERE _File._File-name = "_Db"
               AND _File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  
  FIND _File WHERE _File._File-name = "_File"
               AND _File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File WHERE _File._File-name = "_Field"
               AND _File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File where _File._File-name = "_Index"
               AND _File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF is-all OR is-some 
   then do:
    if PDBNAME(user_dbname) <> ?
     THEN RUN "prodict/misc/osprefix.p"
             ( INPUT PDBNAME(user_dbname),
               OUTPUT trash,
               OUTPUT dump-as
               ).
      else assign dump-as = user_dbname.
     end.          
  ASSIGN
    user_env[2] = (IF class = "4" THEN "_trgdefs.df"
                  ELSE prefix + dump-as + ".df")
    io-title    = (IF class = "4" THEN "Dump Database Triggers for "
                  ELSE "Dump Data Definitions for ")
                + (IF is-all THEN "All Tables"
                  ELSE IF is-some THEN "Some Tables"
                  ELSE "Table" + ' "' + user_env[1] + '"').

END. /* IF class = "d" OR "4" */

/*--------------------------------------------*/ /* DUMP DATA FILE CONTENTS */
ELSE IF class = "f" THEN DO FOR _File:

  nodump = "u".
  { prodict/dictgate.i &action=undumpload
    &dbtype=user_dbtype &dbrec=drec_db &output=nodump
  }

  FIND _File "_File".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  
  IF is-one OR is-some THEN
  DO:
      /* if user_env[1] is "", then value is in user_longchar */
      IF user_env[1] NE "" THEN DO:
          IF isCpUndefined THEN
             base = user_env[1].
          ELSE
             base_lchar = user_env[1].
      END.
      ELSE
          base_lchar = user_longchar.

  END.
  ELSE
      base = "".

  ASSIGN
    user_env[2] = prefix + (IF is-all OR is-some THEN "" ELSE dump-as + ".d")
    
    io-file     = NOT is-all AND NOT is-some
    io-title    = "Dump Data Contents for "
                + (IF is-all THEN "All Tables"
                  ELSE IF is-some THEN "Some Tables"
                  ELSE "Table" + ' "' + user_env[1] + '"')
    user_env[1] = ""
    user_longchar = (IF isCpUndefined THEN user_longchar ELSE "")
    comma       = ""
    i           = 1.

  /* If user had selected ALL, fill base array with list of files.  
     Otherwise, it is already set to file list.
  */
  IF is-all THEN FOR EACH _File
    WHERE _File._File-number > 0
      AND (IF NOT fHidden THEN NOT _File._Hidden ELSE _File._File-Number > 0)
      AND _File._Tbl-Type <> "V"
      AND _File._Db-recid = drec_db
      AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" )
      AND CAN-DO(_File._Can-read,USERID(user_dbname))
      AND CAN-DO(_File._Can-dump,USERID(user_dbname))
      AND (nodump = "" OR NOT CAN-DO(nodump,_File._For-type))
    BY _File._File-name:
       IF (isCpUndefined) THEN
           base = base + (IF base = "" THEN "" ELSE ",") + _File._File-name.
       ELSE
           base_lchar = base_lchar + (IF base_lchar = "" THEN "" ELSE ",") + _File._File-name.
  END.

  /* Run through the file list and cull out the ones that the user
     is not allowed to dump for some reason.
  */
  user_env[4] = "".
  
  IF isCpUndefined THEN
      ASSIGN numCount = NUM-ENTRIES(base).
  ELSE
      ASSIGN numCount = NUM-ENTRIES(base_lchar).
  isAllMultiTenant = ?.
  DO i = 1 TO numCount:
    err = ?.
    dis_trig = "y".

    IF isCpUndefined THEN
        cItem = ENTRY(i,base).
    ELSE
        cItem = ENTRY(i,base_lchar).

    FIND _File
      WHERE _File._Db-recid = drec_db AND _File._File-name = cItem
        AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
    IF NOT CAN-DO(_File._Can-read,USERID(user_dbname)) OR 
       NOT CAN-DO(_File._Can-dump,USERID(user_dbname)) THEN
      err = _File._File-name
        + " will not be dumped due to insufficient privileges.".
    ELSE 
    IF nodump <> "" AND CAN-DO(nodump,_File._For-type) THEN
      err = "".
        /*SUBSTITUTE("&1 is a &2 &3 and cannot be dumped.",
          _File._File-name,user_dbtype,_File._For-type).*/
    ELSE DO:
      {prodict/dump/dtrigchk.i &OK = answer}
      IF NOT answer THEN DO:
         MESSAGE "You do not have privileges to dump table" _File._File-name 
                 SKIP
                 "with triggers disabled.  Do you want to dump this table" SKIP
                 "anyway even though the FIND trigger will fire?"
                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE answer.
         IF answer = no THEN
            err = "".  /* don't do this table but no more messages */
         ELSE IF answer = yes THEN DO:
            err = ?.   /* include this table in dump */
            dis_trig = "n".
         END.
         ELSE DO:    /* cancel the dump operation */
            user_path = "".
            RETURN.
         END.
      END.
    END.

    IF err = ? THEN DO:

      /* now we will only put the table number of tables that we will not
         disable triggers for, which is the exception (for most cases).
      */
      IF dis_trig = "n" THEN DO:
          IF user_env[4] = "" THEN
             user_env[4] = STRING(_File._File-number).
          ELSE
              user_env[4] = user_env[4] + "," + STRING(_File._File-number).
      END.

      IF isCpUndefined THEN
         user_env[1] = user_env[1] + comma + _File._File-name.
      ELSE
         user_longchar = user_longchar + comma + _File._File-name.

      ASSIGN comma       = ",".
    END.
    ELSE IF err <> "" THEN DO:
      answer = TRUE.
      IF NUM-ENTRIES(IF isCpUndefined THEN base ELSE base_lchar) = 1 THEN DO:
         MESSAGE err VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         user_path = "".
         RETURN.
      END.
      ELSE DO:
         MESSAGE err SKIP "Do you want to continue?"
            VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO UPDATE answer.
         IF answer = FALSE THEN DO:
            user_path = "".
            return.
         END.
      END.
    END.
    if isSuperTenant then 
    do:         
        if isAnyMultiTenant = false then 
            isAnyMultiTenant = _file._file-attributes[1].
       
        if isAllMultiTenant = ? or isAllMultiTenant then
           isAllMultiTenant = _file._file-attributes[1].   
    end.
    
  END.  /* end of DO i = 2 TO numCount */
  if isAllMultiTenant = ? then
        isAllMultiTenant = false. 
  
  /* subsequent removal of files changed from many to one, so reset ui stuff */
  IF (is-some OR is-all) AND 
     NUM-ENTRIES((IF isCpUndefined THEN user_env[1] ELSE user_longchar)) = 1 THEN DO:

    IF NOT isCpUndefined THEN
       assign user_env[1] = user_longchar
              user_longchar ="".

    FIND _File
      WHERE _File._Db-recid = drec_db
        AND _File._File-name = user_env[1]
      AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
    
    ASSIGN  
      is-some     = FALSE
      is-all      = FALSE
      is-one      = TRUE
      user_env[2] = prefix + (IF _File._Dump-name = ?
                    THEN _File._File-name ELSE _File._Dump-name)
                  + ".d"
      io-file     = TRUE
      io-title    = "Dump Data Contents for Table ~"" + user_env[1] + "~""
      base        = user_env[1].
  END. /* IF is-some OR is-all */
  ELSE DO:
      /* set multitenant flag to identify tenant specific data dump for file */
      if int(dbversion("dictdb")) > 10 then 
      do:
          if io-file then
          do:
              FIND _File
              WHERE _File._Db-recid = drec_db
                AND _File._File-name = cItem /* Fixed 209398*/
                AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
         
          end.    
      end. 
      
      IF NOT isCpUndefined THEN DO:
          /* see if we can put user_longchar into user_env[1] */
          ASSIGN user_env[1] = user_longchar NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN
             ASSIGN user_longchar = "".
          ELSE
             ASSIGN user_env[1] = "".
      END.
      
  END.

END. /* IF class = "f" */

/*-----------------------------------------------------*/ /* DUMP SEQ DEFS */
ELSE IF class = "s" THEN DO FOR _File:
  FIND _File "_Sequence".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  
  ASSIGN
    user_env[2] = prefix + "_seqdefs.df"
    io-title    = "Dump Sequence Definitions".
 
END.

/*-----------------------------------------------------*/ /* DUMP SEQ VALS */
ELSE IF class = "k" THEN DO FOR _File:
  FIND _File "_Sequence".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_seqvals.d"
    io-title    = "Dump Sequence Current Values".
  if isSuperTenant then 
  do:      
  
     isAllMultiTenant = ?.
     FOR EACH _Sequence where _Db-recid = drec_db and NOT _Sequence._Seq-name BEGINS "$" no-lock:
        if isAnyMultiTenant = false then 
            isAnyMultiTenant = _Sequence._Seq-attributes[1].
       
        if isAllMultiTenant = ? or isAllMultiTenant then
           isAllMultiTenant = _Sequence._Seq-attributes[1].   
           
     end. 
     if isAllMultiTenant = ? then
        isAllMultiTenant = false.
      
  end.
END.

/*------------------------------------------*/ /* DUMP AUTO-CONNECT RECORDS */
ELSE IF class = "a" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_auto.df"
    io-title    = "Dump Auto-Connect Records".
END.

/*-----------------------*/ /* DUMP AUDIT POLICIES - AS XML */
ELSE IF class = "x" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-Read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN io-title    = "Dump Audit Policies as XML"
         user_env[5] = "UTF-8"
         user_env[5]:SENSITIVE IN FRAME write-output-file = FALSE.
END.

/*------------------*/ /* DUMP DATABASE OPTIONS */
ELSE IF class = "o" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-Read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  io-title    = "Dump Database Options".
END.

/*------------------*/ /* DUMP SECURITY AUTHENTICATION RECORDS */
ELSE IF class = "h" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-Read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  io-title    = "Dump Security Domains" /* Security Authentication Records" */.
END.

/*------------------*/ /* DUMP SECURITY PERMISSIONS */
ELSE IF class = "m" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-Read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  io-title    = "Dump Security Permissions".
END.

/*--------------------------------------*/ /* DUMP APPLICATION AUDIT EVENTS */
ELSE IF class = "e" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-Read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  io-title    = "Dump Application Audit Events".
END.

/*---------------------------------------*/ /* DUMP AUDIT POLICIES - AS TEXT */
ELSE IF class = "t" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-Read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  io-title    = "Dump Audit Policies as Text".  
END.

/*---------------------------------------*/ /* DUMP AUDIT DATA */
ELSE IF class = "y" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-Read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  io-title    = "Dump Audit Data".
END.

/*------------------------------------------*/ /* DUMP COLLATION stuff */
ELSE IF class = "c" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_tran.df"
    io-title    = "Dump Collation Tables".
END.

/*--------------------------------------------*/ /* DUMP USER FILE CONTENTS */
ELSE IF class = "u" THEN DO FOR _File:
  FIND _File "_User".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_user.d"
    io-title    = "Dump User Table Contents".
END.

/*--------------------------------------------*/ /* DUMP VIEW FILE CONTENTS */
ELSE IF class = "v" THEN DO FOR _File:
  FIND _File "_View".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 2.
  ASSIGN
    user_env[2] = prefix + "_view.d"
    io-title    = "Dump SQL Views".
END.

/*---------------------------------*/ /* DUMP FILE DEFINITIONS IN V5 FORMAT */
ELSE IF class = "5" THEN DO FOR _File:
  FIND _File "_File".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File "_Field".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File "_Index".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 4.
  IF is-all OR is-some  
   then do:
    if PDBNAME(user_dbname) <> ?
     THEN RUN "prodict/misc/osprefix.p"
             ( INPUT PDBNAME(user_dbname),
               OUTPUT trash,
               OUTPUT dump-as
               ).
      else assign dump-as = user_dbname.
     end.          
  ASSIGN
    user_env[2] = prefix + dump-as + ".df"
    io-title    = "Dump Definitions in V5 Format for "
                + (IF is-all THEN "All Tables"
                  ELSE IF is-some THEN "Some Tables"
                  ELSE "Table" + ' "' + user_env[1] + '"').
END. /* IF class = "5" */
/*-------------------------------------*/ /* MAKE BULKLOAD DESCRIPTION FILE */
ELSE IF class = "b" THEN DO FOR _File:
  FIND _File "_File".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File "_Field".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File "_Index".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 5.
  IF is-all OR is-some  
   then do:
    if PDBNAME(user_dbname) <> ?
      THEN RUN "prodict/misc/osprefix.p"
              ( INPUT PDBNAME(user_dbname),
              OUTPUT trash,
              OUTPUT dump-as
              ).
      else assign dump-as = user_dbname.
     end.          
  ASSIGN
    user_env[2] = prefix + dump-as + ".fd"
    io-title    = "Make Bulk Load Description File for "
                + (IF is-all THEN "All Tables"
                  ELSE IF is-some THEN "Some Tables"
                  ELSE "Table" + ' "' + user_env[1] + '"').
END. /* IF class = "b" */

IF msg-num > 0 THEN DO:
  MESSAGE (
    IF      msg-num = 1 THEN
      "Cannot dump User information from a non-{&PRO_DISPLAY_NAME} database."
    ELSE IF msg-num = 2 THEN
      "Cannot dump View information from a non-{&PRO_DISPLAY_NAME} database."
    ELSE IF msg-num = 3 THEN
      "You do not have permission to use this option."
    ELSE IF msg-num = 4 THEN
      "You can only dump definitions in V5 format for {&PRO_DISPLAY_NAME} databases."
    ELSE /*IF msg-num = 5 THEN*/
      "You can only create bulkload description files for {&PRO_DISPLAY_NAME} databases.")
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END. /* msgnum > 0 */

/* Adjust the graphical rectangle and the ok and cancel buttons */
IF class = "f" THEN DO:
   IF io-file THEN DO:
       if isAnyMultiTenant then 
       do:
         {adecomm/okrun.i  
            &FRAME  = "FRAME write-dump-file-mt" 
            &BOX    = "rect_Btns"
            &OK     = "btn_OK" 
            {&CAN_BTN}
            {&HLP_BTN}
          } 
       end.
       else 
       do:
          {adecomm/okrun.i  
            &FRAME  = "FRAME write-dump-file" 
            &BOX    = "rect_Btns"
            &OK     = "btn_OK" 
            {&CAN_BTN}
            {&HLP_BTN}
          } 
     end.
   END.
   ELSE IF isAnyMultiTenant then
   DO:
     {adecomm/okrun.i  
        &FRAME  = "FRAME write-dump-dir-mt" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
     }
   END.
   ELSE DO:
     {adecomm/okrun.i  
        &FRAME  = "FRAME write-dump-dir" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
   }
   END.
END. /* class = "f" */
ELSE IF class = "y" THEN DO:
  {adecomm/okrun.i  
     &FRAME  = "FRAME write-audit-data" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
  }
  ASSIGN io-title    = "Dump Audit Data"
         inclob      = FALSE.
END.

ELSE IF class = "i" THEN DO:
  {adecomm/okrun.i  
     &FRAME  = "FRAME write-dump-file-nobl" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
  }
  ASSIGN io-title    = "Dump Database Identification Properties"
         user_env[2] = "_db-detail.d".
END.
ELSE IF CAN-DO("o",class) THEN DO:
  {adecomm/okrun.i
   &FRAME  = "FRAME write-output-file-nocp"
   &BOX    = "rect_Btns"
   &OK     = "btn_OK"
   {&CAN_BTN}
   {&HLP_BTN}
  }
END.
ELSE IF CAN-DO("m,t",class) THEN DO:
  {adecomm/okrun.i
   &FRAME  = "FRAME write-dump-dir-cdpg"
   &BOX    = "rect_Btns"
   &OK     = "btn_OK"
   {&CAN_BTN}
   {&HLP_BTN}
  }
END.
ELSE IF class = "h" THEN DO:
  {adecomm/okrun.i
   &FRAME  = "FRAME write-dump-dir-nobl"
   &BOX    = "rect_Btns"
   &OK     = "btn_OK"
   {&CAN_BTN}
   {&HLP_BTN}
  }
END.
else 
if class = "5"  /* version 5 .df */
or class = "k"  /* sequence def's */
or class = "s"  /* sequence-values */ THEN 
DO:
    /* moved with update since there are addtionl logic to decide Mt or not
    (ALL of these should really be moved where they are used) */
END.
ELSE DO:
  IF class <> "b" THEN DO:
    {adecomm/okrun.i  
       &FRAME  = "FRAME write-output-file" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
       {&HLP_BTN}
    }
  END.
  ELSE DO:
    {adecomm/okrun.i  
     &FRAME  = "FRAME write-boutput-file" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
    }
  END.
END.

 
PAUSE 0.
user_env[3] = "".

/* If name contains the .db, remove it */
IF INDEX(user_env[2],".db") > 0 THEN
        SUBSTRING(user_env[2],INDEX(user_env[2],".db"),3,"RAW") = "".

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  if class = "k" and isAnyMultiTenant then 
  do WITH FRAME write-dump-seq-mt:
      {adecomm/okrun.i  
        &FRAME  = "FRAME write-dump-seq-mt" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
      }
      assign 
          UseDefaultDirs = true
          user_env[32]  = get-effective-tenant-name("dictdb")
          user_env[33]  =  "Tenant"
                           
          gFileName = user_env[2].
              
      refreshSeqDefaults().  
      /*
      if isAllMultiTenant then
      do:
          user_env[33]:disable("Tenant") in frame write-dump-seq-mt .
          user_env[33]:disable("All").
      end.      
      */
      display 
          user_env[33]
          user_env[32]
          UseDefaultDirs
          user_env[2]
          user_env[5]. 
      
      ENABLE user_env[33]
             user_env[32]
             btn_Tenant
             UseDefaultDirs
             RootDirectory
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
             btn_DirRoot 
           &ENDIF 
             user_env[2] 
             btn_File      
             user_env[5]
             btn_OK 
             btn_Cancel
             {&HLP_BTN_NAME}.
          
      refreshSeqMTState().
      wait-for "go" of frame write-dump-seq-mt.
      assign 
          frame write-dump-seq-mt user_env[32]
          frame write-dump-seq-mt user_env[33]
          frame write-dump-seq-mt user_env[2]
          frame write-dump-seq-mt user_env[5].
       
       if user_env[33] = "ALL" then
           assign
               user_env[32] = "" 
               user_env[33] = "".
  
  end.
  else 
  if class = "5"  /* version 5 .df */
  or class = "k"  /* sequence def's */
  or class = "s"   /* sequence-values */ THEN
  do: 
     {adecomm/okrun.i  
       &FRAME  = "FRAME write-def-file" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
       {&HLP_BTN}
     }  
      
     UPDATE user_env[2] 
          btn_File      
          user_env[5]
          btn_OK 
          btn_Cancel
          {&HLP_BTN_NAME}
          WITH FRAME write-def-file.
  end.
  ELSE IF class = "b" THEN
      UPDATE UNLESS-HIDDEN user_env[2] 
           btn_File
       inclob
       user_env[30]
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
        btn_dir
       &ENDIF
           user_env[5] 
           btn_OK 
           btn_Cancel
           {&HLP_BTN_NAME}
           WITH FRAME write-boutput-file.
  ELSE IF class = "o" THEN
      UPDATE UNLESS-HIDDEN user_env[2]
                           btn_File
                           btn_OK
                           btn_Cancel
                           {&HLP_BTN_NAME}
         WITH FRAME write-output-file-nocp.
  ELSE IF CAN-DO("t,m",class) THEN DO:
    IF class = "t" THEN DO:
      DISPLAY user_env[5] WITH FRAME write-dump-dir-cdpg.
      UPDATE UNLESS-HIDDEN user_env[2]
                           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
                             btn_Dir2
                           &ENDIF
                           btn_OK
                           btn_Cancel
                           {&HLP_BTN_NAME}
         WITH FRAME write-dump-dir-cdpg.
    END.
    ELSE
      UPDATE UNLESS-HIDDEN user_env[2]
                           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
                             btn_Dir2
                           &ENDIF
                           user_env[5]
                           btn_OK
                           btn_Cancel
                           {&HLP_BTN_NAME}
         WITH FRAME write-dump-dir-cdpg.
  END.
  ELSE IF class = "h" THEN
    UPDATE user_env[2] 
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
              btn_dir2
           &ENDIF
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
             io-mapl 
           &ELSE
             io-mapc 
           &ENDIF
           user_env[5] btn_OK btn_Cancel {&HLP_BTN_NAME}
       WITH FRAME write-dump-dir-nobl.
  ELSE IF class = "i" THEN
    UPDATE user_env[2] 
           btn_File   
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
             io-mapl
           &ELSE
             io-mapc 
           &ENDIF
           user_env[5] 
           btn_OK 
           btn_Cancel
           {&HLP_BTN_NAME}
           WITH FRAME write-dump-file-nobl.
  ELSE IF class = "y" THEN DO:
    DISPLAY inclob user_env[30] user_env[5]
        WITH FRAME write-audit-data.
    UPDATE user_env[2] 
             &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
                btn_dir2
             &ENDIF
             btn_OK btn_Cancel {&HLP_BTN_NAME}
           WITH FRAME write-audit-data.
  END.
  ELSE IF class <> "f" THEN DO:
    IF class = "x" THEN DO:
      DISPLAY user_env[5] WITH FRAME write-output-file.
      UPDATE UNLESS-HIDDEN user_env[2] 
           btn_File    
           dmp-rpos
           btn_OK 
           btn_Cancel
           {&HLP_BTN_NAME}
           WITH FRAME write-output-file.
    END.
    ELSE
      UPDATE UNLESS-HIDDEN user_env[2] 
           btn_File    
           user_env[5] 
           dmp-rpos
           btn_OK 
           btn_Cancel
           {&HLP_BTN_NAME}
           WITH FRAME write-output-file.
  END.
  ELSE DO:
    IF io-file THEN
    do:
    
       if isAnyMultiTenant then
       do WITH FRAME write-dump-file-mt:
          assign 
              UseDefaultDirs = true
              user_env[32]  = get-effective-tenant-name("dictdb")
              gFileName = user_env[2].
              
          refreshFileDefaults(). 
         
          display 
              user_env[32]
              UseDefaultDirs
              user_env[2]
              user_env[30] 
              inclob
              user_env[5].
            
          &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
          display  io-mapl . 
          /* establish tab-order */
          enable   
              user_env[32] 
              btn_Tenant 
              UseDefaultDirs 
              RootDirectory
              btn_dirroot
              user_env[2]
              btn_file
              inclob  
              user_env[30]
              btn_dir
              io-mapl
              user_env[5]
              btn_OK 
              btn_Cancel
              {&HLP_BTN_NAME}
              .
          &else
          
          display  io-mapc. 
          enable   
              user_env[32] 
              btn_Tenant 
              UseDefaultDirs 
              RootDirectory
              user_env[2]
              btn_file
              inclob  
              user_env[30]
              io-mapc
              user_env[5]
              btn_OK 
              btn_Cancel
              {&HLP_BTN_NAME}
              .
              
          &endif
          
          refreshFileMTState().
          
          wait-FOR "GO" OF FRAME write-dump-file-mt. 
          
          assign
              frame write-dump-file-mt user_env[32]
              frame write-dump-file-mt RootDirectory 
              frame write-dump-file-mt UseDefaultDirs
              frame write-dump-file-mt user_env[2]
              frame write-dump-file-mt inclob
              frame write-dump-file-mt user_env[30] 
              frame write-dump-file-mt user_env[5]
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
              frame write-dump-file-mt io-mapl
          &ELSE
              frame write-dump-file-mt io-mapc
          &ENDIF
           .  
           if UseDefaultDirs then
           do:
             /* don't pass file name 
                it makes it difficult to create lob dir 
                the file name will be added by _dmpdefs if 
                use default */  
               user_env[2]  = RootDirectory.
               user_env[33] = gUseDefaultOut.
           end.
        end.
        else 
           UPDATE user_env[2]  
              btn_File   
              inclob
              user_env[30]
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
              btn_dir
              io-mapl
           &ELSE
              io-mapc 
           &ENDIF
              user_env[5] 
              btn_OK 
              btn_Cancel
           {&HLP_BTN_NAME}
           WITH FRAME write-dump-file.
    end.
    ELSE DO:
        if isANyMultiTenant then
        do WITH FRAME write-dump-dir-mt:
           
           assign 
              UseDefaultDirs = true
              user_env[32] = get-effective-tenant-name("dictdb").
            
            refreshDirDefaults().  
            
            display 
                user_env[32] 
                UseDefaultDirs
                user_env[2] 
                user_env[33] 
                inclob
                user_env[30]
                user_env[34]
                user_env[5] 
                .
            &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
            if isAllMultiTenant then 
               labeldir = labelDirRoot.
            else
               labeldir = labelDirShared. 
                 
            disp io-mapl labeldir.
           
            enable user_env[32] 
                   btn_Tenant 
                   UseDefaultDirs
                   user_env[2] 
                   btn_dir2
                   user_env[33] 
                   btn_dirMT
                   inclob
                   user_env[30]
                   btn_dir
                   user_env[34]
                   btn_dirMTLOB
                   io-mapl 
                   user_env[5] 
                   btn_OK 
                   btn_Cancel 
                   {&HLP_BTN_NAME}.
            
            &ELSE
            if isAllMultiTenant then 
               user_env[2]:label in frame write-dump-dir-mt = "Root Directory".
            else
               user_env[2]:label in frame write-dump-dir-mt = "Shared Directory". 
                    
             display  io-mapc .
             enable user_env[32] 
                    btn_Tenant 
                    UseDefaultDirs
                    user_env[2] 
                    user_env[33] 
                    inclob
                    user_env[30]
                    user_env[34]
                    io-mapc 
                    user_env[5] 
                    btn_OK 
                    btn_Cancel 
                   {&HLP_BTN_NAME}.
            
            &ENDIF
            
            refreshDirMTState().
            wait-for "go" of frame  write-dump-dir-mt.
            assign frame write-dump-dir-mt user_env[2] 
                   frame write-dump-dir-mt user_env[32] 
                   frame write-dump-dir-mt user_env[33] when not UseDefaultDirs
                   frame write-dump-dir-mt inclob
                   frame write-dump-dir-mt user_env[30] 
                   frame write-dump-dir-mt user_env[34]
               &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN      
               
                   frame write-dump-dir-mt io-mapc
                   frame write-dump-dir-mt io-mapl

               &ELSE
               
                   frame write-dump-dir-mt io-mapc
               
               &ENDIF    
                   frame write-dump-dir-mt user_env[5]. 
             if UseDefaultDirs then
                 user_env[33] = gUseDefaultOut.
        end. /* do WITH FRAME write-dump-dir-mt*/
        else  /* not isMultiTenant */
            UPDATE 
                user_env[2] 
                     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
                btn_dir2
                     &ENDIF
                inclob
                user_env[30]
                     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
                btn_dir
                io-mapl 
                     &ELSE
                   io-mapc 
                 &ENDIF
                user_env[5] 
                btn_OK 
                btn_Cancel 
                {&HLP_BTN_NAME}
           WITH FRAME write-dump-dir.
        
    END.
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
      CASE io-mapl:
          WHEN 1 THEN user_env[3] = "NO-MAP".
          WHEN 2 THEN user_env[3] = io-mapc.
      END CASE.
    &ELSE
      IF io-mapc <> "" THEN user_env[3] = io-mapc.
    &ENDIF
  END.
  IF NOT io-file THEN
  do:   
    RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).
    if isANyMultiTenant then
    do:
       if user_env[33] <> gUseDefaultOut then
           RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[33]).
    end.
  end.    
  { prodict/dictnext.i trash }
  canned = FALSE.
END.

HIDE MESSAGE NO-PAUSE.

HIDE FRAME write-output-file NO-PAUSE.
HIDE FRAME write-dump-file NO-PAUSE.
HIDE FRAME write-dump-dir NO-PAUSE.
HIDE FRAME write-output-file-nocp NO-PAUSE.

IF canned THEN
  user_path = "".
RETURN.

/**** procedures  *************************************************************/
 
procedure walkFrame:
    define input parameter hWidget as handle no-undo.
    define variable cc as character no-undo.
   
    hwidget = hWidget:first-child.
    hwidget = hwidget:first-child.
 
    /* move everything up to fill the empty space from user_env[2] and [30] */ 
    do while valid-handle(hwidget):    
        cc = cc + (if hWidget:name = ? then hwidget:type else hwidget:name) + chr(10).  
        hWidget = hWidget:next-sibling.
 
    end.    
    message cc
    view-as alert-box.
 end.    