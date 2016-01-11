/** ------------------------------------------------------------------------
    File        : RulesServerConnectionParameters
    Purpose     : Purposed connection parameters for connecting to a Rules Server
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 15:07:49 EST 2013
    Notes       : * The Options property contains JSON data, which for a Rules Server Connection must have
                    the following structure
                    { "URL": Parameters as per OpenEdge.Core.ServerConnection.WebServiceConnectionParameters
                            OR a host name like "http://localhost:8980/"
                            OR a simple pathed URL like "http://localhost:8980/axis/services/"
                            OR something else in the future
                     }
                     
                 * The Rules Server Connection may also be an explicit WSDL, in which case a second property can be 
                   specified. Note that if a WSDL is specified, it overrides the value specified by the URL property
                    {"WSDL": Parameters as per OpenEdge.Core.ServerConnection.WebServiceConnectionParameters,
                              which includes a simple string like "wsdl/CorticonExecuteMod.wsdl"
                     }
                 
                 * If a WSDL property is specified, that wsdl will be used for the Decision Service,
                   thus overriding the value or the URL property. The URL property is always
                   used for the Admin Service.
                 * The WSDL is always used as-is for the connection: there are no
                   default paths or queries added to it.
                 * The URL property is used for the Decision and Admin Services in the
                   absence of a WSDL property.                
                 * A URL may have certain default values appended to it
                      Path: /axis/services/<ServiceName>
                      ServiceName: either Corticon or CorticonAdmin
                      Query: ?wsdl 
                   
                   If the URL property is in one of the following formats, this
                   object will add the necessary default values to allow a call
                   to a Corticon Server.
                     - No path, no query: eg http://localhost:8980
                     - Matching path: eg http://localhost:8980/axis/services
                     - No path, no WSDL query: eg http://localhost:8980?name1=value1
                     
                   In all of these cases, the URL will be modified with the missing
                   parts. For example, the resulting Decision Service URL will be
                      http://localhost:8980/axis/services/Corticon?wsdl
                   
                   The protocol, host, port and user/password aspects of the URL
                   are not modified. Only the path and query may change. 

                 * The Admin Service cannot be overridden. However, if there is no URL
                   property specified, the Admin Service cannot be contacted and thus
                   any Admin Service APIs will throw an error.
                 * The default GetConnectionString() API returns the connection string for the
                   Decision Service connection
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.ServerConnection.WebServiceConnectionParameters.
using OpenEdge.Core.ServerConnection.FormatMaskEnum.
using OpenEdge.Core.Assert.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.

class OpenEdge.BusinessRules.RulesServerConnectionParameters implements IConnectionParameters:
    define public property AdminServiceConnectionParameters as IConnectionParameters no-undo get. private set.
    define public property DecisionServiceConnectionParameters as IConnectionParameters no-undo get. private set.
    
    /** The FormatMask property contains a mask to be used together with
        the ABL SUBSTITUTE function. It can include up to 9 substitutions (&1-&9)
        and should also include any key/value pair separators (space, usually). */    
    define public property FormatMask as FormatMaskEnum no-undo get. private set.
    
    constructor public RulesServerConnectionParameters(input pcOptions as character):
        define variable oOptions as JsonObject no-undo.
        define variable oParser as ObjectModelParser no-undo.
        
        if pcOptions eq '' or pcOptions eq ? then
            oOptions = new JsonObject().
        else
        do: 
            oParser = new ObjectModelParser().
            oOptions = cast(oParser:Parse(pcOptions), JsonObject).
        end.
        
        ShadowConstructor(oOptions).
    end constructor.
    
    constructor public RulesServerConnectionParameters(input poOptions as JsonObject):
        Assert:NotNull(poOptions, 'Options').        
        ShadowConstructor(poOptions).
    end constructor.
    
    /** Shadow constructor for this class. Used instead of a real constructor since some transformations
        have to happen before its called, and since a constructor must be invoked first via SUPER or THIS-OBJECT,
        there's no room for those transformations. 
        
        @param JsonObject     The options in JSON form */
    method private void ShadowConstructor(input poOptions as JsonObject):
        this-object:FormatMask = FormatMaskEnum:Custom.
        this-object:Initialise(poOptions).
    end method.
    
    method protected void Initialise(input poOptions as JsonObject):
        define variable oAdminOptions as JsonObject no-undo.
        define variable oDecisionServiceOptions as JsonObject no-undo.
        
        /* We take the WSDL as given */
        if poOptions:Has('WSDL') then
        do:
            if poOptions:GetType('WSDL') eq JsonDataType:STRING then
            do:
                oDecisionServiceOptions = new JsonObject().
                oDecisionServiceOptions:Add('URL', poOptions:GetCharacter('WSDL')).
            end.
            else
                oDecisionServiceOptions = poOptions:GetJsonObject('WSDL').
                
            if not oDecisionServiceOptions:Has('ServiceName') then
                 oDecisionServiceOptions:Add('ServiceName', 'CcServerMessagingAxisService').
            
            if not oDecisionServiceOptions:Has('PortName') then
                 oDecisionServiceOptions:Add('PortName', 'CcServerMessagingAxis').
    
            if not oDecisionServiceOptions:Has('Operation') then
                 oDecisionServiceOptions:Add('Operation', 'execute').
        end.    /* WSDL */
        
        /* If we have a URL, then we need to make sure that the Admin and Decision Service WSDL suffixes are added */
        if poOptions:Has('URL') then
        do:
            /* if the Option's URL property is a string, append the service WSDL */
            if poOptions:GetType('URL') eq JsonDataType:STRING then
            do:
                oAdminOptions = new JsonObject().
                oAdminOptions:Add('URL', poOptions:GetCharacter('URL')).
            end.
            else
                oAdminOptions = poOptions:GetJsonObject('URL').
            
            /* In URL mode, we always use the generic API */
            if not oAdminOptions:Has('ServiceName') then
                oAdminOptions:Add('ServiceName', 'CcServerMessagingAxisService').
            else
                oAdminOptions:Set('ServiceName', 'CcServerMessagingAxisService').
                
            if not oAdminOptions:Has('PortName') then
                oAdminOptions:Add('PortName', 'CcServerMessagingAxis').
            else
                oAdminOptions:Set('PortName', 'CcServerMessagingAxis').

            /* URL. If this is true for admin, it will be true for decision service, because
               we cloned the options. */
            if not oAdminOptions:Has('URL') then
                return error new AppError('No URL option specified for the service connection', 0).

            /* WSDL overrides URL */
            if not valid-object(oDecisionServiceOptions) then
            do:
                oDecisionServiceOptions = cast(oAdminOptions:Clone(), JsonObject).
                if not oDecisionServiceOptions:Has('Operation') then
                    oDecisionServiceOptions:Add('Operation', 'execute').
                else
                    oDecisionServiceOptions:Set('Operation', 'execute').
                
                AddServiceWsdl(oDecisionServiceOptions, 'Corticon').
            end.
            
            /* do this after we clone, else we will just append Corticon?wsdl to CorticonAdmin?wsdl */            
            AddServiceWsdl(oAdminOptions, 'CorticonAdmin').
        end.    /* URL */
        
        /* We need at least a connection parameters for the decision service to continue. */
        Assert:NotNull(oDecisionServiceOptions, 'DecisionServiceConnectionParameters').

        this-object:DecisionServiceConnectionParameters = new WebServiceConnectionParameters(oDecisionServiceOptions).
        if valid-object(oAdminOptions) then
            this-object:AdminServiceConnectionParameters = new WebServiceConnectionParameters(oAdminOptions).
    end method.
    
    method private void AddServiceWsdl(input poOptions as JsonObject,
                                       input pcServiceName as character):
        define variable oURL as JsonObject no-undo.
        define variable oWsdl as JsonObject no-undo.
        define variable cTestValue as character no-undo.
        define variable cServicePath as character no-undo initial 'axis/services'.
        define variable lAddQuery as logical no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oQuery as JsonArray no-undo.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(poOptions, 'Connection options').
                                           
        if poOptions:GetType('URL') eq JsonDataType:STRING then
        do:
            assign cTestValue = poOptions:GetCharacter('URL')
                   /* Strip off the trailing /; if we add the standard path we 
                      will add it back in */
                   cTestValue = right-trim(cTestValue, '/').
            
            /* If the URL already has no path, or has the correct axis/services path,
               then add the service name and path. */
            
            /* no query, no path. num-entries is 3 because of the double slashes after 
               the protocol */
            if (index(cTestValue, '&') eq 0 and num-entries(cTestValue, '/') eq 3) then
                poOptions:Set('URL', substitute('&1/&2/&3?wsdl', cTestValue, cServicePath, pcServiceName)).
            else 
            /* no query, path already matches axis/services */
            if (index(cTestValue, '&') eq 0 and 
                num-entries(cTestValue, '/') eq 5 and
                entry(4, cTestValue, '/') + '/' + entry(5, cTestValue, '/') eq cServicePath) then
                poOptions:Set('URL', substitute('&1/&2?wsdl', cTestValue, pcServiceName)).
        end.
        else
        do:
            assign oURL = poOptions:GetJsonObject('URL')
                   lAddQuery = true.
            
            /* path can either not exist or be a string */
            if not oURL:Has('path') then
                oURL:Add('path', cServicePath + pcServiceName).
            else
            do:
                assign cTestValue = oURL:GetCharacter('path')
                       cTestValue = right-trim(cTestValue, '/').
                
                /* If the path exists and is either blank or a single slash,
                   then use the default values. Otherwise keep as-is */
                if (cTestValue eq '' or cTestValue eq ?) or
                   (cTestValue eq cServicePath) then
                    oURL:Set('path', '/' + cServicePath + '/' + pcServiceName).
                else
                    lAddQuery = false.
            end.
            
            /* query can either not exist, be a string, or an array of name/value objects */
            if lAddQuery then
            do:
                if not oURL:Has('query') then
                    oURL:Add('query', '?wsdl').
                else
                if oURL:GetType('query') eq JsonDataType:STRING then
                do:
                    cTestValue = oURL:GetCharacter('query').
                    if cTestValue eq ? or cTestValue eq '' then
                        oURL:Set('query',  '?wsdl').
                    else
                    if lookup('?wsdl', cTestValue, '&')  + lookup('wsdl', cTestValue, '&') eq 0 then                          
                        oURL:Set('query',  cTestValue + '&wsdl').
                end.
                else
                do:
                    assign oQuery = oURL:GetJsonArray('query')
                           iMax = oQuery:Length
                           .
                    do iLoop = 1 to iMax while lAddQuery:
                        if not oQuery:GetType(iLoop) eq JsonDataType:OBJECT then
                            next.
                        
                        oWsdl = oQuery:GetJsonObject(iLoop).

                        /* If there's already a WSDL query parameter in any form,
                           use it. */
                        if oWsdl:Has('name') and oWsdl:GetCharacter('name') eq 'wsdl' then 
                            lAddQuery = false.
                    end.
                    
                    if lAddQuery then
                    do:
                        oWsdl = new JsonObject().
                        oWsdl:Add('name', 'wsdl').
                        oQuery:Add(oWsdl).
                    end.
                end.
            end.
        end.
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @return character A useable string of connection parameters. */
    method public character GetConnectionString():
        /* default to returning decision service connection params .
           both Decision Service and Admin Service parameters are publicy available */
        return this-object:DecisionServiceConnectionParameters:GetConnectionString().
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @param character The format mask to use. Typically overrides the mask
                         specified by the property.
        @return character A useable string of connection parameters. */
    method public character GetConnectionString(input pcFormatMask as character):
        return this-object:DecisionServiceConnectionParameters:GetConnectionString(pcFormatMask).
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @param FormatMaskEnum The format mask to use. Overrides the mask
                              specified by the property.
        @return character A useable string of connection parameters. */
    method public character GetConnectionString(input poFormatMask as FormatMaskEnum):
        return this-object:DecisionServiceConnectionParameters:GetConnectionString(poFormatMask).
    end method.
        
end class.