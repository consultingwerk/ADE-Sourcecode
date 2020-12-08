/*************************************************************/
/* Copyright (c) 2010,2019 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/

USING OpenEdge.DataAdmin.Binding.IContextTree.
USING OpenEdge.DataAdmin.Binding.IDataAdminContext.
USING OpenEdge.DataAdmin.Binding.IDataAdminModel.
USING OpenEdge.DataAdmin.Binding.IDataDefinitionOptions.
USING OpenEdge.DataAdmin.Binding.OptionContext.
USING OpenEdge.DataAdmin.Binding.PartitionQueryContext.
USING OpenEdge.DataAdmin.Binding.SchemaChanges.
USING OpenEdge.DataAdmin.Binding.SchemaContext.
USING OpenEdge.DataAdmin.Core.JSONLoader.
USING OpenEdge.DataAdmin.Core.JSONWriter.
USING OpenEdge.DataAdmin.DataAdminService.
USING OpenEdge.DataAdmin.Entity.
USING OpenEdge.DataAdmin.Error.UnknownValueError.
USING OpenEdge.DataAdmin.Error.UnsupportedOperationError.
USING OpenEdge.DataAdmin.IDataAdminElement.
USING OpenEdge.DataAdmin.IDataAdminExporter.
USING OpenEdge.DataAdmin.IDataAdminSerializable.
USING OpenEdge.DataAdmin.IPartitionCollection.
USING OpenEdge.DataAdmin.IRequestInfo.
USING OpenEdge.DataAdmin.ISchema.
USING OpenEdge.DataAdmin.ISequenceSet.
USING OpenEdge.DataAdmin.ITableSet.
USING OpenEdge.DataAdmin.Message.LoadDefinitions.
USING OpenEdge.DataAdmin.PartitionCollection.
USING OpenEdge.DataAdmin.TableSet.
USING Progress.Lang.Object.
/*------------------------------------------------------------------------
    File        : Schema
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jun 10   2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw. 
/*using OpenEdge.DataAdmin.SequenceSet from propath.*/
/*using OpenEdge.DataAdmin.PartitionMap from propath.*/
class OpenEdge.DataAdmin.Schema inherits Entity implements ISchema, IDataAdminElement, IDataAdminSerializable:  
    
    /** SchemaState is "NEW" for unloaded schema, 
                    "LOADED" for loaded schema 
                    "IMPORTED" after import of partitions 
                    "NORMAL" n a regular instance retrieved through the service:GetSchema() */ 
    define public property SchemaState as character no-undo 
        get():
            if type-of(Context,SchemaChanges) then 
            do:
               if SchemaState = "" then  
                  return "NEW".
            end.
            else if SchemaState = "" then  
               return "NORMAL". 
            return SchemaState.       
        end.     
        set.     
        
    define public property Tables as ITableSet     no-undo 
        get():
            if SchemaState = "NEW" then 
                undo, throw new UnsupportedOperationError("Tables collection is not accessible in unsaved schema changes.").
            if not valid-object(Tables) then
            do:
                Tables = cast(GetChildCollection("tables"),ITableSet).
            end.
            return Tables.     
        end.
        protected set.
    
    define public property ForceAllocation as char no-undo get. private set. 
        
    /** Partitions are accessible in a schema instance with newly loaded definition changes. 
        The collection will throw an UnsupportedOperationError if referenced in a new 
        unloaded schema or in a regular instance retrieved through the service:GetSchema(). 
        For a regular Schema the Partitions are available in the tables in the schema's Tables collections and in 
        the indexes and fields in each table's Indexes and LOBFields collections. */               
    define public property Partitions as IPartitionCollection  no-undo    
        get():
            /* There's currently no point in supporting NEW state since the core cannot 
               access partitions until the schema has been committed (different from tenant and group)
               An implementation of this will require generation of fake partitions from
               the loaded tables, fields and indexes (if mulit-tenant changes). There 
               is already a NewPartitionContext for fake partitions for new tenants 
               and groups generated from the physical schema. This could possibly be 
               extended. It could also be a local variation of this. */ 
                    
            if SchemaState = "NEW" then
                undo, throw new UnsupportedOperationError("Partitions are only accessible after the schema changes have been updated in the service.").
            /* See general property comments. The main reason fro blocking this is the 
               performance consequences. This would read all partions for PUB, which 
               will have partions for mt schema elements * tenants (with some reduction for groups). */  
            if SchemaState = "NORMAL" then
                undo, throw new UnsupportedOperationError("Partitions are only accessible in a schema instance with newly loaded definition changes. The Partitions are available in the tables in the schema's Tables collections and in the indexes and fields in each table's Indexes and LOBFields collections.").
            
            if not valid-object(Partitions) then
            do:
                Partitions = cast(GetChildCollection("partitions"),IPartitionCollection).
            end.     
            return Partitions.
        end.
        private set.
     
    define public property LoadOptions as IDataDefinitionOptions no-undo 
        get():
            define variable h as handle no-undo.
            if not valid-object(LoadOptions) then
            do:
                LoadOptions = new LoadDefinitions(). 
            end.
            return LoadOptions.     
        end.
        protected set.
    
    define public property Sequences as ISequenceSet     no-undo 
        get():
            if SchemaState = "NEW" then 
                undo, throw new UnsupportedOperationError("Sequences collection is not accessible in unsaved schema changes.").
            if not valid-object(Sequences) then
            do:
                Sequences = cast(GetChildCollection("sequences"),ISequenceSet).
            end.
            return Sequences.     
        end.
        protected set.
		
    define private property OptionContext as OptionContext no-undo 
        get():
        	if not valid-object(OptionContext) then 
        	do:
        		OptionContext = new OptionContext( ).
/*        		OptionContext:TableHandle:default-buffer-handle:buffer-create().*/
        	end.
        	return OptionContext.    
        end. 
          
        set.
    
	constructor public Schema ( cntxt as IDataAdminModel ):
		super (cntxt).
/*		message "schema constructor  context: " cntxt*/
/*        view-as alert-box.                     */
	end constructor.
	
	constructor public Schema ( cntxt as IDataAdminModel, preq as IRequestInfo  ):
        super (cntxt,preq).
/*      message "schema constructor  context: " cntxt*/
/*        view-as alert-box.                     */
    end constructor.	
    
   
    /* No local context needed - no child collections in local mode   */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
    
    method public override void Attach(cntxt as IDataAdminContext):   
        define variable schemaContext as SchemaContext no-undo.
        define variable partitionQuery as PartitionQueryContext no-undo.
        if not valid-object(cntxt) then
            undo, throw new UnknownValueError("Attach","context").  
        /* if old context was changes before load */
        if type-of(Context,SchemaChanges) and type-of(cntxt,SchemaContext) then
        do:
            if not cntxt:find(Context:name) then
            do:
                cntxt:Tablehandle:default-buffer-handle:buffer-create().
                cntxt:Tablehandle:default-buffer-handle::name = "PUB".
            end.    
            cast(cntxt,SchemaContext):CopyTable(Context).
            
            schemaContext = cast(cntxt,SchemaContext).
            partitionQuery = schemaContext:GetNewPartitionContext().
            
            SchemaState = "LOADED". 
        
            if valid-object(partitionQuery) then
                Partitions:Attach(partitionQuery).
       
            Context = schemaContext.   
          end.        
        else super:Attach(cntxt).
    end method.
    
    /** override to handle collections for this */
    method public override void ExportTree(pcfile as char):
        define variable hds as handle no-undo.
        define variable writer as IDataAdminExporter no-undo.
        if SchemaState = "NEW" then
        do: 
            hds = Context:DatasetHandle. 
            hds:write-json ("File",pcFile,yes,"UTF-8",no). 
        end.
        else do:
            writer = new JSONWriter().
            writer:WriteToFile(this-object,pcfile,"tables,sequences").
        end.  
    end method.    
     
    
    /** override to handle collections for this */
    method public override void ExportTree(pcfile as char,pcCollectionlist as char):
        define variable writer as IDataAdminExporter no-undo.
        if SchemaState = "NEW" then
              undo, throw new UnsupportedOperationError("Cannot Export selected collections for schema changes. Use ExportTree(file).").
              
        
        writer = new JSONWriter().
        writer:WriteToFile(this-object,pcfile,pcCollectionlist).
    end method.    
    
    method public override void WriteTree(tree as IContextTree):
        tree:SetJoin(SerializeName,"tables","Name,SchemaName").
        Tables:WriteTree(tree,"lobFields,indexes").  
        
        tree:SetJoin(SerializeName,"sequences","Name,SchemaName").
        Sequences:WriteTree(tree).  
          
    end method.
     
    /* write specified collections  */
    method public override void WriteTree(tree as IContextTree,pcCollections as char):
        define variable lparse as logical no-undo.
        if lookup("options",pcCollections) > 0 then
        do:
            OptionContext:AddTableTo(tree). 
        end.
        /** backward support load of options with no parent   */
        else do:
            tree:SetHandle(SerializeName,mDefaultBuffer,mDefaultBuffer:rowid).   
        end.     
        
        if lookup("partitions",pcCollections) > 0 then
        do:
            Partitions:WriteTree(tree,"").
        end.
        lparse = tree:Parse.
        
        /* tables and sequences were loaded with the entity, so set parse to apoid new load*/ 
        tree:Parse = true.
        if lookup("tables",pcCollections) > 0 then
        do:
            /* default to export lobFields and not fields */ 
            tree:SetJoin(SerializeName,"tables","Name,SchemaName").
            Tables:WriteTree(tree,"lobFields,indexes").  
        end.
        if lookup("sequences",pcCollections) > 0 then
        do:
            tree:SetJoin(SerializeName,"sequences","Name,SchemaName").
            Sequences:WriteTree(tree).  
        end.
        tree:Parse = lparse.
    end method.
    
    /* write specified collections (default all) */
/*    method public override void WriteTree(writer as IDataAdminWriter,pcCollections as char):*/
/*        if lookup("options",pcCollections) > 0 then                                         */
/*        do:                                                                                 */
/*            writer:WriteContext(OptionContext).                                             */
/*        end.                                                                                */
/*        if lookup("partitions",pcCollections) > 0 then                                      */
/*        do:                                                                                 */
/*            Partitions:WriteAllTo(writer).                                                  */
/*        end.                                                                                */
/*    end method.                                                                             */
                                                           
    method public void ImportTree(pcfile as char,pcCollections as char):
        define variable reader as JSONLoader no-undo.        
      
        if SchemaState = "IMPORTED" then
             undo, throw new UnsupportedOperationError("ImportTree(" + pccollections + ") has already imported data t this schema.").
        
        if SchemaState <> "NEW" then
             undo, throw new UnsupportedOperationError("ImportTree(" + pccollections + ") is only supported in Schema with new unloaded definitions.").
        if lookup("partitions",pcCollections) > 0 then
            SchemaState ="IMPORT".
        
        reader = new JSONLoader().
        reader:LoadFromFile(this-object,pcfile,"replace",pcCollections).  
        
        if lookup("partitions",pcCollections) > 0 then
            SchemaState = "IMPORTED".
        
        if lookup("options",pcCollections) > 0 then
        do:
            SetOptions().
        end.   
    end method.     
        
  
    
    method private void SetOptions():
        define variable hbuffer as handle no-undo.
        hBuffer =     OptionContext:TableHandle:default-buffer-handle.
        
        hBuffer:find-first().
        assign
            LoadOptions:ForceCommit = hbuffer::ForceCommit 
            LoadOptions:AddObjectsOnline = hbuffer::AddObjectsOnline
            LoadOptions:ForceIndexDeactivate = hbuffer::ForceIndexDeactivate
            LoadOptions:ForceSharedSchema = hbuffer::ForceSharedSchema
            ForceAllocation = hbuffer::ForceAllocation.
    end method.
        
   
    /*
    method public override void Import(pcFile as char). 
        
        
        DatasetHandle:get-buffer-handle(1):table-handle:tracking-changes = true.
        DatasetHandle:get-buffer-handle(1):read-json ("File",pcFile,"replace").
/*        DatasetHandle:get-buffer-handle(1):tracking-changes = false.*/    
    end method. 
    
    */
    
end class.
