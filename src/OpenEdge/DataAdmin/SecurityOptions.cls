 /*************************************************************/
 /* Copyright (c) 2011-2017,2019 by Progress Software Corporation  */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : SecurityOptions
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rkumar
    Created     : Thu Nov 24 15:55:18 IST 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminSerializable.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ISecurityOptions.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.*.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.SecurityOptions inherits Entity implements IDataAdminElement, IDataAdminSerializable, ISecurityOptions: 

    define public property TrustApplicationDomainRegistry as logical no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::TrustApplicationDomainRegistry.
            else
                return TrustApplicationDomainRegistry. 
        end.
        
        set(pTrustApplicationDomainRegistry as logical):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::TrustApplicationDomainRegistry = pTrustApplicationDomainRegistry.
            end.
            TrustApplicationDomainRegistry = pTrustApplicationDomainRegistry.
        end. 

    define public property RecordAuthenticatedSessions as logical no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::RecordAuthenticatedSessions.
            else
                return RecordAuthenticatedSessions. 
        end.
        
        set(pRecordAuthenticatedSessions as logical):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::RecordAuthenticatedSessions = pRecordAuthenticatedSessions.
            end.
            RecordAuthenticatedSessions = pRecordAuthenticatedSessions.
        end. 

    define public property DisallowBlankUserid as logical no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::DisallowBlankUserid.
            else
                return DisallowBlankUserid. 
        end.
        
        set(pDisallowBlankUserid as logical):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::DisallowBlankUserid = pDisallowBlankUserid.
            end.
            DisallowBlankUserid = pDisallowBlankUserid.
        end. 

    define public property UseRuntimePermissions as logical no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::UseRuntimePermissions.
            else
                return UseRuntimePermissions. 
        end.
        
        set(pUseRuntimePermissions as logical):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::UseRuntimePermissions = pUseRuntimePermissions.
            end.
            UseRuntimePermissions = pUseRuntimePermissions.
        end. 
        
    define public property CDCUserid as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CDCUserid.
            else
                return CDCUserid. 
        end.
        
        set(pCDCUserid as character):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CDCUserid = pCDCUserid.
            end.
            CDCUserid = pCDCUserid.
        end. 
    define public property SafeUserid as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::SafeUserid.
            else
                return SafeUserid. 
        end.
        
        set(pSafeUserid as character):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::SafeUserid = pSafeUserid.
            end.
            SafeUserid = pSafeUserid.
        end.

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/        
    constructor public SecurityOptions( cntxt as IDataAdminModel ):
        super (cntxt).
    end constructor.
    
    constructor public SecurityOptions( cntxt as IDataAdminModel, preq as IRequestInfo ):
        super (cntxt,pReq).
    end constructor.
    
    
    /* No local context needed - no child collections   */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
     
    method public override void Import(pcfile as char):
        define variable parser as ObjectModelParser no-undo.
        define variable cText as character no-undo.
        define variable json as JSONObject no-undo.   
        parser = new ObjectModelParser().
        json  = cast(parser:ParseFile(pcfile),JSONObject).
        json = json:GetJsonObject(SerializeName). 
        TrustApplicationDomainRegistry = json:GetLogical("trustApplicationDomainRegistry").
        RecordAuthenticatedSessions    = json:GetLogical("recordAuthenticatedSessions").  
        DisallowBlankUserid            = json:GetLogical("disallowBlankUserid").  
        UseRuntimePermissions          = json:GetLogical("useRuntimePermissions").
        CDCUserid                      = json:GetCharacter("cdcUserid"). 
        SafeUserid                     = json:GetCharacter("safeUserid").            
    end method.
     
    method public override void Export(pcfile as char):
        define variable root as JSONObject no-undo.   
        define variable body as JSONObject no-undo.   
        root = new JsonObject().
        body = new JsonObject().
        root:Add(SerializeName,body).
        body:Add("trustApplicationDomainRegistry",TrustApplicationDomainRegistry).
        body:Add("recordAuthenticatedSessions",RecordAuthenticatedSessions).
        body:Add("disallowBlankUserid",DisallowBlankUserid).
        body:Add("useRuntimePermissions",UseRuntimePermissions).
        body:Add("cdcUserid",CDCUserid).        
        body:Add("safeUserid",safeUserid). 
        root:WriteFile(pcFile,yes).
    end method.

end class.