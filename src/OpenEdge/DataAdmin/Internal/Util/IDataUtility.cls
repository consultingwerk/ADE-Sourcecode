/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : IDataUtility
    Purpose     : Common wrapper for data admin dump/load of sequences and tables
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Apr 28  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.Message.IUtilityRequest.
using OpenEdge.DataAdmin.Util.IDataAdminUtility.
 
interface OpenEdge.DataAdmin.Internal.Util.IDataUtility inherits IDataAdminUtility:  
    define public property Name        as char   no-undo get. set.
    define public property FileName    as char no-undo get. set.
    define public property Directory   as char no-undo get. set.
    define public property UseDefaultLocation as logical no-undo get. set.
    define public property AllTenants  as logical   no-undo get. set.   
    define public property Tenants     as IDataAdminCollection   no-undo get. set.   
  
    method public void ExportOptions(pcFile as char).  
end interface.