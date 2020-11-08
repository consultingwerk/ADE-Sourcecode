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
routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IndexContext.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IField.
using OpenEdge.DataAdmin.IIndex.
using OpenEdge.DataAdmin.IIndex.
using OpenEdge.DataAdmin.IIndexField.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ISchemaPartitionMap.
using Progress.Lang.*.
class OpenEdge.DataAdmin.IndexField final  inherits Entity  implements IIndexField : 
          
    define public property Field as IField no-undo 
        get():
            if not valid-object(this-object:Field) and valid-handle(mBuffer) and valid-object(Service) then
            do:
                 this-object:Field = service:GetTable(mBuffer::Tablename):Fields:Find(mBuffer::FieldName). 
            end.
            return this-object:Field.
        end.
        private set. 
            
    define public property Index as IIndex no-undo 
        get():
            if not valid-object(this-object:Index) and valid-handle(mBuffer) and valid-object(Service) then
            do:
                 this-object:Index = service:GetTable(mBuffer::Tablename):Indexes:Find(mBuffer::IndexName). 
            end.
            return this-object:Index.
        end.
        private set.            
     
     /** Readonly property that returns true if the index field is ascending  */
    define public property IsAscending      as logical   no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsAscending.
            else
                return IsAscending.  
        end.  
      
     /** Readonly property that returns true if the index field is ascending  */
    define public property Number      as int   no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Number.
            else
                return Number.  
        end. 
    
     /** Readonly property that returns true if the index field is abbreviate  */
    define public property IsAbbreviate      as logical   no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsAbbreviate.
            else
                return IsAbbreviate.  
        end.
		
	constructor public IndexField ( cntxt as IDataAdminModel ):
	 	super (cntxt).
	end constructor.
            
    constructor public IndexField ( cntxt as IDataAdminModel, pReq as IRequestInfo ):
        super (cntxt).
    end constructor.
    
    method public override void Export():
        export("indexfield.json").
    end method.          
    
    /* No local context needed - currently not used to create    */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
     
 end class.