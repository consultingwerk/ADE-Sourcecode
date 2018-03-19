/*************************************************************/
/* Copyright (c) 2011-2017 by Progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_securityoptions.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : Fri Nov 18 16:40:40 IST 2011
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */

/* ***************************  Main Block  *************************** */
routine-level on error undo, throw.

using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.JSONObject from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ISecurityOptions from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
 

define temp-table ttOptions serialize-name "securityOptions" 
    field TrustApplicationDomainRegistry       as log  serialize-name "trustApplicationDomainRegistry"
    field RecordAuthenticatedSessions          as log  serialize-name "recordAuthenticatedSessions"
    field DisallowBlankUserid                  as log  serialize-name "disallowBlankUserid"
    field UseRuntimePermissions                as log  serialize-name "useRuntimePermissions"
    field CDCUserid                            as char  serialize-name "cdcUserid"
 .
 
{darest/restbase.i get securityoptions}  

procedure Execute:
    define input parameter restRequest as IRestRequest  no-undo.
    define variable secopt     as ISecurityOptions no-undo. 
 
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
       
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
    secopt = service:GetSecurityOptions().
    secopt:Export(restRequest:OutFileName).
    
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
