/*********************************************************************
* Copyright (C) 2006-2007,2009,2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _usrtgen.p */

/* This program generates CREATE TABLE statements from _File records
stored in the database.  These CREATE TABLE statements can then be
run on another database to define those tables. */

/*
  user_env[2] = output file
  user_env[3] = '' or separate output file for 'create index'
  user_env[4] = allow PROGRESS format statements, also xlat "-" -> "_"
  user_env[5] = statement terminator
  user_env[6] = unique index names
  user_env[7] = support DEFAULT <init value>
  user_env[8] = xlat "-" -> "_"
  user_env[9] = userid
  user_env[11..18] = strings of how to convert PROGRESS datatypes to SQL:
                character -> char, character, vchar, varchar, long char
                date      -> date, datetime
                logical   -> logical
                integer   -> integer, smallint, number
                decimal   -> decimal, number, real, float, double precision
                decimal*  -> decimal, integer, number
                recid     -> recid, rowid
                char**    -> long, character, long varchar
              (decimal* is decimal with _Decimals=0)
              (char** is character longer than 240)
 user_env[19] = character to use for unique name creation
 user_env[21] = Add shadow column for case-insensitive key fields
 user_env[22] = dbtype ("ORACLE"...)
 user_env[23] = Min width for character fields.
 user_env[24] = Min width for numeric fields.
 user_env[25] = create sequences (oracle only).
 user_env[33] = to use _Width of field or calculate.
 
History:
    nagaraju    11/12/09    Remove numbers for radio-set options in MSSDS
    nagaraju    10/06/09    Support for computed column to PROGRESS_RECID in MSSDS
    fernando    04/03/09    Support for MSS's sequence generator and 2008 data types
    fernando    08/10/07    Removed UI restriction for Unicode support 
    fernando    07/19/06    Unicode support - restrict UI
    fernando    04/18/06    Unicode support for DataServers
    D. McMann   03/06/03    Removed shadow columns for Oracle.
    D. McMann   11/15/02    Split compatible objects into seperate selections
    D. McMann   09/18/02    Change SQL Width to Width
    D. McMann   08/18/00    Incresed size of max length for identifiers 200008007028
    D. McMann   08/18/00    Added support for MS SQL Server 20000727013
    D. McMann   04/13/00    Added support for long path names
    D, McMann   00/02/01    Added sqlwidth toggle box.
    Mario B.    98/12/04    Gray l_cmptbl when Progress is SQL flavor
    D. McMann   98/07/14    Added _Owner to _File finds
    hutegger    95/05/03    turned ue8 on for PROGRESS ("-" -> "_")
    hutegger    95/02/07    changed UI and created list of switches for
                            different SQL-flavors and extented the
                            switches set for wrktgen dpending on the
                            SQL-flavor
    hutegger    94/05/06    added parameters user_env[20 ... 25] for
                            _wrktgen.p (based on info from Marceau)
                            
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE allusers  AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE answer    AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE canned    AS LOGICAL   INITIAL TRUE  NO-UNDO.

DEFINE VARIABLE fn        AS CHARACTER               NO-UNDO.
DEFINE VARIABLE fot       AS CHARACTER               NO-UNDO.
DEFINE VARIABLE foi       AS CHARACTER               NO-UNDO.
DEFINE VARIABLE ft        AS CHARACTER INITIAL "pro" NO-UNDO.
DEFINE VARIABLE l_cmptbl  AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE shadowcol AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE crtdef    AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE l_dbtyp   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_i       AS INTEGER                 NO-UNDO.
DEFINE VARIABLE l_ue-4    AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-5    AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-6    AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-7    AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-8    AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-11   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-12   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-13   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-14   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-15   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-16   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-17   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-18   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-19   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-20   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-21   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-22   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-23   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-24   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-25   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-28   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l_ue-29   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE usrnm     AS CHARACTER               NO-UNDO.
DEFINE VARIABLE uidtag    AS CHARACTER   	     NO-UNDO.
DEFINE VARIABLE alltables AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE optlab    AS CHARACTER INITIAL "Output Option:"
			             FORMAT "X(15)"  NO-UNDO.
DEFINE VARIABLE cFormat   AS CHARACTER INITIAL "For field widths use:"
                                           FORMAT "x(21)"  NO-UNDO.

DEFINE VARIABLE usrlab    AS CHARACTER INITIAL "Which Users:"
			             FORMAT "X(15)"  NO-UNDO.
DEFINE VARIABLE iFmtOption AS INTEGER  INITIAL 2     NO-UNDO.
DEFINE VARIABLE lFormat    AS LOGICAL  INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE unicodeTypes AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE tmp_str      AS CHARACTER               NO-UNDO.
DEFINE VARIABLE lUniExpand   AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE mapMSSDatetime AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE newseq       AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE cRecid        AS CHARACTER INITIAL "For Create RECID use:"
                                           FORMAT "x(22)" NO-UNDO.
DEFINE VARIABLE iRecidOption AS INTEGER  INITIAL 1     NO-UNDO.

{prodict/misc/filesbtn.i &NAME="btn_File_t"}
{prodict/misc/filesbtn.i &NAME="btn_File_i" &NOACC=yes}

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 7 NO-UNDO INITIAL [
  /* 1*/ "Could not find a user in the connected database with this userid.",
  /* 2*/ "A file named",
  /* 3*/ "already exists.",
  /* 4*/ "Overwrite it?",
  /* 5*/ "All Tables",
  /* 6*/ "You do not have permission to use this option.",
  /* 7*/ "(Enter a Userid or ~"ALL~")"
].


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
&IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN  
   &GLOBAL-DEFINE LINEUP 45
   &GLOBAL-DEFINE FILLCH 48
&ELSE
   &GLOBAL-DEFINE LINEUP 48
   &GLOBAL-DEFINE FILLCH 50
&ENDIF

FORM 
  SKIP({&TFM_WID})
  "Output File for CREATE TABLE:"  VIEW-AS TEXT AT 2
  SKIP({&VM_WID})
  fot {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
      VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 AT 2
  btn_File_t 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID}) 
  &ELSE SKIP({&VM_WIDG}) &ENDIF

  "Output File for CREATE INDEX:" VIEW-AS TEXT AT 2
  SKIP({&VM_WID})

  foi {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
      VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 AT 2
  btn_File_i 
  SKIP({&VM_WIDG})
    
  "SQL-Flavor:" VIEW-AS TEXT AT 2
  ft VIEW-AS RADIO-SET horizontal
             RADIO-BUTTONS "{&PRO_DISPLAY_NAME}",      "pro",
                           "ORACLE",        "ora",
                           "MS SQL Server", "mss"
  SKIP({&VM_WIDG})
      
  l_cmptbl AT 2 label  "Create RECID Field "
          VIEW-AS toggle-box
          HELP "Create PROGRESS_RECID Column/Index...?"
  shadowcol AT 34 VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" 
          HELP "Create shadow columns for case insensitivity...?"
  SKIP({&VM_WID})
  crtdef AT 2 LABEL "Include Defaults" VIEW-AS toggle-box
              HELP "Include initial value as field default."
   unicodeTypes AT 34 VIEW-AS TOGGLE-BOX LABEL "Use Unicode Types" 
            HELP "Create character columns as Unicode data types?"
    SKIP({&VM_WID})
    lUniExpand AT 2 VIEW-AS TOGGLE-BOX LABEL "Expand width (utf-8)"
           HELP "Double field length (for utf-8 compatibility)"
    newSeq AT 34 VIEW-AS TOGGLE-BOX LABEL "Use Revised Sequence Generator" 
             HELP "Create sequences using new generation logic?"
    SKIP({&VM_WID})
    mapMSSDatetime AT 2 VIEW-AS TOGGLE-BOX LABEL "Map to MSS 'Datetime' Type"
           HELP "Default mapping for OpenEdge date and datetime to the MSS datetime type?"
    SKIP({&VM_WID})
    cFormat VIEW-AS TEXT NO-LABEL AT 2
    iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                               "ABL Format", 2
                                 HORIZONTAL NO-LABEL
               HELP "Make choice to determine field width in output."
    lFormat VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30"
            HELP "Choose to output field width of 30 for x(8) fields."
            AT 51
    SKIP({&VM_WID}) 
    cRecid VIEW-AS TEXT NO-LABEL AT 2
    iRecidOption VIEW-AS RADIO-SET RADIO-BUTTONS "Trigger", 1,
                                               "Computed column", 2
                                 HORIZONTAL NO-LABEL
               HELP "Make choice to determine Create RECID option."
  {prodict/user/userbtns.i}
  WITH FRAME createtable
  NO-LABELS CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Dump CREATE TABLE for ~"" + fn + "~" ".

FORM 
  SKIP({&TFM_WID})
  "Output File for CREATE TABLE:" VIEW-AS TEXT AT 2 
  SKIP({&VM_WID})

  fot {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
      VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 AT 2
  btn_File_t 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID})
  &ELSE SKIP({&VM_WIDG}) &ENDIF
    
  "Output File for CREATE INDEX:" VIEW-AS TEXT AT 2 
  SKIP({&VM_WID})

  foi {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
      VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 AT 2
  btn_File_i 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID})
  &ELSE SKIP({&VM_WIDG}) &ENDIF
       
  usrlab VIEW-AS TEXT AT 2
  SKIP({&VM_WIDG})

  allusers AT 2 VIEW-AS RADIO-SET HORIZONTAL 
	RADIO-BUTTONS "All Users",yes,"Single User",no SPACE(0)
  usrnm {&STDPH_FILL} 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID})
  &ELSE SKIP({&VM_WIDG}) &ENDIF 
  
  "SQL-Flavor:" VIEW-AS TEXT AT 2 
  ft VIEW-AS RADIO-SET HORIZONTAL
             RADIO-BUTTONS "{&PRO_DISPLAY_NAME}",      "pro",
                           "ORACLE",        "ora",
                           "MS SQL Server", "mss"
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
    &ELSE SKIP({&VM_WID}) &ENDIF
  l_cmptbl AT 2 label "Create RECID Field "
          VIEW-AS toggle-box
          HELP "Create PROGRESS_RECID Column/Index?"
  shadowcol AT 34 VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" 
          HELP "Create shadow columns for case insensitivity...?"
  SKIP({&VM_WID})
    crtdef AT 2 LABEL "Include Defaults" VIEW-AS toggle-box
            HELP "Include initial value as field default."
    unicodeTypes AT 34 VIEW-AS TOGGLE-BOX LABEL "Use Unicode Types" 
                  HELP "Create character columns as Unicode data types?"
    SKIP({&VM_WID})
    lUniExpand AT 2 VIEW-AS TOGGLE-BOX LABEL "Expand width (utf-8)"
           HELP "Double field length (for utf-8 compatibility)"
    newSeq AT 34 VIEW-AS TOGGLE-BOX LABEL "Use Revised Sequence Generator" 
             HELP "Create sequences using new generation logic?"
    SKIP({&VM_WID})    
    mapMSSDatetime AT 2 VIEW-AS TOGGLE-BOX LABEL "Map to MSS 'Datetime' Type"
           HELP "Default mapping for OpenEdge date and datetime to the MSS datetime type?"
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
    &ELSE SKIP({&VM_WID}) &ENDIF    
    cFormat VIEW-AS TEXT NO-LABEL AT 2
    iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                               "ABL Format", 2
                                 HORIZONTAL NO-LABEL
               HELP "Make choice to determine field width in output."
    lFormat VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30"
            HELP "Choose to output field width of 30 for x(8) fields."
            AT 51
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
    &ELSE SKIP({&VM_WID}) &ENDIF
    cRecid VIEW-AS TEXT NO-LABEL AT 2
    iRecidOption VIEW-AS RADIO-SET RADIO-BUTTONS "Trigger", 1,
                                               "Computed column", 2
                                 HORIZONTAL NO-LABEL
               HELP "Make choice to determine Create RECID option."
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
    &ELSE SKIP({&VM_WID}) &ENDIF
  {prodict/user/userbtns.i}

  WITH FRAME createalltables
  NO-LABELS CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Dump CREATE TABLE for All Tables".

&ELSE
   &GLOBAL-DEFINE LINEUP 30
   &GLOBAL-DEFINE LINEUP2 37
   &GLOBAL-DEFINE FILLCH 34

FORM 
  SKIP({&TFM_WID})
  fot {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
      VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 
        LABEL "Output File for CREATE TABLE" COLON {&LINEUP}
  btn_File_t
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID})
  &ELSE SKIP({&VM_WIDG}) &ENDIF
    
  foi {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
      VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 
        LABEL "Output File for CREATE INDEX" COLON {&LINEUP}
  btn_File_i
  SKIP({&VM_WIDG})

  "SQL-Flavor:" VIEW-AS TEXT AT 2 
  ft NO-LABEL VIEW-AS RADIO-SET HORIZONTAL 
                      RADIO-BUTTONS "{&PRO_DISPLAY_NAME}",      "pro",
                                    "ORACLE",        "ora",
                                   "MS SQL Server", "mss"
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
  &ELSE SKIP({&VM_WID}) &ENDIF
  l_cmptbl AT 2 label "Create RECID Field "
          VIEW-AS toggle-box
          HELP "Create PROGRESS_RECID Column/Index?"
  shadowcol AT 34 VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" 
          HELP "Create shadow columns for case insensitivity...?"
  SKIP({&VM_WID})
    crtdef AT 2 LABEL "Include Defaults" VIEW-AS toggle-box
            HELP "Include initial value as field default."
    unicodeTypes AT 34 VIEW-AS TOGGLE-BOX LABEL "Use Unicode Types" 
                 HELP "Create character columns as Unicode data types?"
    SKIP({&VM_WID})
    lUniExpand AT 2 VIEW-AS TOGGLE-BOX LABEL "Expand width (utf-8)"
           HELP "Double field length (for utf-8 compatibility)"
    newSeq AT 34 VIEW-AS TOGGLE-BOX LABEL "Use Revised Sequence Generator" 
             HELP "Create sequences using new generation logic?"
    SKIP({&VM_WID})  
    mapMSSDatetime AT 2 VIEW-AS TOGGLE-BOX LABEL "Map to MSS 'Datetime' Type"
           HELP "Default mapping for OpenEdge date and datetime to the MSS datetime type?"
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
    &ELSE SKIP({&VM_WID}) &ENDIF        
    cFormat VIEW-AS TEXT NO-LABEL AT 2
    iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                               "ABL Format", 2
                                 HORIZONTAL NO-LABEL 
               HELP "Make choice to determine field width in output."
    lFormat VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30"
            HELP "Choose to output field width of 30 for x(8) fields."
            AT 51
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
    &ELSE SKIP({&VM_WID}) &ENDIF
    cRecid VIEW-AS TEXT NO-LABEL AT 2
    iRecidOption VIEW-AS RADIO-SET RADIO-BUTTONS "Trigger", 1,
                                               "Computed column", 2
                                 HORIZONTAL NO-LABEL
               HELP "Make choice to determine Create RECID option."

    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
    &ELSE SKIP({&VM_WID}) &ENDIF
  "This program generates a SQL DDL program containing CREATE TABLE statements" 
               VIEW-AS TEXT   AT    2     SKIP
  "equivalent to those originally used to define the table.  It does NOT" 
               VIEW-AS TEXT   AT    2     SKIP
  "generate any GRANT or REVOKE statements to set permissions on the tables." 
               VIEW-AS TEXT   AT    2     SKIP
  "It also generates CREATE INDEX statements in a separate file (these will"
               VIEW-AS TEXT   AT    2    SKIP
  "be omitted if no file is specified for them above)."
               VIEW-AS TEXT   AT 2
  {prodict/user/userbtns.i}

  WITH FRAME createtable
  SIDE-LABELS ATTR-SPACE ROW 1 CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Dump CREATE TABLE for ~"" + fn + "~" ".

FORM 
  SKIP({&TFM_WID})
  fot {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
      VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 
        LABEL "Output File for CREATE TABLE" COLON {&LINEUP}
  btn_File_t 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID})
  &ELSE SKIP({&VM_WIDG}) &ENDIF
    
  foi {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
      VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 
        LABEL "Output File for CREATE INDEX" COLON {&LINEUP}
  btn_File_i 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID})
  &ELSE SKIP({&VM_WIDG}) &ENDIF

  usrnm  LABEL "Which Users"                COLON {&LINEUP}
  uidtag FORMAT "x(25)" NO-LABEL              AT 53    
  SKIP({&VM_WIDG})
  
  "SQL-Flavor:" VIEW-AS TEXT AT 2 
  ft NO-LABEL VIEW-AS RADIO-SET HORIZONTAL 
                      RADIO-BUTTONS "{&PRO_DISPLAY_NAME}",      "pro",
                                    "ORACLE",        "ora",
                                    "MS SQL Server", "mss"
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
  &ELSE SKIP({&VM_WID}) &ENDIF
  l_cmptbl AT 2 label "Create RECID Field "
          VIEW-AS toggle-box
          HELP "Create PROGRESS_RECID Column/Index?"
  shadowcol AT 34 VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" 
          HELP "Create shadow columns for case insensitivity...?"
  SKIP({&VM_WID})
  crtdef AT 2 LABEL "Include Defaults" VIEW-AS toggle-box
            HELP "Include initial value as field default."
  unicodeTypes AT 34 VIEW-AS TOGGLE-BOX LABEL "Use Unicode Types" 
               HELP "Create character columns as Unicode data types?"
    SKIP({&VM_WID})
    lUniExpand AT 2 VIEW-AS TOGGLE-BOX LABEL "Expand width (utf-8)"
           HELP "Double field length (for utf-8 compatibility)"
    newSeq AT 34 VIEW-AS TOGGLE-BOX LABEL "Use Revised Sequence Generator" 
             HELP "Create sequences using new generation logic?"
  SKIP({&VM_WID})
  mapMSSDatetime AT 2 VIEW-AS TOGGLE-BOX LABEL "Map to MSS 'Datetime' Type"
         HELP "Default mapping for OpenEdge date and datetime to the MSS datetime type?"
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
  &ELSE SKIP({&VM_WID}) &ENDIF      
  cFormat VIEW-AS TEXT NO-LABEL AT 2
  iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                             "ABL Format", 2
                               HORIZONTAL NO-LABEL 
             HELP "Make choice to determine field width in output."
  lFormat VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30"
          HELP "Choose to output field width of 30 for x(8) fields."
          AT 51
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
  &ELSE SKIP({&VM_WID}) &ENDIF
    cRecid VIEW-AS TEXT NO-LABEL AT 2
    iRecidOption VIEW-AS RADIO-SET RADIO-BUTTONS "Trigger", 1,
                                               "Computed column", 2
                                 HORIZONTAL NO-LABEL
               HELP "Make choice to determine Create RECID option."

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP({&VM_WIDG})
  &ELSE SKIP({&VM_WID}) &ENDIF
  "This program generates a SQL DDL program containing CREATE TABLE statements" 
             VIEW-AS TEXT   AT    2     SKIP
  "equivalent to those originally used to define the table.  It does NOT" 
             VIEW-AS TEXT   AT    2     SKIP
  "generate any GRANT or REVOKE statements to set permissions on the tables." 
             VIEW-AS TEXT   AT    2     SKIP
  "It also generates CREATE INDEX statements in a separate file (these will"
             VIEW-AS TEXT   AT    2    SKIP
  "be omitted if no file is specified for them above)."
             VIEW-AS TEXT   AT 2
  {prodict/user/userbtns.i}

  WITH FRAME createalltables
  SIDE-LABELS ATTR-SPACE ROW 1 CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Dump CREATE TABLE for All Tables".
&ENDIF

/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame createtable
   or CHOOSE OF btn_Help in frame createtable
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Dump_Create_Table_Dlg_Box},
      	       	     	     INPUT ?).
on HELP of frame createalltables
   or CHOOSE OF btn_Help in frame createalltables
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Dump_Create_Table_All_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


ON GO OF FRAME createtable
DO:
  DEFINE VAR f1  AS CHAR NO-UNDO.
  DEFINE VAR f2  AS CHAR NO-UNDO.
  DEFINE VAR uid AS CHAR NO-UNDO.

  f1 = fot:SCREEN-VALUE IN FRAME createtable.
  f2 = foi:SCREEN-VALUE IN FRAME createtable.

  IF SEARCH(f1) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[2] f1 new_lang[3] SKIP new_lang[4]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO fot IN FRAME createtable.
      RETURN NO-APPLY.
    END.
  END.
  IF SEARCH(f2) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[2] f2 new_lang[3] SKIP new_lang[4]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO foi IN FRAME createtable.
      RETURN NO-APPLY.
    END.
  END.
END.
ON GO OF FRAME createalltables
DO:
  DEFINE VAR f1  AS CHAR NO-UNDO.
  DEFINE VAR f2  AS CHAR NO-UNDO.
  DEFINE VAR uid AS CHAR NO-UNDO.

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
    IF allusers:SCREEN-VALUE = "yes" THEN
	  uid = "ALL".
    ELSE DO:
	  uid = usrnm:SCREEN-VALUE.
	  usrnm = uid.
    END.
  &ELSE
    uid  = usrnm:SCREEN-VALUE.
  &ENDIF

  IF uid <> "ALL" AND NOT CAN-FIND(_User WHERE _User._Userid = uid) THEN DO:
    MESSAGE new_lang[1] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO usrnm IN FRAME createalltables.
    RETURN NO-APPLY.
  END.


  f1 = fot:SCREEN-VALUE IN FRAME createalltables.
  f2 = foi:SCREEN-VALUE IN FRAME createalltables.

  IF SEARCH(f1) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[2] f1 new_lang[3] SKIP new_lang[4]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO fot IN FRAME createalltables.
      RETURN NO-APPLY.
    END.
  END.
  IF SEARCH(f2) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[2] f2 new_lang[3] SKIP new_lang[4]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO foi IN FRAME createalltables.
      RETURN NO-APPLY.
    END.
  END.
END.
ON CHOOSE OF btn_File_t in frame createtable DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT fot:handle in frame createtable /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.

ON LEAVE OF fot in frame createtable
   fot:screen-value in frame createtable = 
        TRIM(fot:screen-value in frame createtable).

ON CHOOSE OF btn_File_i in frame createtable DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT foi:handle in frame createtable /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.

ON LEAVE OF foi in frame createtable
   foi:screen-value in frame createtable = 
        TRIM(foi:screen-value in frame createtable).

ON VALUE-CHANGED OF iFmtOption IN FRAME createalltables DO:
  IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN lFormat:CHECKED IN FRAME createalltables   = FALSE
           lFormat:SENSITIVE IN FRAME createalltables = FALSE.
  ELSE
    ASSIGN lFormat:CHECKED  IN FRAME createalltables  = TRUE
           lFormat:SENSITIVE IN FRAME createalltables = TRUE.
END.

ON VALUE-CHANGED OF iFmtOption IN FRAME createtable DO:
  IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN lFormat:CHECKED IN FRAME createtable   = FALSE
           lFormat:SENSITIVE IN FRAME createtable = FALSE.
  ELSE
    ASSIGN lFormat:CHECKED IN FRAME createtable   = TRUE
           lFormat:SENSITIVE IN FRAME createtable = TRUE.
END.

ON VALUE-CHANGED OF ft IN FRAME createtable DO:
   CASE SELF:SCREEN-VALUE:
     WHEN "pro" THEN DO:
       ASSIGN iFmtOption:SCREEN-VALUE IN FRAME createtable = "2" 
              iRecidOption:SCREEN-VALUE IN FRAME createtable = "1" 
              l_cmptbl:SENSITIVE = FALSE
              l_cmptbl:SCREEN-VALUE = "no"
              shadowcol:SENSITIVE = FALSE
              shadowcol:SCREEN-VALUE = "no"
              crtdef:SENSITIVE = FALSE
              crtdef:SCREEN-VALUE = "no".
       
          ASSIGN unicodeTypes:SENSITIVE IN FRAME createtable = NO
                 unicodeTypes:SCREEN-VALUE = "no"
                 lUniExpand:SENSITIVE = NO
                 lUniExpand:SCREEN-VALUE = "no"
                 newSeq:SCREEN-VALUE = "no"
                 newSeq:SENSITIVE = NO
                 mapMSSDatetime:SCREEN-VALUE = "no"
                 mapMSSDatetime:SENSITIVE = NO
                 iRecidOption:SENSITIVE = NO.

       iFmtOption:DISABLE("Width") IN FRAME createtable.
       APPLY "VALUE-CHANGED" TO iFmtOption IN FRAME createtable.
     END.  
     WHEN "ora" THEN DO:       
       ASSIGN l_cmptbl:SENSITIVE = TRUE
              l_cmptbl:SCREEN-VALUE = "no"
              shadowcol:SENSITIVE = TRUE
              crtdef:SENSITIVE = TRUE.
       
           ASSIGN
              unicodeTypes:SENSITIVE IN FRAME createtable = YES
              unicodeTypes:SCREEN-VALUE = "no"
              lUniExpand:SENSITIVE = NO
              lUniExpand:SCREEN-VALUE = "no"
              newSeq:SCREEN-VALUE = "no"
              newSeq:SENSITIVE = NO
              mapMSSDatetime:SCREEN-VALUE = "no"
              mapMSSDatetime:SENSITIVE = NO
             iRecidOption:SENSITIVE = NO.

       iFmtOption:ENABLE("Width") IN FRAME createtable.
       APPLY "VALUE-CHANGED" TO iFmtOption IN FRAME createtable.
     END.
     OTHERWISE DO:
       ASSIGN l_cmptbl:SENSITIVE = TRUE
              l_cmptbl:SCREEN-VALUE = "no"
              shadowcol:SENSITIVE = TRUE
              crtdef:SENSITIVE = TRUE.
       
           ASSIGN
              unicodeTypes:SENSITIVE IN FRAME createtable = YES
              unicodeTypes:SCREEN-VALUE = "no"
              lUniExpand:SENSITIVE = NO
              lUniExpand:SCREEN-VALUE = "no"
              newSeq:SCREEN-VALUE = "no"
              newSeq:SENSITIVE = YES
              mapMSSDatetime:SCREEN-VALUE = "yes"
              mapMSSDatetime:SENSITIVE = YES
              iRecidOption:SENSITIVE = YES.

       iFmtOption:ENABLE("Width") IN FRAME createtable.
       APPLY "VALUE-CHANGED" TO iFmtOption IN FRAME createtable.
     END.
   END CASE.
END.

ON ENTRY OF FRAME createtable DO:
   /* Just assigning l_cmptbl:SENSITIVE = FALSE doesn't work because the *
    * widget is not realized until the UPDATE statements are executed.   *
    * Once that happens, this is the only way to force the assignment.   */
   APPLY "VALUE-CHANGED" TO ft IN FRAME createtable.
END.

ON WINDOW-CLOSE OF FRAME createtable
   APPLY "END-ERROR" TO FRAME createtable.

ON CHOOSE OF btn_File_t in frame createalltables DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT fot:handle in frame createalltables /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.

ON VALUE-CHANGED OF unicodeTypes IN FRAME createalltables DO:
    DEF VAR dummyl AS LOGICAL NO-UNDO.

    IF ft:SCREEN-VALUE EQ "ora" THEN
        RETURN.

    IF SELF:SCREEN-VALUE = "NO" THEN
       ASSIGN lUniExpand:SENSITIVE IN FRAME createalltables = NO
              lUniExpand:SCREEN-VALUE = "no".
    ELSE
    ASSIGN lUniExpand:SENSITIVE IN FRAME createalltables = YES
           lUniExpand:SCREEN-VALUE = "no"
           dummyl = lUniExpand:MOVE-AFTER-TAB-ITEM(unicodeTypes:HANDLE).
END.

ON VALUE-CHANGED OF unicodeTypes IN FRAME createtable DO:
    DEF VAR dummyl AS LOGICAL NO-UNDO.

    IF ft:SCREEN-VALUE EQ "ora" THEN
        RETURN.
            
    IF SELF:SCREEN-VALUE = "NO" THEN
       ASSIGN lUniExpand:SENSITIVE IN FRAME createtable = NO
              lUniExpand:SCREEN-VALUE = "no".
    ELSE
    ASSIGN lUniExpand:SENSITIVE IN FRAME createtable = YES
           lUniExpand:SCREEN-VALUE = "no"
           dummyl = lUniExpand:MOVE-AFTER-TAB-ITEM(unicodeTypes:HANDLE).
END.



ON VALUE-CHANGED OF l_cmptbl IN FRAME createalltables DO:

    IF ft:SCREEN-VALUE EQ "ora" THEN
        RETURN.

    IF SELF:SCREEN-VALUE = "NO" THEN
       ASSIGN iRecidOption:SENSITIVE IN FRAME createalltables = NO
           iRecidOption:SCREEN-VALUE IN FRAME createalltables = "1".
    ELSE
    ASSIGN iRecidOption:SENSITIVE IN FRAME createalltables = YES
           iRecidOption:SCREEN-VALUE IN FRAME createalltables = "1" .
END.

ON VALUE-CHANGED OF l_cmptbl IN FRAME createtable DO:

    IF ft:SCREEN-VALUE EQ "ora" THEN
        RETURN.
            
    IF SELF:SCREEN-VALUE = "NO" THEN
       ASSIGN iRecidOption:SENSITIVE IN FRAME createtable = NO
           iRecidOption:SCREEN-VALUE IN FRAME createalltables = "1".
    ELSE
    ASSIGN iRecidOption:SENSITIVE IN FRAME createtable = YES
           iRecidOption:SCREEN-VALUE IN FRAME createalltables = "1".
END.


ON LEAVE OF fot in frame createalltables
   fot:screen-value in frame createalltables = 
        TRIM(fot:screen-value in frame createalltables).

ON CHOOSE OF btn_File_i in frame createalltables DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT foi:handle in frame createalltables /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.

ON LEAVE OF foi in frame createalltables
   foi:screen-value in frame createalltables = 
        TRIM(foi:screen-value in frame createalltables).

ON VALUE-CHANGED OF ft IN FRAME createalltables DO:
   CASE SELF:SCREEN-VALUE:
     WHEN "pro" THEN DO:
       ASSIGN iFmtOption:SCREEN-VALUE IN FRAME createalltables = "2" 
              iRecidOption:SCREEN-VALUE IN FRAME createalltables = "1" 
              l_cmptbl:SENSITIVE = FALSE
              l_cmptbl:SCREEN-VALUE = "no"
              shadowcol:SENSITIVE = FALSE
              shadowcol:SCREEN-VALUE = "no"
              crtdef:SENSITIVE = FALSE
              crtdef:SCREEN-VALUE = "no".
       
       ASSIGN
              unicodeTypes:SENSITIVE IN FRAME createalltables= NO
              unicodeTypes:SCREEN-VALUE = "no"
              lUniExpand:SENSITIVE = NO
              lUniExpand:SCREEN-VALUE = "no"
              newSeq:SCREEN-VALUE = "no"
              newSeq:SENSITIVE = NO
              mapMSSDatetime:SCREEN-VALUE = "no"
              mapMSSDatetime:SENSITIVE = NO
              iRecidOption:SENSITIVE = NO.

       iFmtOption:DISABLE("Width") IN FRAME createalltables.
       APPLY "VALUE-CHANGED" TO iFmtOption IN FRAME createalltables.
     END.
     WHEN "ora" THEN DO:
       ASSIGN l_cmptbl:SENSITIVE = TRUE
              l_cmptbl:SCREEN-VALUE = "no"
              crtdef:SENSITIVE = TRUE
              shadowcol:SENSITIVE = TRUE.
       
       ASSIGN
              unicodeTypes:SENSITIVE IN FRAME createalltables = YES
              unicodeTypes:SCREEN-VALUE = "no"
              lUniExpand:SENSITIVE = NO
              lUniExpand:SCREEN-VALUE = "no"
              newSeq:SCREEN-VALUE = "no"
              newSeq:SENSITIVE = NO
              mapMSSDatetime:SCREEN-VALUE = "no"
              mapMSSDatetime:SENSITIVE = NO
              iRecidOption:SENSITIVE = NO.

       iFmtOption:ENABLE("Width") IN FRAME createalltables.
       APPLY "VALUE-CHANGED" TO iFmtOption IN FRAME createalltables.
     END.
     OTHERWISE DO:
       ASSIGN shadowcol:SENSITIVE = TRUE
              l_cmptbl:SENSITIVE = TRUE
              l_cmptbl:SCREEN-VALUE = "no"
              crtdef:SENSITIVE = TRUE.
       
       ASSIGN
              unicodeTypes:SENSITIVE IN FRAME createalltables = YES
              unicodeTypes:SCREEN-VALUE = "no"
              lUniExpand:SENSITIVE = NO
              lUniExpand:SCREEN-VALUE = "no"
              newSeq:SCREEN-VALUE = "no"
              newSeq:SENSITIVE = YES
              mapMSSDatetime:SCREEN-VALUE = "yes"
              mapMSSDatetime:SENSITIVE = YES
              iRecidOption:SENSITIVE = NO.

       iFmtOption:ENABLE("Width") IN FRAME createalltables.
       APPLY "VALUE-CHANGED" TO iFmtOption IN FRAME createalltables.
     END.
   END CASE.
END.

ON ENTRY OF FRAME createalltables DO:
   /* Just assigning l_cmptbl:SENSITIVE = FALSE doesn't work because the *
    * widget is not realized until the UPDATE statements are executed.   *
    * Once that happens, this is the only way to force the assignment.   */
   APPLY "VALUE-CHANGED" TO ft IN FRAME createalltables.
END.

ON WINDOW-CLOSE OF FRAME createalltables
   APPLY "END-ERROR" TO FRAME createalltables.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
ON VALUE-CHANGED OF allusers IN FRAME createalltables DO:
   DEFINE VARIABLE dummyl AS LOGICAL NO-UNDO.

   IF allusers:SCREEN-VALUE = "yes" THEN DO:
	usrnm:SENSITIVE = FALSE.
	usrnm:SCREEN-VALUE = "".
   END.
   ELSE DO:
        usrnm = "".
	usrnm:SENSITIVE = TRUE.
	dummyl = usrnm:MOVE-AFTER-TAB-ITEM(allusers:HANDLE).
	APPLY "ENTRY" TO usrnm.
   END.
END.
&ENDIF

/*========================= Initializations ============================*/

FIND DICTDB._File "_File" WHERE _File._Owner = "PUB" NO-LOCK.
answer = CAN-DO(_Can-read,USERID("DICTDB")).
FIND DICTDB._File "_Field" WHERE _File._Owner = "PUB" NO-LOCK.
answer = answer AND CAN-DO(_Can-read,USERID("DICTDB")).
FIND DICTDB._File "_Index" WHERE _File._Owner = "PUB" NO-LOCK.
answer = answer AND CAN-DO(_Can-read,USERID("DICTDB")).
IF NOT answer THEN DO:
  MESSAGE new_lang[6] VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  user_path = "".
  RETURN.
END.

RELEASE DICTDB._File.
assign alltables = (IF user_env[1] = "ALL" THEN yes ELSE no).

IF NOT alltables THEN
  FIND DICTDB._File 
    WHERE DICTDB._File._Db-recid = drec_db 
    AND DICTDB._File._File-name = user_env[1]
    AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN").


ASSIGN
  answer = TRUE
  fot = (IF alltables THEN user_dbname ELSE DICTDB._File._File-name)
      + ".p"
  foi = (IF alltables THEN user_dbname ELSE DICTDB._File._File-name)
      + ".i"
  fn  = (IF alltables THEN new_lang[5] ELSE DICTDB._File._File-name)
  usrnm  = (IF alltables THEN "ALL" ELSE ENTRY(1,_File._Can-read))
  ft  = ( if lookup(user_env[22],"pro,ora,mss") = 0
            then "pro"
            else user_env[22]
        )
  .

/* Adjust the graphical rectangle and the ok and cancel buttons */
IF alltables THEN DO:
  {adecomm/okrun.i  
    &FRAME  = "FRAME createalltables" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
  }
END.
ELSE DO:
  {adecomm/okrun.i  
    &FRAME  = "FRAME createtable" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
  }
END.
PAUSE 0.

/* here is the matrix of parameters per db-type */
assign
  l_dbtyp = "pro,ora,mss"
  l_ue-4  = "y,n,n"                        /* allow PROGRESS format statements */
  l_ue-5  = ".,;,go"                       /* statement terminator */
  l_ue-6  = "n,y,y"                        /* Unique index names? */
  l_ue-7  = "y,n,n"                        /* default <init value> */
  l_ue-8  = "y,y,y"                        /* xlat "-" -> "_" */
  l_ue-11 = "character,varchar2,varchar"   /* character */
  l_ue-12 = "date,date,datetime"           /*           */
  l_ue-13 = "logical,number,tinyint"       /* logical   */
  l_ue-14 = "integer,number,integer"       /* integer   */
  l_ue-15 = "decimal,number,decimal(18,5)" /* decimal   */
  l_ue-16 = "decimal,number,decimal"       /* decimal(_decimal=0) */
  l_ue-17 = "recid,number,integer"         /* recid     */
  l_ue-18 = "character,long,text"          /* char > x(240) */
  l_ue-19 = "logical,number,tinyint"       /* logical(idx-comp) */
  l_ue-20 = ",#,#"                         /* char for arrays; e.g. mnth-sales##12 */
  l_ue-21 = "n,y,n"                        /* shadowing for case-sensitivity */
  l_ue-22 = "PROGRESS,ORACLE,MSS"                         
  l_ue-23 = "8,30,30"                     /* minimum width for character-fields */
  l_ue-24 = "7,15,15"                     /* minimum width for numeric-fields */
  l_ue-25 = "n,y,y"                       /* sequences supported */
  l_ue-28 = "32,30,128"                    /* max-length(idx-name) */
  l_ue-29 = "32,26,128"                    /* max-length(id-name) */
  .
/*========================== Mainline code =============================*/

IF alltables THEN 
 DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN  
    uidtag = new_lang[7].

    DISPLAY uidtag cFormat lFormat cRecid WITH FRAME createalltables.
    usrnm = "ALL".
  
    UPDATE
      fot btn_File_t
      foi btn_File_i
      usrnm
      ft
      l_cmptbl
      shadowcol
      crtdef
      unicodeTypes
      lUniExpand WHEN unicodeTypes
      newSeq
      mapMSSDatetime
      iFmtOption
      lFormat WHEN iFmtOption = 2 
      iRecidOption
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
      WITH FRAME createalltables.
  &ELSE
    DISPLAY usrlab cFormat lFormat cRecid WITH FRAME createalltables.
    UPDATE
      fot btn_File_t
      foi btn_File_i
      allusers
      ft
      l_cmptbl
      shadowcol      
      crtdef
      unicodeTypes
      lUniExpand WHEN unicodeTypes
      newSeq
      mapMSSDatetime
      iFmtOption
      lFormat WHEN iFmtOption = 2
      iRecidOption
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
      WITH FRAME createalltables.
    IF allusers THEN usrnm = "ALL".
  &ENDIF

  /* if cr tab and cr idx both going to same file, wipe out idx fil name */
  IF foi = fot AND (OPSYS <> "UNIX" OR ENCODE(foi) = ENCODE(fot)) THEN foi = "".

  ASSIGN
    l_i          = lookup(ft,l_dbtyp)
    user_env[ 2] = fot  /* output file */
    user_env[ 3] = foi  /* '' or separate output file for 'create index' */
    user_env[ 4] = entry(l_i,l_ue-4)
    user_env[ 5] = entry(l_i,l_ue-5)
    user_env[ 6] = entry(l_i,l_ue-6)
    user_env[ 8] = entry(l_i,l_ue-8)
    user_env[ 9] = usrnm             /* userid */
    user_env[11] = entry(l_i,l_ue-11)
    user_env[12] = entry(l_i,l_ue-12)
    user_env[13] = entry(l_i,l_ue-13)
    user_env[14] = entry(l_i,l_ue-14)
    user_env[15] = entry(l_i,l_ue-15)
    user_env[16] = entry(l_i,l_ue-16)
    user_env[17] = entry(l_i,l_ue-17)
    user_env[18] = entry(l_i,l_ue-18)
    user_env[19] = entry(l_i,l_ue-19)
    user_env[20] = entry(l_i,l_ue-20)   
    user_env[22] = entry(l_i,l_ue-22)
    user_env[23] = entry(l_i,l_ue-23)
    user_env[24] = entry(l_i,l_ue-24)
    user_env[25] = entry(l_i,l_ue-25)
    user_env[27] = string(l_cmptbl,"y/n")
    user_env[28] = entry(l_i,l_ue-28)
    user_env[29] = entry(l_i,l_ue-29)
    user_env[31] = "-- **"           /*comment-character*/
    user_env[38] = "1"            /* OE00209275 */
    user_env[39] = "1"            /* OE00209275 */
    user_env[36] = "n,n,n,n,n"    /* OE00211502 */
    .

  IF user_env[22] = "ORACLE" OR user_env[22] = "MSS" THEN
     unicodeTypes = LOGICAL(unicodeTypes:SCREEN-VALUE IN FRAME createalltables).
  ELSE
     unicodeTypes = NO.

  IF user_env[22] = "MSS" THEN DO:
        ASSIGN user_env[7]  = (IF crtdef THEN "y" ELSE "n")
             user_env[10] = (IF unicodeTypes THEN "4000" ELSE "8000")
             user_env[12] = (IF mapMSSDatetime THEN "datetime" ELSE "date")
             user_env[32] = "MSSQLSRV7"
             user_env[21] = (IF shadowcol THEN "y" ELSE "n")
             user_env[27] = (IF l_cmptbl THEN "y" + "," + STRING(iRecidOption) ELSE "n")
             user_env[35] = "n".

       /* first y is for sequence support.
          second entry is for new sequence generator 
          third entry is for use 2008 types 
       */
       ASSIGN user_env[25] = "y" + (IF newseq THEN ",y" ELSE ",n") + 
                             (IF mapMSSDatetime THEN ',n' ELSE ',y').

      IF unicodeTypes THEN
         ASSIGN user_env[11] = "nvarchar"
                user_env[18] = "nvarchar(max)"
                lUniExpand = LOGICAL(lUniExpand:SCREEN-VALUE IN FRAME createalltables)
                user_env[35] = (IF lUniexpand THEN "y" ELSE "n").
                
  END.
  ELSE IF user_env[22] = "ORACLE" THEN
      ASSIGN user_env[7]  = (IF crtdef THEN "y" ELSE "n")
             user_env[18] = (IF unicodeTypes THEN "NVARCHAR2" ELSE "VARCHAR2")
             user_env[21] = (IF shadowcol THEN "y" ELSE "n")
             /* no support for character semantics and clob expansion */
             user_env[10] = (IF unicodeTypes THEN "2000" ELSE "4000") + ",no,no"
             user_env[11] = (IF unicodeTypes THEN "nvarchar2" ELSE "varchar2").
  ELSE
      ASSIGN user_env[7]  = "y" 
             user_env[21] = "n".
   
  IF iFmtOption = 1 THEN
    ASSIGN user_env[33] = "y".
  ELSE IF (lFormat = TRUE) THEN
    ASSIGN user_env[33] = "n".
  ELSE ASSIGN user_env[33] = "?".

  RUN "prodict/misc/_wrktgen.p".
  canned = FALSE.
END.

ELSE /*Single table*/
 DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN  
   DISPLAY cFormat lFormat cRecid WITH FRAME createtable.
   UPDATE
    fot btn_File_t
    foi btn_File_i
    ft
    l_cmptbl
    shadowcol
    crtdef
    unicodeTypes
    lUniExpand WHEN unicodeTypes
    newSeq
    mapMSSDatetime
    iFmtOption
    lFormat WHEN iFmtOption = 2
    iRecidOption
    btn_OK 
    btn_Cancel
    {&HLP_BTN_NAME}
    WITH FRAME createtable.
  &ELSE
   DISPLAY cFormat lFormat cRecid WITH FRAME createtable.
   UPDATE
    fot btn_File_t
    foi btn_File_i
    ft
    l_cmptbl
    shadowcol
    crtdef
    unicodeTypes
    lUniExpand WHEN unicodeTypes
    newSeq
    mapMSSDatetime
    iFmtOption
    lFormat WHEN iFmtOption = 2
    iRecidOption
    btn_OK 
    btn_Cancel
    {&HLP_BTN_NAME}
    WITH FRAME createtable.
  &ENDIF

  /* if cr tab and cr idx both going to same file, wipe out idx fil name */
  IF foi = fot AND (OPSYS <> "UNIX" OR ENCODE(foi) = ENCODE(fot)) THEN foi = "".

  ASSIGN
    l_i          = lookup(ft,l_dbtyp)
    user_env[ 2] = fot  /* output file */
    user_env[ 3] = foi  /* '' or separate output file for 'create index' */
    user_env[ 4] = entry(l_i,l_ue-4)
    user_env[ 5] = entry(l_i,l_ue-5)
    user_env[ 6] = entry(l_i,l_ue-6)
    user_env[ 8] = entry(l_i,l_ue-8)
    user_env[ 9] = "ALL"      	     /* userid */
    user_env[11] = entry(l_i,l_ue-11)
    user_env[12] = entry(l_i,l_ue-12)
    user_env[13] = entry(l_i,l_ue-13)
    user_env[14] = entry(l_i,l_ue-14)
    user_env[15] = entry(l_i,l_ue-15)
    user_env[16] = entry(l_i,l_ue-16)
    user_env[17] = entry(l_i,l_ue-17)
    user_env[18] = entry(l_i,l_ue-18)
    user_env[19] = entry(l_i,l_ue-19)
    user_env[20] = entry(l_i,l_ue-20)
    user_env[22] = entry(l_i,l_ue-22)
    user_env[23] = entry(l_i,l_ue-23)
    user_env[24] = entry(l_i,l_ue-24)
    user_env[25] = entry(l_i,l_ue-25)
    user_env[27] = string(l_cmptbl,"y/n")
    user_env[28] = entry(l_i,l_ue-28)
    user_env[29] = entry(l_i,l_ue-29)
    user_env[31] = "-- **"           /*comment-character*/
    user_env[38] = "1"            /* OE00209275 */
    user_env[39] = "1"            /* OE00209275 */
    user_env[36] = "n,n,n,n,n"    /* OE00211502 */
    .

  IF user_env[22] = "ORACLE" OR user_env[22] = "MSS" THEN
     unicodeTypes = LOGICAL(unicodeTypes:SCREEN-VALUE IN FRAME createtable).
  ELSE
      unicodeTypes = NO.

  IF user_env[22] = "MSS" THEN DO:
  
      ASSIGN user_env[ 7] = (IF crtdef THEN "y" ELSE "n")
             user_env[10] = (IF unicodeTypes THEN "4000" ELSE "8000")
             user_env[12] = (IF mapMSSDatetime THEN "datetime" ELSE "date")
             user_env[32] = "MSSQLSRV7"
             user_env[21] = (IF shadowcol THEN "y" ELSE "n")
             user_env[27] = (IF l_cmptbl THEN "y" + "," + STRING(iRecidOption) ELSE "n")
             user_env[35] = "n".

      /* first y is for sequence support.
         second entry is for new sequence generator 
         third entry is for use 2008 types 
      */
      ASSIGN user_env[25] = "y" + (IF newseq THEN ",y" ELSE ",n") + 
                            (IF mapMSSDatetime THEN ',n' ELSE ',y').

      IF unicodeTypes THEN
         ASSIGN user_env[11] = "nvarchar"
                user_env[18] = "nvarchar(max)"
                lUniExpand = LOGICAL(lUniExpand:SCREEN-VALUE IN FRAME createtable)
                user_env[35] = (IF lUniexpand THEN "y" ELSE "n").
  END.
  ELSE IF user_env[22] = "ORACLE" THEN
      ASSIGN user_env[ 7] = (IF crtdef THEN "y" ELSE "n")
             user_env[18] = (IF unicodeTypes THEN "NVARCHAR2" ELSE "VARCHAR2")
             user_env[21] = (IF shadowcol THEN "y" ELSE "n")
             /* no support for character semantics and clob expansion */
             user_env[10] = (IF unicodeTypes THEN "2000" ELSE "4000") + ",no,no"
             user_env[11] = (IF unicodeTypes THEN "nvarchar2" ELSE "varchar2").
  ELSE
      ASSIGN user_env[ 7] = "y"
             user_env[21] = "n".

  IF iFmtOption = 1 THEN
    ASSIGN user_env[33] = "y".
  ELSE IF (lFormat = TRUE) THEN
    ASSIGN user_env[33] = "n".   
  ELSE ASSIGN user_env[33] = "?".

  RUN "prodict/misc/_wrktgen.p".
  canned = FALSE.
END.

HIDE FRAME createtable NO-PAUSE.
IF canned THEN
  user_path = "".

RETURN.

