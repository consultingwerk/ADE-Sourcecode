/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: procbfrpul.p

Description:   
   This file creates the procedure to pull constraint info during independent 
   pull operation.

HISTORY
Author: Kumar Mayur

Date Created: 06/21/2011

          kmayur  22/2/2012   OE00217787- compatibility for MSS 2000
----------------------------------------------------------------------------*/
Define var sql1 as char.
define var h1 as int.

Define var sql2 as char.
define var h2 as int.

sql1 = "IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = '_Constraint_Info') ".
sql1 = sql1 + "BEGIN ".
sql1 = sql1 + "DROP Procedure _Constraint_Info ".
sql1 = sql1 + "END ".

RUN STORED-PROC DICTDBG.send-sql-statement h1 = PROC-HANDLE NO-ERROR (sql1).
IF ERROR-STATUS:ERROR THEN .
ELSE IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
    CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h1.
END.
ELSE DO:
 CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h1.
END.

sql2 = "CREATE PROCEDURE _Constraint_Info @table_name varchar(80) AS ".

sql2 =  sql2 + "CREATE TABLE #tmp(Table_Name Varchar(80),Column_Name Varchar(80),Constr_Name varchar(120) ,Const_type Varchar(80), ".
sql2 =  sql2 +  "Def_check_Exp Varchar(8000),Parent_Key Varchar(120),Parnt_Key_Num Integer,Indx_Num Integer,Indx_Name Varchar(80), par_tab Varchar(80)) ".


sql2 = sql2 +  "INSERT INTO #tmp     
        select  t.name , c.name ,o.name , o.xtype,cols.COLUMN_DEFAULT ,NULL ,NULL ,NULL ,NULL ,NULL
        from syscolumns c
        inner join sysobjects o  
        on o.id = c.cdefault 
        inner join sysobjects t     
        on c.id = t.id and t.name = @table_name
        inner join INFORMATION_SCHEMA.COLUMNS cols
        on c.name = cols.COLUMN_NAME and cols.TABLE_NAME = @table_name ".

sql2 = sql2 + "INSERT INTO #tmp
        select   columns.TABLE_NAME,  columns.COLUMN_NAME, checks.CONSTRAINT_NAME,'C',  checks.CHECK_CLAUSE, NULL ,NULL ,NULL ,NULL ,NULL
        from INFORMATION_SCHEMA.COLUMNS columns 
        inner join  INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE  usage 
        on  columns.COLUMN_NAME = usage.COLUMN_NAME 
        and columns.TABLE_NAME = usage.TABLE_NAME
        and columns.TABLE_NAME = @table_name
        inner join INFORMATION_SCHEMA.CHECK_CONSTRAINTS  checks 
        on usage.CONSTRAINT_NAME = checks.CONSTRAINT_NAME  ".

sql2 = sql2 + "INSERT INTO #tmp
        select  tt.name,c.name  ,i.name , 'CLUSTERED' ,NULL,NULL ,NULL ,NULL ,NULL ,NULL from
        sysindexes i 
        inner join sysindexkeys ic on i.indid = 1
        and ic.indid = i.indid and i.id = ic.id 
        inner join syscolumns c on c.colorder = ic.colid and c.id = ic.id 
        inner join  sysobjects tt on tt.id = c.id where tt.name = @table_name  ".

sql2 = sql2 + "INSERT INTO #tmp
        select  c.TABLE_NAME  , c.COLUMN_NAME, pk.CONSTRAINT_NAME , pk.CONSTRAINT_TYPE ,NULL,NULL ,NULL ,NULL ,NULL ,NULL
	    from INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
	    INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	    where  
	    (pk.CONSTRAINT_TYPE = 'PRIMARY KEY' OR pk.CONSTRAINT_TYPE = 'UNIQUE')
	    and c.TABLE_NAME = pk.TABLE_NAME 
	    and c.TABLE_NAME = @table_name
	    and	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME  ".

sql2 = sql2 + "create table #prgrstmptable(Parent_tab varchar(80),Unique_key varchar(80),col_name varchar(80), constr_name varchar(120))  ".
 
sql2 = sql2 + "INSERT INTO #prgrstmptable   
        select tt.name,rc.UNIQUE_CONSTRAINT_NAME    , c.name, rc.CONSTRAINT_NAME from
        sysindexes i 
        inner join sysindexkeys ic on i.indid = ic.indid
        and i.id = ic.id 
        inner join INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc on rc.UNIQUE_CONSTRAINT_NAME = i.name 
        inner join syscolumns c on c.colorder = ic.colid and c.id = ic.id 
        inner join  sysobjects tt on tt.id = c.id ".

sql2 =  sql2 + " INSERT INTO #tmp
        select distinct c.TABLE_NAME  , c.COLUMN_NAME  ,pk.CONSTRAINT_NAME ,
        pk.CONSTRAINT_TYPE , NULL,  #prgrstmptable.Unique_key ,NULL ,NULL ,NULL , #prgrstmptable.Parent_tab
        from 	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk,INFORMATION_SCHEMA.KEY_COLUMN_USAGE c,#prgrstmptable
        where pk.TABLE_NAME = c.TABLE_NAME 
        and  pk.TABLE_NAME COLLATE SQL_Latin1_General_CP1_CI_AS = @table_name COLLATE SQL_Latin1_General_CP1_CI_AS
        and  pk.CONSTRAINT_TYPE COLLATE SQL_Latin1_General_CP1_CI_AS = 'FOREIGN KEY' COLLATE SQL_Latin1_General_CP1_CI_AS 
	    and	 c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME 
	    and  #prgrstmptable.constr_name COLLATE SQL_Latin1_General_CP1_CI_AS = 
                                                                 c.CONSTRAINT_NAME COLLATE SQL_Latin1_General_CP1_CI_AS ".

sql2 =  sql2 + " DROP TABLE #prgrstmptable ".
	    
sql2 = sql2 + "SELECT * FROM #tmp ".
sql2 = sql2 + "go ".

RUN STORED-PROC DICTDBG.send-sql-statement h2 = PROC-HANDLE NO-ERROR (sql2).
IF ERROR-STATUS:ERROR THEN .
ELSE IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
    CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h2.
END.
ELSE DO:
 CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h2.
END.
