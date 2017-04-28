/* ***********************************************************/
/* Copyright (c) 2013-2016 by Progress Software Corporation       */
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
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.

class  OpenEdge.DataAdmin.Binding.AbstractDataTree abstract implements IDataTree:  
    define protected event AfterJsonRow signature void (pname as char,jsonrow as JsonObject, table-handle htbl ). 

    define public property Write as logical no-undo  get. set. 
    define public property WriteCode as logical no-undo  get. set. 
    define public property Total as int64 no-undo init ? get. set. 
    define public property batchStart as int64 no-undo init ? get. set. 
    define public property pSize as int64 no-undo init ? get. set.
    define public property TableList as logical no-undo  get. set. 
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
    
    method final public JsonObject GetJSON(pageReq as IPageRequest):
        define variable json as JsonObject no-undo.
        define variable json2 as JsonObject no-undo.
        
        assign
            batchStart = pageReq:Start
            pSize = pageReq:PageSize
            TableList = pageReq:TableList.
        
        /*json = new JsonObject().
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
         
        AddJsonBody(json2).*/
        
        return GetJSON().
    end method.
    
    method protected JsonArray GetJsonArrayFromQuery(phQuery as handle,pcname as char,pbuffers as char,phidefields as char):
        define variable hBuffer as handle no-undo.
        define variable jsonArray as JsonArray no-undo.
        define variable hbuffers as handle extent no-undo.
        define variable i as integer no-undo.
        define variable cnt as integer no-undo.
        define variable polCnt as integer no-undo init 1. 
        //define variable totalCnt as integer no-undo.
        
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
                    if pcname eq "cdcTablePolicies" then 
                    do:                        
                        //jsonrow2 = getCdcJsonRow(hbuffers[i],pcname,tb,s,quer,pbuffers).
                        //jsonrow2:Write(jSon_string,TRUE). 
                        //MESSAGE STRING(jSon_string) VIEW-AS ALERT-BOX.
                        //jsonarray:add(GetJSONRow(hBuffers[i],pcname,phidefields)).
                        cnt =  cnt + 1. 
                        if (batchStart eq 0 and pSize eq 0) or (batchStart eq ? and pSize eq ?) then do:
                            jsonArray:add(GetJSONRow(hBuffers[i],pcname,phidefields)).
                        end.
                        else if (cnt ge batchStart) and (polCnt le pSize) then do:                            
                            jsonArray:add(GetJSONRow(hBuffers[i],pcname,phidefields)).
                            polCnt = polCnt + 1. //used for batching
                            //totalCnt = totalCnt + 1. // user to count total policies with respect to batching             
                        end. 
                                             
                        //jsonArray:Add(GetJSONRow(hBuffers[i],pcname,phidefields)). 
                    end. 
                    else
                        jsonArray:Add(GetJSONRow(hBuffers[i],pcname,phidefields)).
                end.
                phQuery:get-next().
            end.
            if pcname eq "cdcTablePolicies" then do:
                //if totalCnt > 0 then
                //    this-object:Total = totalCnt.
                this-object:Total = Cnt.
             end.
            return jsonArray.
        end.
        return ?.
    end method.
    
    method protected JsonArray GetCdcJsonArrayFromQuery(phQuery as handle,que as handle, pcname as char,pbuffers as char,phidefields as char,pfilter as char):    
        
        define variable hfld          as handle     no-undo.     
        define variable jsonArray     as JsonArray  no-undo.    
        define variable hbuffers      as handle     extent no-undo.     
        define variable i             as integer    no-undo.    
        define variable j             as integer    no-undo.        
        define variable TableList1    as character  no-undo.
        define variable TableList2    as character  no-undo.        
        define variable tblChar       as char       no-undo.
        define variable schChar       as char       no-undo.  
        define variable cnt           as integer    no-undo.
        define variable totalCnt      as integer    no-undo.  
        define variable polCnt        as integer    no-undo init 1.    
        //if batchStart gt 0 then batchStart = batchStart - 1.
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
                    do j = 1 to hbuffers[i]:num-fields:
                        hfld = hBuffers[i]:buffer-field(j).            
                        if hfld:serialize-name eq "tablename" then                        
                            tblChar = hfld:buffer-value.
                        if hfld:serialize-name eq "schemaname" then
                            schChar = hfld:buffer-value.
                        if schChar ne "" and tblChar ne "" then 
                            leave. // leave to skip iterating other fields                            
                    end.
                    TableList2 = tblChar + "@" + schChar + ",".                    
                    if index(TableList1,TableList2) eq 0 or TableList1 eq "" then do:
                        cnt = cnt + 1.                        
                        if (batchStart eq 0 and pSize eq 0) or (batchStart eq ? and pSize eq ?) then do:
                            jsonArray:add(getCdcJsonRow(que,tblChar,schChar,pfilter,pbuffers,pcname,phidefields)).
                        end.
                        else if (cnt ge batchStart) and (polCnt le pSize) then do:                            
                            jsonArray:add(getCdcJsonRow(que,tblChar,schChar,pfilter,pbuffers,pcname,phidefields)).
                            //totalCnt = totalCnt + 1.
                            polCnt = polCnt + 1.                            
                        end.
                        /*else if (cnt eq batchStart) and (batchStart eq pSize + 1) then
                            jsonArray:add(getCdcJsonRow(que,tblChar,schChar,pfilter,pbuffers,pcname,phidefields)).*/
                        TableList1 = TableList1 + TableList2.                       
                    end.
                    if schChar > "" and tblChar > "" then
                    assign schChar = ""
                           tblChar = "".                    
                    //TableList1 = TableList1 + TableList2.
                end.
                phQuery:get-next().
            end.
            //if totalCnt > 0 then
            //    this-object:Total = totalCnt.
            this-object:Total = Cnt.
            return jsonArray.
        end.
        return ?.
    end method.
    
    method protected jsonObject GetCdcJsonRow(pBuffer as handle,tbl as char, sch as char,pfilter as char,pbuffers as char,pcname as char,phidefields as char):
        define variable jsonRow1    as JsonObject no-undo.
        define variable jsonRow2    as JsonObject no-undo.
        define variable jsonRowMain as JsonObject no-undo.
        define variable jsonArray1  as JsonArray  no-undo.
        define variable jsonArray2  as JsonArray  no-undo.
        define variable i           as int        no-undo.
        define variable hfld        as handle     no-undo.
        define variable hQuery      as handle     no-undo.
        define variable hbuffer     as handle     no-undo.
        define variable hbuffers    as handle     no-undo extent.    
        define variable tblname     as char       no-undo.
        define variable schname     as char       no-undo.
        define variable instance    as int        no-undo.
        define variable jsonvalue   as char       no-undo.
        define variable cnt         as int        no-undo.    
        define variable j           as int        no-undo.
        define variable tempSort     as char       no-undo.    
        
            jsonRowMain = new jsonObject().
            jsonRowMain:Add("tableName",tbl).
            jsonRowMain:Add("schemaName",sch).
           
            create buffer hbuffer for table pBuffer.
            create query hQuery.           
            hQuery:add-buffer(hBuffer).            
            pfilter = "for each " + pBuffer:name + " where ttCdcTablePolicy.tablename eq " + quoter(tbl) + " and ttCdcTablePolicy.schemaname eq " + quoter(sch).            
            hQuery:query-prepare (pFilter). 
            
            extent(hbuffers) = num-entries(pbuffers).  
            if not hQuery:is-open then
                hQuery:query-open().
            hQuery:get-first().
            do i = 1 to num-entries(pbuffers):
                hbuffers[i] = hQuery:get-buffer-handle (entry(i,pbuffers)).
            end.   
        
            if hbuffers[1]:avail then
            do:             
                jsonArray1 = new JsonArray().   
                jsonArray2 = new JsonArray().
                JsonRow1 = new JSONObject(). 
                JsonRow2 = new JSONObject().       
                do while hbuffers[1]:avail:
                    do i = 1 to extent(hbuffers):                    
                        do j = 1 to hbuffers[i]:num-fields:
                            hfld = hBuffers[i]:buffer-field(j).                              
                            if hfld:serialize-name eq "instance" then 
                            do:
                                instance = hfld:buffer-value.
                                if instance eq 0 then 
                                    jsonValue = "Current".
                                else if instance eq 2 then
                                    jsonValue = "Pending".
                                else jsonValue = "Previous".  
                                leave.                       
                            end.                     
                        end.
                        if jsonvalue eq "previous" then
                            cnt = cnt + 1.
                        else if jsonvalue eq "Pending" then
                        do:                            
                            jsonRow1 = GetJsonRow(hbuffers[i],pcname,phidefields).
                            jsonArray1:add(jsonRow1).
                            //jsonRowMain:add(jsonvalue,jsonArray2).                            
                        end.
                        else 
                        do:                            
                            jsonRow2 = GetJsonRow(hbuffers[i],pcname,phidefields).
                            jsonArray2:add(jsonRow2).
                            //jsonRowMain:add(jsonvalue,jsonArray1).
                        end.               
                    end.
                hQuery:get-next().
                end.            
            end.
        jsonRowMain:add("current", jsonArray2).
        jsonRowMain:add("previous", cnt).
        jsonRowMain:add("pending", jsonArray1).
        return jsonRowMain.
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