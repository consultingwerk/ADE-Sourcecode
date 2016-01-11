/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : UrlConnectionParameters
    Purpose     : Builds a URL from a set of (JSON) connection parameters
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 15:07:49 EST 2013
    Notes       : * The Options property contains JSON data, which for a URL must have
                    the follopwing structure
                        {"protocol":"http|https|...",
                         "host":"localhost|192.168.0.1|...",
                         "port":80,
                         "user":"<username>",
                         "password":"<password>",
                         "path": "/app/path",
                         "query": [{"name":"query-param-name-1", "value":"query-param-value-1"}, ... , {"name":"query-param-name-N", "value":"query-param-value-N"} ] }
                    Alternatively, provide a complete URL
                        {"URL":"http://localhost/index.html"}
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ServerConnection.ConnectionParameters.
using OpenEdge.Core.ServerConnection.FormatMaskEnum.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.


class OpenEdge.Core.ServerConnection.UrlConnectionParameters inherits ConnectionParameters:
    constructor public UrlConnectionParameters(input poOptions as JsonObject):
        super(poOptions, FormatMaskEnum:Custom).
    end constructor.
    
    constructor public UrlConnectionParameters(input pcOptions as character):
        super(pcOptions, FormatMaskEnum:Custom).
    end constructor.
    
    method override protected void Initialise():
        this-object:ResolvedOptions = ?.
        super:Initialise().
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @param character The format mask to use. This value is IGNORED for this class.
        @return character A useable string of connection parameters. */
    method override public character GetConnectionString():   
        /* Define variables for protocol and host, since we want to provide defaults for them.
           Just take what's provided for the other elements and use as-is. */
        define variable cProtocol as character no-undo initial 'http'.
        define variable cHost as character no-undo initial 'localhost'.
        define variable iPort as integer no-undo initial 80.
        define variable cUrl as character no-undo.
        define variable cPath as character no-undo initial 'index.html'.
        define variable cQuery as character no-undo.
        define variable cOptions as character no-undo.
        define variable oOptionsArray as JsonArray no-undo.
        define variable oSingleOption as JsonObject no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cNames as character extent no-undo.
        define variable cDelimiter as character no-undo.
        
        if this-object:ResolvedOptions eq ? then
        do:
            if this-object:Options:Has('URL') and
               this-object:Options:GetType('URL') eq JsonDataType:STRING then
            do:
                this-object:ResolvedOptions = this-object:Options:GetCharacter('URL').
                return this-object:ResolvedOptions.
            end.

            if this-object:Options:Has('protocol') then
                cProtocol = this-object:Options:GetCharacter('protocol').
            cURL = substitute('&1://', cProtocol).
            
            if this-object:Options:Has('user') then
            do: 
                cURL = cURL + this-object:Options:GetCharacter('user').            
                if this-object:Options:Has('password') then
                    cURL = cURL + substitute(':&1', this-object:Options:GetCharacter('password')). 
                cURL = cURL + '@'.
            end.

            if this-object:Options:Has('host') then
                cHost= this-object:Options:GetCharacter('host').
            cURL = cURL + cHost.
            
            if this-object:Options:Has('port') then
                iPort = this-object:Options:GetInteger('port').
            cURL = cURL + substitute(':&1', iPort).
    
            if this-object:Options:Has('path') then
                assign cPath = this-object:Options:GetCharacter('path')
                       /* we re-add the leading / when building the URL */
                       cPath = left-trim(cPath, '/').
            
            if this-object:Options:Has('query') then
            do:
                if this-object:Options:GetType('query') eq JsonDataType:STRING then
                    cQuery = this-object:Options:GetCharacter('query').
                else
                    oOptionsArray = this-object:Options:GetJsonArray('query').
                if valid-object(oOptionsArray) then
                do:
                    /* blank to remove defaults. Since there is an object here, assume that's the intent */
                    cDelimiter = '?'.
                    iMax = oOptionsArray:Length.
                    do iLoop = 1 to iMax:
                        oSingleOption = oOptionsArray:GetJsonObject(iLoop).
                        cQuery = cQuery + substitute('&1&2', cDelimiter, oSingleOption:GetCharacter('name')).
                        cDelimiter = '&'. 
                        if oSingleOption:Has('value') then
                            cQuery = cQuery + substitute('=&1',oSingleOption:GetCharacter('value')).
                    end.
                end.
            end.
            
            /* if there's no query string, then cQUery will be blank. */
            this-object:ResolvedOptions = substitute('&1/&2&3', cURL, cPath, cQuery). 
        end.
        
        return this-object:ResolvedOptions.
    end method.
    
end class.