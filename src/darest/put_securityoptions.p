/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_securityoptions.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : Wed Jan 04 17:59:05 IST 2012
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

 
/* to be deprecated */
{darest/restbase.i put securityOptions} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo. 
     
    /* ***************************  Definitions  ************************** */
   
    define variable secoptions   as ISecurityOptions no-undo. 
 
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable cLong        as longchar   no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest:Validate().
    cFile  = restRequest:fileName.
    cFileOut  = restRequest:OutFileName.
    service = new DataAdminService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
    
    secoptions = service:GetSecurityOptions().
    secoptions:Import(cFile).
    service:UpdateSecurityOptions(secoptions).
    secoptions:Export(cFileOut).
    
    
    copy-lob file cFileOut to clong.     
    substring(cLong,2,0) = '"success" : true, '.
    copy-lob clong to file cFileOut.
    
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else do:       
             
            errorHandler = new DataAdminErrorHandler().
        end.
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
 
end.

 