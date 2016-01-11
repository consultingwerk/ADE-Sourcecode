/**************************************************************/
 /* Copyright (c) 2014 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : PartitionPolicyDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
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

routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.PartitionPolicyDataSource inherits DataSource: 
    
 
    define buffer b_dataArea  for dictdb._Area.
    define buffer b_indexArea for dictdb._Area.
    define buffer b_LobArea   for dictdb._Area.
    define private property PolicyURL  as character no-undo get. set.
    define private property AreaURL  as character no-undo get. set.
       /* not really allowed - */
    define public property QueryString as character no-undo 
        get():
            return Queryhandle:prepare-string.   
        end.
        
    define private property mAreaQuery as character no-undo  
        get(): 
            return "each _file no-lock where _file._file-number = _Partition-Policy._Object-number,each b_dataArea outer-join no-lock where b_dataArea._area-number = _Partition-Policy._DataArea-default,"
                   + " each b_indexArea outer-join no-lock where b_indexArea._area-number = _Partition-Policy._IndexArea-default,"
                   + " each b_LobArea outer-join no-lock where b_LobArea._area-number = _Partition-Policy._LobArea-default".   
        end.
        
    define protected property FieldMapNoArea as char no-undo 
          /*isDataEnabled,_Tenant-attributes[1],isAllocated,_Tenant-attributes[2], */
/*        init "Name,_Partition-Policy-name,Table-Name,_File._Field-Name,Field-Names,_Column-Name,HasRange,_Has-Range,NumField,_Num-Columns,Description,_Description,DefaultAllocation,_Allocation-default,DefaultDataAreaName"*/
         init "Name,_Partition-Policy-name,TableName,_File._File-Name,SchemaName,_File._Owner,ObjectNumber,_Object-Number,FieldNames,_Column-Name,HasRange,_Has-Range,NumFields,_Num-Columns,Description,_Description,DefaultAllocation,_Allocation-default"
       get. 
         
       /* for attach */
    define protected property FieldMap as char no-undo 
        get().
            return FieldMapNoArea + ",DefaultDataAreaName,b_dataarea._Area-name,DefaultIndexAreaName,b_indexarea._Area-name,DefaultLobAreaName,b_lobarea._Area-name".
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
   
	constructor public PartitionPolicyDataSource ( ):	    
		this-object (FieldMap).
		/* order is important = policyfield source creates local index if noin eexists  */
		SaveChildNames = "ttLocalIndex,ttPartitionPolicyField".
    end constructor.
    
    constructor public PartitionPolicyDataSource (pfieldmap as char ):        
        super ("_Partition-Policy,_File,b_dataArea,b_indexArea,b_LobArea","dictdb._Partition-Policy,dictdb._File,dictdb._Area,dictdb._Area,dictdb._Area", pFieldMap). 
        BaseQuery = "for each _Partition-Policy no-lock, " + mAreaQuery.    
    end constructor.
   
/*    constructor public PartitionPolicyDataSource (phChild as handle,pfieldmap as char ):                                              */
/*        super ("_Tenant,b_dataArea,b_indexArea,b_LobArea","dictdb._Tenant,dictdb._Area,dictdb._Area,dictdb._Area",phchild, pFieldMap).*/
/*        BaseQuery = "for each _Tenant no-lock,"                                                                                       */
/*                  +  mAreaQuery                                                                                                       */
/*                  + ", each " + phChild:name + " no-lock".                                                                            */
/*    end constructor.                                                                                                                  */
    /* keep
    constructor public TenantDataSource (phParent as handle,pcJoin as char,pfieldmap as char ):        
        super (phParent, "_Tenant,b_dataArea,b_indexArea,b_LobArea","dictdb._Tenant,dictdb._Area,dictdb._Area,dictdb._Area",pFieldMap). 
        BaseQuery = "for each " + phParent:name + " no-lock,"
                  + " each _Tenant" 
                  + (if pcjoin > "" then " where " + pcjoin else "")
                  + " no-lock, " 
                  + mAreaQuery + " no-lock".       
    end constructor.
    */
   
    method public override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        define variable lok as logical no-undo.
        phBuffer:set-callback("After-Row-fill","AfterRow").
        mBuffer = phBuffer.      
        lok = super:Prepare(phBuffer,pcTargetQuery,pcJoin).
        return lok.
    end method.
    
    method override protected void AfterSetUrl(): 
        PolicyURL = url + "/partitionpolicies/".
        AreaURL = url + "/areas/".
    end method.
    
    method protected override logical PrepareQueryString (poQueryString as QueryString):    
        define variable isOk as logical no-undo.
        define variable cQuery as character no-undo.
        
        cQuery = poQueryString:BuildQueryString(Tables).
     
        isOk = QueryHandle:query-prepare(cQuery).  
        return isOk.
    end method.
    
   /** tenant requires control of order , so this is not supported  */
    method public override logical Save(phbuffer as handle):
        undo, throw new UnsupportedOperationError("Save without state for " + this-object:GetClass():TypeName).
    end method.
    
    /**  refresh row-state 0  isallocated  */
    method public override logical Refresh(phbuffer as handle):
/*        define variable hQuery  as handle no-undo.                                                            */
/*        create query hquery.                                                                                  */
/*        hquery:add-buffer(phBuffer).                                                                          */
/*        hQuery:query-prepare("for each _Partition-Policy where row-state(_Partition-Policy) = 0 ").           */
/*        hquery:query-open().                                                                                  */
/*        hquery:get-first.                                                                                     */
/*        do while phbuffer:avail:                                                                              */
/*            /** @todo - remove no-error and throw something                                                   */
/*             also check if exclusive and validate is needed                                                   */
/*             (this was done late before ship) */                                                              */
/*            find dictdb._tenant where dictdb._tenant._tenantid = phBuffer::id exclusive-lock no-wait no-error.*/
/*            if avail dictdb._tenant then                                                                      */
/*            do:                                                                                               */
/*                validate dictdb._tenant.                                                                      */
/*                phBuffer::IsAllocated =  dictdb._tenant._Tenant-attributes[2].                                */
/*            end.                                                                                              */
/*            hquery:get-next.                                                                                  */
/*        end.                                                                                                  */
 
    end method.
    
    
   /** Save changes of specified state 
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified) 
                      ? = all */
    method public override logical Save(phbuffer as handle,piState as int):
        define buffer b_policy-detail for dictdb._Partition-Policy-Detail.
        
        define variable hDataset as handle no-undo. 
        define variable hBeforeBuff as handle    no-undo.
        define variable hquery      as handle    no-undo.
        define variable cMsg        as character no-undo.
        define variable dbRecid     as recid no-undo.
        define variable fieldSource as IDataSource no-undo.
        define variable indexSource as IDataSource no-undo.
        define variable i           as integer no-undo.
        define variable inumidx     as integer no-undo.
        define variable ipos        as integer no-undo.
        define variable cIdx        as character no-undo.
        define variable cIdxMsg     as character no-undo.
        define variable iNumFlds    as integer no-undo.                  
        define variable partitionobj as Storage no-undo.                  
        if not valid-object(DataAccess) then
            undo, throw new AppError("PartitionPolicyDataSource:Save called with unknown DataAccess property",? ).
      
        if piState  = ?  then
            undo, throw new IllegalArgumentError("PartitionPolicyDataSource save does not support unknown value in state parameter." ).
        
        if piState < 1 or pistate > 3 then
            undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
              
        fieldSource = DataAccess:GetSaveSource("ttPartitionPolicyField").
        if not valid-object(DataAccess) then
            undo, throw new AppError("Save failed. PartitionPolicyFieldDataSource not found in DataAccess object " + DataAccess:toString() ,? ).
        
        indexSource = DataAccess:GetSaveSource("ttLocalIndex").
        if not valid-object(DataAccess) then
            undo, throw new AppError("Save failed. LocalIndexDataSource not found in DataAccess object " + DataAccess:toString() ,? ).
        
        mSave = true.
        
           
        create query hquery.
        hBeforeBuff = phBuffer:before-buffer.
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare("for each ttPartitionPolicyCopy where row-state(ttPartitionPolicyCopy) = " + string(piState)).
        hquery:query-open().       
        hquery:get-first.   
               
        do transaction on error undo, throw:
            do while hBeforebuff:avail:
                if hBeforeBuff:row-state <> 0 then 
                do:
                   
                    if hBeforeBuff:row-state = row-deleted then 
                    do:
                        find dictdb._Partition-Policy where dictdb._Partition-Policy._Partition-Policy-Name =  hBeforeBuff::name 
                        exclusive-lock no-wait.
                        for each dictdb._Partition-Policy-Detail
                             where dictdb._Partition-Policy-Detail._Object-Number = dictdb._Partition-Policy._Object-Number 
                        no-lock 
                        on error undo , throw:
                            
                            find b_policy-detail where rowid(b_policy-detail) = rowid(dictdb._Partition-Policy-Detail) exclusive no-wait no-error.
                            if b_policy-detail._partition-id = 0 then 
                            do:
                                undo, throw new DataAccessError("Cannot delete policy " + quoter(hBeforeBuff::name) + " because it has details in a composite partition" ). 
                            end.    
                            partitionobj = DBConfig:GetTable(hBeforeBuff::TableName,b_policy-detail._Partition-name,"P") .
                            if partitionobj:AllocationState = "Allocated" then
                            do:
                                undo, throw new DataAccessError("Cannot delete policy " + quoter(hBeforeBuff::name) + " because it has allocated details" ). 
                            end.   
                            delete b_policy-detail.
                          
                        end.
                               
                        delete dictdb._Partition-Policy. 
                         
                    end.    
                    else do :    
                       
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
                                               and dictdb._file._owner = "PUB" no-lock no-error. 
                             
                             if not avail dictdb._file then  
                                undo, throw new DataAccessError("Table " + quoter(phBuffer::TableName) + " does not exist.").   
                              
                             if not dictdb._file._file-attributes[3] then 
                             do:
                                 find dictdb._file where dictdb._file._db-recid = dbRecid
                                                     and dictdb._file._file-name = phBuffer::TableName 
                                                     and dictdb._file._owner = "PUB" exclusive-lock. 
                                 dictdb._file._file-attributes[3] = true.
                             end.
                             else do:
                                 find dictdb._file where dictdb._file._db-recid = dbRecid
                                                     and dictdb._file._file-name = phBuffer::TableName 
                                                     and dictdb._file._owner = "PUB" no-lock. 
                             end.        
                              
                              /* call child before create since we make index local */ 
                             SaveChildBuffers(phBuffer,SaveChildNames,piState).
                             /* core schema (bug) gives  other errors before slready exists */
                             if can-find( dictdb._Partition-Policy  where dictdb._Partition-Policy._Partition-Policy-name = phBuffer::Name ) then
                                  undo, throw new  DataAccessError("PartitionPolicy " + quoter (phBuffer::Name) + " already exists").
                             create dictdb._Partition-Policy.
                        
                             assign
                                 dictdb._Partition-Policy._Partition-Policy-name = phBuffer::Name
                                 dictdb._Partition-Policy._Object-Number = dictdb._file._file-number
                                 dictdb._Partition-Policy._Has-Range = phBuffer::HasRange.
                             
                             do i = 1 to 15:     
                                 if phBuffer::FieldNames(i) > "" then
                                 do:
                                     dictdb._Partition-Policy._Column-Name[i] = phBuffer::FieldNames(i).
                                     iNumFlds = i.
                                 end.
                                 else 
                                     leave.     
                             end.             
                             
                             catch e as Progress.Lang.Error :
                                 
                                 if e:GetMessageNum(1) = 132 then 
                                 do:
                                     if e:GetMessage(1) matches "*_Partition-Policy*Object-Number*" then
                                     do:
                                         undo, throw new DataAccessError("PartitionPolicy already exists for Table " + quoter(phBuffer::TableName) + ".",e).
                                     end.     
                                 end.    
                                   /* Currently the message for non matching local index is: 
                                      "Must have an _Index-Field of _Index"
                                      @TODO update to check number  when core is done
                                   */
                                 else if e:GetMessage(1) matches "*_index-field*_index*" then
                                 do:   
                                     cidxmsg = IndexFields(recid( dictdb._file),output inumidx) .
                                     if inumidx > 0 then
                                     do:
                                         ipos = index(e:GetMessage(1),"'").
                                         if ipos > 0 then
                                         do:
                                             cIdx =  right-trim(substr(e:GetMessage(1),ipos + 1),"'").
                                             cidxmsg = IndexFields(recid( dictdb._file),cIdx,output inumidx) .
                                             /* wipe out if not found */
                                             if inumidx <> 1 then
                                             do:
                                                 cidx = "".                                        
                                             end.
                                         end.     
                                                                       
                                         cmsg = "Table " + phBuffer::TableName
                                              + " has no local index that matches".
                                         do i = 1 to iNumFLds:
                                             cMsg = cMsg
                                                  + (if i = 1            then " "
                                                     else if inumFlds  = i then " and "
                                                                        else ", ")
                                                  +  phBuffer::FieldNames(i).
                                         end.
                                         cMsg = cMsg
                                              + ". The table has "
                                              + (if inumidx > 1 or cidx > "" then "" else "a ")
                                              + "local index"
                                              + (if cidx > "" then " " + quoter(cidx) + " " 
                                                 else if inumidx > 1 then "es " 
                                                 else " ")
                                              + "on "
                                              + cidxmsg
                                              + ".".
                    
                                        undo, throw new DataAccessError(cMsg , e).
                                    end.
                                end.
                                /* let the post transaction catch throw the DataAccessError */
                                undo, throw e.   
                            end catch.
                        end. 
                        else do: 
                            find dictdb._Partition-Policy where dictdb._Partition-Policy._Partition-Policy-name = hBeforeBuff::name 
                            exclusive no-wait. 
                        
                            if dictdb._Partition-Policy._Partition-Policy-name <> phBuffer::Name then 
                                dictdb._Partition-Policy._Partition-Policy-name = phBuffer::Name. 
                            
                            if dictdb._Partition-Policy._Has-Range <> phBuffer::HasRange then
                            do:
                                undo, throw new DataAccessError("Cannot change has range of an existing PartitionPolicy").
                            end.
                            /* allocated only makes sense when not new */
/*                            if dictdb._Partition-Policy._Partition-Policy-attributes[2] <> phBuffer::isAllocated  */
/*                            and phBuffer::isAllocated = true then                                                 */
/*                            do:                                                                                   */
/*                                dictdb._Partition-Policy._Partition-Policy-attributes[2] =  phBuffer::isAllocated.*/
/*                                RefreshPartitionState(phBuffer::name,phBuffer:dataset).                           */
/*                            end.                                                                                  */
                        end. 
                                            
/*                        if dictdb._Partition-Policy._Partition-Policy-attributes[1] <> phBuffer::IsDataEnabled then*/
/*                            dictdb._Partition-Policy._Partition-Policy-attributes[1] = phBuffer::IsDataEnabled.    */
/*                                                                                                                   */
                        /* source ? and blank ui means nothing changed */
                        if  dictdb._Partition-Policy._description <> phBuffer::Description 
                        and (dictdb._Partition-Policy._description <> ? or phBuffer::Description > "") then
                            dictdb._Partition-Policy._description = phBuffer::Description. 
                        
                        if phbuffer::DefaultDataAreaName > "" then
                        do on error undo, throw:
                            find b_dataarea where b_dataarea._area-name = phbuffer::DefaultDataAreaName
                                no-lock.
                             catch e as Progress.Lang.Error :
                                 cmsg = "DefaultDataArea " + quoter(phbuffer::DefaultDataAreaName) + " does not exist".    
                                 undo, throw new DataAccessError(cMsg).
                             end.        
                        end.
                        if phbuffer::DefaultIndexAreaName > "" then
                        do on error undo, throw:
                            find b_indexarea where b_indexarea._area-name = phbuffer::DefaultIndexAreaName
                                no-lock. 
                             catch e as Progress.Lang.Error :
                                 cmsg = "DefaultIndexArea " + quoter(phbuffer::DefaultIndexAreaName) + " does not exist".    
                                 undo, throw new DataAccessError(cMsg).
                             end.        
                        end.
                                
                        if phbuffer::DefaultLobAreaName > "" then
                        do on error undo, throw:
                            find b_lobarea where b_lobarea._area-name = phbuffer::DefaultLobAreaName
                                no-lock. 
                             catch e as Progress.Lang.Error :
                                 cmsg = "DefaultLobArea " + quoter(phbuffer::DefaultLobAreaName) + " does not exist".    
                                 undo, throw new DataAccessError(cMsg,e).
                             end.        
                        end.
                          
                        if avail b_dataarea and b_dataarea._area-number <> dictdb._Partition-Policy._DataArea-default then                  
                            dictdb._Partition-Policy._DataArea-default = b_dataarea._area-number.
                            
                        if avail b_indexarea and b_indexarea._area-number <> dictdb._Partition-Policy._IndexArea-default then     
                            dictdb._Partition-Policy._IndexArea-default = b_indexarea._area-number. 
                            
                        if avail b_lobarea and b_lobarea._area-number <> dictdb._Partition-Policy._LobArea-default then
                            dictdb._Partition-Policy._LobArea-default = b_lobarea._area-number.
                            
                        if dictdb._Partition-Policy._Allocation-default <> phBuffer::DefaultAllocation then
                             dictdb._Partition-Policy._Allocation-default = phBuffer::DefaultAllocation.     
                        
                      
                        
                        /* ensure partitions are created and partition changes are seen (IsAllocated)*/
                        validate dictdb._Partition-Policy.
                        
                        hdataset = phBuffer:dataset.
                        AfterRow(dataset-handle hdataset by-reference).    
                               
                        phBuffer:error = false.
                        phBuffer:rejected = false.
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
                   if length(phbuffer::name) > 32 then
                      undo, throw new DataAccessError("Policy name is longer than 32 characters",e).
                   else     
                      undo, throw new DataAccessError("Policy name cannot be blank",e).
                end.
                if e:GetMessageNum(1) = 274 then
                do:
                   if index(phbuffer::name," ") > 0 then
                       undo, throw new DataAccessError("Spaces are not allowed in the partition policy name." ,e).
                end.
                 
                undo, throw new DataAccessError(
                new DataMapper("PartitionPolicy,_Partition-Policy,PartitionPolicyDetail,_Partition-Policy-Detail,Table,_File,Area,b_dataarea,Area,b_indexarea,Area,b_lobarea",
                FieldMap + ",DefaultDataArea,_DataArea-Default,DefaultIndexArea,_IndexArea-Default,DefaultLobArea,_LobArea-Default"),
                e). 
               
            end catch.
          
        
        end. /* transaction */
         
        return true.     
        finally:
           delete object hQuery no-error. 
           mSave = false.     		
        end finally.
    end method.      
   
    /* set allocated in partitions that were changed . The Tenantcontext 
       will do a new request, but it does this before the changes are merged so
       partitions with pending updates will not be refreshed due to the
       protection in dataRefreshed */ 
    method public void RefreshPartitionState(pcTenant as char,hds as handle):
        define variable hQuery as handle no-undo.
        define variable hBuffer as handle no-undo.
        hBuffer = hds:get-buffer-handle ("ttPartition").
        if valid-handle(hBuffer) then
        do:
            create query hquery.
            hquery:add-buffer(hBuffer).
            hQuery:query-prepare("for each ttPartition where ttPartition.Tenantname = " + quoter(pcTenant)
                                 + " and ttPartition.AllocationState = 'Delayed'").
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
    
    method public override  void AfterRow(dataset-handle hds):
        define variable hbuffer       as handle no-undo.
        define variable cEncodeName   as character no-undo.
        
        hBuffer =  hds:get-buffer-handle("ttPartitionPolicy").
 
        assign
            cEncodeName = WebUtil:UrlEncode(hBuffer::Name)  
            hBuffer::Url  = PolicyURL + cEncodeName
            hBuffer::TableUrl  = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(hBuffer::TableName) 
        
            hBuffer::DefaultDataAreaUrl  = AreaUrl + WebUtil:UrlEncode(hBuffer::DefaultDataAreaName)                   
            hBuffer::DefaultIndexAreaUrl = AreaUrl + WebUtil:UrlEncode(hBuffer::DefaultIndexAreaName)
            hBuffer::DefaultLobAreaUrl   = AreaUrl + WebUtil:UrlEncode(hBuffer::DefaultLobAreaName)
            hbuffer::DefaultAllocation   = caps(substr(hbuffer::DefaultAllocation,1,1)) 
                    + lc(substr(hbuffer::DefaultAllocation,2))
            hBuffer::PartitionPolicyDetailsURL = PolicyURL + cEncodeName + "/partitionpolicydetails"
            hBuffer::type = if hBuffer::HasRange then if hBuffer::NumFields > 1 then "List-range" else "Range" else "List" 
            .
/*            hBuffer::AreasUrl      = AreasUrl.*/
    end method.  
    
    /* convert type char value in query to the integer value in the db */
    method public override character ColumnExpression(pcColumn as char,pcOperator as char,pcValue as char):
       

        return ?.   
    end. 
    
    /**  type integer has same order as char value  
    /* convert type char value in query to the integer value in the db */
    method public override character ColumnSortSource(pcColumn as char):
        if pccolumn = "_tenant._Tenant-type" then
        do:
        end. 
        return ?.   
    end. 
    **/
        
    /* override to rename Type, which is not mapped 
       and default areas if not mapped  */
    method public override character ColumnSource (pcColumn as char):
        define variable cNew as character no-undo.
  
            cNew = super:ColumnSource(pccolumn).
            if cNew <> pccolumn then
                 return cNew.       
        /* data types does not match - for access permissions 
           Attach maps with MapNoArea to avoid finding the area fields */
        if pccolumn = "ttPartitionPolicy.DefaultDataAreaName" then
        do:
            return "_Partition-Policy._DataArea-default".      
        end.
        if pccolumn = "ttPartitionPolicy.DefaultIndexAreaName" then
        do:
            return "_Partition-Policy._IndexArea-default".      
        end.
        else if pccolumn = "ttPartitionPolicy.DefaultLobAreaName" then
        do:
            return "_Partition-Policy._LobArea-default".      
        end.
     
        return pccolumn.
    end method.     
    
    method public override logical Attach(bufferHandle as handle).
        FieldMapping = FieldMapNoArea.
        return super:Attach(bufferHandle).
    end method.
    
    method private char IndexFields (pfilerecid as recid,output pnum as int):
        return IndexFields(pfileRecid,"",output pnum).
    end method.    
    
    method private char IndexFields (pfilerecid as recid,cidx as char,output pnum as int):
        define buffer bfield for dictdb._field. 
        define variable clist as character no-undo.
        
        for each dictdb._index where dictdb._index._file-recid = pfilerecid 
            and dictdb._index._index-attributes[1] = true 
            and (cidx = "" or dictdb._index._index-name = cidx) 
            no-lock: 
            cList = cList + (if clist = "" then " " else " and ") 
/*            + dictdb._index._index-name + ":"*/
            .
            pnum = pnum + 1.
            for each dictdb._index-field of dictdb._index no-lock:
                find  bfield of dictdb._index-field no-lock.
                cList = cList + 
                       (if dictdb._index-field._index-seq = 1 then "" 
                       /* replace last comma with and if we only show one index */  
                        else if dictdb._index-field._index-seq = dictdb._index._num-comp and cidx > "" then " and "
                        else ", ") 
                      + bfield._field-name.
                
            end.
        end.
        return clist.
    end method.    
    
end class.