/*----------------------------------------------------------- 
   Copyright (c) 2013 by Progress Software Corporation        
 *                                                           * 
 * All rights reserved.  No part of this program or document * 
 * may be  reproduced in  any form  or by  any means without * 
 * permission in writing from Progress Software Corporation. * 
 *************************************************************/
/*------------------------------------------------------------------------
    File        : IContextTree:  
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Aug 16 20:18:09 EDT 2010
    Notes       : htbl as table-handle
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath. 
using Progress.Json.ObjectModel.JsonObject from propath. 
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.Binding.IDataTree from propath.

interface OpenEdge.DataAdmin.Binding.IContextTree inherits IDataTree:  
  
    define public property Parse as logical no-undo get. set. 
    define public property Server as logical no-undo get. set. 
   
    method public void SetName(name as char).
    method public void SetList(name as char,cList as char).
    method public void SetJoin(cParent as char,name as char,cFieldPairs as char). 
    method public void SetRepositionJoin(cParent as char,name as char,cFieldPairs as char).    
    method public void SetFilter(name as char,cFilter as char). 
    method public void SetQuery(name as char,h as handle,buffers as char). 
  
    method public void SetHandle(name as char,h as handle).
    method public void SetHandle(name as char, h as handle,filter as char).
    method public void SetHandle(name as char, h as handle, rid as rowid). 
   
    method public handle GetHandle(name as char). 
    method public rowid  GetRowid(name as char). 
    method public char   GetFilter(name as char). 
    method public char   GetParent(name as char). 
    method public char   GetFieldPairs(name as char). 
   
    method public handle GetReadHandle().  
end interface.
