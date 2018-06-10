/*************************************************************/
/* Copyright (c) 2014 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : PartitionPolicyDetailDataSource.cls
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Jul 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.DataAccess.DataMapper from propath.
using OpenEdge.DataAdmin.DataSource.DataSource from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath. 
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using Progress.Database.DBConfig.
using Progress.Database.Storage.

class OpenEdge.DataAdmin.DataSource.PartitionPolicyDetailDataSource inherits DataSource : 
   
    define variable msave as logical no-undo.
    define buffer b_dataArea  for dictdb._Area.
    define buffer b_indexArea for dictdb._Area.
    define buffer b_LobArea   for dictdb._Area.
    define variable lSplit as logical no-undo.
    define variable mcount as integer no-undo.
    define protected variable mBuffer as handle no-undo.
       
    
	define private variable FieldMapNoArea as char
	   init  	
"Name,_Partition-Name,~
Id,_Partition-Id,~
ObjectNumber,_Object-Number,~
Description,_description,~
StringValues,_Partition-Column-Value,~
InternalValue,_Partition-Internal-Value,~
IsSplitTarget,_Attributes[2]"
    no-undo.
    
 /*   ?? mapped in 11.4  - always false and  never updatable 
      Was exported in .d - replaced by readonly in 11.5 
       - safe since it was false in .d and thus can never be used for enabled...... 
isDataEnabled,_Attributes[1],~
*/

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
            return FieldMapNoArea + ",DefaultDataAreaName,b_dataarea._Area-name,DefaultIndexAreaName,b_indexarea._Area-name,DefaultLobAreaName,b_lobarea._Area-name".
        end. 
   
     
    define private property mAreaQuery as character no-undo  
        get(): 
            return "each b_dataArea outer-join no-lock where b_dataArea._area-number = _Partition-Policy-Detail._ianum-Data,"
                   + " each b_indexArea outer-join no-lock where b_indexArea._area-number = _Partition-Policy-Detail._ianum-Index,"
                   + " each b_LobArea outer-join no-lock where b_LobArea._area-number = _Partition-Policy-Detail._ianum-Lob".   
        end.
     
/*  field Id                   as integer         serialize-hidden                                                     */
/*     field Name                 as character       serialize-name "name"                                             */
/*     field IsDataEnabled        as logical         serialize-name "isDataEnabled"                                    */
/*     field IsAllocated          as logical         serialize-name "isAllocated"                                      */
/*     field InternalValue        as raw             serialize-hidden                                                  */
/*     field PartitionPolicyName  as character       serialize-name "partitionPolicyName"                              */
/*     field Description          as character       serialize-name "description"                                      */
/*     field StringValues         as character       serialize-name "values"                                           */
/*     field DefaultDataAreaName  as character       serialize-name "defaultDataAreaName" /* Must be valid TII area */ */
/*     field DefaultDataAreaUrl   as character       serialize-name "defaultDataArea_url"                              */
/*     field DefaultIndexAreaName as character       serialize-name "defaultIndexAreaName" /* Must be valid TII area */*/
/*     field DefaultIndexAreaUrl  as character       serialize-name "defaultIndexArea_url"                             */
/*     field DefaultLobAreaName   as character       serialize-name "defaultLobAreaName" /* Must be valid TII area */  */
/*     field DefaultLobAreaUrl    as character       serialize-name "defaultLobArea_url"                               */
/*     field DefaultAllocation    as character       serialize-name "defaultAllocation"                                */
    
     constructor public PartitionPolicyDetailDataSource ():      
         super ("_Partition-Policy-Detail,b_dataArea,b_indexArea,b_LobArea","dictdb._Partition-Policy-Detail,dictdb._Area,dictdb._Area,dictdb._Area", FieldMap). 
         BaseQueryTemplate = "for each _Partition-Policy-Detail use-index _Partition-obj-IValue&1no-lock, " + mAreaQuery.    
     end constructor.
     
        /* allow subclasses to override to not set call back even if we  have call back here */
    method protected logical SetCallBack(phBuffer as handle):
        phBuffer:set-callback("After-Row-fill","AfterRow").
    end method.
    
    method protected override void PrepareBuffer(phBuffer as handle):
        SetCallBack(phBuffer).
        mBuffer = phBuffer.
    end method.
    
    /** override to sort on the internal value that defines the true order of the partitions  */
    method protected override logical PrepareQueryString (poQueryString as QueryString):    
        define variable isOk as logical no-undo.
        define variable cQuery as character no-undo.
        define variable lok as logical no-undo.
        define variable cuseindex as character no-undo. 
        if poQueryString:SortExpression = "" then 
            cuseindex = " use-index _Partition-obj-IValue ".
        lOk  = AddUniqueOrNone("_Partition-policy",poQueryString). 
        if lok = false then
            return false. 
        if lok = ? and lookup("_Partition-policy",Tables) = 0 then
        do:
            Tables =   "_Partition-policy," + Tables.
            PhysicalTables = "dictdb._Partition-policy," + PhysicalTables.
            BaseQuery = "for each _Partition-policy no-lock, " + TrimQuery(BaseQuery).  
            CreateQuery().    
            DataBuffer:attach-data-source(DataSourceHandle,FieldMap) .
        end.
            
         /* default to sort on true order 
            (by _Partition-policy-detail._Object-number is necessary to avoid current core limitation that 
             fails to return any data when sorting only on _Partition-internal-Value, but should probably be kept 
             even if the limitation is eliminated since we typcially read for one table   )
            @TODO really only necessary when batching  
              */
/*        if poQueryString:SortExpression = "" then                                                                                     */
/*            poQueryString:SetSort("by _Partition-policy-detail._Object-number by _Partition-policy-detail._Partition-internal-Value").*/

        cQuery = poQueryString:BuildQueryString(Tables).
        isOk = QueryHandle:query-prepare(cQuery).  
        return isOk.
    end method.
    
    method protected override character FindTableJoinValues(pTable as char,pFind as char):
        case pTable:
            when "_Partition-Policy" then
                return FindPartitionPolicyJoin(pFind).
        end case.
        return ?. 
    end method.
    
     /* throw standard progress error if non found */
    method private character FindPartitionPolicyJoin(pFind as char):
        buffer dictdb._Partition-Policy:find-unique(pFind).
        return "_Partition-Policy-Detail._Object-number = " + quoter(dictdb._Partition-Policy._Object-number ).
    end method.
   
    /** Save all  
         @param buffer the temp-table buffer handle with data */
    method public override logical Save(bufferHandle as handle):
        this-object:Save(bufferHandle,?).
    end method.     
    
    /** Save changes of specified state 
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified) 
                      ? = all */
    method public override logical Save(bufferHandle as handle,piState as int):
      /*        CreateSaveSource("").*/
        mSave = true. 
        return SaveDetail(bufferHandle,piState).
        finally:
            mSave = false.
        end finally.
    end method.     
    
     /** SaveUser changes of specified state 
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified) 
                      ? = all */
    method protected logical  SaveDetail(phbuffer as handle,pistate as int):
        define buffer bpolicy for dictdb._Partition-Policy.
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
        if piState < 1 or pistate > 3 then
            undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
      
        create query hquery.
        hBeforeBuff = phBuffer:before-buffer.
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare("for each ttPartitionPolicyDetailCopy"
                              + (if piState <> ? 
                                 then " where row-state(ttPartitionPolicyDetailCopy) = " + string(piState)
                                 else "") 
                             ).    
        hquery:query-open().
        hquery:get-first.   
        do transaction on error undo, throw:
            do while hBeforebuff:avail:
                assign
                    lAllocate = false
                    lReadOnly = ? /* use unknwon to detect change to both true or false whihc needs to be stored in pStroage class  */
                    lSplit    = false.    
                if hBeforeBuff:row-state <> 0 then 
                do:
                    if hBeforeBuff:row-state = row-deleted then 
                    do:
                        find dictdb._Partition-Policy-Detail where dictdb._Partition-Policy-Detail._Partition-Name =  hBeforeBuff::name 
                        exclusive-lock no-wait.
                        delete dictdb._Partition-Policy-Detail. 
                    end.    
                    else do :    
                        phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                        /* avoid merge changes if not success set to false at end */ 
                        phBuffer:error = true.
                        
                        if hBeforeBuff:row-state = row-created then 
                        do on error undo, throw:
                            find bPolicy where bPolicy._Partition-Policy-Name =  phBuffer::PartitionPolicyName no-lock.
                            create dictdb._Partition-Policy-Detail.
                              /* it's a core requirement that the object-number must be assigned first */ 
                            assign
                                 dictdb._Partition-Policy-Detail._Object-Number = bPolicy._Object-Number
                                 dictdb._Partition-Policy-Detail._Partition-name = phBuffer::Name
                                 dictdb._Partition-Policy-Detail._Partition-Column-value = phBuffer::StringValues
                                 phBuffer::DefaultAllocation = bPolicy._Allocation-Default 
                                 phBuffer::ObjectNumber      = bPolicy._Object-Number.   
                                
                             
                            if phBuffer::IsAllocated 
                             /* if immediate the language takes care of the allocation, 
                                (The correct state will be returned to client from after row) */
                            and bPolicy._Allocation-Default  <> "Immediate"  
                              /* no point allocating a composite partiton (already is)  
                                @todo - ? find better way to check if composite =- seems a bit scary to rely 
                                        on getting this from UI/client (supposedly read-only though) */     
                            and phBuffer::IsComposite = false then  
                                 lAllocate = true.
                                 
                             if phBuffer::IsReadOnly = true then
                                 lReadOnly = true.
                             
                             if phBuffer::IsSplitTarget = true then
                                 dictdb._Partition-Policy-Detail._Attributes[2] = true.  
                        end. 
                        else do: 
                            if hBeforeBuff::IsSplitTarget <> phBuffer::IsSplitTarget then 
                            do:
                                /*  Core requirement - exclusive lock policy if we're setting split-target  */
                                if phBuffer::IsSplitTarget = true then 
                                do:
                                    
                                    find bPolicy where bPolicy._Partition-Policy-Name =  phBuffer::PartitionPolicyName
                                    exclusive no-wait. 
                                    lSplit = true. /* use flag to avoid checking the condition twice */
                                end.
                                else
                                    undo, throw new DataAccessError("SplitTarget cannot be set to false").
                                
                            end.
                            
                            find dictdb._Partition-Policy-Detail where dictdb._Partition-Policy-Detail._Partition-Name = hBeforeBuff::name 
                            exclusive no-wait. 
                            
                            if dictdb._Partition-Policy-Detail._Partition-name <> phBuffer::Name then 
                                dictdb._Partition-Policy-Detail._Partition-name = phBuffer::Name. 
                     
                            if hBeforeBuff::isAllocated <> phBuffer::isAllocated
                            and phBuffer::isAllocated = true 
                            and dictdb._Partition-Policy-Detail._partition-id <> 0 then
                            do:
                                lAllocate = true.
                            end.
                    
                            if hBeforeBuff::isReadOnly <> phBuffer::isReadOnly
                            and dictdb._Partition-Policy-Detail._partition-id <> 0 then
                            do:
                                lReadOnly = phBuffer::isReadOnly.
                            end.
                        end. 
                       
                        /* source ? and blank ui means nothing changed */
                        if  dictdb._Partition-Policy-Detail._description <> phBuffer::Description then
/*                        and (dictdb._Partition-Policy._description <> ? or phBuffer::Description > "") then*/
                            dictdb._Partition-Policy-Detail._description = phBuffer::Description. 
                        
                        if phbuffer::DefaultDataAreaName > "" then
                        do on error undo, throw:
                            find b_dataarea where b_dataarea._area-name = phbuffer::DefaultDataAreaName
                                no-lock.
                                /* allow default on create*/
                             catch e as Progress.Lang.Error :
                                 if hBeforeBuff:row-state <> row-created then
                                 do: 
                                     cmsg = "DefaultDataArea " + quoter(phbuffer::DefaultDataAreaName) + " does not exist".
                                     undo, throw new DataAccessError(cMsg).
                                 end.
                             end.
                        end.
                        
                        if phbuffer::DefaultIndexAreaName > "" then
                        do on error undo, throw:
                            find b_indexarea where b_indexarea._area-name = phbuffer::DefaultIndexAreaName
                                no-lock. 
                             catch e as Progress.Lang.Error :
                                 if hBeforeBuff:row-state <> row-created then
                                 do:
                                      cmsg = "DefaultIndexArea " + quoter(phbuffer::DefaultIndexAreaName) + " does not exist".    
                                      undo, throw new DataAccessError(cMsg).
                                 end.     
                             end.        
                        end.
                                
                        if phbuffer::DefaultLobAreaName > "" then
                        do on error undo, throw:
                            find b_lobarea where b_lobarea._area-name = phbuffer::DefaultLobAreaName
                                no-lock. 
                             catch e as Progress.Lang.Error :
                                 if hBeforeBuff:row-state <> row-created then
                                 do:
                                     cmsg = "DefaultLobArea " + quoter(phbuffer::DefaultLobAreaName) + " does not exist".    
                                     undo, throw new DataAccessError(cMsg).
                                 end.    
                             end.        
                        end.
                            
                        if avail b_dataarea and b_dataarea._area-number <> dictdb._Partition-Policy-Detail._ianum-data then                  
                            dictdb._Partition-Policy-Detail._ianum-data = b_dataarea._area-number.
                            
                        if avail b_indexarea and b_indexarea._area-number <> dictdb._Partition-Policy-Detail._ianum-index then     
                            dictdb._Partition-Policy-Detail._ianum-index = b_indexarea._area-number. 
                            
                        if avail b_lobarea and b_lobarea._area-number <>  dictdb._Partition-Policy-Detail._ianum-lob then
                            dictdb._Partition-Policy-Detail._ianum-lob = b_lobarea._area-number.
 
                        /* do this after default area changes = data defauot area cannot be changed if split is set
                           lSplit flag is set above if modify (since we need to lock the parent policy for this operation) */
                        if lSplit then 
                        do:
                            /* somewhat unlikely, but could in theory already have been changed by others */
                            if dictdb._Partition-Policy-Detail._Attributes[2]  = false then 
                            do:
                                dictdb._Partition-Policy-Detail._Attributes[2] = true.
                            end.
                        end.
                        /* ensure partitions are created and partition changes are seen (IsAllocated)*/
                        validate dictdb._Partition-Policy-Detail.
                        if hBeforeBuff:row-state = row-created or lSplit then
                            phBuffer::Id = dictdb._Partition-Policy-Detail._partition-id.
                        
                        If lAllocate or lReadOnly <> ? then                           
                        do:
                            /* partition 0 applies to multiple details and is allocated per definition, 
                               so skip when new   */  
                            if dictdb._Partition-Policy-Detail._Partition-id <> 0 or 
                            hBeforeBuff:row-state = row-modified  then
                            do: 
                                /* The first call to DatabaseInfo may call the constructor which
                                         has a find that will give error 7254 in where clause  */
                                dbRecid = DatabaseInfo:DatabaseRecid. 
                                find dictdb._file where dictdb._file._db-recid = dbRecid
                                                  and dictdb._file._file-number = phBuffer::ObjectNumber 
                                                  and dictdb._file._owner = "PUB" no-lock. 
                               
                                partitionobj = DBConfig:GetTable(dictdb._file._file-name,phBuffer::Name,"P").
                               
                                if lAllocate then
                                    partitionobj:AllocationState = "Allocated".
                                IF lReadOnly <> ? then
                                    partitionobj:readOnly = lReadOnly.
                                
                                RefreshPartitionState(phBuffer::name,phBuffer:dataset). 
                            end.
                        end.
                        hdataset = phBuffer:dataset.
                       
                        AfterRow(dataset-handle hdataset by-reference).    
                               
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
            if e:GetMessageNum(1) = 1700 then
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
                e). 
        end catch.       
            
        finally:
           delete object hQuery no-error. 
           mSave = false.           
        end finally.
    end method.  
      
    method public override  void AfterRow(dataset-handle hds):
        define buffer bPolicy for dictdb._Partition-policy.
        define variable hbuffer       as handle no-undo.
        define variable cEncodeName as character no-undo.
        define variable cAreaUrl as character no-undo.
        define variable partitionobj as Storage no-undo.
        define variable dbRecid     as recid no-undo.
        mcount = mcount + 1.
        hBuffer =  hds:get-buffer-handle("ttPartitionPolicyDetail").
        
        if not mSave then
        do:
            find bPolicy where bPolicy._Object-Number =  hBuffer::ObjectNumber no-lock no-error.
            if avail bPolicy then
            do:
                hBuffer::PartitionPolicyName =  bPolicy._Partition-Policy-name.
                hBuffer::DefaultAllocation = bPolicy._Allocation-Default.   
            end.   
        end.    
        
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
                               and dictdb._file._owner = "PUB" no-lock. 
        
        
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
        hBuffer::InternalSort = mcount.
        if url > "" then 
        assign
            cAreaUrl = url + "/areas/"
            cEncodeName = WebUtil:UrlEncode(hBuffer::Name)  
/*            hBuffer::Url  = url + "/partitionpolicydetails/" + cEncodeName*/
            hBuffer::DefaultDataAreaUrl  = cAreaUrl + WebUtil:UrlEncode(hBuffer::DefaultDataAreaName)                   
            hBuffer::DefaultIndexAreaUrl = cAreaUrl + WebUtil:UrlEncode(hBuffer::DefaultIndexAreaName)
            hBuffer::DefaultLobAreaUrl   = cAreaUrl + WebUtil:UrlEncode(hBuffer::DefaultLobAreaName)
            hbuffer::DefaultAllocation   = caps(substr(hbuffer::DefaultAllocation,1,1)) 
                    + lc(substr(hbuffer::DefaultAllocation,2))
            .
    end method.                    
    
    /* set allocated in partitions that were changed . The  context 
       will do a new request, but it does this before the changes are merged so
       partitions with pending updates will not be refreshed due to the
       protection in dataRefreshed */ 
    method public void RefreshPartitionState(pcDetail as char,hds as handle):
        define variable hQuery as handle no-undo.
        define variable hBuffer as handle no-undo.
        hBuffer = hds:get-buffer-handle ("ttPartition").
        if valid-handle(hBuffer) then
        do:
            create query hquery.
            hquery:add-buffer(hBuffer).
            hQuery:query-prepare("for each ttPartition where ttPartition.PartitionPolicyDetailName = " + quoter(pcDetail)
                                 + " and ttPartition.AllocationState <> 'Allocated'").
            hquery:query-open().       
            hquery:get-first.
            do while(hBuffer:avail):
                hBuffer::AllocationState = "Allocated".  
                hquery:get-next.
            end.    
        end.   
        finally:
           delete object hquery no-error.
        end finally. 
    end method.
    
    /* This is the call back for the QueryString parsing. There is currently no mapping, but we override it in 
       order to return the ttPartition's parent keys to the Query. This allows us to extract the expression later.
       Because it is added as parent (i.e _tenant) we can also extract the actual query fields without these.        
    */
   
    method public override character ColumnSource(pcColumn as char):
        if pcColumn = "ttPartitionPolicyDetail.PartitionPolicyName" then 
        do:
            return "_Partition-Policy._Partition-Policy-Name".    
        end.
        else return super:ColumnSource(pcColumn).
    end method.
    
/*    method protected override character FindTableJoinValues(pTable as char,pFind as char):*/
/*        case pTable:                                                                      */
/*            when "_tenant" then                                                           */
/*                return FindTenantJoin(pFind).                                             */
/*                                                                                          */
/*        end case.                                                                         */
/*        return ?.                                                                         */
/*    end method.                                                                           */
/*                                                                                          */
/*    method private character FindTenantJoin(pFind as char):                               */
/*        buffer dictdb._tenant:find-unique(pFind).                                         */
/*        return "_User._Tenantid = " + quoter(_Tenant._Tenantid).                          */
/*    end method.                                                                           */
    
end class.