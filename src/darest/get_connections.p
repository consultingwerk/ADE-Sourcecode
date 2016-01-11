/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : get_connections.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.IAreaSet from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Rest.Connection from propath.

{darest/restbase.i get connections}
 
procedure Execute :
    define input  parameter restRequest as IRestRequest  no-undo.
     
    /* ***************************  Definitions  ************************** */
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable connection   as Connection  no-undo.
       
    /* ***************************  Main Block  *************************** */
    
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl. 
    cFile = restRequest:FileName.
    cFileOut = restRequest:OutFileName.

    if restRequest:NumLevels > 0 then 
        undo, throw new UnsupportedOperationError(restRequest:ConnectionUrl).
     
    connection = new Connection(service). 
    connection:ExportNormalized(cFileOut).
    
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
end.
 
    
