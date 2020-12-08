/*************************************************************/
/* Copyright (c) 2011,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : hdaniels
   Created     : Fri Jun 11 19:45:12 EDT 2010
   Notes       : 
 ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.CreateContext.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IFilteredContext.
using OpenEdge.DataAdmin.Binding.Query.AbstractFilteredContext.
using OpenEdge.DataAdmin.Core.CodeWriter.
using OpenEdge.DataAdmin.Core.DataAdminIterator.
using OpenEdge.DataAdmin.Core.JSONWriter.
using OpenEdge.DataAdmin.Error.*.
using OpenEdge.DataAdmin.Lang.Collections.ICollection.
using OpenEdge.DataAdmin.Lang.Collections.IIterator.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
class OpenEdge.DataAdmin.DataAdminCollection abstract implements IDataAdminCollection,IDataAdminSerializable,ICollection: 
    
    define stream exportstream.
    define stream importstream.
          
           
    define protected property DefaultBuffer    as handle    no-undo 
        get. 
        private set. 
   
    define public property SerializeName as char no-undo 
        get():
            if valid-handle(DefaultBuffer) then 
                return DefaultBuffer:serialize-name.
            return "".       
        end.        
   
    define protected property TableHandle as handle no-undo 
        get. 
        private set.
    
    define public property HasChanges as logical no-undo
        get:
            return this-object:Context:HasChanges().
        end.
    
    define protected property DatasetHandle as handle no-undo 
        get. 
        private set.
    
    define protected property TableName        as character no-undo 
        get. 
        private set.
    
    define protected property Context  as IDataAdminContext no-undo 
        get.   
        set(cntxt as IDataAdminContext): 
            assign
                DatasetHandle = cntxt:DatasetHandle
                DefaultBuffer = DatasetHandle:get-buffer-handle(1)
                TableHandle   = DefaultBuffer:table-handle
                TableName     = DefaultBuffer:name.  
            if valid-object(cntxt:Service) and valid-handle(DefaultBuffer:before-buffer) then
               TableHandle:tracking-changes = true.     
            if valid-object(Context) and type-of(Context,IDataAdminModel) then
                 Context:AddedToContext:Unsubscribe(NewContext).
            Context = cntxt.
            
            if valid-object(Context) and type-of(Context,IDataAdminModel) then
                Context:AddedToContext:Subscribe(NewContext).
        end.   

    define public property Count as int no-undo get():
        return Context:Count.
    end.   
    
    /* TODO move to context as this can be done more efficently by checking has-records, 
       but this needs logic to handle filtered context with count.*/
    define public property IsEmpty as logical  no-undo get():
        return Count = 0. 
    end.  
    
    define public property RequestInfo as IRequestInfo no-undo get. protected set.
    
    method public logical Remove(Obj as Object).
        undo, throw new UnsupportedOperationError("Remove from " + this-object:GetClass():TypeName).
    end.  
    
    method public logical Add(Obj as Object).
        undo, throw new UnsupportedOperationError("Add to " + this-object:GetClass():TypeName).
    end.  
    
    method public void Clear().
         undo, throw new UnsupportedOperationError("Clear of collection.").
    end method. 
        
    define public property Service as IDataAdminService no-undo 
        get():
            if valid-object(Context) then
                /* can be unknown */
                return this-object:Context:Service. 
            return ?. 
        end.    
        
    /** defines the context (or scope?) for the instance.
        Used in Equals() to check entities with the same keys not 
        are equals if different context */
    define public property ContextId as char no-undo           
        get():
            if valid-object(Context) then 
            do:
               return Context:Id.
            end.
            return "".    
        end.    
    
    /** defines the source (or scope?) for the instance.
        - blank means the object has no source  (yet)   
            new and not attached (in which case equals is only true if exact same 
            object instance)  
        - returns the same as ContextId if this collection is for the entire context    
         */
    define public property SourceId as char  no-undo           
        get():
            return Context:ContentId.
        end.     
    
    define public property CodeExtension as char no-undo init "download" get. set.  
        
    constructor public DataAdminCollection (contxt as IDataAdminContext):
        super ().    
        Context = contxt.
        if type-of(contxt,IFilteredContext) then
            RequestInfo = cast(contxt,IFilteredContext):RequestInfo.    
    end constructor.
    
    /* Creates a collection with a local context  
       The collection can(should?) later be passed to a 
       service:Create<Name>s, which will use Attach() to bind to the 
       service context for the entity 
       (Attach will copy the local context into the service context) */
    constructor public DataAdminCollection ():
        super ().    
        Context = CreateLocalContext().
    end constructor.
  
    method abstract protected IDataAdminContext CreateLocalContext().
/*                                                                                    */
/*    method public IDataAdminElement FindElement(c as char):                         */
/*        undo, throw new UnsupportedOperationError("FindElement with character key").*/
/*    end method.                                                                     */
/*                                                                                    */
/*    method public IDataAdminElement FindElement(i as int).                          */
/*        undo, throw new UnsupportedOperationError("FindElement with integer key").  */
/*    end method.                                                                     */
/*                                                                                    */
/*    method public IDataAdminElement FindElement(rid as rowid).                      */
/*        undo, throw new UnsupportedOperationError("FindElement with rowid").        */
/*    end method.                                                                     */
/*                                                                                    */
    method abstract public logical Contains(obj as Object).
    
    method public logical AddAll(pcol as ICollection).
        if type-of(pcol,IDataAdminCollection) then
        do:
            return AddAll(cast(pcol,IDataAdminCollection)). 
        end.   
        return AddAll(pcol:Iterator()).
    end method.
    
    method protected logical AddAll(pcol as IDataAdminCollection).
        if pCol:CanAttach(Context) then 
        do:
            pcol:Attach(Context).
            return true.
        end.
        return AddAll(pcol:Iterator()).
    end method.    
    
    method private logical AddAll(piter as IITerator).
        define variable lok as logical no-undo. 
        define variable lanyok as logical no-undo.
        do while piter:HasNext():
            lok = this-object:Add(piter:next()). 
            if lok then lanyok = true.
        end. 
        return lanyok.  
    end method.
         
    method public IIterator Iterator():
        return new DataAdminIterator(Context).
    end method.   
    
    /** returns a filtered and/or sorted iterator  
        @param  filter query expression on properties of the entities in the collection 
                       field expressions <b>must</b> be separated by space (also =)
                     - can also specify a single column for sort 
                     - or a sort expression 'clustersize by recordsperblock' */ 
    method public IIterator Iterator(filter as char):
        define variable cQuery as character no-undo.
        define variable iter as IIterator no-undo.
        define variable i     as integer no-undo.
        define variable lfirstword as logical no-undo.
        define variable cword as character no-undo.
        define variable hQuery as handle no-undo.
        /* @todo - add TransformQuery override in CreateContext that throws unsupported 
                   possibly catch error here and rethrow with a message along the current 
                   OR fix the problem ..*/
        if type-of(Context,CreateContext) then
            undo, throw new UnsupportedOperationError("Filtered iterator over created collection.").
        filter = trim(filter).
        /*  if not already start on "by " add "by " if sort only  */
        if (filter begins "by ") = false then
        do:
            if num-entries(filter," ") = 1 then 
                filter = 'by ' + filter.
            else 
            /* check two first words for descending */
            sortsearch:
            do i = 1 to num-entries(filter," "): 
               cWord = entry(i,filter," ").
               if cWord <> " " then
               do:
                   if not lfirstword then 
                      lfirstword = true.
                   else do:
                      if cword = "descending" or cword = "by" then
                         filter = "by " + filter.
                      leave sortsearch.
                   end.
               end.               
            end.
        end.
        /**  hack   @todo move to context objects */
        if type-of(Context,AbstractFilteredContext) then
        do: 
            hQuery = Context:IteratorHandle.
            if valid-handle(hQuery) then
                cast(Context,AbstractFilteredContext):BaseQuery = hQuery:prepare-string.  
        end.
        cQuery = Context:TransformQuery(filter).
        iter = new DataAdminIterator(Context,cQuery).
        return iter. 
    end method.   
    
    
    method public logical CanAttach(cntxt as IDataAdminContext):
        if valid-object(cntxt) then
        do: 
            /* no context - assume transition ok - type checking will happen later */
            if ContextId = "" then
                return true.
                
            return cntxt:CanCopy(Context).     
        
        end.
        return false.
    end method.   
  
    
    /**
     * 
     * @param context 
     */
    method public void Attach(cntxt as IDataAdminContext).
        define variable oldcontext as IDataAdminContext no-undo.
        if not valid-object(cntxt) then
            undo, throw new UnknownValueError("Attach","context").  
        cntxt:Copy(this-object:Context).                     
            
        oldcontext = this-object:Context.  
        this-object:Context = cntxt.
         
         
        if oldcontext:IsLocal then
        do:
            delete object oldcontext.
        end.        
        
    end method.
     
     /* the context we attached to changed */
    method protected void NewContext(cntxt as IDataAdminContext):   
        Context = cntxt.
    end method. 
     
    method public void Reset().
/*        Binding:*/
    end method.
   
    method public void ExportTree(pcfile as char):
        define variable writer as IDataAdminExporter no-undo.
        writer = GetExporter(pcfile).
        writer:WriteToFile(this-object,pcfile,"ALL").
    end method.
    
    method public void ExportTree(pcfile as char,pageReq as IPageRequest):
        define variable writer as IDataAdminExporter no-undo.
        writer = GetExporter(pcfile).
        writer:WriteToFile(this-object,pcfile,"ALL",pageReq).
    end method.      
    
    method public void ExportTree(pcfile as char,pcCollectionlist as char):
        define variable writer as IDataAdminExporter no-undo.
        writer = GetExporter(pcfile).
        writer:WriteToFile(this-object,pcfile, pcCollectionlist).
    end method.
    
    method public void ExportAsProcedure(pcfile as char ):
        define variable writer as IDataAdminExporter no-undo.
        writer = GetCodeExporter().
        writer:WriteToFile(this-object,pcfile,"ALL").
    end method. 
    
    method public void ExportAsProcedure(pcfile as char,pcCollectionlist as char):
        define variable writer as IDataAdminExporter no-undo.
        writer = GetCodeExporter().
        writer:WriteToFile(this-object,pcfile,pcCollectionList).
    end method. 
    
    method public void Export():
        this-object:Export(DatasetHandle:get-buffer-handle(1):serialize-name + ".json").     
    end method.  
        
    method public void Export(pcFile as char):   
        define variable hst as handle no-undo.
        define variable cRenamed as char no-undo. 
        if GetFileExtension(pcFile) = "d" then 
        do on error undo, throw:
            output stream exportstream to value(pcFile).   
            hst = stream exportstream:handle.
            this-object:Serialize(hst).
            put stream-handle hst unformatted "." .
            finally:
                 output stream exportstream close.		
            end finally.
        end.
        else do on error undo, throw: 
            PrepareExport().    
            if valid-object(RequestInfo) then 
            do:
                if RequestInfo:name > "" and RequestInfo:name <> Serializename then 
                do:
                    cRenamed = TableHandle:default-buffer-handle:serialize-name.
                    TableHandle:default-buffer-handle:serialize-name = RequestInfo:name.
                end.    
            end.    
            Context:Export(pcFile,"").   
            finally:
               if cRenamed > "" then 
                   TableHandle:default-buffer-handle:serialize-name = cRenamed.  		
            end finally.  
        end.
    end method.    
    
    method public void ExportList( ):   
        ExportList(DatasetHandle:serialize-name + ".json").
    end method.
    
    method public final integer Deserialize(phHandle as handle). 
        return Deserialize(phHandle,0) .
    end.
    
    method public final integer Deserialize(phHandle as handle,piMaxRows as int). 
        return Deserialize(phHandle,piMaxRows,"Append") .
    end.
    
    method protected integer Deserialize(phHandle as handle,piMaxRows as int, pcmode as char). 
        return Context:Deserialize(phHandle,piMaxRows,pcmode) .
    end.
    
    method public integer Serialize(phHandle as handle). 
        return Context:Serialize(phHandle) .
/*        define variable iter as IIterator no-undo.        */
/*        define variable inst as IDataAdminElement no-undo.*/
/*        define variable i as integer no-undo.             */
/*        iter = Iterator().                                */
/*        do while iter:HasNext() on error undo, throw:     */
/*            inst = cast(iter:Next(),IDataAdminElement).   */
/*            inst:Serialize(phHandle).                     */
/*            i = i + 1.                                    */
/*        end.                                              */
/*        return i.                                         */
    end method. 
    
    method protected abstract void PrepareExportTree().
    
    method protected abstract void PrepareExportList().
    
    method protected abstract void PrepareExport().
    
    method public void ExportList(pcFile as char):  
        PrepareExportList().
        Context:Export(pcFile,"").   
    end method.   
      
    method public void ExportList(pcFile as char,pcQuery as char):
        PrepareExportList().    
        Context:Export(pcFile,"").    
    end method.   
     
    method public void WriteTree(tree as IContextTree):
        Context:AddTreeTo(tree,RequestInfo).     
    end method.
    
    /* write specified collections  */
    method public void WriteTree(tree as IContextTree,pcCollections as char):
        Context:AddTreeTo(tree,pcCollections,RequestInfo).     
    end method.
    
    method public void ImportNew(pcFile as char). 
        this-object:Import(pcfile,"Append").
    end method.
    
    method public final void ImportDelete(pcFile as char). 
        Context:ImportDelete(pcfile).
    end method.
      
    method public void Import(pcFile as char). 
        this-object:Import(pcfile,"Replace").
    end method.
    
    method private void Import(pcFile as char,pcmode as char). 
        define variable hst as handle no-undo.
        if GetFileExtension(pcFile) = "d" then 
        do on error undo, throw:
            input stream importstream from value(pcFile).   
            hst = stream importstream:handle.
            this-object:Deserialize(hst,0,pcmode).
            catch e as UnsupportedOperationError  :
            	if pcMode = "Replace" then 
            	   	undo, throw new UnsupportedOperationError("Import of .d in replace mode for " + GetClass():TypeName) .      
                else
                    undo, throw new UnsupportedOperationError("Import of .d in " + GetClass():TypeName ).      
            end catch.
            finally:
                output stream importstream close.      
            end finally.
        end.
        else 
           Context:Import(pcfile,pcmode).
    end method.
    
    method public void ImportNewTree(pcFile as char). 
        ImportTree(pcFile,"Append").
    end method. 
    method public void ImportTree(pcFile as char). 
        ImportTree(pcFile,"Replace").
    end method. 
    
    /* not ready for prime time? - see comment in interface  
    method public void ImportNewTree(pcFile as char). 
        ImportTree(pcFile,"Append").
    end method. 
    */
    
    method private void ImportTree(pcFile as char,pcMode as char). 
        define variable tree as IContextTree no-undo.
        tree = new ContextTree(). 
        WriteTree(tree).
        Context:ImportTree(pcFile,pcMode).
    end method. 
    
    method public void ExportLastSavedTree(pcFile as char). 
        Context:ExportLastSavedTree(pcFile).
    end method. 
    
    method public void ExportLastSaved(pcFile as char). 
        Context:ExportLastSaved(pcFile).
    end method. 
    
        /* optional call back from context tree. 
        called when parse is complete
         override to return json  to export instead  of dataset
         returns unknown to use standard dataset. write-json  */
    method public JSONObject GetJSONExport(tree as IContextTree):
        return Context:GetJSONExport(tree).
    end.  
    
    method protected IDataAdminExporter GetCodeExporter():
        if Context:CanGenerateCode then
            return new CodeWriter().
                    
        undo, throw new UnsupportedOperationError("Generation of code for " + Context:Name). 
    end method.
     
    method protected IDataAdminExporter GetExporter(pcFile as char):
        define variable i as integer no-undo.
        define variable fileext as character no-undo.
        fileExt = GetFileExtension(pcFile).
        case fileExt:
            when "p" or when CodeExtension  then
            do:
                return GetCodeExporter().
            end.  
            when "json" then  
                return new JSONWriter().
            otherwise 
                undo, throw new IllegalArgumentError("Export to file with extension " + quoter(fileext)). 
        end.
    end method.
    
    
    method protected char GetFileExtension(pcFile as char):
       define variable i as integer no-undo.
       i = num-entries(pcfile,".").
       if i > 1 then
           return entry(i,pcfile,".").
       else return "".    
    end method.   
    
    method protected void AssertNotNull(i as int,arg as char):
        if i = ? then 
            ThrowNull(program-name(2),arg).
    end method. 
    
    method protected void AssertNotNull(c as char,arg as char):
        if c = ? then 
            ThrowNull(program-name(2),arg).
    end method. 
    
    method protected void AssertNotNull(o as Object, arg as char):
        if not valid-object(o) then 
            ThrowNull(program-name(2),arg).
    end method. 
    
    method protected void ThrowNull(caller as char,arg as char):
        undo, throw new UnknownValueError(entry(1,caller," "),arg).
    end method. 

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	destructor public DataAdminCollection ( ):
        if type-of(Context,IFilteredContext) then
            delete object Context.
	end destructor.
    
end class.
