/* ***********************************************************/
/* Copyright (c) 2013 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : IJsonRowListener
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Nov 11 19:26:19 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.

interface OpenEdge.DataAdmin.Binding.IJsonRowListener:  
    method public void AddRowValues(pname as char,pjson as JsonObject,table-handle h):
end interface.