/* ***********************************************************/
/* Copyright (c) 2013 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Nov 06 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using OpenEdge.DataAdmin.Binding.IDataTree.
using OpenEdge.DataAdmin.Binding.IJsonRowListener.
using Progress.Lang.*.

class  OpenEdge.DataAdmin.Binding.AbstractDataTree abstract implements IDataTree:  
    define protected event AfterJsonRow signature void (pname as char,jsonrow as JsonObject, table-handle htbl ). 

    define public property Write as logical no-undo  get. set. 
    define public property WriteCode as logical no-undo  get. set. 
    define public property Total as int64 no-undo init ? get. set. 
    define public property Success as log no-undo init ?  get. set. 
    define public property UseDataset as logical no-undo 
        init true 
        get. 
        set. 
    
    define public property IncludeRoot as logical no-undo 
        init true
        get.
        set. 
    
    define abstract public property NoTopArray as logical no-undo get. set. 
    define abstract public property TopTable   as char    no-undo get. set. 
         
    define protected property HasRowListener as logical no-undo get. set. 
 
    method abstract public handle GetWriteHandle():
    
    method abstract protected void AddJsonBody(json as JsonObject):
    method abstract protected void AddJsonTables(pjson as JsonObject,pcParent as char,phParent as handle).
    method abstract public void SetFieldHandler(pname as char,phandler as Object) .
    method abstract public Object GetFieldHandler(pname as char) .
  
    method public void AddRowListener(listener as IJsonRowListener):
        AfterJsonRow:Subscribe(listener:AddRowValues).
        HasRowListener = true.
    end method.
      
    method final public JsonObject GetJSON():
        define variable json as JsonObject no-undo.
        define variable json2 as JsonObject no-undo.
        
        json = new JsonObject().
        if success <> ? then
        do:
            json:Add("success",success).
        end.
        if Total <> ? then
        do:
            json:Add("total",Total).
        end.      
        if IncludeRoot then 
        do:
           json2 = new JsonObject().
           json:Add("root",json2).
        end.   
        else 
           json2 = json.   
         
        AddJsonBody(json2).
        
        return json.
    end method.
    
    method protected JsonArray GetJsonArrayFromQuery(phQuery as handle,pcname as char,pbuffers as char,phidefields as char):
        define variable hBuffer as handle no-undo.
        define variable jsonArray as JsonArray no-undo.
        define variable hbuffers as handle extent no-undo.
        define variable i as integer no-undo.
        extent(hbuffers) = num-entries(pbuffers).
        if not phQuery:is-open then
            phquery:query-open().
        phQuery:get-first().
        do i = 1 to num-entries(pbuffers):
            hbuffers[i] = phQuery:get-buffer-handle (entry(i,pbuffers)).
        end.    
        if hbuffers[1]:avail then
        do:
            jsonArray = new JsonArray().
            do while hbuffers[1]:avail:
                do i = 1 to extent(hbuffers):
                    jsonArray:Add(GetJSONRow(hBuffers[i],pcname,phidefields)).
                end.
                phQuery:get-next().
            end.
            return jsonArray.
        end.
        return ?.
    end method.
    
    method protected JsonObject GetJsonRow(hBuffer as handle,pcname as char,phidefields as char):
        define variable jsonRow   as JsonObject no-undo.
        define variable jsonArray as JsonArray no-undo.
        define variable i         as integer no-undo.    
        define variable hfld as handle no-undo.
        define variable cChar as character no-undo.
        define variable dDec as decimal no-undo.
        define variable iInt as integer no-undo.
        define variable iInt64 as int64 no-undo.
        define variable lLog as logical no-undo.
        define variable ddate as date no-undo.   
        define variable ddatetm as datetime no-undo.   
        define variable ddatetmtz as datetime-tz no-undo.   
        define variable htbl as handle no-undo.
 
        JsonRow = new JSONObject(). 
        
        do i = 1 to hbuffer:num-fields:
            hfld = hBuffer:buffer-field(i).
            if hfld:serialize-hidden = false
            and (phidefields = "" or phidefields = ? or lookup(hfld:name,phidefields)  = 0) then
            do:
                
                if hfld:extent > 0  then
                do:
                    jsonArray = GetJsonFieldArray(hfld).
                    JsonRow:Add(hfld:serialize-name,jsonArray).
                end.
                else do:
                    case hfld:data-type: 
                    when "character" then
                        do:  
                            cChar = hfld:buffer-value.
                            JsonRow:Add(hfld:serialize-name,cChar).
                        end.
                        when "decimal" then
                        do:  
                            dDec = hfld:buffer-value.
                            JsonRow:Add(hfld:serialize-name,dDec).
                        end.
                        when "logical" then
                        do:  
                            llog = hfld:buffer-value.
                            JsonRow:Add(hfld:serialize-name,llog).
                        end.
                        when "integer" then
                        do:
                            iInt = hfld:buffer-value.
                            JsonRow:Add(hfld:serialize-name,iInt).
                        end.
                        when "int64" then
                        do:  
                            iInt64 = hfld:buffer-value.
                            JsonRow:Add(hfld:serialize-name,iInt64).
                        end.
                        when "date" then
                        do:  
                            ddate = hfld:buffer-value.
                            JsonRow:Add(hfld:serialize-name,ddate).
                        end.
                        when "datetime" then
                        do:  
                            ddatetm = hfld:buffer-value.
                            JsonRow:Add(hfld:serialize-name,ddatetm).
                        end.
                        when "datetime-tz" then
                        do:  
                            ddatetmtz = hfld:buffer-value.
                            JsonRow:Add(hfld:serialize-name,ddatetmtz).
                        end. 
                    end.
                end.
            end. 
        end. 
        htbl = hBuffer:table-handle.
        AfterJsonRow:Publish(pcname,JsonRow,table-handle htbl by-reference).
        AddJSONTables(JsonRow,pcname,hBuffer).       
        return JsonRow.
    end method.
    
    method protected JsonArray GetJsonFieldArray(hfld as handle):
        define variable i as integer no-undo.
        define variable jsonArray as JsonArray no-undo.    
        jsonArray  = new JSONArray().
        do i = 1 to hfld:extent:
            jsonArray:Add(hfld:buffer-value(i)).
        end.
        return jsonArray.
    end method. 
end class.