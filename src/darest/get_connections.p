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
using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Rest.Connection from propath.

define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "connections" no-undo.
/*                                                                                                 */
/*define temp-table ttConnection serialize-name "connection"                                       */
/*   field DatabaseUser         as char serialize-name "databaseUser"                              */
/*   field TenantName           as char serialize-name "tenantName"                                */
/*   field TenantType           as char serialize-name "tenantType"                                */
/*   field DomainName           as char serialize-name "domainName"                                */
/*                                                                                                 */
/*   field Administrators_url     as char serialize-name "administrators_url"                      */
/*   field Areas_url              as char serialize-name "areas_url"                               */
/*   field CountTenants_url       as char serialize-name "counttenants_url"                        */
/*   field CreateGroupScript_url  as char serialize-name "creategroupscript_url"                   */
/*   field CreateTenantScript_url as char serialize-name "createtenantscript_url"                  */
/*   field DataSecurity_url       as char serialize-name "datasecurity_url"                        */
/*   field Definitions_url        as char serialize-name "definitions_url"                         */
/*   field Domains_url            as char serialize-name "domains_url"                             */
/*   field DomainTypes_url        as char serialize-name "domaintypes_url"                         */
/*   field Groups_url             as char serialize-name "groups_url" /* uses *_partitiongroups.p*/*/
/*   field Permissions_url        as char serialize-name "permissions_url"                         */
/*   field Schemas_url            as char serialize-name "schemas_url"                             */
/*   field SecuritySummary_url    as char serialize-name "securitysummary_url"                     */
/*   field Sequences_url          as char serialize-name "sequences_url"                           */
/*   field Tenants_url            as char serialize-name "tenants_url"                             */
/*   field UserPermissions_url    as char serialize-name "userpermissions_url"                     */
/*   field Users_url              as char serialize-name "users_url"                               */
/*   .                                                                                             */
   

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_connections.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  

procedure executeRequest:
    define input  parameter pcURL as character no-undo.
     
    /* ***************************  Definitions  ************************** */
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable connection   as Connection  no-undo.
       
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcUrl).  
     
    service = new DataAdminService().
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
 
    
