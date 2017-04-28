/*------------------------------------------------------------------------
    File        : GrantedRole
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-25 
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.GrantedRoleContext.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminSerializable.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IRole.

class OpenEdge.DataAdmin.GrantedRole inherits Entity implements IGrantedRole, IDataAdminElement,IDataAdminSerializable: 
    define private variable mChild as logical no-undo.
    define private variable myContext as IDataAdminContext no-undo.
    
    /* The role for this grant */
    define public property Role as IRole no-undo
        get():
             if not valid-object(Role) then
             do:
                 if valid-handle(mBuffer) and mBuffer::RoleName > "" 
                 and valid-object(Service) then
                     return Service:GetRole(mBuffer::RoleName).   
             end.
             return this-object:Role.
        end get.
        set(input pRole as IRole):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).
                mdefaultbuffer::RoleName = pRole:Name.
            end.
            assign this-object:Role = pRole.    
        end set.        
        
    /* Returns true if the Role is built-in (a system role) */ 
    define public property IsBuiltin as logical no-undo                 
         get():
            if valid-handle(mBuffer) then
                return mBuffer::IsBuiltin.
            else
                return IsBuiltin. 
        end.
    
    define public property Id as character no-undo                 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Id.
            else
                return Id. 
        end get.
    
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
  
    /* The user or role that granted the use of this role */  
    define public property Grantor as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Grantor.
            else
                return Grantor. 
        end.
        set(pcGrantor as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Grantor = pcGrantor.
            end.
            assign this-object:Grantor = pcGrantor.
        end. 
    
    /* The user or the role that is granted the use of this role */
    define public property Grantee as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Grantee.
            else
                return Grantee. 
        end.
        set(pcGrantee as character):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Grantee = pcGrantee.
            end.
            assign this-object:Grantee = pcGrantee.
        end. 

    /* Set true if this user or role may grant the use of this role to others */
    define public property CanGrant as logical no-undo 
         init false
         get():
            if valid-handle(mBuffer) then
                return mBuffer::CanGrant.
            else
                return CanGrant. 
        end.
        set(plCanGrant as logical):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CanGrant = plCanGrant.
            end.
            CanGrant = plCanGrant.
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
	
	constructor public GrantedRole (cntxt as IDataAdminModel,preq as IRequestInfo):
        super (cntxt,preq).        
    end constructor.
      
	constructor public GrantedRole (cntxt as IDataAdminModel):
        super (cntxt).        
    
    end constructor.
      
    constructor public GrantedRole (name as character):
        super (name).
    end constructor. 
    
    method protected override IDataAdminModel CreateLocalContext(): 
        return new GrantedRoleContext().  
    end method.
        
    method public override void ExportTree(pcfile as char):
        this-object:Export(pcFile).
    end method.     
     
	method public override  void Export():
		Export("grantedrole.json").
	end method.
	
end class.
