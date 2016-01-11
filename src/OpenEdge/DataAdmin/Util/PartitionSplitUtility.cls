 /************************************************************/
/* Copyright (c) 2014 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : PartitionSplitUtility
    Purpose     : Split a partition policy detail's data into other detail 
                  partitions. 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Mar 19 18:30:26 EDT 2014
    Notes       : The targets of the operation is any detail in the policy
                  where IsSplitTarget is true (in the database)  
                - To split the initial composite partition (0) specify only 
                  Table or use one of the Table or PartitionPolicy constructors. 
                - For a regular split specify the PartitionPolicyDetail
                  or use one of the PartitionPolicyDetail constructors to 
                  specify the source of the split.  
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
using OpenEdge.DataAdmin.Message.PartitionSplitRequest from propath.
using OpenEdge.DataAdmin.Util.IPartitionSplitUtility.
using OpenEdge.DataAdmin.Util.PartitionManageUtility.
using Progress.Lang.*.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.IPartitionPolicy from propath.


class OpenEdge.DataAdmin.Util.PartitionSplitUtility inherits PartitionManageUtility implements IPartitionSplitUtility: 
    
    define protected override property ReadOnlyReason as char no-undo 
        get():
            if not valid-object(PartitionPolicyDetail) then
                return "Table was passed to constructor.".
            else
                return "PartitionPolicyDetail was passed to constructor.".
        end.  
        
	define override public property Name as character no-undo 
	init "PartitionSplit"
	get.
	set. 
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	constructor public PartitionSplitUtility (  ):
		super ().
	end constructor.
	
	/** Split initial (0) composite partition  
	 @param ITable  table with source composite 0 partition  */
    constructor public PartitionSplitUtility ( ptbl as ITable ):
        super ().
        AssertNotNull(ptbl,"PartitionSplitUtility constructor","Table").
        this-object:Table = ptbl.
        this-object:IsReadOnly = true.
    end constructor.
    
    /** Split initial (0) composite partition  
       @param ITable  table with source composite 0 partition 
       @param IIndex use index directive for utility
     */
   constructor public PartitionSplitUtility ( ptbl as ITable, pidx as IIndex):
        super (pidx).
        AssertNotNull(ptbl,"PartitionSplitUtility constructor","Table").
        this-object:Table = ptbl.
        this-object:IsReadOnly = true.
    end constructor.
    
    /** Split initial (0) composite partition  
       @param ITable  table with source composite 0 partition 
       @param int transaction size (num rows)
     */
    constructor public PartitionSplitUtility ( ptbl as ITable,  prows as int ):
        super (prows).
        AssertNotNull(ptbl,"PartitionSplitUtility constructor","Table").
        this-object:Table = ptbl.
        this-object:IsReadOnly = true.
    end constructor.
    
    /** Split initial (0) composite partition  
       @param ITable  table with source composite 0 partition 
       @param IIndex use index directive for utility
       @param int transaction size (num rows)
     */
    constructor public PartitionSplitUtility ( ptbl as ITable, pidx as IIndex, prows as int ):
        super (pidx,prows).
        AssertNotNull(ptbl,"PartitionSplitUtility constructor","Table").
        this-object:Table = ptbl.
        this-object:IsReadOnly = true.
    end constructor.
    
    /** Split initial (0) composite partition  
       @param IPolicy  policy with source composite 0 partition 
     */ 
     constructor public PartitionSplitUtility ( ppolicy as IPartitionPolicy ):
        super ().
        AssertNotNull(ppolicy,"PartitionSplitUtility constructor","PartitionPolicy").
        AssertPolicy(ppolicy).
        this-object:Table = ppolicy:Table.
        this-object:IsReadOnly = true.
    end constructor.
     
    /** Split initial (0) composite partition  
       @param IPolicy  policy with source composite 0 partition 
       @param int transaction size (num rows)
     */ 
    constructor public PartitionSplitUtility (ppolicy as IPartitionPolicy,  prows as int ):
        super (prows).
        AssertNotNull(ppolicy,"PartitionSplitUtility constructor","PartitionPolicy").
        AssertPolicy(ppolicy).
        this-object:Table = ppolicy:Table.
        this-object:IsReadOnly = true.
    end constructor.
    
      /** Split initial (0) composite partition  
       @param IPolicy  policy with source composite 0 partition 
       @param IIndex use index directive for utility
     */ 
    constructor public PartitionSplitUtility (ppolicy as IPartitionPolicy,  pidx as IIndex ):
        super (pidx).
        AssertNotNull(ppolicy,"PartitionSplitUtility constructor","PartitionPolicy").
        AssertPolicy(ppolicy).
        this-object:Table = ppolicy:Table.
        this-object:IsReadOnly = true.
    end constructor.
    
     /** Split initial (0) composite partition  
       @param IPolicy  policy with source composite 0 partition 
       @param IIndex use index directive for utility
       @param int transaction size (num rows)
     */ 
    constructor public PartitionSplitUtility (ppolicy as IPartitionPolicy,  pidx as IIndex,prows as int   ):
        super (pidx,prows).
        AssertNotNull(ppolicy,"PartitionSplitUtility constructor","PartitionPolicy").
        AssertPolicy(ppolicy).
        this-object:Table = ppolicy:Table.
        this-object:IsReadOnly = true.
    end constructor.  
    
     /** Split partition  
       @param IPartitionPolicyDetail  partition policy detail source of split operation */ 
    constructor public PartitionSplitUtility ( pdetail as IPartitionPolicyDetail):
        super ( ).
        AssertNotNull(pdetail,"PartitionSplitUtility constructor","PartitionPolicyDetail").
        this-object:PartitionPolicyDetail = pdetail.
        this-object:IsReadOnly = true.
    end constructor.
    
    /** Split partition  
       @param IPartitionPolicyDetail  partition policy detail source of split operation 
       @param IIndex use index directive for utility
       */ 
    constructor public PartitionSplitUtility ( pdetail as IPartitionPolicyDetail, pidx as IIndex  ):
        super (pidx).
        AssertNotNull(pdetail,"PartitionSplitUtility constructor","PartitionPolicyDetail").
        this-object:PartitionPolicyDetail = pdetail.
        this-object:IsReadOnly = true.
    end constructor.
    
    /** Split partition  
       @param IPartitionPolicyDetail  partition policy detail source of split operation 
       @param int transaction size (num rows)
     */   
    constructor public PartitionSplitUtility (pdetail as IPartitionPolicyDetail, prows as int  ):
        super (prows).
        AssertNotNull(pdetail,"PartitionSplitUtility constructor","PartitionPolicyDetail").
        this-object:PartitionPolicyDetail = pdetail.
        this-object:IsReadOnly = true.
    end constructor.
    
    /** Split partition  
       @param IPartitionPolicyDetail  partition policy detail source of split operation 
       @param IIndex use index directive for utility
       @param int transaction size (num rows)
     */
    constructor public PartitionSplitUtility (pdetail as IPartitionPolicyDetail, pidx as IIndex, prows as int  ):
        super (pidx,prows).
        AssertNotNull(pdetail,"PartitionSplitUtility constructor","PartitionPolicyDetail").
        this-object:PartitionPolicyDetail = pdetail.
        this-object:IsReadOnly = true.
    end constructor.
    
    /** Return the utility request to pass to server command  */
	method override public IUtilityRequest GetRequest(  ):
        define variable msg as PartitionSplitRequest no-undo.
        AssertNotNull(this-object:Table,"Table").
        if valid-object(this-object:Index)  then 
        do:
            if not this-object:Table:Equals(this-object:Index:Table) then
                undo, throw new IllegalOperationError("The " + quoter(this-object:Index:Name) +  " index does not belong in the " + quoter(this-object:Table:Name) + " table").
        end.        
        assign 
            msg = new PartitionSplitRequest()
            msg:TableName = Table:Name
            msg:NumRows = TransactionSize
            msg:IndexName = if valid-object(this-object:Index) then Index:Name else ""
            msg:IsComposite =  not valid-object(PartitionPolicyDetail) 
            msg:Name = if valid-object(PartitionPolicyDetail) then PartitionPolicyDetail:Name
                       else "<composite>".
        return msg.
	end method.
	
    method protected void AssertPolicy( ppolicy as IPartitionPolicy):
        if not valid-object(ppolicy:Table) then
            undo, throw new IllegalArgumentError("The PartitionPolicy has no table").
    end method.
    
    method protected override void AssertPolicyDetail( pdetail as IPartitionPolicyDetail):
        super:AssertPolicyDetail(pdetail).
        AssertPolicy(pdetail:PartitionPolicy).
        if pdetail:IsSplitTarget then
            undo, throw new IllegalArgumentError("The split PartitionPolicyDetail source " + quoter(pdetail:Name) +  " is in transition").
        if not pdetail:IsAllocated then
            undo, throw new IllegalArgumentError("The split PartitionPolicyDetail source " + quoter(pdetail:Name) + "  is not allocated").
        if pdetail:IsComposite then
            undo, throw new IllegalArgumentError("The split PartitionPolicyDetail source " + quoter(pdetail:Name) + "  is in a composite partition").
    
    end method.
end class.