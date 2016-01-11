/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_sequences.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ISequenceSet from propath.
using OpenEdge.DataAdmin.ISequence from propath.
using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
 
define variable mMode       as char init "put" no-undo.
define variable mCollection as char init "sequences" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("put_sequences.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  
 
procedure executeRequest:
    define input  parameter pcParam as character no-undo.      
    /* ***************************  Definitions  ************************** */
   
    define variable sequences    as ISequenceSet no-undo.
    define variable seq          as ISequence    no-undo.
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable clong        as longchar no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    assign
       cFile = restRequest:FileName
       cFileOut = restRequest:OutFileName.
       
    
    if restRequest:KeyValue[1] > "" then 
    do:
        seq = service:GetSequence(restRequest:KeyValue[1]).
        if seq = ? then
            undo, throw new NotFoundError("Sequence "  + restRequest:KeyValue[1]  + " not found").
         
        seq:Import(cFile).
        service:UpdateSequence(seq).
        seq:Export(cFileOut).
       
       
       copy-lob file cFileOut to clong.     
       substring(cLong,2,0) = '"success" : true,'.
       copy-lob clong to file cFileOut.
    end.
    else if restRequest:CollectionName[1] = "sequences" then 
    do:
        sequences = service:GetSequences().
        sequences:Import(cFile).
        service:UpdateSequences(sequences).
        sequences:ExportLastSaved(cFileOut).
       
       
       copy-lob file cFileOut to clong.     
       substring(cLong,2,0) = '"success" : true,'.
       copy-lob clong to file cFileOut.
    end.    
    else
        undo, throw new UnsupportedOperationError("PUT with no key in URL:" + restRequest:ConnectionUrl).     
    
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