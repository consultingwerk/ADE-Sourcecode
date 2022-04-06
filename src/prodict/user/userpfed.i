/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/*----------------------------------------------------------------
   Shared variables used for parameter file editor.

   Author: Tony Lavinio, Laura Stern
     Data: 02/03/93

     Tex updated 1/4/95 with 7.3b I18N parameters (cp**)
     DLM 10/01/99 Updated 9.1A valid Parameters
     DLM 01/31/00 Updated 9.1B valid Parameters
     DLM 02/19/03 Removed AS400 options
-----------------------------------------------------------------*/

/* arg_nam   - Starts as array of all the parm data: name description and type.
               Translated into array of arg name/description pairs 
               (e.g., -B   Buffers)
   arg_lst   - All parm names (-B) strung out in a comma delimited list
   arg_typ   - Array of argument data types ((l)ogical, (c)haracter, (n)umber)
   arg_val   - Array of values
   args#     - Number of arguments 
   arg_comm  - Array of comment lines 
   arg_comm# - # of non-blank comment lines
   pf_file   - The parameter file to edit.
*/

DEFINE {1} SHARED VARIABLE arg_lst   AS CHARACTER CASE-SENSITIVE NO-UNDO.
DEFINE {1} SHARED VARIABLE arg_typ   AS CHARACTER EXTENT 200     NO-UNDO.
DEFINE {1} SHARED VARIABLE arg_val   AS CHARACTER EXTENT 200     NO-UNDO.
DEFINE {1} SHARED VARIABLE args#     AS INTEGER   INITIAL 0      NO-UNDO.
DEFINE {1} SHARED VARIABLE arg_comm  AS CHARACTER EXTENT 10      NO-UNDO.
DEFINE {1} SHARED VARIABLE arg_comm# AS INTEGER   INITIAL 0      NO-UNDO.
DEFINE {1} SHARED VARIABLE pf_file   AS CHARACTER                NO-UNDO.

/* PKEY  is the actual parameter: "-B"
   PDESC is the description: "Buffers"
   PNAME is the key plus the description: "-B  Buffers" 
   COMM# is the number of comment lines supported
*/
&GLOBAL-DEFINE PKEY_LEN    16
&GLOBAL-DEFINE PDESC_LEN   20
&GLOBAL-DEFINE PNAME_LEN   37
&GLOBAL-DEFINE VAL_START   39
&GLOBAL-DEFINE VAL_CHARS   39   /*How many chars to allow input*/
&GLOBAL-DEFINE COMM_LEN           73
&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN
&GLOBAL-DEFINE COMM#       8
&ELSE
/* Change comm# to 6 if we use _guipfed.p under TTY */
&GLOBAL-DEFINE COMM#       10
&ENDIF

/*---------------------------------------------------------------------
   These labels match the VMS arguments wherever possible. 
   They should not be translated to non-English languages. 

   The following parameters are not valid in .pf files:
     -lm  (leave memory)
     -ovl (overlay buffer size)
     -rft (return fault table)
   
   The following parameters were deliberately left out to avoid problems:
     -K c   (keycapture mode)
     -noshm (no shared memory on server)
   
   There are a bunch of other parameters that are used only in utilities
   (like proshut).
   
----------------------------------------------------------------------*/

DEFINE {1} SHARED VARIABLE arg_nam AS CHARACTER EXTENT 158 NO-UNDO INITIAL [
  "1,SINGLE-USER,l",
  "adminport,ADMINSERVER-PORT,n",
  "aibufs,AFTER-IMAGE-BUFFERS,n",
  "aistall,AFTER-IMAGE-STALL,l",
  "asyncqueuesize,ASYNC-QUEUE-SIZE,n",
  "b,BATCH,l",
  "B,BUFFERS,n",
  "baseADE,ADE-CODE-LOC,c",
  "baseindex,BASE-INDEX,n",
  "basekey,REGISTRY-BASE-KEY,c",
  "basetable,BASE-TABLE,n",
  "bibufs,BI-BUFFERS,n",
  "bistall,THRESHOLD-STALL,l",
  "bithold,REC-LOG-THRESHOLD,n",
  "Bp,PRIVATE-RO-BUFFERS,n",
  "Bpmax,MAX-PRI-BUFFERS,n",
  "brl,BLEEDING-RECORD-LOCK,l",
  "Bt,TEMP-TABLE-BUFFERS,n",
  "c,INDEX-CURSORS,n",
  "cache,SCHEMA-CACHE-FILE,c",
  "checkdbe,CHECK-DBE,l",
  "classpath,JAVA-CLASSPATH,l",
  "clientlog,CLIENT-LOG,c",
  "convmap,CONVERSION-MAP,c",
  "cp,COMM-PARMFILE,c",
  "cpcase,CASE-CHAR-SET,c",
  "cpcoll,COLLATION-CHAR-SET,c",
  "cpinternal,INTERNAL-CHAR-SET,c",
  "cplog,LOG-FILE-CODE-PAGE,c",
  "cpprint,PRINTER-CHAR-SET,c",
  "cprcodein,READ-RCODE-CHAR-SET,c",
  "cprcodeout,WRITE-RCODE-CHAR-SET,c",
  "cpstream,STREAM-CHAR-SET,c",
  "cpterm,TERMINAL-CHAR-SET,c",
  "cs,CURSOR-SIZE,n",
  "d,DATE-FORMAT,c",
  "D,DIRECTORY-SIZE,n",
  "DataService,DATASERVICE,c",
  "db,DATABASE,c",
  "debug,DEBUG,l",
  "debugalert,DEBUG-ALERT-BOX,l",
  "dictexps,DICT-EXPRESSIONS,l",
  "directio,DIRECT-I/O,l",
  "Dsrv,DATASERVER,c",
  "dt,DB-TYPE,c",
  "E,EUROPEAN-NUMBERS,l",
  "esqllog,ESQL-LOG,l",
  "esqlnopad,ESQL-NO-PADDING,l",
  "evtlevel,EVENT-LEVEL,c",
  "expandbrow,EXPANDABLE-BROWSE,l",
  "fc,SCHEMA-FLD-CACHE-SZ,n",
  "filteroxcevents,FILTER-ASYNC-COM,l",
  "fldisable,FIELD-LIST-DISABLE,l",
  "G,BI-CLUSTER-AGE,n",
  "groupdelay,GROUP-DELAY,n",
  "h,MAX-DATABASES,n",
  "H,HOST-NAME,c",
  "hardlimit,HARDLIMIT,l",
  "hash,HASH,n",
  "i,NO-INTEGRITY,l",
  "icfparm,ICF-PARAMETERS,c",
  "indexrangesize,INDEX-RANGE-SIZE,n",
  "ininame,INITIALIZATION-FILE,c",
  "inp,MAX-STATEMENT-LEN,n",
  "isnoconv,INI-VAL-SEQ-NO-CVT,l",
  "k,KEYWORD-FORGET,c",
  "l,LOCAL-BUFFER-SIZE,n",
  "L,NUMBER-LOCKS,n",
  "ld,LOGICAL-DBNAME,c",
  "lkwtmo,LOCK-TIMEOUT,n",
  "lng,LANGUAGE-NAME,c",
  "m1,AUTO-SERVER,l",
  "m2,MANUAL-SERVER,l",
  "m3,LOGIN-BROKER,l",
  "Ma,MAXIMUM-CLIENTS,n",
  "maxport,MAX-DYNAMIC-SERVER,n",
  "Mf,DELAYED-BI-WRITE,n",
  "Mi,MINIMUM-CLIENTS,n",
  "minport,MIN-DYNAMIC-SERVER,n",
  "Mm,MESSAGE-BUFFER-SIZE,n",
  "mmax,MAX-R-CODE-MEMORY,n",
  "Mn,MAX-SERVERS,n",
  "Mp,SERVERS/PROTOCOL,n",
  "Mpb,MAX-SERVERS/BROKER,n",
  "Mpte,VLM-PG-TBL-ENT-OPT,l",
  "Mr,RECORD-BUFFER-SIZE,n",
  "Mxs,EXCESS-SHARED-MEM,n",
  "n,NUMBER-OF-USERS,n",
  "N,NETWORK-TYPE,c",
  "nb,NESTED-BLOCK-LIMIT,n",
  "NL,NO-LOCK-DEFAULT,l",
  "nochkttnames,NO-CHK-TEMP-TBL,l",
  "noindexhint,INDEX-HINT,l",
  "nojoinbysqldb,SERVER-JOIN,l",
  "noSQLbyserver,PASS-THRU-DISABLE,l",
  "numdec,FRACTIONAL-SEPARATOR,n",
  "numsep,THOUSANDS-SEPARATOR,n",
  "o,PRINTER,c",
  "ojmode,OUTER-JOIN-MODE,n",
  "p,STARTUP-PROCEDURE,c",
  "P,PASSWORD,c",
  "param,PARAMETER,c",
  "pf,PARAMETER-FILE,c",
  "pinshm,PIN-SHARED-MEM,l",
  "plm,PROLIB-MEMORY,l",
  "pls,PROLIB-SWAP,l",
  "populate,FAST-SCHEMA-CHANGE,l",
  "pp,ESQL-PROPATH,c",
  "properties,CONFIG-PROPS-FILE,c",
  "proxyhost,PROXY-HOST,c",
  "proxyPassword,PROXY-PASSWORD,c",
  "proxyport,PROXY-PORT,n",
  "ProxyUserid,PROXY-USERID,c",
  "q,QUICK-REQUEST,l",
  "Q,ANSI-SQL,l",
  "Q2,ANSI-SQL-CLIENT,l",
  "r,NON-RELIABLE-I/O,l",
  "rand,RANDOM-NUM-MODE,n",
  "rereadnolock,REREAD-NL,l",
  "rg,RUN-4GL-CLIENT,l",
  "RO,READ-ONLY-DATABASE,l",
  "rptint,LIC-USAGE-RPT-INTVAL,n",
  "rq,RUN-QUERY-CLIENT,l",
  "rr,RUN-RUNTIME-CLIENT,l",
  "rx,ENCRYPTED-COMPILER,l",
  "s,STACK-SIZE,n",
  "S,SERVICE-NAME,c",
  "semsets,SEMAPHORE-SETS,n",
  "servergroup,SERVER-GROUP,c",
  "ServerType,TYPE-OF-SERVER,c",
  "spin,SPIN-LOCK-TRIES,n",
  "SQLStackSize,SQL92-STACK-SZ,n",
  "SQLStmtCacheSize,SQL92-STMT-SZ,n",
  "stsh,STASH-AREA-SIZE,n",
  "SV,OI-DRIVER-CONNECTION,c",
  "t,SAVE-TEMP-FILES,l",
  "T,TEMP-FILE-DIRECTORY,c",
  "tablerangesize,TABLE-RANGE-SIZE,n",
  "TB,SORT-BLOCK-SIZE,n",
  "TM,MERGE-BUFFER-COUNT,n",
  "tok,MAX-TOKENS,n",
  "trig,TRIGGER-LOCATION,c",
  "U,USERID,c",
  "usrcount,USER-COUNT,n",
  "v6colon,VERSION-6-COLON,l",
  "v6q,V6-QUERY,l",
  "wss,WIN-SINGLE-SESSION,l",
  "wy,WINDOWS-EXIT,c",
  "y,STATISTICS,l",
  "yc,STATISTICS-CTRLC,l",
  "yd,SEGMENT-STATISTICS,l",
  "yr4def,4-DIGIT-YEAR-DEFAULT,l",
  "yx,STATISTICS-XREF,l",
  "yy,YEAR-OFFSET,n",
  ""
].


