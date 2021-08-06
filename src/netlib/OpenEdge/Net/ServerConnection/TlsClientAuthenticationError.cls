/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
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
using Progress.Lang.SysError.

class OpenEdge.Net.ServerConnection.TlsClientAuthenticationError inherits ApplicationError
serializable:
    /* Static constructor */
    constructor static TlsClientAuthenticationError():
        ApplicationError:AddError(
            get-class(TlsClientAuthenticationError),
            /* short message */
            'TLS Client Authentication Error for &2:&3: &4 (code: &1)',
            /* message */
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
        
        if valid-object(pInnerError)
        and type-of(pInnerError, SysError)
        and pInnerError:GetMessageNum(1) eq 9318
        then
        do:
            // Secure Socket Layer (SSL) failure. error code 336151570:  SSL routines (9318)
            assign msg    = pInnerError:GetMessage(1)
                   pos[1] = index(msg, ':')
                   pos[2] = r-index(msg, OpenEdge.Core.StringConstant:SPACE, pos[1])
                   .
            // get the error code if we can
            if pos[2] + 1 lt pos[1] then
            do:
                assign errorCode = integer(substring(msg, pos[2] + 1, pos[1] - pos[2] - 1)).
                AddMessage(string(errorCode), 1).
            end.
            else
                AddMessage('?':u, 1).
        end.
        else
            AddMessage('?':u, 1).
        
        AddMessage(pUri:Host, 2).
        AddMessage(string(pUri:Port), 3).
        
        case errorCode:
            when 336151570 then AddMessage('Client certificate not specified', 4).
            when 336151574 then AddMessage('Client certificate not known to server', 4).
            when 101077092 then AddMessage('Client credentials incorrect', 4).
            when 151584876 then AddMessage('Invalid client certificate format', 4).
            otherwise           AddMessage('Unknown error', 4).
        end case.
    end constructor.
    
end class.