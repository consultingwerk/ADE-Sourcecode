/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DatabaseOption
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Apr 21 08:57:12 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.DatabaseOptionContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminSerializable.
using OpenEdge.DataAdmin.IDatabaseOption.
using OpenEdge.DataAdmin.IRequestInfo.

class OpenEdge.DataAdmin.DatabaseOption inherits Entity implements IDatabaseOption, IDataAdminElement,IDataAdminSerializable: 

	define public property Code as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Code.
            else
                return Code. 
        end.
        set(pCode as character):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Code = pCode.
            end.
            Code = pCode.
        end. 

	define public property Description as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Description.
            else
                return Description. 
        end.
        set(pDescription as character):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Description = pDescription.
            end.
            Description = pDescription.
        end. 

	define public property IsBuiltin as logical no-undo 
         get():
            if valid-handle(mBuffer) then
                return mBuffer::IsBuiltin.
            else
                return IsBuiltin. 
        end.

	define public property OptionType as integer no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::OptionType.
            else
                return OptionType. 
        end.
        set(pOptionType as integer):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::OptionType = pOptionType.
            end.
            OptionType = pOptionType.
        end. 

	define public property OptionValue as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::OptionValue.
            else
                return OptionValue. 
        end.
        set(pOptionValue as character):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::OptionValue = pOptionValue.
            end.
            OptionValue = pOptionValue.
        end. 

	constructor public DatabaseOption ( input cntxt as IDataAdminModel ):
		super (input cntxt).
	end constructor.

	constructor public DatabaseOption ( input cntxt as IDataAdminModel, input preq as IRequestInfo ):
		super (input cntxt, input preq).
	end constructor.

	constructor public DatabaseOption ( input pname as character ):
		super (input pname).
	end constructor.

	method override protected IDataAdminModel CreateLocalContext(  ):
        return new DatabaseOptionContext(). 
	end method.

    method public override  void Export(  ):
        Export("dboption.json").
    end method.

end class.