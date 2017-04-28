 /* ************************************************************/
 /* Copyright (c) 2010 - 2016 by Progress Software Corporation */
 /*                                                            */
 /* All rights reserved.  No part of this program or document  */
 /* may be  reproduced in  any form  or by  any means without  */
 /* permission in writing from Progress Software Corporation.  */
 /**************************************************************/
 /*------------------------------------------------------------------------
    File        : ContextTree
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Aug 16 20:44:10 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Binding.AbstractDataTree from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using Progress.Json.ObjectModel.JsonArray from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using Progress.Lang.AppError from propath.
using Progress.Lang.Error from propath.
using Progress.Lang.Object from propath.

routine-level on error undo, throw.
class OpenEdge.DataAdmin.Binding.ContextTree inherits AbstractDataTree implements IContextTree: 
    define private variable mSummary as character no-undo.
    define variable Counter as integer no-undo.
    define variable mDataset as handle no-undo.
    
    define temp-table ttTable no-undo
        field name       as char
        field num        as int
        field DataHandle as handle
        field serializeNameOverride as char
        field FieldList  as char
        field rid        as rowid
        field parent     as char
        field joinfields  as char
        field reposJoin   as logical 
        field newhandle   as handle
        field filter as char
        field QueryHandle as handle
        field ViewBuffers as char
        field Fieldhandler as Object
  
      index num as primary num  
      index name as unique name.  
    
    define buffer bttTable for ttTable.
    
	define public property Parse as logical no-undo get. set. 
	
	define public property Server as logical no-undo get. set. 
    
    define public override property NoTopArray as logical no-undo 
        get. 
    
        set (plnoarray as log):
            /* This is currentluy only supported for DataExportTree  */ 
            if plNoArray then undo, throw 
                new UnsupportedoperationError("Cannot set NoTopArray to true for ContextTree.").
        end.     
    
    define public override property TopTable as char no-undo  
        get():
            define buffer bTable for ttTable.
            for each btable by btable.num:
                if valid-handle(btable.DataHandle) then
                do:
                    if btable.DataHandle:type = "dataset" then
                    do:  
                        return btable.DataHandle:get-buffer-handle (1):name. 
                    end.
                    else do: 
                        return btable.DataHandle:name. 
                    end.
                end.
                return ?.
            end. 
        end.  
        set (pctop as char):
            /* This is currently only supported for DataExportTree  */ 
            undo, throw 
                new UnsupportedoperationError("Cannot set TopTable for ContextTree.").
        end.     
    
    method private void AddHandle(cname as char, h as handle):
        find ttTable where ttTable.name = cname no-error.
        if not avail ttTable then this-object:add(cname).
        ttTable.datahandle = h.
    end method.
    
    method private void Add(cname as char):
        Counter = Counter + 1. 
        create ttTable.
        assign ttTable.name = cname 
               ttTable.num = counter.
    end method.    
    
    method private void UpdateJoin(cparent as char,cname as char,cfields as char,plRepos as log):      
        find ttTable where ttTable.name = cname no-error.
        if not avail ttTable then this-object:add(cname).
        assign ttTable.parent = cparent 
               ttTable.joinfields = cfields
               ttTable.reposJoin = plRepos.
    end method.    
   
    method private void UpdateFilter(pname as char,pfilter as char):      
        find ttTable where ttTable.name = pname no-error.
        if not avail ttTable then this-object:add(pname).
        
        ttTable.filter  = pfilter.
    end method.    
     
    method private void UpdateFieldHandler(pname as char,pFieldHandler as Object):      
        find ttTable where ttTable.name = pname no-error.
        if not avail ttTable then this-object:add(pname).
        ttTable.FieldHandler  = pFieldHandler.
    end method.    
    
    method private void UpdateQuery(pname as char,pQuery as handle,pbuffers as char):      
        find ttTable where ttTable.name = pname no-error.
        if not avail ttTable then this-object:add(pname).
        assign
            ttTable.QueryHandle  = pQuery
            ttTable.ViewBuffers  = pbuffers.
     
    end method.  
    
    method public void SetName(cname as char):
        AssertNotNull(cname,"SetName()","name").
        this-object:add(cname).
    end method.
    
    method public void SetList(cname as char,cList as char):
        AssertNotNull(cList,"SetList()","list").
        this-object:add(cname).
        ttTable.FieldList  = clist.
    end method.
    
    method public void SetJoin(cParent as char,cname as char,cFieldPairs as char):
        AssertNotNull(cParent,"SetJoin()","parent").
        AssertNotNull(cName,"SetJoin()","name").
        AssertNotNull(cFieldPairs,"SetJoin()","fieldPairs").
        UpdateJoin(cparent,cname,cfieldpairs,false).
    end method. 
   
    method public void SetRepositionJoin(pParent as char,pname as char,pFieldPairs as char):
        AssertNotNull(pParent,"SetRepositionJoin()","parent").
        AssertNotNull(pName,"SetRepositionJoin()","name").
        AssertNotNull(pFieldPairs,"SetRepositionJoin()","fieldPairs").
        UpdateJoin(pparent,pname,pfieldpairs,true).
    end method. 
   
    method public void SetQuery(pname as char,pQuery as handle,pbuffers as char):
        AssertNotNull(pname,"SetQuery()","name").
        AssertNotNull(pQuery,"SetQuery()","query").
        AssertNotNull(pbuffers,"SetQuery()","buffers").
        UpdateQuery(pname,pQuery,pbuffers).
    end method. 
   
    method public void SetFilter(pname as char,pFilter as char):
        AssertNotNull(pname,"SetFilter()","name").
        AssertNotNull(pFilter,"SetFilter()","filter").
        UpdateFilter(pname,pfilter).
    end method.
     
    method public override void SetFieldHandler(pname as char,phandler as Object):
        AssertNotNull(pname,"SetFilter()","name").
        AssertNotNull(phandler,"SetFieldHandler()","FieldHandler").
        UpdateFieldHandler(pname,phandler).
    end method
    . 
    method public void SetHandle(pname as char,ph as handle):
        AssertNotNull(pname,"SetHandle()","name").
        AssertNotNull(ph,"SetHandle()","handle").
        addHandle(pname,ph).
    end method.
    
    method public void SetHandle(pname as char, ph as handle,filter as char):
        AssertNotNull(pname,"SetHandle()","name").
        AssertNotNull(pname,"SetHandle()","handle").
        AssertNotNull(ph,"SetHandle()","filter").
        addHandle(pname,ph).    
        ttTable.filter  = filter.
    end method.
    
    method public void SetHandle(pname as char, ph as handle, rid as rowid):
        AssertNotNull(pname,"SetHandle()","name").
        AssertNotNull(ph,"SetHandle()","handle").
        AssertNotNull(string(rid),"SetHandle()","rowid").
        addHandle(pname,ph).     
        ttTable.rid  = rid.
    end method. 
    
    method public handle GetHandle(pname as char):
        
        find bttTable where bttTable.name = pname no-error.
        if not avail bttTable then  
            undo, throw GetIllegalNameError(pname).
        return bttTable.DataHandle.
    end method. 
        
    method public rowid  GetRowid(pname as char):
        find bttTable where bttTable.name = pname no-error.
        if not avail bttTable then  
            undo, throw GetIllegalNameError(pname).
        return bttTable.rid.
    end method.  
    
    method public char   GetFilter(pname as char): 
        find bttTable where bttTable.name = pname no-error.
        if not avail bttTable then  
            undo, throw new IllegalArgumentError("").
        return bttTable.filter.
    end method. 
    
    method public override Object GetFieldHandler(pname as char).
        find bttTable where bttTable.name = pname no-error.
        if not avail bttTable then  
            undo, throw GetIllegalNameError(pname).
        return bttTable.Fieldhandler.
    end method. 
    
    method public char   GetParent(pname as char): 
        find bttTable where bttTable.name = pname no-error.
        if not avail bttTable then  
            undo, throw GetIllegalNameError(pname).
        return bttTable.parent.
    end method.
     
    method public char   GetFieldPairs(pname as char):
        find bttTable where bttTable.name = pname no-error.
        if not avail bttTable then  
            undo, throw GetIllegalNameError(pname).
        return bttTable.joinfields.
    end method. 
    
	method override public character ToString(  ):
	    define variable cc as character no-undo.
	    cc = super:ToString() + chr(10)
	            + getSummary(  ).
	    return right-trim(cc,chr(10)).  
	end method.
	  
	method private char GetSummary(  ):    
        define variable iCount as integer no-undo.
        define variable hTable as handle no-undo.
        define variable cc as character no-undo.
        for each ttTable on error undo, throw:
            cc = cc + string(ttTable.num ) + " Name: " + ttTable.name 
                 + " Parent: " 
                 + ttTable.parent 
                 + " FieldList: " 
                 + ttTable.fieldlist 
                 + " JoinFields: "
                 + ttTable.joinfields 
                   + " Filter: "
                 + ttTable.filter 
                 + " Handle Type: "
                 + (if valid-handle(ttTable.DataHandle) then ttTable.DataHandle:type else "?")
                 + " Rowid: "
                 + (if ttTable.rid <> ? then string(ttTable.rid) else "?")              
                 + " Tablehandle: "
                 + (if valid-handle(ttTable.DataHandle) 
                    then if ttTable.DataHandle:type = "buffer" 
                         then string(ttTable.DataHandle:Table-handle) 
                         else ""
                    else "")
                 + " Queryhandle: " 
                  + (if valid-handle(ttTable.QueryHandle) 
                    then string(ttTable.QueryHandle) 
                    else "") 
                 + " HasRecs: "
                 + (if valid-handle(ttTable.DataHandle) 
                    then if ttTable.DataHandle:type = "buffer" 
                         then string(ttTable.DataHandle:Table-handle:has-records) 
                         else ""
                    else "")
                
                   + chr(10)   .
        end.
        return if cc = ? then "<empty>" else right-trim(cc,chr(10)).
        
    end method.

    method public override handle GetWriteHandle():
        /* keep table if writecode */
        return CreateDataset("write",WriteCode).
    end method.
    
    
    method public handle GetReadHandle():
        return CreateDataset("read",no).
    end method.
    
    method protected override void AddJsonBody(jsonRoot as JsonObject):
        AddJsonTables(jsonRoot,"",?).
    end method.
     
    method protected override void AddJsonTables(pjson as JsonObject,pcParent as char,phParent as handle):
        define variable json as JsonObject no-undo.
        define variable hQuery as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable jsonarray as JsonArray no-undo.
        define buffer btable for tttable.
        for each btable where parent = pcParent by btable.num  on error undo,throw:
            hQuery = btable.QueryHandle.
            
            if not valid-handle (btable.QueryHandle) then 
            do:
                if btable.DataHandle:type = "dataset" then
                do:  
                    hbuffer = btable.DataHandle:get-buffer-handle (1). 
                end.
                else do: 
                    hbuffer = btable.DataHandle. 
                end.
                if btable.rid <> ? then
                do: 
                    jsonarray = GetJSOArrayFromRow (hbuffer,btable.name,btable.rid ).
                end.
                else if btable.joinfields > "" then 
                do:
                    if index(btable.joinfields,"CdcTablePolicyName") eq 0 then
                    jsonarray = GetJsonArrayFromChildBuffer(hbuffer,btable.name,phParent,btable.joinfields,btable.filter).
                end.    
                else do:
                    jsonarray = GetJsonArrayFromBuffer(hbuffer,btable.name,btable.filter ).
                    if btable.name = "cdcTablePolicies" then do:
                        if pjson:Has("total") then
                            pjson:set("total",Total).
                        else pjson:add("total",Total).
                    end.
                end.     
            end.    
            else do:
                if btable.name = "cdcTablePolicies" then do:
                    /* Simple JSON will be generated when TableList is set to 'YES' and a formatted JSON will be generated when TableList is set to 'NO' */                      
                    if TableList then 
                        jsonarray = GetJsonArrayFromQuery(btable.QueryHandle,btable.name,btable.ViewBuffers,"").  
                    else jsonarray = GetCdcJsonArrayFromQuery(btable.QueryHandle,btable.DataHandle,btable.name,btable.ViewBuffers,"",btable.filter).                                      
                    //Sometimes total property comes as unknown(?), so total json object might not be added to the json.
                    //We need to find total jsonObject and then set it or else add it. 
                    if pjson:Has("total") then
                        pjson:set("total",Total).
                    else pjson:add("total",Total).
                end.                                 
                else do:
                    jsonarray = GetJsonArrayFromQuery(btable.QueryHandle,btable.name,btable.ViewBuffers,"").
                 end.   
            end.    
            if valid-object (jsonarray)  then                 
                pjson:Add(btable.name,jsonarray).
                 
        end.
    end method.
    
    method private JsonArray GetJSOArrayFromRow(pBuffer as handle,pcname as char,prid as rowid):
        define variable jsonArray as JsonArray no-undo.
        define variable hBuffer as handle no-undo.
        create buffer hBuffer for table pBuffer.
        hBuffer:find-by-rowid(prid).
        if hBuffer:avail then
        do:
            jsonArray = new JsonArray().
            jsonArray:Add(GetJSONRow(hBuffer,pcname,"")).
        end.
        return jsonArray.
        finally: 
            delete object hbuffer no-error.
        end.    
    end method.
    
    method private JsonArray GetJsonArrayFromBuffer(pBuffer as handle,pcname as char,pfilter as char):
        define variable jsonArray as JsonArray no-undo.
        define variable hBuffer as handle no-undo.
        define variable hQuery as handle no-undo.
        define variable fil as char no-undo.
        create buffer hBuffer for table pBuffer.
        create query hQuery.
        fil = pfilter.
        hQuery:add-buffer(hBuffer).
        if pfilter = "" or pfilter = ? then 
           pfilter = "for each " + pBuffer:name.
        hQuery:query-prepare (pFilter).
        if pBuffer:name eq "ttCdcTablePolicy" and not TableList then 
            return GetCdcJsonArrayFromQuery(hQuery,pBuffer,pcname,hBuffer:name,"",fil). 
        return GetJsonArrayFromQuery(hQuery,pcname,hBuffer:name,"").
        finally: 
            delete object hQuery no-error.
            delete object hbuffer no-error.
        end.    
    end method.
    
    method private JsonArray GetJsonArrayFromChildBuffer(pBuffer as handle,pcName as char,phParent as handle, pcJoin as char,pFilter as char):
        define variable jsonArray as JsonArray no-undo.
        define variable cvalues as character extent no-undo.
        define variable i as integer no-undo.
        define variable hBuffer as handle no-undo.
        define variable hQuery as handle no-undo.
        define variable hFld as handle no-undo.
        define variable cQuery as character no-undo.
        define variable cflds as character no-undo.
        extent(cValues) = int(num-entries(pcJoin) / 2).
        do i = 1 to extent(cValues):
            hFld = phParent:buffer-field(entry((i * 2) - 1,pcJoin)).
            cvalues[i] = hFld:buffer-value ().
            cflds = cflds + (if i = 1 then "" else ",") + entry((i * 2),pcJoin).
        end.    
        create buffer hBuffer for table pBuffer.
        create query hQuery.
        hQuery:add-buffer(hBuffer).
        cQuery = GetChildQuery(pBuffer,pcJoin,cvalues).
        if pfilter > "" then
              cQuery = cQuery + " and (" + pfilter + ")".
        hQuery:query-prepare (cQuery).
        return GetJsonArrayFromQuery(hQuery,pcname,hBuffer:name,cflds).
        finally: 
            delete object hQuery no-error.
            delete object hbuffer no-error.
        end.    
    end method.
    
    method public character GetChildQuery(hbuffer as handle,pcjoinfields as char,pcKeyValues as char extent).
        return "for each " 
               + hbuffer:name 
               + " where " 
               + GetChildJoinExpression(hbuffer,pcjoinfields,pcKeyValues).   
    end method.
    
    method protected character GetChildJoinExpression(hbuffer as handle,pcjoinfields as char,pcKeyValues as char extent).
        define variable cjoinFields as character no-undo.
        define variable i as integer no-undo.
        define variable cExpression as character no-undo.
        do i = 1 to int(num-entries(pcjoinfields) / 2 ) :
            cExpression = cExpression
                        + (if i = 1 then "" else " and ")
                        +  hbuffer:name + "." + entry(i * 2,pcJoinFields)
                        + " = "    
                        + quoter(pcKeyValues[i]). 
        end. 
        return cExpression.
    end method.
    
    method private handle GetNewHandle(name as char):    
        define buffer bttTable for ttTable.
        find bttTable where bttTable.name = name no-error.
        if avail bttTable then
        do:
             return bttTable.newhandle.
        end.
        return ?.
    end method.  
    
    method private handle CreateDataset(pcmode as char,plKeep as log):
        define variable hds as handle no-undo.
        define variable hParent as handle no-undo.
        define variable hQuery as handle no-undo.
        define variable hbuffer as handle no-undo.
        define variable cFilter as character no-undo.
        create dataset mDataset. 
        mDataset:serialize-name = "root".
         
        for each ttTable on error undo,throw:
            if not valid-handle(ttTable.DataHandle) then 
                undo, throw new AppError("Cannot create dataset. No handle found for " + quoter(ttTable.name)).
            if ttTable.DataHandle:type = "dataset" then
            do:  
                hbuffer = ttTable.DataHandle:get-buffer-handle (1). 
            end.
            else do: 
                hbuffer = ttTable.DataHandle. 
            end.
             
            /* the separation of write and read is a bit loose here. 
            Make sure the filter only is applied for write  */ 
            if pcMode = "write" then     
            do:
                cFilter = ttTable.filter. 
                hQuery = ttTable.QueryHandle.
            end.
            if ttTable.num = 1 then 
            do:
               if pcMode = "write" and ttTable.rid <> ? then 
                   ttTable.newhandle = CreateTopBuffer(hbuffer,ttTable.rid).
               else 
                   ttTable.newhandle = Addbuffer(ttTable.name,hbuffer,cFilter,hQuery).
/*  not for dataset write-json - can be used if we export using json  */
/*               if ttTable.filter > "" then*/
/*               do:                        */
/*                   mdataset:top-nav-query(hbuffer:name):query-prepare ("for each ttTable where ttTable.Name = " + quoter("customer")).*/
/*               end.*/
            
            end.
            else do:
               if ttTable.joinfields  > "" then
               do:
/*                   message ttTable.parent GetNewHandle(ttTable.parent) ttTable.name hbuffer ttTable.joinfields*/
/*                   view-as alert-box.                                                                         */
                 /* to do change to parent name */
                   ttTable.newhandle = AddChild(GetNewHandle(ttTable.parent),ttTable.name,hbuffer,ttTable.joinfields,ttTable.reposJoin,cFilter,hQuery).     
               end.
               else 
                  ttTable.newhandle = Addbuffer(ttTable.name,hbuffer,cFilter,hQuery).          
            end. 
            
            if ttTable.name <> ttTable.newhandle:serialize-name then 
                 ttTable.newhandle:serialize-name = ttTable.name.
/*            if pcMode = "write" and ttTable.serializeNameOverride > "" then        */
/*                ttTable.newhandle:serialize-name =  ttTable.serializeNameOverride .*/
        end. 
        if not plKeep then    
            EmptyTable().
        return mDataset.
    end method.    
    
    method private handle CreateTopBuffer(hBuffer as handle, rid as rowid):
        define variable hTbl as handle no-undo.
        create temp-table htbl.
        
        htbl:create-like(hBuffer).
        htbl:temp-table-prepare (hBuffer:name).
        hBuffer:find-by-rowid(rid).
        htbl:default-buffer-handle:buffer-copy (hBuffer).
        htbl:default-buffer-handle:serialize-name = hbuffer:serialize-name . 
        mDataset:add-buffer(htbl).
        return hTbl:default-buffer-handle. 
    end.    
   
    /* if there is a filter assigned   we create copy of data since 
       the dataset would include all for the buffer and parent relation if applicable.  
       The filter should thus not include parent relations which are handled by the dataset.    
       This RequestInfo is provided from an entity or instance. 
       The query will and must have children for multiple (all possible) parents. 
       (Note: this could also include records for which there is no parent in the dataset, 
              if for example the parent also is filtered. They would not show up in the dataset, but
              this is an unnecesary copy. Difficult to fix as long as we use dataset 
              An alternative is to use native JSON and navigate throught the queries recursively
   */  
    method private handle CreateFilterBuffer(phBuffer as handle, pfilter as char):
        define variable hquery as handle no-undo.
        define variable hnewBuffer as handle no-undo.
        define variable hbuffer as handle no-undo.
        
        hnewBuffer = CreateTableBuffer(phBuffer).
        create buffer hBuffer for table phBuffer.
        create query hquery.
        hQuery:add-buffer(hBuffer).
        hQuery:query-prepare (pfilter).
        hquery:query-open().
        hQuery:get-first().
        do while hBuffer:avail:
            hNewBuffer:buffer-create().
            hnewBuffer:buffer-copy (hBuffer).
            hQuery:get-next().
        end.
        return hnewBuffer. 
        finally:
            delete object hBuffer no-error.
            delete object hQuery no-error.
        end.     
    end.   
    
    method private handle CreateQueryBuffer(phBuffer as handle, phQuery as handle):
        define variable hnewBuffer as handle no-undo.
        define variable hbuffer as handle no-undo.
        
        hnewBuffer = CreateTableBuffer(phBuffer).
        hBuffer = phQuery:get-buffer-handle(phBuffer:name).
        if not phQuery:is-open then
            phquery:query-open().
        phQuery:get-first().
        do while hBuffer:avail:
            hNewBuffer:buffer-create().
            hnewBuffer:buffer-copy (hBuffer).
            phQuery:get-next().
        end.
        return hnewBuffer. 
    end.    
    
    method private handle CreateTableBuffer(phBuffer as handle):
        define variable hTbl as handle no-undo.
        define variable hnewBuffer as handle no-undo.
        create temp-table htbl.
        htbl:create-like(phBuffer).
        htbl:temp-table-prepare (phBuffer:name).
        hnewBuffer = hTbl:default-buffer-handle.
        hnewBuffer:serialize-name = phBuffer:serialize-name . 
        return hnewBuffer. 
    end.    
   
    method public handle AddBuffer(pname as char, hBuffer as handle,pfilter as char,phQuery as handle):
        define variable h as handle no-undo.
        if valid-handle(phQuery) then 
            hBuffer = CreateQueryBuffer(hBuffer,phQuery).
        else if pfilter > "" then 
            hBuffer = CreateFilterBuffer(hBuffer,pfilter).
        else do:    
            create buffer hBuffer for table hBuffer.
            hBuffer:serialize-name = pname.
        end.
        mDataset:add-buffer(hBuffer).
        return hBuffer.
    end.
     
    method public handle AddChild(hParent as handle,pname as char,hchild as handle,link as char,plRepos as log,pcFilter as char,phQuery as handle):
        hchild = AddBuffer(pname,hchild,pcFilter,phQuery).
       
 /*   errors here are pretty badly reported                          */
/*        message                                                      */
/*          "name" name skip                                           */
/*          "link" link skip                                           */
/*           "ds" valid-handle(mDataset)                               */
/*         if valid-handle(mDataset) then mDataset:type else "bad" skip*/
/*           "child" valid-handle(hchild)                              */
/*         if valid-handle(hchild) then hchild:type else "bad" skip    */
/*           "parent" valid-handle(hParent)                            */
/*         if valid-handle(hParent) then hParent:type else "bad"       */
/*         skip                                                        */
/*         view-as alert-box.                                          */
        mDataset:add-relation(hparent,hchild,link,plRepos,yes,yes,no,yes).
     
          /*
        ADD-RELATION ( parent-buffer-handle, child-buffer-handle,  
         [ pairs-list [, reposition-mode [, nested [, not-active [, recursive 
          [, foreign-key-hidden ] ] ] ] ] ]) */ 
        return hchild. 
    end.
    
    method private Error GetIllegalNameError(pname as  char):
        return new IllegalArgumentError(pname + " is not a valid name in this context."). 
    end. 
    
    method private void AssertNotNull(phval as handle, pcMethodname as char, pcArg as char):
        if phval = ? then 
            undo, throw new UnknownValueError(pcMethodname,pcArg).   
    end. 
    
    method private void AssertNotNull(pval as Object, pcMethodname as char, pcArg as char):
        if not valid-object(pval) then 
            undo, throw new UnknownValueError(pcMethodname,pcArg).   
    end. 
    
    method private void AssertNotNull(pcval as char, pcMethodname as char, pcArg as char):
        if pcval = ? then 
            undo, throw new UnknownValueError(pcMethodname,pcArg).   
    end. 
        
    method private void EmptyTable():
        empty temp-table ttTable.
    end.    

end class.
