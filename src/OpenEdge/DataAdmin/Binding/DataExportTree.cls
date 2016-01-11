 /* ***********************************************************/

 /* Copyright (c) 2013 by Progress Software Corporation       */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : Export a dataset as json 
                  Used by ExortLastSavedTree 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Nov 11 14:40:08 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Binding.AbstractDataTree.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

using Progress.Lang.*.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.DataExportTree inherits AbstractDataTree: 
    define private variable DatasetHandle as handle no-undo.
    
    define public override property NoTopArray as logical no-undo get. set. 
    define public override property TopTable   as char init ?  no-undo 
        get():
            if TopTable = ? then
            do:
                if valid-handle(DatasetHandle) then
                     return DatasetHandle:get-top-buffer (1):name.
            end.
            return TopTable.    
        end. 
        set. 
     
 	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	constructor public DataExportTree (pDataset as handle):
		super ().
		DatasetHandle = pDataset.
		this-object:Write = true.
	end constructor.
	
    method protected override void AddJsonBody(jsonRoot as JsonObject):
        define variable i as integer no-undo.
        define variable hQuery as handle no-undo.
        define variable jsonArray as JsonArray no-undo.
        define variable jsonObject as JsonObject no-undo.
        define variable hBuffer as handle no-undo.
        define variable hStartBuffer as handle no-undo.
        define variable lDelQuery as logical no-undo.
        if DatasetHandle:num-top-buffers > 1 then 
            undo, throw new UnsupportedOperationError("DataExportTree export dataset with more than one top buffer.").
         
        if TopTable > "" then
        do:
            hBuffer = DatasetHandle:get-buffer-handle (TopTable).        
        end.    
        if NoTopArray then 
        do: 
            if not valid-handle(hBuffer) then
                hBuffer =  DatasetHandle:get-top-buffer (1).
            
            hBuffer:find-first ().
            
            if hBuffer:available then
            do:
                jsonObject = GetJsonRow(hBuffer,hBuffer:serialize-name,"").
                jsonRoot:Add(hBuffer:serialize-name,jsonObject).
            end.
        end.
        else do:
            if valid-handle (hBuffer) then
            do:
                create query hQuery.
                hQuery:add-buffer(hBuffer).
                hQuery:query-prepare("for each " + hBuffer:name).
            end.
            else do:    
                hQuery = DatasetHandle:top-nav-query(1).
                hBuffer = hQuery:get-buffer-handle (1).
            end.
            jsonarray = GetJsonArrayFromQuery(hQuery,hBuffer:serialize-name,hBuffer:name,"").
            jsonRoot:Add(hBuffer:serialize-name,jsonArray).
        end.
            
    end method.
    
    method protected override void AddJsonTables(pjson as JsonObject,pcParent as char,phParent as handle):
        define variable hQuery as handle no-undo.
        define variable hRelQuery as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable jsonarray as JsonArray no-undo.
        define variable hRelation as handle no-undo.
        define variable i as integer no-undo.
        define variable cHideFlds as character no-undo.
        define variable cRelflds as character no-undo.
        define variable ifld as integer no-undo.
        define variable hParentField as handle no-undo.
        define variable cParentfield as character no-undo.
        define variable cParentValue as character no-undo.
        define variable cQuery       as character no-undo.
        define variable cChildField  as character no-undo.
        /* cannot use the relation query since the GetJsonArrayFromQuery is in a super 
           and the parent record avaialable here does not propagate upwards (or something.. possibly bug)
           so the join of child.fieldname = parent.fieldname fails miserably sonce the super parent buffer remains 
           positioned to the first parent */
       
        do i = 1 to  phparent:num-child-relations:
            hRelation = phparent:get-child-relation(i).
            hBuffer = hRelation:child-buffer.
            hRelQuery = hRelation:query.
            cRelflds = hRelation:relation-fields.
            create query hQuery.
            hQuery:add-buffer(hBuffer). 
            
            cQuery = "for each " + hBuffer:name.
            do ifld = 1 to num-entries(cRelflds) by 2:
                assign
                    cParentField = entry(ifld,cRelflds) 
                    cChildField =  entry(ifld + 1,cRelflds) 
                    hParentfield = phParent:buffer-field (cParentField) 
                    cParentValue = hParentfield:buffer-value 
                    cQuery = cQuery + (if ifld = 1 then " where " else " and ")  
                           + hBuffer:name + "." + cChildField + " = " + quoter(cParentValue)  
                    cHideFlds = cHideFlds + (if cHideFlds = "" then "" else ",") + cChildField . 
            end.    
            hQuery:query-prepare (cQuery).
            jsonarray = GetJsonArrayFromQuery(hQuery,hBuffer:serialize-name,hBuffer:name,cHideFlds).
            if valid-object (jsonarray)  then
                pjson:Add(hBuffer:serialize-name,jsonarray).  
            delete object hquery.
        end.
    end method.
    
	method override public handle GetWriteHandle(  ):
	    return DatasetHandle.
	end method.
        
	method public void ExportToFile(pcFile as char):
	    define variable json as JsonObject no-undo.
	    if UseDataset and NoTopArray = false and HasRowListener = false then
        do: 
            DatasetHandle = GetWriteHandle().
            /* the json-write parameter is OmitRoot, opposite of IncludeRoot */
            DatasetHandle:write-json ("File",pcFile,yes,"UTF-8",no,if IncludeRoot = yes then no else yes). 
        end.
        else do:
            json = GetJSON().
            json:WriteFile(pcFile,yes).
        end.    
    end.    
                   
	method public override void SetFieldHandler(pname as char,phandler as Object):
        undo, throw new UnsupportedOperationError("SetFieldHandler in DataExportTree is not implemented.").
    end method.
    
    method public override  Object GetFieldHandler(pname as char) :
        undo, throw new UnsupportedOperationError("GetFieldHandler in DataExportTree is not implemented.").
    end method.
      
  
end class.