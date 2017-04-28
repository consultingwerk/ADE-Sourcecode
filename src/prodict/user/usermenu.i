/*********************************************************************
* Copyright (C) 2006-2013,2016 by Progress Software Corporation. All *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------
File: usermenu.i

Description:
   This include file contains the definition of the Admin menu and the
   Dictionary menu for the TTY version.
 
Arguments:
   {1} - this is either "NEW" or nothing.

Author: Laura Stern

HISTORY
mcmann   03/06/03   Remove the DB2/400 DataServer Utilities
mcmann   04/23/02   Change where schema lock is taken for on-line schema adds
mcmann   03/26/99   Added support for MS SQL Server 7 Utilities
McMann   02/01/00   Added Oracle Bulk Insert Menu Option
Mario B. 05/19/99   Adjust Width Field browser integration.
mcmann   08/24/98   Added incremental df migration for Oracle
mcmann   06/29/98   Added ProToOdbc in ODBC DataServer menu
mcmann   06/05/98   DICTDB was being assigned to a foreign database which
                    caused an error message to be display when trying to
                    access DataServer utilities. 98-04-28-005 96-10-17-026
laurief  04/09/98   Changed user_env[1] from "a" to "s" for the following
                    utilities to allow users to select/deselect multiple
                    tables (BUG 97-07-22-029).  Utilities include Dump
                    Definitions
mcmann   02/11/98   Changed user_env[1] for dump dfs to s from a 97-07-22-029
mcmann   01/07/98   Added Storage Area Report
hutegger 96/09      removed DB2 and DB2-DRDA again
tomn     07/96      Changed "menu graying" logic (Menu_Walk) so that a menu item
                    will be disabled if all of its children are disabled.  This
                    is an MS-Windows standard, which has a side-effect on TTY
                    since there is no visual cue that a menu item is disabled.
tomn     07/96      Added "Schema Migration Tools" pop-up menu to MS-SQL, ORACLE,
                    and SYBASE sub-menus.  This menu is essentially 3 of the 4
                    individual steps of the "PROTOXXX" utility: Generate DDL,
                    Send SQL, and Adjust Schema (Beautify).  The fourth
                    step is Create Schema Image, which is already on the previous
                    menu.  Also on this menu is the combined "PROTOXXX" utility.
tomn     07/96      Reordered DataServer main menu in alphabetic order.
DLM      06/96      Removed DB2/400 V6 Utilities and Allbase reference
sjp      06/96      Added db type DB2-DRDA. Re-used DB2 for DB2 with ODBC.
                    DB2-DRDA is older, native DB2 dataserver.
DLM      05/96      Changed system check to be begins ms-win instead of =
tomn     03/96      Removed dataserver name from submenu label to shorten length
tomn     03/96      Removed Sybase4 from menu; Changed Sybase10 menu labels to
                    "Sybase" (Sybase4 was "Sybase" and Sybase10 was "Sybase-10")
hutegger 95/11      added MSSQL-menu plus /*###*/ to indicate where
                    changes are needed when adding a new DataServer
                    (Don't forget adecomm/ds_type.i & prodict/dictgate.i!)
hutegger 95/09      removed netisam and ctos-isam, also V5-dump 
trb      05/05/95   Updated AS400 V7 Utilities.
nhorn    11/14/94   Added AS400 V7 Utilities. Took out Allbase Utilities.
gfs      11/01/94   Fixed wording on menu.
gfs      07/22/94   Changed mneumonic on "Change" from "g" to "h" for
                    better readability.
mcmann  02/15/01    Added schema migration menu for DB2/400    
mcmann  03/05/02    Added new user_path for loading objects without getting
                    a schema lock.  The *T option is moved to _usrload.p      
mcmann  12/03/02    Added Delta SQL Utility to MSS     
McMann  02/21/03    Replaced GATEWAYS with DATASERVERS      
McMann  02/24/03    Removed depreciated DataServers                   
kmcintos 04/04/05   Added menus, menu-items and logic support for auditing
kmcintos 04/20/05   Removed directory check and refined logic for performance
                    when menu-item requires _db-detail, _aud or _sec
kmcintos 04/28/05   Changed dump and security options to set user_env[9]
                    before call to _usrtget & _guitget. 20050427-022
kmcintos 04/30/05   Added code to rerun menu initialization proc after changing
                    DICTDB.
kmcintos 04/30/05   Added code to db disconnect, db connect and db create to 
                    rerun menu initialization process.
kmcintos 05/24/05   Changed Dump/Load DB Id Records to Dump/Load Db Id 
                    Properties. 20050505-019                    
kmcintos 07/19/05   Re-Fixed bug 20050301-003.
kmcintos 08/18/05   Added Audit Policy Refresh after load 20050629-018.
kmcintos 09/01/05   Moved setting of user_env[9] to before call to table list
                    20050831-019.
kmcintos 10/28/05   Changed audit event inserter perm requirement to audit admin
                    bug # 20051026-058.
fernando 01/04/06   Changes for 20051230-006.
fernando 06/09/06   Support for large key entries
fernando 06/23/08   Support for encryption
fernando 04/07/09   Added Alternate Buffer Pool utilities
kmayur   06/21/11   Added options for constraint creation (Server Attributes in Dataserver) OE00195067
rkamboj  08/16/11   Added new terminology for security items and windows. 

Date Created: 01/04/93 
----------------------------------------------------------------------------*/

{prodict/misc/misc-funcs.i}
{prodict/sec/sec-func.i}

/*===========================Variables==================================*/

/*---------------------------------------------------------------------
   This will be filled with the menu handles for each menu-item.  After
   the initial graying phase, elements for menu-items that will NEVER
   be activated for this version of progress will be set to ?.
---------------------------------------------------------------------*/
Define var Menu_Hdl as widget-handle extent /*170*/ 200 NO-UNDO.  /* tsn 7/96 */

/* Indexes into the Menu_Hdl array and the ?_Gray arrays. */
Define var All_Items_ix as integer NO-UNDO init 0. /* idx into Menu_Hdl */
Define var Submenu_ix         as integer NO-UNDO init 0. /* idx into ?_Gray array */

/* This is used after running another ADE tool */
Define var num_connected as integer NO-UNDO.

/*------------------------------------------------------------------------
   This array is used to determine what should be grayed when we are
   running a particular version of Progress.  There is an array element 
   for each sub-menu.  The value of the array element is a comma 
   delimited list, with a value for each menu item.  (A rule is considered
   a menu item!)  Each of these values is a combination of the letters FCXQRN.
   Each letter represents a configuration of Progress as shown below.  If the 
   letter is present, it means that this menu item should be enabled for 
   this Progress.  Otherwise, it is replaced with a "-".  So FCX--- means 
   that we enable this menu item only for Full, Compile and Compile-Encrypted 
   Progress.

   The code letters are as follows:
      F = FULL PROGRESS
      C = COMPILE-ONLY PROGRESS

      X = COMPILE-ENCRYPT PROGRESS
      Q = QUERY/REPORT PROGRESS
      R = RUN-TIME PROGRESS
      N = PROGRESS w/no database connected 
      A = Requires Audit tables be present in the database
      Z = Requires _db-detail table be in the database
      B = Requires _db-option table be in the database
      Y = Requires Security tables be present in the database
      E = Requires db that has Encryption capabilities
      M = Requires sys admin user (only for PROGRESS db type)
      
   *****************************IMPORTANT***************************
   The order of submenus was generated by the same tree walk 
   that will be used to process the list for graying.
   If any menus/menu items are added, removed or re-ordered, this 
   table must be updated. Also need to fix MSSQL_IX, etc below to
   match new position of DataServer menus.
   ******************************************************************
---------------------------------------------------------------------------*/
Define var Gray_Table as char extent 32 NO-UNDO init /*###*/
[
   /*Database  */ "FCXQR-,FCXQRN,FCXQRN,FCXQR-,FCXQRN",       
   /*Reports   */ "FCXQR-,FCXQR-,FCXQR-,FCXQR-,FCXQR-,FCXQR-,FCXQR-,FCXQ--,FCXQR-,FCXQR-,FCXQR-,FCXQRM-,------,------",
   /*Auditing Reports */ "FCXQR-A,FCXQR-A,FCXQR-A,FCXQR-A,------,FCXQR-A,FCXQR-A,FCXQR-A,FCXQR-A,------,FCXQR-A,FCXQR-A,FCXQR-A,------,FCXQR-A,FCXQR-A,FCXQR-A,------,FCXQR-A",
   /*Encryption Policy Reports */ "FCXQR-E,FCXQR-E",
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   /*&Schema   */ "FCXQR-,FCX---,FCX---,FCXQR-,FCX---,FCX---,FCXQR-,FCXQR-,FCXQR",         
  &ENDIF
   /*Admin     */ "FCX---,FCX---B,FCX----",
   /*Dump      */ "FCX---,F-----,FCX---,------,FCX---,FCXQR-Y,FCXQR-Y,------,FCX---,FCX---,FCX---,F-----,FCXQR-Z,FCXQR-B,------,FCXQR-A,------,FCX---,------,FCXQR-D",
   /*Audit Policies*/ "FCXQR-A,FCXQR-A,-------,FCXQR-A",
   /*Load      */ "FCX---,F-----,FCX---,------,FCX---,FCXQR-Y,FCXQR-Y,------,F-----,FCX---,FCXQR-Z,FCXQR-B,------,FCXQR-A,------,FCXQR-D",   
   /*Audit Policies*/ "FCXQR-A,FCXQR-A,-------,FCXQR-A",
   /*DB Identification*/ "FCX---Z,FCX---Z",
   /*Security  */ "FCXQ--,FCXQ--,FCXQ--,FCXQ--A,FCXQ--,FCXQ--,FCXQ--,------,------",
   /*Auth Systems */ "FCXQ--Y,FCXQ--Y",
   /*Encryption Policies */ "FCX--E,FCX--E,FCX--E",
   /*Export    */ "F-----,F-----,F-----,F-----",          
   /*Import    */ "F-----,F-----,F-----,F-----,F-----,F-----",    
   /*AltBufPool*/ "FCX--M",
   /*DataServer*/ "",
   /*MSSQL Util*/ "FCX---,FCX---,FCX---,FCX---,FCX---,FCX---,FCX---,------,FCX---",
   /*OE00195067 MSSQL Server Attributes */ "FCX---,FCX---,FCX---,FCX---",  
   /*MSSQL Tool*/ "FCX---,FCX---,FCX---",    
   /*ORA Util  */ "FCX---,FCX---,FCX---,FCX---,FCX---,FCX---,FCX---,------,FCX---",
   /*OE00195067 ORACLE Server Attributes */ "FCX---,FCX---,FCX---",
   /*ORA Tools */ "FCX---,FCX---,FCX---,FCX---",
   /*Utilities */ "FCXQ-N,------,FCX---,FCX---,FCX---,------,FCXQ-N",
   /*Quoter    */ "FCXQ-N,FCXQ-N,FCXQ-N,FCXQ-N", 
   /*Incl File */ "FCXQ--,FCXQ--,FCXQ--", 
   /*PRO/SQL   */ "FCXQR-,FCXQ--,FCXQ--"
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   ,
   /*&Help     */ "FCXQRN,FCXQRN,FCXQRN,FCXQRN,FCXQRN,FCXQRN,FCXQRN"  
  &ENDIF
   ].

/* These are array indices for the DataServer sub-menus in Gray_Table.
*/
&IF "{&WINDOW-SYSTEM}" = "TTY" /*###*/
 &THEN
 &global-define MSSQL_IX       18 /* tools 19 */ 
 &global-define ODBC_IX        20 /* tools 21 */
 &global-define ORACLE_IX      22 /* tools 23 */
 &ELSE                         /*###*/                       
  &global-define MSSQL_IX       17 /* tools 18 */
  &global-define ODBC_IX        19 /* tools 20 */
  &global-define ORACLE_IX      21 /* tools 22 */
&ENDIF

/*=============================Menu Definitions==========================*/

/* standard tools menu */
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   {adecomm/toolmenu.i 
      &EXCLUDE_ADMIN = yes
      &EXCLUDE_DICT  = yes
   }
&ELSE 
   {adecomm/toolmenu.i 
      &EXCLUDE_ADMIN = yes
   }
&ENDIF

DEFINE SUB-MENU mnu_Aud_Rep
   MENU-ITEM mi_Rpt_AudPol    LABEL "Track Audit &Policy Changes"
   MENU-ITEM mi_Rpt_DbSchma   LABEL "Track Database &Schema Changes"
   MENU-ITEM mi_Rpt_AudAdmn   LABEL "Track &Audit Data Administration (Dump/Load)"
   MENU-ITEM mi_Rpt_TblAdmn   LABEL "Track Application &Data Administration (Dump/Load)"
   RULE
   MENU-ITEM mi_Rpt_UsrAct    LABEL "Track &User Account Changes"
   MENU-ITEM mi_Rpt_SecPerm   LABEL "Track Security Per&missions Changes"
   MENU-ITEM mi_Rpt_Dba       LABEL "&Track SQL Permissions Changes"
   MENU-ITEM mi_Rpt_AuthSys   LABEL "Track Authe&ntication System Changes"
   RULE
   MENU-ITEM mi_Rpt_CltSess   LABEL "&Client Session Authentication Report"
   MENU-ITEM mi_Rpt_DbAdmin   LABEL "Database Administ&ration Report (Utilities)"
   MENU-ITEM mi_Rpt_AppLogin  LABEL "Database Access Report (Lo&gin/Logout/etc...)"
   RULE
   MENU-ITEM mi_Rpt_EncPol    LABEL "Track &Encryption Policy Changes"
   MENU-ITEM mi_Rpt_KeyStore  LABEL "Track &Key Store Changes"
   MENU-ITEM mi_Rpt_EncAdmin  LABEL "Database Encr&yption Administration (Utilities)"
   RULE
   MENU-ITEM mi_Rpt_Cust      LABEL "Custom Audit Data &Filter Report".

DEFINE SUB-MENU mnu_Enc_Rep
    MENU-ITEM mi_Rpt_QkEncPol   LABEL "&Quick Encryption Policies"
    MENU-ITEM mi_Rpt_DtEncPol   LABEL "&Detailed Encryption Policies".

/*--------------------Database and its Sub-menus-------------------------*/
Define sub-menu mnu_Reports        
   menu-item mi_Rpt_DetTbl    label "&Detailed Table"
   menu-item mi_Rpt_Table     label "Quick &Table"
   menu-item mi_Rpt_Field     label "Quick &Field"
   menu-item mi_Rpt_Index     label "Quick &Index"
   menu-item mi_Rpt_View      label "PRO/SQL &View"
   menu-item mi_Rpt_Sequence  label "&Sequence"
   menu-item mi_Rpt_Trigger   label "Tri&gger"
   menu-item mi_Rpt_User      label "&User"
   menu-item mi_Rpt_TblRel    label "Table &Relations"
   menu-item mi_Rpt_Area      label "Storage &Areas"
   MENU-ITEM mi_Rpt_Width     LABEL "Verify Data &Width"
   MENU-ITEM mi_Rpt_AltBufPool LABEL "Alternate &Buffer Pool"
   RULE
   SUB-MENU  mnu_Aud_Rep      LABEL "Auditing R&eports"
   SUB-MENU  mnu_Enc_Rep      LABEL "Encryption &Policy Reports".

Define sub-menu mnu_Database
   menu-item mi_DB_Select     label "&Select Working Database..."
   menu-item mi_DB_Create     label "&Create..."
   menu-item mi_DB_Connect    label "Co&nnect..." 
   menu-item mi_DB_Disconnect label "&Disconnect..."
   sub-menu  mnu_Reports      label "&Reports"   
   menu-item mi_Exit          label "E&xit"
   .

/*---------------------------Schema Menu----------------------------------*/
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
Define sub-menu mnu_Schema
   menu-item mi_Sch_ModTbl    label "&Modify Table..."
   menu-item mi_Sch_AddTbl    label "&Add New Table..."
   menu-item mi_Sch_DelTbl    label "&Delete Table(s)..."
   menu-item mi_Sch_FldEdit   label "&Field Editor..."     
   menu-item mi_Sch_ReordFld  label "&Reorder Fields..."
   menu-item mi_Sch_RenamFld  label "&Global Field Name Change..."
   menu-item mi_Sch_IdxEdit   label "&Index Editor..."
   menu-item mi_Sch_SeqEdit   label "&Sequence Editor..."
   menu-item mi_Sch_SQL       label "Adjust Field &Width..."
   .
&ENDIF
    
/*-----------------Admin Menu and its Sub-menus---------------------------*/

DEFINE SUB-MENU mnu_Dump_Aud_Pol
   MENU-ITEM mi_Dump_as_XML   LABEL "Dump as &XML (.xml file)..."
   MENU-ITEM mi_Dump_as_Txt   LABEL "Dump as &Text (.ad file)..."
   RULE
   MENU-ITEM mi_Dump_Evt      LABEL "Application Audit &Events...".
   
Define sub-menu mnu_Dump
   menu-item mi_Dump_Defs     label "&Data Definitions (.df file)..."
   menu-item mi_Dump_Contents label "&Table Contents (.d file)..."
   menu-item mi_Dump_Views    label "SQL &Views..."
   RULE
   menu-item mi_Dump_User     label "&User Table Contents..."
   MENU-ITEM mi_Dump_Sec_Auth LABEL "Securit&y Domains..." /* Security Aut&hentication Records..." */
   MENU-ITEM mi_Dump_Sec_Perm LABEL "Security Per&missions..."
   RULE
   menu-item mi_Dump_AutoConn label "Auto-Conn&ect Records only..."
   menu-item mi_Dump_CollTran label "&Collation Tables..."
   menu-item mi_Dump_SeqDefs  label "&Sequences Definitions..."
   menu-item mi_Dump_SeqVals  label "Se&quences Current Values..."
   MENU-ITEM mi_Dump_DB_Ids   LABEL "Database Identi&fication Properties..."
   MENU-ITEM mi_Dump_DB_Opt   LABEL "Database &Options..."
   RULE
   SUB-MENU mnu_Dump_Aud_Pol  LABEL "Audit &Policies"
   MENU-ITEM mi_Dump_Aud_Data LABEL "&Audit Data..."
   RULE
   menu-item mi_Dump_IncrDF   label "Create &Incremental .df File..."
   RULE
   MENU-ITEM mi_Dump_CDC      LABEL "C&hange Data Capture Policies (.cd file)..." 
   .

DEFINE SUB-MENU mnu_Load_Aud_Pol
   MENU-ITEM mi_Load_XML      LABEL "Load &XML (.xml file)..."
   MENU-ITEM mi_Load_Txt      LABEL "Load &Text (.ad file)..."
   RULE
   MENU-ITEM mi_Load_Evt      LABEL "Application Audit &Events...".
           
Define sub-menu mnu_Load
   menu-item mi_Load_Defs     label "&Data Definitions (.df file)..."
   menu-item mi_Load_Contents label "&Table Contents (.d file)..."
   menu-item mi_Load_Views    label "SQL &Views..."
   RULE
   menu-item mi_Load_User     label "&User Table Contents..."
   MENU-ITEM mi_Load_Sec_Auth LABEL "Securit&y Domains..." /* "Security Aut&hentication Records..." */
   MENU-ITEM mi_Load_Sec_Perm LABEL "Security Per&missions..."
   RULE
   menu-item mi_Load_SeqVals  label "&Sequences Current Values..."
   menu-item mi_Load_BadRecs  label "&Reconstruct Bad Load Records..."
   MENU-ITEM mi_Load_DB_Ids   LABEL "Database Identi&fication Properties..."
   MENU-ITEM mi_Load_DB_Opt   LABEL "Database &Options..."
   RULE
   SUB-MENU  mnu_Load_Aud_Pol LABEL "Audit &Policies"
   MENU-ITEM mi_Load_Aud_Data LABEL "Aud&it Data..."
   RULE
   MENU-ITEM mi_Load_CDC      LABEL "C&hange Data Capture Policies (.cd file)..." 
.

DEFINE SUB-MENU mnu_dbid
   MENU-ITEM mi_db_id_maint LABEL "Database Identification &Maintenance..."
   MENU-ITEM mi_db_id_hist  LABEL "Database Identification &History..."
   .

DEFINE SUB-MENU mnu_auth_maint
    MENU-ITEM mi_auth_sys       LABEL "&Authentication Systems..." /* "Security Authentication &Systems..." */
    MENU-ITEM mi_auth_dom       LABEL "&Domains..." /* Authentication System &Domains..." */ .

DEFINE SUB-MENU mnu_Enc_Policies
    MENU-ITEM mi_encpol_edit     LABEL "&Edit Encryption Policy..."
    MENU-ITEM mi_encpol_regen    LABEL "&Generate Encryption Keys..."
    MENU-ITEM mi_encpol_history  LABEL "&Encryption Policy History...".

Define sub-menu mnu_Security
   menu-item mi_Sec_EditUser  label "&Edit User List..."
   menu-item mi_Sec_Password  label "Change Your &Password..."
   menu-item mi_Sec_DataSec   label "Edit Data &Security..."
   MENU-ITEM mi_Sec_Aud_Perm  LABEL "Edit Au&dit Permissions..."
   menu-item mi_Sec_Adminors  label "Security &Administrators..."
   menu-item mi_Sec_BlankId   label "Disallow &Blank Userid Access..."
   menu-item mi_Sec_UserRpt   label "&User Report..."
   RULE
   SUB-MENU  mnu_auth_maint   LABEL "Domain &Maintenance" /* "Authentication System &Maintenance" */
   SUB-MENU  mnu_Enc_Policies LABEL "En&cryption Policies"
   .
        
Define sub-menu mnu_Export
   menu-item mi_Exp_DIF              label "&DIF..."
   menu-item mi_Exp_SYLK      label "&SYLK..."
   menu-item mi_Exp_ASCII     label "&Text..."
   menu-item mi_Exp_MSWord    label "&Microsoft Word Merge Data..."
   .

Define sub-menu mnu_Import
   menu-item mi_Imp_DIF              label "&DIF..."
   menu-item mi_Imp_SYLK      label "&SYLK..."
   menu-item mi_Imp_ASCII     label "Delimited &Text..."
   menu-item mi_Imp_FixedLen  label "&Fixed-Length..."
   menu-item mi_Imp_dBASEDefs label "d&BASE Definitions..."
   menu-item mi_Imp_dBASECont label "dBASE File &Contents..."
   .

Define sub-menu mnu_AltBuf
    menu-item mi_AltBuf_Maint label "Alternate Buffer Pool Maintenance"
    .

Define sub-menu mnu_Admin
   sub-menu  mnu_Dump         label "&Dump Data and Definitions"
   sub-menu  mnu_Load         label "&Load Data and Definitions"
   SUB-MENU  mnu_dbid         LABEL "Database Identi&fication"
   sub-menu  mnu_Security     label "&Security"
   sub-menu  mnu_Export       label "&Export Data"
   sub-menu  mnu_Import       label "&Import Data"
   menu-item mi_BulkLoad      label "Create &Bulk Loader Description File..."
   MENU-ITEM mi_DbOptions     LABEL "Database &Options..."
   MENU-ITEM mi_LargeKeys     LABEL "Enable Large &Key Entries"
   sub-menu  mnu_AltBuf       label "&Alternate Buffer Pool"
   .

/*== Pop-up menus for "protoxxx" tools -  MS-SQL ==*/
/* OE00195067 */
Define sub-menu mnu_mss_srv_attr  
   menu-item mi_mss_viw_mnt_cnst         label "View/Maintain Foreign Constraint Definitions..."
   menu-item mi_mss_active_all_cnst      label "Activate/Deactivate Constraint Definitions..."
   menu-item mi_mss_delete_all_cns       label "Delete Constraint Definitions..."
   menu-item mi_mss_gen_cnst_frm_rowid   label "Generate Constraints from ROWID..."
   .
/* OE00195067 */

Define sub-menu mnu_mss_tools 
   menu-item mi_mss_Migrate   label "&OpenEdge DB to MS SQL Server..."
   menu-item mi_mss_Incre     label "&Generate Delta.sql OpenEdge to MSS..." 
   menu-item mi_mss_AdjstSI   label "&Adjust Schema..."
   .
/*== Pop-up menus for "protoxxx" tools -  ODBC ==*/

Define sub-menu mnu_odb_tools
   menu-item mi_odb_DBtoodb    label "&OpenEdge DB to ODBC..."
   MENU-ITEM mi_odb_AdjstSI    LABEL "&Adjust Schema..."
   .

/*== Pop-up menus for "protoxxx" tools -  Oracle ==*/

/* OE00195067 */
Define sub-menu mnu_ora_srv_attr  
   menu-item mi_ora_viw_mnt_cnst         label "View/Maintain Foreign Constraint Definitions..."
   menu-item mi_ora_active_all_cnst      label "Activate/Deactivate Constraint Definitions..."
   menu-item mi_ora_delete_all_cns       label "Delete Constraint Definitions..."
   .

Define sub-menu mnu_ora_tools
   menu-item mi_ora_DBtoORA   label "&OpenEdge DB to ORACLE..."
   menu-item mi_ora_Incre     label "&Generate Delta.sql OpenEdge to ORACLE..." 
   menu-item mi_ora_AdjstSI   label "&Adjust Schema..."
   MENU-ITEM mi_ora_BInsert   LABEL "&Bulk Inserts..."
   .

Define sub-menu mnu_MSSQL
   menu-item mi_MSSQL_Create    label "&Create DataServer Schema..."
   menu-item mi_MSSQL_UpdFile   label "&Update/Add Table Definitions..."
   menu-item mi_MSSQL_VerFile   label "&Verify Table Definition..."
   menu-item mi_MSSQL_ConnInfo  label "&Edit Connection Information..."
   menu-item mi_MSSQL_ChgCP     label "C&hange DataServer Schema Code Page..."
   sub-menu mnu_mss_srv_attr    label "Server Attributes"  /* OE00195067 */
   menu-item mi_MSSQL_Delete    label "&Delete DataServer Schema..."
   RULE
   sub-menu mnu_mss_tools       label "Schema &Migration Tools"
   .

Define sub-menu mnu_Odbc
   menu-item mi_Odb_Create    label "&Create DataServer Schema..."
   menu-item mi_Odb_UpdFile   label "&Update/Add Table Definitions..."
   menu-item mi_Odb_VerFile   label "&Verify Table Definition..."
   menu-item mi_Odb_ConnInfo  label "&Edit Connection Information..."
   menu-item mi_odb_ChgCP     label "C&hange DataServer Schema Code Page..."
   menu-item mi_Odb_Delete    label "&Delete DataServer Schema..."
   RULE
   sub-menu mnu_odb_tools     label "Schema &Migration Tools"
   .

Define sub-menu mnu_ORACLE
   menu-item mi_ORA_Create    label "&Create DataServer Schema..."
   menu-item mi_ORA_UpdFile   label "&Update/Add Table Definitions..."
   menu-item mi_ORA_VerFile   label "&Verify Table Definition..."
   menu-item mi_ORA_ConnInfo  label "&Edit Connection Information..."
   menu-item mi_ORA_ChgCP     label "C&hange DataServer Schema Code Page..."
   menu-item mi_ORA_Delete    label "&Delete DataServer Schema..."
   sub-menu  mnu_ora_srv_attr label "Server Attributes"    /* OE00195067 */
   menu-item mi_ORA_SQLPlus   label "&Run ORACLE SQL*Plus..."
   RULE
   sub-menu mnu_ora_tools     label "Schema &Migration Tools"
   .


/*== DataServers Main Menu ==*/     /*###*/ /*###*/
Define sub-menu mnu_Gateway
   sub-menu mnu_MSSQL         label "MS S&QL Server Utilities"  
/*    sub-menu mnu_Odbc          label "O&DBC Utilities" */
   sub-menu mnu_ORACLE        label "&ORACLE Utilities"
   .


/*---------------Utilities Menus and its sub-menus--------------------------*/

Define sub-menu mnu_Quoter
   menu-item mi_Quo_EntLines  label "&Entire Lines..."
   menu-item mi_Quo_Delimiter label "By &Delimiter..."
   menu-item mi_Quo_ColRanges label "By &Column Ranges..."
   menu-item mi_Quo_InclFile  label "Quoter &Include File..."
   .

Define sub-menu mnu_GenIncl
   menu-item mi_Incl_Assign   label "&ASSIGN Statement..."
   menu-item mi_Incl_FORM     label "&FORM Statement..."
   menu-item mi_Incl_WorkFile label "&DEFINE WORK-TABLE Statement..."
   .

Define sub-menu mnu_Utilities
   menu-item mi_Util_ParmFile label "Editor for &Parameter Files..."
   sub-menu  mnu_Quoter              label "&Quoter Functions"
   sub-menu  mnu_GenIncl      label "&Generate Include Files"
   RULE
   menu-item mi_Util_AutoConn label "Edit OpenEdge &Auto-Connect List..."
   menu-item mi_Util_Freeze   label "&Freeze/Unfreeze..."
   menu-item mi_Util_IdxDeact label "Index &Deactivation..."
   RULE
   menu-item mi_Util_Info     label "&Information..."
   .


/*---------------------------Other menus----------------------------------*/

Define sub-menu mnu_SQL
   menu-item mi_SQL_ViewRpt   label "PRO/SQL View &Report..."
   menu-item mi_SQL_DumpView  label "Dump as CREATE &VIEW Statement..."
   menu-item mi_SQL_DumpTable label "Dump as CREATE &TABLE Statement..."
   .

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
Define sub-menu mnu_Help SUB-MENU-HELP
   MENU-ITEM mi_Hlp_Master       LABEL "OpenEdge &Master Help"
   menu-item mi_Hlp_Topics       label "Data Administration &Help Topics"
   RULE 
   menu-item mi_Hlp_Messages     label "M&essages..."
   menu-item mi_Hlp_Recent       label "&Recent Messages..."
   RULE
   menu-item mi_Hlp_About        label "&About Database Administration".
&ENDIF


/*----------------------------Menu bar-----------------------------------*/
Define {1} shared menu mnu_Admin_Tool
   MENUBAR
   sub-menu mnu_Database    label "&Database"

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   sub-menu mnu_Schema            label "&Schema"
   &ENDIF

   sub-menu mnu_Admin            label "&Admin"
   sub-menu mnu_Gateway     label "DataSer&ver"
   sub-menu mnu_Utilities   label "&Utilities"
   sub-menu mnu_SQL            label "&PRO/SQL"
   sub-menu mnu_Tools       label "&Tools"

   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   sub-menu mnu_Help            label "&Help"
   &ENDIF
   .


/*==========================Internal Procedures==========================*/

/*----------------------------------------------------------------------
   Do_Menu_Item_Initial

   This is the function called for each menu item on the initial walk
   through the menus.

   Input Parameter:
      p_hdl    - Handle to a menu item
      p_sub_ix  - Index of the sub-menu being processed (in Gray_Table)
      p_item_ix - Index of the menu item within this sub-menu.
----------------------------------------------------------------------*/
Procedure Do_Menu_Item_Initial:
   Define INPUT parameter p_hdl      as widget-handle NO-UNDO.
   Define INPUT parameter p_sub_ix   as integer       NO-UNDO.
   Define INPUT parameter p_item_ix  as integer       NO-UNDO.

   Define var gray as integer NO-UNDO.  /*  0 = gray, 1 = don't gray */
   Define var code as char    NO-UNDO.  /* FCXQRN entry from gray table */
   
   DEFINE VARIABLE hBuffer  AS HANDLE NO-UNDO.
   DEFINE VARIABLE hBuffer2 AS HANDLE NO-UNDO.

   IF (NUM-ENTRIES(Gray_Table[p_sub_ix])>=p_item_ix) THEN
     code = ENTRY(p_item_ix, Gray_Table[p_sub_ix]).
   ELSE ASSIGN code = ?.

   case PROGRESS:
      when "Full" then
               gray = INDEX(code, "F").
      when "COMPILE" then 
               gray = INDEX(code, "C").
      when "COMPILE-ENCRYPT" then 
               gray = INDEX(code, "X").
      when "Query" then 
               gray = INDEX(code, "Q").
      when "Run-Time" then 
               gray = INDEX(code, "R").
     end.

  IF NUM-DBS > 0 AND
      (INDEX(code,"Y") > 0 OR
       INDEX(code,"Z") > 0 OR
       INDEX(code,"B") > 0 OR
       INDEX(code,"A") > 0 OR 
       INDEX(code,"M") > 0 OR
	   INDEX(code,"D") > 0 OR 
       INDEX(code,"E") > 0) THEN DO:
     CREATE BUFFER hBuffer FOR TABLE "DICTDB._file".
     
     IF INDEX(code,"Z") > 0 THEN DO:
       /* Check to see whether this menu item requires the _db-detail 
          table in the database */
       hBuffer:FIND-FIRST("WHERE _file._File-Name = ~'_db-detail~'",
                          NO-LOCK) NO-ERROR.
       IF NOT hBuffer:AVAILABLE THEN gray = 0.

     END. /* INDEX(code,"Z") > 0 */

     IF INDEX(code,"B") > 0 THEN DO:
       /* Check to see whether this menu item requires the _db-option 
          table in the database */
       hBuffer:FIND-FIRST("WHERE _file._File-Name = ~'_db-option~'",
                          NO-LOCK) NO-ERROR.
       IF NOT hBuffer:AVAILABLE THEN gray = 0.

     END. /* INDEX(code,"B") > 0 */

     IF INDEX(code,"A") > 0 THEN DO:
       /* Check to see whether this menu item requires any of the audit 
          tables to be in the database */
       hBuffer:FIND-FIRST("WHERE _file._file-name BEGINS ~'_aud~'",
                          NO-LOCK) NO-ERROR.
    
       IF NOT hBuffer:AVAILABLE THEN gray = 0.
     END. /* INDEX(code,"A") > 0 */
	 
	 IF INDEX(code,"D") > 0 THEN DO:
       /* Check to see whether this menu item requires any of the CDC 
          tables to be in the database */
 
       hBuffer:FIND-FIRST("WHERE _file._file-name BEGINS ~'_Cdc~'",
                          NO-LOCK) NO-ERROR.
       IF NOT hBuffer:AVAILABLE THEN gray = 0.
     END. /* INDEX(code,"D") > 0 */
 
     IF INDEX(code,"E") > 0 THEN DO:
       /* Check to see whether this menu item requires encryption to be enabled */
       CREATE BUFFER hBuffer2 FOR TABLE "DICTDB._database-feature" NO-ERROR.
       IF VALID-HANDLE(hBuffer2) THEN DO:
          hBuffer2:FIND-FIRST("WHERE _database-feature._dbfeature_name = ~'encryption~'",
                             NO-LOCK) NO-ERROR.

          IF NOT hBuffer2:AVAILABLE OR hBuffer2::_dbfeature_enabled <> "1" THEN 
             ASSIGN gray = 0.
          ELSE DO:
              hBuffer2:BUFFER-RELEASE().

              /* can't maintain encryption if not local 
                 or not progress db or not sys admin */
              IF DBTYPE("DICTDB") NE "PROGRESS" OR 
                 user_dbtype NE "PROGRESS" OR
                 NOT dbAdmin(USERID("DICTDB")) THEN 
                 ASSIGN gray = 0.
          END.
          DELETE OBJECT hBuffer2 NO-ERROR.
       END.
       ELSE
           ASSIGN gray = 0.
     END. /* INDEX(code,"E") > 0 */

     IF INDEX(code,"M") > 0 THEN DO:
         IF DBTYPE("DICTDB") NE "PROGRESS" OR 
            user_dbtype NE "PROGRESS" OR
            NOT dbAdmin(USERID("DICTDB")) THEN 
            ASSIGN gray = 0.
     END.

     IF INDEX(code,"Y") > 0 THEN DO:
       /* Check to see whether this menu item requires any of the security
          tables to be in the database */
       hBuffer:FIND-FIRST("WHERE _file._file-name BEGINS ~'_sec-granted~'",
                          NO-LOCK) NO-ERROR.
     
       IF NOT hBuffer:AVAILABLE THEN gray = 0.
     END. /* INDEX(code,"Y") > 0 */

     DELETE OBJECT hBuffer.
   END. /* NUM-DBS > 0 and code = A, Z or Y */

   if gray = 0 then
      /* If this menu item not appropriate for this PROGRESS
         then disable it and set handle to ? so it will never
         get enabled.
      */
      assign
         p_hdl:sensitive = no
         Menu_Hdl[All_Items_ix] = ?. 
   else do:
      Menu_Hdl[All_Items_ix] = p_hdl.  /* store the menu handle */
      /* If we're not connected to a database and this isn't 
         appropriate when no database is connected then disable it 
      */
      if user_dbname = "" AND (INDEX(code, "N") = 0) then
         p_hdl:sensitive = no.
      ELSE p_hdl:SENSITIVE = (gray <> 0).
     end.
   
  end.


/*----------------------------------------------------------------------
   Do_Menu_Item_Db_Change

   This is the function called for each menu item on the subsequent
   walks through the menus when the database connection status has
   changed.

   Input Parameter:
      p_hdl    - Handle to a menu item
      p_sub_ix  - Index of the sub-menu being processed (in Gray_Table)
      p_item_ix - Index of the menu item within this sub-menu.      
----------------------------------------------------------------------*/
Procedure Do_Menu_Item_Db_Change:
   Define INPUT parameter p_hdl      as widget-handle NO-UNDO.
   Define INPUT parameter p_sub_ix   as integer       NO-UNDO.
   Define INPUT parameter p_item_ix  as integer       NO-UNDO.

   Define var code as char    NO-UNDO.  /* FCXQRN entry from gray table */

   /* If handle is ?, it's been grayed already and forever 
      because of the PROGRESS version or lack of gateway support.
      So do nothing */
   if NOT Menu_Hdl[All_Items_ix] = ? then
   do:
      /* If the menu item is marked as not appropriate when no database
               is connected (a "-" in the "N" slot) gray it or ungray it
               depending on if database is connected.  If it IS marked as
               appropriate even when there's no db connected (a "N" in the "N"
               slot) leave it alone - it will never be grayed.
      */
      IF NUM-ENTRIES(Gray_Table[p_sub_ix]) >= p_item_ix THEN
         code = ENTRY(p_item_ix, Gray_Table[p_sub_ix]).

      if INDEX(code, "N") = 0 then
         p_hdl:sensitive = (if user_dbname = "" then no else yes).
     end.
  end.


/*--------------------------------------------------------------------------
   Menu_Walk

   Walk through the menu tree and do menu graying.  This will be
   called once for initial menu graying and again for each time
   we switch between having a connected database and not having one.
   p_Func will do different things for each case.

   Input Parameter:
      p_hdl      - Handle to either the top level menu or a submenu.
      p_Func     - Function to call to process each menu item. 
      p_sm-alive - Flag to indicate if sub-menu should be disabled.  If any
                   of it's children are enabled, then it is "alive". 
----------------------------------------------------------------------------*/
Procedure Menu_Walk:
   Define INPUT  parameter p_hdl      as widget-handle NO-UNDO.  
   Define INPUT  parameter p_Func     as char          NO-UNDO.
   Define OUTPUT parameter p_sm-alive as logical       NO-UNDO init no.

    
   /* Submenu index that this recursive level is processing */
   Define var loc_sub_ix as integer NO-UNDO.  
   Define var item_ix    as integer NO-UNDO init 0.  /* index within submenu */
   Define var l_sm-alive as logical NO-UNDO.  /* store return value from   *
                                               * recursive calls to myself */

   loc_sub_ix = Submenu_ix.
   do while p_hdl <> ?:
      if p_hdl:type = "menu-item" then 
      do:
         assign
                 All_Items_ix = All_Items_ix + 1
                 item_ix      = item_ix + 1.
                 
               run VALUE(p_Func) (p_hdl, loc_sub_ix, item_ix).
               if p_hdl:sensitive then assign p_sm-alive = yes.  /* sub-menu alive; at *
                                                                  * least one enabled  *
                                                                  * menu-item          */
        end.
      else do:
               /* Don't handle the tools menu - common code deals with this */
               if NOT(p_hdl:type = "sub-menu" AND p_hdl:label = "&Tools") then
               do:
                  /* type will either be sub-menu or menu */
            if p_hdl:type = "sub-menu" then
               Submenu_ix = Submenu_ix + 1.
            run Menu_Walk (p_hdl:first-child, p_Func, OUTPUT l_sm-alive).
            if not l_sm-alive then
              p_hdl:sensitive = no.  /* disable sub-menu - no enabled children */
            else assign
              p_sm-alive = yes        /* at least one enabled sub-menu */
              p_hdl:sensitive = yes.  /* so enable parent              */
                 end.
        end.
      if p_hdl:type <> "menu" then  /* if not top-level menu bar */
               p_hdl = p_hdl:next-sibling.
      else
               p_hdl = ?.
     end.
  end.


/*----------------------------------------------------------------------
   Initial_Menu_Gray

   Gray menu items based on what the current version of PROGRESS 
   supports.  This includes the type of Progress as shown below as well
   as the gateways supported by this Progress.

   This graying only happens once since the executable doesn't change
   within one session.  Also, at this time check to see if there is a
   database connected.  If not, gray based on the "N" array as well.  
   We want to do it in one pass since menu graying can be very slow.
----------------------------------------------------------------------*/
Procedure Initial_Menu_Gray:
   Define var gate       as char NO-UNDO.
   Define var supp_gates as char NO-UNDO.  /* supported gateways */
   Define var all_gates  as char NO-UNDO.

   Define var g_all_ix  as integer NO-UNDO. /* index into all gateways list */
   Define var gate_ix   as integer NO-UNDO. /* index into Gray_Table array */
   Define var gate_list as char    NO-UNDO. /* list of "------"s for gateway */
   Define var junk      as logical no-undo. /* for output parm we don't care about */

   /* Change the Gray_Table based on whether this copy of PROGRESS
      supports certain gateways.  If a gateway is not supported, reset
      the comma delimited list for that gateway menu to all "------"'s so
      that all the menu items will be grayed out.
   */
   ASSIGN
     all_gates  = {adecomm/ds_type.i 
       &direction = "itype"
       &from-type = supp_gates
       }
     supp_gates = DATASERVERS.
   do g_all_ix = 1 to NUM-ENTRIES(all_gates):
      gate = ENTRY(g_all_ix, all_gates).
      if NOT CAN-DO(supp_gates, gate) then
            case gate:              
            when "MSS" then do:
               Gray_Table[{&MSSQL_IX}] =      /* MS-SQL Menu */
               "------,------,------,------,------,------,------,------".
               Gray_Table[{&MSSQL_IX} + 1] =  /* Migrate Menu */
               "------,------,------".
            end.
            when "ODBC" then DO:
               Gray_Table[{&ODBC_IX}] =
               "------,------,------,------,------,------,------,------".
               Gray_Table[{&ODBC_IX} + 1] = 
                 "------,------". 
            end.     
            when "ORACLE" then do:
                Gray_Table[{&ORACLE_IX}] =      /* ORACLE Menu */
                "------,------,------,------,------,------,------,------,------".
                Gray_Table[{&ORACLE_IX} + 1] =  /* Migrate Menu */
                "------,------,------,------".
            end.
            end case.          /*###*/
     end.
   
   /* Walk through the menu and do menu graying. */
   assign
      All_Items_ix = 0
      submenu_ix = 0.
   run Menu_Walk (MENU mnu_Admin_Tool:HANDLE, "Do_Menu_Item_Initial", OUTPUT junk).
  end.


/*------------------------------------------------------------------------ 
   Fix up the aliases.
------------------------------------------------------------------------*/
Procedure Reset_Aliases:
   IF LDBNAME("DICTDBG") <> ? THEN DELETE ALIAS "DICTDBG".
   IF user_dbname = "" THEN
      DELETE ALIAS "DICTDB".
   ELSE IF SDBNAME(user_dbname) = ? THEN DO:
      /* this case should never be executed except when running a copy
         of progress with a missing gateway (whatever that means!). */
      DO i = 1 TO cache_db#:
               IF cache_db_t[i] = user_dbtype AND cache_db_l[i] = user_dbname THEN 
                  LEAVE.
        end.
      CREATE ALIAS "DICTDB" FOR DATABASE VALUE(cache_db_s[i]) NO-ERROR.
     end.
   ELSE DO:
      IF    DBTYPE("DICTDB") = "PROGRESS"
       AND  user_dbtype     <> "PROGRESS" 
       THEN RUN prodict/_dctalia.p
              ( INPUT user_dbname
              ). /* switch DICTDB only if needed */
      IF  DBTYPE("DICTDB") <> "PROGRESS"
       THEN CREATE ALIAS DICTDB FOR DATABASE VALUE(SDBNAME(user_dbname)).
      IF LDBNAME(user_dbname) <> SDBNAME(user_dbname) 
       AND CONNECTED(user_dbname)
       THEN CREATE ALIAS "DICTDBG"
            FOR DATABASE VALUE(LDBNAME(user_dbname)) 
            NO-ERROR.
     end.
  end.


/*------------------------------------------------------------------------
   Reset the current database - the last one may have been disconnected
   or what have you.
   
   Input Parameter:
      p_Prev - name of previously connected database or "" if there
                     was no connected database.
------------------------------------------------------------------------*/
Procedure Reset_Db:

   Define INPUT PARAMETER p_Prev as char NO-UNDO.
   Define var junk as logical no-undo.  /* for output parm we don't care about */

   run Reset_Aliases.

   IF user_dbname = "" AND NUM-DBS > 0 THEN DO:
      RUN "prodict/_dctsget.p".
      RUN "prodict/_dctgues.p".
     end.
   /* If we've gone from having a database connected to not having one
      or vice-versa, we need to change menu gray state.
   */
   if (p_Prev = ""  AND user_dbname <> "") OR
      (p_Prev <> "" AND user_dbname = "") then
   do:
      assign
         All_Items_ix = 0
         submenu_ix = 0.
      run Menu_Walk (MENU mnu_Admin_Tool:HANDLE, "Do_Menu_Item_Db_Change", OUTPUT junk).
     end.
  end.


/*----------------------------------------------------------------------
   Perform_Func:

   Perform the function the user chose from the
   menu.  The input control string specifies what to do.
   Here is how the string is interpreted:

   If the statement looks like "number=value", where <number> is an
   integer from 1 to 19, then dictionary environment variable
   user_env[<number>] is set to <value>.  This is an assignment.

   If the statement begins with a star "*", it is an action statement.
   The different types of action strings are:
     *C - commit transaction
     *E - exit dictionary
     *N - nop (no operation, or do nothing)
     *O - OS-COMMAND (values in user_env[1-6] are the names of the
          programs to call (btos,msdos,os2,unix,vms,win32); user_env[7]
          is a default-value, used when any of user_env[1-6] = " "
     *Q - quit
     *R - rollback transaction.  this must be the last item in a
          control string, otherwise it is ignored (i.e., user_path
          must equal "*R" for this to execute properly).
     *T - start transaction, followed optionally by a colon ":" and
          the name of the procedure to execute when the user_path is
          empty.

   If the statement begins with a question mark "?", it is a DBTYPE
   string.  The name following the ? (e.g. "?ORA") is checked against
   the GATEWAYS function, and if the result is FALSE, a message is
   displayed and the control string is set to "".  In other words, 
   you can only perform this function if the current database is the
   given type.

   A "!" is similar to a "?", except that not only must the gateway be
   available in the current copy of PROGRESS, but the currently selected
   database must also be of that type.

   A "@" is similar to !, except that not only must the current database
   be of that type, but it must also be connected.

   If the statement is anything else, it is assumed to be a procedure.
   A "prodict/" is tacked on to the beginning, a ".p" is tacked on to
   the end, and it is RUN.
-----------------------------------------------------------------------*/
Procedure Perform_Func:
   Define INPUT parameter p_CtrlStr as char NO-UNDO.
   
   Define var prev_dbname as char    NO-UNDO.
   Define var ampersand   as integer NO-UNDO.
   Define var lbl         as char    NO-UNDO.
   

   hide message NO-PAUSE.

   /* Display menu pick text in header line, removing ampersand first */
   lbl = SELF:label.  /* based on trigger that called this function */
   ampersand = INDEX(lbl, "&").
   lbl = (if ampersand > 1 then SUBSTR(lbl,1,ampersand - 1,"character")
                           else "")
                + SUBSTR(lbl,ampersand + 1,-1,"character").
   lbl = TRIM (lbl, ".").  /* remove any elipsis */
   { prodict/user/userhdr.i lbl}

   assign
      user_path = p_CtrlStr   
      prev_dbname = user_dbname.

   run Reset_Aliases.

   /* Hide welcome frame */
   if frame guten-tag:visible then
      hide frame guten-tag.

   /* To parent dialogs properly. */
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      CURRENT-WINDOW = win.
   &ENDIF

   /* this is the main execute loop */
   mainl:
   DO WHILE user_path <> "" AND user_path <> "*E" AND user_path <> "*R"
             ON ERROR UNDO, LEAVE mainl
             ON STOP  UNDO, LEAVE mainl:
       if user_dbname = "" then 
           run "prodict/_dctexen.p".
       else do:
           if dict_trans then 
           _dict: 
           do transaction:
               run "prodict/_dctexec.p".
               if user_path = "*R" then undo _dict,leave _dict.
               catch onError as Progress.Lang.Error:
                    /* display alert box for error condition when transaction is rolled back  */
                   run showTransactionError(onError).
               end catch.
           end.
           else run "prodict/_dctexec.p".
       end.
   end.

   IF user_path = "*E" 
     THEN APPLY "CHOOSE" TO MENU-ITEM mi_Exit IN MENU mnu_Database.

   /* Make sure userpath is set properly, in the event main loop exited
    * because of an error.
    * We also need to clear the window and reset the cursor.
    *                                                   (hutegger 95/09)
    */
   user_path =  "".

   

   hide all no-pause.
   RUN adecomm/_setcurs.p ("").
   { prodict/user/usercon.i }
  
   /* Make sure current database is set properly. */
   IF user_path <> "*E" 
     THEN run Reset_Db (INPUT prev_dbname).

   ASSIGN dict_trans   = FALSE
          dict_dirty   = FALSE
          user_trans   = ""
          user_excepts = "".

   IF user_env[35] NE "persistent" THEN user_env = "".

   /* Reset context line */
   lbl = "Main Menu".
   { prodict/user/userhdr.i lbl}

  end.

/*------------------------------------------------------------------------ 
   Disable myself because user has run another tool.  This simply
   means disable the menu bar.
------------------------------------------------------------------------*/
Procedure disable_widgets:

   /* Unset global active ade tool variable. */
   ASSIGN h_ade_tool = ?.

   num_connected = NUM-DBS.   /* remember this for later */

   /* This only does top level menu items, so we don't have to worry 
      about messing up grayed/non-grayed items.
   */
   menu mnu_Admin_Tool:sensitive = no.

   if frame guten-tag:visible then
      hide frame guten-tag.
   hide frame user_hdr.
   hide frame user_ftr.
   hide message NO-PAUSE.
   SESSION:SUPPRESS-WARNINGS = sw_sav.  /* sw_sav is defined in _dictc.p */
  end.


Procedure showTransactionError:
    define input parameter  pError  as Progress.Lang.Error no-undo.
    define variable cMsg as character no-undo.
    define variable i as integer no-undo.
    define variable ctxt as character no-undo.
    do i = 1 to pError:NumMessages:
        cMsg = cMsg + pError:GetMessage (i) + chr(10).
    end.
    cMsg = trim(cMsg,CHR(10)).
    /* Show something a bit meaningful in context line */
     ctxt = "Apply Changes".
    { prodict/user/userhdr.i ctxt}
    message cMsg view-as alert-box title "Transaction Failed".     
end procedure.


/*------------------------------------------------------------------------ 
   Reactivate myself now that invoked tool has returned. 
------------------------------------------------------------------------*/
Procedure enable_widgets:
   
   Define var ix        as integer NO-UNDO.
   Define var all_conn  as logical NO-UNDO init yes.
   Define var curr_conn as logical NO-UNDO.
   Define var prev_db   as char    NO-UNDO.

   /* Set global active ade tool procedure handle to Procedure Editor. */
   ASSIGN h_ade_tool = THIS-PROCEDURE.

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      /* Reattach the menubar and redisplay hdr and ftr frames */
      default-window:menubar = menu mnu_Admin_Tool:handle.
      {prodict/user/userhdr.i user_hdr}
      { prodict/user/usercon.i user_filename} /* displays footer */

      /* Reset session attributes in case tool clobbered them. */
      ASSIGN
               session:APPL-ALERT-BOXES = NO
               session:SYSTEM-ALERT-BOXES = NO
               SESSION:SUPPRESS-WARNINGS = YES.
   &ELSE
      /* Reset session attributes in case tool clobbered them. */
      ASSIGN
         session:APPL-ALERT-BOXES = NO
         session:SYSTEM-ALERT-BOXES = YES
         SESSION:SUPPRESS-WARNINGS = YES.
   &ENDIF

   menu mnu_Admin_Tool:sensitive = yes.

   /* If any of the databases that were connected before are no longer
      connected or there are new ones connected, then reset the
      database cache.
   */
   curr_conn = connected (user_dbname).
   if num_connected = NUM-DBS then  /* this check is for efficiency */
   do ix = 1 to cache_db# while all_conn:
       all_conn = all_conn AND CONNECTED(cache_db_l[ix]).
   end.

   if num_connected <> NUM-DBS OR NOT all_conn then
   do:
      prev_db = user_dbname.
      if user_dbname <> "" AND NOT curr_conn then
      do:
           /* previous db no longer connected */
           user_dbname = "".
           user_dbtype = "".
           user_filename = "".
           { prodict/user/usercon.i user_filename} /* displays footer */
      end.
      if user_dbname = "" then
          run Reset_Db (INPUT prev_db). /* refresh cache and pick a new db */
      else 
          run "prodict/_dctsget.p".  /* refresh the cache */
    end.

    if curr_conn then 
    do:
        IF user_dbtype <> "PROGRESS" THEN
            /* Make sure alias is still set properly. */
            CREATE ALIAS "DICTDB" FOR DATABASE VALUE(SDBNAME(user_dbname)) NO-ERROR.
        ELSE
            CREATE ALIAS "DICTDB" FOR DATABASE VALUE(user_dbname) NO-ERROR.

        /* Since someone may have changed the schema in other tool */
        assign
            user_filename = ""
            cache_dirty = yes.
    end.
    {prodict/user/usercon.i user_filename} /* redisplay footer */
end procedure.

/* Execute the different utilities for encryption policies */
PROCEDURE encpol_tool.
    DEFINE INPUT PARAMETER mode AS CHAR NO-UNDO.

    IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
      MESSAGE "You must be a Security Administrator to access this utility!"
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
   END.
   IF DBTYPE(user_dbname) NE "PROGRESS" THEN DO:
       MESSAGE "You tried to perform some PROGRESS operation on a"
               DBTYPE(user_dbname) "database."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       RETURN.
   END.

   RUN prodict/sec/_sec-pol-driver.p (INPUT mode).
END.

/*=============================Triggers==================================*/

/*---------------------------Database menu-------------------------------*/

/*----- SELECT DATABASE -----*/
ON CHOOSE OF MENU-ITEM mi_DB_Select         IN MENU mnu_Database DO:
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   RUN Perform_Func ("1=get,_usrsget").
   &ELSE
   RUN Perform_Func ("1=get,_guisget").
   &ENDIF
   
   RUN  Initial_Menu_Gray.
END.

/*----- CONNECT DATABASE -----*/
ON CHOOSE OF MENU-ITEM mi_DB_Connect        IN MENU mnu_Database DO:
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=usr,_usrscon,1=new,_usrsget,*N").
   &ELSE
   run Perform_Func ("1=usr,_usrscon,1=new,_guisget,*N").
   &ENDIF

   RUN  Initial_Menu_Gray.
END.

/*----- DISCONNECT DATABASE -----*/
ON CHOOSE OF MENU-ITEM mi_DB_Disconnect     IN MENU mnu_Database DO:
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=dis,_usrsget").
   &ELSE
   run Perform_Func ("1=dis,_guisget").
   &ENDIF
   
   RUN  Initial_Menu_Gray.
END.

/*----- CREATE DATABASE -----*/
ON CHOOSE OF MENU-ITEM mi_DB_Create         IN MENU mnu_Database DO:
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrprdb,1=env,_usrscon,1=new,_usrsget,*N").
   &ELSE
   run Perform_Func ("_usrprdb,1=env,_usrscon,1=new,_guisget,*N").
   &ENDIF
   
   RUN  Initial_Menu_Gray.
END.

/*---------------------------Schema menu-------------------------------*/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
/*----- MODIFY TABLE -----*/
on choose of menu-item mi_Sch_ModTbl   in menu mnu_Schema
   run Perform_Func ("*T:_usrtrax,_usrtget,_usrtchg,19=alpha,_usrfchg").

/*----- CREATE TABLE -----*/
on choose of menu-item mi_Sch_AddTbl   in menu mnu_Schema
   run Perform_Func ("*T:_usrtrax,_usrtchg,19=alpha,_usrfchg").

/*----- DELETE TABLE -----*/
on choose of menu-item mi_Sch_DelTbl   in menu mnu_Schema  
   run Perform_Func ("_usrtdel").

/*----- FIELD EDITOR -----*/
on choose of menu-item mi_Sch_FldEdit  in menu mnu_Schema  
   run Perform_Func ("*T:_usrtrax,_usrtget,19=alpha,_usrfchg").

/*----- REORDER FIELDS -----*/
on choose of menu-item mi_Sch_ReordFld in menu mnu_Schema  
   run Perform_Func ("_usrtget,_usrfnum").

/*----- RENAME FIELDS -----*/
on choose of menu-item mi_Sch_RenamFld in menu mnu_Schema
   run Perform_Func ("_usrfglo").

/*----- INDEX EDITOR -----*/
on choose of menu-item mi_Sch_IdxEdit  in menu mnu_Schema
   run Perform_Func ("*T:_usrtrax,_usrtget,_usrichg").

/*----- SEQUENCE EDITOR -----*/
on choose of menu-item mi_Sch_SeqEdit  in menu mnu_Schema 
   run Perform_Func ("*T:_usrtrax,_usrkchg").

/*----- SQL PROPERTIES -----*/
on choose of menu-item mi_Sch_SQL      in menu mnu_Schema  
   run Perform_Func ("!PROGRESS,*T:_usrtrax,_usrtget,19=alpha,_guisqlw").
&ENDIF


/*----------------------------Admin/Dump menu---------------------------*/

/*----- DUMP DEFS -----*/
on choose of menu-item mi_Dump_Defs     in menu mnu_Dump   
   run Perform_Func ("9=d,1=s,_guitget,_usrdump,_dmpsddl").
  

/*----- DUMP CONTENTS -----*/
on choose of menu-item mi_Dump_Contents in menu mnu_Dump 
  run Perform_Func ("9=f,1=s,_guitget,_usrdump,*N,_dmpdata").
   
/*----- DUMP VIEWS -----*/
on choose of menu-item mi_Dump_Views    in menu mnu_Dump 
   run Perform_Func ("!PROGRESS,2=ALL,9=v,_usrdump,_dmpview").

/*----- DUMP USERS -----*/
on choose of menu-item mi_Dump_User     in menu mnu_Dump 
   run Perform_Func ("!PROGRESS,9=u,_usrdump,_dmpuser").


/*----- DUMP SECURITY AUTHENTICATION RECORDS -----*/
ON CHOOSE OF MENU-ITEM mi_Dump_Sec_Auth IN MENU mnu_Dump DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this dump option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.

  user_env[1] = "_sec-authentication-system,_sec-authentication-domain".
  RUN Perform_Func ("9=h,_usrdump,_dmpdata").
END.

/*----- DUMP SECURITY PERMISSIONS -----*/
ON CHOOSE OF MENU-ITEM mi_Dump_Sec_Perm IN MENU mnu_Dump DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this dump option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.

  ASSIGN user_env[1]  = 
                "_sec-role,_sec-granted-role,_sec-granted-role-condition"
         user_excepts = "_sys.audit.admin,_sys.audit.archive," + 
                        "_sys.audit.read,_sys.audit.appevent.insert".
  RUN Perform_Func ("9=m,_usrdump,_dmpdata").
END.

/*----- DUMP AUTO-CONNECT -----*/
on choose of menu-item mi_Dump_AutoConn in menu mnu_Dump 
   run Perform_Func ("!PROGRESS,9=a,_usrdump,_dmpsddl").

/*----- DUMP COLLATE/TRANSLATE Stuff -----*/
on choose of menu-item mi_Dump_CollTran in menu mnu_Dump 
   run Perform_Func ("!PROGRESS,9=c,_usrdump,_dmpsddl").

/*----- DUMP SEQUENCES -----*/
on choose of menu-item mi_Dump_SeqDefs  in menu mnu_Dump 
   run Perform_Func ("!PROGRESS,9=s,_usrdump,_dmpsddl").

/*----- DUMP SEQUENCE VALUES -----*/
on choose of menu-item mi_Dump_SeqVals  in menu mnu_Dump 
   run Perform_Func ("!PROGRESS,9=k,_usrdump,_dmpseqs").

/*----- DUMP AUDIT POLICIES -- AS XML -----*/
ON CHOOSE OF MENU-ITEM mi_Dump_as_XML IN MENU mnu_Dump_Aud_Pol DO:
  /* Ensure that the user has the appropriate permission assigned
     to dump audit data/policies. */
  IF NOT hasRole(USERID("DICTDB"),"_sys.audit.admin",FALSE) THEN DO:
    MESSAGE "You must have Audit Administrator permissions to " +
            "access this dump option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                           
    user_env = "".
    RETURN NO-APPLY.
  END. /* Permission Check */
                                           
  RUN Perform_Func 
      ("_aud-pol,9=x,2=_audit-policies.xml,35=persistent,_usrdump").

  IF user_env[1] = ? OR
     user_env[1] = "" THEN DO:
    user_env = "".
    RETURN NO-APPLY.
  END.

  IF user_env[1] = "All" THEN user_env[1] = "*".
  
  IF user_env[1] NE ? THEN
    RUN prodict/dump/_dmpaudp.p ( INPUT "x",
                                  INPUT user_env[1],
                                  INPUT user_env[2] ).

  user_env = "".
END.

/*----- DUMP AUDIT POLICIES -- AS TEXT -----*/
ON CHOOSE OF MENU-ITEM mi_Dump_as_Txt IN MENU mnu_Dump_Aud_Pol DO:
  DEFINE VARIABLE lRetry  AS LOGICAL     NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE cFilter AS CHARACTER   NO-UNDO.

  /* Ensure that the user has the appropriate permission assigned
     to dump audit data/policies. */
  IF NOT hasRole(USERID("DICTDB"),"_sys.audit.admin",FALSE) THEN DO:
    MESSAGE "You must have Audit Administrator permissions to " +
            "access this dump option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                                 
    user_env = "".
    RETURN NO-APPLY.
  END. /* Permission Check */
                                           
  RUN Perform_Func ("9=t,_aud-pol,35=persistent").

  IF user_env[1] = ? OR
     user_env[1] = "" THEN DO:
    user_env = "".
    RETURN NO-APPLY.
  END.

  cFilter     = user_env[1].
  user_env[1] = "_aud-audit-policy,_aud-event-policy," +
                "_aud-field-policy,_aud-file-policy".
  
  DO WHILE lRetry:
    RUN Perform_Func ("5=UTF-8,9=t,35=persistent,_usrdump").

    IF user_env[1] EQ ? THEN LEAVE.

    RUN prodict/dump/_dmpsec.p ( INPUT "",
                                 INPUT cFilter,
                                 INPUT user_env[2],
                                 INPUT user_env[30],
                                 INPUT "ap" ).

    lRetry = (RETURN-VALUE = "Retry").
  END.
  
  user_env = "".
END.
                   
/*----- DUMP AUDIT EVENTS -----*/
ON CHOOSE OF MENU-ITEM mi_Dump_Evt IN MENU mnu_Dump_Aud_Pol DO:
  /* Ensure that the user has the appropriate permission assigned
     to dump audit events. */
  IF NOT hasRole(USERID("DICTDB"),"_sys.audit.admin",FALSE) THEN 
    PERM-CHK: DO:
      
    MESSAGE "You must have Audit Administrator permissions to " +
            "access this dump option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                                 
    user_env = "".
    RETURN NO-APPLY.
  END. /* Permission Check */
                                           
  
  ASSIGN user_env[2] = "_aud-event.ad"
         user_env[1] = "_aud-event".

  RUN Perform_Func ("9=e,_usrdump,_dmpdata").

END.

/*----- DUMP AUDIT Data -----*/
ON CHOOSE OF MENU-ITEM mi_Dump_Aud_Data  IN MENU mnu_Dump DO:
  DEFINE VARIABLE lRetry  AS LOGICAL     NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE cFilter AS CHARACTER   NO-UNDO.

  /* Ensure that the user has the appropriate permission assigned
     to dump audit data/policies. */
  IF NOT hasRole(USERID("DICTDB"),"_sys.audit.archive",FALSE) THEN DO:
    MESSAGE "You must have Audit Archiver permissions to " +
            "access this dump option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                    
    user_env = "".
    RETURN NO-APPLY.
  END. /* Permission Check */
                                         
  RUN adecomm/_auddfilt.p ( INPUT "y",
                            OUTPUT user_env[1] ).

  IF user_env[1] = ? THEN DO:
    user_env  = "".
    user_path = "".
    RETURN NO-APPLY.
  END.
  
  cFilter     = user_env[1].
  user_env[1] = "_aud-audit-data,_aud-audit-data-value".
  user_env[5] = "UTF-8".

  DO WHILE lRetry:
    RUN Perform_Func ( "9=y,35=persistent,_usrdump" ).

    IF user_env[1] = ? THEN LEAVE.
        
    RUN prodict/dump/_dmpsec.p ( INPUT "",
                                 INPUT cFilter,
                                 INPUT user_env[2],
                                 INPUT user_env[30],
                                 INPUT "ad" ).

    lRetry = (RETURN-VALUE = "Retry").
  END.
            
  user_env = "".
END.

/*----- DUMP DATABASE IDENTIFICATION -----*/
ON CHOOSE OF MENU-ITEM mi_Dump_Db_ids  IN MENU mnu_Dump DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this dump option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        
    user_env = "".
    RETURN NO-APPLY.
  END.
 
   RUN Perform_Func ("9=i,1=_db-detail,2=_db-detail.d,_usrdump,_dmpdata").
END.

/*----- DUMP DATABASE IDENTIFICATION -----*/
ON CHOOSE OF MENU-ITEM mi_Dump_Db_Opt  IN MENU mnu_Dump DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this dump option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
 
    user_env = "".
    RETURN NO-APPLY.
  END.
   
  RUN Perform_Func ("9=o,1=_db-option,2=_db-option.d,_usrdump,_dmpdata").
END.

/*----- INCREMENTAL DF FILE -----*/
on choose of menu-item mi_Dump_IncrDF   in menu mnu_Dump
   run Perform_Func ("_usrincr,*N,_dmpincr").

/*----- DUMP CDC Policies -----*/
on choose of menu-item mi_Dump_CDC     in menu mnu_Dump 
DO:
  DEFINE VARIABLE lRetry  AS LOGICAL     NO-UNDO INITIAL TRUE.
                                             
  RUN Perform_Func ("9=p,_cdc-pol,35=persistent").

  IF user_env[1] = ? OR
     user_env[1] = "" THEN DO:
    user_env = "".
    RETURN NO-APPLY.
  END.
   
  DO WHILE lRetry:
   /* RUN Perform_Func ("9=p,35=persistent,_usrdump"). */
	RUN Perform_Func ("!PROGRESS,9=p,_usrdump").
    
    IF user_env[1] EQ ? THEN LEAVE.        

    DEF VAR h AS HANDLE NO-UNDO.
    RUN prodict/dump_cdc.p PERSISTENT SET h 
       (INPUT user_env[1], INPUT user_env[2], INPUT user_env[5]).
    RUN setSilent in h (?).
    RUN doDump IN h.
    DELETE PROCEDURE h.
			     			    
    lRetry = (RETURN-VALUE = "Retry").
  END.
  
  user_env = "".
END.


/*----------------------------Admin/Load menu---------------------------*/

/*----- LOAD DEFS -----*/
on choose of menu-item mi_Load_Defs     in menu mnu_Load 
   run Perform_Func ("9=d,_usrload").

/*----- LOAD CONTENTS -----*/
on choose of menu-item mi_Load_Contents in menu mnu_Load
   run Perform_Func ("9=f,1=s,_guitget,_usrload,*N,_loddata").

/*----- LOAD VIEWS -----*/
on choose of menu-item mi_Load_Views    in menu mnu_Load 
   run Perform_Func ("2=ALL,9=v,_usrload,_lodview").

/*----- LOAD USERS -----*/
on choose of menu-item mi_Load_User     in menu mnu_Load 
   run Perform_Func ("9=u,_usrload,_loduser").

/*----- LOAD SECURITY AUTHENTICATION RECORDS -----*/
ON CHOOSE OF MENU-ITEM mi_Load_Sec_Auth IN MENU mnu_Load DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this load option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    user_env = "".
    RETURN NO-APPLY.
  END.

  user_env[1]  = "_sec-authentication-system,_sec-authentication-domain".
  RUN Perform_Func ("9=z,_usrload,_loddata").
END.

/*----- LOAD SECURITY AUTHENTICATION RECORDS -----*/
ON CHOOSE OF MENU-ITEM mi_Load_Sec_Perm IN MENU mnu_Load DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this load option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    user_env = "".
    RETURN NO-APPLY.
  END.

  user_env[1]  = "_sec-role,_sec-granted-role," + 
                 "_sec-granted-role-condition".

  RUN Perform_Func ("9=m,_usrload,_loddata").
END.

/*----- LOAD SEQUENCE VALUES -----*/
on choose of menu-item mi_Load_SeqVals  in menu mnu_Load 
   run Perform_Func ("!PROGRESS,9=k,_usrload,_lodseqs").

/*----- LOAD AUDIT DATA -----*/
ON CHOOSE OF MENU-ITEM mi_Load_Aud_Data  IN MENU mnu_Load DO:
  DEFINE VARIABLE lRetry AS LOGICAL     NO-UNDO INITIAL TRUE.
  
  /* Ensure that the user has the appropriate permission assigned
     to load audit data/policies. */
  IF NOT hasRole(USERID("DICTDB"),"_sys.audit.archive",FALSE) THEN DO:
    MESSAGE "You must have Audit Archiver permissions to " +
            "access this load option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
    user_env = "".
    RETURN NO-APPLY.
  END. /* Permission Check */

  DO WHILE lRetry:
    RUN Perform_Func ( "35=persistent,9=y,_usrload" ).
    
    IF user_env[2] = ? THEN LEAVE.
      
    RUN prodict/dump/_lodsec.p ( INPUT user_env[2],
                                 INPUT "ad",
                                 INPUT LDBNAME("DICTDB"),
                                 INPUT user_env[30] ).
    
    lRetry = (RETURN-VALUE EQ "Retry").
  END.
                                       
  user_env = "".
                                         
END.

/*----- LOAD DATABASE IDENTIFICATION -----*/
ON CHOOSE OF MENU-ITEM mi_Load_DB_ids  IN MENU mnu_Load DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this load option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    user_env = "".
    RETURN NO-APPLY.
  END.

  RUN Perform_Func ("9=i,1=_db-detail,2=_db-detail.d,_usrload,5=n,_loddata").
END.

/*----- LOAD DATABASE IDENTIFICATION -----*/
ON CHOOSE OF MENU-ITEM mi_Load_DB_Opt  IN MENU mnu_Load DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this load option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    user_env = "".
    RETURN NO-APPLY.
  END.

  RUN Perform_Func ("9=o,1=_db-option,2=_db-option.d,_usrload,_loddata").
END.

/*----- LOAD AUDIT POLICIES -- AS XML -----*/
ON CHOOSE OF MENU-ITEM mi_Load_XML   IN MENU mnu_Load_Aud_Pol DO:
  /* Ensure that the user has the appropriate permission assigned
     to load audit data/policies. */
  IF NOT hasRole(USERID("DICTDB"),"_sys.audit.admin",FALSE) THEN DO:
    MESSAGE "You must have Audit Administrator permissions to " +
            "access this load option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     
    user_env = "".
    RETURN NO-APPLY.
  END. /* Permission Check */
  
  RUN Perform_Func ( "9=x,2=_audit-policies.xml,35=persistent,_usrload" ).

  IF user_env[2] NE ? THEN
    RUN prodict/dump/_lodaudp.p ( INPUT user_env[9],
                                  INPUT user_env[2],
                                  INPUT user_overwrite ).

  IF user_commit  EQ TRUE AND
     RETURN-VALUE EQ "" THEN
    AUDIT-POLICY:REFRESH-AUDIT-POLICY("DICTDB").

  user_env = "".
END.

/*----- LOAD AUDIT POLICIES -- AS TEXT -----*/
ON CHOOSE OF MENU-ITEM mi_Load_Txt   IN MENU mnu_Load_Aud_Pol DO:
  DEFINE VARIABLE lRetry AS LOGICAL     NO-UNDO INITIAL TRUE.

  /* Ensure that the user has the appropriate permission assigned
     to load audit data/policies. */
  IF NOT hasRole(USERID("DICTDB"),"_sys.audit.admin",FALSE) THEN DO:
    MESSAGE "You must have Audit Administrator permissions to " +
            "access this load option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                              
    user_env = "".
    RETURN NO-APPLY.
  END. /* Permission Check */

  DO WHILE lRetry:
    RUN Perform_Func ( "35=persistent,9=t,_usrload" ).

    IF user_env[2] = ? THEN LEAVE.
    
    RUN prodict/dump/_lodsec.p ( INPUT user_env[2],
                                 INPUT "ap",
                                 INPUT LDBNAME("DICTDB"),
                                 INPUT user_env[30] ).

    lRetry = (RETURN-VALUE EQ "Retry").
  END.
  
  IF (user_commit = TRUE) AND 
     RETURN-VALUE = "" THEN
    AUDIT-POLICY:REFRESH-AUDIT-POLICY("DICTDB").

  user_env = "".
END.


/*----- LOAD CDC Data -----*/
on choose of menu-item mi_Load_CDC in menu mnu_Load DO:
   DEFINE VARIABLE lRetry AS LOGICAL     NO-UNDO INITIAL TRUE.
   DEFINE VARIABLE v-path AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE v-file AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vSlash AS CHARACTER   NO-UNDO. 

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
     vSlash = "/".
  &ELSE 
     vSlash = "~\".
  &ENDIF

  DO WHILE lRetry:
  
    RUN Perform_Func ( "35=persistent,9=p,_usrload").

    IF user_env[2] = ? THEN LEAVE. 
    
    ASSIGN v-path = SUBSTRING(user_env[2],1,R-INDEX(user_env[2],vSlash))
           v-file = SUBSTRING(user_env[2],R-INDEX(user_env[2],vSlash) + 1,(INDEX(user_env[2],".") - R-INDEX(user_env[2],vSlash) - 1)).
    
    DEF VAR h AS HANDLE NO-UNDO.
	RUN prodict/load_cdc.p PERSISTENT SET h 
    (INPUT v-file, INPUT v-path).
	RUN SetAcceptableErrorPercentage in h (user_env[4]).
	RUN doLoad IN h.
	DELETE PROCEDURE h.
	
    /*RUN prodict/load_cdc.p (INPUT v-file,
                            INPUT v-path).                               */

    lRetry = (RETURN-VALUE EQ "Retry").
  END.
  /*IF (user_commit = TRUE) AND 
     RETURN-VALUE = "" THEN
    AUDIT-POLICY:REFRESH-AUDIT-POLICY("DICTDB").*/

  user_env = "".
END.


/*----- LOAD AUDIT EVENTS -----*/
ON CHOOSE OF MENU-ITEM mi_Load_Evt   IN MENU mnu_Load_Aud_Pol DO:
  /* Ensure that the user has the appropriate permission assigned
     to load audit events. */
  IF NOT hasRole(USERID("DICTDB"),"_sys.audit.admin",FALSE) THEN
    PERM-CHK: DO:
      
    MESSAGE "You must have Audit Administrator permissions to " +
            "access this load option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                                 
    user_env = "".
    RETURN NO-APPLY.
  END. /* Permission Check */
  
  RUN Perform_Func ( "9=e,1=_aud-event,2=_aud-event.ad,_usrload,_loddata" ).
END.

/*----- RECONSTRUCT BAD LOAD RECORDS -----*/
on choose of menu-item mi_Load_BadRecs  in menu mnu_Load 
   run Perform_Func ("_usrlrec,_dctlrec").

/*----------------------------Admin/DB Identification menu---------------------*/
ON CHOOSE OF MENU-ITEM mi_db_id_maint IN MENU mnu_dbid DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this utility!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  
    user_env = "".
    RETURN NO-APPLY.
  END.

  RUN Perform_Func ("_db-id-mnt").

END.

ON CHOOSE OF MENU-ITEM mi_db_id_hist IN MENU mnu_dbid DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this utility!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    user_env = "".
    RETURN NO-APPLY.
  END.
  RUN Perform_Func ("_db-id-hst").

END.

/*-------------------------Admin/Security menu---------------------------*/

/*----- EDIT USER LIST -----*/
on choose of menu-item mi_Sec_EditUser  in menu mnu_Security 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("!PROGRESS,_usruchg").
   &ELSE
   run Perform_Func ("!PROGRESS,_guiuchg").
   &ENDIF

/*----- CHANGE PASSWORD -----*/
on choose of menu-item mi_Sec_Password  in menu mnu_Security 
   run Perform_Func ("!PROGRESS,_usrupwd").

/*----- EDIT DATA SECURITY -----*/
on choose of menu-item mi_Sec_DataSec   in menu mnu_Security 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("9=rw,_usrtget,_usrsecu").
   &ELSE
   run Perform_Func ("9=rw,_guisecu").
   &ENDIF

ON CHOOSE OF MENU-ITEM mi_Sec_Aud_Perm            IN MENU mnu_Security
  RUN Perform_Func ("9=a,_sec-perm").

/*----- SECURITY ADMINISTRATORS -----*/
on choose of menu-item mi_Sec_Adminors  in menu mnu_Security 
   run Perform_Func ("!PROGRESS,_usradmn").

/*----- DISALLOW BLANK USERID ACCESS -----*/
on choose of menu-item mi_Sec_BlankId   in menu mnu_Security 
   run Perform_Func ("!PROGRESS,_usrblnk").

/*----- USER REPORT -----*/
on choose of menu-item mi_Sec_UserRpt   in menu mnu_Security 
   run Perform_Func ("_rptuqik").

/*----- AUTHENTICATION SYSTEM MAINTENANCE -----*/
ON CHOOSE OF MENU-ITEM mi_auth_sys    IN MENU mnu_auth_maint DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this utility!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
  RUN Perform_Func ("_sec-sys").
END.

ON CHOOSE OF MENU-ITEM mi_auth_dom    IN MENU mnu_auth_maint DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this utility!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
  END.
  RUN Perform_Func ("_sec-dom").
END.

/*----- SECURITY POLICIES-----*/
ON CHOOSE OF MENU-ITEM mi_encpol_edit    IN MENU mnu_Enc_Policies DO:
   RUN encpol_tool("edit").
END.

ON CHOOSE OF MENU-ITEM mi_encpol_regen   IN MENU mnu_Enc_Policies DO:
   RUN encpol_tool("generate").
END.

ON CHOOSE OF MENU-ITEM mi_encpol_history    IN MENU mnu_Enc_Policies DO:
   RUN encpol_tool("history").
END.

/*---------------------------Admin/Export menu---------------------------*/
        
/*----- EXPORT DIF -----*/
on choose of menu-item mi_Exp_DIF           in menu mnu_Export 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,9=dif,_usrexpo,_dmpdiff").
   &ELSE
   run Perform_Func ("_guitget,9=dif,_usrexpo,_dmpdiff").
   &ENDIF

/*----- EXPORT SYLK -----*/
on choose of menu-item mi_Exp_SYLK      in menu mnu_Export 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,9=sylk,_usrexpo,_dmpsylk").
   &ELSE
   run Perform_Func ("_guitget,9=sylk,_usrexpo,_dmpsylk").
   &ENDIF

/*----- EXPORT ASCII -----*/
on choose of menu-item mi_Exp_ASCII     in menu mnu_Export 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,9=ascii,_usrexpo,_dmpasci").
   &ELSE
   run Perform_Func ("_guitget,9=ascii,_usrexpo,_dmpasci").
   &ENDIF

/*----- EXPORT MS WORD -----*/
on choose of menu-item mi_Exp_MSWord    in menu mnu_Export 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,9=word,_usrexpo,_dmpasci").
   &ELSE
   run Perform_Func ("_guitget,9=word,_usrexpo,_dmpasci").
   &ENDIF


/*---------------------------Admin/Import menu---------------------------*/

/*----- IMPORT DIF -----*/
on choose of menu-item mi_Imp_DIF           in menu mnu_Import 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,9=dif,_usrimpo,_loddiff").
   &ELSE
   run Perform_Func ("_guitget,9=dif,_usrimpo,_loddiff").
   &ENDIF

/*----- IMPORT SYLK -----*/
on choose of menu-item mi_Imp_SYLK      in menu mnu_Import 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,9=sylk,_usrimpo,_lodsylk").
   &ELSE
   run Perform_Func ("_guitget,9=sylk,_usrimpo,_lodsylk").
   &ENDIF

/*----- IMPORT ASCII -----*/
on choose of menu-item mi_Imp_ASCII     in menu mnu_Import 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,9=ascii,_usrimpo,_lodasci").
   &ELSE
   run Perform_Func ("_guitget,9=ascii,_usrimpo,_lodasci").
   &ENDIF

/*----- IMPORT FIXED LENGTH -----*/
on choose of menu-item mi_Imp_FixedLen  in menu mnu_Import 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,9=fixed,_usrimpo,_lodasci").
   &ELSE
   run Perform_Func ("_guitget,9=fixed,_usrimpo,_lodasci").
   &ENDIF


   /*----- IMPORT dBASE DEFS -----*/
   on choose of menu-item mi_Imp_dBASEDefs in menu mnu_Import 
      run Perform_Func ("_usrsdbf,_lodsdbf,9=h,_usrload").

   /*----- IMPORT dBASE FILE CONTENTS -----*/
   on choose of menu-item mi_Imp_dBASECont in menu mnu_Import 
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      run Perform_Func ("_usrtget,9=dbf,_usrimpo,_loddbff").
      &ELSE
      run Perform_Func ("_guitget,9=dbf,_usrimpo,_loddbff").
      &ENDIF


/*---------------------------Admin/other menu items---------------------*/

/*----- CREATE BULK LOADER DESCRIPTION FILE -----*/
on choose of menu-item mi_BulkLoad      in menu mnu_Admin
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=s,_usrtget,9=b,_usrdump,_dmpbulk").
   &ELSE
   run Perform_Func ("1=s,_guitget,9=b,_usrdump,_dmpbulk").
   &ENDIF

/*----- DATABASE OPTIONS -----*/
ON CHOOSE OF MENU-ITEM mi_DbOptions     IN MENU mnu_Admin DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Security Administrator to access this utility!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        
    user_env = "".
    RETURN NO-APPLY.
  END.
  
  RUN Perform_Func ("_db-optn").
END.

/*----- ENABLE LARGE KEY ENTRIES -----*/
ON CHOOSE OF MENU-ITEM mi_LargeKeys     IN MENU mnu_Admin DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Database Administrator to access this utility!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        
    user_env = "".
    RETURN NO-APPLY.
  END.
  
  RUN Perform_Func ("_db-lkey").
END.

/*----- ALTERNATE BUFFER POOL MAINTENANCE -----*/
ON CHOOSE OF MENU-ITEM mi_AltBuf_Maint     IN MENU mnu_AltBuf DO:
   IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
     MESSAGE "You must be a Database Administrator to access this utility!"
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.

     user_env = "".
     RETURN NO-APPLY.
   END.

   IF DBTYPE(user_dbname) NE "PROGRESS" THEN DO:
       MESSAGE "You tried to perform some PROGRESS operation on a"
               DBTYPE(user_dbname) "database."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       RETURN.
   END.

   RUN prodict/pro/_alt-buf-driver.p (INPUT "edit").
END.

/*-------------------------------DataServer/MSSQL--------------------------*/

     /*----- Create Schema -----*/
     on choose of menu-item mi_MSSQL_Create    in menu mnu_MSSQL
        run Perform_Func
           ("?MSS,1=add,3=MSS,_mssschg,_gat_ini,*C,_gat_drv,*C,_gat_con,_mss_get,mss/procbfrpul,_mss_pul,_gat_cro").

     /*----- Update File Def -----*/
     on choose of menu-item mi_MSSQL_UpdFile   in menu mnu_MSSQL
        run Perform_Func
           ("!MSS,1=upd,_gat_ini,*C,_gat_con,_mss_get,mss/procbfrpul,_mss_pul,_gat_cro").

     /*----- Verify File Def -----*/
     on choose of menu-item mi_MSSQL_VerFile   in menu mnu_MSSQL
        run Perform_Func
          ("!MSS,1=,_gat_ini,*C,_gat_con,25=compare,_mss_get,mss/procbfrpul,_mss_pul,_gat_cmp,_gat_cro").

     /*----- Edit Connect Info -----*/
     on choose of menu-item mi_MSSQL_ConnInfo  in menu mnu_MSSQL
        run Perform_Func ("!MSS,1=chg,3=MSS,_mssschg").

     /*----- Change Code Page -----*/
     on choose of menu-item mi_MSSQL_ChgCP     in menu mnu_MSSQL   
        run Perform_Func ("!MSS,_gat_cp,_gat_cp1").

     /* OE00195067 */ 
     /*----- "Server Attributes" pop-up menu: Migrate DB to MS-SQL -----*/
     on choose of menu-item mi_mss_viw_mnt_cnst in menu  mnu_mss_srv_attr
        run Perform_Func("_msc_viw"). 
     on choose of menu-item  mi_mss_active_all_cnst in menu  mnu_mss_srv_attr
        run Perform_Func("_msc_act"). 
     on choose of menu-item  mi_mss_delete_all_cns in menu  mnu_mss_srv_attr
        run Perform_Func("_msc_del"). 
     on choose of menu-item  mi_mss_gen_cnst_frm_rowid in menu  mnu_mss_srv_attr  
        run Perform_Func("_mss_gid").

     /* OE00195067 */
     
     /*----- Delete Schema -----*/
     on choose of menu-item mi_MSSQL_Delete    in menu mnu_MSSQL
        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
        run Perform_Func ("!MSS,_usrsdel,*N,1=sys,_usrsget").
        &ELSE
        run Perform_Func ("!MSS,_usrsdel,*N,1=sys,_guisget").
        &ENDIF

     /*----- "Schema Migration Tools" pop-up menu: Migrate DB to MS-SQL -----*/
     on choose of menu-item mi_mss_Migrate in menu mnu_mss_tools
        run Perform_Func ("?MSS,mss/protomss").
     /*----- "Schema Migration Tools" pop-up menu: Incremental Dump -----*/
     on choose of menu-item mi_mss_Incre in menu mnu_mss_tools
       run Perform_Func ("!MSS,mss/_mss_inc").
     on choose of menu-item mi_mss_AdjstSI in menu mnu_mss_tools
        run Perform_Func ("!MSS,22=mss,mss/_beauty").



/*----------------------------DataServer/Odbc-----------------------------*
 
*----- Create Schema -----*
on choose of menu-item mi_Odb_Create    in menu mnu_Odbc
   run Perform_Func
      ("?ODBC,1=add,3=ODBC,_usrschg,_gat_ini,*C,_gat_drv,*C,_gat_con,_odb_get,25=add,_odb_pul,_gat_cro").
 
*----- Update File Def -----*
on choose of menu-item mi_Odb_UpdFile   in menu mnu_Odbc
   run Perform_Func 
     ("!ODBC,1=upd,_gat_ini,*C,_gat_con,_odb_get,25=upd,_odb_pul,_gat_cro").
 
*----- Verify File Def -----*
on choose of menu-item mi_Odb_VerFile   in menu mnu_Odbc
   run Perform_Func
     ("!ODBC,1=,_gat_ini,*C,_gat_con,25=compare,_odb_get,_odb_pul,_gat_cmp,_gat_cro").
 
*----- Edit Connect Info -----*
on choose of menu-item mi_Odb_ConnInfo  in menu mnu_Odbc
   run Perform_Func ("!ODBC,1=chg,3=ODBC,_usrschg").
 
*----- Change Code Page -----*
on choose of menu-item mi_Odb_ChgCP     in menu mnu_Odbc
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("!ODBC,_gat_cp,_gat_cp1").
   &ELSE
   run Perform_Func ("!ODBC,_gat_cp,_gat_cp1").
   &ENDIF

*----- Delete Schema -----*
on choose of menu-item mi_Odb_Delete    in menu mnu_Odbc
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("!ODBC,_usrsdel,*N,1=sys,_usrsget").
   &ELSE
   run Perform_Func ("!ODBC,_usrsdel,*N,1=sys,_guisget").
   &ENDIF   

*----- "Schema Migration Tools" pop-up menu: ProtoODBC -----*
on choose of menu-item mi_odb_DBtoODB in menu mnu_odb_tools
   run Perform_Func ("?ODBC,odb/protoodb").
 
*----- "Schema Migration Tools" pop-up menu: Adjust Schema -----*
on choose of menu-item mi_odb_AdjstSI in menu mnu_odb_tools
   run Perform_Func ("!ODBC,22=odbc,odb/_beauty").
 
*-----------------End of ODBC DataServer code -------------------*/
   
/*----------------------------DataServer/ORACLE---------------------------*/

/*----- Create Schema -----*/
on choose of menu-item mi_ORA_Create    in menu mnu_ORACLE 
   run Perform_Func 
     ("?ORACLE,1=add,3=ORACLE,_usrschg,_gat_ini,*C,_gat_con,_ora_lk0,*C,_ora_lkc,_ora_lkl").

/*----- Update File Def -----*/
on choose of menu-item mi_ORA_UpdFile   in menu mnu_ORACLE 
   run Perform_Func 
     ("!ORACLE,1=upd,_gat_ini,*C,_gat_con,_ora_lk0,*C,_ora_lkc,_ora_lkl").

/*----- Verify File Def -----*/
on choose of menu-item mi_ORA_VerFile   in menu mnu_ORACLE 
   run Perform_Func 
     ("!ORACLE,1=,_gat_ini,*C,_gat_con,_ora_lk0,*C,_ora_lkc,25=compare,_ora_lkl").

/*----- Edit Connect Info -----*/
on choose of menu-item mi_ORA_ConnInfo  in menu mnu_ORACLE 
   run Perform_Func ("!ORACLE,1=chg,3=ORACLE,_usrschg").

/*----- Change Code Page -----*/
on choose of menu-item mi_ORA_ChgCP     in menu mnu_ORACLE
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("!ORACLE,_gat_cp,_gat_cp1").
   &ELSE
   run Perform_Func ("!ORACLE,_gat_cp,_gat_cp1").
   &ENDIF

/* OE00195067 */ 
/*----- "Server Attributes" pop-up menu: Migrate DB to ORACLE -----*/
on choose of menu-item mi_ora_viw_mnt_cnst in menu  mnu_ora_srv_attr
    run Perform_Func("_orc_viw"). 
on choose of menu-item  mi_ora_active_all_cnst in menu  mnu_ora_srv_attr
    run Perform_Func("_orc_act"). 
on choose of menu-item  mi_ora_delete_all_cns in menu  mnu_ora_srv_attr
    run Perform_Func("_orc_del"). 

/* OE00195067 */

/*----- Delete Schema -----*/
on choose of menu-item mi_ORA_Delete    in menu mnu_ORACLE
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("!ORACLE,_usrsdel,*N,1=sys,_usrsget").
   &ELSE
   run Perform_Func ("!ORACLE,_usrsdel,*N,1=sys,_guisget").
   &ENDIF

/*----- SQL Plus -----*/
on choose of menu-item mi_ORA_SQLPlus   in menu mnu_ORACLE
   run Perform_Func ("?ORACLE,1= ,2=plus31,3= ,4= ,5= ,6=sqlplus,7=sqlplus,*O").

/*----- "Schema Migration Tools" pop-up menu: ProtoOra -----*/
on choose of menu-item mi_ora_DBtoORA in menu mnu_ora_tools
   run Perform_Func ("?ORACLE,ora/protoora").
   
/*----- "Schema Migration Tools" pop-up menu: Incremental Dump -----*/
on choose of menu-item mi_ora_Incre in menu mnu_ora_tools
   run Perform_Func ("!ORACLE,ora/_ora_inc").

/*----- "Schema Migration Tools" pop-up menu: Adjust Schema -----*/
on choose of menu-item mi_ora_AdjstSI in menu mnu_ora_tools
   run Perform_Func ("!ORACLE,22=ora,ora/_beauty").

/*----- "Schema Migration Tools" pop-up menu: Bulk Inserts -----*/
on choose of MENU-ITEM mi_ora_BInsert in menu mnu_ora_tools
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("!ORACLE,1=s,_usrtget,9=f,ora/_oraload,*N,35=ora,_loddata").
   &ELSE
   run Perform_Func ("!ORACLE,1=s,_guitget,9=f,ora/_oraload,*N,35=ora,_loddata").
   &ENDIF

/*-----------------------Utilities/Quoter menu--------------------------*/

/*----- ENTIRE LINES -----*/
on choose of menu-item mi_Quo_EntLines  in menu mnu_Quoter 
   run Perform_Func ("1=1,_usrquot").

/*----- By DELIMITER -----*/
on choose of menu-item mi_Quo_Delimiter in menu mnu_Quoter 
   run Perform_Func ("1=d,_usrquot").

/*----- BY COLUMN RANGES -----*/
on choose of menu-item mi_Quo_ColRanges in menu mnu_Quoter 
   run Perform_Func ("1=c,_usrquot").

/*----- INCLUDE FILE -----*/
on choose of menu-item mi_Quo_InclFile  in menu mnu_Quoter 
   run Perform_Func ("1=m,_usrquot").


/*------------------Utilities/General Include File menu------------------*/

/*----- ASSIGN -----*/
on choose of menu-item mi_Incl_Assign   in menu mnu_GenIncl 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,_usrcgen").
   &ELSE
   run Perform_Func ("_guitget,_usrcgen").
   &ENDIF

/*----- FORM -----*/
on choose of menu-item mi_Incl_FORM     in menu mnu_GenIncl 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,_usrfgen").
   &ELSE
   run Perform_Func ("_guitget,_usrfgen").
   &ENDIF

/*----- DEFINE WORKFILE -----*/
on choose of menu-item mi_Incl_WorkFile in menu mnu_GenIncl 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,_usrwgen").
   &ELSE
   run Perform_Func ("_guitget,_usrwgen").
   &ENDIF


/*-----------------------Utilities/other menu items---------------------*/

/*----- PARAMETER FILE EDITOR -----*/
on choose of menu-item mi_Util_ParmFile in menu mnu_Utilities 
   run Perform_Func ("_usrpfed").

/*----- AUTO-CONNECT EDITOR -----*/
on choose of menu-item mi_Util_AutoConn  in menu mnu_Utilities
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrauto").
   &ELSE
   run Perform_Func ("_guiauto").
   &ENDIF

/*----- FREEZE/UNFREEZE -----*/
on choose of menu-item mi_Util_Freeze   in menu mnu_Utilities 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("_usrtget,_usrcold").
   &ELSE
   run Perform_Func ("_guitget,_usrcold").
   &ENDIF

/*----- INDEX DEACTIVATE -----*/
on choose of menu-item mi_Util_IdxDeact in menu mnu_Utilities
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("9=note,_usriact,1=a,_usrtget,9=off,_usriact").
   &ELSE
   run Perform_Func ("9=note,_usriact,1=a,_guitget,9=off,_usriact").
   &ENDIF

/*----- INFORMATION -----*/
on choose of menu-item mi_Util_Info     in menu mnu_Utilities 
   run Perform_Func ("_usrinfo").


/*---------------------------PRO/SQL menu-------------------------------*/

/*----- VIEW REPORT -----*/
on choose of menu-item mi_SQL_ViewRpt   in menu mnu_SQL 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=a,_usrvget,_rptvqik").
   &ELSE
   run Perform_Func ("1=a,_guivget,_rptvqik").
   &ENDIF

/*----- DUMP AS CREATE VIEW -----*/
on choose of menu-item mi_SQL_DumpView  in menu mnu_SQL 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=a,_usrvget,_usrvgen").
   &ELSE
   run Perform_Func ("1=a,_guivget,_usrvgen").
   &ENDIF

/*----- DUMP AS CREATE TABLE -----*/
on choose of menu-item mi_SQL_DumpTable in menu mnu_SQL 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=a,_usrtget,_usrtgen").
   &ELSE
   run Perform_Func ("1=a,_guitget,_usrtgen").
   &ENDIF


/*--------------------------Reports menu----------------------------------*/

/*----- DETAILED TABLE REPORT -----*/
on choose of menu-item mi_Rpt_DetTbl    in menu mnu_Reports DO:

   assign user_env[42] =  "true".

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=a,_usrtget,9=,_rptflds").
   &ELSE
   run Perform_Func ("1=a,_guitget,9=,_rptflds").
   &ENDIF
end.

/*----- TABLE REPORT -----*/
on choose of menu-item mi_Rpt_Table     in menu mnu_Reports 
   run Perform_Func ("_rpttqik").

/*----- FIELD REPORT -----*/
on choose of menu-item mi_Rpt_Field     in menu mnu_Reports do:

   assign user_env[42] =  "true".

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=a,_usrtget,19=o,_rptfqik").
   &ELSE
   run Perform_Func ("1=a,_guitget,19=o,_rptfqik").
   &ENDIF
end.

/*----- INDEX REPORT -----*/
on choose of menu-item mi_Rpt_Index     in menu mnu_Reports do:
 
   assign user_env[42] =  "true".

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=a,_usrtget,_rptiqik").
   &ELSE
   run Perform_Func ("1=a,_guitget,_rptiqik").
   &ENDIF
end.

/*----- VIEW REPORT -----*/
on choose of menu-item mi_Rpt_View      in menu mnu_Reports 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=a,_usrvget,_rptvqik").
   &ELSE
   run Perform_Func ("1=a,_guivget,_rptvqik").
   &ENDIF

/*----- SEQUENCE REPORT -----*/
on choose of menu-item mi_Rpt_Sequence  in menu mnu_Reports 
   run Perform_Func ("_rptsqik").

/*----- TRIGGER REPORT -----*/
on choose of menu-item mi_Rpt_Trigger   in menu mnu_Reports 
   run Perform_Func ("_rpttrig").

/*----- USER REPORT -----*/
on choose of menu-item mi_Rpt_User      in menu mnu_Reports 
   run Perform_Func ("_rptuqik").

/*----- TABLE RELATIONS REPORT -----*/
on choose of menu-item mi_Rpt_TblRel    in menu mnu_Reports do:

   assign user_env[42] =  "true".

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("1=a,_usrtget,_rptrels").
   &ELSE
   run Perform_Func ("1=a,_guitget,_rptrels").
   &ENDIF
end.

/*----- AREA REPORT -----*/
on choose of menu-item mi_Rpt_Area      in menu mnu_Reports 
   run Perform_Func ("_rptaqik").

/*------WIDTH REPORT ----*/
ON CHOOSE OF MENU-ITEM mi_Rpt_Width IN MENU mnu_reports do:

   assign user_env[42] =  "true".

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   run Perform_Func ("!PROGRESS,1=a,_usrtget,_rptwdth").
   &ELSE
   run Perform_Func ("!PROGRESS,1=a,_guitget,_rptwdth").
   &ENDIF
end.

/*------ ALTERNATE BUFFER POOL WIDTH REPORT ----*/
ON CHOOSE OF MENU-ITEM mi_Rpt_AltBufPool IN MENU mnu_reports
   RUN Perform_Func ("_rptaltbuf").

/*------    Track Audit Policy Changes Report            -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_AudPol   IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=1,_rptaud"). /* AUD_POL_MNT */

/*------    Track Database Schema Changes Report         -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_DbSchma  IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=2,_rptaud"). /* SCH_CHGS */

/*------    Track Audit Data Administration Report       -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_AudAdmn  IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=3,_rptaud"). /* AUD_ARCHV */

/*------    Track Application Data Administration Report-------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_TblAdmn  IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=4,_rptaud"). /* DATA_ADMIN */

/*------    Track User Account Changes Report            -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_UsrAct   IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=5,_rptaud"). /* USER_MAINT */

/*------    Track Security Permissions Changes Report       -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_SecPerm  IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=6,_rptaud"). /* SEC_PERM_MNT */

/*------    Track Database Administrator Changes Report -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_Dba      IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=7,_rptaud"). /* DBA_MAINT */

/*------    Track Authentication System Changes Report   -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_AuthSys  IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=8,_rptaud"). /* AUTH_SYS */

/*------    Client Session Authentication Report         -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_CltSess IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=9,_rptaud"). /* CLT_SESS */

/*------    Database Administration Report               -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_DbAdmin IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=10,_rptaud"). /* DB_ADMIN */

/*------    Database Access Report                       -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_AppLogin IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=11,_rptaud"). /* DB_ACCESS */

/*------    Custom Audit Data Filter Report              -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_Cust IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=12,_rptaud"). /* CUST_RPT */

/*------    Track Encryption Policy Changes              -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_EncPol IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=13,_rptaud"). /* ENC_POL */

/*------    Track Key Store Changes                      -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_KeyStore IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=14,_rptaud"). /* ENC_KEYSTORE */

/*------   Database Encryption Administration (Utilities) -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_EncAdmin IN MENU mnu_Aud_Rep
  RUN Perform_Func ("9=15,_rptaud"). /* ENC_ADMIN */

/*------    Security Report - Quick                      -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_QkEncPol IN MENU mnu_enc_Rep
  RUN Perform_Func ("9=1,_rptencp").

/*------    Security Report - Detailed                   -------*/
ON CHOOSE OF MENU-ITEM mi_Rpt_DtEncPol IN MENU mnu_Enc_Rep DO:

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Database Administrator to access this report!"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.

  user_env = "".
  RETURN NO-APPLY.
END.


IF DBTYPE("DICTDB") NE "PROGRESS" THEN DO:
    MESSAGE "Cannot use this option with this database type."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_env = "".
  RETURN NO-APPLY.
END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    RUN Perform_Func ("1=a,_usrtget,9=2,_rptencp").
&ELSE
    RUN Perform_Func ("1=a,_guitget,9=2,_rptencp").
&ENDIF

END.

/*------------------------------Tools menu-------------------------------*/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   {adecomm/toolrun.i &MENUBAR       = "mnu_Admin_Tool"
                      &EXCLUDE_ADMIN = yes 
                                   &EXCLUDE_DICT  = yes
   }
&ELSE
   {adecomm/toolrun.i &MENUBAR       = "mnu_Admin_Tool"
                      &EXCLUDE_ADMIN = yes 
   }
&ENDIF
if tool_bomb then return.  /* admin is already running so quit. */


/*-----------------------------Help menu----------------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
/*----- HELP CONTENTS -----*/
on choose of menu-item mi_Hlp_Topics in menu mnu_Help
   RUN "adecomm/_adehelp.p" ("admn", "TOPICS", ?, ?).

ON CHOOSE OF MENU-ITEM mi_Hlp_Master IN MENU mnu_Help
    RUN "adecomm/_adehelp.p" ("mast", "TOPICS", ?, ?).

/*----- MESSAGES HELP -----*/
on choose of menu-item mi_Hlp_Messages in menu mnu_Help
   run prohelp/_msgs.p.

/*----- RECENT MESSAGES HELP -----*/
on choose of menu-item mi_Hlp_Recent   in menu mnu_Help
   run prohelp/_rcntmsg.p.

/*----- HELP ABOUT ADMIN -----*/
on choose of menu-item mi_Hlp_About in MENU mnu_Help
   run adecomm/_about.p ("Database Administration", "adeicon/admin%").

&ENDIF
