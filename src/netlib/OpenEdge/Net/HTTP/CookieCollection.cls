/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : CookieCollection
    Purpose     : A specialised collection containing Cookie objects  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 22 13:35:38 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.CookieCollection.

{OpenEdge/Core/Collections/typedcollectionclass.i
    &CollectionType = CookieCollection
    &ValueType      = Cookie
    &Package        = OpenEdge.Net.HTTP
}
