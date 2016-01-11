/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_users.p
    Purpose     : 

    Syntax      :

    Description : This is the API for post users ST034

    Author(s)   : rkumar
    Created     : Wed Mar 16 14:59:22 IST 2011
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.
using OpenEdge.DataAdmin.IUser.
using OpenEdge.DataAdmin.IUserSet.

define variable mMode       as char init "post" no-undo.
define variable mCollection as char init "users" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value(mMode + "_" + mCollection + ".log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  
 
procedure executeRequest:
    define input  parameter pcParam as character no-undo.     
    /* ***************************  Definitions  ************************** */
    define variable tuser          as IUser no-undo.
    define variable userset        as IUserSet no-undo.
    define variable restRequest    as RestRequest no-undo.
    define variable service        as DataAdminService no-undo.
    define variable errorHandler   as DataAdminErrorHandler no-undo.
    define variable cFile          as character no-undo.
    define variable cFileOut       as character no-undo.
    define variable clong as longchar no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
     
    service:URL = restRequest:ConnectionUrl.
    assign
       cFile = restRequest:FileName
       cFileOut = restRequest:OutFileName.
    

    if restRequest:KeyValue[1] > "" then 
        undo, throw new UnsupportedOperationError("Post with key in URL:" + restRequest:RequestUrl).     
    else if restRequest:CollectionName[1] = "users" then 
    do:
        userset = service:NewUsers().
        userset:Import(cFile).
        service:CreateUsers(userset).  
        userset:ExportLastSaved(cFileOut).
       
       
       copy-lob file cFileOut to clong.     
       substring(cLong,2,0) = '"success" : true,'.
       copy-lob clong to file cFileOut.
    end.    
    else
        undo, throw new UnsupportedOperationError("Could not understand URL:" + restRequest:ConnectionUrl).     
 
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