 /*************************************************************/
 /* Copyright (c) 2010,2013 by progress Software Corporation  */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : SchemaChanges
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sep   2010
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IServiceContextFactory.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.Message.FetchDefinitions.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Schema.
using OpenEdge.DataAdmin.IRequestInfo.

using Progress.Lang.*.
class OpenEdge.DataAdmin.Binding.SchemaChanges inherits DataAdminContext implements IDataAdminContext:
    {daschema/schema.i}    
    {daschema/table.i}
    {daschema/index.i}
    {daschema/field.i}
    {daschema/sequence.i}
    {daschema/change.i}
    
   define private dataset dsSchema serialize-name "root"
        for ttSchema,ttTable,ttIndex,ttField,ttSequence,ttTableChange,ttIndexChange,ttFieldChange,ttSequenceChange
       
       data-relation schematable  for ttSchema,ttTable
           relation-fields(name,schemaname) nested foreign-key-hidden
    
       data-relation tableindex   for ttTable,ttIndex
           relation-fields(name,tablename) nested foreign-key-hidden           

       data-relation tableindex   for ttTable,ttField
           relation-fields(name,tablename) nested foreign-key-hidden 

       data-relation chemasequence for ttSchema,ttSequence
           relation-fields(name,schemaname) nested foreign-key-hidden
        
       data-relation tablechange  for ttTable,ttTableChange
           relation-fields(name,tablename) nested foreign-key-hidden

       data-relation indexchange for ttIndex,ttIndexChange
           relation-fields(TableName,TableName,name,Indexname) nested foreign-key-hidden           

       data-relation fieldchange for ttField,ttFieldChange
           relation-fields(TableName,TableName,name,Fieldname) nested foreign-key-hidden           
      
       data-relation sequencechange for ttSequence,ttSequenceChange
           relation-fields(name,SequenceName) nested foreign-key-hidden
       .
       
    define variable mCount as integer no-undo.
      
    define public override property TableHandle as handle no-undo 
        get():
            return temp-table ttSchema:handle.
        end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return "Name". 
        end.   
        
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bschema for ttSchema.
            if Count = ? then
            do:
                Count = 0.
                for each bschema:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
    define private property FileName as character no-undo 
        get. 
        set.
 
    constructor public SchemaChanges (pcfile as char,pScope as IServiceContextFactory):
        define variable prt as IDataAdminModel no-undo.
        super ("SchemaChanges",pScope).
       
        FileName = pcfile.
        prt =  pScope:GetLocalContext("Partition").
        prt:Lazy = false.
        AddChild(prt).
        
    end constructor.
    
    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsSchema:handle. 
    end method.
     
    method public override character GetJoinFields(parentid as char):
        return "".
    end.
    
    method public override IFetchRequest GetRequest():
         define variable msg as FetchDefinitions no-undo.
        msg = new FetchDefinitions(Name,Id,DatasetHandle).
        msg:FileName = FileName.
        return msg.
    end method.
    /*
    method public FetchDefinitions GetDefinitionRequest():
        define variable msg as FetchDefinitions no-undo.
        msg = new FetchDefinitions(Name,Id,DatasetHandle).
        msg:FileName = FileName.
        return msg.
    end method.
    */
    method public override void CopyTable(cntxt as IDataAdminModel).
        undo, throw new UnsupportedOperationError("Copy Schema").
    end method. 
     
    method public override void CreateRow(entity as IDataAdminElement):
        undo, throw new UnsupportedOperationError("Create Schema row").
    end method. 
    
    method public override logical CanFind(name as character):
        return can-find(ttSchema where ttSchema.name = name).            
    end.    
     
    method public override logical Find(name as character):
        find ttSchema where ttSchema.name = name no-error.
        return avail ttSchema.            
    end.    
    
    method public handle GetChangeDataset():
        define variable contexttree as IContextTree no-undo.
        define variable msg as IFetchRequest no-undo.
        define variable hcopy as handle no-undo.
        define variable hdataset as handle no-undo.
        contexttree = new ContextTree().
        contextTree:SetHandle("tableChanges",temp-table ttTableChange:default-buffer-handle).
        contextTree:SetHandle("indexChanges",temp-table ttIndexChange:default-buffer-handle).
        contextTree:SetHandle("fieldChanges",temp-table ttFieldChange:default-buffer-handle).
        contextTree:SetHandle("sequenceChanges",temp-table ttSequenceChange:default-buffer-handle).
   
        return contextTree:GetReadHandle().
      
    end method.      
    
    /*
    method public override IDataAdminCollection GetChildCollection(cKey as char,child as char).
        define variable newcoll as IDataAdminCollection no-undo.
        define variable cntxt as IDataAdminContext no-undo.
        define variable islazy as logical no-undo.
        if child = "partitions" then
        do:
            cntxt = GetChild(child).            
            if this-object:Find(cKey) then
            do:
                cntxt = GetChild(child).       
                islazy = cntxt:Lazy.
                cntxt:Lazy = false.
                newcoll = cntxt:GetCollection(SerializeName + "/" + cKey).  
                cntxt:Lazy = islazy.
                return newcoll.
            end.
            return ?.
        end.    
        else do:
            return super:GetChildCollection(cKey,child).
        end.    
         
    end method.
    */
    
    
    method private void CreateTableChange(pcaction as char, pcname as char):
        mCount = mcount + 1.
        create ttTableChange.
        assign
            ttTableChange.Tablename = pcname
            ttTableChange.name =  GetAction(pcAction)
            ttTableChange.seq  = mCount.
    end method.
    
    method private char GetAction(imod as char):  
        return if imod = "cp":u then "ADD/MODIFY"
                else if imod = "a":u  then "ADD"
                else if imod = "m":u  then "MODIFY"
                else if imod = "r":u  then "RENAME"
                else if imod = "d":u  then "DELETE"
                else if imod = "e":u  then ""
                else ?.
    end method.
            
    method private void CreateSequenceChange(pcaction as char, pcname as char):
        mCount = mcount + 1.
        create ttSequenceChange.
        assign
            ttSequenceChange.Sequencename = pcname
            ttSequenceChange.name =  GetAction(pcAction)
            ttSequenceChange.seq  = mCount.
    end method.     
      
    method private void CreateIndexChange(pcaction as char, pctable as char, pcname as char):
        mCount = mcount + 1.
        create ttIndexchange.
        assign
            ttIndexChange.TableName = pctable
            ttIndexChange.Indexname = pcname
            ttIndexChange.name =  GetAction(pcAction)
            ttIndexChange.seq  = mCount.
    end method.
    
    method private void CreateFieldChange(pcaction as char, pctable as char, pcname as char):
        mCount = mcount + 1.
        create ttFieldchange.
        assign
            ttfieldChange.TableName = pctable
            ttfieldChange.Fieldname = pcname
            ttfieldChange.name =  GetAction(pcAction)
                    ttfieldChange.seq  = mCount.
    end method.
    
    method public void TestData():
        if not session:batch-mode then
        do:        
            message "testing use testdata in schemachanges"
                view-as alert-box.
        end.                
        create ttSchema.
        ttSchema.name = "pub".
        CreateTableChange("a","Btable") .
        ttTablechange.IsMultiTenantchange =true.
        CreateFieldChange("a","BTable","BField").
        ttFieldchange.IsMultiTenantchange =true.
        CreateFieldChange("a","BTable","blobField").
        ttFieldchange.IsMultiTenantchange =true.
        CreateIndexChange("a","BTable","bidx").
        ttIndexchange.IsMultiTenantchange =true.
        CreateIndexChange("a","ATable","bidx").
        ttIndexchange.IsMultiTenantchange =true.
        CreateFieldChange("a","CTable","blobfld").           
        ttFieldchange.IsMultiTenantchange =true.
        CreateSequenceChange("a","ASeq") .           
    
    end.
    
    /* TEST   
    method public override IDataAdminElement GetEntity(pckey as char):
     
       TestData().
       return CreateEntity(this-object). 
    end method.
    **/
    
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        undo, throw new UnsupportedOperationError("CreateCollection in SchemaChanges").
    end method.
    
    method protected override IDataAdminElement CreateEntity(preq as IRequestInfo):
        define variable schemaobj as Schema no-undo.
        schemaobj = new Schema(this-object,preq).
        schemaobj:LoadOptions:FileName = FileName.
        return schemaobj.
    end method. 
    
end class.