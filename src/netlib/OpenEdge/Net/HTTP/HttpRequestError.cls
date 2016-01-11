/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpRequestError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 13:06:33 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.HttpRequestError.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ErrorSeverityEnum.
using Progress.Lang.Error.

class OpenEdge.Net.HTTP.HttpRequestError  inherits ApplicationError: 
    constructor static HttpRequestError():
        ApplicationError:AddError(
            get-class(HttpRequestError),
            /* short message */
            'Http Request Error: status &1',
            /* message */
            'Status code &1 for &2 operation at URI &3').       
    end constructor.
        
    constructor public HttpRequestError (input pcStatusCode as character,
                                         input pcMethod as character,
                                         input pcURI as character):
        this-object(?, pcStatusCode, pcMethod, pcURI).       
    end constructor.

    constructor public HttpRequestError (input poInnerError as Error, 
                                         input pcStatusCode as character,
                                         input pcMethod as character,
                                         input pcURI as character):
        super(poInnerError).
        
        AddMessage(pcStatusCode, 1).
        AddMessage(pcMethod, 2).
        AddMessage(pcURI, 1).
    end constructor.

end class.