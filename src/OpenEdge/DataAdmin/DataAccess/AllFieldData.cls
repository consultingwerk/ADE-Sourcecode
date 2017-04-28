 /*************************************************************/
 /* Copyright (c) 2016 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : AllFieldData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Fri Mar 04 12:52:38 IST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAccess.DataAccess from propath.
 
using OpenEdge.DataAdmin.DataSource.IDataSource from propath.
using OpenEdge.DataAdmin.DataSource.AllFieldDataSource from propath.

using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.ISaveRequest from propath.
using OpenEdge.DataAdmin.Message.ITableRequest from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataAccess.AllFieldData inherits DataAccess: 
    
    define variable mfieldrel as handle no-undo.
    define variable mindexrel as handle no-undo.
   
    method public override void FetchData(msg as IFetchRequest):  
        url = msg:URL. 
        FillData(msg). 
    end method.  
    
    method public void FillData(msg as IFetchRequest):
        define variable hBuffer as handle no-undo.
        define variable cQuery as character no-undo.
        define variable allfieldDataSource as IDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.     
        hBuffer = msg:DataHandle:get-buffer-handle("ttField").          
        if valid-handle(hBuffer) then
        do:
            allfieldDataSource = new AllFieldDataSource().
            cQuery = msg:GetTableQuery("ttField").  
            PrepareSource(allfieldDataSource,hBuffer,cQuery).       
                           
            /*               
            allfieldDataSource =  new AllFieldDataSource().
            tableRequest = msg:GetTableRequest("ttField").
            if valid-object(tableRequest) then 
                 PrepareSource(allfieldDataSource,hBuffer,tableRequest).   
            else  
                 PrepareSource(allfieldDataSource,hBuffer,""). */  
        end.
        msg:DataHandle:Fill().
        if valid-object(allfieldDataSource) and allfieldDataSource:NumRecords <> ? then 
                msg:SetTableTotal("ttField",allfieldDataSource:NumRecords).
           
        finally: /* no GC when set-callabck is used */                        
            delete object allfieldDataSource no-error.
        end finally.    
      
    end method. 
     
 
    method protected void PrepareSource(src as IDataSource,phbuffer as handle,pcQuery as char,pcFillMode as char):     
        src:FillMode = pcFillMode.
        src:Url = Url.
        src:Prepare(phBuffer,pcQuery,"").
    end method.     
    
    method protected void PrepareSource(src as IDataSource,phBuffer as handle,req as ITableRequest):     
        src:FillMode = "Replace".
        src:Url = Url.
        src:Prepare(phBuffer,req).
    end method.    
    
    method protected void PrepareSource(src as IDataSource,phbuffer as handle,pcQuery as char):     
         this-object:PrepareSource(src,phbuffer,pcquery,"Replace").
    end method.      

end class.