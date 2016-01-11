 /*************************************************************/
 /* Copyright (c) 2010 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
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

using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.JsonObject from propath.

using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.RequestInfo from propath.
using OpenEdge.DataAdmin.Binding.Query.AbstractFilteredContext from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.

using OpenEdge.DataAdmin.Message.ITableResponse from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.FetchRequest from propath.

using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.

using OpenEdge.DataAdmin.Lang.QueryString from propath. 
using OpenEdge.DataAdmin.Lang.BeforeQuery from propath. 
using OpenEdge.DataAdmin.Rest.IPageRequest from propath. 

class OpenEdge.DataAdmin.Binding.Query.FilteredContext inherits AbstractFilteredContext:
                                                          
            
	      
    /* NOTE: the public ParentUrl and ParentSerializeName for join 
       is NOT related to the protected Parent context, which is the unfiltered data    */    
    define public property ParentSerializeName    as character  no-undo  
        get.  
        protected set.  
    
    define public property ParentUrl              as character  no-undo  
        get.  
        protected set.  
    
    define protected property JoinFields          as character  no-undo  
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
	
                	    
    /*** constructors ****************************************/ 
    constructor protected FilteredContext (sourcecntxt as IDataAdminContext):
        super(sourcecntxt).  
        CreateQuery().    
    end constructor.
   
   
    /** The filter is an expression of properties and values and operators on 
        a child collection . 
        Note that this context have no information about the parent and CANNOT transform 
        an external key to an internal key. The context must be able to use the value as is 
    **/
     
    constructor public FilteredContext (sourcecntxt as IDataAdminContext,pcparent as char,pcKeyValue as char,pReq as IRequestInfo):
        super(sourcecntxt,pReq).          
        InitParent(pcparent,pcKeyvalue). 
        CreateQuery(). 
        InitRequest(pReq).
        QueryHandle:query-prepare (LocalFilter).
        catch e as Progress.Lang.Error :
        	undo, throw e.	
        end catch. 
    end constructor.
     
    constructor public FilteredContext (sourcecntxt as IDataAdminContext,pcparent as char,pcKeyvalues as char extent,pReq as IRequestInfo):
        super(sourcecntxt,pReq).
        /* ParentValue and ParentURLis not set 
           subclasses need to override all use with use of muliple keys */
        InitParent(pcparent,pcKeyvalues). 
        CreateQuery().
        InitRequest(pReq).
        QueryHandle:query-prepare (LocalFilter). 
    end constructor.
    
    constructor public FilteredContext (sourcecntxt as IDataAdminContext,pReq as IRequestInfo):
        super(sourcecntxt,pReq).
        CreateQuery().    
        InitRequest(pReq).
        QueryHandle:query-prepare (LocalFilter).
    end constructor.
    
    constructor public FilteredContext (sourcecntxt as IDataAdminContext,pcparent as char,pcKeyvalue as char):
        define variable dummy as IRequestInfo no-undo.
        this-object(sourcecntxt,pcParent,pcKeyValue,dummy). 
    end constructor.
   
    /** The filter is an expression of properties and values and operators. 
        It can also be a parent url of form serializename/key or 
        a serializename.property/value expression.  
        Note that this context have no information about the parent and CANNOT transform 
        an external key to an internal key. The context must be able to use the value as is 
    **/
    constructor public FilteredContext (sourcecntxt as IDataAdminContext,pfilter as char):
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
            /*
            /* comma separated keys (no blanks = 1 entry) */
            else if num-entries(pfilter) > 1 and num-entries(pfilter," ") = 1 then
            do:
                assign
                    Filter       = pFilter
                    LocalFilter  = ListExpression(pFilter)
                    lTransformed = true.
            end.
            */     
        end.
        
        CreateQuery().
          
        if not lTransformed then
        do:       
            InitFilter(pfilter).
        end.
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
         
    
    /**
     sets ParentSerializeName, ParentUrl, ParentValue, Joinfields, Filter and LocalFilter 
     uses TableHandle Parent
    */
    method private void InitParent(pcparent as char,pckeyValue as char):
        define variable cWhere as character no-undo.
        assign
            ParentValue         = pcKeyValue  
            ParentSerializeName = pcparent
            ParentUrl           = ParentSerializeName + "/" + pcKeyValue.
         
        InitJoinFields(pcparent).
        InitParentFilter(pcparent,pckeyValue).
        
        if Filter = "" then
            undo, throw new IllegalArgumentError("FilterContext cannot be created for foreign key." 
                                                + " InitParentFilter did not define a Filter was defined with join from "  
                                                + quoter(pcparent) 
                                                + " to " + quoter(Parent:Serializename) + ".").
        
    end method.
    
    method private void InitParent(pcparent as char,pckeyValues as char extent):
        define variable cWhere as character no-undo.
        assign
            ParentValues         = pcKeyValues  
            ParentSerializeName = pcparent
         .
         
        InitJoinFields(pcparent).
        InitParentFilter(pcparent,pckeyValues).
        
        if Filter = "" then
            undo, throw new IllegalArgumentError("FilterContext cannot be created for foreign key." 
                                                + " InitParentFilter did not define a Filter was defined with join from "  
                                                + quoter(pcparent) 
                                                + " to " + quoter(Parent:Serializename) + ".").
        
    end method.
      
    method private void InitJoinFields(pcParent as char):
        if JoinFields = "" then
        do:
            JoinFields          = GetJoinFields(pcParent).
            if JoinFields = ""  or JoinFields = ?  then
                undo, throw new IllegalArgumentError("FilterContext cannot be created for foreign key." 
                                                             + " There is no join specified from " 
                                                             + quoter(pcparent) 
                                                             + " to " + quoter(Parent:Serializename)+ ".").
        end.
   end.                    
        
    
    /** set Filter and LocalFilter from single keyvalue using JoinFields */ 
    method private void InitParentFilter(pcparent as char,pckeyValue as char):
        if JoinFields = "" then
             InitJoinFields(pcparent).       
        assign
            Filter = Model:GetServerChildQuery(pcparent,pckeyValue)
            LocalFilter = Model:GetChildQuery(pcparent,pckeyValue).
    
    end method.

    /** set Filter and LocalFilter from extent keyvalues using JoinFields */ 
    method protected void InitParentFilter(pcparent as char,pckeyValues as char extent):
        if JoinFields = "" then
             InitJoinFields(pcparent).        
        assign
            Filter = Model:GetServerChildQuery(pcparent,pckeyValues)
            LocalFilter = Model:GetChildQuery(pcparent,pckeyValues).
    
    end method.
    
    /**
     sets Filter and LocalFilter from an external filter )
    */
    method private void InitFilter(pFilter as char):
        define variable cQuery as character no-undo.
        define variable  QueryString as QueryString no-undo.       
        define variable lBoth as logical no-undo.
     
        lBoth = TrimQuery(Filter) <> TrimQuery(LocalFilter).    
        
        /* BaseQuery is set in AbstractFilterConstructor to avoid the QueryString class 
          default no-lock, so don't set it blank */ 
        if Filter > "" then
           BaseQuery =  Filter.
       
        Filter = TransformQuery(pfilter).
        
        if lBoth then
        do:
            If LocalFilter > "" then
                BaseQuery =  LocalFilter.
            LocalFilter = TransformQuery(pfilter).
            BaseQuery = LocalFilter.
        end.
        else
           LocalFilter = 'preselect ' + TrimQuery(Filter).
    end method.
    
    method private char TrimQuery(pcQuery as char):
         pcQuery = left-trim(pcQuery).
         entry(1,pcQuery," ") = "".
         return left-trim(pcQuery).
    end.
    
    method protected override handle extent GetBufferHandles():
        if ParentSerializeName > "" then
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
    
    method private character JoinExpression(pckeys as char extent, pcValues as char extent):
        define variable i as integer no-undo.
        define variable cwhere as character no-undo.       
        cWhere = "for each " + TableHandle:name. 
  
        do i = 1 to extent(pcValues):
             cWhere = cWhere
                    + (if i = 1 then " where " else " or ") 
                    + TableHandle:name + "." + pcKeys[i] 
                    + " = " 
                    + quoter(pcValues[i]).   
        end. 
                     
        return cWhere.
        
    end method.
    
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
        
        if ParentSerializeName > "" then
        do:
            parent:CopyForParent(ParentSerializeName,ParentValue,cntxt).
        end.    
        else 
           super:Copy(cntxt).
        
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
               return Parent:Delete(c). 
        end.    
        return false. 
    end.
    
    method public override logical Find(c as char):
        define variable lok as logical no-undo. 
        define variable hBuf as handle no-undo.
        if num-entries(KeyFields) > 1 then
            lok = InvokeInParent("Find",c).
        else
            lok = Parent:Find(c).
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
        define variable hBuf as handle no-undo.
        if num-entries(KeyFields) > 1 then
            lok = InvokeInParent("Find",c).
        else
            lok = Parent:Find(c).
        if lok then
        do:
            hBuf = QueryHandle:get-buffer-handle(1).
            lok = hBuf:avail and TableHandle:default-buffer-handle:rowid = hBuf:rowid.                          
            if not lok then
            do:
                lok = QueryHandle:reposition-to-rowid(TableHandle:default-buffer-handle:rowid) no-error.
            end.
        end.  
        return lok.     
    end method.
    
    method public override IDataAdminCollection GetChildCollection(ckey as char, child as char).
        if this-object:Find(ckey) then
        do:
            if num-entries(KeyFields) > 1 then  
                return Parent:GetChildCollection(GetKeyValues(ckey),child).
            else 
                return Parent:GetChildCollection(ckey,child).
        end.
        return ?.
    end method.
    
    method public override IDataAdminCollection GetChildCollection(ckey as char, pReq as IRequestInfo).
        if this-object:Find(ckey) then
        do:
            if num-entries(KeyFields) > 1 then  
                return Parent:GetChildCollection(GetKeyValues(ckey),pReq).
            else 
                return Parent:GetChildCollection(ckey,pReq).
        end.
        return ?.
    end method.
    
    /* convert collection single key to parent context multiple key values using parent query join info */ 
    method private char extent GetKeyValues(pKey as char):
        define variable i    as integer no-undo.
        define variable j    as integer no-undo.   
        define variable iNumKeys as integer no-undo.
        define variable cVal as character extent no-undo.  
        define variable cField as character no-undo.
        
        iNumKeys = num-entries(KeyFields).
        if iNumKeys > 0 then
        do:
            extent(cVal) = iNumKeys.
            KeyLoop:
            do i = 1 to iNumKeys :
                cField = entry(i,KeyFields).
                do j = 2 to num-entries(JoinFields):
                   if cField = entry(j,JoinFields) then 
                   do:
                       cVal[i] = entry(2,ParentURL,"/"). 
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
        define variable cKeyArray as character extent no-undo.
        cKeyArray = GetKeyValues(pKey).
        case extent(cKeyArray):
            when 2 then 
            do:
                /* core bug workaround */
                c1 = cKeyArray[1].
                c2 = cKeyArray[2].
                lok = dynamic-invoke (Parent,pcCall,c1,c2).
            end.
            otherwise
                undo, throw new UnsupportedOperationError("FilterContext InvokeInParent " + quoter(pcCall) + " with many keys").      
        end.
        return lok.
        
    end method.
    
    /* override if message needs to override to add additional/different tables for join */
    method protected IFetchRequest GetQueryRequest():
        return Parent:GetRequest().
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
            Parent:TransferMatchingRequests(RequestInfo:GetChildren(),msg).
        end.
        
        
        return msg.
        
    end method.    
    
    /* single table import of the entity (flat - no tree)
       with foreign key not in json all records will be imported with 
       blank foreign key and seen as new records. We cannot copy these
       as-is when to the existing since all values may not be present  */     
    method public override void Import(pcfile as char,pcMode as char):         
        
        if ParentSerializeName > "" then
        do:
            if pcMode = "replace" then
                Parent:ImportForParent(ParentSerializeName,ParentValue,pcfile). 
            else if pcMode = "append" then
                Parent:ImportNewForParent(ParentSerializeName,ParentValue,pcfile). 
        end.
        else   
            Parent:Import(pcfile,pcMode). 
        QueryHandle:query-open().    
    end method.
      
    /* single row import of the entity (flat no tree) */     
    method public override void ImportRow(pcfile as char, i as int).
        Parent:ImportRow(pcfile,i).
    end method.
    
    /* single row import of the entity (flat no tree) */     
    method public override void ImportRow(pcfile as char, c as char).
        Parent:Importrow(pcfile,c).
    end method.
    /*
    method public override void ImportTree(pcfile as char).
        Parent:ImportTree(pcfile).
    end method.
    */
    method public override void ReadChild(pcparent as char,pckey as char extent, pjson as JSONObject).
        Parent:ReadChild(pcparent, pckey, pjson).
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
        
        hAfterbuffer = Tablehandle:default-buffer-handle.
        hbuffer = hAfterbuffer:before-buffer.
        hfield  = hAfterBuffer:buffer-field(entry(2,Joinfields)).
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
           
            create Query hBefQuery.
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
        create Query hQuery.
        hQuery:add-buffer(phBefore).
        cQuery = GetBeforeQueryString(pcParentTable,phOrigQuery).    
        
        hQuery:query-prepare (cQuery).
        return hQuery.
    end method.
    
    method protected character GetBeforeQueryString(pcParentTable as char,phOrigQuery as handle):
        define variable beforeQuery as BeforeQuery no-undo.
        define variable hQuery as handle no-undo.
        define variable cSingleValue  as character extent 1 no-undo.
        
        /* create the query to nav */
        if parentserializename > "" then
        do:
            if extent(ParentValues) > 1 then
                beforeQuery = new BeforeQuery(phOrigQuery:prepare-string,pcParentTable,JoinFields,ParentValues).
            else do:
                cSingleValue[1] = ParentValue.
                beforeQuery = new BeforeQuery(phOrigQuery:prepare-string,pcParentTable,JoinFields,cSingleValue).
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
