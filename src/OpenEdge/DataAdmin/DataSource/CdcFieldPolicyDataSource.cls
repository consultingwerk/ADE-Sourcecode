 /*************************************************************/
 /* Copyright (c) 2015-2017 by progress Software Corporation  */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 
 /*------------------------------------------------------------------------
    File        : CdcFieldPolicyDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Tue Dec 01 18:48:41 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.DataAccess.DataMapper from propath.
using OpenEdge.DataAdmin.DataSource.DataSource from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath. 
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using Progress.Database.DBConfig.
using Progress.Database.Storage.
using OpenEdge.DataAdmin.Internal.Util.CdcTablePolicyInstanceEnum from propath.

block-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.CdcFieldPolicyDataSource inherits DataSource: 
    
    define variable msave as logical no-undo.
    define buffer b_dataArea  for dictdb._Area.
    define buffer b_indexArea for dictdb._Area.
    define variable lSplit as logical no-undo.
    define variable mcount as integer no-undo.
    define protected variable mBuffer as handle no-undo.
    
    define private variable FieldMapNoArea as char
       init     
"CdcPolicyId,_Policy-Id,~
FieldRecId,_Field-recid,~
IdentifyingField,_Identifying-Field,~
FieldPosition,_Field-Position,~
Misc,_Misc"
    no-undo.
    
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
    
    define protected property FieldMap as char no-undo 
        get(). 
            return FieldMapNoArea + ",FieldName,_Field._Field-Name".
        end. 
        
    define private property mAreaQuery as character no-undo  
        get(): 
            return "each _field no-lock where recid(_field) = _Cdc-Field-Policy._Field-Recid".   
            //return "each _file no-lock where _file._file-number = _Cdc-Table-Policy._ObjectId"
        end. 
        
    
    constructor public CdcFieldPolicyDataSource ():      
         super ("_Cdc-Field-Policy,_Field","dictdb._Cdc-Field-Policy,dictdb._Field", FieldMap). 
         BaseQuery = "for each _Cdc-Field-Policy use-index _Policy-Id no-lock, " + mAreaQuery.    
     end constructor.
     
    method protected logical SetCallBack(phBuffer as handle):
        phBuffer:set-callback("After-Row-fill","AfterRow").
    end method.
    
    method public final override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        define variable lok as logical no-undo.
        SetCallBack(phBuffer).
        lok  = super:Prepare(phBuffer,pcTargetQuery,pcJoin).
        mBuffer = phBuffer.
        return lok.
    end method.
    
    method protected override logical PrepareQueryString (poQueryString as QueryString):    
        define variable isOk as logical no-undo.
        define variable cQuery as character no-undo.
        define variable lok as logical no-undo.
        define variable cuseindex as character no-undo. 
        if poQueryString:SortExpression = "" then 
           cuseindex = " use-index _Policy-Id ".
        lOk  = AddUniqueOrNone("_Cdc-Table-Policy",poQueryString). 
        if lok = false then
            return false. 
        if lok = ? and lookup("_Cdc-Table-Policy",Tables) = 0 then
        do:
            Tables =   "_Cdc-Table-Policy," + Tables.
            PhysicalTables = "dictdb._Cdc-Table-Policy," + PhysicalTables.
            BaseQuery = "for each _Cdc-Table-Policy no-lock, " + TrimQuery(BaseQuery).  
            CreateQuery().    
            DataBuffer:attach-data-source(DataSourceHandle,FieldMap) .
        end.            
         
        cQuery = poQueryString:BuildQueryString(Tables).
        isOk = QueryHandle:query-prepare(cQuery).  
        return isOk.
    end method.
    
    method protected override character FindTableJoinValues(pTable as char,pFind as char):
        case pTable:
            when "_Cdc-Table-Policy" then
                return FindCdcTablePolicyJoin(pFind).
        end case.
        return ?. 
    end method.
    
    /* throw standard progress error if non found */
    method private character FindCdcTablePolicyJoin(pFind as char):
        buffer dictdb._Cdc-Table-Policy:find-unique(pFind). //_Source-File-Recid dictdb._Cdc-Table-Policy._Policy-Id
        //find dictdb._file where recid(dictdb._file) = dictdb._Cdc-Table-Policy._Source-File-Recid.
        //find dictdb._field of dictdb._file where dictdb._field._file-recid = recid(dictdb._file).
        return "_Cdc-Field-Policy._Policy-Id = " + quoter(dictdb._Cdc-Table-Policy._Policy-Id).
    end method.
    
    method public override logical Save(bufferHandle as handle):
        this-object:Save(bufferHandle,?).
    end method.
    
    method public override logical Save(bufferHandle as handle,piState as int):
      /*        CreateSaveSource("").*/
        mSave = true. 
        return SaveFieldPolicy(bufferHandle,piState).
        finally:
            mSave = false.
        end finally.
    end method.
    
    method protected logical  SaveFieldPolicy(phbuffer as handle,pistate as int):
        define buffer bpolicy for dictdb._Cdc-Table-Policy.
        define variable hBeforeBuff  as handle    no-undo.
        define variable hquery       as handle    no-undo.
        define variable hDataset     as handle no-undo.        
        define variable i            as integer no-undo.
        define variable dbRecid      as recid no-undo.
        define variable fldName      as character no-undo.
        
        if piState < 1 or pistate > 3 then
            undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
      
        create query hquery.
        hBeforeBuff = phBuffer:before-buffer.
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare("for each ttCdcFieldPolicyCopy"
                              + (if piState <> ? 
                                 then " where row-state(ttCdcFieldPolicyCopy) = " + string(piState)
                                 else "") 
                             ).    
        hquery:query-open().
        hquery:get-first.   
        do transaction on error undo, throw:
            do while hBeforebuff:avail:   
                if hBeforeBuff:row-state <> 0 then 
                do:
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
                    else do :    
                        phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                        /* avoid merge changes if not success set to false at end */ 
                        phBuffer:error = true.
                        if hBeforeBuff:row-state = row-created then 
                        do on error undo, throw:                        
                           
                            /*table policy creation block in CdcTablePolicyDataSource has field policy creation which will create field policies if mentioned.
                              skip the creation of field policies when created along with table policies in this block.*/
                            if phBuffer:dataset:get-buffer-handle("ttCdcTablePolicy"):row-state <> 3 then 
                            do:                                
                                find bPolicy where bPolicy._Policy-Name =  phBuffer::CdcTablePolicyName no-lock no-error.    
                                dbRecid = DatabaseInfo:DatabaseRecid. 
                                find dictdb._file where dictdb._file._db-recid = dbRecid
                                    and   recid(dictdb._file) = bPolicy._Source-File-Recid no-lock no-error.                                
                                if not avail dictdb._file then       
                                    undo, throw new DataAccessError("Table " + quoter(phBuffer::TableName) + " does not exist").
                                    
                                hdataset = phBuffer:dataset.    
                                /* FieldName comes with table name and policy name attached to it.
                                filter only the field name from the value */     
                                if num-entries (phbuffer::FieldName,"@") > 1 then
                                    fldName = entry(1,phbuffer::FieldName,"@").
                                else fldName = phbuffer::FieldName.
                  
                                find dictdb._field of dictdb._file where dictdb._field._Field-name = fldName no-lock no-error.
                                if not avail dictdb._field then       
                                    undo, throw new DataAccessError("Field " + quoter(fldName) + " was not found in table " + quoter(phBuffer::TableName)).
                               
                                find dictdb._Cdc-Field-Policy where dictdb._Cdc-Field-Policy._Field-Recid eq recid(dictdb._field)
                                    and dictdb._Cdc-Field-Policy._Policy-Id = bPolicy._Policy-Id no-lock no-error.
                                
                                /* Skip creation of field policy when CdcTablePolicyDataSource created it already */                             
                                if avail dictdb._Cdc-Field-Policy or ParentChanged(dataset-handle hdataset by-reference)then 
                                do:
                                    hQuery:get-next.
                                    next.
                                end.
                               
                                create dictdb._Cdc-Field-Policy.                              
                                assign
                                    dictdb._Cdc-Field-Policy._Policy-Id         = bPolicy._Policy-Id
                                   //dictdb._Cdc-Field-Policy._Field-Position =  dictdb._field._field-rpos //fld._field-rpos
                                    dictdb._Cdc-Field-Policy._Field-Recid       = recid(dictdb._field)
                                    dictdb._Cdc-Field-Policy._Identifying-Field = phBuffer::IdentifyingField
                                    .
                                phBuffer::FieldRecId = recid(dictdb._field).                                
                            end. 
                        end. 
                        else 
                        do:                             
                            if hBeforeBuff::identifyingField <> phBuffer::identifyingField then 
                            do: 
                                hdataset = phBuffer:dataset.  
                                if hBeforeBuff::identifyingField eq ? then 
                                do:                                     
                                    find dictdb._Cdc-Field-Policy where dictdb._Cdc-Field-Policy._Policy-Id = hBeforeBuff::cdcpolicyid
                                        and dictdb._Cdc-Field-Policy._Field-Recid = hBeforeBuff::fieldrecid exclusive no-wait.                                                                    
                                    
                                    if dictdb._Cdc-Field-Policy._Identifying-Field <> phBuffer::identifyingField 
                                        and not ParentChanged(dataset-handle hdataset by-reference) then 
                                        assign dictdb._Cdc-Field-Policy._Identifying-Field = phBuffer::identifyingField.
                                end.
                                else 
                                do:
                                    find dictdb._Cdc-Field-Policy where dictdb._Cdc-Field-Policy._Policy-Id = hBeforeBuff::cdcpolicyid
                                        and dictdb._Cdc-Field-Policy._Field-Recid = hBeforeBuff::fieldrecid exclusive no-wait. 
                                         
                                    if dictdb._Cdc-Field-Policy._Identifying-Field <> phBuffer::identifyingField 
                                        and not ParentChanged(dataset-handle hdataset by-reference) then
                                        assign dictdb._Cdc-Field-Policy._Identifying-Field = phBuffer::identifyingField. 
                                end.                                  
                            end.
                        end. 
                                              
                        hdataset = phBuffer:dataset.                                             
                        AfterRow(dataset-handle hdataset by-reference).    
                               
                        phBuffer:error = false.
                        phBuffer:rejected = false.
                    end.
                end.
                hQuery:get-next.
            end. //end hBeforebuff avail block            
        end. // end do trans block
        return true. 
        catch e2 as DataAccessError :
            undo,throw e2.  
        end catch.
        catch e as Progress.Lang.Error : 
             undo, throw new DataAccessError(            
                new DataMapper("CDCFieldPolicy,_Cdc-Field-Policy,CDCTablePolicy,_Cdc-Table-Policy",FieldMap),
                e).
        end catch.       
            
        finally:
           delete object hQuery no-error. 
           mSave = false.       
        end finally.
    end method.
    
    method public override  void AfterRow(dataset-handle hds):
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
        assign
            cAreaUrl = url + "/areas/"
            cEncodeName = WebUtil:UrlEncode(hBuffer::CdcTablePolicyName)  
            hBuffer::InternalSort = mcount
            .
    end method.
    
    /* when there are any table policy changes(create/update) and we have changes for fields policies
       then the field policy changes will be done in the CdcTablePolicyDataSource 
       This is done to support single transaction for field policy and table policy */
    method public logical ParentChanged(dataset-handle hds):
        define buffer bPolicy for dictdb._Cdc-Table-Policy.
        define variable fBuffer as handle no-undo.
        define variable tBuffer as handle no-undo.
        define variable pBuffer as handle no-undo.
        define variable hQuery  as handle no-undo.
        define variable pFilter as char   no-undo.
        
        fBuffer =  hds:get-buffer-handle("ttCdcFieldPolicy").
        tBuffer =  hds:get-buffer-handle("ttCdcTablePolicy").
        
        create buffer pBuffer for table tBuffer.
        create query hQuery.           
        hQuery:add-buffer(pBuffer).            
        pFilter = "for each " + pBuffer:name + " where ttCdcTablePolicy.name eq " + quoter(fBuffer::CdcTablePolicyName).            
        hQuery:query-prepare (pFilter). 
        if not hQuery:is-open then
            hQuery:query-open().
        hQuery:get-first().
            //undo, throw new DataAccessError("debug: " + quoter(fBuffer::CdcTablePolicyName) + quoter(pbuffer::IdentifyingField)).  
        if pBuffer:available then              
            find bPolicy where bPolicy._Policy-Name =  pBuffer::Name no-error.
        if available bPolicy then 
        do:
            if bPolicy._Identifying-Fields <> pBuffer::IdentifyingField 
                or bPolicy._Level <> pBuffer::Level 
                or bPolicy._Policy-State <> pBuffer::State then
                return yes.  
        end.       
        return false.
    end method.
    
    method public override character ColumnSource(pcColumn as char):
        if pcColumn = "ttCdcFieldPolicy.CdcTablePolicyName" then 
        do:
            return "_Cdc-Table-Policy._Policy-Name".    
        end.
        else return super:ColumnSource(pcColumn).
    end method.
    
 
end class.