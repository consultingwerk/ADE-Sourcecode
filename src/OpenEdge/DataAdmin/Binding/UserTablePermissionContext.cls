 /*************************************************************/
USING OpenEdge.DataAdmin.Binding.ContextTree.
USING OpenEdge.DataAdmin.Binding.DataAdminContext.
USING OpenEdge.DataAdmin.Binding.Factory.IServiceContextFactory.
USING OpenEdge.DataAdmin.Binding.IContextTree.
USING OpenEdge.DataAdmin.Binding.IDataAdminContext.
USING OpenEdge.DataAdmin.Binding.IDataAdminModel.
USING OpenEdge.DataAdmin.Binding.ServiceAdapter.
USING OpenEdge.DataAdmin.Binding.ServiceAdapter.
USING OpenEdge.DataAdmin.Binding.UserFieldPermissionContext.
USING OpenEdge.DataAdmin.DataAdminService.
USING OpenEdge.DataAdmin.Error.UnsupportedOperationError.
USING OpenEdge.DataAdmin.IDataAdminCollection.
USING OpenEdge.DataAdmin.IDataAdminElement.
USING OpenEdge.DataAdmin.IRequestInfo.
USING OpenEdge.DataAdmin.Message.FetchRequest.
USING OpenEdge.DataAdmin.Message.IFetchRequest.
USING OpenEdge.DataAdmin.Message.ISaveRequest.
USING OpenEdge.DataAdmin.Message.SaveRequest.
USING OpenEdge.DataAdmin.UserTablePermission.
USING OpenEdge.DataAdmin.UserTablePermissionSet.
USING Progress.Lang.*.
 /* Copyright (c) 2011 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : UserTablePermissionContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :   2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
class OpenEdge.DataAdmin.Binding.UserTablePermissionContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/usertablepermission.i}
     
    define private dataset dsTablePermission serialize-name "root" for ttUserTablePermission.  
    
    define variable mLastSavedTable as handle no-undo.
     
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttUserTablePermission:handle.
    	end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return "UserRef,Name". 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bPerm for ttUserTablePermission.
            if Count = ? then
            do:
                Count = 0.
                for each bPerm:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
    constructor public UserTablePermissionContext (pScope as IServiceContextFactory):
        define variable cntxt as IDataAdminModel no-undo.
        super ("UserTablePermission",pScope).
        cntxt = pScope:GetUserFieldPermissionContext().
        cntxt:Lazy = false.
        AddChild(cntxt).  
    end constructor.
      
    method override protected handle InitDataset ():
        return dataset dsTablePermission:handle. 
    end method.
    
    method public override void CopyTable(cntxt as IDataAdminModel).
        undo, throw new UnsupportedOperationError("Copy UserTablePermission").
    end method. 
     
    method public override void CreateRow(entity as IDataAdminElement):
        undo, throw new UnsupportedOperationError("Create UserTablePermission row").
    end method. 
	
    method public override character GetJoinFields(parentid as char):
        case parentid:
            when "userPermissions" then 
                return "Id,UserRef".
        end.
    end.
      
	method public override logical CanFind(name as character):
        undo, throw new UnsupportedOperationError("CanFind of UserTablePermission with single key.").    end.    
    
    method public  logical CanFind(pUser as char,pname as character):
        return can-find(ttUserTablePermission 
                       where ttUserTablePermission.UserRef = pUser
                       and ttUserTablePermission.name = pname).            
    end.    
         
    method public override logical Find(name as character):
          undo, throw new UnsupportedOperationError("Find of UserTablePermission with single key.").
    end.   
    
    method public logical Find(pUser as char,pname as character):
        find ttUserTablePermission where ttUserTablePermission.UserRef = pUser
                                   and   ttUserTablePermission.name = pname no-error.
        return avail ttUserTablePermission.            
    end.    
      
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new UserTablePermissionSet(cntxt). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(pReq as IRequestInfo):
        return new UserTablePermission(this-object,pReq). 
    end method. 
end class.
