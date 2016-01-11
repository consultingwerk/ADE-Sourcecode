 
/*************************************************************/
/* Copyright (c) 2014 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    file        : PartitionMergeUtility
    purpose     : 
    syntax      : 
    description : 
    author(s)   : mkondra
    created     : thu sep 25 12:10:18 ist 2014
    notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError from propath.
using OpenEdge.DataAdmin.Util.IPartitionMergeUtility.
using OpenEdge.DataAdmin.Util.PartitionManageUtility.
using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
using OpenEdge.DataAdmin.Message.PartitionMergeRequest from propath.
using OpenEdge.DataAdmin.Error.ValidationError.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.IPartitionPolicy from propath.

block-level on Error undo, throw.

class OpenEdge.DataAdmin.Util.PartitionMergeUtility inherits PartitionManageUtility implements IPartitionMergeUtility: 

	define override public property name as character no-undo 
	init "partitionMerge"
	get.
	set. 
  
	define public property FromSourceDetail AS OpenEdge.DataAdmin.IPartitionPolicyDetail NO-UNDO 
        get.
        set(pdtl as IPartitionPolicyDetail):
             if IsReadOnly then
                undo ,throw new ReadOnlyPropertyError("PartitionManageUtility","","FromSourceDetail",""). 
             /* allow  null */   
             if valid-object(pdtl) then
             do:
                 AssertPolicyDetail(pdtl).
                 NullTable().
             end.   
             FromSourceDetail = pdtl.
         end.  
         
     define public property ToSourceDetail as IPartitionPolicyDetail no-undo
         get.   
         set(pdtl2 as IPartitionPolicyDetail):
             if IsReadOnly then
                undo ,throw new ReadOnlyPropertyError("PartitionManageUtility","","ToSourceDetail",""). 
             /* allow  null */   
             if valid-object(pdtl2) then
             do:
                 AssertPolicyDetail(pdtl2).
                 NullTable().
             end.   
             ToSourceDetail = pdtl2.
         end. 
         
     define public property TargetDetail as IPartitionPolicyDetail no-undo
         get.   
         set(tpdtl as IPartitionPolicyDetail):
             if IsReadOnly then
                undo ,throw new ReadOnlyPropertyError("PartitionManageUtility","","TargetDetail",""). 
             /* allow  null */   
             if valid-object(tpdtl) then
             do:
                 AssertPolicyDetail(tpdtl).
                 NullTable().
             end.   
             TargetDetail = tpdtl.
         end.
         
     define override public property Table as ITable no-undo 
         get():
              
             if valid-object(FromSourceDetail) then 
             do:
                 if valid-object(FromSourceDetail:PartitionPolicy) then
                 do:
                     return FromSourceDetail:PartitionPolicy:Table.
                 end.    
             end.
             if valid-object(ToSourceDetail) then 
             do:
                 if valid-object(ToSourceDetail:PartitionPolicy) then
                 do:
                     return ToSourceDetail:PartitionPolicy:Table.
                 end.    
             end.
             if valid-object(TargetDetail) then 
             do:
                 if valid-object(TargetDetail:PartitionPolicy) then
                 do:
                     return TargetDetail:PartitionPolicy:Table.
                 end.    
             end.  
             return this-object:Table.    
         end.     
         set(ptbl as ITable):
            if IsReadOnly then do:
                undo ,throw new ReadOnlyPropertyError("PartitionManageUtility","","Table","").                  
            end.
            
            if valid-object(ptbl)  and not  ptbl:IsPartitioned then
                undo ,throw new IllegalArgumentError("Table " + quoter(ptbl:name ) + " is not a partitioned table").             
         
            this-object:Table = ptbl.           
         end.
         
         
	
	constructor public PartitionMergeUtility (  ):
		super ().		
	end constructor.


    constructor public  PartitionMergeUtility (sourcePartitionPolicyDetail as IPartitionPolicyDetail, pdetail as IPartitionPolicyDetail):
        super ().
        
        AssertNotNull(sourcePartitionPolicyDetail,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail").
        AssertNotNull(pdetail,"PartitionMergeUtility constructor","TargetPartitionPolicyDetail").

        this-object:FromSourceDetail = sourcePartitionPolicyDetail.
        this-object:TargetDetail = pdetail.
       
    end constructor.
    
    constructor public PartitionMergeUtility ( sourcePartitionPolicyDetail as IPartitionPolicyDetail,pdetail as IPartitionPolicyDetail, pidx as IIndex  ):
        super (pidx).

        AssertNotNull(sourcePartitionPolicyDetail,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail"). 
        AssertNotNull(pdetail,"PartitionMergeUtility constructor","TargetPartitionPolicyDetail"). 

        this-object:FromSourceDetail = sourcePartitionPolicyDetail.
        this-object:TargetDetail = pdetail.        
        
    end constructor.
    
    constructor public PartitionMergeUtility (sourcePartitionPolicyDetail as IPartitionPolicyDetail,pdetail as IPartitionPolicyDetail, pidx as IIndex, prows as integer  ):
        super (pidx,prows).

        AssertNotNull(sourcePartitionPolicyDetail,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail"). 
        AssertNotNull(pdetail,"PartitionMergeUtility constructor","TargetPartitionPolicyDetail"). 

        this-object:FromSourceDetail = sourcePartitionPolicyDetail.
        this-object:TargetDetail = pdetail.
        
    end constructor.
    
    constructor public PartitionMergeUtility (sourcePartitionPolicyDetail as IPartitionPolicyDetail,sourcePartitionPolicyDetail2 as IPartitionPolicyDetail, pdetail as IPartitionPolicyDetail):
        super ( ).
        
        AssertNotNull(sourcePartitionPolicyDetail,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail").
        AssertNotNull(sourcePartitionPolicyDetail2,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail").
        AssertNotNull(pdetail,"PartitionMergeUtility constructor","TargetPartitionPolicyDetail").

        this-object:FromSourceDetail = sourcePartitionPolicyDetail.
        this-object:ToSourceDetail = sourcePartitionPolicyDetail2.
        this-object:TargetDetail = pdetail.
       
    end constructor.
    
    constructor public PartitionMergeUtility (sourcePartitionPolicyDetail as IPartitionPolicyDetail,sourcePartitionPolicyDetail2 as IPartitionPolicyDetail,pdetail as IPartitionPolicyDetail, pidx as IIndex  ):
        super (pidx).

        AssertNotNull(sourcePartitionPolicyDetail,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail"). 
        AssertNotNull(sourcePartitionPolicyDetail2,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail"). 
        AssertNotNull(pdetail,"PartitionMergeUtility constructor","TargetPartitionPolicyDetail"). 

        this-object:FromSourceDetail = sourcePartitionPolicyDetail.
        this-object:ToSourceDetail = sourcePartitionPolicyDetail2.
        this-object:TargetDetail = pdetail.
        
    end constructor.

    constructor public PartitionMergeUtility (sourcePartitionPolicyDetail as IPartitionPolicyDetail,sourcePartitionPolicyDetail2 as IPartitionPolicyDetail,pdetail as IPartitionPolicyDetail, pidx as IIndex, prows as integer  ):
        super (pidx,prows).
        
        AssertNotNull(sourcePartitionPolicyDetail,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail"). 
        AssertNotNull(sourcePartitionPolicyDetail2,"PartitionMergeUtility constructor","SourcePartitionPolicyDetail"). 
        AssertNotNull(pdetail,"PartitionMergeUtility constructor","TargetPartitionPolicyDetail"). 

        this-object:FromSourceDetail = sourcePartitionPolicyDetail.
        this-object:ToSourceDetail = sourcePartitionPolicyDetail2.
        this-object:TargetDetail = pdetail.
        
    end constructor.
		 
	method override public OpenEdge.DataAdmin.Message.IUtilityRequest GetRequest():
		
		define variable msg as PartitionMergeRequest no-undo.
		
         AssertNotNull(this-object:table,"table").
         
         if valid-object(this-object:Table) then
         do:
             if valid-object(this-object:FromSourceDetail) then do:
                if not this-object:Table:equals(this-object:FromSourceDetail:PartitionPolicy:Table) then 
                   undo, throw new IllegalOperationError("the " + quoter(this-object:FromSourceDetail:PartitionPolicy:Table) +  " PartitionPolicyDetail does not belong in the " + quoter(this-object:table:name) + " table").
             end.
             if valid-object(this-object:ToSourceDetail) then do:
                if not this-object:Table:equals(this-object:ToSourceDetail:PartitionPolicy:Table) then 
                   undo, throw new IllegalOperationError("the " + quoter(this-object:ToSourceDetail:PartitionPolicy:Table) +  " PartitionPolicyDetail does not belong in the " + quoter(this-object:table:name) + " table").
             end.
             
             if valid-object(this-object:FromSourceDetail) then do:
                if not this-object:Table:equals(this-object:TargetDetail:PartitionPolicy:Table) then 
                   undo, throw new IllegalOperationError("the " + quoter(this-object:TargetDetail:PartitionPolicy:Table) +  " PartitionPolicyDetail does not belong in the " + quoter(this-object:table:name) + " table").
             end.
        end.
        
        if valid-object(this-object:index) then 
        do:
            if not this-object:table:equals(this-object:index:table) then
                undo, throw new IllegalOperationError("the " + quoter(this-object:index:name) +  " index does not belong in the " + quoter(this-object:table:name) + " table").
        end.     
       
        assign
            msg = new PartitionMergeRequest()
            msg:tablename = table:name
            msg:numrows = transactionsize
            msg:indexname = if valid-object(this-object:index) then index:name else ""
            msg:fromsourcename = if valid-object(FromSourceDetail) then FromSourceDetail:name else "".
            msg:tosourcename = if valid-object(ToSourceDetail) then ToSourceDetail:name else "".
            msg:TargetDetail = if valid-object(TargetDetail) then TargetDetail:name else "".

        return msg.

	end method.
	 
	method protected void AssertPolicy(ppolicy as IPartitionPolicy):
        if not valid-object(ppolicy:table) then
            undo, throw new IllegalArgumentError("The PartitionPolicy has no table").
    end method. 
    
    method private void NullTable():
        this-object:table = ?.
    end method.  
    
    method protected override void AssertPolicydetail( pdetail as IPartitionPolicyDetail):
        super:AssertPolicydetail(pdetail).
        AssertPolicy(pdetail:PartitionPolicy).
        if pdetail:issplittarget then
            undo, throw new IllegalArgumentError("The merge PartitionPolicyDetail source " + quoter(pdetail:name) +  " is in transition").
        if not pdetail:isallocated then
            undo, throw new IllegalArgumentError("The merge PartitionPolicyDetail source " + quoter(pdetail:name) + "  is not allocated").
        if pdetail:iscomposite then
            undo, throw new IllegalArgumentError("The merge PartitionPolicyDetail source " + quoter(pdetail:name) + "  is in a composite partition").
    
    end method.

end class.