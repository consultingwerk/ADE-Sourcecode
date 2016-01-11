/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : IDataAdminUtility
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Jul 12 17:06:35 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.

interface OpenEdge.DataAdmin.Util.IDataAdminUtility:  
    method public IUtilityRequest GetRequest().
    method public void ImportOptions(pcFile as char). 
end interface.