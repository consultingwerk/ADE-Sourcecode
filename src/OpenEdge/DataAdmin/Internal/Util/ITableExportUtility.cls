/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : ITableExportUtility
    Purpose     : Wrapper for data admin .d export of tenant table data  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Apr 28  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.ITableDataUtility.
using OpenEdge.DataAdmin.Internal.Util.IExportUtility.
interface OpenEdge.DataAdmin.Internal.Util.ITableExportUtility inherits ITableDataUtility,IExportUtility :          
    /* all,multitenant,shared,one or list*/
    define public property TableSelection     as char      no-undo get. set.  
    define public property NoMap              as logical   no-undo get. set.  
    define public property CharacterMap       as char      no-undo get. set.  
end interface.