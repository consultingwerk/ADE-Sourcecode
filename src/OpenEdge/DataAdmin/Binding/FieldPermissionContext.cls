 /*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : FieldPermissionContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :   2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IServiceContextFactory.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.FieldPermission.
using OpenEdge.DataAdmin.FieldPermissionSet.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.*. 

class OpenEdge.DataAdmin.Binding.FieldPermissionContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/fieldpermission.i}
     
    define private dataset dsFieldPermission serialize-name "root" for ttFieldPermission.
    define buffer bFieldPermission for ttFieldPermission.
    define temp-table copyFieldPermission reference-only like ttFieldPermission .  
 
    
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttFieldPermission:handle.
    	end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return TableHandle:default-buffer-handle:Keys. 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bFieldPermission for ttFieldPermission.
            if Count = ? then
            do:
                Count = 0.
                for each bFieldPermission:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
        
        
    constructor public FieldPermissionContext (pscope as IServiceContextFactory):
        super ("FieldPermission",pscope).
    end constructor.
    
    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsFieldPermission:handle. 
    end method.
    
	method public override void CopyTable(cntxt as IDataAdminModel).
        undo, throw new UnsupportedOperationError("Copy FieldPermission").
    end method. 
     
    method public override void CreateRow(entity as IDataAdminElement):
        undo, throw new UnsupportedOperationError("Create FieldPermission row").
    end method. 
	
    method public override character GetJoinFields(parentid as char):
        case parentid:
            when "tablePermissions" then 
                 return "Name,TableName".
        end.
        return "".
    end.
    
	method public override logical CanFind(name as character):
        undo, throw new UnsupportedOperationError("CanFind of FieldPermission with single key.").
    end.    

    method public  logical CanFind(ptable as char,pname as character):
        return can-find(ttFieldPermission 
                       where ttFieldPermission.Tablename = pTable
                       and ttFieldPermission.name = pname).            
    end.    
    
    method public override logical Find(name as character):
        undo, throw new UnsupportedOperationError("Find of FieldPermission with single key.").
    end.   
     
    method public logical Find(ptable as char,pname as character):
        find ttFieldPermission where ttFieldPermission.Tablename = pTable
                               and ttFieldPermission.name = pname no-error.
        return avail ttFieldPermission.            
    end.   
     
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new FieldPermissionSet(cntxt). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(pReq as IRequestInfo):
        return new FieldPermission(this-object,pReq).
    end method.

/*    method public override void DataRefreshed(pResponse as OpenEdge.DataAdmin.Message.IFetchResponse):*/
/*        super:DataRefreshed(pResponse).                                                               */
/*        ShowPartitionData().                                                                          */
/*    end method.                                                                                       */
/*                                                                                                      */
/*    method protected void ShowPartitionData():                                                        */
/*        current-window:width = 200.                                                                   */
/*        for each ttFieldPermission with width 200:                                                    */
/*            display                                                                                   */
/*               ttFieldPermission.TableName                                                            */
/*               ttFieldPermission.Name                                                                 */
/*               .                                                                                      */
/*        end.                                                                                          */
/*                                                                                                      */
/*    end method.                                                                                       */
end class.
