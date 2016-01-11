/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError from propath.
using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
using OpenEdge.DataAdmin.Message.IUtilityResponse from propath.
using OpenEdge.DataAdmin.Util.IPartitionManageUtility from propath.
using Progress.Lang.Object from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.

class OpenEdge.DataAdmin.Util.PartitionManageUtility abstract implements IPartitionManageUtility: 
    
     define public abstract property Name as character no-undo get. set. 
     define public abstract property Table as ITable no-undo get. set.  
    
     define protected variable IsReadOnly as logical no-undo. 
   
     define public property Index as IIndex no-undo 
         get.  
         set.
         
     define public property TransactionSize as int  no-undo get.  set.
  
     define public property TaskName as character no-undo get. set.
     
     define public property LogStatus      as logical no-undo 
        get. 
        set(log as logical):
            if log then 
               undo, throw new OpenEdge.DataAdmin.Error.UnsupportedOperationError("Status log is not supported for partition manage utility.").
        end.
        
    define public property StatusFileName as character  no-undo 
        get. 
        set(pfile as char):
            if pfile > "" then 
               undo, throw new OpenEdge.DataAdmin.Error.UnsupportedOperationError("Status log is not supported for partition manage utility.").
        end.
     
    define public property StatusInterval      as integer no-undo 
        get. 
        set(ptime as integer):
            if ptime <> 0 then 
               undo, throw new OpenEdge.DataAdmin.Error.UnsupportedOperationError("Status log is not supported for partition manage utility.").
        end.
    
    constructor protected PartitionManageUtility (   ):
        super ().
    end constructor.
    
    constructor protected PartitionManageUtility ( pidx as IIndex,  prows as int ):
        super ().
        this-object:TransactionSize = prows.
        AssertNotNull(pidx,"PartitionManageUtility constructor","index").
        this-object:Index = pidx.
    end constructor.
    
    constructor protected PartitionManageUtility ( prows as int ):
        super ().
        this-object:TransactionSize = prows.
    end constructor.
    
    constructor protected PartitionManageUtility ( pidx as IIndex ):
        super ().
        AssertNotNull(pidx,"PartitionManageUtility constructor","index").
        this-object:Index = pidx.
    end constructor.   
      
    method public abstract IUtilityRequest GetRequest().   
    
    method public void ImportOptions(cfile as char):
        undo, throw new  UnsupportedOperationError("ImportOptions is not supported for partition manage utility.").
    end method. 
    
    /*  include method in error message */ 
    method protected void AssertNotNull(o as Object, oper as char, arg as char):
        if not valid-object(o) then 
            ThrowNull(oper,arg).
    end method. 
    
     method protected void AssertNotNull(o as Object, arg as char):
        if not valid-object(o) then 
            ThrowNull(arg).
    end method.
    
    method protected void AssertPolicyDetail( pdetail as IPartitionPolicyDetail):
        AssertNotNull(pdetail,"PartitionPolicyDetail").
        if not valid-object(pdetail:PartitionPolicy) then
           undo, throw new IllegalArgumentError("PartitionPolicyDetail with no PartitionPolicy").
        if not valid-object(pdetail:PartitionPolicy:Table) then
           undo, throw new IllegalArgumentError("PartitionPolicyDetail with no Table").
    end.    
    
    method protected void ThrowNull(arg as char):
        undo, throw new IllegalOperationError( "Cannot execute partition manage utility with unknown " + arg).
    end method. 
    
    method protected void ThrowNull(oper as char, arg as char):
        undo, throw new UnknownValueError(oper, arg  ).
    end method.
    
    method public void SetResponse(resp as IUtilityResponse):
    end method. 
     
end class.