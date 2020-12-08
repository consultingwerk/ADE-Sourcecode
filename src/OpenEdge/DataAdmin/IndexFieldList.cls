/*************************************************************/
/* Copyright (c) 2013,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : list of indexfields for an index
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Jul 17 2013
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
  
using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAdminCollection from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IIndexFieldList from propath.
using OpenEdge.DataAdmin.IIndexField from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath. 
  
class OpenEdge.DataAdmin.IndexFieldList inherits DataAdminCollection  implements IIndexFieldList  :  
    
    define private variable mLoaded   as logical no-undo.
              
/*	 constructor ExtentList():                                             */
/*        /* the super empty constructor will call CreateLocalContext() */*/
/*        super().                                                        */
/*    end constructor.                                                    */
    
    constructor IndexFieldList(cntxt as IDataAdminContext):
        super(cntxt).  
    end constructor. 
    
    method override protected IDataAdminContext CreateLocalContext(  ):
        return ?.
    end method.
         
/*    method public IIndexField Create(piNum as int):*/
/*                                                   */
/*    end method.                                    */
    
    method protected override logical AddAll(pcol as IDataAdminCollection).
       undo, throw new UnsupportedOperationError("AddAll() to ExtentList is not supported.").
    end method.
    
    method public override logical Add(o as Object):
        def var inst as IIndexField no-undo.
        inst = cast(o,IIndexField).
        return this-object:Add(inst).
    end method.  
    
    method public logical Add(pinst as IIndexField):
        if Contains(pinst) then
            return false.   
        return Context:AddEntity(pinst) .  
    end method.  
   
    method public IIndexField Get(i as int):
        return cast(Context:FindEntity(i),IIndexField).
    end method.    
    
    method public override logical Remove(o as Object):
        define variable inst as IIndexField no-undo.
        inst = cast(o,IIndexField).
        return Remove(inst).
    end method.  
    
    method public logical Remove(pinst as IIndexField):
        AssertNotNull(pinst,"IndexField").
        
        if valid-object(pinst:Service) then 
            undo, throw new UnsupportedOperationError("IndexField cannot be removed after it has been created.").
        if Contains(pinst) then 
            return Context:Delete(pinst:Number).
        return false.
    end method.  
    
    method public override logical Contains(obj as Object):
        return Contains(cast(obj,IIndexField)).   
        catch e as Progress.Lang.Error :
            return false.   
        end catch.
    end method.
   
    method public logical Contains(pinst as IIndexField):
        if pinst:ContextId <> ContextId then
           return false. 
        if not Context:CanFind(pinst:Number) then
           return false.
        return pinst:Equals(this-object:Get(pinst:Number)).   
    end method.  
    
    /* Returns the index in this list of the specified extent */
    method public integer IndexOf(o as Object):
        def var inst as IIndexField no-undo.
        inst = cast(o,IIndexField).
        return this-object:IndexOf(inst).
    end method.  
    
    /* The Number is also the list number */
    method public integer IndexOf(pinst as IIndexField). 
        if Contains(pinst) then
           return pinst:Number.
        return 0.    
    end method.
    
    method override protected void PrepareExport(  ):

    end method.

    method override protected void PrepareExportTree() :

    end method.

    method override protected void PrepareExportList(  ):

    end method.
end class.
