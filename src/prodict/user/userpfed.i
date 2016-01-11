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

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/*----------------------------------------------------------------
   Shared variables used for parameter file editor.

   Author: Tony Lavinio, Laura Stern
     Data: 02/03/93

     Tex updated 1/4/95 with 7.3b I18N parameters (cp**)
     DLM 10/01/99 Updated 9.1A valid Parameters
     DLM 01/31/00 Updated 9.1B valid Parameters
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

DEFINE {1} SHARED VARIABLE arg_nam AS CHARACTER EXTENT 140 NO-UNDO INITIAL [
  "1,SINGLE-USER,l",
  "adminport,ADMINSERVER-PORT,n",
  "aibufs,AFTER-IMAGE-BUFFERS,n",
  "aistall,AFTER-IMAGE-STALL,l",
  "b,BATCH,l",
  "B,BUFFERS,n",
  "baseindex,BASE-INDEX,n",
  "basekey,REGISTRY-BASE-KEY,c",
  "basetable,BASE-TABLE,n",
  "bibufs,BI-BUFFERS,n",
  "bistall,THRESHOLD-STALL,l",
  "bithold,REC-LOG-THRESHOLD,n",
  "Bp,PRIVATE-RO-BUFFERS,n",
  "brl,BLEEDING-RECORD-LOCK,l",
  "Bt,TEMP-TABLE-BUFFERS,n",
  "c,INDEX-CURSORS,n",
  "cache,SCHEMA-CACHE-FILE,c",
  "checkdbe,CHECK-DBE,l",
  "classpath,JAVA-CLASSPATH,l",
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
  "d,DATE-FORMAT,c",
  "D,DIRECTORY-SIZE,n",
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
  "fc,SCHEMA-FLD-CACHE-SZ,n",
  "fldisable,FIELD-LIST-DISABLE,l",
  "G,BI-CLUSTER-AGE,n",
  "groupdelay,GROUP-DELAY,n",
  "h,MAX-DATABASES,n",
  "H,HOST-NAME,c",
  "hardlimit,HARDLIMIT,l",
  "hash,HASH,n",
  "i,NO-INTEGRITY,l",
  "indexrangesize,INDEX-RANGE-SIZE,n",
  "ininame,INITIALIZATION-FILE,c",
  "inp,MAX-STATEMENT-LEN,n",
  "is,IGNORE-TIME-STAMPS,l",
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
  "noindexhint,INDEX-HINT,l",
  "nojoinbysqldb,SERVER-JOIN,l",
  "noSQLbyserver,PASS-THRU-DISABLE,l",
  "numdec,FRACTIONAL-SEPARATOR,n",
  "numsep,THOUSANDS-SEPARATOR,n",
  "o,PRINTER,c",
  "p,STARTUP-PROCEDURE,c",
  "P,PASSWORD,c",
  "param,PARAMETER,c",
  "pf,PARAMETER-FILE,c",
  "plm,PROLIB-MEMORY,l",
  "pls,PROLIB-SWAP,l",
  "populate,FAST-SCHEMA-CHANGE,l",
  "pp,ESQL-PROPATH,c",
  "properties,CONFIG-PROPS-FILE,c",
  "q,QUICK-REQUEST,l",
  "Q,ANSI-SQL,l",
  "Q2,ANSI-SQL-CLIENT,l",
  "r,NON-RELIABLE-I/O,l",
  "rand,RANDOM-NUM-MODE,n",
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
  "Sn,AS/400-SVR-PGM-NAME,c",
  "spin,SPIN-LOCK-TRIES,n",
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


