/************************************************
  Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : AuthTag
    Purpose     : Represents an AuthTag granted to a Role
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : 2023-07-24
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.AuthTagContext.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminSerializable.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IAuthTag.

class OpenEdge.DataAdmin.AuthTag inherits Entity implements IAuthTag, IDataAdminElement,IDataAdminSerializable: 
    define private variable mChild as logical no-undo.
    define private variable myContext as IDataAdminContext no-undo.

    // Note: the default "Name" property of Entity will store the AuthTag name.

    /* The role name to associate with the auth tag */ 
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
	
	constructor public AuthTag (cntxt as IDataAdminModel,preq as IRequestInfo):
        super(cntxt,preq).        
    end constructor.
      
	constructor public AuthTag (cntxt as IDataAdminModel):
        super(cntxt).        
    end constructor.
    
    constructor public AuthTag (tagname as character):
        super(tagname).
    end constructor. 
    
    method protected override IDataAdminModel CreateLocalContext(): 
        return new AuthTagContext().
    end method.
        
    method public override void ExportTree(pcfile as char):
        this-object:Export(pcFile).
    end method.     
     
	method public override  void Export():
		export("authtag.json").
	end method.

end class.
