/*********************************************************************
* Copyright (C) 2006-2010 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*

_wrktgen.p

This program generates CREATE TABLE statements from DICTDB._File records
stored in the database.  These CREATE TABLE statements can then be
run on another database to define those tables.

  user_env[2] = output file
  user_env[3] = '' or separate output file for 'create index'
  user_env[4] = allow PROGRESS format statements and CASE-SENS modifier
  user_env[5] = statement terminator
  user_env[6] = unique index names
  user_env[7] = support DEFAULT <init value>
  user_env[8] = xlat "-" -> "_", "%" -> "_", Append "_" to reserved words
  user_env[9] = userid
  user_env[10] = Maximun size of Varchar for MS SQL Server 7 
                        or list of other options for ORACLE
  user_env[11..18] = a string of how to convert PROGRESS datatypes to SQL:
         [11] = character -> char, character, vchar, varchar, long char
         [12] = date      -> date, datetime
         [13] = logical   -> logical, bit
         [14] = integer   -> integer, smallint, number
         [15] = decimal   -> decimal, number, real, float, double precision
         [16] = decimal*  -> decimal, integer, number
         [17] = recid     -> recid, rowid
         [18] = char**    -> long, character, long varchar
         [19] = logical** -> logical, tinyint
              (decimal* is decimal with _Decimals=0)
              (char** is character longer than 240)
              (logical** is logical fields which are key components)
  user_env[20] = character to use for unique name creation
  user_env[21] = Add shadow column for case-insensitive key fields
  user_env[22] = external dbtype ("ORACLE"...)
  user_env[23] = Min width for character fields.
  user_env[24] = Min width for numeric fields.
  user_env[25] = comma-separated list:
                 [1] = create sequences
                 [2] = new sequence generator (for MSS)
                 [3] = use newer datetime types (for MSS).
  user_env[26] = foreign database login name.
  user_env[27] = comma-separated list of values
                    entry 1: compatible or not ("" is yes)
                    entry 2: "dbe"|"singel-byte"
                 (old users supply only the first entry!)
                    entry 2: ""1"|"2" (for DB2/400 only)
		             1- All tables
			     2- Tables without unique key /* OE00177721 */
                    entry 2: ""1"|"2" (for MSS-DS only)
		             1- trigger /* default */
			     2- Computed Columns/* OE00186593 */
  user_env[28] = maximum number of characters for index names,
                 undefined indicates no limit.
  user_env[29] = maximum length of identifiers.
  user_env[30] = write exit at end of SQL.
  user_env[32] = Underlying DBMS Type
  user_env[31] = string to comment out a line of SQL. 
  user_env[33] = Field width... 
                   Values:
                      "y" = Use SQL WIDTH
                      "n" = Use VARCHAR(30) for "x(8)" fields
                      "?" = Use field format
  user_env[34] = name of tablespace for tables for Oracle only. Or DB2 db type.
  user_env[35] = name of tablespace for indexes for Oracle only. For MSS, whether to expand
                 the field width (for Unicode).
*/
/*
HISTORY:

    hutegger 06/01/12   ORACLE defines length of a character in bytes,
                        so in case of dbe we need to double the 
                        calculated default.
                        Added this info as entry two to user_env[27]
    tomn     12/05/95   Added spacing to frame "working" to fix 4041 
                        errors on intl windows platforms  
    radams   94/09/09   Add support for more batch mode logging.
                        Cleanup error messages and information message 
                        logging.
                        Add support for commenting out SQL that isn't
                        valid.
                        Add column count calculation to avoid SQL errors.
                        Add check for descending index components for 
                        Sybase 10.
    fladung  94/07/22   add support for ALLBASE DataServer
    radams   94/07/22   if user_env[27] "compatable" is "" then assume yes
    radams   94/07/19   if user_env[27] "compatable" is ?  then assume yes
    gfs      94/07/13   94-07-07-066 & 94-07-13-034
    radams   94/06/03   add support for a maximum identifier length.
    radams   94/06/01   add support for producing non-compatible sql.
    radams   94/05/10   add sybase 10 functionality 
    hutegger 94/05/06   after discussing with Marceau I made the following
                        changes:
                        + oracle7 longchar gets identified by
                                user_env[18] = "VARCHAR2"
                        + topic             PROGRESS  ORACLE  SYBASE
                          DROP TABLE            no      yes     yes
                          progress_recid        no      yes     yes
                          ditto - index         no      yes     yes
                          ditto for uniqueness  no      yes     yes
Note: I did not use the dictgate.i functionality because this file has
to be worked on anytime we add another DataServer anyhow. I rather
enumerate all DataServers that allow things than use <> "PROGRESS" to
prevent future-bugs resulting out of default behaviour <hutegger>

    mcmann  97/11/12  Removed references to all DataServers except ODBC and ORACLE.
    mcmann  97/12/18  Added validation for more than one long, changed size of long and
                      changed how length of format was calculated.  Also eliminated
                      creation of file if zero fields were defined in PROGRESS.
    mcmann  98/01/13  Added check for oracle version for proper assignment of
                      longs.
    mcmann  98/04/02   98-03-26-025 problem with defaults and duplicate names
    mcmann  98/05/11   98-05-05-055 Seq-name was not being set properly.
    mcmann  98/05/18   Changed how the default value for logical's are determined
    mcmann  98/06/12   Added initialization of nbrchar for character data type 98-06-09-012
    mcmann  98/07/06   Added user_env[32] for ODBC underlying DBMS and added code
                       to handle multiple data sources for ODBC.
    mcmann  98/09/03   Removed drop statement from script.
    mcmann  98/09/15   Changed how unique index for recid is created using
                       prowid_col.
    mcmann  98/10/29   Change how the length of a character field is calcaluated when checking
                       for long fields.
    mcmann  99/01/14   99-01-13-022 Changed Oralce PROGRESS_RECID index name
    mcmann  99/01/26   Added check for _decimals = ? for data type decimals
    mcmann  99/03/09   Added logic to put all field names into verify-name file.
    mcmann  99/03/10   Changed trigger for MS SQL Server and split out Sybase
    mcmann  99/03/25   Removed use <db-name> syntax from Sybase and MS SQL Server
    mcmann  99/08/31   Added logic to verify table and index names
    mcmann  99/09/01   Added logic to change a sequence name if it ends in _seq.
    mcmann  99/09/03   Added check for RAW datatype so not too many longs
                       could be created.
    mcmann  99/09/07   Changed PROGRESS_RECID to be the name for all ODBC Db's.
    mcmann  99/09/28   Added "_" to Ident for name for seperation of words.
    mcmann  99/12/02   Added DESC in indexes for Oracle 19991102005
    mcmann  99/12/15   Added check for truncated index field name 19991215003
    mcmann  99/12/30   Added check for length of sequence name 19991230038
    mcmann  00/01/18   Added _foreign for owner 20000111011
                       check for length of extent names and
                       number of long columns 
    mcmann  00/02/01   Added use of _Width and size of field.
    mcmann  00/02/17   Added support for Current Value Support for ODBC
    mcmann  00/03/21   Removed block for ODBC on number of long columns. 
    mcmann  00/03/22   Added support for MS SQL Server 7
    mcmann  00/04/25   put back syntax remvoed for MSSQLServer 7 for 6.5 and
                       Sybase
    mcmann  00/05/11   Quoted PROGRESS 20000502007
    mcmann  05/24/00   Added support for LONG RAW for Oracle.
    mcmann  07/17/00   Changed calculation of sqlwidth for extent fields.
    mcmann  09/12/00   Added increament to non-cycling seq for initial value
                       20000821013
    mcmann  12/05/00   Recognized MS SQL Server 7 and Oracle limitation of decimal size for using _Width.
    mcmann  02/09/01   syslogins column suid has been removed for ms sql server 7 changed to sid                       
    mcmann  04/09.01   Removed the "use dbname" from script for Sybase and SQL Server 6.5
    mcmann  11/13/01   Added DEFAULT values for all data types except RECID and RAW. 20011127-002
                       20011026-013, 20011108-022
    mcmann  05/28/02   Logic error on date defaults if not equal to today it will be blanked out.
    mcmann  06/11/02   Added comment_chars to Tablespace logic 20020611-021
    mcmann  06/25/02   Support for UPPER function indexes
    mcmann  08/08/02   Changed max number of possible sequences to 2000 20020731-003
    mcmann  08/08/02   Eliminated any sequences whose name begins "$" - Peer Direct
    mcmann  10/01/02   Eliminated SQL tables from being processed.
    mcmann  01/16/03   Added logic to check start with value to initial 20030116-015
    mcmann  02/17/03   Added support for BLOB for Oracle
    mcmann  07/31/03   Added blocking of unsupported Progress Data Types.
    mcmann  10/23/03   Changed routine for generating unique names to match Delta
                       SQL routine 20031023-018
  kmcintos  04/13/04   Added support for DB2/400 Libraries.  Prepending library names 
                       to CREATE (TABLE & INDEX) statements
  
  kmcintos 02/15/05   Added "DB2" to case statement.  Fixed bug # 20050214-020.
  kmcintos 02/28/05   Added cases for user_env[33] (Field width/x8override)
  fernando 01/04/06   Handle decimals for DB2/400 20051214-009
  fernando 06/26/06   Added support for int64
  fernando 06/11/07   Unicode and clob support for ORACLE
  fernando 02/14/08   Support for datetime for MSS
  fernando 04/07/08   Support for datetime for ORACLE
  fernando 04/11/08   Support for new sequence generator for MSS.
  rkumar   05/15/08   Support for new sequence generator for MSS DataServers
  rkumar   06/09/08   Fixed bug OE00169473/75 related to new sequence generator for MSS DataServers
  fernando 08/25/08   Start cyclic sequence with current value - ORACLE - OE00167056
  fernando 08/25/08   Fix logic for extent and sql-width - OE00172253
If working with an Oracle Database and the user wants to have a DEFAULT value of blank for VARCHAR2 fields, an environment variable BLANKDEFAULT can be set to "YES" and the code will put the DEFAULT ' ' syntax on the definition. D. McMann 11/27/02    
  knavneet 09/28/08   Added error handling code to the sequence generator - OE00172741
  rkumar   12/10/08   DROP TABLE SQL for MSS DataServers  OE00177726 
  rkumar   01/07/09   Added default values for ODBC DataServer- OE00177724
  rkumar   03/30/09   Fixed issue with error-handling code using new seq generator- OE00182302
  rkumar   03/30/09   DROP TABLE SQL for ODBC DataServers  OE00182649
  fernando 04/03/09   Support for DATETIME-TZ (and other date time types) for MSS
  knavneet 04/28/09   Support for BLOB for MSS (OE00178319)
  rkumar   05/05/09   Added RECID support for ODBC DataServer- OE00177721
  nmanchal 07/15/09   Trigger changes for MSS(OE00178470)
  nmanchal 07/20/09   Trigger changes for MSS(OE00178470) to remove 'WITH NOWAIT'
  nmanchal 07/30/09   To fix MSS unicode migration issues for trigger creation (OE00188693)
  rkumar   08/25/09   Fix RECID implementation issues (OE00189366)
  Nagaraju 09/22/09   Implement Computed column solution for MSS DS (OE00189563)
  fernando 02/11/10   Fix issue with sql generated for old sequence generator
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE a                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE c                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE e                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE f                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i                   AS INT64      NO-UNDO.
DEFINE VARIABLE j                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE k                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE ri                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE n1                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE n2                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pfmt                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE sdef                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE xlat                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE skptrm              AS LOGICAL    NO-UNDO. /* skip line before user_env[5] */
DEFINE VARIABLE shadow              AS LOGICAL    NO-UNDO. /* Evil twin (uppercase) columns */
DEFINE VARIABLE prowid_col          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE doseq               AS LOGICAL    NO-UNDO. /* create sequences (oracle) */
DEFINE VARIABLE have_u              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE compatible          AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE batch_mode          AS LOGICAL    NO-UNDO. 

DEFINE VARIABLE column_count        AS INTEGER    NO-UNDO. 
DEFINE VARIABLE col_long_count      AS INTEGER    NO-UNDO.
DEFINE VARIABLE dbe-factor          AS INTEGER    NO-UNDO.
DEFINE VARIABLE longwid             AS INTEGER    NO-UNDO INITIAL 240.
DEFINE VARIABLE minwdth             AS INTEGER    NO-UNDO.
DEFINE VARIABLE mindgts             AS INTEGER    NO-UNDO.
DEFINE VARIABLE unik                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dbtyp               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE db2type             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE idbtyp              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE afldn               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pindex              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE uc_col              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE uc_tmp              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE max_idx_len         AS INTEGER    NO-UNDO.
DEFINE VARIABLE max_id_length       AS INTEGER    NO-UNDO.
DEFINE VARIABLE max_ext_length      AS INTEGER    NO-UNDO.
DEFINE VARIABLE comment_chars       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE comment_all_objects AS LOGICAL    NO-UNDO.
DEFINE VARIABLE sqlwidth            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE maxidxcollen        AS INTEGER    NO-UNDO.
DEFINE VARIABLE blankdefault        AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE tmp_str             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE tmpfile             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE l_seq-num           AS INTEGER    NO-UNDO.
DEFINE VARIABLE start               AS INT64      NO-UNDO.
DEFINE VARIABLE limit               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE logfile_name        AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE codefile_name       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE warnings_issued     AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE tables_not_created  AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE index_checking      AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE shadow_is_valid     AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE trunc_name          AS LOGICAL    NO-UNDO.

DEFINE VARIABLE left_paren          AS INTEGER    NO-UNDO.
DEFINE VARIABLE right_paren         AS INTEGER    NO-UNDO.
DEFINE VARIABLE lngth               AS INTEGER    NO-UNDO.
DEFINE VARIABLE z                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE nbrchar             AS INTEGER    NO-UNDO.
DEFINE VARIABLE slash               AS INTEGER    NO-UNDO.
DEFINE VARIABLE unsprtdt            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dot                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTmpFmt             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE large_seq           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lUniExpand          AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE lnewSeq             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE seqt_prefix         AS CHARACTER  NO-UNDO INITIAL "_SEQT_".
DEFINE VARIABLE seqp_prefix         AS CHARACTER  NO-UNDO INITIAL "_SEQP_".
DEFINE VARIABLE other-seq-tab       AS CHARACTER  NO-UNDO. /* OE00170189 */
DEFINE VARIABLE other-seq-proc      AS CHARACTER  NO-UNDO. /* OE00170189 */
DEFINE VARIABLE mssNewDTTypes       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE unique_idx_flag     AS LOGICAL    NO-UNDO INITIAL FALSE. /* OE00177721 */

DEFINE NEW SHARED VARIABLE crnt-vals AS INT64 EXTENT 2000 init 0 NO-UNDO.

DEFINE TEMP-TABLE verify-name NO-UNDO
  FIELD new-name LIKE _Field._Field-name
  FIELD prog-name LIKE _Field._Field-name
  INDEX trun-name IS UNIQUE new-name
  INDEX prog-name IS UNIQUE prog-name.
        
DEFINE TEMP-TABLE verify-table NO-UNDO
  FIELD new-name LIKE _File._File-name
  INDEX trun-name IS UNIQUE new-name.
  
DEFINE TEMP-TABLE verify-index NO-UNDO
  FIELD new-name LIKE _index._index-name
  INDEX trun-name IS UNIQUE new-name.  
                
DEFINE STREAM code.           /* file containing SQL for foreign database */
DEFINE STREAM tmpstream.   /* */

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

FORM
  SKIP(1)
  DICTDB._File._File-name LABEL "Working on Table" FORMAT "x(32)" AT 3
  SKIP(1)
  WITH FRAME working 
  WIDTH 58 SIDE-LABELS ROW 5 CENTERED &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D TITLE "Dump CREATE TABLE Statement" &ENDIF.

/* If user_library has been specified, then this is for DB2/400 and we
   need to define a dot(.) in order to prepend the library name to the
   TABLE/INDEX name */
ASSIGN user_library = (IF user_library EQ ? THEN "" ELSE user_library)
       dot          = (IF user_library NE "" THEN "." ELSE "").

IF NOT batch_mode THEN 
  COLOR DISPLAY MESSAGES DICTDB._File._File-name WITH FRAME working.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

SESSION:IMMEDIATE-DISPLAY = yes.

IF OS-GETENV("BLANKDEFAULT")   <> ? THEN
  tmp_str   = OS-GETENV("BLANKDEFAULT").
IF tmp_str BEGINS "Y" THEN
  ASSIGN blankdefault = TRUE.

ASSIGN
  pfmt   = (user_env[4]  BEGINS "y") /* progress-format */
  sdef   = (user_env[7]  BEGINS "y") /* default <init value> */
  xlat   = (user_env[8]  BEGINS "y") /* xlat "-" -> "_", "%" -> "_", reswrds */
  shadow = (user_env[21] BEGINS "y") /* Create shadow columns for case-insens key fields */
  doseq  = (user_env[22] = "ORACLE" and user_env[25] BEGINS "y") OR
           (user_env[32] <> ?   and user_env[25] BEGINS "y")
  doseq  = doseq and user_env[1] = "ALL".

IF user_env[33] = "y" THEN
  sqlwidth = TRUE. /* Use _Width field for size */
ELSE IF user_env[33] = "?" THEN
  sqlwidth = ?. /* Use _Format field for size */
ELSE sqlwidth = FALSE. /* Calculate size */

IF user_env[30] = ? OR user_env[30] = "" 
 THEN ASSIGN user_env[30] = "y".

/* parse user_env[27]:
 * entry 1: ""|"y*" -> create recid fields/indexes and shadow-columns
 *                  <> create non-compatible foreign MetaSchema
 * entry 2:
 */
if  user_env[27] = ?  OR user_env[27] = ""
 THEN ASSIGN compatible = true
             dbe-factor = 1.
else if num-entries(user_env[27]) > 1
 then assign  /* more than one value in user_env[27] */
  compatible = ( entry(1,user_env[27]) BEGINS "y"
              or entry(1,user_env[27]) = ""
               ) 
  shadow     = shadow and compatible
  dbe-factor = ( if entry(1,user_env[27]) = "dbe"
                    then 2
                    else 1
               ).
 else assign
  compatible = (user_env[27] BEGINS "y") /* create recid fields/indexes */
  dbe-factor = 1.

batch_mode = SESSION:BATCH-MODE.

IF user_env[20] = ""   THEN unik = "##".
ELSE unik = SUBSTR( user_env[20], 1, 1) + SUBSTR( user_env[20], 1, 1).

assign  minwdth = INTEGER (user_env[23])
        mindgts = INTEGER (user_env[24])
        idbtyp = { adecomm/ds_type.i 
                  &direction = "ETOI"
                  &from-type = "user_env[22]"
                  }.

/* protoodbc assign the foreign data source type in user_env[32] and has
   the generic ODBC type in [22]
*/   
IF user_env[22] = "ODBC" OR user_env[22] = "MSS" THEN DO:
  ASSIGN dbtyp = user_env[32].

  /* 20051214-009 DB2 type is in user_env[34] */
  IF user_env[22] = "ODBC" THEN
     assign db2type = user_env[34].
  ELSE DO:     
     /* MSS db type */
     RUN setMSSOptions.
  END.
END.
ELSE
  ASSIGN dbtyp = user_env[22]
         db2type = ?.

CASE dbtyp:
  WHEN "ORACLE" THEN DO:
    prowid_col = "progress_recid".

    IF user_env[18] = "VARCHAR2" OR user_env[18] = "NVARCHAR2" THEN DO:
        /* the max size for char columns is the first entry stored in user_env[10],  */
       ASSIGN longwid = integer(entry(1,user_env[10])).

       /* if the second entry is yes, user wants char fields to expand to CLOB and not LONG */
       IF LOGICAL(ENTRY(2,user_env[10])) THEN
          ASSIGN user_env[18] = "clob".
       ELSE /* if using Unicode data types, expand column to NCLOB */
          ASSIGN user_env[18] = (IF user_env[18] = "NVARCHAR2" THEN "nclob" ELSE "long").
    END.
    ELSE
       ASSIGN longwid = 2000
              user_env[18] = "long".
  END. 
  WHEN "Informix" THEN
    ASSIGN longwid = 2000
           prowid_col = "PROGRESS_RECID".
           
  WHEN "DB2/400" OR WHEN "DB2(Other)" OR WHEN "DB2" THEN
    ASSIGN longwid = 4000
           prowid_col = "PROGRESS_RECID".
                 
  WHEN "MS SQL Server" THEN 
    ASSIGN longwid = 255
           prowid_col = "PROGRESS_RECID". 
  
 WHEN "MSSQLSRV7" THEN 
    ASSIGN longwid = integer(user_env[10])
           prowid_col = "PROGRESS_RECID"
           shadow     = (user_env[21] BEGINS "y").

  WHEN "SYBASE"  THEN 
    ASSIGN longwid = 255
           prowid_col = "PROGRESS_RECID".
           
  WHEN "MS Access" OR WHEN "Other" THEN 
    ASSIGN longwid = 255
           prowid_col = "PROGRESS_RECID".
  
END CASE.

/* Check for a max idx name length, if undefed, assume none */

IF user_env[28] <> ? THEN
  max_idx_len = INTEGER(user_env[28]).
ELSE
  max_idx_len = 0.  /* Since a max length of 0 is silly, this implies no max */

IF user_env[29] <> ? THEN 
  max_id_length = INTEGER(user_env[29]).
ELSE
  max_id_length = 0. 

PAUSE 0.
IF user_env[3] <> "" THEN DO:
  /* This clears the file if it existed already */
  OUTPUT STREAM code TO VALUE(user_env[3]) NO-ECHO NO-MAP.
  OUTPUT STREAM code CLOSE.
END.

IF INDEX(user_env[2],".", 1) > 0 THEN
     ASSIGN logfile_name  = SUBSTRING(user_env[2],1,INDEX(user_env[2],".", 1) - 1) + ".log"
            codefile_name = user_env[2].
ELSE ASSIGN logfile_name  = user_env[2] + ".log"
            codefile_name = user_env[2] + ".sql".


OUTPUT STREAM code    TO VALUE(codefile_name) NO-ECHO NO-MAP.

/* 
 * Open the logfile if we haven't got an open one already.
 */
IF NOT logfile_open THEN 
    OUTPUT STREAM logfile to VALUE(logfile_name)  UNBUFFERED APPEND NO-ECHO NO-MAP.

IF dbtyp = "SYBASE" OR dbtyp = "MS SQL Server"  OR dbtyp = "MSSQLSRV7" THEN 
  skptrm = TRUE.
ELSE
  skptrm = FALSE.

IF dbtyp = "ORACLE" THEN DO:
    /* this defines if the user wants character semantics */
    IF LOGICAL(entry(3,user_env[10])) THEN
        PUT STREAM code UNFORMATTED "ALTER SESSION SET NLS_LENGTH_SEMANTICS='CHAR';" SKIP.
END.

_fileloop:
FOR EACH DICTDB._File  WHERE DICTDB._File._Db-recid = drec_db
                         AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                         AND (IF user_env[1] = "ALL"  THEN 
                              NOT DICTDB._File._Hidden AND 
                             (CAN-DO(_File._Can-read, user_env[9]) OR user_env[9] = "ALL")
                               ELSE
                                  DICTDB._File._File-name = user_filename
                              ):
  
  ASSIGN unique_idx_flag = FALSE. /* OE00177721 */
  IF DICTDB._File._Db-lang > 0 THEN NEXT _fileloop.

  /* Clear temp table for new file */                            
  FOR EACH verify-name:
     DELETE verify-name.
  END. 

  /* If Progress database, clear index names */
  IF dbtyp = "PROGRESS"  THEN DO:
      FOR EACH verify-index:
          DELETE verify-index.
      END.
  END.
                              
  IF TERMINAL <> "" or NOT batch_mode THEN
    DISPLAY DICTDB._File._File-name WITH FRAME working.
  ELSE IF batch_mode THEN DO:
      PUT STREAM logfile UNFORMATTED 
          "Table " at 10 DICTDB._File._File-name at 25 skip. 
  END. 
  
  ASSIGN comment_chars = ""
         comment_all_objects = FALSE
         unsprtdt = FALSE.

  /* Count the number of columns that will be in the table. 
   * This should be used to see if we are exceeding any limits 
   * of individual data managers. 
   
   * Verify that no unsupport datatypes are present
 */
    
  ASSIGN column_count = 0
         col_long_count = 0.

  for each DICTDB._Field where DICTDB._Field._file-recid = recid(DICTDB._file):
 
    /*  If this isn't an array then only add one. If it is an array add one 
     * for each column we'll create. */
      
    if DICTDB._Field._Extent = 0 then
        column_count = column_count + 1. 
    else 
        column_count = column_count + DICTDB._Field._Extent.

    /*  add the shadow columns if appropriate*/
    
    if can-find(DICTDB._Index-field where DICTDB._Index-field._Field-recid = recid(DICTDB._Field))
        AND shadow then
         ASSIGN column_count = column_count + 1. 
         
    /* check for long data types which will be a format greater than maximum char length (longwid) */    
    IF DICTDB._Field._Dtype = 1 THEN DO:
      IF sqlwidth THEN DO:
        IF DICTDB._Field._Extent = 0 THEN 
          ASSIGN z = DICTDB._Field._Width.
        ELSE DO:
          ASSIGN z = ((DICTDB._Field._Width - (DICTDB._Field._Extent * 2)) / DICTDB._Field._Extent).
          /* OE00172253 - check if value is negative, then assign it the width value unless it's too
             big, in which case we assign the max value allowed for this type.
          */
          IF z <= 0 THEN DO:
              z = DICTDB._Field._Width.
              IF z > longwid THEN
                  z = longwid.
          END.
        END.
      END.
      ELSE DO:       
        ASSIGN lngth = LENGTH(DICTDB._Field._format, "character")
               z = 0.
           
        IF INDEX(DICTDB._Field._Format, "(") > 1 THEN DO:
           left_paren = INDEX(DICTDB._Field._Format, "(").
           right_paren = INDEX(DICTDB._Field._Format, ")").
           lngth = right_paren - (left_paren + 1).
           assign z = INTEGER(SUBSTRING(DICTDB._Field._Format, left_paren + 1, lngth)).  
        END. 
        ELSE DO:         
          DO j = 1 to lngth:        
            IF SUBSTRING(DICTDB._Field._Format,j,1) = "9" OR
               SUBSTRING(DICTDB._Field._Format,j,1) = "N" OR   
               SUBSTRING(DICTDB._Field._Format,j,1) = "A" OR    
               SUBSTRING(DICTDB._Field._Format,j,1) = "x" OR
               SUBSTRING(DICTDB._Field._Format,j,1) = "!"   THEN
                 ASSIGN z = z + 1.
          END.      
        END.   
        IF z = 0 THEN                    
           ASSIGN z = lngth.    
      END.
      
      IF lUniExpand THEN
          z = z * 2.

      /* if not ORACLE, or if expanding to long column, then increment long count */
      /* user_env[18] may be a clob type, in which case it's ok to have more than one column on a given table */
      IF dbtyp <>  "ORACLE" OR user_env[18] EQ "long" THEN DO:
        IF z > longwid THEN 
            ASSIGN col_long_count = col_long_count + 1.
        END.
        ELSE IF DICTDB._Field._Dtype = 8 THEN
             ASSIGN col_long_count = col_long_count + 1.
    END.
    
    IF dbtyp <> "PROGRESS" AND DICTDB._Field._Dtype NE 41 /*int64*/ THEN DO:
      IF (dbtyp = "MSSQLSRV7" OR dbtyp = "ORACLE") 
          AND DICTDB._Field._Dtype EQ 34 /*datetime*/ THEN 
          /*ok*/ .
      ELSE IF (dbtyp = "ORACLE" OR (dbtyp = "MSSQLSRV7" AND mssNewDTTypes)) AND 
               DICTDB._Field._Dtype EQ 40 /*datetime-tz*/ THEN 
          /*ok*/ .
      ELSE IF dbtyp = "MSSQLSRV7" AND DICTDB._Field._Dtype EQ 18 /*BLOB*/ THEN
          /*ok*/ .
      ELSE IF dbtyp <>  "ORACLE" AND DICTDB._Field._Dtype > 17 THEN
        ASSIGN unsprtdt = TRUE.
      ELSE IF dbtyp = "ORACLE" AND DICTDB._Field._Dtype > 19 THEN     
        ASSIGN unsprtdt = TRUE.
    END.
  end.   

  IF dbtyp <> "PROGRESS" AND column_count = 0 THEN DO:
    PUT STREAM logfile UNFORMATTED
          "WARNING: TABLE " DICTDB._File._File-name " will not be created." skip
          " " skip
          "         Table has " column_count " columns." skip
          " " skip.  
    warnings_issued = true. 
  END. /* empty tables check */
  
  IF dbtyp = "ORACLE"  AND col_long_count > 1 THEN DO:
    PUT STREAM logfile UNFORMATTED
          "WARNING: TABLE " DICTDB._File._File-name " will not be created." skip
          " " skip
          "         Table has " col_long_count " long columns." skip
          " " skip.  
    ASSIGN warnings_issued = true
           tables_not_created = true
           comment_chars = user_env[31]
           comment_all_objects = TRUE.

  END. 
  
  IF (dbtyp = "SYBASE" OR dbtyp = "MS SQL Server" ) AND column_count > 250 THEN DO:
    PUT STREAM logfile UNFORMATTED
        "WARNING: TABLE " DICTDB._File._File-name " will not be created." skip
        " " skip
        "         Table has " column_count " columns including shadow " skip
        "         columns and arrays. SQL Server only supports 250." skip
        " " skip.  
    ASSIGN comment_chars = user_env[31]
           comment_all_objects = true
           warnings_issued = true.            
  END. /* sybase & SQL Server 6.5 check */

  IF dbtyp = "MSSQLSRV7"  AND column_count > 1024 THEN DO:
    PUT STREAM logfile UNFORMATTED
        "WARNING: TABLE " DICTDB._File._File-name " will not be created." skip
        " " skip
        "         Table has " column_count " columns including shadow " skip
        "         columns and arrays. MS SQL Server 7 only supports 1024." skip
        " " skip.  
    ASSIGN comment_chars = user_env[31]
           comment_all_objects = true
           tables_not_created = true
           warnings_issued = true.            
  END. /* MS SQL Server 7 check */

  IF (dbtyp = "DB2" ) AND column_count > 500 THEN DO:
    PUT STREAM logfile UNFORMATTED
        "WARNING: TABLE " DICTDB._File._File-name " will not be created." skip
        " " skip
        "         Table has " column_count " columns including shadow " skip
        "         columns and arrays. DB2 only supports 500." skip
        " " skip.  
    ASSIGN comment_chars = user_env[31]
           comment_all_objects = true
           tables_not_created = true
           warnings_issued = true.        
  END. /* DB2 check */

  IF unsprtdt THEN DO:
    PUT STREAM logfile UNFORMATTED
        "WARNING: TABLE " DICTDB._File._File-name " will not be created." skip
        " " skip
        "         Table contains unsupported Progress data types " SKIP
        "         and cannot be created. " SKIP
        " " skip.  

    ASSIGN comment_chars = user_env[31]
           comment_all_objects = true
           tables_not_created = true
           warnings_issued = true.        
  END.
  
  ASSIGN uc_col = "".

  IF DICTDB._File._For-name <> ? AND DICTDB._File._For-name <> "n/a" 
                                 AND DICTDB._File._For-name <> "" THEN 
      n1 = DICTDB._File._For-name.
  
  ELSE IF DICTDB._File._fil-misc2[1] <> ? THEN DO:
    IF R-INDEX (_fil-misc2[1], ".") > 0 THEN
      n1 = SUBSTR (_fil-misc2[1], R-INDEX (_fil-misc2[1], ".") + 1).
    ELSE
      n1 = DICTDB._File._fil-misc2[1].
  END. 
  ELSE
    n1 = DICTDB._File._File-name.

  trunc_name = FALSE.
  IF xlat THEN DO:
     if max_id_length <> 0 and length(n1) > max_id_length then do:
           /*  _resxlat will truncate name  */
           put stream logfile unformatted
              "WARNING: Table name " n1 " is longer than the maximum " skip
              "         legal identifier length of " max_id_length "." skip.
           trunc_name = TRUE.
      end.
      n1 = n1 + "," + idbtyp + "," + string (max_id_length).
      RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n1).
  end.
  else if max_id_length <> 0  and length(n1) > max_id_length then do:
        /*  need to truncate name  */
     put stream logfile unformatted
           "WARNING: Table name " n1 " is longer than the maximum " skip
           "         legal identifier length of " max_id_length "." skip.
     n1 = substring(n1,1,max_id_length).
     trunc_name = TRUE.
  end.
 
  _verify-table:
  DO WHILE TRUE:
    FIND verify-table WHERE verify-table.new-name = n1 NO-ERROR.
    IF NOT AVAILABLE verify-table THEN DO:
      CREATE verify-table.
      ASSIGN verify-table.new-name = n1.
      LEAVE _verify-table.
    END.
    ELSE DO:
      DO a = 1 TO 999:
        ASSIGN n1 = SUBSTRING(n1, 1, LENGTH(n1) - LENGTH(STRING(a))) + STRING(a).

        IF CAN-FIND(verify-table WHERE verify-table.new-name = n1) THEN NEXT.
        ELSE DO:
          CREATE verify-table.
          ASSIGN verify-table.new-name = n1.
          LEAVE _verify-table.
        END.
      END.
    END.    
  END.
 
  if trunc_name then     
     put stream logfile unformatted 
             "         Truncating table name to " n1 skip(2).         
    
  IF dbtyp = "ORACLE" THEN DO:
     PUT STREAM code UNFORMATTED comment_chars
        "DROP SEQUENCE " n1 "_SEQ".
     IF skptrm THEN
        PUT STREAM code UNFORMATTED SKIP.
     PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
     IF compatible THEN DO:
         PUT STREAM code UNFORMATTED comment_chars
            "CREATE SEQUENCE " n1 "_SEQ START WITH 1 INCREMENT BY 1".
         IF skptrm THEN
            PUT STREAM code UNFORMATTED SKIP.
         PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
     END.
  
     PUT STREAM code UNFORMATTED comment_chars "DROP TABLE " n1.
     IF skptrm THEN PUT STREAM code UNFORMATTED SKIP.
     PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
  END.

  ELSE IF DBTYP = "SYBASE" OR DBTYP = "MS SQL Server"  THEN DO:

      PUT STREAM CODE UNFORMATTED 
          comment_chars "if (select name from sysobjects " SKIP 
          comment_chars "           where name = '" n1 "' and type = 'U' and " SKIP
          comment_chars "                 uid = (select uid from sysusers " SKIP  
          comment_chars "                               where suid = (select suid from master.dbo.syslogins" SKIP 
          comment_chars "                                                    where UPPER(name) = UPPER('" 
          user_env[26] "'))))" skip 
          comment_chars "   is not NULL" SKIP          
          comment_chars "    drop table " n1 SKIP
          comment_chars user_env[5] SKIP.
  END. 
  ELSE IF dbtyp = "MSSQLSRV7" THEN DO:
      PUT STREAM CODE UNFORMATTED 
          comment_chars "if (select name from sysobjects " SKIP 
          comment_chars "    where name = '" n1 "' and type = 'U' and " SKIP
          comment_chars "    uid = (select uid from sysusers " SKIP  
          comment_chars "            where sid = (select sid from master.dbo.syslogins" SKIP 
          comment_chars "                         where UPPER(name) = UPPER('" user_env[26] "'))))" skip 
          comment_chars "   is not NULL" SKIP          
          comment_chars "    drop table " n1 SKIP
          comment_chars user_env[5] SKIP.
  END.
 /*  ELSE IF ( dbtyp <> "Informix" AND dbtyp <> "DB2" AND dbtyp <> "MS ACCESS" )  THEN DO: */ 
 /*  OE00177726- Added DROP SQL statement to .sql file for all ODBC-compliant
                databases which are not handled above */
   ELSE DO:
      PUT STREAM code UNFORMATTED comment_chars "DROP TABLE " user_library dot n1.
      IF skptrm THEN
          PUT STREAM code UNFORMATTED SKIP.
      PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
  end. 
 
  PUT STREAM code UNFORMATTED comment_chars "CREATE TABLE " user_library dot.
  PUT STREAM code UNFORMATTED n1 " (" SKIP.
 
  FOR EACH DICTDB._Field OF DICTDB._File BREAK BY DICTDB._Field._Order:
   
    IF DICTDB._Field._For-type = "TIME" THEN NEXT.
    
    IF   DICTDB._Field._For-name <> ? AND 
         DICTDB._Field._For-name <> "n/a" AND 
         DICTDB._Field._For-name <> "" THEN          
       ASSIGN n2 = DICTDB._Field._For-name.    
    ELSE DO:
        /* Avoid collisions with unrolled extents */
       ASSIGN n2 = DICTDB._Field._Field-name.
       
       IF DICTDB._Field._Extent > 0 THEN DO:
         ASSIGN ri = R-INDEX (n2, "##").
              
         IF ri > 2 AND ri < LENGTH (n2) THEN DO:
           IF INDEX ("0123456789", SUBSTR (n2, ri + 1, 1)) > 0 THEN DO:
             ASSIGN afldn = SUBSTR (n2, 1, ri - 1).
             IF CAN-FIND (DICTDB._Field WHERE DICTDB._Field._Field-name = afldn) THEN 
                OVERLAY (n2, ri, 1) = "_".
           END.
         END.
       END.
    END.

    trunc_name = FALSE.
    IF xlat THEN DO:
       IF DICTDB._Field._Extent > 0 THEN DO:
         ASSIGN max_ext_length = max_id_length - 2 - length(string(DICTDB._Field._Extent)).
         if max_ext_length <> 0 and length(n2) > max_ext_length then do:
           /*  _resxlat will truncate name  */
           put stream logfile unformatted
              "WARNING: Field name " n2 " is longer than the maximum " skip
              "         legal identifier length of " max_id_length "." skip.
             trunc_name = TRUE.
         end.
         n2 = n2 + "," + idbtyp + "," + string (max_ext_length).
         RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n2).
       END.
       ELSE if max_id_length <> 0 and length(n2) > max_id_length then do:
          /*  _resxlat will truncate name  */
          put stream logfile unformatted
              "WARNING: Field name " n2 " is longer than the maximum " skip
              "         legal identifier length of " max_id_length "." skip.
             trunc_name = TRUE.
        end.
        n2 = n2 + "," + idbtyp + "," + string (max_id_length).
        RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n2).
    end.
    else if max_id_length <> 0 and length(n2) > max_id_length then do:
       /*  need to truncate name  */
       put stream logfile unformatted
             "WARNING: Field name " n2 " is longer than the maximum " skip
             "         legal identifier length of " max_id_length "." skip.
       n2 = substring(n2,1,max_id_length).
       trunc_name = TRUE.
    end.
  
    _verify-name:
    DO WHILE TRUE:
      FIND verify-name WHERE verify-name.new-name = n2 NO-ERROR.
      IF NOT AVAILABLE verify-name THEN DO:
        CREATE verify-name.
        ASSIGN verify-name.new-name = n2
               verify-name.prog-name = DICTDB._Field._Field-name.
        LEAVE _verify-name.
      END.
      ELSE DO:
        DO a = 1 TO 999:
          ASSIGN n2 = SUBSTRING(n2, 1, LENGTH(n2) - LENGTH(STRING(a))) + STRING(a).

          IF CAN-FIND(verify-name WHERE verify-name.new-name = n2) THEN NEXT.
          ELSE DO:
            CREATE verify-name.
            ASSIGN verify-name.new-name = n2
                   verify-name.prog-name = DICTDB._Field._Field-name.
            LEAVE _verify-name.
          END.
        END.
      END.    
    END.

    if trunc_name then       
       put stream logfile unformatted 
               "         Truncating field name to " n2 skip(2).         
 
     DO e = MINIMUM(DICTDB._Field._Extent,1)TO MAXIMUM(0,DICTDB._Field._Extent):  /* extent unrolling */

         IF (  ( NOT FIRST(DICTDB._Field._Order) ) 
              OR ( e > MINIMUM(DICTDB._Field._Extent,1) ) )
           THEN PUT STREAM code UNFORMATTED "," SKIP.

      ASSIGN c = ""
             i = DICTDB._Field._dtype.

      /* character data type */ 
      IF i = 1 THEN DO: /* char */  
        IF sqlwidth THEN DO:
          IF DICTDB._Field._Extent = 0 THEN 
            ASSIGN j = DICTDB._Field._Width.
          ELSE
            ASSIGN j = ((DICTDB._Field._Width - (DICTDB._Field._Extent * 2)) / DICTDB._Field._Extent).

            /* OE00172253 - check if value is negative, then assign it the width value unless it's too
               big, in which case we assign the max value allowed for this type.
            */
            IF j <= 0 THEN DO:
                j = DICTDB._Field._Width.
                IF j > longwid THEN
                    j = longwid.
            END.

        END.
        ELSE DO:    

          ASSIGN nbrchar = 0 
                 lngth = LENGTH(DICTDB._Field._format, "character").  
           
          if index(DICTDB._Field._Format, "(") > 1 THEN DO:
             left_paren = INDEX(DICTDB._Field._Format, "(").
             right_paren = INDEX(DICTDB._Field._Format, ")").
             lngth = right_paren - (left_paren + 1).
             assign j = INTEGER(SUBSTRING(DICTDB._Field._Format, left_paren + 1, lngth)).  
          END.  
          ELSE DO:           
               DO z = 1 to lngth:        
                   IF SUBSTRING(DICTDB._Field._Format,z,1) = "9" OR
                        SUBSTRING(DICTDB._Field._Format,z,1) = "N" OR   
                        SUBSTRING(DICTDB._Field._Format,z,1) = "A" OR    
                        SUBSTRING(DICTDB._Field._Format,z,1) = "x" OR
                        SUBSTRING(DICTDB._Field._Format,z,1) = "!"   THEN
                   ASSIGN nbrchar = nbrchar + 1.
                END.         
                IF nbrchar > 0 THEN
                    ASSIGN j = nbrchar.
                ELSE
                    ASSIGN j = lngth.    
          END.                            

          IF DICTDB._Field._Decimals > 0 
            AND can-find(first DICTDB._Db where RECID(DICTDB._Db) = drec_db
                         and DICTDB._Db._Db-type <> "PROGRESS" ) THEN 
            ASSIGN j = DICTDB._Field._Decimals.
          
          IF j = 8 AND sqlwidth = FALSE THEN j = minwdth.
        END.

        IF lUniExpand THEN
            j = j * 2.

        IF j > longwid THEN
             i = 8. /* long char */
        ELSE
          c = " (" + STRING(j * dbe-factor) + ")".
      END.     /*===== character =====*/

      /* If its a logical field that's a key componet, it can't be a bit */

      IF i = 3 AND CAN-FIND (FIRST DICTDB._Index-field WHERE
              DICTDB._Index-field._Field-recid = RECID (DICTDB._Field)) THEN 
         ASSIGN i = 9.
     

      /* Decimal data type */ 
      IF dbtyp = "ORACLE" OR dbtyp = "SYBASE" OR 
         dbtyp = "MS SQL Server" OR dbtyp = "MSSQLSRV7" OR 
         /* 20051214-009 - handle decimals for DB2/400 too */
        (dbtyp = "DB2" and db2type = "DB2/400") THEN DO:
          /* get the size of decimal fields */

          IF i = 5 AND LENGTH(DICTDB._Field._Format) <> 0 THEN DO: 
            IF sqlwidth THEN DO:
              IF DICTDB._Field._Extent = 0 THEN DO:        
                IF dbtyp = "MSSQLSRV7" AND DICTDB._Field._Width > 28 THEN 
                  ASSIGN j = 28.
                ELSE IF dbtyp = "ORACLE" AND DICTDB._Field._Width > 38 THEN
                  ASSIGN j = 38.
                ELSE
                  ASSIGN j = DICTDB._Field._Width.
              END.              
              ELSE DO:              
                ASSIGN j = ((DICTDB._Field._Width - (DICTDB._Field._Extent * 2)) / DICTDB._Field._Extent). 
                IF dbtyp = "MSSQLSRV7" AND j > 28 THEN 
                  ASSIGN j = 28.
                ELSE IF dbtyp = "ORACLE" AND j > 38 THEN
                  ASSIGN j = 38.                
              END.
            END.
            ELSE DO:
              ASSIGN k = 1
                     j = 0. 
              /* get count of significant digits stopping at ".".
               * only count elements that can be considered digits. */
              REPEAT:
                IF k > LENGTH(DICTDB._Field._Format) OR SUBSTR(DICTDB._Field._Format,k,1) = "." THEN 
                   LEAVE. 
                IF SUBSTR(DICTDB._Field._Format,k,1) = ">" OR 
                   SUBSTR(DICTDB._Field._Format,k,1) = "<" OR 
                   SUBSTR(DICTDB._Field._Format,k,1) = "Z" OR 
                   SUBSTR(DICTDB._Field._Format,k,1) = "z" OR 
                   SUBSTR(DICTDB._Field._Format,k,1) = "9" OR 
                   SUBSTR(DICTDB._Field._Format,k,1) = "*" THEN
                     j = j + 1. 

                k = k + 1.
              END. 

              /* Add the scale to the precision. */ 
              j = j + DICTDB._Field._Decimals.
            END.
              /* use the datatype only and not the default type and size */
            ASSIGN  i = 6. 
              /* format the string that will follow the datatype   */
            IF DICTDB._Field._Decimals <> ? THEN
              c = "(" + STRING(j) + "," + STRING(DICTDB._Field._Decimals) + ")".
            ELSE
               c = " ".
          END.  
      END. /*===== decimal =====*/

      /* create shadow columns, char field, case-insens, and a key componet */

      IF shadow AND  i = 1 AND DICTDB._Field._Fld-case = FALSE AND
          CAN-FIND (FIRST DICTDB._Index-field WHERE
                    DICTDB._Index-field._Field-recid = RECID (DICTDB._Field))THEN 
      _Shadow_Block:
      DO:

        /* Make sure that there is at least one NON-Word index this 
         * field is participating in.  If all the indexes it is in are 
         * word indexes, then we must skip creating the shadow columns. */ 
         
         ASSIGN shadow_is_valid = false. 
         for each DICTDB._Index-field where DICTDB._Index-field._Field-recid = RECID(DICTDB._Field):
           find DICTDB._Index where RECID(DICTDB._Index) = DICTDB._Index-field._Index-recid 
                                and DICTDB._Index._Wordidx <> 1 NO-ERROR.

           if available(DICTDB._Index) then do: 
             ASSIGN shadow_is_valid = true. 
             leave.
           end. 
         end. 

         if not shadow_is_valid then leave _Shadow_Block. 

          IF LENGTH (uc_col) > 0 THEN
            uc_col = uc_col + ",".
          uc_col = uc_col + n2.

        IF dbtyp = "SYBASE" OR dbtyp = "MS SQL Server" OR
           dbtyp = "MSSQLSRV7" THEN 
          PUT STREAM code UNFORMATTED
             comment_chars "  _S#_" n2 
             (if e = 0 then "" else unik + string(e))
             " " user_env[i + 10] c "," SKIP.         
        ELSE
          PUT STREAM code UNFORMATTED comment_chars " "
             comment_chars " U" unik n2  
             (IF e = 0 THEN "" ELSE unik + STRING(e)) 
             " " user_env[i + 10] c 
              (IF DICTDB._Field._Mandatory THEN " NOT NULL" ELSE "") "," SKIP.
            
      END. /* end of creation of shadow columns  _Shadow_Block */ 
      
      /* Oracle and the RAW data type must be recognized so that proper one 
        is put into the script.  They are also supporting BLOBS.
      */
      IF dbtyp = "ORACLE" AND (DICTDB._Field._Dtype = 8 OR DICTDB._Field._Dtype > 17 ) 
          AND DICTDB._Field._Dtype NE 41 /*int64 */ THEN DO: 
        IF DICTDB._Field._Dtype = 8 THEN
          PUT STREAM code UNFORMATTED
           comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e)) 
           " " "long raw".    
        ELSE IF DICTDB._Field._Dtype = 18 THEN
          PUT STREAM CODE UNFORMATTED
          comment_chars "  " n2 " blob not null".
        ELSE IF DICTDB._Field._Dtype = 19 THEN
          PUT STREAM CODE UNFORMATTED
            comment_chars "  " n2  (IF user_env[11] = "NVARCHAR2" THEN " nclob" ELSE " clob")
            " not null".
        ELSE IF DICTDB._Field._Dtype = 34 /*datetime*/ THEN
            PUT STREAM CODE UNFORMATTED
             comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e)) " timestamp".
        ELSE IF DICTDB._Field._Dtype = 40 /*datetime-tz*/ THEN
            PUT STREAM CODE UNFORMATTED
             comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e)) " timestamp with time zone".
        ELSE  
          PUT STREAM CODE UNFORMATTED comment_chars "  " n2 " UNSUPPORTED-" DICTDB._Field._Data-type.          
      END.
      ELSE IF dbtyp = "PROGRESS" AND DICTDB._Field._Dtype > 17 THEN DO:
          IF DICTDB._Field._DType = 18 THEN
            PUT STREAM CODE UNFORMATTED
            comment_chars "  " n2 " blob".
          ELSE IF DICTDB._Field._Dtype = 19 THEN
            PUT STREAM CODE UNFORMATTED
              comment_chars "  " n2  " clob".
          ELSE IF DICTDB._Field._Dtype = 20 THEN
            PUT STREAM CODE UNFORMATTED
            comment_chars "  " n2  " xlob".
          ELSE IF DICTDB._Field._Dtype = 34 THEN
            PUT STREAM CODE UNFORMATTED
            comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e)) " datetime".
          ELSE IF DICTDB._Field._Dtype = 40 THEN
            PUT STREAM CODE UNFORMATTED
            comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e)) " datetime-tz".
          ELSE IF DICTDB._Field._Dtype = 41 THEN
            PUT STREAM CODE UNFORMATTED
            comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e)) " int64".
      END.
      ELSE IF DICTDB._Field._Dtype > 17 AND dbtyp <> "PROGRESS" THEN DO:
        IF DICTDB._Field._Dtype EQ 41 /*int64 */ THEN DO:
            PUT STREAM code UNFORMATTED
             comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e)) 
                /* extent unrolling */
             " "  (IF dbtyp = "ORACLE" THEN "number" ELSE "bigint")
                /*char,date,log,int,deci,deci0,recid,lchar,tinyint*/
             c. /* (n,m) */
        END.
        ELSE IF dbtyp = "MSSQLSRV7" AND DICTDB._Field._Dtype EQ 34 /* datetime */ THEN DO:
            PUT STREAM code UNFORMATTED
             comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e))
             (IF mssNewDTTypes THEN " datetime2(3)" ELSE " datetime")
             c. /* (n,m) */
        END.
        ELSE IF dbtyp = "MSSQLSRV7" AND DICTDB._Field._Dtype EQ 40 /* datetime-tz */ AND 
            mssNewDTTypes THEN DO:
            PUT STREAM code UNFORMATTED
             comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e))
             " datetimeoffset(3)"
             c. /* (n,m) */
        END.
        ELSE IF dbtyp = "MSSQLSRV7" AND DICTDB._Field._Dtype EQ 18 /* BLOB */ THEN DO:
            PUT STREAM CODE UNFORMATTED
            comment_chars "  " n2 " varbinary(max)".
        END.
        ELSE
           PUT STREAM CODE UNFORMATTED
               comment_chars "  " n2 " UNSUPPORTED-" DICTDB._Field._Data-type.       
      END.
      ELSE
        PUT STREAM code UNFORMATTED
         comment_chars "  " n2 (IF e = 0 THEN "" ELSE unik + STRING(e)) 
            /* extent unrolling */
         " " user_env[i + 10] 
            /*char,date,log,int,deci,deci0,recid,lchar,tinyint*/
         c. /* (n,m) */

      IF pfmt THEN DO:
        IF DICTDB._Field._dtype = 1 THEN PUT STREAM code UNFORMATTED
            " " TRIM(STRING(_Fld-case,"/NOT")) " CASE-SENSITIVE".
        RUN "prodict/_dctquot.p" (_Format,"'",OUTPUT c).
        PUT STREAM code UNFORMATTED " FORMAT " c.
        IF DICTDB._Field._Label <> ? AND DICTDB._Field._Label <> "" THEN DO:
          RUN "prodict/_dctquot.p"
            (_Label + (IF e > 0 THEN "[" + STRING(e) + "]" ELSE ""),
            "'",OUTPUT c).
          PUT STREAM code UNFORMATTED " LABEL " c.
        END.
        IF DICTDB._Field._Col-label <> ? AND DICTDB._Field._Col-label <> "" THEN DO:
          RUN "prodict/_dctquot.p"
            (_Col-label + (IF e > 0 THEN "[" + STRING(e) + "]" ELSE ""),
            "'",OUTPUT c).
          PUT STREAM code UNFORMATTED " COLUMN-LABEL " c.
        END.
      END.

      IF DICTDB._Field._Data-type = "character" AND sdef AND 
          (dbtyp = "ORACLE" OR dbtyp = "MSSQLSRV7") AND blankdefault AND
         (DICTDB._Field._Initial = ? OR Dictdb._field._Initial = " " OR DICTDB._Field._Initial = "?") THEN
            PUT STREAM code UNFORMATTED " DEFAULT ' ' ".
  
      /* Put default values */
      IF sdef AND (DICTDB._Field._Initial <> ? AND Dictdb._field._Initial <> " " AND DICTDB._Field._Initial <> "?" )THEN DO:      
          c = DICTDB._Field._Initial. 
         IF DICTDB._Field._Data-type = "DATE" OR 
            DICTDB._Field._Data-type BEGINS "DATETIME" THEN DO:
           IF UPPER(c) = "TODAY" OR UPPER(c) = "NOW" THEN DO:        
             IF dbtyp = "ORACLE" THEN
               ASSIGN c = "SYSDATE".
             ELSE IF dbtyp = "MSSQLSRV7" THEN DO:
                IF mssNewDTTypes AND DICTDB._Field._Data-type BEGINS "DATETIME" THEN DO:
                   IF DICTDB._Field._Data-type = "DATETIME" THEN
                      ASSIGN c = "SYSDATETIME()".
                   ELSE /* must be datetime-tz */
                      ASSIGN c = "SYSDATETIMEOFFSET()".
                END.
                ELSE IF DICTDB._Field._Data-type NE "DATETIME-TZ" THEN
                     ASSIGN c = "GETDATE()".
                ELSE
                    ASSIGN c = "".
             END.
             ELSE IF dbtyp = "DB2" and db2type = "DB2/400" THEN 
	       ASSIGN c = "CURRENT DATE".
	     ELSE IF dbtyp = "PROGRESS" THEN.  /* OK to leave TODAY/NOW for OpenEdge */
             ELSE 
               ASSIGN c = "".
           END.
           ELSE
             ASSIGN c = "".
         END.
         IF DICTDB._Field._dtype = 3 THEN DO:
            ASSIGN slash = INDEX("/", Dictdb._Field._Format).
            IF UPPER(c) = UPPER(SUBSTRING(Dictdb._Field._Format,1, (slash - 1))) OR
               UPPER(c) BEGINS "Y" OR UPPER(c) BEGINS "T" THEN
                  ASSIGN c = "1".
            ELSE IF UPPER(c) = UPPER(SUBSTRING(Dictdb._Field._Format,(slash + 1))) OR
               UPPER(c) BEGINS "N" OR UPPER(c) BEGINS "F"  THEN  
                  ASSIGN c = "0".
            ELSE
              ASSIGN c = "".               
         END.
         ELSE IF DICTDB._Field._dtype = 4 THEN
           ASSIGN c = DICTDB._Field._Initial.
         ELSE IF DICTDB._Field._dtype = 5 THEN DO:
           ASSIGN c = DICTDB._Field._Initial.
           IF INDEX(c, ",") > 0 THEN DO:           
             DO k = 1 TO LENGTH(c):
               IF INDEX(c, ",") > 0 THEN
                 ASSIGN c = SUBSTRING(c, 1, (INDEX(c, ",") - 1)) +  
                            SUBSTRING(c, (INDEX(c, ",") + 1)).
               ELSE
                 ASSIGN k = LENGTH(c).
             END.
           END.           
         END.
         IF DICTDB._Field._Data-type = "character" THEN DO:
           RUN "prodict/_dctquot.p" (_Initial,"'",OUTPUT c).        
           IF c <> " "  AND c <> "0" THEN         
              PUT STREAM code UNFORMATTED " DEFAULT " c.  
         END.    
         ELSE IF c <> " " AND CAN-DO("logical,date,datetime,datetime-tz",DICTDB._Field._Data-type) THEN
              PUT STREAM code UNFORMATTED " DEFAULT " c. 
         ELSE IF  c <> " " AND c <> ? THEN
             PUT STREAM code UNFORMATTED " DEFAULT " c.    
      END.
     
      IF dbtyp = "ORACLE" OR dbtyp = "PROGRESS" THEN DO:
        IF DICTDB._Field._Mandatory 
           THEN PUT STREAM code UNFORMATTED " NOT NULL".
           

         /* The following code will find if the DICTDB._Field is part of a primary unique
         ** Index for the table.   This test should be done for the demo database
         ** because there are NO mandatory fields in the demo database.*/
         
        ELSE IF not compatible THEN DO:  /* add "NOT NULL" if is part of the primary index */
           IF CAN-FIND(DICTDB._Index-field
                        where DICTDB._Index-field._Field-recid = recid(DICTDB._Field) 
                          and CAN-FIND(DICTDB._Index where recid(DICTDB._Index) =
                                                           DICTDB._Index-field._Index-recid 
                                                       and CAN-FIND(DICTDB._File
                                                           where DICTDB._File._Prime-Index =
                                                                  recid(DICTDB._Index))))
            THEN
                PUT STREAM code UNFORMATTED
                    " NOT NULL".
        END.     /* add "not null" if is part of the primary index */
      END.     /* oracle or PROGRESS */
      ELSE IF (dbtyp = "SYBASE" OR dbtyp = "MS SQL Server" OR 
              dbtyp = "MSSQLSRV7") AND NOT unsprtdt THEN 
        PUT STREAM code UNFORMATTED
          (if DICTDB._Field._Mandatory OR (i <= 9 /*not int64 */ AND user_env[i + 10] = "bit") 
           then " not null" else " null").
      ELSE IF (db2type <> ? AND db2type <> "")  AND DICTDB._Field._Mandatory THEN
          PUT STREAM code UNFORMATTED " NOT NULL".
    END.     
  END. /* FOR EACH DICTDB._Field OF DICTDB._File BREAK BY DICTDB._Field._Order */

  FOR EACH DICTDB._Index of DICTDB._File WHERE DICTDB._Index._Index-name BEGINS "sql-uniq":
    PUT STREAM code UNFORMATTED "," SKIP "  UNIQUE (".
    FOR EACH DICTDB._Index-field OF DICTDB._Index,DICTDB._Field OF DICTDB._Index-field
      BREAK BY DICTDB._Index-field._Index-seq:
        n2 = DICTDB._Field._Field-name.

        /* Avoid collisions with unrolled extents */

        ri = R-INDEX (n2, "#").
        IF ri > 2 AND ri < LENGTH (n2) THEN DO:
           IF INDEX ("0123456789", SUBSTR (n2, ri + 1, 1)) > 0 THEN DO:
              afldn = SUBSTR (n2, 1, R-INDEX (n2, "#") - 1).
              IF CAN-FIND (DICTDB._Field WHERE DICTDB._Field._Field-name = afldn) THEN DO:
                OVERLAY (n2, R-INDEX (n2, "#"), 1) = "_".
              END.
           END.
        END.

        IF xlat THEN DO:
           n2 = n2 + "," + idbtyp + "," + string (max_id_length).
           RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n2).
        end.
        else if max_id_length <> 0 and length(n2) > max_id_length then 
            /*  need to truncate name  */
          n2 = substring(n2,1,max_id_length).

        PUT STREAM code UNFORMATTED n2 (IF LAST(_Index-seq) THEN ")" ELSE ",").
    END. /* end of each _index_field */
  END. /* FOR EACH DICTDB._Index of DICTDB._File WHERE DICTDB._Index._Index-name BEGINS "sql-uniq" */

  IF compatible THEN DO: 
    IF dbtyp = "Informix" THEN  
      PUT STREAM code UNFORMATTED "," SKIP comment_chars "  " prowid_col " " user_env[14] " default null".      
    ELSE IF dbtyp = "MS SQL Server" OR dbtyp = "MSSQLSRV7" OR dbtyp = "SYBASE" THEN DO:
      IF ((NUM-ENTRIES(user_env[27]) < 2) OR (entry(2,user_env[27]) EQ "1")) THEN 
        PUT STREAM code UNFORMATTED "," SKIP comment_chars "  " prowid_col " bigint null". 
      ELSE IF entry(2,user_env[27]) EQ "2" THEN DO: 
        PUT STREAM code UNFORMATTED "," SKIP comment_chars "  "   prowid_col " AS  " skip
               "      CASE WHEN PROGRESS_RECID_ALT_ is null " skip 
               "        THEN  PROGRESS_RECID_IDENT_ " skip
               "        ELSE  PROGRESS_RECID_ALT_   " skip
               "      END PERSISTED not null". 
      END. /* END of entry(2,user_env[27]) EQ "2"  */
    END. /* END of dbtyp is MSS/SYBASE */

    ELSE IF dbtyp = "DB2" and db2type = "DB2/400"  THEN DO: 
             IF entry(2,user_env[27]) EQ "1" THEN
                 PUT STREAM code UNFORMATTED "," SKIP comment_chars "  " prowid_col " bigint  " skip  
                      "  GENERATED ALWAYS AS IDENTITY " skip
                      "  (START WITH 1 INCREMENT BY 1 " skip
                      "  NO MINVALUE "                  skip
                      "  MAXVALUE 9223372036854775807 " skip
                      "  NO ORDER "                     skip
                      "  CACHE 20)" .
            ELSE IF entry(2,user_env[27]) EQ "2"   THEN DO: 
             /* OE00177721- Find tables without unique key- If no unique key, create RECID column */
             FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Unique = TRUE NO-ERROR.
             IF AVAILABLE DICTDB._Index THEN ASSIGN unique_idx_flag = TRUE.
             ELSE 
                 PUT STREAM code UNFORMATTED "," SKIP comment_chars "  " prowid_col " bigint  " skip  
                      "  GENERATED ALWAYS AS IDENTITY " skip
                      "  (START WITH 1 INCREMENT BY 1 " skip
                      "  NO MINVALUE "                  skip
                      "  MAXVALUE 9223372036854775807 " skip
                      "  NO ORDER "                     skip
                      "  CACHE 20)" .
             END. /* END of entry(2,user_env[27]) EQ "2"  */
    END. /* END of dbtyp = DB2 */
    ELSE
      PUT STREAM code UNFORMATTED "," SKIP comment_chars "  " prowid_col " " user_env[14] " null". 
      
    IF dbtyp = "MS SQL Server" OR dbtyp = "MSSQLSRV7" OR dbtyp = "SYBASE" THEN DO:  
      PUT STREAM code UNFORMATTED "," SKIP.
      PUT STREAM code UNFORMATTED comment_chars "  " prowid_col "_IDENT_ bigint identity".

      IF (NUM-ENTRIES(user_env[27]) >= 2) AND (entry(2,user_env[27]) EQ "2")   THEN DO :
        PUT STREAM code UNFORMATTED "," SKIP.
        PUT STREAM code UNFORMATTED comment_chars "  " prowid_col "_ALT_ bigint NULL default NULL".
        PUT STREAM code UNFORMATTED "," SKIP.

        /* unique constraint name */
        ASSIGN n2 = prowid_col.
        IF user_env[6] = "Y" THEN 
          n2 = n1 + unik + n2. 

        IF xlat THEN DO:
           if max_idx_len <> 0 and length(n2) > max_idx_len then 
                 ASSIGN trunc_name = TRUE.
           n2 = n2 + "," + idbtyp + "," + string (max_idx_len).
           RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n2).
        END.

        PUT STREAM code UNFORMATTED comment_chars "  CONSTRAINT "
              n2 " UNIQUE (" prowid_col ")".
      END. /* END of entry(2,user_env[27]) EQ "2"  */

    END.
  END.  
  
  PUT STREAM code UNFORMATTED SKIP comment_chars ")".

  IF skptrm THEN 
     PUT STREAM code UNFORMATTED SKIP.
  IF dbtyp = "ORACLE" AND user_env[34] <> ? AND user_env[34] <> "" THEN 
     PUT STREAM code UNFORMATTED SKIP comment_chars "TABLESPACE " user_env[34].
     
  PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.

  pindex = "".

  /* If this is sybase or MS SQL Server, we must add an insert trigger to set 
     the value of the progress_recid and fill out any case insensitive 
     shadow columns.
  */ 
  IF (dbtyp = "SYBASE" OR dbtyp = "MS SQL Server") and compatible THEN DO:
    n2 = "_TI_" + n1.
    
    PUT STREAM code UNFORMATTED
      comment_chars " "  skip    
      comment_chars "create trigger " n2 " ON " n1 " for insert as" SKIP
      comment_chars "begin" SKIP
      comment_chars "    if  ( select max(inserted." prowid_col ") from inserted) is NULL" SKIP
      comment_chars "    begin" SKIP
      comment_chars "        update " n1 " set " prowid_col " = @@identity " SKIP
      comment_chars "               where " prowid_col " is NULL" skip
      comment_chars "        select convert (bigint, @@identity)" SKIP
      comment_chars "    end" SKIP.    
      
    /* end the insert trigger's code */
    PUT STREAM code UNFORMATTED comment_chars "end".

    IF skptrm THEN
      PUT STREAM code UNFORMATTED SKIP.
    PUT STREAM code UNFORMATTED  comment_chars user_env[5] SKIP.
  END.
  ELSE  IF dbtyp = "MSSQLSRV7" and compatible and (entry(2,user_env[27]) EQ "1") THEN DO:
    n2 = "_TI_" + n1.
    
    PUT STREAM code UNFORMATTED
      comment_chars " "  skip    
      comment_chars "create trigger " n2 " ON " n1 " for insert as" SKIP
      comment_chars " RAISERROR ('PSC-init',0,1) " SKIP    
      comment_chars " SET XACT_ABORT ON " SKIP    
      comment_chars " SET LOCK_TIMEOUT -1 " SKIP    
      comment_chars "    if  ( select " prowid_col " from inserted) is NULL" SKIP
      comment_chars "    begin" SKIP
      comment_chars "        update t set " prowid_col " = i.IDENTITYCOL " SKIP
      comment_chars "         from " n1 " t  JOIN inserted i ON " skip
      comment_chars "         t.PROGRESS_RECID_IDENT_ = i.PROGRESS_RECID_IDENT_" SKIP
      comment_chars "        select convert (bigint, @@identity)" SKIP
      comment_chars "    end" SKIP    
      comment_chars " SET XACT_ABORT OFF " SKIP    
      comment_chars " RAISERROR ('PSC-end',0,1) " SKIP.    

    IF skptrm THEN
      PUT STREAM code UNFORMATTED SKIP.
    PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
  END. /* dbtyp = "SYBASE" OR "MS SQL Server" and compatible */

  IF user_env[3] <> "" THEN DO:
    OUTPUT STREAM code CLOSE.
    OUTPUT STREAM code TO VALUE(user_env[3]) NO-ECHO APPEND NO-MAP.
  END.

  /* Create unique progress_recid index */
 
  IF  compatible THEN DO:
    IF dbtyp = "ORACLE"  THEN DO:
      IF LENGTH(n1) < 15 THEN
        ASSIGN n2 = n1 + unik + prowid_col.
      ELSE
        ASSIGN n2 = n1.  
    END.
    ELSE DO:  
      ASSIGN n2 = prowid_col.
      IF user_env[6] = "Y" THEN n2 = n1 + unik + n2. /* unique index names */
      IF xlat THEN DO:
         if max_idx_len <> 0 and length(n2) > max_idx_len then 
               ASSIGN trunc_name = TRUE.
         n2 = n2 + "," + idbtyp + "," + string (max_idx_len).
         RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n2).
      END.
    END.
    IF dbtyp = "MSSQLSRV7" THEN DO:
      IF (entry(2,user_env[27]) EQ "1") THEN DO:
        PUT STREAM code UNFORMATTED comment_chars "CREATE INDEX "
              n2 " ON " n1 " (" prowid_col ")".
       
        ASSIGN n2 = n2 + "_ident_".
        PUT STREAM code UNFORMATTED SKIP .
        PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
        PUT STREAM code UNFORMATTED comment_chars "CREATE UNIQUE INDEX "
              n2 " ON " n1 " (" prowid_col "_IDENT_ )".
      END.
    END.
    ELSE IF dbtyp = "DB2" AND db2type = "DB2/400"  THEN DO: 
        IF NOT unique_idx_flag THEN
           PUT STREAM code UNFORMATTED comment_chars "CREATE UNIQUE INDEX "
             user_library dot n2 " ON " user_library dot n1 " (" prowid_col ")". /* OE00189366 */
        ELSE .
    END. 
    ELSE 
       PUT STREAM code UNFORMATTED comment_chars "CREATE UNIQUE INDEX "
              n2 " ON " n1 " (" prowid_col ")".
  
    IF skptrm THEN
        PUT STREAM code UNFORMATTED SKIP comment_chars.
        
    IF dbtyp = "ORACLE" AND user_env[35] <> ? AND user_env[35] <> "" THEN
      PUT STREAM code UNFORMATTED SKIP comment_chars "TABLESPACE " user_env[35].

    IF (dbtyp = "MSSQLSRV7") THEN DO:
      IF ((NUM-ENTRIES(user_env[27]) < 2) OR (entry(2,user_env[27]) EQ "1")) then 
        PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
    END.
    ELSE 
        PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
  END.



  _idxloop:
  FOR EACH DICTDB._Index OF DICTDB._File
    WHERE NOT DICTDB._Index._Index-name BEGINS "sql-"
      AND NOT DICTDB._Index._Index-name = "default": /* eliminate empty idxs */
      
    n2 = DICTDB._Index._Index-name.
    
    if DICTDB._Index._Wordidx = 1 then do:
      PUT STREAM logfile UNFORMATTED 
         "++ " skip 
         "WARNING: INDEX " n2 " not created." skip 
          " " skip
          "         Cannot create index " n2 " because it is a " skip
          "         WORD index. " skip
          "-- " skip.
         ASSIGN comment_chars = user_env[31]
                warnings_issued = true.
       NEXT  _idxloop.  
    END.
    trunc_name = FALSE.

    IF xlat THEN DO:
       if max_idx_len <> 0 and length(n2) > max_idx_len then 
                trunc_name = TRUE.
       n2 = n2 + "," + idbtyp + "," + string (max_idx_len).
       RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n2).
    end.
    else if max_idx_len <> 0 and  length(n2) > max_idx_len then 
          /*  need to truncate name  */
       ASSIGN n2 = substring(n2,1,max_idx_len)
              trunc_name = TRUE.
 
    /* 
        Check that the index name is not longer than the max, and if 
        so then fix it.  First we check if n2 + unik, are under the max, 
        and if so we add them to a substring of n1, otherwise we 
        widdle n2 down in a repeat loop, and then concatinate the 
        smaller n2 with a substring of n1 and the unik.
        ***  There is a problem here, because the fixup will not find
                and index with this name
    */ 

    IF user_env[6] = "Y" THEN DO:    /* need unique names, so create/check len*/
      IF max_idx_len > 0 THEN DO:    /* We have a max len so check it */
        IF LENGTH(n1) + LENGTH(n2) + LENGTH(unik) > max_idx_len THEN DO:
          IF LENGTH(n2) + LENGTH(unik) < max_idx_len THEN  /* easy way */
             ASSIGN n2 = SUBSTRING(n1,1,max_idx_len - LENGTH(n2) - LENGTH(unik)) + unik + n2
                    trunc_name = TRUE.               
          
          ELSE DO:  /* Then, we have to knock some chars off of n2 as well */
            REPEAT:
              n2 =  SUBSTRING (n2,1, LENGTH(n2) - 1).       
              IF LENGTH(n2) + LENGTH(unik) < max_idx_len THEN
              LEAVE.   /* This what we want */
            END.  
            ASSIGN n2 = SUBSTRING(n1,1,max_idx_len - LENGTH(n2) - LENGTH(unik)) + unik + n2
                   trunc_name = TRUE.              
          END.  
        END. /* Done with length checking */
        ELSE  /*string was okay in the first place */
          ASSIGN n2 = n1 + unik + n2. 
      END. 
      ELSE  /* No need to check for length */
        ASSIGN n2 = n1 + unik + n2.         
    END.  
  
    FIND FIRST verify-index WHERE verify-index.new-name = n2 NO-ERROR.
    IF NOT AVAILABLE verify-index THEN DO:
      CREATE verify-index.
      ASSIGN verify-index.new-name = n2.
    END.
    ELSE DO:
      DO WHILE AVAILABLE verify-index:
        ASSIGN n2 = SUBSTRING(n2, 1, (length(n2) - 1)).
        FIND FIRST verify-index WHERE verify-index.new-name = n2 NO-ERROR.  
      END.
      CREATE verify-index.
      ASSIGN verify-index.new-name = n2
             trunc_name = TRUE.
    END.
 
    if trunc_name then do:
      put stream logfile unformatted 
        "WARNING: Index name too long. Name truncated to " max_idx_len skip
        "         characters.  New index name = " n2 skip(2).
        warnings_issued = true.
    END. 

    /* Index block:
     **
     **     This block contains all appropriate index validation for 
     **     creation of indexes in the foreign data manager. */ 
    _Index_Block: 
    DO: 

      /* Make sure we check indexes.  If we run across an invalid index we 
       * can stop further index checking by setting this variable to false. 
     */
      
      ASSIGN index_checking = true. 

      IF NOT comment_all_objects THEN comment_chars = "". 
 
     /* Do not allow descending indexes with Sybase or MS SQL Server 6.  
        It doesn't do them so we shouldn't create them.
     */
     IF (dbtyp = "SYBASE" OR dbtyp = "MS SQL Server" OR 
        (dbtyp = "MSSQLSRV7" and user_env[34] = "n")) AND index_checking THEN DO: 
       FIND FIRST DICTDB._Index-field of DICTDB._Index
           WHERE NOT DICTDB._Index-field._Ascending NO-ERROR.
       IF AVAILABLE(DICTDB._Index-field) THEN DO:
          FIND FIRST DICTDB._Field
               WHERE RECID(DICTDB._Field) = DICTDB._Index-Field._Field-recid.
         
           PUT STREAM logfile UNFORMATTED 
             "++ " skip 
             "WARNING: INDEX " n2 " not created." skip
             " " skip
             "         Cannot create index " n2 " because it contains " skip
             "         a decending component " DICTDB._Field._Field-name "." SKIP
             "-- " skip.
             
           ASSIGN comment_chars = user_env[31]
                  warnings_issued = true
                  index_checking = false. 
       END. 
     END. 


      /* Don't allow indexes with text or long / clob datatypes */ 
      if index_checking then do: 
        ASSIGN maxidxcollen = 0.
        for each DICTDB._Index-field of DICTDB._Index, 
            each DICTDB._Field of DICTDB._Index-field where DICTDB._Field._Data-Type = "character": 

            lngth = LENGTH(DICTDB._Field._format, "character").  
           
            if index(DICTDB._Field._Format, "(") > 1 THEN DO:
               left_paren = INDEX(DICTDB._Field._Format, "(").
               right_paren = INDEX(DICTDB._Field._Format, ")").
               lngth = right_paren - (left_paren + 1).
               assign j = INTEGER(SUBSTRING(DICTDB._Field._Format, left_paren + 1, lngth)).  
            END.  
            else
              j = lngth.
            IF DICTDB._Field._Decimals > 0 THEN j = DICTDB._Field._Decimals.
                  
            IF j > 255 AND (dbtyp = "SYBASE" or dbtyp = "MS SQL Server") THEN DO:  
              PUT STREAM logfile UNFORMATTED
                   "++ " skip 
                   "WARNING: INDEX " n2 " not created." skip
                   " " skip 
                   "         Cannot create index " n2 " because it contains " skip
                   "         column " DICTDB._Field._Field-name " which cannot be ".

              PUT STREAM logfile UNFORMATTED
                       " indexed by SQL Server" skip
                       "         because it has data type text." skip. 
              PUT STREAM logfile UNFORMATTED
                   "-- " skip.
              ASSIGN comment_chars = user_env[31]
                      warnings_issued = true
                      index_checking = false.
              
            END.       
            ELSE IF j > 900 AND dbtyp = "MSSQLSRV7" THEN DO:  
              PUT STREAM logfile UNFORMATTED
                   "++ " skip 
                   "WARNING: INDEX " n2 " not created." skip
                   " " skip 
                   "         Cannot create index " n2 " because it contains " skip
                   "         column " DICTDB._Field._Field-name " which cannot be ".

              PUT STREAM logfile UNFORMATTED
                       " indexed by MS SQL Server 7" skip
                       "         because it has data type text." skip. 
              PUT STREAM logfile UNFORMATTED
                   "-- " skip.
              ASSIGN comment_chars = user_env[31]
                      warnings_issued = true
                      index_checking = false.
              
            END.       
            ELSE IF dbtyp = "ORACLE" AND j > longwid /*4000*/ then DO:  
              PUT STREAM logfile UNFORMATTED
                   "++ " skip 
                   "WARNING: INDEX " n2 " not created." skip
                   " " skip 
                   "         Cannot create index " n2 " because it contains " skip
                   "         column " DICTDB._Field._Field-name " which cannot be ".
              PUT STREAM logfile UNFORMATTED
                       " indexed by Oracle" skip
                       "         because it has data type " user_env[18] /*" long"*/ "." skip. 

              PUT STREAM logfile UNFORMATTED
                   "-- " skip.
              ASSIGN comment_chars = user_env[31]
                      warnings_issued = true
                      index_checking = false.
               
            END.  /* end of longwid (formely 4000) */ 
            IF dbtyp = "MSSQLSRV7" THEN 
                ASSIGN maxidxcollen = maxidxcollen + j.
        end. /* end of for each */ 
        IF dbtyp = "MSSQLSRV7" AND maxidxcollen > 900 THEN DO:
           PUT STREAM logfile UNFORMATTED "++ " SKIP 
             "WARNING: INDEX " n2 " not created." skip
             " " skip 
             "         Cannot create index " n2 " because it's length is greater than 900. " SKIP
             "-- " skip.

            ASSIGN comment_chars = user_env[31]
                   warnings_issued = true
                   index_checking = false.
             
          END.       
      end. /* end of text and long dbtyp test */ 


      IF DICTDB._File._Prime-index = RECID (DICTDB._Index) THEN
         pindex = comment_chars + "sp_primarykey " + n1.

      PUT STREAM code UNFORMATTED
        comment_chars "CREATE" (IF DICTDB._Index._Unique THEN " UNIQUE" ELSE "")
        " INDEX " user_library dot n2 " ON " user_library dot n1 " (".
      
      FOR EACH DICTDB._Index-field OF DICTDB._Index,
             DICTDB._Field OF DICTDB._Index-field 
             BREAK BY DICTDB._Index-field._Index-seq:
        n2 = DICTDB._Field._Field-name.

        /* Avoid collisions with unrolled extents */

        ri = R-INDEX (n2, "#").
        IF ri > 2 AND ri < LENGTH (n2) THEN DO:
           IF INDEX ("0123456789", SUBSTR (n2, ri + 1, 1)) > 0 THEN DO:
              afldn = SUBSTR (n2, 1, R-INDEX (n2, "#") - 1).
              IF CAN-FIND (DICTDB._Field WHERE DICTDB._Field._Field-name = afldn) THEN DO:
                 OVERLAY (n2, R-INDEX (n2, "#"), 1) = "_".
              END.
          END.
        END.

        IF xlat THEN DO:
          FIND FIRST verify-name WHERE verify-name.prog-name = DICTDB._Field._Field-name.
          IF AVAILABLE verify-name THEN
            ASSIGN n2 = verify-name.new-name.
          ELSE DO:          
            n2 = n2 + "," + idbtyp + "," + string (max_id_length).
            RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n2).
          END.
        end.
        else if max_id_length <> 0 and length(n2) > max_id_length then 
               /*  need to truncate name  */
               n2 = substring(n2,1,max_id_length).
        
        IF (dbtyp = "SYBASE" OR dbtyp = "MS SQL Server" OR dbtyp = "MSSQLSRV7") THEN DO:
          IF LOOKUP(n2, uc_col) > 0 THEN 
              ASSIGN n2 = "_S#_" + n2. 
        END.
        ELSE     
          IF LOOKUP(n2, uc_col) > 0 THEN 
             ASSIGN n2 = "U" + unik + n2.
        
        IF dbtyp = "ORACLE" THEN DO:
            IF NOT shadow AND DICTDB._Field._Dtype = 1 /*AND longwid = 4000*/ AND NOT DICTDB._Field._fld-case THEN
                ASSIGN n2 = "upper(" + n2 + ") ".
            IF NOT DICTDB._Index-field._Ascending THEN
                ASSIGN n2 = n2 + " DESC".
        END.
        IF dbtyp = "MSSQLSRV7" AND user_env[34] = "y" THEN DO:
           IF NOT DICTDB._Index-field._Ascending THEN
                ASSIGN n2 = n2 + " DESC".
        END.
        IF DICTDB._Field._For-type = "TIME" THEN 
           assign n2 = "".

        else IF DICTDB._File._Prime-index = RECID (DICTDB._Index)
          THEN pindex = pindex + ", " + n2.

        
           

        PUT STREAM code UNFORMATTED n2.
        IF LAST(_Index-seq) THEN DO:
          IF DICTDB._Index._Unique 
             or dbtyp = "PROGRESS"   
             or not compatible       /* progress_recid not available in PROGRESS */ 
             or (dbtyp = "DB2" and db2type = "DB2/400" and
                 entry(2,user_env[27]) EQ "2" and unique_idx_flag) THEN 
                PUT STREAM code UNFORMATTED ")".     
                                                     /* hutegger 94/06 */
          ELSE IF compatible THEN DO:
             IF DICTDB._File._Prime-index = RECID (DICTDB._Index) THEN
                pindex = pindex + ", " + prowid_col.
             PUT STREAM code UNFORMATTED ", " prowid_col ")".
          END. /* compatible */ 
        END. /* last (_Index-seq) */
        ELSE
        PUT STREAM code UNFORMATTED ", ".
      END. /* for each DICTDB._index-field  */ 
      IF skptrm THEN
         PUT STREAM code UNFORMATTED SKIP comment_chars.
      IF dbtyp = "ORACLE" AND user_env[35] <> ? AND user_env[35] <> "" THEN
         PUT STREAM code UNFORMATTED SKIP comment_chars "TABLESPACE " user_env[35].         
      PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.
    END.  /* Index Block */ 

  END.

  IF user_env[3] <> "" THEN DO:
    OUTPUT STREAM code CLOSE.
    OUTPUT STREAM code TO VALUE(user_env[2]) NO-ECHO APPEND NO-MAP.
  END.

END. /* for each DICTDB._File */

/* creating SEQT_REV_SEQTMGR table for revised sequence generator for MSS if one does not exist. */
IF lnewSeq THEN DO:
put stream code unformatted 
    " if not exists (select * from dbo.sysobjects where id = object_id(N'_SEQT_REV_SEQTMGR') " skip
    "    and OBJECTPROPERTY(id, N'IsTable') = 1)" skip
           "create table _SEQT_REV_SEQTMGR (" skip
           "        seq_name varchar(30) not null, " skip
	   "        initial_value bigint, " skip
	   "        increment_value bigint, " skip
	   "        upper_limit bigint, " skip
	   "        cycle bit not null )" skip 
           " " skip.
END.

IF doseq THEN DO:

  /* find out if source db supports large sequences */
  FIND FIRST  DICTDB._Db WHERE RECID(_Db) = drec_db.
  IF DICTDB._DB._Db-res1[1] = 1 THEN
     large_seq = YES.

  /* clear it out */
  ASSIGN comment_chars = "".

  if PROGRESS = "full" then do:  /* get real current sequence values */
    RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
    OUTPUT STREAM tmpstream TO VALUE(tmpfile) NO-MAP NO-ECHO.
    PUT STREAM tmpstream UNFORMATTED
      'DEFINE  SHARED VARIABLE crnt-vals AS INT64 EXTENT 2000 NO-UNDO.' SKIP.

    assign l_seq-num = 0.

    FOR EACH DICTDB._Sequence  WHERE DICTDB._Sequence._Db-recid = drec_db
                                 AND NOT DICTDB._Sequence._Seq-name BEGINS "$":
      assign l_seq-num = l_seq-num + 1.
      IF DICTDB._Sequence._Seq-Num >= 0
        THEN PUT STREAM tmpstream UNFORMATTED
              'crnt-vals [' 
              STRING (DICTDB._Sequence._Seq-Num + 1) 
              '] = CURRENT-VALUE ('
              DICTDB._Sequence._Seq-Name ', DICTDB).' SKIP.
      ELSE PUT STREAM tmpstream UNFORMATTED
           'crnt-vals [' 
              STRING (l_seq-num) 
              '] = 0 /*CURRENT-VALUE ('
              DICTDB._Sequence._Seq-Name ', DICTDB)*/.' SKIP.
    END. /* for each DICTDB._Sequence */

    PUT STREAM tmpstream UNFORMATTED
      'RETURN.' SKIP.

    OUTPUT STREAM tmpstream CLOSE.

    RUN VALUE (tmpfile).
    OS-DELETE VALUE (tmpfile). 

  end.  /* get real current sequence values */
       /*  else use 0's as current values */

  assign l_seq-num = 0.
  FOR EACH DICTDB._Sequence  WHERE DICTDB._Sequence._Db-recid = drec_db
                               AND NOT DICTDB._Sequence._Seq-name BEGINS "$" :

    assign l_seq-num = l_seq-num + 1.

    IF DICTDB._Sequence._Seq-misc[2] <> ? THEN
      n1 = DICTDB._Sequence._Seq-misc[1].
    ELSE
      n1 = DICTDB._Sequence._Seq-name.
    
    IF n1 = ? THEN
       assign n1 = DICTDB._Sequence._Seq-name.
       
    /*
     * check that the maximum size of an identifer is not exceeded for 
     * the sequence name.
     */ 

    trunc_name = FALSE.
    IF xlat THEN DO:
      if max_id_length <> 0  and length(n1) > max_id_length then do:
        /*  _resxlat will truncate name  */
        put stream logfile unformatted
              "WARNING: Sequence name " n1 " is longer than the maximum " skip
              "         legal identifier length of " max_id_length "." skip.
        trunc_name = TRUE.
      end.
      n1 = n1 + "," + idbtyp + "," + string (max_id_length).

      RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT n1). 
    end.
    
    else if max_id_length <> 0 and length(n1) > max_id_length then do:
      /*  need to truncate name  */
      put stream logfile unformatted
         "WARNING: Sequence name " n1 " is longer than the maximum " skip
         "         legal identifier length of " max_id_length "." skip.
         n1 = substring(n1,1,max_id_length).
         trunc_name = TRUE.
    end.
    IF length(n1) > 3 AND lc(SUBSTRING(n1, (LENGTH(n1) - 3))) = "_seq" THEN
        ASSIGN n1 = SUBSTRING(n1, 1, (LENGTH(n1) - 1))
               trunc_name = TRUE.

    if trunc_name then
       put stream logfile unformatted 
               "         Truncating sequence name to " n1 skip(2).         
    
    IF (dbtyp = "SYBASE" or dbtyp = "MS SQL Server" OR dbtyp = "MSSQLSRV7") THEN DO: 
     IF (dbtyp = "SYBASE" or dbtyp = "MS SQL Server")  THEN DO:
        PUT STREAM code UNFORMATTED 
           "if (select name from sysobjects where name = '_SEQT_" n1 "' and" skip
           "    uid = (select uid from sysusers " SKIP
           "where suid = (select suid from master.dbo.syslogins" skip 
           "where UPPER(name) = UPPER('" user_env[26] "'))))" skip
           "is not NULL" skip
           "drop table _SEQT_" n1 skip. 
        IF skptrm THEN 
           put stream code unformatted skip.
           
        PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.

        PUT STREAM code UNFORMATTED 
           "if (select name from sysobjects where name = '_SEQP_" n1 "' and" skip
           "           uid = (select uid from sysusers " SKIP
           "                  where suid = (select suid from master.dbo.syslogins" skip 
           "                  where UPPER(name) = UPPER('" user_env[26] "'))))" skip
           " is not NULL" skip
           "    drop procedure _SEQP_" n1 skip. 
           
        IF skptrm THEN 
           PUT STREAM code UNFORMATTED SKIP.
     END.
     ELSE IF dbtyp = "MSSQLSRV7" THEN DO:

       PUT STREAM code UNFORMATTED 
           "if (select name from sysobjects where name = '"seqt_prefix n1 "' and" skip
           "    uid = (select uid from sysusers " SKIP
           "           where sid = (select sid from master.dbo.syslogins" skip 
           "                        where UPPER(name) = UPPER('" user_env[26] "'))))" skip
           "is not NULL" skip
           "drop table " seqt_prefix n1 skip.  /* OE00170729 */
	
	IF seqt_prefix = "_SEQT_REV_" THEN 
	   ASSIGN other-seq-tab = "_SEQT_".
        ELSE 
           ASSIGN other-seq-tab = "_SEQT_REV_".
	
	IF seqt_prefix = "_SEQT_" THEN
	   PUT STREAM code UNFORMATTED 
            "if exists (select name from dbo.sysobjects where id = object_id(N'_SEQT_REV_SEQTMGR') " skip
            "   and OBJECTPROPERTY(id, N'IsTable') = 1) " skip
            "      if (select seq_name from _SEQT_REV_SEQTMGR where seq_name = '" n1 "') " skip
            "         is not NULL delete from _SEQT_REV_SEQTMGR where seq_name = '" n1 "'" skip
    
            "if exists (select name from dbo.sysobjects where id = object_id(N'_SEQT_REV_SEQTMGR') " skip
            "   and OBJECTPROPERTY(id, N'IsTable') = 1) " skip
    	    "       if (select seq_name from _SEQT_REV_SEQTMGR) is NULL drop table _SEQT_REV_SEQTMGR " skip.

	PUT STREAM code UNFORMATTED 
           "if (select name from sysobjects where name = '"other-seq-tab n1 "' and" skip
           "    uid = (select uid from sysusers " SKIP
           "           where sid = (select sid from master.dbo.syslogins" skip 
           "                        where UPPER(name) = UPPER('" user_env[26] "'))))" skip
           "is not NULL" skip
           "drop table " other-seq-tab n1 skip.

        IF skptrm THEN 
           put stream code unformatted skip.
           
        PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.

        PUT STREAM code UNFORMATTED 
           "if (select name from sysobjects where name = '"seqp_prefix n1 "' and" skip
           "           uid = (select uid from sysusers " SKIP
           "                  where sid = (select sid from master.dbo.syslogins" skip 
           "                               where UPPER(name) = UPPER('" user_env[26] "'))))" skip
           " is not NULL" skip
           "    drop procedure " seqp_prefix n1 skip.  /* OE00170729 */

	IF seqp_prefix = "_SEQP_REV_" THEN 
	     ASSIGN other-seq-proc = "_SEQP_".
	ELSE 
	     ASSIGN other-seq-proc = "_SEQP_REV_".
        
	PUT STREAM code UNFORMATTED 
           "if (select name from sysobjects where name = '"other-seq-proc n1 "' and" skip
           "           uid = (select uid from sysusers " SKIP
           "                  where sid = (select sid from master.dbo.syslogins" skip 
           "                               where UPPER(name) = UPPER('" user_env[26] "'))))" skip
           " is not NULL" skip
           "    drop procedure " other-seq-proc n1 skip. 
           
        IF skptrm THEN 
           PUT STREAM code UNFORMATTED SKIP.
     END.
     PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.

    IF NOT lnewSeq THEN 
        PUT STREAM code UNFORMATTED 
           "create table _SEQT_" n1 " ( " skip 
           "    initial_value    bigint null," skip
           "    increment_value  bigint null," skip
           "    upper_limit      bigint null," skip
           "    current_value    bigint null," skip
           "    cycle            bit not null) " skip 
           "  " skip.
     ELSE 
        PUT STREAM code UNFORMATTED 
     	  "create table _SEQT_REV_" n1 " ( " skip 
           "    current_value bigint identity(" _Seq-Init ", " _Seq-Incr ")" skip
           "    primary key, " skip
	   "    seq_val int) " skip 
           "  " skip.

       /* If the increment is positive, get the sequence's maximum.
          Otherwise, get its minimum. This will be stored as the
          upper_limit value.
       */
       IF DICTDB._Sequence._Seq-Incr > 0 THEN
         limit = ( IF DICTDB._Sequence._Seq-Max <> ?
                   THEN STRING(DICTDB._Sequence._Seq-Max)
                   ELSE (IF large_seq THEN "9223372036854775807" ELSE "2147483647")
                 ).
       ELSE
         limit = ( IF DICTDB._Sequence._Seq-Min <> ?
                   THEN STRING(DICTDB._Sequence._Seq-Min)
                   ELSE "0"
                 ).

     IF NOT lnewSeq then DO:
       IF DICTDB._Sequence._Seq-Num >= 0
        then put stream code unformatted 
           "insert into _SEQT_" n1 skip
           "       (initial_value, increment_value, upper_limit, current_value, cycle)" skip 
           "       values(" STRING(_Seq-Init) ", "
           STRING(_Seq-Incr) ", " limit ", " 
           STRING(crnt-vals[_Seq-Num + 1])  ", " 
           (if DICTDB._Sequence._Cycle-Ok then "1" else "0") ") " skip 
           " " skip.  
        else put stream code unformatted 
           "insert into _SEQT_" n1 skip
           "       (initial_value, increment_value, upper_limit, current_value, cycle)" skip 
           "       values(" STRING(_Seq-Init) ", "
           STRING(_Seq-Incr) ", " limit ", " 
           STRING(crnt-vals[l_seq-num])  ", " 
           (if DICTDB._Sequence._Cycle-Ok then "1" else "0") ") " skip 
           " " skip.  
       END.
       ELSE DO:
         PUT STREAM code UNFORMATTED 
           "if (select seq_name from _SEQT_REV_SEQTMGR where seq_name = '" n1 "') " skip
           " is not NULL" skip
           "    delete from _SEQT_REV_SEQTMGR where seq_name = '" n1 "' " skip
	   " " skip 
           "insert into _SEQT_REV_SEQTMGR " skip
           "       (seq_name, initial_value, increment_value, upper_limit, cycle)" skip 
           "       values('" n1 "', "
	       STRING(_Seq-Init) ", "
               STRING(_Seq-Incr) ", " limit ", " 
               (if DICTDB._Sequence._Cycle-Ok then "1" else "0") ") " skip 
           " " skip.
       END.

       if skptrm then 
           put stream code unformatted skip.
       put stream code unformatted comment_chars user_env[5] skip.

       /* 
        * Create the procedure to keep sequence numbers 
        */

       /* only MSS will have support for the new sequence generator. We should
          only get here with lnewSeq = TRUE for MSS, but just in case, check the
          db type.
       */
       IF NOT lnewSeq OR dbtyp NE "MSSQLSRV7" THEN DO:
           /* this is the default version of the sequence generator */
           put stream code unformatted 
               "create procedure _SEQP_" n1 " (@op int, @val bigint output) as " skip
               "begin" skip 
               "    /* " skip 
               "     * Current-Value function " skip 
               "     */" skip.
           if dbtyp NE "SYBASE" THEN 
                put stream code unformatted "   SET XACT_ABORT ON " skip.
           put stream code unformatted
               "    declare @err int " skip
               "    if @op = 0 " skip 
               "    begin" skip 
               "        begin transaction" skip
               "        select @val = (select current_value from _SEQT_" n1 ")" skip 
               "        SET @err = @@error " skip
               "        if @err <> 0 goto Err " skip
               "        commit transaction " skip
               "        return 0" skip
               "    end" skip 
               "    " skip 
               "    /*" skip  
               "     * Next-Value function " skip 
               "     */" skip 
               "    else if @op = 1" skip 
               "    begin" skip 
               "        declare @cur_val  bigint" skip 
               "        declare @last_val bigint" skip 
               "        declare @inc_val  bigint" skip 
               " " skip 
               "        begin transaction" skip 
               " " skip 
               "        /* perform a 'no-op' update to ensure exclusive lock */" skip 
               "        update _SEQT_" n1 " set initial_value = initial_value" skip
               "        SET @err = @@error " skip
               "        if @err <> 0 goto Err " skip
               " " skip 
               "        select @cur_val = (select current_value from _SEQT_" n1 ")" skip
               "        SET @err = @@error " skip
               "        if @err <> 0 goto Err " skip
               "        select @last_val = (select upper_limit from _SEQT_" n1 ")" skip
               "        SET @err = @@error " skip
               "        if @err <> 0 goto Err " skip
               "        select @inc_val  = (select increment_value from _SEQT_" n1 ")" skip
               "        SET @err = @@error " skip
               "        if @err <> 0 goto Err " skip
               " " skip 
               "        /*" skip 
               "         * if the next value will pass the upper limit, then either" skip
               "         * wrap or return a range violation" skip 
               "         */ " skip 
               "        if  @inc_val > 0 and @cur_val > @last_val - @inc_val  or @inc_val < 0 and @cur_val < @last_val - @inc_val " skip  
               "        begin" skip 
               "            if (select cycle from _SEQT_" n1 ") = 0 /* non-cycling sequence */" skip 
               "            begin " skip 
               "                SET @err = @@error " skip
               "                if @err <> 0 goto Err " skip
               "                select @val = @cur_val" skip
               "                commit transaction" skip 
               "                return -1" skip 
               "            end" skip 
               "            else " skip 
               "            BEGIN " skip
               "                 select @val = (select initial_value from _SEQT_" n1 ")" skip
               "                 SET @err = @@error " skip
               "                 if @err <> 0 goto Err " skip
               "            END " skip
               "        end" skip 
               "        else " skip 
               "             select @val = @cur_val + @inc_val" skip 
               " " skip 
               " " skip 
               "        update _SEQT_" n1 " set current_value = @val" skip 
               "        SET @err = @@error " skip
               "        if @err <> 0 goto Err " skip
               " " skip 
               " " skip 
               "        commit transaction" skip 
               "        return 0" skip 
               "    end" skip 
               "    else " SKIP
               "    /*" skip  
               "     * Set Current-Value function " skip 
               "     */" skip
               "    if @op = 2 " SKIP
               "    begin " SKIP
               "      begin transaction " SKIP
               "      update _SEQT_" n1 " set current_value = @val" SKIP
               "      SET @err = @@error " skip
               "      if @err <> 0 goto Err " skip
               "      commit transaction " SKIP
               "      return 0 " SKIP
               "   end " SKIP           
               "    else " skip 
               "        return -2" skip 
               "   Err: " skip
               "       rollback " skip
               "       return @err " skip
               "end" skip 
               " "   skip. 
       END.
       ELSE DO:
           /* here we will create the revised version of the sequence generator procedure */
	put stream code unformatted 
           "create procedure _SEQP_REV_" n1 " (@op int, @val bigint output) as " skip
           " begin " skip 
           "    DECLARE @err int " skip
           "    /* " skip 
           "     * Current-Value function " skip 
           "     */" skip
           "    if @op = 0 " skip 
           "    begin" skip
           "     BEGIN TRAN " skip
           "       set @val = ident_current('_SEQT_REV_" n1 "')" skip 
           "       SET @err = @@error " skip
           "       if @err <> 0 goto Err " skip
           "       commit transaction " skip
           "       return " skip
           "    end" skip
           "    " skip  
           "    /*" skip  
           "     * Next-Value function " skip 
           "     */" skip 
           "    else if @op = 1" skip 
           "    begin" skip 
           "     BEGIN TRAN " skip
           "        declare @ini_val  bigint" skip 
           "        declare @inc_val  bigint" skip 
           "        declare @upper_limit  bigint" skip 
           "        declare @cycle  bit" skip
           "        /* get upper limit and cycle info from _seqt_rev_seqtmgr */" skip 
           " " skip 
           "   select @upper_limit = upper_limit, " skip
           "          @inc_val = increment_value, " skip 
           "          @cycle = cycle, " skip
           "          @ini_val = initial_value " skip 
           "          from _seqt_rev_seqtmgr where seq_name = '" n1 "'" skip
           "    SET @err = @@error " skip
           "    if @err <> 0 goto Err " skip
           " " skip 
           "        /*" skip 
           "         * get current value from sequence table " skip
           "         */" skip 
           " " skip
           "       set @val = ident_current('_SEQT_REV_" n1 "')" skip 
           "       SET @err = @@error " skip
           "       if @err <> 0 goto Err " skip
           "        if (@inc_val > 0 and @upper_limit - @val < @inc_val) or (@inc_val < 0 and @upper_limit + @val > @inc_val) " skip  
           "     begin " skip 
           "         if @cycle != 0 " skip 
           "           begin " skip 
           "             DBCC CHECKIDENT ('_SEQT_REV_" n1 "', RESEED, @ini_val) " SKIP
           "             SET @err = @@error " skip
           "             if @err <> 0 goto Err " skip
           "             set @val = ident_current('_SEQT_REV_" n1 "')" skip
           "             SET @err = @@error " skip
           "             if @err <> 0 goto Err " skip
           "           end" skip 
           "         else " skip 
           "          BEGIN  " skip
           "           commit transaction " skip
           "           return -1" skip
           "          END " skip
           "     end" skip 
           "        else " skip 
           "     begin" skip
           "        insert into _SEQT_REV_" n1 " (seq_val) values (@val) " skip
           "        SET @err = @@error " skip
           "        if @err <> 0 goto Err " skip
           "        set @val = scope_identity() " skip
           "        SET @err = @@error " skip
           "        if @err <> 0 goto Err " skip
           "        delete from _SEQT_REV_" n1 skip 
           "        SET @err = @@error " skip
           "        if @err <> 0 goto Err " skip
           "     end" skip 
           "   commit transaction " skip
           "   return " skip
           "   end" skip
           "    else " skip
           "    /*" skip  
           "     * Set Current-Value function: Reseed the identity with passed value " skip 
           "     */" skip
           "    if @op = 2 " skip
           "    begin " skip
           "     BEGIN TRAN " skip
           "      DBCC CHECKIDENT ('_SEQT_REV_" n1 "', RESEED, @val) " skip
           "      SET @err = @@error " skip
           "      if @err <> 0 goto Err " skip
           "     COMMIT TRAN " skip
           "     return  " skip
           "    end " skip           
           "    else " skip 
           "        return -2" skip 
           " Err: " skip
           "   rollback " skip
           "   return @err "
           " end " skip          
           " "   skip. 

       END.

       if skptrm then 
           put stream code unformatted skip.
       put stream code unformatted comment_chars user_env[5] skip.

    end. /* (dbtyp = "SYBASE" or dbtyp = "MS SQL Server") */
    ELSE DO:
      IF dbtyp = "Informix" THEN
        PUT STREAM code UNFORMATTED
          "DROP SEQUENCE " n1 " ".
      ELSE
        PUT STREAM code UNFORMATTED
          "DROP SEQUENCE " n1.          

      /* If cycling sequence, start with initial value, 
        otherwise, start with current value.
        OE00167056 - Changing behavior. Always start with current value.
      */
      /* IF DICTDB._Sequence._Cycle-OK THEN
          start = DICTDB._Sequence._Seq-Init.
      ELSE */
          start = (IF DICTDB._Sequence._Seq-Num >= 0  
                   THEN (crnt-vals [_Seq-Num + 1] + _Seq-Incr)
                   ELSE (crnt-vals [l_seq-num] + _Seq-Incr)
                  ).

       assign
          i = ( IF DICTDB._Sequence._Seq-Min <> ?
                  THEN DICTDB._Sequence._Seq-Min
                  ELSE 0
              )
          limit = ( IF DICTDB._Sequence._Seq-Max <> ?
                  THEN STRING(DICTDB._Sequence._Seq-Max)
                  ELSE (IF large_seq THEN "9223372036854775807" ELSE "2147483647")
              ).

      /* If the initial value is some how greater than the current value
         Oracle will issue an error stating that the start with value can
         not be less than the initial value */
      IF start < i THEN
        ASSIGN start = i + _Seq-Incr.

      IF skptrm THEN
        PUT STREAM code UNFORMATTED SKIP.
        
      PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP
         "CREATE SEQUENCE " n1 "  START WITH " 
          STRING (start)
         " INCREMENT BY " + STRING (_Seq-Incr) 
         " MAXVALUE " limit " MINVALUE " STRING (i)
         (IF DICTDB._Sequence._Cycle-OK THEN " CYCLE" ELSE " NOCYCLE").

      IF skptrm THEN
        PUT STREAM code UNFORMATTED SKIP.
        
      PUT STREAM code UNFORMATTED comment_chars user_env[5] SKIP.   
    END.
  END. /* for each DICTDB._Sequence */
END. /* if doseq */
IF ( dbtyp <> "PROGRESS" ) and ( user_env[30] begins "y") THEN 
    PUT STREAM code UNFORMATTED "exit" SKIP.

OUTPUT STREAM code CLOSE.

/* Close the logfile if it wasn't open before we started. */
IF NOT logfile_open THEN DO:
   OUTPUT STREAM logfile CLOSE.
END. 
  

IF NOT batch_mode THEN DO:
    HIDE FRAME working NO-PAUSE.
    SESSION:IMMEDIATE-DISPLAY = no.
    IF NOT warnings_issued THEN 
        MESSAGE "Output Completed" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ELSE IF tables_not_created = true THEN
        MESSAGE "Output Completed. Some tables will not be created." SKIP
                "See" logfile_name "for more information." 
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ELSE 
        MESSAGE "Output Completed. See" logfile_name "for more information." 
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

RETURN.

PROCEDURE setMSSOptions:
   DEFINE VARIABLE numEntries          AS INTEGER    NO-UNDO.

   /* for new sequence generator support. If it's set, it will be the
     second entry. use2008types will be the third one.
   */
   numEntries = NUM-ENTRIES(user_env[25]).

   IF numEntries > 1 THEN DO:
      IF numEntries > 2 AND ENTRY(3,user_env[25]) BEGINS "Y" THEN
         ASSIGN mssNewDTTypes = YES.

       IF ENTRY(2,user_env[25]) BEGINS "Y" THEN DO:
         ASSIGN lnewSeq = TRUE
                seqt_prefix = "_SEQT_REV_"
                seqp_prefix = "_SEQP_REV_".
       END.
   END.

   ASSIGN lUniExpand = (user_env[35] = "y").
END.
