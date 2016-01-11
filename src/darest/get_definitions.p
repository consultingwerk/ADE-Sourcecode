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
using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
 

define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "definitions" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_definitions.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  
 
procedure executeRequest:
    define input  parameter pcParam as character no-undo.   

    
    /* ***************************  Definitions  ************************** */
    define variable definitions  as ISchema no-undo.
    define variable restRequest  as RestRequest no-undo.
    define variable service      as IDataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
     
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
   