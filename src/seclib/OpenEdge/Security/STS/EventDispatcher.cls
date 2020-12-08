/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : EventDispatcher
    Purpose     : Dispatches policy and other events from the STS to an ABL
                  provider. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 28 11:44:45 EST 2016
    Notes       : *
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Net.URI.
using OpenEdge.Security.Principal.
using OpenEdge.Security.STS.ClientValidator.
using OpenEdge.Security.STS.IErrorProvider.
using OpenEdge.Security.STS.IEventProvider.
using OpenEdge.Security.STS.IPolicyProvider.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using OpenEdge.Security.STS.EventDispatcher.
using OpenEdge.Logging.LoggerBuilder.

class OpenEdge.Security.STS.EventDispatcher implements ISupportLogging:
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(EventDispatcher)).
            return this-object:Logger.
        end get.
        set.
    
    /* use to handle the validation of a STS's credentials */
    define private variable moValidator as ClientValidator no-undo.
    
    /* saves us getting a new instance every time */
    define private variable moJsonParser as ObjectModelParser no-undo.
    
    /* Default constructor */
    constructor public EventDispatcher():
        super().
        assign moJsonParser = new ObjectModelParser()
               moValidator  = new ClientValidator().
    end constructor.
    
    /* Emits a named event to the ABL provider. This is a one-way operation:
       nothing is returned from provider to the STS. 
     
       @param character (optional) The name of the STS sending this event
       @param character (mandatory) The ABL provider name used to process the event
       @param character (optional) A hash used to verify the provider's authenticity
       @param character (optional) The name of the event to send.
       @param raw (optional) The token currently being processed in the STS
       @param longchar (optional) The domain context from the STS */
    method public void EmitEvent (input pcSender as character,
                                  input pcEventProvider as character,
                                  input pcProviderHash as character,
                                  input pcEventName as character,
                                  input prClientPrincipal as raw,
                                  input pcDomainCtx as longchar):
        define variable oProvider as IEventProvider no-undo.
        define variable oCP as Principal no-undo.
        define variable oCtx as JsonObject no-undo.
        define variable cMessage as character no-undo.
        
        /* validate the client */
        if not moValidator:Validate(get-class(EventDispatcher):TypeName, 'EmitEvent':u) then
            return error new AppError('Unable to validate client', 0). 
        
        Assert:NotNullOrEmpty(pcEventProvider, 'Provider name').
        
        /* the specified type may not provide the policy provider; error out */
        if not Progress.Lang.Class:GetClass(pcEventProvider):IsA(get-class(IEventProvider)) then
        do:
            assign cMessage = substitute('Provider &1 does not implement event API: &2',
                                            quoter(pcEventProvider),
                                            get-class(IEventProvider):TypeName).
            Logger:Error(cMessage).
            
            undo, throw new AppError(cMessage, 0).
        end.
        
        ValidateProvider(pcEventProvider, pcProviderHash).
        
        /* instantiate the provider */        
        oProvider = dynamic-new pcEventProvider ().
        
        /* load context. pass empty context if none is provided.
           build the CP */
        assign oCP = Principal:Import(prClientPrincipal)
               oCtx = ParseContext(pcDomainCtx).
        
        /* Record the event */        
        oProvider:RecordEvent(pcSender, pcEventName, oCP, oCtx).
    end method.

    /* Applies some by an ABL provider. 
     
       @param character (optional) The name of the STS sending this event
       @param character (mandatory) The ABL provider name used to process the event
       @param character (optional) A hash used to verify the provider's authenticity
       @param character (optional) The name of the event to send.
       @param raw (mandatory) The token currently being processed in the STS
       @param longchar (optional) The domain context from the STS 
       @return raw The token/client-principal after having policy applied. */
    method public raw ApplyPolicy(input  pcSender as character,
                                  input  pcPolicyProvider as character,
                                  input  pcProviderHash as character,
                                  input  pcEventName as character,
                                  input  prClientPrincipal as raw,
                                  input  pcDomainCtx as longchar,
                                  output piStatus as integer,
                                  output pcStatusDetail as character):
        define variable oProvider as IPolicyProvider no-undo.
        define variable oCP as Principal no-undo.
        define variable oCtx as JsonObject no-undo.
        define variable cMessage as character no-undo.
        
        /* validate the client */
        if not moValidator:Validate(get-class(EventDispatcher):TypeName, 'ApplyPolicy':u) then
            return error new AppError('Unable to validate client', 0).
        
        /* the specified type may not provide the policy provider; error out */
        if not Progress.Lang.Class:GetClass(pcPolicyProvider):IsA(get-class(IPolicyProvider)) then
        do:
            assign cMessage = substitute('Provider &1 does not implement policy API: &2',
                                            quoter(pcPolicyProvider),
                                            get-class(IPolicyProvider):TypeName).
            Logger:Error(cMessage).
            
            undo, throw new AppError(cMessage, 0).
        end.
        
        /* instantiate the provider */        
        ValidateProvider(pcPolicyProvider, pcProviderHash).
        
        oProvider = dynamic-new pcPolicyProvider ().
        /* load context. pass empty context if none is provided.
           build the CP */
        assign oCP  = Principal:Import(prClientPrincipal)
               oCtx = ParseContext(pcDomainCtx).
        
        /* apply the policy */
        assign piStatus = integer(oProvider:ApplyPolicy(pcSender, pcEventName, oCP, oCtx,
                                                output pcStatusDetail)).
        
        /* return to sender */
        return oCP:Token:export-principal().
    end method.

    /* handles/customises an error 
       
       @param character (optional) The name of the STS sending this event
       @param character (mandatory) The ABL provider name used to process the event
       @param character (optional) A hash used to verify the provider's authenticity
       @param character (optional) The name of the event to send.
       @param raw (optional) The token currently being processed in the STS
       @param character (optional) An error string indicating the error being handled. Could be a java exception or 
                                   something from an auth proivider, or empty. One of the client-principal and error-string 
                                   fields SHOULD be provided
       @param longchar (optional) The domain context from the STS 
       @param character out (optional) An error code per the OAuth2 and OpenId Connect specs. To return an 
                                       error number a string of custom:<error_code> must be returned. If not empty or null,
                                       this value will replace the auth process's error value.
       @param character out (optional) If blank or unknown the response will omit the error_description field.
       @param character out (optional) If null the response will omit the error_uri field.
       @return logical TRUE if the current token should be included in the error response */
    method public logical HandleError (input  pcSender as character,
                                       input  pcErrorProvider as character,
                                       input  pcProviderHash as character,
                                       input  pcEventName as character,
                                       input  prClientPrincipal as raw,
                                       input  pcErrorString as character,
                                       input  pcDomainCtx as longchar,
                                       output pcErrorCode as character,
                                       output pcErrorDetail as character,
                                       output pcErrorURI as character):
        define variable lIncludeToken as logical no-undo.
        define variable oProvider as IErrorProvider no-undo.
        define variable oCP as Principal no-undo.
        define variable oCtx as JsonObject no-undo.
        define variable oErrorURI as URI no-undo.
        
        /* validate the client */
        if not moValidator:Validate(get-class(EventDispatcher):TypeName, 'HandleError':u) then
            return error new AppError('Unable to validate client', 0). 
        
        /* the specified type may not provide the error policy */
        if not Progress.Lang.Class:GetClass(pcErrorProvider):IsA(get-class(IErrorProvider)) then
        do:
            Logger:Warn(substitute('Provider &1 does not implement error API: &2',
                            quoter(pcErrorProvider),
                            get-class(IErrorProvider):TypeName)).
            return false.
        end.
        
        /* instantiate the provider */
        ValidateProvider(pcErrorProvider, pcProviderHash).
        
        oProvider = dynamic-new pcErrorProvider ().
        
        /* load context. pass empty context if none is provided.
           build the CP */
        assign oCP  = Principal:Import(prClientPrincipal)
               oCtx = ParseContext(pcDomainCtx).
        
        assign lIncludeToken = oProvider:HandleError(input  pcSender,
                                                     input  pcEventName,
                                                     input  oCP,
                                                     input  pcErrorString,
                                                     input  oCtx,
                                                     output pcErrorCode,
                                                     output pcErrorDetail,
                                                     output oErrorURI).
        if valid-object(oErrorURI) then
            assign pcErrorURI = oErrorURI:ToString().
        
        return lIncludeToken.        
    end method.
    
    /* Creates useful JSON from the input context string
       
       @param longchar (optional) The domain context from the STS
       @return JsonObject The context in JSON form */ 
    method private JsonObject ParseContext (input pcDomainCtx as longchar):
        define variable oCtx as JsonObject no-undo.
        
        assign oCtx = cast(moJsonParser:Parse(pcDomainCtx), JsonObject) no-error.
        if not valid-object(oCtx) then
            assign oCtx = new JsonObject().
        
        /* need some default properties */
        if not oCtx:Has('domainContext':u) then
            oCtx:Add('domainContext':u, '':u).
        if not oCtx:Has('refreshOptions':u) then            
            oCtx:Add('refreshOptions':u, '':u).
        if not oCtx:Has('clientType':u) then
            oCtx:Add('clientType':u, '':u).
        if not oCtx:Has('scope':u) then
            oCtx:Add('scope':u, '':u).
        
        return oCtx.
    end method.
    
    /* Ensures that a provider type is the one we were expecting. 
        
       @param character (mandatory) The ABL provider name used to process the event
       @param character (optional) A hash used to verify the provider's authenticity
       @throws AppError If a hash is passed and the provider type's hash does not match */
    method private void ValidateProvider(input pcProviderType as character,
                                         input pcProviderHash as character ):
        Assert:NotNullOrEmpty(pcProviderType, 'Provider type').
        
        if pcProviderHash eq '':u or pcProviderHash eq ? then
            return.
         
        assign rcode-info:file-name = replace(pcProviderType, '.':u, '/':u).
        if rcode-info:md5-value ne pcProviderHash then
            return error new AppError(substitute('Provider error: invalid provider &1', pcProviderType), 0).
    end method.
    
end class.