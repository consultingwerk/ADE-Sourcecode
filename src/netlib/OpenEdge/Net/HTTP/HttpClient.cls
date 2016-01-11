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
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.Filter.Status.AuthorizationStatusFilter.
using OpenEdge.Net.HTTP.Filter.Status.OKStatusFilter.
using OpenEdge.Net.HTTP.Filter.Status.RedirectStatusFilter.
using OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilter.
using OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilterList.
using OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilterNode.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpRequestError.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.StatusActionEnum.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Net.HTTP.HttpClient:
    /** Miscellanous options (like timeouts) for this client */
    define public property Options as ClientOptions no-undo get. private set.
    
    /* Reference to the library that does the actual work. */
    define private variable moWwwLib as IHttpClientLibrary no-undo.
    
    /* Holds filter for processing status codes on return */
    define protected variable moStatusFilter as StatusCodeFilterList no-undo.
    
    /* Holds configuration */
    define private variable moConfig as JsonObject no-undo.
    
    define private temp-table Credentials no-undo
        field Realm as character        
        field Credentials as handle        
        index idx1 as primary unique Realm.
    
    constructor public HttpClient():
        this-object(new JsonObject()).
    end constructor.
    
    constructor public HttpClient(input poConfig as JsonObject):
        Assert:NotNull(poConfig, 'Client Config').
        
        assign moConfig            = poConfig.
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
    
    method public HttpResponse Execute(input poRequest as HttpRequest):
        define variable oResponse as HttpResponse no-undo.
        define variable iTimeout as integer no-undo.
        define variable oStatusAction as StatusActionEnum no-undo.
        
        assign iTimeout = this-object:Options:RequestTimeout.
        
        /* Use looping instead of recursion to avoid deeping the call stack */
        repeat on stop undo, return error new HttpRequestError(
                                                    '408' /*reqwuest timeout */,
                                                    poRequest:Method:Name,
                                                    poRequest:URI:URI)
                stop-after iTimeout:
            
            assign oResponse = moWwwLib:Execute(poRequest).
            
            /* Check for redirects, auth and friends */
            oStatusAction = moStatusFilter:Filter(input oResponse).
            
            if ProcessStatusAction(input oStatusAction, input oResponse) then
                leave.
        end.
        
        return oResponse.
    end method.
    
    /** Process the action resulting from the status evaluation
        
        @param StatusActionEnum The evaluation's action
        @param HttpResponse The response in question
        @return logical Returns TRUE if the loop is complete */
    method protected logical ProcessStatusAction(input poStatusAction as StatusActionEnum,
                                                 input poResponse as HttpResponse):
        define variable lOK as logical no-undo.
        
        case poStatusAction:
            when StatusActionEnum:OK    then lOK = true.
            when StatusActionEnum:Abort then lOK = true.
            when StatusActionEnum:Retry then lOK = false.
            when StatusActionEnum:Error then
                undo, throw new HttpRequestError(poResponse:StatusCode:Name,
                                        poResponse:Request:Method:Name,
                                        poResponse:Request:URI:URI).
        end case.
        
        return lOK. 
    end method.
    
    method public void Initialize():
        LoadConfig().
        
        InitializeStatusFilters().
        
        assign moWwwLib = new OpenEdge.Net.HTTP.Lib.ABLSockets.HttpClient(
                                    'OpenEdge.Net.HTTP.HttpClient','0.1', 
                                    this-object:Options).
        moWwwLib:Initialize().
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
        assign moStatusFilter = new StatusCodeFilterList().
        
        AddStatusFilter(new RedirectStatusFilter(this-object)).
        AddStatusFilter(new AuthorizationStatusFilter(this-object)).
        AddStatusFilter(new OKStatusFilter(this-object)).
    end method.
    
    method public void Destroy():
        RemoveStatusFilter().
        
        moWwwLib:Destroy().
    end method.
    
    method protected void AddStatusFilter(input poFilter as StatusCodeFilter):
        Assert:NotNull(poFilter, 'Status Code Filter').
        moStatusFilter:InsertLast(new StatusCodeFilterNode(poFilter)).
    end method.
    
    method protected void RemoveStatusFilter():
        assign moStatusFilter = ?.
    end method.
    
    method public handle GetCredentials(input pcRealm as character):
        define variable hCredentials as handle no-undo.
        
        define buffer lbCredentials for Credentials.
        
        Assert:NotNullOrEmpty(pcRealm, 'Realm').
        
        find lbCredentials where
             lbCredentials.Realm eq pcRealm
             no-error.
        
        if available lbCredentials then
            assign hCredentials = lbCredentials.Credentials.
        
        return hCredentials.                                            
    end method.
    
    /** Stores/sets the credentials for a particular realm.
        
        @param character The identifying realm
        @param character The username
        @param chracter  The password/passphrase for the user */
    method public void SetCredentials(input pcRealm as character,
                                      input pcUserName as character,
                                      input pcPassphrase as character):
        define buffer lbCredentials for Credentials.
        
        Assert:NotNullOrEmpty(pcRealm, 'Realm').
        
        find lbCredentials where
             lbCredentials.Realm eq pcRealm
             no-error.
        if not available lbCredentials then
        do:
            create lbCredentials.
            assign lbCredentials.Realm = pcRealm.
                         
            create client-principal lbCredentials.Credentials.
            assign lbCredentials.Credentials:user-id = pcUserName
                   lbCredentials.Credentials:primary-passphrase = pcPassphrase
                   lbCredentials.Credentials:domain-name = pcRealm.
        end.
    end method.
    
end class.