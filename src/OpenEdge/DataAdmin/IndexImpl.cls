/*************************************************************/
/* Copyright (c) 2011,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     :  
    Syntax      : 
    Description : 
    @Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.AbstractSchemaElement.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IndexContext.
using OpenEdge.DataAdmin.Core.JSONWriter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnauthorizedOperationError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IArea.
using OpenEdge.DataAdmin.IDataAdminExporter.
using OpenEdge.DataAdmin.IFieldSet.
using OpenEdge.DataAdmin.IIndex.
using OpenEdge.DataAdmin.IIndexFieldList.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ISchemaPartitionMap.
using OpenEdge.DataAdmin.ITable.
using Progress.Lang.*.

routine-level on error undo, throw.
class OpenEdge.DataAdmin.IndexImpl final  inherits AbstractSchemaElement  implements IIndex : 
          
    define public property Table as ITable no-undo 
        get():
            if not valid-object(this-object:Table) and valid-handle(mBuffer) and valid-object(Service) then
            do:
                 this-object:Table = service:GetTable(mBuffer::Tablename). 
            end.
            return this-object:Table.
        end.
        private set.     
             
    define public override property ObjectType as character no-undo 
        get():
            return "Index". 
        end.
           
     /** Readonly property that returns true if the index is active  */
    define public property IsActive      as logical   no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsActive.
            else
                return IsActive.  
        end.  
        set(pActive as logical):
            if pActive = true then
            do:
                undo, throw new UnsupportedOperationError("Making an index active.").              
            end.     
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::IsActive = pActive.
            end.
            IsActive = pActive.
        end. 
    
    /** Readonly property that returns true if the index is unique  */
    define public property IsUnique      as logical   no-undo   
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsUnique.
            else
                return IsUnique. 
        end.  
    
    /** Readonly property that returns true if the index is the primary index  */
    define public property IsPrimary     as logical   no-undo   
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsPrimary.
            else
                return IsPrimary. 
        end.  
        set(pprimary as logical):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::IsPrimary = pprimary.
            end.
            IsPrimary = pprimary.
        end. 
        
    /** Readonly property that returns true if the index is a word index  */
    define public property IsWordIndex   as logical   no-undo    
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsWordIndex.
            else
                return IsWordIndex. 
        end.  
        
     /** Returns true if the index is local (table partition)  */
    define public property IsLocal       as logical   no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsLocal.
            else
                return IsLocal. 
        end.  
        set(plocal as log):
            define variable hBefore as handle no-undo.
            define variable lalreadylocal as logical no-undo.
            if valid-handle(mBuffer) then
            do:
 /*  policy for empty tables can be changed back, so as of current let the server validate      */         
/*                if plocal = false and valid-object(Service) then                                                                            */
/*                do:                                                                                                                         */
/*                    hBefore =  mDefaultBuffer:before-buffer.                                                                                */
/*                    if valid-handle (hBefore) then                                                                                          */
/*                    do:                                                                                                                     */
/*                         hBefore:find-by-rowid (mDefaultBuffer:before-rowid).                                                               */
/*                                                                                                                                            */
/*                    end.                                                                                                                    */
/*                    if ...     */
/*                        undo, throw new UnsupportedOperationError("The local index " + quoter(this-object:name) + " cannot be made global").*/
/*                end.                                                                                                                        */
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::IsLocal = plocal.
            end.
            IsLocal = plocal.
        end. 
    /* not supported 
    /** lists all Field of the Index */ 
    define public property Fields as IFieldSet no-undo     
        get():
         end.
        protected set.
    */
     define public property Fields as IFieldSet no-undo    
        get():
            if not valid-object( this-object:Fields) then
                this-object:Fields = cast(GetChildCollection("Fields"),IFieldSet).
            return this-object:Fields.
        end.
        protected set.    
    
     define public property IndexFields as IIndexFieldList no-undo    
        get():
            if not valid-object( this-object:IndexFields) then
                this-object:IndexFields = cast(GetChildCollection("IndexFields"),IIndexFieldList).
            return this-object:IndexFields.
        end.
        protected set.       
   
   /*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public IndexImpl ( cntxt as IDataAdminModel ):
	 	super (cntxt).
	end constructor.
	
    constructor public IndexImpl ( cntxt as IDataAdminModel,pReq as IRequestInfo ):
        super (cntxt,pReq).
    end constructor.
    
    method public override void Export():
        export("index.json").
    end method.          
    
    /* No local context needed - currently not used to create    */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
         
    
 end class.