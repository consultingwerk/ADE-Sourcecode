/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : delete_domains.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2011
    Notes       :     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ITenant from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest  from propath.

 define stream acceptstream. 
/* to be deprecated */
{darest/restbase.i delete domains}
 
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.

    /* ***************************  Definitions  ************************** */
    define variable service              as DataAdminService no-undo.
    define variable errorHandler         as DataAdminErrorHandler no-undo.
    define variable cFile                as character no-undo.
    define variable cFileOut             as character no-undo.
   
    define variable cLong as longchar no-undo.
     
    /* ***************************  Main Block  *************************** */
    
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
    
    If restRequest:KeyValue[1] <> ? then
    do: 
        if restRequest:NumLevels = 1 then
            service:DeleteDomain(restRequest:KeyValue[1]).
        else 
        do:
            undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).              
        end.    
        
        output stream  acceptstream to value(cFileOut).
        put stream  acceptstream unformatted "HTTP/1.1 200 OK" skip (1)
        '~{"success" : true~}'.
        output stream  acceptstream  close.
    end.
    else 
        undo, throw new UnsupportedOperationError("DELETE with no key in URL:" + restRequest:RequestUrl).    
     
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler = new DataAdminErrorHandler(restRequest:ErrorFileName).
        else do:
            
            errorHandler = new DataAdminErrorHandler().
        end.
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.		
    end finally.
end.