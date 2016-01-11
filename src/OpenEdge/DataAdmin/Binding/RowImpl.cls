/*************************************************************/
/* Copyright (c) 2011,2012 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    File        : RowImpl
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

class OpenEdge.DataAdmin.Binding.RowImpl implements IRow: 
    define private variable mState as int no-undo init ?.
    define private variable mValues as character extent no-undo.
      /**  Model - to manage relations between local Model and service Model in many-to-many queries */
    define public property Model as IDataAdminModel no-undo 
        get. 
        private set. 
        
    /** SerializeName is used in child and parent defintitions  */
    define public property SerializeName as character no-undo 
        get.
        private set.
    
    /** is  - true means that values are not refrehsed 
            - use for message only don't store  */
    define public property IsSnapShot as logical no-undo 
        init true
        get. 
          
  	define public property Created as logical no-undo 
	   get():
	       return mstate = row-created.
	   end.
	   
    define public property Modified as logical no-undo 
       get():
           return mstate = row-modified.
       end.
       
	define public property FieldNames as character no-undo
	   init ? 
	   get.
	   private set. 

	define public property KeyFields as character no-undo 
	    get.
	    private set. 
    
    /** returns the integer value that correspond to a single entry KeyFields for this row */
    define public property KeyIntValue as integer  no-undo init ? 
        get.
        private set. 
   	   
    /** returns the value that correspond to a single entry KeyFields for this row */
    define public property KeyValue as character  no-undo init ? 
        get():
            /* separate integer seems to have been a bad idea? - used quoted in dynamic queries
               return int as string here for generic cases   */
            if KeyValue = ? and KeyIntValue <> ? then
                return string(KeyIntValue).
            return KeyValue.        
        end.
        private set. 
       
    define public property KeyValues as character extent no-undo 
       get.
       private set. 

	constructor public RowImpl (pModel as IDataAdminModel, pSerializename as char,pState as int,pKeyField as char,pKeyValue as char):
        this-object(pModel, pSerializename,pstate,pKeyfield,GetSingleValue(pKeyValue)).
        KeyValue = pKeyValue. 
    end method.
	
	constructor public RowImpl (pModel as IDataAdminModel, pSerializename as char,pState as int,pKeyField as char,pKeyValue as char,pFields as char,pvalues as char extent):
        this-object(pModel, pSerializename,pstate,pKeyfield,GetSingleValue(pKeyValue),pfields,pValues). 
        KeyValue = pKeyValue. 
    end method.
    
	constructor public RowImpl (pModel as IDataAdminModel, pSerializename as char,pState as int,pKeyField as char,pKeyValue as int):
        this-object(pModel, pSerializename,pstate,pKeyfield,GetSingleValue(pKeyValue)). 
        KeyIntValue = pKeyValue. 
    end method.
    
    constructor public RowImpl (pModel as IDataAdminModel, pSerializename as char,pState as int,pKeyField as char,pKeyValue as int,pFields as char,pvalues as char extent):
        this-object(pModel, pSerializename,pstate,pKeyfield,GetSingleValue(pKeyValue),pfields,pValues). 
        KeyIntValue = pKeyValue. 
        
    end method.
    
	constructor public RowImpl (pModel as IDataAdminModel, pSerializename as char,pState as int,pKeyFields as char,pKeyValues as char extent):
	    define variable cMsg as character no-undo.   
	    if pstate > 3 or pstate < 0 then
            undo, throw new IllegalArgumentError("Invalid state passed to RowImpl constructor. The value must correspond to a row-state.").
        if pState = row-created then 
	        undo, throw new IllegalArgumentError("Invalid state passed to RowImpl constructor. The value must correspond to a row-state other than row-created.").
        if num-entries(pKeyfields) <> extent(pKeyValues) then
        do:
            cMsg = "Invalid parameters passed to RowImpl constructor.". 
            if extent(pKeyValues) = 1 then
                cMsg = cMsg + " KeyField " + quoter(pKeyfields) + " does not match the single extent passed in KeyValues.".
            else   
                cMsg = cMsg + " KeyFields " + quoter(pKeyfields) + " does not match the " + string(extent(pKeyValues)) + " extents in KeyValues.".
            
            undo, throw new IllegalArgumentError(cmsg).
        end.
        mState = pState.
	    KeyFields = pKeyfields.
        KeyValues = pKeyValues.
        SerializeName = pSerializeName.    
	end constructor.
    
    constructor public RowImpl (pModel as IDataAdminModel, pSerializename as char,pState as int,pKeyFields as char,pKeyValues as char extent,pFieldNames as char,pfieldvalues as char extent):
        this-object (pModel, pSerializename,pState,pKeyFields,pKeyValues).
        if num-entries(pFieldNames) <> extent(pFieldValues) then
            undo, throw new IllegalArgumentError("Invalid parameters passed to RowImpl constructor. FieldNames " + quoter(pKeyfields) + " does not match the " + string(extent(pFieldValues)) + " extents in FieldValues.").
        FieldNames = pFieldNames.
        mValues = pFieldValues.
    end constructor.
    
    method private char extent 1 GetSingleValue(piValue as int):
        define variable cVal as char extent 1 no-undo. 
        cval[1] = string(piValue).
        return cval.
    end.    
    
    method private char extent 1 GetSingleValue(pcValue as char):
        define variable cVal as character extent 1 no-undo. 
        cval[1] = pcValue.
        return cval.
    end.    
    
	method public character FieldValue( pcColumn as character ):
		define variable ifld as integer no-undo.
		define variable ikey as integer no-undo.
		ikey = lookup(pcColumn,KeyFields).
		if ikey > 0 then 
		    return KeyValues[ikey] .
		if extent(mValues) > 0 then 
		do:
		    iFld = lookup(pccolumn,FieldNames).
		    if iFld > 0 then 
		        return mvalues[iFld]. 
		    else
                undo, throw new IllegalArgumentError("Invalid field name " + quoter(pccolumn) + " passed to FieldValue.").
 		end.
        undo, throw new UnsupportedOperationError("FieldValue not in key is not supported in the current row instance.").
	end method.

end class.