/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_sequences.p
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
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
 
/* to be deprecated */
{darest/restbase.i post sequences} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.   
    /* ***************************  Definitions  ************************** */
   
    define variable sequences    as ISequenceSet no-undo.
    define variable seq          as ISequence    no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable clong        as longchar no-undo.
    define variable LineFeed as character init "~r~n" no-undo.
  
    /* ***************************  Main Block  *************************** */
    
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    assign
       cFile = restRequest:FileName
       cFileOut = restRequest:OutFileName.
       
    if restRequest:KeyValue[1] > "" then 
    do:
        if restRequest:NumLevels > 1 then
            undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).  
        
        seq = service:NewSequence(restRequest:KeyValue[1]).
        seq:Import(cFile).
        service:CreateSequence(seq).
        seq:Export(cFileOut).
        copy-lob file cFileOut to clong.     
        substring(cLong,2,0) = '"success" : true,' + LineFeed.
        copy-lob clong to file cFileOut.
    end.
    else if restRequest:CollectionName[1] = "sequences" then 
    do:
        sequences = service:NewSequences().
        sequences:Import(cFile).
        service:CreateSequences(sequences).
        sequences:ExportLastSaved(cFileOut).
        copy-lob file cFileOut to clong.     
        substring(cLong,2,0) = '"success" : true,' + LineFeed.
        copy-lob clong to file cFileOut.
    end.    
    
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