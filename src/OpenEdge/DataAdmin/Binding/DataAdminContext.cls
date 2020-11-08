/*************************************************************/
/* Copyright (c) 2011-2016,2019 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
 /** ------------------------------------------------------------------------
    Purpose     : Default implementation of IDataAdminContext    
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Aug 07 16:54:55 EDT 2010
    Notes       : implements IDataAdminModel 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.ContextTree from propath.
using OpenEdge.DataAdmin.Binding.DataAdminJsonUtil from propath.
using OpenEdge.DataAdmin.Binding.DataExportTree from propath.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminModel from propath.
using OpenEdge.DataAdmin.Binding.IDataTree from propath.
using OpenEdge.DataAdmin.Binding.IRow from propath.
using OpenEdge.DataAdmin.Binding.IRowChange from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Binding.RowBuffer from propath.
using OpenEdge.DataAdmin.Binding.RowChange from propath.
using OpenEdge.DataAdmin.Binding.ServiceAdapter from propath.
using OpenEdge.DataAdmin.Core.IElement from propath.
using OpenEdge.DataAdmin.Error.DataContextError from propath.
using OpenEdge.DataAdmin.Error.DataError from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IDataAdminService from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.Lang.BeforeQuery from propath.
using OpenEdge.DataAdmin.Lang.IQueryMap from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath.
using OpenEdge.DataAdmin.Message.FetchRequest from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.IFetchResponse from propath.
using OpenEdge.DataAdmin.Message.ISaveRequest from propath.
using OpenEdge.DataAdmin.Message.ITableResponse from propath.
using OpenEdge.DataAdmin.Message.SaveRequest from propath.
using OpenEdge.DataAdmin.Message.TableResponse from propath.
using OpenEdge.DataAdmin.RequestInfo from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using Progress.Json.ObjectModel.JsonArray from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using Progress.Json.ObjectModel.ObjectModelParser from propath.
using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.Binding.ModelList from propath.
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.Util.CompareHelper from propath.
using OpenEdge.Core.Collections.StringStringMap from propath.

/*using OpenEdge.DataAdmin.Binding.IContextWriter from propath.*/
/** default implementation IDataAdminContextData implements IDataAdminModel */ 
class OpenEdge.DataAdmin.Binding.DataAdminContext abstract implements IDataAdminContext,IDataAdminModel: 
    
    define public event RowCreated signature void (). 
    
    define public event RowDeleted signature void ().
    
    define public event BeforeDelete  signature void (rid as rowid). 
    define public event ContextDeleted signature void (). 
    
    define public event ContextRefreshed signature void (tblResponse as ITableResponse). 
       
    define public event AddedToContext signature void (newContext as IDataAdminModel). 
    define public event SearchQuery signature void (id as char,input-output queryContext as IDataAdminContext). 
    define public event SearchRequest signature void (Req as IRequestInfo,pcParent as char,pcKeys as char extent,input-output queryContext as IDataAdminContext). 
    define public event KeyChanged signature void (keyChange as IRowChange). 
    
    define protected property JsonUtil as DataAdminJsonUtil no-undo 
        get():
            if not valid-object(JsonUtil) then
                JsonUtil = new DataAdminJsonUtil().
            return JsonUtil.     
        end. 
        set.
       
    /** KeepInstances decides whether to keep a reference to the entity in the tt.
        Set to true since as of current entities are not garbage collected due to the subscribtion
        to events here, so keeping them in TT does not add make any difference. 
        There are thus probably no benefits from not keeping the reference here and it does 
        improve performance if the object is retrieved more than once. */    
    define public property KeepInstances as logical no-undo 
        init true
        get. 
/*        set.*/
    
    define private variable LineFeed as character init "~r~n" no-undo.
    
    define protected property ReadOnlyFieldNames  as character init ? no-undo 
        get():
           if ReadOnlyFieldNames = ? then
           do:
               ReadOnlyFieldNames = GetUrlFieldNames().
           end.    
           return ReadOnlyFieldNames.
        end.    
        set.
  
	define public property LastSavedDataset as handle no-undo get. set.
	/* keeps track of last import in order to export it with same format in ExportLastSavedTree */ 
	define protected property LastImportNoTopArray as logical no-undo get. set.
    
    /* set to false if retrieved with parent on intstantiation */
    define public property Lazy as logical  no-undo  
        init true
        get.  
        set.
        
    define protected property IsDatasetLoaded as logical no-undo get. set.
    
    define public property DatasetHandle as handle no-undo 
        get():
            if not valid-handle(DatasetHandle) then 
            do:
                DatasetHandle  = InitDataset().
                IsDatasetLoaded = true.
            end.
            return DatasetHandle.
        end get.
        protected set(h as handle):
            DatasetHandle = h.
            IsDatasetLoaded = true.
        end set.    
        
    /* should be used to exclude child objects that have double representation in the context
       i.e. tenants skips its own users because domains will provide users */
    define protected property SkipList as character no-undo 
        get. 
        set.     
    
    
    define protected variable SaveDataset as handle no-undo.
  
    /* true on a secondary page request (not on the first request with only limit ) */
    define protected property PageRequested as logical  no-undo  
        get. 
        private set.
      
    define public property Total as int64 no-undo 
        init ?  
        get. 
        protected set.
    
    define protected property NextPosition as character  no-undo  
        get. 
        private set.
        
    define protected property PrevPosition as character  no-undo  
        get. 
        private set.
        
    define protected property Loaded as logical  no-undo get. set. 
    
    define public property ContextScope as IContextScope no-undo
        get.
        private set.
    
    define private property ChildList as ModelList no-undo
        get():
            if not valid-object(ChildList) then do:
                ChildList = new ModelList().
                if valid-object(ContextScope) then 
                    initChildren(ContextScope).
                else    
                    initChildren().
            end.    
            return ChildList.
        end.
        set.              
    
    define protected property ServiceAdapter as ServiceAdapter no-undo
        protected get.
        private set.
    
    define protected property TargetAdapter as ServiceAdapter no-undo
        protected get.
        private set.
    
    define public property TargetService as IDataAdminService no-undo
          get.
          protected set.
          
    /** currently root is default in write-json (dataset did not support this in first release - UI need to support old versions) */
    define public property ExportWithRoot       as logical init true no-undo  get. set.   
    
 
	define abstract public property TableHandle as handle no-undo 
	    get.
	
	define  public property CanEditKey as logical no-undo 
        get.
	    protected set.
	   /** can genarate code  */
	   
   define public property CanGenerateCode      as logical no-undo  get. set.   
  
     
	/* IIterable */
	define  public property Table as char no-undo 
        get():
            return TableHandle:name.
        end.
    
	define public property BaseQuery as char no-undo 
        get():
            return "for each " + TableHandle:name.
        end.      
        set(cQuery as char): /* IQueryMap has setter */
	        undo, throw new IllegalOperationError("Set of BaseQuery in " + this-object:GetClass():TypeName).
	    end.
	define public property RootId as rowid no-undo 
        get.      
        private set.
    
	 /* set to false if retrieved with parent on instantiation */
    define public property ReadOnly as logical  no-undo  
        get():
            return not valid-handle(TableHandle:before-table).
        end.  
	
	/** iteratorHandle implements IIterable allows IIterator to use existing query or tablehandle */
    define public property IteratorHandle as handle  no-undo  
	    get():
            return TableHandle.
        end.
	
	define public property EntityFieldName as char no-undo 
	    get().
	        return "Entity".  
	    end.
	     
	define abstract public property KeyFields as character  no-undo  
	    get. 	
	    
	define public property IsLocal as logical no-undo 
        get.
        private set.
      
    define public property IsLocalShared as logical no-undo 
        get.
/*        private set.*/
        
	define public property SerializeName as character  no-undo  
	    get():
	        if valid-handle(TableHandle) then
	            return TableHandle:default-buffer-handle:serialize-name.
	        return "".
	    end. 
	     
	define abstract public property Count as integer no-undo  
	    get.	    
        protected set.
        
	define public property Service as IDataAdminService no-undo  
        get.
        protected set.
   
	 /* unique identifier, exposed as contextid for comparison
        of collections and entities */ 
    define public property Id            as character no-undo  
        get():
            if Id = "" then
            do:
                /* adding oe to avoid to easy access to widget-handle 
                   as this may change  (and TableHandle is public if you need it) */ 
                Id = string("OE" + string(TableHandle)).
            end.
            return Id.    
        end method.    
        private set. 
    
     /**  
        unique content identifier, exposed as Sourceid in collections. 
        Used to isolate updates in context.  
        Is the same as the Id for the Model itself 
     */ 
     define public property ContentId       as character no-undo  
        get():
             return id.
        end.    
        
    define public property Name as character no-undo 
        get.
        private set.
        
    /* @todo improve this - see usercontext  */   
	define protected variable mParent    as char no-undo. 
    define protected variable mParentKey as char no-undo. 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    constructor public DataAdminContext (pname as char):
        super ().
        IsLocal = true.
        this-object:Name = pname.    
    end constructor.
 
    constructor public DataAdminContext (pname as char, pscope as IContextScope):
         this-object(pname,pscope,pScope:IsLocal). 
    end constructor.
    
    constructor protected DataAdminContext (pname as char, pscope as IContextScope, plLocal as logical):
       super ().
         
        if not valid-object(pscope) then
            undo, throw new UnknownValueError("DataAdminContext constructor","scope/factory").
         
        this-object:IsLocal = pscope:IsLocal.
        
        this-object:Name = pname.  
        this-object:ContextScope = pscope.
/*   true not supported yet     this-object:IsLocalShared = pScope:IsLocalShared.*/
        /* @todo improve this... ? */
        if plLocal then 
        do:
            TargetService = pscope:Service.
            TargetAdapter = pscope:ServiceAdapter.
        end.
        else 
        do:
            this-object:Service = pscope:Service.  
            this-object:ServiceAdapter = pscope:ServiceAdapter.        
        end.
        pscope:Service:ServiceDeleted:Subscribe(this-object:Destroy). 
                             
    end constructor.
    
    /* override to initialize child context for local context */ 
    method protected void initChildren():
    end method.
        
    /* override to initialize child context for scope */ 
    method protected void initChildren(pscope as IContextScope):
    end method.
        
    method protected void OnRowCreated():
        RowCreated:Publish().
    end method.    
    
    method protected void OnBeforeDelete():
        BeforeDelete:Publish(TableHandle:default-buffer-handle:rowid).
    end method.    
    
    method protected void OnRowDeleted():
        RowDeleted:Publish().
    end method.    
    
    method protected void FireContextRefreshed(pTbl as ITableResponse):
        ContextRefreshed:Publish(pTbl).
    end method.    
    
    method protected void FireContextRefreshed( ):
        ContextRefreshed:Publish(new TableResponse(TableHandle:name)).
    end method.    
    
    method protected character GetCreateError(entity as IDataAdminElement, fldvalue as char):
        return GetCreateError(fldvalue). 
    end method.
    
    method protected character GetCreateError(fldvalue as char):
        return Name + " " + quoter(fldvalue) + " was not " 
               + (if valid-object(Service) 
                  then "created in service " + quoter(Service:Name) 
                  else "added to collection")
               + ".". 
    end method.
    
    /* Client key - external key - for import 
       now this should really be a property... 
       method is used since it is rarely overridden */
    method protected character GetClientKeyFields():
        return KeyFields. 
    end method.
    
    method public abstract character GetJoinFields(parenturl as char).
    
    /* override for external join - for example json import  */  
    method protected character GetClientJoinFields(parenturl as char).
        return GetJoinFields(parenturl).
    end method.
    
    /* override if server side join is different - */  
    method protected character GetServerJoinFields(parenturl as char).
        return GetJoinFields(parenturl).
    end method.
    
    /*   */  
    method protected character GetUrlFieldNames( ).
        define variable hcols as handle extent no-undo.
        define variable i as integer no-undo.
        define variable cFlds as character no-undo.
        hcols = GetUrlColumns(false).
        do i = 1 to extent(hcols):
            if valid-handle(hcols[i]) then
               cFlds = cFlds + ","  + hcols[i]:name.
        end.
        return trim(cFlds,",").    
    end method.
   
/*    method public handle GetIteratorHandle():*/
/*        return TableHandle.                  */
/*    end method.                              */
    
    /* add entity is Idataadmincontext wrapper for attach called from collection sub classes :add 
       logical for future general add support (contains check? context check?) 
       currently collection add is not really in synch with attach that also support just context setting
       - see attach   
      */
     method public logical AddEntity(pentity as IDataAdminElement):
        if pEntity:CanAttach(this-object) then 
        do:
            pentity:Attach(this-object).
        end.
        else do:
            CreateRow(pEntity). 
        end.
        return true.   
    end method.
    
    method public abstract void CreateRow(pEntity as IDataAdminElement).
    
    /* override to handle parent data - currently calles regu  
    @todo- make abstract and force every subclass to deal with it OR make it generic  
    */
    method public void CreateRowForParent(pRow as IRow, pEntity as IDataAdminElement):
        CreateRow(pEntity).   
    end method.    
       
    /* Called from DatasetHandle getter temporary until all sub classes are using this 
       This is now overidden by almost all classes .. se comment in getRequestDataset
      */
    method protected handle InitDataset ():
        return CreateDataset().
    end method.
    
    /**  Create row with key - used by CreateRootEntity */
    method final public void CreateRootRow(pName as char):
        define variable hbuffer as handle no-undo.
        hBuffer = TableHandle:default-buffer-handle.
/*        hBuffer:buffer-release().*/
        InitRow(pname).      
        RegisterRow(hBuffer:rowid). 
        catch e as Progress.Lang.Error :
            InitNewError(e,pname).
        end catch.
    end method.
    
    method private void RegisterRow(pr as rowid):
        if not IsLocalShared then
        do:
            RootId = pr.                    
        end.
        
    end method.
    
    method private void InitNewError(e as Error,pckey as char):
        define variable hbuffer as handle no-undo.
        define variable cmsg as character no-undo.
        define variable cmsg2 as character no-undo.        
        define variable hfld  as handle no-undo.
        define variable err as AppError no-undo.
        hBuffer = TableHandle:default-buffer-handle.
        if hBuffer:avail then
           hBuffer:buffer-delete().             
         
         cmsg = replace(e:GetMessage(1),TableHandle:name,name).
         if e:GetMessageNum(1) = 132 and IsLocalShared then
         do:
             hfld = hbuffer:buffer-field(KeyFields) no-error.
             
             if hFld:data-type = "character" then 
                 pcKey = quoter(pcKey).
             entry(2,cMsg,".") = "".
             cMsg = right-trim(cMsg,".").
             cMsg = " A new " + name + " with " + KeyFields + " " + pcKey + " is already active for this service.".  
             undo, throw new IllegalArgumentError(cMsg). 
         end.
         cMsg2 = " The new " + name + " could not be initialized for the service.".  
         Err = new IllegalArgumentError(cMsg2).  
         Err:AddMessage(cmsg,?).
         undo, throw Err. 
    
    end method.
    
    /**  Create row with key - used by CreateRootRow */
    method protected void InitRow(pName as char):
        define variable hField as handle no-undo.
        define variable hBuffer as handle no-undo.
        
        if num-entries(KeyFields) > 1 then 
            undo, throw new UnsupportedOperationError("InitRow(character) with multiple KeyFields").      
        hBuffer = TableHandle:default-buffer-handle.
        hfield = hBuffer:buffer-field(KeyFields). 
        if hField:data-type <> "character" then 
            undo, throw new UnsupportedOperationError("InitRow(character) cannot be used on key field " + hField:name + ", which is of data type " + hField:data-type + ".").      
        hBuffer:buffer-create().
        hField:buffer-value = pname.
    end method.
    
    method public void CreateRootRow():
        define variable hbuffer as handle no-undo.
        hBuffer = TableHandle:default-buffer-handle.
        InitRow().      
        RegisterRow(hBuffer:rowid). 
        catch e as Progress.Lang.Error :
            InitNewError(e,"").
        end catch.
 
    end method.
    
    /**  Create row  - used by CreateRootRow  - override if needed */
    method protected void InitRow():
        undo, throw new UnsupportedOperationError("InitRow with no parameters is not supported in " + GetClass():TypeName).      
      
/*        define variable hBuffer as handle no-undo.  */
/*        hBuffer = TableHandle:default-buffer-handle.*/
/*        do transaction:                             */
/*            hBuffer:buffer-create().                */
/*        end.                                        */
    end method.
    
    /**  Create row with key - used by CreateRootEntity */
    method final public void CreateRootRow(pId as int):
        define variable hbuffer as handle no-undo.
        hBuffer = TableHandle:default-buffer-handle.
        InitRow().
        RegisterRow(hBuffer:rowid). 
        catch e as Progress.Lang.Error :
            InitNewError(e,string(pid)).
        end catch.
    end method.
    
    /**  Create row with key - used by CreateRootRow */
    method protected void InitRow(pId as int):
        define variable hField as handle no-undo.
        define variable hBuffer as handle no-undo.
        if num-entries(KeyFields) > 1 then 
            undo, throw new UnsupportedOperationError("CreateRow(integer) with multiple KeyFields").      
        hBuffer = TableHandle:default-buffer-handle.
        hfield = hBuffer:buffer-field(KeyFields). 
        if hField:data-type <> "integer" then 
            undo, throw new UnsupportedOperationError("CreateRow(integer) cannot be used on key field " + hField:name + ", which is of data type " + hField:data-type + ".").      
        hBuffer:buffer-create().
        hField:buffer-value = pId.
    end method.
       
     /**  Create row with IRequestInfo - used by CreateRootEntity */
    method public void CreateRootRow(pReq as IRequestInfo):
        define variable hbuffer as handle no-undo.
        define variable cVal as character extent no-undo.
        hBuffer = TableHandle:default-buffer-handle.
        InitRow(pReq).
        RegisterRow(hBuffer:rowid). 
        catch e as Progress.Lang.Error :
            cVal = pReq:GetKeyValues(). 
            InitNewError(e,cVal[1]).
        end catch.
    end method.

    /**  Create row with key - used by CreateRootRow */
    method protected void InitRow(pReq as IRequestInfo):
        define variable hField as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable cKeys as character extent no-undo. 
        /* @todo - check index instead - if unique allow  (adm2 dataset.p has code)*/
        if num-entries(Preq:KeyFields) > 1 then 
            undo, throw new UnsupportedOperationError("CreateRow from RequestInfo with multiple key values").      
        
        /* @todo - check index instead - if unique allow  (adm2 dataset.p has code)*/
        if KeyFields <> Preq:KeyFields then 
        do:
            undo, throw new UnsupportedOperationError("CreateRow from RequestInfo with different key fields").      
        end.       
        hBuffer = TableHandle:default-buffer-handle.
        hfield = hBuffer:buffer-field(KeyFields).
        cKeys =  pReq:GetKeyValues().
        hBuffer:buffer-create().
        hField:buffer-value = cKeys[1].
    end method.
    
    /** Delete 
    */  
    
    method public logical Delete(pNum as integer):
       
        if this-object:Find(pNum) then
        do:  
            return Remove().          
        end.
        return false.
    end method.
    
    method public logical Delete(name as character):
       
        if this-object:Find(name) then
        do:  
            return Remove().          
        end.
        return false.
    end method.
    
    /** Delete 
        @param name extent for multi-component keys
    */  
    
    method public logical Delete(name as character extent):
       
        if this-object:Find(name) then
        do:  
            return Remove().          
        end.
        return false.
    end method.
    
    /** subclasses must implement CopyTable that throws DataError if 
       any of the records exists and that works also when the 
       source (or target) has changes 
       (temp-table-copy does not handle any of these requirements) 
       @TODO - protected ?
       */  
    method protected abstract void CopyTable(cntxt as IDataAdminModel).
    
    /** @TODO Make abstract - 
          currently calls default when 1 key since many collections handle parent 
          with settable <Entity> property. This does not mean that ths is handled. 
          it's only to ensure old code works and should really throw an error to force 
          override or actually resolve the key assigment ( .    
      - override to set from FilteredContext:ParentValue */
    method protected void CopyTableForParent(pRow as IRow,cntxt as IDataAdminModel):
        if num-entries(pRow:Keyfields) = 1 then
            CopyTable(cntxt).
        else 
            undo, throw new UnsupportedOperationError("CopyTableForParent with IRow and multiple keys."). 
    end method.   
    
    /** add foreign key for parent (called from filteredContext:copy with parentvalue) 
       NOTE: the copy wil copy all records from the passed context assuming all records 
             belongs to the passed parent value (only local context should be passed) 
       See refactoring notes Dec 2013 for Copy() 
      */
    method final public void CopyForParent(pRow as IRow,cntxt as IDataAdminContext):
        define variable fromModel as IDataAdminModel no-undo.
        if cntxt = this-object then 
             undo, throw new UnsupportedOperationError("Cannot copy to itself"). 
        if type-of(cntxt,IDataAdminModel) then
        do:
            fromModel = cast(cntxt,IDataAdminModel).
            CopyTableForParent(pRow,fromModel).
            CopyChildren(fromModel).
            /** hack for Newcontext call back to GetKeywhere */
            mParent = pRow:SerializeName.
            mParentKey = pRow:KeyValue.
            fromModel:MoveQueries(this-object).
        end.
        else 
            undo, throw new UnsupportedOperationError("CopyForParent from query context."). 
   
        finally:
            mParent = "".
            mParentKey = "".
        end finally.        
    end method.
 
    /** returns true if the context can be passed to Copy() - see comments about Copy below.
        NOTE: Should not validate data, only ensure that the physical TT mmatches and that the 
        new context is in a transferable state (currently isLocal only)
        The purpose of this is to avoid the need to override IDataAdminCollecton:Add and/or AddAll to handle variations
        and call CreateRow  
        @todo - fix existing overrides... 
        
        - The assumption is that will be extended with future improvement to collections eliminating the 
        */
    method public logical CanCopy(cntxt as IDataAdminContext):
        if valid-object(cntxt) 
        /** same context cannot be copied */
        and cntxt:ContentId <> ContentId 
        and cntxt:TableHandle:name = TableHandle:name then
            return cntxt:IsLocal.
        return false.    
    end method.
            
    /** This is not intended for general copy, but used specifically to move new objects/records from local 
       context to this context (including children). This could be both a local or service context.
       A new entity with its own context can be copied/added to a new collection with its own local context.
       A new entity with a local context can also be copied directly to the service context.
       A new collection is only copied to a service context.
       (A new entity without context uses createrow to achieve this) 
      - The passed context is no longer in use after this operation  
      refactoring notes- Dec 2013 (also applies to CopyforParent) 
        AbstractFiltercontext MoveQueries (call back to newcontext now removed and only defined in model  - 
        may change name without fixing this comments) would throw unsupported error  (and had no overrides) 
        so apparently this is only called with model, and the move of unsupported up here does not change behavior
        - @todo - keep (in IDataAdmincontext?) with current signature and extend to support query context?  
          warning - need to understand the publish to query from movequeries ?? probably not needed and unproblematic      
      */
   
    method public void Copy(cntxt as IDataAdminContext):
        define variable fromModel as IDataAdminModel no-undo.
        if type-of(cntxt,IDataAdminModel) then
        do:
            fromModel = cast(cntxt,IDataAdminModel).
            CopyTable(fromModel).
            CopyChildren(fromModel).
            fromModel:MoveQueries(this-object).
        end.
        else 
            undo, throw new UnsupportedOperationError("Copy from query context."). 
    end method.    
    
    method public void MoveQueries(cntxt as IDataAdminModel).
        AddedToContext:Publish(cntxt).
    end method.
    
    method protected void CopyChildren(cntxt as IDataAdminModel):
        define variable i as int no-undo.
        define variable cname as character no-undo.
        define variable childcntxt as IDataAdminModel no-undo.
        define variable iCount as integer no-undo.
        iCount = ChildList:Count.
        do i = 1 to iCount:       
            cName = ChildList:Get(i):SerializeName.
            if lookup(cName,SkipList) = 0 then
            do:  
                childcntxt = cntxt:GetChild(cName).
            
                if valid-object(childcntxt)   then
                    ChildList:Get(i):Copy(childcntxt).
            end.
        end. 
        Loaded = false. 
    end method.    
    
    method public void ForeignKeyChanged(pparentChange as IRowChange):
        define variable hQuery as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable cQuery as character no-undo.
        define variable cChildJoinFields as character no-undo.
        define variable cJoinFields as character no-undo.
        define variable lTrack as logical no-undo init ?.
        define variable i as integer no-undo. 
        create query hQuery.
        create buffer hBuffer for table TableHandle.
       
        lTrack = TableHandle:tracking-changes.
        TableHandle:tracking-changes = false.
        hQuery:add-buffer(hBuffer).
        cJoinFields = GetJoinFields(pparentChange:SerializeName).
        cQuery  = "for each " 
                + TableHandle:name 
                + " where " 
                + GetFieldExpression(cJoinFields,pparentChange:OldKeyValues).
                
        cChildJoinFields = GetChildJoinFields(pparentChange:SerializeName).
        hQuery:query-prepare(cQuery).
        hQuery:query-open().
        hQuery:get-first().
        
        do while hBuffer:avail:
            /* @todo if keyfields in THIS changed as part of this
               Keychanged:publish -  */
            SetValues(hBuffer,cChildJoinFields,pparentChange:KeyValues).                   
            hQuery:get-next().
            
        end.    

        finally:
            if lTrack <> ? then
                TableHandle:tracking-changes = lTrack.
            delete object hQuery no-error.
            delete object hBuffer no-error.
        end finally.
    end method.
    
   /* remove for or preselect from query - duplicated in FilteredContext */
    method protected char TrimQuery(pcQuery as char):
        define variable i as integer no-undo.
        if pcQuery begins "for " then 
           return trim(substr(pcQuery,5)).  
        if pcQuery begins "preselect " then 
           return trim(substr(pcQuery,11)). 
        return pcQuery .
    end. 
    
    method public final character GetParentJoinFields(parentid as char):
        return GetFieldsFromJoin(GetJoinFields(parentid),no).
    end method.
    
    method public final character GetChildJoinFields(parentid as char):
        return GetFieldsFromJoin(GetJoinFields(parentid),yes).
    end method.
    
    method protected final character GetParentFieldsFromJoin(pcJoinfields as char):
        return GetFieldsFromJoin(pcJoinfields,no).
    end method.
    
    method protected final character GetChildFieldsFromJoin(pcJoinfields as char):
        return GetFieldsFromJoin(pcJoinfields,yes).
    end method.
    
    /* public to be used from AbstractFilteredContext - @todo - move to some utility  */
    method public final character GetFieldsFromJoin(pcJoinfields as char,plChild as log):
        define variable cFields as character no-undo.
        define variable cField as character no-undo.
        define variable iplus as integer no-undo.
        define variable i as integer no-undo.
        if plchild then iplus = 1.
        do i = 1 to num-entries(pcJoinfields) by 2:
            cField = entry(i + iplus,pcJoinFields).
            cFields = cFields + "," + cField.
        end.   
        return left-trim(cFields,",").
    end method.
    
    method public logical CanFind(i as int):
        undo, throw new UnsupportedOperationError("CanFind with integer key").
    end method. 
    
    method public logical Find(i as int):
        undo, throw new UnsupportedOperationError("Find with integer key").
    end method. 
    
    method public logical Find(preq as IRequestInfo):
        define variable lok as logical no-undo.
        define variable cWhere as character no-undo.
        if preq:KeyFields = ""  or preq:KeyFields = ? then
            undo, throw new IllegalArgumentError("RequestInfo with no key expression passed to find."). 
        cWhere = GetWhere(preq:KeyFields,preq:GetKeyValues()). 
        /* @todo  - ensure not exposing hidden internal fields (?) */
        lok = Tablehandle:default-buffer-handle:find-unique("where " + cWhere) no-error. 
        if error-status:error and error-status:get-number (1) <> 138 then
        do: 
            undo, throw CreateFindError(error-status:get-message(1),error-status:get-number (1),preq).
        end.  
        return lok.
    end method.    
    
    method public logical Find(c as char):
        define variable lok as logical no-undo.
        if num-entries(KeyFields) > 1 then 
            undo, throw new UnsupportedOperationError("Find with char key. " + this-object:GetClass():TypeName + " has multiple KeyFields").
        else do:
            lok = TableHandle:default-buffer-handle:find-unique("where " + TableHandle:name + "." + KeyFields + " = " + quoter(c)) no-error. 
            return lok.
        end.    
        return false.
    end method. 
    
    method public logical Find(c as char extent):
        define variable lok as logical no-undo.       
        lok = Tablehandle:default-buffer-handle:find-unique("where " + GetKeyWhere(c)) no-error. 
        return lok. 
    end method. 
    
    /** FindOrigin - find row from origin rowid in row extracted with getchanges  
       @param rOriginid rowid from row in change dataset   */
    method public logical FindOrigin(rOriginid as rowid).
        define variable hBefore as handle no-undo. 
        define variable lok     as logical no-undo.
        if valid-handle(TableHandle:before-table) then
        do:
           hBefore = TableHandle:before-table:default-buffer-handle.
           lok = hBefore:find-by-rowid(rOriginid) no-error.  
           if lok then
           do:
               TableHandle:default-buffer-handle:find-by-rowid(hBefore:after-rowid).
               return true.   
           end.
           return false. 
        end.
        else
            undo, throw new IllegalArgumentError("Find Origin called in non updatable context " + SerializeName).
   
    end method. 
    
    method public logical CanFind(c as char):
        undo, throw new UnsupportedOperationError("CanFind with character key").
    end method. 
    
    method protected handle CreateDataset(pcCollections as char):
        return CreateDataset(pcCollections,no).
    end method.
    
    method protected handle CreateDataset():
        return CreateDataset(no).
    end method.
    
    /* final - not in use in any default case currently so no point overriding 
      - see and use GetRequestDataset */
    method protected final handle CreateServerDataset():
        return CreateDataSet(yes). 
    end method.
    
    method protected final handle CreateServerDataset(pcCollections as char):
        return CreateDataset(pcCollections,yes).
    end method.
    
      /* Dataset used by getRequest -
         Some programs overrides this to call CreateServerDataset,
         This was recommended at some point, but since then DatasetHandle has been 
         fixed to have only a single table to support lazy load in most classes.
         This is accomplished by overriding initDataset to have the default 
         dataset with a single table.  
         initDataset is called from datasetHandle getter.   
      @todo - this is all very convoluted and could be cleaned up ... 
              but with care */
    method protected handle GetRequestDataset():
        return DatasetHandle. 
    end method.
    
    method private handle CreateDataset(pcCollections as char,plServer as log):
        define variable tree as IContextTree no-undo.
        tree = new ContextTree().  
        tree:Parse = true.  
        tree:Server = plserver.      
        AddTreeTo(tree,pcCollections). 
        return tree:GetReadHandle().
    end method.
    
    method private handle CreateDataset(plserver as log):
        define variable tree as IContextTree no-undo.
        tree = new ContextTree().  
        tree:Parse = true.       
        tree:Server = plserver.
        AddTreeTo(tree).
        return tree:GetReadHandle().
    end method.
    
    /* override to save child context not in default child list mChildContextList */
    method protected handle CreateSaveDataset():
        return CreateDataSet(). 
    end method.
    
    method final public void AddRowTo(tree as IContextTree,prid as rowid).
        SetTreeOptions(tree).
        tree:setHandle(SerializeName,TableHandle:default-buffer-handle,prid).
    end method.    
      
    /* final - keep final -
       if there is a need to override  obverride AddTableTo(tree,requestinfo)  */
    method final public void AddTableTo(tree as IContextTree):
        tree:setHandle(SerializeName,TableHandle:default-buffer-handle).
    end method.    
    
    /* hook for tree */
    method protected void SetTreeOptions(tree as IDataTree):
        if tree:Write then
        do:
            /* only do this if we're the toptable (? means nothing set yet which implies this is the toptable) */
            if tree:TopTable = TableHandle:name or tree:TopTable = ? then
               assign
                  tree:Success = true
                  tree:Total = Total
                  tree:IncludeRoot = ExportWithRoot.
        end.
        
    end method.  
      
    method final public void AddTableTo(tree as IContextTree,pReq as IRequestInfo):
        define variable cName as character no-undo.
        
         /** use named query name (getNamedQuery) if defined, 
            also make sure to keep SerializeName (and not pReq:name even if pReq =serializeName) 
            to ensure correct casing  */
        cName = if valid-object(pReq) and pReq:name <> Serializename then pReq:name else SerializeName.
        tree:setHandle(cName,TableHandle:default-buffer-handle).
        if valid-object(pReq) and pReq:QueryString > "" then
        do:
            /* for export   */
            tree:setFilter(cName,TransformQuery(pReq:QueryString)).
        end.
        SetTreeOptions(tree).
        
    end method. 
    
    /* final - override  AddTreeTo(tree,preq) if necessary */
    method public final void AddTreeTo(tree as IContextTree).
        define variable nullReq as IRequestInfo no-undo.
        AddTreeTo(tree,nullReq).
    end method.    
    
    method public void AddTreeTo(tree as IContextTree,pReq as IRequestInfo).
        AddTableTo(tree,pReq).
        AddChildrenTo(tree,pReq).
    end method. 
   
    /* final - control elsewhere 
     - child management needs cleanup , it is currently (mainly) managed by SkipList and by AddTreeTo 
           overrides, allowing it to be controlled by overrides here in this state will make it worse */
    method public final void AddChildrenTo(tree as IContextTree,pReq as IRequestInfo).
        define variable i as integer no-undo.
        define variable childReq as IRequestInfo no-undo.
        define variable iCount as integer no-undo.
        iCount = ChildList:Count.
        do i = 1 to iCount:
            if lookup(ChildList:Get(i):SerializeName,SkipList) = 0 then
            do:
                if valid-object (preq) then
                    childReq = preq:Get(ChildList:Get(i):Serializename).
                ChildList:Get(i):AddTreeTo(tree,this-object,childReq).
            end.  
        end.
    end method.    
    
    /* final - override  AddTreeTo(tree,pollections,requestinfo) if necessary */
    method final public void AddTreeTo(tree as IContextTree,pcCollections as char).
        define variable nullReq as IRequestInfo no-undo.
        AddTreeTo(tree,pcCollections,nullReq).
    end method.  
      
    method public void AddTreeTo(tree as IContextTree,pcCollections as char,pReq as IRequestInfo).
         AddTableTo(tree,pReq).
         AddChildrenTo(tree,pccollections,pReq).
    end method.  
     
    /* final - control elsewhere 
      - child management needs cleanup , it is currently (mainly) managed by SkipList and by AddTreeTo 
        overrides, allowing it to be controlled by overrides here in this state will make it worse */
    method public final void AddChildrenTo(tree as IContextTree,pcCollections as char,pReq as IRequestInfo).
        define variable i            as integer no-undo.
        define variable cChild       as character no-undo.
        define variable childReq     as IRequestInfo no-undo.
        define variable childcontext as IDataAdminContext no-undo.
        define variable lNeedAdd     as logical no-undo. 
        do i = 1 to num-entries(pcCollections):
            lNeedAdd = false.
            cChild = entry(i,pcCollections).
            childReq = ?.
            if valid-object (preq) then
            do on error undo, throw:
                childReq = preq:Get(ChildList:Get(i):Serializename).
                catch e as Progress.Lang.Error :
                    /*  suppress error from childlist:Get - thrown if out of range */   
                end catch.
            end.
            childContext = GetChildWithRequestInfo(cChild,input-output childReq). 
            if valid-object(childContext) then
            do:
                /** not sure..  
                if lNeedAdd and valid-object(childReq) then
                do:
                    pReq:Add(childReq).            
                end.
                **/      
                childContext:AddTreeTo(tree,this-object,childReq).
            end.
            else do:
                undo, throw new IllegalArgumentError("Child " + cChild + " is not defined in  " + this-object:GetClass():TypeName).
            end.    
        end.
        
    end method.   
    
    method public void AddTreeTo(tree as IContextTree,parent as IDataAdminContext,pReq as IRequestInfo).
        AddJoinTo(tree,parent,pReq).    
        AddTreeTo(tree,pReq).
    end method.  
    
    method public void AddTreeTo(tree as IContextTree,parent as IDataAdminContext,pcCollections as char,pReq as IRequestInfo).
        AddJoinTo(tree,parent,pReq).    
        AddTreeTo(tree,pcCollections,pReq).
    end method.    
    
    method protected void AddJoinTo(tree as IContextTree,parent as IDataAdminContext,pReq as IRequestInfo).
        define variable msg as IFetchRequest no-undo.
        define variable cName as character no-undo.
        define variable rid as rowid no-undo.
        define variable rowinfo as IRow no-undo.
        define variable cJoin as character no-undo.
        if tree:Server then 
            cJoin = GetServerJoinFields(Parent:SerializeName).
        else
            cJoin = GetJoinFields(Parent:SerializeName) .   
        /** use named query name (getNamedQuery) if defined (pReq:name <> Serializename), 
            also make sure to keep SerializeName (and not pReq:name even if pReq =serializeName) 
            to ensure correct casing  */
        cName = if valid-object(pReq) and pReq:name <> Serializename then pReq:name else SerializeName.
        
        tree:SetJoin(Parent:SerializeName,cName,cJoin).
        if tree:Parse = false and Lazy and valid-object(Service)  then
        do: 
            /* check if parent is single row and use a child request with key values if that is the case*/
            rid = tree:GetRowid(Parent:SerializeName).
            if rid <> ? then
            do:
                rowinfo = new RowBuffer(this-object,tree:GetHandle(Parent:SerializeName),Parent:KeyFields,rid).
                msg = GetChildRequest(rowinfo).
            end.
            else
                msg = GetRequest().
            if valid-object(pReq) then
                TransferMatchingRequests(preq,msg).
                
            FetchData(msg). 
        end.    
    end method.
  
    method protected IFetchRequest GetChildRequest(pParentRow as IRow):
        define variable msg as IFetchRequest no-undo.
        define variable cQuery as character no-undo.
        msg = GetRequest().
        cQuery = GetServerChildQuery(pParentRow).
        msg:SetTableQuery(TableHandle:name,cQuery).
        return msg.    
    end method.
  
    method public IFetchRequest GetRequest():
        define variable lkeep as logical no-undo.
        define variable h as handle no-undo.
        h = GetRequestDataset().
        lkeep = IsDatasetLoaded and DatasetHandle = h.
        return new FetchRequest(Name,Id,h,lkeep).
	end method.
	
	method public ISaveRequest GetSaveRequest():
	    define variable hchanges as handle no-undo.
	    define variable savemsg as ISaveRequest no-undo.
	    
	    delete object SaveDataset no-error.
	    SaveDataset = CreateSaveDataset().       
	    hchanges = GetChanges(SaveDataset).
	     
	    savemsg = new SaveRequest(Name,Id,hchanges).
      
        return savemsg.
    end method.
    
    method public ISaveRequest GetSaveRequest(pid as char):
        define variable hchanges as handle no-undo.
        define variable savemsg as ISaveRequest no-undo.
       
        hchanges = GetSaveChanges(pid).
        if valid-handle(hChanges) then 
            savemsg = new SaveRequest(Name,Id,hchanges).
        return savemsg.  
    end method.   
   
    method public ISaveRequest GetSaveRowRequest(pcKey as char,pReq as IRequestInfo):
        define variable hchanges as handle no-undo.
        define variable savemsg as ISaveRequest no-undo.
               
        hchanges = GetSaveRowChanges(pcKey,pReq).
        if valid-handle(hChanges) then 
           savemsg = new SaveRequest(Name,Id,hchanges).
        
        return savemsg.  
        
    end method.   
    
    method public ISaveRequest GetSaveRowRequest(pRow as IRow,pReq as IRequestInfo):
        define variable hchanges as handle no-undo.
        define variable savemsg as ISaveRequest no-undo.
        hchanges = GetSaveRowChanges(pRow,pReq,row-modified). 
        if valid-handle(hChanges) then 
            savemsg = new SaveRequest(Name,Id,hchanges).
        return savemsg.  
    end method.   
    
    method public ISaveRequest GetCreateRowRequest(pRow as IRow):
        define variable hchanges as handle no-undo.
        define variable savemsg  as ISaveRequest no-undo.
        hchanges = GetSaveRowChanges(pRow,?,row-created).
        if valid-handle(hChanges) then 
           savemsg = new SaveRequest(Name,Id,hchanges).
        return savemsg.  
    end method.   
    
    method public ISaveRequest GetCreateRowRequest():
        define variable hchanges as handle no-undo.
        define variable savemsg  as ISaveRequest no-undo.
        define variable cKey     as character no-undo.
        define variable hField    as handle no-undo.
        
        if num-entries(KeyFields) > 1 then 
        do:
            undo, throw new IllegalArgumentError("GetCreateRowRequest() with multiple keys.").
        end.    
        if TableHandle:default-buffer-handle:row-state <> row-created then
            undo, throw new IllegalArgumentError("GetCreateRowRequest with new row in context not available.").
        
        hField = TableHandle:default-buffer-handle:buffer-field(KeyFields).
        hchanges = GetSaveRowChanges(hField:buffer-value,?).
        if valid-handle(hChanges) then 
           savemsg = new SaveRequest(Name,Id,hchanges).
        return savemsg.  
    end method.   
    
    method public ISaveRequest GetDeleteRowRequest(pRow as IRow,pReq as IRequestInfo):
        define variable hchanges as handle no-undo.
        define variable savemsg as ISaveRequest no-undo.
       
        hchanges = GetDeleteRowChanges(pRow,pReq).
        if valid-handle(hChanges) then 
            savemsg = new SaveRequest(Name,Id,hchanges).
        return savemsg.  
    end method.   
   
    method protected handle GetSaveChanges(pid as char):
        define variable hchanges   as handle    no-undo.
        define variable hNavQuery  as handle    no-undo.
        define variable childcntxt as IDataAdminContext no-undo.
       
        delete object SaveDataset no-error.
       
        SaveDataset = CreateSaveDataset().       
        hchanges = GetChanges(SaveDataset).
         
        if Contentid <> pid then 
        do:
            SearchQuery:Publish(pid,input-output childcntxt).            
            childcntxt:ValidateChanges(hChanges).        
        end.    
        else 
            ValidateChanges(hChanges).        
        return hChanges.
    end method.
    
    method protected handle GetDeleteRowChanges(pRow as IRow,pReq as IRequestInfo):
        define variable hchanges   as handle    no-undo.
        define variable hTopNavQuery as handle no-undo.
        define variable hAfter as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable rBefOrig as rowid no-undo.
        define variable rAfter     as rowid no-undo.
        
        delete object SaveDataset no-error.
        SaveDataset = CreateSaveDataset().       
        hchanges = GetChanges(SaveDataset).
        hTopNavQuery = hchanges:top-nav-query(TableHandle:name).
        /* remove everything that is not deleted */
        RemoveAfterBuffers(hTopNavQuery).
        hAfter = hTopNavQuery:get-buffer-handle(1).
            /* remove deletes exept prow */
        if valid-handle(hAfter:before-buffer) then 
           RemoveDeletes(hAfter:before-buffer,prow). 
        
        return hchanges.
    end method.
    
    method protected handle GetSaveRowChanges(pRow as IRow,pReq as IRequestInfo,pstate as int):
        define variable hchanges   as handle    no-undo.
        define variable hTopNavQuery as handle no-undo.
        define variable hAfter as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable rBefOrig as rowid no-undo.
        define variable rAfter     as rowid no-undo.
        define variable lok as logical no-undo.
        if this-object:Find(pRow:KeyValues) then
        do:
            hBuffer = TableHandle:default-buffer-handle.
            
            if pstate <> hBuffer:row-state then
            do:
                if pstate = row-created then
                    undo, throw new IllegalArgumentError("GetSaveRowChanges for create called with new row in context not available.").
            end.     
            
            delete object SaveDataset no-error.
            SaveDataset = CreateSaveDataset().       
            hchanges = GetChanges(SaveDataset).
            hTopNavQuery = hchanges:top-nav-query(TableHandle:name).
             
            if hBuffer:row-state = 0 then 
            do: 
                 rAfter = FindRidAndRemoveOtherAfterBuffers(hTopNavQuery,prow).
            end.
            else do:     
                 rBefOrig = hBuffer:before-rowid.
                 rAfter = FindRidAndRemoveOtherAfterBuffers(hTopNavQuery,rBefOrig).
            end.
            hAfter = hTopNavQuery:get-buffer-handle(1).
            
            if valid-handle(hAfter:before-buffer) then
                RemoveDeletes(hAfter:before-buffer,?). 
            lok = hAfter:find-by-rowid(rAfter) no-error.
            if lok then 
            do:
                ValidateRowChanges(hAfter,pReq).   
            end.
            return hChanges.
        end.
            
    end method.
    
    method protected handle GetSaveRowChanges(pcKey as char,pReq as IRequestInfo):
        define variable hchanges   as handle    no-undo.
        define variable hTopNavQuery as handle no-undo.
        define variable hAfter as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable rBefOrig as rowid no-undo.
        define variable rAfter     as rowid no-undo.
        define variable lok as logical no-undo.
        
        if this-object:Find(pcKey) then
        do:
            hBuffer = TableHandle:default-buffer-handle.
            
            delete object SaveDataset no-error.
            SaveDataset = CreateSaveDataset().       
            hchanges = GetChanges(SaveDataset).
            hTopNavQuery = hchanges:top-nav-query(TableHandle:name).
             
            if hBuffer:row-state = 0 then 
            do:
                 rAfter = FindRidAndRemoveOtherAfterBuffers(hTopNavQuery,pcKey).
            end.
            else do:     
                 rBefOrig = hBuffer:before-rowid.
                 rAfter = FindRidAndRemoveOtherAfterBuffers(hTopNavQuery,rBefOrig).
            end.
            hAfter = hTopNavQuery:get-buffer-handle(1).
            
            if valid-handle(hAfter:before-buffer) then
               RemoveDeletes(hAfter:before-buffer,?). 
            lok = hAfter:find-by-rowid(rAfter) no-error.
            if lok then 
            do:
                ValidateRowChanges(hAfter,pReq).   
            end.
            return hChanges.
        end.
            
    end method.
    
    method protected final rowid FindRidAndRemoveOtherAfterBuffers(phTopNavQuery as handle,porigrid as rowid):
        define variable hAfter as handle no-undo.
        define variable rAfter as rowid no-undo. 
        phTopNavQuery:query-open(). 
        phTopNavQuery:get-first.        
        hAfter = phTopNavQuery:get-buffer-handle(1).
        do while hAfter:avail:
           
           if hAfter:origin-rowid = porigrid then
           do:
              rAfter = hAfter:rowid.
           end.
           
           else  
              RemoveDatasetRow(hAfter).
           
           phTopNavQuery:get-next.
        end. 
        return rAfter. 
    end method.        
    
    method protected final rowid FindRidAndRemoveOtherAfterBuffers(phTopNavQuery as handle,pKey as char):
        define variable hAfter as handle no-undo.
        define variable rAfter as rowid no-undo. 
        define variable hField as handle no-undo.
        if pKey > "" and num-entries(KeyFields) > 1 then 
        do:
            undo, throw new IllegalArgumentError("Single row update with multiple keys and child changes only.").
        end.    
      
        phTopNavQuery:query-open(). 
        phTopNavQuery:get-first.        
        
        hAfter = phTopNavQuery:get-buffer-handle(1).
        if pKey > "" then
            hField = hAfter:buffer-field (KeyFields).
        
        do while hAfter:avail:
           if not valid-handle(hField) or hField:buffer-value <> pKey then
           do:
               RemoveDatasetRow(hAfter).
           end.
           else  
               rAfter = hAfter:rowid.
           
           phTopNavQuery:get-next.
        end. 
        return rAfter. 
    end method.        
    
    method protected final rowid FindRidAndRemoveOtherAfterBuffers(phTopNavQuery as handle,pRow as IRow):
        define variable hAfter as handle no-undo.
        define variable rAfter as rowid no-undo. 
        define variable hField as handle extent no-undo.
        define variable cField as character no-undo.
        define variable i       as integer no-undo.
        define variable lRemove as logical no-undo.
        define variable cValues as character no-undo.
        phTopNavQuery:query-open(). 
        phTopNavQuery:get-first.        
        hAfter = phTopNavQuery:get-buffer-handle(1).
        if valid-object(pRow)  then
        do:
            extent(hField) = extent(pRow:KeyValues).
            do i = 1 to num-entries(pRow:KeyFields).
                cField = entry(i,pRow:KeyFields).
                hField[i] = hAfter:buffer-field (cField ).
            end.
        end.
        do while hAfter:avail:
           lRemove = false.
           if extent(hField) = ? then 
               lRemove = true.
           else 
           do: 
               do i = 1 to num-entries(pRow:KeyFields):
                   if hField[i]:buffer-value <> pRow:KeyValues[i] then
                   do:
                       lRemove = true.
                       leave.              
                   end.
               end. 
           end.
           if lRemove then  
               RemoveDatasetRow(hAfter).
           else  
               rAfter = hAfter:rowid.
           
           phTopNavQuery:get-next.
        end. 
        return rAfter. 
    end method.        
    
    method protected final void RemoveAfterBuffers(phTopNavQuery as handle):
        define variable hAfter as handle no-undo.
        define variable rAfter as rowid no-undo. 
        phTopNavQuery:query-open(). 
        phTopNavQuery:get-first.        
        hAfter = phTopNavQuery:get-buffer-handle(1).
        do while hAfter:avail:
           RemoveDatasetRow(hAfter).
           phTopNavQuery:get-next.
        end. 
    end method.        
    
    method protected final void RemoveDeletes(phBefore as handle,pExceptRow as IRow):
        define variable lok as logical no-undo.
        define variable hBuffer as handle no-undo.
        define variable hNavQuery as handle no-undo.
        define variable cField as char no-undo.
        define variable hField as handle extent no-undo.
        define variable i      as integer no-undo.
        define variable lDelete as logical no-undo. 
        
        if not valid-handle(phBefore) then 
        do:
            undo, throw new IllegalArgumentError("Cannot delete row for invalid handle.").        
        end.    
                
        create query hNavQuery.
        hNavQuery:add-buffer(phBefore).
        hNavQuery:query-prepare ("for each " + phBefore:name).
        
        hNavQuery:query-open(). 
        hNavQuery:get-first.   
        hBuffer = hNavQuery:get-buffer-handle(1).    
        
        if valid-object(pExceptRow) then
        do:
            extent(hField) = num-entries(pExceptRow:KeyFields).
            do i = 1 to num-entries(pExceptRow:KeyFields).
                cField = entry(i,pExceptRow:KeyFields).
                hField[i] = hBuffer:buffer-field (cField ).
            end.
        end.
        
        do while hBuffer:avail:
            lDelete = false.
            if hBuffer:row-state = row-deleted then
            do:
                if not valid-object(pExceptRow) then
                    lDelete = true.
                else do:
                    lDelete = false.
                    do i = 1 to extent(pExceptRow:KeyValues):
                        if hfield[i]:buffer-value <> pExceptRow:KeyValues[i] then
                        do:
                            lDelete = true.
                            leave.
                        end.       
                    end.
                end.    
                if lDelete then
                    hbuffer:reject-row-changes.
            end.
            hNavQuery:get-next.
        end.    
        
        finally:
            delete object hNavQuery no-error.        
        end finally.
    end method.
    
    method public void ValidateChanges(phDs as handle ):
        define variable hquery as handle no-undo.
        hQuery = phDs:top-nav-query(TableHandle:name).
        ValidateQueryChanges(hQuery).   
    end method.
    
    method public void ValidateQueryChanges(phQuery as handle):
        phQuery:query-open(). 
        phQuery:get-first.        
        do while phQuery:get-buffer-handle(1):avail:
            ValidateRowChanges(phQuery:get-buffer-handle(1),?).
            phQuery:get-next.        
        end.    
    end method.
    
    method public void ValidateRowChanges(hBuffer as handle,pReq as IRequestInfo):
        define variable ichild as integer no-undo.
        define variable hRel   as handle no-undo.        
        define variable childReq     as IRequestInfo no-undo.        
        define variable childContext as IDataAdminContext no-undo.
         
        if hBuffer:row-state > 0 then
            ValidateBuffer(hbuffer).
            
        do iChild = 1 to hBuffer:num-child-relations:
            hRel = hBuffer:get-child-relation (ichild).
            if valid-object(pReq) then 
                childReq = pReq:Get(hRel:child-buffer:serialize-name).
            childContext = GetChild(hRel:child-buffer:serialize-name).
            if not valid-object(childcontext) then 
                 undo, throw new IllegalArgumentError(
                          "Save of data for " 
                          + hRel:child-buffer:serialize-name 
                          +  " of " 
                          + this-object:name 
                          + " does not have a matching context."
                       ).
            
            cast(childContext,IDataAdminModel):ValidateRelationChanges(hRel,childReq).    
        
        end.    
    end method.    
    
    method private character GetParentKey(phRelation as handle):
        define variable cFields as character no-undo.
        define variable cParentFields as character no-undo.
        define variable i as integer no-undo.  
        cFields = phRelation:relation-fields.
        do i = 1 to num-entries(cfields) by 2:
            cParentfields = (if i = 1 then "" else cParentfields + ",") 
                            + entry(i,cFields). 
        end.
        return cParentfields.
    end method.
    
    
    method public void ValidateRelationChanges(hRelation as handle, pReq as IRequestInfo):
        define variable cntxt as IDataAdminContext no-undo.
        define variable cParent as character no-undo.
        define variable cValues as character extent no-undo.
        if valid-object(pReq) then
        do:
            cParent = hRelation:parent-buffer:serialize-name.
            cValues = GetValues(hRelation:parent-buffer,GetParentKey(hRelation)).
            SearchRequest:publish(pReq,cParent, cValues, input-output cntxt).
            /* no child no updates */
            if valid-object(cntxt) then         
               cntxt:ValidateChanges(hRelation).
        end.
        else 
            ValidateQueryChanges(hRelation:query).           
    end method.    
    
    /*  
    method private void LoopRelation(phRel as handle):
        define variable hParent     as handle no-undo. 
        define variable hBuffer     as handle no-undo.
        define variable hBefore     as handle no-undo.
        define variable cRelFields  as character no-undo.
        define variable cValues     as character extent no-undo.
        define variable cField      as character no-undo.
        define variable cFields     as character no-undo.
        define variable hField      as handle no-undo.
        define variable i           as integer no-undo.
        define variable hBefQuery   as handle no-undo.
        define variable beforeQuery as BeforeQuery no-undo.
        define variable cBefQuery   as character no-undo. 
        
        hParent    = phRel:parent-buffer.
        hBuffer    = phRel:child-buffer.
        cRelFields = phRel:relation-fields. 
        extent(cValues) = int(num-entries(cRelFields) / 2). 
        do i = 1 to extent(cValues):
            cField = entry((i * 2) - 1,cRelFields).
            cFields = cFields + (if i = 1 then "" else ",") 
                      + hParent:name + "." + cField.
            hField = hParent:buffer-field(cfield).
            cValues[i] = hField:buffer-value.
        end.     
        
        hBefore = hbuffer:before-buffer. 
        hBefQuery = CreateUpdateQuery(hBefore).
        beforeQuery = new BeforeQuery(phRel:query:prepare-string,cfields,cValues). 
        cBefQuery = beforeQuery:GetQueryString().
        hBefQuery:query-prepare (cBefQuery).        
        
/*        LoopBeforeQuery(hBefQuery).*/
      
        
        LoopQuery(phRel:Query). 
        
    end method.
     */
    
    
    method private character GetRowState(phbuffer as handle):
        return if phbuffer:row-state = row-created then "Created"
               else if phbuffer:row-state = row-deleted then "Deleted" 
               else if phbuffer:row-state = row-modified then "Modified"
               else "Unchanged".
    end.    
   /*     
    method protected handle CreateUpdateQuery(phBuffer as handle):
        define variable hQuery as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable cQuery as char no-undo.
        define variable hBuffers as handle extent no-undo.
        define variable i as integer no-undo.
        create Query hQuery.
        hBuffers = GetQueryHandles(phBuffer:serialize-name).
        do i = 1 to extent(hBuffers):
            if phbuffer:table-handle:origin-handle = hBuffers[i]:table-handle then
            do: 
                hBuffer = phBuffer.
/*                if i > 1 then /* there should not be any, but there is currently nothing that prevents this */ */
/*                   undo, throw new UnsupportedOperationError("Save of query where update table is not first.").*/
/*                create buffer hBuffer for table phbuffer.                                                      */
            end.
            else    
                create buffer hBuffer for table hbuffers[i].
            
            hQuery:add-buffer(phbuffer).
        end.    
        return hQuery.         
        
    end method.
    */
    
    method protected handle GetChanges(phdataset as handle):
        define variable hChangeDataset as handle  no-undo.
        define variable i              as integer no-undo.
        define variable hBuffer        as handle  no-undo.
        
        create dataset hChangeDataset.
        
        hChangeDataset:create-like(phdataset).
        hchangeDataSet:serialize-name = "root".
         
        do i = 1 to hChangeDataset:num-buffers:
            hChangeDataset:get-buffer-handle(i):serialize-name = phDataset:get-buffer-handle(i):serialize-name. 
        end.    
        hChangeDataset:get-changes(phdataset,true). 
        
        return hChangeDataset.
    end method.   
    
    method public logical HasChanges().
        if valid-handle(TableHandle:before-table) then 
           return TableHandle:before-table:has-records.
        else
           return false.
    end method.
     /*
	method public handle GetChanges():
        define variable hChangeDataset as handle no-undo.
        create dataset hChangeDataset.
        
        hChangeDataset:create-like(DatasetHandle).
        hChangeDataset:get-changes(DatasetHandle). 
        return hChangeDataset.
    end method.   
    */
    /* @TODO merge data in child context */
    method public void MergeChanges(pResponse as ISaveRequest).   
        define variable hLast as handle no-undo.  
        if not valid-handle(SaveDataset) then
            undo, throw new UnsupportedOperationError("Attempting to merge changes without a pending save request").
        if not valid-object(pResponse) then
            undo, throw new UnknownValueError("MergeChange","response").
        
        hLast = LastSavedDataset.       
        MergeChanges(SaveDataset,pResponse:DataHandle).
        delete object SaveDataset no-error.
        delete object hLast no-error.
    end method.
     
    /* @TODO merge data in child context properly - not just set LastSaved */
    method protected void MergeChanges(phOlddataSet as handle, phChangedDataset as handle):
        define variable hTable as handle no-undo.
        define variable i as integer no-undo.
        define variable child as IDataAdminContext no-undo.
        
      
        LastSavedDataset = phChangedDataset.
        do i = 1 to phOlddataSet:num-buffers:
            hTable = phOlddataSet:get-buffer-handle(i):table-handle.
            child = GetChild(phOlddataSet:get-buffer-handle(i):serialize-name).
            if valid-object(child) then
                child:LastSavedDataset = LastSavedDataset.
            hTable:tracking-changes = false. 
        end.    
        phChangedDataset:merge-changes(phOlddataSet,true).
        do i = 1 to phOlddataSet:num-buffers:
            hTable = phOlddataSet:get-buffer-handle(i):table-handle.
            if valid-handle(hTable:before-table) then
                hTable:tracking-changes = true.     
        end. 
       
    end method.    
 
    /* Note returns an array for each table - with unknown if tracking was not changed */
    method private handle extent TrackDataset(phdataset as handle,pltrack as log):
        define variable hExt as handle no-undo extent.
        define variable i as integer no-undo.
        define variable htable as handle no-undo.
        extent(hExt) = phdataset:num-buffers.
        do i = 1 to phdataset:num-buffers:
            hTable = phdataset:get-buffer-handle(i):table-handle.
            if valid-handle(hTable:default-buffer-handle:before-buffer) then
            do:   
               hExt[i] = htable.
               hTable:tracking-changes = pltrack.     
            end.
        end.
        return hExt.    
    end method.    
    
    method private void TrackTables(phtables as handle extent,plTrack as log):
       
        define variable i as integer no-undo.
        do i = 1 to extent(phtables):
           if valid-handle(phtables[i]) then
                phtables[i]:tracking-changes = plTrack.     
        end.
     
    end method.    
    
    /* @Deprecated  */
    method public void MergeChanges(phChangeDataset as handle):
        define variable lTrack as logical extent no-undo.
        define variable hTable as handle no-undo.
        define variable i as integer no-undo.
        LastSavedDataset = phChangeDataset.
        extent(ltrack) = DatasetHandle:num-buffers.
        do i = 1 to DatasetHandle:num-buffers:
            hTable = DatasetHandle:get-buffer-handle(i):table-handle.
            lTrack[i] = hTable:tracking-changes.
            hTable:tracking-changes = false. 
        end.    
        phChangeDataset:merge-changes(DatasetHandle).
        do i = 1 to DatasetHandle:num-buffers:
            hTable = DatasetHandle:get-buffer-handle(i):table-handle.
            hTable:tracking-changes = lTrack[i].     
        end. 
           
    end method.    
    
    /** keep client changes  - remove corresponding records in received new table */             
    method protected void RemoveBeforeChanges(hNewBuffer as handle):
        define variable hq as handle no-undo.
        define variable hBefore as handle no-undo.
        define variable cWhere as character no-undo.
        define variable lok as logical no-undo. 
        
        hBefore = TableHandle:before-table:default-buffer-handle.
        create query hq.
        hq:add-buffer(hBefore).   
        hq:query-prepare("for each "  + hBefore:name).
        hq:query-open ().
        hq:get-first.
        do while hBefore:avail.
            cWhere = GetKeyWhere(GetKeyValues(hBefore)).
            lok = hNewBuffer:find-unique("where " + cWhere) no-error.           
            if lok then
            do:
                hNewBuffer:buffer-delete().
            end.    
            hq:get-next.
        end.
        
    end method.
    
    method protected void ReceiveBuffer(phNewBuffer as handle):
        /* keep client changes  - remove corresponding records in received new table */
        if HasChanges() then 
        do:
            RemoveBeforeChanges(phNewBuffer).
        end.    
        Tablehandle:copy-temp-table(phNewBuffer,yes,yes).
       
    end method.
    
    method protected void AfterTableRefreshed():
    end method.
    
    method public  void DataRefreshed(pResponse as IFetchResponse):
        define variable i as integer no-undo.
        define variable TblResponse as ITableResponse no-undo.
        define variable hNewBuffer  as handle no-undo.
        define variable iCount as integer no-undo.
        TblResponse = pResponse:GetTableResponse(TableHandle:name).
/*KEEP */
/*        message                                                 */
/*          "response:entity"                                     */
/*         pResponse:entityname skip                              */
/*        "datarefreshed in " this-object skip                    */
/*        "TableHandlename " TableHandle:Name skip                */
/*                                                                */
/*         "response" pResponse skip(1)                           */
/*          "valid table response " valid-object(TblResponse) skip*/
/*                                                                */
/*        view-as alert-box.                                      */
        if valid-object(TblResponse) then
        do:
            hNewBuffer = pResponse:DataHandle:get-buffer-handle (TableHandle:name).              
            if hNewBuffer:table-handle <> Tablehandle then
            do:
                /* keep client changes  - remove corresponding records in received new table */
                if HasChanges() then 
                do:
                    RemoveBeforeChanges(hNewBuffer).
                end.    
                Tablehandle:copy-temp-table(hNewBuffer,yes,yes).
            end.
            
/*            Lazy = TblResponse:RequestType <> "ALL".*/
            this-object:Total = TblResponse:Total.
            AfterTableRefreshed().
            
            /* pass message on to children */
            iCount = ChildList:Count. 
            do i = 1 to iCount: 
/*                message ChildList:Get(i):name*/
/*                view-as alert-box.           */
                ChildList:Get(i):DataRefreshed(pResponse).
            end.
            
            /* refresh queries */
            ContextRefreshed:Publish(TblResponse).
            
            if valid-handle(TableHandle:before-table) then
                TableHandle:tracking-changes = true.                    
                    
        end.            
    end method.   
    
    method protected character extent GetCurrentKeyValues():
        define variable hBuffer as handle no-undo.
        hBuffer = TableHandle:default-buffer-handle.
        return GetKeyValues(hBuffer). 
    end method. 
    
    method public character extent GetKeyValues(pBuffer as handle):
        return GetValues(pBuffer,KeyFields).
    end method. 
    
    method private void SetValues(pBuffer as handle,pcFields as char,pcValues as char extent):
        define variable cKey as character no-undo.
        define variable hFld as handle no-undo. 
        define variable i as integer no-undo.
        do i = 1 to num-entries(pcFields):
            /** @todo = callsetproperty for each value if  */
            hFld = pBuffer:buffer-field (entry(i,pcFields)).
            hfld:buffer-value = pcValues[i].
        end.     
        catch e as Progress.Lang.Error :
            undo, throw new IllegalArgumentError("Fields " + pcfields +  " does not match buffer: " + e:GetMessage(1)).  
        end catch. 
    end method. 
    
    
    method private character extent GetValues(pBuffer as handle,pcFields as char):
        define variable cKey as character no-undo.
        define variable hFld as handle no-undo. 
        define variable i as integer no-undo.
        define variable cValues as char extent no-undo.
         
        extent(cValues) = num-entries(pcFields).
        do i = 1 to num-entries(pcFields):
            hFld = pBuffer:buffer-field (entry(i,pcFields)).
            cValues[i] = string(hfld:buffer-value).
        end.     
        return cValues.
        catch e as Progress.Lang.Error :
            undo, throw new IllegalArgumentError("Fields " + pcfields +  " does not match buffer: " + e:GetMessage(1)).  
        end catch. 
    end method. 
    
    method public char TransformQuery(pKeyWhere as char): 
        return TransformQuery(TableHandle:name,pKeyWhere,this-object).   
    end method.
    
    method public char TransformQuery(pcTables as char, pWhere as char,mapcontxt as IQueryMAp):    
        define variable  QueryString as QueryString no-undo.       
        define variable cq as character no-undo.
        QueryString = new QueryString(pWhere,mapcontxt). 
        /* CcolumnExpression adds the table qualifier */
     
        cq = QueryString:BuildQueryString(pcTables).
        
        return cq.
        catch e as Progress.Lang.Error :
            HandleParseError(e,pWhere). 
        end catch.
        
    end method. 
    
    method private void HandleParseError(e as Error, filter as char):
         define variable cmsg as character no-undo.
         if type-of(e,IllegalArgumentError) then
            undo, throw e.
        
         cMsg = "Parsing of filter " + quoter(filter)  + " causes error "
              + "~n"
              +  e:GetMessage(1).
         undo, throw new IllegalArgumentError(cMsg,e).
    end method.    
    
    method public character GetKeyWhere(pcValues as char extent):
        define variable cJoin  as character no-undo.
        define variable cField as character no-undo.
        define variable i as int no-undo.
        define variable iKey as int no-undo.
        if extent(pcValues) <> num-entries(KeyFields) then 
            undo, throw new IllegalArgumentError("The number of extents passed as key does not match the number of entries in the KeyFields property."). 
        
        if name = "User" and mParent = "domains" then
        do:
           if Keyfields = "id" then
           
           do:
         
               if index(pcvalues[1],"@") = 0 then
                  pcvalues[1] = pcValues[1] + "@" + mParentKey.
                
           end.    
        end.
        else if mParent > "" then
        do:
            cJoin = GetJoinFields(mParent).
            /* add parent values to key values  */
            do i = 2 to num-entries(cJoin) by 2:
                cField = entry(i,cJoin).
                iKey = lookup(cField,KeyFields). 
                 /* if the passed values is part one of the keyfields then use the value from the parameter */
                if iKey > 0 then 
                do:
                    pcValues[iKey] = mParentKey.
                end.
            end.   
        end.
        return GetWhere(KeyFields,pcValues).       
         
    end method. 
    
    /* Use for find expressions. 
       Final - Override ColumnExpression hook called from here (which is ignored
        if it returns the default ?)  
     */ 
    method public final character GetWhere(pcKeyFields as char, pcValues as char extent):
        define variable cKeyFields  as character  no-undo.
        define variable iField      as integer    no-undo.
        define variable cField      as character  no-undo.
        define variable cKeyWhere   as character  no-undo.
        define variable cExpression as character  no-undo.
        
        if extent(pcValues) <> num-entries(pcKeyFields) then 
            undo, throw new IllegalArgumentError("The number of entries in the passed key does not match the number of extents passed as values"). 
               
        do iField = 1 to extent(pcValues):
           assign
              cField      = entry(iField,pcKeyFields)
              cField      = TableHandle:name  + "." + cField
              cExpression = ColumnExpression(cField,"=",pcValues[ifield]).
           if cExpression = ? then
               cExpression = cField
                           + " = " 
                           + quoter(pcValues[ifield]).
                               
           cKeyWhere  = cKeyWhere 
                      + (if iField > 1 then ' and ' else '')
                      + cExpression. 
        end.
  
        return cKeyWhere. 

    end method. 
    
    method public void TransferMatchingRequests(pReq as IRequestInfo,pmsg as IFetchRequest):
        if pmsg:HasTable(TableHandle:name) then
        do:
            if pReq:QueryString > "" then 
                pmsg:SetTableQuery(TableHandle:name,TransformQuery(pReq:QueryString)).
            
            if pReq:PageSize > 0 then
            do:
                if type-of(pReq,IPageRequest) then
                    pmsg:SetTablePageRequest(TableHandle:name,pReq:PageSize,cast(pReq,IPageRequest):Start).    
                else if pReq:PageSize > 0 then
                    pmsg:SetTablePageRequest(TableHandle:name,pReq:PageSize).                   
            end. 
            TransferMatchingRequests(pReq:GetChildren(),pmsg).
        end.               
    end method.    
    
    method public void TransferMatchingRequests(pReqs as IRequestInfo extent,pmsg as IFetchRequest):
        define variable i as integer no-undo.
        define variable childreq as IRequestInfo no-undo.  
        define variable cntxt as IDataAdminContext no-undo.
        do i = 1 to extent(pReqs):
            childreq = pReqs[i].
            if childreq:name  = "" then 
                undo, throw new IllegalArgumentError("Request with no name used in request for " + Name). 
            cntxt = GetChildWithRequestInfo(childreq:name,input-output childreq).
            if not valid-object(cntxt) then 
                undo, throw new IllegalArgumentError("Invalid collection reference " + childreq:name + " used in request for " + Name). 
            
            cntxt:TransferMatchingRequests(pReqs[i],pmsg).              
        end.    
    end method.
    
    /** subclasses must implement factory method for classes */ 
    method protected IDataAdminCollection CreateCollection(cntxt as IDataAdminContext).
        undo, throw new UnsupportedOperationError("CreateCollection not implemented").     
    end method.
    
    method protected abstract IDataAdminElement CreateEntity(req as IRequestInfo).
   
    method public void RefreshRow(pFields as char, pValues as char extent):
        define variable hDataset as handle no-undo.
        define variable hBuffer  as handle no-undo.
        define variable lDynamic as logical no-undo.
        define variable cValues  as character no-undo extent.
        define variable cWhere   as character no-undo.
        define variable lKeep    as logical no-undo.
        define variable oRequest as IFetchRequest no-undo.
        define variable hBefore  as handle no-undo.
        define variable oChanges as StringStringMap  no-undo.
        define variable ltrack   as logical no-undo.
        define variable cChanged as character no-undo.
        define variable iFld     as integer no-undo.
        define variable hFld     as handle no-undo.
        define variable cLong    as longchar  no-undo.
        
        If DatasetHandle:num-buffers = 1 then do: 
            assign 
                hDataset = DatasetHandle
                hBuffer  = hDataset:get-buffer-handle(1)
                .
        end.    
        else do:
            lDynamic = true.
            create dataset hDataset.
            create buffer hBuffer for table TableHandle buffer-name TableHandle:name.
            hDataset:add-buffer(hBuffer).    
        end.    
        
        cWhere  = GetWhere(pFields,pValues).
        hBuffer:find-unique ("where " + cWhere) no-error.
        if hbuffer:avail then do:
            /* if record is updated - store backup */
            if hBuffer:before-rowid <> ? then do:
                hBefore = hBuffer:before-buffer.
                hBefore:find-by-rowid(hBuffer:before-rowid).
                cChanged = CompareHelper:CompareBuffers(hBefore,hBuffer,"","case-sensitive"). 
                ochanges = new StringStringMap().
                do iFLd = 1 to num-entries(cChanged):
                    hFLd = hBuffer:buffer-field(entry(iFld,cChanged)).
                    if hFld:data-type = "character" then
                        oChanges:Put(hFld:name,hFld:buffer-value).
                    else if hfld:data-type = "clob" then do:
                        copy-lob from hfld:buffer-value to clong .
                        oChanges:Put(hFld:name,clong).
                    end.    
                    else
                        oChanges:Put(hFld:name,string(hFld:buffer-value)).
                end.  
            end.    
            hBuffer:buffer-delete().
        end.    
        if num-entries(pFields) = 1 then do:
            assign
                cValues = pValues
                lTrack = TableHandle:tracking-changes
                TableHandle:tracking-changes = false.
             
            ServiceAdapter:FetchRow(Name,Id,Service:Url,hDataSet,pfields,cValues[1],false).
            if lTrack then 
                TableHandle:tracking-changes = true.
        end.
        else do:
            assign
                lkeep    = not lDynamic
                oRequest = new FetchRequest(Name,Id,hDataset,lkeep)    
                . 
            oRequest:SetTableQuery(Tablehandle:name,"for each " + Tablehandle:name + " where " + cWhere).
            FetchData(oRequest).
        end.
        if valid-object(oChanges) then do:
            hBuffer:find-unique ("where " + cWhere) no-error.
            if hBuffer:avail then do:
                do iFLd = 1 to num-entries(cChanged):
                    hFLd = hBuffer:buffer-field(entry(iFld,cChanged)).
                    case hFld:data-type:
                        when "character" then
                            hFld:buffer-value = oChanges:Get(entry(iFld,cChanged)).
                        when "integer" then
                            hFld:buffer-value = int(oChanges:Get(entry(iFld,cChanged))).
                        when "int64" then
                            hFld:buffer-value = int64(oChanges:Get(entry(iFld,cChanged))).    
                        when "decimal" then
                            hFld:buffer-value = dec(oChanges:Get(entry(iFld,cChanged))).
                        when "logical" then
                            hFld:buffer-value = logical(oChanges:Get(entry(iFld,cChanged))).
                        when "date" then
                            hFld:buffer-value = date(oChanges:Get(entry(iFld,cChanged))).
                        when "datetime-tz" then
                            hFld:buffer-value = datetime-tz(oChanges:Get(entry(iFld,cChanged))).
                        when "datetime" then
                            hFld:buffer-value = datetime(oChanges:Get(entry(iFld,cChanged))).
                        when "clob" then do:
                            clong = oChanges:Get(entry(iFld,cChanged)).
                            copy-lob from clong to hfld:buffer-value.
                        end.
                    end.       
                end.
            end.
        end.
        
        finally:
             if valid-object(ochanges) then        
                 delete object oChanges.
               
            if lDynamic then do:
                delete object hBuffer no-error.
                delete object hDataset no-error.
            end.    
        end.     
    end method.
 
    method protected void FetchRow(pDataset as handle,pField as char, pValue as char,pLazy as logical):
        define variable lTrack as logical no-undo.
        define variable hTable as handle  no-undo.
        
        hTable = pdataset:get-buffer-handle(1):table-handle.
        
        /* set tracking unconditionally ifd this is first request 
           (this is normally done in DataRefreshed */ 
        if not TableHandle:has-records and valid-handle(hTable:before-table) then
            lTrack = true.
        else
            lTrack =  hTable:tracking-changes. 
        hTable:tracking-changes = false.    
        /* no point in lazy fetch if url is set since data will be exported */
        ServiceAdapter:FetchRow(Name,Id,Service:Url,pDataSet,pfield,pValue,pLazy and Service:url = "").
        /* current usage should not need to refresh queries as there should not be any */
        /*   ContextRefreshed:Publish(new TableResponse(hTable:name)). */
        
        finally:
            if lTrack and valid-handle(hTable) then       
                hTable:tracking-changes = true.    
        end.    
 
    end method.
        
    /** override GetIntegerKey in context with integer key 
       There are also many overrides of FindExpression since GetIntegerKey is
       new (11.7.3)
    */
    method protected char FindExpression(i as int):
        define variable cField as character no-undo.
        cField = GetIntegerKey().
        if cfield = "" then
        undo, throw new UnsupportedOperationError("FindExpression with integer").
        return subst("&1.&2 = &3",TableHandle:name,cField,quoter(i)).
    end method.
    
    /** default find expression assumes there is a name field 
       override in context with different key name or more complex logic */
    method protected char FindExpression(c as char):
        define variable h as handle no-undo.
        h = TableHandle:default-buffer-handle:buffer-field ("name").
        if not valid-handle(h) then 
            undo, throw new UnsupportedOperationError("FindExpression with character").
        
        return subst("&1.&2 = &3",TableHandle:name,"Name",quoter(c)).
    end method.
    
    /** Create filtered context for parent row    */
    method protected FilteredContext CreateFilteredContext(pParentRow as IRow,pReq as IRequestInfo):
        return new FilteredContext(this-object,pParentRow,pReq).        
    end method. 
    
    /** create default filteredcontext that also handles parent/keyvalue as filter. */
    method protected FilteredContext CreateFilteredContext(filter as char):
        return new FilteredContext(this-object,filter).
    end method.
  
    /** create default filteredcontext with requestinfo  */
    method protected FilteredContext CreateFilteredContext(pReq as IRequestInfo):
        return new FilteredContext(this-object,pReq).
    end method.
    
    /** create default collection - override for dedicated child collections */
    method protected IDataAdminCollection CreateCollection(parent as char,cntxt as FilteredContext):
        return CreateCollection(cntxt).
    end method.
    
    method protected void FetchFilteredData(cntxt as FilteredContext):
        if valid-object(ServiceAdapter) and Lazy then
        do:   
            /**   @todo this (Lazy) needs to be improved
             useful for cases that can only have one parent, but is turned off for most cases
             deja vu - this is resolved in adm2 dataview using dataisfetched and 
             other logic to decide if data is fetched by parent or in dataavailable
             (this is equivalent of dataavailable for the cases where filter 
              has single row parent...foreignkey is already added though )  */ 
            FetchData(cntxt:GetRequest()).
        end.
        else  
            FireContextRefreshed().
         
    end method.
    
    method public /*final*/ IDataAdminCollection NewCollection().
        return CreateCollection(this-object).
    end method.
     
    method public final IDataAdminCollection GetCollection().
        define variable coll as IDataAdminCollection no-undo.
        if valid-object(ServiceAdapter) and Lazy then   
            FetchData(GetRequest()).
        return CreateCollection(this-object). 
    end method.
    
    method public IDataAdminCollection GetCollection(pParentRow as IRow,pReq as IRequestInfo).    
        define variable cntxt as FilteredContext no-undo.
        cntxt = CreateFilteredContext(pParentRow,pReq).
        FetchFilteredData(cntxt). 
        return CreateCollection(pParentRow:SerializeName,cntxt).
    end method.
    
    method public /*final*/ IDataAdminCollection GetCollection(filter as char).
        define variable cntxt as FilteredContext no-undo.
        cntxt = CreateFilteredContext(filter).
        FetchFilteredData(cntxt). 
        return CreateCollection(cntxt).
    end method.
      
    method public /*final*/ IDataAdminCollection GetCollection(preq as IRequestInfo).
        define variable cntxt as IDataAdminContext no-undo.
        define variable msg   as IFetchRequest no-undo.
        
        if preq:QueryString > "" then
        do: 
            cntxt = CreateFilteredContext(preq).
            msg   = cntxt:GetRequest().
        end.    
        else
        do:
            cntxt = this-object.         
            msg = GetRequest().
            TransferMatchingRequests(preq,msg). 
        end.
        FetchData(msg). 
        
        return CreateCollection(cntxt).
    end method.
    
    method public final IDataAdminCollection GetChildCollection(pRow as IRow,pchild as char).
        define variable cntxt as IDataAdminModel no-undo.
        define variable req as IRequestInfo no-undo.
      
        cntxt = GetChildWithRequestInfo(pchild,input-output req).      
        if not valid-object(cntxt) then
            undo, throw new IllegalArgumentError("Get child collection " + quoter(pchild) + " from " + name + " context").
        return cntxt:GetCollection(pRow,req).         
    end method.    
   
    method public final IDataAdminCollection GetChildCollection(pRow as IRow,pReq as IRequestInfo).
        define variable cntxt as IDataAdminModel no-undo.
        cntxt = GetChildWithRequestInfo(pReq:Name,input-output pReq).      
        if not valid-object(cntxt) then
            undo, throw new IllegalArgumentError("Get child collection " + quoter(pReq:Name) + " from " + name + " context").
        return cntxt:GetCollection(pRow, pReq).         
    end method.    
    
    /* Override for more efficient GetEntity and to not overide FindExpression(int)
       This exists bcause we do not have a consistent naming of integer keys 
        (mostly Number or Id) */
    method protected character GetIntegerKey():
        return "".
    end method.
    
    /* Note that there is no GetCharKey to deal with temp-tables with no name field  
       the way it is for integer key with GetIntegerKey 
       The reason is that all tables that supports Get with char should have an indexed
       name field.  
       The ones that don't should override this method to pass
       correct field to SetTableKeyValue  */ 
    method public IDataAdminElement GetEntity(pKey as char).
        define variable msg as IFetchRequest no-undo.
        define variable h        as handle no-undo.
        define variable hDs      as handle no-undo.
        define variable lok      as logical no-undo.
        define variable cField   as character no-undo.
        define variable cFindExp as character no-undo.
        if not this-object:Find(pKey) then
        do:
            /* all tables that support get on char fields should have a name field, 
               but unfortunately some does not  - override getentity in those cases */
            if KeyFields = "name" then 
                h = TableHandle:default-buffer-handle:buffer-field ("name") no-error.
            if not valid-handle(h) then do:
                /* FindExpression is overriden if the key is not name  */
                cFindExp = FindExpression(pKey).
                /* use substr - value may have period */
                cFindExp = substr(cfindExp,index(cfindExp,".") + 1).
                if index(cFindExp,"=") > 0 then
                   cField = right-trim(entry(1,cFindExp,"=")).
                else 
                   cField = right-trim(entry(1,cFindExp," ")). /* eq cannot be used as delimiter*/   
            end. 
            else 
                cField = "name".
                
            if cfield = "" then
                undo, throw new UnsupportedOperationError("GetEntity with char key. The table has no character key field.").
 
            hDs = getRequestDataset().
            if hDs:num-buffers = 1 and IsDatasetLoaded and DatasetHandle = hDs then do:
                FetchRow(hDs, cField ,pkey, Lazy).
                
            end.
            else do:
            msg = GetRequest(). 
                msg:SetTableKeyValue(Tablehandle:name, cField ,pKey).
                msg:SetTableLazy(Tablehandle:name,Lazy).
            FetchData(msg).   
            end.
        end.  
        
        return FindEntity(pKey).
       
    end method.    
    
    method public IDataAdminElement GetEntity(pKey as int):
        define variable oMsg      as IFetchRequest no-undo.
        define variable cFindExp  as character no-undo.
        define variable cfield    as character no-undo.
        define variable hDs       as handle no-undo.
        if not this-object:Find(pKey) then
        do:
            cField = GetIntegerKey().
            if cfield = "" then do:
                /* default behavior for old code with no GetIntegerKey 
                   FindExpression throws error if not overriden 
                   */
                cFindExp = FindExpression(pKey).
                /* use substr - value may have period */
                cFindExp = substr(cfindExp,index(cfindExp,".") + 1).
                if index(cFindExp,"=") > 0 then
                   cField = right-trim(entry(1,cFindExp,"=")).
                else 
                   cField = right-trim(entry(1,cFindExp," ")).   
            end. 
            
            hDs = getRequestDataset().
            if hDs:num-buffers = 1 and IsDatasetLoaded and DatasetHandle = hDs then do:
                FetchRow(hDs,cField,string(pKey),Lazy).
            end.
            else do:
                oMsg = GetRequest(). 
                oMsg:SetTableKeyValue(Tablehandle:name,cField,string(pKey)). 
                oMsg:SetTableLazy(Tablehandle:name,Lazy).   
                FetchData(oMsg). 
            end.
        end.   
        return FindEntity(pKey). 
    end method.
    
    method public IDataAdminElement GetEntity(preq as IRequestInfo):
        define variable msg as IFetchRequest no-undo.
        define variable cWhere as character no-undo.
        define variable cError as character no-undo.
        define variable lok as logical no-undo.
        define variable cValues  as character extent no-undo.
        define variable hDs as handle no-undo.
        define variable oReqChildren as IRequestInfo extent no-undo.
        
        lok = this-object:Find(pReq).      
        if not lok then 
        do:
            if preq:KeyFields = ""  or preq:KeyFields = ? then
                undo, throw new IllegalArgumentError("RequestInfo with no key expression passed to GetEntity."). 
            
            hDs = getRequestDataset().
            oReqChildren = pReq:GetChildren().
            
            /* no child requesinfo, single row, single table and single key then use the fastest track */
            if num-entries(preq:KeyFields) = 1 
            and extent(oReqChildren) = ? 
            and hDs:num-buffers = 1 
            and IsDatasetLoaded 
            and DatasetHandle = hDs then do:
                cValues = pReq:GetKeyValues().
                FetchRow(hDs,preq:KeyFields,cValues[1],Lazy).
            end.
            else do:
                msg = GetRequest(). 
                /* if single key then utilize optimized query for key on server   */
                if num-entries(preq:KeyFields) = 1 then do:
                    cValues = pReq:GetKeyValues().
                    msg:SetTableKeyValue(Tablehandle:name,preq:KeyFields,cValues[1]).
                end.
                else do:
            cWhere = GetWhere(preq:KeyFields,preq:GetKeyValues()). 
            msg:SetTableQuery(Tablehandle:name,"for each " + Tablehandle:name + " where " + cWhere).
                end.
                msg:SetTableLazy(Tablehandle:name,Lazy).
            TransferMatchingRequests(pReq:GetChildren(),msg).
            FetchData(msg). 
            end. 
        end.  
        /* find again in case it became ambiguous after fetch (non unique key) */
        lok = this-object:Find(pReq).
        if lok then      
            return RealizeEntity(pReq).  
    end method.    

    method public logical Remove(phdl as handle):
        define variable lok as logical no-undo.
        lok = SynchWithHandle(phdl).
        if lok then
        do:
            return Remove(). 
        end.
        return false.          
    end method.
    
    method private logical SynchWithHandle(phdl as handle):
        define variable lok as logical no-undo.
        lok = phdl = TableHandle:default-buffer-handle.
        if not lok then
        do: 
            lok = TableHandle:default-buffer-handle:find-by-rowid(phdl:rowid) no-error.
        end. 
        return lok. 
    end method.
    
    method private IllegalArgumentError CreateFindError(pmsg as char,pnum as int,preq as IRequestInfo):
        define variable cvalues as character extent no-undo.
        if pnum = 7328 then 
        do:
            pmsg = "Invalid property reference " + entry(3,pmsg,"") + " used in in request for " + substr(entry(2,pmsg,""),3).
        end.
        else if pnum = 3166 then 
        do: 
            if num-entries(preq:Keyfields) = 1 then 
            do:
                  cValues = preq:GetKeyValues().
                  pmsg = "More than one " + Name + " found by request using " + preq:KeyFields + " = " + quoter(cValues[1]) + " as unique key.".
            end.  
            else  
                  pmsg = "More than one " + Name + " found by request using " + preq:KeyFields + " as unique key.".
        end.    
        return new IllegalArgumentError(pmsg).
    end.
    
    /**
    method public IDataAdminElement Remove(phdl as handle):
        define variable elem as IDataAdminElement no-undo.
        elem = FindEntity(phdl).
        if valid-object(elem) then
        do:
            elem:Detach().   
            if Remove() then
                return elem.    
        end.
        return ?.          
    end method.
    **/
    
    /** remove row */
    method protected logical Remove(): 
      
        define variable lTrack as logical no-undo.
        OnBeforeDelete().
        lTrack = TableHandle:tracking-changes.
        /***
        /** @todo replace/improve to walk through context children and 
             fire OnRowDeleted */
        RemoveChildren(TableHandle:default-buffer-handle).
        ***/
        TableHandle:tracking-changes = true.
        
        TableHandle:default-buffer-handle:buffer-delete().
        
        TableHandle:tracking-changes = lTrack.
        
        Count = Count - 1.
        OnRowDeleted().
        return true.                             
    end method.
    
    /** remove row  */
    method protected void RemoveDatasetRow(phBuffer as handle):
        RemoveDatasetChildren(phBuffer).
        phBuffer:buffer-delete(). 
    end method.    
    
    /** currently used to delete non applicable data for change and 
        regular cascade when deleting row from service 
        (the latter need to be replaced/improved - see comment in Remove) */ 
    method protected void RemoveDatasetChildren(phBuffer as handle):
         define variable ichild as integer no-undo.
         define variable hRel   as handle no-undo.
         do iChild = 1 to phBuffer:num-child-relations:
            hRel = phBuffer:get-child-relation (ichild).
            hrel:query:query-open(). 
            hrel:query:get-first.
            do while hrel:child-buffer:avail:
                RemoveDatasetRow(hrel:child-buffer).
                hrel:query:get-next.
            end.    
        end.       
    end method.    
    
    method public logical Detach(entity as IDataAdminElement).
               
    end.
    
    method protected IDataAdminElement RealizeEntity().
        return RealizeEntity(?).       
    end method.
    
    method protected IDataAdminElement RealizeEntity(pReq as IRequestInfo).
        define variable lTrack as logical no-undo.
        define variable inst as IDataAdminElement no-undo.
        if not valid-object(TableHandle::Entity) then 
        do:
            lTrack = TableHandle:tracking-changes.
            inst = CreateEntity(pReq).   
            if KeepInstances then
            do:      
                TableHandle:tracking-changes = false.   
                TableHandle::Entity = inst.
                TableHandle:tracking-changes = lTrack.            
            end.
            return inst.
        end.
        return TableHandle::Entity.       
    end method.
  
  /**   Return a query expression with the key field(s) and current
        value(s). 
     @param handle  - the buffer is typically the before-image or after-image
                      buffer.  
           pcQual   - Optional qualifier for the column reference.               
            
    Notes: Used to find a record without relying on rowid. 
           For example in deleteRow error handling, where prodataset methods 
           may reuse the rowids of a deleted record that need to be undeleted. */   
     
   
    /** find the entity (factory method - data already avail )
        Is considered internal.                    
        @param handle buffer that points to the record to find the entity for */ 
    method public IDataAdminElement FindEntity(phdl as handle).
        if SynchWithHandle(phdl) then
            return RealizeEntity().
        return ?.          
    end method.
    
    /** find the entity (factory method - data already avail )
        Is considered internal.                    
        @param handle buffer that points to the record to find the entity for */ 
    method public IDataAdminElement FindEntity(phdl as handle,pReq as IRequestInfo).
        if SynchWithHandle(phdl) then
            return RealizeEntity(pReq).
        return ?.          
    end method.
    
    
    method public IDataAdminElement FindEntity(c as char extent).
        if this-object:Find(c) then
            return RealizeEntity().
        return ?.
    end method.
    
    method public IDataAdminElement FindEntity(pReq as IRequestInfo).
        if this-object:Find(pReq) then
            return RealizeEntity().
        return ?.
    end method.
    
    method public IDataAdminElement FindEntity(c as char).
        if this-object:Find(c) then do:
            return RealizeEntity().
        end.
        return ?.
    end method.
    
    method public IDataAdminElement FindEntity(i as int):
        if this-object:Find(i) then
            return RealizeEntity(). 
        return ?.
    end method.
    
    method public IDataAdminElement FindEntity(c as char extent,pReq as IRequestInfo).
        if this-object:Find(c) then
            return RealizeEntity(preq).
        return ?.
    end method.
    
    method public IDataAdminElement FindEntity(c as char,pReq as IRequestInfo).
        if this-object:Find(c) then
            return RealizeEntity(pReq).
        return ?.
    end method.
    
    method public IDataAdminElement FindEntity(i as int,pReq as IRequestInfo):
        if this-object:Find(i) then
            return RealizeEntity(preq). 
        return ?.
    end method.
    
    method public final IDataAdminElement CreateRootEntity().
        /* default unsupported */
        CreateRootRow().
        return RealizeEntity().
    end method.
    
    method public final IDataAdminElement CreateRootEntity(c as char).
        CreateRootRow(c).
        return RealizeEntity().
    end method.
    
    method public final IDataAdminElement CreateRootEntity(i as int):
        CreateRootRow(i).
        return RealizeEntity().
    end method.
    
    method public final IDataAdminElement CreateRootEntity(pReq as IRequestInfo).
        CreateRootRow(pReq).
        return RealizeEntity(pReq).
    end method.
    
    /** final overridw with getNamedChild */
    method final public IDataAdminModel GetChild(pname as char):
        define variable i as integer no-undo.
        define variable iCount as integer no-undo.
        iCount = ChildList:Count.
        do i = 1 to iCount:
            if  ChildList:Get(i):serializename = pname then
                return ChildList:Get(i).
        end.
        /** check if there is an override that provides a named child */
        return GetNamedChild(pname).
    end method.   
    
    /** get a child by name -  Will add or append to request info if the passed name is supported in GetNamedQuery   */
    method final protected IDataAdminModel GetChildWithRequestInfo(pname as char,input-output preq as IRequestInfo):
        define variable i      as integer no-undo.
        define variable cQuery as character no-undo.
        define variable model  as IDataAdminModel no-undo.
        define variable icount as integer no-undo.
        iCount = ChildList:Count.
        do i = 1 to iCount:
            if  ChildList:Get(i):serializename = pname then
            do:
                return ChildList:Get(i).
            end.
            else if type-of(ChildList:Get(i),IDataAdminModel) then 
            do:    
                model = cast(ChildList:Get(i),IDataAdminModel).
                cQuery = model:GetNamedQuery(pname).
                if cQuery > "" then
                do:
                    /* ensure correct casing */
                    pname = model:GetNamedQueryName(pname).
                    if not valid-object(pReq) then
                        pReq = new RequestInfo(pname).
                    
                    if not pReq:IsNameChecked then
                    do:                       
                        assign
/*                            pReq:Name = pName*/
                            preq:QueryString = (if preq:QueryString <> "" 
                                                then "(" + preq:QueryString + ") and " 
                                                else "")  
                                             + cQuery
                            pReq:IsNameChecked = true.  
                    end.
                    return ChildList:Get(i).
                end.                    
            end.
        end. /*  do i = 1 to ChildList:Count  */
        /* lastly - return a named child if override exists */
        return getNamedChild(pname).
    end method.
    
    method protected void AddChild(cntxt as IDataAdminModel):
        ChildList:Add(cntxt).
        KeyChanged:Subscribe(cntxt:ForeignKeyChanged).
    end method.    
   
/*    method protected void FetchEntityData():                                      */
/*        msg = GetRequest().                                                       */
/*        msg:SetTableQuery(Tablehandle:name,                                       */
/*               "for each " + Tablehandle:name + " where " + FindExpression(cKey)).*/
/*            FetchData(msg).                                                       */
/*        end.                                                                      */
/*    end method.                                                                   */

    method protected final void FetchData(pmsg as IFetchRequest):  
        FetchData(pMsg,ServiceAdapter,Service).
    end method. 
    
    method public final void FillData(pmsg as IFetchRequest):  
        define variable oadapter  as ServiceAdapter no-undo.
        define variable oservice  as IDataAdminService no-undo.
        if valid-object(ServiceAdapter) then
            assign oadapter = ServiceAdapter
                   oService = Service.
        else if valid-object(TargetAdapter) then
            assign oadapter = TargetAdapter  
                   oService = TargetService.
        else 
            undo, throw new UnsupportedOperationError("FillData not supported in " + getClass():TypeName).
 
        FetchData(pMsg,oadapter,oService).
    end method. 
         
    method private void FetchData(pmsg as IFetchRequest,pAdapter as ServiceAdapter,pService as IDataAdminService):  
        define variable hds as handle no-undo.
        define variable hTbls  as handle extent no-undo.

        pmsg:Url =  pService:URL.
        PageRequested = pmsg:IsPageRequest.
        
        hTbls = TrackDataset(pmsg:DataHandle,false).
        
        if not valid-object(pAdapter) then
            undo, throw new UnsupportedOperationError("FetchData not supported in " + getClass():TypeName).
        
        pAdapter:RequestComplete:Subscribe(DataRefreshed).        
        
/*                                                       */
/*        message this-object skip                       */
/*              "message" skip msg                       */
/*            skip "has changes" this-object:HasChanges()*/
/*        view-as alert-box.                 
             */
        pAdapter:FetchData(pmsg).
        Count = ?.
        TrackTables(hTbls,true).    
        finally:
            pAdapter:RequestComplete:Unsubscribe(DataRefreshed).        
        end finally.
        
    end method.
    
    method public void ExportNormalized(pcfile as char):
        undo, throw new UnsupportedOperationError("ExportNormalized not supported in " + getClass():TypeName).  
    end method.
 
    method public handle extent HideColumns(cList as char):
        define variable i as integer no-undo. 
        define variable hflds as handle extent no-undo.
        define variable hfld  as handle no-undo.
        define variable cfld as character no-undo.
        extent(hflds) = num-entries(cList).
        do i = 1 to num-entries(cList):
            cfld = entry(i,cList).
            hfld =  TableHandle:default-buffer-handle:buffer-field(cfld).
            if hfld:serialize-hidden = false then
            do: 
                hfld:serialize-hidden = true. 
                hflds[i] = hfld. 
            end.
        end.
        return hflds.
    end method.
    
    method public handle extent HideUrlColumns():
        return GetUrlColumns(true).
    end method.
    
    method protected handle extent GetUrlColumns(plHide as logical):
        define variable i as integer no-undo. 
        define variable hflds as handle extent no-undo.
        define variable hfld  as handle no-undo.
        define variable cfld as character no-undo.
        define variable hbuff as handle no-undo.
        define variable iNum as integer no-undo.
        hBuff = TableHandle:default-buffer-handle.
        extent(hflds) = hBuff:num-fields.
        do i = 1 to hBuff:num-fields:
            hfld =  hBuff:buffer-field(i).
            if (hfld:serialize-name matches "*_url" or hfld:serialize-name = "url")
            and hfld:serialize-hidden = false then
            do: 
                if plHide then
                     hfld:serialize-hidden = true. 
                hflds[i] = hfld. 
            end.
        end.
        return hflds.
    end method.
    
    
    method public void ViewHiddenColumns(phdls as handle extent):
        define variable i as integer no-undo.
        do i = 1 to extent(phdls):
            if valid-handle(phdls[i]) then
               phdls[i]:serialize-hidden = false.
        end.    
    end method.
    
    method public int Deserialize(phStream as handle,piMax as int,pcmode as char):
        define variable lCreateOnly as logical no-undo. 
        if pcMode = "Append" then
           lCreateOnly = true. 
        else if pcMode <> "Replace" then
           undo, throw new IllegalArgumentError("Read mode " + quoter(pcMode) +  " passed to Deserialize. Valid values are ""Replace"" or ""Append"" "). 
      
        define variable lTrack as logical no-undo. 
        define variable hbuf as handle no-undo.
        define variable i as integer no-undo.
        hbuf = TableHandle:default-buffer-handle.
        lTrack = TableHandle:tracking-changes.
        if not lTrack then
            TableHandle:tracking-changes = true.
        repeat on error undo,throw:
            if lCreateOnly then
            do:
                if not DeserializeRow(phStream) then 
                   leave.
            end.
            else do:
                if not DeserializeRow(phStream,yes) then 
                    leave.
            end.   
            i = i + 1.
            if piMax > 0 and i >= piMax then leave.
        end.    
        return i.
        catch e as Error:  
            undo, throw new DataContextError(this-object:Name,e).  
        end catch.  
        finally:
            if not lTrack then
                TableHandle:tracking-changes = lTrack.              
        end finally.
    end method.
    
    
    method public int Serialize(phStream as handle):
        define variable hQuery  as handle no-undo. 
        define variable hBuffer as handle no-undo. 
        define variable i as integer no-undo.
        create query hQuery.
        hBuffer = TableHandle:default-buffer-handle.
        hQuery:add-buffer(hBuffer).
        hQuery:query-prepare ("For each " + hBuffer:name   ).
        hQuery:query-open ().
        hQuery:get-first.
        do while hBuffer:avail:
           i = i + 1.
           SerializeRow(phStream).
           hQuery:get-next.
        end.
        /* set count in case we don't have it */
        Count = i.
        return i.
        finally:
            delete object hQuery no-error.		
        end finally. 
    end.    
   
    method public void SerializeRow(phBuffer as handle,phStream as handle): 
        if SynchWithHandle(phBuffer) then
        do:
            SerializeRow(phStream).
        end.
    end method.
    
    method protected void SerializeRow(phStream as handle):
        undo, throw new UnsupportedOperationError("SerializeRow to stream in " + GetClass():TypeName ).      
    end method.
    
    method protected final logical DeserializeRow(phStream as handle):
        return DeserializeRow(phStream,no).      
    end method.
    
    method protected logical DeserializeRow(phStream as handle,plUpdate as log):
        undo, throw new UnsupportedOperationError("Deserialize row from stream in " + GetClass():TypeName ).      
    end method.
   
    /*** not in use  yet 
    /* exportlist is the opposite of export in the sense that the second paramter is displayed fields */
    method public void ExportList(pcfile as char,pcDispfields as char): 
        define variable cHiddenList as character no-undo. 
        cHiddenList = HiddenColumns(pcDispFields).
        this-object:Export(pcfile,cHiddenList).    
    end method.
    */
  
    method public void Export(pcfile as char,pcHidefields as char): 
        define variable clong as longchar no-undo.             
        define variable hflds as handle extent no-undo.
        define variable hUrlflds as handle extent no-undo.
        if pcHidefields > "" then
            hflds = HideColumns(pchidefields).
            
        if Total = ? and (valid-object(service) and service:url = "") then
        do:
            hUrlFlds = HideUrlColumns().    
            DatasetHandle:get-buffer-handle(1):write-json ("file",pcFile,yes).   
            ViewHiddenColumns(hUrlFlds).
        end.    
        else
        do:
            DatasetHandle:get-buffer-handle(1):write-json ("longchar",clong,yes).   
            substring(cLong,2,0) = LineFeed 
                                 /* need to add fields before we use MetaData
                                 + (if Total <> ? and not PageRequested then MetaData() else '') 
                                  */
                                 + (if valid-object(service) and service:url > "" then '  "success": true,' + LineFeed else "") 
                                 + (if Total <> ? then '  "total": ' + string(Total) + "," + LineFeed else '') 
                                 + '  '.
            
            copy-lob clong to file pcFile.
        end.
        if extent(hflds) <> ? then
            ViewHiddenColumns(hflds).
    end method.
    
    method private char MetaData ():
        return      ' "metaData": ~{ '                    + LineFeed 
                  + '   "root": "' + SerializeName + '",' + LineFeed 
                  + '   "totalProperty": "total",'        + LineFeed 
                  + '   "successProperty": "success",'    + LineFeed
                  + '   "start": ' + string(0) + ","      + LineFeed 
                  + '   "limit": ' + string(Count)        + LineFeed 
                  + '  ~},'                               + LineFeed
                  .        
    end method.    
    
    method public void ExportLastSaved(pcfile as char). 
        define variable hBuffer as handle no-undo. 
        if valid-handle(LastSavedDataset) then
        do:
            hbuffer = LastSavedDataset:get-buffer-handle(TableHandle:name) . 
            if valid-handle(hBuffer) then 
                hBuffer:write-json ("File",pcFile,yes).    
        end.
    end method.  
    
    method public void ExportLastSavedTree(pcfile as char):
        define variable tree as DataExportTree no-undo.
        if valid-handle(LastSavedDataset) then 
        do: 
            tree = new DataExportTree(LastSavedDataset).
            tree:NoTopArray = LastImportNoTopArray.
            tree:TopTable = TableHandle:name.
            PrepareLastSavedTree(tree, LastSavedDataset:get-buffer-handle(TableHandle:name)).
            tree:Total = ?. /* ensure no total in response for save */
            tree:ExportToFile(pcFile).     
        end.
        else 
            undo, throw new UnsupportedOperationError("ExportLastSavedTree without a last saved dataset in context.").
    end method.
    
    method public void PrepareLastSavedTree(tree as IDataTree,phBuffer as handle):
        define variable ichild as integer no-undo.
        define variable hRel   as handle no-undo.        
        define variable childReq     as IRequestInfo no-undo.        
        define variable childContext as IDataAdminModel no-undo.
        
        SetTreeOptions(tree).
           
        do iChild = 1 to phBuffer:num-child-relations:
            hRel = phBuffer:get-child-relation (ichild).
            childContext = GetChild(hRel:child-buffer:serialize-name).
            if valid-object(childcontext) then 
                childContext:PrepareLastSavedTree(tree,hRel:child-buffer).
/*                 undo, throw new IllegalArgumentError(          */
/*                          "Prepare last saved tree for "        */
/*                          + hRel:child-buffer:serialize-name    */
/*                          +  " of "                             */
/*                          + this-object:name                    */
/*                          + " does not have a matching context."*/
/*                       ).                                       */
            
                 
        
        end.    
    
    end method.
    
    
    method protected handle CloneTable ():
        define variable htbl as handle no-undo.
        define variable i as integer no-undo.
        create temp-table htbl.
        htbl:create-like(TableHandle:default-buffer-handle).
        htbl:temp-table-prepare (TableHandle:name).
        htbl:default-buffer-handle:serialize-name = TableHandle:default-buffer-handle:serialize-name.     
        do i = 1 to Tablehandle:default-buffer-handle:num-fields:
            htbl:default-buffer-handle:buffer-field(i):serialize-name = Tablehandle:default-buffer-handle:buffer-field(i):serialize-name.
        end.    
        return htbl.
    end.
    
    method public final void ImportNewForParent(pParentRow as IRow,pcfile as char):
        ImportNewForParent(pParentRow,ReadJsonRoot(pcFile)).      
    end method.
    
    method public final void ImportNewForParent(pParentRow as IRow,pJson as JsonObject):
        ReadChild(pParentRow,pJson,"Append") .  
    end method.
    
    /* single table import of the entity from query/filtered context 
        (flat - no tree ?? will probably work with tree if no root ) 
         replace mode 
       Adds forein value to all records from the passed parameters. 
       pcParent - parent serializename
       pcValue - parent key  - foreign value
       
        */
    
    method public void ImportForParent(pParentRow as IRow,pcfile as char):
        ImportForParent(pParentRow,ReadJSONFile(pcfile)).
    end method.
    
    method public void ImportForParent(pParentRow as IRow,pJson as JsonObject):
        ReadChild(pParentRow,pJson) .     
    end method.

     /* override to add foreign value  */
    method protected void ReadRowForParent(pParentRow as IRow,json as JSONObject).
        ReadRow(json,GetClientKeyFields()).
    end method. 
    
    method protected logical FindOrCreateFromJson(pcKeyFields as char, json as JSONObject):
        define variable cKeyValues as character extent no-undo.
        define variable i as integer no-undo.
        define variable cField as character no-undo.
        define variable hFld as handle no-undo.
        define variable hbuffer as handle no-undo.
        
        if pcKeyFields = "" or pcKeyFields = ? then 
            undo, throw new IllegalArgumentError("KeyFields not passed to FindOrCreateFromJson"). 
        
        /*
        if extent(pcKey) <> num-entries(KeyFields) then
            undo, throw new IllegalArgumentError("The keys passed to FindOrCreateFromJson has" 
                                                  + string(extent(pcKey)) + "extents while the "
                                                  + this-object:GetClass():TypeName 
                                                  + " KeyFields property has  " 
                                                  + string(num-entries(KeyFields)) 
                                                 + " entries. Cannot load JSON file."). 
    
        */
        hBuffer = TableHandle:default-buffer-handle.
        extent(cKeyValues) = num-entries(pcKeyFields).
        
        do i = 1 to num-entries(pcKeyFields):
            cField = entry(i,pcKeyFields).
            hFld = TableHandle:default-buffer-handle:buffer-field(cField).
            
            /* case sensitive  */
            if json:Has(hFld:serialize-name) then
                cKeyValues[i] = ReadJsonCharValue(cField,json).
            else do:
                cKeyValues[i] = hFld:default-value.
            end.
        end.
       
        TableHandle:default-buffer-handle:find-unique("where " + GetWhere(pcKeyFields,cKeyValues)) no-error.
       
        if not TableHandle:default-buffer-handle:avail then
        do on error undo, throw:
            Count = Count + 1.
            TableHandle:default-buffer-handle:buffer-create().
            do i = 1 to num-entries(pcKeyFields):
                cField = entry(i,pcKeyFields).
                hFld = TableHandle:default-buffer-handle:buffer-field(cField).
                hfld:buffer-value = cKeyValues[i].        
            end.   
            catch e as Progress.Lang.Error :
                 if TableHandle:default-buffer-handle:avail then
                     TableHandle:default-buffer-handle:buffer-delete().
                 Count = Count + 1.
                 undo, throw e.
            end catch.  
        end.
        return TableHandle:default-buffer-handle:AVAIL.  
    end method.     
    
    method protected logical FindOrCreateFromJson(pcParentJoin as char,pcParentValues as char extent,pcKeyFields as char,pjson as JSONObject):
         return FindOrCreateFromJson(pcParentJoin,pcParentValues,pcKeyFields,pjson,no).
    end method.  
    
    method protected logical CreateFromJson(pcParentJoin as char,pcParentValues as char extent,pcKeyFields as char,pjson as JSONObject):
         return FindOrCreateFromJson(pcParentJoin,pcParentValues,pcKeyFields,pjson,yes).
    end method.
    
    method private logical FindOrCreateFromJson(pcParentJoin as char,pcParentValues as char extent,pcKeyFields as char,pjson as JSONObject,plcreateonly as log):
        define variable cKeyValues as character extent no-undo.
        define variable i as integer no-undo.
        define variable cField as character no-undo.
        define variable cFieldList as character no-undo.
        define variable iKey as integer no-undo.
        define variable iParent as integer no-undo.
        define variable hFld as handle no-undo.
        define variable lcreate as logical no-undo.
        define variable cMsg  as character no-undo.        
        define variable tbl as char no-undo.
        define variable policy as char no-undo.
        define variable fld as char no-undo.
        define variable cdcKeyValue as char no-undo.
        define variable cdcMode as char no-undo.
        
        if pcKeyFields = "" or pcKeyFields = ? then 
            undo, throw new IllegalArgumentError("No KeyFields passed to FindOrCreateFromJson. Cannot load JSON file."). 
        
        if pcParentJoin = "" or pcParentJoin = ? then 
            undo, throw new IllegalArgumentError("No Parent join passed to FindOrCreateFromJson. Cannot load JSON file."). 
        
        if extent(pcParentValues) * 2 <> num-entries(pcParentJoin) then
            undo, throw new IllegalArgumentError("Parent join and ParentValues passed to FindOrCreateFromJson does not match. Cannot load JSON file."). 
        
        extent(cKeyValues) = num-entries(pcKeyFields).
        cFieldList = pcKeyFields.
        
        /* add parent values to key values
           Remove each entry from cFieldList, the fields that remain in cFieldList will have to be found in JSON  */
        do i = 2 to num-entries(pcParentJoin) by 2:
            iParent = iParent + 1.
            cField = entry(i,pcParentJoin).
            iKey = lookup(cField,pcKeyFields). 
            /* if the passed values is part one of the keyfields then use the value from the parameter */
            if iKey > 0 then 
            do:
               if extent(pcParentValues) lt iparent then 
                   undo, throw new IllegalArgumentError("The " + this-object:GetClass():TypeName + " join does not match the passed parent values. Cannot load JSON file."). 
                
                cKeyValues[iKey] = pcParentValues[iParent].
                entry(iKey,cFieldList) = "".
            end.
        end.
        /* remaining fields need to be read from JSON */  
        do i = 1 to extent(cKeyValues):
            cField = entry(i,cFieldList).
            if cField <> "" then
            do:
               if TableHandle:name eq "ttCdcFieldPolicy" then 
               do:
                   if num-entries (pcParentValues[1],".") > 1 then do:
                      policy = entry(1,pcParentValues[1],".").
                      tbl = entry(2,pcParentValues[1],".").
                   end. 
                   hFld = TableHandle:default-buffer-handle:buffer-field("FieldName").
                   if pjson:Has(hFld:serialize-name) then do: 
                       cKeyValues[i] = ReadJsonCharValue(cField,pjson) + "@" + policy.
                   end.
                   else do:
                       cKeyValues[i] = hFld:default-value.
                   end.
               end. 
               else 
               do:
                   hFld = TableHandle:default-buffer-handle:buffer-field(cField).
                   /* case sensitive  */
                   if pjson:Has(hFld:serialize-name) then
                       cKeyValues[i] = ReadJsonCharValue(cField,pjson).
                   else do:
                       cKeyValues[i] = hFld:default-value.
                   end.
               end.
            end.
        end.  
        
        if plcreateonly = false or plcreateonly = ? then
        do:
            if TableHandle:name eq "ttCdcFieldPolicy" then 
            do: 
                TableHandle:default-buffer-handle:find-unique("where " + GetKeyWhere(cKeyValues)) no-error.
                if not TableHandle:default-buffer-handle:avail then do:
                    cdcKeyValue = cKeyValues[1].
                    if index(cKeyValues[1],"@") > 0 then 
                        cKeyValues[1] = entry(1,cKeyValues[1],"@").
                    TableHandle:default-buffer-handle:find-unique("where " + GetKeyWhere(cKeyValues)) no-error.
                end.
                cKeyValues[1] = cdcKeyValue.
                
                /* OEM UI expecting delete request to be send in PUT request.
                JSON request will contain cdcMode name/value pair to identify delete request*/
                if pjson:Has("cdcMode") then
                    cdcMode = pjson:GetCharacter("cdcMode").
                if cdcMode eq "delete" and TableHandle:default-buffer-handle:avail then do:                    
                    TableHandle:default-buffer-handle:buffer-delete().
                    return TableHandle:default-buffer-handle:avail.
                end.
            end.
            else TableHandle:default-buffer-handle:find-unique("where " + GetKeyWhere(cKeyValues)) no-error.
        end.
        if plcreateonly or not TableHandle:default-buffer-handle:avail then
        do:
            CreateChildRow(pcParentJoin,pcParentValues,pcKeyFields,cKeyValues).
        end.
        return TableHandle:default-buffer-handle:AVAIL.  
         
    end method. 
    
    method private void CreateChildRow(pcParentJoin as char,pcParentValues as char extent,pcKeyFields as char,pcKeyValues as char extent):
        define variable i as integer no-undo.
        define variable cField as character no-undo.
        define variable hFld as handle no-undo.
        define variable iParent as integer no-undo.
        define variable iKey as integer no-undo.
        define variable cMsg as character no-undo.
        Count = Count + 1.
        TableHandle:default-buffer-handle:buffer-create().
        do i = 1 to num-entries(pcKeyFields):
            cField  = entry(i,pcKeyFields).
            hFld = TableHandle:default-buffer-handle:buffer-field(cField).
            hfld:buffer-value = pcKeyValues[i].
        end.
        /* add parent values to new record   */
        do i = 2 to num-entries(pcParentJoin) by 2:
            iParent = iParent + 1.
            cField = entry(i,pcParentJoin).
            iKey = lookup(cField,pcKeyFields). 
            /* if the parent value is not part of the keyfields then assign the value from the parameter */
            if iKey = 0 then 
            do:
                if extent(pcParentValues) lt iparent then 
                    undo, throw new IllegalArgumentError("The " + this-object:GetClass():TypeName + " join does not match the passed parent values. Cannot load JSON file."). 
                hFld = TableHandle:default-buffer-handle:buffer-field(cField).
                if TableHandle:Name eq "ttCdcFieldPolicy" then do:
                    hfld:buffer-value = entry(1,pcParentValues[iParent],".").
                    hFld = TableHandle:default-buffer-handle:buffer-field("TableName").
                    hfld:buffer-value = entry(2,pcParentValues[iParent],".").
                end.
                else hfld:buffer-value = pcParentValues[iParent].
            end.
        end.
       
        catch e as Progress.Lang.Error :
            TableHandle:default-buffer-handle:buffer-delete().
            Count = Count - 1.
        	if e:GetMessageNum(1) = 132 then
            do:
                /* does not work - seems to be overidden by the tra*/
                cMsg = replace(e:GetMessage(1),TableHandle:name,Name).
                cMsg = replace(cMsg,"(132)","").
                undo, throw new DataError(cMsg).
            end.
            else 
                undo, throw e. 	
        end catch.
    end method. 
                   
    /* @todo throw errr when not found  - needs testing */
    method protected char ReadJsonCharValue(pname as char,json as JSONObject):
        define variable hFld as handle no-undo.
        define variable cName as character no-undo.
        hFld = TableHandle:default-buffer-handle:buffer-field (pname) no-error.
        if not valid-handle(hFld) then 
            undo, throw new IllegalArgumentError("Field " + quoter(pname) + " not found in temp-table.").
        /* case sensitive */
        cName = hFld:serialize-name.
        if json:Has(cname) then
        do:
            case hFld:data-type:
                when "int64" then
                    return string(json:GetInt64(cname)).
                when "integer" then
                    return string(json:GetInteger(cname)).
                when "character" then
                    return json:GetCharacter(cname).
                when "logical" then
                    return string(json:GetLogical(cname)).
                when "date" then
                    return string(json:GetDate(cname)).
                when "datetime" then
                    return string(json:GetDatetime(cname)).
                when "datetime-tz" then
                    return string(json:GetDatetimeTZ(cname)).
                when "decimal" then
                    return string(json:GetDecimal(cname)).
   
            end case.
        end.
        return ?.
         
    end method.    
    
    method protected void ReadRow(json as JSONObject).
        ReadRow(json,"").
    end method.
    
    /** read a buffer field from json  */
    method protected void ReadField(pjson as JSONObject,phfld as handle).
        define variable cold as character no-undo.
        case phFld:data-type:
            when "int64" then
                phFld:buffer-value = pjson:GetInt64(phFld:serialize-name).
            when "integer" then
                phFld:buffer-value = pjson:GetInteger(phFld:serialize-name).
            when "decimal" then
                phFld:buffer-value = pjson:GetDecimal(phFld:serialize-name).
            when "character" then
                phFld:buffer-value = pjson:GetCharacter(phFld:serialize-name).
            when "logical" then
                phFld:buffer-value = pjson:GetLogical(phFld:serialize-name).    
            when "date" then
                phFld:buffer-value = pjson:GetDate(phFld:serialize-name).    
            when "datetime" then
                phFld:buffer-value = pjson:GetDatetime(phFld:serialize-name).    
            when "datetime-tz" then
                phFld:buffer-value = pjson:GetDatetimeTZ(phFld:serialize-name).    
        end case. 
    end.
    
    method protected void ReadRow(pjson as JSONObject,pcExceptColumns as char).
         define variable i as integer no-undo.
         define variable hbuf as handle no-undo.
         define variable hFld as handle no-undo.
         
         hbuf = TableHandle:default-buffer-handle.
         do i = 1 to hbuf:num-fields on error undo, throw:
             hFld = hbuf:buffer-field (i).
             if  hFld:serialize-hidden = false  
             and pjson:Has(hFld:serialize-name) 
             and lookup(hFld:name,pcExceptColumns) = 0 
             and lookup(hFld:name,ReadOnlyFieldNames)  = 0 then
                 ReadField(pjson,hfld).
         end.
         ValidateBuffer(hbuf).
         ReadChildren(pjson).
         ValidateChildren(hbuf).
    end method.    
    
    method protected void ReadChildren(json as JSONObject).
        define variable i as integer no-undo. 
        define variable childcntxt as IDataAdminContext no-undo.
        define variable rowInfo as IRow no-undo.    
        
        rowInfo = new RowBuffer(this-object,TableHandle:default-buffer-handle,KeyFields).
  
        /* loop through children and call ReadChild */
        do i = 1 to ChildList:Count:       
            if valid-object(ChildList:Get(i)) then 
            do:
                if json:Has(ChildList:Get(i):SerializeName) then
                do:
                    ChildList:Get(i):ReadChild(rowInfo, json).
                end.
            end.   
        end.
    end method.
       
       /* override (usually with static for each) if importnew need to add foreign value */
    method protected void CopyNewTableForParent(pParentRow as IRow,hTbl as handle):
         undo, throw new UnsupportedOperationError("ReadNewForParent  in " + Name + " context").
    end method.
    
    /** ReadJsonRow returns the single object from the JSON file.
        The object can be in an array (prodataset style) or be a true 
        object in the file. 
        Throws an error if there is an array with more than one element */  
    method protected JsonObject ReadJsonRow(pcFile as char,plCheckRoot as log):
        define variable json       as JsonObject no-undo.
        define variable jsonOwner  as JsonObject no-undo.
        define variable array      as JsonArray no-undo.
        define variable parser     as ObjectModelParser no-undo.
        
        jsonOwner = ReadJsonFile(pcfile).
        if plCheckRoot and jsonOwner:Has("root") then 
            jsonOwner = jsonOwner:GetJsonObject("root").
        do on error undo, throw: 
            json = jsonOwner:GetJsonObject(SerializeName).
            catch e as Progress.Lang.Error :
              /* Ignore 16060, which is thrown if the object is an array */
               if e:GetMessageNum(1) <> 16060 then 
                  undo, throw e. 	    	
            end catch. 
        end.
        if not valid-object(json) then
        do:      
            array = jsonOwner:GetJsonArray(SerializeName).  
            if array:Length > 1 then 
                undo, throw new IllegalArgumentError("More than one row encountered in import to " + Name + " row " ).
            json = array:GetJsonObject(1). 
        end.
        return json.
    end method.   
    
    method protected JsonObject ReadJsonFile (pcFile as char):
        define variable parser as ObjectModelParser no-undo.
        define variable json as JsonObject no-undo.
        parser = new ObjectModelParser().
        return cast(parser:ParseFile(pcfile),JsonObject).
    end method.
     
    /* public - to be used as utility by  collection */
    method public JsonObject ReadJsonRoot(pcFile as char):
        define variable json as JsonObject no-undo.
        json = ReadJsonFile(pcfile).
        if json:Has("root") then
           json = json:GetJsonObject("root").
        return json.   
    end method.
    
/*    /* override (usually with static for each) if importnew need to add foreign value */        */
/*    method protected void ReadNewForParent(pcParent as char, pcValue as char,hTbl as handle):   */
/*         undo, throw new UnsupportedOperationError("ReadNewForParent  in " + Name + " context").*/
/*    end method.                                                                                 */
    
    /* import of JSON tree with root */
    method public void ImportTree(pcfile as char,pcMode as char):
        define variable ltrack as logical no-undo init true.
        ImportTree(ReadJsonRoot(pcfile),pcmode). 
    end method.
    
    /* import of JSON tree  */
    method public void ImportTree(pJson as JsonObject,pcMode as char):
        define variable ltrack as logical no-undo init true.
        if not TableHandle:tracking-changes then
        do:
            ltrack = false.
            TableHandle:tracking-changes = true.
        end.
        ReadTable(pJson,pcmode,yes). 
        finally:
            TableHandle:tracking-changes = ltrack.           
        end finally.       
    end method.
    
    /* single table import of delete (flat - no tree)*/
    method public void ImportDelete(pcfile as char):
        JsonUtil:ImportDelete(this-object,pcfile).
    end method.

    /* single table import of the entity (flat - no tree)*/
    method public void Import(pcfile as char,pcMode as char):
        define variable json   as JsonObject no-undo.
        json = ReadJsonFile(pcfile).
        this-object:Import(json,pcmode). 
    end method.
    
    /* single table import of the entity (flat - no tree)*/
    method public void Import(pJson as JsonObject,pcMode as char):
        define variable ltrack as logical no-undo init true.
        define variable json   as JsonObject no-undo.
        if not TableHandle:tracking-changes then
        do:
            ltrack = false.
            TableHandle:tracking-changes = true.
        end.       
        ReadTable(pjson,pcmode,no). 
        finally:
            TableHandle:tracking-changes = ltrack.           
        end finally.       
    end method.
    
    method protected logical IsModeAppend(pcmode as char):
        if pcMode = "Append" then
           return true. 
        else if pcMode <> "Replace" then
           undo, throw new IllegalArgumentError("Read mode " + quoter(pcMode) +  " passed to ReadTable. Valid values are ""Replace"" or ""Append"" "). 
        return false.
    end method.
    
    /** supports single row in cases that also must handle table */
    method private JsonArray ReadJsonArray (pjsonRoot as JsonObject):
        define variable array       as JsonArray no-undo.   
        do on error undo, leave:   
            array = pjsonRoot:GetJsonArray(SerializeName).
            LastImportNoTopArray = false.  
            catch e as Progress.Lang.Error :
                /* Ignore 16060, which is thrown if the object is not an array */
                if e:GetMessageNum(1) <> 16060 then 
                    undo, throw e.
                
                LastImportNoTopArray = true.  
                array = new JsonArray(). 
                array:Add(pjsonRoot:GetJsonObject(SerializeName)).  
            end catch. 
        end.
        return array.
    end method.
    
    method protected void ReadTable(pjsonRoot as JsonObject,pcMode as char,plTree as log):
        define variable cMsg        as character no-undo.
        define variable array       as JsonArray no-undo.      
        define variable jsonRow     as JsonObject no-undo.      
        define variable i           as integer no-undo.
        define variable lCreateOnly as logical no-undo.
        define variable cKeyFields  as character no-undo. 
        define variable hbuffer as handle no-undo.
        define variable rid as rowid no-undo.
        lCreateOnly = IsModeAppend(pcMode) .
        array = ReadJsonArray(pjsonRoot). 
        /* transaction scope to ensure row is complete and visible when rowCreated is published  */ 
        do i = 1 to array:length transaction:        
            jsonRow = array:GetJsonObject(i).
            if lCreateOnly then
            do on error undo, throw:
                hbuffer = TableHandle:default-buffer-handle.
                count = count + 1.
                hbuffer:buffer-create().
                rid = hbuffer:rowid.
                ReadRow(jsonRow).
                catch e as Progress.Lang.Error :
                    if hbuffer:avail and rid = hbuffer:rowid then
                        hbuffer:buffer-delete(). 
                    count = count - 1.   
                    undo,throw new DataContextError(this-object:Name ,e) .
                end catch.
            end.
            else do:
                cKeyFields = GetClientKeyFields().
                if FindOrCreateFromJSON(cKeyFields,jsonRow) then
                    ReadRow(jsonrow,cKeyFields).
            end.
        end. /* do i = 1 to array:length */   
        OnRowCreated().
      
    end method.   
    
    /* import single row  */
    method private void ReadRow(pcFile as char):        
        define variable lTrack     as logical no-undo.
        define variable array      as JsonArray no-undo.
        define variable cValues    as character extent no-undo.
        define variable jsonObj    as JsonObject no-undo.
        
        lTrack = TableHandle:tracking-changes.
        TableHandle:tracking-changes = true.  
        
        jsonObj = ReadJsonRow(pcFile,no).
        this-object:ReadKey(jsonObj,KeyFields).
        ReadRow(jsonObj,KeyFields).
      
        finally:
            TableHandle:tracking-changes = lTrack.      
        end finally.
    end method.
      
    method public void ReadChild(pParentRow as IRow,pjson as JSONObject):
        ReadChild(pParentRow,pjson,"replace").
    end method.
     
    method protected void ReadChild(pParentRow as IRow,pjson as JSONObject,pcmode as char):
        define variable array as JsonArray no-undo.
        define variable lTrack as logical no-undo.
        define variable i as integer no-undo.
        define variable cJoinfields as character no-undo.
        define variable cJoinValues as character extent no-undo.
        define variable jsonRow as JSONObject no-undo.
        define variable lCreateOnly as logical no-undo.
        
        lCreateOnly = IsModeAppend(pcMode) .
        lTrack = TableHandle:tracking-changes.
        TableHandle:tracking-changes = true.
        
        array = ReadJsonArray(pjson). 
   
        cJoinFields = GetClientJoinFields(pParentRow:SerializeName).
        extent(cJoinValues) = int(num-entries(cJoinFields) / 2).
        if pParentRow:SerializeName eq "cdcTablePolicies" then do:
            do i = 1 to extent(cJoinValues):
                cJoinValues[i] = pParentRow:FieldValue("Name") + "." + pParentRow:FieldValue("TableName").  
            end.            
        end.
        else 
        do:
            do i = 1 to extent(cJoinValues):
                cJoinValues[i] = pParentRow:FieldValue((entry((i * 2) - 1,cJoinFields))). 
            end.    
        end.        
        /* transaction scope to ensure row is complete and visible when rowCreated is published  */ 
        do i = 1 to array:length transaction:        
            jsonRow = array:GetJsonObject(i).
            if FindOrCreateFromJSON(cJoinFields,cJoinValues,GetClientKeyFields(),jsonRow,lCreateOnly) then
            do:   
                /* default ReadRowForParent = ReadRow(pjson,GetClientKeyFields()).
                   @todo   make generic   */                
                ReadRowForParent(pParentRow,jsonRow).
            end.
        end.
        OnRowCreated().
        catch e as Progress.Lang.Error :
        	undo, throw e.	
        end catch.
        finally:
            TableHandle:tracking-changes = lTrack.      
        end finally.
    end method.  
    
    method private char ShowValues(pcValues as char extent):
        define variable i       as integer no-undo.
        define variable cValue as character no-undo.
        do i = 1 to extent(pcValues):
            cValue = cValue 
                    + if pcValues[i]= ? then "?"  
                      else quoter(pcValues[i])
                    + " ".     
        end.
        return right-trim(cValue).    
    end method.
    
    method private logical CompareValues(pcValues1 as char extent,pcValues2 as char extent,pcStrength as char):
        define variable i       as integer no-undo.
        do i = 1 to extent(pcValues1):
            if pcValues2[i] <> ?   
            and not compare(pcValues1[i],"eq",pcValues2[i],pcStrength) then
                return false.  
        end.
        return true.    
    end method.
    
    /** Read key will check if the key in json matches current row
        The action for a non matching key depends on the CanEditKey property
        - Throws error if CanEditKey = false 
        - Change key and publish to children if CanEditKey = true */
         
    method private void ReadKey(pjson as JsonObject,pcKeyFields as char):
        define variable cValues as character extent no-undo.
        define variable cJsonValues as character extent no-undo.
        define variable pRowChange as IRowChange   no-undo.
       
        cValues =  GetValues(TableHandle:default-buffer-handle,pcKeyFields).
        cJsonValues = ReadValuesFromJson(pjson,pcKeyFields).       
        if not CompareValues(cJsonValues,cValues,"case-insensitive") then
        do:
            /** @todo call validateproperty on each value - catch */
            if CanEditKey = false then
                undo, throw new IllegalArgumentError(
                     "Cannot import json file with " 
                     + ShowValues(cJsonValues)
                     + " to " + name + " " + ShowValues(cValues) 
                     + ".").
            else do:
                SetValues(TableHandle:default-buffer-handle,pcKeyFields,cJsonValues).
                KeyChanged:Publish(new RowChange(this-object,SerializeName,pcKeyFields,cValues,cJsonValues)).
            end.
        end.
/*  allow case correction of key?? possibly use validateproperty  see above comment */    
/*   else if not CompareValues(cJsonValues,cValues,"case-sensitive") then     */
/*            SetValues(TableHandle:default-buffer-handle,pcKeyFields,cJsonValues).*/
/*                                                                                 */
    end method.
    
    method private character extent ReadValuesFromJson(pjson as JsonObject,pcFields as char):
        define variable cValues as character no-undo extent.
        define variable i       as integer no-undo.
        extent(cValues) = num-entries(pcFields).
        do i = 1 to extent(cValues):
            cValues[i] = ReadJsonCharValue(entry(i,KeyFields),pjson).
        end.    
        return cValues.
    end method.
       
    /* single row import of the entity (flat no tree) */     
    method public void ImportRow(pcfile as char, i as int).
        define variable hbuf as handle no-undo.
        if this-object:Find(i) then
            ReadRow(pcfile).      
              
    end method.
    
    /* single row import of the entity (flat no tree) */     
    method public void ImportRow(pcfile as char, c as char).      
        if this-object:Find(c) then
            ReadRow(pcfile).      
    end method.
    
    /* single row import of the entity (flat no tree) */     
    method public void ImportRow(pcfile as char, cKeys as char extent).      
        if this-object:Find(cKeys) then
            ReadRow(pcfile).      
    end method.
    
    method public void ImportRowTree(pcfile as char, i as int).
        if this-object:Find(i) then
            ReadRowTree(pcfile).
    end method.
    
    method public void ImportRowTree(pcfile as char, c as char extent).
        if this-object:Find(c) then
            ReadRowTree(pcfile).
    end method.
    
    method public void ImportRowTree(pcfile as char, c as char).
        if this-object:Find(c) then
            ReadRowTree(pcfile).
    end method.
    
    /** read current row from json file with children   */
    method public void ReadRowTree(pcfile as char).
       define variable json       as JsonObject no-undo.
       define variable lTrack     as logical no-undo init ?.
       
       json = ReadJsonRow(pcfile,yes).  
       if not ReadOnly then 
       do:
           lTrack = TableHandle:tracking-changes.
           TableHandle:tracking-changes = true.
       end.       
       this-object:ReadKey(json,KeyFields).
       if ReadOnly then 
           ReadChildren(json).
       else do:    
           lTrack = TableHandle:tracking-changes.
           TableHandle:tracking-changes = true.
           ReadRow(json,KeyFields).
       end.
       finally:
           if lTrack <> ? then
               TableHandle:tracking-changes = lTrack.      
       end finally.
    end method. 
    
      /** set a property  
         @param rowid the rowid of the tt
         @param name property name
         @param value value
       
       */
    method public logical SetProperty(prid as rowid,pname as char,pvalue as char).
        define variable hBuff as handle no-undo. 
        define variable hFld as handle no-undo.
        define variable cMsg as character no-undo.
        define variable cOld as character no-undo.
        define variable cNew as character no-undo.
        hBuff = TableHandle:default-buffer-handle.
        
        hFld = hBuff:buffer-field(pname).
        if hbuff:rowid <> prid then 
            hBuff:find-by-rowid (prid).
       
        cold = hfld:buffer-value.
        ValidateProperty(pName,cold,pValue).
        hfld:buffer-value = pValue.
        cNew = hfld:buffer-value.
        ValueChanged(pName,cold,cNew).
        return true.
        
        catch e as Progress.Lang.Error :
        	if e:GetMessageNum(1) = 7351 then
        	do:
        	    /* change from buffer to property */
        	    cMsg = e:GetMessage(1).
        	    cMsg = replace(cMsg,"buffer-field","Property").
        	    cMsg = replace(cMsg,"buffer " + TableHandle:name,substr(TableHandle:name,3)).
        	    undo, throw new IllegalArgumentError(cmsg).
        	end.
        	undo, throw e.      	
        end catch.
         
    end method.
    
    /** override to manage change - not intended fro validation - validation should have been done */
    method protected void ValueChanged(pcfield as char,poldvalue as char,pnewvalue as char).  
        define variable cOldValues as character extent no-undo.
        define variable cNewValues as character extent no-undo.
        define variable iKey as integer no-undo.
        iKey = lookup(pcfield,KeyFields).
        if iKey > 0 then 
        do:
            /*publish changes (only case-insensitive - no need to update children for 
              case change - no case sensitive keys) */
            if not compare(poldValue,"eq",pnewvalue,"case-insensitive") then
            do:
                cNewValues = GetValues(TableHandle:default-buffer-handle,KeyFields).
                cOldValues = cNewValues.
                coldValues[iKey] = poldvalue.
                KeyChanged:Publish(new RowChange(this-object, SerializeName,KeyFields,cOldValues,cNewValues)).
            end.
        end.    
    end method.
    
    /** override to validate other fields - make sure to call super */
    method protected void ValidateProperty(pcfield as char,poldvalue as char,pnewvalue as char).  
        if lookup(pcfield,KeyFields) > 0 and not CanEditKey then 
        do:
            if not compare(poldValue,"eq",pnewvalue,"case-sensitive") then
                undo, throw new ReadOnlyPropertyError(this-object:Name,poldvalue,pcfield).
        end.
    end method.
     
    /* hook to validate current Buffer */
    method protected void ValidateBuffer(hBuffer as handle):
    
    end method.  

    /* hook to validate children of current buffer  */ 
    method protected void ValidateChildren(hBuffer as handle):
    
    end method.  
    
    /** convert expression for QueryString - unknown = keep as is
          override in subclasses to handle advanced cases */
    method public character ColumnExpression(pcColumn as char,pcOperator as char,pcValue as char):
        return ?.
    end method.
    
    /* call from ColumnExpression override for columns that only can have some values and we want to validate the query */
    method protected char IntegerExpression(pcColumn as char,pcOperator as char,pcValue as char):
        define variable iFrom as integer no-undo.
        define variable iTo as integer no-undo.
        define variable iVal as integer no-undo.
        define variable cExpression as character no-undo.
        define variable i as integer no-undo.
        define variable cColName as character no-undo.
        define variable cVallist as character no-undo.
        /* support range  as "column eq 4-100" ( still in use for extent???)  */
        if num-entries(pcValue) > 1 or num-entries(pcValue,"-") = 2 then 
        do:
            ccolName = entry(num-entries(pccolumn,"."),pccolumn,".").
            
            if lookup(pcoperator,"=,eq") = 0 then
                undo, throw new IllegalArgumentError("The only valid operator for " + cColname + " with list of values or range of values is equals (eq,=)"). 
             
            if num-entries(pcValue,"-") = 2 then
            do:
                iFrom = int(entry(1,pcValue,"-")).
                iTo   = int(entry(2,pcValue,"-")).
                if iFrom > iTo then 
                    undo, throw new IllegalArgumentError("Invalid values in " + cColname + " range value " + quoter(pcValue)). 
                 
                return  "(" 
                        + pcColumn + " >= " + quoter(iFrom) 
                        + " and " 
                        + pcColumn + " <= " + quoter(iTo) 
                        + ")". 
            end.
            else do:
                /* convert comma separeted list of values to individual expressions */
                do i = 1 to num-entries(pcValue):
                    iVal = int(entry(i,pcValue)).
        
                    if not ValidValue(pccolumn,iVal) then
                    do:
                        cVallist =  ValidValueList(pccolumn).
                        undo, throw new IllegalArgumentError(
                                        "Invalid " + ccolName + " value list " +  quoter(pcValue) + " found in query expression."
                                       + (if cVallist > "" 
                                          then " The valid values are " +  cVallist + "."
                                          else "") 
                                        ). 
                    end. 
                    cExpression = cExpression  
                                 + (if i = 1 then "" else " or ") 
                                 + pcColumn + " " + pcOperator +  " " + quoter(iVal). 
                    
                end. 
                return cExpression.
            end.        
        end.
        else if lookup(pcOperator,"=,eq") > 0 then 
        do:                                                                                                       
            if not ValidValue(pccolumn,int(pcValue)) then
            do:        
                cVallist =  ValidValueList(pccolumn).
                undo, throw new IllegalArgumentError(
                         "Invalid " + pccolumn +  " value " + quoter(pcValue) + " found in query expression."
                         + (if cVallist > "" then " The valid values are " +  cVallist + "." else "")
                       ).
            end. 
        end.
        else return ?. 
        
    end method.  
    
    /** currently used by integerExpression only
       override in subclasses if validation needed in query */ 
    method protected logical ValidValue(pcColumn as char,pcValue as char):
        return true.
    end.
    
    /** currently used by integerExpression only
       override in subclasses if validation needed in query */ 
    method protected logical ValidValue(pcColumn as char,piValue as int):
        return true.
    end.
    
    /** currently used by integerExpression only
       override in subclasses if validation needed in query */ 
    method protected logical ValidValue(pcColumn as char,piValue as int64):
        return true.
    end.
    
    method protected logical ValidValue(pcColumn as char,plLog as logical):
        return true.
    end.
      
    /** currently used by integerExpression only  
       override in subclasses if validation needed in query */ 
    method protected char ValidValueList(pcColumn as char):
        return "".
    end method.
    
    method public character ColumnSortSource(pcColumn as char).
/*        if num-entries(pcColumn,".") > 1 then                                                             */
/*        do:                                                                                               */
/*            undo, throw new IllegalArgumentError("Reference " + quoter(pcColumn) + " in sort expression").*/
/*        end.                                                                                              */
        return pcColumn.
    end method.
    
      /* optional call back from context tree. 
        called when parse is complete
         override to return json  to export instead  of dataset
         returns unknown to use standard dataset. write-json  */
    method public JSONObject GetJSONExport(tree as IContextTree):
        return ?.
    end.   
     
     
    /** qualify columns for QueryString parsing
       subclasses should override to handle advanced cases like 
        qualified collection filters 
      */
    method public character ColumnSource(pcColumn as char):
        define variable hField  as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable cMsg as character no-undo. 
        define variable dectst as dec  no-undo.
        define variable lmsgok as logical no-undo.
        define variable cBuffer as character no-undo.
        define variable cField as character no-undo. 
        define variable hCntxt as IDataAdmincontext no-undo.
        define variable ibracket as integer no-undo.
        define variable cBracket as character no-undo.
        if num-entries(pcColumn,".") > 1 then
        do:
            cBuffer = entry(1,pcColumn,".").
            cField  = entry(2,pcColumn,".").
            hCntxt = ContextScope:GetContext(cBuffer).
            if valid-object(hCntxt) then
            do:
/*                AddJoinTable(hcntxt).*/
                return hCntxt:ColumnSource(cField).
            end.
        end.            
        else
        do on error undo, throw:
            ibracket = index(pcColumn,"[").
            if ibracket > 1 then
            do:
                cBracket = substr(pcColumn,ibracket).
                pcColumn = substr(pcColumn,1,ibracket - 1).
            end.    
            hBuffer = TableHandle:default-buffer-handle.
            hField = hBuffer:buffer-field(pcColumn). /* throw if wrong for now */
            return hBuffer:name + "." + pcColumn + if ibracket > 1 then cBracket else "".
           
            catch e as Progress.Lang.Error :
                cMsg = e:GetMessage(1).
                if e:GetMessageNum(1) = 7351 then
                do:
                   if pccolumn = "false" or pccolumn = "true" then 
                       cMsg = "Unquoted logical value " + pccolumn + " found in query expression. All values must be quoted."   .
                   else do:
                      do on error undo, throw:
                          dectst = dec(pccolumn).
                          /* we only get here if numeric ref */
                          cMsg = "Unquoted numeric value " + pccolumn + " found in query expression. All values must be quoted.".
                          catch e2 as Progress.Lang.Error :
                             /* num test failed, show standard missing field error */ 
                             lmsgok = true.            		
                          end catch. 
                       end.
                       if lmsgok then 
                       do:
                           cMsg = replace(cMsg,"buffer-field ","").
                           cMsg = replace(cMsg,"buffer tt",""). 
                           cMsg = replace(cMsg,"(7351)","").
                           if pcColumn EQ "NOT" OR pcColumn EQ "IN" OR pcColumn EQ "WAS" OR pcColumn EQ "FOUND"  then 
                           /* replace only first occurence of NOT or IN, now WAS and FOUND also- PSC00304601*/
                               cMsg = QUOTER(SUBSTRING(cMsg,INDEX(pcColumn,cMsg) + 1, LENGTH(pcColumn))) + SUBSTRING(cMsg,LENGTH(pcColumn) + 1).
                           else 
                               cMsg = replace(cMsg,pcColumn + " ",quoter(pcColumn) + " ").
                       end.
                   end.        
                end.    
                undo, throw new IllegalArgumentError(cMsg).
            end catch.
        end.
    end method.
    
    method protected void Destroy().
        /* did cause error once.. rcode out of synch */
        delete object this-object no-error.
    end method.
     
    /** returns the query with the values inserted according to GetJoinFields 
        @param parentRow IRow of psarent */ 
    method public character GetChildQuery(pParentRow as IRow).
        define variable cJoinFields as character no-undo.
        cJoinFields = GetJoinFields(pParentRow:SerializeName).
        if cJoinfields = "" or cJoinfields = ?  then
            undo, throw new IllegalArgumentError(this-object:GetClass():TypeName + ".GetJoinFields() has no join for parent " + quoter(pParentRow:SerializeName)).
    
        return "preselect " + GetJoinExpression(pParentRow,cJoinFields) .
    end method.
    
    /** returns the server query with the values inserted according to GetServerJoinFields        
        @param parentRow IRow of psarent */ 
    method public character GetServerChildQuery(pParentRow as IRow).
        define variable cJoinFields as character no-undo.
        /* we cucrrently only use client join for server child query since we have the values */
        /* we could add a Getter or hook of some sort to contro this if necessary */
        /*  if GetUse<XXX> (pParentRow:SerializeName) then                                                                   */
        /*        cJoinFields = GetServerJoinFields(pParentRow:SerializeName).
            else  ..  */
        cJoinFields = GetJoinFields(pParentRow:SerializeName).
        if cJoinfields = "" or cJoinfields = ? then
            undo, throw new IllegalArgumentError(this-object:GetClass():TypeName + ".GetServerJoinFields() has no join for parent " + quoter(pParentRow:SerializeName)).
  
        return "for " + GetJoinExpression(pParentRow,cJoinFields) .
    end method.
    
    /** returns a query with a join expression based on GetJoinFields 
           @param serializename of parent   */
    method public character GetJoinQuery(parentname as character).
        define variable cExpression as character no-undo.
        define variable cjoinFields as character no-undo.
        define variable i as integer no-undo.
        define variable joincntxt as IDataAdminContext no-undo.
        joincntxt = ContextScope:GetContext(parentname).
        if not valid-object(joincntxt) then
            undo, throw new IllegalArgumentError("Context not found for join with " + quoter(parentname)).
        cJoinFields = GetJoinFields(joincntxt:TableHandle:serialize-name).
        if cJoinfields = "" or cJoinfields = ? then
            undo, throw new IllegalArgumentError("JoinFields not defined for parent " + quoter(joincntxt:TableHandle:serialize-name)).
        cExpression = GetJoinExpression(joincntxt:TableHandle:name,cJoinfields).
        return cExpression.
    end method.
    
    /** returns a query with a join expression based on GetServerJoinFields 
           @param serializename of parent   */
    method public character GetServerJoinQuery(parentname as character).
        define variable cExpression as character no-undo.
        define variable cjoinFields as character no-undo.
        define variable joincntxt as IDataAdminContext no-undo.
        joincntxt = ContextScope:GetContext(parentname).
        if not valid-object(joincntxt) then
            undo, throw new IllegalArgumentError("Context not found for join with " + quoter(parentname)).
        cJoinFields = GetServerJoinFields(joincntxt:TableHandle:serialize-name).
        if cJoinfields = "" or cJoinfields = ? then
            undo, throw new IllegalArgumentError("ServerJoinFields not defined for parent " + quoter(joincntxt:TableHandle:serialize-name)).
        cExpression = GetJoinExpression(joincntxt:TableHandle:name,cJoinfields).
        return cExpression.
    end method. 
    
    /** Override to return a query for a subset of the context  */
    method public character GetNamedQuery(pqname as character):
        return "".
    end method.
    
    /** Override to return correct cased name for a named query   */
    method public character GetNamedQueryName(pqname as character):
        return lc(pqname).
    end method.
      
    /** Override to return a child context that is not included in the default getchildren ,  
        but can be requested by getChild and GetChildCollection and AddChildrenTo overloads that 
        support a list of collections   */
    method protected IDataAdminModel GetNamedChild(pqname as character):
        return ?.
    end method.
    
    method public character GetJoinExpression(pParentRow as IRow,pcJoinfields as char).
        return "each " 
               + TableHandle:name 
               + " where " 
               + GetChildJoinExpression(pParentRow,pcJoinfields).   
    end method. 
    
    method public final character GetJoinExpression(pcJoinTable as char,pcJoinfields as char).
        define variable cExpression as character no-undo.
        define variable i as integer no-undo.
        cExpression = "each " + pcJoinTable.
        do i = 1 to num-entries(pcJoinfields) by 2:
            cExpression = cExpression
                        + (if i = 1 then " where " else " and ")
                        +  pcJoinTable + "." + entry(i,pcJoinFields)
                        + " = "    
                        +  TableHandle:name + "." + entry(i + 1,pcJoinFields) . 
        end. 
        return cExpression.
    end method.
    
    method protected final character GetChildJoinExpression(pParentRow as IRow,pcJoinFields as char):
        define variable cParentKey as character no-undo.
        define variable i as integer no-undo.
        define variable cValues as character extent no-undo.
        define variable cField as character no-undo.
        /*  if join matches key use key properties */
        cParentKey = GetParentFieldsFromJoin(pcJoinFields). 
        if pParentRow:KeyFields = cParentKey then
        do:
            if pParentRow:KeyValue <> ? then
                return GetFieldExpression(pcJoinFields,pParentRow:KeyValue). 
            else if pParentRow:KeyIntValue <> ? then
                return GetFieldExpression(pcJoinFields,string(pParentRow:KeyIntValue)).        
            else
                return GetFieldExpression(pcJoinFields,pParentRow:KeyValues).
        end. 
        /* else if join to different field than key get the key value(s) from the parent
           (note - not all IRow instances has all field values ) */
        else do:
            extent(cValues) = num-entries(cParentKey).
            do i = 1 to num-entries(cParentKey) on error undo, throw :
                cField = entry(i,cParentKey).
                cValues[i] = pParentRow:FieldValue(cField).
                catch e as Error:
                    undo, throw new UnsupportedOperationError("Create child query expression with join " + quoter(pcJoinfields) + "."
                                                             + " Parent row delegate for " + quoter(pParentRow:SerializeName) 
                                                             + " does not return the value for field " +  quoter(cField) + "." ,e).
                end catch.
            end.
            return GetFieldExpression(pcJoinFields,cValues).
        end.       
    end method.
    
    method protected final character GetFieldExpression(pcjoinFields as char,pcKeyValue as char).
        if num-entries(pcjoinFields) <>  2 then
            undo, throw new IllegalArgumentError("Join fields " + quoter(pcjoinFields) 
                                                 + " have the wrong number of entries for value "
                                                 + quoter(pcKeyValue)).
     
        return TableHandle:name + "." + entry(2,pcJoinFields)
               + " = "    
               + quoter(pcKeyValue).
    end method.
    
    method protected final character GetFieldExpression(pcjoinFields as char,pcKeyValues as char extent).
        define variable i as integer no-undo.
        define variable cExpression as character no-undo.
        if num-entries(pcjoinFields) <> extent(pcKeyValues) * 2 then
            undo, throw new IllegalArgumentError("Join fields " + quoter(pcjoinFields) 
                                                 + " have the wrong number of entries for values with "
                                                 + quoter(extent(pcKeyValues)) + " extents").
        do i = 1 to extent(pcKeyValues):
            cExpression = cExpression
                        + (if i = 1 then "" else " and ")
                        +  TableHandle:name + "." + entry(i * 2,pcjoinFields)
                        + " = "    
                        + quoter(pcKeyValues[i]). 
        end. 
        return cExpression.
    end method.
    
     
     /**  Get default buffer handles 
          to use in child query for parent  
        - must match order of GetChildQuery
        @param serializename of parent   
       */
    method public handle extent GetQueryHandles(parentid as char).  
        define variable h as handle extent 1 no-undo.
        h[1] = TableHandle:default-buffer-handle.
        return h.
    end method.
   
    method protected void AssertNotNull(o as Object, arg as char):
        if not valid-object(o) then 
            undo, throw  NullError(program-name(2),arg).
    end method. 
    
    method protected Error NullError(caller as char,arg as char):
        return new UnknownValueError(entry(1,caller," "),arg).
    end method.    
      
	/*-----------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	destructor public DataAdminContext ( ):
        define variable i as integer no-undo.
        delete object SaveDataset no-error. 
        delete object LastSavedDataset no-error. 
        /* may be dynamic */
        if IsDatasetLoaded then
            delete object DatasetHandle no-error.  
        if IsLocal then 
        do:
            do i = 1 to ChildList:Count:
               delete object ChildList:Get(i) no-error.
            end.
            if valid-object(ContextScope)
            and ContextScope:IsLocal /* and not ContextScope:IsLocalShared */ then
                delete object ContextScope.
        end. 
        ContextDeleted:publish ().   
	end destructor.
    
end class.
