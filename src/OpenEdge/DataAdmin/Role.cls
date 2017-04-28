/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : Role
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-25
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.RoleContext.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminSerializable.
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IRole.

class OpenEdge.DataAdmin.Role inherits Entity implements IRole, IDataAdminElement,IDataAdminSerializable: 
    define private variable mChild as logical no-undo.
    define private variable myContext as IDataAdminContext no-undo.
    
    /* The unique name for the role */ 
    define public property RoleName as character no-undo
        get():
            if valid-handle(mBuffer) then
                return mBuffer::RoleName.
            else
                return RoleName. 
        end.
        set(input pcRoleName as character):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::RoleName = pcRoleName.
            end.
            RoleName = pcRoleName.
        end. 
    
    /* Returns true if the Role is built-in (a system role) */ 
    define public property IsBuiltin as logical no-undo                 
         get():
            if valid-handle(mBuffer) then
                return mBuffer::IsBuiltin.
            else
                return IsBuiltin. 
        end.
    
    define public property Id as integer no-undo                 
         get():
            if valid-handle(mBuffer) then
                return mBuffer::Id.
            else
                return Id. 
    end.      
    
    /* A free text description to describe the purpose and use of the role */   
    define public property Description as character no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Description.
            else
                return Description. 
        end.
        set(pcDescription as character):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Description = pcDescription.
            end.
            Description = pcDescription.
        end. 
  
    /* The name of the user or role that created / owns this role definition. */  
    define public property Creator as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Creator.
            else
                return Creator. 
        end.
        set(pcCreator as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Creator = pcCreator.
            end.
            Creator = pcCreator.
        end. 

    /* This is a free field to hold custom specific role details */   
    define public property CustomDetail as character no-undo
         get():
            if valid-handle(mBuffer) then
                return mBuffer::CustomDetail.
            else
                return CustomDetail. 
        end.
        set(pcCustomDetail as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CustomDetail = pcCustomDetail.
            end.
            CustomDetail = pcCustomDetail.
        end. 
	
	define public property GrantedRoles as IGrantedRoleSet no-undo  
        get():
            if not valid-object(GrantedRoles) then
                assign GrantedRoles = cast(GetChildCollection("GrantedRole"), IGrantedRoleSet).

            return GrantedRoles.     
        end.
        private set. 
	
	constructor public Role (cntxt as IDataAdminModel,preq as IRequestInfo):
        super (cntxt,preq).        
    end constructor.
      
	constructor public Role (cntxt as IDataAdminModel):
        super (cntxt).        
    end constructor.
    
    constructor public Role (name as character):
        super (name).
    end constructor. 
    
    method protected override IDataAdminModel CreateLocalContext(): 
        return new RoleContext().  
    end method.
        
    method public override void ExportTree(pcfile as char):
        this-object:Export(pcFile).
    end method.     
     
	method public override  void Export():
		Export("role.json").
	end method.

end class.
