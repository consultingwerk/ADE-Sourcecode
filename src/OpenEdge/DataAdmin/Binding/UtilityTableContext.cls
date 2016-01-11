 /*************************************************************/
USING OpenEdge.DataAdmin.Binding.IDataAdminContext.
USING OpenEdge.DataAdmin.Binding.UtilityContext.
USING OpenEdge.DataAdmin.Error.IllegalArgumentError.
USING OpenEdge.DataAdmin.IDataAdminCollection.
USING OpenEdge.DataAdmin.IDataAdminElement.
USING OpenEdge.DataAdmin.IRequestInfo.
USING OpenEdge.DataAdmin.ISchema.
USING OpenEdge.DataAdmin.ITable.
USING OpenEdge.DataAdmin.Internal.Util.UtilityTableSet.
USING Progress.Lang.*.
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : UtilityTableContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed May 09 22:32:23 EDT 2012
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
  
class OpenEdge.DataAdmin.Binding.UtilityTableContext inherits UtilityContext: 
    {daschema/tabledata.i reference-only}
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer btbl for ttTableData.
            if Count = ? then
            do:
                Count = 0.
                for each btbl:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
        
	constructor public UtilityTableContext ( ds as handle):
		super ( ds, "Table").
	end constructor.
    
    method public override void Bind(pHdl as handle).
        Bind(table-handle phdl bind).
    end method.    
    
    method private void Bind(table ttTableData bind):
    end method.
        
    method public override void AssignRow(pinst as IDataAdminElement,phBuffer as handle):
        define variable inst as ITable no-undo. 
        inst = cast(pinst,ITable).
        AssignRow(inst,phBuffer). 
    end method.
  
    method public void AssignRow(inst as ITable,hBuffer as handle):
       /*    hBuffer::schemaname = inst:Schema:name.*/
        hBuffer::name = inst:name. 
    end method.
    
    /* hack for UtilityTableSet Schema property */
    method public ISchema GetSchema():
         if valid-object(TargetService) then 
             return TargetService:GetSchema().       
    end method.
  
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new UtilityTableSet(cntxt). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(pReq as IRequestInfo):
        if valid-object(TargetService) then
        do:
            if this-object:Find(this-object:TableHandle::name) then 
                return TargetService:GetTable(this-object:TableHandle::name).
        end.   
    end method.
    
end class.