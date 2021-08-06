/************************************************************************
* Copyright (C) 2007-2010,2021 by Progress Software Corporation.        * 
* All rights reserved. Prior versions of this work may contain portions *
* contributed by participants of Possenet.                              *
*                                                                       *
*************************************************************************/

/*----------------------------------------------------------------------------

File: prodict/load_df_silent.p

    This is the silent end-user entry point for Admin Tool's "Load .df file" utility
    
    The other .df utilitites; dump_df.p and dump_inc.p supports silent mode 
    as follows: 
              run <.p> persistent set h (param). 
              run setSilent in h (true).
              run <dump> (different name)
    
    The load_df.p does currently NOT support the persistent run silent mode 
    since the .df file only can be loaded once (and the filename is the 
    input parameter) 
    
input parameters:
     pcFileName - The name of the .df file to be loaded into DICTDB
     pcOptions  - Optional comma separated list of one or some of the following 
                  options: 
                  - AddObjectsOnline  - load new tables and sequences on-line 
                  - ForceCommit  - commit even with errors
                  - ForceIndexDeactivate - create new indexes inactive
                  - ForceSharedSchema - ignore Multi-tenant properties
                  - PreDeployLoad  - load predeploy section
                  - TriggerLoad    - load trigger section
                  - PostDeployLoad - load postdeploy section
                  - OfflineLoad    - load predeploy section
                  
output Parameters:    
     pcWarnings - displayable warnings.
     
     Error will be thrown. 
     
    Notes:   
----------------------------------------------------------------------------*/
 
 routine-level on error undo , throw.
 
/*==========================  DEFINITIONS ===========================*/

define input parameter pcFileName as character no-undo.
define input parameter pcOptions as character no-undo.
define output parameter pcWarnings as character no-undo.

define variable dictOptions as prodict.dump._load_options no-undo.
 
dictOptions = new prodict.dump._load_options(new prodict.dump._load_logger()).
dictOptions:FileName = pcFileName.

/* If user wants to load new tables and sequences on-line 
   pass "AddObjectsOnline" in options */
if lookup("AddObjectsOnline",pcOptions) > 0 then
    dictOptions:AddObjectsOnline = true.
if lookup("ForceCommit",pcOptions) > 0 then
    dictOptions:ForceCommit = true.
if lookup("ForceIndexDeactivate",pcOptions) > 0 then
    dictOptions:ForceIndexDeactivate = true.
if lookup("ForceSharedSchema",pcOptions) > 0 then
    dictOptions:ForceSharedSchema = true.
if lookup("PreDeployLoad",pcOptions) > 0 then
    dictOptions:PreDeployLoad = "yes".
if lookup("TriggerLoad",pcOptions) > 0 then
    dictOptions:TriggerLoad = "yes".
if lookup("PostDeployLoad",pcOptions) > 0 then
    dictOptions:PostDeployLoad = "yes".
if lookup("OfflineLoad",pcOptions) > 0 then
    dictOptions:OfflineLoad = "yes".
 
run prodict/dump/_load_df.p(dictOptions). 

pcWarnings = dictOptions:Logger:RemoveWarningMessages().
 
if valid-object(dictOptions:Logger:Error) then
    undo, throw dictOptions:Logger:Error.

finally:
    delete object dictOptions.
end. 
