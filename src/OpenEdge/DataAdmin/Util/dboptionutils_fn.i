/************************************************
  Copyright (c) 2016,2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dboptionutils_fn.i
    Purpose     : Common util functions for the dbconnectionrole_*.p and dbpolicy_*.p utilities
    Author(s)   : pjudge 
    Created     : 2016-05-03
    Notes       :
  ----------------------------------------------------------------------*/
  
&global-define USAGE_CONSTANT dbpolicyutil <operation> <policy-options> -db <db-name> [db-options]
&global-define OPERATION_CONSTANT where <operation> denotes one of the operations to perform
&global-define QUERY_CONSTANT query -- get the database policy status
&global-define SET_CONSTANT set   -- set the database policy
&global-define HELP_CONSTANT help  -- get the usage for the utility
&global-define DB_OPTIONS like -pf, -U, -P, -S, -H etc.
&global-define TYPE_CONSTANT type -- specify the type of policy. Type takes 'avm, sql, db, sts and all'. 'all' option gets the info for all policy types
&global-define SET_EXAMPLE dbpolicyutil set safeUserIdPolicy=preact -db sports...
&global-define QUERY_EXAMPLE dbpolicyutil query safeUserIdPolicy -db sports...
&global-define TYPE_EXAMPLE dbpolicyutil query type=avm -db sports...
&global-define POLICY_OPTION_CONSTANT where <policy-options> vary with the operation


define variable dbopt_lkup  as character EXTENT 9 initial
    ["enforceAuditInsert:AVM:1:_pvm.enforceAuditInsert":u,
     "useAppUserID:AVM:2:_pvm.useAppUserId":u,
     "noBlankUser:AVM:3:_pvm.noBlankUser":u,
     "useFQUserid:AVM:4:_pvm.useFQUserid":u,
     "noBlankUser:SQL:5:_sql.noBlankUser":u,
     "recordSessions:AVM:6:_pvm.recordSessions":u,
     "runtimePermissions:AVM:7:_pvm.runtimePermissions":u,
     "safeUserIdPolicy:AVM:8:_pvm.safeUserIdPolicy":u,
     "useAppRegistry:AVM:9:_pvm.useAppRegistry":u] no-undo.
                   
DEFINE VARIABLE dbopt_desc AS CHARACTER EXTENT 9 INITIAL
     ["1:enforces audit insert. enforceAuditInsert policy belongs to type 'avm'":u,
      "2:use for Application User ID. useAppUserID policy belongs to type 'avm'":u,
      "3:no blank user for avm. noBlankUser policy belongs to type 'avm'":u,
      "4:use FQ userid. useFQUserid policy belongs to type 'avm'":u,
      "5:no blank user for sql. noBlankUser policy belongs to type 'sql'":u,
      "6:record sessions. recordSessions policy belongs to type 'avm'":u,
      "7:runtime permissions. RuntimePermissions policy belongs to type 'avm'":u,
      "8:safe userid policy. safeUserIdPolicy policy belongs to type 'avm'":u,
      "9:use application registry. useAppRegistry policy belongs to type 'avm'":u] no-undo. 

DEFINE VARIABLE dbopt_vals AS CHARACTER NO-UNDO EXTENT 9 INITIAL
      ["1#YES#NO":u,
       "2#YES#NO":u,
       "3#YES#NO":u,
       "4#YES#NO":u,
       "5#YES#NO":u,       
       "6#YES#NO":u,
       "7#YES#NO":u,
       "8#DISABLED#ENABLED:preact#ENABLED:postact#ENABLED:predeact#ENABLED:postdeact":u,       
       "9#YES#NO":u]. 

define variable IsExampleUsed as logical no-undo.

function InitLog returns logical ():
    output to value({&EXPORT-LOG}).
    output close.
end function.

function PutMessage returns logical (input pcMessage as character, 
                                     input poLevel as OpenEdge.Logging.LogLevelEnum):
    output to value({&EXPORT-LOG}) append.
    put unformatted 
        substitute('[&1] &2 &3 &4':u,
            iso-date(now),
            {&EXPORT-LOG-GROUP},
            string(poLevel),  
            pcMessage) 
        skip.
    finally:
        output close.
    end finally.        
end function.    

/**
this method is used to log the info without time
**/
function PutMessageNoTimeStamp returns logical (input pcMessage as character, 
                                     input poLevel as OpenEdge.Logging.LogLevelEnum):
    output to value({&EXPORT-LOG}) append.
    put unformatted 
        substitute('&1 &2':u, pcMessage, string(poLevel)) 
        skip.
    finally:
        output close.
    end finally.        
end function. 

function PutDirectMessage returns logical (input pcMessage as character):
    output to value({&EXPORT-LOG}) append.
    put unformatted 
        substitute('&1':u, pcMessage) 
        skip.
    finally:
        output close.
    end finally.        
end function.

/**
    Display complete help for all policies
**/
PROCEDURE GetHelp:
    define input parameter iCnt as integer no-undo.
    
    PutDirectMessage(substitute("      &1 will set policy type to &2":u,quoter(ENTRY(1, dbopt_lkup[iCnt],":")),quoter(ENTRY(2, dbopt_lkup[iCnt],":")))).
    if (iCnt eq 8) then
        PutDirectMessage(substitute("             Accepted values: &1":u, "preact, postact, predeact, postdeact, disabled")).
    else PutDirectMessage(substitute("             Accepted values: &1":u, replace(trim(dbopt_vals[iCnt],string(iCnt) + "#"),"#", ", "))).
                
END PROCEDURE.  

/**
    Display complete help for all policies
**/
PROCEDURE GetAllHelp:    
    run PutNewLine.
    PutDirectMessage("  {&OPERATION_CONSTANT}:":u).
    PutDirectMessage("      " + '{&QUERY_CONSTANT}').
    PutDirectMessage("      " + '{&SET_CONSTANT}'). 
    IsExampleUsed = true.    
    run PolicyOptionsHelp.
    run GetDbOptionsHelp.
                
END PROCEDURE.  

/**
    Display complete help for all policies
**/
PROCEDURE GetSetHelp:    
    run PutNewLine.
    PutDirectMessage("  {&POLICY_OPTION_CONSTANT}:":u).
    PutDirectMessage("      " + '{&SET_CONSTANT}'). 
    run PolicyOptionsHelp.
    run GetDbOptionsHelp.
                
END PROCEDURE.

PROCEDURE PutNewLine:     
    output to value({&EXPORT-LOG}) append.
        put unformatted "~n".
        finally:
            output close.
        end finally.                
END PROCEDURE.

PROCEDURE GetQueryHelp:    
    run PutNewLine.
    PutDirectMessage("  {&POLICY_OPTION_CONSTANT}:":u).
    PutDirectMessage("      {&QUERY_CONSTANT}"). 
    run PolicyOptionsHelp.
    run GetDbOptionsHelp.
                
END PROCEDURE.

/**
    Display complete help for all policies
**/
PROCEDURE GetDbOptionsHelp:    
    run PutNewLine.
    PutDirectMessage("  where [db-options] are any database connection parameters":u).
    PutDirectMessage("      " + '{&DB_OPTIONS}').                
END PROCEDURE.

PROCEDURE PolicyOptionsHelp:
    define variable cnt as integer no-undo.   
     
    run PutNewLine.
    PutDirectMessage("  {&POLICY_OPTION_CONSTANT}:":u).
    do cnt = 1 to extent(dbopt_lkup) :    
        run PolicyOptionHelp(cnt).     
        //PutDirectMessage(substitute("      &1 -- &2 Accepted values &3",quoter(ENTRY(1, dbopt_lkup[cnt],":")),quoter(ENTRY(1, dbopt_desc[cnt],":")), quoter(replace(trim(dbopt_vals[cnt],string(cnt) + ":"),":", ",")))).        
    end.   
    //PutDirectMessage("      " + '{&TYPE_CONSTANT}').
    //PutDirectMessage("      type -- specify the type of policy. Type takes 'avm, sql, db, sts and ALL'. 'ALL' option gets the info for all policy types").                  
END PROCEDURE.

PROCEDURE PolicyOptionHelp:
    define input parameter cnt as integer no-undo. 
     
    if not IsExampleUsed then do:
        run UsageHelp.
        run PutNewLine.   
        //if helpType eq "set"  or helpType eq "" then 
        PutDirectMessage("EXAMPLES:":u).
        if (cnt eq 8) then
            PutDirectMessage(substitute("  dbpolicyutil set &1=DISABLED -db sports...",ENTRY(1, dbopt_lkup[cnt],":") )).
        else    PutDirectMessage(substitute("  dbpolicyutil set &1=NO -db sports...",ENTRY(1, dbopt_lkup[cnt],":") )).
        //else if helpType eq "query" helpType eq "" then
        PutDirectMessage(substitute("  dbpolicyutil query &1 -db sports...",ENTRY(1, dbopt_lkup[cnt],":") )).
        run PutNewLine.
        PutDirectMessage("  {&POLICY_OPTION_CONSTANT}:":u).
        IsExampleUsed = true.
    end.
    
    PutDirectMessage(substitute("    &1   -- &2",ENTRY(1, dbopt_lkup[cnt],":"),ENTRY(2, dbopt_desc[cnt],":"))).    
    if (cnt eq 8) then
        PutDirectMessage(substitute("             Accepted values: &1":u, "preact, postact, predeact, postdeact, disabled")).
    else    PutDirectMessage(substitute("                        Values: &1",replace(trim(dbopt_vals[cnt],string(cnt) + "#"),"#", ", "))).                    
END PROCEDURE. 

PROCEDURE UsageHelp:
    PutDirectMessage('USAGE:':u).
    PutDirectMessage('  {&USAGE_CONSTANT}').                    
END PROCEDURE.

PROCEDURE PolicyTypeHelp:
    define input parameter typeValue as character no-undo.
    define variable Cnt as integer no-undo.
    if not IsExampleUsed then do:
        run UsageHelp.         
        IsExampleUsed = true.
    end.
    
    if typeValue eq "all" then do:
        run PolicyOptionsHelp.
    end.
    else do: 
        //PutDirectMessage("      type -- specify the type of policy"). 
        //PutDirectMessage("              values: avm, sql, db, sts and all. 'all' option gets the info for all policy types").
        PutDirectMessage("  {&POLICY_OPTION_CONSTANT}:":u).
        do Cnt = 1 to extent(dbopt_lkup) :
            if lookup(typeValue, dbopt_lkup[Cnt],":") gt 0 then 
            do: 
                run PolicyOptionHelp(Cnt).
                //PutDirectMessage(substitute("      &1 -- &2 Accepted values &3",quoter(ENTRY(1, dbopt_lkup[cnt],":")),quoter(ENTRY(1, dbopt_desc[cnt],":")), quoter(replace(trim(dbopt_vals[cnt],string(cnt) + ":"),":", ",")))).
            end. 
        end.  
    end. 
    PutDirectMessage("      type   -- specify the type of policy":u). 
    PutDirectMessage("                Values: avm, sql, db, sts and all. 'all' option gets the info for all policy types":u).
    run PutNewLine.
    PutDirectMessage("EXAMPLES:":u).   
    PutDirectMessage("  dbpolicyutil query type=avm -db sports":u). 
    PutDirectMessage("  dbpolicyutil query type=sql -db sports":u).
    PutDirectMessage("  dbpolicyutil query type=all -db sports":u).
END PROCEDURE. 


function IsAdmin returns logical (input pcUserId as character):
    define variable lIsAdmin as logical no-undo.
    run prodict/_dctadmn.p (input  pcUserId, output lIsAdmin ).
    
    return lIsAdmin.
end function.

function GetOutputFolder returns character (input pcFolder as character):
    assign file-info:file-name = pcFolder 
           pcFolder            = file-info:full-pathname.
    if pcFolder eq ? then
        assign file-info:file-name = os-getenv('WRKDIR':u) 
               pcFolder = file-info:full-pathname.
    if pcFolder eq ? then
        assign file-info:file-name = '.':u 
               pcFolder = file-info:full-pathname.
    if pcFolder eq ? then
        assign file-info:file-name = session:temp-dir 
               pcFolder = file-info:full-pathname.

    return pcFolder.
end function.

/* eof */