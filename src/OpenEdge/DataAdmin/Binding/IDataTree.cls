/* ***********************************************************/
/* Copyright (c) 2013 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : IDataTree
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Nov 06 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
  
using Progress.Lang.*.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.DataAdmin.Binding.IJsonRowListener.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.

interface OpenEdge.DataAdmin.Binding.IDataTree:  
    define public property Write       as logical no-undo get. set. 
    define public property WriteCode   as logical no-undo get. set. 
    define public property Total       as int64 no-undo get. set. 
    define public property Success     as log no-undo get. set. 
    define public property UseDataset  as logical no-undo get. set.
    define public property IncludeRoot as logical no-undo get. set.
    define public property NoTopArray  as logical no-undo get. set.
    define public property TopTable    as char    no-undo get. set.
   
    method public void AddRowListener(listener as IJsonRowListener):
    method public void SetFieldHandler(pname as char,phandler as Object).
    method public Object GetFieldHandler(pname as char).
 
    method public handle GetWriteHandle().
    method public JsonObject GetJSON().
    method public JsonObject GetJSON(pageReq as IPageRequest).
   
end interface.