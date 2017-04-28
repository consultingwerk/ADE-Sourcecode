/************************************************
Copyright (c) 2015-2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : DefaultResponseBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 02 14:18:07 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.HttpResponseDecorator.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ResponseBuilder.

class OpenEdge.Net.HTTP.DefaultResponseBuilder inherits ResponseBuilder:
    /* custom implementation */
    define override public property Response as IHttpResponse no-undo
        get():
            return NewResponse().
        end get.

    constructor public DefaultResponseBuilder():
        super().
    end constructor.
    
    method private IHttpResponse NewResponse():
        define variable oResponse as IHttpResponse no-undo.
        define variable oResponseType as Progress.Lang.Class no-undo.
            
        assign oResponseType = ResponseBuilder:Registry:Get(get-class(IHttpResponse):TypeName).
        
        /* We know the signature to the default library's constructor - make sure that the type we
           get is of that type */
        Assert:IsType(oResponseType, get-class(OpenEdge.Net.HTTP.HttpResponse)).
        
        oResponse = dynamic-new string(oResponseType:TypeName)().
                
        if type-of(oResponse, ISupportInitialize) then
            cast(oResponse, ISupportInitialize):Initialize().
        
        return oResponse.
    end method.
    
    /** Decorate the Response with additional behaviour
            
        @param  Class The type of decorator to use
        @param  IHttpResponse The Response/instance we're decorating
        @return IHttpResponse The new, decorating Response */
    method private IHttpResponse DecorateResponse(input poDecorationType as Progress.Lang.Class,
                                                  input poDecoratedResponse as IHttpResponse):
        define variable oDecorator as IHttpResponse no-undo.
        define variable oDecoratorType as Progress.Lang.Class no-undo.
        define variable oResponse as IHttpResponse no-undo.
        define variable oAdapter as Progress.Lang.Object no-undo.
        
        Assert:NotNull(poDecoratedResponse, 'Response').
        Assert:NotNull(poDecorationType, 'Decoration type').
        
        /* if this is already decorated, carry on */
        if poDecoratedResponse:GetClass():IsA(poDecorationType) then
            return poDecoratedResponse.
        
        if type-of(poDecoratedResponse, IAdaptable) then
            assign oAdapter = cast(poDecoratedResponse, IAdaptable):GetAdapter(poDecorationType).
        
        if valid-object(oAdapter) and oAdapter:GetClass():IsA(poDecorationType) then
            return poDecoratedResponse.
        
        assign oDecoratorType = ResponseBuilder:Registry:Get(poDecorationType:TypeName).
        if not valid-object(oDecoratorType) then
            return poDecoratedResponse.
        
        /* got to be able to decorate ... */            
        Assert:IsType(oDecoratorType, get-class(HttpResponseDecorator)).
        
        oResponse = dynamic-new string(oDecoratorType:TypeName) (input poDecoratedResponse).

        /* version */
        if HasOption('version':u) then
            assign oResponse:Version = GetOptionStringValue('version':u).

        if type-of(oResponse, ISupportInitialize) then
            cast(oResponse, ISupportInitialize):Initialize().
        
        return oResponse.
    end method.    

end class.