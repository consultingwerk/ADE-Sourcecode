
/*------------------------------------------------------------------------
    File        : get_areas.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Jun 19 15:53:21 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.IAreaSet from propath.
using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.

define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "areas" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_areas.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  

procedure executeRequest:
    define input  parameter pcURL as character no-undo.
     
    /* ***************************  Definitions  ************************** */
    define variable area         as IArea no-undo.
    define variable areas        as IAreaSet no-undo.
    define variable restRequest  as RestRequest no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut        as character no-undo.     
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcUrl).  
     
    service = new DataAdminService(restRequest:ConnectionName).
      
    restRequest:Validate().
    service:URL = restRequest:ConnectionUrl. 
    cFile = restRequest:FileName.
    cFileOut = restRequest:OutFileName.
      
    if restRequest:KeyValue[1] > "" then 
    do:
        area = service:GetArea(restRequest:KeyValue[1]).
        if not valid-object(area) then 
            undo, throw new NotFoundError("Area '"  + restRequest:KeyValue[1]  + "' not found").
        area:ExportTree(cFileOut).
    end.
    else do:
        pageRequest = restRequest:GetPageRequest().
        if valid-object(pageRequest) then 
            areas = service:GetAreas(pageRequest).
        else
        if restRequest:Query > "" then 
            areas = service:GetAreas(restRequest:Query).
        else 
            areas = service:GetAreas().
            
        areas:ExportList(cFileOut).
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