/***********************************************************************/
/* Copyright (c) 2016,2024 by Progress Software Corporation.           */
/*                                                                     */
/* All rights reserved.  No part of this program or document           */
/* may be  reproduced in  any form  or by  any means without           */
/* permission in writing from Progress Software Corporation.           */
/***********************************************************************/
/*------------------------------------------------------------------------
    File        : Cdc
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Mon Nov 30 15:52:22 IST 2015
    Notes       : 
-------------------------------------------------------------------------*/

using OpenEdge.DataAdmin.ICdc.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminSerializable.
using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.Binding.* from propath.
using OpenEdge.DataAdmin.Binding.Query.* from propath. 
using OpenEdge.DataAdmin.Error.* from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Cdc implements ICdc, IDataAdminElement, IDataAdminSerializable use-widget-pool:
    
    define private variable mDataset as handle no-undo.
    define private variable mDefaultBuffer as handle no-undo.
    define private variable mBuffer as handle no-undo. 
    define private variable mchild as logical no-undo.
    
    define public property Error     as error no-undo           get.     
    
    define protected property Context   as IDataAdminModel no-undo 
        get. 
        private set(cntxt as IDataAdminModel ):     
            mDefaultBuffer = cntxt:TableHandle:default-buffer-handle.
            if not valid-handle(mBuffer) then
            do:                
                if mDefaultBuffer:avail then
                do:       
                    create buffer mBuffer for table mDefaultBuffer.
                    mBuffer:serialize-name = mDefaultBuffer:serialize-name.
                    mBuffer:find-by-rowid(mDefaultBuffer:rowid).
                end.
                else 
                    undo, throw new IllegalArgumentError("Context set with no corresponding row").
            end.
            if valid-object(Context) then 
              Context:AddedToContext:Unsubscribe(NewContext).
           Context = cntxt.  
           Context:AddedToContext:Subscribe(NewContext).       
        end.

	define public property Area as IArea no-undo 
	get():
             define variable lTrack as logical no-undo. 
/*             if valid-handle(mBuffer) and mBuffer::AreaName > ""*/
/*             and valid-object(Service) then                     */
/*             do:                                                */
/*                 return Service:GetArea(mBuffer::AreaName).     */
/*             end.                                               */
             return Area.
        end.
        set(parea as IArea).
            //if IsCdcEnabled = false then    
            //    undo, throw new ReadOnlyPropertyError(GetName(),"","Area","The " + ObjectType +  " is not Cdc enabled").         
            if not valid-object(parea) then
            do:
               undo, throw new UnknownValueError("Partition Area").
/*                   undo, throw new InvalidPropertyValueError("Partition","","Area","unknown").*/
            end.    
            
            if valid-handle(mBuffer) then
            do:
               
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::AreaName = parea:Name.
            end.
            Area = parea.
        end. 

	define public property Attached as logical no-undo 
	 get():
            return valid-object(Context) and Context:RootId = ?. 
        end. 

	define public property CodeExtension as char no-undo init "download" get. set.  

	define public property ContextId as character no-undo 
	get():
            if valid-object(Context) then 
            do:
                return Context:Id.
            end.
            return "".    
        end. 

	define public property Created as logical no-undo 
	get().
            if valid-handle(mbuffer) then
                 return mBuffer:row-state = row-created.
            return true.
        end. 

	define public property Element as ISchemaElement no-undo 
	get():
	/*
            define variable tbl as ITable no-undo.
            define variable fld as IField no-undo.
            define variable idx as IIndex no-undo.
            if valid-handle(mBuffer)and valid-object(Service) then
            do:
               tbl = service:GetTable(mBuffer::Tablename). 
               case ObjectType:
                   when "Table" then
                      if valid-object(tbl) then 
                         return cast(tbl,ISchemaElement).
                   when "Field" then 
                   do:
                      fld = tbl:LOBFields:Find(mBuffer::FieldName).
                      if valid-object(fld) then 
                          return cast(fld,ISchemaElement). 
                   end.
                   when "Index" then 
                   do: 
                      idx = tbl:Indexes:Find(mBuffer::IndexName).
                      if valid-object(idx) then 
                          return cast(idx,ISchemaElement). 
                   end. 
               end.
            end.
            return ?.*/
        end.

	define public property IsCdcEnabled as logical no-undo 
	get():
            if valid-handle(mBuffer) then
               return  (mBuffer::CdcPolicyName <> "" and mBuffer::CdcPolicyName <> ?) .                      
            return true. /* non case.. partitions should always have mbuffer. */
        end.  

	define public property Modified as logical no-undo 
	get().
            if valid-handle(mbuffer) then
                 return mBuffer:row-state = row-modified.
            return false.
        end.

	define public property ObjectType as character no-undo 
	get():
             return mBuffer::ObjectType.
        end.

	define public property RequestInfo as IRequestInfo no-undo get. protected set.
	
	define public property SerializeName as character no-undo 
	get():
            if valid-handle(mDefaultBuffer) then 
                return mDefaultBuffer:serialize-name.
            return "".       
        end.

	define public property Service as IDataAdminService no-undo 
	get():
            if valid-object(Context) then
                /* can be unknown */
                return this-object:Context:Service. 
            return ?. 
        end. 

	define public property Tenant as ITenant no-undo 
	get.
	set. 

	define public property TenantGroup as ITenantGroup no-undo 
	get.
	set. 

	method public void Attach( input cntxt as IDataAdminContext ):
		define variable oldcntxt as IDataAdminModel no-undo.
        define variable newcntxt as IDataAdminModel no-undo.
        define variable lLocal as logical no-undo.
        if not valid-object(cntxt) then
            undo, throw new UnknownValueError("Attach","context").  
        
        if type-of(cntxt,IFilteredContext) then
            newcntxt = cast(cntxt,IFilteredContext):Model. 
        else if type-of(cntxt,IDataAdminModel) then
            newcntxt = cast(cntxt,IDataAdminModel).
        else      
            undo, throw new IllegalArgumentError("Context passed to attach must be model or filter.").  
        
      
        if ContextId = "" then
        do: 
            mChild = true.
            cntxt:CreateRow(this-object).
            Context = newcntxt.          
        end.
        else do:
            oldcntxt = Context.
            llocal = mbuffer:rowid = oldcntxt:Rootid.
            /* only once - after this we are managed by collection or added to service
               the mchild deals with only copying this into a context once 
               From the first copy the data is managed by its collection or service.
               
             */
            if not mChild then 
                cntxt:Copy(Context).    
            else 
                Context = newcntxt.          
            
            mChild = true.           
        end.
  
        /* this is not handled in newcontext since root id always goes through here */    
        if valid-object(oldcntxt) and llocal then
            delete object oldcntxt.
	end method.
	
	 method protected void NewContext(cntxt as IDataAdminModel):
        define variable hNewDefaultBuffer as handle no-undo. 
        define variable hNewBuffer as handle no-undo. 
        hNewDefaultbuffer = cntxt:TableHandle:default-buffer-handle.
        create buffer hNewBuffer for table hNewDefaultbuffer.
        hNewBuffer:serialize-name = hNewDefaultbuffer:serialize-name.
        hNewBuffer:find-unique ("where " + Context:GetKeyWhere(GetKeyValues())).
        delete object mbuffer no-error.
        mBuffer = hNewBuffer.      
        Context = cntxt.
    end method.

	method public logical CanAttach( input cntxt as IDataAdminContext ):
		 if valid-object(cntxt) then
        do: 
            /* no context - assume transition ok - collection:Add will deal with type checking */
            if ContextId = "" then
                return true.
                
            return cntxt:CanCopy(Context).          
        end.
        return false.
	end method.

	method public void Export(  ):
		Export("cdc.json").
	end method.

	method public void Export( input cFile as character ):
            this-object:ExportToJson():WriteFile(cFile, yes).
	end method.

        method public JsonObject ExportToJson ( ):
            define variable htbl as handle no-undo.
            define variable oJson as JsonObject no-undo.
            oJson = new JsonObject().

            if not valid-handle(mDefaultBuffer) then
            do:
                undo, throw new UnsupportedOperationError("Export of " + this-object:GetClass():TypeName).
            end.

            create temp-table htbl.
            htbl:create-like(mDefaultBuffer).
            htbl:temp-table-prepare(mDefaultBuffer:name).
            htbl:default-buffer-handle:buffer-copy(mBuffer).
            htbl:default-buffer-handle:serialize-name = mDefaultBuffer:serialize-name.
            htbl:default-buffer-handle:write-json("JsonObject", oJson, yes).

            return oJson.

            finally:
                delete object htbl no-error.
            end finally.
        end method.

	method public void ExportAsProcedure( input pcfile as character ):
		undo, throw new UnsupportedOperationError("Generation of code for " + Context:Name). 
	end method.

	method public void ExportAsProcedure( input pcfile as character, input pcCollectionlist as character ):
		undo, throw new UnsupportedOperationError("Generation of code for " + Context:Name). 
	end method.

	method public void ExportTree( input pcFile as character ):
		this-object:Export(pcFile).
	end method.

	method public void ExportTree( input cFile as character, input pcCollections as character ):
		undo, throw new UnsupportedOperationError("ExportTree " + quoter(pcCollections)).
	end method.

	method public JsonObject GetJSONExport( input tree as IContextTree ):
		return Context:GetJSONExport(tree).
	end method.

	method public void Import( input cFile as character ):
		undo, throw new UnsupportedOperationError("Import of single Cdc.").
	end method.

	method public void ImportTree( input cFile as character ):
		undo, throw new UnsupportedOperationError("ImportTree of single Cdc.").   
	end method.
	
	method protected character extent GetKeyValues():
        define variable cKey as character no-undo.
        define variable hFld as handle no-undo. 
        define variable i as integer no-undo.
        define variable cValues as char extent no-undo.
        
        extent(cValues) = num-entries(Context:KeyFields).
        do i = 1 to num-entries(Context:KeyFields):
           hFld = mBuffer:buffer-field (entry(i,Context:KeyFields)).
           cValues[i] = string(hfld:buffer-value).
        end. 
        return cValues.
        catch e as Progress.Lang.Error :
            undo, throw new IllegalArgumentError("KeyFields does not match buffer" + e:GetMessage(1)).  
        end catch. 
    end method. 
    
    method private character GetName ():
        return GetName(mBuffer). 
    end method.
    
    method private character GetName (phbuffer as handle):
         define variable cName as character no-undo.
         define variable ckey as character no-undo.
         define variable cTenant as character no-undo.
         define variable cGroup as character no-undo.
         ckey = phBuffer::Tablename. 
         cTenant = phbuffer::Tenantname.
         cGroup = phbuffer::TenantGroupName.
         if cTenant = ? or cTenant = "" then
            
         if phbuffer::ObjectType = "field" then
             cKey = cKey + " " + phBuffer::Fieldname.
         else if phbuffer::ObjectType = "index" then
             cKey = cKey + " " + phBuffer::Indexname.  
        
         cName = "Cdc for " + phbuffer::ObjectType + " " + quoter(cKey) 
              + if cTenant > "" then " Tenant " + quoter(cTenant)
                else if cGroup > "" then " Group " + quoter(cGroup)
                else "".
         
         return if cName = ? then "<unknown>" else cName.    
    end method. 
    
    method protected logical SetProperty(pcPropName as char, pcValue as char):
        return context:SetProperty(mBuffer:rowid,pcPropName,pcValue).  
    end method. 

	method public integer Serialize( input phStream as handle ):
		undo, throw new UnsupportedOperationError("Serialize to stream handle for " + this-object:GetClass():TypeName).
	end method.
	
	method public final override char ToString():
        define variable cKeyFields as character no-undo.
        define variable i as integer no-undo.
        define variable hField as handle no-undo.
        define variable cOut as character no-undo.
        cout = super:ToString(). 
        
        if valid-object(Context) then
        do:
            cOut = Contextid.
            cKeyFields = Context:KeyFields.
             
            do i = 1 to num-entries(cKeyFields).
              hfield = mBuffer:buffer-field (entry(i,cKeyfields)).
              if valid-handle(hField) then 
              do:
                  cOut = cOut 
                       + " "  
                       + (if hField:buffer-value <> ? then hField:buffer-value else "?") 
                       .
              end.
              else
                  undo, throw New IllegalArgumentError("KeyFields does not match object.").  
            end.  
        end.
        return cout.
    end method.

	method public void WriteTree( input tree as IContextTree, input pcCollections as character ):
		 undo, throw new UnsupportedOperationError("WriteTree to ContextTree"). 
	end method.

	method public void WriteTree( input tree as IContextTree ):
		undo, throw new UnsupportedOperationError("WriteTree to ContextTree").
	end method.

end class.
