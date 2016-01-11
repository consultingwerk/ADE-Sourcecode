/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
/*------------------------------------------------------------------------
    File        : IUtilityFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Mar 22 2014
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Util.IDataAdminUtility from propath.

interface OpenEdge.DataAdmin.Util.IUtilityFactory:  
     method public IDataAdminUtility GetUtility(pcUtil as char).
end interface.