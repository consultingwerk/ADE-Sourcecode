/*************************************************************/
/* Copyright (c) 2010-2013 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : FilteredContext
    Purpose     : Provide filtered access to another context
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Aug 2010
    Notes       : FilteredContext is a buffer and query used to 
                  control and limit access to the Parent DataAdminContext,
                  which really is a temp-table. 
                  It has the same interface so that the collection
                  that uses it doesn't need to know the difference.
           Note:  It stores instance specific context info like filter 
                  and is unique for a collection and its entitites in difference 
                  from the non query context classes
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.IRowChange.
using OpenEdge.DataAdmin.Binding.Query.AbstractFilteredContext.
using OpenEdge.DataAdmin.Binding.RowImpl.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Lang.BeforeQuery.
using OpenEdge.DataAdmin.Lang.QueryString.
using OpenEdge.DataAdmin.Lang.QueryUtil.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.ITableResponse.
using OpenEdge.DataAdmin.RequestInfo.
using OpenEdge.DataAdmin.Rest.IPageRequest.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.Query.FilteredContext inherits AbstractFilteredContext:
                                                          
    /* NOTE: the public ParentUrl and ParentSerializeName for join 
       is NOT related to the protected Parent context, which is the unfiltered data    */    
    define public property ParentSerializeName    as character  no-undo  
        get.  
        protected set.  
    
    define public property ParentUrl              as character  no-undo  
        get.  
        protected set.  
    
    define protected property LocalFilter         as character  no-undo  
        get.  
        protected set. 
        
  	define public property ParentValue         as character  no-undo  
	    get.  
	    protected set.
	
	define public property ParentValues         as character extent no-undo  
        get.  
        protected set.
    
    define protected property ParentRow          as iRow  no-undo  
        get.  
        protected set.
        
	define private variable mBufferHandles     as handle extent no-undo.  
    define private variable mBaseQueries       as char extent no-undo.  
    
    /*** constructors ****************************************/ 
    constructor protected FilteredContext (sourcecntxt as IDataAdminModel):
        super(sourcecntxt).  
        CreateQuery().    
    end constructor.
    
    constructor protected FilteredContext (sourcecntxt as IDataAdminModel,pParentRow as IRow,pReq as IRequestInfo,pCreate as log):
        super(sourcecntxt,pReq). 
        InitParent(pParentRow). 
        InitRequest(pReq).    
        if pCreate then
        do:
            CreateQuery(). 
            QueryHandle:query-prepare (LocalFilter).
        end.
        catch e as Progress.Lang.Error :
            undo, throw e.  
        end catch. 
    end method.
    
    constructor public FilteredContext (sourcecntxt as IDataAdminModel,pParentRow as IRow,pReq as IRequestInfo):
        this-object(sourcecntxt,pParentRow,pReq,yes). 
    end method.
     
    constructor public FilteredContext (sourcecntxt as IDataAdminModel,pcparent as char,pcKeyValue as char,pReq as IRequestInfo):
        super(sourcecntxt,pReq).          
        InitParent(pcparent,pcKeyvalue). 
        InitRequest(pReq).
        CreateQuery(). 
        QueryHandle:query-prepare (LocalFilter).
        catch e as Progress.Lang.Error :
        	undo, throw e.	
        end catch. 
    end constructor.
     
    constructor public FilteredContext (sourcecntxt as IDataAdminModel,pcparent as char,pcKeyvalues as char extent,pReq as IRequestInfo):
        super(sourcecntxt,pReq).
        /* ParentValue and ParentURLis not set 
           subclasses need to override all use with use of muliple keys */
        InitParent(pcparent,pcKeyvalues). 
        InitRequest(pReq).
        CreateQuery().
        QueryHandle:query-prepare (LocalFilter). 
        
    end constructor.
    
    constructor public FilteredContext (sourcecntxt as IDataAdminModel,pReq as IRequestInfo):
        super(sourcecntxt,pReq).
        InitRequest(pReq).
        CreateQuery().    
        QueryHandle:query-prepare (LocalFilter).
    end constructor.
    
    constructor public FilteredContext (sourcecntxt as IDataAdminModel,pcparent as char,pcKeyvalue as char):
        define variable dummy as IRequestInfo no-undo.
        this-object(sourcecntxt,pcParent,pcKeyValue,dummy). 
    end constructor.
   
    /** The filter is an expression of properties and values and operators. 
        It can also be a parent url of form serializename/key or 
        a serializename.property/value expression.  
        Note that this context have no information about the parent and CANNOT transform 
        an external key to an internal key. The context must be able to use the value as is 
    **/
    constructor public FilteredContext (sourcecntxt as IDataAdminModel,pfilter as char):
        define variable h      as handle no-undo.
        define variable cWhere as character no-undo.
        define variable lTransformed as logical no-undo.
        define variable cparent as character no-undo.     
        super (sourcecntxt).
        BaseQuery =  "for each " + TableHandle:Name.
        /* filter has no quotes - check for parent url or comma separated keys */    
        if index(pfilter,"'") = 0 and index(pfilter,'"') = 0 then
        do:
                /* url is only token and has no quotes  */
            if num-entries(pfilter,"/") = 2 then 
            do: 
                cparent = entry(1,pFilter,"/").
                if num-entries(cparent,".") > 0 then       
                    cparent = entry(1,cparent,".").
                InitParent(cParent,entry(2,pFilter,"/")).
                lTransformed = true.
            end.
        end.
        
        if not lTransformed then
        do:       
            InitFilter(pfilter).
        end.
        CreateQuery().
        QueryHandle:query-prepare (LocalFilter).
       
        catch e1 as IllegalArgumentError:
            undo, throw e1.
        end catch.
        catch e2 as Progress.Lang.Error :
            undo, throw new IllegalArgumentError(e2:GetMessage(1)).          
        end catch. 
    end constructor.
     
    /** init filter from the passed request if necessary 
       (batch criteria is handled in getRequest() */ 
    method protected void InitRequest(pReq as IRequestInfo):
        if valid-object(pReq) and preq:QueryString > "" then
        do: 
           if Filter > "" then
                BaseQuery = Filter.
           InitFilter(preq:QueryString).
        end.
    end.    
    
    method private logical CompareValues(pcValues1 as char extent,pcValues2 as char extent):
        define variable i       as integer no-undo.
        do i = 1 to extent(pcValues1):
            if pcValues2[i] <> ?   
            and pcValues1[i] <> pcValues2[i] then 
                return false.  
        end.
        return true.    
    end method.
      
    method public override void ForeignKeyChanged(pParentChange as IRowChange):
        define variable lFound as logical no-undo.
        define variable cValues as character extent no-undo.
        define variable cForeignKeyFields as character no-undo.
        define variable qutil  as QueryUtil  no-undo.
        define variable cNewQuery as character no-undo.
        if pParentChange:SerializeName = ParentSerializeName then
        do:
            /** @todo - simplify this */  
            if extent(ParentValues) = ? then
            do:
                if ParentValue = pParentChange:OldKeyValues[1] then
                do:
                    assign 
                        lFound = true
                        ParentValue = pParentChange:KeyValues[1] 
                        ParentUrl    = ParentSerializeName + "/" + ParentValue. 
                end.
            end.
            else do:
                if CompareValues(ParentValues,pParentChange:OldKeyValues) then
                do:
                    assign 
                        lFound = true 
                        ParentValues = pParentChange:KeyValues.
                    if valid-object(ParentRow) then
                        ParentRow = pParentChange.    
                end.
            end.        
            if lFound then
            do:
                InitParentFilter(pParentChange).
                /** prepare the query with new foreignfields 
                   - this was here before initParentfilter, we could possible just reopen, but not sure 
                     if overrides exists that adds more to Localfilter */ 
                cForeignKeyFields = Model:GetChildJoinFields(ParentSerializeName).
                qutil = new QueryUtil(Tables). 
                cNewQuery = qutil:ReplaceQueryValues(QueryHandle:prepare-string,cForeignKeyFields,pParentChange:KeyValues).
                QueryHandle:query-prepare(cNewQuery).
                LocalFilter = cNewQuery.           
                if QueryHandle:is-open then 
                    Reopen().
            end.
        end.
    end method.
      
    /* allow override for cases that need more info than keyfields  
     sets ParentSerializeName, ParentUrl, ParentValue or ParentValues,  Filter and LocalFilter 
     uses TableHandle Parent
    */  
    method protected void InitParent(pParentRow as IRow):
        ParentValue = ?.
        ParentSerializeName = pParentRow:SerializeName. 
      
        if pParentRow:KeyValue <> ? then
            ParentValue = pParentRow:KeyValue. 
        else if pParentRow:KeyIntValue <> ? then
            ParentValue = string(pParentRow:KeyIntValue).        
        else
            ParentValues = pParentRow:KeyValues.
        
        if ParentValue <> ? then  
             ParentUrl = ParentSerializeName + "/" + ParentValue.    
        
        if not pParentRow:IsSnapShot then
            ParentRow = pParentRow.    
            
        InitParentFilter(pParentRow).    
    end method.
          
    /**
     sets ParentSerializeName, ParentUrl, ParentValue,   Filter and LocalFilter 
     uses TableHandle Parent
    */
    method private void InitParent(pcParent as char,pckeyValue as char):
         
        InitParent(new RowImpl(Model,pcParent,0,GetParentJoinFields(pcParent),pcKeyValue)).
        
        if Filter = "" then
            undo, throw new IllegalArgumentError("FilterContext cannot be created for foreign key." 
                                                + " InitParentFilter did not define a Filter with join from "  
                                                + quoter(pcparent) 
                                                + " to " + quoter(Model:Serializename) + ".").
        
    end method.
      /**
     sets ParentSerializeName, ParentUrl, ParentValues,  Filter and LocalFilter 
     uses TableHandle Parent
    */
    method private void InitParent(pcparent as char,pckeyValues as char extent):
        InitParent(new RowImpl(Model,pcParent,0,GetParentJoinFields(pcParent),pcKeyValues)).
          
        if Filter = "" then
            undo, throw new IllegalArgumentError("FilterContext cannot be created for foreign key." 
                                                + " InitParentFilter did not define a Filter with join from "  
                                                + quoter(pcparent) 
                                                + " to " + quoter(Model:Serializename) + ".").
        
    end method.
      
    method protected final char GetJoinFields():
        define variable cJoinFields as character no-undo. 
        cJoinFields  = GetJoinFields(ParentSerializeName).
        if cJoinFields = ""  or cJoinFields = ?  then
            undo, throw new IllegalOperationError("FilterContext cannot realize foreign key."
                                                             + " There is no join specified from parent "
                                                             + quoter(ParentSerializeName)
                                                             + " to " + quoter(Model:Serializename)+ ".").
        return cJoinFields. 
    end.
         
    method protected final void InitParentFilter(pParent as IRow):
        assign
            Filter = Model:GetServerChildQuery(pParent)
            LocalFilter = Model:GetChildQuery(pParent).
        
        if Filter = "" then
            undo, throw new IllegalArgumentError("FilterContext cannot be created for foreign key." 
                                                + " No Filter is defined from parent "  
                                                + quoter(pParent:Serializename) 
                                                + " to " + quoter(Model:Serializename) + ".").
            
    end method. 
    
    /**
     sets Filter and LocalFilter from an external filter )
    */
    method protected final void InitFilter(pFilter as char):
        define variable cQuery as character no-undo.
        define variable  QueryString as QueryString no-undo.       
        define variable lBoth as logical no-undo.
        
        if Filter = "" then Filter = BaseQuery.    
        QueryString = new QueryString(pFilter,this-object). 
    
        lBoth = TrimQuery(Filter) <> TrimQuery(LocalFilter).   
        
        /* BaseQuery is set in AbstractFilterConstructor to avoid the QueryString class 
           default no-lock, so don't set it blank */ 
        if Filter > "" then
            BaseQuery = Filter.
        Filter = QueryString:BuildQueryString(Tables).
    
        if lBoth then
        do:
            if LocalFilter > "" then
                BaseQuery =  LocalFilter.
            
            LocalFilter = 'preselect ' + TrimQuery(QueryString:BuildQueryString(Tables)).
            BaseQuery = LocalFilter.
        end.
        else
            LocalFilter = 'preselect ' + TrimQuery(Filter).
    end method.
 
    
    /** add join buffer - called from columnSource overrides when parent columns
                          are added to query 
        not very robust - assumes BaseQuery and Tables is set                   
    */ 
    method protected logical AddJoinTable(pcntxt as IDataAdminContext):
        define variable hCurrentHandles as handle extent no-undo.
        define variable i               as integer no-undo.
        define variable hBuffer         as handle  no-undo.
        hBuffer = pCntxt:TableHandle:default-buffer-handle.
        /* admit to our lack of robustness */
        if Filter = "" or Filter = ? then 
            undo, throw new IllegalOperationError("AddJoinTable cannot be called when the Filter is not defined.").
        if LocalFilter = "" or LocalFilter = ? then
        do:
            LocalFilter = "preselect " + TrimQuery(Filter).
        end.    
        if lookup(hBuffer:name,Tables) = 0 then
        do:
            hCurrentHandles = GetBufferHandles(). 
            extent(mBufferHandles) = ?.
            extent(mBufferHandles) = extent(hCurrentHandles) + 1.
            do i = 1 to extent(hCurrentHandles):
                mBufferHandles[i] = hCurrentHandles[i]. 
            end. 
            mBufferHandles[extent(mBufferHandles)] = hBuffer.
            Filter = Filter  
                      + ", " + Model:GetServerJoinQuery(pcntxt:name).
            LocalFilter = LocalFilter  
                      + ", " + Model:GetJoinQuery(pcntxt:name).
            return true.
        end. 
        return false. 
    end method.
    
    method protected override handle extent GetBufferHandles():
        if extent(mBufferHandles) <> ? then
            return mBufferHandles.
        else if ParentSerializeName > "" then
            return Model:GetQueryHandles(ParentSerializeName).
        else
            return super:GetBufferHandles(). 
    end method.    
    
    
    /*
    /* convert comma separated values to where clause */
    method private character ListExpression(pcValues as char):
        define variable i as integer no-undo.
        define variable cwhere as character no-undo.       
        cWhere = "for each " + TableHandle:name. 
  
        do i = 1 to num-entries(pcValues):
             cWhere = cWhere
                    + (if i = 1 then " where " else " or ") 
                    + TableHandle:name + "." + KeyFields 
                    + " = " 
                    + quoter(entry(i,pcValues)).   
        end. 
                     
        return cWhere.
        
    end method.
    */
    
   
    /*** protected methods ****************************************/ 
    method protected override void RowCreated().       
        Reopen().
        OnRowCreated().
    end method.
    
    method protected override void RowDeleted(). 
        Reopen().
        OnRowDeleted().
    end method. 
    
       /*** methods ****************************************/  
       
    method public override void Copy(cntxt as IDataAdminContext):
        define variable oParentRow  as IRow no-undo.
        oParentRow = GetParentRow().
        if valid-object(oParentRow) then
            Model:CopyForParent(oParentRow,cntxt).
        else 
            super:Copy(cntxt).
        
        QueryHandle:query-open().
    end method.   
    
    method public override void CreateRow(entity as IDataAdminElement):
        define variable oParentRow  as IRow no-undo.
        oParentRow = GetParentRow().
        if valid-object(oParentRow) then
            Model:CreateRowForParent(oParentRow,entity).
        else 
            super:CreateRow(entity).
        
        QueryHandle:query-open().
    end method.   
    
    
    /** TableRefreshed  
    **/          
    method public override void TableRefreshed(msg as ITableResponse):    
        Reopen().
    end method.   
    
    method public override logical Delete(c as char):
        if this-object:Find(c) then
        do:
           if num-entries(KeyFields) > 1 then
               return InvokeInParent("Delete",c).
           else
               return Model:Delete(c). 
        end.    
        return false. 
    end.
    
    method public override logical Find(c as char):
        define variable lok as logical no-undo. 
        define variable hBuf as handle no-undo.
        if num-entries(KeyFields) > 1 then
            lok = InvokeInParent("Find",c).
        else
            lok = Model:Find(c).
        if lok then
        do:
            hBuf = QueryHandle:get-buffer-handle(1).
            lok = TableHandle:default-buffer-handle:rowid = hBuf:rowid.                          
            if not lok then
            do:
                lok = QueryHandle:reposition-to-rowid(TableHandle:default-buffer-handle:rowid) no-error.
                if lok and not hBuf:avail then
                    QueryHandle:get-next.            
            end.
        end.  
        return lok.     
    end method.
    
    method public override logical CanFind(c as char):
        define variable lok as logical no-undo. 
        if num-entries(KeyFields) > 1 then
            lok = InvokeInParent("Find",c).
        else 
            lok = Model:Find(c).
        if lok then
            return CanFindCurrentModel().
        return false.     
    end method.
    
        /* qualify columns for QueryString parsing */
    method public override character ColumnSource(pcColumn as char):
        define variable cBuffer as character no-undo. 
        define variable cField as character no-undo. 
        define variable hCntxt as IDataAdmincontext no-undo.
        if num-entries(pcColumn,".") > 1 then
        do:
            cBuffer = entry(1,pcColumn,".").
            cField  = entry(2,pcColumn,".").
            hCntxt = Model:ContextScope:GetContext(cBuffer).
            if valid-object(hCntxt) then
            do:
                AddJoinTable(hcntxt).
                return hCntxt:ColumnSource(cField).
            end.
        end.    
        return super:ColumnSource(pccolumn).
    end method.
   
    method public override character ColumnSortSource(pcColumn as char).
        define variable cBuffer as character no-undo. 
        define variable cField as character no-undo. 
        define variable hCntxt as IDataAdmincontext no-undo.
        /*
        if num-entries(pcColumn,".") > 1 then
        do:
            cBuffer = entry(1,pcColumn,".").
            cField  = entry(2,pcColumn,".").
            
            hCntxt = Model:ContextScope:GetContext(cBuffer).
            if valid-object(hCntxt) then
            do:
                AddJoinTable(hcntxt).
                return hCntxt:ColumnSortSource(cField).
            end.
        end.    
        */
        return Model:ColumnSortSource(pcColumn).
    end method.   
    
    /* convert collection single key to parent context multiple key values using parent query join info */ 
    method private char extent GetKeyValues(pKey as char):
        define variable i    as integer no-undo.
        define variable j    as integer no-undo.   
        define variable iNumKeys as integer no-undo.
        define variable cVal as character extent no-undo.  
        define variable cField as character no-undo.
        define variable cJoinFields as character no-undo.
        iNumKeys = num-entries(KeyFields).
        if iNumKeys > 0 then
        do:
            cJoinFields = GetJoinFields(ParentSerializeName).
            extent(cVal) = iNumKeys.
            KeyLoop:
            do i = 1 to iNumKeys :
                cField = entry(i,KeyFields).
                /* this is a bit misleading and can be simplified... 
                   keyfields and joinfields need to match */
                do j = 2 to num-entries(cJoinFields) by 2:
                   if cField = entry(j,cJoinFields) then 
                   do:
                       if ParentUrl > "" then
                          cVal[i] = entry(2,ParentURL,"/"). 
                       else if extent(ParentValues) >= i then
                          cVal[i] = ParentValues[i] .
                        
                       next Keyloop.
                   end.    
                end.     
                cVal[i] = pKey.
            end.   
        end.
        
        return cval.
    end method.
     
    /* converts a single key operation to multiple key call based on KeyFields and 
       the filter parentjoin */  
    method private logical InvokeInParent(pcCall as char,pKey as char):
        define variable lok as logical no-undo.
        define variable c1 as character no-undo.
        define variable c2 as character no-undo.
        define variable c3 as character no-undo.
        define variable cKeyArray as character extent no-undo.
        cKeyArray = GetKeyValues(pKey).
        case extent(cKeyArray):
            when 2 then 
            do:
                /* core bug workaround */
                c1 = cKeyArray[1].
                c2 = cKeyArray[2].
                lok = dynamic-invoke (Model,pcCall,c1,c2).
            end.
            when 3 then 
            do:
                c1 = cKeyArray[1].
                c2 = cKeyArray[2].
                c3 = cKeyArray[3].
                lok = dynamic-invoke (Model,pcCall,c1,c2,c3).
            end.    
            otherwise
                undo, throw new UnsupportedOperationError("FilterContext InvokeInParent " + quoter(pcCall) + " with many keys").      
        end.
        return lok.
        
    end method.
    
    /* override if message needs to override to add additional/different tables for join */
    method protected IFetchRequest GetQueryRequest():
        define variable tree as IContextTree no-undo.
        define variable msg as IFetchRequest no-undo.
        define variable cJoinFields as character no-undo.
        define variable hds as handle no-undo.
        define variable i as integer no-undo.
        /* mbufferhandles is set from AddJoin which is called when other 
           table references are found in the query 
           BaseQuery and Filter will already reflect the join(s) */ 
        if extent(mBufferHandles) <> ? then 
        do:
            tree = new ContextTree().
            AddTableTo(tree).
            /* we add reposition requests for the joins, but no query. 
               The actual queries are kept as comma separated joins to the main 
               table (MBufferHandles[1]) query  */
            do i = 2 to extent(mBufferHandles):
                tree:SetHandle(mBufferHandles[i]:serialize-name,mBufferHandles[i]).
                cJoinFields = GetJoinFieldsReversed(mBufferHandles[i]:serialize-name).              
                tree:SetJoin(mBufferHandles[1]:serialize-name,mBufferHandles[i]:serialize-name,cJoinFields).
            end.
            hds = tree:GetReadHandle().
            msg = new FetchRequest(Name,Id,hds,no). 
            return msg.
        end.
        else         
            return Model:GetRequest().
    end.
    
    method public final override IFetchRequest GetRequest():
        define variable msg  as IFetchRequest no-undo.
        define variable cWhere as character no-undo. 
        define variable qstr as QueryString no-undo.
        msg = GetQueryRequest().
        cWhere = msg:GetTableQuery(TableHandle:name).
        if cWhere > "" then
        do:
            qstr = new QueryString(Filter,cWhere).
            cWhere = qstr:BuildQueryString(TableHandle:Name).
        end.   
        else 
            cwhere  = Filter.
            
        msg:SetTableQuery(TableHandle:name,cWhere).
     
        if valid-object(RequestInfo) then
        do:           
            if RequestInfo:PageSize > 0 then
            do:
                if type-of(RequestInfo,IPageRequest) then
                    msg:SetTablePageRequest(TableHandle:Name,RequestInfo:PageSize,cast(RequestInfo,IPageRequest):Start).    
                else if RequestInfo:PageSize > 0 then
                    msg:SetTablePageRequest(TableHandle:Name,RequestInfo:PageSize).                   
            end. 
            Model:TransferMatchingRequests(RequestInfo:GetChildren(),msg).
        end.
        return msg.
    end method.    
    
    /* single table import of the entity (flat - no tree) 
       NOTE: not generic - must have overrides for readForParent and readNewForParent
       with foreign key not in json all records will be imported with 
       blank foreign key and seen as new records. We cannot copy these
       as-is to the existing since all values may not be present  */     
    method public override void Import(pcfile as char,pcMode as char):         
       
        if ParentSerializeName > "" then
        do:
            if pcMode = "replace" then
                ImportForParent(pcfile). 
            else if pcMode = "append" then
                ImportNewForParent(pcfile). 
        end.
        else   
            Model:Import(pcfile,pcMode). 
        QueryHandle:query-open().    
    end method.
    
     /* single table import of the entity (flat - no tree) 
       NOTE: not generic - must have overrides for readForParent and readNewForParent
       with foreign key not in json all records will be imported with 
       blank foreign key and seen as new records. We cannot copy these
       as-is to the existing since all values may not be present 
     - The parentserializeName cases would also find root and read children if present - same as importTree      
       There seems to be no reason to keep import and importTree behavior different 
       */
            
    method public override void Import(pJson as JsonObject,pcMode as char):         
       
        if ParentSerializeName > "" then
        do:
            if pcMode = "replace" then
                ImportForParent(pJson). 
            else if pcMode = "append" then
                ImportNewForParent(pJson). 
        end.
        else   
            Model:Import(pJson,pcMode). 
        QueryHandle:query-open().    
    end method.
    
      /* import of the entity in a tree (will )   
       NOTE: not generic - must have overrides for readForParent and readNewForParent
       with foreign key not in json all records will be imported with 
       blank foreign key and seen as new records. We cannot copy these
       as-is to the existing since all values may not be present  
      - This handles all cases import() handles (the only diference is that this would not 
        give error if root exists - seems unimportant)  
       */     
    method public override void ImportTree(pJson as JsonObject,pcMode as char):         
        if ParentSerializeName > "" then
        do:
            if pcMode = "replace" then
                ImportForParent(pJson). 
            else if pcMode = "append" then
                ImportNewForParent(pJson). 
        end.
        else   
            Model:ImportTree(pJson,pcMode). 
        QueryHandle:query-open().    
    end method. 
    
    /* single table import of the entity (flat - no tree) 
       NOTE: not generic - must have overrides for readForParent and readNewForParent
       with foreign key not in json all records will be imported with 
       blank foreign key and seen as new records. We cannot copy these
       as-is to the existing since all values may not be present  */     
    method public override void ImportTree(pcfile as char,pcMode as char):         
       
        if ParentSerializeName > "" then
        do:
            if pcMode = "replace" then
                ImportForParent(pcfile). 
            else if pcMode = "append" then
                ImportNewForParent(pcfile). 
        end.
        else   
            Model:ImportTree(pcfile,pcMode). 
        QueryHandle:query-open().    
    end method.
    
    method protected IRow GetParentRow():
        if valid-object(ParentRow) then
             return ParentRow.
        else do: 
            if extent(ParentValues) <> ? then 
                return new RowImpl(Model,ParentSerializeName,0,GetParentJoinFields(ParentSerializeName),ParentValues).
            else 
                return new RowImpl(Model,ParentSerializeName,0,GetParentJoinFields(ParentSerializeName),ParentValue).
        end.
    end method.
    
    method protected void ImportForParent(pcfile as char):
        if ParentSerializeName = "" then 
            undo, throw new IllegalOperationError("ImportForParent cannot be called when ParentSerializeName is not defined.").
        
        Model:ImportForParent(GetParentRow(),pcfile).
    end method.  
    
    method protected void ImportForParent(pJson as JsonObject):
        if ParentSerializeName = "" then 
            undo, throw new IllegalOperationError("ImportForParent cannot be called when ParentSerializeName is not defined.").
        
        Model:ImportForParent(GetParentRow(),pJson).
    end method.  
      
    method protected void ImportNewForParent(pcfile as char):
        if ParentSerializeName = "" then 
            undo, throw new IllegalOperationError("ImportNewForParent cannot be called when ParentSerializeName is not defined.").
        
        Model:ImportNewForParent(GetParentRow(),pcfile).
    end method.  
      
    method protected void ImportNewForParent(pJson as JsonObject):
        if ParentSerializeName = "" then 
            undo, throw new IllegalOperationError("ImportNewForParent cannot be called when ParentSerializeName is not defined.").
        
        Model:ImportNewForParent(GetParentRow(),pJson).
    end method. 
          
    /* single row import of the entity (flat no tree) */     
    method public override void ImportRow(pcfile as char, i as int).
        Model:ImportRow(pcfile,i).
    end method.
    
    /* single row import of the entity (flat no tree) */     
    method public override void ImportRow(pcfile as char, c as char).
        Model:Importrow(pcfile,c).
    end method.
    /*
    method public override void ImportTree(pcfile as char).
        Parent:ImportTree(pcfile).
    end method.
    */
    method public override void ReadChild(parentRow as IRow,  pjson as JSONObject).
        Model:ReadChild(parentRow, pjson).
    end method.
    
    /*
         /* qualify columns for QueryString parsing */
    method public override character ColumnSource(pcColumn as char):
/*        define variable cntxt as IDataAdminContext no-undo.*/
/*        define variable cCollection as character no-undo.  */
/*        define variable cColumn as character no-undo.      */
/*                                                           */
        /*
          @TODO inner join of parent 
        if num-entries(pcColumn,".") > 1 then
        do:
            ccollection = entry(1,pccolumn,".").
            cntxt = Parent:GetChild(ccollection).
            ccolumn = entry(2,pccolumn,".").
            return cntxt:ColumnSource(ccolumn). 
        end.
        */
                
        return super:ColumnSource(pccolumn).
   
    end method.
    */
    method private void UpdateParentKey():
        define variable hQuery as handle no-undo.
        define variable hbuffer as handle no-undo.
        define variable hAfterbuffer as handle no-undo.
        define variable hField as handle no-undo.
        define variable cJoinFields as character no-undo.
        hAfterbuffer = Tablehandle:default-buffer-handle.
        hbuffer = hAfterbuffer:before-buffer.
        cJoinFields = GetJoinFields().
        hfield  = hAfterBuffer:buffer-field(entry(2,cJoinfields)).
        create query hquery.      
        hQuery:add-buffer (hbuffer).
        hquery:query-prepare("for each "  + hBuffer:name).
        hquery:query-open().
        hquery:get-first.
        
        do while hbuffer:avail:
            hAfterBuffer:find-by-rowid (hBuffer:after-rowid).
            if hAfterBuffer:row-state = row-created 
            and (hField:buffer-value = "" or hField:buffer-value = ?) then
               assign hField:buffer-value = ParentValue.
            hquery:get-next.
        end.    
    end method.    
    
    method public override void ValidateChanges(phDsOrRel as handle ):
        define variable hRelNavQuery as handle no-undo.
        define variable hBefNavQuery as handle no-undo.
        define variable hBefQuery as handle no-undo.
        define variable hBefore as handle no-undo.
        define variable hAfter as handle no-undo.
        define variable cParentTable as character no-undo.
        if phDsOrRel:type = "DATASET" then
          super:ValidateChanges(phDsOrRel).
        else do:
            hRelNavQuery = phDsOrRel:query.
           
            hAfter = hRelNavQuery:get-buffer-handle(1).
            hBefore = hAfter:before-buffer.
            cParentTable = phDsOrRel:parent-buffer:name.
            hBefNavQuery = CreateBeforeNavQuery(cParentTable,hBefore,hRelNavQuery).
            /* create the query that matches this object */
           
            create query hBefQuery.
            hBefQuery = CreateBeforeUpdQuery(cParentTable,hBefore).
           
            ValidateDeletes(hBefNavQuery,hBefQuery).
            
            ValidateQueryChanges(hRelNavQuery).   
        end.
     
        finally:
            delete object hBefNavQuery no-error.        
            delete object hBefQuery no-error.       
        end finally.
        
    end method.
    
    method protected handle CreateBeforeNavQuery(pcParentTable as char,phBefore as handle, phOrigQuery as handle):
        define variable beforeQuery as BeforeQuery no-undo.
        define variable cQuery as char no-undo.
        define variable hQuery as handle no-undo.
        define variable cSingleValue  as character extent 1 no-undo.
        /* create the query to nav */
        create query hQuery.
        hQuery:add-buffer(phBefore).
        cQuery = GetBeforeQueryString(pcParentTable,phOrigQuery).    
        
        hQuery:query-prepare (cQuery).
        return hQuery.
    end method.
    
    method protected character GetBeforeQueryString(pcParentTable as char,phOrigQuery as handle):
        define variable beforeQuery as BeforeQuery no-undo.
        define variable hQuery as handle no-undo.
        define variable cSingleValue  as character extent 1 no-undo.
        define variable cJoinFields as character no-undo. 
        /* create the query to nav */
        if parentserializename > "" then
        do:
            cJoinFields = GetJoinFields().
            if extent(ParentValues) > 1 then
                beforeQuery = new BeforeQuery(phOrigQuery:prepare-string,pcParentTable,cJoinFields,ParentValues).
            else do:
                cSingleValue[1] = ParentValue.
                beforeQuery = new BeforeQuery(phOrigQuery:prepare-string,pcParentTable,cJoinFields,cSingleValue).
            end.
           
        end.
        else
            beforeQuery = new BeforeQuery(phOrigQuery:prepare-string).
      
        return beforeQuery:GetQueryString().
    end method.
    
    method protected handle CreateBeforeUpdQuery(pcParentTable as char,phBefore as handle):
        define variable beforeQuery as BeforeQuery no-undo.
        define variable hQuery as handle no-undo.
        define variable cQuery as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cSingleValue  as character extent 1 no-undo.
        create query hQuery.
        iMax = QueryHandle:num-buffers.
         
        do iLoop  = 1 to iMax:
            if phBefore:after-buffer:name = TableHandle:name then
                hQuery:add-buffer(phBefore).
            else    
                hQuery:add-buffer(QueryHandle:get-buffer-handle(iLoop)).
        end.
        cQuery = GetBeforeQueryString(pcParentTable,QueryHandle).    
        hQuery:query-prepare (cQuery).
        return hQuery.
    end method. 
    
    
    method protected override void SearchRequest (pRequestInfo as IRequestInfo,pcParent as char,pcKeys as char extent,input-output pqueryContext as IDataAdminContext):
        define variable i as integer no-undo.
        if not valid-object(pqueryContext) 
        and  pRequestInfo = RequestInfo 
        and pcParent = ParentSerializeName then
        do:
            if extent(pcKeys) = 1 and ParentValue = pcKeys[1] then
                pqueryContext = this-object. 
            else if extent(pcKeys) = extent(ParentValues) then 
            do:
                do i = 1 to extent(pcKeys):
                    if pckeys[i] <> ParentValues[i] then 
                        return.    
                end.        
                pqueryContext = this-object. 
            end.    
        end. 
         
    end method.
    
   
end class.
