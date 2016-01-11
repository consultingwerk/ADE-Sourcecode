/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HttpClient
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 10:44:00 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertJson.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterList.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterNode.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpRequestError.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.ParameterList.
using OpenEdge.Net.HTTP.Filter.Status.RedirectStatusFilter.
using OpenEdge.Net.HTTP.Filter.Status.AuthorizationStatusFilter.
using OpenEdge.Net.HTTP.Filter.Status.OKStatusFilter.

class OpenEdge.Net.HTTP.HttpClient:
    /** Miscellanous options (like timeouts) for this client */
    define public property Options as ClientOptions no-undo get. private set.
    
    /* Reference to the library that does the actual work. */
    define private variable moWwwLib as IHttpClientLibrary no-undo.
    
    /* Holds filter for processing status codes on return */
    define protected variable moStatusFilter as MessageFilterList no-undo.
    
    /* Holds configuration */
    define private variable moConfig as JsonObject no-undo.
    
    constructor public HttpClient():
        this-object(new JsonObject()).
    end constructor.
    
    constructor public HttpClient(input poConfig as JsonObject):
        Assert:NotNull(poConfig, 'Client Config').
        
        assign moConfig = poConfig.
    end constructor.
    
    method static public HttpClient Instance(input poConfig as JsonObject):
        define variable oHttpClient as HttpClient no-undo.
        
        oHttpClient = new HttpClient(poConfig). 
        oHttpClient:Initialize().
        
        return oHttpClient.
    end method.

    method static public HttpClient Instance():
        define variable oHttpClient as HttpClient no-undo.
        
        oHttpClient = new HttpClient(). 
        oHttpClient:Initialize().
        
        return oHttpClient.
    end method.
    
    /** Executes an HTTP request.
        
        @param HttpRequest Request parameters (URL, method, etc)  
        @param HttpResponse Includes status and payload*/
    method public HttpResponse Execute(input poRequest as HttpRequest):
        define variable oResponse as HttpResponse no-undo.
        define variable iTimeout as integer no-undo.
        define variable iNumRetries as integer no-undo.
        define variable oStatusAction as FilterActionEnum no-undo.
        define variable rRequestHash as raw extent 2 no-undo.
        
        assign iTimeout = this-object:Options:RequestTimeout.
        
        /* Use looping instead of recursion to avoid deeping the call stack */
        repeat on stop undo, return error new HttpRequestError(
                                                    string(StatusCodeEnum:RequestTimeOut:Value),
                                                    poRequest:Method:Name,
                                                    poRequest:URI:URI)
               stop-after iTimeout:
            
            if rRequestHash[1] eq rRequestHash[2] then
            do:
                assign iNumRetries = iNumRetries + 1.
                if this-object:Options:PauseBetweenRetry gt 0 then
                    pause this-object:Options:PauseBetweenRetry no-message.
            end.
            else
                assign iNumRetries = 0.
            
            assign rRequestHash[2] = rRequestHash[1]
                   /* make the request */
                   oResponse       = moWwwLib:Execute(poRequest)
                   rRequestHash[1] = poRequest:Hash.
            
            /* Check for redirects, auth and friends */
            oStatusAction = moStatusFilter:Filter(input oResponse).
            
            if ProcessStatusAction(input oStatusAction, input oResponse) then
                leave.
            
            if this-object:Options:NumRetries gt 0 and
               iNumRetries gt this-object:Options:NumRetries then
                leave.
        end.
        
        return oResponse.
    end method.
    
    /** Process the action resulting from the status evaluation
        
        @param FilterActionEnum The evaluation's action
        @param HttpResponse The response in question
        @return logical Returns TRUE if the loop is complete */
    method protected logical ProcessStatusAction(input poStatusAction as FilterActionEnum,
                                                 input poResponse as HttpResponse):
        define variable lOK as logical no-undo.
        
        case poStatusAction:
            when FilterActionEnum:OK    then lOK = true.
            when FilterActionEnum:Abort then lOK = true.
            when FilterActionEnum:Retry then lOK = false.
            when FilterActionEnum:Stop  then lOK = false.
            when FilterActionEnum:Error then
                undo, throw new HttpRequestError(poResponse:StatusCode:Name,
                                        poResponse:Request:Method:Name,
                                        poResponse:Request:URI:URI).
        end case.
        
        return lOK. 
    end method.
    
    method public void Initialize():
        define variable oLibType as Progress.Lang.Class no-undo.
        define variable oConfig as JsonObject no-undo.
        define variable oParams as ParameterList no-undo.
        define variable cClientLibName as character no-undo.
        define variable cClientLibVersion as character no-undo.
        
        LoadConfig().
        
        if valid-object(moConfig) and moConfig:Has('httpClientLib') then
        do:
            AssertJson:PropertyIsType(oConfig, 'httpClientLib', JsonDataTypeEnum:Object).
            oConfig = moConfig:GetJsonObject('httpClientLib').
            
            AssertJson:PropertyIsType(oConfig, 'type', JsonDataTypeEnum:String).
            oLibType = Progress.Lang.Class:GetClass(oConfig:GetCharacter('type')).
            
            AssertJson:PropertyIsType(oConfig, 'name', JsonDataTypeEnum:String).
            cClientLibName = oConfig:GetCharacter('name').
            
            AssertJson:PropertyIsType(oConfig, 'version', JsonDataTypeEnum:String).
            cClientLibVersion = oConfig:GetCharacter('version').
        end.
        else
            /* default/standard library */
            assign oLibType          = get-class(OpenEdge.Net.HTTP.Lib.ABLSockets.HttpClient)
                   cClientLibName    = 'OpenEdge-HttpClient'
                   cClientLibVersion = '0.1.0'.
        
        Assert:IsType(oLibType, get-class(IHttpClientLibrary)).

        oParams = new ParameterList(3).
        oParams:SetParameter(1,
                             DataTypeEnum:Character:Name,
                             IOModeEnum:Input:Name,
                             cClientLibName).
        oParams:SetParameter(2,
                             DataTypeEnum:Character:Name,
                             IOModeEnum:Input:Name,
                             cClientLibVersion).
        oParams:SetParameter(3,
                             DataTypeEnum:ProgressLangObject:Name,
                             IOModeEnum:Input:Name,
                             this-object).
        
        /* start */                                                          
        moWwwLib = cast(oLibType:New(oParams), IHttpClientLibrary).
        moWwwLib:Initialize().
        
        InitializeStatusFilters().
    end method.
    
    method protected void LoadConfig():
        define variable oObject as JsonObject no-undo.

        /* load ClientOptions from "options" property */
        assign this-object:Options = new ClientOptions().
        
        if valid-object(moConfig) and
            moConfig:Has('options') then
        do:            
            oObject = moConfig:GetJsonObject('options').
            if oObject:Has('numRetries') then
                this-object:Options:NumRetries = oObject:GetInteger('numRetries').
            if oObject:Has('pauseBetweenRetry') then
                this-object:Options:NumRetries = oObject:GetDecimal('pauseBetweenRetry').
            if oObject:Has('requestTimeout') then
                this-object:Options:NumRetries = oObject:GetDecimal('requestTimeout').
        end.
    end method.
    
    method protected void InitializeStatusFilters():
        assign moStatusFilter = new MessageFilterList().
        
        AddMessageFilter(moStatusFilter, get-class(RedirectStatusFilter)).
        AddMessageFilter(moStatusFilter, get-class(AuthorizationStatusFilter)).
        AddMessageFilter(moStatusFilter, get-class(OKStatusFilter)).
    end method.
    
    method public void Destroy():
        RemoveStatusFilters().
        
        moWwwLib:Destroy().
    end method.
    
    method protected void AddMessageFilter(input poFilterList as MessageFilterList,
                                           input poFilterType as class Progress.Lang.Class):
        define variable oFilter as IMessageFilter no-undo.
        
        Assert:NotNull(poFilterList, 'Message filter list').
        assign oFilter = poFilterList:GetFilterInstance(poFilterType).
        
        Assert:NotNull(oFilter, 'Message filter').
        poFilterList:InsertLast(new MessageFilterNode(oFilter)).
    end method.
    
    method protected void RemoveStatusFilters():
        assign moStatusFilter = ?.
    end method.
    
end class.