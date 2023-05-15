/************************************************
Copyright (c) 2021, 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : TlsClientAuthenticationError
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-03-17
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Net.ServerConnection.TlsClientAuthenticationError.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Lang.SysError.

class OpenEdge.Net.ServerConnection.TlsClientAuthenticationError inherits ApplicationError
serializable:

    /* Static constructor */
    constructor static TlsClientAuthenticationError():
        ApplicationError:AddError(get-class(TlsClientAuthenticationError),
                                  /* short message */
                                  'TLS Client Authentication Error for &2:&3: &4 (code: &1)',
                                  /* error message */
                                  'TLS Client Authentication Error for &2:&3: &4 (code: &1)').
    end constructor.
    
    /* Constructor
       
       @param URI The host that raised the stop condition
       @param PLStop The stop condition raised */
    constructor public TlsClientAuthenticationError (input pURI as URI,
                                                     input pInnerStop as Progress.Lang.Stop):
        super(pInnerStop).
        
        Assert:NotNull(pURI, 'Host URI').
        
        AddMessage('?':u, 1).
        AddMessage(pUri:Host, 2).
        AddMessage(string(pUri:Port), 3).
        AddMessage('Unknown error', 4).
    end constructor.
    
    /* Constructor
       
       @param URI The host that raised the error condition
       @param PLError The error raised. SysError 9318 is parsed for the error code */
    constructor public TlsClientAuthenticationError (input pURI as URI,
                                                     input pInnerError as Progress.Lang.Error):
        var integer[2] pos.
        var character msg.
        var integer errorCode.
        
        super(pInnerError).
        
        Assert:NotNull(pURI, 'Host URI').

        // Only perform inspection on a valid error object if of type SysError and message number is 9318.
        if valid-object(pInnerError)
        and type-of(pInnerError, SysError)
        and pInnerError:GetMessageNum(1) eq 9318
        then
        do:
            // Secure Socket Layer (SSL) failure. error code <#>:  SSL routines (9318)
            assign msg    = pInnerError:GetMessage(1)
                   pos[1] = index(msg, ':') // Look for the first ":" character in the message
                   pos[2] = r-index(msg, OpenEdge.Core.StringConstant:SPACE, pos[1]) // Get right-most space before that ":"
                   .
            // Get the error code if we can (starting just after the " " and before the ":")
            if pos[2] + 1 lt pos[1] then
            do:
                assign errorCode = integer(trim(substring(msg, pos[2] + 1, pos[1] - pos[2] - 1))).
                AddMessage(string(errorCode), 1). // Add only the error number as the first message.
            end.
            else
                AddMessage('?':u, 1). // No error number derived from inner error message.
        end.
        else
            AddMessage('?':u, 1). // No error number available.

        // Add only the hostname as the second message.
        AddMessage(pUri:Host, 2).

        // Add only the port as the third message.
        case true:
            when pUri:Port ne ? then
                AddMessage(string(pUri:Port), 3).
            when pUri:Scheme eq string(UriSchemeEnum:http) then
                AddMessage("80", 3). // Use default for HTTP
            when pUri:Scheme eq string(UriSchemeEnum:https) then
                AddMessage("443", 3). // Use default for HTTPS
        end case.

        case errorCode:
            // Add a user-friendly error as the fourth message when a valid error code is found.
            when 336151538 then AddMessage('Unable to use specified TLS Supported Groups', 4).
            when 336151570 then AddMessage('Client certificate not specified', 4).
            when 336151574 then AddMessage('Client certificate not known to server', 4).
            when 101077092 then AddMessage('Client credentials incorrect', 4).
            when 151584876 then AddMessage('Invalid client certificate format', 4).
            otherwise do:
                // Return the inner error message when available as it may contain useful information.
                if (msg gt "") eq true then
                    AddMessage(msg, 4).
                else
                    AddMessage('Unknown error', 4).
            end.
        end case.
    end constructor.
    
end class.