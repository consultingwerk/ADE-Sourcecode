/************************************************
Copyright (c)  2013, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : WebServiceConnectionParameters
    Purpose     : Specialised connection parameters for connecting to a WebService connection
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 15:07:49 EST 2013
    Notes       : * The Options property contains JSON data, which for a URL must have
                    the following structure
                    {"ServiceName": "",
                     "PortName":"",
                     "Operation":"",
                     "URL": Parameters as per OpenEdge.Core.ServerConnection.UrlConnectionParameters
                            OR a simple string like "http://localhost:8980/axis/services/Corticon?wsdl" 
                     "Options": [{"WSDLUserId": "user-id"},{"WSDLPassword":"password"}]}
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ServerConnection.UrlConnectionParameters.
using OpenEdge.Core.ServerConnection.ConnectionParameters.
using OpenEdge.Core.ServerConnection.FormatMaskEnum.

using OpenEdge.Core.Assert.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Core.ServerConnection.WebServiceConnectionParameters inherits ConnectionParameters:     
    /** The name of the WebService */
    define public property ServiceName as character no-undo get. protected set.
    /** The name of the (default) Port  */
    define public property PortName as character no-undo get. protected set.
    /** The name of the (default) Operation */
    define public property Operation as character no-undo get. protected set.
    
    constructor public WebServiceConnectionParameters(input poOptions as JsonObject):
        super(poOptions, FormatMaskEnum:Custom).
    end constructor.
    
    constructor public WebServiceConnectionParameters(input pcOptions as character):
        super(pcOptions, FormatMaskEnum:Custom).
    end constructor.
    
    method override protected void Initialise():
        this-object:ResolvedOptions = ?.
        
        super:Initialise().
        
        if this-object:Options:Has('ServiceName') then
             this-object:ServiceName = this-object:Options:GetCharacter('ServiceName').
             
        Assert:NotNullOrEmpty(this-object:ServiceName, 'Service Name').             

        if this-object:Options:Has('PortName') then
             this-object:PortName = this-object:Options:GetCharacter('PortName').

        if this-object:Options:Has('Operation') then
             this-object:Operation = this-object:Options:GetCharacter('Operation').
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @return character A useable string of connection parameters. */
    method override public character GetConnectionString():
        define variable cConnectionString as character no-undo.
        define variable cUrl as character no-undo.
        define variable cOptions as character no-undo.
        define variable oOptionsArray as JsonArray no-undo.
        {&_proparse_ prolint-nowarn(varusage)}
        define variable oSingleOption as JsonObject no-undo.
        define variable oURLOptions as JsonObject no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oUrlCP as UrlConnectionParameters no-undo.
        
        if this-object:ResolvedOptions eq ? then
        do:
            /* SERVICE */
            cConnectionString = substitute('-Service &1', this-object:ServiceName).
            
            /* WSDL */
            /* Build the URL */
            if not this-object:Options:Has('URL') then
                return error new AppError('No URL option specified', 0).
            
            if this-object:Options:GetType('URL') eq JsonDataType:STRING then
                cUrl = this-object:Options:GetCharacter('URL').
            else
            do:
                oURLOptions = this-object:Options:GetJsonObject('URL').
                assign oUrlCP = new UrlConnectionParameters(oURLOptions)
                       cUrl = oUrlCP:GetConnectionString().
            end.
            
            cOptions = ''.
            if this-object:Options:Has('Options') then
            do:
                oOptionsArray = this-object:Options:GetJsonArray('Options').
                /* blank to remove defaults. Since there is an object here, assume that's the intent */
                iMax = oOptionsArray:Length.
                do iLoop = 1 to iMax:
                    oSingleOption = oOptionsArray:GetJsonObject(iLoop).
                    cOptions  = cOptions 
                              + ConnectionParameters:GetConnectionString(
                                        oOptionsArray:GetJsonObject(iLoop),
                                        FormatMaskEnum:DashSpace:ToString()).
                end.
            end.
            this-object:ResolvedOptions = cConnectionString + substitute(' -WSDL &1 ', cUrl) + cOptions.
        end.
        
        return this-object:ResolvedOptions.
    end method.
    
end class.