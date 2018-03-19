 /*************************************************************/
 /* Copyright (c) 2015-2017 by Progress Software Corporation. */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : CdcTablePolicyDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Tue Dec 01 16:31:51 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.DataAccess.DataAccess from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.DataAccess.DataMapper from propath.
using OpenEdge.DataAdmin.DataSource.DataSource from propath.
using OpenEdge.DataAdmin.DataSource.DatabaseInfo from propath.
using OpenEdge.DataAdmin.DataSource.IDataSource from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath.
using OpenEdge.DataAdmin.Lang.WebUtil from propath.
using Progress.Lang.AppError from propath.
using Progress.Database.DBConfig.
using Progress.Database.Storage.
using OpenEdge.DataAdmin.CdcTablePolicyStateEnum.
using OpenEdge.DataAdmin.Internal.Util.CdcTablePolicyInstanceEnum.
using OpenEdge.DataAdmin.CdcTablePolicyLevelEnum.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.CdcTablePolicyDataSource inherits DataSource: 
    
    define buffer b_dataArea  for dictdb._Area.
    define buffer b_indexArea for dictdb._Area.    
    define private property PolicyURL  as character no-undo get. set.
    define private property AreaURL  as character no-undo get. set.
    define variable mcount as integer no-undo.

	define public property QueryString as character no-undo 
        get():
            return Queryhandle:prepare-string.   
        end.
        
    define private property mAreaQuery as character no-undo  
        get(): 
            return "each _file no-lock where recid(_file) = _Cdc-Table-Policy._Source-File-Recid,each b_dataArea outer-join no-lock where b_dataArea._area-number = _Cdc-Table-Policy._Area-Ianum,"
                   + " each b_indexArea outer-join no-lock where b_indexArea._area-number = _Cdc-Table-Policy._Index-Area-Ianum".   
            //return "each _file no-lock where _file._file-number = _Cdc-Table-Policy._ObjectId"
        end. 
        
    define protected property FieldMapNoArea as char no-undo 
          /*isDataEnabled,_Tenant-attributes[1],isAllocated,_Tenant-attributes[2], */
/*        init "Name,_Partition-Policy-name,Table-Name,_File._Field-Name,Field-Names,_Column-Name,HasRange,_Has-Range,NumField,_Num-Columns,Description,_Description,DefaultAllocation,_Allocation-default,DefaultDataAreaName"*/
         init 
"CdcPolicyId,_Policy-Id,~
Name,_Policy-name,~
TableName,_File._File-Name,~
SchemaName,_File._Owner,~
sourcetableowner,_File._Owner,~
Level,_Level,~
State,_Policy-State,~
Instance,_Policy-Instance,~
Description,_Policy-Desc,~
ChangeTable,_Change-Tablename,~
ChangeTableOwner,_Change-Table-Owner,~
IdentifyingField,_Identifying-Fields,~
EncryptPolicy,_Encrypt-Policy,~
LastModified,_Last-Modified,~
Misc,_misc"
       get. 
       
    define protected property FieldMap as char no-undo 
        get().
            return FieldMapNoArea + ",DataAreaName,b_dataarea._Area-name,IndexAreaName,b_indexarea._Area-name".
        end.
        
    define protected variable mBuffer as handle no-undo.
    define variable mSave as logical no-undo.
   
    define protected property DBConfig as DBConfig no-undo
        get():
            if not valid-object(DBConfig) then  
            do:      
                DBConfig = new DBConfig(ldbname("dictdb")).
                DBConfig:LockWait = false.
            end.    
            return DBConfig.
        end.
        private set.
        
    constructor public CdcTablePolicyDataSource ( ):       
        this-object (FieldMap).
        /* order is important = policyfield source creates local index if noin eexists  */
        //SaveChildNames = "ttCdcTablePolicyField".
    end constructor.
    
    constructor public CdcTablePolicyDataSource (pfieldmap as char ):        
        super ("_Cdc-Table-Policy,_File,b_dataArea,b_indexArea","dictdb._Cdc-Table-Policy,dictdb._File,dictdb._Area,dictdb._Area", pFieldMap). 
        BaseQuery = "for each _Cdc-Table-Policy no-lock, " + mAreaQuery.    
    end constructor.
    
    method public override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        define variable lok as logical no-undo.
        phBuffer:set-callback("After-Row-fill","AfterRow").
        mBuffer = phBuffer.      
        lok = super:Prepare(phBuffer,pcTargetQuery,pcJoin).
        return lok.
    end method.
    
    method override protected void AfterSetUrl(): 
        PolicyURL = url + "/cdctablepolicies/".
        AreaURL = url + "/areas/".
    end method.
        
     method protected override logical PrepareQueryString (poQueryString as QueryString):    
        define variable isOk as logical no-undo.
        define variable cQuery as character no-undo.
        
        cQuery = poQueryString:BuildQueryString(Tables).
     
        isOk = QueryHandle:query-prepare(cQuery).  
        return isOk.
    end method.
    
    method public override logical Save(phbuffer as handle):
        undo, throw new UnsupportedOperationError("Save without state for " + this-object:GetClass():TypeName).
    end method.
    
       /** Save changes of specified state 
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified) 
                      ? = all */
    method public override logical Save(phbuffer as handle,piState as int):
        define buffer b_Cdc-Field-Policy for dictdb._Cdc-Field-Policy.
        define buffer b_Cdc-Table-Policy for dictdb._Cdc-Table-Policy.
        
        define variable hDataset     as handle      no-undo. 
        define variable hBeforeBuff  as handle      no-undo.
        define variable hquery       as handle      no-undo.
        define variable cMsg         as character   no-undo.
        define variable dbRecid      as recid       no-undo.
        define variable fieldSource  as IDataSource no-undo.
        define variable indexSource  as IDataSource no-undo.
        define variable i            as integer     no-undo.
        define variable inumidx      as integer     no-undo.
        define variable ipos         as integer     no-undo.
        define variable cIdx         as character   no-undo.
        define variable cIdxMsg      as character   no-undo.
        define variable iNumFlds     as integer     no-undo.                  
        define variable partitionobj as Storage     no-undo.         
        define variable policyId     as char        no-undo.         
        define variable hchild       as handle      no-undo.
        define variable currentInstance    as logical     no-undo init no.
        define variable fieldsSaved    as logical     no-undo.
        
        /*define buffer bpolicy1 for dictdb._Cdc-Table-Policy.
        
        define variable hBeforeBuff1 as handle no-undo.        
        define variable hquery1      as handle no-undo.
        define variable hDataset1    as handle no-undo.
        define variable dbRecid1     as recid  no-undo. */
       
        if not valid-object(DataAccess) then
            undo, throw new AppError("CdcTablePolicyDataSource:Save called with unknown DataAccess property",? ).
      
        if piState  = ?  then
            undo, throw new IllegalArgumentError("CdcTablePolicyDataSource save does not support unknown value in state parameter." ).
        
        if piState < 1 or pistate > 3 then
            undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
        
        mSave = true.
        
           
        create query hquery.
        hBeforeBuff = phBuffer:before-buffer.
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare("for each ttCdcTablePolicyCopy where row-state(ttCdcTablePolicyCopy) = " + string(piState)).
        hquery:query-open().       
        hquery:get-first.   
               
        do transaction on error undo, throw:
            do while hBeforebuff:avail:
                if hBeforeBuff:row-state <> 0 then 
                do:
                    
                    if hBeforeBuff:row-state = row-deleted then 
                    do:                        
                        find dictdb._Cdc-Table-Policy where dictdb._Cdc-Table-Policy._Policy-Name =  hBeforeBuff::Name 
                        exclusive-lock no-wait.
                               
                        delete dictdb._Cdc-Table-Policy.                          
                    end.    
                    else 
                    do :                          
                        phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                        /* avoid merge changes if not success set to false at end */ 
                        phBuffer:error = true.
                        if hBeforeBuff:row-state = row-created then 
                        do on error undo, throw:
                            /* The first call to DatabaseInfo may call the constructor which
                                has a find that will give error 7254 in where clause */
                               
                            dbRecid = DatabaseInfo:DatabaseRecid. 
                            if phBuffer::TableName = "" or phBuffer::TableName = ? then
                                undo, throw new DataAccessError("Table is not specified.").   
                             
                            find dictdb._file where dictdb._file._db-recid = dbRecid
                                and dictdb._file._file-name = phBuffer::TableName 
                                and dictdb._file._owner = phBuffer::SourceTableOwner no-lock no-error. 
                             
                            if not avail dictdb._file then  
                                undo, throw new DataAccessError("Table " + quoter(phBuffer::TableName) + " does not exist.").   
                             
                            /*find dictdb._file where dictdb._file._db-recid = dbRecid
                                and dictdb._file._file-name = phBuffer::TableName 
                                and dictdb._file._owner = phBuffer::SourceTableOwner  no-lock no-error.
                             */
                              
                            /* call child before create since we make index local */ 
                            //SaveChildBuffers(phBuffer,SaveChildNames,piState).                             
                                 
                            create dictdb._Cdc-Table-Policy.                                                     
                            assign
                                dictdb._Cdc-Table-Policy._Policy-name        = phBuffer::Name   
                                dictdb._Cdc-Table-Policy._Encrypt-Policy     = phbuffer::EncryptPolicy when phbuffer::Level ne 0 
                                dictdb._Cdc-Table-Policy._Level              = phbuffer::Level                                 
                                dictdb._Cdc-Table-Policy._Source-File-Recid  = recid(dictdb._file)
                                dictdb._Cdc-Table-Policy._Identifying-Fields = phbuffer::IdentifyingField                                                       
                            .                                  
                            if phbuffer::Instance eq 0 then
                                currentInstance = yes.                            
                                
                            policyId = dictdb._Cdc-Table-Policy._Policy-Id.                                
                            catch e as Progress.Lang.Error :
                                // message e:GetMessage(1) view-as alert-box.
                                 
                                if e:GetMessageNum(1) = 132 then 
                                do:
                                    if e:GetMessage(1) matches "*_Cdc-Table-Policy*Policy-Name*" then
                                    do:
                                        undo, throw new DataAccessError("CDCTablePolicy already exists with Policy Name " + quoter(phBuffer::Name)).
                                    end.
                                    else if e:GetMessage(1) matches "*_Cdc-Table-Policy*Policy-Id*" then
                                    do:
                                        undo, throw new DataAccessError("CDCTablePolicy already exists with Policy Id generated").
                                    end.     
                                end.                                    
                                undo, throw e. 
                            end catch.
                        end. 
                        else 
                        do: 
                            find dictdb._Cdc-Table-Policy where dictdb._Cdc-Table-Policy._Policy-name = hBeforeBuff::Name 
                            exclusive no-wait. 
                            
                            policyId = dictdb._Cdc-Table-Policy._Policy-Id.
                            
                            if dictdb._Cdc-Table-Policy._Policy-name <> phBuffer::Name then 
                                dictdb._Cdc-Table-Policy._Policy-name = phBuffer::Name. 
                                                                
                            /* Core requirement: update IdentifyingField and Level property in following order 
                                case: level 0 to level >0, assign Level first then IdentifyingFields
                                case: level>0 to level 0, assign IdentifyingFields first then Level*/    
                            if hBeforeBuff::Level eq 0 then 
                            do:                                
                                if dictdb._Cdc-Table-Policy._Level <> phBuffer::Level then
                                    dictdb._Cdc-Table-Policy._Level = phBuffer::Level.                                     
                                
                                if dictdb._Cdc-Table-Policy._Identifying-Fields <> phBuffer::IdentifyingField then 
                                    dictdb._Cdc-Table-Policy._Identifying-Fields = phBuffer::IdentifyingField.                                                              
                            end.
                            else 
                            do:
                                if dictdb._Cdc-Table-Policy._Identifying-Fields <> phBuffer::IdentifyingField then 
                                do:                                    
                                    /* update the field policies before setting the IdentifyingFields */
                                    do i = 1 to phBuffer:num-child-relations:
                                        hchild = phBuffer:get-child-relation(i):child-buffer.                            
                                        SaveFieldPolicy(hchild,row-modified,policyId,phbuffer).
                                        SaveFieldPolicy(hchild,row-created,policyId,phbuffer).                                         
                                    end.
                                    fieldsSaved = true.
                                    if dictdb._Cdc-Table-Policy._Identifying-Fields <> phBuffer::identifyingField then
                                        dictdb._Cdc-Table-Policy._Identifying-Fields = phBuffer::IdentifyingField. 
                                end.
                                
                                if dictdb._Cdc-Table-Policy._Level <> phBuffer::Level then 
                                    dictdb._Cdc-Table-Policy._Level = phBuffer::Level.                           
                            end.
                            
                            if dictdb._Cdc-Table-Policy._Encrypt-Policy <> phbuffer::EncryptPolicy then     
                                dictdb._Cdc-Table-Policy._Encrypt-Policy = phbuffer::EncryptPolicy.                                                 
                        end. 
                        /* source ? and blank ui means nothing changed */
                        if  dictdb._Cdc-Table-Policy._Policy-Desc <> phBuffer::Description 
                            and (dictdb._Cdc-Table-Policy._Policy-Desc <> ? or phBuffer::Description > "") then
                            dictdb._Cdc-Table-Policy._Policy-Desc = phBuffer::Description.                                                       
                       
                        if  dictdb._Cdc-Table-Policy._Change-Table-Owner <> phBuffer::ChangeTableOwner 
                            and phBuffer::ChangeTableOwner > "" then
                            dictdb._Cdc-Table-Policy._Change-Table-Owner = phBuffer::ChangeTableOwner.
                                                    
                        if dictdb._Cdc-Table-Policy._Change-TableName <> phBuffer::ChangeTable then do:
                            if phBuffer::ChangeTable > "" then
                                dictdb._Cdc-Table-Policy._Change-TableName = phBuffer::ChangeTable.
                            else if phBuffer::ChangeTable eq "" then 
                                dictdb._Cdc-Table-Policy._Change-TableName = ?.                                
                        end. 
                            
                        if phbuffer::DataAreaName > "" then
                        do on error undo, throw:
                            find b_dataarea where b_dataarea._area-name = phbuffer::DataAreaName
                            no-lock.
                            catch e as Progress.Lang.Error :
                                cmsg = "DataArea " + quoter(phbuffer::DataAreaName) + " does not exist".    
                                undo, throw new DataAccessError(cMsg).
                            end.        
                        end.
                        if phbuffer::IndexAreaName > "" then
                        do on error undo, throw:
                            find b_indexarea where b_indexarea._area-name = phbuffer::IndexAreaName
                            no-lock. 
                            catch e as Progress.Lang.Error :
                                cmsg = "IndexArea " + quoter(phbuffer::IndexAreaName) + " does not exist".    
                                undo, throw new DataAccessError(cMsg).
                            end.        
                        end.                        
                          
                        if avail b_dataarea and b_dataarea._area-number <> dictdb._Cdc-Table-Policy._Area-Ianum then                  
                            dictdb._Cdc-Table-Policy._Area-Ianum = b_dataarea._area-number.
                            
                        if avail b_indexarea and b_indexarea._area-number <> dictdb._Cdc-Table-Policy._Index-Area-Ianum then     
                            dictdb._Cdc-Table-Policy._Index-Area-Ianum = b_indexarea._area-number.
                        
                        /* To achieve create/update of table policy and field policy in a single transaction, 
                           moving the field policy create/update from CdcFieldPolicyDataSource to CdcTablePolicyDataSource */
                        if not fieldsSaved then 
                        do:
                            do i = 1 to phBuffer:num-child-relations:
                                hchild = phBuffer:get-child-relation(i):child-buffer.                            
                                SaveFieldPolicy(hchild,row-modified,policyId,phbuffer).
                                SaveFieldPolicy(hchild,row-created,policyId,phbuffer).                                         
                            end.                                                   
                        end.    
                            
                        /* core requirment: special case where loading current inactive policy, we need to set policy state to active(0) initially. 
                           Then set it to inactive(1) within the same transaction */                           
                        if currentInstance and phBuffer::State eq 1 then 
                            dictdb._Cdc-Table-Policy._Policy-State = 0.
                                
                        if  dictdb._Cdc-Table-Policy._Policy-State <> phBuffer::State then                           
                            dictdb._Cdc-Table-Policy._Policy-State = phbuffer::State.
                        
                        /* release the dataarea and indexarea to have updated values for them 
                           so that it wont have the previous policy information, as we support bulk create/update */     
                        if avail b_dataarea then
                            release b_dataarea.
                            
                        if avail b_indexarea then
                            release b_indexarea.                             
                         
                        /* ensure policy rows are created*/
                        validate dictdb._Cdc-Table-Policy.                                            
                         
                        hdataset = phBuffer:dataset.
                        AfterRow(dataset-handle hdataset by-reference).    
                               
                        phBuffer:error = false.
                        phBuffer:rejected = false.
                        fieldsSaved = false.
                    end.
                end.
                hQuery:get-next.
            end. /* do while hBeforebuff:avail */
            catch e3 as UnsupportedOperationError :
                undo, throw e3.
            end.    
 
            catch e2 as DataAccessError :
                undo, throw e2.
            end.    
            catch e as Progress.Lang.Error :
                if e:GetMessageNum(1) = 1700 then
                do:
                    if length(phbuffer::Name) > 32 then
                        undo, throw new DataAccessError("Policy name is longer than 32 characters",e).
                    else if phbuffer::Name eq "" or phbuffer::Name eq ? then
                        undo, throw new DataAccessError("Cannot create CDC policy with unknown or blank policy name.",e).
                end.
                if e:GetMessageNum(1) = 274 then
                do:
                    if index(phbuffer::Name," ") > 0 then
                        undo, throw new DataAccessError("Spaces are not allowed in the CDC policy name." ,e).
                end.
                 
                undo, throw new DataAccessError(
                    new DataMapper("CDCTablePolicy,_Cdc-Table-Policy,CDCFieldPolicy,_Cdc-Field-Policy,CDCFieldPolicies,_Cdc-Field-Policies,Table,_File,Area,b_dataarea,Area,b_indexarea,",
                    FieldMap + ",DataArea,_Area-Ianum,IndexArea,_Index-Area-Ianum,SourceTable,_Source-File-Recid"),
                    e). 
               
            end catch.          
        
        end. /* transaction */ 
        return true.     
        finally:
            delete object hQuery no-error. 
            mSave = false. 
            fieldsSaved = ?.          
        end finally.
    end method.
    
    method private logical saveFieldPolicy(phbuffer as handle,pistate as int,policyId as char, parentBuff as handle):
        define buffer bpolicy for dictdb._Cdc-Table-Policy.
        define buffer bfld for dictdb._Field.
        define variable hBeforeBuff  as handle    no-undo.
        define variable lnew         as logical   no-undo. 
        define variable hquery       as handle    no-undo.
        define variable iType        as integer   no-undo.
        define variable cType        as character no-undo.
        define variable hDataset     as handle no-undo.
        define variable cMsg         as character no-undo.         
        define variable i            as integer no-undo.
        define variable dbRecid      as recid no-undo.
        define variable partitionobj as Storage no-undo.
        define variable lAllocate    as logical no-undo.
        define variable lReadOnly    as logical no-undo.
        define variable fldName         as character no-undo.
        if piState < 1 or pistate > 3 then
            undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
      
        create query hquery.
        hBeforeBuff = phBuffer:before-buffer.
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare("for each ttCdcFieldPolicyCopy"
                              + (if piState <> ? 
                                 then " where row-state(ttCdcFieldPolicyCopy) = " + string(piState)
                                 else "")
                              //+ " and ttCdcFieldPolicyCopy.CdcTablePolicyName = " + quoter(parentbuff::name) 
                             ).    
        hquery:query-open().
        hquery:get-first.   
        do transaction on error undo, throw:
            do while hBeforebuff:avail:                   
                if hBeforeBuff:row-state <> 0 then 
                do: 
                    /* delete field policy might not be required here, since the same logic is available in CdcFieldPolicyDataSource 
                       which deletes the field policies*/
                        
                    if hBeforeBuff:row-state = row-deleted then 
                    do:
                        find dictdb._Cdc-Table-Policy where dictdb._Cdc-Table-Policy._Policy-name =  hBeforeBuff::CdcTablePolicyName no-lock no-error.
                        dbRecid = DatabaseInfo:DatabaseRecid. 
                        find dictdb._file where dictdb._file._db-recid = dbRecid
                                    and recid(dictdb._file) = dictdb._Cdc-Table-Policy._Source-File-Recid no-lock no-error.
                        find dictdb._field of dictdb._file where dictdb._field._Field-name = hBeforeBuff::FieldName no-lock no-error. 
                                                            
                        find dictdb._Cdc-Field-Policy where dictdb._Cdc-Field-Policy._Field-Recid =  recid(dictdb._field)  
                                                            and dictdb._Cdc-Field-Policy._Policy-Id = hBeforeBuff::CdcPolicyid exclusive-lock no-wait.
                                                            
                        if not avail dictdb._Cdc-Field-Policy then 
                            undo, throw new DataAccessError("Field " + quoter(hBeforeBuff::FieldName) + " was not found in policy " + quoter(hBeforeBuff::CdcTablePolicyName)).
                                                                 
                        delete dictdb._Cdc-Field-Policy. 
                    end.    
                    else 
                    do :    
                        phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                        /* avoid merge changes if not success set to false at end */ 
                        phBuffer:error = true.
                        
                        if hBeforeBuff:row-state = row-created then 
                        do on error undo, throw:
                                                     
                            /* when bulk insert takes place the other policy field information will also be available here.
                               so need to skip the fields which are not part of current policy 
                               @TODO form a better query on queryHandle to find only field policies which are current*/ 
                            if phBuffer::CdcTablePolicyName ne parentbuff::name then 
                            do:
                                hQuery:get-next.
                                next.
                            end.
                            dbRecid = DatabaseInfo:DatabaseRecid. 
                            find dictdb._file where dictdb._file._db-recid = dbRecid
                                      and   dictdb._file._file-name = parentbuff::TableName 
                                      and   dictdb._file._owner = parentbuff::SourceTableOwner no-lock no-error. 
                                
                            if not avail dictdb._file then       
                               undo, throw new DataAccessError("Table " + quoter(parentbuff::TableName) + " does not exist").
                               
                            /* FieldName comes with table name and policy name attached to it.
                               filter only the field name from the value */     
                            if num-entries (phbuffer::FieldName,"@") > 1 then
                                fldName = entry(1,phbuffer::FieldName,"@").
                            else fldName = phbuffer::FieldName.
                            
                            find dictdb._field of dictdb._file where dictdb._field._Field-name = fldName no-lock no-error.
                            if not avail dictdb._field then       
                                undo, throw new DataAccessError("Field " + quoter(FldName) + " was not found in table " + quoter(parentbuff::TableName)). 
                            if policyId eq "" or policyId eq ? then
                                policyId = parentBuff::CdcPolicyId. 
                               
                            create dictdb._Cdc-Field-Policy.
                              /* it's a core requirement that the _Field-Recid must be assigned first before _Identifying-Field*/ 
                            assign
                                 dictdb._Cdc-Field-Policy._Policy-Id = PolicyId
                                 dictdb._Cdc-Field-Policy._Field-Recid = recid(dictdb._field)
                                 dictdb._Cdc-Field-Policy._Identifying-Field = phBuffer::IdentifyingField
                                 .   
                                phBuffer::FieldRecId = recid(dictdb._field).
                                phbuffer::CdcPolicyId = PolicyId.                            
                        end. 
                        else do:                             
                            if hBeforeBuff::identifyingField <> phBuffer::identifyingField then 
                            do: 
                                if hBeforeBuff::identifyingField eq ? then do:
                                    find dictdb._Cdc-Field-Policy where dictdb._Cdc-Field-Policy._Policy-Id = hBeforeBuff::cdcpolicyid
                                                                    and dictdb._Cdc-Field-Policy._Field-Recid = hBeforeBuff::fieldrecid exclusive no-wait.  
                                    if parentbuff::identifyingField eq yes then do:
                                        find dictdb._Cdc-Table-Policy where dictdb._Cdc-Table-Policy._Policy-Id = dictdb._Cdc-Field-Policy._Policy-Id no-error.
                                        if parentbuff::identifyingField <> dictdb._Cdc-Table-Policy._Identifying-Fields then 
                                            dictdb._Cdc-Table-Policy._Identifying-Fields = parentbuff::identifyingField.
                                    end.
                                    if dictdb._Cdc-Field-Policy._Identifying-Field <> phBuffer::identifyingField then
                                        assign dictdb._Cdc-Field-Policy._Identifying-Field = phBuffer::identifyingField.
                                end.
                                else do:
                                    find dictdb._Cdc-Field-Policy where dictdb._Cdc-Field-Policy._Policy-Id = hBeforeBuff::cdcpolicyid
                                                                    and dictdb._Cdc-Field-Policy._Field-Recid = hBeforeBuff::fieldrecid exclusive no-wait.  
                                    if dictdb._Cdc-Field-Policy._Identifying-Field <> phBuffer::identifyingField then
                                        assign dictdb._Cdc-Field-Policy._Identifying-Field = phBuffer::identifyingField.   
                                end.                                  
                            end.
                        end. 
                                              
                        hdataset = phBuffer:dataset.                       
                        AfterFieldRow(dataset-handle hdataset by-reference).    
                               
                        phBuffer:error = false.
                        phBuffer:rejected = false.
                    end.
                end.
                hQuery:get-next.
            end. 
        end.
        return true. 
        catch e2 as DataAccessError :
            undo,throw e2.  
        end catch.
        catch e as Progress.Lang.Error :             
            undo, throw new DataAccessError(            
                new DataMapper("CDCFieldPolicy,_Cdc-Field-Policy,CDCTablePolicy,_Cdc-table-policy",
                "CdcPolicyId,_Policy-Id,FieldRecId,_Field-recid,CDCFieldPolicy:IdentifyingField,_Identifying-Field,FieldPosition,_Field-Position"),
                e).
           /* if e:GetMessageNum(1) = 1700 then
            do:
                if length(phbuffer::name) > 32 then
                    undo, throw new DataAccessError("Policy detail name is longer than 32 characters",e).
                else     
                   undo, throw new DataAccessError("Policy detail name cannot be blank",e).
            end.
            if e:GetMessageNum(1) = 274 then
            do:
                if index(phbuffer::name," ") > 0 then
                    undo, throw new DataAccessError("Spaces are not allowed in the partition policy detail name" ,e).
            end.
            undo, throw new DataAccessError(
            
                new DataMapper("PartitionPolicyDetail,_Partition-Policy-Detail,PartitionPolicy,bPolicy,DefaultDataArea,_ianum-Data",
                FieldMap),
                e). */
        end catch.       
            
        finally:
           delete object hQuery no-error. 
           //mSave = false.           
        end finally.
    end.
    
        method public override  void AfterRow(dataset-handle hds):
        define variable hbuffer       as handle no-undo.        
        define variable cEncodeName   as character no-undo.
        define variable dbRecid       as recid no-undo.
        define variable partitionobj  as Storage no-undo.  
        hBuffer =  hds:get-buffer-handle("ttCdcTablePolicy").   

          /* The first call to DatabaseInfo may call the constructor which
                                     has a find that will give error 7254 in where clause  */
        
        //message hBuffer::CdcTablePolicyName view-as alert-box.
        /*
        dbRecid = DatabaseInfo:DatabaseRecid. 
        find dictdb._file where dictdb._file._db-recid = dbRecid
                          and dictdb._file._file-name = hBuffer::TableName 
                          /*and dictdb._file._owner = "PUB"*/ no-lock no-error. 
        find first dictdb._Cdc-Table-Policy where dictdb._Cdc-Table-Policy._ObjectId =  dictdb._file._file-number
                                                   /*and   dictdb._Cdc-Field-Policy._partition-id = 0*/  no-lock no-error.
        
        find first dictdb._Cdc-Field-Policy where dictdb._Cdc-Field-Policy._Policy-Id =  dictdb._Cdc-Table-Policy._Policy-Id
                                                   /*and   dictdb._Cdc-Field-Policy._partition-id = 0*/  no-lock no-error.
                                                   
        if avail dictdb._Cdc-Field-Policy then
        do on error undo, throw:                                    
             //hBuffer::HasComposite = true.
             
             /* Cannot access inital composite during creation - it is always false for this reason. */     
             if hBuffer:row-state <> row-created then 
             do:
                 partitionobj = DBConfig:GetTable(dictdb._file._file-name,"initial","C").
                 //hBuffer::IsCompositeReadOnly = partitionobj:readOnly. 
             end.      
             //else 
                 //hBuffer::IsCompositeReadOnly = false. 
        end.                
        /*
        if valid-object(partitionobj) then 
        do:
            hBuffer::IsCompositeReadOnly = partitionobj:readOnly.
        end. */    
        */                   
        assign
            cEncodeName = WebUtil:UrlEncode(hBuffer::Name)  
            hBuffer::url  = PolicyURL + cEncodeName
            hBuffer::TableUrl  = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(hBuffer::TableName) 
        
            hBuffer::DataAreaUrl  = AreaUrl + WebUtil:UrlEncode(hBuffer::DataAreaName)                   
            hBuffer::IndexAreaUrl = AreaUrl + WebUtil:UrlEncode(hBuffer::IndexAreaName)               
            hBuffer::CdcFieldPoliciesURL = PolicyURL + cEncodeName + "/cdcfieldpolicies"
            //hBuffer::type = if hBuffer::State eq CdcTablePolicyStateEnum:Active then "Active" else "InActive" 
            . 
/*            hBuffer::AreasUrl      = AreasUrl.*/
    end method.
        
    method public void AfterFieldRow(dataset-handle hds):
        define buffer bPolicy for dictdb._Cdc-Table-Policy.
        define variable hbuffer       as handle no-undo.
        define variable cEncodeName as character no-undo.
        define variable cAreaUrl as character no-undo.
        define variable partitionobj as Storage no-undo.
        define variable dbRecid     as recid no-undo.
        mcount = mcount + 1.
        hBuffer =  hds:get-buffer-handle("ttCdcFieldPolicy").
        //message "obj num" hBuffer::ObjectNumber view-as alert-box.
        if not mSave then
        do:
            find bPolicy where bPolicy._Policy-Id =  hBuffer::CdcPolicyId no-lock no-error.
            //find bPolicy where bPolicy._ObjectId =  hBuffer::ObjectNumber no-lock no-error.
            if avail bPolicy then
            do:
                hBuffer::CdcTablePolicyName =  bPolicy._Policy-name.
                hBuffer::CdcPolicyId = bPolicy._Policy-Id.
                dbRecid = DatabaseInfo:DatabaseRecid. 
                find dictdb._file where dictdb._file._db-recid = dbRecid
                               and recid(dictdb._file) = bPolicy._Source-File-Recid no-lock.
                hbuffer::SourceTableOwner = dictdb._file._owner. 
                hbuffer::TableName = dictdb._file._file-name.
            end.   
        end.    
      /*
        if hBuffer::Id = 0 and hBuffer:row-state = row-created then 
        do:
            assign 
                hBuffer::IsComposite = true
                hBuffer::IsReadOnly  = false
                hBuffer::IsAllocated = true.
        end.
        else do:
           /* The first call to DatabaseInfo may call the constructor which
                has a find that will give error 7254 in where clause  */
           dbRecid = DatabaseInfo:DatabaseRecid. 
           find dictdb._file where dictdb._file._db-recid = dbRecid
                               and dictdb._file._file-number = hBuffer::ObjectNumber 
                               /*and dictdb._file._owner = "PUB"*/ no-lock. 
        
            
            if hBuffer::Id = 0 then
            do:           
                assign
                    hBuffer::IsComposite = true
                    /* find composite partition - initial - C */
                    partitionobj = DBConfig:GetTable(dictdb._file._file-name,"initial","C" ).
            end.       
            else do: 
                assign 
                    hBuffer::IsComposite = false 
                    partitionobj = DBConfig:GetTable(dictdb._file._file-name,hBuffer::Name,"P" ).
            end.
            assign 
                hBuffer::IsReadOnly = partitionobj:ReadOnly
                hBuffer::IsAllocated = partitionobj:AllocationState = "Allocated". 
        end. 
        */
        assign
            cAreaUrl = url + "/areas/"
            cEncodeName = WebUtil:UrlEncode(hBuffer::CdcTablePolicyName)  
            hBuffer::InternalSort = mcount
/*            hBuffer::Url  = url + "/partitionpolicydetails/" + cEncodeName*/
            /*hBuffer::DefaultDataAreaUrl  = cAreaUrl + WebUtil:UrlEncode(hBuffer::DefaultDataAreaName)                   
            hBuffer::DefaultIndexAreaUrl = cAreaUrl + WebUtil:UrlEncode(hBuffer::DefaultIndexAreaName)
            hBuffer::DefaultLobAreaUrl   = cAreaUrl + WebUtil:UrlEncode(hBuffer::DefaultLobAreaName)
            hbuffer::DefaultAllocation   = caps(substr(hbuffer::DefaultAllocation,1,1)) 
                    + lc(substr(hbuffer::DefaultAllocation,2))*/
            .
    end method.
    
     method public override character ColumnExpression(pcColumn as char,pcOperator as char,pcValue as char):
       
        return ?.   
    end. 
    
    method public override logical Attach(bufferHandle as handle).
        FieldMapping = FieldMapNoArea.
        return super:Attach(bufferHandle).
    end method.
    
    method public override logical Refresh(phbuffer as handle):
        define variable hQuery  as handle no-undo.                                                            
        create query hquery.                                                                                  
        hquery:add-buffer(phBuffer).                                                                          
        hQuery:query-prepare("for each ttCdcTablePolicy").           
        hquery:query-open().                                                                                  
        hquery:get-first.                                                                                     
        do while phbuffer:avail:                                                                              
            /** @todo - remove no-error and throw something                                                   
             also check if exclusive and validate is needed                                                   
             (this was done late before ship) */                                                           
            find dictdb._Cdc-table-policy where dictdb._Cdc-table-policy._policy-name = phBuffer::Name no-lock no-error.
            if avail dictdb._Cdc-table-policy then                                                                      
            do:                                                                                               
                validate dictdb._Cdc-table-policy. 
                assign                 
                phBuffer::ChangeTableOwner = dictdb._Cdc-table-policy._Change-Table-Owner
                phBuffer::CdcPolicyId  = dictdb._Cdc-table-policy._Policy-Id
                phBuffer::LastModified  = dictdb._Cdc-table-policy._Last-Modified                
                .                                
            end.                                                                                              
            hquery:get-next.                                                                                  
        end.                                                                                                  
 
    end method.
    
    method public override logical Refreshbuffers(phbuffer as handle):        
        find dictdb._Cdc-table-policy where dictdb._Cdc-table-policy._policy-name = phBuffer::Name no-lock no-error.
        if avail dictdb._Cdc-table-policy then                                                                      
        do:                                                                                               
            //validate dictdb._Cdc-table-policy. 
            assign                                                                      
                phBuffer::ChangeTable =  dictdb._Cdc-table-policy._Change-Tablename                
                phBuffer::Instance  = dictdb._Cdc-table-policy._Policy-Instance
                .   
         end.  
    end method.
    
    method public override character ColumnSource (pcColumn as char):
        define variable cNew as character no-undo.
  
            cNew = super:ColumnSource(pccolumn).
            if cNew <> pccolumn then
                 return cNew.       
        /* data types does not match - for access permissions 
           Attach maps with MapNoArea to avoid finding the area fields */
        if pccolumn = "ttCdcTablePolicy.DataAreaName" then
        do:
            return "_Cdc-Table-Policy._Area-Ianum".      
        end.
        if pccolumn = "ttCdcTablePolicy.IndexAreaName" then
        do:
            return "_Cdc-Table-Policy._Index-Area-Ianum".      
        end.        
     
        return pccolumn.
    end method.

end class.