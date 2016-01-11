/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : TenantGroupMember
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.TenantGroupContext.
using OpenEdge.DataAdmin.Core.CodeWriter.
using OpenEdge.DataAdmin.Core.JSONWriter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.InvalidPropertyValueError.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError.
using OpenEdge.DataAdmin.Error.UnknownValueError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IArea.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminExporter.
using OpenEdge.DataAdmin.IDataAdminSerializable.
using OpenEdge.DataAdmin.IPartitionCollection.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ITable.
using OpenEdge.DataAdmin.ITenant.
using OpenEdge.DataAdmin.ITenantGroup.
using OpenEdge.DataAdmin.ITenantGroupMember.
using OpenEdge.DataAdmin.IUserSet.
using OpenEdge.DataAdmin.TenantGroup.
using OpenEdge.DataAdmin.TenantGroupMember.
using Progress.Lang.Error.
using Progress.Lang.Object.



class OpenEdge.DataAdmin.TenantGroupMember inherits Entity implements ITenantGroupMember:
    
    /* implements ITenant, IDataAdminElement, IDataAdminSerializable */  
    define private property ValidTypeList as char 
       init "Regular,Super"
       get.
         
        
    
    define private variable mChild as logical no-undo. 

             
    define public property TenantGroup as ITenantGroup no-undo                 
        get():
            if not valid-object(TenantGroup) then
            do:
                if valid-handle(mBuffer) then
                    this-object:TenantGroup = Service:GetTenantGroup(mBuffer::TenantGroupName).
            
            end.
            return TenantGroup. 
            
        end.
        set(pGroup as ITenantGroup):
            if not valid-object(pGroup) then 
                undo, throw new UnknownValueError("TenantGroup").
/*            if valid-object(TenantGroup) then                                          */
/*                undo, throw new ReadOnlyPropertyError("TenantGroupMember","","Tenant").*/
/*                                                                                          */
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::TenantGroupName = pGroup:Name.
            end.
            TenantGroup = pGroup.
        end. 
    
     define public property Tenant as ITenant no-undo 
        get():
             if not valid-object(Tenant) then
             do:
                 if valid-handle(mBuffer) and mBuffer::TenantName > "" 
                 and valid-object(Service) then
                     Tenant = Service:GetTenant(mBuffer::TenantName).            
             end.
             return tenant.
        end.     
        set(pTenant as ITenant ):
/*            if valid-object(Tenant) then                                                                   */
/*                undo, throw new ReadOnlyPropertyError("TenantGroupMember",TenantGroup:name,"Tenant").*/
            /*
            if valid-object(Service) then 
                undo, throw new ReadOnlyPropertyError("Domain",name,"Tenant").     
            */
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::TenantName = pTenant:name.
            end.
            Tenant = pTenant.    
        end.
        
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public TenantGroupMember (pGroup as ITenantGroup,pTenant as ITenant  ):
        super (pGroup:name + chr(1) + pTenant:name).
        if not valid-object(pTenant) then
            undo, throw new UnknownValueError("TenantGroupMember constructor","tenant").   
        Tenant = pTenant.
        TenantGroup = pGroup.    
        
    end constructor.   
    
    constructor public TenantGroupMember ():
        super ("").   
    end constructor.
       
    constructor public TenantGroupMember (pcntxt as IDataAdminModel ):
        super (pcntxt).   
    end constructor.
   
    constructor public TenantGroupMember (pcntxt as IDataAdminModel,preq as IRequestInfo ):
        super (pcntxt).   
    end constructor.
        
     /* No local context needed - currently not used to create    */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
    
/*    method override logical Equals(obj as Object):            */
/*        define variable tnt as TenantGroupMember no-undo.     */
/*        if super:Equals(obj) then                             */
/*            return true.                                      */
/*        else do:                                              */
/*            tnt = cast(obj,TenantGroupMember).                */
/*            if  this-object:ContextId = tnt:ContextId         */
/*            and this-object:Tenant = tnt:Tenant               */
/*            and this-object:TenantGroup = tnt:TenantGroup then*/
/*                return true.                                  */
/*        end.                                                  */
/*        return false.                                         */
/*        catch e as Error :                                    */
/*            return false.                                     */
/*        end catch.                                            */
/*    end method.                                               */
    
    method public override void Export():
        export("tenantgroupmember.json").
    end method.          
    
    method protected character GetCreateError():
        return "TenantGroupMember was not " 
               + (if valid-object(Service) 
                  then "created in service " + quoter(Service:Name) 
                  else "added to TenantGroupMemberSet")
               + ".". 
    end method.
    
    method public override void WriteTree(tree as IContextTree):
        tree:SetHandle(SerializeName,mDefaultBuffer,mDefaultBuffer:rowid).                
    end method.
   
      /* write specified collections (default all) */
    method public override  void WriteTree(tree as IContextTree,pcCollections as char):
        WriteTree(tree).  
    end method.
     
    method public override void ExportTree(pcfile as char):
        define variable writer as IDataAdminExporter no-undo.
        writer = GetExporter(pcfile).
        writer:WriteToFile(this-object,pcfile,"All").
    end method.     
    
    method public override void ExportTree(pcfile as char,pcCollectionlist as char):
        define variable writer as IDataAdminExporter no-undo.
        writer = GetExporter(pcfile).
        writer:WriteToFile(this-object,pcfile,pcCollectionlist).
    end method.     
   
end class.
