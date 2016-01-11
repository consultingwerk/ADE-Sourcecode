/*************************************************************/
/* Copyright (c) 2011,2013 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : Many to many where join is hidden
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sun Sep 04 00:17:40 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.Query.ManyToManyQuery abstract inherits FilteredContext: 
  	
  	/** Parent context (Model) may change  - this is updated in NewContext */
  	define protected property UpdateContext as IDataAdminModel no-undo
  	    get.	
	    set(pCntxt as IDataAdminModel):	    
	        if valid-object(UpdateContext) then
            do:
                UpdateContext:RowCreated:Unsubscribe(Reopen).
                UpdateContext:RowDeleted:Unsubscribe(Reopen).
                UpdateContext:AddedToContext:unsubscribe(NewUpdateContext).
            end.
            UpdateContext = pCntxt.
            UpdateContext:RowCreated:Subscribe(Reopen).
            UpdateContext:RowDeleted:Subscribe(Reopen).
            UpdateContext:AddedToContext:subscribe(NewUpdateContext).
        end.
        
	define protected property ChildSerializeName as character no-undo
	    get.
	    private set.   
 
    constructor public ManyToManyQuery (psourcecntxt as IDataAdminModel,pParentRow as IRow,pChildname as char,pReq as IRequestInfo):
        define variable updcntxt as IDataAdminModel no-undo.
        super (psourcecntxt,pparentRow,pReq,no) /* no = no create / prepare */. 
        ChildSerializeName = pchildname.
        /* @todo - always get UpdateContext from parent row model? 
             it is likely always better to use row context, but old code need to be checked/tested  
             () */
        if valid-object(pParentRow:Model) and pParentRow:Model:IsLocal then
            updcntxt = pParentRow:Model:GetChild(pchildname).
        else do:   
            updcntxt = psourcecntxt:GetChild(pchildname).
            if not valid-object(updcntxt)  then
                updcntxt = pParentRow:Model:GetChild(pchildname).
        end.    
        if not valid-object(updcntxt) then 
          undo, throw new UnsupportedOperationError("Many to many query cannot find updatecontext "  + quoter(pchildname) + " in " + quoter(psourcecntxt:Name) + " context for parent " + quoter(pParentRow:SerializeName)).    
        UpdateContext = updcntxt.     
        CreateQuery(). 
        QueryHandle:query-prepare (LocalFilter).
    end constructor.
    
    constructor public ManyToManyQuery (psourcecntxt as IDataAdminModel,pcparent as character,pcKeyvalue as character, pchildname as char, pReq as IRequestInfo ):         
        super (psourcecntxt,pcparent,pcKeyvalue,pReq). 
        ChildSerializeName = pchildname.
        UpdateContext = psourcecntxt:GetChild(pchildname).
    end constructor.
    
    constructor public ManyToManyQuery (psourcecntxt as IDataAdminModel,pcparent as character,pcKeyvalues as character extent ,pchildname as char, pReq as IRequestInfo ):         
        super (psourcecntxt,pcparent,pcKeyvalues,pReq). 
        ChildSerializeName = pchildname.
        UpdateContext = psourcecntxt:GetChild(pchildname).
    end constructor.
    
    method protected override handle extent GetBufferHandles():
        define variable h  as handle extent 2 no-undo.
        
        if valid-object(ParentRow) and valid-object(ParentRow:Model) and ParentRow:Model:IsLocal then
        do:  
            h[1] = UpdateContext:TableHandle:default-buffer-handle.
            h[2] = Model:TableHandle:default-buffer-handle.
            return h.
        end.
        return super:GetBufferHandles(). 
    end method.   
    
    method protected void NewUpdateContext(pCntxt as IDataAdminModel):
        UpdateContext = pCntxt.
        createAndOpenQuery().
    end method.   
    
    /* update context is handled in newUpdateContext 
    method protected override void NewContext(pCntxt as IDataAdminModel):
        if valid-object(UpdateContext) then
        do:
            UpdateContext:RowCreated:Unsubscribe(Reopen).
            UpdateContext:RowDeleted:Unsubscribe(Reopen).
        end.
        UpdateContext = pCntxt:GetChild(ChildSerializeName).
        UpdateContext:RowCreated:Subscribe(Reopen).
        UpdateContext:RowDeleted:Subscribe(Reopen).
        super:NewContext(pCntxt). 
    end method.
    */
    
    /** subclasses deals with the calls to the updatecontext for these for now 
        the updatecontext would typically have methods for both keys 
        some logic to deal with the field order would be needed to move this here */ 
    method public abstract override logical CanFind(pname as character). 
    method public abstract override logical Find(pname as character). 
    method public abstract override logical Delete(pname as character). 
      
    /* Override to check update context */ 
    method public override logical CanCopy(cntxt as IDataAdminContext):
        return UpdateContext:CanCopy(cntxt).                   
    end method.        
    
     method public override void Copy(cntxt as IDataAdminContext):
        define variable oParentRow  as IRow no-undo.
        oParentRow = GetParentRow().
        if valid-object(oParentRow) then
            UpdateContext:CopyForParent(ParentRow,cntxt).
        else 
            UpdateContext:Copy(cntxt).
        
        QueryHandle:query-open().
    end method.   
    
    method public override void CreateRow(entity as IDataAdminElement):
        define variable oParentRow  as IRow no-undo.
        oParentRow = GetParentRow().
        if valid-object(oParentRow) then
            UpdateContext:CreateRowForParent(ParentRow,entity).
        else 
            UpdateContext:CreateRow(entity).
        
        QueryHandle:query-open().
    end method.   
    
       
end class.