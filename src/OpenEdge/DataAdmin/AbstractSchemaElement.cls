 /*************************************************************/
  /* Copyright (c) 2011-2016 by progress Software Corporation. */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : abstract class for table,field and index
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Aug 05 2011
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminModel from propath.
using OpenEdge.DataAdmin.Entity from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.ISchema from propath.
using OpenEdge.DataAdmin.ISchemaElement from propath.
using OpenEdge.DataAdmin.ISchemaPartitionMap from propath.

class OpenEdge.DataAdmin.AbstractSchemaElement  inherits Entity abstract implements ISchemaElement: 
    
    /** currently only PUB */
    define public property Schema as ISchema no-undo 
        get():
            if valid-handle(mBuffer) and valid-object(Service) 
            and mBuffer::SchemaName = "PUB" then                   
                return Service:GetSchema().                 
            return ?.          
        end. 
        
    define public property NonPUBSchemaName as char no-undo 
        get():
            if valid-handle(mBuffer) and valid-object(Service) 
            and mBuffer::SchemaName ne "PUB" then               
                return mBuffer::SchemaName.               
            return ?.          
        end.   
    
    define public abstract property ObjectType as character no-undo 
        get.
        
    define public property Area as IArea no-undo 
        get():
            if not valid-object(Area) 
            and valid-handle(mBuffer)  
            and valid-object(Service) then
            do: 
                    
                   if mbuffer::AreaName > "" then 
                        Area = Service:GetArea(mBuffer::AreaName).            
                else if mbuffer::AreaNumber > 0 then 
                    Area = Service:GetArea(mBuffer::AreaNumber).            
                else if ObjectType = "Table" then do: 
                    Refresh().
                    Area = Service:GetArea(mBuffer::AreaName).            
                end. 
            end. 
            return Area.
        end.    
        private set.
    
    
    define public property Partitions as ISchemaPartitionMap no-undo  
        get():
            if not valid-object(Partitions) then
            do:
                Partitions = cast(GetChildCollection("partitions"),ISchemaPartitionMap).
           end.     
           return Partitions.
        end.
        private set.
    
    define public property Description as char no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Description.
             return Description.
        end.    
        set(pDescription as char):
            if ObjectType = "Field" then 
                undo, throw new UnsupportedOperationError ("Fields are not editable").
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Description = pDescription.
            end.
            Description = pDescription.
        end. 
        
	constructor public AbstractSchemaElement (name as character ):
		super (input name).
	end constructor.
	
	constructor public AbstractSchemaElement (cntxt as IDataAdminModel ):
		super (input cntxt).
	end constructor.

    constructor public AbstractSchemaElement (cntxt as IDataAdminModel,pReq as IRequestInfo ):
        super (cntxt,pReq).
    end constructor.

end class.