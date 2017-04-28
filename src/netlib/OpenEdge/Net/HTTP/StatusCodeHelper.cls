/************************************************
Copyright (c) 2015-2016 by Progress Software Corporation. All rights reserved.
*************************************************/  
/*------------------------------------------------------------------------
    File        : StatusCodeHelper
    Purpose     : Helps to convert/find default values for status codes and 
                  their messages 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Sep 16 10:57:44 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Core.Assert.

class OpenEdge.Net.HTTP.StatusCodeHelper:
    
    /* Returns the default status message for a status code.
         
       @param integer The status code to convert.
       @return character The (default) status code text. */
    method public static character GetMessage(input piStatusCode as integer):
        define variable oStatusCode as StatusCodeEnum no-undo.
        
        assign oStatusCode = StatusCodeEnum:GetEnum(piStatusCode) no-error.
        
        return GetMessage(oStatusCode).
    end method.
        
    /* Returns the default status message for a status code.
         
       @param StatusCodeEnum The status code to convert.
       @return character The (default) status code text. */
    method public static character GetMessage(input poStatusCode as StatusCodeEnum):
        if not valid-object(poStatusCode) then
            return StatusCodeEnum:Unknown:ToString().
        else
        case poStatusCode:
            /* 1xx */
            when StatusCodeEnum:SwitchingProtocols then return 'Switching Protocols':u.
            /* 2xx */
            when StatusCodeEnum:NonAuthoritativeInformation then return 'Non Authoritative Information':u.
            when StatusCodeEnum:NoContent                   then return 'No Content':u.
            when StatusCodeEnum:ResetContent                then return 'Reset Content':u.
            when StatusCodeEnum:PartialContent              then return 'Partial Content':u.
            when StatusCodeEnum:AlreadyReported             then return 'Already Reported':u.
            when StatusCodeEnum:IMUsed                      then return 'IM Used':u.
            
            /* 3xx */
            when StatusCodeEnum:MultipleChoices   then return 'Multiple Choices':u.
            when StatusCodeEnum:MovedPermanently  then return 'Moved Permanently':u.
            when StatusCodeEnum:SeeOther          then return 'See Other':u.
            when StatusCodeEnum:NotModified       then return 'Not Modified':u.
            when StatusCodeEnum:UseProxy          then return 'Use Proxy':u.
            when StatusCodeEnum:TemporaryRedirect then return 'Temporary Redirect':u.
            when StatusCodeEnum:PermanentRedirect then return 'Permanent Redirect':u.

            /* 4xx */
            when StatusCodeEnum:BadRequest                   then return 'Bad Request':u.
            when StatusCodeEnum:PaymentRequired              then return 'Payment Required':u.
            when StatusCodeEnum:NotFound                     then return 'Not Found':u.
            when StatusCodeEnum:MethodNotAllowed             then return 'Method Not Allowed':u.
            when StatusCodeEnum:NotAcceptable                then return 'Not Acceptable':u.
            when StatusCodeEnum:ProxyAuthenticationRequired  then return 'Proxy Authentication Required':u.
            when StatusCodeEnum:RequestTimeOut               then return 'Request TimeOut':u.
            when StatusCodeEnum:LengthRequired               then return 'Length Required':u.
            when StatusCodeEnum:PreconditionFailed           then return 'Precondition Failed':u.
            when StatusCodeEnum:RequestEntityTooLarge        then return 'Request Entity Too Large':u.
            when StatusCodeEnum:RequestURITooLarge           then return 'Request URI Too Large':u.
            when StatusCodeEnum:UnsupportedMediaType         then return 'Unsupported Media Type':u.
            when StatusCodeEnum:RequestedRangeNotSatisfiable then return 'Requested Range Not Satisfiable':u.
            when StatusCodeEnum:ExpectationFailed            then return 'Expectation Failed':u.
            when StatusCodeEnum:MisdirectedRequest           then return 'Misdirected Request':u.  
            when StatusCodeEnum:UnprocessableEntity          then return 'Unprocessable Entity':u.  
            when StatusCodeEnum:FailedDependency             then return 'Failed Dependency':u.  
            when StatusCodeEnum:UpgradeRequired              then return 'Upgrade Required':u.  
            when StatusCodeEnum:PreconditionRequired         then return 'Precondition Required':u.  
            when StatusCodeEnum:TooManyRequests              then return 'Too Many Requests':u.  
            when StatusCodeEnum:RequestHeaderFieldsTooLarge  then return 'Request Header Fields Too Large':u.   
            /* 5xx */
            when StatusCodeEnum:InternalServerError           then return 'Internal Server Error':u.
            when StatusCodeEnum:NotImplemented                then return 'Not Implemented':u.
            when StatusCodeEnum:BadGateway                    then return 'Bad Gateway':u.
            when StatusCodeEnum:ServiceUnavailable            then return 'Service Unavailable':u.
            when StatusCodeEnum:GatewayTimeout                then return 'Gateway Timeout':u.
            when StatusCodeEnum:HTTPVersionNotSupported       then return 'HTTP Version Not Supported':u.
            when StatusCodeEnum:VariantAlsoNegotiates         then return 'Variant Also Negotiates':u.
            when StatusCodeEnum:InsufficientStorage           then return 'Insufficient Storage':u.
            when StatusCodeEnum:LoopDetected                  then return 'Loop Detected':u.
            when StatusCodeEnum:NotExtended                   then return 'Not Extended':u.
            when StatusCodeEnum:NetworkAuthenticationRequired then return 'Network AuthenticationRequired':u.
            /* single word */
            otherwise   return string(poStatusCode).
        end case.
    end method.
    
    /* Finds the default status code enum for a status message, if possible.
       Returns StatusCodeEnum:Unknown if the text cannot be converted into an
       existing enum.
       
       @param character The status text
       @return StatusCodeEnum A status code enumeration based on the name */
    method public static StatusCodeEnum GetCode(input pcStatusMessage as character):
        define variable oCode as StatusCodeEnum no-undo.
        
        Assert:NotNull(pcStatusMessage, 'Status message'). 
        
        if pcStatusMessage eq '':u then
            assign oCode = StatusCodeEnum:None.
        else
            assign oCode = StatusCodeEnum:GetEnum(replace(pcStatusMessage, ' ':u, '':u)) no-error.
        
        if not valid-object(oCode) then 
            assign oCode = StatusCodeEnum:Unknown.
        
        return oCode.
    end method.
    
end class.