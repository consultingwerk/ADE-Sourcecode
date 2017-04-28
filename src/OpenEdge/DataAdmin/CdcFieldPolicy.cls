/* ***********************************************************/
/* Copyright (c) 2015-2016 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
   File        : CdcFieldPolicy
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : mkondra
   Created     : Mon Nov 23 15:23:32 IST 2015
   Notes       : 
 ----------------------------------------------------------------------*/


routine-level on error undo, throw.

using OpenEdge.DataAdmin.AbstractPartitionOwner from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminModel from propath.
using OpenEdge.DataAdmin.Binding.CdcFieldPolicyContext from propath.
using OpenEdge.DataAdmin.ICdcFieldPolicy from propath.
using OpenEdge.DataAdmin.ICdcTablePolicy from propath. 
using OpenEdge.DataAdmin.IDataAdminService from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.IField from propath.

using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.Error.CreateOnlyPropertyError.
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.ITable from propath.

class OpenEdge.DataAdmin.CdcFieldPolicy inherits AbstractPartitionOwner implements ICdcFieldPolicy: 
    define private variable mInitialized as logical no-undo. 
    
    define protected property FieldPolicyContext  as CdcFieldPolicyContext no-undo                 
        get() :
            return cast(this-object:Context,CdcFieldPolicyContext).
        end.

    define public property CdcTablePolicy as ICdcTablePolicy no-undo 
        get():
            define variable currentservice as IDataAdminService no-undo.
            if not valid-object(CdcTablePolicy) then
            do:
                if valid-handle(mBuffer) then
                do:
                    currentservice = GetLookupService().
                    if valid-object(currentservice) then    
                        return currentservice:GetCdcTablePolicy(mBuffer::CdcTablePolicyName).
                end. 
            end.
            return CdcTablePolicy. 
        end. 
        
    define public property CdcPolicyId as char no-undo  
    get():
        if valid-handle(mBuffer) then 
            return mBuffer::CdcPolicyId.
        else
            return CdcPolicyId. 
    end.
    set.
        
    define public property Field as IField no-undo 
        get():
            if not valid-object(this-object:Field) and valid-handle(mBuffer)  and mBuffer::Fieldname > "" then   
            do: 
                this-object:Field = GetField(). 
            end.
            return this-object:Field.
        end.
        set(fld as IField):
            if not valid-object(fld) then 
            do:
                undo, throw new UnknownValueError("CdcFieldPolicy:Field").          
            end.
            //if valid-object(Service) then
            //    undo, throw new CreateOnlyPropertyError("CdcFieldPolicy",Name,"Field").
            do on error undo, throw:       
                if valid-handle(mBuffer) then
                    mBuffer::FieldName = fld:name.
            end.
            this-object:Field = fld.
            catch e as Progress.Lang.Error :                     
                if e:GetMessageNum(1) = 132 then
                    undo, throw new IllegalOperationError("Found duplicate field value for CDC field policy.").   
                else  undo, throw e.       
            end catch.            
        end.
        
    /*define public property FieldName as char no-undo 
        get():
            if not valid-object(this-object:Field) and valid-handle(mBuffer)  and mBuffer::Fieldname > "" then   
            do: 
                return mBuffer::Fieldname.
               //if valid-object(Service) then 
               //    return service:GetField(mBuffer::Fieldname). 
              // if valid-object(Context:TargetService) then
               //    return Context:TargetService:GetField(mBuffer::Fieldname). 
            end.
            return this-object:FieldName.
        end.*/        
        
    define public property NumFields as int no-undo    
        get() :
            if valid-object(Service) then 
            do:
                if NumFields = 0 then
                    NumFields = CdcTablePolicy:NumFields.
                return NumFields.      
            end. 
            if GetPolicyName() > "" then
                return FieldPolicyContext:GetPolicyNumFields(GetPolicyName()).
            return 0.
            
        end.
        private set.

    define public property CdcTablePolicyName as char no-undo 
    get():
        if valid-handle(mBuffer) then
            return mBuffer::CdcTablePolicyName.
        else
            return CdcTablePolicyName. 
    end.
    set. 
	
    define public property IdentifyingField as integer no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IdentifyingField.
            else
                return IdentifyingField. 
        end.
        set(pIdentifyingField as int):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::IdentifyingField = pIdentifyingField.
            end.
            else
                IdentifyingField = pIdentifyingField.
        end. 
        
     define public property FieldPosition as int no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::FieldPosition.
            else
                return FieldPosition. 
        end.
        set.
        
    define public property FieldRecId as int no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::FieldRecId.
            else
                return FieldRecId. 
        end.
        set.
        
    define public property Misc as character extent 16 no-undo 
    get(i as int):
        if valid-handle(mBuffer) then do:              
                 return mBuffer::Misc(i).                      
        end.
        else
            return this-object:Misc[i].  
    end.
    set. 


    define public property Values as character extent no-undo 
        get(i as int):
            if valid-handle(mBuffer) and mInitialized then
                return mBuffer::StringValues(i).
            else
                return this-object:Values[i]. 
        end.     
        protected set(pval as char,i as int):
            if valid-handle(mBuffer) and mInitialized then 
            do:
                //SetStringValue("character",pval,i).
            end.
            else
                this-object:Values[i] =  pval.
        end.
        
    constructor public CdcFieldPolicy (pname as character ):
        super (pname).
    end constructor.
    
    constructor public CdcFieldPolicy (  cntxt as IDataAdminModel,  preq as IRequestInfo ):
        super ( cntxt,  preq).
        if not Created then 
        do:
            //extent(this-object:Values) = NumFields.
            mInitialized = true.
        end. 
    end constructor.
        
    constructor public CdcFieldPolicy (  cntxt as IDataAdminModel ):
        this-object ( cntxt,?).
    end constructor.
    
    method protected char GetValidDefaultLevelList(): 
        return "0,1,2".
    end method.
    
    method private char GetPolicyName( ):
        if valid-handle(mBuffer) then
            return mBuffer::CdcTablePolicyName.
        return "".
    end.
    
    method private IField GetField( ):
        define variable currService as IDataAdminService no-undo.
        define variable tbl as ITable no-undo.
        currService = GetLookupService().
        if valid-object(currService) then
        do:                 
            tbl = currService:GetTable(mBuffer::TableName,mBuffer::SourceTableOwner).
            return tbl:Fields:Find(mBuffer::FieldName).
        end.
        else if valid-object (Context:TargetService) then do:
            tbl = Context:TargetService:GetTable(mBuffer::TableName,mBuffer::SourceTableOwner).
            return tbl:Fields:Find(mBuffer::FieldName).
        end.            
        return ?.
    end.
    
    method public override void Attach(cntxt as IDataAdminContext):  
        define variable cValues as character extent no-undo.
        define variable i       as integer   no-undo.
        /*if extent(this-object:Values) <> ? and Numfields = 0 then
        do:
            cValues = this-object:Values.
        end.   */  
        super:Attach(cntxt).
        /*if NumFields > 0 then
        do:
            extent(this-object:Values) = ?.
            extent(this-object:Values) = NumFields.
            mInitialized = true.
            if extent(cValues) <> ? then
            do:
                if extent(cValues) > NumFields then 
                    undo, throw new IllegalOperationError("The policy has " + string(Numfields) + " fields while the detail has " + string(extent(cValues)) + " values."). 
                do i = 1 to extent(cValues):
                    this-object:Values[i] = cValues[i].
                end.
            end.      
        end.
        else */
        mInitialized = true.
    end.
    
    method char GetDataType(i as int ):
        if valid-handle(mBuffer) then
        do:
            return FieldPolicyContext:GetPolicyFieldDataType(mBuffer::CdcTablePolicyName,i).
        end.    
        return "".
    end. 

    method protected override void AssertPartitions():
        if Created then 
        do:
            if getPolicyName() = "" then 
                undo, throw new IllegalOperationError("Partitions are not available in a new FieldPolicy that does not belong to a Table Policy.").  
            
            /*if CdcTablePolicyName = "" or CdcTablePolicyName = ? then
                undo, throw new IllegalOperationError("Partitions are not available in a new FieldPolicy that does not have a name.").  
            */
            if (valid-object(CdcTablePolicy) and not valid-object(CdcTablePolicy:Table)) 
                or mBuffer::Tablename = "" 
                or mBuffer::Tablename = ? then
            
                undo, throw new IllegalOperationError("Partitions are not available in a new FieldPolicy when the parent CdcTablePolicy:Table is undefined or invalid." ).
        end.
        
    end method.

    method override protected IDataAdminModel CreateLocalContext(  ):
        return new CdcFieldPolicyContext().
    end method.
	
    /*
    
   define public override property DataArea as IArea no-undo  
   get.
   set.
    
   define public override property IndexArea as IArea no-undo  
   get.
   set. 
    
   define public override property ChangeTableOwner as char no-undo  
   get.
   set.  
    
   define public override property ChangeTable as char no-undo  
   get.
   set. */
    
    define override public property DefaultDataArea as IArea no-undo 
        get.
        set.
    
    define override public property DefaultIndexArea as IArea no-undo 
        get.
        set.
    
    define override public property DefaultLobArea as IArea no-undo 
        get.
        set.
    
    define override public property DefaultAllocation as char no-undo 
        get.
        set.
    
    define public override property IsDataEnabled as logical no-undo 
        get.
        set.
    
    method public override logical Allocate(  ):
    end.
   
end class.