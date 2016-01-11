 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : AuthenticationSystemDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : feb 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataSource.DataSource from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath. 
using OpenEdge.DataAdmin.DataAccess.DataMapper from propath.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.AuthenticationSystemDataSource inherits DataSource: 
    define buffer b_authenticationsystem for dictdb._Sec-Authentication-System.
    define protected variable mBuffer as handle no-undo.
    define variable cErrorMap as character no-undo.
    define private variable msave as logical no-undo.
    define private variable mMapping as char
       init     
"Name,_Domain-type,~
Description,_Domain-type-description,~
Comments,_Custom-detail"     
     no-undo.
    
    constructor public AuthenticationSystemDataSource (pcurl as char):        
        this-object ( ).   
        url = pcURL. 
    end constructor.
    
    constructor public AuthenticationSystemDataSource ( ):        
        super ("_sec-authentication-system","dictdb._sec-authentication-system", mMapping). 
        BaseQuery = "for each _sec-authentication-system no-lock".
    end constructor.
    
    method public override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        phBuffer:set-callback("After-Row-fill","AfterRow").
        super:Prepare(phBuffer,pcTargetQuery,pcJoin).
        mBuffer = phBuffer.
    end method.
    
    method public override logical Save(phBuffer as handle):
        define variable hBeforeBuff as handle    no-undo.     
        define variable hquery      as handle    no-undo.
        define variable hDataset    as handle    no-undo.
        define variable mapper     as DataMapper no-undo.
        define variable cMsg as character no-undo.
       
        create query hquery.
        hBeforeBuff = phBuffer:before-buffer.
        
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare("for each ttAuthenticationSystemCopy").    
        hquery:query-open().
        
        do while true:
            
            hquery:get-next.
            if not hBeforebuff:avail then 
                leave.
         
            if hBeforeBuff:row-state = row-deleted then 
            do:
                find b_authenticationsystem where b_authenticationsystem._domain-type = hBeforeBuff::Name exclusive.
                delete  b_authenticationsystem.
            end.
            else do:
                phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
             
                if hBeforeBuff:row-state = row-created then 
                do:
                    create dictdb._sec-authentication-system.
                    assign 
                       dictdb._sec-authentication-system._Domain-type = phBuffer::Name
                       /* PAM plug in is currrenty not exposed in any tools or APIs, but 
                          shopuld default to NO for now (as in DataAdmin tool ) */  
                       dictdb._sec-authentication-system._PAM-plug-in = no.
                end. 
                else do:
                  find dictdb._sec-authentication-system
                       where dictdb._sec-authentication-system._Domain-type = phbuffer::Name exclusive no-error.
                end.    
            
                assign 
                   dictdb._sec-authentication-system._Domain-type-description = phBuffer::Description
                   dictdb._sec-authentication-system._Custom-detail = phBuffer::Comments. 
                 
                 
                hdataset = phBuffer:dataset.
                msave = true.
                AfterRow (dataset-handle hdataset  by-reference).
                msave = false.
        
           end. /* end of else row-deleted */ 
        end.
 
        return true.   
        catch e as Progress.Lang.Error :
            mapper = new DataMapper("Authentication System,_sec-authentication-system,Domain,_sec-authentication-domain",mmapping).
            /* replace domain type with name */   
            if e:GetMessageNum(1) = 132 then
            do:
                cMsg = replace(e:GetMessage(1),"Domain type","name").
                undo, throw new DataAccessError(mapper,cMsg,e:GetMessageNum(1),e).
            end.
            else           
                undo, throw new DataAccessError( mapper ,  e). 
        end catch.   
                    
    end method.    
    
    method public override void AfterRow(dataset-handle hds):
        define variable hbuffer as handle no-undo.
        define variable typeurl as character no-undo.
        define variable iSource as integer no-undo.
        
        assign
            hBuffer       = hds:get-buffer-handle("ttAuthenticationSystem")
            hBuffer::Url = Url + "/authenticationsystems/" + WebUtil:UrlEncode(hBuffer::Name). 

        if not msave then   
        do:
             isource = lookup("_sec-authentication-system",Tables).
             hBuffer::IsBuiltin  = DataSourceHandle:get-source-buffer(isource)::_Domain-type begins "_".
        end.
    end method.                 
    
end class.