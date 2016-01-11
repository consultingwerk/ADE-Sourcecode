/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
 /*************************************************************/
/** ------------------------------------------------------------------------
    Purpose     : Write IDataAdminSerializable in JSON format 
                  to file, longchar, memptr or stream,  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Aug 16 20:18:09 EDT 2010
    Notes       : This is often used by the various ExportTree and 
                  Export methods of the objects, but not always                  
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using Progress.Lang.* from propath. 
using Progress.Json.ObjectModel.JsonObject  from propath.  
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.Core.DataAdminWriter from propath. 
using OpenEdge.DataAdmin.Core.DataAdminWriter from propath. 
using OpenEdge.DataAdmin.Binding.IContextTree from propath. 

class OpenEdge.DataAdmin.Core.JSONWriter inherits DataAdminWriter implements IDataAdminExporter:  
	 
    define public property Formatted as logical no-undo 
    init true
    get.
    set. 
    
	constructor public JSONWriter (  ):
		super ().
    end constructor.
      
    /** WriteToFile 
        @param Serializable IDataAdminSerializable is implemented by all entities and collections 
        @param FileName  for output (typically .json)
        @param Mode All, Object - Unsupported,  List - Unsupported 
                    collection names */ 
    method public void WriteToFile(serializable as IDataAdminSerializable,pcFile as char,pccollection as char):
        define variable h as handle no-undo.
        define variable json as JsonObject no-undo.
        define variable tree as IContextTree no-undo.
        tree = this-object:Write(serializable,pccollection /*pcMode*/ ).
        if tree:UseDataset then
        do:
            h =  tree:GetWriteHandle().
            /* the json-write parameter is OmitRoot */
            h:write-json ("File",pcFile,Formatted,"UTF-8",no,if tree:IncludeRoot = yes then no else yes). 
            delete object h no-error.
        end.
        else do:
            json = tree:GetJSON().
            json:WriteFile(pcFile,yes).
        end.
        catch e as Progress.Lang.Error :
            handleError(e). 
        end catch.        
    end method.
    
    /** WriteToLongchar 
        @returns longchar with exported data  
        @param Serializable IDataAdminSerializable is implemented by all entities and collections 
        @param Mode All, Object - Unsupported,  List - Unsupported 
                    collection names */   
    method public longchar WriteToLongchar(serializable as IDataAdminSerializable,pccollection as char):
        define variable h as handle no-undo.
        define variable cl as longchar no-undo.
        define variable json as JsonObject no-undo.
        define variable tree as IContextTree no-undo.
        tree = this-object:Write(serializable,pccollection /*pcMode*/ ).
        if tree:UseDataset then
        do:
            h =  tree:GetWriteHandle().
            h:write-json ("Longchar",cl,Formatted,"UTF-8",no,if tree:IncludeRoot = yes then no else yes). 
            delete object h no-error.
        end.
        else do:
            json = tree:GetJSON().
            json:Write(input-output cl,Formatted).
        end.
        catch e as Progress.Lang.Error :
            handleError(e). 
        end catch.
    end method.
    
    /** WriteToMemptr 
        @param Serializable IDataAdminSerializable is implemented by all entities and collections 
        @param Memptr for output 
        @param Mode All, Object - Unsupported,  List - Unsupported 
                    collection names */ 
    method public void WriteToMemptr(serializable as IDataAdminSerializable,m as memptr,pccollection as char):
        define variable h as handle no-undo.
        define variable json as JsonObject no-undo.
        define variable tree as IContextTree no-undo.
        tree = this-object:Write(serializable,pccollection   ).
        if tree:UseDataset then
        do:
            h =  tree:GetWriteHandle().
            h:write-json ("memptr",m,Formatted,"UTF-8",no,if tree:IncludeRoot = yes then no else yes). 
            delete object h no-error.
        end.
        else do:
            json = tree:GetJSON().
            json:Write(m,Formatted).
        end.
        catch e as Progress.Lang.Error :
            handleError(e). 
        end catch.
    end method.
    
    /** WriteToStream 
        @param Serializable IDataAdminSerializable is implemented by all entities and collections 
        @param Stream-handle for output 
        @param Mode All, Object - Unsupported,  List - Unsupported 
                    collection names */ 
    method public void WriteToStream(serializable as IDataAdminSerializable,phStream as handle,pccollection as char):
        define variable h as handle no-undo.
        define variable json as JsonObject no-undo.
        define variable tree as IContextTree no-undo.
        tree = this-object:Write(serializable,pccollection   ).
        if tree:UseDataset then
        do:
            h =  tree:GetWriteHandle().
            h:write-json ("STREAM-HANDLE",phStream,Formatted,"UTF-8",no,if tree:IncludeRoot = yes then no else yes). 
            delete object h no-error.
        end. 
        else do:
            json = tree:GetJSON().
            json:Write(phStream,Formatted).
        end.   
        catch e as Progress.Lang.Error :
        	handleError(e).	
        end catch.
    end method.
    
    method protected void handleError(e as Error):
        if e:GetMessageNum(2) = 3140 or e:GetMessageNum(1) = 3135 then
            undo, throw new AppError("The write operation cannot complete. No data output returned from the context writer.").
        else do:
            undo, throw e. 
        end.    
    end method.
    
end class.
