/*************************************************************/
/* Copyright (c) 2011-2016 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : Wraps info about a row for interobject messages/events
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Oct 08 15:09:48 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnknownValueError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.RowBuffer implements IRow: 
    
	define private variable mBuffer as handle no-undo.
    define private variable mState as integer init ? no-undo.
    
    define public property Model as IDataAdminModel no-undo 
        get. 
        private set(pmodel as IDataAdminModel).
            if valid-object(Model) then 
            do:
                Model:RowDeleted:Unsubscribe(RowDeleted).
                Model:AddedToContext:Unsubscribe(NewContext).
            end.
            Model = pmodel.  
            Model:AddedToContext:Subscribe(NewContext).
            Model:RowDeleted:Subscribe(RowDeleted).    
        end. 
        
    /** SerializeName is used in child and parent defintitions  */
    define public property SerializeName as character no-undo 
        get.
        private set. 
    
    /** is  - true means that values are not refrehsed 
            - use for message only don't store  */
    define public property IsSnapShot as logical no-undo 
        init false
        get. 
        
  	define public property Created as logical no-undo 
	    get():
	        if mState <> ? then
	             return mstate = row-created.
	        return mBuffer:row-state = row-created.    
	    end.
	   
    define public property Modified as logical no-undo 
        get():
            if mState <> ? then
                 return mstate = row-modified.
            return mBuffer:row-state = row-modified.    
        end.
       
	define public property FieldNames as character no-undo
	    init ? 
	    get():
	        define variable i as integer no-undo.
	        if FieldNames = ? then
	        do: 
	            do i = 1 to mbuffer:num-fields:
	                FieldNames = FieldNames 
	                           + (if i = 1 then "" else ",")
	                           + mbuffer:buffer-field(i):name.
	            end.    
	        end.    
	       return FieldNames.     
	    end.
	    private set. 

	define public property KeyFields as character no-undo 
	    get.
	    private set. 
	   
    /** returns the value that correspond to a single entry KeyFields for this row */
    define public property KeyValue as character  no-undo init ? 
        get.
        private set. 
       
    /** returns the integer value that correspond to a single entry KeyFields for this row */
    define public property KeyIntValue as integer  no-undo init ? 
        get.
        private set. 
    
    define public property KeyValues as character extent no-undo 
       get.
       private set.


	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    
    constructor public RowBuffer (pModel as IDataAdminModel, pBuffer as handle,pstate as int,pKeyFields as char):
        this-object(pModel, pbuffer, pKeyFields).
        mstate = pState.   
    end method.
    
    constructor public RowBuffer (pModel as IDataAdminModel, pBuffer as handle,pKeyFields as char):
        define variable nullid as rowid no-undo.
        this-object(pModel, pbuffer, pKeyFields, nullid).
    end method.
    
    constructor public RowBuffer (pModel as IDataAdminModel, pBuffer as handle,pKeyFields as char,prowid as rowid):
        super().
        
        if not valid-handle(pBuffer) then
            undo, throw new UnknownValueError("RowImpl constructor","buffer-handle").
        if pBuffer:avail = false or pBuffer:rowid <> pRowid then do:
            pBuffer:find-by-rowid(prowid) no-error.
        if pBuffer:avail = false then 
            undo, throw new IllegalArgumentError("Buffer passed to RowImpl is not available.").
        end.
        KeyFields = pKeyFields. 
        if pmodel:name eq "AllTable" then
            SetKeyValues(pBuffer,pKeyFields,"").
        else SetKeyValues(pBuffer,pKeyFields).
        create buffer mBuffer for table pbuffer.
        SerializeName = pBuffer:serialize-name.
        Model = pModel.
        if pRowid = ? then 
            prowid = pBuffer:rowid.
        
        mBuffer:find-by-rowid(prowid). 
    end constructor.
    
    constructor public RowBuffer (pModel as IDataAdminModel, hBuffer as handle,pKeyFields as char,pFieldNames as char):
        this-object (pModel, hBuffer,pKeyFields).
        FieldNames = pFieldNames. 
    end constructor.
    
    constructor public RowBuffer (pModel as IDataAdminModel, hBuffer as handle,pState as int,pKeyFields as char,pFieldNames as char):
        this-object (pModel, hBuffer, pState, pKeyFields).
        FieldNames = pFieldNames. 
    end constructor.
    
    /* the context we attached to changed */
    method protected void NewContext(cntxt as IDataAdminModel):
        define variable hNewDefaultBuffer as handle no-undo. 
        define variable hNewBuffer as handle no-undo. 
        hNewDefaultbuffer = cntxt:TableHandle:default-buffer-handle.
        create buffer hNewBuffer for table hNewDefaultbuffer.
        hNewBuffer:serialize-name = hNewDefaultbuffer:serialize-name.
        hNewBuffer:find-unique ("where " + cntxt:GetWhere(KeyFields,KeyValues)).
        delete object mbuffer no-error.
        mBuffer = hNewBuffer.      
        Model = cntxt.
    end method.
    
    /* ?? @todo  - event needs rowid   */
    method protected void RowDeleted( ):
       
    end.
     
    method private char SetKeyValues(pBuffer as handle,pnames as char):
         define variable hField as handle no-undo. 
         define variable i as integer no-undo.
        
         if pnames = "" or pnames = ? then
             undo, throw new UnknownValueError("KeyFields vas not passed RowBuffer constructor.").
        
         /* the assumption is that only single key objects will need this without 
            context */
         if num-entries(pnames) = 1 then
         do:
             extent(KeyValues) = 1.
             hField = pBuffer:buffer-field(pnames).
             if hfield:data-type = "character" then
                KeyValue = hField:buffer-value.  
              /* seems to have been a bad idea? - this is only used quoted in dynamic queries 
                - ensure KeyValue is also set */  
             else if hfield:data-type = "integer" then
             do:
                assign
                    KeyIntValue = hField:buffer-value  
                    KeyValue = string(KeyIntValue).
             end.       
             KeyValues[1] = hField:buffer-value.
         end.    
         else do:   
             extent(KeyValues) = num-entries(pnames).
             do i = 1 to num-entries(pnames):
                 hField = pBuffer:buffer-field (entry(i,pnames)).
                 KeyValues[i] = hField:buffer-value.
             end.    
         end. 
         catch e as Progress.Lang.Error :
            undo, throw new IllegalArgumentError("KeyFields does not match buffer. Error:  " + e:GetMessage(1)).  
         end catch. 
    end method. 
    
    method private char SetKeyValues(pBuffer as handle,pnames as char,dummy as char):
         define variable hField as handle no-undo. 
         define variable i as integer no-undo.
        
         if pnames = "" or pnames = ? then
             undo, throw new UnknownValueError("KeyFields vas not passed RowBuffer constructor.").
        
         /* the assumption is that only single key objects will need this without 
            context */
         if num-entries(pnames) = 1 then
         do:
             extent(KeyValues) = 2.
             hField = pBuffer:buffer-field(pnames).
             if hfield:data-type = "character" then
                KeyValue = hField:buffer-value.  
              /* seems to have been a bad idea? - this is only used quoted in dynamic queries 
                - ensure KeyValue is also set */  
             else if hfield:data-type = "integer" then
             do:
                assign
                    KeyIntValue = hField:buffer-value  
                    KeyValue = string(KeyIntValue).
             end.       
             KeyValues[1] = hField:buffer-value.
             hField = pBuffer:buffer-field("SchemaName").
             KeyValues[2] = hField:buffer-value.
         end.    
         else do:   
             extent(KeyValues) = num-entries(pnames).
             do i = 1 to num-entries(pnames):
                 hField = pBuffer:buffer-field (entry(i,pnames)).
                 KeyValues[i] = hField:buffer-value.
             end.    
         end. 
         catch e as Progress.Lang.Error :
            undo, throw new IllegalArgumentError("KeyFields does not match buffer. Error:  " + e:GetMessage(1)).  
         end catch. 
    end method.
    
	method public character FieldValue( pcColumn as character ):
		define variable ifld as integer no-undo.
		define variable hfld as handle no-undo.
        if FieldNames = ? or lookup(pcColumn,FieldNames) > 0 then
        do:
            hFld = mBuffer:buffer-field(pccolumn) no-error.
            if valid-handle(hFld) then 
                 return hFld:buffer-value.
        end. 
        undo, throw new IllegalArgumentError("Invalid field name " + quoter(pccolumn) + " passed to FieldValue().").
	end method.
	
	/* currently not in any interface (@todo IrowBuffer? need to cast anayways) */
    method public logical AssignFieldValue( pcColumn as character, pVal as int ):
        AssignFieldValue( pcColumn,string(pval)).   
    end method.
	
	/* currently not in any interface (@todo IrowBuffer? need to cast anayways) */
    method public logical AssignFieldValue( pcColumn as character, pcValue as char ):
        define variable ifld as integer no-undo.
        define variable hfld as handle no-undo.
        define variable lTrack  as logical no-undo.
        if FieldNames = ? or lookup(pcColumn,FieldNames) > 0 then
        do on error undo, throw :
            lTrack =  mBuffer:table-handle:tracking-changes.    
            hFld = mBuffer:buffer-field(pccolumn) no-error.
            if valid-handle(hFld) then
            do: 
                mBuffer:table-handle:tracking-changes = false.    
                hFld:buffer-value = pcValue.
                return true.
            end.
            else 
            finally:
                mBuffer:table-handle:tracking-changes = lTrack.    
            end finally.
        end. 
        undo, throw new IllegalArgumentError("Invalid field name " + quoter(pccolumn) + " passed to AssignFieldValue().").
    end method.
 
 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	destructor public RowBuffer ( ):
        delete object mbuffer no-error.
	end destructor.

end class.