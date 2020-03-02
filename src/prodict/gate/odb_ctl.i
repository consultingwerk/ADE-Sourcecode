/*********************************************************************
* Copyright (C) 2005,2006,2008,2009,2010,2011,2014 by Progress Software Corporation.*
* All rights reserved.  Prior versions of this work may contain      *
* portions contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* odb_ctl.i - Odbc schema control settings */
/*
Note 'ODBALLOWED':
  This is a list of object types that the gateway supports.  Currently,
  "VIEW" "TABLE" "SYSTEM TABLE" and "PROCEDURE" are allowed.

Note 'SOBJECTS' 'POBJECTS':
  sobjects contains a list of Odbc objects as they described in the
  SQLTables API call. pobjects is their PROGRESS name.
 
This file has been moved from odb to gate because it will be used by both
the ODBC DataServer and the MSS DataServer  DLM  6/19/00

Schema holder version number introduced  DJM  10/27/05
  
*/

DEFINE VARIABLE datetime             AS LOGICAL   NO-UNDO.
DEFINE VARIABLE odballowed           AS CHARACTER NO-UNDO.
DEFINE VARIABLE pobjects             AS CHARACTER NO-UNDO.
DEFINE VARIABLE sobjects             AS CHARACTER NO-UNDO.
/* dictionary version format changed to ###.##, (same as dataserver client / server format) */
/* default dictionary version, continues to be "2.000.0000" ONLY */
DEFINE VARIABLE odbc-dict-ver        AS CHARACTER NO-UNDO INIT "4.000.000".
/* New dictionary version is "103.00", this will be set when new features are used */
/* For 10.2B in MSSDS, if PROGRESS_RECID uses computed column then New dictionary version is set*/
/* in $RDLRH/dtcomm.h, #define DATA_SRVR_VERS105  10300 */
DEFINE VARIABLE odbc-dict-ver-new    AS CHARACTER NO-UNDO INIT "103.00".

/* Normally we would track schema holder changes with a version change to
 * Schema holder but for legacy reasons, we need to use dictionary version.
 * odbc-dict-ver should have changed to 2 in 101B but was not discovered until
 * all service pack releases. Therefore the change will be applied to 101b tfix
 * branch, 101C & 102A and above */

/**********************************************************************************************

  The value of "prgrs_clnt" input to _Db._Db-misc2[7] changes from 
    "<vers>" 
     to 
    "<vers>:sh_min=<minvers>,sh_max=<maxvers>."
      where <vers> is the Progress Client Version number
        and <minvers> is the minimum schema holder version compatible with this Progress client
        and <maxvers> is the maximum schema holder version compatible with this Progress client
        <minvers> and <maxvers> are maintained by the Progress client connected to the schema
        holder.

   Db._Db-misc2[6] changes to 
     "Dictionary Ver#: <dict-vers>" + "Client Ver#: <clnt-vers>" + "Server Ver# <srvr-vers>" +
       "Schema Holder Ver# <sch-hldr-vers>" 
      where <sch-hldr-vers> is the current version of the schema holder
      <sch-hldr-vers> is set initially to <minvers> but is maintained by the Dictionary as
        version features are added to the schema holder.

   ** NOTE: There are change requirements in _odb_get.p if these formats are further changed. **

   The schema holder version number is being introduced in Progress client
   and dictionaries in  versions 9.1E03, 10.0B04, and 10.1A.  The progress 
   client version for all these versions will be set to "101".  But the maximum
   compatible schema holder version will only be set to "2" for 10.1A and 10.0B04.
   9.1E03 will have a maximum schema holder version number of "1" meaning 
   incompatibilities with Version 2 schema holder features will exist.

   Since the Progress client and Dictionary are mutually responsible for the content 
   in the schema holder, they should apply the schema holder version in coordinated
   fashion.  The Progress Client passes the schema holder minumum version number to 
   the Dictionary through the GetInfo_buffer.  The minimum value is applied to a newly
   built schema holder unless the Dictionary has a valid reason to override or update 
   that value.  The Dictionary may upgrade the schema holder version number either 
   automatically, because of features inherent in this version of the Dictionary, or 
   conditionally, because of features associated with a newer schema holder version 
   that are enacted in this schema holder through the use of dictionary utilities.  
   NOTE:  It is possible, but unlikely, that a schema holder version number will be
   applied by the dictionary that is  greater than the schema holder version range 
   declared by the client to be supported.  Since the client and dictionary are shipped 
   together, it is not likely that a version of the Dictionary that is incompatible with 
   the current version of the client will be used to maintain the schema holder.
   But the dictionary should test for this possibility just in case the utilities 
   used to build or upgrade a schema holder happen to be incompatible with the current
   client version that uses it.

   Ultimately, the schema holder version number should reflect the level of features 
   implemented in the schema holder through the dictionary and/or Progress client.

   With these changes, Progress clients that are incompatible with new dictionary features,
   or old dictionaries that are incompatible with newer clients can be identified and 
   conveyed to customer.

   Schema Holder Version Change Log:
    --------------------------------
    1 - Is the baseline for everything before OpenEdge Version 10.1A, 10.0B04
        and 9.1E03.
    2 - Introduces an "_" suffix identifier, instead of "#" for array field suffixes
         used against a DB2 database.  The presence of these entries are determined 
         by the dictionary which will conditionally and automatically upgrade the 
         version number in the schema holder's _Db record.

    # - Introduces .... 
    # - Introduces .... 
*/

&GLOBAL-DEFINE ODBC_SCH_VER1 1
&GLOBAL-DEFINE ODBC_SCH_VER2 2

/* List of certified drivers. Warning is issued for non certified drivers. */
DEFINE VARIABLE odbc-certify-list AS CHARACTER NO-UNDO.
/*
 Each odbc-bug-list[N] variable includes a list of ODBC drivers which have 
 the bug. "ALL" suggests that all the drivers has the bug. Each            
 odbc-bug-excld[N] variable include a list of ODBC drivers which DON'T have
 the bug (useful if you want to exclude specific drivers where ALL was     
 specified.                                                                 

 BUG-1 is the inability to use Search Patterns in a Catalog function  
       for qualifiers.                                                
 BUG-2 is an occasional corrupt of prepared statements at the end of  
       a transaction.                                                 
 BUG-3 is the inconsistency of the sort order of NULL values.         
 BUG-4 is the description of all the components of an index in one row
       concatenating the fields: "fld1+fld2+fld3..."                  
 BUG-5 the support of only one statement per connection.                
 BUG-6 Multiple connection can block each other.                        
 BUG-7 Quoting an identifier does not work.                                
 BUG-8 is the inability to use Search Patterns in a Catalog function  
       for owners.                                                            
 BUG-9 is wrong type values returned from SQLColumnAttributes. To work
       around it, we skip runtime schema comparison.                       
 BUG-10 is not being able to handle WHERE 1 = 2 clauses.              
 BUG-11 NULL is sorted to be the lowest value. Turn BUG-3 off !!        
 BUG-12 Do SELECT <key> not SELECT <flds> - More compatible but slow. 
 BUG-13 Lock/transaction mode 1 support by driver:                          
            Exclusive-lock & Lock Upgrade.                               
              No shared-lock support,                                        
              One connection.                                                
              async mode.                                                
              only scrolling cursors.                                        
          Lock/transaction mode 0 by driver, which is the default:        
              No lock control.                                               
              Use the dbmgr isolation level for concurrency control.        
              By default - One connection only.                               
              no async mode.                                               
              might use non scrolling cursors.                               
 BUG-14 Does not follow the ODBC protocol for the LIKE where clause   
        operator. Wants the type of the value to match the type of    
           the field instead of being specified as SQL_VARCHAR.                
 BUG-15 The db has a "timestamp" field which get updated with each row
           update.                                                        
 BUG-16 We use SQLColumns, at runtime, to get schema info, instead of 
          SQLColumnsAttributes - to prevent waiting on a lock.                
        To avoid a full table scan by not issuing SQL statement        
        "select * from table where 1=2" for Access2 driver             
        ODBCJT16.DLL per bug #95-09-01-043.                           
 BUG-17 UPPER function for the WHERE clause is not supported.                
 BUG-18 This driver needs the hint system.                                
 BUG-19 This driver gives the wrong index uniqueness info.                
 BUG-20 This bug used to only apply to the Informix driver.  It has   
        been revamped to be switched on for all drivers in which the  
        record lock wait state needs to be modified from its          
        data source default.  If the driver doesn't do it, we must.   
 BUG-21 The driver cannot handle FLD LIKE ? phrase. We put                
           FLD LIKE <literal> instead.                                        
 BUG-22 Driver sends wrong data about indexes - don't build indexes   
          automatically.                                                
 BUG-23 The driver has some problems in qualifying object in SQLTab().
        We will qualify, on the client side, the objects for schema   
          import.                                                        
 BUG-24 The driver has some problems with wild cards in SQLTables().  
        We will qualify, on the client side, the objects for schema   
          import if wild cards are used. Note that BUG-23 implies       
          BUG-24.                                                        
 BUG-25 The driver supports WHERE char_fld = <value> even if <value>  
          is longer then what char_fld can hold. We would allow that    
          expression for those drivers.                                        
 BUG-26 The driver has problems with re-using prepared statements -   
        we don't reuse them.                                                
 BUG-27 The driver has problems with join by sql db - do it by client.
 BUG-28 Don't create OWNER.TABLE names, since "OWNER." is added by    
        the Driver.                                                   
 BUG-29 The driver has proprietary ODBC extensions for BLOB/CLOB      
            support. Specifically, the driver uses -98/-99 for these      
        large objects. Progress will translate these to LongVarBinary 
        datatype.                                                     
 BUG-30 The driver supports setting transaction isolation level on        
            a statement basis. I.e., PODBC can change it within a         
            transaction, not just before a transaction begins. Note that  
        per-statement isolation is NOT ODBC V2.0 conformant, but is        
            very useful for Progress.                                                         
 BUG-31 The driver supports the use of % and _ in LIKE string by      
        using brackets around the characters.  Driver doesn't support 
        the escape clause.                                            
 BUG-32 Driver does not support the ESCAPE clause.  There is no known 
        mechanism to use % and _ characters in the LIKE string.          
 BUG-33 Driver does NOT support ASYNC as PODBC prefers, so PODBC will 
        not issue ASYNC_ENABLE  call to driver. Crucial rule that        
        driver must follow is to support polling for call completion        
        by call with truncated parameter list (see dtserror.c).           
        Thus, if this flag on, PODBC will NOT request driver to do    
        ASYNC at Connect time. If flag off, PODBC will request ASYNC. 
 BUG-34 Driver expects databases of the format dbname:owner.table     
        as opposed to dbamae.owner.table.  If the flag is on, then    
          change the format of the full table name to use a :, not dot.      
 BUG-35 This switch indicates that dynamic cursors need to be added   
        to enable the use of server-side cursors in MSSQL.  This      
        indirectly removes the restriction that a cursor be closed    
        before another statement can be executed.                     
 BUG-36 This switch indicates that firehose cursors need to be   
        enabled for MSSQL.
 BUG-37 This switch indicates that transactions need to be disabled
        for tdriver tests.
 BUG-38 SQLColumns returns Type-name as "text" for varchar(max) and
        "image" for varbinary(max).
 BUG-39 Issue specific to Data Direct Wire protocol driver for 
        SQL Server.
 
 Modified by    : Anders Luk 2/7/96 Adding new 32-bit drivers for certification                
                        Informix5 - Intersolv IVINF508.DLL                
                        Dbase 5.5 - Intersolv IVDBF08.DLL                
                        Access 7.0 - MS ODBCJT32.DLL                        
                       Paradox 7.0 - MS ODBCJT32.DLL ?   
                                            
                  SLK 2/20/97 Fix s/e 135 More than 4096 chars in single statement  
                                                                      
                  DJM 10/26/99 Resolve problem with Microsoft driver cursor limitations  
                  
                  DJM 11/19/99 Added Intersolv 3.5 and Progress-branded drivers to the list for 
                               Informix, MSSQL, and Oracle.  
                       Informix7 - Intersolv IVINF14.DLL,P1INF14.DLL  
                       Oracle7&8 - Intersolv IVOR714.DLL,IVOR814.DLL  
                       SQL Srvr - Intersolv IVMSSS14.DLL,P1MSSS14.DLL IVMSSS15.DLL              
                       
                  DLM 06/19/00 Moved from prodict/odb to prodict/gate   
                  
                  DLM 10/25/00 Removed bug flag 7 from MSS              
                  
                  Savitha Rajiv 01/31/2001  Added Merant 3.7and Progress-branded drivers 
                                           to the list for Informix, MSSQL, and DB2.  					
                       Informix7 - Merant IVINF16, P1INF16.DLL, IVINF18.DLL, P1INF18.DLL  	
                       DB2 - Merant IVUDB16.DLL, P1UDB16.DLL,		
			 	                    P1DB216.DLL, IVDB216.DLL  		
                       SQL Srvr - Merant  IVMSSS16.DLL,P1MSSS16.DLL   
                                  IVSS616.DLL, P1SS616.DLL	     
                                  
                 DLM 09/08/03 Added Data Direct 4.2 drivers 10.0A
                 DCS 04/08/04 Added BUG-36 for firehose cursors
                 DCS 04/26/04 Added BUG-37 for FFO cursor testing
                 rkumar 08/28/07 Added DataDirect 5.3 drivers 10.1C
		 rkumar 06/26/08 Added DataDirect 5.3 64-bit drivers for 10.2A release
		 rkumar 03/20/09 Added DataDirect 6.0 32-bit and 64-bit drivers 
				 for 10.2B release
                 musingh 08/09/11 Added ODBC Wire Protocol driver for DB2 in BUG-33
				 
                 Mahesh Anem 30/09/2011 Removing the Data Direct 6.0 DLL entries from the list of Bug[26].
                 musingh 03/30/11 Added BUG-38 for SQLColumns
                 musingh 01/29/13 Added SNAC11 driver (SQLNCLI11.DLL).
		 ashukla 09/11/14 Added DataDirect 7.1.4 32-bit and 64-bit legacy wire protocol drivers 
				 for 11.5 release (to address ssl security issue)
		vprasad 08/10/2018 Added ODBC Driver 13 and 17 for SQL Server
		vprasad 18/Jun/2019 Added ODBC8.0
*/ 
DEFINE VARIABLE odbc-bug-list AS CHARACTER EXTENT 80 NO-UNDO.
DEFINE VARIABLE odbc-bug-excld AS CHARACTER EXTENT 80 NO-UNDO.

ASSIGN
odbc-certify-list = "PROGODBC.DLL,ODBCJT16.DLL,SIMBA.DLL,DB2CLIW.DLL,"
        + "PODBC_Sybase_Driver,PODBC_Allbase_Driver,PODBC_DB2_Driver,"
        + "QEINF04.DLL,QEINF05.DLL,QEINF06.DLL,QEPDX04.DLL,QEPDX05.DLL,"
        + "QEPDX06.DLL,QEPDX07.DLL,QEDBF03.DLL,QEDBF04.DLL,QEDBF05.DLL,"
        + "QEDBF06.DLL,QEDBF07.DLL,QEINF503.DLL,QEINF504.DLL,"
        + "QEINF505.DLL,QEINF506.DLL,QEINF507.DLL,PODBC_M/S_SQL_Server_Driver"
odbc-bug-list[1] = "ODBCJT32.DLL,ODBCJT16.DLL,SIMBA.DLL,QEDBF,QEPDX,QEGUP,IVDBF"
odbc-bug-list[2] = "SIMBA.DLL,QEDBF,QEPDX,IVDBF"
odbc-bug-list[3] = "ALL"
odbc-bug-list[4] = "QEDBF,QEPDX,IVDBF"
odbc-bug-list[5] = "PODBCSYB,PODBC_Sybase_Driver,PODBC_M/S_SQL_Server_Driver"
odbc-bug-list[6] = "PODBC_Sybase_Driver,PODBC_M/S_SQL_Server_Driver" 
odbc-bug-list[7] = "QEGUP,DB2CLIW.DLL,PODBC_M/S_SQL_Server_Driver,"
                    + "DB2CLI.DLL,IVOR709.DLL,IVOR714.DLL,IVOR814.DLL,IVDB214.DLL,P1DB214.DLL,"
                    + "IVUDB16.DLL,P1UDB16.DLL,P1DB218.DLL,IVDB218.DLL,P1DB219.DLL,IVDB219.DLL,"
                    + "P1DB220.DLL,IVDB220.DLL,P1DB221.DLL,IVDB221.DLL,"
                    + "P1DB223.DLL,IVDB223.DLL,"
		    + "P2DB223.DLL,DDDB223.DLL,CWBODBC.DLL,"
		    + "P1DB224.DLL,IVDB224.DLL,P2DB224.DLL,DDDB224.DLL,"
                    + "PGDB226.DLL,IVDB226.DLL,PGDB226.DLL,DDDB226.DLL,"
                    + "P1DB227.DLL,IVDB227.DLL,P2DB227.DLL,DDDB227.DLL"
odbc-bug-list[8] = "SIMBA.DLL,QEDBF,QEPDX,IVDBF"
odbc-bug-list[9] = "QEGUP"
odbc-bug-list[10] = "PODBC_Sybase_Driver,QEINF,QEINF5,PODBC_Allbase_Driver,"
                    + "PODBC_M/S_SQL_Server_Driver,IVINF508.DLL,IVINF709.DLL,IVINF16.DLL,"
                    + "P1INF16.DLL,IVINF14.DLL,P1INF14.DLL,P1IFCL18.DLL,IVIFCL18.DLL,"
                    + "IVINF18.DLL,P1INF18.DLL,P1IFCL19.DLL,IVIFCL19.DLL,IVINF19.DLL,P1INF19.DLL"
odbc-bug-list[11] = "PODBC_Sybase_Driver,QEINF,QEINF5,IVINF508.DLL,IVINF709.DLL,"
                    + "IVINF16.DLL,P1INF16.DLL,IVINF14.DLL,P1INF14.DLL,P1IFCL18.DLL,"
                    + "IVIFCL18.DLL,ODBC_M/S_SQL_Server_Driver,IVINF18.DLL,P1INF18.DLL,"
                    + "P1IFCL19.DLL,IVIFCL19.DLL,IVINF19.DLL,P1INF19.DLL,"
                    + "IVMSSS23.DLL,P1MSSS23.DLL,DDMSSS23.DLL,P2MSSS23.DLL," 
                    + "SQLSRV32.DLL,SQLNCLI.DLL,SQLNCLI10.DLL,SQLNCLI11.DLL,MSODBCSQL11.DLL,MSODBCSQL13.DLL,MSODBCSQL17.DLL,"
		    + "P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "P1SQLS25.DLL,IVSQLS25.DLL,P1MSSS25.DLL,IVMSSS25.DLL,P2SQLS25.DLL,DDSQLS25.DLL,P2MSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL,"
                    + "P1SQLS27.DLL,P1SQLS28.DLL,IVSQLS27.DLL,P2SQLS27.DLL,P2SQLS28.DLL,DDSQLS27.DLL,DDSQLS28.DLL"
odbc-bug-list[12] = "PODBC_Sybase_Driver,PODBC_M/S_SQL_Server_Driver"
odbc-bug-list[13] = "PODBC_Sybase_Driver,PODBC_Allbase_Driver,DB2CLIW.DLL,"
                    + "PODBC_DB2_Driver,PODBC_M/S_SQL_Server_Driver,SQLSRV32.DLL,SQLNCLI.DLL,SQLNCLI10.DLL,SQLNCLI11.DLL,MSODBCSQL11.DLL,MSODBCSQL13.DLL,MSODBCSQL17.DLL,"
                    + "IVUDB16.DLL,P1UDB16.DLL,IVMSSS16.DLL,IVSS616.DLL,P1MSSS16.DLL,IVMSSS16.DLL,"
                    + "DB2CLI.DLL,IVOR709.DLL,IVINF16.DLL,P1IFCL18.DLL,IVIFCL18.DLL,"
                    + "IVDB214.DLL,P1DB214.DLL,IVSS614.DLL,P1SS614.DLL,P1DB218.DLL,IVDB218.DLL,"
                    + "P1SS616.DLL,P1INF16.DLL,IVINF14.DLL,P1INF14.DLL,IVMSSS14.DLL,P1MSSS14.DLL,"
                    + "P1MSSS18.DLL,IVMSSS18.DLL,P1SS618.DLL,IVSS618.DLL,IVINF18.DLL,P1INF18.DLL,"
                    + "IVINF19.DLL,P1INF19.DLL,P1MSSS19.DLL,IVMSSS19.DLL,P1SS619.DLL,IVSS619.DLL,P1MSSS21.DLL,IVMSSS21.DLL,"
                    + "P1IFCL19.DLL,IVIFCL19.DLL,P1DB219.DLL,IVDB219.DLL,P1DB220.DLL,IVDB220.DLL,P1DB221.DLL,IVDB221.DLL," 
                    + "P1DB223.DLL,IVDB223.DLL,P1MSSS23.DLL,IVMSSS23.DLL,"
		    + "P2DB223.DLL,DDDB223.DLL,P2MSSS23.DLL,DDMSSS23.DLL,CWBODBC.DLL,"
		    + "P1DB224.DLL,IVDB224.DLL,P2DB224.DLL,DDDB224.DLL,"
		    + "P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "PGDB226.DLL,IVDB226.DLL,PGDB226.DLL,DDDB226.DLL,"
                    + "P1SQLS25.DLL,IVSQLS25.DLL,P1MSSS25.DLL,IVMSSS25.DLL,P2SQLS25.DLL,DDSQLS25.DLL,P2MSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL,"
                    + "P1SQLS27.DLL,P1SQLS28.DLL,IVSQLS27.DLL,P2SQLS27.DLL,P2SQLS28.DLL,DDSQLS27.DLL,DDSQLS28.DLL,"
	   	    + "P1DB227.DLL,IVDB227.DLL,P2DB227.DLL,DDDB227.DLL"
odbc-bug-list[14] = "PODBC_DB2_Driver,DB2CLIW.DLL,SQLSRV32.DLL,SQLNCLI.DLL,SQLNCLI10.DLL,SQLNCLI11.DLL,MSODBCSQL11.DLL,MSODBCSQL13.DLL,MSODBCSQL17.DLL,IVMSSS16.DLL,IVSS616.DLL,"
                    + "P1MSSS16.DLL,P1SS616.DLL,DB2CLI.DLL,IVOR709.DLL,IVOR714.DLL,IVOR814.DLL,"
                    + "IVUDB16.DLL,P1UDB16.DLL,IVMSSS14.DLL,ODBCJT32.DLL,P1DB218.DLL,IVDB218.DLL,"
                    + "P1MSSS14.DLL,IVDB214.DLL,P1DB214.DLL,IVSS614.DLL,P1SS614.DLL,P1SS618.DLL,"
                    + "IVSS618.DLL,P1MSSS18.DLL,IVMSSS18.DLL,P1DB219.DLL,IVDB219.DLL,P1SS619.DLL,"
                    + "IVSS619.DLL,P1MSSS19.DLL,IVMSSS19.DLL,P1DB220.DLL,IVDB220.DLL,P1DB221.DLL,IVDB221.DLL,P1MSSS21.DLL,IVMSSS21.DLL,"
                    + "P1DB223.DLL,IVDB223.DLL,P1MSSS23.DLL,IVMSSS23.DLL,"
		    + "P2DB223.DLL,DDDB223.DLL,P2MSSS23.DLL,DDMSSS23.DLL,CWBODBC.DLL,"
		    + "P1DB224.DLL,IVDB224.DLL,P2DB224.DLL,DDDB224.DLL,"
                    + "PGDB226.DLL,IVDB226.DLL,PGDB226.DLL,DDDB226.DLL,"
		    + "P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "P1SQLS25.DLL,IVSQLS25.DLL,P1MSSS25.DLL,IVMSSS25.DLL,P2SQLS25.DLL,DDSQLS25.DLL,P2MSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL,"
                    + "P1SQLS27.DLL,P1SQLS28.DLL,IVSQLS27.DLL,P2SQLS27.DLL,P2SQLS28.DLL,DDSQLS27.DLL,DDSQLS28.DLL,"
		    + "P1DB227.DLL,IVDB227.DLL,P2DB227.DLL,DDDB227.DLL"
odbc-bug-list[15] = "PODBC_Sybase_Driver,PODBC_M/S_SQL_Server_Driver"
odbc-bug-list[16] = "PODBC_Sybase_Driver,ODBCJT16.DLL,ODBCJT32.DLL,IVUDB16.DLL,P1UDB16.DLL,"
                    + "P1DB218.DLL,IVDB218.DLL,P1DB219.DLL,IVDB219.DLL,P1DB220.DLL,IVDB220.DLL,P1DB221.DLL,IVDB221.DLL,"
                    + "P1DB223.DLL,IVDB223.DLL,"
		    + "P2DB223.DLL,DDDB223.DLL,CWBODBC.DLL,"
		    + "P1DB224.DLL,IVDB224.DLL,P2DB224.DLL,DDDB224.DLL,"
                    + "PGDB226.DLL,IVDB226.DLL,PGDB226.DLL,DDDB226.DLL,"
		    + "P1DB227.DLL,IVDB227.DLL,P2DB227.DLL,DDDB227.DLL"
odbc-bug-list[17] = "PODBC_Allbase_Driver,QEINF,QEINF5,IVINF508.DLL,"
                    + "IVINF709.DLL,IVINF16.DLL,P1INF16.DLL,IVINF14.DLL,P1INF14.DLL,"
                    + "IVUDB16.DLL,P1UDB16.DLL,IVDB214.DLL,P1DB214.DLL,ODBCJT32.DLL,"
                    + "IVSS614.DLL,"
                    + "P1SS614.DLL,IVSS616.DLL,P1SS616.DLL,DB2CLI.DLL,"
                    + "P1IFCL18.DLL,IVIFCL18.DLL,P1DB218.DLL,IVDB218.DLL,"
                    + "P1SS618.DLL,IVSS618.DLL,IVINF18.DLL,P1INF18.DLL,"
                    + "P1IFCL19.DLL,IVIFCL19.DLL,P1DB219.DLL,IVDB219.DLL,"
                    + "P1SS619.DLL,IVSS619.DLL,IVINF19.DLL,P1INF19.DLL,"
                    + "P1DB220.DLL,IVDB220.DLL,P1DB221.DLL,IVDB221.DLL,"
                    + "P1DB223.DLL,IVDB223.DLL,"
		    + "P2DB223.DLL,DDDB223.DLL,CWBODBC.DLL,"
		    + "P1DB224.DLL,IVDB224.DLL,P2DB224.DLL,DDDB224.DLL,"
                    + "PGDB226.DLL,IVDB226.DLL,PGDB226.DLL,DDDB226.DLL,"
		    + "P1DB227.DLL,IVDB227.DLL,P2DB227.DLL,DDDB227.DLL,"
                    + "P1SQLS25.DLL,DDSQLS25.DLL,DDMSSS25.DLL,"
                    + "DDMSSS26.DLL,"
                    + "DDMSSS27.DLL"
odbc-bug-list[18] = "PODBC_Allbase_Driver"
odbc-bug-list[19] = "".

ASSIGN
odbc-bug-list[20] = "QEINF,QEINF5,IVINF508.DLL,IVINF709.DLL,IVINF16.DLL,P1SS616.DLL,"
                    + "P1INF16.DLL,SQLSRV32.DLL,SQLNCLI.DLL,SQLNCLI10.DLL,SQLNCLI11.DLL,MSODBCSQL11.DLL,MSODBCSQL13.DLL,MSODBCSQL17.DLL,IVMSSS16.DLL,IVSS616.DLL,P1MSSS16.DLL,"
                    + "IVINF14.DLL,P1INF14.DLL,IVMSSS14.DLL,P1MSSS14.DLL,IVSS614.DLL,P1SS614.DLL," 
                    + "P1IFCL18.DLL,IVIFCL18.DLL,P1MSSS18.DLL,IVMSSS18.DLL,P1SS618.DLL,IVSS618.DLL,"
                    + "IVINF18.DLL,P1INF18.DLL,P1IFCL19.DLL,IVIFCL19.DLL,P1MSSS19.DLL,IVMSSS19.DLL,P1MSSS21.DLL,IVMSSS21.DLL,"
                    + "P1SS619.DLL,IVSS619.DLL,IVINF19.DLL,P1INF19.DLL,"
                    + "P1MSSS23.DLL,IVMSSS23.DLL,"
		    + "P2MSSS23.DLL,DDMSSS23.DLL,"
		    + "P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "P1SQLS25.DLL,IVSQLS25.DLL,P1MSSS25.DLL,IVMSSS25.DLL,P2SQLS25.DLL,DDSQLS25.DLL,P2MSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL,"
                    + "P1SQLS27.DLL,P1SQLS28.DLL,IVSQLS27.DLL,P2SQLS27.DLL,P2SQLS28.DLL,DDSQLS27.DLL,DDSQLS28.DLL"
odbc-bug-list[21] = ""
odbc-bug-list[22] = ""
odbc-bug-list[23] = "ALL"
odbc-bug-list[24] = ""
odbc-bug-list[25] = "PODBC_Sybase_Driver,PODBC_M/S_SQL_Server_Driver"
odbc-bug-list[26] = "QEINF,QEINF5,ODBCJT16.DLL,ODBCJT32.DLL,DB2CLIW.DLL,"
                    + "IVINF508.DLL,IVINF709.DLL,IVINF16.DLL,P1INF16.DLL,DB2CLI.DLL,"
                    + "IVUDB16.DLL,P1UDB16.DLL,P1IFCL18.DLL,IVIFCL18.DLL,P1DB218.DLL,"
                    + "IVINF14.DLL,P1INF14.DLL,IVDB214.DLL,P1DB214.DLL,IVDB218.DLL,"
                    + "IVINF18.DLL,P1INF18.DLL,P1IFCL19.DLL,IVIFCL19.DLL,P1DB219.DLL,"
                    + "IVDB219.DLL,IVINF19.DLL,P1INF19.DLL,P1DB220.DLL,IVDB220.DLL,P1DB221.DLL,IVDB221.DLL,"
                    + "P1DB223.DLL,IVDB223.DLL,"
		    + "P2DB223.DLL,DDDB223.DLL,CWBODBC.DLL"
odbc-bug-list[27] = "ODBCJT16.DLL,ODBCJT32.DLL"
odbc-bug-list[28] = ""
odbc-bug-list[29] = "DB2CLIW.DLL,DB2CLI.DLL,IVUDB16.DLL,P1UDB16.DLL,P1DB218.DLL,IVDB218.DLL,"
                    + "IVDB214.DLL,P1DB214.DLL,P1DB219.DLL,IVDB219.DLL,P1DB220.DLL,IVDB220.DLL,P1DB221.DLL,IVDB221.DLL,"
                    + "P1DB223.DLL,IVDB223.DLL,"
		    + "P2DB223.DLL,DDDB223.DLL,CWBODBC.DLL,"
		    + "P1DB224.DLL,IVDB224.DLL,P2DB224.DLL,DDDB224.DLL,"
                    + "PGDB226.DLL,IVDB226.DLL,PGDB226.DLL,DDDB226.DLL,"
		    + "P1DB227.DLL,IVDB227.DLL,P2DB227.DLL,DDDB227.DLL"
odbc-bug-list[30] = "PODBC_M/S_SQL_Server_Driver,PODBC_Sybase_Driver"
odbc-bug-list[31] = "PODBC_M/S_SQL_Server_Driver"
odbc-bug-list[32] = "ODBCJT16.DLL,ODBCJT32.DLL,IVDBF08.DLL"
odbc-bug-list[33] = "SQLSRV32.DLL,SQLNCLI.DLL,SQLNCLI10.DLL,SQLNCLI11.DLL,MSODBCSQL11.DLL,MSODBCSQL13.DLL,MSODBCSQL17.DLL,IVMSSS16.DLL,IVMSSS15.DLL,P1MSSS16.DLL,DB2CLIW.DLL,"
                    + "DB2CLI.DLL,IVOR709.DLL,IVOR714.DLL,IVOR814.DLL,IVMSSS14.DLL,"
                    + "P1MSSS14.DLL,IVSS616.DLL,P1SS616.DLL,IVSS614.DLL,P1SS614.DLL,"
                    + "IVDB214.DLL,P1DB214.DLL,IVUDB16.DLL,P1UDB16.DLL,IVASE16.DLL,P1ASE16.DLL,"
                    + "P1DB218.DLL,IVDB218.DLL,P1MSSS18.DLL,IVMSSS18.DLL,P1SS618.DLL,IVSS618.DLL,"
                    + "P1DB219.DLL,IVDB219.DLL,P1MSSS19.DLL,IVMSSS19.DLL,P1SS619.DLL,IVSS619.DLL,"
                    + "P1ASE18.DLL,IVASE18.DLL,P1ASE19.DLL,IVASE19.DLL,P1MSSS21.DLL,IVMSSS21.DLL,P1ASE21.DLL,IVASE21.DLL," 
                    + "P1DB223.DLL,P1ASE23.DLL,IVASE23.DLL,P1MSSS23.DLL,IVMSSS23.DLL,"
		    + "P2DB223.DLL,P2ASE23.DLL,DDASE23.DLL,P2MSSS23.DLL,DDMSSS23.DLL,"
		    + "P1DB224.DLL,P1ASE24.DLL,IVASE24.DLL,P2ASE24.DLL,DDASE24.DLL,"
                    + "PGDB226.DLL,PGASE26.DLL,IVASE26.DLL,PGASE26.DLL,DDASE26.DLL,"
		    + "P2DB224.DLL,P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "PGDB226.DLL,P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "P1SQLS25.DLL,IVSQLS25.DLL,P1MSSS25.DLL,IVMSSS25.DLL,P2SQLS25.DLL,DDSQLS25.DLL,P2MSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL,"
                    + "P1SQLS27.DLL,P1SQLS28.DLL,IVSQLS27.DLL,P2SQLS27.DLL,P2SQLS28.DLL,DDSQLS27.DLL,DDSQLS28.DLL,"
		    + "P1DB227.DLL,P2DB227.DLL,P1ASE27.DLL,IVASE27.DLL,P2ASE27.DLL,DDASE27.DLL"
odbc-bug-list[34] = "IVINF508.DLL,IVINF709.DLL,IVINF16.DLL,P1INF16.DLL,"
                    + "IVINF14.DLL,P1INF14.DLL,P1IFCL18.DLL,IVIFCL18.DLL,IVINF18.DLL,P1INF18.DLL," 
                    + "P1IFCL19.DLL,IVIFCL19.DLL,IVINF19.DLL,P1INF19.DLL"
odbc-bug-list[35] = "SQLSRV32.DLL,SQLNCLI.DLL,SQLNCLI10.DLL,SQLNCLI11.DLL,MSODBCSQL11.DLL,MSODBCSQL13.DLL,MSODBCSQL17.DLL,IVMSSS16.DLL,IVSS616.DLL,P1SS616.DLL,P1MSSS16.DLL,P1MSSS18.DLL,"
                    + "IVMSSS14.DLL,P1MSSS14.DLL,IVSS614.DLL,P1SS614.DLL,IVMSSS18.DLL,P1SS618.DLL,"
                    + "IVSS618.DLL,P1MSSS19.DLL,IVMSSS19.DLL,P1SS619.DLL,IVSS619.DLL,P1MSSS21.DLL,IVMSSS21.DLL,"
                    + "P1MSSS23.DLL,IVMSSS23.DLL,"
		    + "P2MSSS23.DLL,DDMSSS23.DLL,"
		    + "P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "P1SQLS25.DLL,IVSQLS25.DLL,P1MSSS25.DLL,IVMSSS25.DLL,P2SQLS25.DLL,DDSQLS25.DLL,P2MSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL"
odbc-bug-list[36] = "SQLSRV32.DLL,SQLNCLI.DLL,SQLNCLI10.DLL,SQLNCLI11.DLL,MSODBCSQL11.DLL,MSODBCSQL13.DLL,MSODBCSQL17.DLL,IVMSSS16.DLL,IVSS616.DLL,P1SS616.DLL,P1MSSS16.DLL,P1MSSS18.DLL,"
                    + "IVMSSS14.DLL,P1MSSS14.DLL,IVSS614.DLL,P1SS614.DLL,IVMSSS18.DLL,P1SS618.DLL,"
                    + "IVSS618.DLL,P1MSSS19.DLL,IVMSSS19.DLL,P1SS619.DLL,IVSS619.DLL,P1MSSS21.DLL,IVMSSS21.DLL,"
                    + "P1MSSS23.DLL,IVMSSS23.DLL,"
		    + "P2MSSS23.DLL,DDMSSS23.DLL,"
		    + "P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "P1SQLS25.DLL,IVSQLS25.DLL,P1MSSS25.DLL,IVMSSS25.DLL,P2SQLS25.DLL,DDSQLS25.DLL,P2MSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL,"
		    + "P1SQLS27.DLL,P1SQLS28.DLL,IVSQLS27.DLL,P2SQLS27.DLL,P2SQLS28.DLL,DDSQLS27.DLL,DDSQLS28.DLL"
odbc-bug-list[37] = ""
odbc-bug-list[38] = "SQLSRV32.DLL,P1MSSS23.DLL,P2MSSS23.DLL,IVMSSS23.DLL,DDMSSS23.DLL,"
                    + "P1MSSS24.DLL,P2MSSS24.DLL,IVMSSS24.DLL,DDMSSS24.DLL,"
                    + "P1MSSS25.DLL,P2MSSS25.DLL,IVMSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL"
odbc-bug-list[39] = "P1SQLS27.DLL,P1SQLS28.DLL,IVSQLS27.DLL,P2SQLS27.DLL,P2SQLS28.DLL,DDSQLS27.DLL,DDSQLS28.DLL".

ASSIGN
odbc-bug-excld[1] = "" 
odbc-bug-excld[2] = "" 
odbc-bug-excld[3] = "PODBC_Sybase_Driver,QEINF,QEINF5,PODBC_DB2_Driver,"
                    + "DB2CLIW.DLL,PODBC_M/S_SQL_Server_Driver,IVINF508.DLL,"
                    + "IVINF709.DLL,IVUDB16.DLL,P1UDB16.DLL,"
                    + "DB2CLI.DLL,IVDB214.DLL,P1DB214.DLL," 
                    + "IVMSSS23.DLL,P1MSSS23.DLL,DDMSSS23.DLL,P2MSSS23.DLL," 
                    + "SQLSRV32.DLL,SQLNCLI.DLL,SQLNCLI10.DLL,SQLNCLI11.DLL,MSODBCSQL11.DLL,MSODBCSQL13.DLL,MSODBCSQL17.DLL," 
                    + "P1MSSS24.DLL,IVMSSS24.DLL,P2MSSS24.DLL,DDMSSS24.DLL,"
                    + "P1SQLS25.DLL,IVSQLS25.DLL,P1MSSS25.DLL,IVMSSS25.DLL,P2SQLS25.DLL,DDSQLS25.DLL,P2MSSS25.DLL,DDMSSS25.DLL,"
                    + "PGMSSS26.DLL,IVMSSS26.DLL,PGMSSS26.DLL,DDMSSS26.DLL,"
                    + "P1MSSS27.DLL,IVMSSS27.DLL,P2MSSS27.DLL,DDMSSS27.DLL,"
                    + "P1SQLS27.DLL,P1SQLS28.DLL,IVSQLS27.DLL,P2SQLS27.DLL,P2SQLS28.DLL,DDSQLS27.DLL,DDSQLS28.DLL"
odbc-bug-excld[4] = "" 
odbc-bug-excld[5] = "" 
odbc-bug-excld[6] = "" 
odbc-bug-excld[7] = ""
odbc-bug-excld[8] = ""
odbc-bug-excld[9] = ""
odbc-bug-excld[10] = ""
odbc-bug-excld[11] = ""
odbc-bug-excld[12] = ""
odbc-bug-excld[13] = ""
odbc-bug-excld[14] = ""
odbc-bug-excld[15] = ""
odbc-bug-excld[16] = ""
odbc-bug-excld[17] = ""
odbc-bug-excld[18] = ""
odbc-bug-excld[19] = ""
odbc-bug-excld[20] = ""
odbc-bug-excld[21] = ""
odbc-bug-excld[22] = ""
odbc-bug-excld[23] = "PODBC_Sybase_Driver,PODBC_DB2_Driver,"
                     + "PODBC_M/S_SQL_Server_Driver"
odbc-bug-excld[24] = ""
odbc-bug-excld[25] = ""
odbc-bug-excld[26] = ""
odbc-bug-excld[27] = ""
odbc-bug-excld[28] = ""
odbc-bug-excld[29] = ""
odbc-bug-excld[30] = ""
odbc-bug-excld[31] = ""
odbc-bug-excld[32] = ""
odbc-bug-excld[33] = ""
odbc-bug-excld[34] = ""
odbc-bug-excld[35] = ""
odbc-bug-excld[36] = "".
odbc-bug-excld[37] = "".

ASSIGN
pobjects = "TABLE,STABLE,VIEW,LOG,PROCEDURE,RULE,DEFAULT,TRIGGER,BUFFER,ALIAS,SYNONYM,SEQUENCE"
sobjects = "TABLE,SYSTEM TABLE,VIEW,LOG,PROCEDURE,RULE,DEFAULT,TRIGGER,BUFFER,ALIAS,SYNONYM,SEQUENCE"
odballowed = "TABLE,SYSTEM TABLE,VIEW,ALIAS,SYNONYM,PROCEDURE,BUFFER,SEQUENCE".
