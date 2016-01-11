/*------------------------------------------------------------------------
    File        : StatusCodeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 10 17:35:47 EST 2014
    Notes       : * http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.1.1
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Net.HTTP.StatusCodeEnum inherits EnumMember:
    &global-define EnumMembers
    &global-define EnumValues
         
    {Consultingwerk/EnumMember.i Unknown                            -1 StatusCodeEnum}
    
    /* 1xx: Informational - Request received, continuing process */
    {Consultingwerk/EnumMember.i Continue                           100 StatusCodeEnum}
    {Consultingwerk/EnumMember.i SwitchingProtocols                 101 StatusCodeEnum}
    
    /* 2xx: Success - The action was successfully received, understood, and accepted */
    {Consultingwerk/EnumMember.i OK                                 200 StatusCodeEnum}
    {Consultingwerk/EnumMember.i Created                            201 StatusCodeEnum}
    {Consultingwerk/EnumMember.i Accepted                           202 StatusCodeEnum}
    {Consultingwerk/EnumMember.i NonAuthoritativeInformation        203 StatusCodeEnum}
    {Consultingwerk/EnumMember.i NoContent                          204 StatusCodeEnum}
    {Consultingwerk/EnumMember.i ResetContent                       205 StatusCodeEnum}
    {Consultingwerk/EnumMember.i PartialContent                     206 StatusCodeEnum}
    
    /* 3xx: Redirection - Further action must be taken in order to complete the request */
    {Consultingwerk/EnumMember.i MultipleChoices                    300 StatusCodeEnum}
    {Consultingwerk/EnumMember.i MovedPermanently                   301 StatusCodeEnum}
    {Consultingwerk/EnumMember.i Found                              302 StatusCodeEnum}
    {Consultingwerk/EnumMember.i SeeOther                           303 StatusCodeEnum}
    {Consultingwerk/EnumMember.i NotModified                        304 StatusCodeEnum}
    {Consultingwerk/EnumMember.i UseProxy                           305 StatusCodeEnum}
    {Consultingwerk/EnumMember.i TemporaryRedirect                  307 StatusCodeEnum}
    
    /* 4xx: Client Error - The request contains bad syntax or cannot be fulfilled */
    {Consultingwerk/EnumMember.i BadRequest                         400 StatusCodeEnum}
    {Consultingwerk/EnumMember.i Unauthorized                       401 StatusCodeEnum}
    {Consultingwerk/EnumMember.i PaymentRequired                    402 StatusCodeEnum}
    {Consultingwerk/EnumMember.i Forbidden                          403 StatusCodeEnum}
    {Consultingwerk/EnumMember.i NotFound                           404 StatusCodeEnum}
    {Consultingwerk/EnumMember.i MethodNotAllowed                   405 StatusCodeEnum}
    {Consultingwerk/EnumMember.i NotAcceptable                      406 StatusCodeEnum}                                                                   
    {Consultingwerk/EnumMember.i ProxyAuthenticationRequired        407 StatusCodeEnum}
    {Consultingwerk/EnumMember.i RequestTimeOut                     408 StatusCodeEnum}
    {Consultingwerk/EnumMember.i Conflict                           409 StatusCodeEnum}
    {Consultingwerk/EnumMember.i Gone                               410 StatusCodeEnum}
    {Consultingwerk/EnumMember.i LengthRequired                     411 StatusCodeEnum}
    {Consultingwerk/EnumMember.i PreconditionFailed                 412 StatusCodeEnum}
    {Consultingwerk/EnumMember.i RequestEntityTooLarge              413 StatusCodeEnum}
    {Consultingwerk/EnumMember.i RequestURITooLarge                 414 StatusCodeEnum}
    {Consultingwerk/EnumMember.i UnsupportedMediaType               415 StatusCodeEnum}
    {Consultingwerk/EnumMember.i RequestedRangeNotSatisfiable       416 StatusCodeEnum}
    {Consultingwerk/EnumMember.i ExpectationFailed                  417 StatusCodeEnum}
    
    /* 5xx: Server Error - The server failed to fulfill an apparently valid request */
    {Consultingwerk/EnumMember.i InternalServerError                500 StatusCodeEnum}
    {Consultingwerk/EnumMember.i NotImplemented                     501 StatusCodeEnum}
    {Consultingwerk/EnumMember.i BadGateway                         502 StatusCodeEnum}
    {Consultingwerk/EnumMember.i ServiceUnavailable                 503 StatusCodeEnum}
    {Consultingwerk/EnumMember.i GatewayTimeout                     504 StatusCodeEnum}
    {Consultingwerk/EnumMember.i HTTPVersionNotSupported            505 StatusCodeEnum}
    
    constructor protected StatusCodeEnum( input piValue as integer, input pcName as character):
        super (input piValue, input pcName).
    end constructor.

    method static public StatusCodeEnum EnumFromName (input pcName as character):
        /* The HTTP response names have spaces. Remove them for the enum names */
        if lookup(replace(pcName, ' ', ''), "{&EnumMembers}") gt 0 then
            return cast(get-class(StatusCodeEnum):GetPropertyValue(pcName), StatusCodeEnum).
    end method.

    method static public StatusCodeEnum EnumFromValue (input piValue as integer):
        return StatusCodeEnum:EnumFromName(entry(lookup(string(piValue), "{&EnumValues}"), "{&EnumMembers}")).
    end method.
    
end class.