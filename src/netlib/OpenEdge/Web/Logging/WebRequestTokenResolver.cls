/* *************************************************************************************************************************
Copyright (c) 2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : WebRequestTokenResolver
    Purpose     : Resolves tokens for web.*
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2019-12-13
    Notes       : * Group args for WEB
                    WEBAPP["." webapp-type]
                        webapp-type
                            NAME : the context/webapp name (default)
                            PATH : the fully-qualified path of the webapp
                    URI          : The complete request URI
                    URI.TEMPLATE : The URI template used to select a webhandler
                    URI.HOST     : The host to which the request was made
                    URI.PORT     : The port to which the request was made
                    VERB         }
                    METHOD       : the http method of the request
                    SCHEME       : the scheme of the request (HTTP or HTTPS)
                    TRANSPORT    }
                    TPT          : the transport, including path. So generally /web
                    SERVICE      }
                    SVC          : PATH.1 or PathInfo[1]. The service name is, by convention, the first path segment after
                                   the transport
                    PATH         : The path after the transport
                    PATH.PARAM   : Comma-separated list of the path parameter names, plus TEMPLATE, FINAL_MATCH_GROUP
                    PATH.<param> : value for the path parameter named <param>. Blank if the <param> does not exist
                    PATH.<n>     : value of the nth path segment of the PathInfo (after the transport)
                    HDR.<name>   : the header value for <name>
                    COOKIE.<name>: the complete cookie value for <name>
                    QRY.<name>   : The query string value of <name>
                    CGI          : a CSV list of the CGI variable names
                    CGI.<name>   }
                    CTX.<name>   : The value of the CGI variable
                    REMOTE"." remote-client-data
                        remote-client-data
                            HOST    : The hostname of the remote client
                            PORT    : The port of the remote client
                            ADDRESS : The IP address of the remote client
                    LOCAL"." local-server-data  These values may differ from the request URI due to proxies or whatnot
                        local-server-data
                            HOST    : The hostname of this instance
                            PORT    : The port of this instance
                            ADDRESS : The IP address of this instance
                    <value>      : If none of the above, treat as CGI.<name>
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Util.TokenResolverEventArgs.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.WebRequest.

class OpenEdge.Web.Logging.WebRequestTokenResolver:
    
    /* Default constructor.
        The constructor is PRIVATE to prevent any instantiation of this class - it is intended
        to only have static members .*/
    constructor private WebRequestTokenResolver():
        // no-op
    end constructor.
    
    /* Event published after a token is resolved by this resolver. Allows a listener to override the value */
    method static public void TokenResolvedHandler(input pSender as Progress.Lang.Object,
                                                   input pArgs as TokenResolverEventArgs):
        define variable args as character extent 2 no-undo.
        define variable idx as integer no-undo.
        define variable req as IWebRequest no-undo.
        define variable pathParams as character no-undo.
        define variable cgiVars as character no-undo initial '':u.
        define variable qryVals as character extent no-undo.
        define variable iCount as integer no-undo.
        define variable iLoop as integer no-undo.
                
        if    not valid-object(pArgs)
           or not pArgs:TokenGroup eq 'web':u
        then
            return.
        
        // allow a web request to be passed as context
        if type-of(pArgs:SourceValue, IWebRequest) then
            assign req = cast(pArgs:SourceValue, IWebRequest).
        else
            assign req               = new WebRequest()
                   pArgs:SourceValue = req
                   .
        
        // if we're not in a WEBSPEED or PASOE session, these'll resolve to null/unknown
        case pArgs:TokenArg:
            // the file-system path to the webapp
            when 'webapp.path':u then
                assign pArgs:TokenValue = req:ResolvedWebAppPath.
            
            // the webapp name
            when 'webapp':u or
            when 'webapp.name':u then
            do:
                // we want a name here not a path. for that, use webapp.path
                assign pArgs:TokenValue = req:WebAppPath.
                if pArgs:TokenValue eq '':u then
                    assign pArgs:TokenValue = 'ROOT':u.
            end.
            
            when 'method':u or
            when 'verb':u then
                assign pArgs:TokenValue = req:Method.
            
            when 'scheme':u then
                assign pArgs:TokenValue = req:URI:Scheme.
            
            when 'svc':u or
            when 'service':u then
                // PathInfo starts with a / so the entries are off-by-one
                assign pArgs:TokenValue = entry(2, req:PathInfo, '/':u).
            
            when 'tpt':u or
            when 'transport':u then
                assign pArgs:TokenValue = req:TransportPath.
            
            when 'uri':u then
                assign pArgs:TokenValue = string(req:Uri).
            
            when 'uri.host':u then
                assign pArgs:TokenValue = req:URI:Host.
            
            when 'uri.port':u then
                assign pArgs:TokenValue = substitute('&1':u, req:URI:Port).
            
            when 'uri.template':u then
                assign pArgs:TokenValue = req:UriTemplate.
            
            // web.path with no extra modifiers
            when 'path':u then
                assign pArgs:TokenValue = req:PathInfo.
            
            when 'path.param':u then
            do:
                if pathParams eq '':u then
                    assign pathParams = req:PathParameterNames.
                
                assign pArgs:TokenValue = pathParams.
            end.
            
            when 'remote.host':u then
                assign pArgs:TokenValue = req:RemoteHost.
            
            when 'remote.port':u then
                assign pArgs:TokenValue = string(req:RemotePort).
            
            when 'remote.address':u then
                assign pArgs:TokenValue = req:RemoteAddress.
            
            when 'local.host':u then
                assign pArgs:TokenValue = req:LocalHost.
            
            when 'local.port':u then
                assign pArgs:TokenValue = string(req:LocalPort).
            
            when 'local.address':u then
                assign pArgs:TokenValue = req:LocalAddress.
            
            // returns the list of CGI variables.
            // may also return a single value using web.cgi.<name>
            when 'cgi':u then
            do:
                if cgiVars eq '':u then
                    assign cgiVars = req:ContextNames.
                
                assign pArgs:TokenValue = cgiVars.
            end.
            
            otherwise
            do:
                assign args[1] = entry(1, pArgs:TokenArg, '.':u)
                       idx     = index(pArgs:TokenArg, '.':u)
                       .
                if idx gt 0 then
                    assign args[2] = substring(pArgs:TokenArg, idx + 1).
                
                // token arguments with variable parts
                case args[1]:
                    // path with modifiers
                    when 'path':u then
                    do:
                        if pathParams eq '':u then
                            assign pathParams = req:PathParameterNames.
                        
                        if lookup(args[2], pathParams) gt 0 then
                            assign pArgs:TokenValue = req:GetPathParameter(args[2]).
                        else
                        do:
                            // PathInfo starts with a / so the entries are off-by-one
                            assign idx = integer(args[2]) + 1
                                   no-error.
                            if error-status:error then
                                assign pArgs:TokenValue = ?
                                       no-error.
                            else
                            if  idx le num-entries(req:PathInfo, '/':u) then
                                assign pArgs:TokenValue = entry(idx, req:PathInfo, '/':u).
                        end.
                    end.
                    
                    when 'hdr':u then
                        assign pArgs:TokenValue = req:GetHeader(args[2]):Value.
                    
                    when 'qry':u then do:
                        assign iCount = req:Uri:GetQueryValueCount(args[2]).
                        if iCount eq 1 then
                            assign pArgs:TokenValue = req:Uri:GetQueryValue(args[2]). // Just return the single value.
                        else if iCount gt 1 then do:
                            qryVals = req:Uri:GetQueryValues(args[2]). // Always returns values as a character extent.
                            pArgs:TokenValue = "". // Initialize the token to an empty string before appending values.
                            iCount = extent(qryVals). // Just make sure this is in agreement with the count.
                            do iLoop = 1 to iCount:
                                // Just create a comma-delimited string for the token (to keep it a character value).
                                assign pArgs:TokenValue = trim(substitute("&1,&2", pArgs:TokenValue, qryVals[iLoop]), ",").
                            end.
                        end.
                    end.
                    
                    when 'cookie':u then
                        assign pArgs:TokenValue = string(req:GetCookie(args[2])).
                    
                    when 'cgi':u or
                    when 'ctx':u then
                    do:
                        if cgiVars eq '':u then
                            assign cgiVars = req:ContextNames.
                        
                        if lookup(args[2], cgiVars) eq 0 then
                            assign pArgs:TokenValue = ?.
                        else
                            assign pArgs:TokenValue = req:GetContextValue(args[2]).
                    end.
                    
                    otherwise
                    do:
                        if cgiVars eq '':u then
                            assign cgiVars = req:ContextNames.
                        
                        if lookup(args[1], cgiVars) eq 0 then
                            assign pArgs:TokenValue = ?.
                        else
                            assign pArgs:TokenValue = req:GetContextValue(args[1]).
                    end.
                end case.   // args[1]
            end.
         end case.
    end method.
    
end class.
