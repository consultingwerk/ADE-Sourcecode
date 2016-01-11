 /*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : TableDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Sep 04 02:01:56 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/


routine-level on error undo, throw.

using OpenEdge.DataAdmin.DataAccess.DataAccessError.
using OpenEdge.DataAdmin.DataAccess.DataMapper.
using OpenEdge.DataAdmin.DataSource.DataSource.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.Lang.QueryString.
using Progress.Lang.*.

class OpenEdge.DataAdmin.DataSource.TableDataSource inherits DataSource: 
    define protected variable AreaUrl as char no-undo init "/areas/".
    define protected variable mBuffer as handle no-undo.
    define protected variable mDBRecid as recid no-undo.	
    define variable mNoPolicy as logical no-undo.
    define variable mNoArea as logical no-undo.
    define variable mPolicyBuffer as handle no-undo.
      
    
    define temp-table ttfilefilter 
         field ttrecid  as recid.
         
    define private variable mMapping as char
	   init  	   
"SchemaName,_Owner,~
Name,_File-name,~
trowid,rowid(_File),~
Id,_File-number,~
Description,_desc,~
Hidden,_hidden,~
IsMultiTenant,_File-attributes[1],~
IsPartitioned,_File-attributes[3],~
KeepDefaultArea,_File-attributes[2]"
/*Description,_Desc,~  */
/*DumpName,_Dump-name,~*/
/*DisplayName,_File-label"*/
 no-undo.
/*
ValidationExpression,_Valexp,~
ValidationMessage,_Valmsg"  no-undo.
*/

     /* valmsg-SA  stringatributes*/
     /* _for - 11 fields   */
     /* _Has-C- F- U- PCnstrs  */
   /*
/* filelabelSA  stringatributes*/
     _hidden
     _frozen
     _db-lang
     _version
     _Tbl-status
     _Tbl-Type
     _crc
     _last-change
     _last-modified
     _mod-sequence
     _field-map
     field fileMisc1 ext 8 
     field fileMisc2 ext 8 
     field fileRes1 ext 8 
     field fileRes2 ext 8 
      _User-Misc
      _Rssid
         */ 
 /*  _cache */  
 /*  _file-number */    
 /*  _dft-pk */
 /* _numkey */    
 /* _numkfld */    
 /* _numkcomp */ 
 /* _Template*/
 /* _numfld */
		
/*	constructor public TableDataSource (pcurl as char):*/
/*        this-object ( ).                            */
/*        url = pcURL.                                */
/*        AreaURL = pcURL + AreaURL.                  */
/*    end constructor.                                */
    
    constructor public TableDataSource (hchanges as handle ):     
        super (hchanges,"_File","dictdb._File", mMapping).
        BaseQuery = "for each ttTablechange, each _file where _file._file-name = ttTableChange.Tablename and " + DatabaseInfo:FileExpression + " no-lock".
    end constructor.
    
    constructor protected TableDataSource ( alltables as log):     
        super ("_File","dictdb._File", mMapping).   
/*      BaseQuery = "for each _file  no-lock".*/
        BaseQuery = "for each _file" 
                   + (if alltables then "" 
                      else " where " + DatabaseInfo:FileExpression) + " no-lock".
        
    end constructor.
    
    constructor public TableDataSource (htt as handle,cquery as char):     
        super (htt,"_File","dictdb._File", mMapping).   
/*      BaseQuery = "for each _file  no-lock".*/
        BaseQuery = "for each  " + htt:name  
                    + ", each _file where " + DatabaseInfo:FileExpression  + " no-lock".
        
    end constructor.
	constructor public TableDataSource ( ):	    
		this-object (no).	
    end constructor.
    
    constructor public TableDataSource (pJoinTables as char, pJoinPhysTables as char ):     
        define variable i as integer no-undo.
        define variable cTable as char no-undo. 
        super ("_File," + pJoinTables,"dictdb._File," + pJoinPhysTables, mMapping).
        BaseQuery = "for each _file where " + DatabaseInfo:FileExpression + " no-lock".
        /* add the join tables to basequery - the client is expected to pass the 
          actual join as part of the query  */
        do i = 1 to num-entries(pJoinTables) :
           cTable = entry(1,pJoinTables).
           
           BaseQuery = BaseQuery
                     + ", each " + cTable + " no-lock".   
        end. 
    end constructor.
    
     
    method public override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        phBuffer:set-callback("After-Row-fill","AfterTableRow").
        super:Prepare(phBuffer,pcTargetQuery,pcJoin).
        mBuffer = phBuffer.
    end method.
    
        /** override to sort on the internal value that defines the true order of the partitions  */
    method protected override logical PrepareQueryString (poQueryString as QueryString ):    
        define variable isOk as logical no-undo.
        define variable cQuery as character no-undo.
        define variable lok as logical no-undo.
        define variable cBaseQuery as character no-undo. 
        define variable lRecreate as logical no-undo.
        define variable hQuery as handle no-undo.
        cBaseQuery = BaseQuery.
        BaseQuery = "for each _Partition-policy no-lock".
        cQuery = poQueryString:BuildQueryString("_Partition-policy").
        if mNoPolicy then
        do:
            /* this table is only present if the db is enabled for table partitioning*/
            if not valid-handle (mPolicyBuffer) then
                create buffer mPolicyBuffer for table "dictdb._Partition-Policy".
             
            
            for each dictdb._file no-lock:
                mPolicyBuffer:find-first("where _Partition-Policy._Object-number = " + string(dictdb._File._File-number)).
                if not mPolicyBuffer:avail then
                do: 
                    create ttfilefilter.
                    ttfilefilter.ttrecid = recid(dictdb._file).
                end.
            end. 
           
            TempSourceBuffer = temp-table ttfilefilter:default-buffer-handle. 
            Tables =   "ttfilefilter," + Tables.
            PhysicalTables = "ttfilefilter," + PhysicalTables.
            BaseQuery = "for each ttfilefilter" + ", " + TrimQuery(cBaseQuery).  
            poQueryString:AddExpression("recid(_file)  = ttfilefilter.ttrecid").
            lRecreate = true.
              
        end.     
        else if cQuery <> BaseQuery and lookup("_Partition-policy",Tables) = 0 then
        do:
            Tables =   "_Partition-policy," + Tables.
            PhysicalTables = "dictdb._Partition-policy," + PhysicalTables.
            BaseQuery = BaseQuery + ", " + TrimQuery(cBaseQuery).  
            poQueryString:AddExpression("_Partition-Policy._Object-number = _File._File-number").
            lRecreate = true.
        end.
        else
            BaseQuery = cBaseQuery.
            
        cBaseQuery = BaseQuery.
        BaseQuery = "for each _Area no-lock".
        cQuery = poQueryString:BuildQueryString("_Area").
        if cQuery <> BaseQuery and lookup("_Area",Tables) = 0 then
        do:
            if not lRecreate then 
            do: 
                Tables =   "_Area," + Tables.
                PhysicalTables = "dictdb._Area," + PhysicalTables.
                BaseQuery = BaseQuery + ", " + TrimQuery(cBaseQuery).  
            end. 
            else do:
                Tables =   Tables + ",_Area".
                PhysicalTables =  PhysicalTables + ",dictdb._Area".
                BaseQuery = cBaseQuery + ", " + TrimQuery(BaseQuery).  
            end.    
            poQueryString:AddExpression("_Area._Area-number = _File._ianum").
            lRecreate = true.
        end.
        else
            BaseQuery = cBaseQuery.
            
   
        if lRecreate then 
        do:  
            CreateQuery().    
            DataBuffer:attach-data-source(DataSourceHandle,mMapping) .
        end.
        
        cQuery = poQueryString:BuildQueryString(Tables).
/*          message cQuery  */
/*        view-as alert-box.*/
        isOk = QueryHandle:query-prepare(cQuery).  
        return isOk.
    end method.
    
    method protected override character FindTableJoinValues(pTable as char,pFind as char):
        case pTable:
            when "_Partition-Policy" then
                return FindPartitionPolicyJoin(pFind).
        end case.
        return super:FindTableJoinValues(pTable,pFind). 
    end method.
    
     /* throw standard progress error if non found 
        - NOTE Dynamic code since the table is only present when db is partition enabled*/
    method private character FindPartitionPolicyJoin(pFind as char):
        define variable hBuffer as handle no-undo.
        create buffer hBuffer for table "dictdb._Partition-Policy".
        hBuffer:find-unique(pFind).
        return "_Partition-Policy._Partition-Policy-name = " + quoter(hBuffer::_Partition-Policy-name ).
    end method.
    
    method public void AfterTableRow(dataset-handle hds):
        define variable cArea as character no-undo.
        define variable cAreaRef as character no-undo.
        define variable iTbl as integer no-undo.
        define variable iFile as integer no-undo.
        define variable istype1 as logical no-undo.
        assign 
            cArea = ""
            cAreaRef = ""
            iTbl = lookup("_File",Tables).
       
        find dictdb._file where recid(dictdb._file) = DataSourceHandle:get-source-buffer(itbl):recid no-lock.
       
        find dictdb._storage where dictdb._storage._db-recid = dictdb._file._db-recid
                             and dictdb._storage._object-type = 1                                     
                             and dictdb._storage._object-number = dictdb._file._file-number 
                             and dictdb._storage._Partitionid = 0
                             no-lock no-error.
        if mbuffer::isPartitioned then
        do:
            /* this table is only present if the db is enabled for table partitioning*/
            if not valid-handle (mPolicyBuffer) then
                create buffer mPolicyBuffer for table "dictdb._Partition-Policy".
            if valid-handle(mPolicyBuffer) then 
            do:
                iFile = dictdb._file._File-number.
                mPolicyBuffer:find-unique ("where _Partition-Policy._Object-Number = " + string(dictdb._file._File-number)) no-error.
                if mPolicyBuffer:avail  then
                do:
                    assign
                        mBuffer::PartitionPolicyUrl  = url + "/partitionpolicies/" + WebUtil:UrlEncode(mPolicyBuffer::_Partition-Policy-Name)
                        mBuffer::PartitionPolicyName = mPolicyBuffer::_Partition-Policy-Name.
                end.
            end.
        end.                         
        if avail dictdb._storage and dictdb._storage._Area-number > 0 then
        do:
            find dictdb._area where dictdb._Area._Area-number
                                  =  dictdb._storage._Area-number no-lock.   
            assign
               cArea    = dictdb._area._area-name       
               cAreaRef =  url +  AreaURL + WebUtil:UrlEncode(dictdb._Area._Area-name,"default"). 
               isType1 =  dictdb._area._Area-clustersize <> 8 
                          and         
                          dictdb._area._Area-clustersize <> 64 
                          and         
                          dictdb._area._Area-clustersize <> 512. 
        end. 
        else isType1 = false.
        assign
            mBuffer::AreaName = cArea
            mBuffer::AreaURL  = cAreaRef 
            mBuffer::HasType1Area = isType1
            mBuffer::Url  = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(mBuffer::name) 
            mBuffer::IndexURL  = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(mBuffer::name) +  "/indexes" 
            mBuffer::FieldURL  = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(mBuffer::name) +  "/fields" 
            mBuffer::PartitionsUrl = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(mBuffer::name) +  "/partitions".
    end method.
    
    method private void DeleteTable(rid as rowid):
        /* this is not used in 11.0.0. We might need this in future.
           NOT TESTED */
           
        define buffer b_IndexField for dictdb._Index-field.   
        define buffer b_FileTrig   for dictdb._File-trig.   
        define buffer b_FieldTrig  for dictdb._Field-trig.
           
        find dictdb._File where rowid(dictdb._File) = rid exclusive-lock no-wait.
        
        for each dictdb._Index of dictdb._File no-lock:
            find b_IndexField of dictdb._Index exclusive-lock no-wait.
            delete b_IndexField.
 
            delete dictdb._Index.
        end.
        
        find b_FileTrig of dictdb._File exclusive-lock no-wait.
        delete b_FileTrig.
        
        for each dictdb._Field of dictdb._File no-lock:
            find b_FieldTrig of dictdb._Field exclusive-lock no-wait.
            delete b_FieldTrig.
            
            delete dictdb._Field.
        end.
        delete dictdb._File.
    end method.   

    method public override logical Save(phbuffer as handle):
        define variable hDataset as handle no-undo. 
        define variable hBeforeBuff as handle    no-undo.
        define variable dbRecid as recid no-undo.
        define variable hquery      as handle    no-undo.
        
               /* The first call to DatabaseInfo may call the constructor which
             has a find that will give error 7254 , so don't use in where clause */
        dbRecid = DatabaseInfo:DatabaseRecid. 
        create query hquery.
        hBeforeBuff = phBuffer:before-buffer.
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare("for each ttTableCopy").    
        hquery:query-open().       
        do transaction on error undo, throw:
            do while true:
                hquery:get-next.             
                if not hBeforebuff:avail then 
                    leave.
                phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                /* avoid merge changes if not success set to false at end */ 
                phBuffer:error = true.
           
                if hBeforeBuff:row-state = row-created then 
                    undo, throw new UnsupportedOperationError("Create of Table.").
                 
                find dictdb._file where dictdb._file._db-recid = dbRecid
                                    and dictdb._file._file-name = phBuffer::Name 
                                    and dictdb._file._owner = phBuffer::SchemaName exclusive-lock no-error. 
                                    
                if locked dictdb._file then 
                     undo, throw new DataAccessError("Table " + quoter(hBeforeBuff::Name) +  " is locked").
                              
                if not avail dictdb._file then       
                    undo, throw new DataAccessError("Table " + quoter(phBuffer::TableName) + " does not exist"). 
                
                if dictdb._File._File-attributes[1] = true and phBuffer::IsMultitenant = false then
                     undo, throw new DataAccessError("Cannot set IsMultiTenant to false.").                               
                
                if dictdb._File._File-attributes[1] <> phBuffer::IsMultitenant then
                    dictdb._File._File-attributes[1] = phBuffer::IsMultitenant.
                
                if dictdb._File._File-attributes[2] <> phBuffer::KeepDefaultArea then
                do:
                    if phBuffer::KeepDefaultArea = no then
                         undo, throw new DataAccessError("Cannot set KeepDefaultArea back to false.").    
              
                    dictdb._File._File-attributes[2] = phBuffer::KeepDefaultArea.  
                                         
                end.
                if dictdb._File._File-attributes[3] <> phBuffer::IsPartitioned then
                    dictdb._File._File-attributes[3] = phBuffer::IsPartitioned.
                
                if phBuffer::Description <> hBeforeBuff::Description then
                do:
                    dictdb._File._Desc = phBuffer::Description.
                end.
       
       /*         hdataset = phBuffer:dataset.
                AfterTableRow(dataset-handle hdataset  by-reference).     */
                         
                phBuffer:error = false.
                phBuffer:rejected = false.
            end.
            catch e1 as DataAccessError:
            	undo, throw e1.	
            end catch.
            catch e2 as Progress.Lang.Error :
                undo, throw new DataAccessError(new DataMapper("TtTable,_file",mMapping ),e2).
            		
            end catch.
             
        end. /* transaction */
             
    end method.      
        
    method public override character ColumnExpression (pcColumn as char,pcoperator as char, pcvalue as char):
        if pcColumn = "_Partition-Policy._Partition-Policy-Name" then
        do:
            if pcValue = "" then
            do:
                if lookup(pcOperator,"EQ,=") > 0 then
                    mNoPolicy = true.
                /* throw error for range that includes blank */
            end.
                   
        end.    
        else if pcColumn = "ttTable.HasType1Area" then
        do:
            if pcValue = "true" or pcValue = "yes"   then
                 mNoArea = lookup(pcOperator,"EQ,=") > 0 .
            else if pcValue = "false" or pcValue = "no"  then
                 mNoArea = lookup(pcOperator,"NE,<>") > 0 .
        
        end.
        return super:ColumnExpression(pcColumn,pcoperator,pcvalue).
    end method.
       
    method public override character ColumnSource (pcColumn as char):
        if pcColumn = "ttTable.AreaNumber" then
            return "_File._ianum".
            
        if pcColumn = "ttTable.AreaName" then
            return "_Area._Area-Name".
           
        if pcColumn = "ttTable.PartitionPolicyName" then
            return "_Partition-Policy._Partition-Policy-Name".    
        return super:ColumnSource (pcColumn). 
    
    end method.      

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public TableDataSource ( ):
        delete object mPolicyBuffer no-error. 
	end destructor.
       

end class.