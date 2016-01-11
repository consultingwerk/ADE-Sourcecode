/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : IDataAdminWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Aug 16 20:18:09 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.* from propath. 
using Progress.Json.ObjectModel.* from propath.
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.Binding.* from propath.
using OpenEdge.DataAdmin.Error.* from propath.
using OpenEdge.DataAdmin.Core.* from propath.

class OpenEdge.DataAdmin.Core.DataAdminWriter abstract implements IDataAdminWriter:  
    define private variable mlog as character no-undo.	
    
   constructor public DataAdminWriter (  ):
		super ().
    end constructor.
   
    method override public character ToString(  ):
        return super:ToString()
                + if mlog > "" then chr(10) + mlog else "".
    end method. 
     
    method private void Parse(serializable as IDataAdminSerializable,tree as IContextTree,pcMode as char):
        define variable cMsg as character no-undo.
        case pcMode: 
            when "All" then
            do:
/*                if NotReadyForContextTree then           */
/*                    serializable:WriteAllTo(this-object).*/
/*                else                                     */
                    serializable:WriteTree(tree).                    
            end.
            when "Object" then
                undo, throw new UnsupportedOperationError("Parse object").   
/*                serializable:WriteObjectTo(this-object).*/
            when "List" then
                undo, throw new UnsupportedOperationError("Parse list").   
/*                serializable:WriteListTo(this-object).*/
            otherwise
            do: 
/*                if NotReadyForContextTree then                 */
/*                do:                                            */
/*                    serializable:WriteTree(this-object,pcMode).*/
/*                end.                                           */
/*                else do:                                       */
                  
                    serializable:WriteTree(tree,pcMode).
/*                end.*/
            end.
        end.
        mlog = tree:ToString().
    end method.
    
    method protected IContextTree CreateContextTree():
        return new ContextTree(). 
    end method.
    
    method protected IContextTree Write(serializable as IDataAdminSerializable,pcMode as char):
        define variable contextTree as IContextTree no-undo.
        ContextTree = CreateContextTree(). 
        ContextTree:Write = true.
        Parse(serializable,contextTree,pcMode).
         
/*        mDS = ContextTree:GetWriteHandle().                                                                                     */
/*                                                                                                                                */
/*        if not valid-handle(mDS) then                                                                                           */
/*            undo, throw new AppError("The write operation cannot complete. No output result returned from the context writer.").*/
/*                                                                                                                                */
        return ContextTree.
    end method.
    
    method protected IContextTree Load(serializable as IDataAdminSerializable,pcMode as char):
        define variable contextTree as IContextTree no-undo.
        contextTree = new ContextTree(). 
        Parse(serializable,contextTree,pcMode).
        return contextTree.
    end method.

	 
    
end class.
