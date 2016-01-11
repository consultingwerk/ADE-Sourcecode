/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_definitions.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Jun 19 15:53:21 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*  from propath.
using OpenEdge.DataAdmin.IDataAdminService from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ISchema from propath. 
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
 
  
 
{darest/restbase.i get definitions}
 
procedure Execute :
    define input  parameter restRequest as IRestRequest  no-undo.

    /* ***************************  Definitions  ************************** */
    define variable definitions  as ISchema no-undo.
    define variable service      as IDataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    /* ***************************  Main Block  *************************** */
     
    service = new DataAdminService(restRequest:ConnectionName). 
    restRequest:Validate().
    service:URL = restRequest:ConnectionUrl.
    definitions = service:GetSchemaChanges(restRequest:FileName2). 
    cFile = restRequest:FileName.
    cFileOut = restRequest:OutFileName.
    definitions:ExportTree(cFileOut).
  
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
   